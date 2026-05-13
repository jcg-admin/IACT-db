---
id: MAPEO-MIGRACION-SESIONES-012-001
tipo: mapeo
dominio: infraestructura
tema: reorganizacion
fecha: 2025-11-18
estado: completado
tags: [sesiones, migracion, nomenclatura]
---

# Mapeo de Migración - Nomenclatura Estándar de Sesiones

## Resumen

Este documento proporciona un mapeo completo de cómo renombrar y reorganizar sesiones existentes según la nomenclatura estándar YYYY-MM-DD-tema-descripcion.md.

**Total de sesiones a migrar:** 45+
**Criterios aplicados:** Fecha ISO 8601, tema singular, descripción corta

---

## 1. Migración de Backend (3 archivos)

### Fuente: `/docs/backend/sesiones/2025-11-11/`

| Archivo Actual | Fecha | Tema | Nombre Propuesto | Ubicación Nueva | Estado |
|---|---|---|---|---|---|
| `analisis_arquitectura_2025-11-11.md` | 2025-11-11 | analisis | `2025-11-11-analisis-arquitectura-backend.md` | `backend/sesiones/2025/2025-11/` | Pendiente |
| `analisis_cobertura_requisitos.md` | 2025-11-11 | validacion | `2025-11-11-validacion-cobertura-requisitos.md` | `backend/sesiones/2025/2025-11/` | Pendiente |
| `requirements_session_summary.md` | 2025-11-11 | reporte | `2025-11-11-reporte-requirements-summary.md` | `backend/sesiones/2025/2025-11/` | Pendiente |

**Cambios estructurales:**
- Mover de: `sesiones/2025-11-11/`
- Hacia: `sesiones/2025/2025-11/`
- Agregar: Frontmatter YAML con id, tipo, dominio, tema, fecha

**Frontmatter a agregar:**
```yaml
---
id: SESION-BACKEND-2025-11-11-001
tipo: sesion
dominio: backend
tema: analisis
fecha: 2025-11-11
estado: completada
tags: [backend, arquitectura, sesiones]
---
```

---

## 2. Migración de Gobernanza - Archivos Raíz (6 archivos)

### Fuente: `/docs/gobernanza/sesiones/` (raíz)

#### Grupo 1: Consolidación y Estrategia

| Archivo Actual | Fecha Inferida | Tema | Nombre Propuesto | Ubicación Nueva |
|---|---|---|---|---|
| `CONSOLIDATION_STATUS.md` | 2025-11-18 | consolidacion | `2025-11-18-consolidacion-status.md` | `gobernanza/sesiones/2025/2025-11/` |
| `PLAN_CONSOLIDACION_PRS.md` | 2025-11-15 | plan | `2025-11-15-plan-consolidacion-prs.md` | `gobernanza/sesiones/2025/2025-11/` |

#### Grupo 2: Decisiones y Pull Requests

| Archivo Actual | Fecha Inferida | Tema | Nombre Propuesto | Ubicación Nueva |
|---|---|---|---|---|
| `MERGE_STRATEGY_PR_175.md` | 2025-11-17 | decision | `2025-11-17-decision-merge-strategy-pr175.md` | `gobernanza/sesiones/2025/2025-11/` |
| `PR_BODY.md` | 2025-11-16 | decision | `2025-11-16-decision-pr-body.md` | `gobernanza/sesiones/2025/2025-11/` |
| `PR_DESCRIPTION.md` | 2025-11-16 | decision | `2025-11-16-decision-pr-description.md` | `gobernanza/sesiones/2025/2025-11/` |

#### Grupo 3: Pipeline y Sesiones

| Archivo Actual | Fecha Inferida | Tema | Nombre Propuesto | Ubicación Nueva |
|---|---|---|---|---|
| `SESSION_PIPELINE_2025_11_13.md` | 2025-11-13 | pipeline | `2025-11-13-pipeline-session.md` | `gobernanza/sesiones/2025/2025-11/` |

---

## 3. Migración de Gobernanza - Subdirectorio analisis_nov_2025/ (37+ archivos)

### Fuente: `/docs/gobernanza/sesiones/analisis_nov_2025/`

#### Grupo A: Análisis de Documentación (8 archivos)

| Archivo Actual | Fecha Inferida | Tema | Nombre Propuesto |
|---|---|---|---|
| `ANALISIS_COMPLETITUD_REORGANIZACION.md` | 2025-11-16 | analisis | `2025-11-16-analisis-completitud-reorganizacion.md` |
| `ANALISIS_DOCS_ESTRUCTURA_20251116.md` | 2025-11-16 | analisis | `2025-11-16-analisis-docs-estructura.md` |
| `ANALISIS_DOCS_FINAL_20251116_0945.md` | 2025-11-16 | analisis | `2025-11-16-analisis-docs-final.md` |
| `ANALISIS_FALLAS_DOCS.md` | 2025-11-15 | analisis | `2025-11-15-analisis-fallas-documentacion.md` |
| `ANALISIS_FINAL_LIMPIO.md` | 2025-11-16 | analisis | `2025-11-16-analisis-final-limpio.md` |
| `ANALISIS_UBICACION_ARCHIVOS.md` | 2025-11-15 | analisis | `2025-11-15-analisis-ubicacion-archivos.md` |
| `ANALISIS_FALLAS_DOCS.md` | 2025-11-15 | analisis | `2025-11-15-analisis-fallas-documentacion.md` |

#### Grupo B: Reportes (7 archivos)

| Archivo Actual | Fecha Inferida | Tema | Nombre Propuesto |
|---|---|---|---|
| `REPORTE_VALIDACION_COMPLETA.md` | 2025-11-17 | validacion | `2025-11-17-reporte-validacion-completa.md` |
| `REPORTE_REORGANIZACION.md` | 2025-11-15 | reporte | `2025-11-15-reporte-reorganizacion.md` |
| `REPORTE_REORGANIZACION_FINAL.md` | 2025-11-17 | reporte | `2025-11-17-reporte-reorganizacion-final.md` |
| `REPORTE_FINAL_FASES_1_2.md` | 2025-11-16 | reporte | `2025-11-16-reporte-final-fases-1-2.md` |
| `REPORTE_DUPLICADOS.md` | 2025-11-15 | reporte | `2025-11-15-reporte-duplicados.md` |
| `SYNC_REPORT_20251106_132547.md` | 2025-11-06 | sincronizacion | `2025-11-06-sync-report-consolidacion-v1.md` |
| `SYNC_REPORT_20251106_132936.md` | 2025-11-06 | sincronizacion | `2025-11-06-sync-report-consolidacion-v2.md` |

#### Grupo C: Síntesis Ejecutiva (5 archivos)

| Archivo Actual | Fecha Inferida | Tema | Nombre Propuesto |
|---|---|---|---|
| `RESUMEN_EJECUTIVO_REORGANIZACION.md` | 2025-11-16 | resumen | `2025-11-16-resumen-ejecutivo-reorganizacion.md` |
| `RESUMEN_EJECUTIVO_FASES_1_2_3.md` | 2025-11-17 | resumen | `2025-11-17-resumen-ejecutivo-fases-1-2-3.md` |
| `RESUMEN_SESION_CONSOLIDACION.md` | 2025-11-18 | resumen | `2025-11-18-resumen-sesion-consolidacion.md` |
| `RESUMEN_REMEDIACION_CRITICA_DOCS.md` | 2025-11-16 | resumen | `2025-11-16-resumen-remediacion-critica-docs.md` |

#### Grupo D: Decisiones y Estrategia (4 archivos)

| Archivo Actual | Fecha Inferida | Tema | Nombre Propuesto |
|---|---|---|---|
| `ESTRATEGIA_REORGANIZACION_TODO_POR_DOMINIO.md` | 2025-11-15 | decision | `2025-11-15-decision-estrategia-reorganizacion.md` |
| `PROPUESTA_FINAL_REESTRUCTURACION.md` | 2025-11-17 | decision | `2025-11-17-decision-propuesta-reestructuracion.md` |
| `MIGRATION_FROM_LEGACY.md` | 2025-11-15 | plan | `2025-11-15-plan-migracion-legacy.md` |
| `GAP_ANALYSIS_SISTEMA_PERMISOS.md` | 2025-11-16 | analisis | `2025-11-16-analisis-gap-sistema-permisos.md` |

#### Grupo E: Guías y Procedimientos (3 archivos)

| Archivo Actual | Fecha Inferida | Tema | Nombre Propuesto |
|---|---|---|---|
| `COMO_VER_DOCUMENTACION.md` | 2025-11-15 | procedimiento | `2025-11-15-procedimiento-como-ver-documentacion.md` |
| `VALIDACION_CONFORMIDAD_GOBERNANZA.md` | 2025-11-17 | validacion | `2025-11-17-validacion-conformidad-gobernanza.md` |
| `TDD_REFACTOR_RESUMEN.md` | 2025-11-16 | reporte | `2025-11-16-reporte-tdd-refactor.md` |

#### Grupo F: Meta-Documentación (3 archivos)

| Archivo Actual | Fecha Inferida | Tema | Nombre Propuesto |
|---|---|---|---|
| `META_CODEX_PARTE_1.md` | 2025-11-16 | meta | `2025-11-16-meta-agente-codex-parte1.md` |
| `ETA_CODEX_ANALISIS.md` | 2025-11-16 | meta | `2025-11-16-meta-eta-agente-codex-analisis.md` |
| `ANUNCIO_EQUIPO_REORGANIZACION.md` | 2025-11-15 | anuncio | `2025-11-15-anuncio-equipo-reorganizacion.md` |

#### Grupo G: Documentación de Procesos (3+ archivos)

| Archivo Actual | Fecha Inferida | Tema | Nombre Propuesto |
|---|---|---|---|
| `REVISION_20251112_CONSOLIDADA.md` | 2025-11-12 | validacion | `2025-11-12-validacion-revision-consolidada.md` |
| `REV_20251112_REMEDIATION_PLAN.md` | 2025-11-12 | plan | `2025-11-12-plan-remediation.md` |

---

## 4. Notas Importantes sobre la Migración

### 4.1 Inferencia de Fechas

Para archivos sin fecha clara en el nombre, se usa:
- Nombre del archivo: `SYNC_REPORT_20251106_132547.md` → 2025-11-06
- Contenido (si está disponible): Buscar "2025-11-18" o similares
- Contexto: "analisis_nov_2025" → 2025-11-15 (mitad del mes aproximada)
- Por defecto: Fecha de creación del archivo en el sistema

### 4.2 Temas Asignados

| Tema Asignado | Criterio |
|---|---|
| **analisis** | Archivos con "ANALISIS", "GAP_ANALYSIS" en nombre |
| **validacion** | Archivos con "VALIDACION", "VALIDACION_CONFORMIDAD", "REPORTE_VALIDACION" |
| **reporte** | Archivos con "REPORTE", "REPORT" (salvo validacion) |
| **decision** | Archivos con "PROPUESTA", "ESTRATEGIA", "MERGE_STRATEGY", "DECISION" |
| **sincronizacion** | Archivos con "SYNC", "SESSION_PIPELINE", "CONSOLIDATION" |
| **plan** | Archivos con "PLAN", "PLANNING", "MIGRATION" |
| **resumen** | Archivos con "RESUMEN", "SYNOPSIS" |
| **procedimiento** | Archivos con "COMO_VER", "GUIDE", "HOW_TO" |
| **meta** | Archivos con "META", "ETA" |
| **anuncio** | Archivos con "ANUNCIO", "ANNOUNCEMENT" |

### 4.3 Duplicados Detectados

```
RESUMEN_SESION_CONSOLIDACION.md (aparece 2 veces)
  - gobernanza/sesiones/analisis_nov_2025/
  - Mismo archivo duplicado

Acción: Mantener una copia, eliminar duplicado
```

### 4.4 Cambios Estructurales

**De:**
```
/docs/gobernanza/sesiones/
├── ARCHIVO.md (raíz)
└── analisis_nov_2025/
    └── ARCHIVO.md
```

**Hacia:**
```
/docs/gobernanza/sesiones/
└── 2025/
    └── 2025-11/
        └── YYYY-MM-DD-tema-descripcion.md
```

### 4.5 Metadatos a Agregar

Cada archivo migrado debe recibir:
```yaml
---
id: SESION-GOBERNANZA-YYYY-MM-DD-XXX
tipo: sesion
dominio: gobernanza
tema: [asignado]
fecha: YYYY-MM-DD
estado: completada
tags: [gobernanza, reorganizacion, sesiones]
---
```

---

## 5. Plan de Ejecución de Migración

### Fase 1: Preparación
1. [ ] Crear estructura `sesiones/2025/2025-11/` en todos los dominios
2. [ ] Crear `.gitkeep` en `sesiones/2024/`
3. [ ] Copiar plantilla de sesión
4. [ ] Documentar convenciones en README

### Fase 2: Backend (3 archivos)
1. [ ] Renombrar y mover archivos
2. [ ] Agregar frontmatter YAML
3. [ ] Verificar referencias internas
4. [ ] Eliminar directorio antiguo si está vacío

### Fase 3: Gobernanza - Raíz (6 archivos)
1. [ ] Inferir fechas de forma más precisa
2. [ ] Renombrar y mover archivos
3. [ ] Agregar frontmatter YAML
4. [ ] Actualizar referencias en documentos que los citan

### Fase 4: Gobernanza - analisis_nov_2025/ (37+ archivos)
1. [ ] Procesar archivos por grupo (A-G)
2. [ ] Renombrar según nomenclatura estándar
3. [ ] Agregar frontmatter YAML
4. [ ] Verificar no hay broken links

### Fase 5: Otros Dominios (frontend, ai, etc.)
1. [ ] Crear estructura estándar
2. [ ] Identificar sesiones existentes si las hay
3. [ ] Aplicar nomenclatura y metadatos estándar

### Fase 6: Validación Final
1. [ ] Verificar 100% conformidad de nomenclatura
2. [ ] Auditar metadatos completitud
3. [ ] Validar referencias cruzadas
4. [ ] Generar reporte de conformidad

---

## 6. Scripts de Ayuda

### Script Bash para Renombrar Archivos

```bash
#!/bin/bash
# Procesar archivos gobernanza/sesiones/analisis_nov_2025/

cd /docs/gobernanza/sesiones/

# Ejemplo: renombrar ANALISIS_DOCS_ESTRUCTURA_20251116.md
# A: 2025-11-16-analisis-docs-estructura.md
mv "analisis_nov_2025/ANALISIS_DOCS_ESTRUCTURA_20251116.md" \
   "2025/2025-11/2025-11-16-analisis-docs-estructura.md"

# Agregar frontmatter YAML
```

### Script Python (futuro)

Crear script que:
1. Lee archivos MD
2. Detecta fecha (nombre o contenido)
3. Clasifica por tema
4. Renombra automáticamente
5. Agrega frontmatter YAML
6. Genera reporte

---

## 7. Validación Post-Migración

### Checklist por Archivo

- [ ] Nombre en formato YYYY-MM-DD-tema-descripcion.md
- [ ] Frontmatter YAML presente y válido
- [ ] Campos obligatorios completos: id, tipo, dominio, tema, fecha, estado, tags
- [ ] Sin caracteres especiales o espacios
- [ ] Sin acentos ni mayúsculas innecesarias
- [ ] Referencias internas actualizadas
- [ ] No hay broken links

### Validación Global

- [ ] 100% de sesiones en estructura YYYY/YYYY-MM/
- [ ] 0 archivos en raíz de sesiones/
- [ ] 0 duplicados identificados
- [ ] Índices actualizados
- [ ] Enlaces cruzados funcionan

---

## 8. Estimación de Esfuerzo

| Tarea | Archivos | Tiempo | Dificultad |
|-------|----------|--------|-----------|
| Preparación | N/A | 30m | Baja |
| Backend | 3 | 15m | Baja |
| Gobernanza Raíz | 6 | 30m | Media |
| Gobernanza Subdirectorio | 37+ | 90m | Media |
| Otros Dominios | TBD | 60m | Media |
| Validación Final | N/A | 45m | Baja |
| **TOTAL** | **45+** | **~4.5h** | **Media** |

---

**Mapeo completado:** 2025-11-18
**Próxima etapa:** Implementación de migración
**Responsable:** Equipo de Reorganización Infraestructura
