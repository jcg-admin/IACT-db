# Análisis profundo de inconsistencias documentales

**Fecha:** 2026-05-11  
**Propósito:** Identificar exactamente qué necesita actualizarse en FASE 7,  
documento por documento, sección por sección.

---

## TIPO DE INCONSISTENCIAS ENCONTRADAS

Se encontraron 3 tipos distintos, ordenados por gravedad:

**TIPO 1 — Tabla correcta, cuerpo contradictorio:** El campo `**Estado:**` en el
cuerpo fue actualizado a RESUELTO, pero la subsección `### Corrección requerida`
sigue presente describiendo un fix que ya fue implementado. Un lector del cuerpo
cree que la corrección sigue pendiente.

**TIPO 2 — Tabla y cuerpo desactualizados:** Tanto la tabla como el cuerpo dicen
PENDIENTE, pero el código ya tiene la corrección implementada.

**TIPO 3 — Cifras de baseline desactualizadas:** El documento dice "verify.sh: 26 OK"
cuando el baseline actual es 27 OK.

---

## DOCUMENTO 1 — HALLAZGOS-SEGURIDAD-MARIADB-202605101700.md

**Tipo:** TIPO 1 (tabla correcta, cuerpo contradictorio)

| Hallazgo | Tabla | Cuerpo Estado | Problema |
|---|---|---|---|
| H-SEC-002 | RESUELTO | RESUELTO | Subsección `### Corrección requerida` describe el fix como pendiente |
| H-SEC-003 | DOCUMENTADO | DOCUMENTADO | Subsección `### Corrección requerida` propone un ALTER USER como pendiente |
| H-SEC-004 | RESUELTO | RESUELTO | Subsección `### Corrección requerida` pide agregar PREREQUISITOS — ya están en L47-56 |

**Verificación del código:**
- H-SEC-002: schema_historico.sh L127-135 tiene auto-detección de socket y fallback `${MARIADB_SOCK:-}`
- H-SEC-003: el ALTER USER ya lo ejecutó `_secure_mariadb()` en entornos aprovisionados
- H-SEC-004: schema_historico.sh L47-56 tiene sección PREREQUISITOS completa

**Qué actualizar:**
Renombrar `### Corrección requerida` → `### Corrección implementada` en H-SEC-002 y H-SEC-004.
Para H-SEC-003: la sección describe el estado de un entorno no aprovisionado correctamente,
ya es histórica — agregar nota de que en entornos aprovisionados via config.sh esto no ocurre.

---

## DOCUMENTO 2 — HALLAZGOS-FASE3-202605101800.md

**Tipo:** TIPO 2 (tabla y cuerpo desactualizados) para H-F3-003 y H-F3-004.
TIPO 1 para la subsección de corrección de H-F3-003.

| Hallazgo | Estado en tabla | Estado en cuerpo | Estado real en código |
|---|---|---|---|
| H-F3-003 | PENDIENTE | PENDIENTE | RESUELTO — seed_historico.sql ejecutado sin ERROR 1308 |
| H-F3-004 | PENDIENTE | PENDIENTE | RESUELTO — log_fatal tiene exit 1 (FASE 4, commit 4ded8ab) |
| H-F3-001, H-F3-002 | RESUELTO | RESUELTO | Correctos |
| H-F3-005 | DOCUMENTADO | DOCUMENTADO | Correcto |

**Verificación del código:**
- H-F3-003: seed_historico.sql L137 `sp_seed_historico: BEGIN` + L454 `END sp_seed_historico$$`. Sin LEAVE/LOOP/ITERATE internos. Ejecutado en BD: tablas recibieron datos sin ERROR 1308.
- H-F3-004: utils/logging.sh — `log_fatal()` tiene `log_message ... ; exit 1`

**Sección adicional a corregir:**
Al final del documento hay `## Próximos pasos requeridos` que dice:
- "Investigar y confirmar H-F3-004 (comportamiento de `log_fatal`)" → HECHO
- "Corregir H-F3-003 (DELIMITER/pipe issue en `seed_historico.sql`)" → HECHO

Esa sección debe actualizarse para reflejar que ambos están resueltos.

---

## DOCUMENTO 3 — HALLAZGOS-FASE4-202605101830.md

**Tipo:** TIPO 2 para H-F4-003.

| Hallazgo | Estado en tabla | Estado real |
|---|---|---|
| H-F4-003 | PENDIENTE evaluación | RESUELTO — verify.sh reordenado (FASE 4, commit 4ded8ab): históricas al final |

**Verificación:** verify.sh orden actual: analíticas L205 → funciones L229 → SPs L258
→ GRANT L284 → históricas L312. El reordenamiento fue la corrección de H-VFY-001.

---

## DOCUMENTO 4 — HALLAZGOS-FASE5-202605101900.md

**Tipo:** TIPO 2 para H-F5-001, H-F5-002 / TIPO 1 subsección.

| Hallazgo | Estado en tabla | Estado real |
|---|---|---|
| H-F5-001 | PENDIENTE | PENDIENTE legítimo — la corrección de log NO fue implementada en el código |
| H-F5-002 | PENDIENTE (bloqueado H-F3-003) | Bloqueante resuelto — H-F3-003 está corregido |
| H-F5-003 | PENDIENTE evaluación | Decisión de diseño — no hay código que corregir |

**Detalle H-F5-001:**
La `### Corrección requerida` pide cambiar los mensajes de log en schema_seed.sh y schema_historico.sh:
- schema_seed.sh L115: `"Tabla ya tiene ${count} registros — seed omitido (idempotente)"` — sin nombre de componente
- schema_historico.sh L451: `"SKIP_SEED=1 — seed omitido."` — sin nombre de componente

Estas correcciones específicas NO fueron implementadas. H-F5-001 sigue siendo legítimamente PENDIENTE.
Sin embargo, dado que es MEDIA severidad y es solo un mensaje de log, puede ser DOCUMENTADO
si el equipo decide no implementarlo.

**Detalle H-F5-002:**
El bloqueante (H-F3-003) está resuelto. H-F5-002 puede cambiar de
"PENDIENTE (bloqueado por H-F3-003)" a RESUELTO, ya que la verificación
del seed es posible — `verificar_seed_completo()` ya existe en schema_historico.sh.

---

## DOCUMENTO 5 — HALLAZGOS-FASE0-SEED-202605102010.md

**Tipo:** TIPO 2 para H-F0-002 (estado ambiental superado).

| Hallazgo | Estado en documento | Estado real |
|---|---|---|
| H-F0-002 | PENDIENTE evaluación | SUPERADO — seed_executions y tbl_historico tienen datos consistentes |

**Verificación:** seed_executions registra filas_antes > 0 (APPEND) en todas las ejecuciones
recientes. tbl_historico_t1_2025: 86098 filas. La inconsistencia era del ambiente de aquella
sesión, no del código.

**Acción:** Cambiar a DOCUMENTADO con nota de que era un estado transitorio del ambiente.

---

## DOCUMENTO 6 — HALLAZGOS-FASE1-SEED-202605102015.md

**Tipo:** TIPO 2 para H-F1-004 y H-F1-005 / TIPO 1 para la subsección de corrección.

| Hallazgo | Estado en tabla/cuerpo | Estado real en código |
|---|---|---|
| H-F1-004 | PENDIENTE | RESUELTO — seed_historico.sql L85: `IF(@SCRIPT_VER IS NULL OR @SCRIPT_VER = '', '3.0.0', @SCRIPT_VER)` — usa valor inyectado, no lo sobreescribe |
| H-F1-005 | PENDIENTE | RESUELTO — schema_historico.sh L166: `SCRIPT_VERSION="2.4.0"` · L229: `echo "SET @SCRIPT_VER = '${SCRIPT_VERSION}'"` inyectado |

**Nota para H-F1-004:** La `### Corrección requerida` pedía hacer el @SCRIPT_VER condicional.
El código actual en seed_historico.sql L85 hace exactamente eso con el patrón `IF(@SCRIPT_VER IS NULL ...)`.
La corrección fue implementada pero el documento no fue actualizado.

**Nota para H-F1-005:** El documento reportaba `script_version` reportando `2.0.0`.
El código actual inyecta `SCRIPT_VERSION="2.4.0"` correctamente. El problema era de la versión
en uso en aquella sesión, ya no aplica.

---

## DOCUMENTO 7 — HALLAZGOS-PROVISIONAMIENTO-202605101945.md

**Tipo:** TIPO 2 para H-PROV-003 / TIPO 1 para subsección / TIPO 3 baseline.

| Hallazgo | Estado en tabla/cuerpo | Estado real |
|---|---|---|
| H-PROV-001 | DOCUMENTADO | Correcto — limitación estructural del ambiente |
| H-PROV-002 | DOCUMENTADO | Correcto |
| H-PROV-003 | PENDIENTE | RESUELTO — H-F3-003 (bloqueante) está resuelto en el código |

**"Corrección requerida en start.sh" (H-PROV-001, L102-117):**
El código ya implementa exactamente lo que pedía la corrección:
- start.sh L61-67: `sleep 2; if mariadb_is_running; then ...` tras arranque via `service`
Esta sección debe renombrarse a `### Corrección implementada`.

**"Corrección requerida" de H-PROV-003 (L198):** hace referencia a H-F3-003 para la solución.
Ya que H-F3-003 está resuelto, esta sección debe actualizarse.

**Baseline desactualizado:**
- L24: `| verify.sh final | **26 OK, 0 WARN, 0 ERR** | EXIT 0 |`
- L213: `verify.sh: 26 OK, 0 WARN, 0 ERR, EXIT 0`

Estas cifras corresponden al ambiente de aquella sesión (antes de FASE 4 que añadió
verificaciones). El baseline actual es 27 OK. Agregar nota de que el número cambió.

---

## DOCUMENTO 8 — HALLAZGOS-JOB-ETL-SIMULACION-202605102245.md

**Tipo:** TIPO 2 para H-JOB-005.

| Hallazgo | Estado en tabla | Estado real |
|---|---|---|
| H-JOB-005 | PENDIENTE | RESUELTO — config/mariadb/99-iact.cnf tiene `event_scheduler = ON` · BD confirma ON |

---

## DOCUMENTO 9 — HALLAZGOS-PAQUETES-SISTEMA-202605112345.md

**Tipo:** TIPO 2 para H-PKG-003.

| Hallazgo | Estado en tabla/cuerpo | Estado real |
|---|---|---|
| H-PKG-003 | PENDIENTE DECISIÓN | RESUELTO — decisión Opción A documentada en bootstrap.sh · commit a4bcf36 |

---

## DOCUMENTO 10 — HALLAZGOS-SEPARACION-RESPONSABILIDADES-202605112350.md

**Tipo:** TIPO 1 especial — el mismo hallazgo aparece DOS VECES con estados distintos.

| Hallazgo | Ubicación | Estado |
|---|---|---|
| H-ARCH-003 | L19-21 (primera sección) | RESUELTO — commit 21eb26e |
| H-ARCH-003 | L210-212 (segunda sección) | DOCUMENTADO — requiere decisión de refactoring |
| H-ARCH-003 | Tabla (L362) | PENDIENTE DECISIÓN |

**Causa:** El documento fue editado en dos sesiones distintas sin unificar el estado.
La primera sección documenta un commit específico. La segunda re-analiza si la decisión
es correcta. La tabla nunca fue actualizada.

**Estado real:** La decisión fue tomada en FASE 6 (commit a4bcf36): Opción A,
install.sh mezcla instalación con config del SO — patrón válido para el proyecto actual.

---

## DOCUMENTO 11 — ANALISIS-ALTERNATIVA-E-202605112358.md

**Tipo:** TIPO 2 — tabla desactualizada (documento pre-implementación).

| Hallazgo | Estado en tabla | Estado real |
|---|---|---|
| H-INST-001 | PENDIENTE | RESUELTO — FASE 1 + FASE 2 |
| H-INST-002 | PENDIENTE | RESUELTO — FASE 2 |
| H-INST-003 | PENDIENTE | RESUELTO — FASE 1 + FASE 2 |

**Contexto:** Este documento fue escrito ANTES de ejecutar las FASES. La tabla
al final resume el estado previo a la implementación. Necesita una sección de
cierre con el estado post-implementación.

---

## DOCUMENTO 12 — GRAFO-DEPENDENCIAS-SIMULACION-ETL-202605102230.md

**Tipo:** TIPO 2 para H-SIM-005.

| Hallazgo | Estado en tabla | Estado real |
|---|---|---|
| H-SIM-005 | PENDIENTE | RESUELTO — config/mariadb/99-iact.cnf tiene `event_scheduler = ON` |
| H-SIM-006 | PENDIENTE | Fuera del scope de IACT-db (Django DRF) — DOCUMENTADO |

---

## DOCUMENTO 13 — PLAN-ALTERNATIVA-E-CONSOLIDADO-202605120030.md

**Tipo:** Falta columna de estado de ejecución en el resumen ejecutivo.

El plan no tiene una columna "Estado" por FASE. El resumen ejecutivo describe
QUÉ hace cada FASE pero no si fue ejecutada. Para cierre del proyecto, agregar
columna "Commit" o "Estado":

| FASE | Estado | Commit |
|---|---|---|
| FASE 1 | COMPLETO | f4a9e98 |
| FASE 2 | COMPLETO | 8384bab |
| FASE 3 | COMPLETO | bb44944 |
| FASE 4 | COMPLETO | 4ded8ab + cb5c04a |
| FASE 5 | COMPLETO | 5a48040 |
| FASE 6 | COMPLETO | a4bcf36 |
| FASE 7 | EN PROGRESO | — |

**Baseline final:** Ya corregido a "27 OK (H-F4-002: la proyección de ≥28 era incorrecta)".

---

## DOCUMENTO 14 — PLAN-DEUDA-CERO-202605102315.md

Las tareas T-6.1..T-6.6 (cierre documental) están enumeradas en el plan pero
no tienen marcadores de estado. Para el cierre del proyecto, registrar que
estas tareas fueron ejecutadas en FASE 7.

---

## RESUMEN: DOCUMENTOS A ACTUALIZAR EN FASE 7

| Documento | Tipo | Hallazgos afectados | Prioridad |
|---|---|---|---|
| HALLAZGOS-FASE3-202605101800 | TIPO 2 | H-F3-003, H-F3-004 + sección "Próximos pasos" | ALTA |
| ANALISIS-ALTERNATIVA-E-202605112358 | TIPO 2 | H-INST-001, H-INST-002, H-INST-003 | ALTA |
| HALLAZGOS-PAQUETES-SISTEMA | TIPO 2 | H-PKG-003 | ALTA |
| HALLAZGOS-JOB-ETL-SIMULACION | TIPO 2 | H-JOB-005 | ALTA |
| HALLAZGOS-SEPARACION-RESPONSABILIDADES | TIPO 1 especial | H-ARCH-003 (triple estado) | ALTA |
| HALLAZGOS-SEGURIDAD-MARIADB | TIPO 1 | H-SEC-002, H-SEC-003, H-SEC-004 | MEDIA |
| HALLAZGOS-FASE4-202605101830 | TIPO 2 | H-F4-003 | MEDIA |
| HALLAZGOS-FASE5-202605101900 | TIPO 2 | H-F5-001 (legítimo), H-F5-002 (desbloqueado) | MEDIA |
| HALLAZGOS-FASE0-SEED | TIPO 2 | H-F0-002 (superado) | MEDIA |
| HALLAZGOS-FASE1-SEED | TIPO 2 | H-F1-004, H-F1-005 | MEDIA |
| HALLAZGOS-PROVISIONAMIENTO | TIPO 1 + TIPO 3 | H-PROV-003 + baseline 26→27 | MEDIA |
| GRAFO-DEPENDENCIAS-SIMULACION | TIPO 2 | H-SIM-005, H-SIM-006 | BAJA |
| PLAN-ALTERNATIVA-E-CONSOLIDADO | Falta estado | Agregar columna Estado/Commit | BAJA |
| PLAN-DEUDA-CERO | Falta estado | T-6.1..T-6.6 sin marcador | BAJA |

---

## HALLAZGO QUE SIGUE ABIERTO (no resuelto en el código)

**H-F5-001** — Mensajes de log sin nombre de componente en schema_seed.sh y schema_historico.sh.

La `### Corrección requerida` específica:
- schema_seed.sh: agregar "schema_seed:" al mensaje "seed omitido (idempotente)"
- schema_historico.sh: agregar "schema_historico:" al mensaje "SKIP_SEED=1 — seed omitido"

El código actual NO implementó esto. Es severidad MEDIA. El equipo debe decidir:
- Implementarlo como tarea de FASE 7 (requiere código + commit)
- O marcarlo DOCUMENTADO aceptando la ambigüedad de log como tolerable
