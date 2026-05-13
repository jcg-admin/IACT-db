```yml
type: Architectural Decision Record
category: Decisión Técnica
version: 1.0
purpose: Separación de sub-proyectos
goal: Organizar código en sub-proyectos independientes
updated_at: 2026-03-25
```

# ADR-004: Separación de Sub-proyectos

**ADR ID:** ADR-004 | **Status:** Aprobado | **Fecha:** 2025-03-24 | **Owner:** User

---

## Decisión

**API y Build son sub-proyectos separados dentro del mismo repositorio.**

---

## Estructura

```
thyrox/
├── api/        # Sub-proyecto API
├── build/      # Sub-proyecto Build
└── docs/       # Documentación compartida
```

---

## Justificación

- Independencia de desarrollo
- Equipos pueden trabajar en paralelo
- Versionado separado si es necesario
- Misma documentación base
- Mantenimiento enfocado

---

## Consecuencias

### Positivas

+Desarrollo paralelo facilitado<br>
+Equipos independientes<br>
+Responsabilidades claras<br>
+Escalabilidad

### Negativas

-Complejidad de monorepo<br>
-Sincronización de dependencias<br>
-Build más complejo

---

## Alternativas Consideradas

- Monorepo gigante (demasiado caótico)
- Repositorios separados (falta de contexto)

---

**Estado:** Activo en producción
