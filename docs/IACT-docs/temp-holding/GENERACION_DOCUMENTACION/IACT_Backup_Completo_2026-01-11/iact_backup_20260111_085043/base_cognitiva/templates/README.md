# TEMPLATES - Base Cognitiva IACT v2.0.0

**Ubicación:** `/base_cognitiva/templates/`  
**Versión Templates:** 1.1.0  
**Fecha:** 2026-01-09  
**Total Templates:** 12 archivos RST

---

## 📋 ÍNDICE DE TEMPLATES

### Business Rules (1 template)

1. **TPL_BR_Decision_Tipo_1_1_0.rst**
   - Template para documentar Business Rules
   - 10 secciones estándar
   - Test de observabilidad (Desencadenador vs Inferencia)
   - Incluye análisis por tipo (Restricción, Cálculo, etc.)

### Use Cases (7 templates)

2. **TPL_UC_Construccion_7_Pasos_1_1_0.rst** ⭐ PRINCIPAL
   - Estructura estándar de 11 pasos (Cockburn/Larman)
   - Actor, Precondiciones, Trigger, Flujo Normal, FA, FE
   - Postcondiciones, RNF, BR asociadas, derivación FR

3. **TPL_UC_CRUD_Operaciones_1_1_0.rst**
   - Patrones para CREATE, READ, UPDATE, DELETE
   - Validaciones estándar
   - Soft delete implementado

4. **TPL_UC_Larman_Contratos_1_1_0.rst**
   - Técnica de Craig Larman
   - Contratos de operación (Pre/Post condiciones)
   - GRASP Patterns (9 patrones)

5. **TPL_UC_UI_Driven_1_1_0.rst**
   - Derivado desde mockup/wireframe
   - Elementos UI identificados
   - Interacciones (onChange, onClick, etc.)

6. **TPL_UC_Stakeholder_Driven_1_1_0.rst**
   - Elicitación desde narrativa de stakeholder
   - Quote textual del stakeholder
   - Validación con firma

7. **TPL_UC_Actor_Secundario_1_1_0.rst**
   - Múltiples actores participando
   - Diagrama de actores
   - Responsabilidades por actor

8. **TPL_UC_Temporal_Schedulers_1_1_0.rst**
   - Procesos programados (cron jobs)
   - Sistema como actor principal
   - Manejo de locks, monitoreo

### Functional Requirements (3 templates)

9. **TPL_FR_Documentacion_10_Componentes_1_1_0.rst** ⭐ PRINCIPAL
   - Estándar de 10 componentes (PARTE_4)
   - Derivado, Descripción, SQL, Parámetros, Output
   - Validaciones, Timeout, Errores, Logs, Tests

10. **TPL_FR_Query_SQL_1_1_0.rst**
    - Especializado para queries SQL
    - Parámetros bound, índices requeridos
    - Análisis de performance

11. **TPL_FR_Validacion_Reglas_1_1_0.rst**
    - Validaciones de datos
    - Reglas V-1, V-2, V-3...
    - Código Python con regex

### Trazabilidad (1 template)

12. **TPL_TRZ_Matriz_RTM_1_1_0.rst**
    - Requirements Traceability Matrix
    - 7 columnas: BR, Tipo, UC, FR, Código, Tests, Cobertura
    - Script Python para generación automática

---

## 🚀 CÓMO USAR LOS TEMPLATES

### Paso 1: Seleccionar Template Apropiado

**Para Business Rules:**
- Usa TPL_BR_Decision_Tipo para cualquier BR

**Para Use Cases:**
- **Caso general:** TPL_UC_Construccion_7_Pasos (el más común)
- **CRUD:** TPL_UC_CRUD_Operaciones
- **Diseño OOP:** TPL_UC_Larman_Contratos
- **Desde mockup:** TPL_UC_UI_Driven
- **Desde stakeholder:** TPL_UC_Stakeholder_Driven
- **Múltiples actores:** TPL_UC_Actor_Secundario
- **Procesos programados:** TPL_UC_Temporal_Schedulers

**Para Functional Requirements:**
- **Caso general:** TPL_FR_Documentacion_10_Componentes
- **Query SQL:** TPL_FR_Query_SQL
- **Validaciones:** TPL_FR_Validacion_Reglas

**Para Trazabilidad:**
- TPL_TRZ_Matriz_RTM

### Paso 2: Copiar Template

```bash
cp templates/TPL_UC_Construccion_7_Pasos_1_1_0.rst \
   use_cases/UC_IACT_RPT_01_Consultar_Reporte_4_0_0.rst
```

### Paso 3: Modificar Metadata

```rst
.. meta::
   :Proyecto: IACT
   :Codigo: UC-IACT-RPT-01
   :Titulo: Consultar Reporte Trimestral
   :Version: 4.0.0
   :Modulo: RPT
   :Implementa_BR: BR-IACT-028, BR-IACT-053
   :Fecha: 2026-01-09
   :Autor: Juan Pérez
   :Estado: DRAFT
```

### Paso 4: Llenar Secciones

Reemplaza todos los placeholders:
- `[...]` → Contenido específico
- `XXX-YY` → IDs reales
- `[Nombre]` → Nombres descriptivos

### Paso 5: Validar Nomenclatura

```bash
./validar_nomenclatura.sh UC_IACT_RPT_01_Consultar_Reporte_4_0_0.rst
```

---

## 📖 CONVENCIONES

### Nomenclatura de Archivos

**Business Rules:**
```
BR_IACT_XXX_[Nombre_Corto]_1_0_0.rst
```

**Use Cases:**
```
UC_IACT_[MOD]_NN_[Nombre_Corto]_4_0_0.rst
```

Módulos: RPT, AUTH, ACC, PIPE, DASH, ADMIN, API, NOTIF

**Functional Requirements:**
```
FR_[MOD]_NN_ZZ_[Nombre_Corto]_1_0_0.rst
```

### Contenido de Templates

**Placeholders:**
- `[texto]` → Reemplazar con valor específico
- `:parametro` → Parámetro SQL/código
- `XXX-YY-ZZ` → IDs de documentos

**Secciones Opcionales:**
- Marcadas con `(Opcional)` o `(si aplica)`
- Eliminar si no son relevantes

**Ejemplos:**
- Mantener ejemplos como referencia
- Reemplazar con ejemplos del dominio IACT

---

## 📊 ESTADÍSTICAS

| Template | Líneas | Tamaño | Uso |
|----------|--------|--------|-----|
| TPL_BR_Decision_Tipo | ~700 | 25KB | Todas las BR |
| TPL_UC_Construccion_7_Pasos | ~500 | 18KB | UC generales |
| TPL_UC_CRUD_Operaciones | ~400 | 14KB | Operaciones CRUD |
| TPL_UC_Larman_Contratos | ~350 | 12KB | Diseño OOP |
| TPL_UC_UI_Driven | ~300 | 10KB | Desde mockups |
| TPL_UC_Stakeholder_Driven | ~150 | 5KB | Elicitación |
| TPL_UC_Actor_Secundario | ~120 | 4KB | Múltiples actores |
| TPL_UC_Temporal_Schedulers | ~180 | 6KB | Cron jobs |
| TPL_FR_Documentacion_10 | ~350 | 12KB | FR generales |
| TPL_FR_Query_SQL | ~200 | 7KB | Queries SQL |
| TPL_FR_Validacion_Reglas | ~180 | 6KB | Validaciones |
| TPL_TRZ_Matriz_RTM | ~250 | 9KB | RTM |
| **TOTAL** | **~3,680** | **~128KB** | **12 templates** |

---

## 🔗 RELACIÓN CON MATERIAL PEDAGÓGICO

Cada template se relaciona con el material pedagógico:

| Template | Documento Pedagógico |
|----------|---------------------|
| TPL_BR_Decision_Tipo | PARTE_1 (Secciones 2-3) |
| TPL_UC_Construccion_7_Pasos | PARTE_2B, PARTE_3B |
| TPL_UC_CRUD_Operaciones | PARTE_3A |
| TPL_UC_Larman_Contratos | PARTE_3B |
| TPL_UC_UI_Driven | PARTE_3C |
| TPL_UC_Stakeholder_Driven | PARTE_3C |
| TPL_UC_Temporal_Schedulers | PARTE_1 (Sección 3 - Inferencias) |
| TPL_FR_Documentacion_10 | PARTE_4 (completo) |
| TPL_FR_Query_SQL | PARTE_4 (queries) |
| TPL_FR_Validacion_Reglas | PARTE_4 (validaciones) |
| TPL_TRZ_Matriz_RTM | PARTE_5 (Sección 2) |

**Recomendación:** Leer el documento pedagógico correspondiente ANTES de usar el template.

---

## 💡 CASOS DE USO POR ROL

### Business Analyst

1. Identificar BR → TPL_BR_Decision_Tipo
2. Clasificar tipo de BR (Restricción, Cálculo, etc.)
3. Aplicar test de observabilidad (Desencadenador vs Inferencia)
4. Si genera UC → TPL_UC_Construccion_7_Pasos
5. Documentar trazabilidad → TPL_TRZ_Matriz_RTM

### Developer

1. Recibir UC documentado
2. Identificar FR derivados en UC
3. Implementar cada FR → TPL_FR_Documentacion_10
4. Queries SQL → TPL_FR_Query_SQL
5. Validaciones → TPL_FR_Validacion_Reglas
6. Agregar trazabilidad en código (comentarios con IDs)

### QA Engineer

1. Leer BR original → TPL_BR_Decision_Tipo sección 8
2. Revisar UC completo → TPL_UC_Construccion_7_Pasos
3. Diseñar tests basados en FR → TPL_FR_Documentacion_10 sección 10
4. Validar cobertura → TPL_TRZ_Matriz_RTM
5. Actualizar métricas de cobertura

---

## 🎯 EJEMPLOS DE USO

### Ejemplo 1: Documentar BR de Restricción

```bash
# 1. Copiar template
cp templates/TPL_BR_Decision_Tipo_1_1_0.rst \
   fundacionales/BR_IACT_028_Aprobacion_Consultas_1_0_0.rst

# 2. Editar metadata
# :Tipo: Restriccion
# :Genera_UC: UC-IACT-RPT-01 (FA-2)

# 3. Llenar Sección 4.1 (Si es RESTRICCION)
# - Qué restringe: Ejecución de consultas >10K registros
# - Cuándo aplica: Al solicitar reporte
# - Cómo valida: COUNT(*) previo
# - Qué pasa si viola: Solicita aprobación supervisor

# 4. Validar
./validar_nomenclatura.sh BR_IACT_028_Aprobacion_Consultas_1_0_0.rst
```

### Ejemplo 2: Documentar UC CRUD

```bash
# 1. Copiar template CRUD
cp templates/TPL_UC_CRUD_Operaciones_1_1_0.rst \
   use_cases/UC_IACT_CRM_01_CRUD_Cliente_4_0_0.rst

# 2. Especificar entidad
# Entidad: Cliente
# Campos: nombre, email, telefono, segmento

# 3. Llenar 4 operaciones
# CREATE: Formulario con campos cliente
# READ: Búsqueda por nombre/email
# UPDATE: Edición con optimistic locking
# DELETE: Soft delete (deleted_at)

# 4. Derivar FR
# FR-CRM-01-01: Validar datos cliente
# FR-CRM-01-04: INSERT cliente
# FR-CRM-01-07: SELECT clientes
# ...
```

### Ejemplo 3: Documentar FR con Query SQL

```bash
# 1. Copiar template
cp templates/TPL_FR_Query_SQL_1_1_0.rst \
   functional_requirements/FR_RPT_01_08_Ejecutar_Query_1_0_0.rst

# 2. Escribir query completo
SELECT 
    COUNT(*) as total_calls,
    COUNT(*) FILTER (WHERE status='ABANDONED') as abandoned
FROM ivr_calls
WHERE quarter = :quarter AND year = :year

# 3. Documentar parámetros
# :quarter - VARCHAR(2) - Obligatorio - Q1,Q2,Q3,Q4
# :year - INTEGER - Obligatorio - 2020-2025

# 4. Especificar índices
CREATE INDEX idx_calls_quarter ON ivr_calls(quarter, year);
```

---

## ⚠️ ERRORES COMUNES

### Error 1: No aplicar Test de Observabilidad

❌ **Incorrecto:**
```
BR-IACT-046: Marcar sesiones expiradas
Genera UC: SÍ (asume que siempre genera)
```

✅ **Correcto:**
```
BR-IACT-046: Marcar sesiones expiradas
Test: ¿Usuario VE algo? NO (solo cambia BD)
Tipo: INFERENCIA
Genera UC: NO (solo deriva FR directo)
```

### Error 2: Confundir FA (Flujo Alterno) con FE (Flujo Excepción)

❌ **Incorrecto:**
```
FA-1: Error de Base de Datos
En paso 5, si BD no responde...
```

✅ **Correcto:**
```
FA-1: Validación Falla (situación ESPERADA)
En paso 4, si datos inválidos...

FE-1: Error de Base de Datos (error INESPERADO)
En cualquier paso, si BD no responde...
```

### Error 3: Nomenclatura Incorrecta

❌ **Incorrecto:**
```
UC_Generar_Reporte.rst (sin módulo, sin versión)
FR_Validar.rst (sin jerarquía)
```

✅ **Correcto:**
```
UC_IACT_RPT_01_Generar_Reporte_4_0_0.rst
FR_RPT_01_01_Validar_Parametros_1_0_0.rst
```

---

## 📚 REFERENCIAS

**Estándares del Proyecto:**
- `STD_001_Estandares_Documentacion_1_1_0.rst`
- `NOM_001_Nomenclatura_Proyecto_2_0_0.rst`

**Material Pedagógico:**
- `PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md`
- `PARTE_2B_Construccion_Detallada_IACT_1_0_0.md`
- `PARTE_3B_Tecnica_Larman_IACT_1_0_0.md`
- `PARTE_3C_UI_Stakeholders_IACT_1_0_0.md`
- `PARTE_4_Requisitos_Funcionales_IACT_1_0_0.md`
- `PARTE_5_Trazabilidad_Gestion_IACT_1_0_0.md`

**Metodologías:**
- Cockburn, Alistair. "Writing Effective Use Cases"
- Larman, Craig. "Applying UML and Patterns"
- IIBA. "BABOK v3 - Business Analysis Body of Knowledge"

---

**Última Actualización:** 2026-01-09  
**Versión Templates:** 1.1.0  
**Mantenido por:** Equipo IACT Base Cognitiva
