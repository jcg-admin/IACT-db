.. _CNST_001:

============================================================
CNST_001 - NO Email bajo Ninguna Circunstancia
============================================================

:Restricción: CNST_001
:Versión: 1.0.0
:Fecha: 2026-01-11
:Estado: VIGENTE
:Prioridad: CRÍTICA
:Ámbito: Sistema completo IACT - TODOS los módulos
:Fundamento: Decisión arquitectónica de seguridad y privacidad
:Proyecto: IACT-2025-001
:Relacionado_Con: CNST_004 (Alertas buzón interno)

.. contents:: Tabla de Contenido
   :depth: 4
   :local:

============================================================
1. RESUMEN EJECUTIVO
============================================================

1.1 Definición de la Restricción
----------------------------------

   **El Sistema IACT NO utiliza correo electrónico (email) bajo NINGUNA 
   circunstancia para comunicación de negocio, notificaciones, alertas, 
   recuperación de contraseñas, o cualquier otro propósito.**
   
   **TODAS las comunicaciones del sistema se realizan exclusivamente a 
   través del BUZÓN INTERNO de la aplicación.**

1.2 Alcance
------------

Esta restricción aplica a:

- **TODOS los módulos** del sistema IACT (8 módulos)
- **TODAS las notificaciones** al usuario
- **TODOS los eventos** que requieran comunicación
- **SIN excepciones** - No existen casos donde se permita email

.. warning::
   Esta restricción es ABSOLUTA y NO NEGOCIABLE. Cualquier funcionalidad
   que requiera envío de emails debe ser RECHAZADA en fase de diseño.

1.3 Impacto General
--------------------

.. list-table:: Impacto por Módulo
   :header-rows: 1
   :widths: 25 25 50

   * - Módulo
     - Funciones Afectadas
     - Impacto
   * - **MOD_Auth**
     - AUT-003 (resetea_password)
     - Notificación de password temporal por buzón interno
   * - **MOD_Users**
     - USR-001 (crea_usuarios)
     - Bienvenida + credenciales por buzón interno
   * - **MOD_Alerts**
     - ALR-002, ALR-003
     - Alertas solo por buzón interno
   * - MOD_Reports
     - Ninguna directa
     - No envío de reportes por email
   * - MOD_Pipeline
     - Ninguna directa
     - Notificaciones ETL por buzón interno
   * - MOD_Access
     - Ninguna directa
     - Notificaciones de cambios de permisos por buzón
   * - MOD_Audit
     - Ninguna directa
     - No envío de reportes compliance por email
   * - MOD_Logs
     - Ninguna directa
     - No envío de logs por email

**Total funciones RBAC afectadas directamente:** 3 (AUT-003, USR-001, ALR-002, ALR-003)

**Total módulos con restricción indirecta:** 8 (TODOS)

============================================================
2. JUSTIFICACIÓN DE LA RESTRICCIÓN
============================================================

2.1 Justificación Técnica
---------------------------

**Razones de Seguridad:**

1. **Prevención de Phishing**
   
   - Emails del sistema pueden ser falsificados
   - Usuarios no pueden distinguir emails legítimos de phishing
   - Buzón interno es intrínsecamente seguro (autenticado)

2. **Control de Datos Sensibles**
   
   - Emails pueden contener credenciales temporales
   - Riesgo de intercepción en tránsito (aunque sea TLS)
   - Buzón interno mantiene datos dentro del perímetro de seguridad

3. **Trazabilidad Completa**
   
   - Emails pueden ser eliminados por el usuario
   - Buzón interno mantiene log completo de notificaciones
   - Auditoría garantizada (CNST_008)

4. **Eliminación de Dependencia Externa**
   
   - No requiere servidor SMTP
   - No depende de servicios de terceros (SendGrid, AWS SES, etc.)
   - Reduce superficie de ataque

**Razones de Privacidad:**

1. **Protección de PII**
   
   - Emails pueden contener información personal
   - Riesgo de exposición en servidores de correo intermedios
   - Buzón interno cumple con políticas de privacidad estrictas

2. **No Spam**
   
   - Sistema no contribuye a sobrecarga de emails corporativos
   - Usuarios no reciben notificaciones no solicitadas
   - Comunicación opt-in (usuario accede cuando quiere)

2.2 Justificación de Negocio
------------------------------

**Ventajas Operativas:**

1. **Simplicidad Arquitectónica**
   
   - No requiere infraestructura de email
   - No requiere plantillas de email
   - No requiere gestión de rebotes/fallos de entrega

2. **Costo Reducido**
   
   - No hay costos de servicio de email
   - No hay costos de ancho de banda para emails
   - No hay costos de mantenimiento de servidor SMTP

3. **Experiencia de Usuario Coherente**
   
   - Todas las notificaciones en un solo lugar (buzón interno)
   - Usuario no necesita revisar múltiples canales
   - Interfaz unificada

**Alineación con Políticas:**

- Cumple con políticas corporativas de seguridad
- Alineado con estándares de privacidad de datos
- Reduce riesgos de compliance

2.3 Casos de Uso Cubiertos
----------------------------

Los siguientes casos de uso que típicamente usan email están cubiertos
por buzón interno:

.. list-table:: Casos de Uso sin Email
   :header-rows: 1
   :widths: 40 60

   * - Caso de Uso Típico (Email)
     - Solución IACT (Buzón Interno)
   * - Recuperación de contraseña
     - UC-003: Password temporal notificado en buzón
   * - Bienvenida a nuevo usuario
     - UC-006: Credenciales en buzón al crear cuenta
   * - Alertas de umbral superado
     - UC-036, UC-037: Alerta aparece en buzón
   * - Notificación de cambio de permisos
     - UC-010: Notificación en buzón
   * - Reporte generado
     - Download directo, sin envío por email
   * - Mantenimiento programado
     - Notificación en buzón + banner en sistema

============================================================
3. FUNCIONES RBAC AFECTADAS
============================================================

3.1 Funciones Directamente Afectadas
--------------------------------------

**AUT-003: resetea_password**

.. code-block:: yaml

   Función: resetea_password
   Módulo: MOD_Auth
   Capacidad: auth:reset_password
   
   ANTES (sistema típico con email):
     1. Generar token de recuperación
     2. Enviar email con enlace
     3. Usuario hace clic en enlace
     4. Establecer nueva contraseña
   
   AHORA (IACT con buzón interno):
     1. Generar contraseña temporal (12+ chars)
     2. Actualizar hash en BD
     3. Marcar debe_cambiar_password = TRUE
     4. Crear notificación en buzón interno:
        - Título: "Contraseña temporal generada"
        - Mensaje: "Tu contraseña temporal es: [PASSWORD]"
        - Indicación: "Debes cambiarla en tu primer inicio de sesión"
     5. Usuario recibe notificación en buzón interno
     6. Usuario inicia sesión con password temporal
     7. Sistema fuerza cambio de password
   
   Restricción CNST_001:
     ✓ NO envío de email
     ✓ Notificación solo buzón interno
   
   Caso de Uso: UC-003
   Código de ejemplo: Ver sección 7.1

**USR-001: crea_usuarios**

.. code-block:: yaml

   Función: crea_usuarios
   Módulo: MOD_Users
   Capacidad: users:crear
   
   ANTES (sistema típico con email):
     1. Crear usuario en BD
     2. Generar credenciales
     3. Enviar email de bienvenida con credenciales
   
   AHORA (IACT con buzón interno):
     1. Validar email único
     2. Generar username automático
     3. Crear con estado PENDIENTE_CONFIGURACION
     4. Generar contraseña temporal
     5. Crear notificación en buzón interno:
        - Título: "Bienvenido al Sistema IACT"
        - Mensaje: "Tu cuenta ha sido creada"
        - Username: [username]
        - Password temporal: [password]
        - Enlace directo a login
     6. Administrador notifica al usuario por canal externo
        (presencial, teléfono, etc.) que revise su buzón
   
   Restricción CNST_001:
     ✓ NO envío de email de bienvenida
     ✓ Credenciales solo en buzón interno
   
   Caso de Uso: UC-006
   Código de ejemplo: Ver sección 7.2

**ALR-002: configura_alertas**

.. code-block:: yaml

   Función: configura_alertas
   Módulo: MOD_Alerts
   Capacidad: alerts:configurar
   
   ANTES (sistema típico con email):
     1. Configurar alerta con umbral
     2. Seleccionar destinatarios
     3. Elegir canal: Email, SMS, etc.
     4. Cuando se dispara → enviar email
   
   AHORA (IACT con buzón interno):
     1. Configurar alerta con umbral
     2. Seleccionar destinatarios (max 50 - CNST_004)
     3. Canal: SOLO buzón interno (no hay opción)
     4. Cuando se dispara:
        - Crear notificación en buzón de cada destinatario
        - Severidad: INFO, WARNING, CRITICAL
        - Timestamp del evento
        - Valores actuales vs umbral
   
   Restricción CNST_001:
     ✓ NO envío de email de alertas
     ✓ NO opción de seleccionar email como canal
   
   Restricción CNST_004:
     ✓ Máximo 50 destinatarios
     ✓ Consolidación de alertas repetidas
   
   Caso de Uso: UC-036
   Código de ejemplo: Ver sección 7.3

**ALR-003: configura_alertas_equipo**

.. code-block:: yaml

   Función: configura_alertas_equipo
   Módulo: MOD_Alerts
   Capacidad: alerts:config_equipo
   
   Similar a ALR-002 pero para múltiples usuarios del mismo segmento.
   
   Restricción CNST_001:
     ✓ NO envío de email grupal
     ✓ Notificación individual en buzón de cada miembro
   
   Caso de Uso: UC-040

3.2 Módulos con Restricción Indirecta
---------------------------------------

**MOD_Reports: Sin Envío de Reportes**

- ``exporta_csv`` (RPT-004): Descarga directa, no envío por email
- ``exporta_excel`` (RPT-005): Descarga directa, no envío por email
- ``exporta_pdf`` (RPT-006): Descarga directa, no envío por email

**Consecuencia:**
   Usuario debe descargar el reporte manualmente. 
   NO se implementa funcionalidad de "enviar reporte por email".

**MOD_Pipeline: Notificaciones de ETL**

Cuando hay errores en el ETL:
   - NO se envía email a administradores
   - Se crea notificación en buzón interno de usuarios con ``ve_errores_etl``
   - Opcionalmente: log en MOD_Logs

**MOD_Audit: Reportes de Compliance**

``genera_reporte_compliance`` (AUD-004):
   - NO envío automático por email
   - Descarga manual del reporte
   - Si se requiere envío externo: proceso manual fuera del sistema

============================================================
4. IMPLEMENTACIÓN DEL BUZÓN INTERNO
============================================================

4.1 Características del Buzón Interno
---------------------------------------

El buzón interno es un componente del sistema IACT que:

**Funcionalidades:**

- Recepción de notificaciones del sistema
- Visualización de notificaciones con filtros
- Marcado de leído/no leído
- Eliminación de notificaciones (por usuario, no del sistema)
- Búsqueda de notificaciones históricas
- Categorización por tipo y severidad

**NO incluye:**

- Envío de mensajes entre usuarios (no es chat)
- Adjuntar archivos (solo texto + enlaces)
- Responder a notificaciones
- Reenvío a email externo

**Seguridad:**

- Solo el usuario propietario puede ver sus notificaciones
- Notificaciones encriptadas en BD
- Log inmutable de todas las notificaciones enviadas (auditoría)
- Retención: Mínimo 2 años

4.2 Tipos de Notificaciones
-----------------------------

.. list-table:: Tipos de Notificaciones del Buzón Interno
   :header-rows: 1
   :widths: 20 20 60

   * - Tipo
     - Severidad
     - Ejemplos
   * - SISTEMA
     - INFO
     - Mantenimiento programado, Nuevas funcionalidades
   * - CUENTA
     - WARNING
     - Password temporal generado, Cambio de permisos
   * - ALERTA
     - CRITICAL
     - Umbral superado, Error en ETL
   * - REPORTE
     - INFO
     - Reporte generado, Exportación completada
   * - SEGURIDAD
     - WARNING
     - Intento de acceso denegado, Sesión cerrada por admin

4.3 Modelo de Datos
---------------------

.. code-block:: sql

   CREATE TABLE notificaciones_buzon (
       notificacion_id BIGINT AUTO_INCREMENT PRIMARY KEY,
       usuario_id INT NOT NULL,
       tipo VARCHAR(50) NOT NULL, 
       severidad VARCHAR(20) NOT NULL,
       titulo VARCHAR(200) NOT NULL,
       mensaje TEXT NOT NULL,
       url_accion VARCHAR(500), -- Enlace opcional (ej: /cambiar-password)
       leida BOOLEAN NOT NULL DEFAULT FALSE,
       fecha_leida DATETIME,
       eliminada_por_usuario BOOLEAN NOT NULL DEFAULT FALSE,
       fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
       metadata JSON, -- Datos adicionales según tipo
       
       CONSTRAINT fk_notif_usuario FOREIGN KEY (usuario_id) 
           REFERENCES usuarios(usuario_id),
       INDEX idx_notif_usuario_fecha (usuario_id, fecha_creacion DESC),
       INDEX idx_notif_leida (usuario_id, leida),
       INDEX idx_notif_tipo (tipo)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
   
   -- Tabla de auditoría (inmutable)
   CREATE TABLE audit_notificaciones_enviadas (
       audit_id BIGINT AUTO_INCREMENT PRIMARY KEY,
       notificacion_id BIGINT NOT NULL,
       usuario_destino_id INT NOT NULL,
       tipo VARCHAR(50) NOT NULL,
       titulo VARCHAR(200) NOT NULL,
       fecha_envio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
       checksum_registro CHAR(64) NOT NULL, -- SHA-256
       
       INDEX idx_audit_notif (notificacion_id),
       INDEX idx_audit_usuario (usuario_destino_id),
       INDEX idx_audit_fecha (fecha_envio)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

4.4 API del Buzón Interno
---------------------------

.. code-block:: python

   # file: core/buzon_interno.py
   from django.db import models
   from django.utils import timezone
   import hashlib
   import json
   
   class BuzonInterno:
       """
       Gestor del buzón interno del sistema.
       
       ÚNICA forma de notificar a usuarios (NO email).
       """
       
       TIPOS = [
           'SISTEMA',
           'CUENTA',
           'ALERTA',
           'REPORTE',
           'SEGURIDAD',
       ]
       
       SEVERIDADES = [
           'INFO',
           'WARNING',
           'CRITICAL',
       ]
       
       @classmethod
       def enviar_notificacion(cls, usuario_id, tipo, severidad, 
                               titulo, mensaje, url_accion=None, 
                               metadata=None):
           """
           Envía una notificación al buzón interno de un usuario.
           
           Args:
               usuario_id (int): ID del usuario destinatario
               tipo (str): Tipo de notificación (ver TIPOS)
               severidad (str): Severidad (INFO, WARNING, CRITICAL)
               titulo (str): Título de la notificación (max 200 chars)
               mensaje (str): Mensaje completo
               url_accion (str, optional): URL para acción relacionada
               metadata (dict, optional): Datos adicionales en JSON
           
           Returns:
               Notificacion: Objeto de notificación creado
           
           Raises:
               ValueError: Si tipo o severidad no son válidos
           """
           from .models import NotificacionBuzon, AuditNotificacionEnviada
           
           # Validaciones
           if tipo not in cls.TIPOS:
               raise ValueError(f"Tipo '{tipo}' no válido. Usar: {cls.TIPOS}")
           
           if severidad not in cls.SEVERIDADES:
               raise ValueError(f"Severidad '{severidad}' no válida. Usar: {cls.SEVERIDADES}")
           
           if len(titulo) > 200:
               raise ValueError("Título no puede exceder 200 caracteres")
           
           # Crear notificación
           notificacion = NotificacionBuzon.objects.create(
               usuario_id=usuario_id,
               tipo=tipo,
               severidad=severidad,
               titulo=titulo,
               mensaje=mensaje,
               url_accion=url_accion,
               metadata=metadata or {}
           )
           
           # Registrar en auditoría (inmutable)
           cls._audit_notificacion_enviada(notificacion)
           
           return notificacion
       
       @classmethod
       def enviar_notificacion_masiva(cls, usuarios_ids, tipo, severidad,
                                      titulo, mensaje, url_accion=None):
           """
           Envía la misma notificación a múltiples usuarios.
           
           Usado por alertas de equipo (ALR-003).
           
           Args:
               usuarios_ids (list): Lista de IDs de usuarios
               ... (resto igual a enviar_notificacion)
           
           Returns:
               int: Cantidad de notificaciones enviadas
           
           Raises:
               ValueError: Si usuarios_ids > 50 (CNST_004)
           """
           if len(usuarios_ids) > 50:
               raise ValueError(
                   "Máximo 50 destinatarios por notificación (CNST_004)"
               )
           
           count = 0
           for usuario_id in usuarios_ids:
               cls.enviar_notificacion(
                   usuario_id=usuario_id,
                   tipo=tipo,
                   severidad=severidad,
                   titulo=titulo,
                   mensaje=mensaje,
                   url_accion=url_accion
               )
               count += 1
           
           return count
       
       @classmethod
       def _audit_notificacion_enviada(cls, notificacion):
           """
           Registra el envío de notificación en tabla de auditoría inmutable.
           """
           from .models import AuditNotificacionEnviada
           
           # Calcular checksum del registro
           data = f"{notificacion.notificacion_id}|{notificacion.usuario_id}|{notificacion.tipo}|{notificacion.titulo}|{notificacion.fecha_creacion.isoformat()}"
           checksum = hashlib.sha256(data.encode()).hexdigest()
           
           AuditNotificacionEnviada.objects.create(
               notificacion_id=notificacion.notificacion_id,
               usuario_destino_id=notificacion.usuario_id,
               tipo=notificacion.tipo,
               titulo=notificacion.titulo,
               fecha_envio=notificacion.fecha_creacion,
               checksum_registro=checksum
           )
       
       @classmethod
       def obtener_notificaciones_usuario(cls, usuario_id, solo_no_leidas=False,
                                          tipo=None, limit=50):
           """
           Obtiene notificaciones de un usuario.
           
           Args:
               usuario_id (int): ID del usuario
               solo_no_leidas (bool): Si True, solo no leídas
               tipo (str, optional): Filtrar por tipo
               limit (int): Máximo de notificaciones (default: 50)
           
           Returns:
               QuerySet: Notificaciones ordenadas por fecha DESC
           """
           from .models import NotificacionBuzon
           
           qs = NotificacionBuzon.objects.filter(
               usuario_id=usuario_id,
               eliminada_por_usuario=False
           )
           
           if solo_no_leidas:
               qs = qs.filter(leida=False)
           
           if tipo:
               qs = qs.filter(tipo=tipo)
           
           return qs.order_by('-fecha_creacion')[:limit]
       
       @classmethod
       def marcar_como_leida(cls, notificacion_id, usuario_id):
           """
           Marca una notificación como leída.
           
           Solo el propietario puede marcar sus notificaciones.
           """
           from .models import NotificacionBuzon
           
           notif = NotificacionBuzon.objects.get(
               notificacion_id=notificacion_id,
               usuario_id=usuario_id  # Validación de propietario
           )
           
           if not notif.leida:
               notif.leida = True
               notif.fecha_leida = timezone.now()
               notif.save(update_fields=['leida', 'fecha_leida'])
       
       @classmethod
       def eliminar_para_usuario(cls, notificacion_id, usuario_id):
           """
           "Elimina" una notificación para el usuario (soft delete).
           
           La notificación sigue en BD para auditoría, pero el usuario
           ya no la ve en su buzón.
           """
           from .models import NotificacionBuzon
           
           notif = NotificacionBuzon.objects.get(
               notificacion_id=notificacion_id,
               usuario_id=usuario_id
           )
           
           notif.eliminada_por_usuario = True
           notif.save(update_fields=['eliminada_por_usuario'])

============================================================
5. VALIDACIÓN Y TESTING
============================================================

5.1 Checklist de Validación
-----------------------------

Para validar que CNST_001 se cumple:

.. code-block:: text

   ☐ 1. Búsqueda de Código
        Buscar en todo el código fuente:
        - Importaciones de librerías de email (smtplib, django.core.mail)
        - Llamadas a send_mail()
        - Configuración de SMTP en settings
        
        Resultado esperado: 0 ocurrencias
   
   ☐ 2. Revisión de Configuración
        Verificar settings.py:
        - EMAIL_BACKEND debe estar ausente o comentado
        - EMAIL_HOST debe estar ausente
        - SMTP_* variables ausentes
        
        Resultado esperado: No configuración de email
   
   ☐ 3. Test de Funciones RBAC
        Para AUT-003, USR-001, ALR-002, ALR-003:
        - Ejecutar función
        - Verificar que NO se envía email
        - Verificar que SÍ se crea notificación en buzón
        
        Resultado esperado: 100% notificaciones por buzón
   
   ☐ 4. Auditoría de Logs
        Revisar tabla audit_notificaciones_enviadas:
        - Verificar que TODAS las notificaciones están registradas
        - Verificar checksums válidos
        - Verificar que no hay emails en logs externos
        
        Resultado esperado: Auditoría completa
   
   ☐ 5. Prueba de Recuperación de Password
        UC-003:
        1. Solicitar recuperación de password
        2. Verificar que NO se envía email
        3. Verificar notificación en buzón interno
        4. Verificar password temporal funcional
        
        Resultado esperado: Flujo completo sin email
   
   ☐ 6. Prueba de Creación de Usuario
        UC-006:
        1. Crear nuevo usuario
        2. Verificar que NO se envía email de bienvenida
        3. Verificar notificación en buzón interno
        4. Verificar credenciales en notificación
        
        Resultado esperado: Usuario creado, credenciales en buzón
   
   ☐ 7. Prueba de Alertas
        UC-036:
        1. Configurar alerta con umbral
        2. Disparar alerta (superar umbral)
        3. Verificar que NO se envía email
        4. Verificar notificación en buzón interno
        
        Resultado esperado: Alerta en buzón, no email

5.2 Scripts de Testing
-----------------------

.. code-block:: python

   # file: tests/test_cnst_001.py
   from django.test import TestCase
   from core.buzon_interno import BuzonInterno
   from core.models import NotificacionBuzon
   from users.models import Usuario
   import re
   
   class TestCNST001(TestCase):
       """
       Tests para validar CNST_001: NO Email bajo ninguna circunstancia
       """
       
       def setUp(self):
           self.usuario = Usuario.objects.create(
               username='test_user',
               email='test@example.com'
           )
       
       def test_no_email_imports_in_codebase(self):
           """
           Verificar que no hay importaciones de librerías de email.
           """
           import os
           import subprocess
           
           # Buscar en todo el código fuente
           result = subprocess.run(
               ['grep', '-r', 'from django.core.mail import', '.'],
               capture_output=True,
               text=True
           )
           
           # No debe haber ninguna ocurrencia
           self.assertEqual(result.returncode, 1, 
               "Se encontraron importaciones de django.core.mail")
       
       def test_buzon_interno_funcional(self):
           """
           Verificar que buzón interno funciona correctamente.
           """
           # Enviar notificación
           notif = BuzonInterno.enviar_notificacion(
               usuario_id=self.usuario.usuario_id,
               tipo='CUENTA',
               severidad='INFO',
               titulo='Test de buzón',
               mensaje='Mensaje de prueba'
           )
           
           # Verificar creación
           self.assertIsNotNone(notif.notificacion_id)
           self.assertEqual(notif.usuario_id, self.usuario.usuario_id)
           self.assertFalse(notif.leida)
           
           # Verificar auditoría
           from core.models import AuditNotificacionEnviada
           audit = AuditNotificacionEnviada.objects.filter(
               notificacion_id=notif.notificacion_id
           ).first()
           
           self.assertIsNotNone(audit)
           self.assertEqual(len(audit.checksum_registro), 64)  # SHA-256
       
       def test_reseteo_password_sin_email(self):
           """
           UC-003: Verificar que reseteo de password NO envía email.
           """
           from auth.services import resetear_password
           
           # Ejecutar reseteo
           resultado = resetear_password(self.usuario)
           
           # Verificar que hay notificación en buzón
           notifs = BuzonInterno.obtener_notificaciones_usuario(
               self.usuario.usuario_id,
               tipo='CUENTA'
           )
           
           self.assertGreater(notifs.count(), 0)
           
           # Verificar que la última notificación es de password
           ultima = notifs.first()
           self.assertIn('contraseña temporal', ultima.titulo.lower())
           self.assertIn('password', ultima.mensaje.lower())
       
       def test_creacion_usuario_sin_email(self):
           """
           UC-006: Verificar que creación de usuario NO envía email.
           """
           from users.services import crear_usuario
           
           # Crear usuario
           nuevo = crear_usuario(
               email='nuevo@example.com',
               nombre='Test',
               apellido='User',
               segmento_id='OP'
           )
           
           # Verificar notificación en buzón
           notifs = BuzonInterno.obtener_notificaciones_usuario(
               nuevo.usuario_id,
               tipo='CUENTA'
           )
           
           self.assertGreater(notifs.count(), 0)
           
           # Verificar contenido de bienvenida
           bienvenida = notifs.first()
           self.assertIn('bienvenido', bienvenida.titulo.lower())
       
       def test_alerta_sin_email(self):
           """
           UC-036: Verificar que alertas NO envían email.
           """
           from alerts.services import disparar_alerta
           
           # Disparar alerta
           disparar_alerta(
               usuario_id=self.usuario.usuario_id,
               titulo='Umbral superado',
               mensaje='Llamadas > 10,000',
               severidad='WARNING'
           )
           
           # Verificar notificación en buzón
           notifs = BuzonInterno.obtener_notificaciones_usuario(
               self.usuario.usuario_id,
               tipo='ALERTA'
           )
           
           self.assertGreater(notifs.count(), 0)
           
           alerta = notifs.first()
           self.assertEqual(alerta.severidad, 'WARNING')
       
       def test_notificacion_masiva_limite_50(self):
           """
           CNST_004: Verificar límite de 50 destinatarios.
           """
           # Intentar enviar a 51 usuarios (debe fallar)
           usuarios_ids = list(range(1, 52))
           
           with self.assertRaises(ValueError) as context:
               BuzonInterno.enviar_notificacion_masiva(
                   usuarios_ids=usuarios_ids,
                   tipo='ALERTA',
                   severidad='INFO',
                   titulo='Test',
                   mensaje='Mensaje de prueba'
               )
           
           self.assertIn('Máximo 50 destinatarios', str(context.exception))

5.3 Herramientas de Monitoreo
-------------------------------

.. code-block:: python

   # file: monitoring/cnst_001_monitor.py
   """
   Monitor para detectar violaciones de CNST_001.
   """
   import logging
   from django.core.management.base import BaseCommand
   
   class Command(BaseCommand):
       help = 'Monitorea cumplimiento de CNST_001'
       
       def handle(self, *args, **options):
           violations = []
           
           # 1. Verificar que no hay configuración de email
           from django.conf import settings
           
           if hasattr(settings, 'EMAIL_BACKEND'):
               violations.append("EMAIL_BACKEND configurado en settings")
           
           if hasattr(settings, 'EMAIL_HOST'):
               violations.append("EMAIL_HOST configurado en settings")
           
           # 2. Buscar imports de email en código
           import os
           import subprocess
           
           result = subprocess.run(
               ['grep', '-r', 'send_mail', '.', '--include=*.py'],
               capture_output=True,
               text=True
           )
           
           if result.returncode == 0:
               violations.append(
                   f"Se encontraron {len(result.stdout.splitlines())} "
                   f"llamadas a send_mail() en el código"
               )
           
           # 3. Verificar que buzón interno está activo
           from core.models import NotificacionBuzon
           
           count_24h = NotificacionBuzon.objects.filter(
               fecha_creacion__gte=timezone.now() - timedelta(hours=24)
           ).count()
           
           if count_24h == 0:
               violations.append(
                   "No se han enviado notificaciones en buzón en 24h "
                   "(posible problema)"
               )
           
           # Reporte
           if violations:
               self.stdout.write(
                   self.style.ERROR(f"\n⚠️  VIOLACIONES CNST_001 DETECTADAS:")
               )
               for v in violations:
                   self.stdout.write(self.style.ERROR(f"  - {v}"))
           else:
               self.stdout.write(
                   self.style.SUCCESS("\n✓ CNST_001 cumplido correctamente")
               )

============================================================
6. EXCEPCIONES Y CASOS ESPECIALES
============================================================

6.1 Política de Excepciones
-----------------------------

   **NO EXISTEN EXCEPCIONES A CNST_001.**
   
   Esta restricción es ABSOLUTA y NO NEGOCIABLE.

Si surge un requisito que "requiere" email:

1. **RECHAZAR** la funcionalidad
2. **REDISEÑAR** usando buzón interno
3. **ESCALAR** a Tech Lead si hay presión de negocio

Ejemplos de requisitos rechazados:

.. code-block:: text

   ❌ "Necesitamos enviar el reporte mensual por email"
      → NO. Usuario descarga el reporte manualmente.
   
   ❌ "El cliente quiere recibir alertas por email"
      → NO. Cliente revisa buzón interno o integra vía API.
   
   ❌ "Auditoría externa pide que les enviemos logs por email"
      → NO. Auditor accede al sistema o descarga manualmente.
   
   ❌ "Para recuperación de password necesitamos email"
      → NO. Usamos buzón interno con password temporal.

6.2 Integración con Sistemas Externos
---------------------------------------

Si un sistema externo REQUIERE comunicación por email:

**Opción A: API REST**

- Exponer API endpoint para que sistema externo consulte
- Ejemplo: ``GET /api/v1/notificaciones/usuario/{id}``
- Sistema externo decide si envía email (fuera de IACT)

**Opción B: Webhook**

- IACT notifica vía webhook a sistema externo
- Sistema externo procesa y decide si envía email
- IACT NO envía el email directamente

**Opción C: Integración Manual**

- Usuario descarga datos de IACT
- Usuario los envía manualmente por email
- IACT solo genera el contenido

Ejemplo:

.. code-block:: python

   # Sistema externo (FUERA de IACT) puede enviar email
   # basado en datos de IACT obtenidos vía API
   
   # File: external_system/notifier.py (NO parte de IACT)
   import requests
   import smtplib
   
   def enviar_reporte_por_email():
       # Obtener datos de IACT vía API
       response = requests.get('https://iact.example.com/api/reportes/123')
       reporte = response.json()
       
       # ESTE CÓDIGO ESTÁ FUERA DE IACT
       # Sistema externo decide enviar email
       send_email(
           to='cliente@example.com',
           subject='Reporte IACT',
           body=reporte['contenido']
       )

**CRÍTICO:** El código que envía email NUNCA está en IACT.

============================================================
7. EJEMPLOS DE IMPLEMENTACIÓN
============================================================

7.1 Ejemplo: Reseteo de Password (AUT-003)
--------------------------------------------

.. code-block:: python

   # file: auth/services.py
   from core.buzon_interno import BuzonInterno
   from django.contrib.auth.hashers import make_password
   import secrets
   import string
   
   def resetear_password(usuario):
       """
       Genera contraseña temporal y notifica por buzón interno.
       
       Implementa AUT-003 cumpliendo CNST_001.
       """
       # 1. Generar contraseña temporal segura
       alfabeto = string.ascii_letters + string.digits + '!@#$%^&*'
       password_temporal = ''.join(secrets.choice(alfabeto) for _ in range(14))
       
       # 2. Actualizar hash en BD
       usuario.password = make_password(password_temporal)
       usuario.debe_cambiar_password = True
       usuario.password_temporal_expira = timezone.now() + timedelta(hours=24)
       usuario.save(update_fields=[
           'password', 
           'debe_cambiar_password', 
           'password_temporal_expira'
       ])
       
       # 3. Notificar por buzón interno (CNST_001)
       BuzonInterno.enviar_notificacion(
           usuario_id=usuario.usuario_id,
           tipo='CUENTA',
           severidad='WARNING',
           titulo='Contraseña temporal generada',
           mensaje=(
               f"Se ha generado una contraseña temporal para tu cuenta.\n\n"
               f"Tu contraseña temporal es: {password_temporal}\n\n"
               f"Esta contraseña expira en 24 horas.\n"
               f"Debes cambiarla en tu primer inicio de sesión.\n\n"
               f"Si no solicitaste este cambio, contacta al administrador."
           ),
           url_accion='/cambiar-password',
           metadata={
               'tipo_evento': 'PASSWORD_RESET',
               'expira_en_horas': 24
           }
       )
       
       # 4. Registrar en auditoría
       from core.models import AuditLog
       AuditLog.objects.create(
           usuario=usuario,
           accion='PASSWORD_RESET',
           modulo='MOD_Auth',
           resultado='SUCCESS'
       )
       
       return {
           'success': True,
           'mensaje': 'Contraseña temporal generada. Revisa tu buzón interno.',
           'password_temporal': password_temporal  # Solo para testing
       }

7.2 Ejemplo: Creación de Usuario (USR-001)
--------------------------------------------

.. code-block:: python

   # file: users/services.py
   from core.buzon_interno import BuzonInterno
   from core.rbac import RBACManager
   import secrets
   import string
   
   def crear_usuario(email, nombre, apellido, segmento_id, creado_por):
       """
       Crea un nuevo usuario y notifica credenciales por buzón interno.
       
       Implementa USR-001 cumpliendo CNST_001.
       """
       from users.models import Usuario
       
       # 1. Validar email único
       if Usuario.objects.filter(email=email).exists():
           raise ValueError(f"Email {email} ya existe")
       
       # 2. Generar username automático (CNST_005)
       username = email.split('@')[0].lower()
       if Usuario.objects.filter(username=username).exists():
           username = f"{username}_{secrets.randbelow(1000)}"
       
       # 3. Generar contraseña temporal
       alfabeto = string.ascii_letters + string.digits + '!@#$%^&*'
       password_temporal = ''.join(secrets.choice(alfabeto) for _ in range(14))
       
       # 4. Crear usuario con estado PENDIENTE_CONFIGURACION (CNST_005)
       usuario = Usuario.objects.create(
           username=username,
           email=email,
           nombre=nombre,
           apellido=apellido,
           segmento_id=segmento_id,
           estado='PENDIENTE_CONFIGURACION',
           debe_cambiar_password=True,
           password=make_password(password_temporal)
       )
       
       # 5. Notificar credenciales por buzón interno (CNST_001)
       BuzonInterno.enviar_notificacion(
           usuario_id=usuario.usuario_id,
           tipo='CUENTA',
           severidad='INFO',
           titulo='¡Bienvenido al Sistema IACT!',
           mensaje=(
               f"Hola {nombre},\n\n"
               f"Tu cuenta ha sido creada exitosamente.\n\n"
               f"Tus credenciales de acceso son:\n"
               f"  • Usuario: {username}\n"
               f"  • Contraseña temporal: {password_temporal}\n\n"
               f"Debes cambiar tu contraseña en el primer inicio de sesión.\n\n"
               f"Segmento de datos asignado: {segmento_id}\n\n"
               f"Accede al sistema en: https://iact.example.com/login"
           ),
           url_accion='/login',
           metadata={
               'tipo_evento': 'USER_CREATED',
               'creado_por': creado_por.username
           }
       )
       
       # 6. Registrar en auditoría
       from core.models import AuditLog
       AuditLog.objects.create(
           usuario=creado_por,
           accion='USER_CREATE',
           modulo='MOD_Users',
           recurso_afectado=f"Usuario: {usuario.username}",
           resultado='SUCCESS'
       )
       
       return usuario

7.3 Ejemplo: Configuración de Alerta (ALR-002)
------------------------------------------------

.. code-block:: python

   # file: alerts/services.py
   from core.buzon_interno import BuzonInterno
   
   def disparar_alerta(alerta, valor_actual, timestamp):
       """
       Dispara una alerta y notifica por buzón interno.
       
       Implementa ALR-002 cumpliendo CNST_001 + CNST_004.
       """
       from alerts.models import Alerta
       
       # 1. Obtener destinatarios (max 50 por CNST_004)
       destinatarios = alerta.obtener_destinatarios()
       
       if len(destinatarios) > 50:
           raise ValueError("Máximo 50 destinatarios por alerta (CNST_004)")
       
       # 2. Preparar mensaje
       titulo = f"⚠️ Alerta: {alerta.nombre}"
       
       mensaje = (
           f"La alerta '{alerta.nombre}' se ha disparado.\n\n"
           f"  • Métrica: {alerta.metrica}\n"
           f"  • Umbral configurado: {alerta.umbral}\n"
           f"  • Valor actual: {valor_actual}\n"
           f"  • Timestamp: {timestamp}\n"
           f"  • Severidad: {alerta.severidad}\n\n"
           f"Revisa el dashboard para más detalles."
       )
       
       # 3. Enviar notificación a cada destinatario por buzón interno (CNST_001)
       usuarios_notificados = []
       
       for destinatario in destinatarios:
           BuzonInterno.enviar_notificacion(
               usuario_id=destinatario.usuario_id,
               tipo='ALERTA',
               severidad=alerta.severidad,  # INFO, WARNING, CRITICAL
               titulo=titulo,
               mensaje=mensaje,
               url_accion=f'/alerts/{alerta.alerta_id}/detail',
               metadata={
                   'alerta_id': alerta.alerta_id,
                   'metrica': alerta.metrica,
                   'valor_actual': valor_actual,
                   'umbral': alerta.umbral
               }
           )
           usuarios_notificados.append(destinatario.username)
       
       # 4. Registrar disparo en BD
       from alerts.models import AlertaDisparo
       AlertaDisparo.objects.create(
           alerta=alerta,
           fecha_disparo=timestamp,
           valor_actual=valor_actual,
           usuarios_notificados=usuarios_notificados
       )
       
       # 5. Auditoría
       from core.models import AuditLog
       AuditLog.objects.create(
           accion='ALERT_TRIGGERED',
           modulo='MOD_Alerts',
           recurso_afectado=f"Alerta: {alerta.nombre}",
           resultado='SUCCESS',
           detalles={
               'destinatarios': len(destinatarios),
               'valor_actual': valor_actual
           }
       )
       
       return {
           'success': True,
           'usuarios_notificados': len(usuarios_notificados)
       }

============================================================
8. REFERENCIAS
============================================================

8.1 Documentos Relacionados
-----------------------------

:CNST_004: Alertas buzón interno, máx 50 destinatarios
:CNST_005: RBAC Flat, SoD, permisos con vencimiento
:CNST_008: Audit inmutable, logs sin PII
:UC_003: Recuperación de contraseña
:UC_006: Crear usuario
:UC_036: Configurar alerta personal
:UC_037: Recibir notificación interna
:UC_040: Gestionar destinatarios de alerta

8.2 Funciones RBAC Relacionadas
---------------------------------

:AUT_003: resetea_password
:USR_001: crea_usuarios
:ALR_002: configura_alertas
:ALR_003: configura_alertas_equipo

8.3 Referencias Externas
--------------------------

- Django Documentation: Custom Notifications System
- OWASP: Secure Password Recovery
- NIST: Password Guidelines

============================================================
9. HISTORIAL DE CAMBIOS
============================================================

.. list-table:: Historial de Versiones
   :header-rows: 1
   :widths: 15 15 70

   * - Versión
     - Fecha
     - Cambios
   * - 1.0.0
     - 2026-01-11
     - Versión inicial. Documentación completa de restricción CNST_001:
       NO email bajo ninguna circunstancia. Incluye:
       - 3 funciones RBAC afectadas directamente
       - Implementación completa de buzón interno
       - API Python funcional
       - Tests exhaustivos
       - Ejemplos de código completos

============================================================

.. warning::
   **RECORDATORIO CRÍTICO:**
   
   CNST_001 es ABSOLUTA y NO NEGOCIABLE.
   
   Si alguien solicita funcionalidad que requiera email:
   1. RECHAZAR inmediatamente
   2. REDISEÑAR usando buzón interno
   3. ESCALAR si persiste la presión
   
   El sistema IACT NO envía emails. NUNCA.

**FIN DEL DOCUMENTO CNST_001**
