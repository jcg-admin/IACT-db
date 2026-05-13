```yml
project: IACT-docs
work_package: 2026-04-28-00-19-57-source-references-audit
created_at: 2026-04-28 00:19:57
updated_at: 2026-04-28 00:19:57
current_phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
```

# Risk Register — source-references-audit

| ID | Riesgo | Prob | Impacto | Mitigación | Estado |
|----|--------|------|---------|------------|--------|
| R-01 | Auditoría se vuelve tarea de fix masiva sin documentar primero | A | A | Este WP es **solo de análisis** — produce inventario y plan, NO toca archivos `.rst` | Abierto |
| R-02 | Estimación de esfuerzo para limpieza queda corta porque hay refs ocultas (en text rendered, code blocks, etc.) | M | M | Ejecutar regex sobre todo el contenido bruto, no solo links validados por sphinx | Abierto |
| R-03 | Confundir "broken link de sphinx" con "ref de texto plano sin link" — son distintos | A | M | Distinguir desde Phase 1: refs validadas por sphinx (147) vs menciones en texto (resto) | Abierto |
| R-04 | El usuario decide reemplazar refs en bloque y rompe semántica de archivos | M | A | Plan propone clasificar primero (A/B/C/D) y procesar por categoría con criterio | Abierto |
| R-05 | Crear stubs `.rst` para refs que apunten a docs que ya no existen viola la regla de no inflar source/ | M | M | Decisión documentada: no crear stubs — eliminar ref o convertirlo a literal text | Abierto |
| R-06 | Refs duplicadas entre archivos crean ilusión de "mucho roto" — mismo target referenciado 27 veces | A | B | Reportar tanto ocurrencias totales como destinos únicos | Abierto |
| R-07 | El conteo cambia a medida que se trabajan los WPs activos (otros toques pueden agregar/quitar refs) | M | B | Capturar snapshot al inicio del WP y comparar al cierre | Abierto |
| R-08 | Sub-tipos de refs (`:ref:`, `:doc:`, `<URL>`, `:include:`, etc.) tienen distinto impacto y no se distinguen | M | M | Inventario por tipo en Phase 1 DISCOVER | Abierto |
| R-09 | Las refs a archivos externos (`provisioning/`, `api/`) no son fixeables desde este repo — solo documentables | A | M | Categoría C: convertir a texto literal, no intentar resolver | Abierto |
| R-10 | Audit produce reporte pero sin priorización el cleanup post-audit no avanza | M | A | Phase 5 STRATEGY del WP cleanup deberá priorizar por impacto (broken sphinx primero, después texto) | Abierto |
