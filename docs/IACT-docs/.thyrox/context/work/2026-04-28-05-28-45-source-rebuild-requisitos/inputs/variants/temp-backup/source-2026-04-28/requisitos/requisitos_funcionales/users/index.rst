.. meta::
   :dominio: requisitos
   :subdominio: funcionales/users
   :tipo: Indice
   :version: 1.0.0

.. _fr-users-index:

==================================
Requisitos Funcionales - MOD_Users
==================================

**Módulo:** MOD_Users - Gestión de Usuarios  
**UC Cubiertos:** UC_006 - UC_009  
**Total FR:** 17

----

Índice de FR por Caso de Uso
----------------------------

.. toctree::
   :maxdepth: 2
   :caption: UC_006: Crear Usuario (5 FR)

   UC_006_Crear_Usuario/FR-006.01_Validar_campos_obligatorios
   UC_006_Crear_Usuario/FR-006.02_Verificar_unicidad_username
   UC_006_Crear_Usuario/FR-006.03_Generar_password_temporal
   UC_006_Crear_Usuario/FR-006.04_Crear_registro_usuario
   UC_006_Crear_Usuario/FR-006.05_Registrar_auditoria

.. toctree::
   :maxdepth: 2
   :caption: UC_007: Modificar Usuario (4 FR)

   UC_007_Modificar_Usuario/FR-007.01_Cargar_datos_usuario
   UC_007_Modificar_Usuario/FR-007.02_Validar_campos_modificados
   UC_007_Modificar_Usuario/FR-007.03_Actualizar_registro
   UC_007_Modificar_Usuario/FR-007.04_Registrar_cambios_auditoria

.. toctree::
   :maxdepth: 2
   :caption: UC_008: Dar de Baja Usuario (4 FR)

   UC_008_Baja_Usuario/FR-008.01_Validar_usuario_activo
   UC_008_Baja_Usuario/FR-008.02_Cambiar_estado_INACTIVO
   UC_008_Baja_Usuario/FR-008.03_Invalidar_sesiones
   UC_008_Baja_Usuario/FR-008.04_Preservar_registro_historico

.. toctree::
   :maxdepth: 2
   :caption: UC_009: Listar Usuarios (4 FR)

   UC_009_Listar_Usuarios/FR-009.01_Obtener_lista_paginada
   UC_009_Listar_Usuarios/FR-009.02_Aplicar_filtros
   UC_009_Listar_Usuarios/FR-009.03_Ordenar_resultados
   UC_009_Listar_Usuarios/FR-009.04_Mostrar_indicador_inactividad

----

Resumen Estadístico
-------------------

.. list-table::
   :widths: 40 20 20 20
   :header-rows: 1

   * - Caso de Uso
     - FR
     - Prioridad
     - Complejidad
   * - UC_006: Crear Usuario
     - 5
     - Alta
     - Media
   * - UC_007: Modificar Usuario
     - 4
     - Alta
     - Baja
   * - UC_008: Dar de Baja Usuario
     - 4
     - Alta
     - Baja
   * - UC_009: Listar Usuarios
     - 4
     - Media
     - Baja
   * - **TOTAL**
     - **17**
     - —
     - —
