# Workspaces de Hamilton

Este directorio agrupa workspaces autocontenidos que acompañan la guía de integración Hamilton y las prácticas de TDD para GenAI.

## Hamilton LLM Example

- **Código**: `infrastructure/workspace/hamilton_llm/`
- **Pruebas**: `infrastructure/workspace/tests/hamilton_llm/test_driver.py`

El paquete contiene el driver declarativo (`driver.py`), el dataflow (`dataflow.py`) y el cliente LLM determinista (`llm_client.py`).

### Objetivo

1. Demostrar el flujo `Data → Prompt → LLM → $` utilizando el patrón de funciones declarativas de Hamilton.
2. Servir como punto de partida para crear workspaces adicionales orientados a GenAI en la carpeta `infrastructure/workspace/`.

### Cómo ejecutarlo

```bash
python3 -m pytest infrastructure/workspace/tests/hamilton_llm/test_driver.py
```

La prueba valida tanto el linaje del dataflow como el manejo de dependencias ausentes, permitiendo extender el workspace mediante TDD.

## Hamilton Language Server (Dev Tools)

- **Código**: `infrastructure/workspace/dev_tools/language_server/hamilton_lsp/`
- **Pruebas**: `infrastructure/workspace/tests/dev_tools/language_server/test_hamilton_lsp.py`

Este workspace replica de forma auto-contenida la estructura del lenguaje de servidores de Apache Hamilton. Incluye un `HamiltonLanguageServer` que puede registrar eventos de apertura/cambio, generar completions, exponer símbolos y enviar visualizaciones DOT sin depender de librerías externas.

### Cómo validarlo

```bash
python3 -m pytest infrastructure/workspace/tests/dev_tools/language_server/test_hamilton_lsp.py
```

Las pruebas cubren el registro de features LSP, la construcción del grafo al abrir documentos, los comandos de visualización y la extracción de símbolos.

## Codex MCP Playbooks

- **Código**: `infrastructure/workspace/codex_mcp/`
- **Pruebas**: `infrastructure/workspace/tests/codex_mcp/test_playbooks.py`
- **Documentación**: [`codex_mcp.md`](codex_mcp.md)

El workspace Codex MCP define blueprints declarativos para:

1. Inicializar Codex CLI como servidor MCP (`npx -y codex mcp`).
2. Ejecutar un flujo mono-agente (Designer → Developer) con políticas `workspace-write` automáticas.
3. Orquestar el equipo multi-agente (Project Manager, Designer, Frontend, Backend, Tester) con handoffs gateados.

### Cómo validarlo

```bash
python3 -m pytest infrastructure/workspace/tests/codex_mcp/test_playbooks.py
```

Las pruebas comprueban el blueprint del servidor, la presencia de las políticas Codex MCP, las secuencias de handoffs y los deliverables esperados por cada rol.

## Registro de suites

Para verificar la alineación estructural del workspace, se expone `infrastructure/workspace/tests/test_registry.py`, que afirma la presencia de `TEST_SUITES` en el paquete raíz y que todos los workspaces quedan registrados para futuras automatizaciones.
