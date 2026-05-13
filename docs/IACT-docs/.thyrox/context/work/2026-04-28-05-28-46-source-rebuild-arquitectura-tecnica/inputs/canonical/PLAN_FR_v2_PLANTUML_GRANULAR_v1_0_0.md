# PLAN FR v2.0 PlantUML - ESTRUCTURA GRANULAR

**Versión**: 1.0.0  
**Fecha**: 2026-01-06  
**Estado**: Aprobado para Ejecución  
**Autor**: Equipo IACT

---

## 1. RESUMEN EJECUTIVO

### 1.1 Objetivo

Documentar todos los Functional Requirements (FR) del proyecto IACT en versión 2.0 
con **estructura granular** (un archivo por FR) y diagramas PlantUML.

### 1.2 Métricas Clave

| Métrica | Valor |
|---------|-------|
| UC Origen | 49 |
| FR Totales | 375 |
| **Archivos FR** | **375** (uno por FR) |
| Subdirectorios UC | 49 |
| Índices | 58 (49 UC + 8 módulo + 1 maestro) |
| **Total Archivos RST** | **433** |
| Diagramas PlantUML | ~425 (1 por FR + 49 de resumen) |
| Líneas Estimadas | ~25,000 |

### 1.3 Estructura Granular vs Consolidada

| Aspecto | Consolidada (v1) | Granular (v2) |
|---------|------------------|---------------|
| Archivos por UC | 1 | N (uno por FR) |
| Total archivos | 49 | 433 |
| Mantenibilidad | Media | **Alta** |
| Control versiones | Conflictos posibles | **Aislado** |
| Navegación | Scroll largo | **Por archivo** |
| Reutilización | Baja | **Alta** |

---

## 2. ESTRUCTURA DE DIRECTORIOS

```
funcionales_v2/
├── index.rst                           # Índice maestro
├── conf.py                             # Configuración Sphinx
├── Makefile                            # Build commands
├── _static/
│   └── fr_styles.iuml                  # Estilos PlantUML
│
├── auth/                               # MOD_Auth
│   ├── index.rst                       # Índice del módulo
│   │
│   ├── iniciar_sesion/                 # UC-001
│   │   ├── index.rst                   # Resumen + diagrama flujo
│   │   ├── FR_001_01_Mostrar_Formulario.rst
│   │   ├── FR_001_02_Validar_Username.rst
│   │   ├── FR_001_03_Validar_Password.rst
│   │   ├── FR_001_04_Verificar_Credenciales.rst
│   │   ├── FR_001_05_Verificar_Estado_Usuario.rst
│   │   ├── FR_001_06_Verificar_Bloqueo.rst
│   │   ├── FR_001_07_Generar_Token_JWT.rst
│   │   ├── FR_001_08_Registrar_Sesion.rst
│   │   ├── FR_001_09_Registrar_Auditoria.rst
│   │   ├── FR_001_10_Incrementar_Intentos.rst
│   │   ├── FR_001_11_Bloquear_Usuario.rst
│   │   └── FR_001_12_Redirigir_Dashboard.rst
│   │
│   ├── cerrar_sesion/                  # UC-002 (8 FR)
│   │   ├── index.rst
│   │   └── FR_002_01 a FR_002_08.rst
│   │
│   ├── recuperar_password/             # UC-003 (10 FR)
│   │   ├── index.rst
│   │   └── FR_003_01 a FR_003_10.rst
│   │
│   ├── cambiar_password/               # UC-004 (10 FR)
│   │   ├── index.rst
│   │   └── FR_004_01 a FR_004_10.rst
│   │
│   └── gestionar_sesiones/             # UC-005 (10 FR)
│       ├── index.rst
│       └── FR_005_01 a FR_005_10.rst
│
├── users/                              # MOD_Users (38 FR en 4 UC)
│   ├── index.rst
│   ├── crear_usuario/                  # UC-006 (11 FR)
│   ├── modificar_usuario/              # UC-007 (9 FR)
│   ├── baja_usuario/                   # UC-008 (9 FR)
│   └── listar_usuarios/                # UC-009 (9 FR)
│
├── access/                             # MOD_Access (69 FR en 9 UC)
│   ├── index.rst
│   ├── asignar_funciones/              # UC-010 (10 FR)
│   ├── revocar_funciones/              # UC-011 (9 FR)
│   ├── asignar_segmento/               # UC-041 (7 FR)
│   ├── revocar_segmento/               # UC-042 (5 FR)
│   ├── configurar_sod/                 # UC-043 (8 FR)
│   ├── consultar_permisos/             # UC-044 (6 FR)
│   ├── gestionar_agrupadores/          # UC-045 (7 FR)
│   ├── gestionar_funciones/            # UC-046 (8 FR)
│   └── auditar_permisos/               # UC-047 (9 FR)
│
├── pipeline/                           # MOD_Pipeline (35 FR en 4 UC)
│   ├── index.rst
│   ├── ejecutar_pipeline/              # UC-050 (11 FR)
│   ├── monitorear_pipeline/            # UC-051 (7 FR)
│   ├── configurar_pipeline/            # UC-052 (9 FR)
│   └── historial_pipeline/             # UC-053 (8 FR)
│
├── reports/                            # MOD_Reports (84 FR en 14 UC)
│   ├── index.rst
│   ├── reporte_saldos/                 # UC-017 (10 FR)
│   ├── reporte_movimientos/            # UC-018 (8 FR)
│   ├── balance_general/                # UC-019 (7 FR)
│   ├── estado_resultados/              # UC-020 (7 FR)
│   ├── flujo_efectivo/                 # UC-021 (7 FR)
│   ├── analisis_cuentas/               # UC-022 (7 FR)
│   ├── comparativo_periodos/           # UC-023 (7 FR)
│   ├── presupuesto_vs_real/            # UC-024 (7 FR)
│   ├── antiguedad_saldos/              # UC-025 (7 FR)
│   ├── dashboard_principal/            # UC-026 (7 FR)
│   ├── dashboard_financiero/           # UC-027 (5 FR)
│   ├── dashboard_operativo/            # UC-028 (5 FR)
│   ├── personalizar_dashboard/         # UC-029 (5 FR)
│   └── exportar_dashboard/             # UC-030 (5 FR)
│
├── alerts/                             # MOD_Alerts (35 FR en 5 UC)
│   ├── index.rst
│   ├── configurar_reglas/              # UC-031 (8 FR)
│   ├── visualizar_alertas/             # UC-032 (7 FR)
│   ├── gestionar_suscripciones/        # UC-033 (6 FR)
│   ├── historial_alertas/              # UC-034 (7 FR)
│   └── ejecutar_evaluacion/            # UC-035 (7 FR)
│
├── audit/                              # MOD_Audit (32 FR en 4 UC)
│   ├── index.rst
│   ├── consultar_auditoria/            # UC-036 (12 FR)
│   ├── generar_reporte/                # UC-037 (6 FR)
│   ├── configurar_retencion/           # UC-038 (6 FR)
│   └── archivar_auditoria/             # UC-039 (8 FR)
│
└── logs/                               # MOD_Logs (32 FR en 4 UC)
    ├── index.rst
    ├── consultar_logs/                 # UC-012 (10 FR)
    ├── configurar_niveles/             # UC-013 (7 FR)
    ├── monitorear_errores/             # UC-014 (7 FR)
    └── exportar_logs/                  # UC-015 (8 FR)
```

---

## 3. FORMATO DE ARCHIVOS

### 3.1 Index de UC (con diagrama de flujo)

```rst
.. _fr-uc001-index:

==============================================================================
UC-001: Iniciar Sesión - Índice de FR
==============================================================================

Resumen
-------
| UC Origen | UC-001: Iniciar Sesión |
| Módulo | MOD_Auth |
| Total FR | 12 |
| BR Aplicables | BR_005, BR_008, BR_015 |

Diagrama de Flujo de Validación
-------------------------------

.. uml::
   
   @startuml
   start
   :FR-001.01: Mostrar Formulario;
   :FR-001.02: Validar Username;
   if (Válido?) then (sí)
       :FR-001.03: Validar Password;
       ...
   @enduml

Lista de FR
-----------

.. toctree::
   :maxdepth: 1
   
   FR_001_01_Mostrar_Formulario
   FR_001_02_Validar_Username
   ...
```

### 3.2 Archivo FR Individual (con diagrama)

```rst
.. _fr-001-01:

==============================================================================
FR-001.01: Mostrar Formulario de Login
==============================================================================

1. Identificación
-----------------
| ID | FR-001.01 |
| UC Origen | UC-001, Paso 2 |
| Prioridad | Must Have |
| Estado | Aprobado |

2. Enunciado
------------
El sistema **DEBE** mostrar un formulario de login con campos para 
username y password cuando el usuario accede a la URL de autenticación.

3. Diagrama
-----------

.. uml::
   
   @startuml
   component "FR-001.01\nMostrar Formulario" as FR01 #LightBlue
   
   FR01 --> [FR-001.02] : habilita
   FR01 --> [FR-001.03] : habilita
   
   note right of FR01
     Input: URL /login
     Output: Formulario HTML
   end note
   @enduml

4. Detalles
-----------
- Campo username: input text, requerido
- Campo password: input password (enmascarado), requerido
- Botón "Iniciar Sesión": submit
- Link "Olvidé mi password": navegación a UC-003

5. Criterios de Aceptación
--------------------------

.. code-block:: gherkin

   Feature: FR-001.01 Mostrar Formulario Login
   
   Scenario: Formulario carga correctamente
     Given usuario no autenticado
     When accede a /login
     Then muestra formulario con campo username
     And muestra formulario con campo password
     And password está enmascarado
     And botón submit está habilitado

6. Dependencias
---------------
| Tipo | FR | Descripción |
|------|-----|-------------|
| Precede | FR-001.02 | Habilita validación username |
| Precede | FR-001.03 | Habilita validación password |

7. Trazabilidad
---------------
| UC | UC-001 Paso 2 |
| BR | - |
| Test ID | TEST-001-01 |
```

---

## 4. FASES DE EJECUCIÓN

### Fase 0: Setup
**Entregables:**
- Estructura de directorios (49 subdirectorios UC)
- Estilos PlantUML
- Plantilla FR individual
- Índices vacíos (8 módulo + 1 maestro)

**Archivos:** ~60

### Fase 1: MOD_Auth
**UC:** 5 (iniciar_sesion, cerrar_sesion, recuperar_password, cambiar_password, gestionar_sesiones)
**FR:** 50 archivos individuales
**Índices UC:** 5
**Líneas estimadas:** ~3,500

### Fase 2: MOD_Users
**UC:** 4
**FR:** 38 archivos
**Índices UC:** 4
**Líneas estimadas:** ~2,700

### Fase 3: MOD_Access
**UC:** 9
**FR:** 69 archivos
**Índices UC:** 9
**Líneas estimadas:** ~4,800

### Fase 4: MOD_Pipeline
**UC:** 4
**FR:** 35 archivos
**Índices UC:** 4
**Líneas estimadas:** ~2,500

### Fase 5: MOD_Reports
**UC:** 14
**FR:** 84 archivos
**Índices UC:** 14
**Líneas estimadas:** ~5,900

### Fase 6: MOD_Alerts
**UC:** 5
**FR:** 35 archivos
**Índices UC:** 5
**Líneas estimadas:** ~2,500

### Fase 7: MOD_Audit
**UC:** 4
**FR:** 32 archivos
**Índices UC:** 4
**Líneas estimadas:** ~2,300

### Fase 8: MOD_Logs
**UC:** 4
**FR:** 32 archivos
**Índices UC:** 4
**Líneas estimadas:** ~2,300

### Fase 9: Integración
**Entregables:**
- Índice maestro completo
- conf.py y Makefile
- Verificación compilación
- README y METRICS

---

## 5. RESUMEN DEL PLAN

| Fase | Módulo | UC | FR (archivos) | Índices | Total RST |
|------|--------|-----|---------------|---------|-----------|
| 0 | Setup | -- | -- | 9 | ~60 |
| 1 | auth | 5 | 50 | 5 | 55 |
| 2 | users | 4 | 38 | 4 | 42 |
| 3 | access | 9 | 69 | 9 | 78 |
| 4 | pipeline | 4 | 35 | 4 | 39 |
| 5 | reports | 14 | 84 | 14 | 98 |
| 6 | alerts | 5 | 35 | 5 | 40 |
| 7 | audit | 4 | 32 | 4 | 36 |
| 8 | logs | 4 | 32 | 4 | 36 |
| 9 | Integración | -- | -- | 1 | ~10 |
| **TOTAL** | | **49** | **375** | **58** | **~494** |

**Líneas estimadas totales:** ~26,500

---

## 6. NOMENCLATURA

### 6.1 Directorios UC
```
{modulo}/{nombre_uc_snake_case}/
Ejemplo: auth/iniciar_sesion/
```

### 6.2 Archivos FR
```
FR_{UC}_{SEQ}_{Nombre_Descriptivo}.rst
Ejemplo: FR_001_01_Mostrar_Formulario.rst
```

### 6.3 Referencias RST
```
.. _fr-{uc}-{seq}:
Ejemplo: .. _fr-001-01:
```

---

## 7. DIAGRAMAS PLANTUML

### 7.1 Por Índice UC (1 diagrama)
- **Tipo:** Actividad (flujo de validación)
- **Contenido:** Secuencia de FR con decisiones

### 7.2 Por FR Individual (1 diagrama)
- **Tipo:** Componente
- **Contenido:** FR actual + dependencias (precede/sigue)

### 7.3 Total Diagramas
- Índices UC: 49 diagramas
- FR individuales: 375 diagramas
- **Total:** ~424 diagramas

---

## 8. APROBACIÓN

| Rol | Fecha | Estado |
|-----|-------|--------|
| Autor | 2026-01-06 | ✅ Creado |
| Usuario | -- | **PENDIENTE** |

---

**Siguiente Paso:** Aprobar y ejecutar Fase 0 (Setup)
