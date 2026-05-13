"""
memory_server.py — MCP server for THYROX semantic memory.

Transport: stdio (Claude Code MCP protocol)
Tools exposed:
  - store(content, metadata?) -> {"status": "ok", "id": "<uuid>"}
  - retrieve(query, top_k?) -> [{"content": ..., "metadata": ..., "score": ...}]

Usage:
  python registry/mcp/memory_server.py

Configured in .claude/settings.json under mcpServers:
  "thyrox-memory": {
    "command": "python",
    "args": ["registry/mcp/memory_server.py"],
    "env": { "MEMORY_INDEX_PATH": ".claude/memory/thyrox.faiss" }
  }
"""

from __future__ import annotations

import os
import sys
from pathlib import Path
from typing import Optional

# Allow running from project root: python registry/mcp/memory_server.py
sys.path.insert(0, str(Path(__file__).parent.parent.parent))

from mcp.server import Server  # type: ignore[import]
from mcp.server.stdio import stdio_server  # type: ignore[import]
from mcp.types import TextContent, Tool  # type: ignore[import]
from pydantic import BaseModel

import registry.mcp.thyrox_core as core

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

DEFAULT_INDEX_PATH = ".claude/memory/thyrox.faiss"
INDEX_PATH = os.environ.get("MEMORY_INDEX_PATH", DEFAULT_INDEX_PATH)

# ---------------------------------------------------------------------------
# Tool input schemas
# ---------------------------------------------------------------------------


class StoreInput(BaseModel):
    content: str
    metadata: Optional[dict] = None


class RetrieveInput(BaseModel):
    query: str
    top_k: int = 5


# ---------------------------------------------------------------------------
# MCP Server
# ---------------------------------------------------------------------------

server = Server("thyrox-memory")


@server.list_tools()
async def list_tools() -> list[Tool]:
    return [
        Tool(
            name="store",
            description=(
                "Store text content with optional metadata in the THYROX semantic memory. "
                "Content is vectorized with sentence-transformers and persisted in a FAISS index."
            ),
            inputSchema=StoreInput.model_json_schema(),
        ),
        Tool(
            name="retrieve",
            description=(
                "Retrieve the most semantically similar memories to a query. "
                "Returns up to top_k results sorted by similarity score descending."
            ),
            inputSchema=RetrieveInput.model_json_schema(),
        ),
    ]


@server.call_tool()
async def call_tool(name: str, arguments: dict) -> list[TextContent]:
    if name == "store":
        params = StoreInput(**arguments)
        try:
            entry_id = core.store_memory(
                content=params.content,
                metadata=params.metadata,
            )
            return [TextContent(type="text", text=f'{{"status": "ok", "id": "{entry_id}"}}')]
        except RuntimeError as e:
            return [TextContent(type="text", text=f'{{"status": "error", "message": "{e}"}}')]

    elif name == "retrieve":
        params = RetrieveInput(**arguments)
        try:
            results = core.retrieve_memory(
                query=params.query,
                top_k=params.top_k,
            )
            import json
            payload = [
                {"content": r.content, "metadata": r.metadata, "score": round(r.score, 4)}
                for r in results
            ]
            return [TextContent(type="text", text=json.dumps(payload, ensure_ascii=False))]
        except RuntimeError as e:
            return [TextContent(type="text", text=f'{{"status": "error", "message": "{e}"}}')]

    return [TextContent(type="text", text=f'{{"status": "error", "message": "Unknown tool: {name}"}}')]


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------


async def main() -> None:
    # Initialize memory on startup
    core.init_memory(INDEX_PATH)

    async with stdio_server() as (read_stream, write_stream):
        await server.run(
            read_stream,
            write_stream,
            server.create_initialization_options(),
        )


if __name__ == "__main__":
    import asyncio
    asyncio.run(main())
