```yml
type: Architectural Decision Record
category: Decisión Técnica
version: 1.0
purpose: YAML para configuración
goal: Estandarizar formato de configuración
updated_at: 2026-03-25
```

# ADR-006: YAML para Configuración

**ADR ID:** ADR-006 | **Status:** Pendiente (Fase 2) | **Fecha:** 2025-03-24 | **Owner:** User

---

## Decisión

**Usar YAML para archivos de configuración (CI/CD, etc).**

---

## Archivos

- `.github/workflows/*.yml` - GitHub Actions
- `docker-compose.yml` - Docker setup
- `.claude/config.yml` - Claude Code config

---

## Justificación

- Readable
- Indentation based (visual structure)
- Wide support
- Human-friendly

---

## Consecuencias

### Positivas

+Legible para humanos<br>
+Amplio soporte<br>
+Fácil de mantener

### Negativas

-Sensible a indentación<br>
-Menos expresivo que JSON

---

**Estado:** Planeado para Fase 2
