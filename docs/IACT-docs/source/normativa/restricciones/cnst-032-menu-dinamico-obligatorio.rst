.. meta::
 :artefacto: CNST_032
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-29
 :autor: NestorMonroy
 :clasificacion: Critico

.. _cnst-032:

===================================
CNST-032: Menu Dinamico Obligatorio
===================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_032
 * - **Categoria**
   - RBAC
 * - **Tipo (TXM_01)**
   - Tecnica
 * - **Criticidad**
   - Critico
 * - **Negociable**
   - No
 * - **Estado**
   - Vigente

1. Definicion
-------------

1.1 Enunciado
^^^^^^^^^^^^^

El frontend del sistema IACT DEBE invocar la funcion SQL nativa
``obtener_menu_usuario(user_id)`` para construir la estructura de
navegacion del usuario en cada inicio de sesion y al cambiar
permisos. Esta prohibido renderizar menu estatico, hardcoded o
calculado en frontend basado en roles enumerados.

1.2 Justificacion
^^^^^^^^^^^^^^^^^

Sin esta restriccion, el modelo RBAC plano (:doc:`cnst-029-rbac-modelo-plano`)
no tiene efecto visible en UX. Un usuario con permisos restringidos
veria el mismo menu completo que un admin y obtendria HTTP 403 al
hacer click en items no autorizados — experiencia degradada. El menu
dinamico hace visible el modelo de permisos en la UI: solo aparecen
items que el usuario realmente puede ejecutar.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Decision arquitectonica (D-RBAC-5)
- **Documento:** rbac-formalization.rst § 8 (WP #6 requisitos)
- **Fecha:** 2026-04-29

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^

El frontend obtiene la estructura del menu llamando al endpoint
``GET /api/permisos/verificar/<user_id>/menu/`` que internamente
invoca ``obtener_menu_usuario(user_id)``. La funcion SQL devuelve
JSON con la jerarquia ``dominio → subdominio → funcion → [acciones]``
calculada en tiempo real desde:

- Funciones obtenidas via grupos (``UsuarioGrupo`` →
  ``GrupoCapacidad`` → ``Capacidad``).
- Funciones obtenidas via permisos excepcionales vigentes
  (``PermisoExcepcional``).

El frontend renderiza solo los items presentes en el JSON devuelto.

2.2 Parametros
^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Parametro
   - Valor
 * - Endpoint
   - ``GET /api/permisos/verificar/<user_id>/menu/``
 * - Funcion SQL
   - ``obtener_menu_usuario(user_id INTEGER) RETURNS JSONB``
 * - Cache TTL
   - 0 (sin cache — siempre runtime)
 * - Refresh trigger
   - Inicio de sesion + cualquier cambio de permisos del usuario

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- PostgreSQL function ``obtener_menu_usuario`` (PL/pgSQL)
- Django REST Framework endpoint
- Frontend (React/Vue/cualquier UI): cliente que invoca el endpoint

3. Impacto en Sistema
---------------------

3.1 Modulos Afectados
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Modulo
   - Impacto
 * - MOD_Permissions
   - Implementa la funcion SQL y el endpoint REST
 * - Frontend (transversal)
   - Invoca el endpoint en bootstrap de sesion + on-change

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 35 65
 :header-rows: 1

 * - UC
   - Impacto
 * - :doc:`/requisitos/casos-uso/permissions/uc-perm-08/index`
   - Implementa la generacion de menu (CORE)
 * - :doc:`/requisitos/casos-uso/auth/uc-auth-01/index`
   - Tras login exitoso, frontend invoca el endpoint

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Renderizar menu hardcoded en frontend
- Calcular menu en frontend basado en lista de roles del usuario
- Cachear menu por mas de la sesion actual
- Asumir items de menu que no esten en la respuesta de
  ``obtener_menu_usuario``

4. Business Rules Derivadas
---------------------------

Sin BRs especificas mapeadas hoy. Pendiente catalogo BRs IACT
(WP requisitos v2 — Q-4).

5. Implementacion
-----------------

5.1 Codigo de Referencia
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

 # frontend (pseudo)
 async function bootstrapNavigation(userId) {
 const menu = await fetch(`/api/permisos/verificar/${userId}/menu/`);
 renderMenu(menu);
 }

 # backend (Django REST)
 class UserMenuView(APIView):
 def get(self, request, user_id):
 with connection.cursor as cursor:
 cursor.execute(
 "SELECT obtener_menu_usuario(%s)", [user_id]
 )
 return Response(cursor.fetchone[0])

5.2 Validacion de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

 # Verificar que la funcion SQL existe
 psql -c "\\df obtener_menu_usuario" iact_analytics

 # Verificar que el endpoint responde
 curl -H "Authorization: Bearer $TOKEN" \\
 http://localhost:8000/api/permisos/verificar/1/menu/

6. Excepciones
--------------

6.1 Excepciones Permitidas
^^^^^^^^^^^^^^^^^^^^^^^^^^

Sin excepciones permitidas. El modelo RBAC plano requiere que el menu
sea consistente con los permisos del usuario.

6.2 Proceso de Excepcion
^^^^^^^^^^^^^^^^^^^^^^^^

Cualquier solicitud de excepcion (ej: menu hardcoded por motivos de
performance) requiere ADR + revision de seguridad. Ver
:doc:`/normativa/procedimientos/proc-req-015-excepciones-cnst` (pendiente
de creacion en iteracion correspondiente).

7. Verificacion
---------------

7.1 Criterios de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- La funcion SQL ``obtener_menu_usuario`` existe en BD Analytics.
- El endpoint REST responde JSON valido con la estructura jerarquica.
- El frontend invoca el endpoint en bootstrap de sesion.
- No hay menu hardcoded en el codigo frontend.

7.2 Metodo de Verificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Tipo:** Mixto
- **Frecuencia:** Por deployment + audit trimestral
- **Herramienta:** Tests E2E + audit del codigo frontend

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-029-rbac-modelo-plano` (modelo base que este CNST hace visible),
     :doc:`cnst-033-vocabulario-unificado-rbac`
 * - **BR derivadas**
   - Pendiente WP requisitos
 * - **UCs afectados**
   - UC_PERM_08, UC_AUTH_01
 * - **MODs afectados**
   - MOD_Permissions, Frontend transversal
 * - **ADRs relacionados**
   - ADR-GOB-008 (RBAC Coexistencia, pendiente iteracion correspondiente)

9. Historial de Cambios
-----------------------

.. list-table::
 :widths: 12 15 25 48
 :header-rows: 1

 * - Version
   - Fecha
   - Autor
   - Cambios
 * - 1.0.0
   - 2026-04-29
   - NestorMonroy
   - Version inicial. Restriccion creada en iteracion correspondiente tras decision
     D-RBAC-5 del WP #6 (Hipotesis 1 RBAC Coexistencia).
