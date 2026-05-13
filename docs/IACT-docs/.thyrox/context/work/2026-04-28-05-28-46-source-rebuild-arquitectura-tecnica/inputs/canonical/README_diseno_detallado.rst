Diseño Detallado - Proyecto IACT
================================

Este espacio documenta el diseño detallado de componentes, módulos,
clases y funciones del sistema IACT. Complementa la documentación de
arquitectura con detalles de implementación.

Página padre
------------

-  `Índice de espacios documentales <../index.md>`__

Páginas hijas
-------------

-  `Backend - Diseño
   Detallado <../backend/diseno_detallado/readme.md>`__
-  `Frontend - Diseño
   Detallado <../frontend/diseno_detallado/readme.md>`__
-  `Infrastructure - Diseño
   Detallado <../infrastructure/diseno_detallado/readme.md>`__

Información clave
-----------------

Propósito
~~~~~~~~~

El diseño detallado traduce las decisiones arquitectónicas en
especificaciones concretas de implementación:

-  **Diagramas de clases**: Relaciones y responsabilidades
-  **Diagramas de secuencia**: Flujos de interacción
-  **Esquemas de base de datos**: Modelos de datos
-  **Contratos de API**: Endpoints, requests, responses
-  **Algoritmos críticos**: Pseudocódigo y complejidad

Estructura de Documentación
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Cada componente significativo debe documentarse con:

1. **Propósito**: Qué hace y por qué existe
2. **Responsabilidades**: Qué funcionalidad provee
3. **Dependencias**: Qué otros componentes usa
4. **Interfaces**: Cómo se interactúa con él
5. **Invariantes**: Qué garantías mantiene
6. **Ejemplos de uso**: Código de ejemplo

Componentes Principales
-----------------------

1. ETL Engine (Extracción, Transformación, Carga)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Propósito**: Extrae datos del sistema IVR (MariaDB), aplica
transformaciones y carga resultados en base analítica (PostgreSQL).

**Módulos:**

::

   etl/
   ├── extractors/
   │   ├── ivr_extractor.py       # Extrae datos de MariaDB
   │   └── base_extractor.py      # Clase base para extractores
   ├── transformers/
   │   ├── call_transformer.py    # Transforma datos de llamadas
   │   ├── metrics_calculator.py  # Calcula KPIs
   │   └── base_transformer.py    # Clase base para transformers
   ├── loaders/
   │   ├── analytics_loader.py    # Carga a PostgreSQL
   │   └── base_loader.py         # Clase base para loaders
   └── orchestrator.py            # Orquesta el proceso ETL

**Diagrama de Flujo:**

::

   IVR DB (MariaDB) -> Extractor -> Transformer -> Loader -> Analytics DB (PostgreSQL)
                                       ↓
                               Metrics Calculator
                                       ↓
                               Validation Layer

2. Analytics Core
~~~~~~~~~~~~~~~~~

**Propósito**: Calcula métricas y KPIs del call center.

**KPIs Principales:** - **AHT** (Average Handling Time): Tiempo promedio
de atención - **ASA** (Average Speed of Answer): Tiempo promedio de
respuesta - **FCR** (First Call Resolution): Tasa de resolución en
primera llamada - **Abandonment Rate**: Tasa de abandono - **Service
Level**: % de llamadas atendidas en tiempo objetivo

**Módulos:**

::

   analytics/
   ├── metrics/
   │   ├── aht_calculator.py
   │   ├── asa_calculator.py
   │   ├── fcr_calculator.py
   │   └── base_metric.py
   ├── aggregators/
   │   ├── hourly_aggregator.py
   │   ├── daily_aggregator.py
   │   └── monthly_aggregator.py
   └── reports/
       ├── performance_report.py
       └── trend_report.py

3. Database Layer
~~~~~~~~~~~~~~~~~

**Conexiones Multi-Database:**

.. code:: python

   # Django settings.py
   DATABASES = {
       'default': {  # PostgreSQL - Analytics
           'ENGINE': 'django.db.backends.postgresql',
           'NAME': 'iact_analytics',
           'HOST': '127.0.0.1',
           'PORT': '15432',
       },
       'ivr': {  # MariaDB - Read-only
           'ENGINE': 'django.db.backends.mysql',
           'NAME': 'iact_ivr',
           'HOST': '127.0.0.1',
           'PORT': '13306',
           'OPTIONS': {
               'read_default_file': '/etc/mysql/my.cnf',
           },
       }
   }

**Modelos Principales:**

.. code:: python

   # models/call.py
   class Call(models.Model):
       """Representa una llamada procesada."""
       call_id = models.CharField(max_length=50, unique=True)
       duration = models.IntegerField()
       queue_time = models.IntegerField()
       agent_id = models.IntegerField()
       start_time = models.DateTimeField()
       end_time = models.DateTimeField()

       class Meta:
           db_table = 'analytics_calls'
           indexes = [
               models.Index(fields=['start_time']),
               models.Index(fields=['agent_id']),
           ]

   # models/metrics.py
   class DailyMetrics(models.Model):
       """Métricas agregadas por día."""
       date = models.DateField(unique=True)
       total_calls = models.IntegerField()
       avg_handling_time = models.FloatField()
       avg_speed_answer = models.FloatField()
       abandonment_rate = models.FloatField()

       class Meta:
           db_table = 'analytics_daily_metrics'

Patrones de Diseño Utilizados
-----------------------------

Repository Pattern
~~~~~~~~~~~~~~~~~~

.. code:: python

   # repositories/call_repository.py
   class CallRepository:
       """Abstrae el acceso a datos de llamadas."""

       def get_calls_by_date_range(
           self,
           start_date: datetime,
           end_date: datetime
       ) -> List[Call]:
           """Retorna llamadas en rango de fechas."""
           return Call.objects.filter(
               start_time__gte=start_date,
               start_time__lte=end_date
           ).select_related('agent')

       def get_call_by_id(self, call_id: str) -> Optional[Call]:
           """Retorna llamada por ID."""
           try:
               return Call.objects.get(call_id=call_id)
           except Call.DoesNotExist:
               return None

Service Layer Pattern
~~~~~~~~~~~~~~~~~~~~~

.. code:: python

   # services/metrics_service.py
   class MetricsService:
       """Servicio para cálculo de métricas."""

       def __init__(self):
           self.call_repo = CallRepository()

       def calculate_daily_metrics(self, date: datetime.date) -> DailyMetrics:
           """Calcula métricas del día."""
           calls = self.call_repo.get_calls_by_date(date)

           return DailyMetrics(
               date=date,
               total_calls=len(calls),
               avg_handling_time=self._calculate_aht(calls),
               avg_speed_answer=self._calculate_asa(calls),
               abandonment_rate=self._calculate_abandonment(calls)
           )

Factory Pattern
~~~~~~~~~~~~~~~

.. code:: python

   # factories/extractor_factory.py
   class ExtractorFactory:
       """Crea extractores según tipo de fuente."""

       @staticmethod
       def create_extractor(source_type: str) -> BaseExtractor:
           if source_type == 'ivr':
               return IVRExtractor()
           elif source_type == 'crm':
               return CRMExtractor()
           else:
               raise ValueError(f"Unknown source: {source_type}")

Consideraciones de Performance
------------------------------

Optimización de Queries
~~~~~~~~~~~~~~~~~~~~~~~

.. code:: python

   # OK EFICIENTE: Aggregación en DB
   from django.db.models import Avg, Count

   metrics = Call.objects.filter(
       start_time__date=target_date
   ).aggregate(
       avg_duration=Avg('duration'),
       total_calls=Count('id')
   )

   # NO INEFICIENTE: Aggregación en Python
   calls = Call.objects.filter(start_time__date=target_date)
   avg_duration = sum(c.duration for c in calls) / len(calls)

Caching Strategy (Futuro)
~~~~~~~~~~~~~~~~~~~~~~~~~

-  Métricas diarias: Cache de 1 hora
-  Métricas mensuales: Cache de 24 horas
-  Reportes estáticos: Cache indefinido, invalidar on-demand

Esquema de Base de Datos
------------------------

Tablas Principales
~~~~~~~~~~~~~~~~~~

**analytics_calls:** - call_id (VARCHAR, PK) - duration (INTEGER) -
queue_time (INTEGER) - agent_id (INTEGER, FK) - start_time (TIMESTAMP,
INDEX) - end_time (TIMESTAMP) - created_at (TIMESTAMP)

**analytics_daily_metrics:** - id (SERIAL, PK) - date (DATE, UNIQUE,
INDEX) - total_calls (INTEGER) - avg_handling_time (FLOAT) -
avg_speed_answer (FLOAT) - abandonment_rate (FLOAT)

**analytics_agents:** - agent_id (INTEGER, PK) - name (VARCHAR) - email
(VARCHAR) - active (BOOLEAN)

Estado de cumplimiento
----------------------

+--------------------+----------------+-------------------------------+
| Elemento           | Estado         | Observaciones                 |
+====================+================+===============================+
| Diagramas de       | WARNING        | Existen ejemplos en código,   |
| clases             | Parcial        | falta documentar              |
+--------------------+----------------+-------------------------------+
| Diagramas de       | NO Pendiente   | Crear para flujos críticos    |
| secuencia          |                |                               |
+--------------------+----------------+-------------------------------+
| Esquema DB         | OK Sí          | Incluido arriba               |
| documentado        |                |                               |
+--------------------+----------------+-------------------------------+
| Contratos API      | NO Pendiente   | Backend no expone APIs REST   |
|                    |                | aún                           |
+--------------------+----------------+-------------------------------+
| Patrones           | OK Sí          | Repository, Service, Factory  |
| documentados       |                |                               |
+--------------------+----------------+-------------------------------+

Acciones prioritarias
---------------------

-  ☐ Crear diagramas UML de clases principales
-  ☐ Documentar flujos de secuencia para ETL
-  ☐ Especificar contratos de API REST (preparación)
-  ☐ Documentar algoritmos de cálculo de métricas
-  ☐ Crear ejemplos de uso para cada servicio

Recursos relacionados
---------------------

-  `Arquitectura <../arquitectura/readme.md>`__
-  `Lineamientos de Código <../arquitectura/lineamientos_codigo.md>`__
-  `Requisitos <../requisitos/readme.md>`__
-  `Backend <../backend/readme.md>`__
