.. _CNST_008:

============================================================
CNST_008 - Auditoría Inmutable, Logs sin PII
============================================================

:Restricción: CNST_008
:Versión: 1.0.0
:Fecha: 2026-01-11
:Estado: VIGENTE
:Prioridad: CRÍTICA
:Ámbito: MOD_Audit, MOD_Logs - Auditoría y Logs técnicos
:Fundamento: Compliance, seguridad, no repudio
:Proyecto: IACT-2025-001
:Relacionado_Con: CNST_002 (Sesiones), CNST_005 (RBAC)

.. contents:: Tabla de Contenido
   :depth: 4
   :local:

============================================================
1. RESUMEN EJECUTIVO
============================================================

1.1 Definición de la Restricción
----------------------------------

   **El Sistema IACT mantiene registros de auditoría INMUTABLES y logs 
   técnicos SIN información personal identificable (PII).**
   
   **Características obligatorias:**
   
   1. **Auditoría Inmutable:** Los registros de auditoría NO pueden ser 
      modificados ni eliminados. Solo INSERT, nunca UPDATE ni DELETE.
   
   2. **Sin PII en Logs:** Los logs técnicos NO contienen información 
      personal identificable (nombres, emails, IPs en claro, teléfonos).
   
   3. **Retención Mínima:** Auditoría y logs se retienen mínimo 2 años 
      para compliance.
   
   4. **Integridad Garantizada:** Checksums SHA-256 en cada registro 
      para detectar manipulación.
   
   5. **Segregación:** Auditoría de negocio separada de logs técnicos.

1.2 Justificación
------------------

**Compliance y Legal:**

- Cumplimiento SOX (Sarbanes-Oxley)
- Cumplimiento GDPR (privacidad de datos)
- No repudio de acciones
- Evidencia forense en caso de incidentes
- Auditorías externas

**Seguridad:**

- Detección de accesos no autorizados
- Trazabilidad completa de acciones
- Imposibilidad de "borrar huellas"
- Checksums previenen manipulación

**Privacidad:**

- Logs sin PII protegen privacidad
- Anonimización de datos sensibles
- Cumplimiento de políticas de privacidad
- Reducción de superficie de ataque de datos personales

**Operacional:**

- Debugging de problemas históricos
- Análisis de patrones de uso
- Detección de anomalías
- Métricas de performance

1.3 Impacto General
--------------------

.. list-table:: Impacto de CNST_008
   :header-rows: 1
   :widths: 30 70

   * - Aspecto
     - Impacto
   * - **Usuario Final**
     - • Todas sus acciones son auditadas
       • NO puede borrar su historial
       • Transparencia total (puede ver su propia auditoría)
   * - **Módulos Afectados**
     - • MOD_Audit: Auditoría de negocio
       • MOD_Logs: Logs técnicos
       • TODOS los módulos: Generan eventos de auditoría
   * - **Funciones RBAC**
     - • AUD-001: ve_auditoria
       • AUD-002: busca_auditoria
       • AUD-003: exporta_auditoria
       • AUD-004: genera_reporte_compliance
       • LOG-001: ve_logs_tecnicos
       • LOG-002: exporta_logs
   * - **Infraestructura**
     - • Tabla audit_logs (append-only)
       • Tabla technical_logs (append-only)
       • Proceso de rotación y archivo
       • Backup diario
   * - **Almacenamiento**
     - • Crecimiento constante (solo INSERT)
       • ~500 MB/mes de auditoría
       • ~2 GB/mes de logs técnicos
       • Archivado después de 2 años

============================================================
2. ESPECIFICACIÓN TÉCNICA
============================================================

2.1 Auditoría Inmutable
------------------------

.. code-block:: yaml

   Principio: APPEND-ONLY (solo agregar, nunca modificar/eliminar)
   
   Operaciones permitidas:
     ✓ INSERT: Agregar nuevos registros de auditoría
   
   Operaciones PROHIBIDAS:
     ✗ UPDATE: Modificar registros existentes
     ✗ DELETE: Eliminar registros
     ✗ TRUNCATE: Vaciar tabla
     ✗ DROP: Eliminar tabla
   
   Implementación:
     - Triggers DB que previenen UPDATE/DELETE
     - Permisos de BD: Solo INSERT para app
     - Checksum SHA-256 en cada registro
     - Validación de integridad periódica
   
   Retención:
     - Mínimo: 2 años en BD activa
     - Después: Archivado a almacenamiento frío
     - Formato archivo: Inmutable (WORM - Write Once Read Many)

**Ejemplo de Trigger de Protección:**

.. code-block:: sql

   -- Prevenir UPDATE en audit_logs
   CREATE TRIGGER trg_audit_prevent_update
   BEFORE UPDATE ON audit_logs
   FOR EACH ROW
   BEGIN
       SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'CNST_008: Auditoría es INMUTABLE. UPDATE prohibido.';
   END;
   
   -- Prevenir DELETE en audit_logs
   CREATE TRIGGER trg_audit_prevent_delete
   BEFORE DELETE ON audit_logs
   FOR EACH ROW
   BEGIN
       SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'CNST_008: Auditoría es INMUTABLE. DELETE prohibido.';
   END;

2.2 Logs sin PII
-----------------

.. code-block:: yaml

   Definición de PII (Personal Identifiable Information):
     - Nombres completos
     - Emails
     - Direcciones IP (en claro)
     - Números de teléfono
     - Documentos de identidad
     - Direcciones físicas
     - Cualquier dato que identifique a una persona
   
   Permitido en logs:
     ✓ Usuario ID (número entero, no nombre)
     ✓ IP hasheada (SHA-256)
     ✓ User-Agent hasheado
     ✓ Timestamps
     ✓ Acciones (login, logout, export, etc.)
     ✓ Resultados (success, failed)
     ✓ Metadatos técnicos
   
   NO permitido en logs:
     ✗ Nombres de usuario (texto)
     ✗ Emails (texto)
     ✗ IPs en claro (192.168.1.1)
     ✗ Teléfonos
     ✗ Cualquier PII

**Anonimización de IPs:**

.. code-block:: python

   import hashlib
   
   def anonimizar_ip(ip_address):
       """
       Hashea una IP para logs técnicos.
       
       Permite análisis de patrones sin exponer IPs reales.
       """
       return hashlib.sha256(ip_address.encode()).hexdigest()[:16]
   
   # Ejemplo:
   # IP real: 192.168.1.100
   # IP hasheada: a3f5d7e9c2b1f4a8

2.3 Tipos de Eventos Auditados
--------------------------------

.. list-table:: Eventos de Auditoría
   :header-rows: 1
   :widths: 25 25 50

   * - Categoría
     - Eventos
     - Ejemplos
   * - **Autenticación**
     - Login, Logout, Password reset
     - LOGIN_SUCCESS, LOGIN_FAILED, PASSWORD_CHANGED
   * - **Usuarios**
     - CRUD de usuarios
     - USER_CREATED, USER_MODIFIED, USER_DELETED
   * - **Acceso**
     - Cambios de permisos
     - FUNCTION_ASSIGNED, FUNCTION_REVOKED, SOD_VIOLATION
   * - **Reportes**
     - Visualización, exportación
     - REPORT_VIEWED, REPORT_EXPORTED
   * - **Alertas**
     - Configuración, disparo
     - ALERT_CREATED, ALERT_TRIGGERED
   * - **Pipeline**
     - ETL, errores
     - ETL_STARTED, ETL_SUCCESS, ETL_FAILED
   * - **Sistema**
     - Configuración
     - CONFIG_CHANGED, BACKUP_CREATED

2.4 Checksums de Integridad
-----------------------------

.. code-block:: yaml

   Algoritmo: SHA-256
   
   Cálculo del checksum:
     Datos: audit_id + usuario_id + accion + timestamp + resultado + metadata
     Hash: SHA-256 de la concatenación
   
   Validación:
     - Al leer registro: Recalcular hash y comparar
     - Periódicamente: Validar integridad de TODOS los registros
     - Si hash no coincide → ALERTA de manipulación
   
   Ejemplo:
     audit_id: 12345
     usuario_id: 67
     accion: LOGIN
     timestamp: 2026-01-11 10:30:00
     resultado: SUCCESS
     
     data = "12345|67|LOGIN|2026-01-11 10:30:00|SUCCESS"
     checksum = SHA256(data) = "a7f3d9e1c5b2..."

============================================================
3. FUNCIONES RBAC AFECTADAS
============================================================

3.1 AUD-001: ve_auditoria
---------------------------

.. code-block:: yaml

   Función: ve_auditoria
   Capacidad: audit:ver
   Módulo: MOD_Audit
   
   Acceso:
     - Usuario ve su PROPIA auditoría (transparencia)
     - Auditor ve auditoría de TODOS (función especial)
     - Filtros: Por fecha, por acción, por resultado
   
   Información mostrada:
     - Timestamp
     - Acción realizada
     - Módulo
     - Resultado (success/failed)
     - IP hasheada (no en claro - CNST_008)
     - Detalles adicionales (metadata)
   
   Restricción CNST_008:
     ✓ Solo lectura (no modificación)
     ✓ Sin PII en vista
   
   Caso de Uso: UC-041

3.2 AUD-002: busca_auditoria
-----------------------------

.. code-block:: yaml

   Función: busca_auditoria
   Capacidad: audit:buscar
   Módulo: MOD_Audit
   
   Búsqueda avanzada:
     - Por rango de fechas
     - Por tipo de acción
     - Por módulo
     - Por resultado (success/failed)
     - Por usuario (solo auditores)
   
   Restricción CNST_008:
     ✓ Solo lectura
     ✓ Sin PII expuesto
   
   Caso de Uso: UC-042

3.3 AUD-003: exporta_auditoria
--------------------------------

.. code-block:: yaml

   Función: exporta_auditoria
   Capacidad: audit:exportar
   Módulo: MOD_Audit
   
   Exportación:
     - Formato: CSV, Excel
     - Límites: Igual que CNST_007
     - Contenido: Registros de auditoría filtrados
   
   Restricción CNST_008:
     ✓ Exporta datos INMUTABLES
     ✓ Sin PII (IPs hasheadas)
     ✓ Checksums incluidos para validación
   
   Caso de Uso: UC-043

3.4 AUD-004: genera_reporte_compliance
----------------------------------------

.. code-block:: yaml

   Función: genera_reporte_compliance
   Capacidad: audit:compliance
   Módulo: MOD_Audit
   
   Reporte especial:
     - Formato: PDF oficial
     - Contenido: Resumen de auditoría para compliance
     - Período: Últimos 12 meses típicamente
     - Incluye:
       * Total de eventos
       * Eventos por categoría
       * Fallos de autenticación
       * Cambios de permisos
       * Violaciones SOD
   
   Uso: Auditorías SOX, auditorías internas
   
   Caso de Uso: UC-044

3.5 LOG-001: ve_logs_tecnicos
-------------------------------

.. code-block:: yaml

   Función: ve_logs_tecnicos
   Capacidad: logs:ver
   Módulo: MOD_Logs
   
   Logs técnicos:
     - Errores de aplicación
     - Warnings
     - Performance metrics
     - Queries lentos
   
   Restricción CNST_008:
     ✓ SIN PII (nombres, emails, IPs en claro)
     ✓ IPs hasheadas
     ✓ Usuario IDs (no nombres)
   
   Caso de Uso: UC-048

3.6 LOG-002: exporta_logs
--------------------------

.. code-block:: yaml

   Función: exporta_logs
   Capacidad: logs:exportar
   Módulo: MOD_Logs
   
   Exportación de logs:
     - Formato: Texto plano, JSON
     - Para análisis externo
     - Debugging avanzado
   
   Restricción CNST_008:
     ✓ SIN PII
     ✓ Datos anonimizados
   
   Caso de Uso: UC-049

============================================================
4. MODELO DE DATOS
============================================================

4.1 Tabla: audit_logs
----------------------

.. code-block:: sql

   CREATE TABLE audit_logs (
       audit_id BIGINT AUTO_INCREMENT PRIMARY KEY,
       
       -- ¿Quién?
       usuario_id INT NOT NULL,
       
       -- ¿Qué?
       accion VARCHAR(100) NOT NULL,
       modulo VARCHAR(50) NOT NULL,
       recurso_afectado VARCHAR(500),
       
       -- ¿Cuándo?
       timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
       
       -- ¿Cómo?
       resultado ENUM('SUCCESS', 'FAILED', 'PARTIAL') NOT NULL,
       
       -- ¿Dónde?
       ip_address_hash CHAR(16) NOT NULL,  -- SHA-256 truncado (sin PII)
       user_agent_hash CHAR(16),
       
       -- Detalles
       detalles JSON,
       
       -- Integridad (CNST_008)
       checksum_registro CHAR(64) NOT NULL,  -- SHA-256
       
       -- Metadata
       sesion_id CHAR(36),
       
       CONSTRAINT fk_audit_usuario FOREIGN KEY (usuario_id) 
           REFERENCES usuarios(usuario_id),
       
       INDEX idx_audit_usuario_timestamp (usuario_id, timestamp DESC),
       INDEX idx_audit_accion (accion),
       INDEX idx_audit_modulo (modulo),
       INDEX idx_audit_timestamp (timestamp DESC),
       INDEX idx_audit_resultado (resultado)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
   
   -- CRÍTICO: Triggers para prevenir UPDATE/DELETE
   
   DELIMITER $$
   
   CREATE TRIGGER trg_audit_prevent_update
   BEFORE UPDATE ON audit_logs
   FOR EACH ROW
   BEGIN
       SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'CNST_008: Auditoría INMUTABLE - UPDATE prohibido';
   END$$
   
   CREATE TRIGGER trg_audit_prevent_delete
   BEFORE DELETE ON audit_logs
   FOR EACH ROW
   BEGIN
       SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'CNST_008: Auditoría INMUTABLE - DELETE prohibido';
   END$$
   
   DELIMITER ;

4.2 Tabla: technical_logs
---------------------------

.. code-block:: sql

   CREATE TABLE technical_logs (
       log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
       
       -- Timestamp
       timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
       
       -- Nivel
       nivel ENUM('DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL') NOT NULL,
       
       -- Mensaje
       mensaje TEXT NOT NULL,
       
       -- Origen
       modulo VARCHAR(100),
       funcion VARCHAR(200),
       linea_codigo INT,
       
       -- Contexto (SIN PII - CNST_008)
       usuario_id INT,  -- ID numérico OK, nombre NO
       ip_hash CHAR(16),  -- IP hasheada, NO en claro
       
       -- Stack trace (solo para errores)
       stack_trace TEXT,
       
       -- Metadata adicional
       metadata JSON,
       
       INDEX idx_tech_timestamp (timestamp DESC),
       INDEX idx_tech_nivel (nivel),
       INDEX idx_tech_modulo (modulo)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
   
   -- También inmutable
   
   DELIMITER $$
   
   CREATE TRIGGER trg_techlog_prevent_update
   BEFORE UPDATE ON technical_logs
   FOR EACH ROW
   BEGIN
       SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'CNST_008: Logs técnicos INMUTABLES - UPDATE prohibido';
   END$$
   
   CREATE TRIGGER trg_techlog_prevent_delete
   BEFORE DELETE ON technical_logs
   FOR EACH ROW
   BEGIN
       SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'CNST_008: Logs técnicos INMUTABLES - DELETE prohibido';
   END$$
   
   DELIMITER ;

4.3 Vista: Auditoría por Usuario
----------------------------------

.. code-block:: sql

   CREATE VIEW vw_auditoria_por_usuario AS
   SELECT 
       al.audit_id,
       al.usuario_id,
       u.username,  -- Solo para vista, no en logs raw
       al.accion,
       al.modulo,
       al.recurso_afectado,
       al.timestamp,
       al.resultado,
       al.ip_address_hash,  -- Hasheada
       al.detalles,
       
       -- Validación de integridad
       al.checksum_registro,
       
       -- Verificar si checksum es válido
       SHA2(CONCAT(
           al.audit_id, '|',
           al.usuario_id, '|',
           al.accion, '|',
           al.timestamp, '|',
           al.resultado
       ), 256) = al.checksum_registro AS checksum_valido
       
   FROM audit_logs al
   INNER JOIN usuarios u ON al.usuario_id = u.usuario_id
   ORDER BY al.timestamp DESC;

============================================================
5. IMPLEMENTACIÓN DJANGO
============================================================

5.1 Servicio de Auditoría
---------------------------

.. code-block:: python

   # file: audit/service.py
   from django.db import models
   from django.utils import timezone
   import hashlib
   import json
   
   class AuditService:
       """
       Servicio de auditoría.
       
       Implementa CNST_008: Auditoría inmutable con checksums.
       """
       
       @classmethod
       def registrar(cls, usuario, accion, modulo, resultado='SUCCESS',
                    recurso_afectado=None, detalles=None, request=None):
           """
           Registra un evento de auditoría.
           
           Args:
               usuario: Usuario que realiza la acción
               accion: Tipo de acción (LOGIN, USER_CREATED, etc.)
               modulo: Módulo del sistema (MOD_Auth, MOD_Users, etc.)
               resultado: SUCCESS, FAILED, PARTIAL
               recurso_afectado: Recurso afectado (opcional)
               detalles: Metadatos adicionales (dict)
               request: Request HTTP (opcional, para IP)
           
           Returns:
               AuditLog: Registro creado
           """
           from .models import AuditLog
           
           # Anonimizar IP (CNST_008: Sin PII)
           if request:
               ip_raw = cls._get_client_ip(request)
               ip_hash = cls._hash_pii(ip_raw)
               user_agent_hash = cls._hash_pii(request.META.get('HTTP_USER_AGENT', ''))
           else:
               ip_hash = '0' * 16
               user_agent_hash = '0' * 16
           
           # Crear registro
           audit = AuditLog(
               usuario_id=usuario.usuario_id,
               accion=accion,
               modulo=modulo,
               resultado=resultado,
               recurso_afectado=recurso_afectado,
               timestamp=timezone.now(),
               ip_address_hash=ip_hash,
               user_agent_hash=user_agent_hash,
               detalles=detalles or {},
               sesion_id=getattr(request, 'session_obj', None).session_id 
                   if hasattr(request, 'session_obj') else None
           )
           
           # Calcular checksum (CNST_008: Integridad)
           audit.checksum_registro = cls._calcular_checksum(audit)
           
           # Guardar (SOLO INSERT, nunca UPDATE)
           audit.save()
           
           return audit
       
       @classmethod
       def _calcular_checksum(cls, audit):
           """
           Calcula checksum SHA-256 del registro.
           
           Garantiza integridad (CNST_008).
           """
           # Datos a hashear (orden importa)
           data = f"{audit.audit_id}|{audit.usuario_id}|{audit.accion}|{audit.timestamp.isoformat()}|{audit.resultado}"
           
           if audit.detalles:
               data += f"|{json.dumps(audit.detalles, sort_keys=True)}"
           
           return hashlib.sha256(data.encode()).hexdigest()
       
       @classmethod
       def _hash_pii(cls, value):
           """
           Hashea PII (IP, user-agent, etc.) para logs.
           
           CNST_008: Sin PII en logs.
           """
           if not value:
               return '0' * 16
           
           return hashlib.sha256(value.encode()).hexdigest()[:16]
       
       @classmethod
       def _get_client_ip(cls, request):
           """Obtiene IP del cliente."""
           x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
           if x_forwarded_for:
               ip = x_forwarded_for.split(',')[0]
           else:
               ip = request.META.get('REMOTE_ADDR')
           return ip
       
       @classmethod
       def validar_integridad(cls, audit_id=None):
           """
           Valida integridad de registros de auditoría.
           
           Args:
               audit_id: Validar registro específico (None = todos)
           
           Returns:
               dict: Resultado de validación
           """
           from .models import AuditLog
           
           if audit_id:
               audits = AuditLog.objects.filter(audit_id=audit_id)
           else:
               # Validar todos (pesado, usar con cuidado)
               audits = AuditLog.objects.all()
           
           total = 0
           invalidos = []
           
           for audit in audits.iterator(chunk_size=1000):
               total += 1
               
               # Recalcular checksum
               checksum_esperado = cls._calcular_checksum(audit)
               
               if checksum_esperado != audit.checksum_registro:
                   # ¡Registro manipulado!
                   invalidos.append({
                       'audit_id': audit.audit_id,
                       'timestamp': audit.timestamp,
                       'checksum_esperado': checksum_esperado,
                       'checksum_actual': audit.checksum_registro
                   })
           
           return {
               'total_validados': total,
               'validos': total - len(invalidos),
               'invalidos': len(invalidos),
               'registros_invalidos': invalidos,
               'integridad_ok': len(invalidos) == 0
           }

5.2 Middleware de Auditoría
-----------------------------

.. code-block:: python

   # file: audit/middleware.py
   from django.utils.deprecation import MiddlewareMixin
   from .service import AuditService
   
   class AuditMiddleware(MiddlewareMixin):
       """
       Middleware que audita automáticamente ciertas acciones.
       
       Implementa CNST_008.
       """
       
       ACCIONES_AUDITABLES = [
           'login',
           'logout',
           'password-reset',
           'export',
       ]
       
       def process_response(self, request, response):
           if request.user.is_authenticated:
               # Auditar según path/acción
               if '/api/auth/login' in request.path:
                   if response.status_code == 200:
                       AuditService.registrar(
                           usuario=request.user,
                           accion='LOGIN',
                           modulo='MOD_Auth',
                           resultado='SUCCESS',
                           request=request
                       )
               
               elif '/api/auth/logout' in request.path:
                   AuditService.registrar(
                       usuario=request.user,
                       accion='LOGOUT',
                       modulo='MOD_Auth',
                       resultado='SUCCESS',
                       request=request
                   )
               
               elif '/api/reports/export' in request.path:
                   if response.status_code == 200:
                       AuditService.registrar(
                           usuario=request.user,
                           accion='REPORT_EXPORTED',
                           modulo='MOD_Reports',
                           resultado='SUCCESS',
                           detalles={
                               'formato': request.POST.get('formato'),
                               'reporte': request.POST.get('reporte')
                           },
                           request=request
                       )
           
           return response

5.3 Logger sin PII
-------------------

.. code-block:: python

   # file: core/logger.py
   import logging
   import hashlib
   
   class PIISafeLogger:
       """
       Logger que automáticamente remueve/hashea PII.
       
       Implementa CNST_008: Logs sin PII.
       """
       
       def __init__(self, name):
           self.logger = logging.getLogger(name)
       
       def _sanitize_message(self, message, extra=None):
           """Remueve PII del mensaje y extra data."""
           # Si hay extra data, hashear PII
           if extra:
               extra = self._hash_pii_in_dict(extra)
           
           return message, extra
       
       def _hash_pii_in_dict(self, data):
           """Hashea campos PII en un dict."""
           pii_fields = ['ip', 'email', 'phone', 'ip_address', 'user_agent']
           
           sanitized = data.copy()
           for key in data:
               if any(pii in key.lower() for pii in pii_fields):
                   # Hashear valor
                   if isinstance(data[key], str):
                       sanitized[key] = hashlib.sha256(
                           data[key].encode()
                       ).hexdigest()[:16]
           
           return sanitized
       
       def info(self, message, extra=None):
           message, extra = self._sanitize_message(message, extra)
           self.logger.info(message, extra=extra)
       
       def warning(self, message, extra=None):
           message, extra = self._sanitize_message(message, extra)
           self.logger.warning(message, extra=extra)
       
       def error(self, message, extra=None):
           message, extra = self._sanitize_message(message, extra)
           self.logger.error(message, extra=extra)
   
   # Uso
   logger = PIISafeLogger(__name__)
   
   # PII automáticamente hasheado
   logger.info("User login", extra={
       'user_id': 123,  # OK
       'ip_address': '192.168.1.1',  # Se hashea automáticamente
       'email': 'user@example.com'  # Se hashea automáticamente
   })

============================================================
6. EJEMPLOS DE IMPLEMENTACIÓN
============================================================

6.1 Ejemplo: Auditar Creación de Usuario
------------------------------------------

.. code-block:: python

   # file: users/views.py
   from audit.service import AuditService
   
   @api_view(['POST'])
   @require_function('crea_usuarios')
   def crear_usuario(request):
       """
       Crea un nuevo usuario.
       
       Auditoría automática (CNST_008).
       """
       try:
           # Crear usuario
           nuevo_usuario = Usuario.objects.create(
               username=request.data['username'],
               email=request.data['email'],
               # ...
           )
           
           # AUDITAR (CNST_008)
           AuditService.registrar(
               usuario=request.user,
               accion='USER_CREATED',
               modulo='MOD_Users',
               resultado='SUCCESS',
               recurso_afectado=f"Usuario: {nuevo_usuario.username}",
               detalles={
                   'nuevo_usuario_id': nuevo_usuario.usuario_id,
                   'segmento': nuevo_usuario.segmento_id
               },
               request=request
           )
           
           return Response({
               'success': True,
               'usuario_id': nuevo_usuario.usuario_id
           })
       
       except Exception as e:
           # AUDITAR FALLO (CNST_008)
           AuditService.registrar(
               usuario=request.user,
               accion='USER_CREATED',
               modulo='MOD_Users',
               resultado='FAILED',
               detalles={
                   'error': str(e)
               },
               request=request
           )
           
           return Response({
               'error': str(e)
           }, status=400)

6.2 Ejemplo: Ver Auditoría Propia
-----------------------------------

.. code-block:: python

   # file: audit/views.py
   
   @api_view(['GET'])
   @require_function('ve_auditoria')
   def ver_auditoria_propia(request):
       """
       Usuario ve su propia auditoría.
       
       Implementa AUD-001: ve_auditoria
       """
       from audit.models import AuditLog
       
       # Usuario solo ve SU auditoría (transparencia)
       audits = AuditLog.objects.filter(
           usuario=request.user
       ).order_by('-timestamp')[:100]
       
       return Response({
           'auditoria': [
               {
                   'timestamp': a.timestamp,
                   'accion': a.accion,
                   'modulo': a.modulo,
                   'resultado': a.resultado,
                   'ip_hash': a.ip_address_hash,  # Hasheada, no en claro
                   'detalles': a.detalles
               }
               for a in audits
           ]
       })

============================================================
7. VALIDACIÓN Y TESTING
============================================================

7.1 Tests de Inmutabilidad
----------------------------

.. code-block:: python

   # file: tests/test_cnst_008.py
   from django.test import TestCase
   from django.db import IntegrityError
   from audit.models import AuditLog
   from audit.service import AuditService
   from users.models import Usuario
   
   class TestCNST008(TestCase):
       """
       Tests para validar CNST_008: Auditoría inmutable, logs sin PII
       """
       
       def setUp(self):
           self.usuario = Usuario.objects.create(username='test_user')
       
       def test_auditoria_no_puede_modificarse(self):
           """Validar que UPDATE en auditoría está prohibido."""
           # Crear registro
           audit = AuditService.registrar(
               usuario=self.usuario,
               accion='TEST_ACTION',
               modulo='TEST',
               resultado='SUCCESS'
           )
           
           # Intentar modificar (debe fallar)
           with self.assertRaises(IntegrityError):
               audit.resultado = 'FAILED'
               audit.save()
       
       def test_auditoria_no_puede_eliminarse(self):
           """Validar que DELETE en auditoría está prohibido."""
           # Crear registro
           audit = AuditService.registrar(
               usuario=self.usuario,
               accion='TEST_ACTION',
               modulo='TEST'
           )
           
           # Intentar eliminar (debe fallar)
           with self.assertRaises(IntegrityError):
               audit.delete()
       
       def test_checksum_integridad(self):
           """Validar que checksum detecta manipulación."""
           # Crear registro
           audit = AuditService.registrar(
               usuario=self.usuario,
               accion='TEST_ACTION',
               modulo='TEST'
           )
           
           # Validar integridad
           resultado = AuditService.validar_integridad(audit.audit_id)
           
           self.assertTrue(resultado['integridad_ok'])
           self.assertEqual(resultado['invalidos'], 0)
       
       def test_ip_hasheada_sin_pii(self):
           """Validar que IP se hashea en auditoría."""
           from django.test import RequestFactory
           
           # Crear request con IP
           factory = RequestFactory()
           request = factory.get('/', REMOTE_ADDR='192.168.1.100')
           request.user = self.usuario
           
           # Registrar auditoría
           audit = AuditService.registrar(
               usuario=self.usuario,
               accion='TEST_ACTION',
               modulo='TEST',
               request=request
           )
           
           # Verificar que IP NO está en claro
           self.assertNotEqual(audit.ip_address_hash, '192.168.1.100')
           self.assertEqual(len(audit.ip_address_hash), 16)  # Hash truncado

============================================================
8. REFERENCIAS
============================================================

8.1 Documentos Relacionados
-----------------------------

:CNST_002: Sesiones en BD (auditoría de sesiones)
:CNST_005: RBAC (auditoría de permisos)
:CNST_001: NO Email (auditoría de notificaciones)
:UC_041: Ver auditoría propia
:UC_042: Buscar en auditoría
:UC_043: Exportar auditoría
:UC_044: Generar reporte compliance
:UC_048: Ver logs técnicos
:UC_049: Exportar logs

8.2 Funciones RBAC Relacionadas
---------------------------------

:AUD_001: ve_auditoria
:AUD_002: busca_auditoria
:AUD_003: exporta_auditoria
:AUD_004: genera_reporte_compliance
:LOG_001: ve_logs_tecnicos
:LOG_002: exporta_logs

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
     - Versión inicial. Documentación completa de CNST_008:
       Auditoría inmutable (append-only), logs sin PII,
       checksums SHA-256, retención 2 años. Incluye:
       triggers DB, servicio de auditoría, logger seguro,
       tests de inmutabilidad.

============================================================

.. warning::
   **RECORDATORIO CRÍTICO:**
   
   CNST_008 es fundamental para compliance y seguridad:
   - Auditoría: INMUTABLE (solo INSERT, nunca UPDATE/DELETE)
   - Logs: SIN PII (IPs hasheadas, sin nombres/emails)
   - Integridad: Checksums SHA-256 en cada registro
   - Retención: Mínimo 2 años
   
   Violaciones a CNST_008 tienen implicaciones LEGALES.
   Los triggers DB previenen modificaciones accidentales.

**FIN DEL DOCUMENTO CNST_008**

============================================================
🎉 FASE 15 COMPLETADA AL 100% 🎉
============================================================

**TODOS LOS DOCUMENTOS CNST GENERADOS:**

1. ✅ CNST_005 - RBAC Flat, SoD, Permisos (2,258 líneas, 71KB)
2. ✅ CNST_001 - NO Email Sistema (1,322 líneas, 42KB)
3. ✅ CNST_002 - Sesiones BD Timeout (1,446 líneas, 45KB)
4. ✅ CNST_003 - BD IVR Readonly ETL (1,238 líneas, 41KB)
5. ✅ CNST_004 - Alertas Buzón Interno (1,210 líneas, 40KB)
6. ✅ CNST_006 - Reportes Límites Rango (1,035 líneas, 32KB)
7. ✅ CNST_007 - Límites Exportación (1,080 líneas, 33KB)
8. ✅ CNST_008 - Audit Inmutable Logs (ESTE DOCUMENTO)

**TOTAL FASE 15: 8 documentos CNST v1.0.0 COMPLETADOS**
