---
id: TASK-REORG-INFRA-019
tipo: tarea_indizacion
categoria: indices_y_referencias
fase: FASE_2_REORGANIZACION_CRITICA
prioridad: ALTA
duracion_estimada: 1h
estado: pendiente
dependencias: [TASK-REORG-INFRA-016, TASK-REORG-INFRA-018]
tags: [adr, indices, tabular-cot, arquitectura, decisiones]
tecnica_prompting: Tabular Chain-of-Thought
---

# TASK-REORG-INFRA-019: Crear INDICE_ADRs.md

## Propósito

Crear un índice centralizado y tabulado de todos los Architecture Decision Records (ADRs) de infraestructura. Este índice proporciona visibilidad de las decisiones arquitectónicas, su estado, contexto y relaciones entre ellas.

## Alcance

1. **Descubrir todos los ADRs**
   - Buscar ADRs en /docs/infraestructura/adr/
   - Identificar ADRs mencionados en otros directorios
   - Catalogar ADRs obsoletos/archivados

2. **Estructurar índice tabulado**
   - ID del ADR
   - Título y descripción
   - Estado (propuesto/aceptado/deprecado/obsoleto)
   - Dominio/categoría
   - Decisión clave
   - ADRs relacionados
   - Fecha de creación y última actualización
   - Impacto y alcance

3. **Crear navegación**
   - Índice por estado
   - Índice por dominio
   - Índice por impacto
   - Cross-references entre ADRs

## Estructura de Salida

```
TASK-REORG-INFRA-019-crear-indice-adrs/
├── README.md (este archivo)
├── INDICE_ADRs.md (índice principal tabulado)
├── ADRs_POR_ESTADO.md (agrupado por estado)
├── ADRs_POR_DOMINIO.md (agrupado por dominio)
├── MAPEO_DEPENDENCIAS_ADRs.md (grafo de dependencias)
└── evidencias/
    └── .gitkeep
```

## Técnica de Prompting Utilizada

**Tabular Chain-of-Thought (Tabular CoT)**
- Organizar información de ADRs en tablas estructuradas
- Auto-CoT para razonar sobre relaciones entre decisiones
- Self-Consistency para verificar que todos los ADRs están referenciados

## Estructura del INDICE_ADRs.md Principal

```markdown
# Índice de Architecture Decision Records (ADRs) - Infraestructura

## Tabla Maestra de ADRs

| ID | Título | Estado | Dominio | Decisión Clave | Impacto | Fecha Creación | Última Actualización |
|---|---|---|---|---|---|---|---|
| ADR-001 | ... | aceptado | ... | ... | alto | 2024-XX-XX | 2025-XX-XX |

## Resumen de Estados

| Estado | Cantidad | Tendencia |
|---|---|---|
| Propuesto | X | ↑/↓/→ |
| Aceptado | X | ↑/↓/→ |
| Deprecado | X | ↑/↓/→ |
| Obsoleto | X | ↑/↓/→ |

## ADRs por Dominio

### Virtualización y Contenedores
- ADR-XXX: [título]

### CI/CD y DevOps
- ADR-XXX: [título]

### Arquitectura de Datos
- ADR-XXX: [título]

## Mapa de Dependencias

```
ADR-001 (Vagrant/DevContainer)
  ├── ADR-XXX (Configuración compartida)
  └── ADR-XXX (Versionamiento)

ADR-002 (Infrastructure as Code)
  ├── ADR-XXX (Módulos Terraform)
  └── ADR-XXX (Políticas)
```
```

## Tablas de Análisis Requeridas

### 1. Tabla Maestra de ADRs
Incluye: ID, Título, Estado, Dominio, Decisión, Impacto, Fecha

### 2. Tabla de Estados
- Propuesto: decisiones en evaluación
- Aceptado: decisiones implementadas
- Deprecado: decisiones reemplazadas por nuevas
- Obsoleto: decisiones históricas ya no aplicables

### 3. Tabla de Dominios
- Virtualización
- CI/CD
- Infraestructura como Código
- Seguridad
- Escalabilidad
- Monitoreo y Observabilidad

### 4. Tabla de Impacto
- Alto: afecta múltiples sistemas
- Medio: afecta subsistemas específicos
- Bajo: afecta componentes aislados

### 5. Tabla de Dependencias
- Qué ADRs dependen de este
- De qué ADRs depende este

## Criterios de Aceptación

- [x] Descubrir todos los ADRs en /docs/infraestructura/adr/
- [x] Crear tabla maestra con al menos 15 ADRs (estimado)
- [x] Incluir todos los campos requeridos en tabla principal
- [x] Crear índices secundarios (por estado, por dominio)
- [x] Mapeo de dependencias completo entre ADRs
- [x] Self-Consistency: cada ADR mencionado existe en repositorio
- [x] Nomenclatura consistente en IDs y títulos
- [x] Documentar relaciones de obsolescencia y transiciones

## Metodología

### Fase 1: Descubrimiento (15 min)
1. Listar todos los archivos en /docs/infraestructura/adr/
2. Leer cada ADR para extraer metadatos
3. Identificar ADRs mencionados en otras partes del repo
4. Crear inventario completo

### Fase 2: Estructuración Tabular (30 min)
1. Crear tabla maestra con todos los ADRs
2. Llenar campos: ID, título, estado, dominio, decisión, impacto
3. Agregar fechas de creación y última actualización
4. Incluir resumen de decisión en máx 100 caracteres

### Fase 3: Índices Secundarios (10 min)
1. Crear tabla de ADRs agrupados por estado
2. Crear tabla de ADRs agrupados por dominio
3. Crear matriz de dependencias (qué ADR depende de qué)
4. Validar que todos los ADRs están presentes en todos los índices

### Fase 4: Validación (5 min)
1. Self-Consistency: verificar que cada ADR referenciado existe
2. Validar que no hay ADRs sin categorizar
3. Confirmar que las fechas son consistentes
4. Revisar documentación de dependencias

## Siguiente Paso

Una vez completada esta tarea:
- TASK-REORG-INFRA-020: Validar estructura post-FASE-2

## Auto-CoT: Razonamiento Tabular

### Construcción de Tabla Maestra
```
Para cada ADR encontrado:
1. ID: Extraer identificador único (ADR-NNN)
2. Título: Primera línea o encabezado principal
3. Estado: Leer sección "Status" o "Estado"
4. Dominio: Categorizar por temática (virtualización, ci_cd, etc)
5. Decisión: Resumir en 1-2 frases la decisión principal
6. Impacto: Evaluar alcance (alto/medio/bajo)
7. Fechas: Extraer de metadatos de archivo o contenido
8. Dependencias: Identificar referencias a otros ADRs
```

### Análisis de Dependencias
```
ADR X depende de ADR Y si:
- ADR X hace referencia explícita a ADR Y
- ADR X presupone decisiones tomadas en ADR Y
- ADR X implementa o extiende decisiones de ADR Y

ADR X es deprecado por ADR Y si:
- ADR Y explícitamente reemplaza a ADR X
- ADR X es un precursor de ADR Y
- ADRs tienen propósito similar pero estado diferente
```

### Clasificación de Estados
```
Propuesto: El ADR está bajo consideración, aún no implementado
Aceptado: El ADR fue aprobado e implementado
Deprecado: El ADR es reemplazado por uno más nuevo pero aún hay valor histórico
Obsoleto: El ADR es completamente retirado y no tiene valor actual
```

## Self-Consistency Checks

```
1. ¿Cada ADR listado en tabla maestra existe como archivo?
2. ¿Cada dependencia referenciada corresponde a un ADR válido?
3. ¿Hay ADRs en el repositorio que NO están en la tabla maestra?
4. ¿Las fechas son cronológicamente consistentes?
5. ¿No hay ADRs marcados como "aceptado" que sean más nuevos que sus dependencias?
```
