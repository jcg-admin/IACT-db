.. meta::
   :artefacto: BR_014
   :tipo: Regla de Negocio
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :ultimo_cambio: 2026-01-07
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-014:

=========================
BR_014: Alerta por Umbral
=========================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BR_014
   * - **Nombre**
     - Alerta por Umbral
   * - **Tipo**
     - Desencadenador
   * - **Categoría**
     - Operacional / Monitoreo
   * - **Criticidad**
     - Alta
   * - **Estado**
     - Vigente

----

1. Definición Formal
--------------------

1.1 Enunciado de la Regla
^^^^^^^^^^^^^^^^^^^^^^^^^

.. note:: **Regla de Negocio BR_014**

   CUANDO una métrica del sistema supera o desciende por debajo de un umbral
   configurado, ENTONCES el sistema DEBE generar automáticamente una alerta
   y notificar a los destinatarios configurados mediante notificación in-app.

1.2 Formulación SBVR
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   VOCABULARIO:
     - metrica: Valor medible del sistema (tasa abandono, tiempo espera, etc.)
     - umbral: Valor límite configurado para una métrica
     - alerta: Notificación generada cuando se supera un umbral
     - destinatario: Usuario configurado para recibir alertas
     - notificacion_inapp: Mensaje interno del sistema (sin email/SMS)

   REGLA DESENCADENADORA:
     SI metrica SUPERA umbral_maximo
     O metrica DESCIENDE_POR_DEBAJO_DE umbral_minimo
     ENTONCES:
       1. Sistema DEBE crear registro de alerta
       2. Sistema DEBE notificar a destinatarios via notificacion_inapp
       3. Sistema DEBE registrar evento en auditoría

1.3 Justificación
^^^^^^^^^^^^^^^^^

Las alertas por umbral permiten:

- **Monitoreo proactivo**: Detectar problemas antes de que escalen
- **Respuesta rápida**: Notificar a responsables inmediatamente
- **Mejora continua**: Identificar tendencias y patrones
- **SLA compliance**: Garantizar niveles de servicio acordados

----

2. Clasificación
----------------

2.1 Tipo de Regla
^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 0

   * - **Tipo**
     - **Desencadenador**
   * - 
     - [X] **Desencadenador**: SI condición ENTONCES acción visible

2.2 Naturaleza
^^^^^^^^^^^^^^

- **Estática/Dinámica**: Dinámica - evaluada continuamente
- **Automatizable**: Sí - proceso batch o evento
- **Alcance**: MOD_Alerts y métricas de MOD_Reports

----

3. Aplicación en Sistema
------------------------

3.1 Donde Aplica
^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Componente
     - Descripción de Aplicación
   * - UC_ALR_01
     - Crear Alerta - Define umbral y destinatarios
   * - UC_ALR_02
     - Modificar Alerta - Ajusta umbrales
   * - Proceso ETL
     - Evalúa métricas post-carga contra umbrales

3.2 Métricas Monitoreables
^^^^^^^^^^^^^^^^^^^^^^^^^^

- Tasa de Abandono (> 15% = crítica)
- Tiempo Espera Promedio (> 120 seg = alta)
- Llamadas en Cola (> 50 = media)
- Disponibilidad ETL (< 99% = crítica)

----

4. Trazabilidad
---------------

- **Origen**: BReq_ALR_Alertas
- **UC Relacionados**: UC_ALR_01, UC_ALR_02, UC_ALR_04, UC_ALR_05
- **BR Relacionada**: BR_004 (notificación solo in-app)
- **CNST**: CNST_001 (sin email/SMS)

----

5. Historial de Cambios
-----------------------

.. list-table::
   :widths: 15 15 70
   :header-rows: 1

   * - Versión
     - Fecha
     - Descripción del Cambio
   * - 1.0.0
     - 2026-01-07
     - Versión inicial

----

*Documento versión 1.0.0 - Proyecto IACT Dashboard Analytics*
