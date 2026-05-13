---
id: ARCHIVOS-CANDIDATOS-DISENO-DETALLADO
fecha_creacion: 2025-11-18
tipo: inventario
estado: identificados
---

# Archivos Candidatos para diseno/detallado/

## Resumen Ejecutivo

Se han identificado **8 documentos principales** candidatos para consolidar en `docs/infraestructura/diseno/detallado/`. Estos documentos describen **implementaciones específicas, procedimientos step-by-step y especificaciones técnicas detalladas**.

**Total identificados:** 8 archivos
**Categorías:** 4 (Especificaciones, Guías, Estrategias, Herramientas)

---

## Categoría 1: Especificaciones Técnicas Detalladas (ALTA PRIORIDAD)

### 1. spec_infra_001_cpython_precompilado.md
- **Ubicación:** `/home/user/IACT/docs/infraestructura/spec_infra_001_cpython_precompilado.md`
- **Tipo:** Especificación de Feature
- **Propósito:** Define requisitos técnicos específicos para integración de CPython precompilado en Dev Containers
- **Contenido:** Feature specs, requisitos, criterios de aceptación, trazabilidad
- **Líneas:** ~858 líneas
- **Clasificación:** LOW-LEVEL (implementación específica)
- **Prioridad MOVER:** ⭐⭐⭐⭐⭐ MUY ALTA
- **Ubicación futura:** `diseno/detallado/especificaciones/SPEC_INFRA_001_cpython_precompilado.md`

### 2. TASK-017-layer3_infrastructure_logs.md
- **Ubicación:** `/home/user/IACT/docs/infraestructura/TASK-017-layer3_infrastructure_logs.md`
- **Tipo:** Especificación Técnica de Logging
- **Propósito:** Especificación detallada de logging a nivel de infraestructura (Layer 3)
- **Contenido:** Requisitos de logging, configuración, implementación
- **Clasificación:** LOW-LEVEL (especificación de implementación)
- **Prioridad MOVER:** ⭐⭐⭐⭐ ALTA
- **Ubicación futura:** `diseno/detallado/especificaciones/TASK-017-layer3_infrastructure_logs.md`

---

## Categoría 2: Guías de Implementación Step-by-Step (ALTA PRIORIDAD)

### 3. cpython_builder.md
- **Ubicación:** `/home/user/IACT/docs/infraestructura/cpython_builder.md`
- **Tipo:** Documentación Técnica Detallada
- **Propósito:** Sistema de compilación y construcción de CPython - detalles de implementación
- **Contenido:**
  - Arquitectura del sistema de compilación
  - Componentes principales
  - Estructura de directorios
  - Scripts disponibles
  - Configuración
  - Uso step-by-step
  - Validación y testing
  - Troubleshooting
- **Líneas:** ~860 líneas
- **Clasificación:** LOW-LEVEL (implementación específica de herramienta)
- **Prioridad MOVER:** ⭐⭐⭐⭐⭐ MUY ALTA
- **Ubicación futura:** `diseno/detallado/herramientas/cpython-builder/`

### 4. cpython_development_guide.md
- **Ubicación:** `/home/user/IACT/docs/infraestructura/cpython_development_guide.md`
- **Tipo:** Guía de Desarrollo Detallada
- **Propósito:** Guía paso a paso para desarrollo con CPython
- **Contenido:** Procedimientos, pasos específicos, configuración
- **Líneas:** ~1086 líneas
- **Clasificación:** LOW-LEVEL (guía de implementación)
- **Prioridad MOVER:** ⭐⭐⭐⭐⭐ MUY ALTA
- **Ubicación futura:** `diseno/detallado/procedimientos/cpython-development-guide.md`

### 5. plantilla_provision.md
- **Ubicación:** `/home/user/IACT/docs/infraestructura/qa/plantillas/plantilla_provision.md`
- **Tipo:** Plantilla de Provisión
- **Propósito:** Plantilla detallada para provisión de infraestructura
- **Contenido:** Pasos de provisión, checklist, procedimientos operacionales
- **Clasificación:** LOW-LEVEL (procedimiento operacional)
- **Prioridad MOVER:** ⭐⭐⭐⭐ ALTA
- **Ubicación futura:** `diseno/detallado/procedimientos/plantilla-provision.md`

---

## Categoría 3: Estrategias de Implementación Detallada (MEDIA PRIORIDAD)

### 6. estrategia_migracion_shell_scripts.md
- **Ubicación:** `/home/user/IACT/docs/infraestructura/estrategia_migracion_shell_scripts.md`
- **Tipo:** Estrategia de Implementación Detallada
- **Propósito:** Detalles específicos de cómo migrar shell scripts
- **Contenido:** Pasos de migración, patrones, procedimientos
- **Líneas:** ~48759 líneas (documento muy completo)
- **Clasificación:** LOW-LEVEL (implementación de estrategia)
- **Prioridad MOVER:** ⭐⭐⭐⭐ ALTA
- **Ubicación futura:** `diseno/detallado/estrategias/migracion-shell-scripts.md`

### 7. estrategia_git_hooks.md
- **Ubicación:** `/home/user/IACT/docs/infraestructura/estrategia_git_hooks.md`
- **Tipo:** Estrategia de Configuración Detallada
- **Propósito:** Detalles específicos de configuración de Git hooks
- **Contenido:** Configuración de hooks, procedimientos, scripts
- **Líneas:** ~17891 líneas
- **Clasificación:** LOW-LEVEL (implementación de herramienta)
- **Prioridad MOVER:** ⭐⭐⭐ MEDIA
- **Ubicación futura:** `diseno/detallado/herramientas/git-hooks/`

---

## Categoría 4: Configuración de Ambientes (MEDIA PRIORIDAD)

### 8. ambientes_virtualizados.md
- **Ubicación:** `/home/user/IACT/docs/infraestructura/ambientes_virtualizados.md`
- **Tipo:** Especificación de Ambientes Virtualizados
- **Propósito:** Configuración detallada de ambientes virtualizados (Vagrant, Docker, etc.)
- **Contenido:** Especificaciones de ambientes, configuración, procedimientos
- **Líneas:** ~10592 líneas
- **Clasificación:** LOW-LEVEL (especificación de implementación)
- **Prioridad MOVER:** ⭐⭐⭐⭐ ALTA
- **Ubicación futura:** `diseno/detallado/ambientes/virtualizados.md`

---

## ANÁLISIS: Documentos en Posición Intermedia

### storage_architecture.md
- **Ubicación:** `/home/user/IACT/docs/infraestructura/storage_architecture.md`
- **Tipo:** Podría ser ARQUITECTURA o DETALLADO (requiere revisión)
- **Clasificación TENTATIVA:** ⚠️ NECESITA EVALUACIÓN
- **Notas:**
  - Si define topología de almacenamiento → ARQUITECTURA
  - Si detalla implementación específica → DETALLADO
  - **Acción:** Revisar en TASK-REORG-INFRA-008

---

## Priorización para TASK-REORG-INFRA-008

### MOVER EN PRIMER LOTE (SEMANA 1)
1. spec_infra_001_cpython_precompilado.md ⭐⭐⭐⭐⭐
2. cpython_builder.md ⭐⭐⭐⭐⭐
3. cpython_development_guide.md ⭐⭐⭐⭐⭐
4. ambientes_virtualizados.md ⭐⭐⭐⭐

### MOVER EN SEGUNDO LOTE (SEMANA 2)
5. estrategia_migracion_shell_scripts.md ⭐⭐⭐⭐
6. plantilla_provision.md ⭐⭐⭐⭐

### MOVER EN TERCER LOTE (SEMANA 3)
7. TASK-017-layer3_infrastructure_logs.md ⭐⭐⭐⭐
8. estrategia_git_hooks.md ⭐⭐⭐

### REVISAR/DECIDIR
- storage_architecture.md (¿Arquitectura o Detallado?)

---

## Estructura Propuesta para diseno/detallado/

```
diseno/detallado/
├── README.md (PROPÓSITO)
├── especificaciones/
│   ├── README.md
│   ├── SPEC_INFRA_001_cpython_precompilado.md
│   ├── TASK-017-layer3_infrastructure_logs.md
│   └── ambientes_virtualizados.md
├── procedimientos/
│   ├── README.md
│   ├── cpython-development-guide.md
│   ├── plantilla-provision.md
│   └── [otros procedimientos]
├── herramientas/
│   ├── README.md
│   ├── cpython-builder/
│   │   ├── README.md
│   │   └── index.md
│   ├── git-hooks/
│   │   ├── README.md
│   │   └── [contenido de estrategia_git_hooks.md]
│   └── [otras herramientas]
├── estrategias/
│   ├── README.md
│   ├── migracion-shell-scripts.md
│   └── [otras estrategias]
└── ambientes/
    ├── README.md
    └── virtualizados.md
```

---

## Validación Self-Consistency

### Archivos que PERMANECEN en raíz o root de diseno/
- `diseno/README.md` - Índice general
- `diseno/arquitectura/` - Alto nivel
- `diseno/diagramas/` - Visualizaciones

### Archivos que se MUEVEN a diseno/detallado/
- Todos los 8+ documentos listados arriba

### Archivos que quedan en su lugar (otros directorios)
- `requisitos/` - Mantenerse como está
- `procedimientos/` - Procedimientos generales (no específicos de infraestructura)
- `devops/` - Considerar consolidación con detallado/

---

## Próximos Pasos

1. **TASK-REORG-INFRA-007 (ACTUAL):** ✅ DOCUMENTACIÓN
   - [x] Identificar documentos
   - [x] Definir estructura
   - [x] Documentar propósito
   - [ ] Crear README base de detallado/

2. **TASK-REORG-INFRA-008:** MOVER ARCHIVOS
   - [ ] Crear estructura de subdirectorios
   - [ ] Mover archivos con `git mv`
   - [ ] Actualizar referencias
   - [ ] Validar enlaces

3. **Tareas posteriores:** Otras consolidaciones de diseño

---

## Anexo: Criterios de Clasificación

**ARQUITECTURA (Alto Nivel):**
- Decisiones estratégicas
- ADR (Architecture Decision Records)
- Topologías generales
- Patrones conceptuales
- Lineamientos de diseño

**DETALLADO (Bajo Nivel):**
- Especificaciones de implementación
- Pasos paso a paso
- Configuración de herramientas
- Scripts y procedimientos
- Guías operacionales
- Troubleshooting técnico

---

**Documento preparado para TASK-REORG-INFRA-007**
**Estado:** Listo para pasar a TASK-REORG-INFRA-008
