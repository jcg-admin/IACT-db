.. meta::
   :artefacto: BReq_002
   :tipo: Business Requirement
   :dominio: requisitos
   :subdominio: objetivos
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-06
   :autor: Equipo IACT

.. _breq-002:

=======================================================
BReq_002: Reduccion de Tiempo de Respuesta a Incidentes
=======================================================


Resumen
-------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BReq-002
   * - **Nombre**
     - Reduccion de Tiempo de Respuesta a Incidentes
   * - **Categoria**
     - Eficiencia Operacional
   * - **Prioridad**
     - Alta
   * - **Estado**
     - Aprobado

----

1. Enunciado Formal
-------------------

El sistema DEBE reducir el tiempo de deteccion y respuesta a incidentes
operacionales mediante alertas proactivas basadas en umbrales configurables.

----

2. Metrica de Exito
-------------------

::

   Indicador: Tiempo de respuesta a incidentes
   Meta: Reduccion >= 40% vs linea base
   Linea Base: Tiempo promedio actual sin sistema de alertas
   Medicion: Tiempo desde ocurrencia hasta primera accion correctiva
   Frecuencia: Trimestral

----

3. Justificacion
----------------

La deteccion tardia de problemas operacionales (alta tasa de abandono,
colas saturadas, tiempos de espera excesivos) resulta en:

- Perdida de clientes que abandonan llamadas
- Deterioro de la calidad del servicio
- Incumplimiento de SLAs
- Costos operacionales elevados

Un sistema de alertas proactivo permite anticipar problemas antes
de que escalen significativamente.

----

4. BR que Influyen
------------------

.. list-table::
   :widths: 15 35 50
   :header-rows: 1

   * - BR
     - Nombre
     - Como Influye
   * - BR_014
     - Alerta por Umbral
     - Define mecanismo de deteccion automatica cuando metrica excede limite

----

5. UC que Genera
----------------

.. list-table::
   :widths: 15 35 50
   :header-rows: 1

   * - UC
     - Nombre
     - Relacion
   * - UC-036
     - Crear Alerta por Umbral
     - Configuracion de reglas de deteccion
   * - UC-037
     - Recibir Notificacion Alerta
     - Comunicacion inmediata al responsable
   * - UC-038
     - Consultar Historial Alertas
     - Registro para analisis de patrones
   * - UC-039
     - Modificar Configuracion Alerta
     - Ajuste fino de umbrales
   * - UC-040
     - Gestionar Destinatarios Alerta
     - Asegurar notificacion a personas correctas

----

6. Criterios de Aceptacion
--------------------------

1. Sistema permite definir al menos 10 tipos de alertas diferentes
2. Alertas se disparan en menos de 1 minuto tras exceder umbral
3. Notificaciones llegan a destinatarios via buzon interno
4. Historial de alertas disponible para analisis
5. Reduccion medible de tiempo de respuesta en prueba piloto

----

7. Stakeholders
---------------

- **Sponsor**: Gerencia de Operaciones
- **Beneficiarios**: Supervisores de Call Center
- **Usuarios**: AGR-005 gestor_alertas

----

8. Historial de Cambios
-----------------------

.. list-table::
   :widths: 15 15 20 50
   :header-rows: 1

   * - Version
     - Fecha
     - Autor
     - Descripcion del Cambio
   * - 1.0.0
     - 2026-01-06
     - Equipo IACT
     - Version inicial
