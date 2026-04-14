# Contributing

Integration templates wrap a third-party API. The goal is a thin, predictable layer — not a full SDK. Keep surface area small.

## Ground rules

- **Validate XanoScript before committing.** Use the Xano MCP `validate_xanoscript` tool or `xano-cli xs validate`.
- **One definition per `.xs` file.** Non-negotiable in XanoScript.
- **Fail loudly on non-2xx.** Every `api.request` should be followed by a `precondition` on the response status. Silent third-party failures are the #1 bug in integrations like this.
- **Document env vars in `.env.example`.** Even if empty, keep the file — it signals to the reader that env var usage was considered.
- **Don't ship webhook URLs or API keys in committed code.** Treat the `.env.example` as documentation only; real values belong in the Xano dashboard env var store.
- **Update `xano-template.json`** when adding or removing a function.

## Testing your change

1. Create a throwaway Discord server → channel → webhook.
2. Push the updated function to a scratch Xano workspace.
3. Call it from a debug endpoint and confirm the message appears in Discord.
4. Deliberately hand it a bad webhook URL and confirm the `precondition` fires.

## Pull requests

- Call out any change to function names, paths, or inputs — those are breaking for anyone already using the integration.
