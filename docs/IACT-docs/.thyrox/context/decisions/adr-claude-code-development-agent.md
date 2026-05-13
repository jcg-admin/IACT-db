```yml
type: Architectural Decision Record
category: Decisión Técnica
version: 1.0
purpose: Claude Code como Development Agent
goal: Automatizar desarrollo con Claude Code
updated_at: 2026-03-25
```

# ADR-005: Claude Code como Development Agent

**ADR ID:** ADR-005 | **Status:** Aprobado | **Fecha:** 2025-03-24 | **Owner:** User

---

## Decisión

**Usar Claude Code para automatización de desarrollo.**

---

## Usar Para

- Commits automáticos
- Changelog generation
- Tests
- Refactoring
- Documentation

---

## No Usar Para

- Decisiones arquitectónicas (human-only)
- Code reviews finales (human validation)
- Deployments críticos (manual gate)

---

## Contexto

- CLAUDE.md define comportamiento
- /task:create para nuevas tareas
- /clear para limpiar contexto si es muy largo

---

## Justificación

- Acelera desarrollo
- Reduce trabajo manual
- Mejora consistencia
- Integración con Markdown

---

## Consecuencias

### Positivas

+Desarrollo más rápido<br>
+Menos trabajo manual<br>
+Más consistencia<br>
+Mejor documentación

### Negativas

-Requiere configuración inicial<br>
-Dependencia de Claude Code<br>
-Curva de aprendizaje

---

**Estado:** Activo en producción
