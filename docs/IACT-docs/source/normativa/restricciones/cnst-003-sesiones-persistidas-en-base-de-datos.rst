.. meta::
 :artefacto: CNST_003
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Critico

.. _cnst-003:

===============================================
CNST-003: Sesiones Persistidas en Base de Datos
===============================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_003
 * - **Categoria**
   - Sesiones
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


Las sesiones de usuario DEBEN almacenarse en la base de datos
relacional. Esta prohibido el uso de cookies firmadas, cache externo
(Redis, Memcached) o cualquier mecanismo distinto a la BD para
persistencia de sesion.

1.2 Justificacion
^^^^^^^^^^^^^^^^^


Permite auditoria centralizada, revocacion inmediata y elimina
dependencias de servicios externos para una funcion critica de
seguridad.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Limitacion tecnica + politica de seguridad
- **Documento:** Politica de gestion de sesiones IACT
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^


- Engine obligatorio: ``django.contrib.sessions.backends.db``.
- Tabla principal: ``django_session`` (Django default).
- Tabla auxiliar de auditoria: ``UserSession`` con campos ``user``,
  ``ip``, ``user_agent``, ``last_activity``, ``is_active``.

2.2 Parametros
^^^^^^^^^^^^^^

Ver subseccion 2.1.

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- django.contrib.sessions.backends.db
- Tabla django_session (Django default)
- Modelo UserSession (auditoria)

3. Impacto en Sistema
---------------------

3.1 Modulos Afectados
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Modulo
   - Impacto
 * - MOD_Auth
   - Implementa session backend DB
 * - MOD_Audit
   - Consume UserSession para auditoria

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - UC_001
   - Iniciar Sesion
 * - UC_002
   - Cerrar Sesion
 * - UC_005
   - Gestion de Sesiones

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Almacenar sesiones en cookies firmadas
- Usar Redis o Memcached como session backend
- Persistir sesiones en sistemas externos

4. Business Rules Derivadas
---------------------------

Sin BRs especificas mapeadas a esta CNST en la base cognitiva actual.
El catalogo BR_NNN del dominio IACT esta pendiente de elaborar en
el WP de requisitos (deuda diferida).

5. Implementacion
-----------------

5.1 Codigo de Referencia
^^^^^^^^^^^^^^^^^^^^^^^^


.. code-block:: python

 from django.conf import settings
 assert settings.SESSION_ENGINE == "django.contrib.sessions.backends.db"

5.2 Validacion de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ver seccion 5.1 (codigo de referencia es la validacion ejecutable).


6. Excepciones
--------------

6.1 Excepciones Permitidas
^^^^^^^^^^^^^^^^^^^^^^^^^^

Sin excepciones permitidas.

6.2 Proceso de Excepcion
^^^^^^^^^^^^^^^^^^^^^^^^

Sin excepciones — restriccion tecnica absoluta. Cambios requieren ADR + revision de seguridad.

El protocolo formal de waiver de CNSTs esta pendiente de elaborar en
el WP de gobernanza (`PROC_Excepciones_CNST` — ver
(referencia interna) § W-4).

7. Verificacion
---------------

7.1 Criterios de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El cumplimiento se verifica via los snippets de la seccion 5.

7.2 Metodo de Verificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Tipo:** Automatico
- **Frecuencia:** Por deployment
- **Herramienta:** Test que valida settings.SESSION_ENGINE en CI

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-004-sesion-unica-por-usuario`, :doc:`cnst-005-timeout-de-sesion-de-15-minutos`
 * - **BR derivadas**
   - Pendiente WP requisitos
 * - **UCs afectados**
   - UC_001, UC_002, UC_005
 * - **MODs afectados**
   - MOD_Auth, MOD_Audit
 * - **ADRs relacionados**
   - Pendiente WP arquitectura tecnica

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
   - 2025-12-17
   - NestorMonroy
   - Version inicial (consolidada del backup canonico)
 * - 2.0.0
   - 2026-04-28
   - NestorMonroy
   - Descomposicion SRP (un concern por archivo) + enriquecimiento estructura completa TPL_CNST (9 secciones)

