.. meta::
 :artefacto: RNF-PROC-002
 :tipo: Requisito No Funcional
 :dominio: requisitos
 :subdominio: requisitos-no-funcionales
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-28
 :ultimo_cambio: 2026-04-29
 :autor: Equipo IACT
 :clasificacion: Interno

.. _rnf-proc-002:

================================================================
RNF-PROC-002: Métricas y Reporting del SDLC (sin DORA)
================================================================

.. list-table::
   :header-rows: 1

   * - Campo
     - Valor
   * - **ID RNF**
     - RNF-PROC-002
   * - **Dominio**
     - Proceso / Métricas de entrega
   * - **Alcance**
     - Recolección y publicación de métricas internas de despliegue, incidentes y tiempo de ciclo del proyecto (sin esquema DORA).
   * - **Implementación**
     - Procedimiento descrito en ``docs/s cripts/metrics_and_reporting.rst`` y archivos JSON en ``logs_data/``.

--------------

1. Reglas de Medición
---------------------

- **Fuente única de verdad**: los datos de despliegues, incidentes y
  tiempos de ciclo deben almacenarse en los JSON de ``logs_data/`` con
  fecha y origen documentados.
- **Periodicidad**: actualizar los archivos al menos una vez por ciclo
  de release y registrar la fecha en el README de acompañamiento.
- **Integridad del dato**: cada actualización debe documentar el método
  de recolección y cualquier limitación conocida.

2. Procedimiento Operativo
--------------------------

.. list-table::
   :header-rows: 1

   * - Paso
     - Acción requerida
     - Evidencia
   * - **1**
     - Recopilar datos de despliegues, incidentes y cambios completados.
     - Datos incorporados en los JSON correspondientes.
   * - **2**
     - Actualizar ``logs_data/`` con los valores y anotar fecha/origen dentro del archivo o README asociado.
     - Commit con cambios en los JSON y notas de fecha.
   * - **3**
     - Registrar en el RTM e Índice de Trazabilidad el periodo cubierto y los indicadores reportados.
     - Entrada en índice con rango temporal.
   * - **4**
     - Generar análisis en ``docs/analisis/`` o carpeta equivalente cuando se requiera reporte narrativo.
     - Documento de análisis vinculado al RTM.

3. Criterios de Cumplimiento
----------------------------

- Las métricas deben estar disponibles para auditoría y ser
  reproducibles a partir de los datos en ``logs_data/``.
- Cualquier automatización futura (scripts ``metrics``) debe incluir
  pruebas unitarias y quedar documentada antes de habilitarse en CI/CD.
- Los reportes consumidos por dashboards deben citar este RNF y la
  ubicación exacta de los datos usados.
