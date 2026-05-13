"""
executor_server.py — MCP server for THYROX code execution.

Transport: stdio (Claude Code MCP protocol)
Tools exposed:
  - exec_cmd(cmd, cwd?, timeout?) -> {"stdout": ..., "stderr": ..., "returncode": ...}
  - exec_python(code, timeout?)   -> {"stdout": ..., "stderr": ..., "returncode": ...}

Scope: subprocess execution only. File operations use Claude Code native tools (Read/Write/Edit).

Usage:
  python registry/mcp/executor_server.py

Configured in .claude/settings.json under mcpServers:
  "thyrox-executor": {
    "command": "python",
    "args": ["registry/mcp/executor_server.py"]
  }
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

# Allow running from project root: python registry/mcp/executor_server.py
sys.path.insert(0, str(Path(__file__).parent.parent.parent))

from mcp.server import Server  # type: ignore[import]
from mcp.server.stdio import stdio_server  # type: ignore[import]
from mcp.types import TextContent, Tool  # type: ignore[import]
from pydantic import BaseModel

import registry.mcp.thyrox_core as core

# ---------------------------------------------------------------------------
# Tool input schemas
# ---------------------------------------------------------------------------


class ExecCmdInput(BaseModel):
    cmd: str
    cwd: str = "."
    timeout: int = 60


class ExecPythonInput(BaseModel):
    code: str
    timeout: int = 30


# ---------------------------------------------------------------------------
# MCP Server
# ---------------------------------------------------------------------------

server = Server("thyrox-executor")


@server.list_tools()
async def list_tools() -> list[Tool]:
    return [
        Tool(
            name="exec_cmd",
            description=(
                "Execute a shell command in a subprocess. "
                "Destructive commands (rm -rf /, mkfs, fork bombs, etc.) are blocked. "
                "Use for: yarn test, git status, pytest, npm run build, etc. "
                "Do NOT use for file operations — use Read/Write/Edit native tools instead."
            ),
            inputSchema=ExecCmdInput.model_json_schema(),
        ),
        Tool(
            name="exec_python",
            description=(
                "Execute Python code in an isolated subprocess via a temporary file. "
                "Use for running Python scripts, data transformations, or validation logic."
            ),
            inputSchema=ExecPythonInput.model_json_schema(),
        ),
    ]


@server.call_tool()
async def call_tool(name: str, arguments: dict) -> list[TextContent]:
    if name == "exec_cmd":
        params = ExecCmdInput(**arguments)
        result = core.exec_cmd(
            cmd=params.cmd,
            cwd=params.cwd,
            timeout=params.timeout,
        )
        payload = {
            "stdout": result.stdout,
            "stderr": result.stderr,
            "returncode": result.returncode,
        }
        return [TextContent(type="text", text=json.dumps(payload, ensure_ascii=False))]

    elif name == "exec_python":
        params = ExecPythonInput(**arguments)
        result = core.exec_python(
            code=params.code,
            timeout=params.timeout,
        )
        payload = {
            "stdout": result.stdout,
            "stderr": result.stderr,
            "returncode": result.returncode,
        }
        return [TextContent(type="text", text=json.dumps(payload, ensure_ascii=False))]

    return [TextContent(type="text", text=json.dumps({
        "status": "error",
        "message": f"Unknown tool: {name}",
    }))]


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------


async def main() -> None:
    async with stdio_server() as (read_stream, write_stream):
        await server.run(
            read_stream,
            write_stream,
            server.create_initialization_options(),
        )


if __name__ == "__main__":
    import asyncio
    asyncio.run(main())
