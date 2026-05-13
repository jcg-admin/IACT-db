# 📋 PLAN MAESTRO: REQUISITOS FUNCIONALES (FR)
## Análisis Basado en los 49 UC v4.0 Generados

**Versión:** 1.0.0  
**Fecha:** 2026-01-07  
**Estado:** 📝 PROPUESTO  
**Base:** Extracción directa de 49 UC en /mnt/user-data/outputs/casos_uso/

---

# 1. RESUMEN EJECUTIVO

## 1.1 Hallazgos del Análisis

| Métrica | Valor Real |
|---------|------------|
| UC Analizados | 49 |
| FR Identificados en UC | **158** |
| Promedio FR por UC | 3.2 |
| Nomenclatura UC | UC_NNN (numérico global) |
| Nomenclatura FR | FR-NNN.NN |

## 1.2 Nomenclatura Real vs Propuesta Anterior

| Elemento | Nomenclatura Real | Propuesta Anterior |
|----------|-------------------|-------------------|
| UC Auth | UC_001-005 | UC_AUTH_01-05 |
| UC Users | UC_006-009 | UC_USR_01-04 |
| UC Access | UC_010-011, UC_041-047 | UC_ACC_01-09 |
| UC Reports | UC_017-030 | UC_RPT_01-14 |
| UC Alerts | UC_036-040 | UC_ALR_01-05 |
| UC Pipeline | UC_050-053 | UC_PIP_01-04 |
| UC Audit | UC_060-063 | UC_AUD_01-04 |
| UC Logs | UC_070-073 | UC_LOG_01-04 |
| FR | FR-NNN.NN | FR_MOD_UC_NN |

---

# 2. INVENTARIO COMPLETO DE FR POR MÓDULO

## 2.1 MOD_Auth (5 UC, 21 FR)

### UC_001_Iniciar_Sesion (5 FR)
```
FR-001.01: Validar formato username
FR-001.02: Validar credenciales
FR-001.03: Generar token JWT
FR-001.04: Invalidar sesiones previas
FR-001.05: Registrar evento auditoria
```

### UC_002_Cerrar_Sesion (3 FR)
```
FR-002.01: Invalidar token JWT
FR-002.02: Registrar evento logout
FR-002.03: Limpiar datos de sesion cliente
```

### UC_003_Recuperar_Password (5 FR)
```
FR-003.01: Validar username existe
FR-003.02: Mostrar pregunta seguridad
FR-003.03: Validar respuesta
FR-003.04: Generar password temporal
FR-003.05: Forzar cambio en siguiente login
```

### UC_004_Cambiar_Password (4 FR)
```
FR-004.01: Validar password actual
FR-004.02: Validar complejidad nuevo password
FR-004.03: Actualizar hash en BD
FR-004.04: Invalidar sesiones
```

### UC_005_Gestionar_Sesiones (4 FR)
```
FR-005.01: Listar sesiones activas
FR-005.02: Mostrar detalle de sesion
FR-005.03: Invalidar sesion individual
FR-005.04: Invalidar sesiones por usuario
```

**Subtotal MOD_Auth: 21 FR**

---

## 2.2 MOD_Users (4 UC, 16 FR)

### UC_006_Crear_Usuario (5 FR)
```
FR-006.01: Validar campos obligatorios
FR-006.02: Verificar unicidad username
FR-006.03: Generar password temporal
FR-006.04: Crear registro usuario
FR-006.05: Registrar auditoria
```

### UC_007_Modificar_Usuario (4 FR)
```
FR-007.01: Cargar datos usuario
FR-007.02: Validar campos modificados
FR-007.03: Actualizar registro
FR-007.04: Registrar cambios en auditoria
```

### UC_008_Baja_Usuario (4 FR)
```
FR-008.01: Validar usuario activo
FR-008.02: Cambiar estado a INACTIVO
FR-008.03: Invalidar sesiones
FR-008.04: Preservar registro historico
```

### UC_009_Listar_Usuarios (4 FR)
```
FR-009.01: Obtener lista paginada
FR-009.02: Aplicar filtros
FR-009.03: Ordenar resultados
FR-009.04: Mostrar indicador inactividad (BR_003)
```

**Subtotal MOD_Users: 17 FR**

---

## 2.3 MOD_Access (9 UC, 30 FR)

### UC_010_Asignar_Funciones (4 FR)
```
FR-010.01: Listar funciones disponibles
FR-010.02: Validar SoD antes de asignar
FR-010.03: Crear asignacion usuario-funcion
FR-010.04: Calcular permisos efectivos
```

### UC_011_Revocar_Funciones (3 FR)
```
FR-011.01: Listar funciones asignadas
FR-011.02: Eliminar asignacion
FR-011.03: Recalcular permisos efectivos
```

### UC_041_Asignar_Segmento (3 FR)
```
FR-041.01: Listar centros disponibles
FR-041.02: Asignar centro a usuario
FR-041.03: Aplicar filtro en consultas
```

### UC_042_Revocar_Segmento (2 FR)
```
FR-042.01: Validar minimo un segmento
FR-042.02: Eliminar asignacion segmento
```

### UC_043_Configurar_SoD (5 FR)
```
FR-043.01: Crear restriccion SoD
FR-043.02: Validar conflictos existentes
FR-043.03: Listar restricciones vigentes
FR-043.04: Modificar restriccion
FR-043.05: Eliminar restriccion
```

### UC_044_Consultar_Permisos (3 FR)
```
FR-044.01: Calcular permisos efectivos
FR-044.02: Mostrar origen de permiso
FR-044.03: Mostrar restricciones SoD
```

### UC_045_Gestionar_Agrupadores (4 FR)
```
FR-045.01: Listar agrupadores
FR-045.02: Crear agrupador
FR-045.03: Modificar composicion
FR-045.04: Validar SoD interno
```

### UC_046_Gestionar_Funciones (3 FR)
```
FR-046.01: Listar funciones por modulo
FR-046.02: Mostrar detalle funcion
FR-046.03: Actualizar descripcion
```

### UC_047_Auditar_Permisos (3 FR)
```
FR-047.01: Consultar historial permisos
FR-047.02: Filtrar por criterios
FR-047.03: Exportar reporte auditoria
```

**Subtotal MOD_Access: 30 FR**

---

## 2.4 MOD_Pipeline (4 UC, 11 FR)

### UC_050_Supervisar_ETL (3 FR)
```
FR-050.01: Obtener estado actual ETL
FR-050.02: Mostrar metricas ejecucion
FR-050.03: Actualizar automaticamente
```

### UC_051_Consultar_Errores_ETL (3 FR)
```
FR-051.01: Listar ejecuciones con error
FR-051.02: Mostrar detalle de error
FR-051.03: Exportar log de errores
```

### UC_052_Consultar_Disponibilidad (2 FR)
```
FR-052.01: Obtener fecha ultimo dato
FR-052.02: Calcular completitud de datos
```

### UC_053_Reiniciar_ETL (3 FR)
```
FR-053.01: Verificar ETL no activo
FR-053.02: Iniciar ETL manual
FR-053.03: Registrar ejecucion manual
```

**Subtotal MOD_Pipeline: 11 FR**

---

## 2.5 MOD_Reports (14 UC, 38 FR)

### UC_017_Generar_Reporte (5 FR)
```
FR-017.01: Listar reportes predefinidos
FR-017.02: Aplicar filtros
FR-017.03: Validar rango temporal
FR-017.04: Generar datos del reporte
FR-017.05: Renderizar reporte
```

### UC_018_Crear_Reporte_Personalizado (4 FR)
```
FR-018.01: Listar metricas disponibles
FR-018.02: Listar dimensiones
FR-018.03: Construir query dinamico
FR-018.04: Guardar definicion reporte
```

### UC_019_Programar_Reporte (3 FR)
```
FR-019.01: Crear programacion
FR-019.02: Ejecutar segun frecuencia
FR-019.03: Depositar en buzon
```

### UC_020_Filtrar_Por_Fecha (2 FR)
```
FR-020.01: Validar rango temporal
FR-020.02: Aplicar filtro de fechas
```

### UC_021_Filtrar_Por_Centro (2 FR)
```
FR-021.01: Obtener centros del segmento
FR-021.02: Aplicar filtro de centro
```

### UC_022_Exportar_CSV (3 FR)
```
FR-022.01: Validar limite registros
FR-022.02: Generar CSV
FR-022.03: Streaming de descarga
```

### UC_023_Exportar_Excel (3 FR)
```
FR-023.01: Generar XLSX
FR-023.02: Aplicar estilos
FR-023.03: Incluir metadatos
```

### UC_024_Exportar_PDF (3 FR)
```
FR-024.01: Generar PDF
FR-024.02: Renderizar graficos
FR-024.03: Aplicar layout impresion
```

### UC_025_Visualizar_Dashboard (4 FR)
```
FR-025.01: Cargar datos por segmento
FR-025.02: Renderizar widgets KPI
FR-025.03: Renderizar graficos
FR-025.04: Auto-refresh cada 5 min
```

### UC_026_Ver_KPIs (2 FR)
```
FR-026.01: Calcular KPIs
FR-026.02: Mostrar tendencia
```

### UC_027_Analizar_Tendencias (3 FR)
```
FR-027.01: Obtener datos historicos
FR-027.02: Generar grafico tendencia
FR-027.03: Cambiar granularidad
```

### UC_028_Comparar_Periodos (3 FR)
```
FR-028.01: Calcular metricas por periodo
FR-028.02: Calcular variacion porcentual
FR-028.03: Mostrar comparativa visual
```

### UC_029_Filtrar_Dashboard_Centro (2 FR)
```
FR-029.01: Listar centros del segmento
FR-029.02: Aplicar filtro global dashboard
```

### UC_030_Exportar_Dashboard (2 FR)
```
FR-030.01: Capturar estado dashboard
FR-030.02: Generar imagen/PDF
```

**Subtotal MOD_Reports: 41 FR**

---

## 2.6 MOD_Alerts (5 UC, 14 FR)

### UC_036_Crear_Alerta (4 FR)
```
FR-036.01: Listar metricas alertables
FR-036.02: Crear definicion de alerta
FR-036.03: Validar umbral
FR-036.04: Activar evaluacion periodica
```

### UC_037_Recibir_Notificacion (3 FR)
```
FR-037.01: Depositar en buzon interno
FR-037.02: Mostrar indicador de nuevas
FR-037.03: Marcar como leida
```

### UC_038_Consultar_Historial (3 FR)
```
FR-038.01: Listar alertas historicas
FR-038.02: Filtrar por criterios
FR-038.03: Mostrar detalle de alerta
```

### UC_039_Modificar_Alerta (3 FR)
```
FR-039.01: Cargar configuracion
FR-039.02: Validar cambios
FR-039.03: Actualizar alerta
```

### UC_040_Gestionar_Destinatarios (3 FR)
```
FR-040.01: Listar destinatarios actuales
FR-040.02: Agregar destinatario
FR-040.03: Quitar destinatario
```

**Subtotal MOD_Alerts: 16 FR**

---

## 2.7 MOD_Audit (4 UC, 12 FR)

### UC_060_Registrar_Evento (3 FR)
```
FR-060.01: Capturar datos de evento
FR-060.02: Insertar en tabla inmutable
FR-060.03: Garantizar atomicidad
```

### UC_061_Consultar_Log (3 FR)
```
FR-061.01: Listar eventos de auditoria
FR-061.02: Aplicar filtros
FR-061.03: Mostrar detalle de evento
```

### UC_062_Generar_Reporte_Auditoria (3 FR)
```
FR-062.01: Seleccionar tipo de reporte
FR-062.02: Agregar datos por tipo
FR-062.03: Generar formato reporte
```

### UC_063_Exportar_Auditoria (3 FR)
```
FR-063.01: Exportar a CSV
FR-063.02: Exportar a Excel
FR-063.03: Incluir metadatos
```

**Subtotal MOD_Audit: 12 FR**

---

## 2.8 MOD_Logs (4 UC, 8 FR)

### UC_070_Consultar_Logs_Sistema (3 FR)
```
FR-070.01: Listar logs del sistema
FR-070.02: Filtrar por nivel
FR-070.03: Buscar por texto
```

### UC_071_Filtrar_Logs (2 FR)
```
FR-071.01: Filtrar por multiples criterios
FR-071.02: Combinar filtros con AND
```

### UC_072_Exportar_Logs (2 FR)
```
FR-072.01: Exportar logs filtrados
FR-072.02: Generar formato TXT/CSV
```

### UC_073_Configurar_Retencion (3 FR)
```
FR-073.01: Mostrar configuracion actual
FR-073.02: Validar minimo retencion
FR-073.03: Actualizar politica
```

**Subtotal MOD_Logs: 10 FR**

---

# 3. RESUMEN ESTADÍSTICO

## 3.1 FR por Módulo

| Módulo | UC | FR | Promedio FR/UC |
|--------|----|----|----------------|
| MOD_Auth | 5 | 21 | 4.2 |
| MOD_Users | 4 | 17 | 4.25 |
| MOD_Access | 9 | 30 | 3.3 |
| MOD_Pipeline | 4 | 11 | 2.75 |
| MOD_Reports | 14 | 41 | 2.9 |
| MOD_Alerts | 5 | 16 | 3.2 |
| MOD_Audit | 4 | 12 | 3.0 |
| MOD_Logs | 4 | 10 | 2.5 |
| **TOTAL** | **49** | **158** | **3.2** |

## 3.2 Distribución de Rangos de ID

| Rango ID | Módulo | Cantidad UC |
|----------|--------|-------------|
| 001-005 | Auth | 5 |
| 006-009 | Users | 4 |
| 010-011 | Access (parte 1) | 2 |
| 017-030 | Reports | 14 |
| 036-040 | Alerts | 5 |
| 041-047 | Access (parte 2) | 7 |
| 050-053 | Pipeline | 4 |
| 060-063 | Audit | 4 |
| 070-073 | Logs | 4 |

---

# 4. ESTRUCTURA DE DIRECTORIOS PROPUESTA

## 4.1 Basada en Nomenclatura Real

```
requisitos/
└── funcionales/
    ├── index.rst
    │
    ├── auth/                                    # UC_001-005
    │   ├── index.rst
    │   ├── UC_001_Iniciar_Sesion/
    │   │   ├── FR-001.01_Validar_formato_username.rst
    │   │   ├── FR-001.02_Validar_credenciales.rst
    │   │   ├── FR-001.03_Generar_token_JWT.rst
    │   │   ├── FR-001.04_Invalidar_sesiones_previas.rst
    │   │   └── FR-001.05_Registrar_evento_auditoria.rst
    │   │
    │   ├── UC_002_Cerrar_Sesion/
    │   │   ├── FR-002.01_Invalidar_token_JWT.rst
    │   │   ├── FR-002.02_Registrar_evento_logout.rst
    │   │   └── FR-002.03_Limpiar_datos_sesion_cliente.rst
    │   │
    │   ├── UC_003_Recuperar_Password/
    │   │   ├── FR-003.01_Validar_username_existe.rst
    │   │   ├── FR-003.02_Mostrar_pregunta_seguridad.rst
    │   │   ├── FR-003.03_Validar_respuesta.rst
    │   │   ├── FR-003.04_Generar_password_temporal.rst
    │   │   └── FR-003.05_Forzar_cambio_siguiente_login.rst
    │   │
    │   ├── UC_004_Cambiar_Password/
    │   │   ├── FR-004.01_Validar_password_actual.rst
    │   │   ├── FR-004.02_Validar_complejidad_nuevo_password.rst
    │   │   ├── FR-004.03_Actualizar_hash_BD.rst
    │   │   └── FR-004.04_Invalidar_sesiones.rst
    │   │
    │   └── UC_005_Gestionar_Sesiones/
    │       ├── FR-005.01_Listar_sesiones_activas.rst
    │       ├── FR-005.02_Mostrar_detalle_sesion.rst
    │       ├── FR-005.03_Invalidar_sesion_individual.rst
    │       └── FR-005.04_Invalidar_sesiones_por_usuario.rst
    │
    ├── users/                                   # UC_006-009
    │   ├── index.rst
    │   ├── UC_006_Crear_Usuario/
    │   │   └── [5 FR]
    │   ├── UC_007_Modificar_Usuario/
    │   │   └── [4 FR]
    │   ├── UC_008_Baja_Usuario/
    │   │   └── [4 FR]
    │   └── UC_009_Listar_Usuarios/
    │       └── [4 FR]
    │
    ├── access/                                  # UC_010-011, UC_041-047
    │   ├── index.rst
    │   ├── UC_010_Asignar_Funciones/
    │   │   └── [4 FR]
    │   ├── UC_011_Revocar_Funciones/
    │   │   └── [3 FR]
    │   ├── UC_041_Asignar_Segmento/
    │   │   └── [3 FR]
    │   ├── UC_042_Revocar_Segmento/
    │   │   └── [2 FR]
    │   ├── UC_043_Configurar_SoD/
    │   │   └── [5 FR]
    │   ├── UC_044_Consultar_Permisos/
    │   │   └── [3 FR]
    │   ├── UC_045_Gestionar_Agrupadores/
    │   │   └── [4 FR]
    │   ├── UC_046_Gestionar_Funciones/
    │   │   └── [3 FR]
    │   └── UC_047_Auditar_Permisos/
    │       └── [3 FR]
    │
    ├── pipeline/                                # UC_050-053
    │   ├── index.rst
    │   ├── UC_050_Supervisar_ETL/
    │   │   └── [3 FR]
    │   ├── UC_051_Consultar_Errores_ETL/
    │   │   └── [3 FR]
    │   ├── UC_052_Consultar_Disponibilidad/
    │   │   └── [2 FR]
    │   └── UC_053_Reiniciar_ETL/
    │       └── [3 FR]
    │
    ├── reports/                                 # UC_017-030
    │   ├── index.rst
    │   ├── UC_017_Generar_Reporte/
    │   │   └── [5 FR]
    │   ├── UC_018_Crear_Reporte_Personalizado/
    │   │   └── [4 FR]
    │   ├── UC_019_Programar_Reporte/
    │   │   └── [3 FR]
    │   ├── UC_020_Filtrar_Por_Fecha/
    │   │   └── [2 FR]
    │   ├── UC_021_Filtrar_Por_Centro/
    │   │   └── [2 FR]
    │   ├── UC_022_Exportar_CSV/
    │   │   └── [3 FR]
    │   ├── UC_023_Exportar_Excel/
    │   │   └── [3 FR]
    │   ├── UC_024_Exportar_PDF/
    │   │   └── [3 FR]
    │   ├── UC_025_Visualizar_Dashboard/
    │   │   └── [4 FR]
    │   ├── UC_026_Ver_KPIs/
    │   │   └── [2 FR]
    │   ├── UC_027_Analizar_Tendencias/
    │   │   └── [3 FR]
    │   ├── UC_028_Comparar_Periodos/
    │   │   └── [3 FR]
    │   ├── UC_029_Filtrar_Dashboard_Centro/
    │   │   └── [2 FR]
    │   └── UC_030_Exportar_Dashboard/
    │       └── [2 FR]
    │
    ├── alerts/                                  # UC_036-040
    │   ├── index.rst
    │   ├── UC_036_Crear_Alerta/
    │   │   └── [4 FR]
    │   ├── UC_037_Recibir_Notificacion/
    │   │   └── [3 FR]
    │   ├── UC_038_Consultar_Historial/
    │   │   └── [3 FR]
    │   ├── UC_039_Modificar_Alerta/
    │   │   └── [3 FR]
    │   └── UC_040_Gestionar_Destinatarios/
    │       └── [3 FR]
    │
    ├── audit/                                   # UC_060-063
    │   ├── index.rst
    │   ├── UC_060_Registrar_Evento/
    │   │   └── [3 FR]
    │   ├── UC_061_Consultar_Log/
    │   │   └── [3 FR]
    │   ├── UC_062_Generar_Reporte_Auditoria/
    │   │   └── [3 FR]
    │   └── UC_063_Exportar_Auditoria/
    │       └── [3 FR]
    │
    └── logs/                                    # UC_070-073
        ├── index.rst
        ├── UC_070_Consultar_Logs_Sistema/
        │   └── [3 FR]
        ├── UC_071_Filtrar_Logs/
        │   └── [2 FR]
        ├── UC_072_Exportar_Logs/
        │   └── [2 FR]
        └── UC_073_Configurar_Retencion/
            └── [3 FR]
```

## 4.2 Conteo de Estructura

| Elemento | Cantidad |
|----------|----------|
| Archivos FR (.rst) | 158 |
| Archivos index.rst | 9 |
| Carpetas UC | 49 |
| Carpetas Módulo | 8 |
| **Total Archivos** | **167** |
| **Total Carpetas** | **58** |

---

# 5. NOMENCLATURA FR

## 5.1 Formato Actual (Real)

```
FR-NNN.NN

Donde:
- NNN: Número del UC origen (001-073)
- NN: Número secuencial del FR dentro del UC (01-99)

Ejemplo: FR-001.05 = FR #5 del UC_001
```

## 5.2 Nombre de Archivo

```
FR-NNN.NN_Nombre_Descriptivo.rst

Ejemplos:
- FR-001.01_Validar_formato_username.rst
- FR-025.04_Auto_refresh_cada_5_min.rst
- FR-043.02_Validar_conflictos_existentes.rst
```

---

# 6. TEMPLATE FR INDIVIDUAL

```rst
.. meta::
   :artefacto: FR-NNN.NN
   :tipo: Requisito Funcional
   :dominio: requisitos
   :subdominio: funcionales/{modulo}
   :estado: Borrador
   :version: 1.0.0
   :fecha: 2026-01-XX
   :autor: Equipo IACT

.. _fr-nnn-nn:

==============================================================================
FR-NNN.NN: Nombre Descriptivo
==============================================================================

----

1. Identificación
-----------------

.. list-table::
   :widths: 25 75

   * - **ID**
     - FR-NNN.NN
   * - **Nombre**
     - [Nombre descriptivo]
   * - **UC Origen**
     - UC_NNN: [Nombre UC]
   * - **Paso UC**
     - Paso N del flujo [normal|alterno]
   * - **Módulo**
     - MOD_Xxx
   * - **Prioridad**
     - Alta / Media / Baja
   * - **Tipo**
     - Validación / Proceso / Datos / Interfaz / Seguridad

----

2. Especificación
-----------------

**Declaración:**

   El sistema DEBE [acción específica] CUANDO [condición/trigger].

**Descripción:**

   [Explicación detallada del comportamiento esperado]

----

3. Criterio de Aceptación
-------------------------

::

   DADO [contexto inicial]
   CUANDO [acción del usuario o evento]
   ENTONCES [resultado esperado]

----

4. Reglas y Restricciones
-------------------------

- **BR aplicables:** BR_NNN
- **CNST aplicables:** CNST-NNN

----

5. Trazabilidad
---------------

- **BReq:** BReq-NNN
- **UC:** UC_NNN
- **Depende de:** FR-NNN.NN
- **Requerido por:** FR-NNN.NN
- **TEST:** TST-FR-NNN.NN (pendiente)

----

6. Historial
------------

.. list-table::
   :widths: 15 15 70
   :header-rows: 1

   * - Versión
     - Fecha
     - Cambio
   * - 1.0.0
     - 2026-01-XX
     - Versión inicial
```

---

# 7. PLAN DE GENERACIÓN

## 7.1 Fases por Prioridad

| Fase | Módulo | UC | FR | Prioridad |
|------|--------|----|----|-----------|
| F1 | MOD_Auth | 5 | 21 | 🔴 Alta |
| F2 | MOD_Users | 4 | 17 | 🔴 Alta |
| F3 | MOD_Access | 9 | 30 | 🔴 Alta |
| F4 | MOD_Pipeline | 4 | 11 | 🟡 Media |
| F5 | MOD_Reports | 14 | 41 | 🟡 Media |
| F6 | MOD_Alerts | 5 | 16 | 🟡 Media |
| F7 | MOD_Audit | 4 | 12 | 🟢 Baja |
| F8 | MOD_Logs | 4 | 10 | 🟢 Baja |
| **TOTAL** | — | **49** | **158** | — |

## 7.2 Estimación de Esfuerzo

| Fase | Archivos | Líneas Est. | Sesiones |
|------|----------|-------------|----------|
| F1-F3 (Alta) | 68 FR | ~4,000 | 3-4 |
| F4-F6 (Media) | 68 FR | ~4,000 | 3-4 |
| F7-F8 (Baja) | 22 FR | ~1,300 | 1-2 |
| **TOTAL** | **158 FR** | **~9,300** | **7-10** |

---

# 8. PRÓXIMOS PASOS

1. ✅ Análisis de UC completado
2. ✅ Inventario de 158 FR identificados
3. ⏳ Aprobar nomenclatura y estructura
4. ⏳ Generar FR Fase 1-3 (Auth, Users, Access)
5. ⏳ Validar formato con piloto
6. ⏳ Continuar con fases restantes

---

*Plan FR Basado en Análisis Real v1.0.0*  
*Proyecto: IACT Call Center Analytics Dashboard*  
*Fecha: 2026-01-07*  
*Fuente: 49 UC en /mnt/user-data/outputs/casos_uso/*
