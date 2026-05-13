---
id: TASK-058
titulo: Crear Plantilla Runbook
fase: FASE_3_CONTENIDO_NUEVO
tipo: Creacion Contenido
tecnica: Template-based Prompting
---

# TASK-058: Crear Plantilla Runbook

## Metadatos

- **ID:** TASK-058
- **Prioridad:** MEDIA (P2)
- **Duracion Estimada:** 2 horas
- **Estado:** Pendiente
- **Tipo:** Creacion Contenido
- **Dependencias:** Ninguna
- **Tecnica de Prompting:** Template-based Prompting

## Descripcion

Crear una plantilla reutilizable para documentar runbooks operacionales. Esta plantilla se utilizara para procedimientos automatizados y manuales para incidentes, mantenimiento y operaciones.

## Objetivo

Proporcionar un formato estandarizado para documentar runbooks con:
- Frontmatter YAML con metadatos operacionales
- Descripcion clara de proposito y alcance
- Procedimientos paso a paso
- Flujos de decision y escalacion
- Informacion de contacto y escalacion
- Ejemplos de ejecucion

## Sub-tareas

1. **Diseñar estructura de frontmatter YAML**
   - Campos: id, titulo, tipo-runbook, severidad
   - Propietarios y escalaciones
   - SLA y tiempos de respuesta
   - Campos de mantenimiento: creado-por, ultima-actualizacion

2. **Definir secciones estándar**
   - Resumen ejecutivo
   - Proposito y alcance
   - Precondiciones y requisitos
   - Pasos de diagnostico
   - Pasos de resolucion
   - Escalacion y contactos
   - Rollback y reversa
   - Documentacion posterior al incidente
   - Historial de cambios
   - Referencias y documentacion relacionada

3. **Crear instrucciones de uso**
   - Cuando activar cada runbook
   - Como ejecutar procedimientos correctamente
   - Como documentar acciones tomadas
   - Criterios para escalacion
   - Como actualizar runbook con aprendizajes

4. **Desarrollar ejemplo de aplicacion**
   - Runbook real (ej: Recuperacion de servicio caido)
   - Pasos de diagnostico y resolucion completamente documentados
   - Ejemplo de escalacion

5. **Validar estructura**
   - Verificar YAML valido
   - Confirmar que procedimientos son claros
   - Validar que tiempos estimados son realistas

## Tecnica de Prompting

**Template-based Prompting:**
- Usar estructura de incident response como base
- Incluir placeholders para valores especificos
- Documentar flujos de decision
- Proporcionar ejemplos de logs esperados

## Evidencias Generadas

- `/home/user/IACT/docs/infraestructura/qa/plantillas/plantilla-runbook.md`
- Ejemplo de runbook operacional

## Criterios de Aceptacion

- [ ] Archivo creado con frontmatter YAML valido
- [ ] Minimo 10 secciones estándar incluidas
- [ ] Pasos de diagnostico y resolucion claros
- [ ] Criterios de escalacion documentados
- [ ] Contactos y SLAs incluidos
- [ ] Ejemplo de runbook completamente documentado
- [ ] Tiempos estimados especificados

## Consideraciones Especiales

- Alinear con procedimientos operacionales existentes
- Permitir integracion con sistemas de alerting
- Documentar herramientas y accesos requeridos
- Incluir referencias a dashboards de monitoreo

---

**Creada:** 2025-11-18
**Version:** 1.0.0
