```yml
type: Architectural Decision Record
category: Decisión Técnica
version: 1.0
purpose: ROADMAP.md como single source of truth
goal: Establecer ROADMAP.md como fuente única de verdad
updated_at: 2026-03-25
```

# ADR-002: ROADMAP.md como Single Source of Truth

**ADR ID:** ADR-002 | **Status:** Aprobado | **Fecha:** 2025-03-24 | **Owner:** User

---

## Contexto

Necesitamos un único lugar donde se registre el estado y progreso del proyecto.

---

## Opciones Consideradas

### GitHub Issues
- Scattered context
- No versionado
- Requiere acceso a GitHub

### Trello
- No versionable
- Lock-in a plataforma
- Desaparece con cambios de plan

### Linear
- Caro
- Lock-in
- No integrado con Git

### Notion
- Cerrado
- No versionado
- Sin historial de cambios

### ROADMAP.md (Elegido)
- Versionable
- Accesible desde cualquier lugar
- Integrable con Claude Code
- Simple y eficiente
- No requiere herramientas externas

---

## Decisión

**ROADMAP.md es la fuente única de verdad para tracking de tareas y estado del proyecto.**

---

## Justificación

- **Versionable:** Historial completo en Git
- **Accesible:** Se puede leer en cualquier lugar
- **Integrable:** Claude Code puede leerlo y actualizarlo
- **Simple:** Sin complejidad innecesaria
- **Eficiente:** Bajo overhead de mantenimiento
- **Open:** No requiere herramientas externas o suscripciones

---

## Consecuencias

### Positivas

+Un único lugar de verdad<br>
+Historial versionado de cambios<br>
+Bajo costo<br>
+Fácil de consultar

### Negativas

-Requiere disciplina de actualización<br>
-No hay notificaciones automáticas<br>
-Búsqueda limitada

---

## Impacto

**Áreas afectadas:**<br>
- Gestión de tareas<br>
- Tracking de progreso<br>
- Planificación de features

**Fecha de implementación:** 2025-03-24

---

**Estado:** Activo en producción
