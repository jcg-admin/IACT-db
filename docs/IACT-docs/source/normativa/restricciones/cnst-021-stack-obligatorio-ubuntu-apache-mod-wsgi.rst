.. meta::
 :artefacto: CNST_021
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Alto

.. _cnst-021:

==================================================
CNST-021: Stack Obligatorio Ubuntu Apache mod_wsgi
==================================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_021
 * - **Categoria**
   - Infraestructura
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


El sistema IACT DEBE desplegarse sobre el stack Ubuntu Server +
Apache HTTP Server + ``mod_wsgi`` + Python 3.x. Esta prohibido el uso
de stacks alternativos en produccion.

1.2 Justificacion
^^^^^^^^^^^^^^^^^


Restriccion del cliente: la operacion del cliente esta estandarizada
sobre Ubuntu+Apache. Cambiar el stack obligaria a re-certificar el
ambiente y rompe SLAs operativos del cliente.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Restriccion del cliente (estandar operativo)
- **Documento:** Contrato cliente — stack obligatorio
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^


- OS: Ubuntu Server LTS (22.04 o superior).
- HTTP: Apache 2.4+ con ``mod_wsgi`` (no Nginx, no Caddy).
- WSGI: ``mod_wsgi`` (no Gunicorn, no uWSGI).
- Python: 3.10+ instalado en virtualenv.

2.2 Parametros
^^^^^^^^^^^^^^

Ver subseccion 2.1.

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Ubuntu Server LTS 22.04+
- Apache 2.4+
- mod_wsgi
- Python 3.10+
- virtualenv

3. Impacto en Sistema
---------------------

3.1 Modulos Afectados
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Modulo
   - Impacto
 * - (todos)
   - Corren sobre este stack

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - (transversal)
   - Aplica a todo el deployment

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Usar Nginx o Caddy
- Usar Gunicorn o uWSGI
- Containerizar con Docker en produccion (sin ADR)

4. Business Rules Derivadas
---------------------------

Sin BRs especificas mapeadas a esta CNST en la base cognitiva actual.
El catalogo BR_NNN del dominio IACT esta pendiente de elaborar en
el WP de requisitos (deuda diferida).

5. Implementacion
-----------------

5.1 Codigo de Referencia
^^^^^^^^^^^^^^^^^^^^^^^^


.. code-block:: bash

 apache2 -v | grep "Apache/2"
 apt list --installed | grep libapache2-mod-wsgi-py3

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

Cambio de stack requiere modificacion contractual con el cliente.

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

- **Tipo:** Manual
- **Frecuencia:** Por release
- **Herramienta:** Smoke test de deployment + verificacion manual del stack

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-022-estructura-de-directorios-en-servidor`
 * - **BR derivadas**
   - Pendiente WP requisitos
 * - **UCs afectados**
   - (transversal)
 * - **MODs afectados**
   - (todos)
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

