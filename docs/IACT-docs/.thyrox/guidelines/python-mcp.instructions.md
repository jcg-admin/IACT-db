# Python MCP — Guidelines

Reglas siempre activas para código Python del meta-framework THYROX.
Aplica a: `registry/mcp/*.py`, `registry/bootstrap.py`, cualquier `.py` en el proyecto.

**Principio:** Código propio inspirado en patrones de EvoAgentX. Sin dependencia de `evoagentx`.

---

## Regla 1: Type hints completos — sin `Any` innecesario

```python
# CORRECTO
def exec_cmd(cmd: str, cwd: str = ".", timeout: int = 60) -> ExecResult:
    ...

def retrieve_memory(query: str, top_k: int = 5) -> list[MemoryResult]:
    ...

# INCORRECTO
def exec_cmd(cmd, cwd=".", timeout=60):
    ...
```

---

## Regla 2: Dataclasses para retornos estructurados — no dicts crudos

```python
# CORRECTO
from dataclasses import dataclass

@dataclass
class ExecResult:
    stdout: str
    stderr: str
    returncode: int

# INCORRECTO — dict crudo sin tipado
def exec_cmd(...) -> dict:
    return {"stdout": ..., "stderr": ..., "returncode": ...}
```

---

## Regla 3: exec_cmd siempre con timeout — nunca bloquea indefinido

```python
# CORRECTO
result = subprocess.run(
    cmd,
    shell=True,
    capture_output=True,
    text=True,
    timeout=timeout,
    cwd=cwd,
)

# INCORRECTO — sin timeout
result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
```

---

## Regla 4: Bloquear patrones destructivos antes de exec_cmd

```python
import re

BLOCKED_PATTERNS = [
    r"rm\s+-rf\s+/",
    r">\s*/dev/sd",
    r"dd\s+if=.*of=/dev/",
    r"mkfs\.",
    r":\(\)\s*\{.*\}",  # fork bomb
]

def _is_safe_command(cmd: str) -> bool:
    return not any(re.search(p, cmd) for p in BLOCKED_PATTERNS)
```

---

## Regla 5: MCP servers — error en tool retorna dict con "error", nunca raise

```python
# CORRECTO — errores como datos, no excepciones
@server.tool()
async def exec_cmd_tool(cmd: str, cwd: str = ".") -> dict:
    try:
        result = _exec_cmd(cmd, cwd)
        return {"stdout": result.stdout, "stderr": result.stderr, "returncode": result.returncode}
    except Exception as e:
        return {"error": str(e), "returncode": -1}

# INCORRECTO — raise rompe el MCP server
@server.tool()
async def exec_cmd_tool(cmd: str) -> dict:
    result = subprocess.run(cmd, ...)  # puede raise FileNotFoundError, etc.
```

---

## Regla 6: Paths via pathlib — no string concatenation

```python
# CORRECTO
from pathlib import Path

index_path = Path(os.environ.get("MEMORY_INDEX_PATH", ".claude/memory/thyrox.faiss"))
index_path.parent.mkdir(parents=True, exist_ok=True)

# INCORRECTO
index_path = ".claude/memory/" + "thyrox.faiss"
```

---

## Regla 7: bootstrap.py — idempotencia obligatoria

```python
# CORRECTO — verificar antes de escribir
def write_agent(output_path: Path, content: str, force: bool = False) -> str:
    if output_path.exists() and not force:
        return f"skip: {output_path} ya existe (usar --force para sobreescribir)"
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(content)
    return f"ok: {output_path}"

# INCORRECTO — sobreescribe siempre sin avisar
output_path.write_text(content)
```

---

## Regla 8: FAISS — persistir después de cada store, no al cerrar

```python
# CORRECTO — persistir inmediatamente tras agregar
def store_memory(content: str, metadata: dict) -> str:
    vector = model.encode([content])
    index.add(vector)
    faiss.write_index(index, str(index_path))  # siempre
    return str(uuid.uuid4())

# INCORRECTO — persistir solo al cerrar (se pierde en crash)
atexit.register(lambda: faiss.write_index(index, str(index_path)))
```

---

## Stack de dependencias (no agregar sin justificación)

```
mcp >= 0.9.0                   # MCP SDK Anthropic
faiss-cpu >= 1.7.4             # vector store local (no faiss-gpu)
sentence-transformers >= 2.2.0  # embeddings locales
pydantic >= 2.0                # validación de schemas
```

**Prohibido agregar sin ADR:** `evoagentx`, `torch`, `tensorflow`, `fastapi`, `celery`, `redis`.
