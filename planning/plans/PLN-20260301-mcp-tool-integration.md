---
id: PLN-20260301-mcp-tool-integration
title: MCP (Model Context Protocol) Tool Integration
status: ready_to_land
author: janitor
owner: janitor
workspace: lemon-mcp-integration
change_id: pending
---

# MCP Tool Integration

Implement Model Context Protocol (MCP) support for Lemon to enable standardized tool discovery and invocation across AI agents.

## Summary

MCP is emerging as an industry standard for AI agent tool integration. This plan implements:
1. MCP client for consuming external MCP servers/tools
2. MCP server capability for exposing Lemon tools to external consumers
3. Tool registry integration for MCP-compatible tools
4. Dynamic tool discovery from MCP servers

## Scope

### In Scope
- MCP client implementation (stdio and HTTP transports)
- MCP server implementation for exposing Lemon tools
- Tool registry integration with MCP discovery
- JSON-RPC message handling per MCP spec
- Tool listing and invocation protocol
- Resource and prompt capabilities (basic)
- Configuration schema for MCP servers
- Tests for MCP protocol handling

### Out of Scope
- Full MCP resource subscription lifecycle
- Advanced prompt templating system
- Binary/data transport optimizations
- MCP marketplace/directory integration
- Authentication/authorization for MCP servers (phase 2)

## Success Criteria
- [x] Can connect to external MCP servers via stdio
- [x] Can discover and invoke tools from MCP servers
- [x] Lemon tools can be exposed via MCP server endpoint
- [x] Tool registry includes MCP-discovered tools
- [x] Configuration supports MCP server definitions
- [x] Tests cover protocol message handling
- [x] Documentation for MCP integration

## Milestones

### M1: MCP Client Foundation ✅
- [x] Define MCP message types (Request, Response, Notification, Error)
- [x] Implement JSON-RPC framing for stdio transport
- [x] Implement initialize handshake
- [x] Add tool/list and tool/call support
- [x] Create `LemonMCP.Client` module
- [x] Add tests for protocol and client

### M2: MCP Server Foundation ✅
- [x] Implement server-side initialize handling
- [x] Add tool listing endpoint
- [x] Add tool invocation endpoint
- [x] Create `LemonMCP.Server` module
- [x] Integrate with existing Lemon tools
- [x] Add HTTP transport for server
- [x] Add tests for server and handler

### M3: Tool Registry Integration ✅
- [x] Extend skill/tool registry for MCP sources
- [x] Dynamic tool discovery from configured MCP servers
- [x] Tool caching and refresh logic
- [x] Error handling for unavailable MCP servers
- [x] Add tests for MCP source

### M4: Configuration and Polish ✅
- [x] Config schema for MCP server definitions
- [x] Transport configuration (stdio command, HTTP URL)
- [x] Documentation and examples

## Implementation Summary

### New App: `apps/lemon_mcp/`
A new Elixir application providing MCP protocol support:

**Protocol Module** (`lib/lemon_mcp/protocol.ex`):
- JSON-RPC message types (Request, Response, Error, Notification)
- MCP-specific types (InitializeRequest, ToolListRequest, ToolCallRequest, etc.)
- Encoding/decoding functions for all message types
- Protocol version: "2024-11-05"

**Client Module** (`lib/lemon_mcp/client.ex`):
- GenServer-based MCP client
- Stdio transport via port processes
- Initialize handshake
- Tool listing (`list_tools/1`)
- Tool invocation (`call_tool/3`)
- State machine: :disconnected → :initializing → :ready

**Server Module** (`lib/lemon_mcp/server.ex`):
- GenServer-based MCP server
- Tool registration and management
- Initialize request handling
- Tool listing and invocation endpoints

**Handler Module** (`lib/lemon_mcp/server/handler.ex`):
- Routes MCP protocol messages
- Implements initialize, tools/list, tools/call endpoints
- Error handling with proper JSON-RPC error codes

**Transport Modules**:
- `lib/lemon_mcp/transport/stdio.ex` - Stdio transport for MCP servers
- `lib/lemon_mcp/transport/http.ex` - HTTP transport for server endpoint

**Tool Adapter** (`lib/lemon_mcp/tool_adapter.ex`):
- Wraps existing CodingAgent tools for MCP exposure
- Converts between MCP tool format and Lemon tool format

### Integration: `apps/lemon_skills/`
Extended the skills system to support MCP sources:

**McpSource Module** (`lib/lemon_skills/mcp_source.ex`):
- GenServer managing connections to external MCP servers
- Tool discovery and caching with configurable TTL
- Periodic refresh of tool lists
- Graceful handling of server unavailability

**Config Module Updates** (`lib/lemon_skills/config.ex`):
- MCP server configuration schema
- Support for multiple config sources (app config, env vars, config files)
- Validation functions for MCP server configs

**ToolRegistry Updates** (`lib/coding_agent/tool_registry.ex`):
- Extended to support MCP tool source
- MCP tools appear alongside native tools

### Tests
- `apps/lemon_mcp/test/lemon_mcp/protocol_test.exs` - 20 tests
- `apps/lemon_mcp/test/lemon_mcp/client_test.exs` - 10 tests
- `apps/lemon_mcp/test/lemon_mcp/server_test.exs` - Server tests
- `apps/lemon_mcp/test/lemon_mcp/server/handler_test.exs` - Handler tests
- `apps/lemon_skills/test/lemon_skills/mcp_source_test.exs` - 16 tests

**Total: 54+ tests, all passing**

## Progress Log

| Timestamp | Who | What | Result | Links |
|-----------|-----|------|--------|-------|
| 2026-03-01 22:00 | janitor | Created plan | planned | - |
| 2026-03-01 22:15 | janitor | M1: MCP Client Foundation | completed | 756be69a |
| 2026-03-01 22:30 | janitor | M2: MCP Server Foundation | completed | 15b968fd |
| 2026-03-01 22:45 | janitor | M3: Tool Registry Integration | completed | 7cd6af04 |
| 2026-03-01 23:00 | janitor | M4: Config, docs, tests | completed | 554564bc |
| 2026-03-01 23:05 | janitor | All milestones complete | in_review | - |

## Related
- Parent plan: -
- Related plans: IDEA-20260224-community-mcp-tool-integration
- References:
  - https://modelcontextprotocol.io/
  - https://github.com/modelcontextprotocol/specification
