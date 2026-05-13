.. meta::
   :Proyecto: IACT
   :Codigo: UC-IACT-MOD-NN
   :Titulo: Nombre del Use Case
   :Version: 4.0.0
   :Actor_Principal: Rol del Actor Principal
   :Tipo: Normal|CRUD|Temporal|UI-Driven
   :Fecha: YYYY-MM-DD
   :Autor: Nombre del Business Analyst
   :Estado: DRAFT|REVIEW|APPROVED|IMPLEMENTED

======================================================================
UC-IACT-MOD-NN: Nombre del Use Case
======================================================================

**Proyecto:** IACT - IVR Analytics & Customer Tracking  
**Actor Principal:** Rol del Actor Principal  
**Actores Secundarios:** Actor2, Actor3, Actor4  
**Tipo:** Normal|CRUD|Temporal|UI-Driven  
**Estado:** DRAFT|REVIEW|APPROVED|IMPLEMENTED  
**Prioridad:** Alta|Media|Baja  
**Clasificacion:** C2 - INTERNAL

----------------------------------------------------------------------
INTRODUCCION AL TEMPLATE
----------------------------------------------------------------------

Este template documenta Use Cases donde los actores secundarios
juegan un rol significativo en el flujo, con interacciones complejas
entre multiples actores.

**Cuando Usar Este Template:**

Use este template cuando:

1. El UC tiene 2 o mas actores secundarios importantes
2. Hay interacciones significativas entre actores
3. Actores secundarios toman decisiones o ejecutan acciones criticas
4. Necesita documentar responsabilidades claras de cada actor
5. Hay comunicacion/notificacion entre actores

**Cuando NO Usar Este Template:**

NO use este template para:

- UC con un solo actor
- UC donde actores secundarios solo proveen datos pasivamente
- UC simples donde rol de secundarios es trivial

**Actor Principal vs Actores Secundarios:**

**Actor Principal:**
- INICIA el caso de uso
- Tiene el OBJETIVO que el UC busca satisfacer
- Es el beneficiario primario del UC
- Ejemplo: Usuario que solicita un reporte

**Actor Secundario:**
- PARTICIPA en el UC pero NO lo inicia
- Provee servicios, datos, o autorizaciones
- Puede ser: otro usuario, sistema externo, servicio
- Ejemplo: Supervisor que aprueba, BD que provee datos

**Importancia de Documentar Actores Secundarios:**

1. **Claridad de Responsabilidades:** Quien hace que
2. **Dependencias:** Identificar puntos de falla
3. **Comunicacion:** Documentar interfaces entre actores
4. **Testing:** Saber que actores mockear
5. **Integracion:** Entender sistemas externos involucrados

----------------------------------------------------------------------
1. DIAGRAMA DE ACTORES
----------------------------------------------------------------------

**Proposito:**

Visualizar graficamente los actores y sus relaciones en el UC.

**Formato ASCII:**

.. code-block:: text

   +------------------+
   | Actor Principal  |
   +------------------+
           |
           | inicia UC
           v
   +------------------+
   |   Sistema IACT   |
   +------------------+
      |           |
      | solicita  | notifica
      v           v
   +---------+  +---------+
   | Actor2  |  | Actor3  |
   +---------+  +---------+

**Leyenda:**

- Flechas: Direccion de la interaccion
- Etiquetas: Tipo de interaccion

**EJEMPLO COMPLETO (UC-RPT-02):**

**UC-RPT-02: Aprobar Consulta Grande**

**Diagrama de Actores:**

.. code-block:: text

   +-------------------------+
   | Supervisor de Area      | <-- Actor Principal
   | (Carlos Martinez)       |
   +-------------------------+
             ^
             | (3) notifica
             |
   +-------------------------+
   |    Sistema IACT         |
   |  (Modulo Reportes)      |
   +-------------------------+
      ^              |
      |              | (5) ejecuta
      | (1) crea    |
      | solicitud   v
      |         +-------------------------+
      |         | Sistema Analytics       | <-- Actor Secundario
      |         | (Base de Datos)         |
      |         +-------------------------+
      |
   +-------------------------+
   | Analista Operaciones    | <-- Actor Secundario
   | (Ana Lopez)             |     (solicitante original)
   +-------------------------+
             ^
             | (6) notifica
             | resultado

**Descripcion de Interacciones:**

1. Analista crea solicitud de consulta grande (origen: UC-RPT-01 FA-2)
2. Sistema identifica Supervisor responsable
3. Sistema notifica a Supervisor sobre solicitud pendiente
4. Supervisor revisa y aprueba/rechaza
5. Si aprueba: Sistema ejecuta query en Analytics DB
6. Sistema notifica resultado a Analista solicitante

**Relaciones entre Actores:**

.. list-table::
   :header-rows: 1
   :widths: 25 25 50

   * - Actor 1
     - Actor 2
     - Relacion
   * - Supervisor
     - Analista
     - Supervisor es jefe jerarquico de Analista
   * - Supervisor
     - Sistema IACT
     - Supervisor usa sistema para aprobar
   * - Sistema IACT
     - Sistema Analytics
     - Sistema IACT consulta datos de Analytics
   * - Analista
     - Sistema IACT
     - Analista solicito consulta original

----------------------------------------------------------------------
2. TABLA DE RESPONSABILIDADES
----------------------------------------------------------------------

**Proposito:**

Documentar detalladamente que hace cada actor en el UC.

**Formato de Tabla:**

.. list-table::
   :header-rows: 1
   :widths: 20 15 40 25

   * - Actor
     - Tipo
     - Responsabilidades
     - Pasos donde Participa
   * - Nombre Actor
     - Principal|Secundario
     - Lista de responsabilidades
     - Paso N, Paso M

**EJEMPLO COMPLETO (UC-RPT-02):**

.. list-table::
   :header-rows: 1
   :widths: 20 15 40 25

   * - Actor
     - Tipo
     - Responsabilidades
     - Pasos
   * - Supervisor de Area
     - Principal
     - - Revisar solicitud de consulta grande
       - Evaluar si la consulta es necesaria
       - Aprobar o rechazar solicitud
       - Proporcionar justificacion si rechaza
     - Paso 3-7
   * - Analista de Operaciones
     - Secundario
     - - Origino la solicitud en UC-RPT-01
       - Recibe notificacion de resultado
       - Puede ver reporte si fue aprobado
     - Paso 1 (contexto), Paso 10
   * - Sistema Analytics
     - Secundario
     - - Proveer datos de llamadas IVR
       - Ejecutar query principal si aprobada
       - Retornar dataset con metricas
     - Paso 8-9
   * - Servicio de Email
     - Secundario
     - - Enviar email a Supervisor cuando hay solicitud
       - Enviar email a Analista con resultado
     - Paso 2, Paso 10

**Detalle de Responsabilidades por Actor:**

**Supervisor de Area (Actor Principal):**

Responsabilidades Principales:

1. **Revisar Solicitud:**
   - Verificar parametros de la consulta (trimestre, ano, segmento)
   - Ver count estimado de registros
   - Revisar quien solicito y cuando
   - Verificar historial de consultas del solicitante

2. **Evaluar Necesidad:**
   - Determinar si la consulta es realmente necesaria
   - Considerar si parametros pueden optimizarse
   - Evaluar urgencia vs carga del sistema
   - Considerar horario de ejecucion (pico vs valle)

3. **Tomar Decision:**
   - Aprobar si justificado
   - Rechazar si innecesario o puede optimizarse
   - Proporcionar feedback al solicitante

4. **Gestionar Equipo:**
   - Educar a analistas sobre uso responsable
   - Monitorear patrones de consultas del equipo

Autoridad:

- Puede aprobar consultas de su equipo directo
- NO puede aprobar consultas de otros departamentos
- Debe escalar a su superior si consulta es critica

**Analista de Operaciones (Actor Secundario):**

Contexto:

Este actor ya ejecuto UC-RPT-01 "Consultar Reporte Trimestral" donde
solicito una consulta que retornaria mas de 10,000 registros. El
sistema activo FA-2 creando solicitud de aprobacion. Ahora el Analista
espera la decision del Supervisor.

Responsabilidades en UC-RPT-02:

1. **Recibir Notificacion:**
   - Ser notificado cuando Supervisor aprueba/rechaza
   - Ver resultado en bandeja de notificaciones

2. **Acceder a Reporte:**
   - Si aprobado: Ver link al reporte generado
   - Descargar/exportar reporte

3. **Aprender:**
   - Si rechazado: Leer feedback del Supervisor
   - Ajustar parametros y volver a solicitar

**Sistema Analytics (Actor Secundario):**

Responsabilidades:

1. **Proveer Datos:**
   - Mantener datos de ivr_calls actualizados
   - Garantizar integridad de datos

2. **Ejecutar Query:**
   - Recibir query parametrizada del Sistema IACT
   - Ejecutar con timeout de 30 segundos
   - Retornar dataset o error

3. **Performance:**
   - Responder en tiempo aceptable
   - No degradar por consultas concurrentes

Restricciones:

- READ-ONLY: No puede modificar datos
- Timeout: 30 segundos maximo por query
- Acceso: Via usuario de servicio iact-app

----------------------------------------------------------------------
3. FLUJO CON INTERACCIONES DETALLADAS
----------------------------------------------------------------------

**Proposito:**

Documentar el flujo del UC mostrando explicitamente cuando y como
interactuan los actores.

**Formato:**

N. Actor hace accion

   N.1 Sistema comunica con Actor2

   N.2 Actor2 responde

**Notacion de Comunicacion:**

- Sistema → Actor: Sistema envia mensaje/notificacion
- Actor → Sistema: Actor envia input/decision
- Sistema ↔ Sistema: Integracion entre sistemas

**FLUJO COMPLETO (UC-RPT-02):**

FLUJO NORMAL - Aprobar Consulta Grande

**Precondiciones:**

PC-1: Existe solicitud de aprobacion pendiente creada en UC-RPT-01 FA-2

PC-2: Supervisor autenticado en el sistema

PC-3: Supervisor es jefe jerarquico del Analista solicitante

**Trigger:**

Supervisor recibe notificacion de solicitud pendiente y hace click
en link "Revisar Solicitud"

**Flujo:**

1. **Sistema muestra pantalla de revision de solicitud (FR-RPT-02-01)**
   
   Pantalla contiene:
   - Datos de la solicitud: ID, fecha, hora
   - Solicitante: Ana Lopez (Analista)
   - Parametros: Q3 2024, Segmento OP
   - Count estimado: 25,000 registros
   - Umbral: 10,000 (excedido por 15,000)
   - Historial: Ultimas 5 consultas de Ana

2. **Supervisor revisa informacion**
   
   Supervisor analiza:
   - Es necesaria la consulta?
   - Parametros pueden optimizarse?
   - Horario actual: 2:00 PM (horario pico)
   - Sugerencia del sistema: "Ejecutar en horario valle (6-8 AM)"

3. **Supervisor hace click en boton "Aprobar" (FR-RPT-02-02)**

   Pantalla muestra form:
   - Radio buttons: Aprobar | Rechazar
   - Selector: Ejecutar Ahora | Programar para
   - Text area: Comentarios (opcional)

4. **Supervisor selecciona opciones:**
   
   - Opcion: Aprobar
   - Ejecutar: Programar para manana 6:00 AM
   - Comentarios: "Aprobado. Ejecutar en horario valle para no
     afectar performance."

5. **Supervisor hace click en "Confirmar Decision"**

6. **Sistema valida decision (FR-RPT-02-03)**
   
   Validaciones:
   - Supervisor tiene autoridad sobre Analista solicitante
   - Decision es Aprobar o Rechazar
   - Si programada, hora futura valida

7. **Sistema actualiza registro de aprobacion (FR-RPT-02-04)**

   .. code-block:: sql
   
      UPDATE approvals
      SET status = 'APPROVED',
          approved_by = :supervisor_id,
          approved_at = NOW(),
          scheduled_for = '2024-11-16 06:00:00',
          comments = :supervisor_comments
      WHERE id = :approval_id;

8. **Sistema programa ejecucion (FR-RPT-02-05)**
   
   Crea job programado:

   .. code-block:: python
   
      from django_q.tasks import schedule
      
      schedule(
          'reports.tasks.execute_approved_query',
          approval_id=approval_id,
          schedule_type='O',  # Once
          next_run=datetime(2024, 11, 16, 6, 0, 0)
      )

9. **Sistema → Sistema Analytics: Verifica disponibilidad**
   
   Healthcheck:

   .. code-block:: python
   
      response = requests.get('http://analytics-db/health')
      if response.status_code != 200:
          raise AnalyticsUnavailableError()

10. **Sistema → Analista: Notifica aprobacion (FR-RPT-02-06)**
    
    **Notificacion en bandeja de entrada:**
    
    .. code-block:: python
    
       Notification.objects.create(
           recipient=analista,
           type='APPROVAL_GRANTED',
           title='Consulta Aprobada',
           message=(
               'Su consulta de Q3 2024 ha sido aprobada por '
               'Carlos Martinez. '
               'Se ejecutara el 2024-11-16 a las 6:00 AM. '
               'Comentarios: "Aprobado. Ejecutar en horario valle..."'
           ),
           link=f'/reports/approval/{approval_id}'
       )
    
    **Email al Analista:**
    
    .. code-block:: python
    
       send_email(
           to='ana.lopez@iact.com',
           subject='Consulta Aprobada - Q3 2024',
           template='approval_granted.html',
           context={
               'analista': 'Ana Lopez',
               'supervisor': 'Carlos Martinez',
               'query_params': 'Q3 2024, OP',
               'scheduled_for': '2024-11-16 06:00 AM',
               'comments': supervisor_comments
           }
       )

11. **Sistema muestra confirmacion a Supervisor**
    
    Modal:
    
    "Aprobacion registrada exitosamente.
    
    La consulta se ejecutara el 2024-11-16 a las 6:00 AM.
    
    Ana Lopez ha sido notificada."

12. **Caso de uso termina exitosamente**

**Ejecucion Programada (Al dia siguiente 6:00 AM):**

Nota: Esto ocurre en un UC separado o proceso temporal

8a. **Cron ejecuta job programado**

8b. **Sistema → Sistema Analytics: Ejecuta query (FR-RPT-02-07)**

    .. code-block:: sql
    
       SELECT 
           DATE_TRUNC('day', call_date) as dia,
           COUNT(*) as total_llamadas,
           SUM(CASE WHEN status='COMPLETED' THEN 1 ELSE 0 END) as completadas,
           SUM(CASE WHEN status='ABANDONED' THEN 1 ELSE 0 END) as abandonadas,
           AVG(duration_seconds) as duracion_promedio
       FROM ivr_calls
       WHERE quarter = 'Q3'
         AND year = 2024
         AND segment = 'OP'
       GROUP BY DATE_TRUNC('day', call_date)
       ORDER BY dia ASC

8c. **Sistema Analytics → Sistema IACT: Retorna resultados**

    Dataset con 92 filas (dias de Q3)

8d. **Sistema genera reporte y guarda (FR-RPT-02-08)**

8e. **Sistema → Analista: Notifica reporte listo (FR-RPT-02-09)**

    Email:
    
    "Su reporte Q3 2024 esta listo.
    
    Ver reporte: https://iact.com/reports/12345
    
    Ejecutado: 2024-11-16 06:05 AM
    Registros: 25,120"

**Flujos Alternos:**

FA-1: Supervisor Rechaza Consulta

En paso 4, si Supervisor selecciona Rechazar:

  4a. Supervisor selecciona:
      - Opcion: Rechazar
      - Razon: Dropdown con opciones
        * Parametros muy amplios
        * No es necesario
        * Puede optimizarse
        * Otro (requiere comentario)
      - Comentarios: Obligatorio si rechaza

  4b. Supervisor hace click en "Confirmar Decision"

  4c. Sistema actualiza registro:

      .. code-block:: sql
      
         UPDATE approvals
         SET status = 'REJECTED',
             approved_by = :supervisor_id,
             approved_at = NOW(),
             rejection_reason = :reason,
             comments = :supervisor_comments
         WHERE id = :approval_id

  4d. Sistema → Analista: Notifica rechazo
      
      Email:
      
      "Su consulta Q3 2024 ha sido rechazada.
      
      Razon: Parametros muy amplios
      
      Comentarios de Carlos Martinez:
      'Por favor reduce el rango a un solo mes en lugar de todo
      el trimestre. Si necesitas todo Q3, solicita los 3 meses
      por separado.'"

  4e. UC termina, consulta no se ejecuta

----------------------------------------------------------------------
4. CODIGO DE NOTIFICACIONES
----------------------------------------------------------------------

**Proposito:**

Documentar codigo especifico de comunicacion entre actores.

**CODIGO COMPLETO (UC-RPT-02):**

**Archivo:** notifications.py

.. code-block:: python

   """
   Notification handlers for UC-RPT-02
   
   Handles communication between actors:
   - Supervisor (principal actor)
   - Analyst (secondary actor, requester)
   - Analytics System (secondary actor, data provider)
   """
   
   from django.core.mail import send_mail
   from django.template.loader import render_to_string
   from app.models import Notification, Approval, User
   
   def notify_supervisor_new_approval(approval_id):
       """
       Notifies supervisor of new approval request.
       
       Called from: UC-RPT-01 FA-2 when approval created
       Actor: Supervisor (recipient)
       """
       approval = Approval.objects.get(id=approval_id)
       analyst = approval.user
       supervisor = get_supervisor(analyst)
       
       # In-app notification
       Notification.objects.create(
           recipient=supervisor,
           type='APPROVAL_PENDING',
           title=f'Aprobacion requerida: Consulta de {analyst.name}',
           message=(
               f'Consulta retornaria {approval.record_count:,} registros '
               f'(limite: 10,000). '
               f'Parametros: {approval.parameters}'
           ),
           link=f'/approvals/{approval_id}/review'
       )
       
       # Email notification
       context = {
           'supervisor_name': supervisor.name,
           'analyst_name': analyst.name,
           'record_count': approval.record_count,
           'parameters': approval.get_parameters_display(),
           'review_url': f'https://iact.com/approvals/{approval_id}/review'
       }
       
       html_message = render_to_string(
           'emails/approval_pending.html',
           context
       )
       
       send_mail(
           subject=f'Aprobacion Requerida: {analyst.name}',
           message='',
           from_email='noreply@iact.com',
           recipient_list=[supervisor.email],
           html_message=html_message
       )
   
   def notify_analyst_approval_granted(approval_id):
       """
       Notifies analyst that query was approved.
       
       Called from: UC-RPT-02 step 10
       Actor: Analyst (recipient)
       """
       approval = Approval.objects.get(id=approval_id)
       analyst = approval.user
       supervisor = User.objects.get(id=approval.approved_by)
       
       # In-app notification
       Notification.objects.create(
           recipient=analyst,
           type='APPROVAL_GRANTED',
           title='Consulta Aprobada',
           message=(
               f'Su consulta ha sido aprobada por {supervisor.name}. '
               f'Ejecucion programada: {approval.scheduled_for}. '
               f'Comentarios: {approval.comments}'
           ),
           link=f'/approvals/{approval_id}'
       )
       
       # Email
       context = {
           'analyst_name': analyst.name,
           'supervisor_name': supervisor.name,
           'scheduled_for': approval.scheduled_for,
           'comments': approval.comments,
           'approval_url': f'https://iact.com/approvals/{approval_id}'
       }
       
       html_message = render_to_string(
           'emails/approval_granted.html',
           context
       )
       
       send_mail(
           subject='Consulta Aprobada',
           message='',
           from_email='noreply@iact.com',
           recipient_list=[analyst.email],
           html_message=html_message
       )
   
   def notify_analyst_approval_rejected(approval_id):
       """
       Notifies analyst that query was rejected.
       
       Called from: UC-RPT-02 FA-1
       Actor: Analyst (recipient)
       """
       approval = Approval.objects.get(id=approval_id)
       analyst = approval.user
       supervisor = User.objects.get(id=approval.approved_by)
       
       # In-app notification
       Notification.objects.create(
           recipient=analyst,
           type='APPROVAL_REJECTED',
           title='Consulta Rechazada',
           message=(
               f'Su consulta ha sido rechazada por {supervisor.name}. '
               f'Razon: {approval.rejection_reason}. '
               f'Comentarios: {approval.comments}'
           ),
           link=f'/approvals/{approval_id}'
       )
       
       # Email
       context = {
           'analyst_name': analyst.name,
           'supervisor_name': supervisor.name,
           'rejection_reason': approval.get_rejection_reason_display(),
           'comments': approval.comments
       }
       
       html_message = render_to_string(
           'emails/approval_rejected.html',
           context
       )
       
       send_mail(
           subject='Consulta Rechazada',
           message='',
           from_email='noreply@iact.com',
           recipient_list=[analyst.email],
           html_message=html_message
       )

----------------------------------------------------------------------
REFERENCIAS
----------------------------------------------------------------------

**Estandares:**

- STD_001_Estandares_Documentacion_1_1_0.rst
- NOM_001_Nomenclatura_Proyecto_2_0_0.rst

**Material Pedagogico:**

- PARTE_2_Documentar_Use_Cases_IACT_1_0_0.md

**Documentos Relacionados:**

- UC-IACT-RPT-01-Consultar-Reporte-Trimestral-4-0-0.rst
- BR-IACT-028-Aprobacion-Consultas-1-0-0.rst

----------------------------------------------------------------------

.. note::
   CHECKLIST ACTOR SECUNDARIO:
   
   - Diagrama ASCII de actores completo
   - Tabla de responsabilidades detallada para cada actor
   - Flujo con interacciones explicitas entre actores
   - Codigo de notificaciones/comunicacion entre actores
   - Identificacion clara de actor principal vs secundarios
   - Documentacion de relaciones entre actores
   - Ejemplos concretos del dominio IACT

----------------------------------------------------------------------

**Archivo:** TPL_UC_Actor_Secundario_1_3_0.rst  
**Version Template:** 1.3.0  
**Fecha Creacion Template:** 2026-01-11  
**Autor Template:** Sistema de Regeneracion IACT  
**Lineas Totales:** aproximadamente 550
