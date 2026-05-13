---
id: README-TAREAS-PLANTILLAS
titulo: Tareas de Creacion de Plantillas Reutilizables
tipo: Documentacion
fecha: 2025-11-18
version: 1.0.0
---

# Tareas de Creacion de Plantillas Reutilizables

## Descripcion General

Este directorio contiene las definiciones de 8 tareas (TASK-054 a TASK-061) diseñadas para crear plantillas reutilizables de documentacion para infraestructura. Cada plantilla proporciona un formato estandarizado para documentar diferentes aspectos de la infraestructura.

## Contexto Strategico

**Tecnicas Aplicadas:** Auto-CoT + Self-Consistency
- Auto-CoT (Chain-of-Thought): Razonamiento paso a paso sobre la estructura optima de cada plantilla
- Self-Consistency: Validar que plantillas sean consistentes entre si y con documentacion existente
- Template-based Prompting: Proporcionar plantillas con placeholders claramente marcados

**Fase:** FASE_3_CONTENIDO_NUEVO
**Prioridad:** MEDIA
**Duracion Total:** 16 horas (2 horas por tarea)
**Horizonte:** Semana de implementacion

## Plantillas a Crear

| ID | Plantilla | Descripcion | Caso de Uso Principal |
|----|-----------|-----------|----|
| TASK-054 | plantilla-adr-infraestructura.md | Decisiones arquitectonicas | Registrar decisiones de diseño de infraestructura |
| TASK-055 | plantilla-procedimiento-infra.md | Procedimientos operacionales | Documentar procedimientos paso a paso |
| TASK-056 | plantilla-vm-vagrant.md | Configuracion de VMs Vagrant | Documentar maquinas virtuales de desarrollo |
| TASK-057 | plantilla-devcontainer-feature.md | Features de Dev Container | Documentar extensiones de dev containers |
| TASK-058 | plantilla-runbook.md | Runbooks operacionales | Procedimientos de incident response |
| TASK-059 | plantilla-checklist-provision.md | Checklists de provision | Validar aprovisionamientos |
| TASK-060 | plantilla-requisito-no-funcional.md | Requisitos no funcionales | Especificar RNFs medibles |
| TASK-061 | plantilla-catalogo-servicios.md | Catalogo de servicios | Documentar servicios disponibles |

## Estructura de Cada Tarea

Cada tarea (TASK-054 a TASK-061) contiene:

### Metadatos
- ID unico de tarea
- Prioridad: MEDIA
- Duracion Estimada: 2 horas
- Tipo: Creacion Contenido
- Tecnica: Template-based Prompting

### Contenido
1. **Descripcion:** Explicacion clara del objetivo
2. **Sub-tareas:** Pasos operacionales concretos
3. **Tecnica de Prompting:** Detalles de aplicacion de Auto-CoT + Self-Consistency
4. **Evidencias Generadas:** Artefactos esperados
5. **Criterios de Aceptacion:** Checklist de completitud

## Estructura Comun de Plantillas

Todas las plantillas deben incluir:

### Frontmatter YAML
```yaml
---
id: PLANTILLA-ID
titulo: Titulo de la Plantilla
tipo: Tipo de contenido
version: 1.0.0
fecha: 2025-11-18
responsable: definir
estado: pendiente
trazabilidad:
  tareas: [TASK-XXX]
  adrs: []
---
```

### Secciones Estandar
1. Resumen/Proposito
2. Contexto/Alcance
3. Estructura/Componentes
4. Instrucciones de Uso
5. Ejemplo de Aplicacion
6. Validacion/Criterios de Aceptacion
7. Troubleshooting (si aplica)
8. Referencias/Documentacion Relacionada

## Caracteristicas Clave

### Reutilizabilidad
- Placeholders claramente marcados con [PLACEHOLDER]
- Campos configurables mediante frontmatter YAML
- Ejemplos adaptables a diferentes contextos

### Usabilidad
- Instrucciones paso a paso claras
- Ejemplos reales y completos
- Guias de cuando usar cada plantilla
- Criterios de aceptacion verificables

### Trazabilidad
- Referencias a tareas asociadas
- Vinculos a ADRs cuando aplique
- Historial de cambios documentado
- Metadatos de propietario y version

### Consistencia
- Alineacion con documentacion existente en `/docs/gobernanza/plantillas/`
- Formato YAML validable
- Estructura de secciones predecible
- Nomenclatura estandarizada

## Tecnica: Template-based Prompting

### Componentes Principales

1. **Plantilla Base:** Estructura comun para todas las plantillas
2. **Placeholders:** Valores variables claramente marcados
3. **Instrucciones Integradas:** Guias de como completar cada seccion
4. **Ejemplos Funcionales:** Demostraciones de uso real

### Aplicacion de Auto-CoT

Cada tarea incluye razonamiento sobre:
- Por que la estructura propuesta es optima
- Que secciones son criticas vs. opcionales
- Como el ejemplo demuestra completitud
- Cuando usar vs. cuando no usar

### Aplicacion de Self-Consistency

Validacion que:
- Estructura es consistente entre plantillas
- Placeholders siguen nomenclatura comun
- Instrucciones usan lenguaje similar
- Ejemplos demuestran completitud

## Dependencias y Orden de Ejecucion

Las 8 tareas pueden ejecutarse en paralelo ya que:
- No tienen dependencias entre ellas
- Cada plantilla es independiente
- Pueden validarse simultaneamente

**Orden Recomendado (si se ejecutan secuencialmente):**
1. TASK-054 (ADR - fundacional para decisiones)
2. TASK-060 (RNF - fundacional para requisitos)
3. TASK-055, 056, 057, 058 (Operacionales)
4. TASK-059, 061 (Validacion y catalogo)

## Criterios de Exito Global

- [ ] 8 plantillas creadas con estructura completa
- [ ] Todas con frontmatter YAML valido
- [ ] Todas con minimo de secciones especificadas
- [ ] Ejemplos de aplicacion real en cada una
- [ ] Instrucciones de uso claras y completas
- [ ] Placeholders claramente identificados
- [ ] Validacion de sintaxis YAML completada
- [ ] Documentacion actualizada con referencias

## Proximos Pasos Despues de Plantillas

Despues de completar estas 8 tareas:

1. **Validacion (TASK-062):** Validar estructura de todas las plantillas
2. **Integracion (TASK-063):** Integrar con sistema de documentacion principal
3. **Entrenamiento (TASK-064):** Crear guias de uso para equipos
4. **Monitoreo (TASK-065):** Seguimiento de uso de plantillas

## Referencias Relacionadas

- **Plantillas Existentes:** `/home/user/IACT/docs/gobernanza/plantillas/`
- **Documentacion ADR:** `/home/user/IACT/docs/gobernanza/INDICE_ADRs.md`
- **Estandares de Documentacion:** `/home/user/IACT/docs/gobernanza/GUIA_ESTILO.md`
- **Tareas Activas:** `/home/user/IACT/docs/gobernanza/TAREAS_ACTIVAS.md`
- **LISTADO Completo:** `/home/user/IACT/docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/LISTADO-COMPLETO-TAREAS.md`

## Convenciones de Nomenclatura

### Archivos de Tarea
```
TASK-XXX-descripcion-corta.md
```

### Archivos de Plantilla (a crear)
```
plantilla-tipo-descripcion.md
```

### Archivos de Evidencia
```
evidencias/validacion-plantillas.md
```

## Contacto y Escalacion

Para preguntas sobre estas tareas:
- **Responsable Principal:** Equipo de Infraestructura
- **Revisor de Plantillas:** Equipo de Gobernanza
- **Escalacion:** Ver tareas de validacion posteriores

## Historial de Cambios

| Fecha | Version | Cambios |
|-------|---------|---------|
| 2025-11-18 | 1.0.0 | Creacion inicial de 8 tareas |

---

**Documento Generado:** 2025-11-18
**Proxima Revision Programada:** 2025-11-25 (Despues de completar tareas)
**Responsable:** Equipo de Infraestructura y Documentacion
