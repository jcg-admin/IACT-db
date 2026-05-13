.. meta::
   :artefacto: BReq_003
   :tipo: Business Requirement
   :dominio: requisitos
   :subdominio: objetivos
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-06
   :autor: Equipo IACT

.. _breq-003:

================================================
BReq_003: Decisiones Informadas Basadas en Datos
================================================


Resumen
-------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BReq-003
   * - **Nombre**
     - Decisiones Informadas Basadas en Datos
   * - **Categoria**
     - Inteligencia de Negocio
   * - **Prioridad**
     - Alta
   * - **Estado**
     - Aprobado

----

1. Enunciado Formal
-------------------

El sistema DEBE proporcionar reportes y analisis que permitan a los
tomadores de decision basar sus acciones en datos concretos y actualizados,
eliminando decisiones basadas unicamente en intuicion.

----

2. Metrica de Exito
-------------------

::

   Indicador: Porcentaje de decisiones documentadas con datos
   Meta: 100% de decisiones operacionales con datos de soporte
   Medicion: Auditoria de decisiones vs disponibilidad de reportes
   Requisito adicional: Reportes en formatos exportables (CSV, Excel, PDF)
   Performance: Tiempo de generacion < 30 segundos

----

3. Justificacion
----------------

Decisiones basadas en intuicion o datos desactualizados resultan en:

- Asignacion ineficiente de recursos humanos
- Oportunidades perdidas de mejora
- Incapacidad de justificar inversiones
- Falta de visibilidad sobre tendencias

Con datos accesibles y actualizados, los supervisores pueden:

- Optimizar turnos y asignaciones
- Identificar cuellos de botella
- Demostrar ROI de iniciativas
- Anticipar demanda

----

4. BR que Influyen
------------------

.. list-table::
   :widths: 15 35 50
   :header-rows: 1

   * - BR
     - Nombre
     - Como Influye
   * - BR_011
     - Limites de Exportacion
     - Define volumenes maximos exportables (100K registros)
   * - BR_012
     - Segmentacion Usuario-Centro
     - Define alcance de datos visibles por usuario
   * - BR_020
     - Rango Temporal Reportes
     - Define ventana maxima de consulta (12 meses)

----

5. UC que Genera
----------------

.. list-table::
   :widths: 15 35 50
   :header-rows: 1

   * - UC
     - Nombre
     - Relacion
   * - UC-017
     - Generar Reporte Predefinido
     - Acceso rapido a reportes estandar
   * - UC-018
     - Crear Reporte Personalizado
     - Flexibilidad para analisis ad-hoc
   * - UC-019
     - Programar Reporte Automatico
     - Entrega periodica sin intervencion
   * - UC-020
     - Filtrar Reportes por Fecha
     - Analisis temporal
   * - UC-021
     - Filtrar Reportes por Centro
     - Analisis geografico
   * - UC-022
     - Exportar Reporte CSV
     - Integracion con otras herramientas
   * - UC-023
     - Exportar Reporte Excel
     - Analisis avanzado en hojas de calculo
   * - UC-024
     - Exportar Reporte PDF
     - Presentaciones y archivo

----

6. Criterios de Aceptacion
--------------------------

1. Catalogo de al menos 10 reportes predefinidos disponibles
2. Constructor de reportes personalizados funcional
3. Exportacion a 3 formatos (CSV, Excel, PDF)
4. Tiempo de generacion menor a 30 segundos para reportes tipicos
5. Filtros por fecha y centro operativos

----

7. Stakeholders
---------------

- **Sponsor**: Gerencia de Operaciones
- **Beneficiarios**: Analistas, Supervisores, Gerentes
- **Usuarios**: AGR-003 analista_reportes, AGR-004 visor_dashboard

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
