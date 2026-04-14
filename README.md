# Discord Webhook

Two Xano functions that post to a Discord channel via an incoming webhook. Good for deploy notifications, signup alerts, moderation pings, scheduled digests — anywhere you'd otherwise reach for a full Discord bot.

| Function | What it does |
| -------- | ------------ |
| `discord/post_message` | Plain-text message with optional `username` / `avatar_url` override |
| `discord/post_embed` | Rich embed with title, description, clickable URL, and accent color |

## How Discord webhooks work

1. In Discord: open the target channel → **Edit Channel** → **Integrations** → **Webhooks** → **New Webhook**. Copy the URL.
2. Treat that URL like a secret — anyone who has it can post to that channel.
3. You `POST` JSON to the URL; Discord responds `204 No Content` on success.

No bot account, no OAuth, no scope approvals. One URL per channel.

## Install

1. Copy `functions/discord/*.xs` into your workspace's `functions/discord/` folder.
2. Push with the [Xano CLI](https://docs.xano.com/cli), or paste the content into the dashboard as new functions.
3. Store the webhook URL as an env var (see below).
4. Call from any stack:

   ```xs
   function.run "discord/post_message" {
     input = {
       webhook_url: $env.DISCORD_WEBHOOK_URL,
       content: "New signup: " ~ $user.email
     }
   } as $result
   ```

## Storing the webhook URL

Put the URL in the workspace env var store, not in user-facing request inputs:

1. Xano dashboard → **Settings** → **Environment Variables**.
2. Add `DISCORD_WEBHOOK_URL` with your webhook URL.
3. Reference it as `$env.DISCORD_WEBHOOK_URL` when calling the functions.

Both functions also accept `webhook_url` as a direct input — use that only if you legitimately need to route to different channels at runtime (e.g. per-tenant notifications).

## Reference

### `discord/post_message`

| Input | Type | Default | Notes |
| ----- | ---- | ------- | ----- |
| `webhook_url` | `text` | — | Required. Channel webhook URL. |
| `content` | `text` | — | Required. Plain-text body, up to 2000 chars. |
| `username` | `text` | `null` | Override the webhook's default display name. |
| `avatar_url` | `text` | `null` | Override the webhook's default avatar. |

Returns `{ success: true, status: <http_status> }`. Throws a `standard` error on non-2xx.

### `discord/post_embed`

| Input | Type | Default | Notes |
| ----- | ---- | ------- | ----- |
| `webhook_url` | `text` | — | Required. |
| `title` | `text` | — | Required. |
| `description` | `text` | — | Required. Discord Markdown is supported. |
| `url` | `text` | `null` | Makes the title clickable. |
| `color` | `int` | `3447003` (Discord blurple) | Decimal RGB, `0`–`16777215`. |

Returns `{ success: true, status: <http_status> }`. Throws a `standard` error on non-2xx.

## Common pairings

- **After a signup.** Call `post_message` at the end of your signup flow so your team sees new users in real time.
- **On a scheduled task.** Trigger `post_embed` from a daily Xano task to post a metrics summary.
- **On a webhook from another service.** Relay payloads from Stripe / GitHub / etc. into Discord without a separate worker.

## Troubleshooting

- **`404 Unknown Webhook`** — the webhook URL is wrong or the webhook was deleted. Regenerate it in Discord's channel settings.
- **`401 Unauthorized`** — the URL is incomplete. Webhook URLs have a long token segment after the numeric ID; make sure you pasted the whole thing.
- **Silent success but nothing in Discord** — you're probably posting to a different channel than you think. Webhook URLs embed the channel ID right in them; double-check against the target channel.

## License

MIT — see `LICENSE`.

---

**Building your own integration?** → [`template-starter-integration`](https://github.com/xano-community/template-starter-integration) is the scaffold.
