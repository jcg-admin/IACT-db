.. meta::
 :artefacto: CNST_007
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Critico

.. _cnst-007:

===========================================
CNST-007: Base de Datos IVR es Solo Lectura
===========================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_007
 * - **Categoria**
   - Base de datos
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


El sistema IACT NO PUEDE ejecutar ninguna operacion de escritura
(INSERT, UPDATE, DELETE, DDL) contra la BD IVR. La inmutabilidad
desde IACT es absoluta y sin excepciones tecnicas.

1.2 Justificacion
^^^^^^^^^^^^^^^^^


La BD IVR es propiedad del cliente; cualquier escritura desde IACT
violaria el contrato de no-intervencion y crearia riesgo legal y
operacional. La inmutabilidad se enforza en tres niveles: permisos
de BD, configuracion Django y middleware de aplicacion.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Contrato cliente (no-intervencion en BD origen)
- **Documento:** Contrato cliente — clausulas de proteccion de datos operacionales
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^


- Usuario MySQL de IACT en BD IVR: solo permisos ``SELECT``.
- Modelos Django de IVR: ``managed = False`` y ``Meta.permissions``
  vacio.
- Router Django bloquea ``allow_migrate`` y enruta escrituras de
  modelos IVR a un error explicito.
- Middleware intercepta queries de modificacion sobre alias ``ivr``
  y las rechaza con respuesta 500.

2.2 Parametros
^^^^^^^^^^^^^^

Ver subseccion 2.1.

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- MySQL GRANT SELECT
- Django Meta.managed = False
- Middleware de proteccion

3. Impacto en Sistema
---------------------

3.1 Modulos Afectados
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Modulo
   - Impacto
 * - MOD_Reports
   - Lee con select_related
 * - MOD_ETL
   - Lee bulk para sincronizacion

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - UC_017
   - Reporte Trimestral — solo lectura
 * - UC_025
   - Dashboard — solo lectura

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Ejecutar INSERT/UPDATE/DELETE/DDL contra BD IVR
- Hacer migrations sobre alias 'ivr'
- Aplicar triggers cross-database

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

 mysql -u iact_user -e "SHOW GRANTS FOR CURRENT_USER" | grep -v SELECT && exit 1 || exit 0

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

Sin excepciones — restriccion contractual absoluta.

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

- **Tipo:** Mixto
- **Frecuencia:** Continuo + revision trimestral de grants
- **Herramienta:** Test SHOW GRANTS + middleware de proteccion en runtime

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-006-arquitectura-de-base-de-datos-dual`, :doc:`cnst-008-sincronizacion-etl-en-ventana-de-6-a-12-horas`
 * - **BR derivadas**
   - Pendiente WP requisitos
 * - **UCs afectados**
   - UC_017, UC_025
 * - **MODs afectados**
   - MOD_Reports, MOD_ETL
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

