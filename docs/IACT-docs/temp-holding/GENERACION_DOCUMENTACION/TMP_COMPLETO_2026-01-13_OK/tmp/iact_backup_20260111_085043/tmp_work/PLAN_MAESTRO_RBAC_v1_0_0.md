# PLAN MAESTRO: Actualización RBAC v5.1.1 + Documentación IACT

**Versión del Plan:** 1.0.0  
**Fecha:** 2026-01-11  
**Estado:** Aprobado para ejecución  
**Alcance:** Implementación completa modelo RBAC v5.1.1 en documentación

---

## 📋 TABLA DE CONTENIDO

1. [Resumen Ejecutivo](#resumen-ejecutivo)
2. [Inventario Actual](#inventario-actual)
3. [Plan de Versiones](#plan-versiones)
4. [Fases del Proyecto](#fases-proyecto)
5. [Cronograma](#cronograma)
6. [Dependencias](#dependencias)
7. [Métricas y Validación](#metricas)
8. [Riesgos y Mitigaciones](#riesgos)

---

<a name="resumen-ejecutivo"></a>
## 1. RESUMEN EJECUTIVO

### 1.1 Objetivo

Actualizar la documentación completa del proyecto IACT para reflejar el modelo RBAC v5.1.1 con:
- 44 funciones atómicas
- 10 agrupadores
- 3 restricciones SoD
- 5 segmentos de datos
- 8 restricciones CNST actualizadas

### 1.2 Alcance

```
FASES A EJECUTAR:
├── FASE 15: CNST v1.0.0 (Crear/Actualizar)
├── FASE 16: UC v1.0.0 (Crear con RBAC)
├── FASE 14: Índices RBAC v1.0.0 (Nuevos)
├── FASE 14b: Índices Generales v1.0.0 (Completar)
└── FASE 17: Validación Final

TOTAL DOCUMENTOS: 62 documentos nuevos/actualizados
TOTAL ESFUERZO: 29-31 horas
DURACIÓN: 4-5 días laborables
```

### 1.3 Resultado Esperado

```
base_cognitiva/
├── fundacionales/          (2 archivos - sin cambios)
├── cnst/                   (8 archivos - NUEVOS v1.0.0)
├── casos_uso/              (47 archivos - NUEVOS v1.0.0)
├── indices/                (7 archivos - NUEVOS v1.0.0)
├── pedagogico/             (12 archivos - sin cambios)
├── templates/              (12 archivos - sin cambios)
└── originales/             (16 archivos - archivados)
```

---

<a name="inventario-actual"></a>
## 2. INVENTARIO ACTUAL

### 2.1 Estado Actual de la Documentación

| Categoría | Documentos | Estado | Versión | Acción |
|-----------|------------|--------|---------|--------|
| Fundacionales | 2 | ✅ Completado | v2.0.0, v1.1.0 | Sin cambios |
| Pedagógico | 12 | ✅ Completado | v1.0.0 | Sin cambios |
| Templates | 12 | ✅ Completado | v1.3.0, v1.2.0 | Sin cambios |
| **CNST** | **0** | **❌ NO EXISTEN** | **-** | **Crear v1.0.0** |
| **UC** | **0** | **❌ NO EXISTEN** | **-** | **Crear v1.0.0** |
| **Índices** | **0** | **❌ NO EXISTEN** | **-** | **Crear v1.0.0** |
| Originales | 16 | ✅ Archivados | Sin versión | Sin cambios |

**CRÍTICO:** Los documentos CNST y UC están **completamente ausentes** de la base actual.

### 2.2 Documentos en /originales/ (Archivados)

```
Archivos META_* (7):
  - META_01_Identidad_Proyecto.rst
  - META_02_Clasificacion_Documental.rst
  - META_03_Fases_SDLC.rst
  - META_04_Contexto_IACT.rst
  - META_05_Estructura_Documental.rst
  - MTM_02_Metamodelo_Trazabilidad.rst
  - MTM_03_Metamodelo_RBAC.rst

Archivos FND_* (6):
  - FND_01_Concepto_Requisito.rst
  - FND_03_Casos_de_Uso.rst
  - FND_04_Trazabilidad.rst
  - FND_05_Jerarquia_4_Niveles.rst
  - FND_06_Derivacion_vs_Transformacion.rst
  - FND_07_Requerimientos_Funcionales.rst

Modelos originales (3):
  - MODELO_DOCUMENTAL_IACT_v2_2_0_PARTE1.md
  - MODELO_DOCUMENTAL_IACT_v2_2_0_PARTE2.md
  - MODELO_RBAC_IACT_v5_1_1.md (NO está, es upload nuevo)

ESTADO: Archivados, no requieren actualización
```

---

<a name="plan-versiones"></a>
## 3. PLAN DE VERSIONES

### 3.1 Criterios de Versionado (NOM_001 v2.0.0)

```yaml
Versionado Semántico: MAJOR.MINOR.PATCH

MAJOR (X.0.0):
  - Cambios incompatibles con versiones anteriores
  - Cambio de estructura fundamental
  - Ejemplo: v1.0.0 → v2.0.0

MINOR (0.X.0):
  - Nuevas funcionalidades compatibles
  - Adición de secciones
  - Ejemplo: v1.0.0 → v1.1.0

PATCH (0.0.X):
  - Correcciones de errores
  - Clarificaciones
  - Ejemplo: v1.0.0 → v1.0.1
```

### 3.2 Documentos NUEVOS (Versión Inicial: 1.0.0)

Todos los documentos que **NO EXISTEN** comenzarán con versión **1.0.0**:

#### 3.2.1 CNST - Restricciones (8 documentos)

| Documento | Versión Inicial | Razón |
|-----------|----------------|-------|
| CNST_001_No_Email_Sistema_1_0_0.rst | 1.0.0 | Documento nuevo |
| CNST_002_Sesiones_BD_Timeout_1_0_0.rst | 1.0.0 | Documento nuevo |
| CNST_003_BD_IVR_Readonly_ETL_1_0_0.rst | 1.0.0 | Documento nuevo |
| CNST_004_Alertas_Buzon_Interno_1_0_0.rst | 1.0.0 | Documento nuevo |
| **CNST_005_RBAC_Flat_SoD_Permisos_1_0_0.rst** | **1.0.0** | **Documento nuevo CORE** |
| CNST_006_Reportes_Limites_Rango_1_0_0.rst | 1.0.0 | Documento nuevo |
| CNST_007_Limites_Exportacion_Throttling_1_0_0.rst | 1.0.0 | Documento nuevo |
| CNST_008_Audit_Inmutable_Logs_PII_1_0_0.rst | 1.0.0 | Documento nuevo |

#### 3.2.2 UC - Casos de Uso (~47 documentos)

Todos con versión **1.0.0** (documentos nuevos):

| Módulo | UCs | Nomenclatura | Versión |
|--------|-----|--------------|---------|
| MOD_Auth | UC-001 a UC-005 | UC_AUTH_NNN_Nombre_1_0_0.rst | 1.0.0 |
| MOD_Users | UC-006 a UC-009, UC-041 | UC_USR_NNN_Nombre_1_0_0.rst | 1.0.0 |
| MOD_Access | UC-010, UC-011, UC-042 a UC-047 | UC_ACC_NNN_Nombre_1_0_0.rst | 1.0.0 |
| MOD_Pipeline | UC-050 a UC-053 | UC_PIP_NNN_Nombre_1_0_0.rst | 1.0.0 |
| MOD_Reports | UC-017 a UC-029 | UC_RPT_NNN_Nombre_1_0_0.rst | 1.0.0 |
| MOD_Alerts | UC-036 a UC-040 | UC_ALR_NNN_Nombre_1_0_0.rst | 1.0.0 |
| MOD_Audit | UC-060 a UC-063 | UC_AUD_NNN_Nombre_1_0_0.rst | 1.0.0 |
| MOD_Logs | UC-070 a UC-072 | UC_LOG_NNN_Nombre_1_0_0.rst | 1.0.0 |

#### 3.2.3 Índices RBAC (4 documentos)

| Documento | Versión Inicial | Razón |
|-----------|----------------|-------|
| IDX_Catalogo_Funciones_RBAC_IACT_1_0_0.rst | 1.0.0 | Documento nuevo |
| IDX_Catalogo_Agrupadores_IACT_1_0_0.rst | 1.0.0 | Documento nuevo |
| IDX_Matriz_SoD_IACT_1_0_0.rst | 1.0.0 | Documento nuevo |
| IDX_Catalogo_Segmentos_Datos_IACT_1_0_0.rst | 1.0.0 | Documento nuevo |

#### 3.2.4 Índices Generales (3 documentos)

| Documento | Versión Inicial | Razón |
|-----------|----------------|-------|
| IDX_Maestro_Documentacion_IACT_1_0_0.md | 1.0.0 | Documento nuevo |
| IDX_Mapa_Referencias_Cruzadas_IACT_1_0_0.md | 1.0.0 | Documento nuevo |
| IDX_Catalogo_Templates_IACT_1_0_0.rst | 1.0.0 | Documento nuevo |

### 3.3 Documentos SIN CAMBIOS

| Categoría | Documentos | Versión Actual | Acción |
|-----------|------------|----------------|--------|
| Fundacionales | 2 | NOM_001 v2.0.0, STD_001 v1.1.0 | Mantener |
| Pedagógico | 12 | v1.0.0 | Mantener |
| Templates | 12 | v1.3.0 / v1.2.0 | Mantener |
| Originales | 16 | Sin versión | Mantener archivados |

---

<a name="fases-proyecto"></a>
## 4. FASES DEL PROYECTO

### 4.1 Vista General de Fases

```
┌─────────────────────────────────────────────────────────────┐
│                    PLAN DE EJECUCIÓN                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  FASE 15: CNST v1.0.0                                        │
│  ├── 15.1: CNST_005 (CORE)           2-3h   🔴 CRÍTICA      │
│  └── 15.2: CNST_001-008 (resto)      6h     🟠 ALTA         │
│                                                              │
│  FASE 16: UC v1.0.0                                          │
│  ├── 16.1: Plantilla UC con RBAC     30min  🟡 MEDIA        │
│  ├── 16.2: UC MOD_Reports (13)       1.5h   🟡 MEDIA        │
│  ├── 16.3: UC MOD_Access (8)         1h     🟡 MEDIA        │
│  ├── 16.4: UC MOD_Users (5)          30min  🟡 MEDIA        │
│  └── 16.5: UC resto (21)             1.5h   🟡 MEDIA        │
│                                                              │
│  FASE 14A: Índices RBAC v1.0.0                               │
│  ├── 14A.1: Catálogo Funciones       1h     🟢 BAJA         │
│  ├── 14A.2: Catálogo Agrupadores     1h     🟢 BAJA         │
│  ├── 14A.3: Matriz SoD               1h     🟢 BAJA         │
│  └── 14A.4: Catálogo Segmentos       1h     🟢 BAJA         │
│                                                              │
│  FASE 14B: Índices Generales v1.0.0                          │
│  ├── 14B.1: Índice Maestro           1.5h   🟢 BAJA         │
│  ├── 14B.2: Mapa Referencias         1.5h   🟢 BAJA         │
│  └── 14B.3: Catálogo Templates       1h     🟢 BAJA         │
│                                                              │
│  FASE 17: Validación Final                                   │
│  ├── 17.1: UC ↔ Funciones RBAC       2h     🟢 BAJA         │
│  ├── 17.2: Trazabilidad BR→UC→FR     3h     🟢 BAJA         │
│  ├── 17.3: CNST ↔ Funciones          2h     🟢 BAJA         │
│  ├── 17.4: SoD Consistencia          1h     🟢 BAJA         │
│  ├── 17.5: Segmentos Documentación   1h     🟢 BAJA         │
│  └── 17.6: Nomenclatura NOM_001      1h     🟢 BAJA         │
│                                                              │
└─────────────────────────────────────────────────────────────┘

TOTAL: 62 documentos, 29-31 horas
```

---

### 4.2 FASE 15: CNST v1.0.0 (8 documentos, 8-9h)

#### 15.1 CNST_005 - CORE RBAC (PRIORIDAD CRÍTICA)

```yaml
Documento: CNST_005_RBAC_Flat_SoD_Permisos_1_0_0.rst
Versión: 1.0.0
Ubicación: /base_cognitiva/cnst/
Prioridad: 🔴 CRÍTICA
Esfuerzo: 2-3 horas
Líneas: ~2,000-2,500

Secciones:
  1. Resumen Ejecutivo
  2. Filosofía "Sin Pretensiones"
  3. Arquitectura de 8 Módulos IACT
  4. Las 44 Funciones Atómicas
     - 4.1 MOD_Auth (4 funciones)
     - 4.2 MOD_Users (10 funciones)
     - 4.3 MOD_Access (6 funciones)
     - 4.4 MOD_Pipeline (4 funciones)
     - 4.5 MOD_Reports (8 funciones)
     - 4.6 MOD_Alerts (6 funciones)
     - 4.7 MOD_Audit (4 funciones)
     - 4.8 MOD_Logs (2 funciones)
  5. Los 10 Agrupadores
  6. Restricciones SoD (3)
  7. Segmentos de Datos (5)
  8. Permisos Temporales
  9. Modelo de Datos (ER + Tablas)
  10. Implementación SQL
  11. Implementación Django (decoradores + middleware)
  12. Mapeo Funciones → Casos de Uso
  13. Migración v4.0 → v5.1
  14. Ejemplos Completos
  15. Referencias

Fuentes:
  - MODELO_RBAC_IACT_v5_1_1.md (completo)
  - REFERENCIA_GLOBAL_MODULOS_IACT_v1.md

Dependencias: Ninguna (documento fundacional)
Bloquea: CNST_001-008, todos los UCs
```

#### 15.2 CNST_001 a CNST_008 (resto, 7 documentos, 6h)

| # | Documento | Versión | Líneas | Esfuerzo | Prioridad |
|---|-----------|---------|--------|----------|-----------|
| 1 | CNST_001_No_Email_Sistema_1_0_0.rst | 1.0.0 | ~500 | 30 min | 🟠 ALTA |
| 2 | CNST_002_Sesiones_BD_Timeout_1_0_0.rst | 1.0.0 | ~600 | 45 min | 🟠 ALTA |
| 3 | CNST_003_BD_IVR_Readonly_ETL_1_0_0.rst | 1.0.0 | ~800 | 1h | 🟠 ALTA |
| 4 | CNST_004_Alertas_Buzon_Interno_1_0_0.rst | 1.0.0 | ~700 | 45 min | 🟠 ALTA |
| 6 | CNST_006_Reportes_Limites_Rango_1_0_0.rst | 1.0.0 | ~600 | 45 min | 🟠 ALTA |
| 7 | CNST_007_Limites_Exportacion_Throttling_1_0_0.rst | 1.0.0 | ~700 | 45 min | 🟠 ALTA |
| 8 | CNST_008_Audit_Inmutable_Logs_PII_1_0_0.rst | 1.0.0 | ~900 | 1h | 🟠 ALTA |

**Estructura estándar de cada CNST:**

```rst
CNST_NNN - Título de la Restricción
========================================

:Restricción: CNST_NNN
:Versión: 1.0.0
:Fecha: 2026-01-11
:Estado: VIGENTE
:Prioridad: [CRÍTICA|ALTA|MEDIA]
:Ámbito: [Sistema completo|Módulos específicos]

Resumen Ejecutivo
Definición de la Restricción
Módulos Afectados
Funciones RBAC Afectadas (con códigos)
Justificación Técnica/Negocio
Implementación
Validación y Testing
Excepciones (si aplican)
Ejemplos Completos
Referencias
Historial de Cambios
```

**Dependencias:** CNST_005 completado

---

### 4.3 FASE 16: UC v1.0.0 (47 documentos, 4-5h)

#### 16.1 Plantilla UC con RBAC (30 min)

```yaml
Documento: TPL_UC_Con_RBAC_1_0_0.rst
Versión: 1.0.0
Ubicación: /base_cognitiva/templates/
Esfuerzo: 30 minutos

Secciones estándar (14 + RBAC):
  1. Título e Identificación
  2. Metadatos RBAC (NUEVO)
     - :Función_RBAC_Requerida:
     - :Agrupador_Aplicable:
     - :CNST_Aplicables:
     - :Restricción_SoD:
     - :Segmento_Datos:
     - :Módulo:
  3. Resumen
  4. Actores
  5. Precondiciones
  6. Postcondiciones
  7. Flujo Normal
  8. Flujos Alternativos
  9. Flujos de Excepción
  10. Reglas de Negocio
  11. Requisitos No Funcionales
  12. Trazabilidad
  13. Permisos RBAC Detallados (NUEVO)
  14. Notas de Implementación
  15. Wireframes/Diagramas
  16. Historia de Cambios
```

#### 16.2 UC por Módulo (47 UCs, ~4h)

**Estrategia:** Generar por prioridad de módulo

| Orden | Módulo | UCs | Esfuerzo | Prioridad |
|-------|--------|-----|----------|-----------|
| 1° | MOD_Reports | 13 | 1.5h | 🟡 Core negocio |
| 2° | MOD_Access | 8 | 1h | 🟡 Core RBAC |
| 3° | MOD_Users | 5 | 30min | 🟡 Alta |
| 4° | MOD_Auth | 5 | 30min | 🟡 Alta |
| 5° | MOD_Alerts | 5 | 30min | 🟡 Media |
| 6° | MOD_Pipeline | 4 | 20min | 🟡 Media |
| 7° | MOD_Audit | 4 | 20min | 🟡 Media |
| 8° | MOD_Logs | 3 | 15min | 🟡 Media |

**Nomenclatura:**

```
UC_[MÓDULO]_[NUM]_[Nombre_Snake_Case]_1_0_0.rst

Ejemplos:
- UC_RPT_017_Consultar_Reporte_Trimestral_1_0_0.rst
- UC_ACC_010_Asignar_Funciones_Usuario_1_0_0.rst
- UC_AUTH_001_Iniciar_Sesion_Sistema_1_0_0.rst
```

**Dependencias:** CNST_005 completado, plantilla UC con RBAC

---

### 4.4 FASE 14A: Índices RBAC v1.0.0 (4 documentos, 4h)

| # | Documento | Versión | Líneas | Esfuerzo | Contenido |
|---|-----------|---------|--------|----------|-----------|
| 1 | IDX_Catalogo_Funciones_RBAC_IACT_1_0_0.rst | 1.0.0 | ~500-800 | 1h | 44 funciones con capacidades, UCs, CNST |
| 2 | IDX_Catalogo_Agrupadores_IACT_1_0_0.rst | 1.0.0 | ~300-500 | 1h | 10 agrupadores con composición |
| 3 | IDX_Matriz_SoD_IACT_1_0_0.rst | 1.0.0 | ~200-300 | 1h | 3 restricciones SoD detalladas |
| 4 | IDX_Catalogo_Segmentos_Datos_IACT_1_0_0.rst | 1.0.0 | ~200-300 | 1h | 5 segmentos con reglas |

**Dependencias:** CNST_005, todos los UCs generados

---

### 4.5 FASE 14B: Índices Generales v1.0.0 (3 documentos, 3-4h)

| # | Documento | Versión | Líneas | Esfuerzo | Contenido |
|---|-----------|---------|--------|----------|-----------|
| 1 | IDX_Maestro_Documentacion_IACT_1_0_0.md | 1.0.0 | ~800-1,200 | 1.5h | Índice navegable de toda la base |
| 2 | IDX_Mapa_Referencias_Cruzadas_IACT_1_0_0.md | 1.0.0 | ~600-900 | 1.5h | Matriz de referencias entre docs |
| 3 | IDX_Catalogo_Templates_IACT_1_0_0.rst | 1.0.0 | ~400-600 | 1h | Catálogo de 12 templates con guía uso |

**Dependencias:** Todos los documentos anteriores completados

---

### 4.6 FASE 17: Validación Final (6 tareas, 10h)

| # | Tarea | Esfuerzo | Método |
|---|-------|----------|--------|
| 1 | Cross-references UC ↔ Funciones RBAC | 2h | Script Python de validación |
| 2 | Trazabilidad BR → UC → FR → RBAC | 3h | Matriz de trazabilidad completa |
| 3 | CNST ↔ Funciones consistencia | 2h | Verificar que cada CNST lista funciones correctas |
| 4 | SoD consistencia | 1h | Validar que agrupadores no violan SoD |
| 5 | Segmentos documentación | 1h | Verificar filtrado automático documentado |
| 6 | Nomenclatura NOM_001 v2.0.0 | 1h | Validar nombres de archivos |

**Script de validación sugerido:**

```python
# validar_rbac.py
def validar_uc_funciones():
    """Verificar que cada UC tiene función RBAC correcta"""
    
def validar_cnst_funciones():
    """Verificar que cada CNST lista funciones afectadas"""
    
def validar_sod():
    """Verificar que agrupadores respetan SoD"""
    
def validar_nomenclatura():
    """Verificar formato NOM_001 v2.0.0"""
```

---

<a name="cronograma"></a>
## 5. CRONOGRAMA

### 5.1 Cronograma Semanal

```
SEMANA 1: CNST + UCs Críticos
─────────────────────────────────────────────────────────
DÍA 1 (Lunes):
  ├── FASE 15.1: CNST_005 (CORE)                    2-3h
  └── FASE 15.2: CNST_001, CNST_002, CNST_003       2-3h
      TOTAL DÍA: ~5-6h

DÍA 2 (Martes):
  ├── FASE 15.2: CNST_004, CNST_006, CNST_007       2-3h
  ├── FASE 15.2: CNST_008                           1h
  └── FASE 16.1: Plantilla UC con RBAC              30min
      TOTAL DÍA: ~4h

DÍA 3 (Miércoles):
  ├── FASE 16.2: UC MOD_Reports (13)                1.5h
  ├── FASE 16.3: UC MOD_Access (8)                  1h
  └── FASE 16.4: UC MOD_Users (5)                   30min
      TOTAL DÍA: ~3h

DÍA 4 (Jueves):
  ├── FASE 16.4: UC MOD_Auth (5)                    30min
  ├── FASE 16.5: UC resto (21)                      1.5h
  ├── FASE 14A.1: Catálogo Funciones RBAC           1h
  └── FASE 14A.2: Catálogo Agrupadores              1h
      TOTAL DÍA: ~4h

DÍA 5 (Viernes):
  ├── FASE 14A.3: Matriz SoD                        1h
  ├── FASE 14A.4: Catálogo Segmentos                1h
  ├── FASE 14B.1: Índice Maestro                    1.5h
  ├── FASE 14B.2: Mapa Referencias                  1.5h
  └── FASE 14B.3: Catálogo Templates                1h
      TOTAL DÍA: ~6h

─────────────────────────────────────────────────────────
TOTAL SEMANA 1: ~22-23h de los 29-31h totales

DÍAS 6-7 (Fin de semana o siguiente semana):
  └── FASE 17: Validación Final                     10h
      TOTAL VALIDACIÓN: ~10h

─────────────────────────────────────────────────────────
TOTAL PROYECTO: 29-31h distribuidas en 5-7 días
```

### 5.2 Cronograma por Horas

| Hora | Día 1 | Día 2 | Día 3 | Día 4 | Día 5 | Día 6-7 |
|------|-------|-------|-------|-------|-------|---------|
| 1-2h | CNST_005 | CNST_004 | UC Reports | UC Auth | IDX Funciones | Validación UC↔RBAC |
| 3-4h | CNST_005 | CNST_006 | UC Reports | UC resto | IDX Agrupadores | Validación Trazab |
| 5-6h | CNST_001 | CNST_007 | UC Access | UC resto | IDX SoD | Validación CNST |
| 7-8h | CNST_002 | CNST_008 | UC Users | IDX Funciones | IDX Segmentos | Validación SoD |
| - | CNST_003 | Plantilla UC | - | IDX Agrupadores | IDX Maestro | Validación Seg |
| - | - | - | - | - | IDX Mapa Ref | Validación Nom |
| - | - | - | - | - | IDX Templates | - |

---

<a name="dependencias"></a>
## 6. DEPENDENCIAS

### 6.1 Grafo de Dependencias

```
NIVEL 0 (Fundamentos - ya completados):
  ├── NOM_001_Nomenclatura_Proyecto_2_0_0.rst
  └── STD_001_Estandares_Documentacion_1_1_0.rst

NIVEL 1 (Documento CORE - CRÍTICO):
  └── CNST_005_RBAC_Flat_SoD_Permisos_1_0_0.rst
          ↓
      BLOQUEA TODO LO DEMÁS

NIVEL 2 (Restricciones - dependen de CNST_005):
  ├── CNST_001_No_Email_Sistema_1_0_0.rst
  ├── CNST_002_Sesiones_BD_Timeout_1_0_0.rst
  ├── CNST_003_BD_IVR_Readonly_ETL_1_0_0.rst
  ├── CNST_004_Alertas_Buzon_Interno_1_0_0.rst
  ├── CNST_006_Reportes_Limites_Rango_1_0_0.rst
  ├── CNST_007_Limites_Exportacion_Throttling_1_0_0.rst
  └── CNST_008_Audit_Inmutable_Logs_PII_1_0_0.rst
          ↓
      HABILITAN UCs

NIVEL 3 (Plantilla + UCs - dependen de CNST_005 + resto CNST):
  ├── TPL_UC_Con_RBAC_1_0_0.rst (plantilla)
  │       ↓
  └── UC_* (47 casos de uso)
      ├── UC_AUTH_* (5)
      ├── UC_USR_* (5)
      ├── UC_ACC_* (8)
      ├── UC_PIP_* (4)
      ├── UC_RPT_* (13)
      ├── UC_ALR_* (5)
      ├── UC_AUD_* (4)
      └── UC_LOG_* (3)
          ↓
      HABILITAN ÍNDICES

NIVEL 4 (Índices RBAC - dependen de UCs):
  ├── IDX_Catalogo_Funciones_RBAC_IACT_1_0_0.rst
  ├── IDX_Catalogo_Agrupadores_IACT_1_0_0.rst
  ├── IDX_Matriz_SoD_IACT_1_0_0.rst
  └── IDX_Catalogo_Segmentos_Datos_IACT_1_0_0.rst
          ↓
      COMPLETAN ÍNDICES

NIVEL 5 (Índices Generales - dependen de todo):
  ├── IDX_Maestro_Documentacion_IACT_1_0_0.md
  ├── IDX_Mapa_Referencias_Cruzadas_IACT_1_0_0.md
  └── IDX_Catalogo_Templates_IACT_1_0_0.rst
          ↓
      HABILITAN VALIDACIÓN

NIVEL 6 (Validación Final - requiere todo completo):
  └── Validación exhaustiva (6 tareas)
```

### 6.2 Bloqueos Críticos

| Documento | Bloquea | Impacto |
|-----------|---------|---------|
| **CNST_005** | **Todo el proyecto** | **CRÍTICO - Sin esto, nada más puede avanzar** |
| CNST_001-008 | Todos los UCs | Alto - UCs necesitan referencias CNST |
| Plantilla UC | Generación masiva UCs | Alto - Estándar de calidad |
| UCs completos | Índices RBAC | Medio - Necesitan datos de UCs |
| Índices RBAC | Índices Generales | Bajo - Documentación complementaria |

---

<a name="metricas"></a>
## 7. MÉTRICAS Y VALIDACIÓN

### 7.1 Métricas de Calidad

```yaml
Nomenclatura NOM_001 v2.0.0:
  - ✓ Formato: [PREFIX]_[NUM]_[Nombre]_MAJOR_MINOR_PATCH.ext
  - ✓ Todos los archivos versionados
  - Meta: 100% cumplimiento

Completitud RBAC:
  - ✓ Todas las 44 funciones documentadas
  - ✓ Todos los 10 agrupadores documentados
  - ✓ Todas las 3 SoD documentadas
  - ✓ Todos los 5 segmentos documentados
  - Meta: 100% cobertura

Cross-references:
  - ✓ UC → Función RBAC
  - ✓ CNST → Funciones afectadas
  - ✓ Agrupador → Funciones componentes
  - ✓ SoD → Funciones incompatibles
  - Meta: 0 referencias rotas

Trazabilidad:
  - ✓ BR → UC → FR → Función RBAC
  - ✓ Cadena completa documentada
  - Meta: 100% trazable

Calidad del contenido:
  - ✓ Placeholders: <1.5% (meta: <1%)
  - ✓ Ejemplos completos en cada documento
  - ✓ Código Python/SQL funcional incluido
  - Meta: Calidad EXCELENTE
```

### 7.2 Script de Validación

```python
# /tmp/validar_proyecto_rbac.py

import os
import re
from pathlib import Path

def validar_nomenclatura(directorio):
    """Validar formato NOM_001 v2.0.0"""
    patron = r'^[A-Z]+_[0-9]+_[A-Za-z_]+_\d+_\d+_\d+\.(rst|md)$'
    archivos_invalidos = []
    
    for archivo in Path(directorio).rglob('*.rst'):
        if not re.match(patron, archivo.name):
            archivos_invalidos.append(archivo)
    
    return archivos_invalidos

def validar_funciones_rbac():
    """Verificar que las 44 funciones están documentadas"""
    funciones_esperadas = [
        'AUT-001', 'AUT-002', 'AUT-003', 'AUT-004',
        'USR-001', 'USR-002', # ... etc
    ]
    # Buscar en CNST_005 y UCs
    pass

def validar_referencias_cruzadas():
    """Verificar referencias UC → Función RBAC"""
    # Parsear todos los UCs
    # Verificar que :Función_RBAC_Requerida: existe
    pass

def generar_reporte_validacion():
    """Generar reporte HTML de validación"""
    pass

if __name__ == '__main__':
    print("Validando estructura documental IACT...")
    # Ejecutar validaciones
```

### 7.3 Checklist de Aceptación

```
FASE 15 - CNST:
  ☐ CNST_005 completado con 44 funciones, 10 agrupadores, 3 SoD, 5 segmentos
  ☐ CNST_001 a CNST_008 completados
  ☐ Todos los CNST con ejemplos completos
  ☐ SQL funcional en CNST_005
  ☐ Código Python en CNST_005

FASE 16 - UC:
  ☐ Plantilla UC con RBAC completada
  ☐ 47 UCs generados con versión 1.0.0
  ☐ Todos los UCs con :Función_RBAC_Requerida:
  ☐ Todos los UCs con :CNST_Aplicables:
  ☐ Todos los UCs con sección "Permisos RBAC Detallados"

FASE 14A - Índices RBAC:
  ☐ Catálogo de 44 funciones completo
  ☐ Catálogo de 10 agrupadores completo
  ☐ Matriz de 3 SoD completa
  ☐ Catálogo de 5 segmentos completo

FASE 14B - Índices Generales:
  ☐ Índice maestro navegable
  ☐ Mapa de referencias cruzadas
  ☐ Catálogo de templates actualizado

FASE 17 - Validación:
  ☐ Cross-references validados (0 errores)
  ☐ Trazabilidad completa (100%)
  ☐ SoD sin conflictos
  ☐ Nomenclatura 100% correcta
  ☐ Script de validación ejecutado sin errores
```

---

<a name="riesgos"></a>
## 8. RIESGOS Y MITIGACIONES

### 8.1 Riesgos Identificados

| # | Riesgo | Probabilidad | Impacto | Mitigación |
|---|--------|--------------|---------|------------|
| R1 | CNST_005 toma más tiempo del estimado | Media | Alto | Priorizar, dedicar día completo si es necesario |
| R2 | Inconsistencias en funciones RBAC entre docs | Media | Alto | Validación cruzada continua, script automático |
| R3 | Error en nomenclatura NOM_001 v2.0.0 | Baja | Medio | Validar cada archivo al crearlo |
| R4 | SoD mal documentado | Baja | Alto | Revisar contra MODELO_RBAC_IACT_v5_1_1.md |
| R5 | UCs sin función RBAC correcta | Media | Alto | Plantilla estricta, validación automática |
| R6 | Fatiga en generación masiva (47 UCs) | Alta | Medio | Dividir en bloques, priorizar módulos críticos |
| R7 | Referencias rotas entre documentos | Media | Medio | Script de validación post-generación |

### 8.2 Plan de Contingencia

```yaml
Si CNST_005 se extiende más allá de 3h:
  Acción: Dividir en 2 partes
    - CNST_005_Parte_1: Funciones + Agrupadores (2h)
    - CNST_005_Parte_2: SoD + Segmentos + Implementación (2h)
  Resultado: Completar en Día 1 + parte Día 2

Si UCs toman más tiempo:
  Acción: Priorizar por módulo crítico
    - Completar MOD_Reports primero (core negocio)
    - Diferir MOD_Logs para después
  Resultado: Funcionalidad crítica documentada primero

Si validación encuentra errores masivos:
  Acción: Fix iterativo
    - Corregir CNST_005 primero
    - Re-generar UCs afectados
    - Re-validar
  Resultado: Calidad asegurada antes de continuar
```

---

## 9. ESTRUCTURA FINAL ESPERADA

```
base_cognitiva/
├── fundacionales/                           [2 archivos - sin cambios]
│   ├── NOM_001_Nomenclatura_Proyecto_2_0_0.rst
│   └── STD_001_Estandares_Documentacion_1_1_0.rst
│
├── cnst/                                    [8 archivos NUEVOS v1.0.0]
│   ├── CNST_001_No_Email_Sistema_1_0_0.rst
│   ├── CNST_002_Sesiones_BD_Timeout_1_0_0.rst
│   ├── CNST_003_BD_IVR_Readonly_ETL_1_0_0.rst
│   ├── CNST_004_Alertas_Buzon_Interno_1_0_0.rst
│   ├── CNST_005_RBAC_Flat_SoD_Permisos_1_0_0.rst  ⭐ CORE
│   ├── CNST_006_Reportes_Limites_Rango_1_0_0.rst
│   ├── CNST_007_Limites_Exportacion_Throttling_1_0_0.rst
│   └── CNST_008_Audit_Inmutable_Logs_PII_1_0_0.rst
│
├── casos_uso/                               [47 archivos NUEVOS v1.0.0]
│   ├── UC_AUTH_001_Iniciar_Sesion_Sistema_1_0_0.rst
│   ├── UC_AUTH_002_Cerrar_Sesion_Sistema_1_0_0.rst
│   ├── UC_AUTH_003_Recuperar_Password_1_0_0.rst
│   ├── UC_AUTH_004_Cambiar_Password_1_0_0.rst
│   ├── UC_AUTH_005_Gestionar_Sesiones_BD_1_0_0.rst
│   ├── UC_USR_006_Crear_Usuario_1_0_0.rst
│   ├── UC_USR_007_Modificar_Usuario_1_0_0.rst
│   ├── UC_USR_008_Baja_Logica_Usuario_1_0_0.rst
│   ├── UC_USR_009_Listar_Usuarios_1_0_0.rst
│   ├── UC_USR_041_Asignar_Segmento_Datos_1_0_0.rst
│   ├── UC_ACC_010_Asignar_Funciones_Usuario_1_0_0.rst
│   ├── UC_ACC_011_Consultar_Permisos_Efectivos_1_0_0.rst
│   ├── UC_ACC_042_Asignar_Permisos_Directos_1_0_0.rst
│   ├── UC_ACC_043_Configurar_Reglas_SoD_1_0_0.rst
│   ├── UC_ACC_044_Ver_Asignaciones_Usuario_1_0_0.rst
│   ├── UC_ACC_045_Gestionar_Catalogo_Roles_1_0_0.rst
│   ├── UC_ACC_046_Gestionar_Catalogo_Permisos_1_0_0.rst
│   ├── UC_ACC_047_Auditar_Cambios_Permisos_1_0_0.rst
│   ├── UC_PIP_050_Supervisar_Ejecuciones_ETL_1_0_0.rst
│   ├── UC_PIP_051_Consultar_Errores_ETL_1_0_0.rst
│   ├── UC_PIP_052_Consultar_Disponibilidad_Datos_1_0_0.rst
│   ├── UC_PIP_053_Solicitar_Reintento_ETL_1_0_0.rst
│   ├── UC_RPT_017_Consultar_Reporte_Trimestral_1_0_0.rst
│   ├── UC_RPT_018_Consultar_Problemas_Menu_1_0_0.rst
│   ├── UC_RPT_019_Consultar_Transferencias_Centro_1_0_0.rst
│   ├── UC_RPT_020_Filtrar_Reporte_Fecha_1_0_0.rst
│   ├── UC_RPT_021_Filtrar_Reporte_Centro_1_0_0.rst
│   ├── UC_RPT_022_Exportar_Reporte_CSV_1_0_0.rst
│   ├── UC_RPT_023_Exportar_Reporte_Excel_1_0_0.rst
│   ├── UC_RPT_024_Exportar_Reporte_PDF_1_0_0.rst
│   ├── UC_RPT_025_Ver_Dashboard_Principal_1_0_0.rst
│   ├── UC_RPT_027_Ver_Graficos_Hora_1_0_0.rst
│   ├── UC_RPT_028_Ver_Graficos_Dia_1_0_0.rst
│   ├── UC_RPT_029_Ver_Distribucion_Centro_1_0_0.rst
│   ├── [... 3 más MOD_Reports ...]
│   ├── UC_ALR_036_Crear_Alerta_Personal_1_0_0.rst
│   ├── UC_ALR_037_Recibir_Notificacion_Interna_1_0_0.rst
│   ├── UC_ALR_038_Pausar_Alerta_Snooze_1_0_0.rst
│   ├── UC_ALR_039_Ver_Historial_Alertas_1_0_0.rst
│   ├── UC_ALR_040_Gestionar_Destinatarios_Alerta_1_0_0.rst
│   ├── UC_AUD_060_Registrar_Evento_Auditoria_1_0_0.rst
│   ├── UC_AUD_061_Consultar_Bitacora_Auditoria_1_0_0.rst
│   ├── UC_AUD_062_Generar_Reporte_Auditoria_1_0_0.rst
│   ├── UC_AUD_063_Exportar_Auditoria_1_0_0.rst
│   ├── UC_LOG_070_Consultar_Logs_Sistema_1_0_0.rst
│   ├── UC_LOG_071_Filtrar_Logs_Nivel_Servicio_1_0_0.rst
│   └── UC_LOG_072_Exportar_Logs_Tecnicos_1_0_0.rst
│
├── indices/                                 [7 archivos NUEVOS v1.0.0]
│   ├── IDX_Catalogo_Funciones_RBAC_IACT_1_0_0.rst
│   ├── IDX_Catalogo_Agrupadores_IACT_1_0_0.rst
│   ├── IDX_Matriz_SoD_IACT_1_0_0.rst
│   ├── IDX_Catalogo_Segmentos_Datos_IACT_1_0_0.rst
│   ├── IDX_Maestro_Documentacion_IACT_1_0_0.md
│   ├── IDX_Mapa_Referencias_Cruzadas_IACT_1_0_0.md
│   └── IDX_Catalogo_Templates_IACT_1_0_0.rst
│
├── pedagogico/                              [12 archivos - sin cambios]
│   └── PARTE_*_IACT_1_0_0.md
│
├── templates/                               [13 archivos - 1 NUEVO]
│   ├── TPL_UC_Con_RBAC_1_0_0.rst           ⭐ NUEVO
│   └── [12 templates existentes v1.3.0/v1.2.0]
│
└── originales/                              [16 archivos - sin cambios]
    └── [archivados]

TOTAL ESTRUCTURA:
  - Fundacionales:    2 archivos
  - CNST:            8 archivos NUEVOS
  - Casos de Uso:   47 archivos NUEVOS
  - Índices:         7 archivos NUEVOS
  - Pedagógico:     12 archivos
  - Templates:      13 archivos (1 nuevo)
  - Originales:     16 archivos
  ─────────────────────────────────
  TOTAL:           105 archivos
  NUEVOS:           62 archivos
```

---

## 10. RESUMEN EJECUTIVO DEL PLAN

### 10.1 Alcance Total

| Métrica | Valor |
|---------|-------|
| **Total documentos** | 62 nuevos |
| **Total esfuerzo** | 29-31 horas |
| **Total líneas** | ~35,000-40,000 |
| **Duración estimada** | 5-7 días |
| **Fases** | 5 principales |
| **Validaciones** | 6 tareas |

### 10.2 Distribución de Esfuerzo

```
CNST (8 docs):        8-9h   (27%)  🔴🟠
UCs (47 docs):        4-5h   (15%)  🟡
Índices (7 docs):     7-8h   (25%)  🟢
Validación:          10h     (33%)  🟢
────────────────────────────────────
TOTAL:              29-31h  (100%)
```

### 10.3 Ruta Crítica

```
CNST_005 (CORE) → CNST resto → Plantilla UC → UCs → Índices → Validación
    2-3h            6h           30min        4-5h    7-8h       10h
```

### 10.4 Prioridades

```
🔴 CRÍTICA:  CNST_005 (bloquea todo)
🟠 ALTA:     CNST_001-008 (habilitan UCs)
🟡 MEDIA:    UCs + Plantilla (documentación operativa)
🟢 BAJA:     Índices + Validación (completitud)
```

---

## 11. PRÓXIMOS PASOS INMEDIATOS

### Decisión Requerida

**¿Procedemos con la ejecución del plan?**

**Opción A: Ejecutar plan completo**
- Comenzar por CNST_005
- Seguir secuencia propuesta
- Duración: 5-7 días

**Opción B: Ejecutar por fases**
- Solo FASE 15 primero (CNST)
- Revisar y validar
- Luego continuar con FASE 16

**Opción C: Modificar el plan**
- Ajustar prioridades
- Cambiar secuencia
- Definir alcance diferente

---

**FIN DEL PLAN MAESTRO**

**Versión:** 1.0.0  
**Fecha:** 2026-01-11  
**Estado:** Aprobado para revisión  
**Próxima acción:** Decisión de ejecución

