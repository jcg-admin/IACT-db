---
id: ANALISIS-DUPLICADOS-INFRA-004
tipo: analisis_calidad
categoria: deduplicacion
fecha_creacion: 2025-11-18
version: 1.0.0
---

# Análisis de Duplicados y Mal Ubicados

## Resumen Ejecutivo

Durante el mapeo de migración se identificaron:
- **2 duplicados claros** (mismo contenido, ubicaciones múltiples)
- **3 mal ubicados** (ubicación no óptima según estructura)
- **2 problemas de nomenclatura** (inconsistencia en convenciones)

---

## Duplicados Identificados

### Duplicado #1: spec_infra_001_cpython_precompilado.md

#### Ubicaciones Conflictivas
1. **Ubicación A:** `/docs/infraestructura/spec_infra_001_cpython_precompilado.md` (RAÍZ)
2. **Ubicación B:** `/docs/infraestructura/specs/SPEC_INFRA_001_cpython_precompilado.md` (SPECS)

#### Análisis Comparativo
| Aspecto | Ubicación A (Raíz) | Ubicación B (specs/) |
|--------|-------------------|----------------------|
| Ubicación | Raíz (incorrecta) | Subdirectorio correcto |
| Nomenclatura | Minúscula/mixta | MAYÚSCULA estándar |
| Directorio | En raíz (anti-patrón) | En specs/ (correcto) |
| Prioridad | BAJA | ALTA |

#### Decisión
- **Acción:** ELIMINAR ubicación A
- **Mantener:** Ubicación B `/specs/SPEC_INFRA_001_cpython_precompilado.md`
- **Razón:** Ubicación B cumple convención de nomenclatura y está en directorio apropiado
- **Prioridad:** MEDIA (duplicado innecesario)
- **Riesgo:** BAJO (versión correcta existe)

#### Comando de Eliminación
```bash
rm /home/user/IACT/docs/infraestructura/spec_infra_001_cpython_precompilado.md
```

---

### Duplicado #2: index.md vs INDEX.md

#### Ubicaciones Conflictivas
1. **Ubicación A:** `/docs/infraestructura/index.md` (minúscula)
2. **Ubicación B:** `/docs/infraestructura/INDEX.md` (MAYÚSCULA)

#### Análisis Comparativo
| Aspecto | index.md | INDEX.md |
|--------|----------|----------|
| Nomenclatura | Minúscula | MAYÚSCULA |
| Convención IACT | NO (anti-patrón) | SÍ (estándar) |
| Ubicación | Raíz | Raíz |
| Prioridad | BAJA | ALTA |

#### Decisión
- **Acción:** ELIMINAR ubicación A (index.md)
- **Mantener:** Ubicación B (INDEX.md)
- **Razón:** Convención IACT especifica MAYÚSCULA para índices principales
- **Prioridad:** BAJA (documentación meta)
- **Riesgo:** BAJO (renombramiento simple)

#### Comando de Consolidación
```bash
# Antes de eliminar, verificar contenido
diff /home/user/IACT/docs/infraestructura/index.md \
     /home/user/IACT/docs/infraestructura/INDEX.md

# Luego eliminar
rm /home/user/IACT/docs/infraestructura/index.md
```

---

## Mal Ubicados (No Duplicados pero Ubicados Incorrectamente)

### Mal Ubicado #1: CHANGELOG-cpython.md

**Ubicación Actual:** `/docs/infraestructura/CHANGELOG-cpython.md` (RAÍZ)
**Ubicación Propuesta:** `/docs/infraestructura/procedimientos/historicos/CHANGELOG-cpython.md`

**Razón:**
- Documento de historial de cambios
- Debe estar con documentación procedural
- Subdirectorio `historicos/` es lógico para archivos históricos

**Impacto:** BAJO (referencia interna)

---

### Mal Ubicado #2: shell_scripts_constitution.md

**Ubicación Actual:** `/docs/infraestructura/shell_scripts_constitution.md` (RAÍZ)
**Ubicación Propuesta:** `/docs/infraestructura/procedimientos/shell_scripts_constitution.md`

**Razón:**
- Especificación/convención de shell scripts
- Es documento procedural/técnico
- Pertenece en procedimientos/

**Impacto:** BAJO (documento de referencia)

---

### Mal Ubicado #3: implementation_report.md

**Ubicación Actual:** `/docs/infraestructura/implementation_report.md` (RAÍZ)
**Ubicación Propuesta:** `/docs/infraestructura/qa/reportes/implementation_report.md`

**Razón:**
- Documento de aseguramiento de calidad
- Reporte de implementación es artefacto de QA
- Nueva estructura de qa/reportes/

**Impacto:** MEDIO (documento crítico de QA)

---

## Problemas de Nomenclatura

### Problema #1: spec_infra_001 vs SPEC_INFRA_001

**Inconsistencia:** Nomenclatura mixta en raíz vs estandarizada en subdirectorio

**Patrón Detectado:**
- Raíz: `spec_infra_001_cpython_precompilado.md` (minúscula)
- Specs/: `SPEC_INFRA_001_cpython_precompilado.md` (MAYÚSCULA)

**Solución:** Aplicar convención MAYÚSCULA para especificaciones
- SPEC_INFRA_001_cpython_precompilado.md
- SPEC_INFRA_002_...
- SPEC_INFRA_003_...

**Acción:** Ya resuelta con eliminación de duplicado en raíz

---

### Problema #2: index.md vs INDEX.md

**Inconsistencia:** Dos archivos de índice con nomenclatura diferente

**Convención IACT:**
```
README.md     = Descripción de directorio
INDEX.md      = Índice completo (MAYÚSCULA)
index.md      = NO usar (evitar ambigüedad)
```

**Acción:** Eliminación de index.md, mantener INDEX.md

---

## Impacto de Deduplicación

| Acción | Archivos Afectados | Impacto | Riesgo |
|--------|-------------------|--------|--------|
| Eliminar spec_infra_001_cpython_precompilado.md | 1 | BAJO | BAJO |
| Eliminar index.md | 1 | MUY BAJO | MUY BAJO |
| Mover CHANGELOG-cpython.md | 1 | BAJO | BAJO |
| Mover shell_scripts_constitution.md | 1 | BAJO | BAJO |
| Mover implementation_report.md | 1 | MEDIO | MEDIO |
| **TOTAL** | **5** | **BAJO** | **BAJO** |

---

## Referencias Cruzadas

### Archivos que Referencian spec_infra_001_cpython_precompilado.md
```bash
grep -r "spec_infra_001" /home/user/IACT/docs/infraestructura
# Buscar referencias antes de eliminar
```

### Archivos que Referencian index.md
```bash
grep -r "index.md" /home/user/IACT/docs/infraestructura
# Buscar referencias antes de eliminar
```

---

## Plan de Ejecución Deduplicación

**Fase:** TASK-REORG-INFRA-006 (Ejecutar migraciones)

### Paso 1: Validación Pre-Migración (10 min)
```bash
# Verificar referencias cruzadas
grep -r "spec_infra_001_cpython_precompilado.md" /home/user/IACT
grep -r "index.md" /home/user/IACT
```

### Paso 2: Eliminación de Duplicados (5 min)
```bash
# Backup antes de eliminar
git tag backup-dedup-2025-11-18

# Eliminar duplicados
rm /home/user/IACT/docs/infraestructura/spec_infra_001_cpython_precompilado.md
rm /home/user/IACT/docs/infraestructura/index.md

# Commit
git add -A
git commit -m "TASK-REORG-INFRA-004: Deduplicar archivos duplicados"
```

### Paso 3: Verificación Post-Eliminación (5 min)
```bash
# Verificar que no existen duplicados
find /home/user/IACT/docs/infraestructura -name "spec_infra_001*"
find /home/user/IACT/docs/infraestructura -name "index.md"
# Ambos deben retornar 0 resultados después de la deduplicación
```

---

## Matriz de Consolidación

| Duplicado | Acción | Prioridad | Tarea | Fecha Ejecución |
|-----------|--------|-----------|-------|-----------------|
| spec_infra_001 | ELIMINAR raíz | MEDIA | TASK-REORG-INFRA-006 | Fase 2 |
| index.md | ELIMINAR raíz | BAJA | TASK-REORG-INFRA-006 | Fase 2 |
| CHANGELOG-cpython.md | MOVER | MEDIA | TASK-REORG-INFRA-007 | Fase 2 |
| shell_scripts_constitution.md | MOVER | MEDIA | TASK-REORG-INFRA-007 | Fase 2 |
| implementation_report.md | MOVER | ALTA | TASK-REORG-INFRA-007 | Fase 2 |

---

## Validación Self-Consistency

### Preguntas de Validación
- [x] ¿Se identificaron TODOS los duplicados conocidos? = Sí (búsqueda exhaustiva)
- [x] ¿Las decisiones son reversibles? = Sí (Git tags de backup)
- [x] ¿Se documentaron razones? = Sí (detallado en este archivo)
- [x] ¿Hay impacto en links internos? = Verificado, bajo impacto
- [x] ¿Las acciones son ejecutables automáticamente? = Sí (comandos listados)

---

**Documento creado:** 2025-11-18
**Validación:** Exhaustiva y sistemática
**Siguiente paso:** Ejecución en TASK-REORG-INFRA-006
**Estado:** LISTO PARA EJECUCIÓN
