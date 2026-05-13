.. meta::
 :artefacto: CNST_011
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Alto

.. _cnst-011:

======================================================
CNST-011: Throttling Obligatorio en Endpoints Publicos
======================================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_011
 * - **Categoria**
   - Seguridad DRF
 * - **Tipo (TXM_01)**
   - Tecnica
 * - **Criticidad**
   - Alto
 * - **Negociable**
   - No
 * - **Estado**
   - Vigente

1. Definicion
-------------

1.1 Enunciado
^^^^^^^^^^^^^


Todo endpoint publico (login, recuperacion de password, exportaciones)
DEBE tener throttling activo. Las clases de throttling son
obligatorias y configuradas con limites especificos por tipo de
endpoint.

1.2 Justificacion
^^^^^^^^^^^^^^^^^


Previene ataques de fuerza bruta, scraping y abuso de recursos.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Mitigacion de fuerza bruta + scraping
- **Documento:** RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.rst:225-228
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^

(detalle en parametros)

2.2 Parametros
^^^^^^^^^^^^^^


.. list-table::
 :header-rows: 1
 :widths: 50 25 25

 * - Endpoint
   - Limite
   - Scope
 * - Login
   - 5/min/IP
   - ``login``
 * - Recuperacion de password
   - 3/hora/IP
   - ``recovery``
 * - Exportacion de reportes
   - segun :doc:`cnst-020-throttling-de-exportaciones-por-formato`
   - ``exports``
 * - API general autenticada
   - 100/min/usuario
   - ``user``

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- DRF DEFAULT_THROTTLE_CLASSES
- AnonRateThrottle / UserRateThrottle / ScopedRateThrottle

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
   - Throttle en login y recovery
 * - MOD_Reports
   - Throttle en exportaciones

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - UC_001
   - Login throttled 5/5min/IP
 * - UC_022..024
   - Exports throttled segun CNST_020
 * - UC_003
   - Recovery throttled 3/h/IP

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Exponer endpoints publicos sin throttle
- Permitir scraping masivo sin rate limit

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

 from rest_framework.settings import api_settings
 assert "DEFAULT_THROTTLE_CLASSES" in api_settings.user_settings

5.2 Validacion de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ver seccion 5.1 (codigo de referencia es la validacion ejecutable).


6. Excepciones
--------------

6.1 Excepciones Permitidas
^^^^^^^^^^^^^^^^^^^^^^^^^^

- Cuentas de servicio (system) con scope dedicado y rate limit propio

6.2 Proceso de Excepcion
^^^^^^^^^^^^^^^^^^^^^^^^

Excepciones requieren ADR + revision por equipo de seguridad.

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
- **Frecuencia:** Continuo (tests de carga + smoke)
- **Herramienta:** Tests que verifican respuesta 429 al exceder limites

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-020-throttling-de-exportaciones-por-formato`
 * - **BR derivadas**
   - Pendiente WP requisitos
 * - **UCs afectados**
   - UC_001, UC_022..024, UC_003
 * - **MODs afectados**
   - MOD_Auth, MOD_Reports
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

