```yml
created_at: 2026-05-01 05:17:20
project: IACT-docs
work_package: 2026-05-01-05-17-20-uc-dependency-matrix-iact
phase: Phase 11 — TRACK
author: NestorMonroy
status: Borrador
version: 1.0.0
language: es
parte: conclusión
```

# Conclusión — Métricas finales y próximos pasos

> Cierre del entregable
> ``MATRIZ-DEPENDENCIAS-UC-IACT v1.0.0``.
> Consolida métricas de las 6 partes y deja
> recomendación operativa para los próximos WPs
> del proyecto.

## C.1 Métricas globales del proyecto

::

   ARTEFACTOS DEL CATÁLOGO
   ------------------------
   Casos de uso vigentes:           61 (verificado)
   Clusters funcionales:            9
   Clases canónicas de dominio:     25 (modelo-dominio-iact v1.0.0)
   Bounded contexts:                7 (Auth, RBAC, Calls,
                                       Reports & Metrics,
                                       Pipeline ETL, Alerts,
                                       Audit, Logs)
   Funciones RBAC:                  61 (modelo-rbac-iact v5.4.0)
   Constraints vigentes citadas:    13 (CNST + BR en versiones
                                        canónicas)

   DISTRIBUCIÓN POR CRITICIDAD
   ----------------------------
   CRÍTICOS:                         8 UCs (13%)
   ALTOS:                           27 UCs (44%)
   MEDIOS:                          18 UCs (30%)
   BAJOS:                            8 UCs (13%)

   GRAFO DE DEPENDENCIAS
   ----------------------
   Aristas REQUIERE explícitas:     ≈ 70
   Aristas transversales (T-01):    59 (todos los UCs no públicos)
   Aristas transversales (T-02):    59
   Aristas transversales (T-03):    35 (UCs de escritura)
   UCs raíz (REQUIERE = ninguno):   18
   Camino crítico mínimo:            4 UCs
                                    (UC_AUTH_01 → UC_PERM_07
                                     → UC_RPT_01 + UC_PIP_01
                                     prerequisite background)

   ESFUERZO ESTIMADO
   ------------------
   Person-days UCs:                170
   Overhead (DB, middleware, infra, tests):  88
   Total proyecto:                  ≈ 258 person-days
   Calendario con 2 devs:           ≈ 30 semanas (~7 meses)
   Calendario con 4 devs:           ≈ 15 semanas (~3.5 meses)
   Sprints propuestos:               15

   PATRONES DE DISEÑO
   -------------------
   Patrones GoF/POSA aplicados:     15 distintos
   Patrón más usado (Command):      17 UCs
   Patrones cross-cutting IACT:      8 (RBAC Decorator,
                                       Audit Emitter,
                                       Soft Delete BR-009,
                                       Filtered Variant,
                                       ACC-PERM Coexistence,
                                       Larman Consolidation,
                                       Async Throttled Export,
                                       Internal Mailbox)
   Componentes infra reutilizables:  5 (decorador,
                                       middleware audit,
                                       LifecycleEntity,
                                       ExportJobScheduler,
                                       InternalMailbox)

## C.2 Hallazgos consolidados

| ID | Tipo | Descripción |
|----|------|-------------|
| H-M01 | OBSERVABLE | Los 8 CRÍTICOS son sólo 13% del catálogo pero concentran las 4 rutas críticas. Su fallo deja el sistema sin valor. |
| H-M02 | OBSERVABLE | 59 de 61 UCs requieren T-01 + T-02 (sólo UC_AUTH_01 y la rama pública de UC_AUTH_03 son excepciones). El middleware Auth + RBAC es el componente con mayor leverage del proyecto. |
| H-M03 | OBSERVABLE | UC_PERM_07 es el cuello de botella más crítico — invocado en cada request por todos los UCs operativos. Performance < 50 ms es requisito explícito; sin cache LRU + invalidación, el sistema no escala. |
| H-M04 | OBSERVABLE | UC_PIP_01 (Supervisar ETL) es prerequisito background de todos los UCs RPT y ALR. Si el ETL falla, el dashboard muestra datos stale. Requiere health check + alerta automática. |
| H-M05 | INFERRED | El cluster RPT (15 UCs, 41 person-days) es el más voluminoso. Conviene paralelizar fuertemente: 14 de 15 UCs RPT extienden UC_RPT_01, así que una vez UC_RPT_01 esté implementado, el resto se desarrolla en paralelo. |
| H-M06 | OBSERVABLE | Las 8 patterns cross-cutting de IACT (RBAC Decorator, Audit Emitter, etc.) capturan ≈ 80 % de la infraestructura del sistema. Implementarlas bien es decisivo. |
| H-M07 | OBSERVABLE | Sólo 18 UCs son raíces del grafo (REQUIERE = ninguno). El resto depende transitivamente de ellos. Implementación debe respetar el orden topológico per § 5.5. |
| H-M08 | INFERRED | El cluster AUD tiene UC_AUD_01 como hub: extendido por UC_AUD_02, _03, _04 + UC_PERM_09, _10, UC_ACC_09. Total 6 UCs dependen de él. Es el hub más concentrado del sistema. |

Cero SPECULATIVE — gate I-012 satisfecho.

## C.3 Comparación con corpus equivalente

Mediciones de referencia para el dominio IACT
(no disponibles públicamente como benchmark
externo, sino derivadas de los WPs cerrados del
programa Z):

::

   Iteración del catálogo:            v5.4.0 (vigente)
   Iteraciones previas (programa Z):  v4.0 → v5.0 → v5.0_1
                                      → v5.1 → v5.1.1
                                      → v5.2.0 → v5.2.1
                                      → v5.3.0 → v5.4.0
   UCs históricos pico:               75 (v4.0)
   UCs corregidos por programa Z:     6 nuevos + 2 consolidados
                                      + 4 re-mapeados + 6 renames
                                      preservando IDs
   Corrección por WP previo:          61 / 61 UCs alineados
                                      contra modelo canónico

## C.4 Próximos pasos

### Inmediato

1. **Cierre de este WP** por orden del ejecutor
   (I-011) tras revisión.
2. **Promoción opcional** del documento
   consolidado a ``source/`` como
   ``source/arquitectura-tecnica/matriz-dependencias-uc-iact.rst``
   en próximo WP de promoción documental
   (similar a la promoción del modelo de
   dominio).

### Corto plazo (próximo WP)

3. **Stage 7 DESIGN para implementación**: usar
   el orden topológico de § 5.5 + los 5
   componentes cross-cutting de § 6.4 como guía
   de diseño técnico (Django models / services /
   middleware).
4. **Materializar los 8 CRÍTICOS** primero:
   sprints 1-3 cubren UC_AUTH_01, UC_AUTH_04,
   UC_PERM_07, UC_RPT_01, UC_PIP_01,
   UC_AUD_01, UC_USR_02, UC_ACC_03.
5. **Implementar el middleware T-02 / T-03**
   junto con UC_PERM_07 para que esté listo
   antes de los 59 UCs que dependen de él.

### Mediano plazo

6. **Validación con stakeholders reales** (si se
   habilitan): el plan de elicitación adaptada
   del WP de canonización marcó como riesgo R-01
   la ausencia de stakeholders externos. Cuando
   estén disponibles, validar la criticidad
   asignada y las 4 rutas críticas.
7. **Refinamiento de estimaciones**: las cifras
   de Parte 5 son analíticas. Tras los primeros
   sprints, calibrar contra real para ajustar el
   resto.
8. **Visualizaciones PlantUML** del grafo
   completo (omitidas en este entregable por
   densidad — el diagrama de
   ``modelo-dominio-iact.rst`` cubre las clases;
   la matriz UC × UC se visualiza mejor por
   cluster).

### Largo plazo

9. **WP de implementación real**: convertir
   este análisis en ADRs de implementación
   (Django apps, modelos, vistas, serializers,
   tests) usando la arquitectura ADR-DEVOPS-001
   (Vagrant + Apache + mod_wsgi + Django + MySQL
   + Redis).
10. **Operación y monitoreo**: aplicar los UCs
    LOG_05, LOG_06, LOG_07 (infraestructura,
    salud, métricas técnicas) como observabilidad
    del sistema cuando esté en producción.

## C.5 Status del entregable

| Parte | Status | Líneas aprox |
|-------|:------:|-------------:|
| 1 — Resumen ejecutivo | ✓ | 290 |
| 2 — Tabla maestra (61 UCs) | ✓ | 830 |
| 3 — Matriz compacta | ✓ | 350 |
| 4 — Dependencias críticas | ✓ | 360 |
| 5 — Criticidad y duración | ✓ | 290 |
| 6 — Patrones de diseño | ✓ | 290 |
| Conclusión | ✓ | 220 |
| **Total** | **6 / 6 + concl.** | **~2 630** |

Cobertura final:

- 61 / 61 UCs documentados con ficha completa.
- 100 % cobertura UC × clase verificada (de WP
  predecesor).
- 4 rutas críticas + 3 transversales tipificadas.
- 25 patrones de diseño identificados (15 GoF +
  8 cross-cutting IACT + 2 DDD).
- Timeline propuesto con 15 sprints.
- 8 hallazgos H-M01..H-M08 (6 OBSERVABLE,
  2 INFERRED, 0 SPECULATIVE — gate I-012 OK).

## C.6 Trazabilidad de cierre

Anclajes verificados:

- ``source/arquitectura-tecnica/modelo-dominio-iact.rst``
  v1.0.0
- ``source/arquitectura-tecnica/rbac/modelo-rbac-iact.rst``
  v5.4.0
- WP predecesor de canonización
  ``2026-05-01-02-01-06-domain-model-canonization``
- WP predecesor de correcciones
  ``2026-05-01-03-29-03-uc-corrections-against-canonical-model``
  (61 / 61 UCs corregidos)
- ADR-GOB-008 (coexistencia ACC ↔ PERM)
- BR-009 v2.0.0, BR-011 v2.0.0
- CNST-001, _002, _003, _006/007/008, _015,
  _019 v3.0.0, _020 v3.0.0, _024, _025, _030,
  _031, _032
- Programa Z: Z.1.C, Z.2 (D-01..D-11),
  Z.2.A (5 categorías Cat 1..5)

## C.7 Cierre del WP

WP ``2026-05-01-05-17-20-uc-dependency-matrix-iact``
listo para cierre por orden del ejecutor (I-011).
6 partes + conclusión completas, 0 SPECULATIVE,
todas las exit conditions de ``wp-state.md``
satisfechas.
