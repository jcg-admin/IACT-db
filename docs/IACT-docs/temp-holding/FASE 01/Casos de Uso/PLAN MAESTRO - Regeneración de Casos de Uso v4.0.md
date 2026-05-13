
# Regeneración de Casos de Uso v4.0


# PLAN MAESTRO: Regeneración de Casos de Uso v4.0

**Fecha:** 2026-01-06
**Versión:** 4.0.0
**Estado:** APROBADO PARA EJECUCIÓN

---

## 1. FORMATO DE NOMENCLATURA

### Identificador
```
UC_[MOD]_[NN]

Donde:
  UC    = Prefijo estándar
  [MOD] = Código módulo (AUTH, USR, ACC, PIP, RPT, ALR, AUD, LOG)
  [NN]  = Secuencial (01, 02, 03...)
  
Separador: Guión bajo (_)
```

### Nombre de Archivo
```
UC_[MOD]_[NN]_[Nombre_Descriptivo].rst

Ejemplos:
  UC_AUTH_01_Iniciar_Sesion.rst
  UC_USR_01_Crear_Usuario.rst
  UC_ACC_01_Asignar_Funciones.rst
  UC_RPT_06_Exportar_CSV.rst
```

---

## 2. ESTRUCTURA DE DIRECTORIOS

```
casos_uso_v4/
├── index.rst                          # Índice principal
├── glosario.rst                       # Términos y definiciones
├── actores.rst                        # Catálogo de actores (AGR-001 a AGR-010)
├── restricciones.rst                  # Resumen CNST aplicables
│
├── _static/
│   └── plantuml_styles.iuml           # Estilos PlantUML compartidos
│
├── auth/                              # MOD_Auth (5 UC)
│   ├── index.rst
│   ├── UC_AUTH_01_Iniciar_Sesion.rst
│   ├── UC_AUTH_02_Cerrar_Sesion.rst
│   ├── UC_AUTH_03_Recuperar_Contrasena.rst
│   ├── UC_AUTH_04_Cambiar_Contrasena.rst
│   └── UC_AUTH_05_Gestionar_Sesiones.rst
│
├── users/                             # MOD_Users (4 UC)
│   ├── index.rst
│   ├── UC_USR_01_Crear_Usuario.rst
│   ├── UC_USR_02_Consultar_Usuarios.rst
│   ├── UC_USR_03_Modificar_Usuario.rst
│   └── UC_USR_04_Eliminar_Usuario.rst
│
├── access/                            # MOD_Access (9 UC)
│   ├── index.rst
│   ├── UC_ACC_01_Asignar_Funciones.rst
│   ├── UC_ACC_02_Revocar_Funciones.rst
│   ├── UC_ACC_03_Consultar_Permisos.rst
│   ├── UC_ACC_04_Asignar_Agrupador.rst
│   ├── UC_ACC_05_Gestionar_SoD.rst
│   ├── UC_ACC_06_Gestionar_Segmentos.rst
│   ├── UC_ACC_07_Asignar_Segmento.rst
│   ├── UC_ACC_08_Permiso_Temporal.rst
│   └── UC_ACC_09_Auditar_Cambios_Acceso.rst
│
├── pipeline/                          # MOD_Pipeline (4 UC)
│   ├── index.rst
│   ├── UC_PIP_01_Supervisar_ETL.rst
│   ├── UC_PIP_02_Consultar_Errores_ETL.rst
│   ├── UC_PIP_03_Consultar_Disponibilidad.rst
│   └── UC_PIP_04_Solicitar_Reintento.rst
│
├── reports/                           # MOD_Reports (14 UC)
│   ├── index.rst
│   ├── UC_RPT_01_Consultar_Reporte_Trimestral.rst
│   ├── UC_RPT_02_Consultar_Problemas_Menu.rst
│   ├── UC_RPT_03_Consultar_Transferencias.rst
│   ├── UC_RPT_04_Filtrar_Por_Fecha.rst
│   ├── UC_RPT_05_Filtrar_Por_Centro.rst
│   ├── UC_RPT_06_Exportar_CSV.rst
│   ├── UC_RPT_07_Exportar_Excel.rst
│   ├── UC_RPT_08_Exportar_PDF.rst
│   ├── UC_RPT_09_Ver_Dashboard.rst
│   ├── UC_RPT_10_Ver_KPIs.rst
│   ├── UC_RPT_11_Ver_Tendencias.rst
│   ├── UC_RPT_12_Ver_Grafico_Hora.rst
│   ├── UC_RPT_13_Ver_Grafico_Dia.rst
│   └── UC_RPT_14_Ver_Distribucion_Centro.rst
│
├── alerts/                            # MOD_Alerts (5 UC)
│   ├── index.rst
│   ├── UC_ALR_01_Configurar_Alerta.rst
│   ├── UC_ALR_02_Consultar_Alertas.rst
│   ├── UC_ALR_03_Pausar_Alerta.rst
│   ├── UC_ALR_04_Eliminar_Alerta.rst
│   └── UC_ALR_05_Gestionar_Destinatarios.rst
│
├── audit/                             # MOD_Audit (4 UC)
│   ├── index.rst
│   ├── UC_AUD_01_Consultar_Auditoria.rst
│   ├── UC_AUD_02_Generar_Reporte_Compliance.rst
│   ├── UC_AUD_03_Exportar_Auditoria.rst
│   └── UC_AUD_04_Registrar_Evento.rst
│
└── logs/                              # MOD_Logs (4 UC)
    ├── index.rst
    ├── UC_LOG_01_Consultar_Logs.rst
    ├── UC_LOG_02_Filtrar_Logs.rst
    ├── UC_LOG_03_Exportar_Logs.rst
    └── UC_LOG_04_Configurar_Retencion.rst
```

---

## 3. METODOLOGÍA PASO A PASO

### Fase 0: Preparación (1 vez)
```
□ Crear estructura de directorios
□ Crear archivos base (_static/, index.rst, glosario.rst, actores.rst)
□ Crear plantilla UC estándar
```

### Fase 1-8: Por cada módulo
```
Para cada UC del módulo:
  □ Paso 1: Crear archivo con estructura base
  □ Paso 2: Completar secciones 1-5 (Resumen, Descripción, Diagrama UC, Contexto, Flujo Normal)
  □ Paso 3: Completar secciones 6-8 (Diagrama Secuencia, Flujos Alternos, Excepciones)
  □ Paso 4: Completar secciones 9-11 (Diagrama Actividad, Reglas Negocio, Restricciones Arquitectura)
  □ Paso 5: Completar secciones 12-14 (FR Derivados, Trazabilidad, Historial)
  □ Paso 6: Validar y entregar
```

---

## 4. PLANTILLA ESTÁNDAR DE UC (14 Secciones)

```rst
.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: [MOD_xxx]
   :uc_id: UC_[MOD]_[NN]
   :normativa: [CNST aplicables]

==================================================
UC_[MOD]_[NN]: [Título del Caso de Uso]
==================================================

1. Resumen
----------
.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_[MOD]_[NN]
   * - **Nombre**
     - [Título]
   * - **Actor Principal**
     - [AGR-00x]: [nombre_agrupador]
   * - **Actor Secundario**
     - [Si aplica]
   * - **Módulo**
     - [MOD_xxx]
   * - **Función RBAC**
     - [XXX-NNN]: [nombre_funcion]
   * - **Prioridad**
     - [Alta/Media/Baja]
   * - **Complejidad**
     - [Alta/Media/Baja]
   * - **BReq Origen**
     - [BRQ-xxx]

2. Descripción
--------------
[Descripción detallada del caso de uso, mencionando restricciones CNST aplicables]

3. Diagrama de Caso de Uso
--------------------------
.. uml::
   :caption: Diagrama de Caso de Uso - UC_[MOD]_[NN]

   !include ../_static/plantuml_styles.iuml
   
   [Diagrama PlantUML]

4. Contexto de Ejecución
------------------------

4.1 Precondiciones
^^^^^^^^^^^^^^^^^^
[Lista de precondiciones]

4.2 Trigger
^^^^^^^^^^^
[Evento que inicia el UC]

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^
[Estado del sistema después de ejecución exitosa]

5. Flujo Normal (Camino Feliz)
------------------------------
.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Acción
   * - 1
     - [Actor]
     - [Acción]
   ...

6. Diagrama de Secuencia
------------------------
.. uml::
   :caption: Diagrama de Secuencia - UC_[MOD]_[NN]

   !include ../_static/plantuml_styles.iuml
   
   [Diagrama PlantUML con notas CNST]

7. Flujos Alternos
------------------
[Variaciones del flujo normal]

8. Excepciones
--------------
[Manejo de errores]

9. Diagrama de Actividad
------------------------
.. uml::
   :caption: Diagrama de Actividad - UC_[MOD]_[NN]

   !include ../_static/plantuml_styles.iuml
   
   [Diagrama PlantUML]

10. Reglas de Negocio
---------------------
[BR aplicables]

11. Restricciones de Arquitectura
---------------------------------
.. list-table::
   :widths: 15 25 60
   :header-rows: 1

   * - CNST
     - Nombre
     - Aplicación en este UC
   * - CNST-00x
     - [Nombre]
     - [Cómo se aplica]

12. Requisitos Funcionales Derivados
------------------------------------
[FR-xxx derivados de este UC]

13. Trazabilidad
----------------
.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - [BRQ-xxx]
   * - **Reglas de Negocio**
     - [BR_xxx]
   * - **Restricciones**
     - [CNST-xxx]
   * - **FR Derivados**
     - [FR-xxx]
   * - **UC Relacionados**
     - [UC_xxx]
   * - **Actor Principal**
     - [AGR-00x]
   * - **Función RBAC**
     - [XXX-NNN]

14. Historial de Cambios
------------------------
.. list-table::
   :widths: 15 15 20 50
   :header-rows: 1

   * - Versión
     - Fecha
     - Autor
     - Cambios
   * - 4.0.0
     - 2026-01-06
     - [Autor]
     - Versión inicial v4.0
```

---

## 5. CATÁLOGO COMPLETO DE UC (49)

### MOD_Auth (5 UC)

| ID | Título | Función RBAC | Actor | CNST |
|----|--------|--------------|-------|------|
| UC_AUTH_01 | Iniciar Sesión | (público) | Usuario | CNST-002 |
| UC_AUTH_02 | Cerrar Sesión | (público) | Usuario | CNST-002 |
| UC_AUTH_03 | Recuperar Contraseña | AUT-003 | AGR-006 | CNST-001, CNST-002 |
| UC_AUTH_04 | Cambiar Contraseña | (público) | Usuario | CNST-002 |
| UC_AUTH_05 | Gestionar Sesiones | AUT-001, AUT-002, AUT-004 | AGR-006 | CNST-002, CNST-009 |

### MOD_Users (4 UC)

| ID | Título | Función RBAC | Actor | CNST |
|----|--------|--------------|-------|------|
| UC_USR_01 | Crear Usuario | USR-001 | AGR-006 | CNST-001, CNST-005, CNST-009 |
| UC_USR_02 | Consultar Usuarios | USR-002, USR-005, USR-006 | AGR-006 | CNST-009 |
| UC_USR_03 | Modificar Usuario | USR-003, USR-007, USR-008, USR-009 | AGR-006 | CNST-001, CNST-009 |
| UC_USR_04 | Eliminar Usuario | USR-004 | AGR-006 | CNST-005, CNST-009 |

### MOD_Access (9 UC)

| ID | Título | Función RBAC | Actor | CNST |
|----|--------|--------------|-------|------|
| UC_ACC_01 | Asignar Funciones | ACC-001 | AGR-007 | CNST-005, CNST-009 |
| UC_ACC_02 | Revocar Funciones | ACC-002 | AGR-007 | CNST-005, CNST-009 |
| UC_ACC_03 | Consultar Permisos | ACC-003 | AGR-007 | CNST-009 |
| UC_ACC_04 | Asignar Agrupador | ACC-004 | AGR-007 | CNST-005, CNST-009 |
| UC_ACC_05 | Gestionar SoD | ACC-005 | AGR-007 | CNST-005, CNST-009 |
| UC_ACC_06 | Gestionar Segmentos | ACC-006 | AGR-007 | CNST-009 |
| UC_ACC_07 | Asignar Segmento | USR-010 | AGR-007 | CNST-009 |
| UC_ACC_08 | Permiso Temporal | ACC-001 | AGR-007 | CNST-005, CNST-009 |
| UC_ACC_09 | Auditar Cambios Acceso | (lectura) | AGR-008 | CNST-009 |

### MOD_Pipeline (4 UC)

| ID | Título | Función RBAC | Actor | CNST |
|----|--------|--------------|-------|------|
| UC_PIP_01 | Supervisar ETL | PIP-001 | AGR-009 | CNST-003, CNST-009 |
| UC_PIP_02 | Consultar Errores ETL | PIP-002 | AGR-009 | CNST-003, CNST-009 |
| UC_PIP_03 | Consultar Disponibilidad | PIP-003 | AGR-009 | CNST-003 |
| UC_PIP_04 | Solicitar Reintento | PIP-004 | AGR-009 | CNST-003, CNST-009 |

### MOD_Reports (14 UC)

| ID | Título | Función RBAC | Actor | CNST |
|----|--------|--------------|-------|------|
| UC_RPT_01 | Consultar Reporte Trimestral | RPT-001 | AGR-002, AGR-003 | CNST-003, CNST-006 |
| UC_RPT_02 | Consultar Problemas Menú | RPT-001 | AGR-002, AGR-003 | CNST-003, CNST-006 |
| UC_RPT_03 | Consultar Transferencias | RPT-001 | AGR-002, AGR-003 | CNST-003, CNST-006 |
| UC_RPT_04 | Filtrar Por Fecha | RPT-003 | AGR-002, AGR-003 | CNST-006 |
| UC_RPT_05 | Filtrar Por Centro | RPT-003 | AGR-002, AGR-003 | - |
| UC_RPT_06 | Exportar CSV | RPT-004 | AGR-003, AGR-004 | CNST-001, CNST-007, CNST-009 |
| UC_RPT_07 | Exportar Excel | RPT-005 | AGR-003, AGR-004 | CNST-001, CNST-007, CNST-009 |
| UC_RPT_08 | Exportar PDF | RPT-006 | AGR-003, AGR-004 | CNST-001, CNST-007, CNST-009 |
| UC_RPT_09 | Ver Dashboard | RPT-002 | AGR-001, AGR-002, AGR-003 | CNST-003 |
| UC_RPT_10 | Ver KPIs | RPT-007 | AGR-002, AGR-003 | CNST-003 |
| UC_RPT_11 | Ver Tendencias | RPT-008 | AGR-002, AGR-003 | CNST-003 |
| UC_RPT_12 | Ver Gráfico Hora | RPT-008 | AGR-002, AGR-003 | CNST-003 |
| UC_RPT_13 | Ver Gráfico Día | RPT-008 | AGR-002, AGR-003 | CNST-003 |
| UC_RPT_14 | Ver Distribución Centro | RPT-008 | AGR-002, AGR-003 | CNST-003 |

### MOD_Alerts (5 UC)

| ID | Título | Función RBAC | Actor | CNST |
|----|--------|--------------|-------|------|
| UC_ALR_01 | Configurar Alerta | ALR-002 | AGR-005 | CNST-001, CNST-004, CNST-009 |
| UC_ALR_02 | Consultar Alertas | ALR-001 | AGR-005 | CNST-001 |
| UC_ALR_03 | Pausar Alerta | ALR-004 | AGR-005 | CNST-009 |
| UC_ALR_04 | Eliminar Alerta | ALR-005 | AGR-005 | CNST-009 |
| UC_ALR_05 | Gestionar Destinatarios | ALR-003 | AGR-005 | CNST-001, CNST-004 |

### MOD_Audit (4 UC)

| ID | Título | Función RBAC | Actor | CNST |
|----|--------|--------------|-------|------|
| UC_AUD_01 | Consultar Auditoría | AUD-001, AUD-002 | AGR-008 | CNST-008, CNST-009 |
| UC_AUD_02 | Generar Reporte Compliance | AUD-004 | AGR-008 | CNST-008, CNST-009 |
| UC_AUD_03 | Exportar Auditoría | AUD-003 | AGR-008 | CNST-001, CNST-008, CNST-009 |
| UC_AUD_04 | Registrar Evento | (sistema) | Sistema | CNST-009 |

### MOD_Logs (4 UC)

| ID | Título | Función RBAC | Actor | CNST |
|----|--------|--------------|-------|------|
| UC_LOG_01 | Consultar Logs | LOG-001 | AGR-010 | CNST-008 |
| UC_LOG_02 | Filtrar Logs | LOG-001 | AGR-010 | CNST-008 |
| UC_LOG_03 | Exportar Logs | LOG-002 | AGR-010 | CNST-001, CNST-008 |
| UC_LOG_04 | Configurar Retención | (admin) | AGR-009 | CNST-008 |

---

## 6. ORDEN DE EJECUCIÓN

```
┌─────────────────────────────────────────────────────────────────┐
│                     PLAN DE EJECUCIÓN                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  FASE 0: Preparación                                             │
│  ├── Crear estructura directorios                                │
│  ├── Crear archivos base (index, glosario, actores)             │
│  └── Crear estilos PlantUML                                      │
│                                                                  │
│  FASE 1: MOD_Auth (5 UC)                                         │
│  ├── UC_AUTH_01_Iniciar_Sesion.rst                              │
│  ├── UC_AUTH_02_Cerrar_Sesion.rst                               │
│  ├── UC_AUTH_03_Recuperar_Contrasena.rst                        │
│  ├── UC_AUTH_04_Cambiar_Contrasena.rst                          │
│  └── UC_AUTH_05_Gestionar_Sesiones.rst                          │
│                                                                  │
│  FASE 2: MOD_Users (4 UC)                                        │
│  ├── UC_USR_01_Crear_Usuario.rst                                │
│  ├── UC_USR_02_Consultar_Usuarios.rst                           │
│  ├── UC_USR_03_Modificar_Usuario.rst                            │
│  └── UC_USR_04_Eliminar_Usuario.rst                             │
│                                                                  │
│  FASE 3: MOD_Access (9 UC)                                       │
│  ├── UC_ACC_01_Asignar_Funciones.rst                            │
│  ├── UC_ACC_02_Revocar_Funciones.rst                            │
│  ├── UC_ACC_03_Consultar_Permisos.rst                           │
│  ├── UC_ACC_04_Asignar_Agrupador.rst                            │
│  ├── UC_ACC_05_Gestionar_SoD.rst                                │
│  ├── UC_ACC_06_Gestionar_Segmentos.rst                          │
│  ├── UC_ACC_07_Asignar_Segmento.rst                             │
│  ├── UC_ACC_08_Permiso_Temporal.rst                             │
│  └── UC_ACC_09_Auditar_Cambios_Acceso.rst                       │
│                                                                  │
│  FASE 4: MOD_Pipeline (4 UC)                                     │
│  ├── UC_PIP_01_Supervisar_ETL.rst                               │
│  ├── UC_PIP_02_Consultar_Errores_ETL.rst                        │
│  ├── UC_PIP_03_Consultar_Disponibilidad.rst                     │
│  └── UC_PIP_04_Solicitar_Reintento.rst                          │
│                                                                  │
│  FASE 5: MOD_Reports (14 UC)                                     │
│  ├── UC_RPT_01 a UC_RPT_14                                      │
│  └── (Mayor módulo - 14 UC)                                      │
│                                                                  │
│  FASE 6: MOD_Alerts (5 UC)                                       │
│  ├── UC_ALR_01_Configurar_Alerta.rst                            │
│  ├── UC_ALR_02_Consultar_Alertas.rst                            │
│  ├── UC_ALR_03_Pausar_Alerta.rst                                │
│  ├── UC_ALR_04_Eliminar_Alerta.rst                              │
│  └── UC_ALR_05_Gestionar_Destinatarios.rst                      │
│                                                                  │
│  FASE 7: MOD_Audit (4 UC)                                        │
│  ├── UC_AUD_01_Consultar_Auditoria.rst                          │
│  ├── UC_AUD_02_Generar_Reporte_Compliance.rst                   │
│  ├── UC_AUD_03_Exportar_Auditoria.rst                           │
│  └── UC_AUD_04_Registrar_Evento.rst                             │
│                                                                  │
│  FASE 8: MOD_Logs (4 UC)                                         │
│  ├── UC_LOG_01_Consultar_Logs.rst                               │
│  ├── UC_LOG_02_Filtrar_Logs.rst                                 │
│  ├── UC_LOG_03_Exportar_Logs.rst                                │
│  └── UC_LOG_04_Configurar_Retencion.rst                         │
│                                                                  │
│  ════════════════════════════════════════════════════════════   │
│  TOTAL: 8 Fases + Preparación = 49 UC                            │
└─────────────────────────────────────────────────────────────────┘
```

---

## 7. CHECKLIST DE VALIDACIÓN POR UC

```
□ Formato de nombre correcto (UC_MOD_NN_Nombre.rst)
□ Meta tags completos (project, module, uc_id, normativa)
□ Actor = Agrupador RBAC (AGR-00x)
□ Función RBAC correcta (del catálogo 44)
□ Diagrama UC con actores AGR-00x
□ Diagrama Secuencia con notas CNST
□ Sección 11 "Restricciones de Arquitectura" presente
□ CNST-001: Solo InternalMessage (si aplica notificación)
□ CNST-003: BD especificada (IVR readonly / Analytics write)
□ CNST-009: UserActionLog.record() (si aplica auditoría)
□ Trazabilidad completa (BReq, BR, CNST, FR, UC relacionados)
□ Sin email/webhook/SMS en ningún flujo
```

---

## 8. NORMATIVA A APLICAR

### Por cada UC validar:

| CNST | Verificar |
|------|-----------|
| CNST-001 | ¿Notificaciones? → Solo InternalMessage |
| CNST-002 | ¿Sesiones? → Única, 15 min timeout |
| CNST-003 | ¿Datos IVR? → Solo lectura vía ETL |
| CNST-004 | ¿Alertas? → Máx 50 destinatarios |
| CNST-005 | ¿Permisos? → Flat RBAC, SoD |
| CNST-006 | ¿Reportes fecha? → Máx 2 años |
| CNST-007 | ¿Exportación? → Límites (CSV 100K, Excel 50K, PDF 10K) |
| CNST-008 | ¿Logs? → Sin PII |
| CNST-009 | ¿Cambios críticos? → UserActionLog inmutable |

---

## 9. ENTREGABLES POR FASE

| Fase | Entregable | UC |
|------|------------|-----|
| 0 | Estructura + base files | - |
| 1 | 5 archivos .rst | AUTH-01 a AUTH-05 |
| 2 | 4 archivos .rst | USR-01 a USR-04 |
| 3 | 9 archivos .rst | ACC-01 a ACC-09 |
| 4 | 4 archivos .rst | PIP-01 a PIP-04 |
| 5 | 14 archivos .rst | RPT-01 a RPT-14 |
| 6 | 5 archivos .rst | ALR-01 a ALR-05 |
| 7 | 4 archivos .rst | AUD-01 a AUD-04 |
| 8 | 4 archivos .rst | LOG-01 a LOG-04 |
| **TOTAL** | **49 archivos .rst** | |

---

## 10. ESTIMACIÓN DE ESFUERZO

| Fase | UC | Líneas estimadas | Tiempo estimado |
|------|-----|------------------|-----------------|
| 0 | - | ~500 | 15 min |
| 1 | 5 | ~2,500 | 30 min |
| 2 | 4 | ~2,000 | 25 min |
| 3 | 9 | ~4,500 | 45 min |
| 4 | 4 | ~2,000 | 25 min |
| 5 | 14 | ~7,000 | 60 min |
| 6 | 5 | ~2,500 | 30 min |
| 7 | 4 | ~2,000 | 25 min |
| 8 | 4 | ~2,000 | 25 min |
| **TOTAL** | **49** | **~25,000** | **~4.5 hrs** |

---

**PLAN APROBADO - LISTO PARA EJECUCIÓN**

