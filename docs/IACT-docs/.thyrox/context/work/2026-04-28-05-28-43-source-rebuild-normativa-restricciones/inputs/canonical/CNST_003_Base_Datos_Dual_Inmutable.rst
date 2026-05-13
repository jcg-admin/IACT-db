CNST-003: Base de Datos Dual con Inmutabilidad IVR
==================================================

:ID: CNST-003
:Versión: 1.1.0
:Fecha: 2026-01-03
:Estado: VIGENTE
:Clasificación: CRÍTICO - NO NEGOCIABLE
:Origen: Restricción del cliente

----

Propósito
---------

Este documento establece la arquitectura obligatoria de base de datos dual del Sistema IACT - IVR Analytics & Customer Tracking, definiendo la inmutabilidad de la base IVR (solo lectura) y las operaciones permitidas en la base Analytics.

Contexto
--------

Origen de la Restricción
~~~~~~~~~~~~~~~~~~~~~~~~

Restricción de arquitectura impuesta por el cliente. La base de datos IVR es un sistema legacy crítico que alimenta múltiples aplicaciones. IACT NO puede modificar, insertar ni eliminar datos en esta base.

Justificación del Cliente
~~~~~~~~~~~~~~~~~~~~~~~~~

- Base IVR es sistema legacy crítico en producción
- Múltiples aplicaciones dependen de IVR
- Integridad de datos operacionales del call center
- Segregación de responsabilidades entre sistemas
- Auditoría y trazabilidad de datos originales

Aplicable a
~~~~~~~~~~~

- Sistema IACT completo
- Todos los módulos que accedan a datos IVR
- Proceso ETL de sincronización
- APIs de consulta
- Reportes y dashboards

Arquitectura de Datos
---------------------

Diagrama de Arquitectura
~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: text

   ┌─────────────────────────────────────────────────────────────────┐
   │                        SISTEMA IACT                             │
   │                                                                 │
   │  ┌─────────────┐         ┌─────────────┐         ┌───────────┐ │
   │  │   Django    │         │     ETL     │         │   React   │ │
   │  │   REST API  │         │  (Scheduled)│         │ Dashboard │ │
   │  └──────┬──────┘         └──────┬──────┘         └─────┬─────┘ │
   │         │                       │                      │       │
   │         │                       │                      │       │
   │         ▼                       ▼                      ▼       │
   │  ┌─────────────────────────────────────────────────────────┐   │
   │  │              Database Router (Django)                    │   │
   │  │         IVRReadOnlyRouter + AnalyticsRouter             │   │
   │  └────────────────────┬────────────────────────────────────┘   │
   │                       │                                        │
   └───────────────────────┼────────────────────────────────────────┘
                           │
           ┌───────────────┴───────────────┐
           │                               │
           ▼                               ▼
   ┌───────────────────┐         ┌───────────────────┐
   │   BASE IVR        │         │  BASE ANALYTICS   │
   │   (MariaDB)       │         │  (PostgreSQL)     │
   │                   │         │                   │
   │   SOLO LECTURA    │         │   LECTURA Y       │
   │   READ-ONLY       │         │   ESCRITURA       │
   │                   │         │                   │
   │   - calls         │         │   - call_metrics  │
   │   - queues        │         │   - reports       │
   │   - ivr_options   │         │   - users         │
   │                   │         │   - sessions      │
   │   NO INSERT       │         │   - audit_logs    │
   │   NO UPDATE       │         │   - internal_msgs │
   │   NO DELETE       │         │                   │
   └───────────────────┘         └───────────────────┘
        Cliente                       IACT
     (Externo/Legacy)              (Propio)

Bases de Datos
~~~~~~~~~~~~~~

Base IVR (MariaDB) - SOLO LECTURA
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Motor:** MariaDB 10.x (legacy del cliente)
- **Acceso:** Solo SELECT
- **Propietario:** Cliente (sistema legacy)
- **Contenido:** Datos operacionales del IVR

Tablas disponibles (solo lectura):

.. code-block:: sql

   -- Tabla: calls (llamadas del IVR)
   calls (
       call_id BIGINT PRIMARY KEY,
       queue_id INT,
       call_date DATETIME,
       call_duration INT,          -- segundos
       wait_time INT,              -- segundos
       outcome VARCHAR(50),        -- COMPLETED, ABANDONED, TRANSFERRED
       direction VARCHAR(20)       -- INBOUND, OUTBOUND
   )

   -- Tabla: queues (colas del IVR)
   queues (
       queue_id INT PRIMARY KEY,
       queue_name VARCHAR(100),
       queue_type VARCHAR(50),
       is_active BOOLEAN
   )

   -- Tabla: ivr_options (menú IVR)
   ivr_options (
       option_id INT PRIMARY KEY,
       option_key VARCHAR(10),
       option_description VARCHAR(200),
       parent_option_id INT
   )

Base Analytics (PostgreSQL) - LECTURA/ESCRITURA
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Motor:** PostgreSQL 14+
- **Acceso:** SELECT, INSERT, UPDATE, DELETE
- **Propietario:** IACT
- **Contenido:** Datos procesados, usuarios, auditoría

Tablas principales:

.. code-block:: sql

   -- Métricas procesadas por ETL
   call_metrics (
       id SERIAL PRIMARY KEY,
       metric_date DATE,
       queue_id INT,
       total_calls INT,
       completed_calls INT,
       abandoned_calls INT,
       avg_duration DECIMAL(10,2),
       avg_wait_time DECIMAL(10,2),
       created_at TIMESTAMP DEFAULT NOW()
   )

   -- Usuarios del dashboard (RBAC)
   users (
       id SERIAL PRIMARY KEY,
       username VARCHAR(150) UNIQUE,
       password VARCHAR(128),
       email VARCHAR(254),
       is_active BOOLEAN DEFAULT TRUE,
       -- ... campos Django User
   )

   -- Logs de auditoría (CNST-009)
   user_action_logs (
       id SERIAL PRIMARY KEY,
       user_id INT,
       action VARCHAR(50),
       resource VARCHAR(100),
       created_at TIMESTAMP DEFAULT NOW()
   )

   -- Mensajes internos (CNST-001)
   internal_messages (
       id SERIAL PRIMARY KEY,
       recipient_id INT,
       sender_id INT,
       subject VARCHAR(200),
       body TEXT,
       created_at TIMESTAMP DEFAULT NOW()
   )

Configuración Django
--------------------

Settings de Base de Datos
~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/config/settings/base.py

   import os
   from decouple import config

   DATABASES = {
       # Base principal: Analytics (PostgreSQL)
       'default': {
           'ENGINE': 'django.db.backends.postgresql',
           'NAME': config('DB_ANALYTICS_NAME', default='iact_analytics'),
           'USER': config('DB_ANALYTICS_USER'),
           'PASSWORD': config('DB_ANALYTICS_PASSWORD'),
           'HOST': config('DB_ANALYTICS_HOST', default='localhost'),
           'PORT': config('DB_ANALYTICS_PORT', default='5432'),
           'CONN_MAX_AGE': 60,
           'OPTIONS': {
               'connect_timeout': 10,
           },
       },

       # Base IVR: Solo lectura (MariaDB)
       'ivr_readonly': {
           'ENGINE': 'django.db.backends.mysql',
           'NAME': config('DB_IVR_NAME', default='ivr_legacy'),
           'USER': config('DB_IVR_USER'),
           'PASSWORD': config('DB_IVR_PASSWORD'),
           'HOST': config('DB_IVR_HOST'),
           'PORT': config('DB_IVR_PORT', default='3306'),
           'CONN_MAX_AGE': 60,
           'OPTIONS': {
               'connect_timeout': 10,
               'read_default_file': '/etc/mysql/my.cnf',
               'charset': 'utf8mb4',
           },
       },
   }

   # Routers de base de datos
   DATABASE_ROUTERS = [
       'apps.common.routers.IVRReadOnlyRouter',
       'apps.common.routers.AnalyticsRouter',
   ]

Database Router
~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/common/routers.py

   class IVRReadOnlyRouter:
                           
       Router para base de datos IVR (solo lectura).

       CNST-003: Esta base es INMUTABLE.
       Solo permite operaciones SELECT.
       Rechaza INSERT, UPDATE, DELETE.

       Modelos ruteados a IVR:
       - IVRCall
       - IVRQueue
       - IVROption
                  

       IVR_MODELS = {'ivrcall', 'ivrqueue', 'ivroption'}

       def db_for_read(self, model, **hints):
           """Leer de ivr_readonly para modelos IVR."""
           if model._meta.model_name in self.IVR_MODELS:
               return 'ivr_readonly'
           return None

       def db_for_write(self, model, **hints):
                                              
           PROHIBIR escritura en IVR.

           Retorna None para que Django lance error si se intenta escribir.
           El middleware IVRWriteProtection proporciona mensaje más claro.
                                                                          
           if model._meta.model_name in self.IVR_MODELS:
               return None  # Forzar error
           return None

       def allow_relation(self, obj1, obj2, **hints):
                                                     
           Permitir relaciones entre modelos IVR.
           No permitir relaciones cruzadas IVR-Analytics.
                                                         
           obj1_ivr = obj1._meta.model_name in self.IVR_MODELS
           obj2_ivr = obj2._meta.model_name in self.IVR_MODELS

           if obj1_ivr and obj2_ivr:
               return True
           if obj1_ivr or obj2_ivr:
               return False
           return None

       def allow_migrate(self, db, app_label, model_name=None, **hints):
           """NUNCA migrar a base IVR."""
           if db == 'ivr_readonly':
               return False
           if model_name and model_name.lower() in self.IVR_MODELS:
               return False
           return None


   class AnalyticsRouter:
                         
       Router para base de datos Analytics.

       Permite todas las operaciones en modelos propios de IACT.
                                                                

       def db_for_read(self, model, **hints):
           """Leer de default (Analytics)."""
           return 'default'

       def db_for_write(self, model, **hints):
           """Escribir en default (Analytics)."""
           return 'default'

       def allow_relation(self, obj1, obj2, **hints):
           """Permitir relaciones en Analytics."""
           return True

       def allow_migrate(self, db, app_label, model_name=None, **hints):
           """Migrar solo a Analytics."""
           return db == 'default'

Modelos IVR (Solo Lectura)
--------------------------

.. code-block:: python

   # api/apps/ivr/models.py

   from django.db import models

   class IVRCall(models.Model):
                               
       Modelo de llamadas IVR (SOLO LECTURA).

       CNST-003: Este modelo es de solo lectura.
       NO ejecutar save(), create(), update(), delete().

       Uso correcto:
           calls = IVRCall.objects.filter(call_date__gte=start_date)

       Uso PROHIBIDO:
           IVRCall.objects.create(...)  # ERROR
           call.save()                   # ERROR
           call.delete()                 # ERROR
                                                

       call_id = models.BigAutoField(primary_key=True)
       queue_id = models.IntegerField()
       call_date = models.DateTimeField()
       call_duration = models.IntegerField(help_text='Duración en segundos')
       wait_time = models.IntegerField(help_text='Tiempo de espera en segundos')
       outcome = models.CharField(max_length=50)
       direction = models.CharField(max_length=20)

       class Meta:
           managed = False  # Django NO gestiona esta tabla
           db_table = 'calls'

       def save(self, *args, **kwargs):
           """PROHIBIDO: Base IVR es inmutable."""
           raise PermissionError(
               'CNST-003: Base IVR es de solo lectura. '
               'No se permite save() en IVRCall.'
           )

       def delete(self, *args, **kwargs):
           """PROHIBIDO: Base IVR es inmutable."""
           raise PermissionError(
               'CNST-003: Base IVR es de solo lectura. '
               'No se permite delete() en IVRCall.'
           )


   class IVRQueue(models.Model):
                                
       Modelo de colas IVR (SOLO LECTURA).

       CNST-003: Este modelo es de solo lectura.
                                                

       queue_id = models.AutoField(primary_key=True)
       queue_name = models.CharField(max_length=100)
       queue_type = models.CharField(max_length=50)
       is_active = models.BooleanField()

       class Meta:
           managed = False
           db_table = 'queues'

       def save(self, *args, **kwargs):
           raise PermissionError(
               'CNST-003: Base IVR es de solo lectura.'
           )

       def delete(self, *args, **kwargs):
           raise PermissionError(
               'CNST-003: Base IVR es de solo lectura.'
           )


   class IVROption(models.Model):
                                 
       Modelo de opciones del menú IVR (SOLO LECTURA).

       CNST-003: Este modelo es de solo lectura.
                                                

       option_id = models.AutoField(primary_key=True)
       option_key = models.CharField(max_length=10)
       option_description = models.CharField(max_length=200)
       parent_option_id = models.IntegerField(null=True, blank=True)

       class Meta:
           managed = False
           db_table = 'ivr_options'

       def save(self, *args, **kwargs):
           raise PermissionError(
               'CNST-003: Base IVR es de solo lectura.'
           )

       def delete(self, *args, **kwargs):
           raise PermissionError(
               'CNST-003: Base IVR es de solo lectura.'
           )

Middleware de Protección
------------------------

.. code-block:: python

   # api/apps/common/middleware.py

   from django.http import JsonResponse
   import logging

   logger = logging.getLogger('security')

   class IVRWriteProtection:
                            
       Middleware de protección contra escritura en IVR.

       Detecta y bloquea intentos de escritura a base IVR.
       Proporciona logging de intentos para auditoría.

       CNST-003: Capa adicional de protección.
                                              

       def __init__(self, get_response):
           self.get_response = get_response

       def __call__(self, request):
           response = self.get_response(request)
           return response

       def process_exception(self, request, exception):
           """Capturar excepciones de escritura en IVR."""
           if isinstance(exception, PermissionError):
               error_msg = str(exception)

               if 'CNST-003' in error_msg or 'IVR' in error_msg:
                   # Log del intento de violación
                   logger.warning(
                       f'Intento de escritura a IVR bloqueado: '
                       f'User={getattr(request.user, "username", "anonymous")}, '
                       f'Path={request.path}, '
                       f'Method={request.method}'
                   )

                   return JsonResponse(
                       {
                           'error': 'Operación no permitida',
                           'detail': 'La base de datos IVR es de solo lectura (CNST-003)',
                           'code': 'IVR_READONLY'
                       },
                       status=403
                   )

           return None

ETL: Extracción de Datos IVR
----------------------------

Servicio de Extracción
~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/etl/extractors.py

   from django.db import connections
   from datetime import datetime, timedelta
   import logging

   logger = logging.getLogger('etl')

   class IVRDataExtractor:
                          
       Extractor de datos de base IVR.

       CNST-003: Solo operaciones SELECT permitidas.
       CNST-004: ETL cada 6-12 horas.

       Uso:
           extractor = IVRDataExtractor()
           calls = extractor.extract_calls(start_date, end_date)
                                                                

       def __init__(self):
           self.connection = connections['ivr_readonly']

       def extract_calls(self, start_date, end_date):
                                                     
           Extraer llamadas del período especificado.

           Args:
               start_date: Fecha inicio (datetime)
               end_date: Fecha fin (datetime)

           Returns:
               Lista de diccionarios con datos de llamadas
                                                          
           query = """
               SELECT
                   call_id,
                   queue_id,
                   call_date,
                   call_duration,
                   wait_time,
                   outcome,
                   direction
               FROM calls
               WHERE call_date BETWEEN %s AND %s
               ORDER BY call_date
                                 

           with self.connection.cursor() as cursor:
               cursor.execute(query, [start_date, end_date])
               columns = [col[0] for col in cursor.description]

               results = []
               for row in cursor.fetchall():
                   results.append(dict(zip(columns, row)))

               logger.info(
                   f'Extraídas {len(results)} llamadas '
                   f'de {start_date} a {end_date}'
               )

               return results

       def extract_queues(self):
           """Extraer todas las colas activas."""
           query = """
               SELECT queue_id, queue_name, queue_type
               FROM queues
               WHERE is_active = TRUE
                                     

           with self.connection.cursor() as cursor:
               cursor.execute(query)
               columns = [col[0] for col in cursor.description]

               return [
                   dict(zip(columns, row))
                   for row in cursor.fetchall()
               ]

       def get_last_call_date(self):
           """Obtener fecha de última llamada en IVR."""
           query = "SELECT MAX(call_date) FROM calls"

           with self.connection.cursor() as cursor:
               cursor.execute(query)
               result = cursor.fetchone()
               return result[0] if result else None

Transformador de Datos
~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/etl/transformers.py

   from collections import defaultdict
   from decimal import Decimal
   import logging

   logger = logging.getLogger('etl')

   class CallMetricsTransformer:
                                
       Transformador de llamadas IVR a métricas agregadas.

       Transforma datos individuales de llamadas en métricas
       agregadas por día y cola para almacenar en Analytics.
                                                            

       def transform(self, calls):
                                  
           Transformar lista de llamadas en métricas agregadas.

           Args:
               calls: Lista de diccionarios de llamadas

           Returns:
               Lista de métricas agregadas por día/cola
                                                       
           if not calls:
               return []

           # Agrupar por fecha y cola
           grouped = defaultdict(lambda: {
               'total': 0,
               'completed': 0,
               'abandoned': 0,
               'durations': [],
               'wait_times': []
           })

           for call in calls:
               date = call['call_date'].date()
               queue_id = call['queue_id']
               key = (date, queue_id)

               grouped[key]['total'] += 1

               if call['outcome'] == 'COMPLETED':
                   grouped[key]['completed'] += 1
               elif call['outcome'] == 'ABANDONED':
                   grouped[key]['abandoned'] += 1

               grouped[key]['durations'].append(call['call_duration'])
               grouped[key]['wait_times'].append(call['wait_time'])

           # Calcular métricas
           metrics = []
           for (date, queue_id), data in grouped.items():
               avg_duration = (
                   sum(data['durations']) / len(data['durations'])
                   if data['durations'] else 0
               )
               avg_wait = (
                   sum(data['wait_times']) / len(data['wait_times'])
                   if data['wait_times'] else 0
               )

               metrics.append({
                   'metric_date': date,
                   'queue_id': queue_id,
                   'total_calls': data['total'],
                   'completed_calls': data['completed'],
                   'abandoned_calls': data['abandoned'],
                   'avg_duration': Decimal(str(round(avg_duration, 2))),
                   'avg_wait_time': Decimal(str(round(avg_wait, 2)))
               })

           logger.info(f'Transformadas {len(calls)} llamadas en {len(metrics)} métricas')
           return metrics

Cargador a Analytics
~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/etl/loaders.py

   from apps.analytics.models import CallMetric
   from django.db import transaction
   import logging

   logger = logging.getLogger('etl')

   class AnalyticsLoader:
                         
       Cargador de métricas a base Analytics.

       CNST-003: Solo escribe en base Analytics (default).
                                                          

       def load(self, metrics):
                               
           Cargar métricas en base Analytics.

           Usa upsert: actualiza si existe, inserta si no.

           Args:
               metrics: Lista de diccionarios de métricas

           Returns:
               Tupla (insertados, actualizados)
                                               
           inserted = 0
           updated = 0

           with transaction.atomic():
               for metric in metrics:
                   obj, created = CallMetric.objects.update_or_create(
                       metric_date=metric['metric_date'],
                       queue_id=metric['queue_id'],
                       defaults={
                           'total_calls': metric['total_calls'],
                           'completed_calls': metric['completed_calls'],
                           'abandoned_calls': metric['abandoned_calls'],
                           'avg_duration': metric['avg_duration'],
                           'avg_wait_time': metric['avg_wait_time'],
                       }
                   )

                   if created:
                       inserted += 1
                   else:
                       updated += 1

           logger.info(f'Cargadas métricas: {inserted} nuevas, {updated} actualizadas')
           return inserted, updated

Validación en Desarrollo
------------------------

Pre-commit Checklist
~~~~~~~~~~~~~~~~~~~~

Antes de hacer commit, verificar:

.. list-table::
   :header-rows: 0
   :widths: 10 90

   * - [ ]
     - Modelos IVR tienen ``managed = False``
   * - [ ]
     - Modelos IVR sobrescriben ``save()`` y ``delete()`` con error
   * - [ ]
     - NO existe ``IVRCall.objects.create()`` en código
   * - [ ]
     - NO existe ``.save()`` en instancias de modelos IVR
   * - [ ]
     - Router IVRReadOnlyRouter está configurado

Code Review Checklist
~~~~~~~~~~~~~~~~~~~~~

Durante code review, rechazar si:

.. list-table::
   :header-rows: 0
   :widths: 10 90

   * - [ ]
     - Se intenta escribir en base IVR
   * - [ ]
     - Modelos IVR no tienen protección de escritura
   * - [ ]
     - Se ejecutan migraciones hacia base IVR
   * - [ ]
     - Raw queries con INSERT/UPDATE/DELETE a IVR

Script de Validación
~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   #!/bin/bash
   # scripts/validate_ivr_readonly.sh

   echo "Validando inmutabilidad de base IVR..."

   ERRORS=0

   # Buscar intentos de escritura a modelos IVR
   if grep -r "IVRCall.objects.create\|IVRQueue.objects.create" api/apps/; then
       echo "ERROR: Encontrado create() en modelos IVR"
       ERRORS=$((ERRORS + 1))
   fi

   # Buscar .save() en modelos IVR (fuera de la definición del modelo)
   if grep -r "ivr_call.save()\|ivr_queue.save()" api/apps/; then
       echo "ERROR: Encontrado save() en instancias IVR"
       ERRORS=$((ERRORS + 1))
   fi

   # Buscar raw queries peligrosas
   if grep -ri "INSERT INTO calls\|UPDATE calls\|DELETE FROM calls" api/apps/; then
       echo "ERROR: Encontrada query de escritura a tabla calls"
       ERRORS=$((ERRORS + 1))
   fi

   # Verificar que modelos IVR tienen managed=False
   if ! grep -q "managed = False" api/apps/ivr/models.py; then
       echo "ERROR: Modelos IVR no tienen managed=False"
       ERRORS=$((ERRORS + 1))
   fi

   if [ $ERRORS -eq 0 ]; then
       echo "OK: Base IVR está protegida correctamente"
       exit 0
   else
       echo "FALLO: $ERRORS violaciones de CNST-003 encontradas"
       exit 1
   fi

Excepciones
-----------

**NO EXISTEN EXCEPCIONES**

Esta restricción NO tiene excepciones.

Ningún módulo, componente o proceso puede escribir en la base de datos IVR.

Si surge un requerimiento que parezca necesitar modificar datos IVR:

1. Rechazar el requerimiento
2. Escalar al cliente para que modifique sus sistemas
3. Proponer alternativa usando base Analytics

Alternativas Evaluadas y Rechazadas
-----------------------------------

Alternativa 1: Réplica de IVR
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Propuesta:** Crear réplica de base IVR para permitir escritura.

**Rechazada porque:**

- Complejidad de mantener sincronización
- Riesgo de inconsistencia de datos
- Cliente no aprobó infraestructura adicional

Alternativa 2: API del Cliente para Escritura
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Propuesta:** Solicitar API del cliente para escribir en IVR.

**Rechazada porque:**

- Cliente no tiene API disponible
- Sistema IVR es legacy sin interfaces modernas
- Fuera del alcance del proyecto IACT

Referencias
-----------

Documentos Relacionados
~~~~~~~~~~~~~~~~~~~~~~~

- RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md
- CNST-004: Actualización de Datos (ETL)
- CNST-009: Logging y Auditoría

Implementación de Referencia
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- ``api/apps/common/routers.py`` - Database routers
- ``api/apps/ivr/models.py`` - Modelos IVR read-only
- ``api/apps/etl/extractors.py`` - Extracción de datos
- ``api/apps/etl/transformers.py`` - Transformación
- ``api/apps/etl/loaders.py`` - Carga a Analytics

Historial de Cambios
--------------------

.. list-table::
   :header-rows: 1
   :widths: 15 15 50 20

   * - Versión
     - Fecha
     - Cambios
     - Autor
   * - 1.1.0
     - 2026-01-03
     - Actualización RBAC v5.1.1. Clean Code: IVRWriteProtectionMiddleware → IVRWriteProtection
     - Equipo IACT
   * - 1.0.0
     - 2025-12-17
     - Versión inicial con Clean Code
     - Equipo IACT

Aprobaciones
------------

.. list-table::
   :header-rows: 1
   :widths: 30 30 40

   * - Rol
     - Nombre
     - Firma / Fecha
   * - Cliente (Sponsor)
     - [Nombre]
     - [Pendiente]
   * - Tech Lead
     - [Nombre]
     - [Pendiente]
   * - DBA
     - [Nombre]
     - [Pendiente]

----

**Fin del Documento CNST-003**