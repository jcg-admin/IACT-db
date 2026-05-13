---
id: TASK-055
titulo: Crear Plantilla Procedimiento Infraestructura
fase: FASE_3_CONTENIDO_NUEVO
tipo: Creacion Contenido
tecnica: Template-based Prompting
---

# TASK-055: Crear Plantilla Procedimiento Infraestructura

## Metadatos

- **ID:** TASK-055
- **Prioridad:** MEDIA (P2)
- **Duracion Estimada:** 2 horas
- **Estado:** Pendiente
- **Tipo:** Creacion Contenido
- **Dependencias:** Ninguna
- **Tecnica de Prompting:** Template-based Prompting

## Descripcion

Crear una plantilla reutilizable para documentar procedimientos operacionales en infraestructura. Esta plantilla se utilizara para procedimientos como backups, escalado, mantenimiento, actualizaciones y migraciones.

## Objetivo

Proporcionar un formato estandarizado y reutilizable para documentar procedimientos operacionales con:
- Frontmatter YAML con placeholders
- Estructura paso a paso clara
- Controles de pre y post ejecucion
- Instrucciones de rollback
- Ejemplos de uso comun

## Sub-tareas

1. **Diseñar estructura de frontmatter YAML**
   - Campos: id, titulo, categoria, criticidad, responsables, version
   - Campos de mantenimiento: ultima-revision, proxima-revision
   - Campos de trazabilidad: relacionado-con

2. **Definir secciones estándar**
   - Resumen y alcance
   - Pre-requisitos y validaciones
   - Paso a paso detallado
   - Validaciones durante ejecucion
   - Post ejecucion y verificaciones
   - Rollback o reversa (si aplica)
   - Troubleshooting comun
   - Documentacion relacionada

3. **Crear instrucciones de uso**
   - Como escribir pasos claros y verificables
   - Formato recomendado para comandos
   - Indicadores de riesgo y precauciones
   - Como documentar resultados esperados

4. **Desarrollar ejemplo de aplicacion**
   - Procedimiento real (ej: backup de base de datos)
   - Todos los pasos completamente documentados
   - Ejemplos de comandos y salidas esperadas

5. **Validar estructura y completitud**
   - Verificar YAML valido
   - Confirmar que instrucciones son claras
   - Validar que exemplo es reproducible

## Tecnica de Prompting

**Template-based Prompting:**
- Usar patrones de procedimientos operacionales establecidos
- Incluir placeholders para comandos y valores variables
- Documentar flujos de decision (si-entonces)
- Marcar secciones criticas con [CRITICO]

## Evidencias Generadas

- `/home/user/IACT/docs/infraestructura/qa/plantillas/plantilla-procedimiento-infra.md`
- Ejemplo de procedimiento completado

## Criterios de Aceptacion

- [ ] Archivo creado con frontmatter YAML valido
- [ ] Minimo 8 secciones estándar incluidas
- [ ] Pasos numerados y verificables
- [ ] Instrucciones claras para rollback
- [ ] Ejemplo de procedimiento real incluido
- [ ] Comandos ejemplificados con salidas esperadas
- [ ] Secciones criticas claramente marcadas

## Consideraciones Especiales

- Alinear con procedimientos existentes en runbooks
- Permitir referencia a scripts de automatizacion
- Incluir tiempos estimados para cada paso

---

**Creada:** 2025-11-18
**Version:** 1.0.0
