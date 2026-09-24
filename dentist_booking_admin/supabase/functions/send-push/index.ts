// Sends queue push notifications via FCM HTTP v1.
// Triggered by Database Webhook (or pg_net) on notification_jobs INSERT.
// Secrets: FIREBASE_SERVICE_ACCOUNT (full service-account JSON string)

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.49.1'
import { JWT } from 'npm:google-auth-library@9'

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!

type NotificationJob = {
  id: string
  user_id: string
  booking_id: string | null
  kind: 'booking_confirmed' | 'position_update' | 'your_turn'
  people_before: number
  payload: {
    title?: string
    body?: string
    ticket_code?: string
    booking_id?: string
    queue_number?: number
    people_before?: number
    kind?: string
    collapse_key?: string
  }
  status: string
}

type WebhookPayload = {
  type?: string
  table?: string
  record?: NotificationJob
  process_pending?: boolean
  job_id?: string
}

type ServiceAccount = {
  project_id: string
  client_email: string
  private_key: string
}

function getServiceAccount(): ServiceAccount {
  const raw = Deno.env.get('FIREBASE_SERVICE_ACCOUNT')
  if (!raw) {
    throw new Error('FIREBASE_SERVICE_ACCOUNT secret is not set')
  }
  return JSON.parse(raw) as ServiceAccount
}

async function getFcmAccessToken(sa: ServiceAccount): Promise<string> {
  const client = new JWT({
    email: sa.client_email,
    key: sa.private_key,
    scopes: ['https://www.googleapis.com/auth/firebase.messaging'],
  })
  const tokens = await client.authorize()
  if (!tokens.access_token) {
    throw new Error('Failed to obtain FCM access token')
  }
  return tokens.access_token
}

async function sendFcmMessage(
  accessToken: string,
  projectId: string,
  deviceToken: string,
  job: NotificationJob,
): Promise<{ ok: boolean; status: number; body: unknown; unregistered: boolean }> {
  const payload = job.payload ?? {}
  const title = payload.title ?? 'عيادة الوفاء'
  const body = payload.body ?? ''
  const collapseKey = payload.collapse_key ?? job.booking_id ?? job.id
  const highPriority = job.kind === 'your_turn'

  const message = {
    message: {
      token: deviceToken,
      notification: {
        title,
        body,
      },
      data: {
        kind: job.kind,
        booking_id: String(payload.booking_id ?? job.booking_id ?? ''),
        ticket_code: String(payload.ticket_code ?? ''),
        people_before: String(payload.people_before ?? job.people_before ?? 0),
        queue_number: String(payload.queue_number ?? ''),
        collapse_key: String(collapseKey),
        click_action: 'FLUTTER_NOTIFICATION_CLICK',
      },
      android: {
        collapseKey: String(collapseKey),
        priority: highPriority ? 'high' : 'normal',
        notification: {
          channelId: 'queue_updates',
          tag: String(collapseKey),
          notificationCount: 1,
        },
      },
    },
  }

  const res = await fetch(
    `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
    {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${accessToken}`,
      },
      body: JSON.stringify(message),
    },
  )

  const resBody = await res.json().catch(() => ({}))
  const errorCode = (resBody as { error?: { details?: Array<{ errorCode?: string }> } })
    ?.error?.details?.[0]?.errorCode
  const unregistered =
    res.status === 404 ||
    errorCode === 'UNREGISTERED' ||
    errorCode === 'INVALID_ARGUMENT'

  return {
    ok: res.ok,
    status: res.status,
    body: resBody,
    unregistered,
  }
}

function assertAuthorized(req: Request) {
  const webhookSecret = Deno.env.get('PUSH_WEBHOOK_SECRET')
  if (!webhookSecret) return

  const headerSecret = req.headers.get('x-push-secret')
  const auth = req.headers.get('Authorization') ?? ''
  const bearer = auth.startsWith('Bearer ') ? auth.slice(7) : ''

  if (headerSecret === webhookSecret || bearer === webhookSecret) {
    return
  }

  // Allow Supabase service role (Database Webhook / pg_net)
  if (bearer && bearer === SUPABASE_SERVICE_ROLE_KEY) {
    return
  }

  throw new Error('unauthorized')
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, { status: 204 })
  }

  try {
    assertAuthorized(req)
    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)
    const sa = getServiceAccount()
    const accessToken = await getFcmAccessToken(sa)

    const payload = (await req.json().catch(() => ({}))) as WebhookPayload
    const jobs: NotificationJob[] = []

    if (payload.record?.id) {
      jobs.push(payload.record)
    } else if (payload.job_id) {
      const { data, error } = await supabase
        .from('notification_jobs')
        .select('*')
        .eq('id', payload.job_id)
        .maybeSingle()
      if (error) throw error
      if (data) jobs.push(data as NotificationJob)
    } else if (payload.process_pending) {
      const { data, error } = await supabase
        .from('notification_jobs')
        .select('*')
        .eq('status', 'pending')
        .order('created_at', { ascending: true })
        .limit(50)
      if (error) throw error
      if (data) jobs.push(...(data as NotificationJob[]))
    }

    if (jobs.length === 0) {
      return Response.json({ success: true, processed: 0 })
    }

    let sent = 0
    let failed = 0

    for (const job of jobs) {
      try {
        const { data: tokens, error: tokenError } = await supabase
          .from('device_tokens')
          .select('token')
          .eq('user_id', job.user_id)

        if (tokenError) throw tokenError

        if (!tokens || tokens.length === 0) {
          await supabase
            .from('notification_jobs')
            .update({
              status: 'failed',
              error_message: 'no_device_token',
              sent_at: new Date().toISOString(),
            })
            .eq('id', job.id)
          failed++
          continue
        }

        let anyOk = false
        const errors: string[] = []

        for (const row of tokens) {
          const result = await sendFcmMessage(
            accessToken,
            sa.project_id,
            row.token,
            job,
          )

          if (result.ok) {
            anyOk = true
          } else {
            errors.push(JSON.stringify(result.body))
            if (result.unregistered) {
              await supabase.from('device_tokens').delete().eq('token', row.token)
            }
          }
        }

        if (anyOk) {
          await supabase
            .from('notification_jobs')
            .update({
              status: 'sent',
              error_message: null,
              sent_at: new Date().toISOString(),
            })
            .eq('id', job.id)
          sent++
        } else {
          await supabase
            .from('notification_jobs')
            .update({
              status: 'failed',
              error_message: errors.join('; ').slice(0, 1000),
              sent_at: new Date().toISOString(),
            })
            .eq('id', job.id)
          failed++
        }
      } catch (jobError) {
        const message =
          jobError instanceof Error ? jobError.message : String(jobError)
        await supabase
          .from('notification_jobs')
          .update({
            status: 'failed',
            error_message: message.slice(0, 1000),
            sent_at: new Date().toISOString(),
          })
          .eq('id', job.id)
        failed++
      }
    }

    return Response.json({ success: true, processed: jobs.length, sent, failed })
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error)
    console.error('send-push error:', message)
    return Response.json({ success: false, error: message }, { status: 500 })
  }
})
