```yml
created_at: 2026-04-28 04:25:00
project: IACT-docs
work_package: 2026-04-28-01-58-08-source-rebuild-strategy
phase: Phase 5 — STRATEGY (análisis de soporte)
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Análisis de soporte — Divergencia de restricciones (CNST)

Análisis que respalda la **Idea 7** (CNST como input arquitectónico)
y la **Decision 7** (CNST en WP propio, reconciliación antes de
requisitos) del solution-strategy.md.

## 1. Inventario verificado

### 1.1 source/normativa/restricciones/ (12 archivos, gap en CNST_011)

```
CNST_001_Comunicaciones_Prohibidas.rst
CNST_002_Gestion_Sesiones_BD.rst
CNST_003_Base_Datos_Dual_Inmutable.rst
CNST_004_Actualizacion_Datos_ETL.rst
CNST_005_Seguridad_DRF_Checklist.rst
CNST_006_Antipatrones_Arquitectura.rst
CNST_007_Limites_Performance_SLA.rst
CNST_008_Infraestructura_Deployment.rst
CNST_009_Logging_Auditoria_Inmutable.rst
CNST_010_Clasificacion_Proteccion_Datos.rst
              (CNST_011 — GAP)
CNST_012_RBAC_Flat_SoD_Permisos.rst
```

Plus: `source/requisitos/casos_uso/restricciones.rst` (uno
adicional, no numerado, vive en otro dominio).

Plus: `source/normativa/estandares/plantillas/TPL_CNST_Restricciones_1_0_0.rst`
(template, no instancia).

### 1.2 temp-holding/.../base_cognitiva/normativa/restricciones/ (8 archivos)

Aparece en 3 ubicaciones (las 3 son copias del mismo set):
- `temp-holding/FASE 02/base_cognitiva/normativa/restricciones/`
- `temp-holding/GENERACION_DOCUMENTACION/IACT_Backup_Completo_2026-01-11-old/iact_backup_20260111_085043/base_cognitiva/cnst/`
- `temp-holding/GENERACION_DOCUMENTACION/TMP_COMPLETO_2026-01-13_OK/tmp/iact_backup_20260111_085043/base_cognitiva/cnst/`

Contenido (ordenado por número):

```
CNST_001_No_Email_Sistema_1_0_0.rst
CNST_002_Sesiones_BD_Timeout_1_0_0.rst
CNST_003_BD_IVR_Readonly_ETL_1_0_0.rst
CNST_004_Alertas_Buzon_Interno_1_0_0.rst
CNST_005_RBAC_Flat_SoD_Permisos_1_0_0.rst
CNST_006_Reportes_Limites_Rango_1_0_0.rst
CNST_007_Limites_Exportacion_Throttling_1_0_0.rst
CNST_008_Audit_Inmutable_Logs_PII_1_0_0.rst
```

### 1.3 Otras CNSTs sueltas en temp-holding/

- `temp-holding/FASE 01/CNST_05_Restriccion_Creacion_Iterativa_2_0_0.rst`
  — versión **2.0.0** standalone. Naming distinto (`CNST_05`, no
  `CNST_005`). Posible iteración avanzada de un CNST específico.

### 1.4 Documentos maestros consolidados

| Documento | Ubicación | Estado |
|-----------|-----------|--------|
| `RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md` | `temp-holding/FASE 02/originales/` | Documento canónico (nombre indica completitud) |
| `RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md` | `temp-holding/.../IACT_Backup_Completo_2026-01-11-old/.../uploads/` | Copia de backup |
| `RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md` | `temp-holding/.../TMP_COMPLETO_2026-01-13_OK/tmp/.../uploads/` | Copia de backup |
| `ACTUALIZACION_DEL_ARBOL_SECCION_RESTRICCIONES.md` | `temp-holding/FASE 01/CNST RESTRICCIONES/` | Propuesta de reorganización del árbol |

## 2. Mapeo de divergencia source vs temp-holding

| ID | source/ | temp-holding | ¿Mismo concepto? |
|----|---------|--------------|------------------|
| CNST_001 | Comunicaciones_Prohibidas | No_Email_Sistema | **Posiblemente sí** (email es una comunicación prohibida) |
| CNST_002 | Gestion_Sesiones_BD | Sesiones_BD_Timeout | **Posiblemente sí** (timeout es parte de gestión de sesiones) |
| CNST_003 | Base_Datos_Dual_Inmutable | BD_IVR_Readonly_ETL | **Parcialmente** (ambos sobre BD readonly/inmutable, distinto contexto) |
| CNST_004 | Actualizacion_Datos_ETL | Alertas_Buzon_Interno | **NO** — conceptos completamente distintos |
| CNST_005 | Seguridad_DRF_Checklist | RBAC_Flat_SoD_Permisos | **NO** — DRF security ≠ RBAC SoD |
| CNST_006 | Antipatrones_Arquitectura | Reportes_Limites_Rango | **NO** |
| CNST_007 | Limites_Performance_SLA | Limites_Exportacion_Throttling | **NO** — ambos sobre límites pero dominios distintos |
| CNST_008 | Infraestructura_Deployment | Audit_Inmutable_Logs_PII | **NO** |
| CNST_009 | Logging_Auditoria_Inmutable | (no presente) | source-only |
| CNST_010 | Clasificacion_Proteccion_Datos | (no presente) | source-only |
| CNST_011 | GAP | (no presente) | gap real |
| CNST_012 | RBAC_Flat_SoD_Permisos | (= temp-holding CNST_005) | **Renumeración inversa** |

**Patrón observado:** la versión de source/ parece haber re-numerado
y expandido las CNSTs respecto a la versión de temp-holding/. Hay
solapamientos (CNST_005 source = CNST_012 source = CNST_005
temp-holding) y conceptos huérfanos en cada lado.

## 3. Hallazgo crítico — caos de IDs

**Mismo ID = concepto distinto** entre source/ y temp-holding/. Esto
significa:

- Cualquier referencia textual a "CNST_005" es **ambigua** sin
  especificar el origen.
- Si un UC en source/ dice "respeta CNST_005", se refiere a
  Seguridad_DRF_Checklist. Si el UC vino del temp-holding/, podría
  haberse referido a RBAC_Flat_SoD_Permisos.
- Las refs cruzadas en `requisitos/` que apunten a CNST por número
  pueden estar **silenciosamente equivocadas** ahora mismo.

## 4. Strategy para el WP `normativa/restricciones`

### 4.1 Discover obligatorio

1. Leer `RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md` completo —
   es el documento maestro consolidado.
2. Leer `ACTUALIZACION_DEL_ARBOL_SECCION_RESTRICCIONES.md` para
   conocer la propuesta previa de reorganización.
3. Inspeccionar `CNST_05_Restriccion_Creacion_Iterativa_2_0_0.rst`
   para entender qué representa la v2.0.0 standalone.
4. Mapear cada CNST de source/ y de temp-holding/ contra el
   documento maestro — cuáles están cubiertas, cuáles son únicas
   de cada lado.

### 4.2 Decisiones a tomar en ese WP

- **D-CNST-1:** ¿Numeración nueva consistente, o respetar la de
  source/?
- **D-CNST-2:** ¿Cómo se manejan las CNSTs huérfanas (presentes
  en uno solo de los lados)? ¿Se incorporan, se descartan, se
  fusionan?
- **D-CNST-3:** ¿Qué hacer con `CNST_05_Restriccion_Creacion_
  Iterativa_2_0_0.rst` v2.0.0?
- **D-CNST-4:** Llenar el gap CNST_011 — ¿con qué contenido?
- **D-CNST-5:** Sub-categorías (seguridad, performance, datos,
  infra) — ¿se mantienen flat por número o se agrupan?

### 4.3 Pre-condición de apertura del WP `requisitos`

- WP `normativa/restricciones` cerrado y aprobado.
- Todas las CNSTs renumeradas finalmente (sin gaps, sin solapes).
- Documentación de mapeo: "CNST_005 antiguo source = CNST_NN
  nuevo" para que las refs en requisitos puedan migrarse.
- Los UCs que se reescriben en `requisitos` consumen las CNSTs
  finales, no las antiguas.

## 5. Riesgos identificados

| Riesgo | Impacto | Mitigación |
|--------|---------|------------|
| Reconciliación falla y se incorpora numeración con gaps/solapes | Confusión permanente en refs | Validación final: numeración consecutiva sin gaps |
| Se pierde alguna CNST porque está solo en una de las fuentes | Restricción olvidada → diseño viola constraint sin saberlo | Documento maestro consolidado como árbitro; mapeo exhaustivo |
| `requisitos` se rebuilda con CNSTs viejas porque el WP se abre antes de cerrar restricciones | UCs/FRs hacen referencia a CNSTs que cambiaron de número/concepto | Decision 7: el WP `restricciones` cierra antes de abrir `requisitos`. Hard dependency. |
| `CNST_05_v2_0_0` standalone se ignora porque no está en el set principal | Se pierde una iteración avanzada que pudo ser canónica | Inspeccionarlo en el discover del WP `restricciones` antes de descartar |
