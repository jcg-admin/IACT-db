---
id: TASK-REORG-INFRA-018
tipo: tarea_integracion
categoria: enlaces_y_referencias
fase: FASE_2_REORGANIZACION_CRITICA
prioridad: ALTA
duracion_estimada: 3h
estado: pendiente
dependencias: [TASK-REORG-INFRA-016, TASK-REORG-INFRA-017]
tags: [enlaces, referencias, integridad, chain-of-verification, migracion]
tecnica_prompting: Chain-of-Verification
---

# TASK-REORG-INFRA-018: Actualizar Enlaces en Archivos Movidos

## Propósito

Identificar y actualizar todos los enlaces internos (markdown links) que se rompieron como resultado de los movimientos de archivos ejecutados en FASE_2_REORGANIZACION_CRITICA. Esta tarea garantiza la integridad referencial del repositorio de documentación.

## Alcance

1. **Identificar enlaces rotos**
   - Buscar referencias a ubicaciones antiguas de archivos
   - Detectar broken links en markdown
   - Crear inventario de enlaces a actualizar

2. **Actualizar referencias** en:
   - README.md files en todos los directorios afectados
   - Archivos ADR (Architecture Decision Records)
   - Documentos de planificación
   - Guías y procedimientos
   - Índices y tablas de contenido

3. **Validar integridad**
   - Chain-of-Verification: Verificar que cada enlace apunta a un archivo existente
   - Self-Consistency: Verificar que no hay referencias pendientes sin actualizar
   - Documentar todas las actualizaciones realizadas

## Estructura de Salida

```
TASK-REORG-INFRA-018-actualizar-enlaces-archivos-movidos/
├── README.md (este archivo)
├── INVENTARIO-ENLACES-ROTOS.md (lista de enlaces rotos encontrados)
├── MAPEO-REFERENCIAS-ANTIGUAS-NUEVAS.md (mapeo old_path -> new_path)
├── ACTUALIZACIONES-REALIZADAS.md (registro de cada cambio)
├── VALIDACION-CADENA-VERIFICACION.md (reporte de Chain-of-Verification)
└── evidencias/
    └── .gitkeep
```

## Técnica de Prompting Utilizada

**Chain-of-Verification (CoV)**
- Paso 1: Identificar cada enlace roto
- Paso 2: Verificar que la ubicación destino existe
- Paso 3: Actualizar el enlace
- Paso 4: Verificar que el nuevo enlace es accesible
- Repetir para cada referencia encontrada
- Validar Self-Consistency al final

## Patrones de Enlaces a Buscar

```
[texto](../antigua-ubicacion/archivo.md)
[texto](docs/infraestructura/old_path/file.md)
[enlace]: ../antigua/archivo.md
require/import referencias en comentarios de código
referencias en archivos YAML (dependencias, referencias)
```

## Chain-of-Verification: Proceso Detallado

### Paso 1: Descubrimiento
```
FOR cada archivo.md en docs/infraestructura/
  SCAN línea por línea buscando patrones de enlace
  REGISTRAR enlace encontrado
  EXTRAER ruta destino
END
```

### Paso 2: Validación de Existencia
```
FOR cada enlace en registro
  RESOLVE ruta destino relativa a ubicación actual
  IF archivo_destino NO EXISTE
    REGISTRAR como "Enlace Roto"
    BUSCAR ubicación nueva del archivo
    IF ubicación_nueva ENCONTRADA
      REGISTRAR mapeo: old -> new
    END
  END
END
```

### Paso 3: Actualización
```
FOR cada mapeo old -> new encontrado
  LOAD archivo_origen
  REEMPLAZAR ALL referencias old_path con new_path
  GUARDAR archivo_origin
  REGISTRAR cambio en ACTUALIZACIONES-REALIZADAS.md
END
```

### Paso 4: Verificación Final
```
FOR cada enlace actualizado
  CARGAR archivo referenciador
  EXTRAER ruta de destino
  VERIFICAR que archivo_destino EXISTE
  REGISTRAR resultado ("OK" o "FALLO")
END

IF todos los resultados = "OK"
  MARCAR como COMPLETADO
ELSE
  REGISTRAR FALLOS para investigación manual
END
```

## Categorías de Enlaces a Actualizar

### 1. Referencias en README.md (ALTA PRIORIDAD)
- Enlaces de "Página padre"
- Enlaces de "Páginas hijas"
- Enlaces en "Relacionados"

### 2. Referencias en ADRs
- Enlaces a decisiones previas
- Enlaces a guías aplicables
- Referencias a especificaciones

### 3. Referencias en Procedimientos
- Enlaces a prerequisitos
- Enlaces a checklists
- Enlaces a documentación de soporte

### 4. Referencias en Índices
- Todos los enlaces a documentos listados
- Tabla de contenido
- Índices temáticos

## Criterios de Aceptación

- [x] Identificar todos los enlaces rotos (inventario completo)
- [x] Crear mapeo exhaustivo old_path -> new_path
- [x] Actualizar 100% de referencias identificadas
- [x] Chain-of-Verification: verificar cada enlace actualizado
- [x] Self-Consistency: no deben quedar referencias sin actualizar
- [x] Documentar todas las actualizaciones en ACTUALIZACIONES-REALIZADAS.md
- [x] Registro de validación completo en VALIDACION-CADENA-VERIFICACION.md
- [x] Nomenclatura consistente mantenida

## Metodología

### Fase 1: Descubrimiento (45 min)
1. Buscar todos los patrones de enlace en markdown
2. Buscar referencias en archivos YAML
3. Buscar referencias en comentarios de código
4. Generar inventario completo

### Fase 2: Chain-of-Verification (90 min)
1. Para cada enlace: verificar existencia
2. Si roto: localizar nueva ubicación
3. Crear mapeo completo
4. Documentar todas las hallazgos

### Fase 3: Actualización (30 min)
1. Aplicar reemplazos de rutas
2. Registrar cada cambio
3. Verificar que cambios se aplicaron correctamente

### Fase 4: Validación Final (15 min)
1. Verificar cada enlace actualizado
2. Validar Self-Consistency
3. Generar reporte final

## Siguiente Paso

Una vez completada esta tarea:
- TASK-REORG-INFRA-019: Crear INDICE_ADRs.md
- TASK-REORG-INFRA-020: Validar estructura post-FASE-2

## Auto-CoT: Razonamiento

### Identificación de Archivos Movidos
```
Archivos movidos en FASE_2:
- procedimientos/ -> ahora consolidado con procedimientos/
- checklists/ -> referencias cruzadas con otros directorios
- devops/ -> referencias en cicd/ y planificacion/

Patrones a buscar:
- ../procedimientos/ -> ../procedimientos/
- ../checklists/ -> ../checklists/
- ../devops/ -> ../devops/
```

### Estrategia de Verificación
```
Para cada enlace encontrado:
1. Resolver ruta relativa desde ubicación actual
2. Verificar si ruta absoluta resultante existe
3. Si no existe, buscar archivo en nueva ubicación
4. Si nueva ubicación encontrada, registrar mapeo
5. Si no encontrada, marcar para investigación manual
```

### Priorización de Actualizaciones
```
ALTA: README.md en directorios principales (afecta navegación)
ALTA: Enlaces en ADRs y decisiones arquitectónicas
MEDIA: Enlaces en procedimientos y guías
MEDIA: Enlaces en índices
BAJA: Enlaces comentados en código (bajo impacto)
```
