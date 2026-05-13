.. meta::
   :Proyecto: IACT
   :Codigo: TRZ-IACT-MOD-NN
   :Titulo: Matriz de Trazabilidad - Modulo
   :Version: 1.0.0
   :Alcance: Modulo o Feature especifico
   :Fecha: YYYY-MM-DD
   :Autor: Nombre del Business Analyst
   :Estado: DRAFT|REVIEW|APPROVED|IMPLEMENTED

======================================================================
TRZ-IACT-MOD-NN: Matriz de Trazabilidad - Modulo
======================================================================

**Proyecto:** IACT - IVR Analytics & Customer Tracking  
**Alcance:** Modulo o Feature especifico  
**Estado:** DRAFT|REVIEW|APPROVED|IMPLEMENTED  
**Prioridad:** Alta|Media|Baja  
**Clasificacion:** C2 - INTERNAL

----------------------------------------------------------------------
INTRODUCCION
----------------------------------------------------------------------

**Que es una Matriz de Trazabilidad (RTM):**

Una Requirements Traceability Matrix (RTM) es un documento que mapea
y traza requisitos desde su origen (stakeholder, documento de negocio)
hasta su implementacion final (codigo, tests).

**Proposito de la RTM:**

1. **Completitud:** Verificar que todos los requisitos estan implementados
2. **Cobertura:** Asegurar que todo el codigo implementa requisitos documentados
3. **Impacto:** Analizar impacto de cambios en requisitos
4. **Auditoria:** Demostrar cumplimiento de requisitos
5. **Comunicacion:** Visibilidad del estado de implementacion

**Tipos de Trazabilidad:**

1. **Backward (hacia atras):**
   - De Codigo/Tests → FR → UC → BR → BReq → Stakeholder
   - Responde: "Por que existe este codigo?"

2. **Forward (hacia adelante):**
   - De BReq → BR → UC → FR → Codigo → Tests
   - Responde: "Donde esta implementado este requisito?"

3. **Horizontal (lateral):**
   - UC ↔ UC: Dependencias entre casos de uso
   - FR ↔ FR: Dependencias entre functional requirements
   - Responde: "Que otros componentes dependen de este?"

**Niveles de Trazabilidad:**

.. code-block:: text

   Nivel 0: Stakeholder Need
     |
   Nivel 1: Business Requirement (BReq)
     |
   Nivel 2: Business Rule (BR)
     |
   Nivel 3: Use Case (UC)
     |
   Nivel 4: Functional Requirement (FR)
     |
   Nivel 5: Codigo (modulo.py::funcion)
     |
   Nivel 6: Tests (test_modulo.py::test_funcion)

**Beneficios de Mantener RTM:**

- Deteccion temprana de requisitos faltantes
- Identificacion de codigo huerfano (sin requisito)
- Analisis de impacto de cambios
- Cumplimiento de auditorias (ISO, FDA, etc)
- Facilita onboarding de nuevos miembros

----------------------------------------------------------------------
1. TRAZABILIDAD BACKWARD
----------------------------------------------------------------------

**Proposito:**

Desde Codigo/Tests hacia el origen del requisito.

**Formato:**

.. list-table::
   :header-rows: 1
   :widths: 15 15 15 20 35

   * - Codigo/Test
     - FR
     - UC
     - BR
     - BReq
   * - archivo.py::funcion
     - FR-XXX-YY-ZZ
     - UC-IACT-XXX-YY paso N
     - BR-IACT-XXX
     - BRQ-XXX

**EJEMPLO COMPLETO (Modulo Reportes):**

**Backward Traceability - Reportes Trimestrales:**

.. list-table::
   :header-rows: 1
   :widths: 20 15 20 15 30

   * - Codigo/Test
     - FR
     - UC (Paso)
     - BR
     - BReq
   * - reports/views.py::QuarterlyReportView
     - FR-RPT-01-01
     - UC-RPT-01 (paso 1-2)
     - -
     - BRQ-015
   * - reports/validators.py::validate_parameters
     - FR-RPT-01-01
     - UC-RPT-01 (paso 2)
     - -
     - BRQ-015
   * - reports/queries.py::calculate_count
     - FR-RPT-01-04
     - UC-RPT-01 (paso 5)
     - BR-IACT-028
     - BRQ-015
   * - reports/queries.py::execute_main_query
     - FR-RPT-01-06
     - UC-RPT-01 (paso 7)
     - BR-IACT-028
     - BRQ-015
   * - reports/calculations.py::calculate_abandon_rate
     - FR-RPT-01-07
     - UC-RPT-01 (paso 8)
     - BR-IACT-053
     - BRQ-015
   * - reports/approvals.py::create_approval
     - FR-RPT-01-10
     - UC-RPT-01 FA-2
     - BR-IACT-028
     - BRQ-015
   * - reports/notifications.py::notify_supervisor
     - FR-RPT-01-11
     - UC-RPT-01 FA-2
     - BR-IACT-028
     - BRQ-015
   * - tests/test_validators.py::test_validate_quarter
     - FR-RPT-01-01
     - UC-RPT-01 (paso 2)
     - -
     - BRQ-015
   * - tests/test_queries.py::test_execute_main_query
     - FR-RPT-01-06
     - UC-RPT-01 (paso 7)
     - BR-IACT-028
     - BRQ-015

**Analisis de Cobertura Backward:**

- Total de funciones implementadas: 7
- Total de tests: 2 (baja cobertura, requiere mas tests)
- BR implementadas: 2 (BR-IACT-028, BR-IACT-053)
- BReq origen: 1 (BRQ-015)
- Huerfanos (sin FR): 0

----------------------------------------------------------------------
2. TRAZABILIDAD FORWARD
----------------------------------------------------------------------

**Proposito:**

Desde BReq/BR hacia Codigo/Tests, verificar que todo esta implementado.

**Formato:**

.. list-table::
   :header-rows: 1
   :widths: 15 15 20 25 25

   * - BReq
     - BR
     - UC
     - FR
     - Codigo Implementado
   * - BRQ-XXX
     - BR-IACT-XXX
     - UC-IACT-XXX-YY
     - FR-XXX-YY-ZZ
     - modulo.py::funcion

**EJEMPLO COMPLETO (BRQ-015):**

**Forward Traceability - BRQ-015 Optimizar Performance:**

.. list-table::
   :header-rows: 1
   :widths: 10 15 20 25 30

   * - BReq
     - BR
     - UC
     - FR
     - Implementacion
   * - BRQ-015
     - BR-IACT-028
     - UC-RPT-01 (paso 5)
     - FR-RPT-01-04
     - queries.py::calculate_count
   * - BRQ-015
     - BR-IACT-028
     - UC-RPT-01 (paso 6)
     - FR-RPT-01-05
     - queries.py::evaluate_threshold
   * - BRQ-015
     - BR-IACT-028
     - UC-RPT-01 FA-2
     - FR-RPT-01-10
     - approvals.py::create_approval
   * - BRQ-015
     - BR-IACT-028
     - UC-RPT-01 FA-2
     - FR-RPT-01-11
     - notifications.py::notify_supervisor
   * - BRQ-015
     - BR-IACT-053
     - UC-RPT-01 (paso 8)
     - FR-RPT-01-07
     - calculations.py::calculate_abandon_rate
   * - BRQ-015
     - -
     - UC-RPT-01 (paso 2)
     - FR-RPT-01-01
     - validators.py::validate_parameters
   * - BRQ-015
     - -
     - UC-RPT-01 (paso 7)
     - FR-RPT-01-06
     - queries.py::execute_main_query

**Analisis de Cobertura Forward:**

BRQ-015:
- BR derivadas: 2 (BR-IACT-028, BR-IACT-053)
- UC generados: 1 (UC-RPT-01)
- FR derivados: 7 (FR-RPT-01-01, 04, 05, 06, 07, 10, 11)
- Codigo implementado: 7 funciones
- Estado: 100% implementado

BR-IACT-028:
- UC generados: 1 (UC-RPT-01, afecta paso 5-6 y FA-2)
- FR derivados: 4 (FR-RPT-01-04, 05, 10, 11)
- Estado: 100% implementado

BR-IACT-053:
- UC afectados: 1 (UC-RPT-01, paso 8)
- FR derivados: 1 (FR-RPT-01-07)
- Estado: 100% implementado

----------------------------------------------------------------------
3. TRAZABILIDAD HORIZONTAL
----------------------------------------------------------------------

**Proposito:**

Dependencias entre componentes del mismo nivel.

**3.1 Dependencias entre UC:**

.. list-table::
   :header-rows: 1
   :widths: 25 25 50

   * - UC Origen
     - UC Dependiente
     - Tipo de Dependencia
   * - UC-RPT-01
     - UC-RPT-02
     - UC-RPT-01 FA-2 genera solicitud que UC-RPT-02 procesa
   * - UC-RPT-02
     - UC-RPT-03
     - Si UC-RPT-02 aprueba, UC-RPT-03 ejecuta query
   * - UC-AUTH-01
     - UC-RPT-01
     - UC-RPT-01 requiere usuario autenticado (PC-1)

**3.2 Dependencias entre FR:**

.. list-table::
   :header-rows: 1
   :widths: 25 25 50

   * - FR Origen
     - FR Dependiente
     - Tipo de Dependencia
   * - FR-RPT-01-01
     - FR-RPT-01-04
     - FR-01-04 asume parametros ya validados por FR-01-01
   * - FR-RPT-01-04
     - FR-RPT-01-05
     - FR-01-05 usa count calculado por FR-01-04
   * - FR-RPT-01-05
     - FR-RPT-01-06
     - FR-01-06 solo ejecuta si FR-01-05 aprueba
   * - FR-RPT-01-05
     - FR-RPT-01-10
     - FR-01-10 se ejecuta si FR-01-05 requiere aprobacion

**3.3 Dependencias de Datos:**

.. list-table::
   :header-rows: 1
   :widths: 30 30 40

   * - Entidad/Tabla
     - Componente que Escribe
     - Componentes que Leen
   * - ivr_calls
     - Sistema IVR (externo)
     - FR-RPT-01-04, FR-RPT-01-06
   * - approvals
     - FR-RPT-01-10
     - UC-RPT-02, FR-RPT-02-01
   * - notifications
     - FR-RPT-01-11
     - UC-AUTH-05 (Listar Notificaciones)

----------------------------------------------------------------------
4. MATRIZ RTM COMPLETA
----------------------------------------------------------------------

**Proposito:**

Tabla maestra con toda la trazabilidad en un solo lugar.

**Formato RTM Master:**

.. list-table::
   :header-rows: 1
   :widths: 8 12 12 12 15 15 12 14

   * - BReq
     - BR
     - UC
     - FR
     - Codigo
     - Tests
     - Estado
     - Notas
   * - ID
     - ID
     - ID
     - ID
     - archivo::funcion
     - test_archivo::test
     - %
     - Comentarios

**EJEMPLO COMPLETO (Reportes Trimestrales):**

**RTM Master - Modulo Reportes:**

.. list-table::
   :header-rows: 1
   :widths: 8 10 12 12 18 15 10 15

   * - BReq
     - BR
     - UC
     - FR
     - Codigo
     - Tests
     - Estado
     - Notas
   * - BRQ-015
     - -
     - UC-RPT-01 (paso 1)
     - FR-RPT-01-01
     - validators.py::validate_parameters
     - test_validators.py::test_validate_quarter
     - 100%
     - Validacion completa
   * - BRQ-015
     - BR-028
     - UC-RPT-01 (paso 5)
     - FR-RPT-01-04
     - queries.py::calculate_count
     - test_queries.py::test_calculate_count
     - 100%
     - Count implementado
   * - BRQ-015
     - BR-028
     - UC-RPT-01 (paso 6)
     - FR-RPT-01-05
     - queries.py::evaluate_threshold
     - test_queries.py::test_evaluate_threshold
     - 100%
     - Umbral 10K
   * - BRQ-015
     - BR-028
     - UC-RPT-01 (paso 7)
     - FR-RPT-01-06
     - queries.py::execute_main_query
     - test_queries.py::test_execute_query
     - 100%
     - Query optimizada
   * - BRQ-015
     - BR-053
     - UC-RPT-01 (paso 8)
     - FR-RPT-01-07
     - calculations.py::calculate_abandon_rate
     - test_calculations.py::test_abandon_rate
     - 100%
     - Formula correcta
   * - BRQ-015
     - -
     - UC-RPT-01 (paso 9)
     - FR-RPT-01-08
     - visualizations.py::generate_charts
     - test_visualizations.py::test_charts
     - 80%
     - Graficos basicos, falta KPI card
   * - BRQ-015
     - -
     - UC-RPT-01 (paso 10)
     - FR-RPT-01-09
     - views.py::render_results
     - test_views.py::test_render
     - 100%
     - Tabla completa
   * - BRQ-015
     - BR-028
     - UC-RPT-01 FA-2
     - FR-RPT-01-10
     - approvals.py::create_approval
     - test_approvals.py::test_create
     - 100%
     - Aprobacion funcional
   * - BRQ-015
     - BR-028
     - UC-RPT-01 FA-2
     - FR-RPT-01-11
     - notifications.py::notify_supervisor
     - test_notifications.py::test_notify
     - 100%
     - Email y notif OK
   * - BRQ-015
     - BR-028
     - UC-RPT-02
     - FR-RPT-02-01
     - approvals.py::review_approval
     - test_approvals.py::test_review
     - 100%
     - Pantalla revision
   * - BRQ-015
     - BR-028
     - UC-RPT-02
     - FR-RPT-02-02
     - approvals.py::approve_query
     - test_approvals.py::test_approve
     - 100%
     - Aprobacion completa

**Resumen de Cobertura:**

.. list-table::
   :header-rows: 1
   :widths: 30 20 20 30

   * - Metrica
     - Valor
     - Objetivo
     - Status
   * - BReq implementados
     - 1/1 (100%)
     - 100%
     - OK
   * - BR implementadas
     - 2/2 (100%)
     - 100%
     - OK
   * - UC implementados
     - 2/2 (100%)
     - 100%
     - OK
   * - FR implementados
     - 11/11 (100%)
     - 100%
     - OK
   * - FR con codigo
     - 11/11 (100%)
     - 100%
     - OK
   * - FR con tests
     - 11/11 (100%)
     - >= 80%
     - OK
   * - Cobertura promedio codigo
     - 95%
     - >= 80%
     - OK
   * - Funciones sin FR (huerfanas)
     - 0
     - 0
     - OK

----------------------------------------------------------------------
5. ANALISIS DE GAPS
----------------------------------------------------------------------

**Proposito:**

Identificar requisitos sin implementar o codigo sin requisito.

**5.1 Requisitos Sin Implementar:**

.. list-table::
   :header-rows: 1
   :widths: 20 60 20

   * - Requisito
     - Descripcion
     - Prioridad
   * - -
     - -
     - -

Estado: No hay gaps, todos los requisitos estan implementados

**5.2 Codigo Sin Requisito (Huerfanos):**

.. list-table::
   :header-rows: 1
   :widths: 30 50 20

   * - Codigo
     - Descripcion
     - Accion
   * - -
     - -
     - -

Estado: No hay codigo huerfano

**5.3 Tests Faltantes:**

.. list-table::
   :header-rows: 1
   :widths: 20 60 20

   * - FR
     - Descripcion
     - Prioridad
   * - FR-RPT-01-08
     - Falta test para KPI card en graficos
     - Media

Accion: Crear test_visualizations.py::test_kpi_card

----------------------------------------------------------------------
6. ANALISIS DE IMPACTO DE CAMBIOS
----------------------------------------------------------------------

**Proposito:**

Analizar impacto si un componente cambia.

**Ejemplo: Si BR-IACT-028 cambia (umbral de 10K a 5K):**

**Componentes Afectados:**

.. list-table::
   :header-rows: 1
   :widths: 20 20 60

   * - Nivel
     - Componente
     - Cambio Requerido
   * - BR
     - BR-IACT-028
     - Actualizar umbral en enunciado
   * - UC
     - UC-RPT-01 paso 6
     - Actualizar documentacion paso 6
   * - UC
     - UC-RPT-01 FA-2
     - Actualizar documentacion FA-2
   * - FR
     - FR-RPT-01-05
     - Cambiar constante THRESHOLD = 5000
   * - Codigo
     - queries.py::evaluate_threshold
     - Modificar linea 45: THRESHOLD = 5000
   * - Tests
     - test_queries.py::test_evaluate_threshold
     - Actualizar valores esperados en asserts
   * - Tests
     - test_approvals.py::test_large_query
     - Ajustar data de test: count = 5001 en lugar de 10001

**Estimacion:**

- Archivos afectados: 6
- Esfuerzo estimado: 2 horas
- Riesgo: Bajo (cambio de configuracion)
- Tests afectados: 2
- Requiere: Regression testing completo

----------------------------------------------------------------------
7. MATRIZ DE RESPONSABILIDADES
----------------------------------------------------------------------

**Proposito:**

Quien es responsable de cada componente.

.. list-table::
   :header-rows: 1
   :widths: 20 30 25 25

   * - Componente
     - Tipo
     - Responsable
     - Reviewer
   * - BRQ-015
     - Business Requirement
     - Maria Rodriguez (Stakeholder)
     - Carlos Martinez (BA)
   * - BR-IACT-028
     - Business Rule
     - Carlos Martinez (BA)
     - Ana Lopez (QA)
   * - BR-IACT-053
     - Business Rule
     - Carlos Martinez (BA)
     - Ana Lopez (QA)
   * - UC-RPT-01
     - Use Case
     - Carlos Martinez (BA)
     - Product Owner
   * - UC-RPT-02
     - Use Case
     - Carlos Martinez (BA)
     - Product Owner
   * - FR-RPT-01-XX
     - Functional Requirements
     - Juan Perez (Developer)
     - Tech Lead
   * - reports/*.py
     - Codigo
     - Juan Perez (Developer)
     - Tech Lead
   * - tests/test_*.py
     - Tests
     - Ana Lopez (QA)
     - Tech Lead

----------------------------------------------------------------------
8. HISTORIAL DE CAMBIOS RTM
----------------------------------------------------------------------

**Proposito:**

Rastrear cambios en la matriz de trazabilidad.

.. list-table::
   :header-rows: 1
   :widths: 10 15 50 25

   * - Version
     - Fecha
     - Cambios
     - Autor
   * - 1.0.0
     - 2024-11-15
     - RTM inicial - BRQ-015 completo
     - Carlos Martinez
   * - 1.1.0
     - 2024-11-20
     - Agregado UC-RPT-02 y FR relacionados
     - Carlos Martinez
   * - 1.2.0
     - 2024-11-25
     - Actualizado estado tests: 100% cobertura
     - Ana Lopez

----------------------------------------------------------------------
REFERENCIAS
----------------------------------------------------------------------

**Estandares:**

- STD_001_Estandares_Documentacion_1_1_0.rst
- NOM_001_Nomenclatura_Proyecto_2_0_0.rst

**Material Pedagogico:**

- PARTE_5_Trazabilidad_IACT_1_0_0.md (si existe)

**Documentos Relacionados:**

- BRQ_015_Optimizar_Performance_1_0_0.rst
- BR_IACT_028_Aprobacion_Consultas_1_0_0.rst
- BR_IACT_053_Calculo_Tasa_Abandono_1_0_0.rst
- UC-IACT-RPT-01-Consultar-Reporte-Trimestral-4-0-0.rst
- UC-IACT-RPT-02-Aprobar-Consulta-Grande-4-0-0.rst
- FR-RPT-01-XX-*.rst (todos los FR del modulo)

**RTM Standards:**

- IEEE 830-1998: Software Requirements Specifications
- ISO/IEC 29148:2018: Systems and software engineering

----------------------------------------------------------------------

.. note::
   CHECKLIST RTM:
   
   - Trazabilidad backward completa (Codigo → BReq)
   - Trazabilidad forward completa (BReq → Codigo)
   - Trazabilidad horizontal documentada (UC ↔ UC, FR ↔ FR)
   - Matriz RTM master con todos los componentes
   - Analisis de cobertura (% implementacion)
   - Analisis de gaps (requisitos faltantes, codigo huerfano)
   - Analisis de impacto de cambios
   - Matriz de responsabilidades
   - Estado de implementacion actualizado
   - Historial de cambios RTM

**Como Mantener RTM Actualizada:**

1. Actualizar RTM cuando se agrega nuevo requisito
2. Actualizar RTM cuando se implementa codigo
3. Actualizar RTM cuando se escribe test
4. Revisar RTM en cada sprint/iteration
5. Validar RTM antes de releases
6. Usar RTM en analisis de impacto de cambios

----------------------------------------------------------------------

**Archivo:** TPL_TRZ_Matriz_RTM_1_3_0.rst  
**Version Template:** 1.3.0  
**Fecha Creacion Template:** 2026-01-11  
**Autor Template:** Sistema de Regeneracion IACT  
**Lineas Totales:** aproximadamente 650
