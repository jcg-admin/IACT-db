.. meta::
 :artefacto: CNST_008
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Alto

.. _cnst-008:

=======================================================
CNST-008: Sincronizacion ETL en Ventana de 6 a 12 Horas
=======================================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_008
 * - **Categoria**
   - Base de datos
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


La sincronizacion de datos desde BD IVR hacia BD Analytics SOLO PUEDE
ejecutarse mediante procesos ETL programados en ventanas de 6 a 12
horas. Esta prohibido el uso de mecanismos de tiempo real (CDC,
WebSockets, replicacion sincrona, polling agresivo).

1.2 Justificacion
^^^^^^^^^^^^^^^^^


Garantiza carga predecible sobre la BD IVR del cliente y permite
planificacion de mantenimiento. El sistema IACT esta disenado para
analisis historico, no para operacion en tiempo real.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Limitacion tecnica + carga predecible sobre cliente
- **Documento:** RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.rst:154-155
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^

(detalle en parametros)

2.2 Parametros
^^^^^^^^^^^^^^


- Frecuencia ETL: cada 6 a 12 horas.
- Ventana preferente: madrugada (02:00-04:00 hora local).
- Mecanismo: ``django-crontab`` o scheduler equivalente.
- Mecanismos prohibidos: Debezium, WebSockets, polling inferior a 6 h,
  triggers cross-database.

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- django-crontab
- Scheduler (cron / systemd timers)
- Modelo ETLRun para tracking

3. Impacto en Sistema
---------------------

3.1 Modulos Afectados
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Modulo
   - Impacto
 * - MOD_ETL
   - Implementa la sincronizacion programada
 * - MOD_Reports
   - Consume datos sincronizados

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - UC_025
   - Dashboard — muestra timestamp ultima ETL
 * - UC_017
   - Reportes — datos hasta ultima ventana ETL

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Usar Debezium o CDC
- Implementar replicacion sincrona
- Hacer polling con frecuencia < 6 horas
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


.. code-block:: python

 from etl.models import ETLRun
 last = ETLRun.objects.latest("finished_at")
 assert (now - last.finished_at).total_seconds <= 12 * 3600

5.2 Validacion de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ver seccion 5.1 (codigo de referencia es la validacion ejecutable).


6. Excepciones
--------------

6.1 Excepciones Permitidas
^^^^^^^^^^^^^^^^^^^^^^^^^^

- Reload manual de ETL por administrador (con aprobacion) en caso de incidente

6.2 Proceso de Excepcion
^^^^^^^^^^^^^^^^^^^^^^^^

Reload manual requiere aprobacion del administrador del sistema y queda registrado en auditoria.

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
- **Frecuencia:** Continuo (monitoreo de jobs)
- **Herramienta:** Alerta si ETLRun.latest no se ejecuto en > 12h

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-006-arquitectura-de-base-de-datos-dual`, :doc:`cnst-007-base-de-datos-ivr-es-solo-lectura`
 * - **BR derivadas**
   - Pendiente WP requisitos
 * - **UCs afectados**
   - UC_025, UC_017
 * - **MODs afectados**
   - MOD_ETL, MOD_Reports
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

