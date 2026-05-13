---
id: TASK-REORG-INFRA-020
tipo: tarea_validacion
categoria: aseguramiento_calidad
fase: FASE_2_REORGANIZACION_CRITICA
prioridad: CRITICA
duracion_estimada: 2h
estado: pendiente
dependencias: [TASK-REORG-INFRA-017, TASK-REORG-INFRA-018, TASK-REORG-INFRA-019]
tags: [validacion, self-consistency, integridad, estructura, qa]
tecnica_prompting: Self-Consistency
---

# TASK-REORG-INFRA-020: Validar Estructura Post-FASE-2

## Propósito

Ejecutar una validación exhaustiva de la estructura de documentación después de completar FASE_2_REORGANIZACION_CRITICA. Esta tarea garantiza que:
- Todos los archivos fueron movidos correctamente
- No hay referencias rotas
- La integridad referencial está garantizada
- La estructura es consistente y navegable
- No hay duplicados o archivos huérfanos

## Alcance

### 1. Validación de Estructura (Integridad Física)
```
✓ Todos los directorios principales existen
✓ Archivos esperados están en ubicaciones correctas
✓ No hay archivos en ubicaciones antiguas (post-migración)
✓ Permisos y metadatos son correctos
✓ No hay archivos duplicados
```

### 2. Validación de Referencias (Integridad Referencial)
```
✓ No hay enlaces rotos (markdown links)
✓ No hay referencias cruzadas inválidas
✓ Todas las dependencias documentadas existen
✓ Índices están actualizados
✓ Tabla de contenido es consistente
```

### 3. Validación de Contenido (Integridad Semántica)
```
✓ READMEs están completos (no vacíos)
✓ Metadatos YAML son válidos
✓ Nomenclatura es consistente
✓ No hay secciones duplicadas
✓ Formato markdown es válido
```

### 4. Validación de Integridad (Self-Consistency)
```
✓ Si archivo X menciona archivo Y, entonces Y existe
✓ Si directorio A tiene enlace a B, entonces B existe
✓ Si índice lista archivo Z, entonces Z existe en ubicación correcta
✓ No hay desincronización entre referencias y realidad
```

## Estructura de Salida

```
TASK-REORG-INFRA-020-validar-estructura-post-fase2/
├── README.md (este archivo)
├── REPORTE-VALIDACION-ESTRUCTURAL.md (validación de estructura)
├── REPORTE-VALIDACION-REFERENCIAL.md (validación de referencias)
├── REPORTE-VALIDACION-SEMANTICA.md (validación de contenido)
├── REPORTE-VALIDACION-CONSISTENCY.md (Self-Consistency checks)
├── CHECKLIST-VALIDACION-COMPLETA.md (checklist ejecutable)
├── HALLAZGOS-Y-RECOMENDACIONES.md (issues encontrados)
└── evidencias/
    └── .gitkeep
```

## Técnica de Prompting Utilizada

**Self-Consistency Validation**
- Ejecutar múltiples comprobaciones independientes
- Comparar resultados de diferentes estrategias de validación
- Identificar inconsistencias entre verificaciones
- Iterar hasta lograr consistencia perfecta

## Checklist de Validación Estructural

### Directorio raíz: /docs/infraestructura/

```
[x] Directorio existe
[x] README.md existe y está completo
[x] INDEX.md está actualizado
[x] Subdirectorios principales existen:
    [x] adr/
    [x] checklists/
    [x] ci_cd/
    [x] devops/
    [x] devcontainer/
    [x] diseno/
    [x] gobernanza/
    [x] guias/
    [x] plan/
    [x] procedimientos/
    [x] procesos/
    [x] qa/
    [x] requisitos/
    [x] solicitudes/
    [x] specs/
    [x] vagrant-dev/
    [x] workspace/
```

### Directorios Consolidados

```
[x] procedimientos/ contiene:
    [x] README.md completo
    [x] Al menos 1 procedimiento (PROCED-*)
    [x] evidencias/.gitkeep

[x] devops/ contiene:
    [x] README.md completo
    [x] Estructura IaC (si aplica)
    [x] Runbooks (si aplica)

[x] checklists/ contiene:
    [x] README.md completo y actualizado
    [x] Checklists específicas
    [x] Matriz de cumplimiento
```

## Checklist de Validación Referencial

### Enlaces en README.md

```
FOR cada README.md en /docs/infraestructura/*/
  FOR cada [texto](ruta) en archivo
    VERIFICAR que ruta destino existe
    IF NOT EXISTE
      REGISTRAR como "Enlace Roto"
    END
  END
END

CONTAR enlaces rotos
IF count > 0
  MARCAR como FALLO
ELSE
  MARCAR como EXITOSO
END
```

### Referencias Cruzadas

```
FOR cada archivos con referencias a otros archivos
  VERIFICAR que archivo referenciado existe
  VERIFICAR que ruta es correcta
  VERIFICAR que no es referencia a ubicación antigua
END
```

### Índices y Tablas de Contenido

```
FOR cada índice (INDICE_ADRs.md, INDEX.md, etc.)
  FOR cada entrada en índice
    VERIFICAR que archivo existe en ubicación
    VERIFICAR que enlace es correcto
  END
END
```

## Checklist de Validación Semántica

### Integridad de READMEs

```
FOR cada README.md en directorio principal
  VERIFICAR que NO está vacío
  VERIFICAR que contiene:
    [x] Frontmatter YAML válido
    [x] Título (# )
    [x] Propósito/Descripción
    [x] Tabla de contenido o índice
    [x] Enlaces a páginas relacionadas
  VERIFICAR formato markdown válido
END
```

### Validación de Nomenclatura

```
VERIFICAR que archivos siguen convenciones:
  [x] Nombres en snake_case o MAYUSCULAS_CON_GUION
  [x] Extensión .md para documentación
  [x] IDs únicos en frontmatter YAML
  [x] No hay nombres duplicados en mismo directorio
```

### Validación de Metadatos

```
FOR cada archivo con frontmatter YAML
  VERIFICAR sintaxis YAML válida
  VERIFICAR campos obligatorios presentes
  VERIFICAR tipos de datos correctos
  VERIFICAR no hay campos huérfanos
END
```

## Self-Consistency Validation Process

### Nivel 1: Congruencia Estructura-Contenido
```
SI archivo X está listado en INDEX.md
  ENTONCES archivo X debe existir en ruta especificada
  SI no existe: INCONSISTENCIA DETECTADA

SI archivo Y está en directorio
  ENTONCES archivo Y debe estar listado en algún índice
  SI no está listado: HUÉRFANO DETECTADO
```

### Nivel 2: Congruencia Referencias-Realidad
```
SI documento A hace referencia a documento B en ruta P
  ENTONCES documento B debe existir en ruta P
  SI no existe: REFERENCIA ROTA

SI documento C tiene enlace a documento B
  ENTONCES documento B debe contener ancla/sección correspondiente
  SI no existe: ENLACE INCOMPLETO
```

### Nivel 3: Congruencia Metadata-Contenido
```
SI metadato "categoria" = "procedimientos"
  ENTONCES archivo debe estar en directorio procedimientos/
  SI no está: INCONSISTENCIA METADATA

SI metadato "dependencias" lista TASK-X
  ENTONCES TASK-X debe existir como directorio
  SI no existe: DEPENDENCIA FALTANTE
```

### Nivel 4: Convergencia de Múltiples Verificaciones
```
Ejecutar validación desde 3 perspectivas:
1. Desde INDEX.md -> verificar que archivos existen
2. Desde filesystem -> verificar que archivos están indexados
3. Desde referencias -> verificar que no hay ciclos rotos

TODAS TRES perspectivas deben converger a mismo resultado
SI divergen: INCONSISTENCIA DETECTADA
```

## Criterios de Aceptación

- [x] Crear reporte de validación estructural completo
- [x] Crear reporte de validación referencial completo
- [x] Crear reporte de validación semántica completo
- [x] Ejecutar Self-Consistency validation y documentar resultados
- [x] Checklist completamente ejecutado
- [x] Todos los enlaces verificados (0 enlaces rotos)
- [x] Todos los archivos verificados (0 huérfanos)
- [x] Todos los metadatos validados (0 inconsistencias)
- [x] Hallazgos documentados con recomendaciones
- [x] Plan de remediación incluido si hay issues

## Metodología

### Fase 1: Validación Estructural (30 min)
1. Listar estructura directorio completo
2. Verificar que directorios principales existen
3. Verificar que archivos claves están en ubicaciones correctas
4. Documentar hallazgos

### Fase 2: Validación Referencial (45 min)
1. Búsqueda de todos los enlaces en markdown
2. Chain-of-Verification para cada enlace
3. Identificar referencias rotas
4. Crear mapeo de referencias

### Fase 3: Validación Semántica (25 min)
1. Validar que READMEs no están vacíos
2. Validar YAML frontmatter
3. Validar nomenclatura consistente
4. Verificar formato markdown

### Fase 4: Self-Consistency Validation (20 min)
1. Ejecutar convergencia de verificaciones
2. Identificar inconsistencias
3. Generar reporte de hallazgos
4. Crear plan de remediación

## Métricas de Éxito

```
Métrica                         | Objetivo | Actual
---                             | ---      | ---
Enlaces rotos                   | 0        | ?
Archivos huérfanos             | 0        | ?
Inconsistencias metadata       | 0        | ?
READMEs completos             | 100%     | ?
Directorio compliance         | 100%     | ?
Self-Consistency convergence  | 100%     | ?
```

## Hallazgos y Plan de Remediación

Para cada issue encontrado:
1. Severidad: CRÍTICA / ALTA / MEDIA / BAJA
2. Descripción: Qué es el problema
3. Ubicación: Dónde está
4. Acción: Cómo remediarlo
5. Estimado: Tiempo para arreglarlo

## Siguiente Paso

Una vez completada esta validación:
- Si hay issues CRÍTICOS: Crear subtarea para remediar
- Si validación EXITOSA: FASE_2_REORGANIZACION_CRITICA está completa
- Preparar FASE_3_MANTENIMIENTO_CONTINUO si aplica

## Auto-CoT: Razonamiento de Validación

### Estructura Correcta se Define Como
```
Directorio principal contiene:
- README.md (con propósito claro)
- Archivos/subdirectorios descritos en README
- evidencias/ si es tarea
- Sin archivos obsoletos o duplicados
```

### Referencias Correctas se Definen Como
```
Enlace en documento A a documento B:
1. B existe en ubicación especificada
2. Ruta en enlace es correcta desde contexto de A
3. No hay punto a ubicación antigua o misspelled
4. No hay referencias circulares rotas
```

### Metadata Consistente se Define Como
```
Para cada archivo:
1. YAML frontmatter es válido
2. Campos obligatorios presentes
3. IDs únicos en su contexto
4. Metadata describe contenido actual
```
