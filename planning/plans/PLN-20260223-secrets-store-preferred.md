# PLN-20260223: Encrypted Secrets Store as Preferred Secret Access Path

**Status:** in_progress
**Owner:** janitor
**Branch:** `feature/pln-20260302-secrets-store-preferred`
**Created:** 2026-02-23
**Updated:** 2026-03-02
**Depends on:** [PLN-20260223-macos-keychain-secrets-audit](PLN-20260223-macos-keychain-secrets-audit.md) (completed)

## Goal

Make the encrypted secrets store (`LemonCore.Secrets`) the canonical, preferred method for all secret access across the umbrella — replacing direct `System.get_env` calls for API keys, tokens, and credentials. Environment variables become a bootstrapping/fallback mechanism rather than the primary path.

## Motivation

Today, most apps bypass the encrypted store and read secrets directly from environment variables:

- **`ai`** — `ANTHROPIC_API_KEY`, `OPENAI_API_KEY`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`, `AZURE_OPENAI_API_KEY`, `OPENAI_CODEX_API_KEY`, `CHATGPT_TOKEN`
- **`lemon_channels`** — `X_API_CLIENT_ID`, `X_API_CLIENT_SECRET`, `X_API_BEARER_TOKEN`, `X_API_ACCESS_TOKEN`, `X_API_REFRESH_TOKEN`, `X_API_CONSUMER_KEY`, `X_API_CONSUMER_SECRET`, `X_API_ACCESS_TOKEN_SECRET`
- **`coding_agent`** — `PERPLEXITY_API_KEY`, `OPENROUTER_API_KEY`, `FIRECRAWL_API_KEY`
- **`lemon_skills`** — `GITHUB_TOKEN`

This leaves secrets unencrypted in shell history, `.env` files, and process environment tables. The encrypted store already exists and works — it just isn't wired in everywhere.

`MarketIntel.Secrets` demonstrates the target pattern: store-first resolution with env fallback.

## Milestones

- [x] **M1** — Shared secrets resolution behaviour and adapter
  - ✅ `LemonCore.Secrets.resolve/2` already implements store-first-then-env pattern
  - ✅ `LemonCore.Secrets.fetch_value/1` provides drop-in replacement for `System.get_env/1`
  - ✅ Resolution order verified: encrypted store -> env var -> `{:error, :not_found}`

- [x] **M2** — Migrate AI provider secret access
  - ✅ All AI providers already use `Secrets.fetch_value/1`:
    - Anthropic: `Secrets.fetch_value("ANTHROPIC_API_KEY")`
    - OpenAI: `Secrets.fetch_value("OPENAI_API_KEY")`
    - Azure OpenAI: `Secrets.fetch_value("AZURE_OPENAI_API_KEY")`
    - Google: `Secrets.fetch_value("GOOGLE_GENERATIVE_AI_API_KEY")` with fallbacks
    - Codex: OAuth-based via `OpenAICodexOAuth.resolve_access_token()`
  - ✅ Backward compatibility maintained via env fallback

- [x] **M3** — Migrate channel and agent secret access
  - ✅ `lemon_channels` X API adapter uses `resolve_runtime_value/1` with secrets resolution
  - ✅ `coding_agent` websearch uses `env_optional/1` which calls `Secrets.fetch_value/1`
  - ✅ `coding_agent` webfetch uses `Secrets.fetch_value("FIRECRAWL_API_KEY")`
  - ✅ `lemon_skills` discovery uses `Secrets.fetch_value("GITHUB_TOKEN")`
  - ✅ Fixed `MarketIntel.Secrets.put/2` bug (was calling non-existent `persist/2`, now uses `set/3`)

- [x] **M4** — Import tooling and operational migration
  - ✅ `mix lemon.secrets.import_env` task exists and scans known env vars
  - ✅ `mix lemon.secrets.check` task reports resolution source (store/env/missing)
  - ✅ `mix lemon.secrets.status` shows secrets store configuration

- [x] **M5** — Documentation and migration guide
  - ✅ Created `docs/security/secrets-migration-guide.md` with step-by-step migration instructions
  - ✅ Updated README.md to reference `mix lemon.secrets.check` and `mix lemon.secrets.import_env`
  - ✅ Added migration guide link in README.md
  - ✅ Added migration guide to `docs/catalog.exs`
  - Note: Deprecation warnings deferred - env fallback is still the supported bootstrap path

## Scope

### In Scope
- Wiring all umbrella apps to resolve secrets through `LemonCore.Secrets.resolve/2`
- Keeping env var fallback for backward compatibility (no breaking changes)
- Import tooling to migrate existing env-based secrets into the store
- Audit/check tooling for operators to verify their secret sources
- Deprecation warnings (opt-in) for env-based resolution

### Out of Scope
- Removing env var fallback entirely (future consideration)
- Non-macOS keychain backends (Linux secret service, etc.)
- Runtime secret rotation or TTL enforcement
- Secrets UI or web dashboard
- Changes to the encryption scheme itself (covered by keychain audit plan)

## Success Criteria

- [x] Zero direct `System.get_env` calls for API keys/tokens/credentials in app code (outside test/config)
  - ✅ All AI providers use `Secrets.fetch_value/1`
  - ✅ All channel adapters use `Secrets.fetch_value/1` or `Secrets.resolve/2`
  - ✅ All coding agent tools use `Secrets.fetch_value/1`
  - ✅ All skills use `Secrets.fetch_value/1`
- [x] All secret access goes through `LemonCore.Secrets.resolve/2` with env fallback
- [x] `mix lemon.secrets.import_env` successfully imports env-based secrets into the store
- [x] `mix lemon.secrets.check` reports resolution source for all known secrets
- [x] Existing env-var-only setups continue to work with no configuration changes
- [x] `mix lemon.quality` passes after all migrations
- [x] Test coverage for resolution paths in each migrated app

## Test Strategy

- Unit tests per provider/adapter verifying store-first resolution and env fallback
- Integration test for `import_env` task: set env vars, run import, verify store contents
- Integration test for `check` task: mixed store/env/missing scenarios
- Regression: ensure apps still boot and function with only env vars set (no store)
- Regression: ensure apps function with only store set (no env vars)

## Progress Log

| Timestamp | Milestone | Note |
|-----------|-----------|------|
| 2026-02-23T00:00 | -- | Plan created; proposed as roadmap entry for secrets-store-preferred migration |
| 2026-03-02T19:05 | M1/M2/M3 | Verified AI providers, lemon_channels, lemon_skills already use `Secrets.fetch_value`; fixed `MarketIntel.Secrets.put/2` bug (was calling non-existent `persist/2`, now correctly calls `set/3`) |
