---
title: Gobernanza del Backend IACT
date: 2025-11-13
domain: backend
status: active
---

# Gobernanza del Backend IACT

**Propósito**: Políticas y procesos de gobernanza de desarrollo específicos del dominio Backend.

## [WARNING] Gobernanza Multi-nivel

El proyecto IACT utiliza una arquitectura de gobernanza en dos niveles:

1. **Gobernanza Global** ([`/docs/gobernanza/`](../gobernanza/)): Decisiones que afectan a TODO el proyecto
2. **Gobernanza Backend** (este directorio): Decisiones específicas del backend

### Enlaces Rápidos a Gobernanza Global

**ANTES de crear un ADR aquí, consulta la gobernanza global:**

| Recurso | Ubicación |
|---------|-----------|
| **ADRs Globales** | [`/docs/gobernanza/adr/`](../gobernanza/adr/) |
| **Guías Compartidas** | [`/docs/gobernanza/guias/`](../gobernanza/guias/) |
| **Procedimientos** | [`/docs/gobernanza/procedimientos/`](../gobernanza/procedimientos/) |
| **Templates** | [`/docs/gobernanza/templates/`](../gobernanza/templates/) |
| **Diseño Global** | [`/docs/gobernanza/diseno/`](../gobernanza/diseno/) |

**Documento clave**: [`ADR-GOB-010: Gobernanza Multi-nivel`](../gobernanza/adr/ADR-GOB-010-gobernanza-multinivel.md)

### ¿Cuándo crear ADR aquí vs. Global?

**[OK] ADR de Backend (aquí)**: Solo afecta backend, stack-specific (Python/Django), no rompe interoperabilidad

**[ERROR] ADR Global**: Afecta múltiples dominios, define estándares del proyecto, cross-cutting concerns

## Contenido

- ADRs específicos del backend (ver [`adr/`](adr/))
- Procesos SDLC
- Políticas de código
- Code review guidelines
- Definition of Done
- Políticas de seguridad

## Documentos

- `sdlc-process.md`: Proceso SDLC completo
- `code-standards.md`: Standards de código
- `code-review-checklist.md`: Checklist de review
- `definition-of-done.md`: Criterios de completitud
- `security-policies.md`: Políticas de seguridad

## Restricciones Criticas IACT

### RNF-002: NO Redis
- Sesiones en MySQL
- Validacion automatica en CI

### NO Emojis/Iconos
- ASCII puro solamente
- Validacion con check_no_emojis.py

### NO Email/SMTP
- Usar InternalMessage
- Validacion en CI

## Ownership

Maintainer: Tech Lead
Review: Arquitecto + Product Owner
