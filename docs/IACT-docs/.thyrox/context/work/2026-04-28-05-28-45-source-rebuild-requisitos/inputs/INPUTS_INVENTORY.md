```yml
created_at: 2026-04-28 15:00:00
project: IACT-docs
work_package: 2026-04-28-05-28-45-source-rebuild-requisitos
phase: Phase 1 — DISCOVER (input staging)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Inputs Inventory — WP requisitos

Documentos pre-staged desde `temp-backup/` y `temp-holding/`. Solo estos archivos deben consultarse para el analisis de este WP — evita buscar en todo `temp-*`.

## Convencion

- `canonical/` — un solo archivo por concepto (MD5 deduplicado, preferencia: temp-backup > FASE 02 > FASE 01).
- `variants/` — archivos con mismo nombre pero contenido distinto, ruta espejo del origen para desambiguar.

## Resumen

- Canonicos: **185**
- Variantes: **20**
- Duplicados colapsados: **0**

- Tamano total stage: 3,963,746 bytes (3870.8 KB)

## Canonicos

| Destino | Origen elegido | Hash | Bytes | Dups colapsados |
|---------|---------------|------|-------|----------------|
| `canonical/ACCESS_diagrama_casos_uso.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/ACCESS_diagrama_casos_uso.rst` | f5ad5e5b | 8,875 | 0 |
| `canonical/ALERTS_diagrama_casos_uso.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/ALERTS_diagrama_casos_uso.rst` | f27cee06 | 3,005 | 0 |
| `canonical/ANALISIS_CONSOLIDADO_V2_COMPLETO.md` | `temp-holding/FASE 01/Ingeniería de Requerimientos/ANALISIS_CONSOLIDADO_V2_COMPLETO.md` | 072dad89 | 74,854 | 0 |
| `canonical/ANALISIS_CONSOLIDADO_V2_PARTE2.md` | `temp-holding/FASE 01/Ingeniería de Requerimientos/ANALISIS_CONSOLIDADO_V2_PARTE2.md` | 88a03991 | 53,456 | 0 |
| `canonical/ANALISIS_CONSOLIDADO_V2_PARTE3.md` | `temp-holding/FASE 01/Ingeniería de Requerimientos/ANALISIS_CONSOLIDADO_V2_PARTE3.md` | 4ba017b1 | 61,769 | 0 |
| `canonical/ANALISIS_CONSOLIDADO_V2_PARTE4_FINAL.md` | `temp-holding/FASE 01/Ingeniería de Requerimientos/ANALISIS_CONSOLIDADO_V2_PARTE4_FINAL.md` | 3100cc38 | 65,556 | 0 |
| `canonical/ANALISIS_REGLAS_NEGOCIO_SISTEMA_COMPLETO.md` | `temp-holding/FASE 01/Ingeniería de Requerimientos/ANALISIS_REGLAS_NEGOCIO_SISTEMA_COMPLETO.md` | 346f1cd8 | 63,213 | 0 |
| `canonical/AUDIT_diagrama_casos_uso.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/AUDIT_diagrama_casos_uso.rst` | fef17f0c | 3,027 | 0 |
| `canonical/AUTH_diagrama_casos_uso.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/AUTH_diagrama_casos_uso.rst` | 2a66876e | 7,400 | 0 |
| `canonical/Actualizar referencias en PARTE_2A.txt` | `temp-holding/GENERACION_DOCUMENTACION/FASE 1/Actualizar referencias en PARTE_2A.txt` | fbd2b202 | 895 | 0 |
| `canonical/Análisis módulo por módulo  - v.0.0.1  - 091225.md` | `temp-holding/FASE 01/modulos/Análisis módulo por módulo  - v.0.0.1  - 091225.md` | 0a243fbb | 11,369 | 0 |
| `canonical/BR_001_Fuente_Operacional_Inmutable.rst` | `temp-backup/source-2026-04-28/requisitos/reglas_negocio/BR_001_Fuente_Operacional_Inmutable.rst` | 31e6149a | 4,857 | 0 |
| `canonical/BR_002_ETL_Batch_Nocturno.rst` | `temp-backup/source-2026-04-28/requisitos/reglas_negocio/BR_002_ETL_Batch_Nocturno.rst` | 78a6b08f | 4,882 | 0 |
| `canonical/BR_003_Usuario_Inactivo_90_Dias.rst` | `temp-backup/source-2026-04-28/requisitos/reglas_negocio/BR_003_Usuario_Inactivo_90_Dias.rst` | 2c9e45ad | 4,716 | 0 |
| `canonical/BR_004_Comunicaciones_Internas_Only.rst` | `temp-backup/source-2026-04-28/requisitos/reglas_negocio/BR_004_Comunicaciones_Internas_Only.rst` | 659c9188 | 4,829 | 0 |
| `canonical/BR_005_Sesion_Unica_Por_Usuario.rst` | `temp-backup/source-2026-04-28/requisitos/reglas_negocio/BR_005_Sesion_Unica_Por_Usuario.rst` | 012dca5b | 4,565 | 0 |
| `canonical/BR_006_RBAC_Flat_NIST.rst` | `temp-backup/source-2026-04-28/requisitos/reglas_negocio/BR_006_RBAC_Flat_NIST.rst` | 671b7fca | 5,031 | 0 |
| `canonical/BR_007_Separacion_Funciones_SoD.rst` | `temp-backup/source-2026-04-28/requisitos/reglas_negocio/BR_007_Separacion_Funciones_SoD.rst` | b93ca185 | 5,066 | 0 |
| `canonical/BR_008_Auditoria_Accesos.rst` | `temp-backup/source-2026-04-28/requisitos/reglas_negocio/BR_008_Auditoria_Accesos.rst` | 85019f7f | 3,372 | 0 |
| `canonical/BR_009_Bajas_Logicas.rst` | `temp-backup/source-2026-04-28/requisitos/reglas_negocio/BR_009_Bajas_Logicas.rst` | b4549c1a | 3,102 | 0 |
| `canonical/BR_010_Auditoria_Inmutable.rst` | `temp-backup/source-2026-04-28/requisitos/reglas_negocio/BR_010_Auditoria_Inmutable.rst` | b83d9e22 | 3,313 | 0 |
| `canonical/BR_011_Limites_Exportacion.rst` | `temp-backup/source-2026-04-28/requisitos/reglas_negocio/BR_011_Limites_Exportacion.rst` | 3d71b658 | 8,535 | 0 |
| `canonical/BR_012_Usuario_Segmento_Unico.rst` | `temp-backup/source-2026-04-28/requisitos/reglas_negocio/BR_012_Usuario_Segmento_Unico.rst` | 8de97d4d | 9,901 | 0 |
| `canonical/BR_013_Username_Unico.rst` | `temp-backup/source-2026-04-28/requisitos/reglas_negocio/BR_013_Username_Unico.rst` | 15175359 | 8,435 | 0 |
| `canonical/BR_014_Alerta_Por_Umbral.rst` | `temp-backup/source-2026-04-28/requisitos/reglas_negocio/BR_014_Alerta_Por_Umbral.rst` | 9cdcb088 | 3,699 | 0 |
| `canonical/BR_015_Bloqueo_Intentos_Fallidos.rst` | `temp-backup/source-2026-04-28/requisitos/reglas_negocio/BR_015_Bloqueo_Intentos_Fallidos.rst` | 1566b103 | 4,735 | 0 |
| `canonical/BR_017_Tiempo_Promedio_Espera.rst` | `temp-backup/source-2026-04-28/requisitos/reglas_negocio/BR_017_Tiempo_Promedio_Espera.rst` | 6c5046f6 | 5,726 | 0 |
| `canonical/BR_018_Indice_Eficiencia.rst` | `temp-backup/source-2026-04-28/requisitos/reglas_negocio/BR_018_Indice_Eficiencia.rst` | 5fd8f991 | 5,627 | 0 |
| `canonical/BR_019_Retencion_2_Anios.rst` | `temp-backup/source-2026-04-28/requisitos/reglas_negocio/BR_019_Retencion_2_Anios.rst` | 390c9718 | 6,602 | 0 |
| `canonical/BR_020_Clasificacion_Datos.rst` | `temp-backup/source-2026-04-28/requisitos/reglas_negocio/BR_020_Clasificacion_Datos.rst` | 09889027 | 8,121 | 0 |
| `canonical/BReq_001_Visibilidad_Metricas.rst` | `temp-backup/source-2026-04-28/requisitos/objetivos/BReq_001_Visibilidad_Metricas.rst` | 88ca5828 | 4,734 | 0 |
| `canonical/BReq_002_Reduccion_Incidentes.rst` | `temp-backup/source-2026-04-28/requisitos/objetivos/BReq_002_Reduccion_Incidentes.rst` | 29957bb2 | 3,242 | 0 |
| `canonical/BReq_003_Decisiones_Informadas.rst` | `temp-backup/source-2026-04-28/requisitos/objetivos/BReq_003_Decisiones_Informadas.rst` | d082ff84 | 3,775 | 0 |
| `canonical/BReq_004_Cumplimiento_Seguridad.rst` | `temp-backup/source-2026-04-28/requisitos/objetivos/BReq_004_Cumplimiento_Seguridad.rst` | 9fa43b85 | 4,529 | 0 |
| `canonical/BReq_005_Integridad_Datos.rst` | `temp-backup/source-2026-04-28/requisitos/objetivos/BReq_005_Integridad_Datos.rst` | d9c54963 | 4,417 | 0 |
| `canonical/CATALOGO_BR.md` | `temp-holding/FASE 01/docs/PRODUCTO_DASHBOARD_ANALYTICS/1.0. CATALOGO_BR/CATALOGO_BR.md` | d832c286 | 2,992 | 0 |
| `canonical/CATALOGO_BR_SEGURIDAD.md` | `temp-holding/FASE 01/docs/PRODUCTO_DASHBOARD_ANALYTICS/1.0. CATALOGO_BR/CATALOGO_BR_SEGURIDAD.md` | 282f713e | 3,738 | 0 |
| `canonical/COMPONENTES_BASE.md` | `temp-holding/FASE 01/docs/PRODUCTO_DASHBOARD_ANALYTICS/COMPONENTES_BASE.md` | 999f412a | 3,680 | 0 |
| `canonical/Casos de Usos desde la perspectiva modular  - v.0.0.1 - 091225.md` | `temp-holding/FASE 01/modulos/Casos de Usos desde la perspectiva modular  - v.0.0.1 - 091225.md` | 9cf1a73c | 8,207 | 0 |
| `canonical/Crear directorios individuales.txt` | `temp-holding/GENERACION_DOCUMENTACION/FASE 1/Crear directorios individuales.txt` | dc15ccc1 | 551 | 0 |
| `canonical/De Reglas de Negocio a Sistema Completo.md` | `temp-holding/FASE 01/Ingeniería de Requerimientos/De Reglas de Negocio a Sistema Completo.md` | bda2adc1 | 1,204,148 | 0 |
| `canonical/ESTANDAR_TRAZABILIDAD_SDLC.md` | `temp-holding/FASE 01/docs/PRODUCTO_DASHBOARD_ANALYTICS/ESTANDAR_TRAZABILIDAD_SDLC.md` | e04154c0 | 4,053 | 0 |
| `canonical/ESTRUCTURA_COMPLETA_FR_ANEXO_V.0.0.1.md` | `temp-holding/FASE 01/FR_Requisitos_Funcionales/ESTRUCTURA_COMPLETA_FR_ANEXO_V.0.0.1.md` | a5810502 | 36,751 | 0 |
| `canonical/FASE 2 - MOD_Users - COMPLETADA.txt` | `temp-holding/FASE 01/Casos de Uso/FASE 2 - MOD_Users - COMPLETADA.txt` | 5855042d | 3,387 | 0 |
| `canonical/FASE 3 - MOD_Access - COMPLETADA.txt` | `temp-holding/FASE 01/Casos de Uso/FASE 3 - MOD_Access - COMPLETADA.txt` | 31ffeaa6 | 2,524 | 0 |
| `canonical/FASE 4 - MOD_Pipeline - COMPLETADA.txt` | `temp-holding/FASE 01/Casos de Uso/FASE 4 - MOD_Pipeline - COMPLETADA.txt` | bdc56cb0 | 4,621 | 0 |
| `canonical/FASE 5 - MOD_Reports - COMPLETADA.txt` | `temp-holding/FASE 01/Casos de Uso/FASE 5 - MOD_Reports - COMPLETADA.txt` | d59940bb | 3,231 | 0 |
| `canonical/FASE 6 MOD_Alerts - COMPLETADA.txt` | `temp-holding/FASE 01/Casos de Uso/FASE 6 MOD_Alerts - COMPLETADA.txt` | 6baf7fc5 | 4,361 | 0 |
| `canonical/FASE 7 - MOD_Audit - COMPLETADA.txt` | `temp-holding/FASE 01/Casos de Uso/FASE 7 - MOD_Audit - COMPLETADA.txt` | 88eb6277 | 2,486 | 0 |
| `canonical/FASE 8 - MOD_Logs - COMPLETADA.txt` | `temp-holding/FASE 01/Casos de Uso/FASE 8 - MOD_Logs - COMPLETADA.txt` | afcd8b4e | 6,170 | 0 |
| `canonical/FR-001.01_Validar_formato_username.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/auth/UC_001_Iniciar_Sesion/FR-001.01_Validar_formato_username.rst` | 77814915 | 2,910 | 0 |
| `canonical/FR-001.02_Validar_credenciales.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/auth/UC_001_Iniciar_Sesion/FR-001.02_Validar_credenciales.rst` | c1e59e75 | 3,719 | 0 |
| `canonical/FR-001.03_Generar_token_JWT.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/auth/UC_001_Iniciar_Sesion/FR-001.03_Generar_token_JWT.rst` | fb0ec1df | 3,565 | 0 |
| `canonical/FR-001.04_Invalidar_sesiones_previas.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/auth/UC_001_Iniciar_Sesion/FR-001.04_Invalidar_sesiones_previas.rst` | 1cf01c38 | 3,338 | 0 |
| `canonical/FR-001.05_Registrar_evento_auditoria.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/auth/UC_001_Iniciar_Sesion/FR-001.05_Registrar_evento_auditoria.rst` | 57459084 | 3,629 | 0 |
| `canonical/FR-002.01_Invalidar_token_JWT.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/auth/UC_002_Cerrar_Sesion/FR-002.01_Invalidar_token_JWT.rst` | 5116cc88 | 3,144 | 0 |
| `canonical/FR-002.02_Registrar_evento_logout.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/auth/UC_002_Cerrar_Sesion/FR-002.02_Registrar_evento_logout.rst` | 7d277a7a | 3,325 | 0 |
| `canonical/FR-002.03_Limpiar_datos_sesion_cliente.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/auth/UC_002_Cerrar_Sesion/FR-002.03_Limpiar_datos_sesion_cliente.rst` | b8d7f802 | 3,686 | 0 |
| `canonical/FR-003.01_Validar_username_existe.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/auth/UC_003_Recuperar_Password/FR-003.01_Validar_username_existe.rst` | 8b017c7b | 3,447 | 0 |
| `canonical/FR-003.02_Mostrar_pregunta_seguridad.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/auth/UC_003_Recuperar_Password/FR-003.02_Mostrar_pregunta_seguridad.rst` | 967c0121 | 3,136 | 0 |
| `canonical/FR-003.03_Validar_respuesta.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/auth/UC_003_Recuperar_Password/FR-003.03_Validar_respuesta.rst` | 0f1fb238 | 3,430 | 0 |
| `canonical/FR-003.04_Generar_password_temporal.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/auth/UC_003_Recuperar_Password/FR-003.04_Generar_password_temporal.rst` | fbfe9987 | 3,785 | 0 |
| `canonical/FR-003.05_Forzar_cambio_siguiente_login.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/auth/UC_003_Recuperar_Password/FR-003.05_Forzar_cambio_siguiente_login.rst` | 4a77167c | 3,709 | 0 |
| `canonical/FR-004.01_Validar_password_actual.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/auth/UC_004_Cambiar_Password/FR-004.01_Validar_password_actual.rst` | e5bfcf81 | 3,108 | 0 |
| `canonical/FR-004.02_Validar_complejidad_nuevo_password.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/auth/UC_004_Cambiar_Password/FR-004.02_Validar_complejidad_nuevo_password.rst` | 44e672af | 3,375 | 0 |
| `canonical/FR-004.03_Actualizar_hash_BD.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/auth/UC_004_Cambiar_Password/FR-004.03_Actualizar_hash_BD.rst` | 2d8bc274 | 3,579 | 0 |
| `canonical/FR-004.04_Invalidar_sesiones.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/auth/UC_004_Cambiar_Password/FR-004.04_Invalidar_sesiones.rst` | 430bb437 | 3,607 | 0 |
| `canonical/FR-005.01_Listar_sesiones_activas.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/auth/UC_005_Gestionar_Sesiones/FR-005.01_Listar_sesiones_activas.rst` | 14794aeb | 3,362 | 0 |
| `canonical/FR-005.02_Mostrar_detalle_sesion.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/auth/UC_005_Gestionar_Sesiones/FR-005.02_Mostrar_detalle_sesion.rst` | d0faef0b | 3,241 | 0 |
| `canonical/FR-005.03_Invalidar_sesion_individual.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/auth/UC_005_Gestionar_Sesiones/FR-005.03_Invalidar_sesion_individual.rst` | 74cabb24 | 3,515 | 0 |
| `canonical/FR-005.04_Invalidar_sesiones_por_usuario.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/auth/UC_005_Gestionar_Sesiones/FR-005.04_Invalidar_sesiones_por_usuario.rst` | 0bbb8a16 | 3,685 | 0 |
| `canonical/FR-006.01_Validar_campos_obligatorios.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/users/UC_006_Crear_Usuario/FR-006.01_Validar_campos_obligatorios.rst` | 6fd14e4d | 3,372 | 0 |
| `canonical/FR-006.02_Verificar_unicidad_username.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/users/UC_006_Crear_Usuario/FR-006.02_Verificar_unicidad_username.rst` | 8b97abe2 | 3,301 | 0 |
| `canonical/FR-006.03_Generar_password_temporal.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/users/UC_006_Crear_Usuario/FR-006.03_Generar_password_temporal.rst` | 13405483 | 3,333 | 0 |
| `canonical/FR-006.04_Crear_registro_usuario.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/users/UC_006_Crear_Usuario/FR-006.04_Crear_registro_usuario.rst` | 327b4d06 | 3,728 | 0 |
| `canonical/FR-006.05_Registrar_auditoria.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/users/UC_006_Crear_Usuario/FR-006.05_Registrar_auditoria.rst` | 85b09e54 | 3,410 | 0 |
| `canonical/FR-007.01_Cargar_datos_usuario.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/users/UC_007_Modificar_Usuario/FR-007.01_Cargar_datos_usuario.rst` | 9387c347 | 3,266 | 0 |
| `canonical/FR-007.02_Validar_campos_modificados.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/users/UC_007_Modificar_Usuario/FR-007.02_Validar_campos_modificados.rst` | 00582da0 | 3,295 | 0 |
| `canonical/FR-007.03_Actualizar_registro.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/users/UC_007_Modificar_Usuario/FR-007.03_Actualizar_registro.rst` | a51c8edc | 3,269 | 0 |
| `canonical/FR-007.04_Registrar_cambios_auditoria.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/users/UC_007_Modificar_Usuario/FR-007.04_Registrar_cambios_auditoria.rst` | d2d2e56a | 3,592 | 0 |
| `canonical/FR-008.01_Validar_usuario_activo.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/users/UC_008_Baja_Usuario/FR-008.01_Validar_usuario_activo.rst` | 2aadb428 | 3,182 | 0 |
| `canonical/FR-008.02_Cambiar_estado_INACTIVO.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/users/UC_008_Baja_Usuario/FR-008.02_Cambiar_estado_INACTIVO.rst` | 1e1c7bd8 | 3,313 | 0 |
| `canonical/FR-008.03_Invalidar_sesiones.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/users/UC_008_Baja_Usuario/FR-008.03_Invalidar_sesiones.rst` | 4350739d | 3,424 | 0 |
| `canonical/FR-008.04_Preservar_registro_historico.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/users/UC_008_Baja_Usuario/FR-008.04_Preservar_registro_historico.rst` | 490ad774 | 3,722 | 0 |
| `canonical/FR-009.01_Obtener_lista_paginada.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/users/UC_009_Listar_Usuarios/FR-009.01_Obtener_lista_paginada.rst` | 4cafe5df | 3,326 | 0 |
| `canonical/FR-009.02_Aplicar_filtros.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/users/UC_009_Listar_Usuarios/FR-009.02_Aplicar_filtros.rst` | 781b0028 | 3,302 | 0 |
| `canonical/FR-009.03_Ordenar_resultados.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/users/UC_009_Listar_Usuarios/FR-009.03_Ordenar_resultados.rst` | 6b209c29 | 3,192 | 0 |
| `canonical/FR-009.04_Mostrar_indicador_inactividad.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/users/UC_009_Listar_Usuarios/FR-009.04_Mostrar_indicador_inactividad.rst` | 76cf5853 | 3,381 | 0 |
| `canonical/FR-010.01_Listar_funciones_disponibles.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/access/UC_010_Asignar_Funciones/FR-010.01_Listar_funciones_disponibles.rst` | bc483571 | 3,494 | 0 |
| `canonical/FR-010.02_Validar_SoD_antes_asignar.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/access/UC_010_Asignar_Funciones/FR-010.02_Validar_SoD_antes_asignar.rst` | 9bbe8a48 | 3,681 | 0 |
| `canonical/FR-010.03_Crear_asignacion_usuario_funcion.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/access/UC_010_Asignar_Funciones/FR-010.03_Crear_asignacion_usuario_funcion.rst` | c1f90ca9 | 3,922 | 0 |
| `canonical/FR-010.04_Calcular_permisos_efectivos.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/access/UC_010_Asignar_Funciones/FR-010.04_Calcular_permisos_efectivos.rst` | 6367808a | 3,479 | 0 |
| `canonical/FR-011.01_Listar_funciones_asignadas.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/access/UC_011_Revocar_Funciones/FR-011.01_Listar_funciones_asignadas.rst` | fc3bdde1 | 3,314 | 0 |
| `canonical/FR-011.02_Eliminar_asignacion.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/access/UC_011_Revocar_Funciones/FR-011.02_Eliminar_asignacion.rst` | 51e938b3 | 3,510 | 0 |
| `canonical/FR-011.03_Recalcular_permisos_efectivos.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/access/UC_011_Revocar_Funciones/FR-011.03_Recalcular_permisos_efectivos.rst` | 127e70ec | 3,461 | 0 |
| `canonical/Identificación y Modelado Avanzado de Casos de Uso - 5b45.md` | `temp-holding/FASE 01/Ingeniería de Requerimientos/Identificación y Modelado Avanzado de Casos de Uso - 5b45.md` | b19afcc9 | 144,252 | 0 |
| `canonical/Introducción a las Técnicas de Larman.md` | `temp-holding/FASE 01/Ingeniería de Requerimientos/Introducción a las Técnicas de Larman.md` | b124ea58 | 225,724 | 0 |
| `canonical/LOGS_diagrama_casos_uso.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/LOGS_diagrama_casos_uso.rst` | 1aedb3e8 | 2,920 | 0 |
| `canonical/NOM_001_Nomenclatura_Proyecto_2_0_0.rst` | `temp-holding/GENERACION_DOCUMENTACION/FASE 1/NOM_001_Nomenclatura_Proyecto_2_0_0.rst` | c280a974 | 16,634 | 0 |
| `canonical/PARTE 0 - CONTEXTO Y FUNDAMENTOS - 661ca8.md` | `temp-holding/FASE 01/Ingeniería de Requerimientos/PARTE 0 - CONTEXTO Y FUNDAMENTOS - 661ca8.md` | 5852de57 | 47,017 | 0 |
| `canonical/PARTE 1 - IDENTIFICAR REGLAS DE NEGOCIO - 661ca8.md` | `temp-holding/FASE 01/Ingeniería de Requerimientos/PARTE 1 - IDENTIFICAR REGLAS DE NEGOCIO - 661ca8.md` | 821607f7 | 96,559 | 0 |
| `canonical/PARTE 2 - TRANSFORMAR REGLAS DE NEGOCIO EN CASOS DE USO - 661ca8 - v.0.1.1.md` | `temp-holding/FASE 01/Ingeniería de Requerimientos/PARTE 2 - TRANSFORMAR REGLAS DE NEGOCIO EN CASOS DE USO - 661ca8 - v.0.1.1.md` | cf888dbe | 231,834 | 0 |
| `canonical/PARTE 3 - IDENTIFICAR CASOS DE USO ADICIONALES- 661ca8.md` | `temp-holding/FASE 01/Ingeniería de Requerimientos/PARTE 3 - IDENTIFICAR CASOS DE USO ADICIONALES- 661ca8.md` | a3230816 | 110,580 | 0 |
| `canonical/PARTE 3 - PLAN DETALLADO DE ESTRUCTURA Y CONTENIDO - 661ca8.md` | `temp-holding/FASE 01/Ingeniería de Requerimientos/PARTE 3 - PLAN DETALLADO DE ESTRUCTURA Y CONTENIDO - 661ca8.md` | af84a882 | 24,297 | 0 |
| `canonical/PARTE 3 - PROGRESO DE GENERACIÓN - Sección 3 de forma más concisa pero completa  - 661ca8.md` | `temp-holding/FASE 01/Ingeniería de Requerimientos/PARTE 3 - PROGRESO DE GENERACIÓN - Sección 3 de forma más concisa pero completa  - 661ca8.md` | b203c44c | 52,272 | 0 |
| `canonical/PARTE 3 - TÉCNICA 2 - MODELO DE LARMAN - 661ca8.md` | `temp-holding/FASE 01/Ingeniería de Requerimientos/PARTE 3 - TÉCNICA 2 - MODELO DE LARMAN - 661ca8.md` | ac5cb9af | 240,892 | 0 |
| `canonical/PARTE 4 - ESPECIFICAR REQUERIMIENTOS FUNCIONALES - 661ca8.md` | `temp-holding/FASE 01/Ingeniería de Requerimientos/PARTE 4 - ESPECIFICAR REQUERIMIENTOS FUNCIONALES - 661ca8.md` | 83120163 | 58,736 | 0 |
| `canonical/PIPELINE_diagrama_casos_uso.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/PIPELINE_diagrama_casos_uso.rst` | 8dc1e3e4 | 2,965 | 0 |
| `canonical/PLAN MAESTRO - Regeneración de Casos de Uso v4.0.md` | `temp-holding/FASE 01/Casos de Uso/PLAN MAESTRO - Regeneración de Casos de Uso v4.0.md` | 8078bea3 | 20,610 | 0 |
| `canonical/PLAN_FR_ANALISIS_REAL_v1_0_0.md` | `temp-holding/FASE 01/FR_Requisitos_Funcionales/PLAN_FR_ANALISIS_REAL_v1_0_0.md` | 03e6dc40 | 19,936 | 0 |
| `canonical/PLAN_MAESTRO_FR_NFR_v1_0_0_borrador.md` | `temp-holding/FASE 01/FR_Requisitos_Funcionales/PLAN_MAESTRO_FR_NFR_v1_0_0_borrador.md` | bdbbd7d8 | 22,795 | 0 |
| `canonical/PROCESS_incident_response_activity.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/PROCESS_incident_response_activity.rst` | 75a63785 | 3,814 | 0 |
| `canonical/PROCESS_permission_grant_activity.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/PROCESS_permission_grant_activity.rst` | bd58fc51 | 3,087 | 0 |
| `canonical/PROCESS_user_onboarding_activity.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/PROCESS_user_onboarding_activity.rst` | d1a052b7 | 3,079 | 0 |
| `canonical/REFERENCIA_GLOBAL_MODULOS_IACT.md` | `temp-holding/FASE 01/modulos/REFERENCIA_GLOBAL_MODULOS_IACT.md` | 8f647774 | 21,863 | 0 |
| `canonical/REFERENCIA_GLOBAL_MODULOS_IACT_v1.md` | `temp-holding/FASE 01/modulos/REFERENCIA_GLOBAL_MODULOS_IACT_v1.md` | 8f647774 | 21,863 | 0 |
| `canonical/REPORTS_diagrama_casos_uso.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/REPORTS_diagrama_casos_uso.rst` | 2b5bceac | 3,092 | 0 |
| `canonical/RNF-AUD-001_AUDITORIA.md` | `temp-holding/FASE 01/docs/PRODUCTO_DASHBOARD_ANALYTICS/2.0. REQUISITOS/RNF/RNF-AUD-001_AUDITORIA.md` | 68309f98 | 2,631 | 0 |
| `canonical/RNF-PROC-001_PROCESO_SDLC.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_no_funcionales/RNF-PROC-001_PROCESO_SDLC.rst` | e86fcb59 | 5,076 | 0 |
| `canonical/RNF-PROC-002_METRICAS_PROCESO.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_no_funcionales/RNF-PROC-002_METRICAS_PROCESO.rst` | a96212eb | 4,610 | 0 |
| `canonical/STD_001_Estandares_Documentacion_1_1_0.rst` | `temp-holding/GENERACION_DOCUMENTACION/FASE 1/STD_001_Estandares_Documentacion_1_1_0.rst` | f6418977 | 10,171 | 0 |
| `canonical/UC-010_REGISTRAR_LLAMADA_ENTRANTE.md` | `temp-holding/FASE 01/docs/PRODUCTO_DASHBOARD_ANALYTICS/2.0. REQUISITOS/UC-010_REGISTRAR_LLAMADA_ENTRANTE.md` | af9b20ce | 2,764 | 0 |
| `canonical/UC-010_REGISTRAR_LLAMADA_ENTRANTE_FINAL.md` | `temp-holding/FASE 01/docs/PRODUCTO_DASHBOARD_ANALYTICS/2.0. REQUISITOS/UC-010_REGISTRAR_LLAMADA_ENTRANTE_FINAL.md` | ef4e0dd5 | 3,763 | 0 |
| `canonical/UC_ACC_01_Asignar_Funciones.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/access/UC_ACC_01_Asignar_Funciones.rst` | df4c0b6b | 14,547 | 0 |
| `canonical/UC_ACC_02_Revocar_Funciones.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/access/UC_ACC_02_Revocar_Funciones.rst` | 8d42f23f | 11,317 | 0 |
| `canonical/UC_ACC_03_Consultar_Permisos.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/access/UC_ACC_03_Consultar_Permisos.rst` | 0e6ce405 | 10,825 | 0 |
| `canonical/UC_ACC_04_Asignar_Agrupador.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/access/UC_ACC_04_Asignar_Agrupador.rst` | 030e7eac | 13,090 | 0 |
| `canonical/UC_ACC_05_Gestionar_SoD.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/access/UC_ACC_05_Gestionar_SoD.rst` | 8207cbde | 12,125 | 0 |
| `canonical/UC_ACC_06_Gestionar_Segmentos.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/access/UC_ACC_06_Gestionar_Segmentos.rst` | f9c66c86 | 7,742 | 0 |
| `canonical/UC_ACC_07_Asignar_Segmento.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/access/UC_ACC_07_Asignar_Segmento.rst` | 52bed3d2 | 7,168 | 0 |
| `canonical/UC_ACC_08_Permiso_Temporal.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/access/UC_ACC_08_Permiso_Temporal.rst` | 734ee986 | 9,502 | 0 |
| `canonical/UC_ACC_09_Auditar_Cambios_Acceso.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/access/UC_ACC_09_Auditar_Cambios_Acceso.rst` | da3b7e2b | 8,855 | 0 |
| `canonical/UC_ALR_01_Configurar_Umbrales.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/alerts/UC_ALR_01_Configurar_Umbrales.rst` | 1b0bb9e7 | 12,044 | 0 |
| `canonical/UC_ALR_02_Ver_Alertas_Activas.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/alerts/UC_ALR_02_Ver_Alertas_Activas.rst` | f1b53242 | 11,143 | 0 |
| `canonical/UC_ALR_03_Reconocer_Alerta.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/alerts/UC_ALR_03_Reconocer_Alerta.rst` | f5d73da7 | 10,573 | 0 |
| `canonical/UC_ALR_04_Ver_Historial_Alertas.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/alerts/UC_ALR_04_Ver_Historial_Alertas.rst` | 0cedb6ca | 10,149 | 0 |
| `canonical/UC_ALR_05_Gestionar_Suscripciones.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/alerts/UC_ALR_05_Gestionar_Suscripciones.rst` | 7f8c412b | 12,970 | 0 |
| `canonical/UC_AUD_01_Consultar_Auditoria.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/audit/UC_AUD_01_Consultar_Auditoria.rst` | 6838a654 | 11,497 | 0 |
| `canonical/UC_AUD_02_Buscar_Auditoria.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/audit/UC_AUD_02_Buscar_Auditoria.rst` | 8bb577bd | 8,508 | 0 |
| `canonical/UC_AUD_03_Exportar_Auditoria.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/audit/UC_AUD_03_Exportar_Auditoria.rst` | 538464ed | 8,886 | 0 |
| `canonical/UC_AUD_04_Generar_Reporte_Compliance.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/audit/UC_AUD_04_Generar_Reporte_Compliance.rst` | 78cf9164 | 10,300 | 0 |
| `canonical/UC_AUTH_01_Iniciar_Sesion.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/auth/UC_AUTH_01_Iniciar_Sesion.rst` | de425622 | 17,399 | 0 |
| `canonical/UC_AUTH_02_Cerrar_Sesion.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/auth/UC_AUTH_02_Cerrar_Sesion.rst` | 1f70dcb6 | 12,368 | 0 |
| `canonical/UC_AUTH_03_Recuperar_Contrasena.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/auth/UC_AUTH_03_Recuperar_Contrasena.rst` | 68088219 | 16,364 | 0 |
| `canonical/UC_AUTH_04_Cambiar_Contrasena.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/auth/UC_AUTH_04_Cambiar_Contrasena.rst` | 6d8bfd32 | 15,611 | 0 |
| `canonical/UC_AUTH_05_Gestionar_Sesiones.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/auth/UC_AUTH_05_Gestionar_Sesiones.rst` | bb28f997 | 15,029 | 0 |
| `canonical/UC_LOG_01_Consultar_Logs_Sistema.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/logs/UC_LOG_01_Consultar_Logs_Sistema.rst` | 9def8137 | 9,943 | 0 |
| `canonical/UC_LOG_02_Consultar_Logs_ETL.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/logs/UC_LOG_02_Consultar_Logs_ETL.rst` | 1426d85e | 9,595 | 0 |
| `canonical/UC_LOG_03_Buscar_Logs.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/logs/UC_LOG_03_Buscar_Logs.rst` | bfc8e372 | 8,561 | 0 |
| `canonical/UC_LOG_04_Exportar_Logs.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/logs/UC_LOG_04_Exportar_Logs.rst` | 0b3111c4 | 9,262 | 0 |
| `canonical/UC_PIP_01_Supervisar_ETL.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/pipeline/UC_PIP_01_Supervisar_ETL.rst` | 9be36bd5 | 10,183 | 0 |
| `canonical/UC_PIP_02_Consultar_Errores_ETL.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/pipeline/UC_PIP_02_Consultar_Errores_ETL.rst` | 62bebacb | 8,282 | 0 |
| `canonical/UC_PIP_03_Consultar_Disponibilidad.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/pipeline/UC_PIP_03_Consultar_Disponibilidad.rst` | bf9145a3 | 7,974 | 0 |
| `canonical/UC_PIP_04_Solicitar_Reintento.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/pipeline/UC_PIP_04_Solicitar_Reintento.rst` | b7659744 | 11,704 | 0 |
| `canonical/UC_RPT_01_Ver_Dashboard.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/reports/UC_RPT_01_Ver_Dashboard.rst` | a41e5fe9 | 9,395 | 0 |
| `canonical/UC_RPT_02_Ver_Metricas_Tiempo_Real.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/reports/UC_RPT_02_Ver_Metricas_Tiempo_Real.rst` | e7aa3251 | 9,718 | 0 |
| `canonical/UC_RPT_03_Ver_Reportes_Historicos.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/reports/UC_RPT_03_Ver_Reportes_Historicos.rst` | 6a53c5db | 9,395 | 0 |
| `canonical/UC_RPT_04_Exportar_CSV.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/reports/UC_RPT_04_Exportar_CSV.rst` | 4df6356c | 10,311 | 0 |
| `canonical/UC_RPT_05_Exportar_Excel.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/reports/UC_RPT_05_Exportar_Excel.rst` | 0df829f8 | 8,706 | 0 |
| `canonical/UC_RPT_06_Exportar_PDF.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/reports/UC_RPT_06_Exportar_PDF.rst` | af142607 | 8,452 | 0 |
| `canonical/UC_RPT_07_Programar_Reporte.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/reports/UC_RPT_07_Programar_Reporte.rst` | 42c19307 | 7,431 | 0 |
| `canonical/UC_RPT_08_Ver_Reportes_Programados.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/reports/UC_RPT_08_Ver_Reportes_Programados.rst` | 624c59d8 | 6,059 | 0 |
| `canonical/UC_RPT_09_Configurar_Filtros.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/reports/UC_RPT_09_Configurar_Filtros.rst` | 712289a7 | 6,497 | 0 |
| `canonical/UC_RPT_10_Guardar_Vista.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/reports/UC_RPT_10_Guardar_Vista.rst` | 59a2828e | 5,884 | 0 |
| `canonical/UC_RPT_11_Compartir_Reporte.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/reports/UC_RPT_11_Compartir_Reporte.rst` | b17123a9 | 6,033 | 0 |
| `canonical/UC_RPT_12_Ver_Reporte_Agentes.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/reports/UC_RPT_12_Ver_Reporte_Agentes.rst` | e54459c3 | 6,218 | 0 |
| `canonical/UC_RPT_13_Ver_Reporte_Colas.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/reports/UC_RPT_13_Ver_Reporte_Colas.rst` | a183a594 | 6,200 | 0 |
| `canonical/UC_RPT_14_Ver_Reporte_Campanas.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/reports/UC_RPT_14_Ver_Reporte_Campanas.rst` | 17312622 | 6,259 | 0 |
| `canonical/UC_USR_01_Crear_Usuario.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/users/UC_USR_01_Crear_Usuario.rst` | a48d9fc8 | 17,477 | 0 |
| `canonical/UC_USR_02_Consultar_Usuarios.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/users/UC_USR_02_Consultar_Usuarios.rst` | 1e568815 | 12,135 | 0 |
| `canonical/UC_USR_03_Modificar_Usuario.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/users/UC_USR_03_Modificar_Usuario.rst` | 249136fd | 15,496 | 0 |
| `canonical/UC_USR_04_Eliminar_Usuario.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/users/UC_USR_04_Eliminar_Usuario.rst` | b1c36840 | 14,860 | 0 |
| `canonical/USERS_diagrama_casos_uso.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/USERS_diagrama_casos_uso.rst` | ab2b1a73 | 9,023 | 0 |
| `canonical/Validar STD_001 con scripts de validación.txt` | `temp-holding/GENERACION_DOCUMENTACION/FASE 1/Validar STD_001 con scripts de validación.txt` | 96cc4f0c | 5,921 | 0 |
| `canonical/WORKFLOW_alerting_sequence.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/WORKFLOW_alerting_sequence.rst` | 08fddd61 | 3,125 | 0 |
| `canonical/WORKFLOW_authentication_sequence.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/WORKFLOW_authentication_sequence.rst` | 55f1a034 | 4,815 | 0 |
| `canonical/WORKFLOW_call_processing_sequence.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/WORKFLOW_call_processing_sequence.rst` | 29e45e3e | 3,626 | 0 |
| `canonical/WORKFLOW_reporting_sequence.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/WORKFLOW_reporting_sequence.rst` | 942bb080 | 2,606 | 0 |
| `canonical/actores.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/actores.rst` | 2b60005e | 12,160 | 0 |
| `canonical/estado_generacion.txt` | `temp-holding/GENERACION_DOCUMENTACION/FASE 1/estado_generacion.txt` | 2b1a4081 | 2,470 | 0 |
| `canonical/glosario.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/glosario.rst` | 7362007b | 6,468 | 0 |
| `canonical/iact_regeneracion_validar.txt` | `temp-holding/GENERACION_DOCUMENTACION/FASE 1/iact_regeneracion_validar.txt` | 26d202e3 | 1,270 | 0 |
| `canonical/las 20 BR.txt` | `temp-holding/FASE 01/BR_ Busines Requirements/las 20 BR.txt` | e161937d | 1,575 | 0 |
| `canonical/nota_fin_fase_1.txt` | `temp-holding/GENERACION_DOCUMENTACION/FASE 1/nota_fin_fase_1.txt` | 6d092c14 | 1,760 | 0 |
| `canonical/restricciones.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/restricciones.rst` | a4a37d80 | 12,508 | 0 |

## Variantes

| Destino | Origen | Hash | Bytes |
|---------|--------|------|-------|
| `variants/temp-backup/source-2026-04-28/requisitos/casos_uso/access/index.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/access/index.rst` | 14263694 | 5,265 |
| `variants/temp-backup/source-2026-04-28/requisitos/casos_uso/alerts/index.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/alerts/index.rst` | 41d012a9 | 1,065 |
| `variants/temp-backup/source-2026-04-28/requisitos/casos_uso/audit/index.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/audit/index.rst` | c229edce | 979 |
| `variants/temp-backup/source-2026-04-28/requisitos/casos_uso/auth/index.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/auth/index.rst` | 0b6f74b5 | 17,602 |
| `variants/temp-backup/source-2026-04-28/requisitos/casos_uso/index.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/index.rst` | f460811c | 6,402 |
| `variants/temp-backup/source-2026-04-28/requisitos/casos_uso/logs/index.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/logs/index.rst` | 838dff33 | 987 |
| `variants/temp-backup/source-2026-04-28/requisitos/casos_uso/pipeline/index.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/pipeline/index.rst` | 248c5c9c | 1,004 |
| `variants/temp-backup/source-2026-04-28/requisitos/casos_uso/reports/index.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/reports/index.rst` | 8ee196f9 | 1,461 |
| `variants/temp-backup/source-2026-04-28/requisitos/casos_uso/users/index.rst` | `temp-backup/source-2026-04-28/requisitos/casos_uso/users/index.rst` | 2c72a883 | 988 |
| `variants/temp-backup/source-2026-04-28/requisitos/index.rst` | `temp-backup/source-2026-04-28/requisitos/index.rst` | faccf6b2 | 1,403 |
| `variants/temp-backup/source-2026-04-28/requisitos/objetivos/index.rst` | `temp-backup/source-2026-04-28/requisitos/objetivos/index.rst` | 238219bf | 4,127 |
| `variants/temp-backup/source-2026-04-28/requisitos/reglas_negocio/index.rst` | `temp-backup/source-2026-04-28/requisitos/reglas_negocio/index.rst` | 4ee06ad4 | 7,597 |
| `variants/temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/access/UC_010_Asignar_Funciones/index.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/access/UC_010_Asignar_Funciones/index.rst` | 0384ab40 | 261 |
| `variants/temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/access/UC_011_Revocar_Funciones/index.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/access/UC_011_Revocar_Funciones/index.rst` | 6aae37d8 | 209 |
| `variants/temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/access/index.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/access/index.rst` | 07cd1073 | 276 |
| `variants/temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/auth/index.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/auth/index.rst` | d0f389e6 | 2,622 |
| `variants/temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/index.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/index.rst` | 39fc1b7b | 982 |
| `variants/temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/users/index.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_funcionales/users/index.rst` | f3744639 | 2,194 |
| `variants/temp-backup/source-2026-04-28/requisitos/requisitos_no_funcionales/index.rst` | `temp-backup/source-2026-04-28/requisitos/requisitos_no_funcionales/index.rst` | 267cdb38 | 1,235 |
| `variants/temp-backup/source-2026-04-28/requisitos/rtm/index.rst` | `temp-backup/source-2026-04-28/requisitos/rtm/index.rst` | fff1072f | 1,188 |

