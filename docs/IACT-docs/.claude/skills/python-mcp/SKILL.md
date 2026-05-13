```yml
name: python-mcp
description: "Skill de tecnología para implementar MCP servers en Python y usar EvoAgentX como librería interna. Usar cuando se trabaje en registry/mcp/*.py, registry/bootstrap.py, o cualquier código Python del meta-framework THYROX. Invocar durante Phase 7 DESIGN/SPECIFY para especificar contratos de tools MCP, durante Phase 10 EXECUTE para implementar servers y el adapter layer, y durante Phase 11 TRACK/EVALUATE para verificar seguridad y correctitud."
layer: backend
framework: python-mcp
project: thyrox
stack:
  - Python 3.11+
  - MCP SDK (mcp >= 0.9.0)
  - EvoAgentX 0.1.0
  - faiss-cpu
  - sentence-transformers
```

# Python MCP — SKILL

Guía fase-por-fase para implementar MCP servers y código Python del meta-framework THYROX.

---

## Stage 3: DIAGNOSE — Qué investigar antes de tocar Python

- ¿El código es un MCP server (expone tools) o una librería interna (importada por otros)?
- ¿Qué EvoAgentX APIs se necesitan? Verificar en `_evoagentx_adapter.py` si ya existe el método
- ¿El código modifica el índice FAISS? → Verificar thread-safety y persistencia
- ¿Ejecuta subprocesos? → Identificar comandos, timeouts, y patrones peligrosos a bloquear
- ¿Es idempotente? (bootstrap.py debe serlo siempre)

## Phase 7: DESIGN/SPECIFY — Qué especificar para MCP servers

En `requirements-spec.md`, para cada MCP tool:
- Schema de inputs con tipos explícitos (str, int, dict)
- Schema de output — siempre dict JSON-serializable
- Precondiciones (¿qué debe existir antes de llamar la tool?)
- Comportamiento en error — nunca raise sin capturar; retornar error en el dict
- Timeout si la operación puede bloquearse

## Stage 10: IMPLEMENT — Convenciones de implementación

Ver sección INSTRUCTIONS para reglas activas.

Orden de implementación para un MCP server nuevo:
1. `_evoagentx_adapter.py` — interfaces estables primero
2. Dataclasses de retorno (`ExecResult`, `MemoryResult`)
3. Implementar cada función del adapter con type hints completos
4. MCP server file — importa adapter, registra tools, `server.run()`
5. Probar manualmente con `echo '{"method":"tools/list"}' | python server.py`
6. Actualizar `settings.json` con la nueva entrada mcpServers

## Phase 11: TRACK/EVALUATE — Qué revisar al cerrar

- Todas las funciones públicas tienen type hints de entrada y salida
- `exec_cmd` y `exec_python` tienen timeout configurado — nunca bloquean infinito
- Patrones destructivos bloqueados en `exec_cmd` (rm -rf /, fork bombs, etc.)
- Índice FAISS se persiste después de cada `store_memory` — no se pierde en crash
- `bootstrap.py` es idempotente — correrlo dos veces no rompe nada
- Zero secrets hardcodeados — paths configurables via env vars o argumentos
