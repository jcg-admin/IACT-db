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

 uc-001-iniciar-sesion/fr-001-01-validar-formato-username
 uc-001-iniciar-sesion/fr-001-02-validar-credenciales
 uc-001-iniciar-sesion/fr-001-03-generar-token-jwt
 uc-001-iniciar-sesion/fr-001-04-invalidar-sesiones-previas
 uc-001-iniciar-sesion/fr-001-05-registrar-evento-auditoria

.. toctree::
 :maxdepth: 2
 :caption: UC_002: Cerrar Sesion (3 FR)

 uc-002-cerrar-sesion/fr-002-01-invalidar-token-jwt
 uc-002-cerrar-sesion/fr-002-02-registrar-evento-logout
 uc-002-cerrar-sesion/fr-002-03-limpiar-datos-sesion-cliente

.. toctree::
 :maxdepth: 2
 :caption: UC_003: Recuperar Password (5 FR)

 uc-003-recuperar-password/fr-003-01-validar-username-existe
 uc-003-recuperar-password/fr-003-02-mostrar-pregunta-seguridad
 uc-003-recuperar-password/fr-003-03-validar-respuesta
 uc-003-recuperar-password/fr-003-04-generar-password-temporal
 uc-003-recuperar-password/fr-003-05-forzar-cambio-siguiente-login

.. toctree::
 :maxdepth: 2
 :caption: UC_004: Cambiar Password (4 FR)

 uc-004-cambiar-password/fr-004-01-validar-password-actual
 uc-004-cambiar-password/fr-004-02-validar-complejidad-nuevo-password
 uc-004-cambiar-password/fr-004-03-actualizar-hash-bd
 uc-004-cambiar-password/fr-004-04-invalidar-sesiones

.. toctree::
 :maxdepth: 2
 :caption: UC_005: Gestionar Sesiones (4 FR)

 uc-005-gestionar-sesiones/fr-005-01-listar-sesiones-activas
 uc-005-gestionar-sesiones/fr-005-02-mostrar-detalle-sesion
 uc-005-gestionar-sesiones/fr-005-03-invalidar-sesion-individual
 uc-005-gestionar-sesiones/fr-005-04-invalidar-sesiones-por-usuario

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