// Staff account management that needs the Auth admin API. Admin-only.
//
// POST { action: 'create', email, password, full_name, phone?, position, permissions[] }
//   -> { status: 'success', user_id } | { status: 'error', error }
// POST { action: 'set_password', user_id, password }
//   -> { status: 'success' } | { status: 'error', error }
//
// Everything else (edit, activate/deactivate, delete) uses admin-only RPCs.
// The caller must send their own session JWT (supabase.functions.invoke does).

import { createClient, SupabaseClient } from 'https://esm.sh/@supabase/supabase-js@2.49.1'

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!

const PERMISSIONS = ['bookings', 'queue', 'patients', 'announcements', 'statistics', 'settings']
const POSITIONS = ['nurse', 'receptionist', 'assistant', 'technician', 'cleaner', 'manager']
const MIN_PASSWORD_LENGTH = 6

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  })
}

function fail(error: string, status = 400) {
  return json({ status: 'error', error }, status)
}

async function requireAdmin(admin: SupabaseClient, req: Request): Promise<string | null> {
  const authHeader = req.headers.get('Authorization') ?? ''
  const token = authHeader.startsWith('Bearer ') ? authHeader.slice(7) : ''
  const { data, error } = await admin.auth.getUser(token)
  if (error || !data?.user) return null

  const { data: profile } = await admin
    .from('profiles')
    .select('role, status')
    .eq('user_id', data.user.id)
    .maybeSingle()
  if (!profile || !['admin', 'doctor'].includes(profile.role) || profile.status !== 'active') {
    return null
  }
  return data.user.id
}

async function findUserIdByEmail(admin: SupabaseClient, email: string): Promise<string | null> {
  for (let page = 1; page <= 20; page++) {
    const { data, error } = await admin.auth.admin.listUsers({ page, perPage: 1000 })
    if (error) throw error
    const match = data.users.find((u) => u.email?.toLowerCase() === email)
    if (match) return match.id
    if (data.users.length < 1000) return null
  }
  return null
}

async function createStaff(admin: SupabaseClient, body: Record<string, unknown>) {
  const email = String(body.email ?? '').trim().toLowerCase()
  const password = String(body.password ?? '')
  const fullName = String(body.full_name ?? '').trim()
  const phone = String(body.phone ?? '').trim() || null
  const position = String(body.position ?? 'receptionist')
  const permissions = Array.isArray(body.permissions)
    ? [...new Set(body.permissions.map(String))].filter((p) => PERMISSIONS.includes(p))
    : []

  if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)) return fail('invalid_email')
  if (password.length < MIN_PASSWORD_LENGTH) return fail('password_too_short')
  if (!fullName) return fail('full_name_required')
  if (!POSITIONS.includes(position)) return fail('invalid_position')

  let userId: string | null = null
  const { data: created, error: createError } = await admin.auth.admin.createUser({
    email,
    password,
    email_confirm: true,
    user_metadata: { name: fullName, full_name: fullName },
  })

  if (created?.user) {
    userId = created.user.id
  } else {
    // Email already registered: only a former staff account (no staff row,
    // role staff) may be reused. Never convert patients or admins silently.
    const existingId = await findUserIdByEmail(admin, email)
    if (!existingId) return fail(createError?.message ?? 'create_failed')

    const { data: profile } = await admin
      .from('profiles')
      .select('role')
      .eq('user_id', existingId)
      .maybeSingle()
    const { data: staffRow } = await admin
      .from('staff')
      .select('id')
      .eq('user_id', existingId)
      .maybeSingle()

    if (staffRow) return fail('already_staff', 409)
    if (profile?.role !== 'staff') return fail('email_in_use', 409)

    const { error: pwError } = await admin.auth.admin.updateUserById(existingId, { password })
    if (pwError) return fail(pwError.message)
    userId = existingId
  }

  // Profile row is created by the auth trigger; make it an active staff account.
  const { data: currentProfile } = await admin
    .from('profiles')
    .select('meta')
    .eq('user_id', userId)
    .maybeSingle()
  const meta = {
    ...(currentProfile?.meta ?? {}),
    name: fullName,
    full_name: fullName,
    email,
    phone,
  }
  const { error: profileError } = await admin
    .from('profiles')
    .update({ role: 'staff', status: 'active', meta, updated_at: new Date().toISOString() })
    .eq('user_id', userId)
  if (profileError) return fail(profileError.message, 500)

  const { error: staffError } = await admin.from('staff').insert({
    user_id: userId,
    full_name: fullName,
    email,
    phone,
    position,
    status: 'active',
    permissions,
  })
  if (staffError) return fail(staffError.message, 500)

  return json({ status: 'success', user_id: userId })
}

async function setPassword(admin: SupabaseClient, body: Record<string, unknown>) {
  const userId = String(body.user_id ?? '')
  const password = String(body.password ?? '')
  if (!userId) return fail('invalid_request')
  if (password.length < MIN_PASSWORD_LENGTH) return fail('password_too_short')

  const { data: staffRow } = await admin
    .from('staff')
    .select('id')
    .eq('user_id', userId)
    .maybeSingle()
  if (!staffRow) return fail('target_not_staff', 403)

  const { error } = await admin.auth.admin.updateUserById(userId, { password })
  if (error) return fail(error.message)
  return json({ status: 'success' })
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, {
      auth: { persistSession: false },
    })

    const callerId = await requireAdmin(admin, req)
    if (!callerId) return fail('forbidden', 403)

    const body = (await req.json().catch(() => ({}))) as Record<string, unknown>
    switch (body.action) {
      case 'create':
        return await createStaff(admin, body)
      case 'set_password':
        return await setPassword(admin, body)
      default:
        return fail('unknown_action')
    }
  } catch (e) {
    const message = e instanceof Error ? e.message : String(e)
    console.error('manage-staff error:', message)
    return fail('internal_error', 500)
  }
})
