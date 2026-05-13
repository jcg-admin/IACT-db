# TASK-042: Validar Trazabilidad

## Información General
- **Fase**: FASE 3 - Trazabilidad
- **Duración Estimada**: 15 minutos
- **Prioridad**: ALTA
- **Tipo**: Validación/QA
- **Metodología**: Self-Consistency + Verificación Cruzada Múltiple

## Objetivo
Validar que las matrices de trazabilidad (requisitos-tests y requisitos-código) sean completas, consistentes, bidireccionales y útiles para el equipo.

## Self-Consistency: Marco de Validación

### Validación 1: Completitud
**Pregunta**: ¿Las matrices cubren todos los requisitos?
**Verificaciones**:
- Todos los requisitos mapeados
- Todos los tests inventariados
- Todo el código relevante identificado
- No hay elementos huérfanos

### Validación 2: Bidireccionalidad
**Pregunta**: ¿La trazabilidad funciona en ambas direcciones?
**Verificaciones**:
- Requisito → Tests (y viceversa)
- Requisito → Código (y viceversa)
- Referencias consistentes
- No hay referencias rotas

### Validación 3: Coherencia
**Pregunta**: ¿Los datos son internamente coherentes?
**Verificaciones**:
- Estadísticas cuadran
- Clasificaciones son consistentes
- Prioridades alineadas
- Porcentajes suman correctamente

### Validación 4: Utilidad
**Pregunta**: ¿Las matrices son útiles en la práctica?
**Verificaciones**:
- Fácil encontrar tests de un requisito
- Fácil encontrar código de un requisito
- Gaps claramente identificados
- Roadmap es accionable

## Estructura de Validación

### Checklist: MATRIZ-requisitos-tests.md

#### Metadata y Estructura
- [ ] Metadata completo (fecha, versión, owner)
- [ ] Resumen ejecutivo con estadísticas
- [ ] Tabla de contenidos o navegación clara
- [ ] Formato markdown correcto

#### Matriz Principal (Requisitos → Tests)
- [ ] Todos los requisitos listados
- [ ] Cada requisito tiene:
 - [ ] Descripción clara
 - [ ] Prioridad asignada
 - [ ] Status de implementación
 - [ ] Lista de tests que lo cubren
 - [ ] Porcentaje de cobertura
 - [ ] Status de completitud
- [ ] Tests especifican:
 - [ ] ID de test
 - [ ] Tipo (unitario, integración, E2E)
 - [ ] Archivo y línea
 - [ ] Descripción
 - [ ] Status (PASS/FAIL)

#### Matriz Inversa (Tests → Requisitos)
- [ ] Todos los archivos de test listados
- [ ] Cada test referencia requisitos que cubre
- [ ] Referencias bidireccionales consistentes

#### Análisis de Gaps
- [ ] Requisitos sin tests identificados
- [ ] Requisitos con cobertura insuficiente listados
- [ ] Tests huérfanos identificados
- [ ] Gaps priorizados

#### Roadmap y Métricas
- [ ] Roadmap de testing definido
- [ ] Métricas por módulo calculadas
- [ ] Métricas por prioridad calculadas
- [ ] Métricas por tipo de test calculadas
- [ ] Objetivos de cobertura especificados

### Checklist: MATRIZ-requisitos-codigo.md

#### Metadata y Estructura
- [ ] Metadata completo
- [ ] Resumen ejecutivo con estadísticas
- [ ] Navegación clara
- [ ] Formato markdown correcto

#### Matriz Principal (Requisitos → Código)
- [ ] Todos los requisitos implementados listados
- [ ] Cada requisito especifica:
 - [ ] Descripción y prioridad
 - [ ] Status de implementación
 - [ ] Fecha de implementación
 - [ ] Archivos involucrados
 - [ ] Clases principales
 - [ ] Métodos específicos
 - [ ] Líneas de código aproximadas
 - [ ] Dependencias
 - [ ] Complejidad estimada
 - [ ] Cobertura de tests
- [ ] Implementación por capas (modelo, servicio, vista, etc.)

#### Matriz Inversa (Código → Requisitos)
- [ ] Archivos principales listados
- [ ] Cada archivo lista requisitos que implementa
- [ ] Referencias bidireccionales consistentes

#### Análisis de Impacto
- [ ] Archivos críticos identificados
- [ ] Módulos por complejidad clasificados
- [ ] Riesgo evaluado

#### Estadísticas y Roadmap
- [ ] Estadísticas por prioridad
- [ ] Estadísticas por módulo
- [ ] LOC calculadas
- [ ] Roadmap de implementación
- [ ] Deuda técnica identificada

### Validación Cruzada entre Matrices

#### Consistencia de Requisitos
```markdown
# Verificar que:
- Los mismos requisitos aparecen en ambas matrices
- Los IDs de requisitos son consistentes
- Las descripciones coinciden
- Las prioridades son iguales
- Los status son coherentes
```

| Requisito | En MATRIZ-tests | En MATRIZ-codigo | Status Tests | Status Código | Coherente |
|-----------|-----------------|------------------|--------------|---------------|-----------|
| REQ-AUTH-001 | [OK] | [OK] | Implementado | Implementado | [OK] |
| REQ-AUTH-002 | [OK] | [OK] | Implementado | Implementado | [OK] |
| REQ-USER-002 | [OK] | [OK] | Parcial | Parcial | [OK] |
| REQ-PROD-002 | [OK] | [OK] | No implementado | No implementado | [OK] |

#### Coherencia de Estadísticas
```markdown
# Verificar que:
- Total requisitos coincide en ambas matrices
- Requisitos implementados coinciden
- Requisitos pendientes coinciden
- Clasificaciones por prioridad coinciden
```

**Comparación de Estadísticas:**

| Métrica | MATRIZ-tests | MATRIZ-codigo | Coincide |
|---------|--------------|---------------|----------|
| Total Requisitos | 45 | 45 | [OK] |
| Implementados | 38 | 38 | [OK] |
| Parciales | 5 | 5 | [OK] |
| Pendientes | 2 | 2 | [OK] |
| % Completitud | 84% | 84% | [OK] |

#### Alineación de Prioridades
```markdown
# Verificar que:
- Requisitos CRÍTICA están 100% implementados y testeados
- Requisitos ALTA tienen alta prioridad en roadmap
- Gaps de requisitos CRÍTICA/ALTA están priorizados
```

## Proceso de Validación

### Paso 1: Validación Estructural (3 minutos)
```bash
# Verificar que archivos existen
cd /home/user/IACT/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/

ls -la TASK-039-matriz-requisitos-tests/README.md
ls -la TASK-040-matriz-requisitos-codigo/README.md

# Verificar tamaño (no vacíos)
wc -l TASK-039-matriz-requisitos-tests/README.md
wc -l TASK-040-matriz-requisitos-codigo/README.md

# Verificar formato markdown
mdl TASK-039-matriz-requisitos-tests/README.md || echo "Markdown OK"
mdl TASK-040-matriz-requisitos-codigo/README.md || echo "Markdown OK"
```

### Paso 2: Validación de Completitud (5 minutos)
```bash
# Extraer requisitos de MATRIZ-tests
grep -E "^#### REQ-" TASK-039-matriz-requisitos-tests/README.md | wc -l

# Extraer requisitos de MATRIZ-codigo
grep -E "^#### REQ-" TASK-040-matriz-requisitos-codigo/README.md | wc -l

# Deben coincidir

# Verificar que estadísticas coinciden
grep "Total Requisitos" TASK-039-matriz-requisitos-tests/README.md
grep "Total Requisitos" TASK-040-matriz-requisitos-codigo/README.md
```

### Paso 3: Validación de Bidireccionalidad (4 minutos)
```markdown
## Verificaciones Manuales

### MATRIZ-tests
1. Escoger requisito aleatorio (ej: REQ-AUTH-001)
2. Verificar que lista tests
3. Buscar cada test en matriz inversa (Tests → Requisitos)
4. Verificar que test referencia de vuelta a REQ-AUTH-001

### MATRIZ-codigo
1. Escoger requisito aleatorio (ej: REQ-PROD-001)
2. Verificar que lista archivos/clases
3. Buscar archivo en matriz inversa (Código → Requisitos)
4. Verificar que archivo referencia de vuelta a REQ-PROD-001
```

### Paso 4: Validación de Coherencia (3 minutos)
```markdown
## Checklist de Coherencia

### Estadísticas
- [ ] Total requisitos: 45 (ambas matrices)
- [ ] Implementados: 38 (84%) (ambas matrices)
- [ ] Parciales: 5 (ambas matrices)
- [ ] Pendientes: 2 (ambas matrices)

### Prioridades
- [ ] CRÍTICA: 12 requisitos (ambas matrices)
- [ ] ALTA: 18 requisitos (ambas matrices)
- [ ] MEDIA: 10 requisitos (ambas matrices)
- [ ] BAJA: 5 requisitos (ambas matrices)

### Por Módulo
- [ ] Autenticación: 5 requisitos (ambas matrices)
- [ ] Usuarios: 8 requisitos (ambas matrices)
- [ ] Productos: 12 requisitos (ambas matrices)
- [ ] Pedidos: 10 requisitos (ambas matrices)
- [ ] Notificaciones: 10 requisitos (ambas matrices)
```

## Criterios de Aceptación

### Criterios Obligatorios (MUST)
1. [OK] Ambas matrices existen y son completas
2. [OK] Total de requisitos coincide entre matrices
3. [OK] Status de implementación consistente
4. [OK] Bidireccionalidad verificada (muestras)
5. [OK] Gaps identificados en ambas matrices
6. [OK] Roadmap incluido en ambas

### Criterios Deseables (SHOULD)
1. [OK] Cobertura > 80% (requisitos → tests)
2. [OK] Implementación > 80% (requisitos → código)
3. [OK] Requisitos CRÍTICA 100% cubiertos
4. [OK] Diagramas incluidos
5. [OK] Análisis de impacto en MATRIZ-codigo

### Criterios Opcionales (COULD)
1. [OK] Automatización de generación sugerida
2. [OK] Integración con CI/CD documentada
3. [OK] Dashboard de métricas propuesto

## Reporte de Validación

### Template de Reporte
```markdown
# Reporte de Validación - Matrices de Trazabilidad

## Fecha: [YYYY-MM-DD]
## Validador: [Nombre]

## Resumen Ejecutivo
- Matrices Validadas: 2
- Status General: [[OK] APROBADO | [WARNING] APROBADO CON OBSERVACIONES | [ERROR] RECHAZADO]

## Validación: MATRIZ-requisitos-tests.md

### Completitud
- **Status**: [[OK] | [WARNING] | [ERROR]]
- Total Requisitos: [número]
- Requisitos con Tests: [número] ([%])
- Matriz Inversa: [[OK] | [ERROR]]

### Bidireccionalidad
- **Status**: [[OK] | [WARNING] | [ERROR]]
- Muestras Validadas: [número]
- Referencias Rotas: [número]

### Coherencia
- **Status**: [[OK] | [WARNING] | [ERROR]]
- Estadísticas Correctas: [[OK] | [ERROR]]
- Porcentajes Suman: [[OK] | [ERROR]]

### Observaciones:
- [Lista de observaciones]

### Acciones Requeridas:
- [Lista de acciones]

---

## Validación: MATRIZ-requisitos-codigo.md

### Completitud
- **Status**: [[OK] | [WARNING] | [ERROR]]
- Total Requisitos: [número]
- Requisitos Implementados: [número] ([%])
- Matriz Inversa: [[OK] | [ERROR]]

### Bidireccionalidad
- **Status**: [[OK] | [WARNING] | [ERROR]]
- Muestras Validadas: [número]
- Referencias Rotas: [número]

### Coherencia
- **Status**: [[OK] | [WARNING] | [ERROR]]
- Estadísticas Correctas: [[OK] | [ERROR]]
- Análisis de Impacto: [[OK] | [ERROR]]

### Observaciones:
- [Lista de observaciones]

### Acciones Requeridas:
- [Lista de acciones]

---

## Validación Cruzada

### Consistencia entre Matrices
- **Status**: [[OK] | [WARNING] | [ERROR]]
- Total Requisitos Coincide: [[OK] | [ERROR]]
- Status Implementación Coincide: [[OK] | [ERROR]]
- Prioridades Coinciden: [[OK] | [ERROR]]
- Clasificaciones Coinciden: [[OK] | [ERROR]]

### Tabla Comparativa:

| Métrica | MATRIZ-tests | MATRIZ-codigo | Coincide |
|---------|--------------|---------------|----------|
| Total Requisitos | X | Y | [[OK] | [ERROR]] |
| Implementados | X | Y | [[OK] | [ERROR]] |
| % Completitud | X% | Y% | [[OK] | [ERROR]] |

## Métricas de Calidad

| Métrica | Objetivo | MATRIZ-tests | MATRIZ-codigo |
|---------|----------|--------------|---------------|
| Completitud | 100% | [%] | [%] |
| Bidireccionalidad | 100% | [%] | [%] |
| Coherencia | 100% | [%] | [%] |
| Cobertura | ≥ 80% | [%] | [%] |

## Conclusión
[Conclusión general de la validación de trazabilidad]

## Recomendaciones
1. [Recomendación 1]
2. [Recomendación 2]
3. [Recomendación 3]

## Próximos Pasos
1. [Acción 1]
2. [Acción 2]
3. [Acción 3]

## Aprobación
- Validador: [Nombre]
- Fecha: [YYYY-MM-DD]
- Status: [[OK] APROBADO | [WARNING] APROBADO CON OBSERVACIONES | [ERROR] RECHAZADO]

---

## Anexo: Detalles de Validación

### Muestras de Bidireccionalidad Validadas

#### MATRIZ-tests
- REQ-AUTH-001 → tests → REQ-AUTH-001 [OK]
- REQ-USER-002 → tests → REQ-USER-002 [OK]
- REQ-PROD-001 → tests → REQ-PROD-001 [OK]

#### MATRIZ-codigo
- REQ-AUTH-001 → código → REQ-AUTH-001 [OK]
- REQ-USER-002 → código → REQ-USER-002 [OK]
- REQ-PROD-001 → código → REQ-PROD-001 [OK]

### Referencias Rotas Encontradas
- [Ninguna] o [Listado]

### Inconsistencias Encontradas
- [Ninguna] o [Listado]
```

## Entregables
- [ ] Validación de MATRIZ-requisitos-tests.md completada
- [ ] Validación de MATRIZ-requisitos-codigo.md completada
- [ ] Validación cruzada entre matrices realizada
- [ ] Reporte de validación generado
- [ ] Lista de acciones correctivas (si aplica)
- [ ] Aprobación final o rechazo justificado

## Criterios de Éxito
1. [OK] Todas las validaciones obligatorias pasadas
2. [OK] ≥ 90% de validaciones deseables pasadas
3. [OK] Consistencia 100% entre matrices
4. [OK] No hay referencias rotas
5. [OK] Gaps claramente identificados y priorizados
6. [OK] Roadmaps son accionables

## Notas
- Documentar todas las inconsistencias encontradas
- Priorizar correcciones según impacto
- Validar con usuarios potenciales (devs, QA)
- Considerar automatización de validación futura
- Actualizar matrices si se encuentran errores

## Automatización Futura
```bash
# Script futuro: validate-traceability.sh
# Automatizar validación de:
# - Completitud
# - Bidireccionalidad
# - Consistencia de estadísticas
# - Referencias rotas
# Output: Reporte automático
```
