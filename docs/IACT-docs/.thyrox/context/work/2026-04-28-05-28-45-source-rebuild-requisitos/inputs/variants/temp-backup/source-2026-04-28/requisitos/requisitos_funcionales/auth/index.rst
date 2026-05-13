.. meta::
   :dominio: requisitos
   :subdominio: funcionales/auth
   :tipo: Indice
   :version: 1.0.0

.. _fr-auth-index:

=================================
Requisitos Funcionales - MOD_Auth
=================================

**Módulo:** MOD_Auth - Autenticación y Sesiones
**UC Cubiertos:** UC_001 - UC_005
**Total FR:** 21

----

Índice de FR por Caso de Uso
----------------------------

.. toctree::
   :maxdepth: 2
   :caption: UC_001: Iniciar Sesion (5 FR)

   UC_001_Iniciar_Sesion/FR-001.01_Validar_formato_username
   UC_001_Iniciar_Sesion/FR-001.02_Validar_credenciales
   UC_001_Iniciar_Sesion/FR-001.03_Generar_token_JWT
   UC_001_Iniciar_Sesion/FR-001.04_Invalidar_sesiones_previas
   UC_001_Iniciar_Sesion/FR-001.05_Registrar_evento_auditoria

.. toctree::
   :maxdepth: 2
   :caption: UC_002: Cerrar Sesion (3 FR)

   UC_002_Cerrar_Sesion/FR-002.01_Invalidar_token_JWT
   UC_002_Cerrar_Sesion/FR-002.02_Registrar_evento_logout
   UC_002_Cerrar_Sesion/FR-002.03_Limpiar_datos_sesion_cliente

.. toctree::
   :maxdepth: 2
   :caption: UC_003: Recuperar Password (5 FR)

   UC_003_Recuperar_Password/FR-003.01_Validar_username_existe
   UC_003_Recuperar_Password/FR-003.02_Mostrar_pregunta_seguridad
   UC_003_Recuperar_Password/FR-003.03_Validar_respuesta
   UC_003_Recuperar_Password/FR-003.04_Generar_password_temporal
   UC_003_Recuperar_Password/FR-003.05_Forzar_cambio_siguiente_login

.. toctree::
   :maxdepth: 2
   :caption: UC_004: Cambiar Password (4 FR)

   UC_004_Cambiar_Password/FR-004.01_Validar_password_actual
   UC_004_Cambiar_Password/FR-004.02_Validar_complejidad_nuevo_password
   UC_004_Cambiar_Password/FR-004.03_Actualizar_hash_BD
   UC_004_Cambiar_Password/FR-004.04_Invalidar_sesiones

.. toctree::
   :maxdepth: 2
   :caption: UC_005: Gestionar Sesiones (4 FR)

   UC_005_Gestionar_Sesiones/FR-005.01_Listar_sesiones_activas
   UC_005_Gestionar_Sesiones/FR-005.02_Mostrar_detalle_sesion
   UC_005_Gestionar_Sesiones/FR-005.03_Invalidar_sesion_individual
   UC_005_Gestionar_Sesiones/FR-005.04_Invalidar_sesiones_por_usuario

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
   * - UC_001: Iniciar Sesion
     - 5
     - Alta
     - Media
   * - UC_002: Cerrar Sesion
     - 3
     - Alta
     - Baja
   * - UC_003: Recuperar Password
     - 5
     - Alta
     - Media
   * - UC_004: Cambiar Password
     - 4
     - Alta
     - Baja
   * - UC_005: Gestionar Sesiones
     - 4
     - Media
     - Media
   * - **TOTAL**
     - **21**
     - —
     - —