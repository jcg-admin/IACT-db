.. meta::
 :artefacto: CNST_018
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Alto

.. _cnst-018:

============================================
CNST-018: Rango Maximo de Consulta de 2 Anos
============================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_018
 * - **Categoria**
   - Performance
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


Toda consulta de reporte, dashboard o exportacion DEBE acotarse a un
rango maximo de 2 anos (730 dias) entre ``fecha_inicio`` y
``fecha_fin``. La validacion del rango debe ocurrir ANTES de ejecutar
la query.

1.2 Justificacion
^^^^^^^^^^^^^^^^^


Consultas de mas de 2 anos sobre datos de IVR pueden escanear
millones de registros, generan timeouts, bloquean recursos y rara
vez son utiles desde el punto de vista de negocio.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Performance + utilidad de negocio
- **Documento:** RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.rst:761
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^

(detalle en parametros)

2.2 Parametros
^^^^^^^^^^^^^^


- ``MAX_QUERY_DAYS = 730``.
- Excepcion permitida: rol ``ADMIN_ANALITICA`` con job offline (no
  consulta interactiva).

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Validacion en serializer
- Constants module: MAX_QUERY_DAYS = 730

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
   - Validacion en serializer
 * - MOD_Common
   - Define constante

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - UC_020
   - Filtros Fecha — valida rango
 * - UC_017..019
   - Reportes — validan rango antes de consultar

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Permitir consultas con rango > 730 dias
- Validar el rango despues de ejecutar la query

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

 if (date_end - date_start).days > 730:
 raise ValidationError("rango maximo 730 dias (2 anos)")

5.2 Validacion de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ver seccion 5.1 (codigo de referencia es la validacion ejecutable).


6. Excepciones
--------------

6.1 Excepciones Permitidas
^^^^^^^^^^^^^^^^^^^^^^^^^^

- Rol ADMIN_ANALITICA con job offline (no consulta interactiva)

6.2 Proceso de Excepcion
^^^^^^^^^^^^^^^^^^^^^^^^

Excepcion solo via job offline pre-aprobado, no en path de request.

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
- **Frecuencia:** Continuo
- **Herramienta:** Tests de validacion en serializers de reportes

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-017-sla-de-tiempos-de-respuesta`, :doc:`cnst-019-exportaciones-asincronas-sobre-10k-registros`
 * - **BR derivadas**
   - Pendiente WP requisitos
 * - **UCs afectados**
   - UC_020, UC_017..019
 * - **MODs afectados**
   - MOD_Reports, MOD_Common
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

