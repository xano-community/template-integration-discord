# Discord Webhook — Xano Community Integration

Two reusable Xano functions that post to a Discord channel via an incoming webhook. Useful for deploy notifications, moderation alerts, community pings — anywhere you'd otherwise reach for a bot.

This repo doubles as a **template for future integration templates** in the `xano-community` org — copy its structure when wrapping any third-party HTTP API.

## What's inside

| Path | What it is |
| ---- | ---------- |
| `functions/discord/post_message.xs` | Plain-text message, optional `username` / `avatar_url` override |
| `functions/discord/post_embed.xs` | Rich embed (title + description + link + color) |
| `.env.example` | Declared environment variables (none required — the webhook URL is an input) |
| `xano-template.json` | Machine-readable metadata the org uses to index templates |

## How Discord webhooks work

1. In Discord: open a channel → **Edit Channel** → **Integrations** → **Webhooks** → **New Webhook**. Copy the URL.
2. Treat the URL like a secret. Anyone who has it can post to that channel.
3. `POST` JSON to the URL. Discord responds `204 No Content` on success.

## Install

1. Copy `functions/discord/*.xs` into your workspace's `functions/discord/` folder.
2. Push with the Xano CLI, or paste into the Xano dashboard as new functions.
3. Call from any stack:

   ```xs
   function.run "discord/post_message" {
     input = {
       webhook_url: $env.DISCORD_WEBHOOK_URL,
       content: "New signup: " ~ $user.email
     }
   } as $result
   ```

## Storing the webhook URL

We recommend setting a workspace env var rather than passing the URL in user-facing inputs:

1. Xano dashboard → **Settings** → **Environment Variables**.
2. Add `DISCORD_WEBHOOK_URL` with your webhook URL.
3. Reference it as `$env.DISCORD_WEBHOOK_URL` in your calls.

## Inputs

### `discord/post_message`

| Name | Type | Default | Notes |
| ---- | ---- | ------- | ----- |
| `webhook_url` | `text` | — | Required. Channel webhook URL. |
| `content` | `text` | — | Required. Plain-text body, up to 2000 chars. |
| `username` | `text` | `null` | Override the webhook's default display name. |
| `avatar_url` | `text` | `null` | Override the webhook's default avatar. |

### `discord/post_embed`

| Name | Type | Default | Notes |
| ---- | ---- | ------- | ----- |
| `webhook_url` | `text` | — | Required. |
| `title` | `text` | — | Required. |
| `description` | `text` | — | Required. Markdown supported. |
| `url` | `text` | `null` | Makes the title clickable. |
| `color` | `int` | `3447003` (Discord blurple) | Decimal RGB, `0`–`16777215`. |

## Conventions this template demonstrates

- **One XanoScript definition per file** under a service-named subfolder (`functions/discord/`).
- **`api.request` for arbitrary third-party HTTP APIs** — the pattern to use whenever Xano doesn't ship a native integration for a service.
- **Status-code preconditions.** Every external call should fail loudly when the remote side returns non-2xx. See the `precondition` block in each function.
- **`.env.example`** documents env vars the integration expects. For this template it's empty because the webhook URL is passed as an input — add entries here when your integration requires API keys.

## License

MIT — see `LICENSE`.
