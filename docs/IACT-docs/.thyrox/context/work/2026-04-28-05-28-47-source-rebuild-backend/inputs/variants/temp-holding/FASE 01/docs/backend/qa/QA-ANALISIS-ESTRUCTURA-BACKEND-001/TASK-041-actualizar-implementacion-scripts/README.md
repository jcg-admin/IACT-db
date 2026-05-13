# TASK-041: Actualizar IMPLEMENTACION-SCRIPTS.md

## Información General
- **Fase**: FASE 3 - Trazabilidad
- **Duración Estimada**: 20 minutos
- **Prioridad**: MEDIA
- **Tipo**: Actualización de Documentación
- **Metodología**: Auto-CoT + Self-Consistency

## Objetivo
Actualizar el documento IMPLEMENTACION-SCRIPTS.md con los nuevos scripts y herramientas creados durante la FASE 3, manteniendo trazabilidad de automatizaciones.

## Auto-CoT: Razonamiento en Cadena

### Paso 1: Inventario de Scripts Existentes
**Pregunta**: ¿Qué scripts existen actualmente en IMPLEMENTACION-SCRIPTS.md?
**Razonamiento**:
- Leer documento actual (si existe)
- Identificar scripts ya documentados
- Verificar si están actualizados
- Identificar scripts obsoletos

### Paso 2: Nuevos Scripts de FASE 3
**Pregunta**: ¿Qué scripts se crearon o planificaron en FASE 3?
**Razonamiento**:
- Scripts de generación de catálogos
- Scripts de validación de procesos
- Scripts de generación de matrices
- Scripts de automatización de trazabilidad

### Paso 3: Actualización del Documento
**Pregunta**: ¿Cómo actualizar el documento manteniendo coherencia?
**Razonamiento**:
- Agregar nuevos scripts a secciones apropiadas
- Actualizar índice y estadísticas
- Mantener formato consistente
- Documentar dependencias

## Self-Consistency: Validación Cruzada

### Verificación 1: Completitud
- ¿Todos los scripts nuevos están documentados?
- ¿Se incluye información de uso para cada script?
- ¿Se documentaron dependencias?

### Verificación 2: Coherencia
- ¿El formato es consistente con scripts existentes?
- ¿La categorización es apropiada?
- ¿Las referencias son correctas?

### Verificación 3: Utilidad
- ¿La documentación permite usar los scripts?
- ¿Se incluyen ejemplos?
- ¿Se documentan errores comunes?

## Estructura de Actualización

### Scripts a Agregar/Actualizar

#### 1. Scripts de Catalogación
```bash
# scripts/backend/generate-api-catalog.sh
# Genera catálogo de APIs del backend
# Uso: ./scripts/backend/generate-api-catalog.sh
# Output: docs/backend/catalogos/CATALOGO-APIs.md
```

```bash
# scripts/backend/generate-services-catalog.sh
# Genera catálogo de servicios del backend
# Uso: ./scripts/backend/generate-services-catalog.sh
# Output: docs/backend/catalogos/CATALOGO-SERVICIOS.md
```

```bash
# scripts/backend/generate-models-catalog.sh
# Genera catálogo de modelos de datos
# Uso: ./scripts/backend/generate-models-catalog.sh
# Output: docs/backend/catalogos/CATALOGO-MODELOS.md
```

```bash
# scripts/backend/generate-endpoints-catalog.sh
# Genera catálogo de endpoints REST
# Uso: ./scripts/backend/generate-endpoints-catalog.sh
# Output: docs/backend/catalogos/CATALOGO-ENDPOINTS.md
```

#### 2. Scripts de Validación de Procesos
```bash
# scripts/backend/validate-processes.sh
# Valida que procesos documentados cumplan estándares
# Uso: ./scripts/backend/validate-processes.sh [proceso]
# Output: Reporte de validación en stdout
```

```bash
# scripts/backend/check-process-links.sh
# Verifica que links en documentos de procesos funcionen
# Uso: ./scripts/backend/check-process-links.sh
# Output: Lista de links rotos
```

#### 3. Scripts de Trazabilidad
```bash
# scripts/backend/generate-requirements-tests-matrix.sh
# Genera matriz de trazabilidad requisitos-tests
# Uso: ./scripts/backend/generate-requirements-tests-matrix.sh
# Output: docs/backend/trazabilidad/MATRIZ-requisitos-tests.md
```

```bash
# scripts/backend/generate-requirements-code-matrix.sh
# Genera matriz de trazabilidad requisitos-código
# Uso: ./scripts/backend/generate-requirements-code-matrix.sh
# Output: docs/backend/trazabilidad/MATRIZ-requisitos-codigo.md
```

```bash
# scripts/backend/analyze-coverage-gaps.sh
# Analiza gaps de cobertura entre requisitos y tests
# Uso: ./scripts/backend/analyze-coverage-gaps.sh
# Output: Reporte de gaps con priorización
```

#### 4. Scripts de Actualización Automática
```bash
# scripts/backend/update-process-index.sh
# Actualiza INDICE_PROCESOS.md automáticamente
# Uso: ./scripts/backend/update-process-index.sh
# Output: INDICE_PROCESOS.md actualizado
```

```bash
# scripts/backend/update-catalog-stats.sh
# Actualiza estadísticas en catálogos
# Uso: ./scripts/backend/update-catalog-stats.sh
# Output: Catálogos con estadísticas actualizadas
```

## Contenido de Actualización para IMPLEMENTACION-SCRIPTS.md

### Sección Nueva: Scripts de FASE 3

```markdown
## Scripts de Catalogación (FASE 3)

### generate-api-catalog.sh
**Ubicación**: `scripts/backend/generate-api-catalog.sh`
**Propósito**: Genera catálogo automático de todas las APIs utilizadas en el backend
**Creado**: 2025-11-18
**Mantenedor**: QA Team

**Uso:**
```bash
./scripts/backend/generate-api-catalog.sh [options]

Options:
 --output FILE Output file path (default: docs/backend/catalogos/CATALOGO-APIs.md)
 --format FORMAT Output format: markdown|json|html (default: markdown)
 --verbose Verbose output
```

**Dependencias:**
- Python 3.9+
- jq
- grep
- Backend codebase en /backend

**Output:**
- CATALOGO-APIs.md con tabla de APIs
- APIs clasificadas por tipo
- Configuración requerida por API

**Ejemplo:**
```bash
# Generar catálogo en ubicación por defecto
./scripts/backend/generate-api-catalog.sh

# Generar en formato JSON
./scripts/backend/generate-api-catalog.sh --format json --output apis.json
```

---

### generate-services-catalog.sh
**Ubicación**: `scripts/backend/generate-services-catalog.sh`
**Propósito**: Genera catálogo de servicios del backend con sus responsabilidades
**Creado**: 2025-11-18
**Mantenedor**: QA Team

**Uso:**
```bash
./scripts/backend/generate-services-catalog.sh [options]

Options:
 --output FILE Output file path
 --analyze-deps Analizar dependencias entre servicios
 --graph Generar grafo de dependencias (requiere graphviz)
```

**Dependencias:**
- Python 3.9+
- graphviz (opcional, para --graph)
- Backend codebase

**Output:**
- CATALOGO-SERVICIOS.md con servicios clasificados
- Opcionalmente: grafo de dependencias (services-deps.png)

---

### generate-models-catalog.sh
**Ubicación**: `scripts/backend/generate-models-catalog.sh`
**Propósito**: Genera catálogo de modelos ORM con campos y relaciones
**Creado**: 2025-11-18
**Mantenedor**: QA Team

**Uso:**
```bash
./scripts/backend/generate-models-catalog.sh [options]

Options:
 --output FILE Output file path
 --erd Generar diagrama ER (requiere graphviz)
 --migrations Validar contra migraciones
```

**Dependencias:**
- Python 3.9+
- Django
- graphviz (opcional)

**Output:**
- CATALOGO-MODELOS.md con estructura de modelos
- Opcionalmente: diagrama ER (models-er.png)

---

### generate-endpoints-catalog.sh
**Ubicación**: `scripts/backend/generate-endpoints-catalog.sh`
**Propósito**: Genera catálogo de endpoints REST del backend
**Creado**: 2025-11-18
**Mantenedor**: QA Team

**Uso:**
```bash
./scripts/backend/generate-endpoints-catalog.sh [options]

Options:
 --output FILE Output file path
 --openapi Generar spec OpenAPI adicional
 --test Verificar endpoints activos
```

**Dependencias:**
- Python 3.9+
- Django
- DRF

**Output:**
- CATALOGO-ENDPOINTS.md con tabla de endpoints
- Opcionalmente: openapi.json

---

## Scripts de Validación (FASE 3)

### validate-processes.sh
**Ubicación**: `scripts/backend/validate-processes.sh`
**Propósito**: Valida que procesos documentados cumplan estándares de calidad
**Creado**: 2025-11-18
**Mantenedor**: QA Team

**Uso:**
```bash
./scripts/backend/validate-processes.sh [proceso] [options]

Arguments:
 proceso Proceso específico a validar (opcional, valida todos si se omite)

Options:
 --checklist Mostrar checklist de validación
 --report FILE Guardar reporte en archivo
 --strict Modo estricto (falla con warnings)
```

**Validaciones:**
- Metadata completo
- Estructura correcta
- Links funcionando
- Ejemplos ejecutables
- Diagrams válidos

**Output:**
- Reporte de validación en stdout
- Exit code 0 si OK, 1 si falla

**Ejemplo:**
```bash
# Validar todos los procesos
./scripts/backend/validate-processes.sh

# Validar proceso específico
./scripts/backend/validate-processes.sh PROC-BACK-001

# Generar reporte
./scripts/backend/validate-processes.sh --report validation-report.md
```

---

### check-process-links.sh
**Ubicación**: `scripts/backend/check-process-links.sh`
**Propósito**: Verifica que todos los links en procesos funcionen
**Creado**: 2025-11-18
**Mantenedor**: QA Team

**Uso:**
```bash
./scripts/backend/check-process-links.sh [options]

Options:
 --external Verificar también links externos (más lento)
 --fix Intentar corregir links rotos automáticamente
 --report FILE Guardar reporte de links rotos
```

**Dependencias:**
- grep
- curl (si --external)

**Output:**
- Lista de links rotos
- Exit code 0 si OK, 1 si hay links rotos

---

## Scripts de Trazabilidad (FASE 3)

### generate-requirements-tests-matrix.sh
**Ubicación**: `scripts/backend/generate-requirements-tests-matrix.sh`
**Propósito**: Genera matriz de trazabilidad entre requisitos y tests
**Creado**: 2025-11-18
**Mantenedor**: QA Team

**Uso:**
```bash
./scripts/backend/generate-requirements-tests-matrix.sh [options]

Options:
 --requirements FILE Archivo de requisitos (default: docs/requirements.md)
 --tests-dir DIR Directorio de tests (default: backend/tests)
 --output FILE Output file
 --format FORMAT markdown|json|csv
```

**Dependencias:**
- Python 3.9+
- pytest
- coverage

**Output:**
- MATRIZ-requisitos-tests.md
- Estadísticas de cobertura
- Gaps identificados

**Ejemplo:**
```bash
# Generar matriz por defecto
./scripts/backend/generate-requirements-tests-matrix.sh

# Generar en formato CSV
./scripts/backend/generate-requirements-tests-matrix.sh --format csv
```

---

### generate-requirements-code-matrix.sh
**Ubicación**: `scripts/backend/generate-requirements-code-matrix.sh`
**Propósito**: Genera matriz de trazabilidad entre requisitos e implementación
**Creado**: 2025-11-18
**Mantenedor**: QA Team

**Uso:**
```bash
./scripts/backend/generate-requirements-code-matrix.sh [options]

Options:
 --requirements FILE Archivo de requisitos
 --code-dir DIR Directorio de código fuente
 --output FILE Output file
 --analyze-impact Incluir análisis de impacto
```

**Dependencias:**
- Python 3.9+
- radon (para complejidad)
- ast (parsing de código)

**Output:**
- MATRIZ-requisitos-codigo.md
- Análisis de impacto (si --analyze-impact)

---

### analyze-coverage-gaps.sh
**Ubicación**: `scripts/backend/analyze-coverage-gaps.sh`
**Propósito**: Analiza gaps de cobertura entre requisitos, tests y código
**Creado**: 2025-11-18
**Mantenedor**: QA Team

**Uso:**
```bash
./scripts/backend/analyze-coverage-gaps.sh [options]

Options:
 --requirements FILE Archivo de requisitos
 --report FILE Output report file
 --prioritize Priorizar gaps por criticidad
```

**Output:**
- Reporte de gaps
- Requisitos sin tests
- Requisitos sin implementación
- Tests sin requisitos
- Priorización de gaps

**Ejemplo:**
```bash
./scripts/backend/analyze-coverage-gaps.sh --prioritize --report gaps-report.md
```

---

## Scripts de Automatización (FASE 3)

### update-process-index.sh
**Ubicación**: `scripts/backend/update-process-index.sh`
**Propósito**: Actualiza INDICE_PROCESOS.md automáticamente
**Creado**: 2025-11-18
**Mantenedor**: QA Team

**Uso:**
```bash
./scripts/backend/update-process-index.sh [options]

Options:
 --dry-run Mostrar cambios sin aplicar
 --verify Verificar integridad después de actualizar
```

**Funcionalidad:**
- Escanea directorio de procesos
- Extrae metadata de cada proceso
- Actualiza índice automáticamente
- Recalcula estadísticas

**Dependencias:**
- Python 3.9+
- PyYAML (para metadata)

---

### update-catalog-stats.sh
**Ubicación**: `scripts/backend/update-catalog-stats.sh`
**Propósito**: Actualiza estadísticas en catálogos existentes
**Creado**: 2025-11-18
**Mantenedor**: QA Team

**Uso:**
```bash
./scripts/backend/update-catalog-stats.sh [catalog] [options]

Arguments:
 catalog Catálogo específico a actualizar (opcional)

Options:
 --all Actualizar todos los catálogos
 --verify Verificar estadísticas antes de actualizar
```

**Output:**
- Catálogos con estadísticas actualizadas
- Reporte de cambios

---

## Estadísticas Actualizadas

### Total de Scripts: 20 (+10 nuevos en FASE 3)

| Categoría | Scripts | % del Total |
|-----------|---------|-------------|
| Catalogación | 4 | 20% |
| Validación | 2 | 10% |
| Trazabilidad | 3 | 15% |
| Automatización | 2 | 10% |
| Testing | 3 | 15% |
| Deployment | 4 | 20% |
| Utilidades | 2 | 10% |

### Scripts por Mantenibilidad

| Nivel | Scripts | Descripción |
|-------|---------|-------------|
| Alta | 14 | Bien documentados, con tests |
| Media | 4 | Documentados, sin tests |
| Baja | 2 | Documentación mínima |

## Próximos Scripts Planificados

- [ ] `generate-architecture-diagram.sh`: Generar diagramas de arquitectura
- [ ] `audit-dependencies-security.sh`: Auditoría automática de dependencias
- [ ] `performance-baseline.sh`: Establecer baseline de performance
- [ ] `api-compatibility-check.sh`: Verificar compatibilidad de API

## Referencias
- scripts/backend/
- docs/backend/qa/
- docs/backend/procesos/
- docs/backend/catalogos/
```

## Proceso de Actualización

### Paso 1: Leer Documento Actual (5 minutos)
```bash
# Verificar si existe
ls -la docs/backend/IMPLEMENTACION-SCRIPTS.md

# Leer contenido actual
cat docs/backend/IMPLEMENTACION-SCRIPTS.md
```

### Paso 2: Agregar Nuevas Secciones (10 minutos)
- Copiar secciones preparadas arriba
- Insertar en ubicación apropiada
- Mantener formato consistente
- Actualizar tabla de contenidos

### Paso 3: Actualizar Estadísticas (3 minutos)
- Recalcular totales
- Actualizar porcentajes
- Agregar nuevas categorías si necesario

### Paso 4: Validar Actualización (2 minutos)
- Verificar formato markdown
- Probar links internos
- Verificar coherencia

## Entregables
- [ ] IMPLEMENTACION-SCRIPTS.md actualizado
- [ ] 10 nuevos scripts documentados
- [ ] Estadísticas actualizadas
- [ ] Formato consistente mantenido
- [ ] Validación completada

## Criterios de Aceptación
1. [OK] Todos los scripts de FASE 3 documentados
2. [OK] Formato consistente con scripts existentes
3. [OK] Ejemplos de uso incluidos
4. [OK] Dependencias especificadas
5. [OK] Estadísticas actualizadas
6. [OK] Referencias correctas

## Notas
- Si IMPLEMENTACION-SCRIPTS.md no existe, crearlo con estructura completa
- Mantener orden lógico de secciones
- Incluir ejemplos ejecutables cuando sea posible
- Documentar errores comunes y soluciones
