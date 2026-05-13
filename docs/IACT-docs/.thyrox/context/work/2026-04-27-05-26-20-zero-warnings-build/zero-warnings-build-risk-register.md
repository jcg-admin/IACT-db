```yml
project: IACT-docs
work_package: 2026-04-27-05-26-20-zero-warnings-build
created_at: 2026-04-27 05:26:20
updated_at: 2026-04-27 05:26:20
current_phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
```

# Risk Register — zero-warnings-build

| ID | Riesgo | Prob | Impacto | Mitigación | Estado |
|----|--------|------|---------|------------|--------|
| R-01 | "0 warnings" no es alcanzable porque algunas vienen de extensiones third-party (sphinx-tabs, myst, design) sin control nuestro | M | A | Phase 3 ANALYZE: separar warnings propias vs ajenas; aceptar suprimir las ajenas via `suppress_warnings` con razón documentada | Abierto |
| R-02 | Fixes masivos de RST rompen el contenido visual de la doc | A | A | Fix por categoría con verificación incremental (`make html` por cada categoría); commits atómicos | Abierto |
| R-03 | Auto-fix con regex/script genera regresiones invisibles | A | A | No usar regex global ciego — herramienta + revisión humana antes de commit; o fix manual por archivo | Abierto |
| R-04 | El esfuerzo se vuelve un sumidero (479 warnings × 5 min = 40 horas) | A | M | Escalar por impacto: errores antes que warnings, alta-frecuencia antes que únicas; cap de horas por sesión | Abierto |
| R-05 | Algunas warnings revelan deuda de contenido más profunda (ej: 166 archivos huérfanos del toctree) que requieren reorganizar la información | M | A | Phase 4 CONSTRAINTS: decidir si reorganizar IA o suprimir warning con `:orphan:` | Abierto |
| R-06 | Warnings de `docutils` son errores genuinos de sintaxis RST que ocultan errores de comprensión del autor original | M | M | Phase 3 ANALYZE: leer la intención original antes de "corregir" sintaxis | Abierto |
| R-07 | `make html -W` (warnings as errors) se vuelve gate de CI sin que el equipo esté listo | M | M | Habilitar `-W` solo al final, después de Phase 11 TRACK con baseline 0 verificado | Abierto |
