---
id: TASK-REORG-INFRA-004
tipo: tarea_preparacion
categoria: planificacion
fase: FASE_1_PREPARACION
prioridad: ALTA
duracion_estimada: 2h
estado: pendiente
dependencias: [TASK-REORG-INFRA-001]
tags: [mapeo, migracion, trazabilidad]
tecnica_prompting: Tabular CoT
---

# TASK-REORG-INFRA-004: Crear Matriz de Mapeo de Migración

## Propósito

Crear una matriz exhaustiva de mapeo que documenta:
- Ubicación actual de cada archivo en docs/infraestructura/
- Ubicación nueva propuesta según estructura reorganizada
- Razón del movimiento
- Prioridad de la migración
- Estado actual del mapeo

Esta matriz es el **plano de construcción** para la ejecución de las migraciones en FASE 2.

## Alcance

- Mapear **20+ archivos** en raíz y subdirectorios
- Identificar **archivos duplicados** o con nomenclatura inconsistente
- Documentar **consolidaciones** (ej: diseno/, procedimientos/)
- Crear referencias cruzadas entre ubicaciones antiguasyllamadas nuevas
- Validar **Self-Consistency**: Verificar que NO hay archivos faltantes

## Estructura de Salida

```
TASK-REORG-INFRA-004-mapeo-migracion-documentos/
├── README.md (este archivo)
├── MAPEO-MIGRACION-DOCS.md (matriz principal)
├── ANALISIS-DUPLICADOS.md (análisis de duplicados detectados)
└── evidencias/
    └── .gitkeep
```

## Técnica de Prompting Utilizada

**Tabular Chain-of-Thought (Tabular CoT)**
- Organizar información en tabla para análisis sistemático
- Auto-CoT para razonar sobre categorización
- Self-Consistency para validar completitud

## Criterios de Aceptación

- [x] Matriz MAPEO-MIGRACION-DOCS.md creada con al menos 20 archivos
- [x] Todas las columnas completadas (Ubicación Actual, Nueva, Razón, Prioridad, Estado)
- [x] Al menos 3 consolidaciones documentadas
- [x] Análisis de duplicados incluido
- [x] Self-Consistency validación realizada (verificación de archivos faltantes)
- [x] Nomenclatura consistente utilizada
- [x] Referencias cruzadas actualizadas

## Metodología

1. **Inventario:** Listar todos los archivos en docs/infraestructura/
2. **Categorización:** Clasificar por tipo (ADR, procedimiento, guía, spec, etc.)
3. **Ubicación Óptima:** Definir carpeta destino según estructura objetivo
4. **Priorización:** ALTA para archivos frecuentemente consultados
5. **Validación:** Self-Consistency para detectar omisiones

## Siguiente Paso

Una vez aprobada esta matriz:
- TASK-REORG-INFRA-005: Crear estructura de carpetas nuevas
- TASK-REORG-INFRA-006+: Ejecutar migraciones según matriz
