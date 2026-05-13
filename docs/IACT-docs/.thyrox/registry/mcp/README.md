# MCP Servers

Servidores MCP que exponen capacidades de runtime a Claude durante la sesión. Son la capa de infraestructura de THYROX — permiten a Claude ejecutar código y mantener memoria persistente.

---

## Servidores disponibles

### `executor_server.py` — Ejecución de comandos

Expone dos herramientas:

| Herramienta | Descripción |
|-------------|-------------|
| `mcp__thyrox-executor__exec_cmd` | Ejecuta un comando shell. Aplica blocklist de seguridad. |
| `mcp__thyrox-executor__exec_python` | Ejecuta código Python en un entorno aislado. |

**Blocklist activa** (comandos bloqueados por seguridad):
- `rm -rf /`, `dd`, `mkfs`, `shutdown`, `reboot`, `halt`
- `:(){ :|:& };:` (fork bomb)
- Operaciones destructivas sobre dispositivos

### `memory_server.py` — Memoria persistente (FAISS)

Expone dos herramientas:

| Herramienta | Descripción |
|-------------|-------------|
| `mcp__thyrox-memory__store` | Guarda texto con metadata en el índice FAISS. Retorna UUID. |
| `mcp__thyrox-memory__retrieve` | Búsqueda semántica por query. Retorna top-K resultados. |

El índice FAISS persiste en disco entre sesiones.

### `thyrox_core.py` — Capa core

Módulo compartido importado por los dos servidores. No es un servidor MCP en sí:
- `exec_cmd(cmd, cwd, timeout)` → `ExecResult`
- `exec_python(code, timeout)` → `ExecResult`
- `init_memory(index_path, model_name)` → inicializa FAISS
- `store_memory(content, metadata)` → `str` (UUID)
- `retrieve_memory(query, top_k)` → `list[MemoryResult]`

---

## Configuración

Los servidores están declarados en `.mcp.json` en la raíz del repo:

```json
{
  "mcpServers": {
    "thyrox-memory": {
      "command": "python",
      "args": [".claude/registry/mcp/memory_server.py"]
    },
    "thyrox-executor": {
      "command": "python",
      "args": [".claude/registry/mcp/executor_server.py"]
    }
  }
}
```

Claude Code arranca los servidores automáticamente al inicio de cada sesión.

---

## Dependencias

```bash
pip install -r requirements.txt
```

El `requirements.txt` en la raíz del repo incluye `faiss-cpu`, `sentence-transformers` y otras dependencias de los servidores.

---

## Cómo extender

Para agregar una nueva herramienta MCP:

1. Añadir la lógica en `thyrox_core.py` si es compartida, o directamente en el servidor si es específica
2. Registrar el nuevo tool en el servidor correspondiente siguiendo el patrón MCP
3. Actualizar `.mcp.json` si se agrega un nuevo servidor completo
4. Actualizar `requirements.txt` si hay nuevas dependencias
5. Documentar la nueva herramienta en este README
6. Commit: `feat(mcp): add {nombre-herramienta} tool`

---

## Troubleshooting

**Los servidores no arrancan:**
```bash
# Verificar dependencias
pip install -r requirements.txt

# Probar servidor manualmente
python .claude/registry/mcp/executor_server.py
```

**Error de FAISS en memory_server:**
```bash
# FAISS requiere CPU o GPU según la instalación
pip install faiss-cpu  # CPU (recomendado para desarrollo)
pip install faiss-gpu  # GPU (producción)
```
