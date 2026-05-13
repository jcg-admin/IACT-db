.. meta::
   :Proyecto: IACT
   :Codigo: UC-IACT-XXX-YY
   :Titulo: [Nombre del Caso de Uso - Técnica Larman]
   :Version: 4.0.0
   :Tecnica: Larman (Operation Contracts + GRASP)
   :Modulo: [MOD]
   :Fecha: YYYY-MM-DD
   :Autor: [Nombre BA]

======================================================================
UC-IACT-XXX-YY: [Nombre] (Técnica Larman)
======================================================================

**Proyecto:** IACT  
**Técnica:** Craig Larman - Operation Contracts + GRASP Patterns  
**Enfoque:** Diseño Orientado a Objetos

----------------------------------------------------------------------
INTRODUCCION A LA TECNICA LARMAN
----------------------------------------------------------------------

**¿Qué es la Técnica Larman?**

Craig Larman propone documentar Use Cases usando:

1. **Operation Contracts (Contratos de Operación)**
   - Definen QUÉ debe lograr una operación del sistema
   - No describen CÓMO (eso es diseño)
   - Formato: Precondiciones + Postcondiciones

2. **GRASP Patterns (Patrones de Asignación de Responsabilidades)**
   - 9 patrones para asignar responsabilidades a clases
   - Responden: ¿QUÉ clase hace QUÉ?
   - Fundamento para diseño OOP

**¿Cuándo usar este template?**

- Proyectos orientados a objetos (Python, Java, C#)
- Necesidad de diseño detallado antes de codificar
- Equipos familiarizados con UML y OOP
- Sistemas complejos donde diseño es crítico

**Diferencia con UC estándar:**

- UC estándar: Perspectiva del usuario (qué ve, qué hace)
- UC Larman: Perspectiva del sistema (qué cambia internamente)

**Bibliografía:**

- Larman, Craig. "Applying UML and Patterns" (3rd Edition, 2004)
- Gamma et al. "Design Patterns: Elements of Reusable OO Software"

----------------------------------------------------------------------
CONTRATOS DE OPERACION
----------------------------------------------------------------------

**Estructura de un Contrato:**

.. code-block:: text

   Operación: nombreOperacion(parametro1, parametro2)
   
   Responsabilidades: Qué debe lograr esta operación
   
   Tipo: [Comando|Consulta]
   
   Referencias: UC-IACT-XXX-YY paso N
   
   Precondiciones: Estado del sistema ANTES
   
   Postcondiciones: Cambios en estado del sistema DESPUÉS

**Postcondiciones - Formato Estándar:**

Las postcondiciones describen cambios en 3 categorías:

1. **Instancias creadas o eliminadas**
   
   Formato: "Instancia i de Clase C fue creada/eliminada"

2. **Atributos modificados**
   
   Formato: "i.atributo se estableció en valor"

3. **Asociaciones formadas o rotas**
   
   Formato: "Asociación entre i y j fue formada/rota"

CONTRATO 1: Operación Principal del UC
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Operación:** nombreOperacion(param1: Tipo1, param2: Tipo2): TipoRetorno

**Responsabilidades:**

Descripción en 1-2 oraciones de QUÉ debe lograr esta operación
del punto de vista del negocio.

**Tipo:** Comando (modifica estado) | Consulta (solo lee)

**Referencias:**

- UC-IACT-XXX-YY: [Nombre del UC] (paso N del flujo normal)
- BR-IACT-ZZZ: [Nombre de BR implementada]

**Precondiciones:**

PRE-1: [Condición que debe ser verdadera antes de ejecutar]

.. code-block:: text

   Ejemplo: Usuario con id=:userId existe
   
   Verificación SQL:
   SELECT 1 FROM users WHERE id = :userId

PRE-2: [Otra precondición]

.. code-block:: text

   Ejemplo: Usuario tiene permiso 'RPT-001'
   
   Verificación:
   SELECT 1 FROM user_permissions
   WHERE user_id = :userId AND permission = 'RPT-001'

PRE-3: [Otra precondición]

**Postcondiciones:**

POST-1: Instancia r de Report fue creada

.. code-block:: text

   r.id = nuevo UUID
   r.quarter = :quarter
   r.year = :year
   r.segment = :segment
   r.status = 'GENERATED'
   r.created_at = NOW()
   r.created_by = :userId

POST-2: Atributos calculados fueron establecidos

.. code-block:: text

   r.total_calls = (resultado de COUNT query)
   r.abandoned_calls = (resultado de COUNT WHERE status='ABANDONED')
   r.abandon_rate = (abandoned_calls / total_calls) * 100

POST-3: Asociación entre Report y User fue formada

.. code-block:: text

   r.generated_by apunta a → User(id=userId)

POST-4: Instancia a de AuditLog fue creada

.. code-block:: text

   a.action = 'CREATE'
   a.table_name = 'reports'
   a.record_id = r.id
   a.user_id = userId
   a.created_at = NOW()

**Ejemplo Completo - generarReporteTrimestral:**

Operación: generarReporteTrimestral(quarter: String, year: Integer, 
                                    segment: String, userId: UUID): Report

Responsabilidades:
Generar un reporte trimestral consolidado de métricas IVR para
un segmento específico de usuarios.

Tipo: Comando

Referencias:
- UC-IACT-RPT-01: Consultar Reporte Trimestral (paso 8)
- BR-IACT-053: Cálculo de Tasa de Abandono

Precondiciones:

PRE-1: Usuario con id=userId existe

PRE-2: Usuario tiene permiso 'RPT-001' asignado

PRE-3: quarter está en conjunto {'Q1', 'Q2', 'Q3', 'Q4'}

PRE-4: year está en rango [2020..2025]

PRE-5: segment está en conjunto {'OP', 'MG', 'AD'}

Postcondiciones:

POST-1: Instancia r de Report creada con:
  - r.id = UUID generado
  - r.quarter = quarter
  - r.year = year
  - r.segment = segment
  - r.status = 'GENERATED'
  - r.total_calls = COUNT(*)
  - r.abandoned_calls = COUNT(*) WHERE status='ABANDONED'
  - r.abandon_rate = (abandoned / total) * 100

POST-2: Asociación formada:
  - r.generated_by → User(id=userId)

POST-3: Instancia a de AuditLog creada

----------------------------------------------------------------------
GRASP PATTERNS - ASIGNACION DE RESPONSABILIDADES
----------------------------------------------------------------------

**¿Qué son los GRASP Patterns?**

GRASP = General Responsibility Assignment Software Patterns

Son 9 patrones para decidir QUÉ clase tiene QUÉ responsabilidad.

Los 9 Patrones GRASP
~~~~~~~~~~~~~~~~~~~~

1. Information Expert
2. Creator
3. Controller
4. Low Coupling
5. High Cohesion
6. Polymorphism
7. Pure Fabrication
8. Indirection
9. Protected Variations

GRASP 1: Information Expert
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Principio:**

Asignar responsabilidad a la clase que tiene la INFORMACIÓN necesaria
para cumplir con la responsabilidad.

**Pregunta:** ¿Qué clase tiene los datos necesarios?

**Ejemplo - Cálculo de Tasa de Abandono:**

.. code-block:: text

   Responsabilidad: Calcular tasa de abandono
   
   Información necesaria:
   - total_calls (entero)
   - abandoned_calls (entero)
   
   ¿Qué clase tiene estos datos?
   → Clase Report (tiene ambos atributos)
   
   Decisión: Report.calculateAbandonRate()

**Código:**

.. code-block:: python

   class Report:
       def __init__(self):
           self.total_calls = 0
           self.abandoned_calls = 0
           self.abandon_rate = 0.0
       
       def calculate_abandon_rate(self):
           """
           Information Expert: Report tiene la info necesaria
           """
           if self.total_calls > 0:
               self.abandon_rate = (
                   self.abandoned_calls / self.total_calls
               ) * 100
           else:
               self.abandon_rate = 0.0

**Beneficio:** Encapsulación - los datos y el comportamiento están juntos

GRASP 2: Creator
~~~~~~~~~~~~~~~~

**Principio:**

Asignar a clase A la responsabilidad de crear instancias de clase B si:

- A contiene/agrega B
- A registra B
- A usa estrechamente B
- A tiene datos iniciales para B

**Pregunta:** ¿Quién debe crear instancias de X?

**Ejemplo - Crear Report:**

.. code-block:: text

   ¿Quién crea instancias de Report?
   
   Opciones:
   A) User - tiene asociación con Report pero no lo agrega
   B) ReportService - contiene/agrega/registra Reports
   C) ReportFactory - solo crea, no contiene
   
   Decisión: ReportService
   
   Razones:
   - Contiene/agrega Reports
   - Registra Reports en BD
   - Tiene datos iniciales (quarter, year, segment)
   - Inicializa Reports con datos del sistema

**Código:**

.. code-block:: python

   class ReportService:
       def __init__(self, repository: ReportRepository):
           self.repository = repository
           self.reports = []  # Agrega/contiene Reports
       
       def generate_quarterly_report(self, quarter, year, segment):
           """
           Creator: ReportService crea Reports porque los agrega
           """
           report = Report(
               id=uuid4(),
               quarter=quarter,
               year=year,
               segment=segment
           )
           
           # Inicializa con datos
           report.total_calls = self._query_total(quarter, year, segment)
           report.abandoned_calls = self._query_abandoned(quarter, year, segment)
           
           self.reports.append(report)
           self.repository.save(report)
           
           return report

**Beneficio:** Bajo acoplamiento - creación centralizada

GRASP 3: Controller
~~~~~~~~~~~~~~~~~~~

**Principio:**

Asignar responsabilidad de manejar eventos del sistema a una clase que
representa:

- El sistema completo (Facade Controller)
- Un escenario de caso de uso (Use Case Controller)

**Pregunta:** ¿Quién recibe y coordina operaciones del sistema?

**Ejemplo - Generar Reporte:**

.. code-block:: text

   Operación del sistema: generarReporteTrimestral()
   
   Opciones:
   A) Facade Controller: ReportController (para TODAS las operaciones de reportes)
   B) Use Case Controller: GenerateQuarterlyReportHandler (para esta operación específica)
   
   Decisión: GenerateQuarterlyReportHandler
   
   Razones:
   - Alta cohesión (una sola responsabilidad)
   - Bajo acoplamiento (no depende de otras operaciones)
   - Testeable aisladamente
   - Sigue patrón Command/Handler

**Código:**

.. code-block:: python

   class GenerateQuarterlyReportHandler:
       """
       Controller: Coordina operación generarReporteTrimestral
       """
       def __init__(
           self,
           report_service: ReportService,
           auth_service: IAuthorizationService
       ):
           self.report_service = report_service
           self.auth_service = auth_service
       
       def handle(self, command: GenerateQuarterlyReportCommand):
           """
           Coordina la operación completa
           """
           # Verificar precondiciones
           self.auth_service.check_permission(
               command.user_id, 'RPT-001'
           )
           
           # Delegar a servicio
           report = self.report_service.generate_quarterly_report(
               command.quarter,
               command.year,
               command.segment
           )
           
           return report

**Beneficio:** Separación de coordinación y lógica de negocio

GRASP 4: Low Coupling
~~~~~~~~~~~~~~~~~~~~~

**Principio:**

Asignar responsabilidades para minimizar dependencias entre clases.

**Pregunta:** ¿Cómo reducir dependencias?

**Ejemplo - Autorización:**

.. code-block:: text

   Problema: ReportService necesita validar permisos
   
   Mal diseño (ALTO acoplamiento):
   ReportService → UserPermissionRepository
   ReportService → PermissionValidator
   ReportService → User
   
   Buen diseño (BAJO acoplamiento):
   ReportService → IAuthorizationService (interface)
   
   Implementación concreta está separada

**Código Mal Diseño:**

.. code-block:: python

   class ReportService:
       def __init__(self, db_session):
           self.session = db_session
       
       def generate_report(self, user_id):
           # ALTO ACOPLAMIENTO: conoce detalles de DB
           user = self.session.query(User).get(user_id)
           perms = self.session.query(Permission).filter(
               Permission.user_id == user_id
           ).all()
           
           if 'RPT-001' not in [p.code for p in perms]:
               raise Unauthorized()

**Código Buen Diseño:**

.. code-block:: python

   class IAuthorizationService(ABC):
       @abstractmethod
       def check_permission(self, user_id, permission):
           pass
   
   class ReportService:
       def __init__(self, auth_service: IAuthorizationService):
           self.auth_service = auth_service  # BAJO ACOPLAMIENTO
       
       def generate_report(self, user_id):
           # No conoce implementación de autorización
           self.auth_service.check_permission(user_id, 'RPT-001')

**Beneficio:** Cambios en autorización no afectan ReportService

GRASP 5: High Cohesion
~~~~~~~~~~~~~~~~~~~~~~

**Principio:**

Mantener objetos enfocados, manejables y comprensibles.
Una clase = una responsabilidad bien definida.

**Pregunta:** ¿Esta clase hace demasiado?

**Ejemplo - Report con Baja Cohesión:**

.. code-block:: python

   # MALA COHESIÓN: Report hace demasiado
   class Report:
       def calculate_metrics(self): pass
       def validate_params(self): pass  # No debería estar aquí
       def execute_sql(self): pass  # No debería estar aquí
       def format_to_json(self): pass  # No debería estar aquí
       def send_email(self): pass  # No debería estar aquí
       def generate_pdf(self): pass  # No debería estar aquí

**Ejemplo - Alta Cohesión:**

.. code-block:: python

   # ALTA COHESIÓN: Cada clase una responsabilidad
   
   class Report:
       """Solo dominio: atributos y cálculos de negocio"""
       def calculate_metrics(self):
           self.abandon_rate = (self.abandoned / self.total) * 100
   
   class ReportValidator:
       """Solo validación"""
       def validate_params(self, quarter, year, segment):
           pass
   
   class ReportRepository:
       """Solo persistencia"""
       def save(self, report): pass
       def find_by_id(self, id): pass
   
   class ReportSerializer:
       """Solo serialización"""
       def to_json(self, report): pass
       def to_xml(self, report): pass
   
   class ReportNotifier:
       """Solo notificaciones"""
       def send_email(self, report, recipient): pass
   
   class ReportExporter:
       """Solo exportación"""
       def to_pdf(self, report): pass
       def to_excel(self, report): pass

**Beneficio:** Mantenible, testeable, comprensible

GRASP 6: Polymorphism
~~~~~~~~~~~~~~~~~~~~~

**Principio:**

Usar polimorfismo para manejar alternativas basadas en tipo,
en lugar de if-else por tipo.

**Pregunta:** ¿Cómo manejar variaciones por tipo sin condicionales?

**Ejemplo Mal Diseño:**

.. code-block:: python

   # MAL: if-else por tipo
   def generate_report(report_type, params):
       if report_type == 'QUARTERLY':
           return generate_quarterly_report(params)
       elif report_type == 'MONTHLY':
           return generate_monthly_report(params)
       elif report_type == 'ANNUAL':
           return generate_annual_report(params)
       else:
           raise ValueError("Unknown type")

**Ejemplo Buen Diseño (Polimorfismo):**

.. code-block:: python

   # BIEN: Polimorfismo
   
   class IReport(ABC):
       @abstractmethod
       def calculate_metrics(self):
           pass
   
   class QuarterlyReport(IReport):
       def calculate_metrics(self):
           # Lógica específica trimestral
           self.metrics = self._calc_quarterly()
   
   class MonthlyReport(IReport):
       def calculate_metrics(self):
           # Lógica específica mensual
           self.metrics = self._calc_monthly()
   
   class AnnualReport(IReport):
       def calculate_metrics(self):
           # Lógica específica anual
           self.metrics = self._calc_annual()
   
   # Cliente usa polimorfismo
   def process_report(report: IReport):
       report.calculate_metrics()  # Llama método correcto automáticamente

**Beneficio:** Fácil agregar nuevos tipos sin modificar código existente

GRASP 7: Pure Fabrication
~~~~~~~~~~~~~~~~~~~~~~~~~~

**Principio:**

Crear una clase que NO representa concepto del dominio, cuando
es necesario para:

- Lograr bajo acoplamiento
- Alta cohesión
- Reutilización

**Pregunta:** ¿Necesito clase que no es del dominio?

**Ejemplo - Repository:**

.. code-block:: text

   Problema: Report necesita persistirse pero no debe conocer SQL
   
   Report es del dominio (entidad de negocio)
   
   SQL/BD NO es del dominio
   
   Solución: Crear ReportRepository (Pure Fabrication)
   
   Repository NO existe en dominio real, es fabricación para diseño

**Código:**

.. code-block:: python

   # Pure Fabrication: NO es concepto de dominio
   class ReportRepository:
       """
       Clase fabricada para manejar persistencia.
       NO existe "Repository" en dominio de negocio IACT.
       """
       def __init__(self, db_connection):
           self.db = db_connection
       
       def save(self, report: Report):
           """Persiste Report sin que Report conozca SQL"""
           self.db.execute("""
               INSERT INTO reports (id, quarter, year, ...)
               VALUES (:id, :quarter, :year, ...)
           """, report.to_dict())
       
       def find_by_id(self, report_id):
           row = self.db.query(
               "SELECT * FROM reports WHERE id = :id",
               {'id': report_id}
           )
           return Report.from_dict(row)

**Beneficio:** Report se mantiene puro (dominio), Repository maneja técnico

GRASP 8: Indirection
~~~~~~~~~~~~~~~~~~~~

**Principio:**

Asignar responsabilidad a objeto intermedio para mediar entre
otros componentes, logrando desacoplamiento.

**Pregunta:** ¿Cómo desacoplar dos componentes?

**Ejemplo - Adapter:**

.. code-block:: text

   Problema: ReportService necesita diferentes motores SQL
   (PostgreSQL, MySQL, etc.)
   
   Mal: ReportService → PostgreSQLConnection (acoplado)
   
   Bien: ReportService → IDatabaseConnection → PostgreSQLConnection
         (desacoplado con indirección)

**Código:**

.. code-block:: python

   # Interface (indirección)
   class IDatabaseConnection(ABC):
       @abstractmethod
       def execute(self, query, params):
           pass
   
   # Implementaciones concretas
   class PostgreSQLConnection(IDatabaseConnection):
       def execute(self, query, params):
           # Lógica PostgreSQL específica
           pass
   
   class MySQLConnection(IDatabaseConnection):
       def execute(self, query, params):
           # Lógica MySQL específica
           pass
   
   # Cliente usa indirección
   class ReportRepository:
       def __init__(self, db: IDatabaseConnection):
           self.db = db  # NO conoce implementación concreta
       
       def save(self, report):
           self.db.execute(...)  # Funciona con cualquier DB

**Beneficio:** Cambiar BD sin modificar ReportRepository

GRASP 9: Protected Variations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Principio:**

Diseñar para que variaciones futuras no impacten otros elementos.
Usar interfaces estables para proteger contra cambios.

**Pregunta:** ¿Cómo diseñar para cambios futuros?

**Ejemplo - Exportación:**

.. code-block:: text

   Problema: Formato de exportación puede variar (PDF, Excel, CSV)
   
   Hoy: Solo PDF
   Mañana: Agregar Excel, CSV, JSON
   
   Solución: Interface estable que protege variaciones

**Código:**

.. code-block:: python

   # Interface estable
   class IReportExporter(ABC):
       @abstractmethod
       def export(self, report: Report, format: str) -> bytes:
           pass
   
   # Implementaciones (pueden variar)
   class PDFExporter(IReportExporter):
       def export(self, report, format='pdf'):
           # Genera PDF
           return pdf_bytes
   
   class ExcelExporter(IReportExporter):
       def export(self, report, format='xlsx'):
           # Genera Excel
           return excel_bytes
   
   # Futuro: Agregar sin modificar cliente
   class CSVExporter(IReportExporter):
       def export(self, report, format='csv'):
           return csv_bytes
   
   # Cliente protegido de variaciones
   class ReportService:
       def __init__(self, exporter: IReportExporter):
           self.exporter = exporter  # Interface estable
       
       def export_report(self, report):
           return self.exporter.export(report)  # NO cambia si agregamos formatos

**Beneficio:** Agregar formatos sin romper código existente

----------------------------------------------------------------------
DIAGRAMA DE SECUENCIA
----------------------------------------------------------------------

Secuencia para: generarReporteTrimestral(quarter, year, segment, userId)

.. code-block:: text

   Actor          Handler         Service       Repository     Database
     |               |               |               |             |
     |--request----->|               |               |             |
     |               |               |               |             |
     |               |--validate---->|               |             |
     |               |  permissions  |               |             |
     |               |<--authorized--|               |             |
     |               |               |               |             |
     |               |--generate---->|               |             |
     |               |   report      |               |             |
     |               |               |               |             |
     |               |               |--calculate--->|             |
     |               |               |   metrics     |             |
     |               |               |               |--SELECT---->|
     |               |               |               |<--rows------|
     |               |               |<--data--------|             |
     |               |               |               |             |
     |               |               |--save-------->|             |
     |               |               |   report      |             |
     |               |               |               |--INSERT---->|
     |               |               |               |<--OK--------|
     |               |               |<--saved-------|             |
     |               |               |               |             |
     |               |<--report------|               |             |
     |               |               |               |             |
     |<--response----|               |               |             |

**Descripción Paso a Paso:**

1. Actor envía request a Handler
2. Handler valida permisos con Service (delegación)
3. Service confirma autorización
4. Handler solicita generar reporte
5. Service calcula métricas vía Repository
6. Repository ejecuta SELECT en Database
7. Database retorna filas
8. Repository procesa datos y retorna
9. Service persiste Report vía Repository
10. Repository ejecuta INSERT
11. Database confirma
12. Repository confirma a Service
13. Service retorna Report a Handler
14. Handler retorna response a Actor

----------------------------------------------------------------------
CODIGO EJEMPLO COMPLETO
----------------------------------------------------------------------

**Aplicando los 9 GRASP Patterns:**

.. code-block:: python

   from abc import ABC, abstractmethod
   from uuid import uuid4
   from datetime import datetime
   
   # GRASP 8: Indirection - Interface para autorización
   class IAuthorizationService(ABC):
       @abstractmethod
       def check_permission(self, user_id, permission):
           pass
   
   # GRASP 7: Pure Fabrication - Repository
   class ReportRepository:
       def __init__(self, db):
           self.db = db
       
       def save(self, report):
           """Persiste report en BD"""
           self.db.execute("""
               INSERT INTO reports (id, quarter, year, ...)
               VALUES (:id, :quarter, :year, ...)
           """, report.to_dict())
       
       def query_metrics(self, quarter, year, segment):
           """Ejecuta queries para métricas"""
           result = self.db.query("""
               SELECT 
                   COUNT(*) as total,
                   COUNT(*) FILTER (WHERE status='ABANDONED') as abandoned
               FROM ivr_calls
               WHERE quarter = :q AND year = :y AND segment = :s
           """, {'q': quarter, 'y': year, 's': segment})
           return result[0]
   
   # Dominio: Report
   class Report:
       def __init__(self, id, quarter, year, segment):
           self.id = id
           self.quarter = quarter
           self.year = year
           self.segment = segment
           self.total_calls = 0
           self.abandoned_calls = 0
           self.abandon_rate = 0.0
       
       # GRASP 1: Information Expert - Report calcula su propia tasa
       def calculate_abandon_rate(self):
           """Information Expert: tiene los datos necesarios"""
           if self.total_calls > 0:
               self.abandon_rate = (
                   self.abandoned_calls / self.total_calls
               ) * 100
           else:
               self.abandon_rate = 0.0
       
       def to_dict(self):
           return {
               'id': str(self.id),
               'quarter': self.quarter,
               'year': self.year,
               'segment': self.segment,
               'total_calls': self.total_calls,
               'abandoned_calls': self.abandoned_calls,
               'abandon_rate': self.abandon_rate
           }
   
   # GRASP 2: Creator + GRASP 5: High Cohesion
   class ReportService:
       """
       Creator: Crea Reports (los agrega/contiene)
       High Cohesion: Solo lógica de reportes
       """
       def __init__(
           self,
           repository: ReportRepository,
           auth_service: IAuthorizationService  # GRASP 4: Low Coupling
       ):
           self.repository = repository
           self.auth_service = auth_service
           self.reports = []
       
       def generate_quarterly_report(self, quarter, year, segment, user_id):
           """Creator: crea y gestiona Reports"""
           # Verificar permiso
           self.auth_service.check_permission(user_id, 'RPT-001')
           
           # Crear Report (Creator)
           report = Report(
               id=uuid4(),
               quarter=quarter,
               year=year,
               segment=segment
           )
           
           # Obtener métricas
           metrics = self.repository.query_metrics(quarter, year, segment)
           report.total_calls = metrics['total']
           report.abandoned_calls = metrics['abandoned']
           
           # Information Expert: Report calcula su tasa
           report.calculate_abandon_rate()
           
           # Persistir
           self.repository.save(report)
           
           self.reports.append(report)
           
           return report
   
   # GRASP 3: Controller
   class GenerateQuarterlyReportHandler:
       """
       Controller: Coordina operación del sistema
       """
       def __init__(self, service: ReportService):
           self.service = service
       
       def handle(self, command):
           """Coordina la operación completa"""
           return self.service.generate_quarterly_report(
               command.quarter,
               command.year,
               command.segment,
               command.user_id
           )

----------------------------------------------------------------------
DERIVACION A FR
----------------------------------------------------------------------

Cada método de las clases deriva un FR:

- FR-RPT-01-01: ReportRepository.query_metrics()
- FR-RPT-01-02: Report.calculate_abandon_rate()
- FR-RPT-01-03: ReportRepository.save()
- FR-RPT-01-04: IAuthorizationService.check_permission()
- FR-RPT-01-05: GenerateQuarterlyReportHandler.handle()

----------------------------------------------------------------------
REFERENCIAS
----------------------------------------------------------------------

**Bibliografía:**

- Larman, Craig. "Applying UML and Patterns" (3rd Ed, 2004)
- Gamma et al. "Design Patterns" (1994)

**Estándares:**

- STD_001_Estandares_Documentacion_1_1_0.rst
- NOM_001_Nomenclatura_Proyecto_2_0_0.rst

**Material Pedagógico:**

- PARTE_3B_Tecnica_Larman_IACT_1_0_0.md

----------------------------------------------------------------------

**Archivo:** TPL_UC_Larman_Contratos_1_2_0.rst  
**Version Template:** 1.2.0  
**Fecha:** 2026-01-09  
**Líneas:** ~650

