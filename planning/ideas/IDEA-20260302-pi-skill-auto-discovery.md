---
id: IDEA-20260302-pi-skill-auto-discovery
title: [Pi] Auto-Discover Skills in .agents Paths by Default
source: pi
source_commit: 39cbf47e
discovered: 2026-03-02
status: proposed
---

# Description
Pi (coding-agent) now auto-discovers skills in `.agents` paths by default (commit 39cbf47e). This eliminates manual skill registration and makes skills "just work" when placed in the standard `.agents` directory.

Key behaviors:
- Skills in `.agents/` subdirectories are automatically discovered at startup
- No explicit skill registration required
- Follows SKILL.md convention for skill metadata

# Evidence
- Pi v0.54.0 release notes: "feat(coding-agent): discover skills in .agents paths by default"
- Commit 39cbf47e implements auto-discovery
- Related: Pi v0.19.0 added skills system with Claude Code compatibility

# Lemon Status
- Current state: **has** - Lemon already has skill auto-discovery
- Gap analysis:
  - Lemon's skill discovery works via `apps/lemon_skills`
  - Skills in `~/.agents/skills/` are auto-discovered
  - SKILL.md convention is already supported
  - **Lemon already has parity with this feature**

# Value Assessment
- Community demand: **H** - Skill ecosystem growth depends on easy discovery
- Strategic fit: **H** - Core platform capability
- Implementation complexity: **S** - Already implemented

# Recommendation
**completed** - Lemon already implements skill auto-discovery in `.agents` paths. No action needed - this confirms Lemon's approach aligns with industry best practices.

# Verification
```bash
# Lemon skill discovery is implemented in:
grep -r "skill.*discover\|discover.*skill" apps/lemon_skills --include="*.ex" | head -10
```

Lemon's skill system:
- Scans `~/.agents/skills/` on startup
- Reads SKILL.md for metadata
- Auto-registers discovered skills
- Supports skill installation/updates via control plane
