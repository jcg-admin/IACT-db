---
id: INDICE-NAVEGACION-INFRA-004
tipo: indice
categoria: referencia
---

# Índice de Navegación - TASK-REORG-INFRA-004

## Estructura de Archivos

```
TASK-REORG-INFRA-004-mapeo-migracion-documentos/
│
├── 📋 README.md (75 líneas)
│   Propósito, alcance, metodología de la tarea
│   └─ Inicia aquí para entender el contexto
│
├── 📊 MAPEO-MIGRACION-DOCS.md (202 líneas)
│   Matriz principal de mapeo con 24 entradas
│   └─ Referencia de ejecución para las migraciones
│
├── 🔍 ANALISIS-DUPLICADOS.md (251 líneas)
│   Análisis detallado de duplicados y mal ubicados
│   └─ Guía para deduplicación
│
├── 📈 RESUMEN-EJECUTIVO.md (203 líneas)
│   Visión general de resultados y impacto
│   └─ Para stakeholders y aprobación
│
├── 🧭 INDICE-NAVEGACION.md (este archivo)
│   Mapa de navegación entre documentos
│   └─ Orientación rápida
│
└── 📁 evidencias/
    ├── .gitkeep
    │
    └── 🔬 PROCESO-AUTO-COT-SELF-CONSISTENCY.md (300+ líneas)
        Detalles técnicos de Auto-CoT y Self-Consistency
        └─ Para auditoría metodológica
```

---

## Guía de Lectura por Rol

### Para Aprobadores
1. **Inicia con:** RESUMEN-EJECUTIVO.md
   - Visión general de resultados
   - Impacto cuantificado
   - Timeline estimado

2. **Profundiza en:** MAPEO-MIGRACION-DOCS.md
   - Revisa matriz principal
   - Valida prioridades
   - Aprueba consolidaciones

3. **Verifica:** ANALISIS-DUPLICADOS.md
   - Confirma duplicados encontrados
   - Revisa decisiones de eliminación

### Para Ejecutores (Desarrollo)
1. **Entiende el plan:** README.md
   - Metodología
   - Criterios de aceptación
   - Estructura de salida

2. **Obtén instrucciones:** MAPEO-MIGRACION-DOCS.md
   - Tabla de mapeo = instructivo
   - Priorización por fases
   - Estructura de carpetas nuevas

3. **Ejecuta deduplicación:** ANALISIS-DUPLICADOS.md
   - Comandos de eliminación
   - Validación post-ejecución

### Para QA/Validación
1. **Valida completitud:** PROCESO-AUTO-COT-SELF-CONSISTENCY.md
   - Cómo se realizó el análisis
   - Validaciones ejecutadas
   - Checklists completados

2. **Verifica matriz:** MAPEO-MIGRACION-DOCS.md
   - Todas las 24 entradas tienen justificación
   - Prioridades coherentes
   - Sin conflictos de ubicación

3. **Auditoría metodológica:** PROCESO-AUTO-COT-SELF-CONSISTENCY.md
   - Técnicas aplicadas correctamente
   - Self-Consistency score 100%

---

## Búsqueda Rápida

### ¿Dónde encontrar...?

| Pregunta | Respuesta | Archivo |
|----------|-----------|---------|
| ¿Qué debe hacerse? | Propósito y alcance | README.md |
| ¿Qué archivos se mueven? | Lista de 24 items | MAPEO-MIGRACION-DOCS.md |
| ¿Por qué se mueven? | Razones detalladas | MAPEO-MIGRACION-DOCS.md |
| ¿A dónde van? | Ubicaciones nuevas | MAPEO-MIGRACION-DOCS.md |
| ¿Qué carpetas crear? | 8 directorios nuevos | MAPEO-MIGRACION-DOCS.md → Estructura |
| ¿Qué duplicados eliminar? | 2 archivos duplicados | ANALISIS-DUPLICADOS.md |
| ¿Cómo se hizo el análisis? | Técnicas y metodología | PROCESO-AUTO-COT-SELF-CONSISTENCY.md |
| ¿Cuánto durará? | Timeline estimado | RESUMEN-EJECUTIVO.md |
| ¿Cuál es el impacto? | Métricas de mejora | RESUMEN-EJECUTIVO.md |

---

## Flujo de Aprobación y Ejecución

```
┌─────────────────────────────────────────┐
│  1. APROBACIÓN (Día 1)                  │
│  └─ Revisar RESUMEN-EJECUTIVO.md        │
│  └─ Validar MAPEO-MIGRACION-DOCS.md     │
│  └─ Confirmar ANALISIS-DUPLICADOS.md    │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│  2. TASK-REORG-INFRA-005                │
│  └─ Crear 8 directorios nuevos          │
│  └─ Seguir: MAPEO-MIGRACION-DOCS.md     │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│  3. TASK-REORG-INFRA-006/007            │
│  └─ Ejecutar migraciones fase ALTA      │
│  └─ Seguir: MAPEO-MIGRACION-DOCS.md     │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│  4. TASK-REORG-INFRA-008                │
│  └─ Deduplicar (2 archivos)             │
│  └─ Seguir: ANALISIS-DUPLICADOS.md      │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│  5. VALIDACIÓN FINAL                    │
│  └─ Ejecutar validación de links        │
│  └─ Referencia: RESUMEN-EJECUTIVO.md    │
└─────────────────────────────────────────┘
```

---

## Estadísticas de Cobertura

### Matriz de Mapeo
- **Total Entradas:** 24
- **Archivos Individuales:** 15 (raíz)
- **Directorios:** 3 (a consolidar)
- **Consolidaciones:** 3
- **Duplicados Detectados:** 2
- **Nuevos Directorios Requeridos:** 8

### Validación Aplicada
- **Técnicas de Prompting:** Auto-CoT, Self-Consistency, Tabular CoT
- **Checklists Completados:** 6/6
- **Score de Completitud:** 100%
- **Score de Coherencia:** 100%

### Priorización
| Prioridad | Cantidad | % |
|-----------|----------|-----|
| ALTA | 13 | 59% |
| MEDIA | 8 | 32% |
| BAJA | 1 | 5% |
| A Eliminar | 2 | 4% |

---

## Secciones Principales por Documento

### README.md
1. Propósito
2. Alcance
3. Estructura de salida
4. Técnica de prompting
5. Criterios de aceptación
6. Metodología

### MAPEO-MIGRACION-DOCS.md
1. Resumen ejecutivo (tabla)
2. Matriz principal (24×8)
3. Detalles de consolidaciones (3)
4. Análisis de duplicados
5. Estructura de carpetas nuevas
6. Priorización de ejecución
7. Self-Consistency validation
8. Próximos pasos

### ANALISIS-DUPLICADOS.md
1. Resumen ejecutivo
2. Duplicado #1: spec_infra_001
3. Duplicado #2: index.md
4. Mal ubicados (3)
5. Problemas de nomenclatura (2)
6. Impacto de deduplicación
7. Referencias cruzadas
8. Plan de ejecución
9. Validación Self-Consistency

### RESUMEN-EJECUTIVO.md
1. Misión
2. Resultados obtenidos (4 secciones)
3. Validación realizada
4. Impacto cuantificado
5. Riesgos y mitigación
6. Dependencias
7. Timeline estimado
8. Documentos generados
9. Quick reference

### PROCESO-AUTO-COT-SELF-CONSISTENCY.md
1. Fase de planificación (Auto-CoT)
2. Fase de análisis (Self-Consistency)
3. Fase de síntesis (Tabular CoT)
4. Validación final
5. Evidencias de ejecución
6. Conclusiones

---

## Convenciones Utilizadas

### Nomenclatura de Documentos
- **README.md** = Descripción principal de tarea
- **MAPEO-MIGRACION-DOCS.md** = Matriz/tabla de referencia
- **ANALISIS-*.md** = Análisis detallado de tema
- **RESUMEN-EJECUTIVO.md** = Visión ejecutiva
- **PROCESO-*.md** = Detalles metodológicos

### Símbolos en Estructura
- ✓ = Completado/Validado
- ✗ = Detectado/Problema
- → = Flujo/Dirección
- [NUEVA] = Directorio a crear
- [MOVER] = Directorio a consolidar
- [ACTUALIZAR] = Directorio existente a modificar

### Prioridades
- **ALTA** = Crítico para infraestructura, consultado frecuentemente
- **MEDIA** = Importante, procedimiento o histórico
- **BAJA** = Referencia o consolidación menor

---

## Contacto y Referencias

### Documentos Relacionados
- LISTADO-COMPLETO-TAREAS.md (infraestructura)
- PLAN-REORGANIZACION-ESTRUCTURA-INFRA-2025-11-18.md
- QA-ANALISIS-ESTRUCTURA-INFRA-001/README.md

### Siguiente Tarea
→ **TASK-REORG-INFRA-005:** Crear Estructura de Carpetas Nuevas

### Estado
- **Creación:** 2025-11-18
- **Versión:** 1.0.0
- **Estado:** COMPLETADO Y VALIDADO
- **Aprobación:** PENDIENTE

---

**Última actualización:** 2025-11-18
**Mantenedor:** [TBD]
