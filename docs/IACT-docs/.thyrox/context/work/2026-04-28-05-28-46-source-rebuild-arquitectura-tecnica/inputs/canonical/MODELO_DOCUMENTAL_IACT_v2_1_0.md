# 📘 MODELO DOCUMENTAL IACT v2.1.0

## Sistema de Documentación Gobernado y Trazable

**Versión:** 2.1.0  
**Fecha:** 2026-01-07  
**Estado:** ✅ OFICIAL — Versión con Generación FR en Progreso  
**Autor:** Equipo IACT  
**Clasificación:** Normativo  
**Base:** v2.0.8 + Inicio Generación FR (55 FR generados)

---

# 📋 CHANGELOG DESDE v2.0.8

| Versión | Cambio |
|---------|--------|
| v2.0.8 | Consolidación final 49 UC v4.0, 147 diagramas PlantUML |
| **v2.1.0** | **🆕 Inicio generación FR - FASE 1 (MOD_Auth) completada: 21 FR** |
| **v2.1.0** | **🆕 FASE 2 (MOD_Users) completada: 17 FR** |
| **v2.1.0** | **🆕 FASE 3A-3B (MOD_Access parcial) completada: 17 FR** |
| **v2.1.0** | **🆕 Total 55 FR generados de ~400 estimados (14%)** |
| **v2.1.0** | **🆕 Formato estándar FR: 6 secciones con criterios DADO/CUANDO/ENTONCES** |

---

# 1. ESTRUCTURA COMPLETA DEL SISTEMA DOCUMENTAL

## 1.1 Fórmula del Modelo

```
5 DOMINIOS + 21 SUBDOMINIOS + 6 SUBCARPETAS ORGANIZATIVAS + 49 UC + 55 FR (en progreso)
```

## 1.2 Los 5 Dominios

| # | Dominio | Propósito | Prefijos |
|---|---------|-----------|----------|
| 1 | base_cognitiva/ | Conocimiento fundamental | META, GLOS, FND, SBVR, TXM, MTM, METH |
| 2 | requisitos/ | Especificación del sistema | BReq, BR, UC, FR, NFR |
| 3 | arquitectura_tecnica/ | Diseño e implementación | MOD, ADR, VIEW, API, CNST, FD |
| 4 | normativa/ | Estándares y políticas | STD, PROC, POL, TPL |
| 5 | evidencia/ | Verificación y trazabilidad | TST, RTM, COV |

---

# 2. LOS 8 MÓDULOS FUNCIONALES

## 2.1 Catálogo de Módulos con Casos de Uso v4.0

| Código | Prefijo UC | App Django | # UC | Líneas | Diagramas | FR Gen |
|--------|-----------|------------|------|--------|-----------|--------|
| MOD_Auth | UC_AUTH_ | apps.auth | 5 | 2,587 | 15 | 21 ✅ |
| MOD_Users | UC_USR_ | apps.users | 4 | 1,938 | 12 | 17 ✅ |
| MOD_Access | UC_ACC_ | apps.access | 9 | 4,431 | 27 | 17 🔄 |
| MOD_Pipeline | UC_PIP_ | apps.pipeline | 4 | 1,908 | 12 | 0 ⏳ |
| MOD_Reports | UC_RPT_ | apps.reports | 14 | 6,629 | 42 | 0 ⏳ |
| MOD_Alerts | UC_ALR_ | apps.alerts | 5 | 2,330 | 15 | 0 ⏳ |
| MOD_Audit | UC_AUD_ | apps.audit | 4 | 1,900 | 12 | 0 ⏳ |
| MOD_Logs | UC_LOG_ | apps.logs | 4 | 1,678 | 12 | 0 ⏳ |
| **TOTAL** | — | — | **49** | **23,401** | **147** | **55** |

## 2.2 Estructura de cada MOD_xxx.rst

```
============================
MOD_xxx - Nombre del Módulo
============================

1. Propósito
2. Responsabilidades (PUEDE hacer)
3. Límites (NO PUEDE hacer)
4. Casos de Uso Asociados
5. Restricciones Aplicables (CNST)
6. Business Rules Aplicables (BR)
7. Dependencias con otros Módulos
8. Componentes Internos (si aplica)
9. Diagrama PlantUML
```

## 2.3 SEC_RULES (Integrado en MOD_Access)

SEC_RULES NO es módulo separado. Es subcapa interna de MOD_Access:

| Componente | Visibilidad | Descripción |
|------------|-------------|-------------|
| RBAC_CORE | Usuario ve UI | Administración roles/permisos |
| SEC_RULES | Automático | Enforcement middleware/decoradores |

---

# 3. NOMENCLATURA DE CASOS DE USO v4.0

## 3.1 Formato de Identificador

```
UC_[MOD]_[NN]
```

- **UC**: Prefijo fijo indicando Use Case
- **[MOD]**: Código de módulo (AUTH, USR, ACC, PIP, RPT, ALR, AUD, LOG)
- **[NN]**: Número secuencial de dos dígitos dentro del módulo (01-99)

## 3.2 Catálogo Completo de 49 UC

### MOD_Auth (5 UC) — 21 FR Generados ✅

| ID | Nombre | Archivo | FR |
|----|--------|---------|-----|
| UC_AUTH_01 | Iniciar Sesión | UC_AUTH_01_Iniciar_Sesion.rst | 5 |
| UC_AUTH_02 | Cerrar Sesión | UC_AUTH_02_Cerrar_Sesion.rst | 3 |
| UC_AUTH_03 | Recuperar Contraseña | UC_AUTH_03_Recuperar_Contrasena.rst | 5 |
| UC_AUTH_04 | Cambiar Contraseña | UC_AUTH_04_Cambiar_Contrasena.rst | 4 |
| UC_AUTH_05 | Gestionar Sesiones | UC_AUTH_05_Gestionar_Sesiones.rst | 4 |

### MOD_Users (4 UC) — 17 FR Generados ✅

| ID | Nombre | Archivo | FR |
|----|--------|---------|-----|
| UC_USR_01 | Crear Usuario | UC_USR_01_Crear_Usuario.rst | 5 |
| UC_USR_02 | Modificar Usuario | UC_USR_02_Modificar_Usuario.rst | 4 |
| UC_USR_03 | Desactivar Usuario | UC_USR_03_Desactivar_Usuario.rst | 4 |
| UC_USR_04 | Listar Usuarios | UC_USR_04_Listar_Usuarios.rst | 4 |

### MOD_Access (9 UC) — 17 FR Generados (Parcial) 🔄

| ID | Nombre | Archivo | FR |
|----|--------|---------|-----|
| UC_ACC_01 | Asignar Rol | UC_ACC_01_Asignar_Rol.rst | 4 ✅ |
| UC_ACC_02 | Revocar Rol | UC_ACC_02_Revocar_Rol.rst | 3 ✅ |
| UC_ACC_03 | Gestionar Funciones | UC_ACC_03_Gestionar_Funciones.rst | 0 ⏳ |
| UC_ACC_04 | Gestionar Agrupadores | UC_ACC_04_Gestionar_Agrupadores.rst | 0 ⏳ |
| UC_ACC_05 | Configurar SoD | UC_ACC_05_Configurar_SoD.rst | 5 ✅ |
| UC_ACC_06 | Asignar Segmento | UC_ACC_06_Asignar_Segmento.rst | 3 ✅ |
| UC_ACC_07 | Consultar Permisos Efectivos | UC_ACC_07_Consultar_Permisos_Efectivos.rst | 0 ⏳ |
| UC_ACC_08 | Gestionar Permisos Temporales | UC_ACC_08_Gestionar_Permisos_Temporales.rst | 0 ⏳ |
| UC_ACC_09 | Auditar Cambios Acceso | UC_ACC_09_Auditar_Cambios_Acceso.rst | 2 ✅ |

### MOD_Pipeline (4 UC) — 0 FR ⏳

| ID | Nombre | Archivo |
|----|--------|---------|
| UC_PIP_01 | Monitorear ETL | UC_PIP_01_Monitorear_ETL.rst |
| UC_PIP_02 | Consultar Errores ETL | UC_PIP_02_Consultar_Errores_ETL.rst |
| UC_PIP_03 | Consultar Disponibilidad | UC_PIP_03_Consultar_Disponibilidad.rst |
| UC_PIP_04 | Solicitar Reproceso | UC_PIP_04_Solicitar_Reproceso.rst |

### MOD_Reports (14 UC) — 0 FR ⏳

| ID | Nombre | Archivo |
|----|--------|---------|
| UC_RPT_01 | Ver Dashboard Principal | UC_RPT_01_Ver_Dashboard_Principal.rst |
| UC_RPT_02 | Filtrar por Fecha | UC_RPT_02_Filtrar_por_Fecha.rst |
| UC_RPT_03 | Filtrar por Centro | UC_RPT_03_Filtrar_por_Centro.rst |
| UC_RPT_04 | Ver Gráfico por Hora | UC_RPT_04_Ver_Grafico_por_Hora.rst |
| UC_RPT_05 | Ver Gráfico por Día | UC_RPT_05_Ver_Grafico_por_Dia.rst |
| UC_RPT_06 | Ver Distribución por Centro | UC_RPT_06_Ver_Distribucion_por_Centro.rst |
| UC_RPT_07 | Generar Reporte Trimestral | UC_RPT_07_Generar_Reporte_Trimestral.rst |
| UC_RPT_08 | Generar Reporte Problemas Menú | UC_RPT_08_Generar_Reporte_Problemas_Menu.rst |
| UC_RPT_09 | Generar Reporte Transferencias | UC_RPT_09_Generar_Reporte_Transferencias.rst |
| UC_RPT_10 | Exportar CSV | UC_RPT_10_Exportar_CSV.rst |
| UC_RPT_11 | Exportar Excel | UC_RPT_11_Exportar_Excel.rst |
| UC_RPT_12 | Exportar PDF | UC_RPT_12_Exportar_PDF.rst |
| UC_RPT_13 | Programar Reporte | UC_RPT_13_Programar_Reporte.rst |
| UC_RPT_14 | Compartir Dashboard | UC_RPT_14_Compartir_Dashboard.rst |

### MOD_Alerts (5 UC) — 0 FR ⏳

| ID | Nombre | Archivo |
|----|--------|---------|
| UC_ALR_01 | Crear Alerta | UC_ALR_01_Crear_Alerta.rst |
| UC_ALR_02 | Modificar Alerta | UC_ALR_02_Modificar_Alerta.rst |
| UC_ALR_03 | Eliminar Alerta | UC_ALR_03_Eliminar_Alerta.rst |
| UC_ALR_04 | Consultar Historial Alertas | UC_ALR_04_Consultar_Historial_Alertas.rst |
| UC_ALR_05 | Gestionar Destinatarios | UC_ALR_05_Gestionar_Destinatarios.rst |

### MOD_Audit (4 UC) — 0 FR ⏳

| ID | Nombre | Archivo |
|----|--------|---------|
| UC_AUD_01 | Consultar Auditoría | UC_AUD_01_Consultar_Auditoria.rst |
| UC_AUD_02 | Buscar Auditoría | UC_AUD_02_Buscar_Auditoria.rst |
| UC_AUD_03 | Exportar Auditoría | UC_AUD_03_Exportar_Auditoria.rst |
| UC_AUD_04 | Generar Reporte Compliance | UC_AUD_04_Generar_Reporte_Compliance.rst |

### MOD_Logs (4 UC) — 0 FR ⏳

| ID | Nombre | Archivo |
|----|--------|---------|
| UC_LOG_01 | Consultar Logs | UC_LOG_01_Consultar_Logs.rst |
| UC_LOG_02 | Filtrar Logs | UC_LOG_02_Filtrar_Logs.rst |
| UC_LOG_03 | Exportar Logs | UC_LOG_03_Exportar_Logs.rst |
| UC_LOG_04 | Configurar Retención | UC_LOG_04_Configurar_Retencion.rst |

---

# 4. JERARQUÍA DE DERIVACIÓN (5 NIVELES)

## 4.1 Cadena de Requisitos

```
NIVEL 0          NIVEL 1        NIVEL 2         NIVEL 3        NIVEL 4-5
┌─────────┐     ┌─────────┐    ┌─────────┐     ┌─────────┐    ┌─────────┐
│  BReq   │────►│   BR    │───►│   UC    │────►│   FR    │───►│  CODE   │
│Objetivo │     │ Regla   │    │  Caso   │     │Funcional│    │         │
└─────────┘     └────┬────┘    └────┬────┘     └────┬────┘    └────┬────┘
                     │              │               │              │
                     │ influye      │ satisface     │              │ verifica
                     ▼              ▼               │              ▼
                ┌─────────┐    ┌─────────┐         │         ┌─────────┐
                │  CNST   │    │  CNST   │         └────────►│  TEST   │
                │Restricc.│    │aplicado │                   │         │
                └─────────┘    └─────────┘                   └─────────┘
```

## 4.2 Tipos de Enlaces

| Enlace | Semántica | Cardinalidad |
|--------|-----------|--------------|
| BReq --genera--> BR | Objetivo genera reglas | 1 : 0..* |
| BReq --genera--> UC | Objetivo genera casos de uso | 1 : 1..* |
| BR --deriva--> UC | BR Trigger genera UC completo | 0..1 : 0..1 |
| BR --influye--> UC | BR afecta sin generar | 0..* : 0..* |
| UC --deriva--> FR | Cada paso "Sistema" genera FR | 1 : 1..* |
| CNST --aplica--> UC | Restricción se aplica en UC | 1..* : 1..* |
| FR --implementa--> CODE | FR se codifica | 0..* : 0..* |
| TEST --verifica--> FR | Test valida FR | 1..* : 1..* |

## 4.3 Ratio de Derivación

```
Típico: 1 UC : 8 FR

IACT Actual:
├── BReq: 8 (documentados)
├── BR: 20 (documentadas)
├── UC: 49 (✅ COMPLETADOS v4.0)
├── FR: ~400 estimado (55 generados = 14%) [EN PROGRESO]
└── TEST: ~320 (80% cobertura FR) [PENDIENTE]
```

---

# 5. BUSINESS REQUIREMENTS (BReq)

## 5.1 Los 8 Objetivos de Negocio

| ID | Módulo | Nombre | UC Derivados |
|----|--------|--------|--------------|
| BReq_AUTH | MOD_Auth | Autenticación Segura | UC_AUTH_01-05 |
| BReq_USR | MOD_Users | Gestión de Usuarios | UC_USR_01-04 |
| BReq_ACC | MOD_Access | Control de Acceso RBAC | UC_ACC_01-09 |
| BReq_PIP | MOD_Pipeline | Pipeline de Datos | UC_PIP_01-04 |
| BReq_RPT | MOD_Reports | Reportería y Visualización | UC_RPT_01-14 |
| BReq_ALR | MOD_Alerts | Sistema de Alertas | UC_ALR_01-05 |
| BReq_AUD | MOD_Audit | Auditoría y Compliance | UC_AUD_01-04 |
| BReq_LOG | MOD_Logs | Bitácoras del Sistema | UC_LOG_01-04 |

---

# 6. TIPOS DE BUSINESS RULES

## 6.1 Los 5 Tipos (TXM_03)

| Tipo | Modalidad | ¿Genera UC? | Patrón | Ejemplo |
|------|-----------|-------------|--------|---------|
| **Hecho** | Aléctica | NO | "[X] ES/TIENE [Y]" | BR_006 RBAC Flat NIST |
| **Restricción** | Deóntica | Parcial | "[X] DEBE/NO DEBE [Y]" | BR_001 Fuente Inmutable |
| **Desencadenador** | Deóntica | **SÍ** | "SI [cond] ENTONCES [acción visible]" | BR_002 ETL Batch |
| **Inferencia** | Aléctica | NO | "SI [cond] ENTONCES [estado interno]" | BR_003 Usuario Inactivo |
| **Cálculo** | Aléctica | NO | "[Resultado] = [fórmula]" | BR_016 Tasa Abandono |

## 6.2 Las 20 BR del Sistema IACT

| BR | Nombre | Tipo | CNST Relacionado |
|----|--------|------|------------------|
| BR_001 | Fuente Inmutable | Restricción | CNST_003 |
| BR_002 | ETL Batch Nocturno | Desencadenador | CNST_004 |
| BR_003 | Usuario Inactivo 90d | Inferencia | — |
| BR_004 | Comunicaciones Internas | Restricción | CNST_001 |
| BR_005 | Sesión Única | Restricción | CNST_002 |
| BR_006 | RBAC Flat NIST | Hecho | CNST_005 |
| BR_007 | Separación Funciones SoD | Restricción | CNST_005 |
| BR_008 | Permisos con Vencimiento | Restricción | CNST_005 |
| BR_009 | Bajas Lógicas | Restricción | CNST_005 |
| BR_010 | Auditoría Inmutable | Restricción | CNST_009 |
| BR_011 | Límites Exportación | Restricción | CNST_007 |
| BR_012 | Usuario-Segmento Único | Hecho | — |
| BR_013 | Username Único | Hecho | — |
| BR_014 | Alerta por Umbral | Desencadenador | — |
| BR_015 | Bloqueo Intentos Fallidos | Desencadenador | CNST_005 |
| BR_016 | Tasa Abandono | Cálculo | — |
| BR_017 | Tiempo Promedio Espera | Cálculo | — |
| BR_018 | Índice Eficiencia | Cálculo | — |
| BR_019 | Retención 2 Años | Restricción | CNST_006 |
| BR_020 | Clasificación Datos | Restricción | CNST_010 |

---

# 7. RESTRICCIONES ARQUITECTÓNICAS (CNST)

## 7.1 Las 10 Restricciones

| CNST | Nombre | Impacto en UC |
|------|--------|---------------|
| CNST-001 | Comunicaciones Prohibidas | Sin email/SMS, solo in-app |
| CNST-002 | Gestión Sesiones BD | Sesiones en PostgreSQL |
| CNST-003 | BD Dual Inmutable | MySQL readonly, PG transaccional |
| CNST-004 | Actualización ETL | Solo batch nocturno 2:00 AM |
| CNST-005 | Seguridad DRF | RBAC, SoD, permisos temporales |
| CNST-006 | Retención Datos | 2 años máximo |
| CNST-007 | Límites Exportación | 100,000 registros máx |
| CNST-008 | Infraestructura | Docker, Nginx, Gunicorn |
| CNST-009 | Auditoría Inmutable | user_action_log sin UPDATE/DELETE |
| CNST-010 | Segregación Funciones | 3 reglas SoD obligatorias |

## 7.2 Aplicación de CNST en UC Generados

| CNST | UC que lo aplican |
|------|-------------------|
| CNST-001 | UC_ALR_* (todos), UC_USR_* |
| CNST-003 | UC_RPT_* (todos), UC_PIP_* |
| CNST-004 | UC_PIP_01, UC_PIP_04 |
| CNST-005 | UC_ACC_* (todos), UC_AUTH_* |
| CNST-006 | UC_RPT_*, UC_AUD_*, UC_LOG_* |
| CNST-007 | UC_RPT_10-12, UC_AUD_03, UC_LOG_03 |
| CNST-009 | UC_AUD_* (todos) |
| CNST-010 | UC_ACC_05, UC_AUD_* |

---

# 8. MODELO RBAC v5.1.1 INTEGRADO

## 8.1 Estructura del Modelo

```
┌─────────────────────────────────────────────────────────────┐
│                    MODELO RBAC IACT v5.1.1                  │
├─────────────────────────────────────────────────────────────┤
│  10 AGRUPADORES (AGR-001 a AGR-010)                        │
│  44 FUNCIONES ATÓMICAS                                      │
│  3 REGLAS SoD                                               │
│  Permisos Temporales con Vencimiento                        │
└─────────────────────────────────────────────────────────────┘
```

## 8.2 Los 10 Agrupadores

| ID | Código | Descripción | # Funciones |
|----|--------|-------------|-------------|
| AGR-001 | agr_superadmin | Acceso total al sistema | 44 |
| AGR-002 | agr_admin_usuarios | Gestión de usuarios | 8 |
| AGR-003 | agr_admin_roles | Gestión de roles/permisos | 6 |
| AGR-004 | agr_operador_etl | Supervisión ETL | 4 |
| AGR-005 | agr_analista | Visualización y reportes | 12 |
| AGR-006 | agr_auditor | Auditoría y compliance | 4 |
| AGR-007 | agr_supervisor | Alertas y monitoreo | 5 |
| AGR-008 | agr_exportador | Exportación de datos | 3 |
| AGR-009 | agr_viewer | Solo lectura básica | 3 |
| AGR-010 | agr_soporte | Soporte técnico (logs) | 4 |

## 8.3 Reglas de Segregación de Funciones (SoD)

| Regla | Conflicto | Descripción |
|-------|-----------|-------------|
| SoD-001 | agr_admin_usuarios ↔ agr_auditor | Admin no puede auditar sus propios cambios |
| SoD-002 | agr_admin_roles ↔ agr_auditor | Quien asigna roles no audita |
| SoD-003 | agr_operador_etl ↔ agr_analista | Quien carga datos no los analiza |

---

# 9. REQUISITOS FUNCIONALES (FR) — EN PROGRESO

## 9.1 Nomenclatura FR

```
FR_[UC_ID]_[NN]
```

Ejemplos:
- `FR_UCAUTH_01_01` — Primer FR del UC_AUTH_01
- `FR_UCUSR_02_03` — Tercer FR del UC_USR_02
- `FR_UCACC_05_02` — Segundo FR del UC_ACC_05

## 9.2 Estado de Generación FR

| Fase | Módulo | UC | FR Est. | FR Gen. | Estado |
|------|--------|-----|---------|---------|--------|
| FASE 1 | MOD_Auth | 5 | 40 | 21 | ✅ COMPLETA |
| FASE 2 | MOD_Users | 4 | 32 | 17 | ✅ COMPLETA |
| FASE 3 | MOD_Access | 9 | 72 | 17 | 🔄 PARCIAL |
| FASE 4 | MOD_Pipeline | 4 | 32 | 0 | ⏳ PENDIENTE |
| FASE 5 | MOD_Reports | 14 | 112 | 0 | ⏳ PENDIENTE |
| FASE 6 | MOD_Alerts | 5 | 40 | 0 | ⏳ PENDIENTE |
| FASE 7 | MOD_Audit | 4 | 32 | 0 | ⏳ PENDIENTE |
| FASE 8 | MOD_Logs | 4 | 32 | 0 | ⏳ PENDIENTE |
| **TOTAL** | — | **49** | **~392** | **55** | **14%** |

## 9.3 FR Generados por UC

### FASE 1: MOD_Auth (21 FR) ✅

**UC_AUTH_01: Iniciar Sesión (5 FR)**

| ID | Nombre | Tipo |
|----|--------|------|
| FR_UCAUTH_01_01 | Validar formato username | Validación |
| FR_UCAUTH_01_02 | Validar credenciales contra BD | Validación |
| FR_UCAUTH_01_03 | Generar token JWT | Proceso |
| FR_UCAUTH_01_04 | Invalidar sesiones previas | Proceso |
| FR_UCAUTH_01_05 | Registrar evento en auditoría | Auditoría |

**UC_AUTH_02: Cerrar Sesión (3 FR)**

| ID | Nombre | Tipo |
|----|--------|------|
| FR_UCAUTH_02_01 | Invalidar token JWT actual | Proceso |
| FR_UCAUTH_02_02 | Registrar evento logout | Auditoría |
| FR_UCAUTH_02_03 | Limpiar datos sesión cliente | Interfaz |

**UC_AUTH_03: Recuperar Contraseña (5 FR)**

| ID | Nombre | Tipo |
|----|--------|------|
| FR_UCAUTH_03_01 | Validar username existe | Validación |
| FR_UCAUTH_03_02 | Mostrar pregunta de seguridad | Interfaz |
| FR_UCAUTH_03_03 | Validar respuesta seguridad | Validación |
| FR_UCAUTH_03_04 | Generar contraseña temporal | Proceso |
| FR_UCAUTH_03_05 | Forzar cambio en siguiente login | Proceso |

**UC_AUTH_04: Cambiar Contraseña (4 FR)**

| ID | Nombre | Tipo |
|----|--------|------|
| FR_UCAUTH_04_01 | Validar contraseña actual | Validación |
| FR_UCAUTH_04_02 | Validar complejidad nueva contraseña | Validación |
| FR_UCAUTH_04_03 | Actualizar hash en BD | Datos |
| FR_UCAUTH_04_04 | Invalidar todas las sesiones | Proceso |

**UC_AUTH_05: Gestionar Sesiones (4 FR)**

| ID | Nombre | Tipo |
|----|--------|------|
| FR_UCAUTH_05_01 | Listar sesiones activas del usuario | Proceso |
| FR_UCAUTH_05_02 | Mostrar detalle de sesión | Interfaz |
| FR_UCAUTH_05_03 | Invalidar sesión individual | Proceso |
| FR_UCAUTH_05_04 | Invalidar todas las sesiones de usuario | Proceso |

### FASE 2: MOD_Users (17 FR) ✅

**UC_USR_01: Crear Usuario (5 FR)**

| ID | Nombre | Tipo |
|----|--------|------|
| FR_UCUSR_01_01 | Validar campos obligatorios | Validación |
| FR_UCUSR_01_02 | Verificar unicidad de username | Validación |
| FR_UCUSR_01_03 | Generar contraseña temporal | Proceso |
| FR_UCUSR_01_04 | Crear registro de usuario | Datos |
| FR_UCUSR_01_05 | Registrar creación en auditoría | Auditoría |

**UC_USR_02: Modificar Usuario (4 FR)**

| ID | Nombre | Tipo |
|----|--------|------|
| FR_UCUSR_02_01 | Cargar datos actuales del usuario | Proceso |
| FR_UCUSR_02_02 | Validar campos modificados | Validación |
| FR_UCUSR_02_03 | Actualizar registro en BD | Datos |
| FR_UCUSR_02_04 | Registrar cambios en auditoría | Auditoría |

**UC_USR_03: Desactivar Usuario (4 FR)**

| ID | Nombre | Tipo |
|----|--------|------|
| FR_UCUSR_03_01 | Validar que usuario está activo | Validación |
| FR_UCUSR_03_02 | Cambiar estado a INACTIVO | Datos |
| FR_UCUSR_03_03 | Invalidar sesiones activas | Proceso |
| FR_UCUSR_03_04 | Preservar registro para histórico | Auditoría |

**UC_USR_04: Listar Usuarios (4 FR)**

| ID | Nombre | Tipo |
|----|--------|------|
| FR_UCUSR_04_01 | Obtener lista paginada de usuarios | Proceso |
| FR_UCUSR_04_02 | Aplicar filtros de búsqueda | Interfaz |
| FR_UCUSR_04_03 | Ordenar resultados por columna | Interfaz |
| FR_UCUSR_04_04 | Mostrar indicador de estado | Interfaz |

### FASE 3: MOD_Access (17 FR de ~72) 🔄

**UC_ACC_01: Asignar Rol (4 FR)**

| ID | Nombre | Tipo |
|----|--------|------|
| FR_UCACC_01_01 | Listar funciones disponibles | Proceso |
| FR_UCACC_01_02 | Validar SoD antes de asignar | Validación |
| FR_UCACC_01_03 | Crear asignación usuario-función | Datos |
| FR_UCACC_01_04 | Calcular permisos efectivos | Proceso |

**UC_ACC_02: Revocar Rol (3 FR)**

| ID | Nombre | Tipo |
|----|--------|------|
| FR_UCACC_02_01 | Listar funciones asignadas | Proceso |
| FR_UCACC_02_02 | Eliminar asignación | Datos |
| FR_UCACC_02_03 | Recalcular permisos efectivos | Proceso |

**UC_ACC_05: Configurar SoD (5 FR)**

| ID | Nombre | Tipo |
|----|--------|------|
| FR_UCACC_05_01 | Crear restricción SoD | Datos |
| FR_UCACC_05_02 | Validar conflictos existentes | Validación |
| FR_UCACC_05_03 | Listar restricciones vigentes | Proceso |
| FR_UCACC_05_04 | Modificar restricción | Datos |
| FR_UCACC_05_05 | Eliminar restricción | Datos |

**UC_ACC_06: Asignar Segmento (3 FR)**

| ID | Nombre | Tipo |
|----|--------|------|
| FR_UCACC_06_01 | Listar centros disponibles | Proceso |
| FR_UCACC_06_02 | Asignar centro a usuario | Datos |
| FR_UCACC_06_03 | Aplicar filtro en consultas | Proceso |

**UC_ACC_09: Auditar Cambios Acceso (2 FR)**

| ID | Nombre | Tipo |
|----|--------|------|
| FR_UCACC_09_01 | Validar mínimo un segmento | Validación |
| FR_UCACC_09_02 | Eliminar asignación de segmento | Datos |

## 9.4 Formato Estándar de FR

Cada FR sigue esta estructura de 6 secciones:

```rst
=======================================
FR_UCXXX_NN_NN: Nombre del Requisito
=======================================

1. Identificación
-----------------
- ID, Nombre, UC Origen, Paso UC, Módulo, Prioridad, Tipo

2. Especificación
-----------------
- Declaración DEBE/CUANDO
- Descripción detallada

3. Criterio de Aceptación
-------------------------
- DADO [contexto]
- CUANDO [acción]
- ENTONCES [resultado esperado]

4. Reglas y Restricciones
-------------------------
- BR aplicables
- CNST aplicables

5. Trazabilidad
---------------
- BReq, UC, Dependencias, CNST, TEST

6. Historial
------------
- Versión, Fecha, Cambios
```

---

# 10. ESTRUCTURA DE CADA UC v4.0

## 10.1 Las 14 Secciones Obligatorias

Cada uno de los 49 UC generados contiene exactamente estas 14 secciones:

| # | Sección | Contenido |
|---|---------|-----------|
| 1 | Resumen | Tabla con ID, nombre, actor, módulo, función RBAC, prioridad |
| 2 | Descripción | Propósito y características principales |
| 3 | Diagrama de Caso de Uso | PlantUML actor-usecase |
| 4 | Contexto de Ejecución | Precondiciones, trigger, postcondiciones |
| 5 | Flujo Normal | Pasos del camino feliz |
| 6 | Diagrama de Secuencia | PlantUML secuencia completa |
| 7 | Flujos Alternos | Variaciones del flujo normal |
| 8 | Excepciones | Errores y manejo |
| 9 | Diagrama de Actividad | PlantUML actividad |
| 10 | Reglas de Negocio | BR aplicables |
| 11 | Restricciones de Arquitectura | CNST aplicables |
| 12 | Requisitos Funcionales Derivados | FR generados |
| 13 | Trazabilidad | Enlaces a BReq, BR, CNST, otros UC |
| 14 | Historial de Cambios | Versionado |

## 10.2 Los 3 Diagramas PlantUML por UC

| Diagrama | Propósito | Elementos |
|----------|-----------|-----------|
| **Caso de Uso** | Actores y relaciones | Actor, UC principal, include/extend |
| **Secuencia** | Interacción temporal | Frontend, Controller, Service, DB |
| **Actividad** | Flujo de decisiones | Start, decisiones, acciones, stop |

---

# 11. ÁRBOL COMPLETO v2.1.0

```
IACT/
│
├── conf.py
├── index.rst
├── Makefile
├── requirements.txt
│
│ ═══════════════════════════════════════════════════════════════════
│ DOMINIO 1: BASE COGNITIVA
│ ═══════════════════════════════════════════════════════════════════
│
├── base_cognitiva/
│   ├── index.rst
│   ├── _metadata/                               # [PRIVADO]
│   │   ├── META_01_Identidad_Proyecto.rst
│   │   ├── META_02_Clasificacion_Documental.rst
│   │   ├── META_03_Fases_SDLC.rst
│   │   ├── META_04_Contexto_IACT.rst
│   │   └── META_05_Estructura_Documental.rst
│   │
│   ├── glosario/                                # [CONGELADO]
│   │   └── GLOS_001_Glosario_IACT.rst
│   │
│   ├── _fundamentos_conceptuales/               # [PRIVADO]
│   │   ├── FND_01_Concepto_Requisito.rst
│   │   ├── FND_02_Reglas_de_Negocio.rst
│   │   ├── FND_03_Casos_de_Uso.rst              # v1.3.0
│   │   ├── FND_04_Trazabilidad.rst
│   │   ├── FND_05_Jerarquia_5_Niveles.rst
│   │   ├── FND_06_Derivacion_vs_Transformacion.rst
│   │   └── FND_07_Requerimientos_Funcionales.rst
│   │
│   ├── _ontologia_sbvr/                         # [PRIVADO]
│   │   ├── SBVR_01_Conceptos_Nucleares.rst
│   │   ├── SBVR_02_Fact_Types.rst
│   │   ├── SBVR_03_Reglas_Estructurales.rst
│   │   ├── SBVR_04_Reglas_Operativas.rst
│   │   └── SBVR_05_Vocabulario_Controlado.rst
│   │
│   ├── _taxonomias_y_metamodelos/               # [PRIVADO]
│   │   ├── taxonomias/
│   │   │   ├── TXM_01_Taxonomia_Requisitos.rst
│   │   │   ├── TXM_02_Taxonomia_Artefactos.rst
│   │   │   └── TXM_03_Taxonomia_Reglas_Negocio.rst
│   │   └── metamodelos/
│   │       ├── MTM_01_Metamodelo_Requisitos.rst
│   │       ├── MTM_02_Metamodelo_Trazabilidad.rst
│   │       └── MTM_03_Metamodelo_RBAC.rst
│   │
│   └── _metodologias_analiticas/                # [PRIVADO]
│       ├── METH_01_Derivacion_UC_desde_BR.rst
│       ├── METH_02_Derivacion_FR_desde_UC.rst
│       └── METH_03_Tecnicas_Larman.rst
│
│
│ ═══════════════════════════════════════════════════════════════════
│ DOMINIO 2: REQUISITOS
│ ═══════════════════════════════════════════════════════════════════
│
├── requisitos/
│   ├── index.rst
│   │
│   ├── objetivos_negocio/                       # [DESCONGELADO] 8 BReq
│   │   ├── index.rst
│   │   ├── BReq_AUTH_Autenticacion.rst
│   │   ├── BReq_USR_Gestion_Usuarios.rst
│   │   ├── BReq_ACC_Control_Acceso.rst
│   │   ├── BReq_PIP_Pipeline_Datos.rst
│   │   ├── BReq_RPT_Reporteria.rst
│   │   ├── BReq_ALR_Alertas.rst
│   │   ├── BReq_AUD_Auditoria.rst
│   │   └── BReq_LOG_Bitacoras.rst
│   │
│   ├── reglas_negocio/                          # [CONGELADO] 20 BR
│   │   ├── index.rst
│   │   ├── BR_001_Fuente_Inmutable.rst
│   │   ├── BR_002_ETL_Batch_Nocturno.rst
│   │   ├── ... (BR_003 a BR_019)
│   │   └── BR_020_Clasificacion_Datos.rst
│   │
│   ├── casos_uso/                               # [CONGELADO] 49 UC v4.0
│   │   ├── index.rst
│   │   ├── _actores.rst
│   │   ├── _glosario_uc.rst
│   │   ├── _restricciones_aplicables.rst
│   │   ├── _plantilla_uc.rst
│   │   ├── _estilos_plantuml.iuml
│   │   │
│   │   ├── auth/                                # MOD_Auth: 5 UC
│   │   │   ├── index.rst
│   │   │   ├── UC_AUTH_01_Iniciar_Sesion.rst
│   │   │   ├── UC_AUTH_02_Cerrar_Sesion.rst
│   │   │   ├── UC_AUTH_03_Recuperar_Contrasena.rst
│   │   │   ├── UC_AUTH_04_Cambiar_Contrasena.rst
│   │   │   └── UC_AUTH_05_Gestionar_Sesiones.rst
│   │   │
│   │   ├── users/                               # MOD_Users: 4 UC
│   │   │   ├── index.rst
│   │   │   ├── UC_USR_01_Crear_Usuario.rst
│   │   │   ├── UC_USR_02_Modificar_Usuario.rst
│   │   │   ├── UC_USR_03_Desactivar_Usuario.rst
│   │   │   └── UC_USR_04_Listar_Usuarios.rst
│   │   │
│   │   ├── access/                              # MOD_Access: 9 UC
│   │   │   ├── index.rst
│   │   │   ├── UC_ACC_01_Asignar_Rol.rst
│   │   │   ├── UC_ACC_02_Revocar_Rol.rst
│   │   │   ├── UC_ACC_03_Gestionar_Funciones.rst
│   │   │   ├── UC_ACC_04_Gestionar_Agrupadores.rst
│   │   │   ├── UC_ACC_05_Configurar_SoD.rst
│   │   │   ├── UC_ACC_06_Asignar_Segmento.rst
│   │   │   ├── UC_ACC_07_Consultar_Permisos_Efectivos.rst
│   │   │   ├── UC_ACC_08_Gestionar_Permisos_Temporales.rst
│   │   │   └── UC_ACC_09_Auditar_Cambios_Acceso.rst
│   │   │
│   │   ├── pipeline/                            # MOD_Pipeline: 4 UC
│   │   │   ├── index.rst
│   │   │   ├── UC_PIP_01_Monitorear_ETL.rst
│   │   │   ├── UC_PIP_02_Consultar_Errores_ETL.rst
│   │   │   ├── UC_PIP_03_Consultar_Disponibilidad.rst
│   │   │   └── UC_PIP_04_Solicitar_Reproceso.rst
│   │   │
│   │   ├── reports/                             # MOD_Reports: 14 UC
│   │   │   ├── index.rst
│   │   │   ├── UC_RPT_01_Ver_Dashboard_Principal.rst
│   │   │   ├── UC_RPT_02_Filtrar_por_Fecha.rst
│   │   │   ├── UC_RPT_03_Filtrar_por_Centro.rst
│   │   │   ├── UC_RPT_04_Ver_Grafico_por_Hora.rst
│   │   │   ├── UC_RPT_05_Ver_Grafico_por_Dia.rst
│   │   │   ├── UC_RPT_06_Ver_Distribucion_por_Centro.rst
│   │   │   ├── UC_RPT_07_Generar_Reporte_Trimestral.rst
│   │   │   ├── UC_RPT_08_Generar_Reporte_Problemas_Menu.rst
│   │   │   ├── UC_RPT_09_Generar_Reporte_Transferencias.rst
│   │   │   ├── UC_RPT_10_Exportar_CSV.rst
│   │   │   ├── UC_RPT_11_Exportar_Excel.rst
│   │   │   ├── UC_RPT_12_Exportar_PDF.rst
│   │   │   ├── UC_RPT_13_Programar_Reporte.rst
│   │   │   └── UC_RPT_14_Compartir_Dashboard.rst
│   │   │
│   │   ├── alerts/                              # MOD_Alerts: 5 UC
│   │   │   ├── index.rst
│   │   │   ├── UC_ALR_01_Crear_Alerta.rst
│   │   │   ├── UC_ALR_02_Modificar_Alerta.rst
│   │   │   ├── UC_ALR_03_Eliminar_Alerta.rst
│   │   │   ├── UC_ALR_04_Consultar_Historial_Alertas.rst
│   │   │   └── UC_ALR_05_Gestionar_Destinatarios.rst
│   │   │
│   │   ├── audit/                               # MOD_Audit: 4 UC
│   │   │   ├── index.rst
│   │   │   ├── UC_AUD_01_Consultar_Auditoria.rst
│   │   │   ├── UC_AUD_02_Buscar_Auditoria.rst
│   │   │   ├── UC_AUD_03_Exportar_Auditoria.rst
│   │   │   └── UC_AUD_04_Generar_Reporte_Compliance.rst
│   │   │
│   │   └── logs/                                # MOD_Logs: 4 UC
│   │       ├── index.rst
│   │       ├── UC_LOG_01_Consultar_Logs.rst
│   │       ├── UC_LOG_02_Filtrar_Logs.rst
│   │       ├── UC_LOG_03_Exportar_Logs.rst
│   │       └── UC_LOG_04_Configurar_Retencion.rst
│   │
│   ├── funcionales/                             # 🆕 [EN PROGRESO] 55/~400 FR
│   │   ├── index.rst
│   │   ├── auth/                                # 21 FR ✅
│   │   │   ├── FR_UCAUTH_01_01.rst ... FR_UCAUTH_01_05.rst
│   │   │   ├── FR_UCAUTH_02_01.rst ... FR_UCAUTH_02_03.rst
│   │   │   ├── FR_UCAUTH_03_01.rst ... FR_UCAUTH_03_05.rst
│   │   │   ├── FR_UCAUTH_04_01.rst ... FR_UCAUTH_04_04.rst
│   │   │   └── FR_UCAUTH_05_01.rst ... FR_UCAUTH_05_04.rst
│   │   ├── users/                               # 17 FR ✅
│   │   │   ├── FR_UCUSR_01_01.rst ... FR_UCUSR_01_05.rst
│   │   │   ├── FR_UCUSR_02_01.rst ... FR_UCUSR_02_04.rst
│   │   │   ├── FR_UCUSR_03_01.rst ... FR_UCUSR_03_04.rst
│   │   │   └── FR_UCUSR_04_01.rst ... FR_UCUSR_04_04.rst
│   │   ├── access/                              # 17 FR 🔄
│   │   ├── pipeline/                            # 0 FR ⏳
│   │   ├── reports/                             # 0 FR ⏳
│   │   ├── alerts/                              # 0 FR ⏳
│   │   ├── audit/                               # 0 FR ⏳
│   │   └── logs/                                # 0 FR ⏳
│   │
│   └── no_funcionales/                          # [CONGELADO] ~20 NFR
│       ├── index.rst
│       ├── NFR_001_Rendimiento.rst
│       ├── NFR_002_Seguridad.rst
│       ├── NFR_003_Usabilidad.rst
│       └── NFR_004_Confiabilidad.rst
│
│
│ ═══════════════════════════════════════════════════════════════════
│ DOMINIO 3: ARQUITECTURA TÉCNICA
│ ═══════════════════════════════════════════════════════════════════
│
├── arquitectura_tecnica/
│   ├── index.rst
│   │
│   ├── modulos/                                 # [CONGELADO] 8 MOD_
│   │   ├── index.rst
│   │   ├── MOD_Auth.rst
│   │   ├── MOD_Users.rst
│   │   ├── MOD_Access.rst                       # Incluye SEC_RULES
│   │   ├── MOD_Pipeline.rst
│   │   ├── MOD_Reports.rst
│   │   ├── MOD_Alerts.rst
│   │   ├── MOD_Audit.rst
│   │   └── MOD_Logs.rst
│   │
│   ├── restricciones/                           # [CONGELADO] 10 CNST
│   │   ├── index.rst
│   │   ├── CNST_001_Comunicaciones_Prohibidas.rst
│   │   ├── CNST_002_Gestion_Sesiones_BD.rst
│   │   ├── CNST_003_Base_Datos_Dual_Inmutable.rst
│   │   ├── CNST_004_Actualizacion_Datos_ETL.rst
│   │   ├── CNST_005_Seguridad_DRF_Checklist.rst
│   │   ├── CNST_006_Retencion_Datos.rst
│   │   ├── CNST_007_Limites_Exportacion.rst
│   │   ├── CNST_008_Infraestructura_Deployment.rst
│   │   ├── CNST_009_Logging_Auditoria_Inmutable.rst
│   │   └── CNST_010_Clasificacion_Proteccion_Datos.rst
│   │
│   ├── decisiones/                              # [DESCONGELADO] ADR
│   │   ├── index.rst
│   │   ├── ADR_001_Stack_Django_DRF.rst
│   │   ├── ADR_002_BD_Dual_MySQL_PG.rst
│   │   ├── ADR_003_RBAC_Flat_vs_Hierarchical.rst
│   │   ├── ADR_004_8_Modulos_SEC_RULES_Integrado.rst
│   │   └── ADR_005_UML_PlantUML.rst
│   │
│   ├── vistas/                                  # [DESCONGELADO]
│   │   ├── index.rst
│   │   ├── VIEW_001_Componentes.rst
│   │   ├── VIEW_002_Deployment.rst
│   │   ├── VIEW_003_Secuencia_ETL.rst
│   │   ├── VIEW_004_Dependencias_Modulos.rst
│   │   └── VIEW_005_Modelo_RBAC.rst
│   │
│   ├── flujos_datos/                            # [DESCONGELADO] 12 FD_
│   │   ├── index.rst
│   │   ├── FD_01_Autenticacion.rst
│   │   ├── FD_02_Resolucion_Permisos.rst
│   │   ├── FD_03_Gestion_Identidades.rst
│   │   ├── FD_04_Ejecucion_ETL.rst
│   │   ├── FD_05_Supervision_ETL.rst
│   │   ├── FD_06_Visualizacion.rst
│   │   ├── FD_07_Exportacion.rst
│   │   ├── FD_08_Alertas.rst
│   │   ├── FD_09_Auditoria.rst
│   │   ├── FD_10_Bitacoras.rst
│   │   ├── FD_11_Enforcement_SEC_RULES.rst
│   │   └── FD_12_Mensajeria_Interna.rst
│   │
│   ├── apis/                                    # [DESCONGELADO]
│   │   ├── index.rst
│   │   ├── API_Auth.rst
│   │   ├── API_Users.rst
│   │   ├── API_Access.rst
│   │   ├── API_Pipeline.rst
│   │   ├── API_Reports.rst
│   │   ├── API_Alerts.rst
│   │   ├── API_Audit.rst
│   │   └── API_Logs.rst
│   │
│   └── modelos_datos/                           # [DESCONGELADO]
│       ├── index.rst
│       ├── MDL_001_Conceptual.rst
│       ├── MDL_002_Logico.rst
│       └── MDL_003_Fisico.rst
│
│
│ ═══════════════════════════════════════════════════════════════════
│ DOMINIO 4: NORMATIVA
│ ═══════════════════════════════════════════════════════════════════
│
├── normativa/
│   ├── index.rst
│   │
│   ├── estandares/                              # [DESCONGELADO]
│   │   ├── index.rst
│   │   ├── STD_001_Suite_Calidad_Codigo.rst
│   │   ├── STD_002_Metodologia_SBVR_UML_Larman.rst
│   │   ├── STD_003_Clean_Code_Naming.rst
│   │   ├── STD_004_Nomenclatura_Proyecto.rst
│   │   ├── STD_005_Estilo_Documentacion_Sphinx.rst
│   │   └── plantillas/
│   │       ├── TPL_001_Plantilla_BR.rst
│   │       ├── TPL_002_Plantilla_UC.rst
│   │       ├── TPL_003_Plantilla_FR.rst
│   │       ├── TPL_004_Plantilla_ADR.rst
│   │       ├── TPL_005_Plantilla_CNST.rst
│   │       └── TPL_006_Plantilla_MOD.rst
│   │
│   ├── procedimientos/                          # [CONGELADO]
│   │   ├── index.rst
│   │   ├── PROC_001_Cambio_Requisitos.rst
│   │   ├── PROC_002_Revision_Artefactos.rst
│   │   └── PROC_003_Aprobacion_Documentos.rst
│   │
│   └── politicas/                               # [CONGELADO]
│       ├── index.rst
│       ├── POL_001_Seguridad_Informacion.rst
│       └── POL_002_Control_Acceso.rst
│
│
│ ═══════════════════════════════════════════════════════════════════
│ DOMINIO 5: EVIDENCIA
│ ═══════════════════════════════════════════════════════════════════
│
└── evidencia/
    ├── index.rst
    │
    ├── pruebas/                                 # [DESCONGELADO]
    │   ├── index.rst
    │   ├── auth/
    │   │   └── TST_Auth_Plan.rst
    │   ├── users/
    │   ├── access/
    │   ├── pipeline/
    │   ├── reports/
    │   ├── alerts/
    │   ├── audit/
    │   └── logs/
    │
    └── trazabilidad/                            # [CONGELADO]
        ├── index.rst
        ├── RTM_Master_v1_0_0.rst
        └── COV_001_Reporte_Cobertura.rst
```

---

# 12. MÉTRICAS DE COBERTURA

## 12.1 Estado Actual del Proyecto

| Métrica | Valor | Estado |
|---------|-------|--------|
| BReq documentados | 8 | ✅ Completados |
| BR documentadas | 20 | ✅ Completados |
| UC generados | 49 | ✅ Completados v4.0 |
| Líneas UC | 23,401 | ✅ |
| Diagramas PlantUML | 147 | ✅ |
| FR generados | 55 | 🔄 14% (~392 total) |
| TST creados | 0 | ⏳ Pendiente |

## 12.2 Umbrales de Cobertura

| Cobertura | Umbral | Actual | Estado |
|-----------|--------|--------|--------|
| BReq → UC | 100% | 100% | ✅ |
| BR → UC | 100% | 100% | ✅ |
| CNST → UC | 100% | 100% | ✅ |
| UC → FR | 100% | 14% | 🔄 |
| FR → CODE | 90% | 0% | ⏳ |
| FR → TEST | 80% | 0% | ⏳ |

## 12.3 Progreso de Generación FR

```
GENERACIÓN FR: ██░░░░░░░░░░░░░░░░░░░░░░░░ 14% (55/~392)

MOD_Auth:    ████████████████████ 100% (21/~40)  ✅
MOD_Users:   ████████████████████ 100% (17/~32)  ✅
MOD_Access:  █████░░░░░░░░░░░░░░░  24% (17/~72)  🔄
MOD_Pipeline:░░░░░░░░░░░░░░░░░░░░   0% (0/~32)   ⏳
MOD_Reports: ░░░░░░░░░░░░░░░░░░░░   0% (0/~112)  ⏳
MOD_Alerts:  ░░░░░░░░░░░░░░░░░░░░   0% (0/~40)   ⏳
MOD_Audit:   ░░░░░░░░░░░░░░░░░░░░   0% (0/~32)   ⏳
MOD_Logs:    ░░░░░░░░░░░░░░░░░░░░   0% (0/~32)   ⏳
```

---

# 13. CATÁLOGO DE PREFIJOS

## 13.1 Por Dominio

| Dominio | Prefijos | Cantidad Est. |
|---------|----------|---------------|
| base_cognitiva | META, GLOS, FND, SBVR, TXM, MTM, METH | ~25 |
| requisitos | BReq, BR, UC, FR, NFR | ~470 |
| arquitectura_tecnica | MOD, CNST, ADR, VIEW, FD, API, MDL | ~45 |
| normativa | STD, PROC, POL, TPL | ~15 |
| evidencia | TST, RTM, COV | ~12 |
| **TOTAL** | — | **~567** |

## 13.2 Nomenclatura de Archivos

```
Casos de Uso v4.0:
UC_[MOD]_[NN]_[Nombre_Descriptivo].rst

Requisitos Funcionales:
FR_UC[MOD]_[NN]_[NN].rst

Ejemplos:
- UC_AUTH_01_Iniciar_Sesion.rst
- UC_RPT_07_Generar_Reporte_Trimestral.rst
- FR_UCAUTH_01_01_Validar_Username.rst
- FR_UCUSR_02_03_Actualizar_Registro.rst
```

---

# 14. ORDEN DE EJECUCIÓN SIGUIENTE

## Fase Actual: GENERACIÓN FR 🔄

```
Completado:
├── FASE 1: MOD_Auth (21 FR) ✅
├── FASE 2: MOD_Users (17 FR) ✅
└── FASE 3: MOD_Access (17 FR parcial) 🔄

Siguiente:
├── FASE 3 (continuar): MOD_Access (~55 FR restantes)
├── FASE 4: MOD_Pipeline (~32 FR)
├── FASE 5: MOD_Reports (~112 FR)
├── FASE 6: MOD_Alerts (~40 FR)
├── FASE 7: MOD_Audit (~32 FR)
└── FASE 8: MOD_Logs (~32 FR)
```

## Fases Posteriores

1. **RTM (Matriz de Trazabilidad)**
   - RTM_Master_v2_0_0.rst
   - COV_001_Reporte_Cobertura.rst

2. **TST (Planes de Prueba)**
   - ~314 tests para 80% cobertura FR

---

# 15. ARCHIVOS DE REFERENCIA

| Archivo | Propósito | Ubicación |
|---------|-----------|-----------|
| MODELO_DOCUMENTAL_IACT_v2_1_0.md | Este documento | /tmp/ |
| MODELO_DOCUMENTAL_IACT_v2_0_8.md | Versión anterior | /uploads/ |
| MODELO_RBAC_IACT_v5_1_1.md | Modelo de permisos | /uploads/ |
| DEFINICIONES_OFICIALES_v2_0_0.md | Definiciones base | /uploads/ |
| Casos de Uso v4.0 | 49 UC generados | requisitos/casos_uso/ |
| Requisitos Funcionales | 55 FR generados | requisitos/funcionales/ |

---

# 16. PRINCIPIOS DE EVOLUCIÓN

1. **Compatibilidad hacia atrás**: Nuevas versiones no rompen estructura existente
2. **Versionado semántico**: MAJOR.MINOR.PATCH
3. **Trazabilidad total**: Todo cambio documentado en CHANGELOG
4. **Gobernanza**: PMO aprueba cambios estructurales
5. **Nomenclatura Clean Code**: Nombres descriptivos (UC_AUTH_01 vs UC_001)
6. **Ratio 1:8**: Cada UC genera aproximadamente 8 FR

---

*Modelo Documental IACT v2.1.0*  
*Proyecto: IACT Call Center Analytics Dashboard*  
*Fecha: 2026-01-07*  
*Estado: 🔄 En Progreso - Generación FR (55/~392 = 14%)*
