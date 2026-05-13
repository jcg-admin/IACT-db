# Análisis de completitud — post-ejecución FASES 1-4

**Versión:** 1.0.0  
**Fecha:** 2026-05-13  
**Baseline:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Alcance:** auditoría del repositorio `IACT-db` tras completar las 4 fases del
plan de corrección derivado de `HALLAZGOS-ANALISIS-COMPARATIVO-SQL-SERVER-IACT-DB.md`

---

## Estado del plan de corrección

| Hallazgo | Severidad | FASE | Estado |
|---|---|---|---|
| H-IACT-001: WHILE O(n) en funciones de calendario | MEDIA-ALTA | 4 | RESUELTO |
| H-IACT-002: funciones WHILE por fila en `sp_rpt_centros_xsegmento` | ALTA | 2 | RESUELTO |
| H-IACT-003: subconsulta correlacionada en `sp_rpt_centros_transferencia` | MEDIA | 2 | RESUELTO |
| H-IACT-004: DELETE + INSERT sin transacción | BAJA | 3 | RESUELTO |
| H-IACT-005: PASO 5 ejecuta cuando PASO 4 falla | BAJA-MEDIA | 1 | RESUELTO |
| H-IACT-006: PREPARE dentro del WHILE | MUY BAJA | 1 | RESUELTO |

Todos los hallazgos del plan están resueltos. No quedan hallazgos pendientes.

---

## Dimensiones auditadas

### 1. Archivos SQL individuales (20 objetos)

| Dimensión | Resultado |
|---|---|
| Total archivos | 20 (7 funciones + 12 SPs + 1 event) |
| Bundles eliminados (`funciones_utilidad.sql`, `sp_etl_pipeline.sql`, `sp_rpt_reportes.sql`) | Confirmado eliminados |
| Referencias a bundles en `Prerequisito` | 0 ocurrencias |
| Objetos CREATE por archivo | 1 en cada archivo |
| Campos `Version` y `Prerequisito` presentes | 20 / 20 |
| Problemas de código | 0 |

Versiones finales por objeto:

| Objeto | Versión | FASE que lo modificó |
|---|---|---|
| `ivr_contar_dias_semana` | 3.0.0 | FASE 4 |
| `ivr_agregar_dias_semana` | 3.0.0 | FASE 4 |
| `sp_etl_base_detalle` | 2.2.0 | FASE 1 (PREPARE), FASE 3 (TX) |
| `sp_etl_maestro` | 2.2.0 | FASE 1 (`v_detalle_cargado`) |
| `sp_rpt_centros_xsegmento` | 2.1.0 | FASE 2 (3 CTEs) |
| `sp_rpt_centros_transferencia` | 2.1.0 | FASE 2 (JOIN pre-agregado) |
| Resto de objetos | 2.0.0 | No modificados |

### 2. Dependencias entre objetos

`ivr_contar_dias_semana` v3.0.0 y `ivr_agregar_dias_semana` v3.0.0 ya no dependen
de `ivr_es_dia_semana`. La mención de `ivr_es_dia_semana` en sus archivos aparece
únicamente en el campo `Prerequisito` (documentando la eliminación de la dependencia)
y en el string `COMMENT` del objeto — no en el cuerpo de la función.

`ivr_es_dia_semana` sigue siendo utilizada correctamente por `sp_etl_base_detalle`
para pre-computar `llamadas_entre_semana` en el ETL.

### 3. Scripts de despliegue y verificación

`provision-mariadb.sh`: sin referencias a bundles, 24 referencias a `objetos/`,
despliega los 20 archivos en orden explícito de dependencias.

`verify.sh`: funciona correctamente (27 OK). Cuatro comentarios de sección
mencionaban los bundles eliminados — corregidos en esta auditoría.

### 4. Cobertura de documentación de hallazgos

| Documento | Versión | H-IACT cubiertos |
|---|---|---|
| `HALLAZGOS-ANALISIS-COMPARATIVO-SQL-SERVER-IACT-DB.md` | 1.0.0 | 001-006 (análisis) |
| `PLAN-IMPL-HALLAZGOS-SQL-SERVER-IACT-DB.md` | 1.0.0 | 001-006 (plan) |
| `HALLAZGOS-FASE1-IMPL-HALLAZGOS-SQL-SERVER.md` | 2.0.0 | H-IACT-005, H-IACT-006 |
| `HALLAZGOS-FASE2-IMPL-HALLAZGOS-SQL-SERVER.md` | 1.0.0 | H-IACT-002, H-IACT-003 |
| `HALLAZGOS-FASE3-IMPL-HALLAZGOS-SQL-SERVER.md` | 1.0.0 | H-IACT-004 |
| `HALLAZGOS-FASE4-IMPL-HALLAZGOS-SQL-SERVER.md` | 1.0.0 | H-IACT-001 |

Cobertura: 6/6 hallazgos con documento de ejecución. Cada documento incluye
los hallazgos adicionales encontrados durante la implementación (H-F1-001 a H-F4-004).

### 5. Catálogo de objetos (docs/architecture/catalogo/)

6 archivos del catálogo tenían el campo `Archivo fuente` apuntando a bundles eliminados
y versiones desactualizadas. Corregidos en esta auditoría:

| Archivo | Corrección aplicada |
|---|---|
| `catalogo/funciones/ivr_contar_dias_semana.md` | Fuente → `objetos/funciones/...` · Versión 3.0.0 |
| `catalogo/funciones/ivr_agregar_dias_semana.md` | Fuente → `objetos/funciones/...` · Versión 3.0.0 |
| `catalogo/sps/sp_etl_base_detalle.md` | Fuente → `objetos/sps/...` · Versión 2.2.0 |
| `catalogo/sps/sp_etl_maestro.md` | Fuente → `objetos/sps/...` · Versión 2.0.0 → 2.2.0 |
| `catalogo/sps/sp_rpt_centros_xsegmento.md` | Fuente → `objetos/sps/...` · Versión 2.1.0 |
| `catalogo/sps/sp_rpt_centros_transferencia.md` | Fuente → `objetos/sps/...` · Versión 2.1.0 |

---

## Hallazgos de la auditoría

### AU-001 — verify.sh tenía 4 comentarios con nombres de bundles eliminados

**Severidad:** Baja — los comentarios no afectan el comportamiento del script  
**Estado:** RESUELTO en este commit

Los comentarios de sección en `verify.sh` decían "Funciones de utilidad
(funciones_utilidad.sql)" y "SPs ETL (sp_etl_pipeline.sql)". Corregidos a
"Funciones de utilidad (objetos/funciones/)" y "SPs ETL (objetos/sps/sp_etl_*.sql)".

### AU-002 — 6 catálogos con campo `Archivo fuente` apuntando a bundles eliminados

**Severidad:** Media — un desarrollador que intente localizar el archivo fuente
desde el catálogo obtendría "archivo no encontrado"  
**Estado:** RESUELTO en este commit

### AU-003 (falsa alarma) — `ivr_contar_dias_semana.sql` y `ivr_agregar_dias_semana.sql` mencionan `ivr_es_dia_semana`

La búsqueda de texto plano detectó el nombre `ivr_es_dia_semana` en ambos archivos.
Al inspeccionar el contenido, las menciones son exclusivamente en:
- El campo `Prerequisito` del encabezado (documentando que v3.0.0 elimina la dependencia)
- El string `COMMENT` del objeto (`'O(1) — sin WHILE ni ivr_es_dia_semana'`)

El cuerpo de las funciones no contiene ninguna referencia ni llamada a `ivr_es_dia_semana`.
Las funciones son independientes. No requiere acción.

---

## Verificación final

```
Archivos SQL: 20 / 20 OK
  0 problemas de código
  0 referencias a bundles en Prerequisito
  20/20 con Version y Prerequisito
  20/20 con exactamente 1 objeto CREATE

Scripts:
  provision-mariadb.sh: sin referencias a bundles — OK
  verify.sh:            sin referencias a bundles — OK (4 comentarios corregidos)

Documentación:
  Catálogos:  6/6 actualizados con rutas y versiones correctas
  Hallazgos:  6/6 H-IACT con documento de ejecución

verify.sh: 27 OK, 0 WARN, 0 ERR, EXIT 0
```

---

## Deuda técnica pendiente

**Ninguna.** Todos los hallazgos del plan están resueltos y la auditoría no encontró
problemas de código adicionales. Los hallazgos AU-001 y AU-002 (documentales) quedan
resueltos en este mismo commit.
