```yml
created_at: 2026-04-28 09:00:00
project: IACT-docs
work_package: 2026-04-28-05-28-43-source-rebuild-normativa-restricciones
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# DISCOVER — Source Rebuild: normativa/restricciones (CNST)

## Inputs analizados

| Input | Tamaño | Rol |
|-------|--------|-----|
| `temp-backup/source-2026-04-28/normativa/restricciones/` | 11 archivos CNST | Set canónico (Idea 1) |
| `temp-holding/FASE 02/base_cognitiva/normativa/restricciones/` | 8 archivos CNST | Set divergente (renumerado, conceptos reorganizados) |
| `temp-holding/FASE 02/originales/RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md` | 1135 líneas | Documento maestro consolidado (10 categorías) |
| `temp-holding/FASE 01/CNST RESTRICCIONES/ACTUALIZACION_DEL_ARBOL_SECCION_RESTRICCIONES.md` | 262 líneas | Propuesta previa de reorganización (descongelar 10 CNST a v1.1.0) |
| `temp-holding/FASE 01/CNST_05_Restriccion_Creacion_Iterativa_2_0_0.rst` | 774 líneas | v2.0.0 standalone |

## Mapeo conceptual (backup ↔ temp-holding ↔ doc maestro)

| Concepto | Backup canónico | Temp-holding | Categoría doc maestro |
|----------|-----------------|--------------|------------------------|
| Comunicaciones / no email | CNST_001 Comunicaciones_Prohibidas | CNST_001 No_Email_Sistema | Cat 1 (técnicas críticas) |
| Sesiones BD timeout | CNST_002 Gestion_Sesiones_BD | CNST_002 Sesiones_BD_Timeout | Cat 1 |
| BD IVR readonly | CNST_003 Base_Datos_Dual_Inmutable | CNST_003 BD_IVR_Readonly_ETL | Cat 4 (BD) |
| ETL ventana 6-12h | CNST_004 Actualizacion_Datos_ETL | (fusionada en TH-003) | Cat 4 |
| Alertas buzón interno | (subsumido en CNST_001) | CNST_004 Alertas_Buzon_Interno | Cat 1 |
| Seguridad DRF | CNST_005 Seguridad_DRF_Checklist | (no en TH) | Cat 2 (seguridad) |
| Antipatrones | CNST_006 Antipatrones_Arquitectura | (no en TH) | Cat 3 (arquitectura) |
| Performance SLA + reportes + throttling | CNST_007 Limites_Performance_SLA | CNST_006 Reportes + CNST_007 Throttling | Cat 6 (performance) |
| Infra deployment | CNST_008 Infraestructura_Deployment | (no en TH) | Cat 7 (infra) |
| Logging auditoría | CNST_009 Logging_Auditoria_Inmutable | CNST_008 Audit_Inmutable | Cat 9 (logging) |
| Clasificación protección datos | CNST_010 Clasificacion_Proteccion_Datos | (no en TH) | Cat 10 (privacidad) |
| RBAC + SoD + permisos temporales | CNST_012 RBAC_Flat_SoD_Permisos | CNST_005 RBAC_Flat_SoD | Cat 2 |

**Hallazgo H-1:** El backup canónico cubre el 100 % de las categorías del
documento maestro. Las CNST de temp-holding son una re-numeración + reorganización
(menos granular en algunos casos, más en otros) pero NO aportan conceptos
ausentes del backup.

**Hallazgo H-2:** El gap CNST_011 en backup es estructural — el archivo nunca
existió. CNST_012 sigue inmediatamente después de CNST_010.

## Resoluciones D-CNST

### D-CNST-1: Numeración

**Decisión:** mantener numeración del backup canónico (Idea 1 backup-as-reference)
y eliminar el gap renumerando 012 → 011. Razón: backup es la fuente canónica
declarada en la estrategia v2.0; renumerar solo el último archivo (012→011)
preserva 10 numeraciones consecutivas y solo invalida una referencia externa
(CNST_012 → CNST_011), localizada y trazable.

**Resultado:** 11 CNST consecutivos (001–011).

### D-CNST-2: CNSTs huérfanas

**Decisión:** ninguna CNST es huérfana al nivel conceptual. La aparente
divergencia con temp-holding es de granularidad/nombre, no de cobertura.
Las temp-holding CNST_004 (Alertas Buzón), CNST_006 (Reportes Rango) y
CNST_007 (Throttling) están subsumidas en backup CNST_001 / CNST_007.

**Resultado:** no se incorporan CNSTs adicionales desde temp-holding.

### D-CNST-3: v2.0.0 standalone (`CNST_05_Restriccion_Creacion_Iterativa`)

**Decisión:** descartar para este WP. El contenido es una regla del
**proceso de generación documental** (no permitir batch, hacer uno a uno),
no una restricción del **sistema IACT** (objeto de este cajón). Cabe mejor
como un procedimiento o lineamiento metodológico, no como CNST. Se difiere
a una iteración futura del WP de procedimientos / metodología.

**Resultado:** archivo NO incorporado a `source/normativa/restricciones/`.

### D-CNST-4: Llenar el gap CNST_011

**Decisión:** el gap se cierra renumerando CNST_012 → CNST_011 (D-CNST-1).
No se inventa contenido nuevo (out-of-scope per `wp-state.md`).

**Resultado:** sin acción adicional.

### D-CNST-5: Sub-categorías

**Decisión:** flat por número, consistente con `procedimientos/` (también flat).
La agrupación por dominio (comunicaciones, BD, seguridad, etc.) se expone en
el `index.rst` mediante secciones explicativas, no por subdirectorios.

**Resultado:** un único directorio `restricciones/` con los 11 archivos +
index.rst que provee la vista por dominio.

## Pre-tareas absorbidas (cumplimiento)

| Pre-tarea del wp-state | Acción ejecutada |
|------------------------|------------------|
| Lectura del documento maestro consolidado | Hecho — confirma cobertura del backup |
| Lectura de propuesta previa de reorganización | Hecho — propuesta no aplicable (cubre escenario v1.1.0 no la rebuild canónica) |
| Inspección de v2.0.0 standalone | Hecho — descartado (D-CNST-3) |
| Mapeo source ↔ temp-holding ↔ doc maestro | Tabla "Mapeo conceptual" arriba |
| Tabla de mapeo viejo→nuevo (input para WP #6) | `discover/mapeo-viejo-nuevo.md` |

## Plan de ejecución

1. Copiar 11 CNST de backup a `source/normativa/restricciones/` con
   renombrado 012→011.
2. Migrar metadata legacy (`:ID:`, `:Versión:`) al schema unificado de
   10 campos vía script.
3. Actualizar referencias internas CNST_012 → CNST_011 en el archivo
   renombrado.
4. Reescribir `index.rst` con toctree + estructura por dominio.
5. Conectar al `normativa/index.rst` padre.
6. Build limpio (0 warnings, 0 errors).
7. Tres deep-reviews paralelos.
8. Resolver hallazgos.
9. Cerrar.

## Riesgos identificados

- **R1 (heredado):** WP #6 requisitos consume CNSTs. Mitigado entregando
  mapeo viejo→nuevo en `discover/mapeo-viejo-nuevo.md`.
- **R2 (heredado):** pérdida de CNST huérfana. Mitigado: D-CNST-2 confirmó
  no hay huérfanas conceptuales.
- **R3:** referencias en otros documentos a CNST_012. Verificación: ningún
  archivo en `source/` actual referencia CNST_012 (solo el propio CNST_012
  internamente, todas resueltas en migración).
