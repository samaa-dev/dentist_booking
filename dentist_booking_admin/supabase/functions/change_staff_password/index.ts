// Changes a staff member's password. Admin-only.
// Request (unchanged for existing admin apps): { user_id, new_password }
// Response: { status: 'success' } | { status: 'error', error }
// The caller must send their own session JWT (supabase.functions.invoke does).

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.49.1'

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!

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

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, {
      auth: { persistSession: false },
    })

    // 1) Identify the caller from their session token (not the anon key).
    const authHeader = req.headers.get('Authorization') ?? ''
    const token = authHeader.startsWith('Bearer ') ? authHeader.slice(7) : ''
    const { data: caller, error: callerError } = await admin.auth.getUser(token)
    if (callerError || !caller?.user) {
      return json({ status: 'error', error: 'unauthorized' }, 401)
    }

    // 2) Caller must be an active admin/doctor.
    const { data: callerProfile } = await admin
      .from('profiles')
      .select('role, status')
      .eq('user_id', caller.user.id)
      .maybeSingle()
    if (
      !callerProfile ||
      !['admin', 'doctor'].includes(callerProfile.role) ||
      callerProfile.status !== 'active'
    ) {
      return json({ status: 'error', error: 'forbidden' }, 403)
    }

    // 3) Validate input.
    const { user_id, new_password } = await req.json().catch(() => ({}))
    if (typeof user_id !== 'string' || typeof new_password !== 'string') {
      return json({ status: 'error', error: 'invalid_request' }, 400)
    }
    if (new_password.length < 6) {
      return json({ status: 'error', error: 'password_too_short' }, 400)
    }

    // 4) Only staff accounts can be changed here (never patients or other admins).
    const { data: target } = await admin
      .from('profiles')
      .select('role')
      .eq('user_id', user_id)
      .maybeSingle()
    if (!target || target.role !== 'staff') {
      return json({ status: 'error', error: 'target_not_staff' }, 403)
    }

    const { error } = await admin.auth.admin.updateUserById(user_id, {
      password: new_password,
    })
    if (error) {
      return json({ status: 'error', error: error.message }, 400)
    }

    return json({ status: 'success' })
  } catch (e) {
    const message = e instanceof Error ? e.message : String(e)
    console.error('change_staff_password error:', message)
    return json({ status: 'error', error: 'internal_error' }, 500)
  }
})
