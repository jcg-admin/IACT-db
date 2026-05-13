```yml
type: Architectural Decision Record
category: Decisión Técnica
version: 1.0
purpose: Convenciones de commits
goal: Estandarizar formato de commits
updated_at: 2026-03-25
```

# ADR-003: Conventional Commits

**ADR ID:** ADR-003 | **Status:** Aprobado | **Fecha:** 2025-03-24 | **Owner:** User

---

## Decisión

**Usar Conventional Commits v1.0.0 para todos los commits.**

---

## Formato

```
<type>(<scope>): <description>

<body>

<footer>
```

---

## Tipos Soportados

**feat:** Feature nueva<br>
**fix:** Corrección de bug<br>
**docs:** Cambios en documentación<br>
**style:** Formato de código<br>
**refactor:** Refactoring<br>
**perf:** Mejoras de performance<br>
**test:** Agregar/modificar tests<br>
**chore:** Build, deps, configuración

---

## Justificación

- Commits legibles y semánticos
- Facilita changelog automático
- Semantic versioning automático
- Git history limpio y auditable
- Estándar de industria

---

## Consecuencias

### Positivas

+Changelog automático desde commits<br>
+Versionado automático (semantic)<br>
+Historia clara y estructurada<br>
+Fácil de auditar cambios

### Negativas

-Requiere disciplina de escribir buenos mensajes<br>
-Requiere conocimiento del formato

---

## Implementación

- Usar [commit-convention](../../skills/workflow-execute/references/commit-convention.md) como guía
- Commit helper script (opcional)
- Code review valida formato

---

**Estado:** Activo en producción
