.. meta::
 :artefacto: BR_016
 :tipo: Regla de Negocio
 :dominio: requisitos
 :subdominio: reglas_negocio
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-29
 :autor: NestorMonroy
 :clasificacion: Alto

.. _br-016:

========================
BR_016: Tasa de Abandono
========================

1. Definicion
-------------

La **Tasa de Abandono** es una metrica calculada que mide el
porcentaje de llamadas que el cliente abandona antes de ser
atendidas por un agente. Es uno de los KPI principales del sistema
IVR/Call Center.

**Formula:**

.. code-block:: text

 tasa_abandono = (llamadas_abandonadas / llamadas_recibidas) * 100

Donde:

- ``llamadas_abandonadas``: el cliente colgo antes de ser atendido.
- ``llamadas_recibidas``: total de llamadas que entraron al IVR
  durante la ventana de medicion.

2. Tipo de regla
----------------

**Tipo:** Regla de Calculo (categorizada en
:doc:`/base-cognitiva/_fundamentos-conceptuales/fnd-05-jerarquia-4-niveles`).

Es una de las 3 BRs de tipo "Calculo" del catalogo IACT (junto con
BR_017 Tiempo Promedio Espera y BR_018 Indice Eficiencia).

3. Parametros
-------------

.. list-table::
 :header-rows: 1
 :widths: 30 70

 * - Parametro
   - Valor
 * - Ventana de medicion default
   - 24 horas (rolling)
 * - Ventana minima permitida
   - 1 hora
 * - Ventana maxima permitida
   - 2 anos (CNST_018 Rango Maximo de Consulta)
 * - Granularidad temporal
   - Hora, dia, semana, mes, trimestre
 * - Granularidad por dimension
   - Total, por cola, por agente, por campana

4. Umbrales operativos
----------------------

.. list-table::
 :header-rows: 1
 :widths: 25 25 50

 * - Estado
   - Rango
   - Significado
 * - Optimo
   - < 5 %
   - Performance dentro del SLA
 * - Aceptable
   - 5 % - 10 %
   - Monitoreo recomendado
 * - Critico
   - > 10 %
   - Requiere intervencion inmediata (alerta automatica)

Los umbrales son configurables por ``UC_ALR_01 Configurar
Umbrales``.

5. UCs relacionados
-------------------

- :doc:`/requisitos/casos-uso/reports/uc-rpt-02/index`
- :doc:`/requisitos/casos-uso/reports/uc-rpt-13/index`
- :doc:`/requisitos/casos-uso/alerts/uc-alr-01/index`

6. CNSTs aplicables
-------------------

- :doc:`/normativa/restricciones/cnst-017-sla-de-tiempos-de-respuesta`
  — calculo en runtime debe responder en SLA p95 <= 2 s.
- :doc:`/normativa/restricciones/cnst-018-rango-maximo-de-consulta-de-2-anos`
  — limite de ventana de medicion historica.

7. BRs relacionadas
-------------------

- BR_017 Tiempo Promedio Espera (otra metrica de calidad de servicio).
- BR_018 Indice Eficiencia (metrica complementaria).

8. Origen
---------

- **Fuente:** SLA de negocio del sistema IVR
- **Documento:** referenciado en
  :doc:`/base-cognitiva/_fundamentos-conceptuales/fnd-05-jerarquia-4-niveles`
  como ejemplo canonico de regla de calculo.
- **Fecha:** 2026-04-29 (creacion formal del archivo tras gap detectado)
