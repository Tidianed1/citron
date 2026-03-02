---
id: IDEA-20260302-ironclaw-fulljob-routine-mode
title: [IronClaw] FullJob Routine Mode with Scheduler Dispatch
source: ironclaw
source_commit: 04d3b00
source_commit_2: ea57447
discovered: 2026-03-02
status: proposed
---

# Description
IronClaw implemented a "FullJob" routine mode with scheduler dispatch (commit 04d3b00) and hot-activation of WASM channels with channel-first prompts (commit ea57447). This enables:
- Scheduled job execution with proper dispatch mechanism
- WASM channel hot-activation without restart
- Channel-first prompt routing for better context handling
- Unified artifact resolution across channels

# Evidence
- IronClaw v0.11.0 release notes mention "FullJob routine mode"
- Commit 04d3b00: "feat: implement FullJob routine mode with scheduler dispatch"
- Commit ea57447: "feat: hot-activate WASM channels, channel-first prompts, unified artifact resolution"

# Lemon Status
- Current state: **partial**
- Gap analysis:
  - Lemon has cron jobs via `lemon_automation` but lacks sophisticated routine/job scheduling
  - Lemon has WASM channel support but requires explicit activation
  - No "channel-first" prompt routing concept - prompts go through gateway then router
  - Artifact resolution is per-session, not unified across channels

# Value Assessment
- Community demand: **M** - Job scheduling is useful for automation
- Strategic fit: **H** - Aligns with Lemon's automation and channel goals
- Implementation complexity: **M** - Requires scheduler enhancements and channel routing changes

# Recommendation
**investigate** - The FullJob routine mode and channel-first prompts could enhance Lemon's automation capabilities. The WASM hot-activation pattern is worth studying for faster channel onboarding.

# Related Ideas
- IDEA-20260224-community-long-running-agent-harnesses (task management)
- IDEA-20260224-community-wasm-sandbox-tools (WASM tooling)
