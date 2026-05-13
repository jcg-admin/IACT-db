---
id: INDEX-TAREAS-PLANTILLAS
titulo: Indice de Tareas TASK-054 a TASK-061
tipo: Indice
fecha: 2025-11-18
version: 1.0.0
---

# Indice: Tareas de Plantillas Reutilizables (TASK-054 a TASK-061)

## Navegacion Rapida

### Por Tipo de Plantilla

#### Plantillas Arquitectonicas
- **[TASK-054: Plantilla ADR Infraestructura](./TASK-054-plantilla-adr-infraestructura.md)**
  - Crear plantilla para registrar decisiones arquitectonicas
  - Duracion: 2 horas
  - Ejemplo: Decisión de usar Vagrant para ambientes locales

#### Plantillas Operacionales
- **[TASK-055: Plantilla Procedimiento Infra](./TASK-055-plantilla-procedimiento-infra.md)**
  - Crear plantilla para procedimientos paso a paso
  - Duracion: 2 horas
  - Ejemplo: Procedimiento de backup de BD

- **[TASK-058: Plantilla Runbook](./TASK-058-plantilla-runbook.md)**
  - Crear plantilla para runbooks de incident response
  - Duracion: 2 horas
  - Ejemplo: Runbook para servicio caido

#### Plantillas de Infraestructura Local
- **[TASK-056: Plantilla VM Vagrant](./TASK-056-plantilla-vm-vagrant.md)**
  - Crear plantilla para documentar VMs Vagrant
  - Duracion: 2 horas
  - Ejemplo: VM para desarrollo Python

- **[TASK-057: Plantilla Dev Container Feature](./TASK-057-plantilla-devcontainer-feature.md)**
  - Crear plantilla para features de dev containers
  - Duracion: 2 horas
  - Ejemplo: Feature de Python linting tools

#### Plantillas de Validacion y Catalogo
- **[TASK-059: Plantilla Checklist Provision](./TASK-059-plantilla-checklist-provision.md)**
  - Crear plantilla para checklists de aprovisionamiento
  - Duracion: 2 horas
  - Ejemplo: Checklist para servidor nuevo

- **[TASK-060: Plantilla Requisito No Funcional](./TASK-060-plantilla-requisito-no-funcional.md)**
  - Crear plantilla para RNFs medibles
  - Duracion: 2 horas
  - Ejemplo: RNF de disponibilidad 99.9%

- **[TASK-061: Plantilla Catalogo Servicios](./TASK-061-plantilla-catalogo-servicios.md)**
  - Crear plantilla para catalogo de servicios
  - Duracion: 2 horas
  - Ejemplo: Entrada de BD PostgreSQL

## Por Orden de Ejecucion Recomendada

### Grupo 1: Fundacionales (Dia 1-2)
1. [TASK-054: Plantilla ADR](./TASK-054-plantilla-adr-infraestructura.md) - Registrar decisiones
2. [TASK-060: Plantilla RNF](./TASK-060-plantilla-requisito-no-funcional.md) - Especificar requisitos

### Grupo 2: Operacionales (Dia 2-3)
3. [TASK-055: Plantilla Procedimiento](./TASK-055-plantilla-procedimiento-infra.md) - Procedimientos
4. [TASK-058: Plantilla Runbook](./TASK-058-plantilla-runbook.md) - Incident response
5. [TASK-059: Plantilla Checklist](./TASK-059-plantilla-checklist-provision.md) - Validacion

### Grupo 3: Infraestructura Local (Dia 3-4)
6. [TASK-056: Plantilla VM Vagrant](./TASK-056-plantilla-vm-vagrant.md) - VMs locales
7. [TASK-057: Plantilla Dev Container](./TASK-057-plantilla-devcontainer-feature.md) - Dev containers

### Grupo 4: Cierre (Dia 4)
8. [TASK-061: Plantilla Catalogo](./TASK-061-plantilla-catalogo-servicios.md) - Catalogo de servicios

## Por Sector/Responsabilidad

### Arquitectura
- [TASK-054: Plantilla ADR](./TASK-054-plantilla-adr-infraestructura.md)
- [TASK-060: Plantilla RNF](./TASK-060-plantilla-requisito-no-funcional.md)

### Operaciones
- [TASK-055: Plantilla Procedimiento](./TASK-055-plantilla-procedimiento-infra.md)
- [TASK-058: Plantilla Runbook](./TASK-058-plantilla-runbook.md)
- [TASK-059: Plantilla Checklist](./TASK-059-plantilla-checklist-provision.md)
- [TASK-061: Plantilla Catalogo](./TASK-061-plantilla-catalogo-servicios.md)

### Desarrollo Local
- [TASK-056: Plantilla VM Vagrant](./TASK-056-plantilla-vm-vagrant.md)
- [TASK-057: Plantilla Dev Container](./TASK-057-plantilla-devcontainer-feature.md)

## Caracteristicas Comunes de Todas las Tareas

### Metadatos Estandar
- Prioridad: MEDIA
- Duracion: 2 horas
- Tipo: Creacion Contenido
- Tecnica: Template-based Prompting
- Fase: FASE_3_CONTENIDO_NUEVO

### Estructura Esperada en Cada Plantilla
```
1. Frontmatter YAML con placeholders
2. Minimo 7-13 secciones estándar
3. Instrucciones de uso claras
4. Ejemplo de aplicacion real
5. Validacion de sintaxis YAML
```

### Ubicacion de Plantillas Generadas
- Ruta: `/home/user/IACT/docs/infraestructura/qa/plantillas/`
- Formato: `plantilla-[tipo]-[descripcion].md`

## Tecnicas de Prompting Aplicadas

### Auto-CoT (Chain-of-Thought)
Razonamiento paso a paso sobre:
- Estructura optima de cada plantilla
- Secciones criticas vs. opcionales
- Flujo logico de contenido

### Self-Consistency
Validacion que:
- Estructura es consistente entre plantillas
- Nomenclatura de placeholders es uniforme
- Instrucciones usan lenguaje similar
- Ejemplos demuestran completitud

### Template-based Prompting
- Plantillas con placeholders [PLACEHOLDER]
- Instrucciones integradas
- Ejemplos funcionales
- Componentes reutilizables

## Criterios de Aceptacion Globales

### Para Cada Tarea Individual
- [ ] Archivo creado en ubicacion correcta
- [ ] Frontmatter YAML valido
- [ ] Minimo de secciones cumplidas
- [ ] Instrucciones de uso claras
- [ ] Ejemplo de aplicacion incluido
- [ ] Placeholders claramente marcados

### Para El Conjunto Completo
- [ ] 8 plantillas creadas
- [ ] Todas con estructura consistente
- [ ] YAML validable
- [ ] Ejemplos reproducibles
- [ ] Documentacion actualizada
- [ ] Listo para uso en equipo

## Recursos Relacionados

### Documentacion de Referencia
- [README General de Tareas](./README.md)
- [Listado Completo de Tareas](../QA-ANALISIS-ESTRUCTURA-INFRA-001/LISTADO-COMPLETO-TAREAS.md)
- [Plantillas Gobernanza](../../../gobernanza/plantillas/)
- [Guia de Estilo](../../../gobernanza/GUIA_ESTILO.md)

### Scripts de Validacion
- YAML Validator: `python scripts/validate_yaml.py`
- Markdown Linter: `markdownlint *.md`
- Link Checker: `scripts/validate_links.sh`

## Estado de Progreso

| TASK | Titulo | Estado | Duracion |
|------|--------|--------|----------|
| 054 | Plantilla ADR Infra | Pendiente | 2h |
| 055 | Plantilla Procedimiento | Pendiente | 2h |
| 056 | Plantilla VM Vagrant | Pendiente | 2h |
| 057 | Plantilla Dev Container | Pendiente | 2h |
| 058 | Plantilla Runbook | Pendiente | 2h |
| 059 | Plantilla Checklist | Pendiente | 2h |
| 060 | Plantilla RNF | Pendiente | 2h |
| 061 | Plantilla Catalogo | Pendiente | 2h |
| **TOTAL** | | | **16 horas** |

## Como Usar Este Indice

1. **Para iniciar trabajo:** Seleccionar grupo o TASK segun prioridad
2. **Para validar progreso:** Revisar estado en tabla
3. **Para referencias:** Ver secciones de documentacion relacionada
4. **Para navegacion:** Usar links directos a cada TASK

---

**Indice Generado:** 2025-11-18
**Version:** 1.0.0
**Ultima Actualizacion:** 2025-11-18
