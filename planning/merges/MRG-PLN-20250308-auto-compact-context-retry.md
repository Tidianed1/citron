---
id: MRG-PLN-20250308-auto-compact-context-retry
plan: PLN-20250308-auto-compact-context-retry
landed_revision: 84741ff3
merged_by: janitor
merged_at: 2026-03-08
---

# Merge: Auto-Compact and Retry on ContextLengthExceeded

## Summary

Successfully landed the automatic context compaction and retry feature for AI provider calls.

## Changes Integrated

### New Modules

1. **apps/ai/lib/ai/error.ex** - Enhanced with `context_length_error?/1` function
   - Detects context limit errors from all major providers (Anthropic, OpenAI, Google, Bedrock)
   - Pattern matching for provider-specific error formats

2. **apps/ai/lib/ai/context_compactor.ex** - Context compaction strategies
   - `TruncationStrategy` - removes oldest messages while preserving critical context
   - `HybridStrategy` - combines truncation with different preservation thresholds
   - Configurable via application environment
   - Full telemetry support

3. **apps/ai/lib/ai/compacting_client.ex** - Automatic retry client
   - Drop-in replacement for direct provider calls
   - Automatic retry with compacted context on ContextLengthExceeded
   - Configurable max attempts and strategy selection

### Tests

- **apps/ai/test/ai/context_compactor_test.exs** - 18 new tests
  - Error detection tests for all provider formats
  - Compaction strategy tests
  - Telemetry event tests
  - All tests passing

## Merge Commit

```
84741ff3 feat(ai): merge auto-compact context retry feature
```

## Post-Merge Verification

- [x] All tests pass (`mix test apps/ai`)
- [x] No regressions in existing context handling
- [x] Documentation updated (JANITOR.md, plan progress log)

## Related

- Source: IronClaw v0.13.0 (commit 6f21cfa)
- Idea: IDEA-20260306-ironclaw-auto-compact-context-retry
