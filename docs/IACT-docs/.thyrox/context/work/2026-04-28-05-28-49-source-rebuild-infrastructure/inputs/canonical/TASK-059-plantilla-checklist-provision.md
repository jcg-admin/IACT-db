---
id: TASK-059
titulo: Crear Plantilla Checklist Provision
fase: FASE_3_CONTENIDO_NUEVO
tipo: Creacion Contenido
tecnica: Template-based Prompting
---

# TASK-059: Crear Plantilla Checklist Provision

## Metadatos

- **ID:** TASK-059
- **Prioridad:** MEDIA (P2)
- **Duracion Estimada:** 2 horas
- **Estado:** Pendiente
- **Tipo:** Creacion Contenido
- **Dependencias:** Ninguna
- **Tecnica de Prompting:** Template-based Prompting

## Descripcion

Crear una plantilla reutilizable para checklists de aprovisionamiento de infraestructura. Esta plantilla se utilizara para validar que provisionamientos cumplan con controles de seguridad, consistencia y calidad.

## Objetivo

Proporcionar un formato estandarizado para checklists de provision con:
- Frontmatter YAML con metadatos de checklist
- Categorias organizadas de items de validacion
- Items verificables con criterios claros
- Campos para trazabilidad y evidencias
- Instrucciones de como documentar resultados
- Ejemplos de aplicacion

## Sub-tareas

1. **Diseñar estructura de frontmatter YAML**
   - Campos: id, tipo-provision, ambiente, fecha
   - Responsable y aprobador
   - Campos de trazabilidad: sprint, epic, tareas-relacionadas

2. **Definir secciones estándar**
   - Descripcion de lo que se va a provisionar
   - Pre-requisitos y dependencias
   - Categoria: Controles de Seguridad
   - Categoria: Consistencia y Estandares
   - Categoria: Documentacion y Trazabilidad
   - Categoria: Testing y Validacion
   - Categoria: Backup y Recuperacion
   - Aprobaciones y sign-off
   - Notas y evidencias
   - Historial de cambios

3. **Crear instrucciones de uso**
   - Como crear checklist para nuevo tipo de provision
   - Como documentar evidencias
   - Criterios para marcar item como completado
   - Cuando escalar si item no se puede completar

4. **Desarrollar ejemplo de aplicacion**
   - Checklist para provision de servidor nuevo
   - Items completamente documentados
   - Ejemplo de evidencias y aprobaciones

5. **Validar estructura**
   - Verificar YAML valido
   - Confirmar que items son verificables
   - Validar que checklist es completo pero no excesivo

## Tecnica de Prompting

**Template-based Prompting:**
- Usar estructura de checklists de operaciones como base
- Incluir placeholders para tipos de provision
- Documentar criterios de aceptacion
- Proporcionar ejemplos de evidencias

## Evidencias Generadas

- `/home/user/IACT/docs/infraestructura/qa/plantillas/plantilla-checklist-provision.md`
- Ejemplo de checklist completado

## Criterios de Aceptacion

- [ ] Archivo creado con frontmatter YAML valido
- [ ] Minimo 10 secciones/categorias incluidas
- [ ] Items son verificables y claros
- [ ] Ejemplo de checklist completamente documentado
- [ ] Campos para evidencias incluidos
- [ ] Instrucciones de uso claras
- [ ] Compatible con procesos de aprobacion existentes

## Consideraciones Especiales

- Alinear con procesos de provision existentes
- Permitir reutilizacion para diferentes tipos de provision
- Documentar quien puede firmar/aprobar
- Incluir referencias a configuraciones de IaC

---

**Creada:** 2025-11-18
**Version:** 1.0.0
