---
id: DOC-INFRA-WORKSPACE-CODEX-MCP
estado: borrador
propietario: equipo-infraestructura
ultima_actualizacion: 2025-11-20
relacionados: ["DOC-INFRA-INDEX", "EXECPLAN_codex_mcp_workspace"]
---
# Workspace Codex MCP

Este workspace documenta cómo inicializar Codex CLI como servidor MCP y cómo orquestar agentes con el Agents SDK siguiendo el flujo presentado por OpenAI.

## 1. Prerrequisitos

- **Variable de entorno**: crear un archivo `.env` con `OPENAI_API_KEY`.
- **Dependencias**: instalar `openai-agents` y `openai` en el entorno activo.
  ```bash
  %pip install openai-agents openai
  ```
- **IDE recomendado**: VS Code o Cursor para aprovechar integraciones MCP.

## 2. Servidor MCP

El blueprint `codex_cli_server_blueprint()` expuesto por `infrastructure.workspace.codex_mcp` describe el comando canónico:

```python
from infrastructure.workspace.codex_mcp import codex_cli_server_blueprint

server = codex_cli_server_blueprint()
print(server.command, server.args, server.client_session_timeout_seconds)
```

Este blueprint inicia `npx -y codex mcp` con timeout extendido a 360000 segundos para permitir ejecuciones largas.

## 3. Sistema mono-agente

La función `single_agent_system()` genera la configuración Designer → Developer:

- **Designer**: crea un brief de 3 frases y transfiere la tarea.
- **Developer**: implementa `index.html` usando Codex con `{"approval-policy": "never", "sandbox": "workspace-write"}` para persistir archivos sin pedir autorización.

```python
from infrastructure.workspace.codex_mcp import single_agent_system

system = single_agent_system()
print(system.entrypoint)              # Game Designer
print(system.expected_artifacts)      # ('index.html',)
```

## 4. Orquestación multi-agente

`multi_agent_workflow()` modela al Project Manager y el equipo especializado:

1. **Project Manager** redacta `REQUIREMENTS.md`, `TEST.md`, `AGENT_TASKS.md` y controla los handoffs.
2. **Designer** produce `/design/design_spec.md` y `/design/wireframe.md`.
3. **Frontend** genera `/frontend/index.html`, `styles.css`, `game.js`.
4. **Backend** implementa `/backend/server.js` y `package.json` (sin base de datos externa).
5. **Tester** documenta `/tests/TEST_PLAN.md` y `test.sh`.

Cada handoff está gateado: el Project Manager solo libera al siguiente agente cuando existen los artefactos esperados.

```python
from infrastructure.workspace.codex_mcp import multi_agent_workflow

workflow = multi_agent_workflow()
for rule in workflow.handoffs:
    print(f"{rule.source} → {rule.target}: {rule.required_artifacts}")
```

El `task_list_template` incluido replica el ejemplo “Bug Busters” para acelerar la puesta en marcha.

## 5. Observabilidad y Traces

Aunque el repositorio no conecta con el panel de Traces, los playbooks mantienen la estructura descrita por OpenAI para facilitar la observabilidad (prompts, handoffs, tiempos de ejecución, etc.). Quien despliegue el sistema real puede enviar los eventos generados por Codex MCP al dashboard para auditar conversaciones y tiempos de respuesta.

## 6. Validaciones

Ejecutar las pruebas asociadas desde la raíz del repositorio:

```bash
python3 -m pytest infrastructure/workspace/tests/codex_mcp/test_playbooks.py
python3 -m pytest infrastructure/workspace/tests
```

Las pruebas verifican:
- Blueprint del servidor (`npx -y codex mcp`).
- Políticas `workspace-write` en los agentes.
- Gating de artefactos antes de cada handoff.
- Deliverables mínimos para frontend, backend y testing.

## 7. Próximos pasos

- Integrar la captura de trazas reales hacia el dashboard de OpenAI.
- Automatizar el aprovisionamiento de dependencias con scripts de infraestructura.
- Conectar el workspace con agentes existentes (`ai_capabilities/`).

## Recursos

- Código: `infrastructure/workspace/codex_mcp/`
- Pruebas: `infrastructure/workspace/tests/codex_mcp/`
- ExecPlan: `docs/EXECPLAN_codex_mcp_workspace.md`
