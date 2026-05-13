.. meta::
 :artefacto: CNST_002
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Critico

.. _cnst-002:

===================================
CNST-002: Buzon Interno Obligatorio
===================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_002
 * - **Categoria**
   - Comunicaciones
 * - **Tipo (TXM_01)**
   - Negocio
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


Toda notificacion del sistema IACT a usuarios DEBE entregarse a traves
del buzon interno de la aplicacion, con limites cuantitativos
estrictos sobre alcance, consolidacion y frecuencia de evaluacion.

1.2 Justificacion
^^^^^^^^^^^^^^^^^


Garantiza un canal unico, auditable y bajo control del sistema,
alineado con :doc:`cnst-001-prohibicion-de-email-y-smtp`. Previene
saturacion del buzon, fatiga de alertas y abuso del canal.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Restriccion de negocio (cliente) + complemento operativo
- **Documento:** RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.rst:701-704
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^


- Modelo ``InternalMessage`` con campos ``recipient``, ``subject``,
  ``body``, ``priority`` y ``read_at``.
- Alertas del mismo tipo y metrica disparadas en menos de 1 hora se
  consolidan en un unico mensaje.
- Una alerta no admite mas de 50 destinatarios simultaneos.
- La evaluacion de condiciones corre en intervalos de 5 a 15 minutos.

2.2 Parametros
^^^^^^^^^^^^^^


.. list-table::
 :header-rows: 1
 :widths: 50 50

 * - Parametro
   - Valor
 * - Maximo destinatarios por alerta
   - 50 usuarios
 * - Ventana de consolidacion de alertas iguales
   - 1 hora
 * - Frecuencia de evaluacion de condiciones
   - cada 5-15 minutos (no real-time)
 * - Otros canales permitidos
   - ninguno (sin SMS, push ni webhooks)

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Modelo InternalMessage (Django)
- Scheduler tipo django-crontab para evaluacion 5-15 min
- Cola Celery para batching

3. Impacto en Sistema
---------------------

3.1 Modulos Afectados
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Modulo
   - Impacto
 * - MOD_Notifications
   - Implementa InternalMessage, batching y limites operativos

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - UC_036
   - Configurar Alertas
 * - UC_037
   - Recibir Notificacion
 * - UC_038
   - Marcar Alerta como Leida
 * - UC_039
   - Archivar Alerta
 * - UC_040
   - Consultar Historial de Alertas

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Enviar alertas a mas de 50 destinatarios simultaneos
- Evaluar alertas en tiempo real (<5 min)
- Usar canales paralelos (SMS, push, webhooks)

4. Business Rules Derivadas
---------------------------

.. list-table::
 :widths: 20 40 40
 :header-rows: 1

 * - BR
   - Nombre
   - Relacion
 * - BR (pendiente)
   - Limites operativos de alertas
   - Pendiente WP requisitos

5. Implementacion
-----------------

5.1 Codigo de Referencia
^^^^^^^^^^^^^^^^^^^^^^^^


.. code-block:: python

 assert max_recipients(alert) <= 50
 assert dedup_window_hours == 1
 assert evaluation_interval_minutes in range(5, 16)

5.2 Validacion de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ver seccion 5.1 (codigo de referencia es la validacion ejecutable).


6. Excepciones
--------------

6.1 Excepciones Permitidas
^^^^^^^^^^^^^^^^^^^^^^^^^^

- Alertas operativas criticas pueden tener vigencia 6m + 2a archivado (RESTRICCIONES:704)

6.2 Proceso de Excepcion
^^^^^^^^^^^^^^^^^^^^^^^^

Modificacion del modelo de alertas requiere ADR + aprobacion Tech Lead.

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
- **Frecuencia:** Continuo (tests + lint)
- **Herramienta:** Tests unitarios sobre AlertService.send + chequeo de configuracion del scheduler

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-001-prohibicion-de-email-y-smtp`, :doc:`cnst-008-sincronizacion-etl-en-ventana-de-6-a-12-horas`
 * - **BR derivadas**
   - BR (pendiente)
 * - **UCs afectados**
   - UC_036, UC_037, UC_038, UC_039, UC_040
 * - **MODs afectados**
   - MOD_Notifications
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

