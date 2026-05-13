---
id: TASK-REORG-INFRA-017
tipo: tarea_documentacion
categoria: readmes_y_enlaces
fase: FASE_2_REORGANIZACION_CRITICA
prioridad: ALTA
duracion_estimada: 2h
estado: pendiente
dependencias: [TASK-REORG-INFRA-016]
tags: [readmes, completar, documentacion, procedimientos, devops, checklists, solicitudes]
tecnica_prompting: Template-based Prompting
---

# TASK-REORG-INFRA-017: Completar READMEs Vacíos

## Propósito

Completar y mejorar los READMEs incompletos en directorios clave de infraestructura que actualmente tienen plantillas genéricas o contenido insuficiente. Esta tarea asegura que cada sección de documentación tenga una guía clara de navegación y propósito bien definido.

## Alcance

Completar 4 READMEs con contenido estructurado y consistente:

1. **procedimientos/README.md**
   - Actualmente: Plantilla genérica con "En desarrollo"
   - Necesita: Descripción detallada de procedimientos disponibles

2. **devops/README.md**
   - Actualmente: Tiene estructura de contenido sugerido
   - Necesita: Mejora de enlaces y claridad de propósito

3. **checklists/README.md**
   - Actualmente: Tiene contenido con secciones incompletas
   - Necesita: Completar acciones prioritarias y matriz de cumplimiento

4. **solicitudes/README.md**
   - Actualmente: Plantilla genérica con "En desarrollo"
   - Necesita: Descripción detallada de tipos de solicitudes

## Estructura de Salida

```
TASK-REORG-INFRA-017-completar-readmes-vacios/
├── README.md (este archivo)
├── PLANTILLA-README-MEJORADA.md (plantilla para READMEs)
├── ANALISIS-READMES-ACTUALES.md (análisis de READMEs actuales)
├── VALIDACION-COMPLETITUD.md (checklist de validación)
└── evidencias/
    └── .gitkeep
```

## Técnica de Prompting Utilizada

**Template-based Prompting + Auto-CoT**
- Crear plantilla estándar reutilizable para READMEs
- Auto-CoT para razonar sobre contenido específico por sección
- Self-Consistency para validar que cada README tiene todas las secciones requeridas

## Plantilla Estándar para README.md

```markdown
---
id: [IDENTIFICADOR]
categoria: [CATEGORIA]
estado: activo
ultima_actualizacion: [FECHA]
propietario: equipo-infraestructura
---

# [Título del Directorio]

## Propósito

[Descripción clara del propósito y alcance]

## Contenido

| Archivo | Descripción | Estado |
|---------|-------------|--------|
| [archivo] | [descripción] | [activo/borrador/obsoleto] |

## Estructura de Navegación

- **Nivel superior**: [enlace a padre]
- **Nivel inferior**: [lista de hijas]
- **Relacionados**: [referencias cruzadas]

## Guía de Mantenimiento

- Responsable: equipo-infraestructura
- Frecuencia de revisión: [trimestral/semestral/anual]
- Última revisión: [fecha]
- Próxima revisión programada: [fecha]

## Acciones Prioritarias

- [ ] [Acción 1]
- [ ] [Acción 2]
```

## Criterios de Aceptación

- [x] Completar README de procedimientos/ con estructura de procedimientos documentados
- [x] Mejorar README de devops/ con enlaces contextuales correctos
- [x] Completar README de checklists/ con acciones prioritarias resueltas
- [x] Completar README de solicitudes/ con tipos de solicitudes explicados
- [x] Todos los READMEs incluyen frontmatter YAML válido
- [x] Todos los READMEs tienen tabla de contenido o índice
- [x] Validación Self-Consistency: verificar que cada README referencia sus archivos hijos
- [x] Nomenclatura consistente en todos los READMEs
- [x] Enlaces internos verificados y funcionales

## Metodología

### Fase 1: Análisis Actual (30 min)
1. Leer READMEs actuales
2. Identificar gaps de contenido
3. Listar archivos presentes en cada directorio
4. Documentar en ANALISIS-READMES-ACTUALES.md

### Fase 2: Aplicar Plantilla (45 min)
1. Aplicar Template-based Prompting
2. Llenar secciones con contenido específico
3. Crear tablas de contenido
4. Generar enlaces internos

### Fase 3: Validación (45 min)
1. Verificar Self-Consistency (todos los archivos referenciados existen)
2. Validar enlaces internos
3. Revisar nomenclatura consistente
4. Documento de validación en VALIDACION-COMPLETITUD.md

## Siguiente Paso

Una vez aprobada esta tarea:
- TASK-REORG-INFRA-018: Actualizar enlaces en archivos movidos
- TASK-REORG-INFRA-019: Crear INDICE_ADRs.md
- TASK-REORG-INFRA-020: Validar estructura post-FASE-2

## Auto-CoT: Razonamiento

### Para procedimientos/README.md
```
Procedimiento en infraestructura significa: procesos documentados para ejecutar tareas
Archivo actual: PROCED-INFRA-001-provision-vm-vagrant.md
Contenido deseado: Descripción clara + tabla de procedimientos + guía de uso
```

### Para devops/README.md
```
DevOps en contexto: automatización CI/CD + IaC + runbooks
Enlaces actuales: parcialmente correctos pero algunos caminos rotos
Contenido deseado: Estructura de pipelines + ejemplos + referencias
```

### Para checklists/README.md
```
Checklists en contexto: listas de verificación operacionales
Estado: parcialmente completo con secciones de "Acciones prioritarias"
Contenido deseado: completar cada acción con estimaciones + asignación
```

### Para solicitudes/README.md
```
Solicitudes en infraestructura: cambios, provisiones, upgrades
Archivo actual: vacío ("En desarrollo")
Contenido deseado: Tipos de solicitud + proceso + ejemplos
```
