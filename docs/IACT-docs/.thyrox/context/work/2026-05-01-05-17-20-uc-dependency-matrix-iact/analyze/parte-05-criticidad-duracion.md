```yml
created_at: 2026-05-01 05:17:20
project: IACT-docs
work_package: 2026-05-01-05-17-20-uc-dependency-matrix-iact
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Borrador
version: 1.0.0
language: es
parte: 5 de 6
```

# PARTE 5 — Matriz de criticidad y duración

> Estimaciones de esfuerzo (person-days) por UC,
> totales por criticidad, timeline y secuencia
> de implementación derivada del grafo de
> dependencias (Partes 3 y 4). Las cifras son
> **estimaciones analíticas**, no compromisos
> contractuales — el ADR de implementación
> definirá los números finales en la fase de
> ejecución real.

## 5.1 Método de estimación

Cada UC tiene una **complejidad** y unos **días
estimados** declarados en su ficha de Parte 2.
La metodología de la estimación:

| Complejidad | Días típicos | Criterio |
|-------------|:------------:|----------|
| BAJA | 1-2 | UC con un solo flujo principal, sin flujos alternos significativos, ≤ 3 constraints citadas, ≤ 2 clases tocadas |
| MEDIA | 3-4 | UC con 1-2 flujos alternos, 3-5 constraints, hasta 4 clases, lógica de validación moderada |
| ALTA | 5-7 | UC con flujos asíncronos, transacciones distribuidas (Saga), múltiples clases, integración con servicios externos, performance crítico |

Los días incluyen: análisis, implementación,
tests unitarios, tests de integración, code
review, documentación. **No** incluyen:
testing exploratorio, deployment, training de
usuarios.

Asumido: 1 desarrollador full-time (≈ 6 horas
productivas / día). Para 2+ desarrolladores en
paralelo, los UCs paralelizables reducen el
calendario sin reducir person-days.

## 5.2 Estimación por UC y por criticidad

### 5.2.1 CRÍTICOS (8 UCs)

| UC | Complejidad | Días |
|----|-------------|-----:|
| UC_AUTH_01 — Iniciar Sesion | MEDIA | 5 |
| UC_AUTH_04 — Cambiar Contrasena | BAJA | 2 |
| UC_USR_02 — Consultar Usuarios | BAJA | 3 |
| UC_ACC_03 — Consultar Permisos | MEDIA | 3 |
| UC_PERM_07 — Verificar Permiso | ALTA | 4 |
| UC_PIP_01 — Supervisar ETL | MEDIA | 4 |
| UC_RPT_01 — Ver Dashboard | MEDIA | 5 |
| UC_AUD_01 — Consultar Auditoria | MEDIA | 3 |
| **Subtotal CRÍTICOS** | — | **29** |

### 5.2.2 ALTOS (27 UCs)

| UC | Complejidad | Días |
|----|-------------|-----:|
| UC_AUTH_02 — Cerrar Sesion | BAJA | 1 |
| UC_AUTH_05 — Gestionar Sesiones | MEDIA | 3 |
| UC_USR_01 — Crear Usuario | MEDIA | 4 |
| UC_USR_03 — Modificar Usuario | MEDIA | 3 |
| UC_USR_04 — Eliminar (Deactivate) Usuario | BAJA | 2 |
| UC_ACC_01 — Asignar Funciones | MEDIA | 4 |
| UC_ACC_02 — Revocar Funciones | BAJA | 2 |
| UC_ACC_04 — Asignar Agrupador | BAJA | 2 |
| UC_ACC_05 — Gestionar SoD | ALTA | 5 |
| UC_PERM_01 — Asignar Grupo a Usuario | BAJA | 2 |
| UC_PERM_02 — Revocar Grupo a Usuario | BAJA | 2 |
| UC_PERM_05 — Crear Grupo de Permisos | BAJA | 2 |
| UC_PERM_06 — Asignar Funciones a Grupo | MEDIA | 3 |
| UC_PERM_08 — Generar Menu Dinamico | MEDIA | 3 |
| UC_RPT_02 — Ver Metricas Tiempo Real | MEDIA | 4 |
| UC_RPT_03 — Ver Reportes Historicos | MEDIA | 4 |
| UC_RPT_04 — Exportar Reporte | ALTA | 6 |
| UC_ALR_01 — Configurar Umbrales | MEDIA | 3 |
| UC_ALR_02 — Ver Alertas Activas | BAJA | 2 |
| UC_ALR_03 — Reconocer Alerta | BAJA | 2 |
| UC_PIP_02 — Consultar Errores ETL | BAJA | 2 |
| UC_PIP_03 — Consultar Disponibilidad | BAJA | 2 |
| UC_PIP_04 — Solicitar Reintento | MEDIA | 3 |
| UC_AUD_02 — Buscar Auditoria | MEDIA | 3 |
| UC_AUD_03 — Exportar Auditoria | MEDIA | 3 |
| UC_LOG_01 — Consultar Logs Sistema | BAJA | 2 |
| UC_LOG_02 — Consultar Logs ETL | BAJA | 2 |
| **Subtotal ALTOS** | — | **75** |

### 5.2.3 MEDIOS (18 UCs)

| UC | Complejidad | Días |
|----|-------------|-----:|
| UC_AUTH_03 — Recuperar Contrasena | MEDIA | 3 |
| UC_ACC_08 — Permiso Temporal | MEDIA | 3 |
| UC_PERM_03 — Conceder Permiso Excepcional | MEDIA | 3 |
| UC_PERM_04 — Revocar Permiso Excepcional | BAJA | 1 |
| UC_RPT_07 — Programar Reporte | MEDIA | 3 |
| UC_RPT_08 — Ver Reportes Programados | BAJA | 2 |
| UC_RPT_11 — Compartir Reporte | MEDIA | 3 |
| UC_RPT_12 — Ver Reporte Agentes | BAJA | 2 |
| UC_RPT_13 — Ver Reporte Colas | BAJA | 2 |
| UC_RPT_14 — Ver Reporte Campanas | BAJA | 2 |
| UC_RPT_15 — Reporte Transferencias Centro | MEDIA | 3 |
| UC_RPT_16 — Reporte Menus IVR | MEDIA | 3 |
| UC_RPT_17 — Reporte Clientes Unicos | MEDIA | 3 |
| UC_ALR_04 — Ver Historial Alertas | BAJA | 2 |
| UC_ALR_05 — Gestionar Suscripciones | MEDIA | 4 |
| UC_AUD_04 — Generar Reporte Compliance | ALTA | 5 |
| UC_LOG_04 — Exportar Logs | MEDIA | 3 |
| UC_LOG_05 — Ver Logs Infraestructura | BAJA | 2 |
| **Subtotal MEDIOS** | — | **49** |

### 5.2.4 BAJOS (8 UCs)

| UC | Complejidad | Días |
|----|-------------|-----:|
| UC_ACC_09 — Auditar Cambios de Acceso | BAJA | 2 |
| UC_PERM_09 — Auditar Acceso | BAJA | 1 |
| UC_PERM_10 — Consultar Auditoria de Permisos | BAJA | 2 |
| UC_RPT_09 — Configurar Filtros | BAJA | 2 |
| UC_RPT_10 — Guardar Vista | BAJA | 2 |
| UC_LOG_03 — Buscar Logs | MEDIA | 3 |
| UC_LOG_06 — Ver Estado Sistema | BAJA | 2 |
| UC_LOG_07 — Ver Metricas Tecnicas | MEDIA | 3 |
| **Subtotal BAJOS** | — | **17** |

### 5.2.5 Total

| Criticidad | UCs | Person-days | % |
|------------|---:|-----------:|--:|
| CRÍTICOS | 8 | 29 | 17% |
| ALTOS | 27 | 75 | 44% |
| MEDIOS | 18 | 49 | 29% |
| BAJOS | 8 | 17 | 10% |
| **Total** | **61** | **170** | 100% |

## 5.3 Trabajo no contado por UC (overhead)

Los 170 person-days son sólo los UCs. El proyecto
real necesita además:

| Categoría | Días estimados | Notas |
|-----------|---------------:|-------|
| Modelo de datos (migraciones de BD para 25 clases) | 15 | A factorizar entre los UCs que las introducen |
| Middleware Auth + RBAC (T-01 + T-02) | 10 | Cross-cutting; soporta los 59 UCs no públicos |
| Middleware Audit Emitter (T-03) | 5 | Cross-cutting |
| Diseño de UI / componentes compartidos | 20 | Frontend reusable |
| ETL pipeline (background) | 15 | Independiente de los UCs |
| Setup de infraestructura (Vagrant + Apache + mod_wsgi + Django + MySQL + Redis per ADR-DEVOPS-001) | 8 | Una vez |
| Tests E2E + ambientes | 10 | Cross-cutting |
| Documentación + ADRs | 5 | Continuo |
| **Subtotal overhead** | **88** | |

**Total proyecto** ≈ 170 + 88 = **258
person-days** ≈ ~52 semanas-persona ≈ ~10-12
meses con 1 desarrollador, ~5-6 meses con 2,
~3-4 meses con 4.

## 5.4 Timeline propuesto por sprints

### 5.4.1 Sprint 1-2 (Setup + bootstrap RBAC)

**Objetivo**: que un usuario pueda hacer login y
ver la UI vacía. Duración: 2 sprints (≈ 4
semanas con 2 devs paralelos).

UCs:
- Bootstrap: middleware Auth, middleware RBAC,
  middleware Audit (overhead)
- UC_AUTH_01 (5d), UC_AUTH_04 (2d), UC_PERM_07
  (4d) — la trinidad del acceso

Person-days: ≈ 20-25 (incluido overhead inicial).

### 5.4.2 Sprint 3 (Pipeline + datos)

**Objetivo**: que existan datos analíticos para
mostrar. Duración: 1 sprint (≈ 2 semanas).

UCs:
- ETL pipeline (overhead)
- UC_PIP_01 (4d), UC_PIP_03 (2d)
- UC_RPT_01 mínimo (5d)

Hito: el dashboard muestra datos reales.

### 5.4.3 Sprint 4-5 (Bootstrap administración)

**Objetivo**: que un admin pueda crear / gestionar
usuarios. Duración: 2 sprints.

UCs:
- UC_USR_02 (3d), UC_USR_01 (4d), UC_USR_03 (3d),
  UC_USR_04 (2d)
- UC_ACC_03 (3d), UC_ACC_01 (4d), UC_ACC_02 (2d),
  UC_ACC_04 (2d)
- UC_AUTH_02 (1d), UC_AUTH_05 (3d), UC_AUTH_03 (3d)

Person-days: ≈ 30.

### 5.4.4 Sprint 6 (Auditoría)

**Objetivo**: compliance funcional. Duración: 1
sprint.

UCs:
- UC_AUD_01 (3d), UC_AUD_02 (3d), UC_AUD_03 (3d)
- UC_PERM_09 (1d), UC_ACC_09 (2d)

Person-days: ≈ 12.

### 5.4.5 Sprint 7-8 (RBAC avanzado y vista PERM)

**Objetivo**: completar el modelo RBAC granular.

UCs:
- UC_ACC_05 (5d), UC_ACC_08 (3d)
- UC_PERM_01 (2d), UC_PERM_02 (2d), UC_PERM_05
  (2d), UC_PERM_06 (3d)
- UC_PERM_03 (3d), UC_PERM_04 (1d), UC_PERM_08
  (3d), UC_PERM_10 (2d)

Person-days: ≈ 26.

### 5.4.6 Sprint 9-11 (Reportes)

**Objetivo**: cubrir el cluster RPT completo.

UCs:
- UC_RPT_02 (4d), UC_RPT_03 (4d), UC_RPT_04 (6d)
- UC_RPT_07 (3d), UC_RPT_08 (2d), UC_RPT_09 (2d),
  UC_RPT_10 (2d), UC_RPT_11 (3d)
- UC_RPT_12 (2d), UC_RPT_13 (2d), UC_RPT_14 (2d)
- UC_RPT_15 (3d), UC_RPT_16 (3d), UC_RPT_17 (3d)

Person-days: ≈ 41.

### 5.4.7 Sprint 12 (Alertas)

**Objetivo**: closed-loop alerting.

UCs:
- UC_ALR_01 (3d), UC_ALR_02 (2d), UC_ALR_03 (2d),
  UC_ALR_04 (2d), UC_ALR_05 (4d)

Person-days: ≈ 13.

### 5.4.8 Sprint 13 (Pipeline avanzado)

UCs:
- UC_PIP_02 (2d), UC_PIP_04 (3d)

### 5.4.9 Sprint 14 (Logs + monitoring)

UCs:
- UC_LOG_01 (2d), UC_LOG_02 (2d), UC_LOG_03 (3d),
  UC_LOG_04 (3d)
- UC_LOG_05 (2d), UC_LOG_06 (2d), UC_LOG_07 (3d)

Person-days: ≈ 17.

### 5.4.10 Sprint 15 (Compliance avanzado)

UCs:
- UC_AUD_04 (5d)

### 5.4.11 Resumen del calendario

::

   Sprint 1-2     Setup + Auth/RBAC core      4 sem (8 sem-dev)
   Sprint 3       Pipeline + Dashboard        2 sem (4 sem-dev)
   Sprint 4-5     Admin RBAC                  4 sem (8 sem-dev)
   Sprint 6       Auditoría                   2 sem (4 sem-dev)
   Sprint 7-8     RBAC avanzado / PERM        4 sem (8 sem-dev)
   Sprint 9-11    Reportes                    6 sem (12 sem-dev)
   Sprint 12      Alertas                     2 sem (4 sem-dev)
   Sprint 13      Pipeline avanzado           2 sem (4 sem-dev)
   Sprint 14      Logs + monitoring           2 sem (4 sem-dev)
   Sprint 15      Compliance avanzado         2 sem (4 sem-dev)
   ---------------------------------------------------------------
   Total          15 sprints                  30 sem (60 sem-dev)

   Con 2 devs full-time:                      ~30 semanas calendar
                                              ≈ 7 meses calendar
   Con 4 devs:                                ~15 semanas calendar
                                              ≈ 3.5 meses calendar

## 5.5 Orden de implementación derivado del grafo

Reglas de orden derivadas de Parte 3 (matriz
compacta):

1. UCs con **REQUIERE = ninguno** se pueden
   implementar primero. Son: UC_AUTH_01,
   UC_USR_02, UC_ACC_03, UC_ACC_05, UC_PERM_05,
   UC_PERM_07, UC_RPT_01 (con prereq de
   datos), UC_ALR_01, UC_PIP_01, UC_AUD_01,
   UC_LOG_01, UC_LOG_05, UC_LOG_06, UC_LOG_07.
2. **UC_PERM_07** debe estar lista antes que
   cualquier UC con T-02 — es el mayor cuello
   de botella en orden.
3. **UC_AUTH_01** antes que cualquier UC con
   T-01 — segundo cuello.
4. **UC_PIP_01** antes que cualquier UC del
   cluster RPT que dependa de datos.
5. **UC_RPT_01** antes que UC_RPT_02..17 (todos
   los hijos del cluster).
6. **UC_AUD_01** antes que UC_AUD_02, _03, _04
   y UC_PERM_09, _10, UC_ACC_09 (consumidores
   de la vista AUDIT).

## 5.6 Riesgos de estimación

- **Estimaciones optimistas**: las cifras BAJA =
  1-2 días asumen que los modelos de datos están
  listos. Si las migraciones de BD se ejecutan
  en paralelo con los UCs, pueden inflarse.
- **Cluster RPT** es el más voluminoso (15 UCs,
  41 person-days). Conviene paralelizar
  fuertemente con varios devs y refactorizar
  UC_RPT_01 como base reutilizable.
- **UC_RPT_04** (Exportar — ALTA · 6d) es el UC
  individual más caro y consume CNST-019/020
  (cola asíncrona + throttling). Asignar al
  desarrollador más senior.
- **UC_PERM_07** (verify permission — ALTA · 4d)
  con performance target < 50 ms requiere
  cache LRU + invalidación correcta. Si la
  implementación falla, todo el sistema sufre.
  Asignar prioridad alta y testing extensivo.

----

Próxima parte: Parte 6 — patrones de diseño por
UC con análisis cross-cutting de los 25
patrones que aparecen en las fichas de Parte 2.
