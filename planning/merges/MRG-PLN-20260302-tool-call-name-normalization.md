---
plan_id: PLN-20260302-tool-call-name-normalization
merged_at: 2026-03-02
merged_by: janitor
branch: feature/pln-20260302-tool-call-normalization
commit: 6f3d3ace
---

# Merge Summary

## Changes
- Modified `apps/agent_core/lib/agent_core/loop/tool_calls.ex` - Added name normalization in `find_tool/2`
- Modified `apps/coding_agent/lib/coding_agent/tool_registry.ex` - Added name normalization in `get_tool/3`
- Modified `apps/coding_agent/test/coding_agent/tool_registry_test.exs` - Added 5 new tests

## Test Results
- 33 ToolRegistry tests pass
- 4 ToolCalls tests pass
- All existing tests continue to pass

## Telemetry Events Added
- `[:agent_core, :tool_call, :name_normalized]` - Emitted when tool name is normalized in agent_core
- `[:coding_agent, :tool_call, :name_normalized]` - Emitted when tool name is normalized in coding_agent

## Implementation Notes
- Uses `String.trim/1` for normalization (handles spaces, tabs, newlines)
- Only emits telemetry when normalization actually changes the name
- No breaking changes - existing behavior preserved for normal names
