CNST-001: Comunicaciones Prohibidas
===================================

:ID: CNST-001
:Versión: 1.0.1
:Fecha: 2026-01-03
:Estado: VIGENTE
:Clasificación: CRÍTICO - NO NEGOCIABLE
:Origen: Restricción del cliente

----

Propósito
---------

Este documento establece la prohibición absoluta de uso de servicios de correo electrónico (SMTP) en el Sistema IACT - IVR Analytics & Customer Tracking, y define el mecanismo obligatorio de notificaciones mediante buzón interno.

Contexto
--------

Origen de la Restricción
~~~~~~~~~~~~~~~~~~~~~~~~

Restricción de negocio impuesta por el cliente. El cliente NO permite que aplicaciones corporativas envíen correos electrónicos a través de servicios SMTP externos o internos.

Justificación del Cliente
~~~~~~~~~~~~~~~~~~~~~~~~~

- Control centralizado de comunicaciones corporativas
- Prevención de spam interno
- Auditoría de comunicaciones
- Cumplimiento de políticas de seguridad de información

Aplicable a
~~~~~~~~~~~

- Sistema IACT completo
- Todos los módulos y componentes
- Todos los casos de uso que requieran notificar usuarios
- Todas las fases del ciclo de vida (desarrollo, QA, producción)

Restricciones
-------------

Prohibiciones Absolutas
~~~~~~~~~~~~~~~~~~~~~~~

Servicios de Correo Electrónico
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

PROHIBIDO bajo cualquier circunstancia:

- SMTP (Simple Mail Transfer Protocol)
- SendGrid
- Mailgun
- Amazon SES (Simple Email Service)
- Twilio SendGrid
- Mailchimp Transactional
- Postmark
- SparkPost
- Cualquier otro servicio de email

Librerías Prohibidas
^^^^^^^^^^^^^^^^^^^^

Librerías de email en código Python:

- ``smtplib`` (Python estándar)
- ``django.core.mail``
- ``email.mime`` (para construir emails)
- ``aiosmtplib`` (async SMTP)

Funcionalidades Prohibidas
^^^^^^^^^^^^^^^^^^^^^^^^^^

NO se permite:

- Envío de correos electrónicos
- Templates de email (.html, .txt para emails)
- Recuperación de contraseña por email
- Notificaciones por email
- Alertas por email
- Confirmaciones por email
- Reportes por email
- Invitaciones por email

Consecuencias de Violación
~~~~~~~~~~~~~~~~~~~~~~~~~~

Consecuencias de violación de esta restricción:

- Rechazo inmediato en code review
- Rollback de deployment si se detecta en producción
- Incidente de seguridad categoría Alta
- Re-trabajo completo del módulo afectado

Mecanismo Obligatorio
~~~~~~~~~~~~~~~~~~~~~

OBLIGATORIO: Buzón Interno (InternalMessage)

- Modelo Django: ``InternalMessage``
- Ubicación: ``api/apps/common/models.py``
- Base de datos: Analytics (PostgreSQL)
- Tabla: ``internal_messages``

Funcionalidades del Buzón:

- Crear mensaje interno
- Leer mensajes propios
- Marcar como leído
- Archivar mensajes
- Notificación visual en UI (badge contador)

Características Técnicas:

- Sin límite de caracteres (TextField)
- Adjuntos NO soportados (solo texto)
- Formato HTML básico permitido
- Sin destinatarios externos (solo usuarios del sistema)

Casos de Uso Afectados
----------------------

UC-003: Recuperar Contraseña
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Flujo INCORRECTO (Prohibido)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Usuario solicita recuperación de contraseña
2. Sistema genera token temporal
3. **Sistema envía email con link de recuperación** (PROHIBIDO)
4. Usuario hace clic en link del email
5. Sistema valida token
6. Usuario ingresa nueva contraseña

Flujo CORRECTO (Obligatorio)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Usuario solicita recuperación de contraseña
2. **Sistema valida identidad con 3 preguntas de seguridad**
3. Si respuestas correctas, sistema permite cambio de contraseña
4. Usuario ingresa nueva contraseña
5. Sistema actualiza contraseña

Implementación Código PROHIBIDO
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # NO HACER ESTO - PROHIBIDO
   from django.core.mail import send_mail

   def reset_password_email(user):
       send_mail(
           subject='Recuperar contraseña',
           message='Link: https://...',
           from_email='noreply@iact.com',
           recipient_list=[user.email],
       )

Implementación Código CORRECTO
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # api/apps/users/models.py

   from django.db import models
   from django.contrib.auth import get_user_model
   from django.contrib.auth.hashers import check_password, make_password

   User = get_user_model()

   class SecurityQuestion(models.Model):
                                        
       Preguntas de seguridad para recuperación de contraseña.

       Reemplaza el flujo de email prohibido por CNST-001.
       Cada usuario debe tener exactamente 3 preguntas configuradas.
                                                                    

       user = models.ForeignKey(
           User,
           on_delete=models.CASCADE,
           related_name='security_questions'
       )
       question = models.CharField(max_length=200)
       answer_hash = models.CharField(max_length=128)

       class Meta:
           db_table = 'security_questions'

       def set_answer(self, answer):
           """Hashear y guardar respuesta."""
           self.answer_hash = make_password(answer.lower().strip())

       def check_answer(self, answer):
           """Validar respuesta."""
           return check_password(answer.lower().strip(), self.answer_hash)


   def validate_security_answers(user, answers):
                                                
       Validar las 3 preguntas de seguridad.

       Args:
           user: Usuario que solicita recuperación
           answers: Lista de 3 respuestas

       Returns:
           True si todas las respuestas son correctas
                                                     
       questions = SecurityQuestion.objects.filter(user=user).order_by('id')[:3]

       if questions.count() != 3 or len(answers) != 3:
           return False

       for question, answer in zip(questions, answers):
           if not question.check_answer(answer):
               return False

       return True

UC-037: Recibir Notificación
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Flujo INCORRECTO (Prohibido)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Sistema detecta evento importante
2. **Sistema envía email de notificación** (PROHIBIDO)

Flujo CORRECTO (Obligatorio)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Sistema detecta evento importante
2. **Sistema crea InternalMessage**
3. Usuario ve badge de notificación en navbar
4. Usuario abre buzón interno
5. Usuario lee mensaje

Modelo InternalMessage
~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/common/models.py

   from django.db import models
   from django.contrib.auth import get_user_model
   from django.utils import timezone

   User = get_user_model()

   class InternalMessage(models.Model):
                                       
       Buzón interno para notificaciones del sistema.

       Reemplaza el email prohibido por CNST-001.
       Todos los casos de uso que requieran notificar usuarios
       deben usar este modelo.

       Uso:
           from apps.common.models import InternalMessage

           InternalMessage.objects.create(
               recipient=user,
               subject='Título',
               body='Contenido del mensaje'
           )
            

       recipient = models.ForeignKey(
           User,
           on_delete=models.CASCADE,
           related_name='received_messages'
       )
       sender = models.ForeignKey(
           User,
           on_delete=models.SET_NULL,
           null=True,
           blank=True,
           related_name='sent_messages'
       )
       subject = models.CharField(max_length=200)
       body = models.TextField()
       priority = models.CharField(
           max_length=10,
           choices=[
               ('LOW', 'Baja'),
               ('NORMAL', 'Normal'),
               ('HIGH', 'Alta'),
           ],
           default='NORMAL'
       )
       created_at = models.DateTimeField(auto_now_add=True)
       read_at = models.DateTimeField(null=True, blank=True)
       archived = models.BooleanField(default=False)

       class Meta:
           db_table = 'internal_messages'
           ordering = ['-created_at']
           indexes = [
               models.Index(fields=['recipient', 'read_at']),
               models.Index(fields=['recipient', 'archived']),
               models.Index(fields=['recipient', 'priority']),
           ]

       def __str__(self):
           status = 'Leído' if self.read_at else 'No leído'
           return f"{self.subject} ({status})"

       def mark_as_read(self):
           """Marcar mensaje como leído."""
           if not self.read_at:
               self.read_at = timezone.now()
               self.save(update_fields=['read_at'])

       def archive(self):
           """Archivar mensaje."""
           self.archived = True
           self.save(update_fields=['archived'])

       @classmethod
       def get_unread_count(cls, user):
           """Obtener cantidad de mensajes no leídos de un usuario."""
           return cls.objects.filter(
               recipient=user,
               read_at__isnull=True,
               archived=False
           ).count()

Funciones de Notificación
~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/common/notifications.py

   from apps.common.models import InternalMessage


   def notify(recipient, subject, body, sender=None, priority='NORMAL'):
                                                                        
       Enviar notificación mediante buzón interno.

       Función principal para notificar usuarios.
       CNST-001: Reemplaza completamente el envío de emails.

       Args:
           recipient: Usuario destinatario
           subject: Asunto del mensaje
           body: Contenido del mensaje
           sender: Usuario que envía (opcional)
           priority: Prioridad (LOW, NORMAL, HIGH)

       Returns:
           InternalMessage creado
                                 
       message = InternalMessage.objects.create(
           recipient=recipient,
           subject=subject,
           body=body,
           sender=sender,
           priority=priority
       )

       return message

Notificar a Administradores
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   def notify_admins(subject, body, priority='HIGH'):
                                                     
       Notificar a todos los administradores del sistema.

       Args:
           subject: Asunto
           body: Contenido
           priority: Prioridad (default HIGH para admins)
                                                         
       from django.contrib.auth import get_user_model

       User = get_user_model()
       admins = User.objects.filter(is_staff=True, is_active=True)

       for admin in admins:
           notify(
               recipient=admin,
               subject=subject,
               body=body,
               priority=priority
           )


   def notify_by_function(function_code, subject, body, priority='NORMAL'):
                                                                           
       Notificar a usuarios con una función específica (RBAC v5.1.1).

       Compatible con Modelo RBAC IACT v5.1.1 (44 funciones atómicas).

       Args:
           function_code: Código de función atómica (ej: 've_reportes')
           subject: Asunto
           body: Contenido
           priority: Prioridad

       Example:
           notify_by_function(
               function_code='ve_reportes',
               subject='Nuevo reporte disponible',
               body='El reporte mensual está listo.'
           )
            
       from apps.access.models import UserFunctionAssignment

       # Obtener usuarios con la función específica
       assignments = UserFunctionAssignment.objects.filter(
           function_code=function_code,
           is_active=True
       ).select_related('user')

       for assignment in assignments:
           if assignment.user.is_active:
               notify(
                   recipient=assignment.user,
                   subject=subject,
                   body=body,
                   priority=priority
               )

UC-036 a UC-040: Sistema de Alertas
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Todos los casos de uso del sistema de alertas deben usar InternalMessage:

- UC-036: Configurar Alertas
- UC-037: Recibir Notificación
- UC-038: Marcar Alerta como Leída
- UC-039: Archivar Alerta
- UC-040: Consultar Historial de Alertas

Ejemplos de Alertas
^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   from apps.common.notifications import notify, notify_admins

   # Alerta: ETL completado
   notify(
       recipient=admin_user,
       subject='ETL Completado',
       body='ETL ejecutado a las 02:30. Registros procesados: 15,420',
       priority='NORMAL'
   )

   # Alerta: Error crítico (notificar a todos los admins)
   notify_admins(
       subject='Error Crítico en ETL',
       body='ETL falló. Error: Connection timeout a base IVR.',
       priority='HIGH'
   )

   # Alerta: Nuevo rol asignado
   notify(
       recipient=target_user,
       subject='Nuevo Rol Asignado',
       body='Se te ha asignado el rol DATA_ANALYST (R010).',
       sender=admin_user,
       priority='NORMAL'
   )

   # Alerta: Reporte generado
   notify(
       recipient=report_owner,
       subject='Reporte Listo',
       body='Tu reporte "Llamadas Mensuales" está listo para descargar.',
       priority='LOW'
   )

Validación en Desarrollo
------------------------

Pre-commit Checklist
~~~~~~~~~~~~~~~~~~~~

Antes de hacer commit, verificar:

.. list-table::
   :header-rows: 0
   :widths: 10 90

   * - [ ]
     - NO existe ``import smtplib``
   * - [ ]
     - NO existe ``from django.core.mail import``
   * - [ ]
     - NO existe ``send_mail()`` en código
   * - [ ]
     - NO existen templates en ``templates/email/``
   * - [ ]
     - NO existen settings de EMAIL/SMTP en ``settings/``

Code Review Checklist
~~~~~~~~~~~~~~~~~~~~~

Durante code review, rechazar si:

.. list-table::
   :header-rows: 0
   :widths: 10 90

   * - [ ]
     - Se intenta enviar emails
   * - [ ]
     - Se importan librerías de email
   * - [ ]
     - Se configura SMTP en settings
   * - [ ]
     - Se crean templates de email

Validación Automatizada
~~~~~~~~~~~~~~~~~~~~~~~

Script de Validación
^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

   #!/bin/bash
   # scripts/validate_no_email.sh

   echo "Validando que no existan referencias a email..."

   ERRORS=0

   # Buscar imports prohibidos
   if grep -r "import smtplib" api/apps/; then
       echo "ERROR: Encontrado 'import smtplib'"
       ERRORS=$((ERRORS + 1))
   fi

   if grep -r "from django.core.mail" api/apps/; then
       echo "ERROR: Encontrado 'from django.core.mail'"
       ERRORS=$((ERRORS + 1))
   fi

   if grep -r "send_mail" api/apps/; then
       echo "ERROR: Encontrado 'send_mail'"
       ERRORS=$((ERRORS + 1))
   fi

   # Buscar configuraciones SMTP
   if grep -r "EMAIL_HOST\|SMTP" api/config/settings/; then
       echo "ERROR: Encontrada configuración de email en settings"
       ERRORS=$((ERRORS + 1))
   fi

   # Buscar templates de email
   if [ -d "api/templates/email" ]; then
       echo "ERROR: Existe directorio templates/email"
       ERRORS=$((ERRORS + 1))
   fi

   if [ $ERRORS -eq 0 ]; then
       echo "OK: No se encontraron referencias a email"
       exit 0
   else
       echo "FALLO: $ERRORS violaciones de CNST-001 encontradas"
       exit 1
   fi

Configuración Ruff
^^^^^^^^^^^^^^^^^^

.. code-block:: toml

   # pyproject.toml

   [tool.ruff.lint.per-file-ignores]
   # No se necesitan reglas especiales, pero documentar la prohibición

   [tool.ruff.lint]
   # Nota: Ruff no tiene regla nativa para prohibir imports específicos
   # Usar el script validate_no_email.sh como complemento

Excepciones
-----------

**NO EXISTEN EXCEPCIONES**

Esta restricción NO tiene excepciones.

Ningún módulo, componente o caso de uso puede violar esta restricción bajo ninguna circunstancia.

Si surge un requerimiento que parezca necesitar email, debe ser rechazado y re-diseñado usando InternalMessage.

Alternativas Evaluadas y Rechazadas
-----------------------------------

Alternativa 1: SMTP Interno del Cliente
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Propuesta:** Usar servidor SMTP interno del cliente.

**Rechazada porque:**

- Cliente explícitamente prohibió CUALQUIER uso de SMTP
- Política de seguridad no permite aplicaciones enviando emails
- Control de comunicaciones debe ser centralizado

Alternativa 2: Queue de Emails para Revisión Manual
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Propuesta:** Encolar emails para que operador los envíe manualmente.

**Rechazada porque:**

- Overhead operacional inaceptable
- No soluciona el problema de fondo
- Cliente prefiere notificaciones in-app

Alternativa 3: Notificaciones Push (Web Push API)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Propuesta:** Usar Web Push API para notificaciones de navegador.

**Rechazada porque:**

- Requiere usuario tenga pestaña abierta o PWA instalado
- No cumple con requerimiento de persistencia
- InternalMessage es más simple y robusto

Referencias
-----------

Documentos Relacionados
~~~~~~~~~~~~~~~~~~~~~~~

- RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md
- UC-003: Recuperar Contraseña
- UC-036 a UC-040: Sistema de Alertas
- Modelo RBAC IACT v5.1.1 (44 funciones atómicas, 8 módulos)

Implementación de Referencia
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- ``api/apps/common/models.py`` - InternalMessage
- ``api/apps/common/notifications.py`` - Funciones notify()
- ``api/apps/users/models.py`` - SecurityQuestion

Historial de Cambios
--------------------

.. list-table::
   :header-rows: 1
   :widths: 15 15 50 20

   * - Versión
     - Fecha
     - Cambios
     - Autor
   * - 1.0.0
     - 2025-12-17
     - Versión inicial completa con Clean Code
     - Equipo IACT
   * - 1.0.1
     - 2026-01-03
     - Actualización a RBAC v5.1.1. Función notify_by_function() con funciones atómicas
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
   * - Security Officer
     - [Nombre]
     - [Pendiente]

----

**Fin del Documento CNST-001**