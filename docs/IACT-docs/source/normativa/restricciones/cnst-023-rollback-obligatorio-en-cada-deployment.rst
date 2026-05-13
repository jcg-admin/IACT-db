.. meta::
 :artefacto: CNST_023
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Critico

.. _cnst-023:

=================================================
CNST-023: Rollback Obligatorio en Cada Deployment
=================================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_023
 * - **Categoria**
   - Infraestructura
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


Todo deployment a produccion DEBE ser reversible mediante rollback
automatizado. Un deployment sin rollback documentado y probado NO
puede ejecutarse.

1.2 Justificacion
^^^^^^^^^^^^^^^^^


La reversion rapida de un deployment fallido es la diferencia entre
un incidente menor y una caida prolongada. Es responsabilidad del
deployer probar el rollback antes del go-live.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Politica de operacion + DR
- **Documento:** Politica de deployment IACT
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^


- Mecanismo: cambio de symlink ``current`` a release anterior +
  reload de Apache.
- Tiempo objetivo de rollback: <60 segundos.
- Migraciones que impidan rollback (drop column, drop table)
  requieren ADR explicito y plan de mitigacion.
- ``deploy.sh`` y ``rollback.sh`` deben coexistir y estar versionados.

2.2 Parametros
^^^^^^^^^^^^^^

Ver subseccion 2.1.

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- scripts/deploy.sh
- scripts/rollback.sh
- Apache reload

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
   - Deben ser rollback-compatible

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - (transversal)
   - Aplica a todo deployment

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Deploy sin rollback documentado y probado
- Migraciones destructivas sin ADR (drop column, drop table)
- Rollback > 60 segundos de RTO

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

 test -x scripts/rollback.sh
 bash scripts/rollback.sh --dry-run

5.2 Validacion de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ver seccion 5.1 (codigo de referencia es la validacion ejecutable).


6. Excepciones
--------------

6.1 Excepciones Permitidas
^^^^^^^^^^^^^^^^^^^^^^^^^^

- Migraciones destructivas con plan de mitigacion + ADR

6.2 Proceso de Excepcion
^^^^^^^^^^^^^^^^^^^^^^^^

Migracion destructiva requiere ADR explicito + ventana de mantenimiento programada + comunicacion previa.

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
- **Frecuencia:** Por release
- **Herramienta:** scripts/rollback.sh --dry-run en CI + smoke post-deploy

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

