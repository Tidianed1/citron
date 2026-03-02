---
id: IDEA-20260302-openclaw-mistral-provider-support
title: [OpenClaw] Full Mistral AI Provider Support
source: openclaw
source_commit: d92ba4f8a
discovered: 2026-03-02
status: proposed
---

# Description
OpenClaw added full support for Mistral AI as a provider (commit d92ba4f8a), including:
- Complete Mistral API integration
- Media handling for Mistral models
- Onboarding flow for Mistral credentials
- Test coverage for Mistral-specific behaviors

This is part of OpenClaw's strategy to support diverse AI providers beyond the big three (OpenAI, Anthropic, Google).

# Evidence
- OpenClaw release 2026.2.22: "feat: Provider/Mistral full support for Mistral on OpenClaw"
- Commit d92ba4f8a: "feat: Provider/Mistral full support for Mistral on OpenClaw"
- Related commits for media and onboarding coverage (60c494c02)

# Lemon Status
- Current state: **doesn't have**
- Gap analysis:
  - Lemon's AI providers are in `apps/ai/lib/ai/providers/`
  - Current providers: Anthropic, OpenAI, Google, Azure, Bedrock, Gemini CLI
  - No Mistral provider implementation exists
  - Mistral would need: API client, streaming support, tool calling, model catalog

# Value Assessment
- Community demand: **M** - Mistral is popular in EU, offers competitive pricing
- Strategic fit: **M** - More provider options = better user choice
- Implementation complexity: **M** - Follows existing provider patterns

# Recommendation
**investigate** - Mistral support would add provider diversity. Evaluate:
1. Mistral API compatibility with existing tool-calling patterns
2. Model catalog (Mistral Large, Medium, Small, Code models)
3. Cost/performance vs existing providers
4. Regional compliance benefits (EU data residency)

# Implementation Notes
If proceeding, create:
- `apps/ai/lib/ai/providers/mistral.ex`
- Model definitions in `apps/ai/lib/ai/models.ex`
- Tests following `anthropic_test.exs` pattern
- Documentation in `apps/ai/AGENTS.md`

# Related
- Lemon's provider architecture in `apps/ai/`
- Existing provider implementations for reference
