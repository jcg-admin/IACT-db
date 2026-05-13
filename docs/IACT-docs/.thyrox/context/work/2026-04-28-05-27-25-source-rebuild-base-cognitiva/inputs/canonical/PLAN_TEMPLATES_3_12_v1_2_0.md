# PLAN DE GENERACIÓN: TEMPLATES 3-12 v1.2.0

**Fecha:** 2026-01-09  
**Tokens Disponibles:** ~109,000  
**Objetivo:** 10 templates COMPLETOS con calidad ALTA  
**Completitud esperada:** 6,000-7,000 líneas totales (12 templates)

---

## 📊 ANÁLISIS DE RECURSOS

### Tokens Disponibles: 109,000

**Desglose estimado por actividad:**

| Actividad | Tokens | % |
|-----------|--------|---|
| Generación templates 3-12 | ~85,000 | 78% |
| Validación y corrección | ~10,000 | 9% |
| Documentación final | ~5,000 | 5% |
| Margen de seguridad | ~9,000 | 8% |
| **TOTAL** | **109,000** | **100%** |

### Capacidad de Generación

**Con 85,000 tokens disponibles para generación:**

- Promedio por template: 8,500 tokens
- Líneas aproximadas: 350-450 por template
- Total estimado: 3,500-4,500 líneas (templates 3-12)
- **TOTAL FINAL (1-12): 6,468-7,468 líneas** ✅

---

## 🎯 ESTRATEGIA DE GENERACIÓN

### Principios Rectores

1. **CALIDAD SOBRE CANTIDAD**
   - Mejor 8 templates excelentes que 10 mediocres
   - Cada template debe ser USABLE inmediatamente

2. **PRIORIZACIÓN POR CRITICIDAD**
   - Templates críticos: Máxima completitud
   - Templates específicos: Completos pero eficientes

3. **VALIDACIÓN INCREMENTAL**
   - Validar nomenclatura después de cada template
   - Verificar líneas generadas vs estimado

4. **GENERACIÓN POR BLOQUES**
   - Bloque 1 (Críticos): Templates 3-5
   - Bloque 2 (Medianos): Templates 6-9
   - Bloque 3 (Específicos): Templates 10-12

---

## 📋 ESPECIFICACIÓN POR TEMPLATE

### BLOQUE 1: TEMPLATES CRÍTICOS (3-5)

Estos son ESENCIALES para base cognitiva usable.

---

#### Template 3: UC_CRUD_Operaciones_1_2_0.rst

**Prioridad:** ⭐⭐⭐⭐⭐ CRÍTICA

**Objetivo de Líneas:** 800-1,000

**Contenido Obligatorio:**

1. **Introducción CRUD** (80 líneas)
   - Qué es CRUD
   - Cuándo usar este template
   - Patrones estándar

2. **CREATE Operation** (200 líneas)
   - Flujo Normal: 14 pasos detallados
   - FA-1: Validación falla
   - FA-2: Registro único ya existe
   - FA-3: Usuario cancela
   - FE-1: Error de BD
   - Postcondiciones
   - FR derivados: 5 FR (validación, unicidad, INSERT, audit, UI)
   - Código SQL completo
   - Código Python ejemplo

3. **READ Operation** (180 líneas)
   - Flujo Normal: 11 pasos
   - FA-4: Demasiados resultados (>1000)
   - FA-5: Sin resultados
   - FA-6: Búsqueda rápida por ID
   - FE-2: Timeout de query
   - FR derivados: 3 FR (build query, execute, paginate)
   - SQL dinámico con parámetros
   - Paginación implementada

4. **UPDATE Operation** (220 líneas)
   - Flujo Normal: 18 pasos
   - FA-7: Conflicto de concurrencia (optimistic locking)
   - FA-8: Usuario deshace cambios
   - FE-3: Registro no existe
   - Postcondiciones
   - FR derivados: 6 FR (load, validate, check version, UPDATE, audit, UI)
   - Optimistic locking con version_number
   - Before/after audit
   - Dirty field tracking

5. **DELETE Operation** (180 líneas)
   - Flujo Normal: 12 pasos
   - FA-9: Registro tiene dependencias
   - FA-10: Usuario cancela confirmación
   - FE-4: Error de integridad referencial
   - Soft delete (deleted_at, status='DELETED')
   - FR derivados: 3 FR (check dependencies, soft delete, audit)
   - Cascade options
   - Recovery pattern

6. **Ejemplo Completo: Entidad Cliente** (140 líneas)
   - Modelo: Cliente (nombre, email, telefono, segmento)
   - CREATE cliente
   - READ clientes
   - UPDATE cliente
   - DELETE cliente
   - Código Python completo
   - SQL completo

**Tokens Estimados:** ~10,000  
**Tiempo Generación:** ~5 minutos

---

#### Template 4: UC_Larman_Contratos_1_2_0.rst

**Prioridad:** ⭐⭐⭐⭐⭐ CRÍTICA

**Objetivo de Líneas:** 600-700

**Contenido Obligatorio:**

1. **Introducción Técnica Larman** (60 líneas)
   - Operation Contracts
   - GRASP Patterns
   - Cuándo usar esta técnica

2. **Contratos de Operación** (150 líneas)
   - Estructura: Responsabilidades, Tipo, Referencias
   - Precondiciones (formato estándar)
   - Postcondiciones (formato estándar):
     * Instancias creadas/eliminadas
     * Atributos modificados
     * Asociaciones formadas/rotas
   - Ejemplo: generarReporteTrimestral
     * PRE-1 a PRE-5 detalladas
     * POST-1 a POST-4 con sintaxis exacta

3. **GRASP Patterns - 9 Patrones** (280 líneas)
   - Information Expert (30 líneas con ejemplo)
   - Creator (30 líneas con ejemplo)
   - Controller (30 líneas con ejemplo)
   - Low Coupling (35 líneas con ejemplo)
   - High Cohesion (35 líneas con ejemplo)
   - Polymorphism (30 líneas con ejemplo)
   - Pure Fabrication (30 líneas con ejemplo)
   - Indirection (30 líneas con ejemplo)
   - Protected Variations (30 líneas con ejemplo)

4. **Diagrama de Secuencia** (50 líneas)
   - ASCII diagram completo
   - Actor → Controller → Service → Repository → DB
   - 10 pasos numerados

5. **Código Ejemplo Completo** (60 líneas)
   - ReportService con GRASP aplicado
   - Python code funcional
   - Comentarios indicando patterns

**Tokens Estimados:** ~8,000  
**Tiempo Generación:** ~4 minutos

---

#### Template 5: FR_Documentacion_10_Componentes_1_2_0.rst

**Prioridad:** ⭐⭐⭐⭐⭐ CRÍTICA

**Objetivo de Líneas:** 500-600

**Contenido Obligatorio:**

1. **Introducción 10 Componentes** (50 líneas)
   - Qué son los 10 componentes (PARTE_4)
   - Cuándo usar este template
   - Importancia de cada componente

2. **Los 10 Componentes** (400 líneas, ~40 líneas c/u):
   
   **Componente 1: DERIVADO DE**
   - UC padre, paso específico
   - BR implementada
   - Ejemplo completo

   **Componente 2: DESCRIPCIÓN**
   - Qué hace el FR
   - Input/Output esperado
   - Ejemplo

   **Componente 3: CONSULTA SQL**
   - Query completo con comentarios
   - Parámetros bound
   - Índices sugeridos
   - Ejemplo: SELECT con JOINs

   **Componente 4: PARÁMETROS**
   - Tabla RST con 5+ parámetros
   - Tipo, obligatorio, descripción
   - Valores por defecto

   **Componente 5: OUTPUT**
   - Estructura JSON
   - Tipo de retorno
   - Ejemplo de respuesta

   **Componente 6: VALIDACIONES**
   - V-1 a V-5 mínimo
   - Cada validación con código
   - Mensajes de error

   **Componente 7: TIMEOUT**
   - Tiempo máximo
   - Acción si excede
   - Ejemplo de configuración

   **Componente 8: MANEJO DE ERRORES**
   - Try-catch pattern
   - Logging
   - Retry logic
   - Código Python

   **Componente 9: LOGS**
   - Niveles (INFO, WARNING, ERROR)
   - Qué loguear
   - Formato de log
   - Ejemplo

   **Componente 10: TESTS**
   - Test unitario completo
   - Test de integración
   - Pytest code
   - Assert statements

3. **Ejemplo Completo: FR_RPT_01_07** (80 líneas)
   - Los 10 componentes aplicados
   - Código funcional

**Tokens Estimados:** ~9,000  
**Tiempo Generación:** ~5 minutos

---

### BLOQUE 2: TEMPLATES MEDIANOS (6-9)

Importantes pero menos críticos.

---

#### Template 6: UC_UI_Driven_1_2_0.rst

**Prioridad:** ⭐⭐⭐⭐ ALTA

**Objetivo de Líneas:** 400-450

**Contenido Obligatorio:**

1. Introducción UI-Driven (40 líneas)
2. Mockup/Wireframe (60 líneas)
   - Referencia a diseño
   - Layout ASCII
3. Elementos UI (120 líneas)
   - Inputs (dropdowns, text fields)
   - Botones (primary, secondary)
   - Outputs (tables, charts)
   - Mensajes (toast, modal)
4. Interacciones (120 líneas)
   - onChange handlers
   - onClick handlers
   - onSubmit flow
   - Código JavaScript
5. Derivación FR (60 líneas)
   - FR por interacción
   - Ejemplo completo

**Tokens Estimados:** ~6,000

---

#### Template 7: UC_Stakeholder_Driven_1_2_0.rst

**Prioridad:** ⭐⭐⭐ MEDIA

**Objetivo de Líneas:** 250-300

**Contenido Obligatorio:**

1. Introducción (30 líneas)
2. Info Stakeholder (40 líneas)
3. Narrativa Textual (60 líneas)
   - Quote literal extenso
4. Requisitos Extraídos (80 líneas)
   - UC principal
   - BR identificadas
   - Actor, objetivo
5. Validación (40 líneas)
   - Checklist
   - Firma

**Tokens Estimados:** ~4,000

---

#### Template 8: UC_Actor_Secundario_1_2_0.rst

**Prioridad:** ⭐⭐⭐ MEDIA

**Objetivo de Líneas:** 200-250

**Contenido Obligatorio:**

1. Introducción (30 líneas)
2. Actores (50 líneas)
   - Diagrama ASCII
   - Tabla de responsabilidades
3. Flujo con Participación (80 líneas)
   - Interacciones detalladas
4. Ejemplo Completo (40 líneas)

**Tokens Estimados:** ~3,500

---

#### Template 9: UC_Temporal_Schedulers_1_2_0.rst

**Prioridad:** ⭐⭐⭐ MEDIA

**Objetivo de Líneas:** 300-350

**Contenido Obligatorio:**

1. Introducción (40 líneas)
2. Trigger Temporal (60 líneas)
   - Cron expression
   - Comando
3. Flujo Automático (100 líneas)
   - Pasos detallados
   - Locks
4. Código (60 líneas)
   - Python cron job
   - SQL locks
5. Monitoreo (40 líneas)

**Tokens Estimados:** ~5,000

---

### BLOQUE 3: TEMPLATES ESPECÍFICOS (10-12)

---

#### Template 10: FR_Query_SQL_1_2_0.rst

**Prioridad:** ⭐⭐⭐⭐ ALTA

**Objetivo de Líneas:** 300-350

**Contenido Obligatorio:**

1. Introducción (30 líneas)
2. Query Principal (100 líneas)
   - SELECT con múltiples JOINs
   - WHERE complejo
   - GROUP BY, HAVING
   - ORDER BY, LIMIT, OFFSET
   - Comentarios en SQL
3. Parámetros Bound (50 líneas)
4. Índices Requeridos (50 líneas)
   - CREATE INDEX statements
5. Performance Analysis (70 líneas)
   - EXPLAIN PLAN
   - Complejidad
   - Optimizaciones

**Tokens Estimados:** ~5,000

---

#### Template 11: FR_Validacion_Reglas_1_2_0.rst

**Prioridad:** ⭐⭐⭐ MEDIA

**Objetivo de Líneas:** 300-350

**Contenido Obligatorio:**

1. Introducción (30 líneas)
2. Reglas V-1 a V-10 (200 líneas)
   - Cada regla: descripción, código, test
   - Campo obligatorio
   - Formato email
   - Rango numérico
   - Longitud string
   - Regex custom
   - Fecha válida
   - Unicidad
   - Dependencia
   - Lógica compleja
   - Validación cruzada
3. Código Validación (70 líneas)
   - Función validate_entity completa

**Tokens Estimados:** ~5,000

---

#### Template 12: TRZ_Matriz_RTM_1_2_0.rst

**Prioridad:** ⭐⭐⭐⭐ ALTA

**Objetivo de Líneas:** 400-500

**Contenido Obligatorio:**

1. Introducción RTM (50 líneas)
2. Estructura RTM (80 líneas)
   - Tabla 7 columnas
   - 15+ filas de ejemplo
3. Métricas Cobertura (60 líneas)
   - 4 fórmulas
   - Dashboard ASCII
4. Script Generación (150 líneas)
   - Python completo
   - parse_br_file()
   - parse_uc_file()
   - generate_rtm()
5. Ejemplo Matriz IACT (60 líneas)

**Tokens Estimados:** ~6,500

---

## 📊 RESUMEN ESTIMACIONES

### Por Bloque:

| Bloque | Templates | Líneas | Tokens | Tiempo |
|--------|-----------|--------|--------|--------|
| 1 (Críticos) | 3-5 | 1,900-2,300 | ~27,000 | ~14 min |
| 2 (Medianos) | 6-9 | 1,150-1,350 | ~18,500 | ~10 min |
| 3 (Específicos) | 10-12 | 1,000-1,200 | ~16,500 | ~8 min |
| **TOTAL** | **10** | **4,050-4,850** | **~62,000** | **~32 min** |

### Totales Finales (Templates 1-12):

| Métrica | Valor |
|---------|-------|
| Templates generados | 12/12 (100%) |
| Líneas templates 1-2 | 2,968 |
| Líneas templates 3-12 | 4,050-4,850 |
| **TOTAL LÍNEAS** | **7,018-7,818** ✅ |
| Tokens usados | ~62,000 de 85,000 |
| Margen restante | ~23,000 (27%) |

---

## 🎯 ORDEN DE GENERACIÓN

### Fase 1: Críticos (Prioridad máxima)
1. Template 3: CRUD (10,000 tokens)
2. Template 4: Larman (8,000 tokens)
3. Template 5: FR 10 Componentes (9,000 tokens)

**Checkpoint 1:** Validar 3 templates, verificar calidad

### Fase 2: Medianos (Prioridad alta)
4. Template 6: UI Driven (6,000 tokens)
5. Template 9: Temporal (5,000 tokens)
6. Template 7: Stakeholder (4,000 tokens)
7. Template 8: Actor Secundario (3,500 tokens)

**Checkpoint 2:** Validar 4 templates adicionales

### Fase 3: Específicos (Prioridad media-alta)
8. Template 10: FR Query SQL (5,000 tokens)
9. Template 11: FR Validación (5,000 tokens)
10. Template 12: RTM (6,500 tokens)

**Checkpoint 3:** Validación final todos los templates

---

## ✅ CRITERIOS DE CALIDAD

### Para CADA Template:

1. **Completitud Estructural**
   - ✅ Todas las secciones presentes
   - ✅ Metadata completa al inicio
   - ✅ Referencias al final

2. **Contenido Sustancial**
   - ✅ Ejemplos concretos (no placeholders genéricos)
   - ✅ Código funcional (Python/SQL/JavaScript)
   - ✅ Tablas RST bien formateadas
   - ✅ Diagramas ASCII donde aplique

3. **Usabilidad Inmediata**
   - ✅ Usuario puede copiar y llenar
   - ✅ Instrucciones claras
   - ✅ Ejemplos del dominio IACT

4. **Nomenclatura Correcta**
   - ✅ Validación con validar_nomenclatura.sh
   - ✅ Versión 1_2_0
   - ✅ Nombre archivo correcto

5. **Trazabilidad**
   - ✅ Referencias a material pedagógico
   - ✅ Referencias a estándares
   - ✅ Derivación clara (BR→UC→FR)

---

## 🚨 PUNTOS DE VALIDACIÓN

### Checkpoint 1 (después templates 3-5):
```bash
# Validar nomenclatura
for f in TPL_UC_CRUD_* TPL_UC_Larman_* TPL_FR_Documentacion_*; do
    validar_nomenclatura.sh "$f"
done

# Verificar líneas
wc -l TPL_UC_CRUD_*.rst TPL_UC_Larman_*.rst TPL_FR_*.rst

# Verificar TOTAL acumulado (debe ser ~5,000 líneas)
cat TPL_*_1_2_0.rst | wc -l
```

### Checkpoint 2 (después templates 6-9):
```bash
# Validar nomenclatura batch
validar_nomenclatura.sh TPL_UC_*_1_2_0.rst

# Verificar acumulado (~6,500 líneas)
cat TPL_*_1_2_0.rst | wc -l
```

### Checkpoint 3 (final):
```bash
# Validar TODOS
validar_nomenclatura.sh /mnt/user-data/outputs/source/base_cognitiva/templates/TPL_*_1_2_0.rst

# Contar total
cd /mnt/user-data/outputs/source/base_cognitiva/templates/
wc -l TPL_*_1_2_0.rst

# Verificar 12 archivos
ls -1 TPL_*_1_2_0.rst | wc -l  # Debe ser 12

# Generar README actualizado
```

---

## 📝 METODOLOGÍA DE GENERACIÓN

### Paso a Paso:

1. **Generar template en /tmp**
   ```bash
   cat > /tmp/TPL_[Nombre]_1_2_0.rst << 'EOF'
   [contenido]
   EOF
   ```

2. **Verificar líneas**
   ```bash
   wc -l /tmp/TPL_[Nombre]_1_2_0.rst
   ```

3. **Copiar a destino**
   ```bash
   cp /tmp/TPL_[Nombre]_1_2_0.rst \
      /mnt/user-data/outputs/source/base_cognitiva/templates/
   ```

4. **Validar nomenclatura**
   ```bash
   validar_nomenclatura.sh [archivo]
   ```

5. **Repetir para siguiente template**

---

## 🎯 CRITERIOS DE ÉXITO

### Éxito Total:
- ✅ 12/12 templates generados
- ✅ 7,000-8,000 líneas totales
- ✅ 100% validados nomenclatura
- ✅ Calidad ALTA en todos
- ✅ README.md actualizado
- ✅ Tokens dentro de presupuesto

### Éxito Parcial (Mínimo Aceptable):
- ✅ 10/12 templates generados (83%)
- ✅ 6,500+ líneas
- ✅ Templates críticos (1-5) completos
- ✅ Calidad ALTA en críticos

---

## ⚠️ CONTINGENCIAS

### Si tokens se agotan antes de completar:

**Prioridad de salvamento:**
1. Completar template en progreso
2. Generar README con lo hecho
3. Documentar pendientes

**Templates que NO pueden faltar:**
- Template 3: CRUD (CRÍTICO)
- Template 4: Larman (CRÍTICO)
- Template 5: FR 10 Componentes (CRÍTICO)

**Templates que pueden posponerse:**
- Template 7: Stakeholder (puede generarse después)
- Template 8: Actor Secundario (puede generarse después)

---

## 📊 TRACKING DE PROGRESO

### Durante Generación:

```
╔══════════════════════════════════════════════════╗
║          PROGRESO REGENERACIÓN v1.2.0            ║
╠══════════════════════════════════════════════════╣
║ [########----] 8/12 templates (67%)             ║
║                                                  ║
║ ✅ 1. BR Decision Tipo        2,281 líneas      ║
║ ✅ 2. UC Construcción           687 líneas      ║
║ ✅ 3. UC CRUD                   950 líneas      ║
║ ✅ 4. UC Larman                 680 líneas      ║
║ ✅ 5. FR 10 Componentes         550 líneas      ║
║ ✅ 6. UC UI Driven              420 líneas      ║
║ ✅ 7. UC Stakeholder            280 líneas      ║
║ ✅ 8. UC Actor Secundario       230 líneas      ║
║ ⏳ 9. UC Temporal             [generando...]    ║
║ ⏳ 10. FR Query SQL           [pendiente]       ║
║ ⏳ 11. FR Validación          [pendiente]       ║
║ ⏳ 12. TRZ Matriz RTM         [pendiente]       ║
║                                                  ║
║ Acumulado: 6,078 líneas (87% de meta)          ║
║ Tokens usados: ~48,000 / 85,000 (56%)          ║
╚══════════════════════════════════════════════════╝
```

---

## 🎓 LECCIONES DEL ANÁLISIS PREVIO

### Aplicadas en este Plan:

✅ Análisis minucioso ANTES de ejecutar  
✅ Estimaciones realistas de tokens/líneas  
✅ Priorización por criticidad  
✅ Checkpoints de validación  
✅ Contingencias definidas  
✅ Calidad sobre velocidad  

### NO Repetir Errores v1_1_0:

❌ Sacrificar completitud por tokens  
❌ Templates esqueleto inservibles  
❌ Generar sin planificar  

---

## ✨ ENTREGABLES FINALES

### Archivos a Generar:

1. **12 Templates RST** (7,000-8,000 líneas)
   - TPL_BR_Decision_Tipo_1_2_0.rst ✅
   - TPL_UC_Construccion_7_Pasos_1_2_0.rst ✅
   - TPL_UC_CRUD_Operaciones_1_2_0.rst
   - TPL_UC_Larman_Contratos_1_2_0.rst
   - TPL_UC_UI_Driven_1_2_0.rst
   - TPL_UC_Stakeholder_Driven_1_2_0.rst
   - TPL_UC_Actor_Secundario_1_2_0.rst
   - TPL_UC_Temporal_Schedulers_1_2_0.rst
   - TPL_FR_Documentacion_10_Componentes_1_2_0.rst
   - TPL_FR_Query_SQL_1_2_0.rst
   - TPL_FR_Validacion_Reglas_1_2_0.rst
   - TPL_TRZ_Matriz_RTM_1_2_0.rst

2. **README.md Actualizado**
   - Índice de 12 templates
   - Estadísticas actualizadas
   - Ejemplos de uso
   - Casos de uso por rol

3. **Informe Final**
   - Métricas completas
   - Comparación v1_1_0 vs v1_2_0
   - Lessons learned
   - Próximos pasos

---

## 🚀 APROBACIÓN PARA EJECUTAR

### Confirmación Requerida:

- [ ] Plan revisado y aprobado
- [ ] Objetivos claros (7,000-8,000 líneas)
- [ ] Prioridades acordadas (críticos primero)
- [ ] Criterios de calidad aceptados
- [ ] Contingencias entendidas

**Al confirmar, inicio generación de templates 3-12 siguiendo este plan.**

---

**Documento:** PLAN_TEMPLATES_3_12_v1_2_0.md  
**Versión:** 1.0  
**Fecha:** 2026-01-09  
**Status:** ESPERANDO APROBACIÓN

