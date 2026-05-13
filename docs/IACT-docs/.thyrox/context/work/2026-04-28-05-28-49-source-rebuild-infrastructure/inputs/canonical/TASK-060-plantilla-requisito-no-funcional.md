---
id: TASK-060
titulo: Crear Plantilla Requisito No Funcional
fase: FASE_3_CONTENIDO_NUEVO
tipo: Creacion Contenido
tecnica: Template-based Prompting
---

# TASK-060: Crear Plantilla Requisito No Funcional

## Metadatos

- **ID:** TASK-060
- **Prioridad:** MEDIA (P2)
- **Duracion Estimada:** 2 horas
- **Estado:** Pendiente
- **Tipo:** Creacion Contenido
- **Dependencias:** Ninguna
- **Tecnica de Prompting:** Template-based Prompting

## Descripcion

Crear una plantilla reutilizable para documentar requisitos no funcionales (RNF) en infraestructura. Esta plantilla se utilizara para especificar requisitos de performance, disponibilidad, seguridad, escalabilidad y mantenibilidad.

## Objetivo

Proporcionar un formato estandarizado para documentar RNFs con:
- Frontmatter YAML con clasificacion de RNF
- Descripcion clara y medible
- Metricas y criterios de aceptacion
- Estrategia de validacion
- Implicaciones en diseño y operacion
- Ejemplos de requisitos comunes

## Sub-tareas

1. **Diseñar estructura de frontmatter YAML**
   - Campos: id, titulo, categoria-rnf, prioridad
   - Origen y trazabilidad
   - Campos de relacion: relacionado-con, dependencias

2. **Definir secciones estándar**
   - Resumen y contexto
   - Categoria de RNF (Performance, Disponibilidad, Seguridad, etc.)
   - Descripcion del requisito
   - Metricas de medicion
   - Criterios de aceptacion
   - Casos de prueba
   - Herramientas de validacion
   - Implicaciones arquitectonicas
   - Costo vs. beneficio
   - Historial de cambios

3. **Crear instrucciones de uso**
   - Como identificar RNFs en infraestructura
   - Como escribir requisitos medibles
   - Ejemplos de metricas para cada categoria
   - Como linkear RNF a casos de prueba

4. **Desarrollar ejemplo de aplicacion**
   - RNF real (ej: Requisito de disponibilidad 99.9%)
   - Metricas y criterios de aceptacion
   - Estrategia de validacion completa

5. **Validar estructura**
   - Verificar YAML valido
   - Confirmar que requisitos son medibles
   - Validar que criterios son verificables

## Tecnica de Prompting

**Template-based Prompting:**
- Usar ISO 25010 como referencia de categorias
- Incluir placeholders para metricas
- Documentar relaciones entre RNFs
- Proporcionar ejemplos de requisitos comunes

## Evidencias Generadas

- `/home/user/IACT/docs/infraestructura/qa/plantillas/plantilla-requisito-no-funcional.md`
- Ejemplo de RNF completamente documentado

## Criterios de Aceptacion

- [ ] Archivo creado con frontmatter YAML valido
- [ ] Minimo 10 secciones estándar incluidas
- [ ] Ejemplo de RNF completamente documentado
- [ ] Metricas y criterios claros y medibles
- [ ] Estrategia de validacion especificada
- [ ] Instrucciones de uso claras
- [ ] Alineado con estandares de RNF existentes

## Consideraciones Especiales

- Alinear con RNFs existentes en el proyecto
- Permitir trazabilidad a casos de prueba
- Documentar herramientas de monitoreo necesarias
- Incluir referencia a configuraciones de alerting

---

**Creada:** 2025-11-18
**Version:** 1.0.0
