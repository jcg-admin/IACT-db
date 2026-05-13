```yml
created_at: 2026-04-20 13:46:30
project: THYROX
author: NestorMonroy
status: Aprobado
```

# ADR: python-mcp como Skill Manual (fuera del pipeline _generator.sh)

## Decisión

`python-mcp.instructions.md` en `.thyrox/guidelines/` es una guideline manual — NO fue generada por `_generator.sh` y NO tiene template en registry. Se crea y mantiene manualmente.

## Razón

Las guidelines de MCP para Python requieren documentación de:
- Patrones de seguridad específicos del protocolo MCP (JSON-RPC, tool contracts)
- Restricciones de runtime del servidor MCP de THYROX
- Instrucciones de integración con ADK y callback contracts

Este contenido no es parametrizable en el template genérico de `_generator.sh`. El generador produce guidelines de convenciones de stack tecnológico (naming, estructura de código, patrones de módulo) — no instrucciones de protocolo de integración.

## Distinción con guidelines generadas

| Guideline | Origen | Template |
|-----------|--------|---------|
| backend-nodejs.instructions.md | _generator.sh | registry/backend/nodejs.template.md |
| db-mysql.instructions.md | _generator.sh | registry/db/mysql.template.md |
| db-postgresql.instructions.md | _generator.sh | registry/db/postgresql.template.md |
| frontend-react.instructions.md | _generator.sh | registry/frontend/react.template.md |
| frontend-webpack.instructions.md | _generator.sh | registry/frontend/webpack.template.md |
| agentic-python.instructions.md | _generator.sh | registry/agentic/python.template.md |
| **python-mcp.instructions.md** | **manual** | **sin template** |

## Impacto en CLAUDE.md

La sección `@imports` de CLAUDE.md describe el bloque como "Directivas siempre activas para el stack del proyecto. Generadas por `registry/_generator.sh`." Esta descripción es incorrecta para `python-mcp.instructions.md` — fue creada manualmente.

La nota aclaratoria en CLAUDE.md distingue:
- Guidelines generadas: backend-nodejs, db-mysql, db-postgresql, frontend-react, frontend-webpack, agentic-python
- Guidelines manuales: python-mcp

## Consecuencias

- Al actualizar templates de `_generator.sh`, `python-mcp.instructions.md` NO se regenera — debe actualizarse manualmente
- Si se agrega un nuevo servidor MCP, seguir el mismo patrón: crear guideline manual con contenido de protocolo específico
- No intentar agregar `python-mcp` al pipeline de `_generator.sh` sin primero extraer el contenido de protocolo a un template parametrizable

## Contexto histórico

ÉPICA 42 identificó (cluster-i, H-04) que CLAUDE.md declaraba `python-mcp.instructions.md` como "generada por registry/_generator.sh" — descripción performativa que no correspondía al origen real del archivo. Esta ADR formaliza la distinción y previene la confusión para mantenedores futuros.
