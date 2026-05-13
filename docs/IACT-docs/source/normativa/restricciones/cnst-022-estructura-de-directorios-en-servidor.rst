.. meta::
 :artefacto: CNST_022
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Medio

.. _cnst-022:

===============================================
CNST-022: Estructura de Directorios en Servidor
===============================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_022
 * - **Categoria**
   - Infraestructura
 * - **Tipo (TXM_01)**
   - Tecnica
 * - **Criticidad**
   - Medio
 * - **Negociable**
   - No
 * - **Estado**
   - Vigente

1. Definicion
-------------

1.1 Enunciado
^^^^^^^^^^^^^


El despliegue del sistema IACT en servidor DEBE seguir una estructura
de directorios fija para garantizar previsibilidad de operaciones,
backups y rollback.

1.2 Justificacion
^^^^^^^^^^^^^^^^^


La estrategia tipo Capistrano permite rollback atomico (cambiar
symlink) y aisla artefactos compartidos del codigo de cada release.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Buenas practicas de deployment (Capistrano-like)
- **Documento:** Convencion de deployment IACT
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^


::

 /opt/iact/
 |-- current/ -> symlink al release activo
 |-- releases/
 | |-- 2026-04-28-001/
 | |-- 2026-04-28-002/
 | `-- ...
 |-- shared/
 | |-- media/
 | |-- logs/
 | `-- env/
 `-- venv/

2.2 Parametros
^^^^^^^^^^^^^^

Ver subseccion 2.1.

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Symlink current -> release
- rsync para releases
- shared/ para artefactos persistentes

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
   - Se despliegan en esta estructura

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - (transversal)
   - Aplica a deployment

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Sobrescribir el release activo
- Compartir media/ entre releases sin symlink
- Mezclar codigo y datos en el mismo path

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

 test -L /opt/iact/current && echo "OK"
 readlink /opt/iact/current

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

Sin excepciones — estructura fija.

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

- **Tipo:** Manual + Automatico
- **Frecuencia:** Por release
- **Herramienta:** Smoke test post-deploy verifica estructura

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-021-stack-obligatorio-ubuntu-apache-mod-wsgi`, :doc:`cnst-023-rollback-obligatorio-en-cada-deployment`
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

