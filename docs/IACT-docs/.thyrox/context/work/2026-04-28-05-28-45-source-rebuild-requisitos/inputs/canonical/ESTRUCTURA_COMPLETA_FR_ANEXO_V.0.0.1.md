# 📁 ESTRUCTURA COMPLETA FR - ANEXO AL PLAN MAESTRO
## Detalle de los ~393 Requisitos Funcionales por Módulo

**Versión:** 1.0.0  
**Fecha:** 2026-01-07  
**Documento Base:** PLAN_MAESTRO_FR_NFR_v1_0_0.md

---

# ESTRUCTURA DE DIRECTORIOS COMPLETA

**Principio:** Un archivo .rst por cada FR individual, organizados en subcarpetas por UC.

```
requisitos/
└── funcionales/                                         # [DESCONGELADO] 393 archivos FR
    ├── index.rst
    │
    │ ══════════════════════════════════════════════════════════════════
    │ MOD_Auth (5 UC = 38 FR)
    │ ══════════════════════════════════════════════════════════════════
    │
    ├── auth/
    │   ├── index.rst
    │   │
    │   ├── UC_AUTH_01_Iniciar_Sesion/                   # 8 FR
    │   │   ├── FR_AUTH_01_01_Validar_Formato_Username.rst
    │   │   ├── FR_AUTH_01_02_Validar_Formato_Password.rst
    │   │   ├── FR_AUTH_01_03_Verificar_Credenciales.rst
    │   │   ├── FR_AUTH_01_04_Verificar_Usuario_Activo.rst
    │   │   ├── FR_AUTH_01_05_Generar_Token_JWT.rst
    │   │   ├── FR_AUTH_01_06_Crear_Registro_Sesion.rst
    │   │   ├── FR_AUTH_01_07_Registrar_Login_Auditoria.rst
    │   │   └── FR_AUTH_01_08_Retornar_Token_Frontend.rst
    │   │
    │   ├── UC_AUTH_02_Cerrar_Sesion/                    # 6 FR
    │   │   ├── FR_AUTH_02_01_Validar_Token_Activo.rst
    │   │   ├── FR_AUTH_02_02_Invalidar_Token_JWT.rst
    │   │   ├── FR_AUTH_02_03_Actualizar_Sesion_BD.rst
    │   │   ├── FR_AUTH_02_04_Registrar_Logout_Auditoria.rst
    │   │   ├── FR_AUTH_02_05_Limpiar_Cache_Usuario.rst
    │   │   └── FR_AUTH_02_06_Retornar_Confirmacion.rst
    │   │
    │   ├── UC_AUTH_03_Recuperar_Contrasena/             # 8 FR
    │   │   ├── FR_AUTH_03_01_Validar_Email_Formato.rst
    │   │   ├── FR_AUTH_03_02_Verificar_Email_Existe.rst
    │   │   ├── FR_AUTH_03_03_Generar_Token_Recuperacion.rst
    │   │   ├── FR_AUTH_03_04_Almacenar_Token_Temporal.rst
    │   │   ├── FR_AUTH_03_05_Crear_Notificacion_Interna.rst
    │   │   ├── FR_AUTH_03_06_Registrar_Solicitud_Auditoria.rst
    │   │   ├── FR_AUTH_03_07_Validar_Token_Recuperacion.rst
    │   │   └── FR_AUTH_03_08_Permitir_Nueva_Contrasena.rst
    │   │
    │   ├── UC_AUTH_04_Cambiar_Contrasena/               # 8 FR
    │   │   ├── FR_AUTH_04_01_Validar_Sesion_Activa.rst
    │   │   ├── FR_AUTH_04_02_Verificar_Contrasena_Actual.rst
    │   │   ├── FR_AUTH_04_03_Validar_Nueva_Contrasena.rst
    │   │   ├── FR_AUTH_04_04_Verificar_Historial_Contrasenas.rst
    │   │   ├── FR_AUTH_04_05_Hashear_Nueva_Contrasena.rst
    │   │   ├── FR_AUTH_04_06_Actualizar_Contrasena_BD.rst
    │   │   ├── FR_AUTH_04_07_Invalidar_Otras_Sesiones.rst
    │   │   └── FR_AUTH_04_08_Registrar_Cambio_Auditoria.rst
    │   │
    │   └── UC_AUTH_05_Gestionar_Sesiones/               # 8 FR
    │       ├── FR_AUTH_05_01_Listar_Sesiones_Usuario.rst
    │       ├── FR_AUTH_05_02_Mostrar_Detalles_Sesion.rst
    │       ├── FR_AUTH_05_03_Identificar_Sesion_Actual.rst
    │       ├── FR_AUTH_05_04_Cerrar_Sesion_Especifica.rst
    │       ├── FR_AUTH_05_05_Cerrar_Todas_Sesiones.rst
    │       ├── FR_AUTH_05_06_Registrar_Cierre_Auditoria.rst
    │       ├── FR_AUTH_05_07_Notificar_Cierre_Forzado.rst
    │       └── FR_AUTH_05_08_Actualizar_Lista_Sesiones.rst
    │
    │ ══════════════════════════════════════════════════════════════════
    │ MOD_Users (4 UC = 32 FR)
    │ ══════════════════════════════════════════════════════════════════
    │
    ├── users/
    │   ├── index.rst
    │   │
    │   ├── UC_USR_01_Crear_Usuario/                     # 8 FR
    │   │   ├── FR_USR_01_01_Validar_Permiso_Creacion.rst
    │   │   ├── FR_USR_01_02_Validar_Username_Unico.rst
    │   │   ├── FR_USR_01_03_Validar_Email_Unico.rst
    │   │   ├── FR_USR_01_04_Validar_Formato_Campos.rst
    │   │   ├── FR_USR_01_05_Hashear_Contrasena_Inicial.rst
    │   │   ├── FR_USR_01_06_Crear_Registro_Usuario.rst
    │   │   ├── FR_USR_01_07_Asignar_Segmento_Default.rst
    │   │   └── FR_USR_01_08_Registrar_Creacion_Auditoria.rst
    │   │
    │   ├── UC_USR_02_Modificar_Usuario/                 # 8 FR
    │   │   ├── FR_USR_02_01_Validar_Permiso_Modificacion.rst
    │   │   ├── FR_USR_02_02_Cargar_Datos_Actuales.rst
    │   │   ├── FR_USR_02_03_Validar_Email_Unico_Modificado.rst
    │   │   ├── FR_USR_02_04_Validar_Campos_Modificados.rst
    │   │   ├── FR_USR_02_05_Actualizar_Registro_Usuario.rst
    │   │   ├── FR_USR_02_06_Preservar_Campos_No_Modificados.rst
    │   │   ├── FR_USR_02_07_Registrar_Modificacion_Auditoria.rst
    │   │   └── FR_USR_02_08_Notificar_Usuario_Cambios.rst
    │   │
    │   ├── UC_USR_03_Desactivar_Usuario/                # 8 FR
    │   │   ├── FR_USR_03_01_Validar_Permiso_Desactivacion.rst
    │   │   ├── FR_USR_03_02_Verificar_Usuario_Activo.rst
    │   │   ├── FR_USR_03_03_Impedir_Auto_Desactivacion.rst
    │   │   ├── FR_USR_03_04_Solicitar_Confirmacion.rst
    │   │   ├── FR_USR_03_05_Marcar_Usuario_Inactivo.rst
    │   │   ├── FR_USR_03_06_Cerrar_Sesiones_Activas.rst
    │   │   ├── FR_USR_03_07_Revocar_Permisos_Temporales.rst
    │   │   └── FR_USR_03_08_Registrar_Desactivacion_Auditoria.rst
    │   │
    │   └── UC_USR_04_Listar_Usuarios/                   # 8 FR
    │       ├── FR_USR_04_01_Validar_Permiso_Consulta.rst
    │       ├── FR_USR_04_02_Aplicar_Filtro_Segmento.rst
    │       ├── FR_USR_04_03_Obtener_Lista_Usuarios.rst
    │       ├── FR_USR_04_04_Aplicar_Filtros_Adicionales.rst
    │       ├── FR_USR_04_05_Ordenar_Resultados.rst
    │       ├── FR_USR_04_06_Paginar_Resultados.rst
    │       ├── FR_USR_04_07_Mostrar_Estado_Usuario.rst
    │       └── FR_USR_04_08_Permitir_Acciones_Rapidas.rst
    │
    │ ══════════════════════════════════════════════════════════════════
    │ MOD_Access (9 UC = 89 FR) - ALTA COMPLEJIDAD RBAC
    │ ══════════════════════════════════════════════════════════════════
    │
    ├── access/
    │   ├── index.rst
    │   │
    │   ├── UC_ACC_01_Asignar_Rol/                       # 10 FR
    │   │   ├── FR_ACC_01_01_Validar_Permiso_Asignacion.rst
    │   │   ├── FR_ACC_01_02_Cargar_Roles_Disponibles.rst
    │   │   ├── FR_ACC_01_03_Verificar_Usuario_Destino.rst
    │   │   ├── FR_ACC_01_04_Validar_Conflicto_SoD.rst
    │   │   ├── FR_ACC_01_05_Verificar_Limite_Roles.rst
    │   │   ├── FR_ACC_01_06_Crear_Asignacion_Rol.rst
    │   │   ├── FR_ACC_01_07_Configurar_Fecha_Vencimiento.rst
    │   │   ├── FR_ACC_01_08_Recalcular_Permisos_Efectivos.rst
    │   │   ├── FR_ACC_01_09_Registrar_Asignacion_Auditoria.rst
    │   │   └── FR_ACC_01_10_Notificar_Usuario_Asignacion.rst
    │   │
    │   ├── UC_ACC_02_Revocar_Rol/                       # 9 FR
    │   │   ├── FR_ACC_02_01_Validar_Permiso_Revocacion.rst
    │   │   ├── FR_ACC_02_02_Cargar_Roles_Asignados.rst
    │   │   ├── FR_ACC_02_03_Verificar_Rol_Asignado.rst
    │   │   ├── FR_ACC_02_04_Impedir_Revocar_Ultimo_Admin.rst
    │   │   ├── FR_ACC_02_05_Solicitar_Confirmacion.rst
    │   │   ├── FR_ACC_02_06_Eliminar_Asignacion_Rol.rst
    │   │   ├── FR_ACC_02_07_Recalcular_Permisos_Efectivos.rst
    │   │   ├── FR_ACC_02_08_Registrar_Revocacion_Auditoria.rst
    │   │   └── FR_ACC_02_09_Notificar_Usuario_Revocacion.rst
    │   │
    │   ├── UC_ACC_03_Gestionar_Funciones/               # 10 FR
    │   │   ├── FR_ACC_03_01_Validar_Permiso_Gestion_Funciones.rst
    │   │   ├── FR_ACC_03_02_Listar_Funciones_Sistema.rst
    │   │   ├── FR_ACC_03_03_Mostrar_Detalle_Funcion.rst
    │   │   ├── FR_ACC_03_04_Crear_Nueva_Funcion.rst
    │   │   ├── FR_ACC_03_05_Validar_Codigo_Funcion_Unico.rst
    │   │   ├── FR_ACC_03_06_Modificar_Funcion_Existente.rst
    │   │   ├── FR_ACC_03_07_Desactivar_Funcion.rst
    │   │   ├── FR_ACC_03_08_Verificar_Dependencias_Funcion.rst
    │   │   ├── FR_ACC_03_09_Registrar_Cambio_Auditoria.rst
    │   │   └── FR_ACC_03_10_Sincronizar_Permisos_Afectados.rst
    │   │
    │   ├── UC_ACC_04_Gestionar_Agrupadores/             # 10 FR
    │   │   ├── FR_ACC_04_01_Validar_Permiso_Gestion_Agrupadores.rst
    │   │   ├── FR_ACC_04_02_Listar_Agrupadores_Sistema.rst
    │   │   ├── FR_ACC_04_03_Mostrar_Funciones_Agrupador.rst
    │   │   ├── FR_ACC_04_04_Crear_Nuevo_Agrupador.rst
    │   │   ├── FR_ACC_04_05_Validar_Codigo_Agrupador_Unico.rst
    │   │   ├── FR_ACC_04_06_Asignar_Funciones_Agrupador.rst
    │   │   ├── FR_ACC_04_07_Remover_Funciones_Agrupador.rst
    │   │   ├── FR_ACC_04_08_Modificar_Agrupador_Existente.rst
    │   │   ├── FR_ACC_04_09_Desactivar_Agrupador.rst
    │   │   └── FR_ACC_04_10_Registrar_Cambio_Auditoria.rst
    │   │
    │   ├── UC_ACC_05_Configurar_SoD/                    # 12 FR
    │   │   ├── FR_ACC_05_01_Validar_Permiso_Config_SoD.rst
    │   │   ├── FR_ACC_05_02_Listar_Reglas_SoD_Actuales.rst
    │   │   ├── FR_ACC_05_03_Crear_Nueva_Regla_SoD.rst
    │   │   ├── FR_ACC_05_04_Seleccionar_Roles_Conflicto.rst
    │   │   ├── FR_ACC_05_05_Validar_Regla_No_Duplicada.rst
    │   │   ├── FR_ACC_05_06_Activar_Regla_SoD.rst
    │   │   ├── FR_ACC_05_07_Desactivar_Regla_SoD.rst
    │   │   ├── FR_ACC_05_08_Detectar_Violaciones_Existentes.rst
    │   │   ├── FR_ACC_05_09_Generar_Reporte_Violaciones.rst
    │   │   ├── FR_ACC_05_10_Forzar_Correccion_Violaciones.rst
    │   │   ├── FR_ACC_05_11_Registrar_Config_Auditoria.rst
    │   │   └── FR_ACC_05_12_Notificar_Administradores.rst
    │   │
    │   ├── UC_ACC_06_Asignar_Segmento/                  # 8 FR
    │   │   ├── FR_ACC_06_01_Validar_Permiso_Asignar_Segmento.rst
    │   │   ├── FR_ACC_06_02_Cargar_Segmentos_Disponibles.rst
    │   │   ├── FR_ACC_06_03_Mostrar_Segmento_Actual.rst
    │   │   ├── FR_ACC_06_04_Validar_Segmento_Unico_Usuario.rst
    │   │   ├── FR_ACC_06_05_Actualizar_Segmento_Usuario.rst
    │   │   ├── FR_ACC_06_06_Recalcular_Visibilidad_Datos.rst
    │   │   ├── FR_ACC_06_07_Registrar_Cambio_Auditoria.rst
    │   │   └── FR_ACC_06_08_Notificar_Usuario_Cambio.rst
    │   │
    │   ├── UC_ACC_07_Consultar_Permisos_Efectivos/      # 10 FR
    │   │   ├── FR_ACC_07_01_Validar_Permiso_Consulta.rst
    │   │   ├── FR_ACC_07_02_Seleccionar_Usuario_Consulta.rst
    │   │   ├── FR_ACC_07_03_Obtener_Roles_Usuario.rst
    │   │   ├── FR_ACC_07_04_Expandir_Funciones_Roles.rst
    │   │   ├── FR_ACC_07_05_Incluir_Permisos_Temporales.rst
    │   │   ├── FR_ACC_07_06_Calcular_Permisos_Efectivos.rst
    │   │   ├── FR_ACC_07_07_Mostrar_Origen_Permiso.rst
    │   │   ├── FR_ACC_07_08_Filtrar_Por_Modulo.rst
    │   │   ├── FR_ACC_07_09_Exportar_Permisos_Efectivos.rst
    │   │   └── FR_ACC_07_10_Registrar_Consulta_Auditoria.rst
    │   │
    │   ├── UC_ACC_08_Gestionar_Permisos_Temporales/     # 10 FR
    │   │   ├── FR_ACC_08_01_Validar_Permiso_Gestion_Temporal.rst
    │   │   ├── FR_ACC_08_02_Listar_Permisos_Temporales.rst
    │   │   ├── FR_ACC_08_03_Crear_Permiso_Temporal.rst
    │   │   ├── FR_ACC_08_04_Validar_Fecha_Inicio_Fin.rst
    │   │   ├── FR_ACC_08_05_Validar_Conflicto_SoD_Temporal.rst
    │   │   ├── FR_ACC_08_06_Activar_Permiso_Temporal.rst
    │   │   ├── FR_ACC_08_07_Revocar_Permiso_Temporal.rst
    │   │   ├── FR_ACC_08_08_Expirar_Permisos_Automaticamente.rst
    │   │   ├── FR_ACC_08_09_Notificar_Proxima_Expiracion.rst
    │   │   └── FR_ACC_08_10_Registrar_Cambio_Auditoria.rst
    │   │
    │   └── UC_ACC_09_Auditar_Cambios_Acceso/            # 10 FR
    │       ├── FR_ACC_09_01_Validar_Permiso_Auditoria_Acceso.rst
    │       ├── FR_ACC_09_02_Consultar_Log_Cambios_Acceso.rst
    │       ├── FR_ACC_09_03_Filtrar_Por_Usuario.rst
    │       ├── FR_ACC_09_04_Filtrar_Por_Tipo_Cambio.rst
    │       ├── FR_ACC_09_05_Filtrar_Por_Rango_Fechas.rst
    │       ├── FR_ACC_09_06_Mostrar_Detalle_Cambio.rst
    │       ├── FR_ACC_09_07_Mostrar_Valores_Antes_Despues.rst
    │       ├── FR_ACC_09_08_Exportar_Log_Cambios.rst
    │       ├── FR_ACC_09_09_Generar_Reporte_Cambios.rst
    │       └── FR_ACC_09_10_Registrar_Consulta_Auditoria.rst
    │
    │ ══════════════════════════════════════════════════════════════════
    │ MOD_Pipeline (4 UC = 28 FR)
    │ ══════════════════════════════════════════════════════════════════
    │
    ├── pipeline/
    │   ├── index.rst
    │   │
    │   ├── UC_PIP_01_Monitorear_ETL/                    # 7 FR
    │   │   ├── FR_PIP_01_01_Validar_Permiso_Monitoreo.rst
    │   │   ├── FR_PIP_01_02_Obtener_Estado_ETL_Actual.rst
    │   │   ├── FR_PIP_01_03_Mostrar_Ultima_Ejecucion.rst
    │   │   ├── FR_PIP_01_04_Mostrar_Proxima_Ejecucion.rst
    │   │   ├── FR_PIP_01_05_Calcular_Tiempo_Transcurrido.rst
    │   │   ├── FR_PIP_01_06_Mostrar_Indicadores_Estado.rst
    │   │   └── FR_PIP_01_07_Actualizar_Estado_Automatico.rst
    │   │
    │   ├── UC_PIP_02_Consultar_Errores_ETL/             # 7 FR
    │   │   ├── FR_PIP_02_01_Validar_Permiso_Consulta_Errores.rst
    │   │   ├── FR_PIP_02_02_Listar_Errores_Recientes.rst
    │   │   ├── FR_PIP_02_03_Filtrar_Por_Tipo_Error.rst
    │   │   ├── FR_PIP_02_04_Filtrar_Por_Fecha.rst
    │   │   ├── FR_PIP_02_05_Mostrar_Detalle_Error.rst
    │   │   ├── FR_PIP_02_06_Mostrar_Stack_Trace.rst
    │   │   └── FR_PIP_02_07_Exportar_Log_Errores.rst
    │   │
    │   ├── UC_PIP_03_Consultar_Disponibilidad/          # 7 FR
    │   │   ├── FR_PIP_03_01_Validar_Permiso_Consulta_Disponibilidad.rst
    │   │   ├── FR_PIP_03_02_Obtener_Fecha_Ultima_Carga.rst
    │   │   ├── FR_PIP_03_03_Calcular_Rango_Datos_Disponibles.rst
    │   │   ├── FR_PIP_03_04_Mostrar_Calendario_Disponibilidad.rst
    │   │   ├── FR_PIP_03_05_Identificar_Gaps_Datos.rst
    │   │   ├── FR_PIP_03_06_Mostrar_Estadisticas_Carga.rst
    │   │   └── FR_PIP_03_07_Alertar_Datos_Desactualizados.rst
    │   │
    │   └── UC_PIP_04_Solicitar_Reproceso/               # 7 FR
    │       ├── FR_PIP_04_01_Validar_Permiso_Solicitar_Reproceso.rst
    │       ├── FR_PIP_04_02_Mostrar_Formulario_Solicitud.rst
    │       ├── FR_PIP_04_03_Validar_Rango_Fechas_Reproceso.rst
    │       ├── FR_PIP_04_04_Validar_Motivo_Solicitud.rst
    │       ├── FR_PIP_04_05_Crear_Ticket_Reproceso.rst
    │       ├── FR_PIP_04_06_Notificar_Equipo_ETL.rst
    │       └── FR_PIP_04_07_Registrar_Solicitud_Auditoria.rst
    │
    │ ══════════════════════════════════════════════════════════════════
    │ MOD_Reports (14 UC = 102 FR)
    │ ══════════════════════════════════════════════════════════════════
    │
    ├── reports/
    │   ├── index.rst
    │   │
    │   ├── UC_RPT_01_Ver_Dashboard_Principal/           # 7 FR
    │   │   ├── FR_RPT_01_01_Validar_Permiso_Dashboard.rst
    │   │   ├── FR_RPT_01_02_Cargar_Configuracion_Dashboard.rst
    │   │   ├── FR_RPT_01_03_Aplicar_Filtro_Segmento.rst
    │   │   ├── FR_RPT_01_04_Obtener_Metricas_Resumen.rst
    │   │   ├── FR_RPT_01_05_Renderizar_KPIs_Principales.rst
    │   │   ├── FR_RPT_01_06_Cargar_Graficos_Default.rst
    │   │   └── FR_RPT_01_07_Mostrar_Fecha_Actualizacion.rst
    │   │
    │   ├── UC_RPT_02_Filtrar_por_Fecha/                 # 7 FR
    │   │   ├── FR_RPT_02_01_Mostrar_Selector_Fechas.rst
    │   │   ├── FR_RPT_02_02_Validar_Rango_Fechas.rst
    │   │   ├── FR_RPT_02_03_Validar_Datos_Disponibles.rst
    │   │   ├── FR_RPT_02_04_Aplicar_Filtro_Fecha.rst
    │   │   ├── FR_RPT_02_05_Recalcular_Metricas.rst
    │   │   ├── FR_RPT_02_06_Actualizar_Graficos.rst
    │   │   └── FR_RPT_02_07_Persistir_Filtro_Sesion.rst
    │   │
    │   ├── UC_RPT_03_Filtrar_por_Centro/                # 7 FR
    │   │   ├── FR_RPT_03_01_Cargar_Centros_Disponibles.rst
    │   │   ├── FR_RPT_03_02_Aplicar_Filtro_Segmento_Centros.rst
    │   │   ├── FR_RPT_03_03_Mostrar_Selector_Centros.rst
    │   │   ├── FR_RPT_03_04_Permitir_Seleccion_Multiple.rst
    │   │   ├── FR_RPT_03_05_Aplicar_Filtro_Centro.rst
    │   │   ├── FR_RPT_03_06_Recalcular_Metricas_Centro.rst
    │   │   └── FR_RPT_03_07_Persistir_Filtro_Sesion.rst
    │   │
    │   ├── UC_RPT_04_Ver_Grafico_por_Hora/              # 7 FR
    │   │   ├── FR_RPT_04_01_Validar_Permiso_Graficos.rst
    │   │   ├── FR_RPT_04_02_Obtener_Datos_Por_Hora.rst
    │   │   ├── FR_RPT_04_03_Agregar_Metricas_Horarias.rst
    │   │   ├── FR_RPT_04_04_Renderizar_Grafico_Lineas.rst
    │   │   ├── FR_RPT_04_05_Mostrar_Tooltips_Detalle.rst
    │   │   ├── FR_RPT_04_06_Permitir_Zoom_Rango.rst
    │   │   └── FR_RPT_04_07_Exportar_Grafico_Imagen.rst
    │   │
    │   ├── UC_RPT_05_Ver_Grafico_por_Dia/               # 7 FR
    │   │   ├── FR_RPT_05_01_Validar_Permiso_Graficos.rst
    │   │   ├── FR_RPT_05_02_Obtener_Datos_Por_Dia.rst
    │   │   ├── FR_RPT_05_03_Agregar_Metricas_Diarias.rst
    │   │   ├── FR_RPT_05_04_Renderizar_Grafico_Barras.rst
    │   │   ├── FR_RPT_05_05_Mostrar_Comparativa_Periodos.rst
    │   │   ├── FR_RPT_05_06_Calcular_Tendencia.rst
    │   │   └── FR_RPT_05_07_Exportar_Grafico_Imagen.rst
    │   │
    │   ├── UC_RPT_06_Ver_Distribucion_por_Centro/       # 7 FR
    │   │   ├── FR_RPT_06_01_Validar_Permiso_Graficos.rst
    │   │   ├── FR_RPT_06_02_Obtener_Datos_Por_Centro.rst
    │   │   ├── FR_RPT_06_03_Calcular_Porcentajes_Distribucion.rst
    │   │   ├── FR_RPT_06_04_Renderizar_Grafico_Pie.rst
    │   │   ├── FR_RPT_06_05_Mostrar_Leyenda_Centros.rst
    │   │   ├── FR_RPT_06_06_Permitir_Drill_Down.rst
    │   │   └── FR_RPT_06_07_Exportar_Grafico_Imagen.rst
    │   │
    │   ├── UC_RPT_07_Generar_Reporte_Trimestral/        # 8 FR
    │   │   ├── FR_RPT_07_01_Validar_Permiso_Reportes.rst
    │   │   ├── FR_RPT_07_02_Seleccionar_Trimestre.rst
    │   │   ├── FR_RPT_07_03_Validar_Datos_Trimestre_Completo.rst
    │   │   ├── FR_RPT_07_04_Calcular_Metricas_Trimestre.rst
    │   │   ├── FR_RPT_07_05_Generar_Comparativa_Anterior.rst
    │   │   ├── FR_RPT_07_06_Compilar_Documento_Reporte.rst
    │   │   ├── FR_RPT_07_07_Incluir_Graficos_Reporte.rst
    │   │   └── FR_RPT_07_08_Registrar_Generacion_Auditoria.rst
    │   │
    │   ├── UC_RPT_08_Generar_Reporte_Problemas_Menu/    # 8 FR
    │   │   ├── FR_RPT_08_01_Validar_Permiso_Reportes.rst
    │   │   ├── FR_RPT_08_02_Seleccionar_Rango_Fechas.rst
    │   │   ├── FR_RPT_08_03_Obtener_Datos_Problemas_Menu.rst
    │   │   ├── FR_RPT_08_04_Categorizar_Problemas.rst
    │   │   ├── FR_RPT_08_05_Calcular_Frecuencia_Problemas.rst
    │   │   ├── FR_RPT_08_06_Generar_Top_Problemas.rst
    │   │   ├── FR_RPT_08_07_Compilar_Documento_Reporte.rst
    │   │   └── FR_RPT_08_08_Registrar_Generacion_Auditoria.rst
    │   │
    │   ├── UC_RPT_09_Generar_Reporte_Transferencias/    # 8 FR
    │   │   ├── FR_RPT_09_01_Validar_Permiso_Reportes.rst
    │   │   ├── FR_RPT_09_02_Seleccionar_Rango_Fechas.rst
    │   │   ├── FR_RPT_09_03_Obtener_Datos_Transferencias.rst
    │   │   ├── FR_RPT_09_04_Calcular_Tasa_Transferencia.rst
    │   │   ├── FR_RPT_09_05_Agrupar_Por_Motivo.rst
    │   │   ├── FR_RPT_09_06_Agrupar_Por_Centro.rst
    │   │   ├── FR_RPT_09_07_Compilar_Documento_Reporte.rst
    │   │   └── FR_RPT_09_08_Registrar_Generacion_Auditoria.rst
    │   │
    │   ├── UC_RPT_10_Exportar_CSV/                      # 7 FR
    │   │   ├── FR_RPT_10_01_Validar_Permiso_Exportacion.rst
    │   │   ├── FR_RPT_10_02_Obtener_Datos_Filtrados.rst
    │   │   ├── FR_RPT_10_03_Validar_Limite_Registros.rst
    │   │   ├── FR_RPT_10_04_Generar_Archivo_CSV.rst
    │   │   ├── FR_RPT_10_05_Aplicar_Encoding_UTF8.rst
    │   │   ├── FR_RPT_10_06_Iniciar_Descarga.rst
    │   │   └── FR_RPT_10_07_Registrar_Exportacion_Auditoria.rst
    │   │
    │   ├── UC_RPT_11_Exportar_Excel/                    # 8 FR
    │   │   ├── FR_RPT_11_01_Validar_Permiso_Exportacion.rst
    │   │   ├── FR_RPT_11_02_Obtener_Datos_Filtrados.rst
    │   │   ├── FR_RPT_11_03_Validar_Limite_Registros.rst
    │   │   ├── FR_RPT_11_04_Crear_Workbook_Excel.rst
    │   │   ├── FR_RPT_11_05_Aplicar_Formato_Celdas.rst
    │   │   ├── FR_RPT_11_06_Incluir_Hoja_Resumen.rst
    │   │   ├── FR_RPT_11_07_Iniciar_Descarga.rst
    │   │   └── FR_RPT_11_08_Registrar_Exportacion_Auditoria.rst
    │   │
    │   ├── UC_RPT_12_Exportar_PDF/                      # 8 FR
    │   │   ├── FR_RPT_12_01_Validar_Permiso_Exportacion.rst
    │   │   ├── FR_RPT_12_02_Obtener_Datos_Filtrados.rst
    │   │   ├── FR_RPT_12_03_Validar_Limite_Registros.rst
    │   │   ├── FR_RPT_12_04_Generar_Documento_PDF.rst
    │   │   ├── FR_RPT_12_05_Incluir_Encabezado_Pie.rst
    │   │   ├── FR_RPT_12_06_Incluir_Graficos_PDF.rst
    │   │   ├── FR_RPT_12_07_Iniciar_Descarga.rst
    │   │   └── FR_RPT_12_08_Registrar_Exportacion_Auditoria.rst
    │   │
    │   ├── UC_RPT_13_Programar_Reporte/                 # 8 FR
    │   │   ├── FR_RPT_13_01_Validar_Permiso_Programacion.rst
    │   │   ├── FR_RPT_13_02_Seleccionar_Tipo_Reporte.rst
    │   │   ├── FR_RPT_13_03_Configurar_Frecuencia.rst
    │   │   ├── FR_RPT_13_04_Configurar_Parametros_Reporte.rst
    │   │   ├── FR_RPT_13_05_Seleccionar_Formato_Salida.rst
    │   │   ├── FR_RPT_13_06_Configurar_Destinatarios.rst
    │   │   ├── FR_RPT_13_07_Crear_Tarea_Programada.rst
    │   │   └── FR_RPT_13_08_Registrar_Programacion_Auditoria.rst
    │   │
    │   └── UC_RPT_14_Compartir_Dashboard/               # 7 FR
    │       ├── FR_RPT_14_01_Validar_Permiso_Compartir.rst
    │       ├── FR_RPT_14_02_Capturar_Estado_Dashboard.rst
    │       ├── FR_RPT_14_03_Generar_Link_Compartido.rst
    │       ├── FR_RPT_14_04_Configurar_Expiracion_Link.rst
    │       ├── FR_RPT_14_05_Seleccionar_Destinatarios.rst
    │       ├── FR_RPT_14_06_Crear_Notificacion_Interna.rst
    │       └── FR_RPT_14_07_Registrar_Compartido_Auditoria.rst
    │
    │ ══════════════════════════════════════════════════════════════════
    │ MOD_Alerts (5 UC = 40 FR)
    │ ══════════════════════════════════════════════════════════════════
    │
    ├── alerts/
    │   ├── index.rst
    │   │
    │   ├── UC_ALR_01_Crear_Alerta/                      # 8 FR
    │   │   ├── FR_ALR_01_01_Validar_Permiso_Crear_Alerta.rst
    │   │   ├── FR_ALR_01_02_Mostrar_Formulario_Alerta.rst
    │   │   ├── FR_ALR_01_03_Seleccionar_Tipo_Alerta.rst
    │   │   ├── FR_ALR_01_04_Configurar_Condicion_Umbral.rst
    │   │   ├── FR_ALR_01_05_Seleccionar_Metrica_Monitoreo.rst
    │   │   ├── FR_ALR_01_06_Configurar_Frecuencia_Evaluacion.rst
    │   │   ├── FR_ALR_01_07_Crear_Registro_Alerta.rst
    │   │   └── FR_ALR_01_08_Registrar_Creacion_Auditoria.rst
    │   │
    │   ├── UC_ALR_02_Modificar_Alerta/                  # 8 FR
    │   │   ├── FR_ALR_02_01_Validar_Permiso_Modificar_Alerta.rst
    │   │   ├── FR_ALR_02_02_Cargar_Configuracion_Actual.rst
    │   │   ├── FR_ALR_02_03_Validar_Campos_Modificados.rst
    │   │   ├── FR_ALR_02_04_Actualizar_Condicion_Umbral.rst
    │   │   ├── FR_ALR_02_05_Actualizar_Frecuencia.rst
    │   │   ├── FR_ALR_02_06_Activar_Desactivar_Alerta.rst
    │   │   ├── FR_ALR_02_07_Guardar_Cambios_Alerta.rst
    │   │   └── FR_ALR_02_08_Registrar_Modificacion_Auditoria.rst
    │   │
    │   ├── UC_ALR_03_Eliminar_Alerta/                   # 8 FR
    │   │   ├── FR_ALR_03_01_Validar_Permiso_Eliminar_Alerta.rst
    │   │   ├── FR_ALR_03_02_Verificar_Alerta_Existe.rst
    │   │   ├── FR_ALR_03_03_Solicitar_Confirmacion.rst
    │   │   ├── FR_ALR_03_04_Desactivar_Alerta.rst
    │   │   ├── FR_ALR_03_05_Marcar_Eliminacion_Logica.rst
    │   │   ├── FR_ALR_03_06_Cancelar_Evaluaciones_Pendientes.rst
    │   │   ├── FR_ALR_03_07_Preservar_Historial.rst
    │   │   └── FR_ALR_03_08_Registrar_Eliminacion_Auditoria.rst
    │   │
    │   ├── UC_ALR_04_Consultar_Historial_Alertas/       # 8 FR
    │   │   ├── FR_ALR_04_01_Validar_Permiso_Consulta_Historial.rst
    │   │   ├── FR_ALR_04_02_Listar_Alertas_Disparadas.rst
    │   │   ├── FR_ALR_04_03_Filtrar_Por_Tipo_Alerta.rst
    │   │   ├── FR_ALR_04_04_Filtrar_Por_Rango_Fechas.rst
    │   │   ├── FR_ALR_04_05_Filtrar_Por_Estado.rst
    │   │   ├── FR_ALR_04_06_Mostrar_Detalle_Disparo.rst
    │   │   ├── FR_ALR_04_07_Exportar_Historial.rst
    │   │   └── FR_ALR_04_08_Registrar_Consulta_Auditoria.rst
    │   │
    │   └── UC_ALR_05_Gestionar_Destinatarios/           # 8 FR
    │       ├── FR_ALR_05_01_Validar_Permiso_Gestionar_Destinatarios.rst
    │       ├── FR_ALR_05_02_Listar_Destinatarios_Alerta.rst
    │       ├── FR_ALR_05_03_Agregar_Destinatario.rst
    │       ├── FR_ALR_05_04_Validar_Usuario_Existe.rst
    │       ├── FR_ALR_05_05_Remover_Destinatario.rst
    │       ├── FR_ALR_05_06_Configurar_Canal_Notificacion.rst
    │       ├── FR_ALR_05_07_Guardar_Cambios_Destinatarios.rst
    │       └── FR_ALR_05_08_Registrar_Cambio_Auditoria.rst
    │
    │ ══════════════════════════════════════════════════════════════════
    │ MOD_Audit (4 UC = 36 FR)
    │ ══════════════════════════════════════════════════════════════════
    │
    ├── audit/
    │   ├── index.rst
    │   │
    │   ├── UC_AUD_01_Consultar_Auditoria/               # 9 FR
    │   │   ├── FR_AUD_01_01_Validar_Permiso_Consulta_Auditoria.rst
    │   │   ├── FR_AUD_01_02_Cargar_Vista_Auditoria.rst
    │   │   ├── FR_AUD_01_03_Listar_Eventos_Recientes.rst
    │   │   ├── FR_AUD_01_04_Aplicar_Filtro_Segmento.rst
    │   │   ├── FR_AUD_01_05_Mostrar_Resumen_Actividad.rst
    │   │   ├── FR_AUD_01_06_Paginar_Resultados.rst
    │   │   ├── FR_AUD_01_07_Mostrar_Detalle_Evento.rst
    │   │   ├── FR_AUD_01_08_Verificar_Inmutabilidad.rst
    │   │   └── FR_AUD_01_09_Registrar_Consulta_Auditoria.rst
    │   │
    │   ├── UC_AUD_02_Buscar_Auditoria/                  # 9 FR
    │   │   ├── FR_AUD_02_01_Validar_Permiso_Busqueda.rst
    │   │   ├── FR_AUD_02_02_Mostrar_Formulario_Busqueda.rst
    │   │   ├── FR_AUD_02_03_Filtrar_Por_Usuario.rst
    │   │   ├── FR_AUD_02_04_Filtrar_Por_Accion.rst
    │   │   ├── FR_AUD_02_05_Filtrar_Por_Entidad.rst
    │   │   ├── FR_AUD_02_06_Filtrar_Por_Rango_Fechas.rst
    │   │   ├── FR_AUD_02_07_Ejecutar_Busqueda.rst
    │   │   ├── FR_AUD_02_08_Mostrar_Resultados.rst
    │   │   └── FR_AUD_02_09_Registrar_Busqueda_Auditoria.rst
    │   │
    │   ├── UC_AUD_03_Exportar_Auditoria/                # 9 FR
    │   │   ├── FR_AUD_03_01_Validar_Permiso_Exportacion.rst
    │   │   ├── FR_AUD_03_02_Obtener_Datos_Filtrados.rst
    │   │   ├── FR_AUD_03_03_Validar_Limite_Registros.rst
    │   │   ├── FR_AUD_03_04_Seleccionar_Formato_Exportacion.rst
    │   │   ├── FR_AUD_03_05_Generar_Archivo_Exportacion.rst
    │   │   ├── FR_AUD_03_06_Incluir_Metadatos_Exportacion.rst
    │   │   ├── FR_AUD_03_07_Firmar_Exportacion_Hash.rst
    │   │   ├── FR_AUD_03_08_Iniciar_Descarga.rst
    │   │   └── FR_AUD_03_09_Registrar_Exportacion_Auditoria.rst
    │   │
    │   └── UC_AUD_04_Generar_Reporte_Compliance/        # 9 FR
    │       ├── FR_AUD_04_01_Validar_Permiso_Reporte_Compliance.rst
    │       ├── FR_AUD_04_02_Seleccionar_Periodo_Reporte.rst
    │       ├── FR_AUD_04_03_Obtener_Metricas_Compliance.rst
    │       ├── FR_AUD_04_04_Verificar_Politicas_Cumplidas.rst
    │       ├── FR_AUD_04_05_Identificar_Violaciones.rst
    │       ├── FR_AUD_04_06_Calcular_Indicadores_KPI.rst
    │       ├── FR_AUD_04_07_Generar_Documento_Reporte.rst
    │       ├── FR_AUD_04_08_Incluir_Evidencias.rst
    │       └── FR_AUD_04_09_Registrar_Generacion_Auditoria.rst
    │
    │ ══════════════════════════════════════════════════════════════════
    │ MOD_Logs (4 UC = 28 FR)
    │ ══════════════════════════════════════════════════════════════════
    │
    └── logs/
        ├── index.rst
        │
        ├── UC_LOG_01_Consultar_Logs/                    # 7 FR
        │   ├── FR_LOG_01_01_Validar_Permiso_Consulta_Logs.rst
        │   ├── FR_LOG_01_02_Cargar_Vista_Logs.rst
        │   ├── FR_LOG_01_03_Listar_Logs_Recientes.rst
        │   ├── FR_LOG_01_04_Mostrar_Nivel_Severidad.rst
        │   ├── FR_LOG_01_05_Paginar_Resultados.rst
        │   ├── FR_LOG_01_06_Mostrar_Detalle_Log.rst
        │   └── FR_LOG_01_07_Actualizar_Vista_Tiempo_Real.rst
        │
        ├── UC_LOG_02_Filtrar_Logs/                      # 7 FR
        │   ├── FR_LOG_02_01_Mostrar_Panel_Filtros.rst
        │   ├── FR_LOG_02_02_Filtrar_Por_Nivel.rst
        │   ├── FR_LOG_02_03_Filtrar_Por_Componente.rst
        │   ├── FR_LOG_02_04_Filtrar_Por_Rango_Fechas.rst
        │   ├── FR_LOG_02_05_Buscar_Por_Texto.rst
        │   ├── FR_LOG_02_06_Aplicar_Filtros_Combinados.rst
        │   └── FR_LOG_02_07_Limpiar_Filtros.rst
        │
        ├── UC_LOG_03_Exportar_Logs/                     # 7 FR
        │   ├── FR_LOG_03_01_Validar_Permiso_Exportacion_Logs.rst
        │   ├── FR_LOG_03_02_Obtener_Logs_Filtrados.rst
        │   ├── FR_LOG_03_03_Validar_Limite_Registros.rst
        │   ├── FR_LOG_03_04_Seleccionar_Formato_Exportacion.rst
        │   ├── FR_LOG_03_05_Generar_Archivo_Exportacion.rst
        │   ├── FR_LOG_03_06_Iniciar_Descarga.rst
        │   └── FR_LOG_03_07_Registrar_Exportacion_Auditoria.rst
        │
        └── UC_LOG_04_Configurar_Retencion/              # 7 FR
            ├── FR_LOG_04_01_Validar_Permiso_Configurar_Retencion.rst
            ├── FR_LOG_04_02_Mostrar_Configuracion_Actual.rst
            ├── FR_LOG_04_03_Validar_Periodo_Retencion.rst
            ├── FR_LOG_04_04_Aplicar_Limite_Maximo_2_Anos.rst
            ├── FR_LOG_04_05_Guardar_Configuracion.rst
            ├── FR_LOG_04_06_Programar_Purga_Automatica.rst
            └── FR_LOG_04_07_Registrar_Cambio_Auditoria.rst
```

---

# RESUMEN ESTADÍSTICO

## Conteo por Módulo

| Módulo | UC | FR por UC | Total FR |
|--------|----|-----------| ---------|
| MOD_Auth | 5 | 8+6+8+8+8 | **38** |
| MOD_Users | 4 | 8+8+8+8 | **32** |
| MOD_Access | 9 | 10+9+10+10+12+8+10+10+10 | **89** |
| MOD_Pipeline | 4 | 7+7+7+7 | **28** |
| MOD_Reports | 14 | 7+7+7+7+7+7+8+8+8+7+8+8+8+7 | **102** |
| MOD_Alerts | 5 | 8+8+8+8+8 | **40** |
| MOD_Audit | 4 | 9+9+9+9 | **36** |
| MOD_Logs | 4 | 7+7+7+7 | **28** |
| **TOTAL** | **49** | — | **393** |

## Conteo de Estructura

| Elemento | Cantidad |
|----------|----------|
| Archivos FR (.rst) | 393 |
| Archivos index.rst | 9 |
| Carpetas UC | 49 |
| Carpetas Módulo | 8 |
| **Total Archivos** | **402** |
| **Total Carpetas** | **58** |

---

*Anexo de Estructura FR v1.0.0*  
*Proyecto: IACT Call Center Analytics Dashboard*  
*Fecha: 2026-01-07*
