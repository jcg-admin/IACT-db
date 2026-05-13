# TABLA DE VERSIONADO COMPLETA - PROYECTO IACT RBAC v5.1.1

**Fecha:** 2026-01-11  
**Versión del documento:** 1.0.0

---

## DOCUMENTOS NUEVOS (Versión inicial: 1.0.0)

### CNST - Restricciones (8 documentos)

| # | Archivo | Versión | Estado | Ubicación |
|---|---------|---------|--------|-----------|
| 1 | CNST_001_No_Email_Sistema_1_0_0.rst | 1.0.0 | NUEVO | /cnst/ |
| 2 | CNST_002_Sesiones_BD_Timeout_1_0_0.rst | 1.0.0 | NUEVO | /cnst/ |
| 3 | CNST_003_BD_IVR_Readonly_ETL_1_0_0.rst | 1.0.0 | NUEVO | /cnst/ |
| 4 | CNST_004_Alertas_Buzon_Interno_1_0_0.rst | 1.0.0 | NUEVO | /cnst/ |
| 5 | **CNST_005_RBAC_Flat_SoD_Permisos_1_0_0.rst** | **1.0.0** | **NUEVO ⭐** | **/cnst/** |
| 6 | CNST_006_Reportes_Limites_Rango_1_0_0.rst | 1.0.0 | NUEVO | /cnst/ |
| 7 | CNST_007_Limites_Exportacion_Throttling_1_0_0.rst | 1.0.0 | NUEVO | /cnst/ |
| 8 | CNST_008_Audit_Inmutable_Logs_PII_1_0_0.rst | 1.0.0 | NUEVO | /cnst/ |

### UC MOD_Auth - Autenticación (5 documentos)

| # | Archivo | Versión | Estado | Ubicación |
|---|---------|---------|--------|-----------|
| 1 | UC_AUTH_001_Iniciar_Sesion_Sistema_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 2 | UC_AUTH_002_Cerrar_Sesion_Sistema_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 3 | UC_AUTH_003_Recuperar_Password_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 4 | UC_AUTH_004_Cambiar_Password_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 5 | UC_AUTH_005_Gestionar_Sesiones_BD_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |

### UC MOD_Users - Gestión Identidades (5 documentos)

| # | Archivo | Versión | Estado | Ubicación |
|---|---------|---------|--------|-----------|
| 1 | UC_USR_006_Crear_Usuario_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 2 | UC_USR_007_Modificar_Usuario_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 3 | UC_USR_008_Baja_Logica_Usuario_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 4 | UC_USR_009_Listar_Usuarios_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 5 | UC_USR_041_Asignar_Segmento_Datos_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |

### UC MOD_Access - RBAC Core (8 documentos)

| # | Archivo | Versión | Estado | Ubicación |
|---|---------|---------|--------|-----------|
| 1 | UC_ACC_010_Asignar_Funciones_Usuario_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 2 | UC_ACC_011_Consultar_Permisos_Efectivos_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 3 | UC_ACC_042_Asignar_Permisos_Directos_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 4 | UC_ACC_043_Configurar_Reglas_SoD_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 5 | UC_ACC_044_Ver_Asignaciones_Usuario_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 6 | UC_ACC_045_Gestionar_Catalogo_Roles_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 7 | UC_ACC_046_Gestionar_Catalogo_Permisos_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 8 | UC_ACC_047_Auditar_Cambios_Permisos_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |

### UC MOD_Pipeline - Supervisión ETL (4 documentos)

| # | Archivo | Versión | Estado | Ubicación |
|---|---------|---------|--------|-----------|
| 1 | UC_PIP_050_Supervisar_Ejecuciones_ETL_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 2 | UC_PIP_051_Consultar_Errores_ETL_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 3 | UC_PIP_052_Consultar_Disponibilidad_Datos_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 4 | UC_PIP_053_Solicitar_Reintento_ETL_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |

### UC MOD_Reports - Dashboards y Reportes (13 documentos)

| # | Archivo | Versión | Estado | Ubicación |
|---|---------|---------|--------|-----------|
| 1 | UC_RPT_017_Consultar_Reporte_Trimestral_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 2 | UC_RPT_018_Consultar_Problemas_Menu_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 3 | UC_RPT_019_Consultar_Transferencias_Centro_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 4 | UC_RPT_020_Filtrar_Reporte_Fecha_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 5 | UC_RPT_021_Filtrar_Reporte_Centro_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 6 | UC_RPT_022_Exportar_Reporte_CSV_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 7 | UC_RPT_023_Exportar_Reporte_Excel_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 8 | UC_RPT_024_Exportar_Reporte_PDF_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 9 | UC_RPT_025_Ver_Dashboard_Principal_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 10 | UC_RPT_026_Ver_KPIs_Estaticos_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 11 | UC_RPT_027_Ver_Graficos_Hora_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 12 | UC_RPT_028_Ver_Graficos_Dia_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 13 | UC_RPT_029_Ver_Distribucion_Centro_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |

### UC MOD_Alerts - Alertas y Notificaciones (5 documentos)

| # | Archivo | Versión | Estado | Ubicación |
|---|---------|---------|--------|-----------|
| 1 | UC_ALR_036_Crear_Alerta_Personal_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 2 | UC_ALR_037_Recibir_Notificacion_Interna_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 3 | UC_ALR_038_Pausar_Alerta_Snooze_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 4 | UC_ALR_039_Ver_Historial_Alertas_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 5 | UC_ALR_040_Gestionar_Destinatarios_Alerta_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |

### UC MOD_Audit - Auditoría Funcional (4 documentos)

| # | Archivo | Versión | Estado | Ubicación |
|---|---------|---------|--------|-----------|
| 1 | UC_AUD_060_Registrar_Evento_Auditoria_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 2 | UC_AUD_061_Consultar_Bitacora_Auditoria_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 3 | UC_AUD_062_Generar_Reporte_Auditoria_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 4 | UC_AUD_063_Exportar_Auditoria_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |

### UC MOD_Logs - Bitácoras Técnicas (3 documentos)

| # | Archivo | Versión | Estado | Ubicación |
|---|---------|---------|--------|-----------|
| 1 | UC_LOG_070_Consultar_Logs_Sistema_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 2 | UC_LOG_071_Filtrar_Logs_Nivel_Servicio_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |
| 3 | UC_LOG_072_Exportar_Logs_Tecnicos_1_0_0.rst | 1.0.0 | NUEVO | /casos_uso/ |

### Índices RBAC (4 documentos)

| # | Archivo | Versión | Estado | Ubicación |
|---|---------|---------|--------|-----------|
| 1 | IDX_Catalogo_Funciones_RBAC_IACT_1_0_0.rst | 1.0.0 | NUEVO | /indices/ |
| 2 | IDX_Catalogo_Agrupadores_IACT_1_0_0.rst | 1.0.0 | NUEVO | /indices/ |
| 3 | IDX_Matriz_SoD_IACT_1_0_0.rst | 1.0.0 | NUEVO | /indices/ |
| 4 | IDX_Catalogo_Segmentos_Datos_IACT_1_0_0.rst | 1.0.0 | NUEVO | /indices/ |

### Índices Generales (3 documentos)

| # | Archivo | Versión | Estado | Ubicación |
|---|---------|---------|--------|-----------|
| 1 | IDX_Maestro_Documentacion_IACT_1_0_0.md | 1.0.0 | NUEVO | /indices/ |
| 2 | IDX_Mapa_Referencias_Cruzadas_IACT_1_0_0.md | 1.0.0 | NUEVO | /indices/ |
| 3 | IDX_Catalogo_Templates_IACT_1_0_0.rst | 1.0.0 | NUEVO | /indices/ |

### Templates (1 documento nuevo)

| # | Archivo | Versión | Estado | Ubicación |
|---|---------|---------|--------|-----------|
| 1 | TPL_UC_Con_RBAC_1_0_0.rst | 1.0.0 | NUEVO | /templates/ |

---

## DOCUMENTOS SIN CAMBIOS

### Fundacionales (2 documentos)

| # | Archivo | Versión Actual | Acción | Ubicación |
|---|---------|----------------|--------|-----------|
| 1 | NOM_001_Nomenclatura_Proyecto_2_0_0.rst | 2.0.0 | SIN CAMBIOS | /fundacionales/ |
| 2 | STD_001_Estandares_Documentacion_1_1_0.rst | 1.1.0 | SIN CAMBIOS | /fundacionales/ |

### Material Pedagógico (12 documentos)

| # | Archivo | Versión Actual | Acción | Ubicación |
|---|---------|----------------|--------|-----------|
| 1 | PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md | 1.0.0 | SIN CAMBIOS | /pedagogico/ |
| 2 | PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md | 1.0.0 | SIN CAMBIOS | /pedagogico/ |
| 3 | PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md | 1.0.0 | SIN CAMBIOS | /pedagogico/ |
| 4 | PARTE_2B_Construccion_Detallada_IACT_1_0_0.md | 1.0.0 | SIN CAMBIOS | /pedagogico/ |
| 5 | PARTE_2C_Casos_Especiales_Validacion_IACT_1_0_0.md | 1.0.0 | SIN CAMBIOS | /pedagogico/ |
| 6 | PARTE_3A_Introduccion_CRUD_IACT_1_0_0.md | 1.0.0 | SIN CAMBIOS | /pedagogico/ |
| 7 | PARTE_3B_Tecnica_Larman_IACT_1_0_0.md | 1.0.0 | SIN CAMBIOS | /pedagogico/ |
| 8 | PARTE_3C_UI_Stakeholders_IACT_1_0_0.md | 1.0.0 | SIN CAMBIOS | /pedagogico/ |
| 9 | PARTE_3D_Consolidacion_Resumen_IACT_1_0_0.md | 1.0.0 | SIN CAMBIOS | /pedagogico/ |
| 10 | PARTE_4_Requisitos_Funcionales_IACT_1_0_0.md | 1.0.0 | SIN CAMBIOS | /pedagogico/ |
| 11 | PARTE_5_Trazabilidad_Gestion_IACT_1_0_0.md | 1.0.0 | SIN CAMBIOS | /pedagogico/ |
| 12 | PARTE_6_Casos_Practicos_Completos_IACT_1_0_0.md | 1.0.0 | SIN CAMBIOS | /pedagogico/ |

### Templates Existentes (12 documentos)

| # | Archivo | Versión Actual | Acción | Ubicación |
|---|---------|----------------|--------|-----------|
| 1 | TPL_BR_Decision_Tipo_1_3_0.rst | 1.3.0 | SIN CAMBIOS | /templates/ |
| 2 | TPL_UC_Construccion_7_Pasos_1_3_0.rst | 1.3.0 | SIN CAMBIOS | /templates/ |
| 3 | TPL_FR_Documentacion_10_Componentes_1_3_0.rst | 1.3.0 | SIN CAMBIOS | /templates/ |
| 4 | TPL_UC_UI_Driven_1_3_0.rst | 1.3.0 | SIN CAMBIOS | /templates/ |
| 5 | TPL_UC_Temporal_Schedulers_1_3_0.rst | 1.3.0 | SIN CAMBIOS | /templates/ |
| 6 | TPL_UC_Stakeholder_Driven_1_3_0.rst | 1.3.0 | SIN CAMBIOS | /templates/ |
| 7 | TPL_UC_Actor_Secundario_1_3_0.rst | 1.3.0 | SIN CAMBIOS | /templates/ |
| 8 | TPL_FR_Query_SQL_1_3_0.rst | 1.3.0 | SIN CAMBIOS | /templates/ |
| 9 | TPL_FR_Validacion_Reglas_1_3_0.rst | 1.3.0 | SIN CAMBIOS | /templates/ |
| 10 | TPL_TRZ_Matriz_RTM_1_3_0.rst | 1.3.0 | SIN CAMBIOS | /templates/ |
| 11 | TPL_UC_CRUD_Operaciones_1_2_0.rst | 1.2.0 | SIN CAMBIOS | /templates/ |
| 12 | TPL_UC_Larman_Contratos_1_2_0.rst | 1.2.0 | SIN CAMBIOS | /templates/ |

---

## RESUMEN DE VERSIONADO

```
NUEVOS DOCUMENTOS (versión 1.0.0):
├── CNST:            8 documentos
├── UC MOD_Auth:     5 documentos
├── UC MOD_Users:    5 documentos
├── UC MOD_Access:   8 documentos
├── UC MOD_Pipeline: 4 documentos
├── UC MOD_Reports: 13 documentos
├── UC MOD_Alerts:   5 documentos
├── UC MOD_Audit:    4 documentos
├── UC MOD_Logs:     3 documentos
├── Índices RBAC:    4 documentos
├── Índices Gen.:    3 documentos
└── Templates:       1 documento
    ─────────────────────────────
    TOTAL NUEVOS:   62 documentos

SIN CAMBIOS:
├── Fundacionales:   2 documentos
├── Pedagógico:     12 documentos
├── Templates:      12 documentos
└── Originales:     16 documentos (archivados)
    ─────────────────────────────
    TOTAL SIN CAMBIOS: 42 documentos

TOTAL PROYECTO:    104 documentos
```

---

## CRITERIOS DE INCREMENTO DE VERSIÓN (Futuros)

**Cuando se requiera actualizar un documento existente:**

### MAJOR (X.0.0)
- Cambios incompatibles con la versión anterior
- Cambio de estructura fundamental del documento
- Eliminación de secciones críticas
- Ejemplo: CNST_005_1_0_0 → CNST_005_2_0_0

### MINOR (0.X.0)
- Nuevas secciones añadidas
- Nuevas funciones RBAC documentadas
- Nuevos agrupadores
- Compatibilidad hacia atrás mantenida
- Ejemplo: CNST_005_1_0_0 → CNST_005_1_1_0

### PATCH (0.0.X)
- Correcciones de errores tipográficos
- Clarificaciones de texto
- Ejemplos mejorados sin cambiar estructura
- Ejemplo: CNST_005_1_0_0 → CNST_005_1_0_1

---

**FIN DE LA TABLA DE VERSIONADO**

