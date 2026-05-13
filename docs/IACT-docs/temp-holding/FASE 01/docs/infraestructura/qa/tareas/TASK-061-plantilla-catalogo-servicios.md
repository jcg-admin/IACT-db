---
id: TASK-061
titulo: Crear Plantilla Catalogo Servicios
fase: FASE_3_CONTENIDO_NUEVO
tipo: Creacion Contenido
tecnica: Template-based Prompting
---

# TASK-061: Crear Plantilla Catalogo Servicios

## Metadatos

- **ID:** TASK-061
- **Prioridad:** MEDIA (P2)
- **Duracion Estimada:** 2 horas
- **Estado:** Pendiente
- **Tipo:** Creacion Contenido
- **Dependencias:** Ninguna
- **Tecnica de Prompting:** Template-based Prompting

## Descripcion

Crear una plantilla reutilizable para documentar servicios en un catalogo de infraestructura. Esta plantilla se utilizara para registrar y documentar todos los servicios disponibles, sus caracteristicas, dependencias y como accederlos.

## Objetivo

Proporcionar un formato estandarizado para catalogar servicios con:
- Frontmatter YAML con metadatos de servicio
- Descripcion clara y ubicacion
- Requisitos y dependencias
- Interfaces de acceso
- Informacion operacional
- Soporte y contactos
- Ejemplos de uso

## Sub-tareas

1. **Diseñar estructura de frontmatter YAML**
   - Campos: id, nombre-servicio, tipo, version
   - Propietario y equipo responsable
   - Campos de localizacion: url, puertos, endpoint
   - Campos de relacion: dependencias, servicios-relacionados

2. **Definir secciones estándar**
   - Resumen y descripcion
   - Proposito del servicio
   - Tipo y categoria
   - Ubicacion y acceso
   - Requisitos y dependencias
   - Caracteristicas principales
   - Interfaces disponibles (API, CLI, UI)
   - Autenticacion y autorizacion
   - Performance y limites
   - Informacion operacional
   - Escalation y soporte
   - Documentacion relacionada
   - Historial de cambios

3. **Crear instrucciones de uso**
   - Como agregar nuevo servicio al catalogo
   - Como documentar interfaces de servicio
   - Como mantener el catalogo actualizado
   - Como usar catalogo para discovery

4. **Desarrollar ejemplo de aplicacion**
   - Servicio real (ej: Base de datos PostgreSQL)
   - Acceso, dependencias y operacion completas
   - Ejemplo de multiples interfaces

5. **Validar estructura**
   - Verificar YAML valido
   - Confirmar que informacion es completa
   - Validar que ejemplo es realista

## Tecnica de Prompting

**Template-based Prompting:**
- Usar estructura ITIL Service Catalog como base
- Incluir placeholders para valores especificos
- Documentar relaciones entre servicios
- Proporcionar ejemplos de diferentes tipos de servicios

## Evidencias Generadas

- `/home/user/IACT/docs/infraestructura/qa/plantillas/plantilla-catalogo-servicios.md`
- Ejemplo de entrada de catalogo

## Criterios de Aceptacion

- [ ] Archivo creado con frontmatter YAML valido
- [ ] Minimo 13 secciones estándar incluidas
- [ ] Ejemplo de catalogo completamente documentado
- [ ] Informacion de acceso clara y completa
- [ ] Dependencias y relaciones documentadas
- [ ] Instrucciones de mantenimiento claras
- [ ] Compatible con descubrimiento de servicios

## Consideraciones Especiales

- Alinear con catalogo de servicios existente
- Permitir integracion con sistemas de monitoreo
- Documentar SLAs de cada servicio
- Incluir referencias a runbooks operacionales
- Facilitar busqueda y descubrimiento de servicios

---

**Creada:** 2025-11-18
**Version:** 1.0.0
