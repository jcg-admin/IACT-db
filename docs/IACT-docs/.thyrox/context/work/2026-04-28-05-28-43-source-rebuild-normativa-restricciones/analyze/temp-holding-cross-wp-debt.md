```yml
created_at: 2026-04-28 14:19:16
project: IACT-docs
work_package: 2026-04-28-05-28-43-source-rebuild-normativa-restricciones
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Cross-WP debt — temp-holding/ contenido para CNSTs/BRs/UCs/ADRs no integrado

Análisis de los archivos prioritarios de `temp-holding/` para detectar contenido
relacionado con los 31 CNSTs atómicos (`source/normativa/restricciones/`) que aún
no fue integrado al rebuild.

## Inventario de fuentes

| # | Archivo | Líneas |
|---|---------|--------|
| 1 | `temp-holding/FASE 01/CNST RESTRICCIONES/RESTRICCIONES COMPLETAS DEL SISTEMA IACT.md` | 1118 |
| 2 | `temp-holding/FASE 01/CNST RESTRICCIONES/PROPUESTA_AMPLIACIONES_CNST_005-006.md` | 1126 |
| 3 | `temp-holding/FASE 01/CNST RESTRICCIONES/REPORTE_REVISION_CNST_COMPLETO_v1_0_0.md` | 1129 |
| 4 | `temp-holding/FASE 01/CNST RESTRICCIONES/ANALISIS_ACTUALIZACION_CNST_DEFINITIVO_v1_1_1.md` | 1499 |
| 5 | `temp-holding/FASE 01/Ingeniería de Requerimientos/ANALISIS_REGLAS_NEGOCIO_SISTEMA_COMPLETO.md` | 1898 |
| 6 | `temp-holding/RBAC/MODELO_RBAC_IACT_v5_2_1.md` | 1793 |
| 7 | `temp-holding/RBAC/MODELO_RBAC_IACT_v5.1.1.md` | 1654 |
| 8 | `temp-holding/GENERACION_DOCUMENTACION/ANALISIS_PROFUNDO_RBAC_MODULOS_IACT.md` | 1135 |
| 9 | `temp-holding/GENERACION_DOCUMENTACION/MAPA_RBAC_COMPLETO_v1_0_0.md` | 954 |
| 10 | `temp-holding/FASE 01/modulos/REFERENCIA_GLOBAL_MODULOS_IACT_v1.md` | 663 |
| 11 | `temp-holding/FASE 01/docs/backend/requisitos/restricciones_y_lineamientos.md` | 1129 |
| 12 | `temp-holding/FASE 01/Ingeniería de Requerimientos/PARTE 1 - IDENTIFICAR REGLAS DE NEGOCIO - 661ca8.md` | 3639 |
| 13 | `temp-holding/FASE 02/originales/RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md` | 1135 |
| 14 | `temp-holding/FASE 01/CNST RESTRICCIONES/ANALISIS_GAPS_CNST.md` | 462 |
| 15 | `temp-holding/FASE 01/CNST RESTRICCIONES/ACTUALIZACION_DEL_ARBOL_SECCION_RESTRICCIONES.md` | 262 |

Nota: las rutas reales tienen acento — `Ingeniería`, no `Ingenieria` como aparecía en
la lista priorizada del task.

## BRs derivadas mapeadas

Hallazgo crítico: los archivos prioritarios **no contienen catálogo de BRs propio del
dominio IACT**. Las BRs encontradas (BR_028, BR_045, BR_046, BR_052, BR_087, BR_088,
BR_089) en `ANALISIS_REGLAS_NEGOCIO_SISTEMA_COMPLETO.md` son **ejemplos pedagógicos**
del dominio "químicos" (BR_087: OSHA 1910.1200; BR_028: solicitudes >$500), NO reglas
de IACT. Ver file:line — `ANALISIS_REGLAS_NEGOCIO_SISTEMA_COMPLETO.md:238-240`,
`:619-628`. Por tanto **no hay BRs IACT verificables** en estos 15 archivos para mapear
contra los 31 CNSTs atómicos.

| BR ID | Existe en IACT | CNST atómico relacionado | Comentario |
|-------|---------------|--------------------------|------------|
| BR_028 | NO (ejemplo químicos) | n/a | Pedagógico, ANALISIS_REGLAS:619 |
| BR_045 | NO (ejemplo químicos) | n/a | Pedagógico, ANALISIS_REGLAS:687 |
| BR_046 | NO (ejemplo químicos) | n/a | Pedagógico, ANALISIS_REGLAS:713 |
| BR_052 | NO (ejemplo químicos) | n/a | Pedagógico, ANALISIS_REGLAS:732 |
| BR_087/088/089 | NO (OSHA/EPA) | n/a | Regulación externa, ANALISIS_REGLAS:238-240 |

Acción: la derivación BR→CNST queda pendiente para WP futuro de Ingeniería de
Requerimientos IACT (no este WP).

## UCs afectados por CNST

UCs IACT verificables aparecen en `RESTRICCIONES COMPLETAS DEL SISTEMA IACT.md` y en
`MODELO_RBAC_IACT_v5_2_1.md`. Mapeo a CNST atómicos del rebuild:

| UC | CNST atómico | Evidencia (file:line) |
|----|--------------|------------------------|
| UC_001 Iniciar Sesión | CNST_003, CNST_004, CNST_005, CNST_009 | RESTRICCIONES:89 |
| UC_002 Cerrar Sesión | CNST_003, CNST_004 | RESTRICCIONES:90 |
| UC_003 Recuperar Contraseña | CNST_001, CNST_002 | RESTRICCIONES:56 |
| UC_005 Gestión Sesiones | CNST_003, CNST_004, CNST_005 | RESTRICCIONES:91 |
| UC_017 Reporte Trimestral | CNST_017 (SLA <5s), CNST_018 | RESTRICCIONES:607-611 |
| UC_020 Filtros Fecha | CNST_018 (rango máx 2 años) | RESTRICCIONES:613-618 |
| UC_022 Export CSV | CNST_019, CNST_020 (60s, 100k) | RESTRICCIONES:621-624 |
| UC_023 Export Excel | CNST_019, CNST_020 (90s, 100k) | RESTRICCIONES:626-629 |
| UC_024 Export PDF | CNST_019, CNST_020 (120s, 10k) | RESTRICCIONES:631-634 |
| UC_025 Dashboard | CNST_008 (ETL window), CNST_017 | RESTRICCIONES:163, 648-653 |
| UC_030 Personalizar Dashboard | (sin CNST directo — config) | RESTRICCIONES:663-667 |
| UC_036–UC_040 Alertas | CNST_001, CNST_002 (buzón) | RESTRICCIONES:58, 675 |
| UC_037 Recibir Notificación | CNST_001, CNST_002 | RESTRICCIONES:48, 57 |
| UC_042 Precedencia permisos | CNST_029 (RBAC plano) | RESTRICCIONES:586-589 |

## Parámetros rescatables

Valores cuantitativos específicos en archivos #1 y #6 que **conviene verificar** estén
integrados a los 31 CNSTs atómicos:

| Parámetro | Valor | CNST destino | Evidencia |
|-----------|-------|--------------|-----------|
| Timeout sesión | 15 minutos exactos | CNST_005 | RESTRICCIONES:76 |
| Frecuencia ETL | 6–12 horas (no menor a 6h) | CNST_008 | RESTRICCIONES:154-155 |
| JWT access token | 15 minutos | CNST_009 | RESTRICCIONES:213 |
| JWT refresh token | 7 días, rotate+blacklist | CNST_009 | RESTRICCIONES:214-216 |
| Throttle anon | 100/hour | CNST_011 | RESTRICCIONES:225 |
| Throttle user | 10000/day | CNST_011 | RESTRICCIONES:226 |
| Throttle login | 5 intentos / 5 min / IP | CNST_011 | RESTRICCIONES:228 |
| HSTS | 31536000 s (1 año) | CNST (¿28?) | RESTRICCIONES:182 |
| SLA reporte simple | <5 s | CNST_017 | RESTRICCIONES:719 |
| SLA reporte complejo | <10 s | CNST_017 | RESTRICCIONES:720 |
| SLA análisis exploratorio | <300 s (5 min) | CNST_017 | RESTRICCIONES:721 |
| SLA GET API | <500 ms | CNST_017 | RESTRICCIONES:733 |
| SLA POST/PUT | <1 s | CNST_017 | RESTRICCIONES:734 |
| Pantalla max registros | 50 000 | CNST_014 | RESTRICCIONES:750 |
| Paginación default | 50 items | CNST_014 | RESTRICCIONES:751 |
| Export CSV/Excel max | 100 000 registros | CNST_019 | RESTRICCIONES:755-756 |
| Export PDF max | 10 000 registros | CNST_019 | RESTRICCIONES:757 |
| Rango fechas máx consulta | 2 años | CNST_018 | RESTRICCIONES:761 |
| Permisos temporales máx | 6 meses + justif. ≥20 ch | CNST_031 | RBAC v5.2.1:610, 619-620 |
| Alertas destinatarios máx | 50 por alerta | (sin CNST) | RESTRICCIONES:701 |
| Alertas evaluación | cada 5 minutos | (sin CNST) | RESTRICCIONES:702 |
| Alertas retención | 6 meses + 2 años archivado | (sin CNST) | RESTRICCIONES:704 |
| Export límites diarios por rol | BÁSICO 5, COORD 20 | CNST_020 | RESTRICCIONES:637-640 |

## Excepciones documentadas

| Excepción | Proceso | Evidencia |
|-----------|---------|-----------|
| Restricciones generales: excepciones requieren aprobación formal | Aprobación formal (sin actor especificado) | `PARTE 1 - IDENTIFICAR REGLAS DE NEGOCIO`:1055 |
| Cumplimiento "sin excepción" como cláusula default | Default rígido | `PARTE 1`:1050 |
| Permisos temporales: justificación ≥20 ch + venc. ≤6 meses | Auditado vía CNST_009; renovación = nueva justificación | RBAC v5.2.1:619-623 |
| SoD violación: validar antes de asignar | Validación bloqueante en `MOD_Access` | RESTRICCIONES:594; RBAC v5.2.1:524-603 |

Hallazgo: **no se encontró** un proceso explícito de "exception request / waiver"
estructurado (formulario, aprobador, ventana de validez) en estos 15 archivos. Lo que
existe son menciones genéricas a "aprobación formal" sin protocolo.

## Hallazgos para enriquecer los 31 CNSTs

1. **CNST_011 (Throttling)** — verificar que incluye los 3 valores específicos:
   anon 100/h, user 10k/day, login 5/5min/IP. Si falta alguno: enriquecer con cita
   `RESTRICCIONES:225-228`.

2. **CNST_019/CNST_020 (Exportaciones)** — verificar timeouts por formato (CSV 60s,
   Excel 90s, PDF 120s) y límites diarios por rol (BÁSICO 5, COORD 20). Si solo está
   "10k async" genérico, enriquecer con `RESTRICCIONES:621-640`.

3. **CNST_017 (SLA)** — verificar inclusión completa de la matriz: reportes (5s/10s/
   300s), dashboard (3s carga inicial / 2s widget), API (500ms/1s/2s). Fuente única
   `RESTRICCIONES:715-742`.

4. **CNST_031 (Permisos temporales)** — verificar inclusión de la regla operativa
   completa: justificación mínima 20 caracteres, vencimiento máximo 6 meses,
   renovación = nueva justificación, revocación automática al vencer. Fuente
   `RBAC v5.2.1:617-623`.

5. **CNST sobre alertas (¿faltante?)** — los parámetros "máx 50 destinatarios",
   "evaluación cada 5 min", "retención 6m + 2a archivado" (`RESTRICCIONES:701-704`)
   no tienen CNST atómico evidente en la lista de 31. Considerar nuevo CNST_032
   "Límites operativos de alertas" o anexarlo a CNST_001/CNST_002.

## Hallazgos para WPs futuros

1. **Catálogo BRs IACT pendiente** — no existe en estos 15 archivos. WP destino:
   nuevo `2026-XX-XX-business-rules-catalog-iact` (Stage 1 DISCOVER/REQS) que produzca
   BR_NNN reales del dominio IACT (no los ejemplos químicos). Insumo:
   `MODELO_RBAC_IACT_v5_2_1.md` (42 funciones atómicas).

2. **Tabla de UCs IACT con trazabilidad** — los UCs aparecen como referencias sueltas
   (UC_001..UC_042) sin un catálogo formal en estos archivos. WP destino:
   `2026-04-28-05-28-45-source-rebuild-requisitos` (ya existente — pasar este insumo).

3. **Excepciones / waiver process** — proceso de excepciones a CNST no existe formal.
   WP destino: `2026-04-28-05-28-44-source-rebuild-normativa-gobernanza` (gobernanza
   debería incluir un PROC_Excepciones_CNST).

4. **ADRs sobre RBAC v5.1.1 → v5.2.1** — `MODELO_RBAC_IACT_v5_2_1.md:27` documenta
   cambios v5.2.0→v5.2.1 (terminología "44 → 42 funciones", CNST gap report). Estos
   son ADRs latentes. WP destino: `decisions/` global o WP arquitectura técnica.

5. **CNST-005 / CNST-006 ampliaciones (formato legacy)** — `PROPUESTA_AMPLIACIONES_
   CNST_005-006.md` describe ampliaciones a la numeración antigua (10 CNSTs) con
   contenido válido (ExpiredPermissionsMiddleware, Service Layer pattern, Custom
   Manager). Mapeo a la numeración nueva: el contenido de "Permisos Temporales"
   (CNST-005 legacy) ya está en CNST_031; el contenido de "Patrones Recomendados"
   (CNST-006 legacy) **no tiene CNST atómico** — es contenido positivo (qué SÍ usar)
   complementario a CNST_015 (antipatrones). WP destino:
   `2026-04-28-05-28-46-source-rebuild-arquitectura-tecnica` para considerar guía de
   patrones recomendados como artefacto separado de los CNSTs.
