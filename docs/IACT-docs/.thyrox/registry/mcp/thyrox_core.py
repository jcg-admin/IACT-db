"""
thyrox_core.py — Core services layer for THYROX capabilities.

Implementación propia inspirada en patrones de EvoAgentX (LongTermMemory, CMDToolkit).
Sin dependencia de la librería evoagentx.

Expone:
  - exec_cmd(cmd, cwd, timeout) -> ExecResult
  - exec_python(code, timeout) -> ExecResult
  - init_memory(index_path, model_name) -> None
  - store_memory(content, metadata) -> str   # returns uuid
  - retrieve_memory(query, top_k) -> list[MemoryResult]
"""

from __future__ import annotations

import json
import os
import subprocess
import sys
import tempfile
import uuid
from dataclasses import dataclass, field
from pathlib import Path
from typing import Optional

# ---------------------------------------------------------------------------
# Dataclasses
# ---------------------------------------------------------------------------


@dataclass
class ExecResult:
    stdout: str
    stderr: str
    returncode: int


@dataclass
class MemoryResult:
    content: str
    metadata: dict
    score: float


# ---------------------------------------------------------------------------
# Blocklist — comandos destructivos que nunca deben ejecutarse
# ---------------------------------------------------------------------------

_DESTRUCTIVE_PATTERNS = [
    "rm -rf /",
    "rm -rf ~",
    "mkfs",
    ":(){:|:&};:",   # fork bomb
    "dd if=/dev/zero",
    "chmod -R 777 /",
    "chown -R",
    "> /dev/sda",
    "format c:",
]


def _is_safe_command(cmd: str) -> bool:
    """Returns False if the command matches a known destructive pattern."""
    cmd_lower = cmd.lower().strip()
    for pattern in _DESTRUCTIVE_PATTERNS:
        if pattern.lower() in cmd_lower:
            return False
    return True


# ---------------------------------------------------------------------------
# Execution
# ---------------------------------------------------------------------------


def exec_cmd(cmd: str, cwd: str = ".", timeout: int = 60) -> ExecResult:
    """
    Execute a shell command in a subprocess.

    Args:
        cmd: Shell command string to execute.
        cwd: Working directory (default: current directory).
        timeout: Maximum seconds to wait (default: 60).

    Returns:
        ExecResult with stdout, stderr, returncode.
    """
    if not _is_safe_command(cmd):
        return ExecResult(
            stdout="",
            stderr="Blocked: destructive command pattern detected",
            returncode=1,
        )

    try:
        result = subprocess.run(
            cmd,
            shell=True,  # noqa: S602 — intentional, validated above
            capture_output=True,
            text=True,
            timeout=timeout,
            cwd=cwd,
        )
        return ExecResult(
            stdout=result.stdout,
            stderr=result.stderr,
            returncode=result.returncode,
        )
    except subprocess.TimeoutExpired:
        return ExecResult(
            stdout="",
            stderr=f"Command timed out after {timeout}s",
            returncode=1,
        )
    except Exception as e:  # noqa: BLE001
        return ExecResult(stdout="", stderr=str(e), returncode=1)


def exec_python(code: str, timeout: int = 30) -> ExecResult:
    """
    Execute Python code in a subprocess using a temporary file.

    Args:
        code: Python source code string.
        timeout: Maximum seconds to wait (default: 30).

    Returns:
        ExecResult with stdout, stderr, returncode.
    """
    with tempfile.NamedTemporaryFile(
        mode="w", suffix=".py", delete=False, encoding="utf-8"
    ) as tmp:
        tmp.write(code)
        tmp_path = tmp.name

    try:
        result = subprocess.run(
            [sys.executable, tmp_path],
            capture_output=True,
            text=True,
            timeout=timeout,
        )
        return ExecResult(
            stdout=result.stdout,
            stderr=result.stderr,
            returncode=result.returncode,
        )
    except subprocess.TimeoutExpired:
        return ExecResult(
            stdout="",
            stderr=f"Python execution timed out after {timeout}s",
            returncode=1,
        )
    except Exception as e:  # noqa: BLE001
        return ExecResult(stdout="", stderr=str(e), returncode=1)
    finally:
        os.unlink(tmp_path)


# ---------------------------------------------------------------------------
# Memory — FAISS + sentence-transformers
# ---------------------------------------------------------------------------

# Module-level state (initialized once per process)
_faiss_index = None
_embedder = None
_index_path: Optional[str] = None
_metadata_path: Optional[str] = None
_metadata_store: list[dict] = []


def init_memory(
    index_path: str,
    model_name: str = "all-MiniLM-L6-v2",
) -> None:
    """
    Initialize the FAISS index and sentence-transformers embedder.

    Creates the index file and metadata store if they don't exist.
    Loads existing data if the index already exists.

    Args:
        index_path: Path to the .faiss index file (e.g., .claude/memory/thyrox.faiss).
        model_name: sentence-transformers model to use for embeddings.
    """
    global _faiss_index, _embedder, _index_path, _metadata_path, _metadata_store

    try:
        import faiss  # type: ignore[import]
        from sentence_transformers import SentenceTransformer  # type: ignore[import]
    except ImportError as e:
        raise ImportError(
            f"Missing dependency: {e}. "
            "Run: pip install faiss-cpu sentence-transformers"
        ) from e

    _index_path = index_path
    _metadata_path = index_path.replace(".faiss", ".json")

    index_file = Path(index_path)
    index_file.parent.mkdir(parents=True, exist_ok=True)

    _embedder = SentenceTransformer(model_name)
    dim = _embedder.get_sentence_embedding_dimension()

    if index_file.exists():
        _faiss_index = faiss.read_index(str(index_file))
        meta_file = Path(_metadata_path)
        if meta_file.exists():
            with open(meta_file, encoding="utf-8") as f:
                _metadata_store = json.load(f)
        else:
            _metadata_store = []
    else:
        _faiss_index = faiss.IndexFlatL2(dim)
        _metadata_store = []
        faiss.write_index(_faiss_index, str(index_file))
        with open(_metadata_path, "w", encoding="utf-8") as f:
            json.dump(_metadata_store, f)


def store_memory(content: str, metadata: Optional[dict] = None) -> str:
    """
    Vectorize content and store in the FAISS index.

    Args:
        content: Text content to store.
        metadata: Optional dict with arbitrary metadata (wp, date, tags, etc.).

    Returns:
        UUID string identifying the stored entry.
    """
    global _faiss_index, _metadata_store

    if _faiss_index is None or _embedder is None:
        raise RuntimeError("Memory not initialized. Call init_memory() first.")

    import faiss  # type: ignore[import]
    import numpy as np  # type: ignore[import]

    entry_id = str(uuid.uuid4())
    embedding = _embedder.encode([content], convert_to_numpy=True).astype(np.float32)

    _faiss_index.add(embedding)
    _metadata_store.append(
        {
            "id": entry_id,
            "content": content,
            "metadata": metadata or {},
        }
    )

    # Persist to disk
    faiss.write_index(_faiss_index, str(_index_path))
    with open(_metadata_path, "w", encoding="utf-8") as f:  # type: ignore[arg-type]
        json.dump(_metadata_store, f, ensure_ascii=False, indent=2)

    return entry_id


def retrieve_memory(query: str, top_k: int = 5) -> list[MemoryResult]:
    """
    Retrieve the top_k most similar memories to the query.

    Args:
        query: Search query string.
        top_k: Maximum number of results to return (default: 5).

    Returns:
        List of MemoryResult sorted by cosine similarity descending.
    """
    if _faiss_index is None or _embedder is None:
        raise RuntimeError("Memory not initialized. Call init_memory() first.")

    import numpy as np  # type: ignore[import]

    n_stored = _faiss_index.ntotal
    if n_stored == 0:
        return []

    k = min(top_k, n_stored)
    query_vec = _embedder.encode([query], convert_to_numpy=True).astype(np.float32)

    distances, indices = _faiss_index.search(query_vec, k)

    results: list[MemoryResult] = []
    for dist, idx in zip(distances[0], indices[0]):
        if idx < 0 or idx >= len(_metadata_store):
            continue
        entry = _metadata_store[idx]
        # Convert L2 distance to a similarity score in [0, 1]
        score = float(1.0 / (1.0 + dist))
        results.append(
            MemoryResult(
                content=entry["content"],
                metadata=entry.get("metadata", {}),
                score=score,
            )
        )

    # Sort by score descending
    results.sort(key=lambda r: r.score, reverse=True)
    return results
