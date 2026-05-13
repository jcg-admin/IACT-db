# PLAN MAESTRO: Actualización de Referencias a Nomenclatura v4.0.0

**Fecha:** 2026-01-07  
**Versión Plan:** 1.0.0  
**Estado:** EN ANÁLISIS - PENDIENTE APROBACIÓN  
**Autor:** Equipo IACT

---

## ÍNDICE

1. [Resumen Ejecutivo](#1-resumen-ejecutivo)
2. [Alcance del Plan](#2-alcance-del-plan)
3. [Inventario Completo](#3-inventario-completo)
4. [Mapeo v2.0 → v4.0.0](#4-mapeo-v20--v400)
5. [Metodología por Componente](#5-metodología-por-componente)
6. [Estimaciones de Tiempo](#6-estimaciones-de-tiempo)
7. [Fases de Implementación](#7-fases-de-implementación)
8. [Checklist de Validación](#8-checklist-de-validación)
9. [Riesgos y Mitigación](#9-riesgos-y-mitigación)

---

## 1. RESUMEN EJECUTIVO

### 1.1 Situación Actual

El proyecto IACT migró de nomenclatura **v2.0** (UC-010, UC-043) a **v4.0.0** (UC_ACC_01, UC_ACC_05) en enero 2026. 

**Problema:** ~**97 referencias obsoletas** distribuidas en 20 archivos de base_cognitiva/ y 7 módulos UC pendientes de verificación.

### 1.2 Objetivo

Actualizar TODAS las referencias a nomenclatura v4.0.0 para:
- ✅ Eliminar inconsistencias documentales
- ✅ Facilitar búsquedas y navegación
- ✅ Mejorar onboarding de nuevos miembros
- ✅ Mantener integridad de trazabilidad

### 1.3 Alcance

| Componente | Archivos | Referencias | Estado |
|------------|----------|-------------|--------|
| **access/index.rst** | 1 | ~15 | ✅ SOLUCIÓN LISTA |
| **_fundamentos_conceptuales/** | 7 | ~20 | ⏳ PENDIENTE |
| **metamodelos/** | 3 | ~16 | ⏳ PENDIENTE |
| **taxonomias/** | 3 | ~25 | ⏳ PENDIENTE |
| **Otros 7 módulos UC** | 7 | ~21 | ⏳ NO VERIFICADO |
| **TOTAL** | **21** | **~97** | - |

### 1.4 Esfuerzo Estimado

- **Análisis y mapeo:** 2-3 horas (✅ COMPLETADO)
- **Actualización:** 8-12 horas
- **Validación:** 2-3 horas
- **TOTAL:** **12-18 horas** de trabajo técnico

---

## 2. ALCANCE DEL PLAN

### 2.1 Componentes Incluidos

#### ✅ Ya Verificados
1. access/ (UC individuales) - OK, sin cambios
2. access/index.rst - ✅ **SOLUCIÓN LISTA** (index_access_v4.rst)
3. _metadata/ - OK, sin cambios
4. _ontologia_sbvr/ - OK, sin cambios

#### ⏳ Pendientes de Actualizar
5. _fundamentos_conceptuales/ (~20 referencias)
6. _taxonomias_y_metamodelos/metamodelos/ (~16 referencias)
7. _taxonomias_y_metamodelos/taxonomias/ (~25 referencias)

#### ❓ Pendientes de Verificar
8. auth/index.rst
9. users/index.rst
10. pipeline/index.rst
11. reports/index.rst
12. alerts/index.rst
13. audit/index.rst
14. logs/index.rst

### 2.2 Componentes Excluidos

- ✅ Archivos UC individuales (ya están en v4.0.0)
- ✅ _metadata/ (sin referencias UC)
- ✅ _ontologia_sbvr/ (referencias genéricas correctas)
- ❌ Código fuente Python (fuera de alcance documental)
- ❌ Bases de datos (fuera de alcance documental)

---

## 3. INVENTARIO COMPLETO

### 3.1 Componente: access/index.rst

**Archivo:** `source/requisitos/casos_uso/access/index.rst`  
**Estado:** ✅ **SOLUCIÓN LISTA**  
**Archivo Generado:** `index_access_v4.rst`

**Referencias a actualizar: 15**

| Línea(s) | Antigua | Nueva | Contexto |
|----------|---------|-------|----------|
| 35 | 9 (UC-010, UC-011...) | 9 (UC_ACC_01...) | Resumen |
| 59-103 | UC-010 a UC-047 | UC_ACC_01 a UC_ACC_09 | Tabla UC |
| 110-168 | UC-010, UC-011, UC-041 | UC_ACC_01, UC_ACC_02, etc. | Descripciones |
| 207-232 | UC-010 a UC-047 | UC_ACC_01 a UC_ACC_09 | Tabla funciones RBAC |
| 246-254 | UC-010, UC-043 | UC_ACC_01, UC_ACC_05 | Trazabilidad BR |
| 262-270 | UC_010_Asignar... | UC_ACC_01_Asignar... | Toctree |

**Acción:** Reemplazar archivo completo

```bash
cp index_access_v4.rst source/requisitos/casos_uso/access/index.rst
```

---

### 3.2 Componente: _fundamentos_conceptuales/

**Ubicación:** `source/base_cognitiva/_fundamentos_conceptuales/`  
**Estado:** ⏳ PENDIENTE  
**Referencias:** ~20

#### Archivo: FND_01_Concepto_Requisito.rst (~3 referencias)

| Línea | Antigua | Nueva | Contexto |
|-------|---------|-------|----------|
| 316 | UC-40 | UC_XXX (genérico) | Ejemplo paso UC |
| 490 | UC-015 | UC_RPT_XX | Ejemplo nomenclatura |
| 491 | FR-015.3 | FR_RPT_XX_03 | Ejemplo FR derivado |

#### Archivo: FND_03_Casos_de_Uso.rst (~17 referencias)

| Línea(s) | Antigua | Nueva | Contexto |
|----------|---------|-------|----------|
| 100 | UC-043 | UC_ACC_05 | Ejemplo UC vs FR |
| 160-163 | UC-043 | UC_ACC_05 | Ejemplo estructura |
| 265-274 | UC-006 a UC-009, UC-010, UC-017-024, etc. | UC_USR_XX, UC_ACC_XX, UC_RPT_XX | Tabla agrupadores |
| 277 | UC-050 | UC_PIP_01 | Actor TIEMPO |
| 614-616 | UC-001, UC-002, UC-003 | UC_AUTH_01, UC_AUTH_02, UC_AUTH_03 | Ejemplos autenticación |

**Estrategia:**
- Actualizar ejemplos concretos a v4.0.0
- Mantener conceptos teóricos sin cambios
- Verificar que referencias sean ejemplos ilustrativos

---

### 3.3 Componente: metamodelos/

**Ubicación:** `source/base_cognitiva/_taxonomias_y_metamodelos/metamodelos/`  
**Estado:** ⏳ PENDIENTE  
**Referencias:** ~16

#### MTM_01_Metamodelo_Requisitos.rst (~6 referencias)

| Línea | Antigua | Nueva | Contexto |
|-------|---------|-------|----------|
| 413 | UC_010 | UC_ACC_01 | Diagrama relación BR→UC |
| 434 | UC_010 | UC_ACC_01 | Diagrama UC→FR |
| 451 | UC_ETL | UC_PIP_01 | Ejemplo BR→UC |
| 597 | UC_010 | UC_ACC_01 | Instancia UseCase |
| 606 | UC_010 | UC_ACC_01 | Ejemplo código |

#### MTM_02_Metamodelo_Trazabilidad.rst (~9 referencias)

| Línea | Antigua | Nueva | Contexto |
|-------|---------|-------|----------|
| 241 | UC_010 | UC_ACC_01 | Relación deriva |
| 244 | UC_010 | UC_ACC_01 | Relación influye |
| 253 | UC_010 | UC_ACC_01 | Relación refina |
| 256 | UC_010 | UC_ACC_01 | Relación satisface |
| 282 | UC_010 | UC_ACC_01 | Ejemplo trazabilidad |
| 316 | UC_010 | UC_ACC_01 | Diagrama |
| 331 | UC_010 | UC_ACC_01 | Cadena trazabilidad |
| 359 | UC_010 | UC_ACC_01 | Tabla RTM |
| 482 | UC_010 | UC_ACC_01 | Análisis impacto |
| 535-538 | UC-010 | UC_ACC_01 | Tabla RTM ejemplo |

#### MTM_03_Metamodelo_RBAC.rst (~1 referencia)

| Línea | Antigua | Nueva | Contexto |
|-------|---------|-------|----------|
| 696 | UC-005 a UC-011 | UC_USR_XX, UC_ACC_XX | Trazabilidad RBAC |

**Estrategia:**
- Actualizar todas las tablas RTM
- Actualizar diagramas de relaciones
- Mantener estructura formal del metamodelo

---

### 3.4 Componente: taxonomias/

**Ubicación:** `source/base_cognitiva/_taxonomias_y_metamodelos/taxonomias/`  
**Estado:** ⏳ PENDIENTE  
**Referencias:** ~25

#### TXM_01_Taxonomia_Requisitos.rst (~20 referencias)

**Ejemplos por tipo (6 referencias):**

| Línea | Antigua | Nueva | Contexto |
|-------|---------|-------|----------|
| 214 | UC-006 | UC_USR_01 | Ejemplo UC Gestión |
| 214 | UC-010 | UC_ACC_01 | Ejemplo UC Gestión |
| 217 | UC-017 | UC_RPT_01 | Ejemplo UC Consulta |
| 217 | UC-025 | UC_RPT_09 | Ejemplo UC Consulta |
| 220 | UC-022 | UC_RPT_06 | Ejemplo UC Proceso |
| 220 | UC-037 | UC_ALR_01 | Ejemplo UC Proceso |

**Rangos por dominio (6 referencias):**

| Línea | Antigua | Nueva | Contexto |
|-------|---------|-------|----------|
| 236 | UC-005 a UC-011, UC-041, UC-042 | UC_USR_01-04, UC_ACC_01-09 | Gestión Usuarios |
| 239 | UC-017 a UC-024 | UC_RPT_01-14 | Reportes |
| 242 | UC-025 a UC-030 | UC_RPT_09-14 (parcial) | Dashboards |
| 245 | UC-031 a UC-035 | (eliminar, no existe en v4.0) | Análisis |
| 248 | UC-036 a UC-040 | UC_ALR_01-05 | Alertas |
| 251 | UC-012 a UC-016, UC-043 | UC_AUD_XX, UC_ACC_05 | Administración |

**Nomenclatura FR (3 referencias):**

| Línea | Antigua | Nueva | Contexto |
|-------|---------|-------|----------|
| 301 | FR-10.1 | FR_ACC_01_01 | Ejemplo FR |
| 302 | FR-10.15 | FR_ACC_01_15 | Ejemplo FR |
| 303 | FR-017.5 | FR_RPT_01_05 | Ejemplo FR |

#### TXM_03_Taxonomia_Reglas_Negocio.rst (~5 referencias)

| Línea | Antigua | Nueva | Contexto |
|-------|---------|-------|----------|
| 214 | UC-010 | UC_ACC_01 | Genera UC SoD |
| 230 | UC-006, UC-007, UC-008 | UC_USR_01, 02, 03 | Validación permisos |
| 309 | UC-038 | UC_ALR_XX | Disparar alerta |
| 319 | UC-005 | UC_AUTH_01 | Login |

**Estrategia:**
- Actualizar ejemplos específicos
- Actualizar rangos por dominio
- Revisar si rangos v2.0 corresponden a módulos v4.0

---

### 3.5 Componentes: Otros 7 Módulos UC

**Estado:** ❓ NO VERIFICADOS  
**Acción requerida:** Verificar archivos index.rst

#### Módulos a Verificar:

| Módulo | Archivo | UC Esperados | Estado |
|--------|---------|--------------|--------|
| auth/ | index.rst | UC_AUTH_01-05 | ❓ No verificado |
| users/ | index.rst | UC_USR_01-04 | ❓ No verificado |
| pipeline/ | index.rst | UC_PIP_01-04 | ❓ No verificado |
| reports/ | index.rst | UC_RPT_01-14 | ❓ No verificado |
| alerts/ | index.rst | UC_ALR_01-05 | ❓ No verificado |
| audit/ | index.rst | UC_AUD_01-04 | ❓ No verificado |
| logs/ | index.rst | UC_LOG_01-04 | ❓ No verificado |

**Estimación:** Cada index.rst probablemente tiene ~3-5 referencias obsoletas (similar a access/)

**Total estimado:** ~21-35 referencias

---

## 4. MAPEO v2.0 → v4.0.0

### 4.1 Mapeo Completo de UC

#### MOD_Auth (UC-001 a UC-005?)

| v2.0 | v4.0.0 | Nombre |
|------|--------|--------|
| UC-001 | UC_AUTH_01 | Iniciar Sesión |
| UC-002 | UC_AUTH_02 | Cerrar Sesión |
| UC-003 | UC_AUTH_03 | Recuperar Contraseña |
| UC-004 | UC_AUTH_04 | Cambiar Contraseña |
| UC-005 | UC_AUTH_05 | Gestionar Sesiones |

#### MOD_Users (UC-006 a UC-009?)

| v2.0 | v4.0.0 | Nombre |
|------|--------|--------|
| UC-006 | UC_USR_01 | Crear Usuario |
| UC-007 | UC_USR_02 | Consultar Usuarios |
| UC-008 | UC_USR_03 | Modificar Usuario |
| UC-009 | UC_USR_04 | Eliminar Usuario |

#### MOD_Access (UC-010, UC-041-047)

| v2.0 | v4.0.0 | Nombre |
|------|--------|--------|
| UC-010 | UC_ACC_01 | Asignar Funciones |
| UC-011 | UC_ACC_02 | Revocar Funciones |
| UC-044 | UC_ACC_03 | Consultar Permisos |
| - | UC_ACC_04 | Asignar Agrupador (nuevo) |
| UC-043 | UC_ACC_05 | Gestionar SoD |
| UC-046? | UC_ACC_06 | Gestionar Segmentos |
| UC-041 | UC_ACC_07 | Asignar Segmento |
| - | UC_ACC_08 | Permiso Temporal (nuevo) |
| UC-047 | UC_ACC_09 | Auditar Cambios Acceso |

**Nota:** UC-042 (Revocar Segmento), UC-045 (Gestionar Agrupadores) eliminados en v4.0

#### MOD_Reports (UC-017 a UC-030?)

| v2.0 | v4.0.0 | Nombre |
|------|--------|--------|
| UC-017 | UC_RPT_01 | Consultar Reporte Trimestral |
| UC-018 | UC_RPT_02 | Consultar Problemas Menú |
| UC-019 | UC_RPT_03 | Consultar Transferencias |
| UC-020 | UC_RPT_04 | Filtrar Por Fecha |
| UC-021 | UC_RPT_05 | Filtrar Por Centro |
| UC-022 | UC_RPT_06 | Exportar CSV |
| UC-023 | UC_RPT_07 | Exportar Excel |
| UC-024 | UC_RPT_08 | Exportar PDF |
| UC-025 | UC_RPT_09 | Ver Dashboard |
| UC-026 | UC_RPT_10 | Ver KPIs |
| UC-027 | UC_RPT_11 | Ver Tendencias |
| UC-028 | UC_RPT_12 | Ver Gráfico Hora |
| UC-029 | UC_RPT_13 | Ver Gráfico Día |
| UC-030 | UC_RPT_14 | Ver Distribución Centro |

#### MOD_Alerts (UC-036 a UC-040)

| v2.0 | v4.0.0 | Nombre |
|------|--------|--------|
| UC-036 | UC_ALR_01 | Configurar Alerta |
| UC-037 | UC_ALR_02 | Consultar Alertas |
| UC-038 | UC_ALR_03 | Pausar Alerta |
| UC-039 | UC_ALR_04 | Eliminar Alerta |
| UC-040 | UC_ALR_05 | Gestionar Destinatarios |

#### MOD_Pipeline (UC-050 a UC-053, UC-ETL)

| v2.0 | v4.0.0 | Nombre |
|------|--------|--------|
| UC-050, UC-ETL | UC_PIP_01 | Supervisar ETL |
| UC-051 | UC_PIP_02 | Consultar Errores ETL |
| UC-052 | UC_PIP_03 | Consultar Disponibilidad |
| UC-053 | UC_PIP_04 | Solicitar Reintento |

#### MOD_Audit (UC-060 a UC-063)

| v2.0 | v4.0.0 | Nombre |
|------|--------|--------|
| UC-060 | UC_AUD_01 | Consultar Auditoría |
| UC-061 | UC_AUD_02 | Generar Reporte Compliance |
| UC-062 | UC_AUD_03 | Exportar Auditoría |
| UC-063 | UC_AUD_04 | Registrar Evento |

#### MOD_Logs (UC-070 a UC-073)

| v2.0 | v4.0.0 | Nombre |
|------|--------|--------|
| UC-070 | UC_LOG_01 | Consultar Logs |
| UC-071 | UC_LOG_02 | Filtrar Logs |
| UC-072 | UC_LOG_03 | Exportar Logs |
| UC-073 | UC_LOG_04 | Configurar Retención |

### 4.2 Rangos que Desaparecen en v4.0

| Rango v2.0 | Razón |
|------------|-------|
| UC-031 a UC-035 | Módulo "Análisis" no existe en v4.0 (consolidado en Reports) |
| UC-012 a UC-016 | Probablemente consolidado en otros módulos |

---

## 5. METODOLOGÍA POR COMPONENTE

### 5.1 Para index.rst de Módulos UC

**Plantilla de Actualización (ya probada en access/):**

```rst
MOD_[XXX]: Casos de Uso [Nombre Módulo]
=======================================

Resumen
-------
* UC Documentados: X (UC_[MOD]_01 a UC_[MOD]_0X)
* Version: 4.0.0

Casos de Uso
------------
.. list-table::
   :widths: 15 35 12 12 26
   :header-rows: 1

   * - ID
     - Nombre
     - Complej.
     - Diag.
     - Estado
   * - UC_[MOD]_01
     - [Nombre]
     - Alta/Media/Baja
     - 3
     - Completado
   [... resto de UC ...]

.. toctree::
   :maxdepth: 1
   :caption: Casos de Uso

   UC_[MOD]_01_[Nombre_Archivo]
   UC_[MOD]_02_[Nombre_Archivo]
   [... resto ...]
```

**Pasos:**
1. Abrir index.rst del módulo
2. Buscar todas las referencias UC-XXX
3. Reemplazar con UC_MOD_NN según mapeo
4. Actualizar toctree con nombres de archivo correctos
5. Actualizar versión a 4.0.0
6. Agregar entrada en historial de cambios

**Tiempo:** ~30 min por módulo × 7 módulos = **3.5 horas**

---

### 5.2 Para _fundamentos_conceptuales/

**Estrategia:**
- Actualizar ejemplos concretos (UC-043 → UC_ACC_05)
- Mantener explicaciones teóricas
- Verificar que conceptos no cambien

**Archivos:**
- FND_01_Concepto_Requisito.rst
- FND_03_Casos_de_Uso.rst

**Pasos:**
1. Abrir archivo FND
2. Buscar cada referencia UC-XXX
3. Determinar si es ejemplo ilustrativo o referencia específica
4. Reemplazar con UC_MOD_NN según mapeo
5. Actualizar fecha de última modificación
6. Agregar nota en historial

**Tiempo:** ~2-3 horas para 2 archivos principales

---

### 5.3 Para metamodelos/

**Estrategia:**
- Actualizar tablas RTM (críticas para trazabilidad)
- Actualizar diagramas de relaciones
- Mantener estructura formal UML

**Archivos:**
- MTM_01_Metamodelo_Requisitos.rst
- MTM_02_Metamodelo_Trazabilidad.rst
- MTM_03_Metamodelo_RBAC.rst

**Pasos:**
1. Abrir archivo MTM
2. Buscar cada referencia UC_010, UC-010, UC-XXX
3. Reemplazar con UC_ACC_01 u otro según mapeo
4. Actualizar todas las tablas RTM ejemplo
5. Verificar coherencia de relaciones
6. Actualizar versión y historial

**Tiempo:** ~1-2 horas para 3 archivos

---

### 5.4 Para taxonomias/

**Estrategia:**
- Actualizar ejemplos específicos
- Actualizar rangos por dominio funcional
- Verificar correspondencia rangos v2.0 → módulos v4.0

**Archivos:**
- TXM_01_Taxonomia_Requisitos.rst
- TXM_03_Taxonomia_Reglas_Negocio.rst

**Pasos:**
1. Abrir archivo TXM
2. Actualizar tabla "Ejemplos por tipo"
3. Actualizar tabla "Rangos por dominio funcional"
4. Revisar si rangos v2.0 corresponden a módulos v4.0
5. Actualizar nomenclatura FR (FR-10.1 → FR_ACC_01_01)
6. Actualizar versión y historial

**Tiempo:** ~2-3 horas para 2 archivos

---

## 6. ESTIMACIONES DE TIEMPO

### 6.1 Por Componente

| Componente | Archivos | Referencias | Tiempo | Dificultad |
|------------|----------|-------------|--------|------------|
| access/index.rst | 1 | 15 | 0h (✅ listo) | N/A |
| Otros 7 módulos UC | 7 | ~21-35 | 3-4h | Baja |
| _fundamentos_conceptuales/ | 2 | ~20 | 2-3h | Media |
| metamodelos/ | 3 | ~16 | 1-2h | Baja |
| taxonomias/ | 2 | ~25 | 2-3h | Media |
| **TOTAL ACTUALIZACIÓN** | **15** | **~97** | **8-12h** | - |

### 6.2 Fases de Trabajo

| Fase | Actividad | Tiempo |
|------|-----------|--------|
| ✅ 0 | Análisis y mapeo | 2-3h (completado) |
| ⏳ 1 | Verificar 7 módulos UC | 1h |
| ⏳ 2 | Actualizar 7 módulos UC | 3-4h |
| ⏳ 3 | Actualizar fundamentos | 2-3h |
| ⏳ 4 | Actualizar metamodelos | 1-2h |
| ⏳ 5 | Actualizar taxonomías | 2-3h |
| ⏳ 6 | Validación y testing | 2-3h |
| | **TOTAL** | **13-19h** |

---

## 7. FASES DE IMPLEMENTACIÓN

### FASE 0: Preparación ✅ COMPLETADO

**Duración:** 2-3 horas

- [x] Análisis completo de base_cognitiva/
- [x] Análisis de access/ UC
- [x] Creación de mapeo v2.0 → v4.0.0
- [x] Generación de index_access_v4.rst
- [x] Creación de documento NOM_01 (nomenclatura)
- [x] Creación de este plan maestro

---

### FASE 1: Verificación Módulos UC

**Duración:** 1 hora  
**Objetivo:** Verificar index.rst de los 7 módulos restantes

**Actividades:**
1. Solicitar archivos index.rst de:
   - auth/
   - users/
   - pipeline/
   - reports/
   - alerts/
   - audit/
   - logs/

2. Para cada módulo:
   - [ ] Verificar nomenclatura en tabla de UC
   - [ ] Verificar toctree
   - [ ] Identificar referencias obsoletas
   - [ ] Documentar hallazgos

3. Generar versiones actualizadas (índex_[modulo]_v4.rst)

**Entregables:**
- [ ] Reporte de verificación (7 módulos)
- [ ] 7 archivos index_[modulo]_v4.rst

---

### FASE 2: Actualización Módulos UC

**Duración:** 3-4 horas  
**Objetivo:** Implementar versiones v4.0.0 de index.rst

**Actividades:**
1. Para cada módulo:
   - [ ] Reemplazar index.rst antiguo con versión v4.0
   - [ ] Verificar que toctree apunte a archivos existentes
   - [ ] Actualizar versión y historial
   - [ ] Validar build Sphinx sin warnings

2. Testing:
   - [ ] `make clean`
   - [ ] `make html`
   - [ ] Verificar navegación en navegador
   - [ ] Verificar links internos

**Entregables:**
- [ ] 7 archivos index.rst actualizados en proyecto
- [ ] Build HTML sin warnings

---

### FASE 3: Actualización Fundamentos Conceptuales

**Duración:** 2-3 horas  
**Objetivo:** Actualizar ejemplos en FND_01 y FND_03

**Actividades:**
1. FND_01_Concepto_Requisito.rst:
   - [ ] Línea 316: UC-40 → UC_XXX (genérico)
   - [ ] Línea 490: UC-015 → UC_RPT_XX
   - [ ] Línea 491: FR-015.3 → FR_RPT_XX_03
   - [ ] Actualizar fecha y versión

2. FND_03_Casos_de_Uso.rst:
   - [ ] Línea 100: UC-043 → UC_ACC_05
   - [ ] Líneas 160-163: UC-043 → UC_ACC_05
   - [ ] Líneas 265-274: Tabla agrupadores completa
   - [ ] Línea 277: UC-050 → UC_PIP_01
   - [ ] Líneas 614-616: UC-001/002/003 → UC_AUTH_01/02/03
   - [ ] Actualizar fecha y versión

3. Validación:
   - [ ] Build Sphinx sin warnings
   - [ ] Verificar coherencia conceptual

**Entregables:**
- [ ] FND_01 actualizado
- [ ] FND_03 actualizado
- [ ] Entrada en historial de cambios

---

### FASE 4: Actualización Metamodelos

**Duración:** 1-2 horas  
**Objetivo:** Actualizar referencias en MTM_01, MTM_02, MTM_03

**Actividades:**
1. MTM_01_Metamodelo_Requisitos.rst:
   - [ ] Líneas 413, 434, 451, 597, 606: UC_010 → UC_ACC_01
   - [ ] Línea 451: UC_ETL → UC_PIP_01
   - [ ] Actualizar versión

2. MTM_02_Metamodelo_Trazabilidad.rst:
   - [ ] Líneas 241-482: UC_010 → UC_ACC_01
   - [ ] Líneas 535-538: Tabla RTM UC-010 → UC_ACC_01
   - [ ] Actualizar versión

3. MTM_03_Metamodelo_RBAC.rst:
   - [ ] Línea 696: UC-005 a UC-011 → "UC_USR_01-04, UC_ACC_01-02"
   - [ ] Actualizar versión

4. Validación:
   - [ ] Tablas RTM coherentes
   - [ ] Diagramas actualizados
   - [ ] Build sin warnings

**Entregables:**
- [ ] 3 archivos MTM actualizados
- [ ] Trazabilidad verificada

---

### FASE 5: Actualización Taxonomías

**Duración:** 2-3 horas  
**Objetivo:** Actualizar ejemplos y rangos en TXM_01 y TXM_03

**Actividades:**
1. TXM_01_Taxonomia_Requisitos.rst:
   - [ ] Líneas 214-220: Actualizar 6 ejemplos por tipo
   - [ ] Líneas 236-251: Actualizar 6 rangos por dominio
   - [ ] Líneas 301-303: Actualizar nomenclatura FR
   - [ ] Revisar si rangos v2.0 corresponden a v4.0
   - [ ] Actualizar versión

2. TXM_03_Taxonomia_Reglas_Negocio.rst:
   - [ ] Líneas 214, 230, 309, 319: Actualizar referencias UC
   - [ ] Actualizar versión

3. Validación:
   - [ ] Rangos coherentes con módulos v4.0
   - [ ] Ejemplos consistentes
   - [ ] Build sin warnings

**Entregables:**
- [ ] 2 archivos TXM actualizados
- [ ] Taxonomía coherente con v4.0.0

---

### FASE 6: Validación Final

**Duración:** 2-3 horas  
**Objetivo:** Validar integridad completa del proyecto

**Actividades:**
1. Build Completo:
   - [ ] `make clean`
   - [ ] `make html`
   - [ ] `make linkcheck` (verificar links rotos)
   - [ ] 0 warnings relacionados con UC

2. Navegación Manual:
   - [ ] Verificar 8 módulos UC en HTML
   - [ ] Verificar fundamentos conceptuales
   - [ ] Verificar metamodelos
   - [ ] Verificar taxonomías
   - [ ] Verificar links internos `:doc:`

3. Búsqueda de Residuos:
   ```bash
   grep -r "UC-[0-9]" source/ --exclude-dir=_build
   grep -r "UC_010" source/ --exclude-dir=_build
   ```
   - [ ] 0 referencias a UC-XXX (formato antiguo)
   - [ ] 0 referencias a UC_010 sin módulo

4. Documentación:
   - [ ] Actualizar CHANGELOG del proyecto
   - [ ] Documentar cambios en reunión de equipo
   - [ ] Actualizar wiki si existe

**Entregables:**
- [ ] Build HTML completo sin warnings
- [ ] Reporte de validación
- [ ] Documentación actualizada

---

## 8. CHECKLIST DE VALIDACIÓN

### 8.1 Por Archivo Modificado

Antes de marcar como completado:

- [ ] Todas las referencias UC-XXX actualizadas
- [ ] Todas las referencias UC_010 (sin módulo) actualizadas
- [ ] Versión incrementada correctamente
- [ ] Fecha de última modificación actualizada
- [ ] Entrada agregada en historial de cambios
- [ ] Build Sphinx sin warnings
- [ ] Links internos funcionando

### 8.2 Por Módulo/Componente

- [ ] Todos los archivos del componente actualizados
- [ ] Navegación HTML funcionando
- [ ] Toctree sin referencias rotas
- [ ] Búsqueda de texto encuentra UC correctos
- [ ] Sin referencias residuales a v2.0

### 8.3 Global

- [ ] 0 referencias a UC-XXX en todo el proyecto
- [ ] 0 referencias a UC_010 sin módulo
- [ ] Build completo sin warnings
- [ ] Linkcheck sin errores
- [ ] Documentación de cambios completa
- [ ] Equipo notificado

---

## 9. RIESGOS Y MITIGACIÓN

### 9.1 Riesgos Identificados

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| **Mapeo incorrecto v2.0→v4.0** | Media | Alto | Verificar módulos UC reales antes de actualizar taxonomías |
| **Referencias rotas en toctree** | Media | Medio | Validar cada toctree con build Sphinx |
| **Inconsistencia conceptual** | Baja | Alto | Revisar que ejemplos ilustrativos mantengan sentido |
| **Tiempo subestimado** | Media | Medio | Incluir 30% buffer en estimaciones |
| **Build Sphinx falla** | Baja | Alto | Testing incremental por fase |

### 9.2 Plan de Rollback

Si algo falla durante implementación:

1. **Git:** Cada fase debe ser un commit separado
   ```bash
   git commit -m "FASE X: [descripción]"
   ```

2. **Rollback por fase:**
   ```bash
   git revert [commit-hash]
   ```

3. **Validación antes de siguiente fase:**
   - Build exitoso → Continuar
   - Build con warnings → Revisar y corregir
   - Build falla → Rollback inmediato

---

## 10. APROBACIÓN Y SEGUIMIENTO

### 10.1 Aprobaciones Requeridas

| Rol | Responsabilidad | Estado |
|-----|-----------------|--------|
| **Arquitecto de Documentación** | Aprobar plan maestro | ⏳ Pendiente |
| **BA Lead** | Validar mapeo UC | ⏳ Pendiente |
| **Equipo Técnico** | Revisar cambios | ⏳ Pendiente |

### 10.2 Seguimiento

**Reunión de kickoff:** [Fecha TBD]  
**Checkpoints semanales:** Lunes 10:00 AM  
**Revisión final:** [Fecha TBD]

**Herramienta de seguimiento:** [Jira/Trello/GitHub Issues]

---

## ANEXOS

### Anexo A: Comandos Útiles

```bash
# Buscar referencias antiguas
grep -rn "UC-[0-9]" source/base_cognitiva/
grep -rn "UC_010" source/

# Build y validación
make clean
make html
make linkcheck

# Ver warnings
make html 2>&1 | grep -i warning

# Reemplazos masivos (CUIDADO)
find source/ -name "*.rst" -exec sed -i 's/UC-010/UC_ACC_01/g' {} +
```

### Anexo B: Plantilla de Commit

```
FASE X: [Título de la fase]

Componente: [nombre]
Referencias actualizadas: [número]
Tiempo: [horas]

Cambios:
- [cambio 1]
- [cambio 2]

Validación:
- [ ] Build exitoso
- [ ] Sin warnings
- [ ] Links funcionando
```

---

**FIN DEL PLAN MAESTRO**

**Versión:** 1.0.0  
**Fecha:** 2026-01-07  
**Estado:** EN ANÁLISIS - PENDIENTE APROBACIÓN
