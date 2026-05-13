# 📘 MODELO DOCUMENTAL IACT v2.2.0

## Sistema de Documentación Gobernado y Trazable

**Versión:** 2.2.0  
**Fecha:** 2026-01-07  
**Estado:** ✅ OFICIAL — Versión con TPL y PROC Completos  
**Autor:** Equipo IACT  
**Clasificación:** Normativo  
**Base:** v2.1.1 + 17 TPL + 38 PROC + Reestructuración Árbol

---

# 📋 CHANGELOG DESDE v2.1.1

| Versión | Cambio |
|---------|--------|
| v2.1.1 | STD_006 Versionado Semántico, 20 BR completas |
| **v2.2.0** | **🆕 Sección 11 resumida, árbol completo movido a ANEXO_A** |
| **v2.2.0** | **🆕 17 TPL con nomenclatura versionada (antes 6)** |
| **v2.2.0** | **🆕 38 PROC con nomenclatura versionada (antes 3)** |
| **v2.2.0** | **🆕 Gap de PROC cerrado: 38/38 (100%)** |
| **v2.2.0** | **🆕 Gap de TPL cerrado: 17/17 (100%)** |
| **v2.2.0** | **🆕 Nueva nomenclatura: PROC_[Nombre]_X_Y_Z.rst** |
| **v2.2.0** | **🆕 Nueva nomenclatura: TPL_[Tipo]_[Nombre]_X_Y_Z.rst** |
| **v2.2.0** | **🆕 ~11,873 líneas de PROC generadas** |
| **v2.2.0** | **🆕 ~8,918 líneas de TPL generadas** |

---

# 1. ESTRUCTURA COMPLETA DEL SISTEMA DOCUMENTAL

## 1.1 Fórmula del Modelo

```
5 DOMINIOS + 21 SUBDOMINIOS + 6 SUBCARPETAS + 49 UC + 55 FR + 20 BR + 6 STD + 17 TPL + 38 PROC
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

# 4. JERARQUÍA DE 5 NIVELES

## 4.1 Estructura

```
BReq (8) → BR (20) → UC (49) → FR (~392) → CODE/TEST
  │          │          │          │
  │          │          │          └── ratio 1:8 por UC
  │          │          └── 23,401 líneas, 147 diagramas
  │          └── 20 BR COMPLETAS
  └── 8 objetivos de negocio
```

## 4.2 Tipos de Enlaces

| Relación | Cardinalidad | Ejemplo |
|----------|--------------|---------|
| BReq → BR | 1:N | BReq_AUTH → BR_005, BR_006, BR_015 |
| BR → UC | N:M | BR_001 → UC_PIP_*, UC_RPT_* |
| UC → FR | 1:N (≈1:8) | UC_AUTH_01 → 5 FR |
| FR → CODE | 1:1 | FR_UCAUTH_01_01 → auth_service.py |
| FR → TEST | 1:N | FR_UCAUTH_01_01 → 2 tests |

---

# 5. BUSINESS REQUIREMENTS (BReq) — 8 Objetivos

| ID | Nombre | Módulo | BR Relacionadas |
|----|--------|--------|-----------------|
| BReq_AUTH | Autenticación Segura | MOD_Auth | BR_005, BR_006, BR_013, BR_015 |
| BReq_USR | Gestión de Usuarios | MOD_Users | BR_003, BR_009, BR_012, BR_013 |
| BReq_ACC | Control de Acceso | MOD_Access | BR_006, BR_007, BR_008, BR_012 |
| BReq_PIP | Pipeline de Datos | MOD_Pipeline | BR_001, BR_002 |
| BReq_RPT | Reportería Analítica | MOD_Reports | BR_011, BR_016, BR_017, BR_018 |
| BReq_ALR | Sistema de Alertas | MOD_Alerts | BR_004, BR_014 |
| BReq_AUD | Auditoría y Compliance | MOD_Audit | BR_010, BR_019, BR_020 |
| BReq_LOG | Bitácoras del Sistema | MOD_Logs | BR_010, BR_019 |

---

# 6. BUSINESS RULES (BR) — 20 Reglas COMPLETAS

## 6.1 Catálogo Completo de 20 BR

| BR | Nombre | Tipo | CNST |
|----|--------|------|------|
| BR_001 | Fuente Operacional Inmutable | Restricción | CNST_003 |
| BR_002 | ETL Batch Nocturno | Desencadenador | CNST_004 |
| BR_003 | Usuario Inactivo 90 Días | Inferencia | — |
| BR_004 | Comunicaciones Internas Only | Restricción | CNST_001 |
| BR_005 | Sesión Única por Usuario | Restricción | CNST_002 |
| BR_006 | RBAC Flat NIST | Hecho | CNST_005 |
| BR_007 | Separación Funciones SoD | Restricción | CNST_005 |
| BR_008 | Permisos con Vencimiento | Restricción | CNST_005 |
| BR_009 | Bajas Lógicas | Restricción | CNST_005 |
| BR_010 | Auditoría Inmutable | Restricción | CNST_009 |
| BR_011 | Límites de Exportación | Restricción | CNST_007 |
| BR_012 | Usuario-Segmento Único | Hecho | — |
| BR_013 | Username Único | Hecho | — |
| BR_014 | Alerta por Umbral | Desencadenador | — |
| BR_015 | Bloqueo Intentos Fallidos | Desencadenador | CNST_005 |
| BR_016 | Tasa de Abandono | Cálculo | — |
| BR_017 | Tiempo Promedio Espera | Cálculo | — |
| BR_018 | Índice de Eficiencia | Cálculo | — |
| BR_019 | Retención 2 Años | Restricción | CNST_006 |
| BR_020 | Clasificación de Datos | Restricción | CNST_010 |

## 6.2 Clasificación por Tipo (TXM_03)

| Tipo | Cantidad | BR |
|------|----------|-----|
| **Restricción** | 10 | BR_001, 004, 005, 007, 008, 009, 010, 011, 019, 020 |
| **Desencadenador** | 3 | BR_002, 014, 015 |
| **Hecho** | 3 | BR_006, 012, 013 |
| **Inferencia** | 1 | BR_003 |
| **Cálculo** | 3 | BR_016, 017, 018 |

## 6.3 BR de Cálculo (KPIs)

| BR | Fórmula | Umbral Alerta |
|----|---------|---------------|
| BR_016 | Tasa_Abandono = (Abandonadas / Total) × 100 | > 15% |
| BR_017 | TPE = AVG(tiempo_espera_segundos) | > 120 seg |
| BR_018 | Índice_Eficiencia = (Atendidas / Total) × 100 | < 85% |

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
| CNST-010 | Clasificación Datos | 4 niveles de sensibilidad |

## 7.2 Matriz CNST → BR

| CNST | BR que lo implementan |
|------|----------------------|
| CNST_001 | BR_004 (Comunicaciones Internas) |
| CNST_002 | BR_005 (Sesión Única) |
| CNST_003 | BR_001 (Fuente Inmutable) |
| CNST_004 | BR_002 (ETL Batch) |
| CNST_005 | BR_006, BR_007, BR_008, BR_009, BR_015 |
| CNST_006 | BR_019 (Retención 2 Años) |
| CNST_007 | BR_011 (Límites Exportación) |
| CNST_009 | BR_010 (Auditoría Inmutable) |
| CNST_010 | BR_020 (Clasificación Datos) |

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

## 9.3 Formato Estándar FR

Cada FR contiene 6 secciones:

1. **Identificación**: ID, Nombre, UC origen, Módulo
2. **Especificación**: Descripción detallada del requisito
3. **Criterio de Aceptación**: Formato DADO/CUANDO/ENTONCES
4. **Reglas y Restricciones**: BR y CNST aplicables
5. **Trazabilidad**: Enlaces a UC, BR, CNST
6. **Historial**: Versiones del FR

---

# 10. ESTÁNDARES (STD) — 6 Documentos

## 10.1 Catálogo de Estándares

| ID | Nombre | Líneas | Estado |
|----|--------|--------|--------|
| STD_001 | Suite Calidad Código | ~150 | ✅ |
| STD_002 | Metodología SBVR/UML/Larman | ~200 | ✅ |
| STD_003 | Clean Code Naming | ~120 | ✅ |
| STD_004 | Nomenclatura Proyecto | ~180 | ✅ |
| STD_005 | Estilo Documentación Sphinx | ~160 | ✅ |
| STD_006 | Versionado Semántico | 340 | ✅ |

## 10.2 STD_006 Versionado Semántico

| Sección | Contenido |
|---------|-----------|
| 1. Propósito | Por qué este estándar |
| 2. Alcance | A qué artefactos aplica |
| 3. Formato de Versión | MAJOR.MINOR.PATCH |
| 4. Reglas de Incremento | Cuándo incrementar cada componente |
| 5. Reglas Específicas IACT | Versión inicial, congelados, prohibición de saltos |
| 6. Registro de Versiones | Formato de historial obligatorio |
| 7. Ejemplos Aplicados | Evolución real del Modelo Documental |
| 8. Verificación | Checklist para revisores |
| 9. Referencias | SemVer 2.0.0, GOB_05 |
| 10. Trazabilidad | Origen y relaciones |
| 11. Historial | Versionado del propio documento |
