.. meta::
   :Proyecto: IACT
   :Codigo: BR-IACT-XXX
   :Titulo: [Nombre Descriptivo de la Business Rule]
   :Version: 1.0.0
   :Tipo: [Restriccion|Calculo|Desencadenador|Inferencia|Definicion]
   :Genera_UC: [UC-IACT-XXX-XX o "-" si no genera]
   :Fecha: YYYY-MM-DD
   :Autor: [Nombre del Business Analyst]
   :Estado: [DRAFT|REVIEW|APPROVED|IMPLEMENTED]

======================================================================
BR-IACT-XXX: [Nombre Descriptivo de la Business Rule]
======================================================================

**Proyecto:** IACT - IVR Analytics & Customer Tracking  
**Tipo:** [Restriccion|Calculo|Desencadenador|Inferencia|Definicion]  
**Estado:** [DRAFT|REVIEW|APPROVED|IMPLEMENTED]  
**Prioridad:** [Alta|Media|Baja]  
**Clasificacion:** [C2 - INTERNAL]

----------------------------------------------------------------------
SECCION 1: ENUNCIADO
----------------------------------------------------------------------

[Descripcion clara y concisa de la regla de negocio en lenguaje natural.
Una sola frase declarativa que un stakeholder no tecnico pueda entender.]

**Formato:**
"[Sujeto] [verbo] [complemento] [condicion si aplica]."

**Ejemplos:**

Restriccion:
"Las consultas de reportes que retornen mas de 10,000 registros deben ser
aprobadas por el supervisor del area antes de ejecutarse."

Calculo:
"La tasa de abandono se calcula dividiendo el numero de llamadas
abandonadas entre el total de llamadas, multiplicado por 100."

Desencadenador:
"El sistema debe notificar al usuario cuando su sesion este proxima a
expirar (falten 3 minutos)."

Inferencia:
"El sistema debe marcar automaticamente las sesiones como expiradas cuando
superen 15 minutos de inactividad."

Definicion:
"Un cliente se considera activo si ha realizado al menos una llamada
en los ultimos 90 dias."

----------------------------------------------------------------------
SECCION 2: DERIVADO DE (Backward Traceability)
----------------------------------------------------------------------

2.1 Business Requirement (BReq)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**BReq Padre:**

- **ID:** BRQ-XXX
- **Nombre:** [Nombre del Business Requirement]
- **Archivo:** BRQ_XXX_[Nombre]_1_0_0.rst

**Justificacion:**

[¿Por que esta BR deriva de ese BReq? ¿Como contribuye a los objetivos
del negocio?]

2.2 Stakeholder
~~~~~~~~~~~~~~~

**Identificacion:**

- **Nombre:** [Nombre completo]
- **Rol:** [Cargo/Responsabilidad]
- **Area:** [Departamento]
- **Contacto:** [email@ejemplo.com]

**Fecha de Reunion:** YYYY-MM-DD

**Referencia Documental:**

- Acta de reunion: [Archivo o link]
- Email de confirmacion: [Referencia]
- Documento de requerimientos: [Si aplica]

2.3 Contexto del Negocio
~~~~~~~~~~~~~~~~~~~~~~~~~

**Problema que resuelve:**

[Descripcion del problema o necesidad del negocio que motiva esta BR]

**Impacto esperado:**

[Como esta BR mejorara el negocio: eficiencia, cumplimiento, experiencia
usuario, reduccion de costos, etc.]

**Metricas de exito:**

- Metrica 1: [Descripcion y valor objetivo]
- Metrica 2: [Descripcion y valor objetivo]

----------------------------------------------------------------------
SECCION 3: CRITERIOS DE ACEPTACION
----------------------------------------------------------------------

CA-1: [Criterio especifico, medible y verificable]

**Dado:** [Condicion inicial]  
**Cuando:** [Accion o evento]  
**Entonces:** [Resultado esperado observable]

CA-2: [Otro criterio]

**Dado:** [Condicion inicial]  
**Cuando:** [Accion o evento]  
**Entonces:** [Resultado esperado observable]

CA-3: [Otro criterio]

**Dado:** [Condicion inicial]  
**Cuando:** [Accion o evento]  
**Entonces:** [Resultado esperado observable]

**Ejemplo Completo (BR-IACT-028):**

CA-1: Sistema calcula count antes de ejecutar query

- **Dado:** Usuario solicita generar reporte trimestral
- **Cuando:** Sistema recibe parametros de consulta
- **Entonces:** Sistema ejecuta COUNT(*) antes del SELECT principal

CA-2: Sistema solicita aprobacion si count > 10,000

- **Dado:** Count calculado es 10,500 registros
- **Cuando:** Sistema evalua resultado del count
- **Entonces:** Sistema crea registro en tabla approvals y notifica supervisor

CA-3: Supervisor recibe notificacion en buzón interno

- **Dado:** Consulta requiere aprobacion
- **Cuando:** Sistema crea registro de aprobacion
- **Entonces:** Supervisor ve notificacion en su bandeja con link a detalle

----------------------------------------------------------------------
SECCION 4: ANALISIS POR TIPO DE BR
----------------------------------------------------------------------

.. note::
   Completa SOLO la subseccion que corresponde al tipo de tu BR.
   Las demas subsecciones pueden eliminarse o marcarse como N/A.

4.1 Si es RESTRICCION
~~~~~~~~~~~~~~~~~~~~~

**¿Que restringe esta BR?**

[Describe especificamente que acciones, datos, estados o comportamientos
estan limitados por esta regla]

**¿Cuando aplica la restriccion?**

[Condiciones temporales, contextuales o de estado bajo las cuales
la restriccion esta activa]

**¿Como se valida el cumplimiento?**

[Metodo de validacion: query SQL, calculo, verificacion de estado,
comparacion con umbral, etc.]

**¿Que sucede si se viola?**

[Comportamiento del sistema: mensaje de error, bloqueo de accion,
registro en log, notificacion, etc.]

**Ejemplo (BR-IACT-028 - Restriccion):**

- Restringe: Ejecucion directa de consultas grandes (>10K registros)
- Aplica: Cuando usuario solicita reporte y count > 10,000
- Validacion: Query COUNT(*) con mismos parametros
- Violacion: Sistema no ejecuta query, solicita aprobacion supervisor

4.2 Si es CALCULO
~~~~~~~~~~~~~~~~~

**Formula Matematica:**

.. math::

   [Variable\_Resultado] = \frac{[Numerador]}{[Denominador]} \times [Factor]

O en notacion simple:

.. code-block:: text

   variable_resultado = (numerador / denominador) * factor

**Componentes del Calculo:**

**Entradas (Inputs):**

1. **[Nombre Variable 1]**
   
   - Tipo: [INTEGER|FLOAT|DECIMAL(p,s)]
   - Rango valido: [min, max]
   - Fuente: [Tabla.campo o calculo previo]

2. **[Nombre Variable 2]**
   
   - Tipo: [INTEGER|FLOAT|DECIMAL(p,s)]
   - Rango valido: [min, max]
   - Fuente: [Tabla.campo o calculo previo]

**Salida (Output):**

- **Tipo:** [INTEGER|FLOAT|DECIMAL(p,s)|PERCENTAGE]
- **Rango esperado:** [min, max]
- **Precision decimal:** [Numero de decimales]
- **Unidad:** [%, USD, registros, etc.]

**Casos Especiales:**

- Division por cero: [Como se maneja]
- Valores NULL: [Como se manejan]
- Valores fuera de rango: [Como se validan]

**Ejemplo (BR-IACT-053 - Calculo):**

Formula:

.. code-block:: text

   tasa_abandono = (llamadas_abandonadas / total_llamadas) * 100

Entradas:
1. llamadas_abandonadas (INTEGER, >= 0, desde ivr_calls.status='ABANDONED')
2. total_llamadas (INTEGER, > 0, desde COUNT(*) ivr_calls)

Salida:
- Tipo: DECIMAL(5,2) (ej: 23.45)
- Rango: 0.00 a 100.00
- Precision: 2 decimales
- Unidad: % (porcentaje)

Caso especial:
- Si total_llamadas = 0 → retornar NULL y log WARNING

4.3 Si es DESENCADENADOR
~~~~~~~~~~~~~~~~~~~~~~~~~

**TEST DE OBSERVABILIDAD (CRITICO):**

Pregunta: ¿El usuario VE algo como resultado directo de esta BR?

- [ ] SI → Es DESENCADENADOR (genera UC completo)
- [ ] NO → Es INFERENCIA (NO genera UC, solo FR)

**¿Que desencadena esta BR?**

[Descripcion de la accion observable: notificacion, mensaje en UI,
email, alerta, cambio visible en pantalla, etc.]

**Actor que recibe la accion:**

- **Tipo:** [Usuario interno|Usuario externo|Sistema externo]
- **Rol especifico:** [Analista, Supervisor, Admin, etc.]
- **Canal:** [Pantalla/UI, Email, SMS, Notificacion push, etc.]

**Contenido de la accion:**

[Que informacion se comunica al actor: texto del mensaje, datos
mostrados, formato, etc.]

**Timing:**

[Cuando se ejecuta: inmediatamente, con delay, en horario especifico,
tras N minutos, etc.]

**Genera UC completo:** SI (obligatorio para Desencadenadores)

**Ejemplo (BR-IACT-031 - Desencadenador):**

Test de observabilidad:
- ¿Usuario VE algo? → SI (ve modal/notificacion)
- Conclusion: Es DESENCADENADOR

Desencadena:
- Modal emergente en UI con mensaje: "Su sesion expirara en 3 minutos.
  ¿Desea extenderla?"

Actor:
- Usuario autenticado (cualquier rol)
- Canal: Pantalla/UI (modal JavaScript)

Timing:
- Cuando last_activity_at + 12 minutos = NOW()
  (3 minutos antes de expiracion)

Genera UC:
- UC_IACT_AUTH_07_Notificar_Sesion_Proxima_Expiracion_4_0_0.rst

4.4 Si es INFERENCIA
~~~~~~~~~~~~~~~~~~~~

**TEST DE OBSERVABILIDAD (CRITICO):**

Pregunta: ¿El usuario VE algo como resultado directo de esta BR?

- [ ] SI → Es DESENCADENADOR (genera UC completo)
- [ ] NO → Es INFERENCIA (NO genera UC, solo FR)

**¿Que cambia internamente?**

[Descripcion del cambio silencioso: campo en BD, estado interno,
flag, timestamp, calculo no visible, etc.]

**Tabla/Campo afectado:**

- **Tabla:** [nombre_tabla]
- **Campo:** [nombre_campo]
- **Valor anterior:** [estado previo]
- **Valor nuevo:** [estado resultante]

**Actor que recibe:** Ninguno (cambio silencioso en sistema)

**Trigger del cambio:**

[Que evento interno o temporal dispara el cambio: cron job, tiempo
transcurrido, condicion de BD, etc.]

**Genera UC completo:** NO (las Inferencias solo derivan FR directo)

**Patron de implementacion:**

- **NO** generar UC completo
- Derivar FR directamente
- Implementar como UC temporal (actor: Sistema) si es cron job

**Ejemplo (BR-IACT-046 - Inferencia):**

Test de observabilidad:
- ¿Usuario VE algo? → NO (solo cambia BD)
- Conclusion: Es INFERENCIA

Cambia:
- Campo sessions.status pasa de 'ACTIVE' a 'EXPIRED'

Tabla afectada:
- Tabla: ivr_sessions
- Campo: status
- Anterior: 'ACTIVE'
- Nuevo: 'EXPIRED'

Actor: Ninguno (cambio silencioso)

Trigger:
- Cron job cada 1 minuto
- Condicion: last_activity_at + 15 min < NOW()

NO genera UC completo:
- Deriva FR-AUTH-08-02 directamente
- Se implementa en UC_IACT_AUTH_08_Marcar_Sesiones_Expiradas (temporal)

4.5 Si es DEFINICION
~~~~~~~~~~~~~~~~~~~~

**Termino definido:**

[Palabra, concepto o entidad del dominio que se esta definiendo]

**Definicion formal:**

[Definicion precisa, sin ambiguedad, que puede usarse para determinar
inequivocamente si algo pertenece o no a esta categoria]

**Atributos o criterios:**

Criterio 1: [Condicion que debe cumplirse]

Criterio 2: [Otra condicion]

Criterio 3: [Otra condicion]

**Ejemplos (instancias que SI cumplen):**

1. [Ejemplo concreto 1 con explicacion]
2. [Ejemplo concreto 2 con explicacion]
3. [Ejemplo concreto 3 con explicacion]

**Contraejemplos (instancias que NO cumplen):**

1. [Contraejemplo 1 con explicacion de por que NO cumple]
2. [Contraejemplo 2 con explicacion]

**Uso en el sistema:**

[Como se utiliza esta definicion: en queries, en validaciones,
en logica de negocio, en reportes, etc.]

**Ejemplo (BR-IACT-001 - Definicion):**

Termino: Cliente Activo

Definicion:
Un cliente se considera activo si cumple AL MENOS UNA de estas condiciones
en los ultimos 90 dias:
- Ha realizado una llamada al IVR
- Ha iniciado sesion en el sistema
- Ha sido contactado por el equipo de operaciones

Criterios:
1. Existe registro en ivr_calls con call_date >= NOW() - INTERVAL '90 days'
   O
2. Existe registro en ivr_sessions con created_at >= NOW() - INTERVAL '90 days'
   O
3. Existe registro en customer_contacts con contact_date >= NOW() - INTERVAL '90 days'

Ejemplos SI cumplen:
1. Cliente que llamo hace 30 dias → ACTIVO
2. Cliente que inicio sesion ayer → ACTIVO
3. Cliente que fue contactado hace 89 dias → ACTIVO

Contraejemplos NO cumplen:
1. Cliente que llamo hace 91 dias → INACTIVO (fuera de ventana)
2. Cliente sin llamadas, sesiones ni contactos → INACTIVO
3. Cliente dado de baja (aunque cumpla criterios) → INACTIVO

Uso:
- Query en reportes: WHERE cliente_id IN (SELECT ... [criterios])
- Dashboard: Filtro "Mostrar solo activos"
- Segmentacion: Campanas dirigidas a clientes activos

----------------------------------------------------------------------
SECCION 5: GENERA UC (Forward Traceability)
----------------------------------------------------------------------

.. note::
   REGLAS DE TRANSFORMACION BR → UC:
   
   - Restriccion → Precondicion + Flujo Alterno en UC existente
   - Calculo → Paso en UC existente (NO genera UC propio)
   - Desencadenador → UC completo NUEVO
   - Inferencia → NO genera UC (solo FR directo)
   - Definicion → Glosario (NO genera UC)

5.1 UC Generados o Afectados
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Si esta BR genera UC nuevo:**

- **UC Generado:**
  
  - ID: UC_IACT_XXX_YY_[Nombre]_4_0_0.rst
  - Nombre: [Nombre del UC]
  - Actor principal: [Usuario o Sistema]
  - Tipo: [Normal|Temporal|CRUD]

**Si esta BR afecta UC existente:**

- **UC Afectado:**
  
  - ID: UC_IACT_XXX_YY_[Nombre]_4_0_0.rst
  - Donde se implementa: [Paso N del flujo normal | FA-X | Precondicion]
  - Tipo de impacto: [Agrega validacion | Modifica flujo | Nueva precondicion]

**Si esta BR NO genera UC:**

- **Razon:** [Es Calculo | Es Inferencia | Es Definicion]
- **Implementacion directa:** FR_XXX_YY_ZZ_[Nombre]_1_0_0.rst

**Ejemplos por tipo:**

Restriccion (BR-IACT-028):
- Afecta UC_IACT_RPT_01
- Implementa en: Precondicion + FA-2 (Consulta Requiere Aprobacion)

Calculo (BR-IACT-053):
- NO genera UC propio
- Se usa en paso 8 de UC_IACT_RPT_01

Desencadenador (BR-IACT-031):
- Genera UC_IACT_AUTH_07_Notificar_Sesion_4_0_0.rst (NUEVO)

Inferencia (BR-IACT-046):
- NO genera UC
- Deriva FR_AUTH_08_02_Marcar_Expiradas_1_0_0.rst

Definicion (BR-IACT-001):
- NO genera UC
- Se usa en WHERE clauses de multiples UC

5.2 Patron de Implementacion Detallado
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

[Describir paso a paso como esta BR se materializa en UC y FR]

**Paso 1:** [Primer paso de transformacion]

**Paso 2:** [Siguiente paso]

**Paso 3:** [Resultado final]

**Codigo de ejemplo (si aplica):**

.. code-block:: python

   # Implementacion de BR-IACT-XXX
   def funcion_que_implementa_br():
       """
       Implements: BR-IACT-XXX
       Derived from: UC-IACT-YYY-ZZ (paso N)
       """
       # Codigo...

----------------------------------------------------------------------
SECCION 6: TRAZABILIDAD FORWARD COMPLETA
----------------------------------------------------------------------

Arbol de trazabilidad desde esta BR hasta codigo y tests:

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
     └─> BR-IACT-028 (Aprobacion Consultas Grandes)
           |
           └─> UC_IACT_RPT_01_Consultar_Reporte_4_0_0.rst
                 |
                 ├─> Paso 5 → FR_RPT_01_07_Calcular_Count_1_0_0.rst
                 |              |
                 |              └─> reports_1_0_0/services.py::calculate_query_count (linea 234)
                 |                    |
                 |                    └─> tests/test_reports.py::test_calculate_count_small
                 |                    └─> tests/test_reports.py::test_calculate_count_large
                 |
                 └─> FA-2 → FR_RPT_01_10_Crear_Approval_1_0_0.rst
                              |
                              └─> reports_1_0_0/approvals.py::create_approval (linea 89)
                                    |
                                    └─> tests/test_approvals.py::test_create_approval

----------------------------------------------------------------------
SECCION 7: IMPACTO DE CAMBIOS
----------------------------------------------------------------------

7.1 Analisis de Impacto
~~~~~~~~~~~~~~~~~~~~~~~~

**Si esta BR cambiara, se verian afectados:**

**UC afectados:**

- [ ] UC_IACT_XXX_YY → [Tipo de cambio necesario]
- [ ] UC_IACT_AAA_BB → [Tipo de cambio necesario]

**FR afectados:**

- [ ] FR_XXX_YY_01 → [Modificacion necesaria]
- [ ] FR_XXX_YY_02 → [Modificacion necesaria]

**Archivos de codigo:**

- [ ] modulo_1_0_0/archivo.py → [Funcion(es) a modificar]
- [ ] modulo_1_0_0/otro.py → [Funcion(es) a modificar]

**Tests afectados:**

- [ ] tests/test_modulo.py → [Test(s) a actualizar]
- [ ] tests/test_integracion.py → [Test(s) a actualizar]

**Stakeholders a notificar:**

- [ ] [Nombre - Rol] → [Razon de notificacion]
- [ ] [Nombre - Rol] → [Razon de notificacion]

7.2 Escenarios de Cambio
~~~~~~~~~~~~~~~~~~~~~~~~~

**Escenario 1: Cambio de valor umbral**

Ejemplo: Cambiar umbral de 10,000 a 5,000 registros

- UC: Actualizar documentacion en UC_IACT_RPT_01 (FA-2)
- FR: Modificar FR_RPT_01_07 (cambiar constante)
- Codigo: reports_1_0_0/services.py linea 240 (THRESHOLD = 5000)
- Tests: Actualizar valores en test_calculate_count_large
- Esfuerzo: 1 hora
- Riesgo: Bajo

**Escenario 2: Cambio de logica**

Ejemplo: Cambiar de "aprobacion supervisor" a "limitar resultados"

- UC: Reescribir FA-2 completo
- FR: Eliminar FR approval, crear FR pagination
- Codigo: Refactor completo de approvals.py
- Tests: Reescribir suite de tests de approvals
- Esfuerzo: 8 horas
- Riesgo: Alto

7.3 Estimacion de Esfuerzo
~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Riesgo estimado:** [Bajo|Medio|Alto]

**Esfuerzo estimado por actividad:**

- Actualizacion de documentacion: [X horas]
- Modificacion de codigo: [Y horas]
- Actualizacion de tests: [Z horas]
- Testing y validacion: [W horas]
- **Total:** [X+Y+Z+W horas]

**Recursos necesarios:**

- Business Analyst: [X horas]
- Developer: [Y horas]
- QA Engineer: [Z horas]

----------------------------------------------------------------------
SECCION 8: VALIDACION Y TESTING
----------------------------------------------------------------------

8.1 Como se Valida esta BR
~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Test Funcional Manual:**

**Precondiciones:**

1. [Condicion 1]
2. [Condicion 2]

**Pasos:**

1. [Paso de test]
2. [Paso de test]
3. [Paso de test]

**Resultado Esperado:**

[Descripcion del resultado que demuestra que BR se cumple]

**Resultado Actual:**

[A completar durante testing]

8.2 Tests Automatizados
~~~~~~~~~~~~~~~~~~~~~~~~

**Tests Unitarios:**

.. code-block:: python

   # tests/test_[modulo].py
   
   def test_br_iact_xxx_caso_normal():
       """
       Valida BR-IACT-XXX en caso normal.
       
       Given: [Condicion]
       When: [Accion]
       Then: [Resultado esperado]
       """
       # Arrange
       param1 = valor1
       param2 = valor2
       
       # Act
       resultado = funcion_bajo_test(param1, param2)
       
       # Assert
       assert resultado == valor_esperado

   def test_br_iact_xxx_caso_borde():
       """Valida BR en caso de borde."""
       # ...

   def test_br_iact_xxx_caso_error():
       """Valida manejo de errores."""
       # ...

**Tests de Integracion:**

.. code-block:: python

   def test_br_iact_xxx_flujo_completo():
       """
       Valida BR-IACT-XXX en flujo end-to-end.
       
       Validates: BR-IACT-XXX
       Related UC: UC-IACT-YYY-ZZ
       """
       # Test completo...

8.3 Criterios de Aceptacion de Tests
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Para considerar esta BR validada:**

- [ ] Tests unitarios pasan 100%
- [ ] Tests de integracion pasan 100%
- [ ] Test manual ejecutado y documentado
- [ ] Cobertura de codigo >= 80% en funciones relacionadas
- [ ] Validado por QA Engineer
- [ ] Aprobado por Business Analyst
- [ ] Firmado por Stakeholder

----------------------------------------------------------------------
SECCION 9: NOTAS Y EXCEPCIONES
----------------------------------------------------------------------

9.1 Excepciones Conocidas
~~~~~~~~~~~~~~~~~~~~~~~~~~

**Excepcion 1: [Situacion excepcional]**

- **Descripcion:** [Cuando no aplica la BR]
- **Razon:** [Por que existe esta excepcion]
- **Comportamiento alternativo:** [Que hacer en su lugar]

**Excepcion 2: [Otra situacion]**

- **Descripcion:** [...]
- **Razon:** [...]
- **Comportamiento:** [...]

9.2 Notas Tecnicas
~~~~~~~~~~~~~~~~~~

**Consideraciones de implementacion:**

- [Nota tecnica importante]
- [Otra consideracion]
- [Limitaciones conocidas]

**Dependencias externas:**

- [Servicio externo necesario]
- [Libreria o API requerida]
- [Configuracion especial]

9.3 Decisiones de Diseno
~~~~~~~~~~~~~~~~~~~~~~~~~

**Decision 1: [Titulo de la decision]**

- **Fecha:** YYYY-MM-DD
- **Contexto:** [Por que se tomo esta decision]
- **Alternativas consideradas:** [Opciones que se descartaron]
- **Decision tomada:** [Que se decidio]
- **Razon:** [Por que se eligio esta opcion]

**Decision 2: [Otra decision]**

- [...]

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
     - [Descripcion del cambio MINOR]
     - [Nombre del BA]
   * - 2.0.0
     - YYYY-MM-DD
     - [Cambio MAJOR - breaking change]
     - [Nombre del BA]

**Notas sobre versionado:**

- MAJOR (X.0.0): Cambios incompatibles que rompen implementacion actual
- MINOR (0.X.0): Nueva funcionalidad compatible con version anterior
- PATCH (0.0.X): Correcciones y clarificaciones sin cambio funcional

----------------------------------------------------------------------
REFERENCIAS
----------------------------------------------------------------------

**Estándares del Proyecto:**

- STD_001_Estandares_Documentacion_1_1_0.rst
- NOM_001_Nomenclatura_Proyecto_2_0_0.rst

**Material Pedagógico:**

- PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md
  
  - Seccion 2: Taxonomia de Business Rules (5 tipos)
  - Seccion 3: Desencadenadores vs Inferencias (TEST CRITICO)
  - Seccion 4: Documentacion de BR

**Documentos Relacionados:**

- BRQ_XXX_[Nombre]_1_0_0.rst (Business Requirement padre)
- UC_IACT_XXX_YY_[Nombre]_4_0_0.rst (Use Cases generados)
- FR_XXX_YY_ZZ_[Nombre]_1_0_0.rst (Functional Requirements derivados)

**Fuentes Externas:**

- [URL a documento externo si aplica]
- [Referencia a estandar de industria]

----------------------------------------------------------------------
ANEXOS
----------------------------------------------------------------------

ANEXO A: Glosario de Terminos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**[Termino 1]:** [Definicion breve]

**[Termino 2]:** [Definicion breve]

ANEXO B: Diagramas
~~~~~~~~~~~~~~~~~~

[Insertar diagramas de flujo, entidad-relacion, etc. si aplican]

ANEXO C: Ejemplos Adicionales
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

[Ejemplos detallados si son necesarios para clarificar]

----------------------------------------------------------------------

.. note::
   **CHECKLIST DE CALIDAD:**
   
   Antes de marcar esta BR como APPROVED, verificar:
   
   - [ ] Enunciado claro y conciso (1 frase)
   - [ ] Tipo de BR correctamente identificado
   - [ ] Test de observabilidad aplicado (si Desencadenador vs Inferencia)
   - [ ] Trazabilidad backward completa (BReq, Stakeholder)
   - [ ] Criterios de aceptacion medibles
   - [ ] Seccion de tipo BR completamente llenada
   - [ ] Trazabilidad forward documentada (UC, FR, codigo)
   - [ ] Impacto de cambios analizado
   - [ ] Tests definidos (manual y automatizados)
   - [ ] Metadata correcta al inicio
   - [ ] Version semántica aplicada
   - [ ] Referencias actualizadas

**REGLA DE ORO:**

Si no puedes decidir si es Desencadenador o Inferencia,
aplica el TEST DE OBSERVABILIDAD:

¿El usuario VE algo? → SI = Desencadenador | NO = Inferencia

----------------------------------------------------------------------

**Archivo:** TPL_BR_Decision_Tipo_1_1_0.rst  
**Version Template:** 1.1.0  
**Fecha Creacion Template:** 2026-01-09  
**Autor Template:** Sistema de Regeneracion IACT

