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

 uc-006-crear-usuario/fr-006-01-validar-campos-obligatorios
 uc-006-crear-usuario/fr-006-02-verificar-unicidad-username
 uc-006-crear-usuario/fr-006-03-generar-password-temporal
 uc-006-crear-usuario/fr-006-04-crear-registro-usuario
 uc-006-crear-usuario/fr-006-05-registrar-auditoria

.. toctree::
 :maxdepth: 2
 :caption: UC_007: Modificar Usuario (4 FR)

 uc-007-modificar-usuario/fr-007-01-cargar-datos-usuario
 uc-007-modificar-usuario/fr-007-02-validar-campos-modificados
 uc-007-modificar-usuario/fr-007-03-actualizar-registro
 uc-007-modificar-usuario/fr-007-04-registrar-cambios-auditoria

.. toctree::
 :maxdepth: 2
 :caption: UC_008: Dar de Baja Usuario (4 FR)

 uc-008-baja-usuario/fr-008-01-validar-usuario-activo
 uc-008-baja-usuario/fr-008-02-cambiar-estado-inactivo
 uc-008-baja-usuario/fr-008-03-invalidar-sesiones
 uc-008-baja-usuario/fr-008-04-preservar-registro-historico

.. toctree::
 :maxdepth: 2
 :caption: UC_009: Listar Usuarios (4 FR)

 uc-009-listar-usuarios/fr-009-01-obtener-lista-paginada
 uc-009-listar-usuarios/fr-009-02-aplicar-filtros
 uc-009-listar-usuarios/fr-009-03-ordenar-resultados
 uc-009-listar-usuarios/fr-009-04-mostrar-indicador-inactividad

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
