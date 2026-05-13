
----------------------------------------------------------------------
SECCION 5: GENERA UC (Forward Traceability)
----------------------------------------------------------------------

**Reglas de Transformación BR → UC:**

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Tipo BR
     - ¿Genera UC?
     - Patrón de Implementación
   * - Restricción
     - NO
     - Precondición + Flujo Alterno en UC existente
   * - Cálculo
     - NO
     - Paso en flujo normal (no UC propio)
   * - Desencadenador
     - SÍ
     - UC completo NUEVO
   * - Inferencia
     - NO
     - FR directo (+ UC temporal opcional para cron)
   * - Definición
     - NO
     - Glosario/Diccionario (no genera UC ni FR)

5.1 UC Generados o Afectados
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Si esta BR genera UC nuevo:**

- **UC Generado:**
  
  - **ID:** UC_IACT_[MOD]_NN_[Nombre]_4_0_0.rst
  - **Nombre:** [Nombre descriptivo del UC]
  - **Actor Principal:** [Usuario o Sistema]
  - **Tipo:** [Normal|Temporal|CRUD]
  - **Archivo:** [Nombre del archivo UC]

**Si esta BR afecta UC existente:**

- **UC Afectado:**
  
  - **ID:** UC_IACT_[MOD]_NN_[Nombre]_4_0_0.rst
  - **Nombre:** [Nombre del UC existente]
  - **Donde se implementa:** [Paso N | FA-X | FE-X | Precondición PC-N]
  - **Tipo de impacto:** [Agrega validación | Modifica flujo | Nueva precondición | Nuevo FA]

**Si esta BR NO genera UC:**

- **Razón:** [Es Cálculo | Es Inferencia | Es Definición]
- **Implementación directa:** FR_[MOD]_NN_ZZ_[Nombre]_1_0_0.rst
- **O:** Se implementa en paso X del UC_[MOD]_NN

**Ejemplos por Tipo:**

Restricción (BR-IACT-028):

.. code-block:: text

   NO genera UC nuevo
   
   Afecta: UC_IACT_RPT_01_Consultar_Reporte_4_0_0.rst
   
   Implementa en:
   - Precondición PC-4: count <= 10,000 para ejecución directa
   - FA-2: Consulta Requiere Aprobación (cuando count > 10,000)

Cálculo (BR-IACT-053):

.. code-block:: text

   NO genera UC propio
   
   Se usa en: UC_IACT_RPT_01_Consultar_Reporte paso 9
   
   Derivación: FR_RPT_01_09_Calcular_Metricas_1_0_0.rst

Desencadenador (BR-IACT-031):

.. code-block:: text

   SÍ genera UC nuevo
   
   UC Generado:
   - ID: UC_IACT_AUTH_07_Notificar_Sesion_4_0_0.rst
   - Nombre: Notificar Sesión Próxima a Expiración
   - Actor: Usuario Autenticado
   - Tipo: Normal (UI-driven)

Inferencia (BR-IACT-046):

.. code-block:: text

   NO genera UC (cambio silencioso)
   
   Derivación directa:
   - FR_AUTH_08_02_Marcar_Sesiones_Expiradas_1_0_0.rst
   
   UC Temporal (opcional):
   - UC_IACT_AUTH_08_Marcar_Sesiones_Expiradas_4_0_0.rst
   - Actor: Sistema (Cron Scheduler)

Definición (BR-IACT-001):

.. code-block:: text

   NO genera UC
   NO genera FR
   
   Se documenta en:
   - Glosario de Términos
   - Diccionario de Datos
   
   Se USA en:
   - WHERE clauses de múltiples UC
   - Filtros en reportes
   - Segmentación

----------------------------------------------------------------------
SECCION 6: TRAZABILIDAD FORWARD COMPLETA
----------------------------------------------------------------------

**Árbol de Trazabilidad:**

Desde esta BR hasta código y tests:

.. code-block:: text

   BRQ-XXX ([Nombre del BReq])
     |
     └─> BR-IACT-XXX ([Nombre de esta BR])
           |
           ├─> UC_IACT_XXX_YY_[Nombre]_4_0_0.rst
           |     |
           |     ├─> Paso 5 → FR_XXX_YY_01_[Nombre]_1_0_0.rst
           |     |              |
           |     |              └─> modulo_1_0_0/archivo.py::funcion_1 (linea 234)
           |     |                    |
           |     |                    └─> tests/test_modulo.py::test_funcion_1
           |     |
           |     ├─> Paso 8 → FR_XXX_YY_02_[Nombre]_1_0_0.rst
           |     |              |
           |     |              └─> modulo_1_0_0/archivo.py::funcion_2 (linea 456)
           |     |                    |
           |     |                    └─> tests/test_modulo.py::test_funcion_2
           |     |
           |     └─> FA-2 → FR_XXX_YY_03_[Nombre]_1_0_0.rst
           |                  |
           |                  └─> modulo_1_0_0/archivo.py::funcion_3 (linea 789)
           |                        |
           |                        └─> tests/test_modulo.py::test_funcion_3
           |
           └─> [Otros UC si aplica]

**Ejemplo Concreto (BR-IACT-028):**

.. code-block:: text

   BRQ-015 (Optimizar Performance Reportes)
     |
     └─> BR-IACT-028 (Aprobación Consultas Grandes)
           |
           └─> UC_IACT_RPT_01_Consultar_Reporte_4_0_0.rst
                 |
                 ├─> Paso 6 → FR_RPT_01_07_Calcular_Count_1_0_0.rst
                 |              |
                 |              └─> reports_1_0_0/services.py::calculate_query_count
                 |                    (linea 234-248)
                 |                    |
                 |                    ├─> tests/test_reports.py::test_calculate_count_normal
                 |                    ├─> tests/test_reports.py::test_calculate_count_large
                 |                    └─> tests/test_reports.py::test_calculate_count_timeout
                 |
                 ├─> Paso 7 → FR_RPT_01_08_Evaluar_Umbral_1_0_0.rst
                 |              |
                 |              └─> reports_1_0_0/services.py::evaluate_threshold
                 |                    (linea 250-260)
                 |                    |
                 |                    └─> tests/test_reports.py::test_evaluate_threshold
                 |
                 └─> FA-2 → FR_RPT_01_10_Crear_Approval_1_0_0.rst
                              |
                              └─> reports_1_0_0/approvals.py::create_approval
                                    (linea 89-120)
                                    |
                                    ├─> tests/test_approvals.py::test_create_approval
                                    ├─> tests/test_approvals.py::test_notify_supervisor
                                    └─> tests/integration/test_approval_flow.py

**Matriz de Trazabilidad (formato tabla):**

.. list-table::
   :header-rows: 1
   :widths: 15 20 25 25 15

   * - BR
     - UC
     - FR
     - Código
     - Tests
   * - BR-IACT-028
     - UC-RPT-01 (Paso 6)
     - FR-RPT-01-07
     - services.py:234
     - test_calculate_count
   * - BR-IACT-028
     - UC-RPT-01 (Paso 7)
     - FR-RPT-01-08
     - services.py:250
     - test_evaluate_threshold
   * - BR-IACT-028
     - UC-RPT-01 (FA-2)
     - FR-RPT-01-10
     - approvals.py:89
     - test_create_approval

----------------------------------------------------------------------
SECCION 7: IMPACTO DE CAMBIOS
----------------------------------------------------------------------

**Propósito:**

Analizar qué sucedería si esta BR cambiara, para facilitar análisis
de impacto futuro.

7.1 Análisis de Impacto
~~~~~~~~~~~~~~~~~~~~~~~~

**Si esta BR cambiara, se verían afectados:**

**UC Afectados:**

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - UC ID
     - Tipo de Cambio Necesario
   * - UC_IACT_XXX_YY
     - [Modificar paso N | Reescribir FA | Actualizar precondición]
   * - UC_IACT_AAA_BB
     - [...]

**FR Afectados:**

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - FR ID
     - Modificación Necesaria
   * - FR_XXX_YY_01
     - [Cambiar validación | Actualizar query | Modificar cálculo]
   * - FR_XXX_YY_02
     - [...]

**Archivos de Código:**

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Archivo
     - Función(es) a Modificar
   * - modulo_1_0_0/archivo.py
     - funcion_1() (linea 234), funcion_2() (linea 456)
   * - modulo_1_0_0/otro.py
     - clase.metodo() (linea 89)

**Tests Afectados:**

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Archivo Test
     - Test(s) a Actualizar
   * - tests/test_modulo.py
     - test_funcion_1, test_funcion_2
   * - tests/test_integracion.py
     - test_flujo_completo

**Stakeholders a Notificar:**

.. list-table::
   :header-rows: 1
   :widths: 30 30 40

   * - Nombre
     - Rol
     - Razón de Notificación
   * - [Nombre Stakeholder]
     - [Rol]
     - [Por qué debe saber del cambio]

7.2 Escenarios de Cambio
~~~~~~~~~~~~~~~~~~~~~~~~~

**Escenario 1: [Tipo de cambio - ej: Cambio de valor umbral]**

Ejemplo: Cambiar umbral de 10,000 a 5,000 registros

**Cambios requeridos:**

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Componente
     - Acción
   * - UC-RPT-01
     - Actualizar documentación en FA-2 (nuevo umbral: 5,000)
   * - FR-RPT-01-07
     - Modificar constante THRESHOLD = 5000
   * - reports_1_0_0/services.py
     - Cambiar linea 240: THRESHOLD = 5000
   * - tests/test_reports.py
     - Actualizar valores en test_calculate_count_large (usar 5,001)
   * - BR-IACT-028
     - Actualizar enunciado y sección 4

**Estimación:**

- Esfuerzo: 2 horas
- Riesgo: Bajo (cambio de configuración)
- Impacto: Más consultas requerirán aprobación

**Escenario 2: [Tipo de cambio - ej: Cambio de lógica completa]**

Ejemplo: Eliminar aprobación, implementar paginación automática

**Cambios requeridos:**

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Componente
     - Acción
   * - UC-RPT-01
     - Eliminar FA-2 completo, agregar paso paginación
   * - FR-RPT-01-10
     - Eliminar (ya no hay approvals)
   * - FR-RPT-01-11 (NUEVO)
     - Crear: Implementar paginación automática
   * - reports_1_0_0/approvals.py
     - Deprecar archivo completo
   * - reports_1_0_0/pagination.py
     - Crear nuevo módulo
   * - tests/test_approvals.py
     - Deprecar suite completa
   * - tests/test_pagination.py (NUEVO)
     - Crear suite nueva
   * - DB Migration
     - Opcional: Archivar tabla approvals

**Estimación:**

- Esfuerzo: 16 horas (2 días)
- Riesgo: Alto (cambio de arquitectura)
- Impacto: Experiencia usuario muy diferente
- Requiere: Aprobación stakeholder, testing extenso

----------------------------------------------------------------------
SECCION 8: VALIDACION Y TESTING
----------------------------------------------------------------------

8.1 Cómo se Valida esta BR
~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Test Funcional Manual:**

**Precondiciones:**

1. [Condición 1 que debe existir antes del test]
2. [Condición 2]
3. [Condición 3]

**Pasos del Test:**

1. [Paso de preparación]
2. [Paso de ejecución]
3. [Paso de verificación]

**Resultado Esperado:**

[Descripción detallada del resultado que demuestra que BR se cumple]

**Resultado Actual:**

[A completar durante ejecución del test]

- [ ] PASS
- [ ] FAIL (describir falla)

**Evidencia:**

- Screenshot: [adjuntar]
- Log: [adjuntar extracto]
- Query resultado: [adjuntar]

8.2 Tests Automatizados
~~~~~~~~~~~~~~~~~~~~~~~~

**Tests Unitarios:**

.. code-block:: python

   # tests/test_[modulo].py
   
   import pytest
   from modulo import funcion_bajo_test
   
   def test_br_iact_xxx_caso_normal():
       """
       Valida BR-IACT-XXX en caso normal.
       
       Given: [Condición inicial]
       When: [Acción ejecutada]
       Then: [Resultado esperado]
       """
       # Arrange
       param1 = valor_valido_1
       param2 = valor_valido_2
       
       # Act
       resultado = funcion_bajo_test(param1, param2)
       
       # Assert
       assert resultado == valor_esperado
       assert resultado.tipo == 'esperado'
   
   def test_br_iact_xxx_caso_borde_superior():
       """Valida BR en límite superior."""
       # Arrange
       param = valor_limite_max
       
       # Act
       resultado = funcion_bajo_test(param)
       
       # Assert
       assert resultado is not None
       assert resultado <= max_permitido
   
   def test_br_iact_xxx_caso_borde_inferior():
       """Valida BR en límite inferior."""
       param = valor_limite_min
       resultado = funcion_bajo_test(param)
       assert resultado >= min_permitido
   
   def test_br_iact_xxx_caso_error_division_cero():
       """Valida manejo de división por cero."""
       with pytest.raises(ZeroDivisionError):
           funcion_bajo_test(numerador=10, denominador=0)
   
   def test_br_iact_xxx_caso_input_invalido():
       """Valida rechazo de inputs inválidos."""
       with pytest.raises(ValueError, match="Input fuera de rango"):
           funcion_bajo_test(param=-1)  # negativo no permitido

**Tests de Integración:**

.. code-block:: python

   # tests/integration/test_[modulo]_integration.py
   
   import pytest
   from django.test import TestCase
   
   class TestBRIACT_XXX_Integration(TestCase):
       """
       Integration tests for BR-IACT-XXX.
       
       Validates complete flow from UC through FR to DB.
       """
       
       def setUp(self):
           """Setup test data."""
           self.user = create_test_user()
           self.client.login(username=self.user.username)
       
       def test_br_iact_xxx_flujo_completo(self):
           """
           Valida BR-IACT-XXX en flujo end-to-end.
           
           Validates: BR-IACT-XXX
           Related UC: UC-IACT-YYY-ZZ
           """
           # Given
           data = {
               'param1': 'valor1',
               'param2': 'valor2'
           }
           
           # When
           response = self.client.post('/api/endpoint/', data)
           
           # Then
           self.assertEqual(response.status_code, 200)
           result = response.json()
           self.assertEqual(result['status'], 'success')
           
           # Verify DB state
           obj = Model.objects.get(id=result['id'])
           self.assertEqual(obj.field, expected_value)

8.3 Criterios de Aceptación de Tests
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Para considerar esta BR validada:**

.. list-table::
   :header-rows: 1
   :widths: 50 10 40

   * - Criterio
     - Status
     - Evidencia
   * - Tests unitarios pasan 100%
     - [ ]
     - [Link a reporte]
   * - Tests de integración pasan 100%
     - [ ]
     - [Link a reporte]
   * - Test manual ejecutado y documentado
     - [ ]
     - [Link a documento]
   * - Cobertura de código >= 80% en funciones relacionadas
     - [ ]
     - [Link a coverage report]
   * - Validado por QA Engineer
     - [ ]
     - [Firma: _______ Fecha: _____]
   * - Aprobado por Business Analyst
     - [ ]
     - [Firma: _______ Fecha: _____]
   * - Firmado por Stakeholder
     - [ ]
     - [Firma: _______ Fecha: _____]

----------------------------------------------------------------------
SECCION 9: NOTAS Y EXCEPCIONES
----------------------------------------------------------------------

9.1 Excepciones Conocidas
~~~~~~~~~~~~~~~~~~~~~~~~~~

**Excepción 1: [Situación excepcional]**

- **Descripción:** [Cuándo no aplica la BR]
- **Razón:** [Por qué existe esta excepción]
- **Comportamiento alternativo:** [Qué hacer en su lugar]
- **Frecuencia:** [Común|Rara|Muy rara]
- **Stakeholder que aprobó:** [Nombre]

**Ejemplo:**

Excepción 1: Usuarios Administradores

- Descripción: Administradores del sistema pueden ejecutar cualquier
  consulta sin límite ni aprobación
- Razón: Necesidad operativa para debugging y análisis urgente
- Comportamiento: Sistema valida rol, si user.role='ADMIN' → skip approval
- Frecuencia: Rara (2-3 veces/mes)
- Stakeholder: CTO aprobó el 2024-11-20

9.2 Notas Técnicas
~~~~~~~~~~~~~~~~~~

**Consideraciones de Implementación:**

- [Nota técnica importante 1]
- [Nota técnica importante 2]
- [Limitaciones conocidas]

**Dependencias Externas:**

- [Servicio externo necesario]
- [Librería o API requerida]
- [Configuración especial]

**Performance:**

- [Consideraciones de performance]
- [Índices requeridos]
- [Optimizaciones aplicadas]

9.3 Decisiones de Diseño
~~~~~~~~~~~~~~~~~~~~~~~~~

**Decision 1: [Título de la decisión]**

- **Fecha:** YYYY-MM-DD
- **Contexto:** [Por qué se necesitaba decidir]
- **Alternativas consideradas:**
  
  - Opción A: [descripción]
  - Opción B: [descripción]
  - Opción C: [descripción]

- **Decisión tomada:** [Opción elegida]
- **Razón:** [Por qué se eligió esta opción]
- **Trade-offs:** [Qué se sacrificó]

----------------------------------------------------------------------
SECCION 10: HISTORIAL DE VERSIONES
----------------------------------------------------------------------

.. list-table::
   :header-rows: 1
   :widths: 10 15 50 25

   * - Version
     - Fecha
     - Cambios
     - Autor
   * - 1.0.0
     - YYYY-MM-DD
     - Version inicial - Creacion de BR
     - [Nombre del BA]
   * - 1.1.0
     - YYYY-MM-DD
     - [Descripcion del cambio MINOR - nueva funcionalidad compatible]
     - [Nombre del BA]
   * - 2.0.0
     - YYYY-MM-DD
     - [Cambio MAJOR - breaking change, incompatible con v1.x]
     - [Nombre del BA]

**Notas sobre Versionado Semántico:**

- **MAJOR (X.0.0):** Cambios incompatibles que rompen implementación actual
  
  Ejemplo: Cambiar de "aprobación supervisor" a "paginación automática"

- **MINOR (0.X.0):** Nueva funcionalidad compatible con versión anterior
  
  Ejemplo: Agregar nueva excepción para usuarios VIP

- **PATCH (0.0.X):** Correcciones y clarificaciones sin cambio funcional
  
  Ejemplo: Corregir typo en enunciado

----------------------------------------------------------------------
REFERENCIAS
----------------------------------------------------------------------

**Estándares del Proyecto:**

- STD_001_Estandares_Documentacion_1_1_0.rst
- NOM_001_Nomenclatura_Proyecto_2_0_0.rst

**Material Pedagógico:**

- PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md
  
  - Sección 2: Taxonomía de Business Rules (5 tipos)
  - Sección 3: Desencadenadores vs Inferencias (TEST CRITICO)
  - Sección 4: Documentación de BR
  - Sección 5: Derivación BR → UC → FR

**Documentos Relacionados:**

- BRQ_XXX_[Nombre]_1_0_0.rst (Business Requirement padre)
- UC_IACT_XXX_YY_[Nombre]_4_0_0.rst (Use Cases generados/afectados)
- FR_XXX_YY_ZZ_[Nombre]_1_0_0.rst (Functional Requirements derivados)

**Fuentes Externas:**

- [URL a documento externo si aplica]
- [Referencia a estándar de industria]
- [Regulación o normativa]

----------------------------------------------------------------------
ANEXOS
----------------------------------------------------------------------

ANEXO A: Glosario de Términos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**[Término 1]:** [Definición breve específica a esta BR]

**[Término 2]:** [Definición]

ANEXO B: Diagramas
~~~~~~~~~~~~~~~~~~

[Insertar diagramas de flujo, entidad-relación, secuencia, etc.]

ANEXO C: Ejemplos Adicionales
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

[Ejemplos detallados adicionales si son necesarios para clarificar]

----------------------------------------------------------------------

.. note::
   **CHECKLIST DE CALIDAD (14 PUNTOS):**
   
   Antes de marcar esta BR como APPROVED, verificar:
   
   Sección 1: Enunciado
   - [ ] Enunciado claro y conciso (1 frase)
   - [ ] Tipo de BR correctamente identificado
   - [ ] Test de observabilidad aplicado (si Desencadenador vs Inferencia)
   
   Sección 2: Derivado De
   - [ ] Trazabilidad backward completa (BReq, Stakeholder)
   - [ ] Contexto de negocio documentado
   
   Sección 3: Criterios
   - [ ] Criterios de aceptación medibles (mínimo 3)
   
   Sección 4: Análisis por Tipo
   - [ ] Sección de tipo BR completamente llenada
   
   Sección 5-6: Trazabilidad
   - [ ] Trazabilidad forward documentada (UC, FR, código)
   
   Sección 7: Impacto
   - [ ] Análisis de impacto de cambios completo
   
   Sección 8: Testing
   - [ ] Tests definidos (manual y automatizados)
   
   Sección 9-10: Documentación
   - [ ] Metadata correcta al inicio
   - [ ] Versión semántica aplicada
   - [ ] Referencias actualizadas

**REGLA DE ORO DEL TEST DE OBSERVABILIDAD:**

Si no puedes decidir si es Desencadenador o Inferencia,
aplica el TEST:

   ¿El usuario VE algo? → SI = Desencadenador | NO = Inferencia

----------------------------------------------------------------------

**Archivo:** TPL_BR_Decision_Tipo_1_2_0.rst  
**Version Template:** 1.2.0  
**Fecha Creacion Template:** 2026-01-09  
**Autor Template:** Sistema de Regeneracion IACT  
**Lineas Totales:** ~900

