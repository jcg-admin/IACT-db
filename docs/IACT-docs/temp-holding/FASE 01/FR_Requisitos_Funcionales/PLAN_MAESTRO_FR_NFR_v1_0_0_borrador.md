# 📋 PLAN MAESTRO: REQUISITOS FUNCIONALES (FR) + NFR DESCONGELADOS
## Proyecto IACT - Fase Post-UC v4.0

**Versión:** 1.0.0  
**Fecha:** 2026-01-07  
**Estado:** 📝 PROPUESTO  
**Prerrequisito:** 49 UC v4.0 completados ✅

---

# PARTE 1: PLAN DE REQUISITOS FUNCIONALES (FR)

## 1. CONTEXTO Y JUSTIFICACIÓN

### 1.1 Situación Actual

```
CADENA DE DERIVACIÓN:
BReq (8) → BR (20) → UC (49) ✅ → FR (???) → CODE → TEST
                              ↑
                         ESTAMOS AQUÍ
```

### 1.2 Ratio de Derivación

Basado en metodología Larman y práctica estándar:

| Métrica | Valor |
|---------|-------|
| Ratio típico UC:FR | 1:8 |
| UC generados | 49 |
| **FR estimados** | **~392** |
| FR por módulo (promedio) | ~49 |

---

## 2. NOMENCLATURA FR

### 2.1 Formato de Identificador

```
FR_[MOD]_[UC]_[NN]
```

- **FR**: Prefijo fijo (Functional Requirement)
- **[MOD]**: Código módulo (AUTH, USR, ACC, PIP, RPT, ALR, AUD, LOG)
- **[UC]**: Número del UC origen (01-14)
- **[NN]**: Número secuencial del FR dentro del UC (01-99)

### 2.2 Ejemplos

| UC Origen | FR Derivados | Rango |
|-----------|--------------|-------|
| UC_AUTH_01 | FR_AUTH_01_01 a FR_AUTH_01_08 | 8 FR |
| UC_RPT_07 | FR_RPT_07_01 a FR_RPT_07_10 | 10 FR |
| UC_ACC_05 | FR_ACC_05_01 a FR_ACC_05_12 | 12 FR (SoD complejo) |

### 2.3 Nombre de Archivo

```
FR_[MOD]_[UC]_[Nombre_UC].rst

Ejemplos:
- FR_AUTH_01_Iniciar_Sesion.rst (contiene FR_AUTH_01_01 a FR_AUTH_01_08)
- FR_RPT_07_Generar_Reporte_Trimestral.rst
```

**Decisión:** Un archivo por UC, conteniendo todos sus FR derivados.

---

## 3. ESTRUCTURA DE CADA ARCHIVO FR

### 3.1 Principio

> **Un archivo .rst por cada Requisito Funcional individual**

### 3.2 Template para FR Individual

```rst
.. meta::
   :project: IACT - Call Center Analytics
   :version: 1.0.0
   :date: 2026-01-XX
   :status: Borrador
   :module: MOD_Xxx
   :uc_origen: UC_XXX_NN
   :fr_id: FR_XXX_NN_MM

=========================================
FR_XXX_NN_MM: [Nombre Descriptivo del FR]
=========================================

1. Identificación
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - FR_XXX_NN_MM
   * - **Nombre**
     - [Nombre descriptivo]
   * - **UC Origen**
     - UC_XXX_NN: [Nombre UC]
   * - **Paso UC**
     - Paso N del flujo [normal|alterno|excepción]
   * - **Módulo**
     - MOD_Xxx
   * - **Prioridad**
     - Alta / Media / Baja
   * - **Tipo**
     - Datos / Interfaz / Proceso / Cálculo / Validación / Seguridad / Auditoría

2. Especificación
-----------------

**Declaración:**

   El sistema DEBE [acción específica] CUANDO [condición/trigger].

**Descripción Detallada:**

[Explicación completa del requisito funcional, incluyendo contexto
y comportamiento esperado del sistema.]

3. Criterio de Aceptación
-------------------------

.. code-block:: gherkin

   DADO [contexto inicial / precondiciones]
   CUANDO [acción del usuario o evento del sistema]
   ENTONCES [resultado esperado / postcondiciones]

4. Reglas de Negocio Aplicables
-------------------------------

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - BR
     - Descripción
   * - BR_XXX
     - [Cómo aplica esta BR al FR]

5. Restricciones Técnicas
-------------------------

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - CNST
     - Impacto en este FR
   * - CNST-XXX
     - [Cómo afecta la restricción a la implementación]

6. Dependencias
---------------

**Depende de:**

- FR_XXX_NN_YY: [razón]

**Requerido por:**

- FR_XXX_NN_ZZ: [razón]

7. Notas de Implementación
--------------------------

- Endpoint: ``/api/v1/xxx/``
- Método: GET / POST / PUT / DELETE
- Modelo Django: ``XxxModel``
- Serializer: ``XxxSerializer``

8. Trazabilidad
---------------

.. list-table::
   :widths: 20 80
   :header-rows: 0

   * - **BReq**
     - BReq_XXX
   * - **BR**
     - BR_001, BR_002
   * - **UC**
     - UC_XXX_NN
   * - **CNST**
     - CNST-001, CNST-003
   * - **TEST**
     - TST_FR_XXX_NN_MM (pendiente)

9. Historial de Cambios
-----------------------

.. list-table::
   :widths: 15 15 70
   :header-rows: 1

   * - Versión
     - Fecha
     - Cambios
   * - 1.0.0
     - 2026-01-XX
     - Versión inicial derivada de UC_XXX_NN v4.0
```

### 3.3 Nombre de Archivo

```
FR_[MOD]_[UC]_[NN]_[Nombre_Descriptivo].rst

Ejemplos:
- FR_AUTH_01_01_Validar_Formato_Username.rst
- FR_AUTH_01_05_Generar_Token_JWT.rst
- FR_RPT_07_03_Calcular_Metricas_Trimestre.rst
- FR_ACC_05_02_Detectar_Conflicto_SoD.rst
```

---

## 4. REGLAS DE DERIVACIÓN UC → FR

### 4.1 Principio Base (Larman)

> **"Cada paso del Sistema en el flujo de un UC genera al menos un FR"**

### 4.2 Fuentes de FR en cada UC

| Sección UC | Genera FR | Tipo FR |
|------------|-----------|---------|
| Flujo Normal - pasos "Sistema" | ✅ SÍ | Proceso, Datos |
| Precondiciones | ✅ SÍ | Validación |
| Postcondiciones | ✅ SÍ | Estado, Datos |
| Flujos Alternos | ✅ SÍ | Variantes |
| Excepciones | ✅ SÍ | Manejo errores |
| Reglas de Negocio | ✅ SÍ | Cálculo, Restricción |
| CNST aplicables | ✅ SÍ | Técnicos |

### 4.3 Tipos de FR

| Tipo | Descripción | Ejemplo |
|------|-------------|---------|
| **Datos** | Almacenamiento, estructura | "El sistema DEBE guardar username, email, created_at" |
| **Interfaz** | Presentación, UX | "El sistema DEBE mostrar mensaje de error en rojo" |
| **Proceso** | Lógica de negocio | "El sistema DEBE validar credenciales contra BD" |
| **Cálculo** | Fórmulas, métricas | "El sistema DEBE calcular tasa_abandono = ..." |
| **Validación** | Verificaciones | "El sistema DEBE verificar formato email válido" |
| **Seguridad** | RBAC, autenticación | "El sistema DEBE verificar función AUTH-001" |
| **Auditoría** | Registro de acciones | "El sistema DEBE registrar LOGIN en user_action_log" |

### 4.4 Árbol de Decisión para Derivar FR

```
¿El paso es ejecutado por el Sistema?
│
├─ NO → No genera FR (es acción del Actor)
│
└─ SÍ → ¿Qué tipo de acción?
        │
        ├─ Muestra/Presenta → FR tipo Interfaz
        ├─ Valida/Verifica → FR tipo Validación
        ├─ Guarda/Actualiza → FR tipo Datos
        ├─ Calcula/Procesa → FR tipo Proceso/Cálculo
        ├─ Registra auditoría → FR tipo Auditoría
        └─ Verifica permisos → FR tipo Seguridad
```

---

## 5. ESTIMACIÓN POR MÓDULO

### 5.1 Distribución Esperada

| Módulo | UC | FR Est. | Complejidad |
|--------|----|---------| ------------|
| MOD_Auth | 5 | ~40 | Media (sesiones, tokens) |
| MOD_Users | 4 | ~32 | Media (CRUD + validaciones) |
| MOD_Access | 9 | ~90 | **Alta** (RBAC, SoD, permisos) |
| MOD_Pipeline | 4 | ~28 | Baja (solo lectura ETL) |
| MOD_Reports | 14 | ~100 | Media (filtros, exports) |
| MOD_Alerts | 5 | ~40 | Media (notificaciones) |
| MOD_Audit | 4 | ~35 | Media (consultas, exports) |
| MOD_Logs | 4 | ~27 | Baja (lectura logs) |
| **TOTAL** | **49** | **~392** | — |

### 5.2 FR por Tipo (Estimado Global)

| Tipo | Cantidad | % |
|------|----------|---|
| Proceso | ~120 | 31% |
| Validación | ~80 | 20% |
| Datos | ~70 | 18% |
| Interfaz | ~50 | 13% |
| Seguridad | ~40 | 10% |
| Auditoría | ~20 | 5% |
| Cálculo | ~12 | 3% |
| **TOTAL** | **~392** | 100% |

---

## 6. PLAN DE EJECUCIÓN FR

### 6.1 Fases de Generación

| Fase | Módulo | UC | FR Est. | Prioridad |
|------|--------|----|---------| ----------|
| F1 | MOD_Auth | 5 | ~40 | 🔴 Alta |
| F2 | MOD_Users | 4 | ~32 | 🔴 Alta |
| F3 | MOD_Access | 9 | ~90 | 🔴 Alta |
| F4 | MOD_Pipeline | 4 | ~28 | 🟡 Media |
| F5 | MOD_Reports | 14 | ~100 | 🟡 Media |
| F6 | MOD_Alerts | 5 | ~40 | 🟡 Media |
| F7 | MOD_Audit | 4 | ~35 | 🟢 Baja |
| F8 | MOD_Logs | 4 | ~27 | 🟢 Baja |

### 6.2 Estructura de Directorios

**Principio:** Un archivo .rst por cada FR individual, organizados en subcarpetas por UC.

```
requisitos/
└── funcionales/                                         # [DESCONGELADO] ~392 archivos FR
    ├── index.rst
    │
    ├── auth/
    │   ├── index.rst
    │   │
    │   ├── UC_AUTH_01_Iniciar_Sesion/
    │   │   ├── FR_AUTH_01_01_Validar_Formato_Username.rst
    │   │   ├── FR_AUTH_01_02_Validar_Formato_Password.rst
    │   │   ├── FR_AUTH_01_03_Verificar_Credenciales.rst
    │   │   ├── FR_AUTH_01_04_Verificar_Usuario_Activo.rst
    │   │   ├── FR_AUTH_01_05_Generar_Token_JWT.rst
    │   │   ├── FR_AUTH_01_06_Crear_Registro_Sesion.rst
    │   │   ├── FR_AUTH_01_07_Registrar_Login_Auditoria.rst
    │   │   └── FR_AUTH_01_08_Retornar_Token_Frontend.rst
    │   │
    │   ├── UC_AUTH_02_Cerrar_Sesion/
    │   │   ├── FR_AUTH_02_01_Invalidar_Token_JWT.rst
    │   │   ├── FR_AUTH_02_02_...rst
    │   │   └── ...
    │   │
    │   ├── UC_AUTH_03_Recuperar_Contrasena/
    │   │   └── FR_AUTH_03_NN_...rst
    │   ├── UC_AUTH_04_Cambiar_Contrasena/
    │   │   └── FR_AUTH_04_NN_...rst
    │   └── UC_AUTH_05_Gestionar_Sesiones/
    │       └── FR_AUTH_05_NN_...rst
    │
    ├── users/
    │   ├── index.rst
    │   ├── UC_USR_01_Crear_Usuario/
    │   │   └── FR_USR_01_NN_...rst
    │   ├── UC_USR_02_Modificar_Usuario/
    │   ├── UC_USR_03_Desactivar_Usuario/
    │   └── UC_USR_04_Listar_Usuarios/
    │
    ├── access/
    │   ├── index.rst
    │   ├── UC_ACC_01_Asignar_Rol/
    │   ├── UC_ACC_02_Revocar_Rol/
    │   ├── UC_ACC_03_Gestionar_Funciones/
    │   ├── UC_ACC_04_Gestionar_Agrupadores/
    │   ├── UC_ACC_05_Configurar_SoD/
    │   ├── UC_ACC_06_Asignar_Segmento/
    │   ├── UC_ACC_07_Consultar_Permisos_Efectivos/
    │   ├── UC_ACC_08_Gestionar_Permisos_Temporales/
    │   └── UC_ACC_09_Auditar_Cambios_Acceso/
    │
    ├── pipeline/
    │   ├── index.rst
    │   ├── UC_PIP_01_Monitorear_ETL/
    │   ├── UC_PIP_02_Consultar_Errores_ETL/
    │   ├── UC_PIP_03_Consultar_Disponibilidad/
    │   └── UC_PIP_04_Solicitar_Reproceso/
    │
    ├── reports/
    │   ├── index.rst
    │   ├── UC_RPT_01_Ver_Dashboard_Principal/
    │   ├── UC_RPT_02_Filtrar_por_Fecha/
    │   ├── UC_RPT_03_Filtrar_por_Centro/
    │   ├── UC_RPT_04_Ver_Grafico_por_Hora/
    │   ├── UC_RPT_05_Ver_Grafico_por_Dia/
    │   ├── UC_RPT_06_Ver_Distribucion_por_Centro/
    │   ├── UC_RPT_07_Generar_Reporte_Trimestral/
    │   ├── UC_RPT_08_Generar_Reporte_Problemas_Menu/
    │   ├── UC_RPT_09_Generar_Reporte_Transferencias/
    │   ├── UC_RPT_10_Exportar_CSV/
    │   ├── UC_RPT_11_Exportar_Excel/
    │   ├── UC_RPT_12_Exportar_PDF/
    │   ├── UC_RPT_13_Programar_Reporte/
    │   └── UC_RPT_14_Compartir_Dashboard/
    │
    ├── alerts/
    │   ├── index.rst
    │   ├── UC_ALR_01_Crear_Alerta/
    │   ├── UC_ALR_02_Modificar_Alerta/
    │   ├── UC_ALR_03_Eliminar_Alerta/
    │   ├── UC_ALR_04_Consultar_Historial_Alertas/
    │   └── UC_ALR_05_Gestionar_Destinatarios/
    │
    ├── audit/
    │   ├── index.rst
    │   ├── UC_AUD_01_Consultar_Auditoria/
    │   ├── UC_AUD_02_Buscar_Auditoria/
    │   ├── UC_AUD_03_Exportar_Auditoria/
    │   └── UC_AUD_04_Generar_Reporte_Compliance/
    │
    └── logs/
        ├── index.rst
        ├── UC_LOG_01_Consultar_Logs/
        ├── UC_LOG_02_Filtrar_Logs/
        ├── UC_LOG_03_Exportar_Logs/
        └── UC_LOG_04_Configurar_Retencion/
```

### 6.3 Resumen de Estructura

| Nivel | Contenido | Cantidad |
|-------|-----------|----------|
| funcionales/ | Raíz + index.rst | 1 |
| {modulo}/ | 8 carpetas de módulo + index.rst cada una | 8 |
| UC_{MOD}_{NN}_{Nombre}/ | 49 subcarpetas (una por UC) | 49 |
| FR_{MOD}_{UC}_{NN}_{Nombre}.rst | **~392 archivos individuales** | ~392 |

**Total de archivos:** ~401 (392 FR + 9 index.rst)
**Total de carpetas:** 58 (1 raíz + 8 módulos + 49 UC)

### 6.4 Metodología de Generación

Para cada UC:

1. **Leer** el UC completo (14 secciones)
2. **Crear** subcarpeta UC_{MOD}_{NN}_{Nombre}/
3. **Identificar** todos los pasos "Sistema" en flujos
4. **Extraer** validaciones de precondiciones
5. **Mapear** CNST y BR a FR específicos
6. **Crear** un archivo .rst por cada FR identificado
7. **Redactar** cada FR con formato DEBE/CUANDO
8. **Incluir** criterio de aceptación DADO/CUANDO/ENTONCES
9. **Asignar** tipo, prioridad y dependencias
10. **Validar** trazabilidad completa

---

## 7. EJEMPLO COMPLETO: FR_AUTH_01

### 7.1 UC Origen: UC_AUTH_01_Iniciar_Sesion

**Pasos del Sistema identificados:**
- Paso 2: Valida formato de campos
- Paso 3: Verifica credenciales contra BD
- Paso 4: Valida usuario activo
- Paso 5: Genera token JWT
- Paso 6: Crea registro de sesión
- Paso 7: Registra LOGIN_SUCCESS en auditoría
- Paso 8: Retorna token al frontend

### 7.2 FR Derivados

| ID | Descripción | Tipo | Paso |
|----|-------------|------|------|
| FR_AUTH_01_01 | El sistema DEBE validar que username no esté vacío | Validación | 2 |
| FR_AUTH_01_02 | El sistema DEBE validar que password tenga mínimo 8 caracteres | Validación | 2 |
| FR_AUTH_01_03 | El sistema DEBE verificar credenciales contra tabla users | Proceso | 3 |
| FR_AUTH_01_04 | El sistema DEBE verificar que is_active = true | Validación | 4 |
| FR_AUTH_01_05 | El sistema DEBE generar JWT con exp = 8 horas | Proceso | 5 |
| FR_AUTH_01_06 | El sistema DEBE crear registro en user_sessions (CNST-002) | Datos | 6 |
| FR_AUTH_01_07 | El sistema DEBE registrar LOGIN_SUCCESS en user_action_log (CNST-009) | Auditoría | 7 |
| FR_AUTH_01_08 | El sistema DEBE retornar {token, user_id, expires_at} | Interfaz | 8 |

---

# PARTE 2: DESCONGELAMIENTO DE NO_FUNCIONALES (NFR)

## 8. JUSTIFICACIÓN DEL DESCONGELAMIENTO

### 8.1 Razones

1. **Completitud**: Los NFR actuales (4) son insuficientes para el alcance del sistema
2. **Trazabilidad**: Los UC generados requieren NFR específicos para validación
3. **Métricas SLA**: CNST-007 define límites que requieren NFR formales
4. **Compliance**: Auditoría requiere NFR de seguridad y retención

### 8.2 Estado Actual

```
requisitos/no_funcionales/           # [CONGELADO] → [DESCONGELADO]
├── NFR_001_Rendimiento.rst          # Existente - Ampliar
├── NFR_002_Seguridad.rst            # Existente - Ampliar
├── NFR_003_Usabilidad.rst           # Existente - Mantener
└── NFR_004_Confiabilidad.rst        # Existente - Ampliar
```

---

## 9. NUEVO CATÁLOGO NFR PROPUESTO

### 9.1 Estructura Expandida

```
requisitos/no_funcionales/           # [DESCONGELADO]
├── index.rst
│
├── rendimiento/
│   ├── NFR_PERF_01_Tiempo_Respuesta.rst
│   ├── NFR_PERF_02_Concurrencia.rst
│   ├── NFR_PERF_03_Throughput.rst
│   └── NFR_PERF_04_Limites_Exportacion.rst      # CNST-007
│
├── seguridad/
│   ├── NFR_SEC_01_Autenticacion.rst
│   ├── NFR_SEC_02_Autorizacion_RBAC.rst         # CNST-005
│   ├── NFR_SEC_03_Cifrado.rst
│   ├── NFR_SEC_04_Sesiones.rst                  # CNST-002
│   ├── NFR_SEC_05_Auditoria.rst                 # CNST-009
│   └── NFR_SEC_06_Segregacion_Funciones.rst     # CNST-010
│
├── usabilidad/
│   ├── NFR_USA_01_Accesibilidad.rst
│   ├── NFR_USA_02_Navegacion.rst
│   └── NFR_USA_03_Feedback_Usuario.rst
│
├── confiabilidad/
│   ├── NFR_REL_01_Disponibilidad.rst
│   ├── NFR_REL_02_Recuperacion.rst
│   ├── NFR_REL_03_Tolerancia_Fallos.rst
│   └── NFR_REL_04_Backup.rst
│
├── mantenibilidad/
│   ├── NFR_MNT_01_Modularidad.rst
│   ├── NFR_MNT_02_Testeabilidad.rst
│   └── NFR_MNT_03_Documentacion.rst
│
├── portabilidad/
│   ├── NFR_POR_01_Compatibilidad_Navegadores.rst
│   └── NFR_POR_02_Containerizacion.rst          # CNST-008
│
└── cumplimiento/
    ├── NFR_CMP_01_Retencion_Datos.rst           # CNST-006
    ├── NFR_CMP_02_Proteccion_Datos.rst          # CNST-010
    └── NFR_CMP_03_Logs_Compliance.rst
```

### 9.2 Nomenclatura NFR

```
NFR_[CAT]_[NN]_[Nombre]

Categorías:
- PERF: Performance/Rendimiento
- SEC: Security/Seguridad  
- USA: Usability/Usabilidad
- REL: Reliability/Confiabilidad
- MNT: Maintainability/Mantenibilidad
- POR: Portability/Portabilidad
- CMP: Compliance/Cumplimiento
```

### 9.3 Conteo NFR

| Categoría | Cantidad | CNST Relacionado |
|-----------|----------|------------------|
| Rendimiento (PERF) | 4 | CNST-007 |
| Seguridad (SEC) | 6 | CNST-002, 005, 009, 010 |
| Usabilidad (USA) | 3 | — |
| Confiabilidad (REL) | 4 | — |
| Mantenibilidad (MNT) | 3 | — |
| Portabilidad (POR) | 2 | CNST-008 |
| Cumplimiento (CMP) | 3 | CNST-006, 010 |
| **TOTAL** | **25** | — |

---

## 10. TEMPLATE NFR

```rst
.. meta::
   :project: IACT - Call Center Analytics
   :version: 1.0.0
   :category: [Categoría]
   :cnst_relacionado: CNST-XXX

=========================================
NFR_XXX_NN: [Nombre del NFR]
=========================================

1. Identificación
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - NFR_XXX_NN
   * - **Categoría**
     - [Rendimiento|Seguridad|Usabilidad|...]
   * - **Prioridad**
     - Alta / Media / Baja
   * - **CNST Relacionado**
     - CNST-XXX (si aplica)

2. Descripción
--------------

[Descripción clara del requisito no funcional]

3. Especificación Medible
-------------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Métrica
     - Valor Objetivo
   * - [Métrica 1]
     - [Valor con unidad]
   * - [Métrica 2]
     - [Valor con unidad]

4. Criterios de Aceptación
--------------------------

- [ ] Criterio 1
- [ ] Criterio 2
- [ ] Criterio 3

5. Método de Verificación
-------------------------

[Cómo se validará este NFR: prueba de carga, revisión de código, etc.]

6. Impacto en Arquitectura
--------------------------

[Decisiones arquitectónicas afectadas]

7. Trazabilidad
---------------

- **UC Relacionados**: UC_XXX_NN, UC_YYY_MM
- **FR Relacionados**: FR_XXX_NN_01
- **CNST Origen**: CNST-XXX

8. Historial
------------

.. list-table::
   :widths: 15 15 70
   :header-rows: 1

   * - Versión
     - Fecha
     - Cambios
   * - 1.0.0
     - 2026-01-XX
     - Versión inicial
```

---

## 11. NFR PRIORITARIOS (DERIVADOS DE CNST)

### 11.1 Mapeo CNST → NFR

| CNST | NFR Derivado | Prioridad |
|------|--------------|-----------|
| CNST-002 | NFR_SEC_04_Sesiones | 🔴 Alta |
| CNST-005 | NFR_SEC_02_Autorizacion_RBAC | 🔴 Alta |
| CNST-006 | NFR_CMP_01_Retencion_Datos | 🔴 Alta |
| CNST-007 | NFR_PERF_04_Limites_Exportacion | 🔴 Alta |
| CNST-008 | NFR_POR_02_Containerizacion | 🟡 Media |
| CNST-009 | NFR_SEC_05_Auditoria | 🔴 Alta |
| CNST-010 | NFR_SEC_06_Segregacion_Funciones | 🔴 Alta |

### 11.2 Ejemplo: NFR_SEC_05_Auditoria (de CNST-009)

```
NFR_SEC_05: Auditoría Inmutable

Descripción:
El sistema DEBE mantener un log de auditoría inmutable que registre
todas las acciones de usuarios sin posibilidad de modificación o eliminación.

Métricas:
- Latencia de registro: < 100ms
- Retención: 2 años mínimo (CNST-006)
- Disponibilidad: 99.9%

Criterios:
- [ ] No existe operación UPDATE en user_action_log
- [ ] No existe operación DELETE en user_action_log
- [ ] Trigger de BD previene modificaciones
- [ ] Logs exportables para auditoría externa
```

---

## 12. ACTUALIZACIÓN MODELO DOCUMENTAL

### 12.1 Cambio de Estado

```markdown
ANTES (v2.0.8):
└── no_funcionales/                # [CONGELADO] ~20 NFR

DESPUÉS (v2.0.9):
└── no_funcionales/                # [DESCONGELADO] 25 NFR
    ├── rendimiento/               # 4 NFR
    ├── seguridad/                 # 6 NFR
    ├── usabilidad/                # 3 NFR
    ├── confiabilidad/             # 4 NFR
    ├── mantenibilidad/            # 3 NFR
    ├── portabilidad/              # 2 NFR
    └── cumplimiento/              # 3 NFR
```

### 12.2 Changelog para v2.0.9

| Versión | Cambio |
|---------|--------|
| v2.0.9 | Descongelado subdominio no_funcionales/ |
| v2.0.9 | Nueva estructura NFR con 7 categorías |
| v2.0.9 | 25 NFR identificados (vs 4 anteriores) |
| v2.0.9 | Nomenclatura NFR_[CAT]_[NN] |
| v2.0.9 | Mapeo CNST → NFR completado |

---

## 13. PLAN DE EJECUCIÓN CONSOLIDADO

### 13.1 Orden de Prioridad

| # | Actividad | Artefactos | Prioridad |
|---|-----------|------------|-----------|
| 1 | Generar FR Fase 1-3 | ~162 FR (Auth, Users, Access) | 🔴 Alta |
| 2 | Generar NFR prioritarios | 7 NFR (derivados de CNST) | 🔴 Alta |
| 3 | Generar FR Fase 4-6 | ~168 FR (Pipeline, Reports, Alerts) | 🟡 Media |
| 4 | Generar NFR restantes | 18 NFR | 🟡 Media |
| 5 | Generar FR Fase 7-8 | ~62 FR (Audit, Logs) | 🟢 Baja |
| 6 | RTM y Cobertura | Matrices de trazabilidad | 🟢 Baja |

### 13.2 Estimación de Esfuerzo

| Fase | Artefactos | Líneas Est. | Tiempo Est. |
|------|------------|-------------|-------------|
| FR Completos | 49 archivos | ~15,000 | 8-10 sesiones |
| NFR Completos | 25 archivos | ~3,000 | 2-3 sesiones |
| RTM | 2 archivos | ~1,000 | 1 sesión |
| **TOTAL** | **76 archivos** | **~19,000** | **11-14 sesiones** |

---

## 14. CRITERIOS DE ACEPTACIÓN DEL PLAN

### 14.1 Para FR

- [ ] Cada UC tiene su archivo FR correspondiente
- [ ] Cada FR tiene ID único con formato FR_MOD_UC_NN
- [ ] Cada FR tiene criterio de aceptación DADO/CUANDO/ENTONCES
- [ ] Matriz de cobertura paso-FR en cada archivo
- [ ] Trazabilidad a BR y CNST documentada

### 14.2 Para NFR

- [ ] 25 NFR documentados en 7 categorías
- [ ] Cada NFR con métricas medibles
- [ ] Mapeo CNST → NFR completo
- [ ] Método de verificación definido

### 14.3 General

- [ ] Modelo Documental actualizado a v2.0.9
- [ ] Índices actualizados
- [ ] RTM preliminar creado

---

## 15. PRÓXIMOS PASOS INMEDIATOS

1. **Aprobar** este plan
2. **Crear** estructura de directorios FR
3. **Generar** FR_AUTH_01 como piloto
4. **Validar** formato y contenido
5. **Proceder** con fases restantes

---

*Plan Maestro FR + NFR v1.0.0*  
*Proyecto: IACT Call Center Analytics Dashboard*  
*Fecha: 2026-01-07*  
*Estado: 📝 Propuesto - Pendiente Aprobación*
