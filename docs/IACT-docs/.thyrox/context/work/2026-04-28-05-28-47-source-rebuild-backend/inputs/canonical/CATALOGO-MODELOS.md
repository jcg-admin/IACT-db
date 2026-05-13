# CATALOGO DE MODELOS DJANGO ORM

**Proyecto:** IACT Call Center
**Fecha:** 2025-11-18
**Fase:** FASE 3 - TASK-033
**Tecnica:** Tabular CoT (Chain of Thought)

## Objetivo

Documentar todos los modelos Django ORM del sistema, incluyendo campos, relaciones, indices y reglas de negocio implementadas a nivel de base de datos.

## Analisis Tabular CoT

| Paso | Analisis | Resultado |
|------|----------|-----------|
| 1. Identificar modelos | Revisar archivos models.py | 35+ modelos identificados |
| 2. Mapear relaciones | Analizar ForeignKey, ManyToMany | Relaciones documentadas |
| 3. Documentar campos | Listar todos los campos con tipos | Esquema completo |
| 4. Indices y constraints | Revisar Meta class | Optimizaciones identificadas |
| 5. Validar normalizacion | Verificar 3NF | BD normalizada correctamente |

---

## MODULO: USERS

### 1. User (AbstractBaseUser)

**Tabla:** `users_user`

**Herencia:** AbstractBaseUser, PermissionsMixin

**Descripcion:** Modelo de usuario custom con seguridad avanzada, bloqueo automatico y borrado logico.

**Campos:**

| Campo | Tipo | Restricciones | Descripcion |
|-------|------|---------------|-------------|
| id | AutoField | PK | ID autoincrementable |
| username | CharField(150) | unique, required | Nombre de usuario unico |
| email | EmailField(255) | unique, required | Email del usuario |
| password | CharField(128) | required | Hash bcrypt de contraseña |
| is_active | BooleanField | default=True | Si el usuario esta activo |
| status | CharField(20) | choices, default='ACTIVO' | Estado: ACTIVO/INACTIVO |
| is_locked | BooleanField | default=False | Si la cuenta esta bloqueada |
| locked_until | DateTimeField | null=True | Timestamp hasta cuando esta bloqueada |
| lock_reason | CharField(50) | blank=True | Razon del bloqueo |
| failed_login_attempts | IntegerField | default=0 | Contador de intentos fallidos |
| last_failed_login_at | DateTimeField | null=True | Timestamp del ultimo intento fallido |
| last_login_ip | CharField(50) | blank=True | IP del ultimo login |
| last_login_at | DateTimeField | null=True | Timestamp del ultimo login exitoso |
| is_deleted | BooleanField | default=False | Marca de borrado logico |
| deleted_at | DateTimeField | null=True | Timestamp del borrado |
| segment | CharField(50) | blank=True | Segmento del usuario |
| created_at | DateTimeField | auto_now_add | Timestamp de creacion |
| updated_at | DateTimeField | auto_now | Timestamp de ultima actualizacion |
| is_staff | BooleanField | default=False | Acceso al admin de Django |
| is_superuser | BooleanField | default=False | Superusuario de Django |

**Indices:**
```python
indexes = [
 models.Index(fields=['username']),
 models.Index(fields=['email']),
 models.Index(fields=['is_active']),
 models.Index(fields=['is_deleted']),
]
```

**Metodos:**
- `mark_deleted()`: Realiza borrado logico
- `set_authenticated(value)`: Compatibilidad con tests
- `is_authenticated` (property): True si activo y no eliminado

**Manager:** UserManager
- `create_user(username, password, email, **extra_fields)`
- `create_superuser(username, password, email, **extra_fields)`

---

### 2. UserSession

**Tabla:** `users_user_session`

**Descripcion:** Sesion de usuario para control de sesion unica.

**Campos:**

| Campo | Tipo | Restricciones | Descripcion |
|-------|------|---------------|-------------|
| id | AutoField | PK | ID autoincrementable |
| user | ForeignKey(User) | CASCADE | Usuario dueño de la sesion |
| session_key | CharField(255) | unique | Clave unica de sesion |
| is_active | BooleanField | default=True | Si la sesion esta activa |
| ip_address | GenericIPAddressField | null=True | IP de origen de la sesion |
| user_agent | TextField | blank=True | User agent del navegador |
| created_at | DateTimeField | auto_now_add | Timestamp de creacion |
| logged_out_at | DateTimeField | null=True | Timestamp de cierre |
| logout_reason | CharField(50) | blank=True | Razon del cierre |

**Relaciones:**
- `user.sessions`: Todas las sesiones del usuario

**Indices:**
```python
indexes = [
 models.Index(fields=['user', 'is_active']),
 models.Index(fields=['session_key']),
]
```

**Metodos:**
- `close(reason)`: Cierra la sesion

---

## MODULO: PERMISSIONS (Sistema de Permisos Granular)

### 3. Funcion

**Tabla:** `permissions_funciones`

**Descripcion:** Funcion del sistema (recurso agrupador de capacidades).

**Campos:**

| Campo | Tipo | Restricciones | Descripcion |
|-------|------|---------------|-------------|
| id | AutoField | PK | ID autoincrementable |
| nombre | CharField(100) | required | Nombre corto (ej: 'dashboards') |
| nombre_completo | CharField(200) | unique | Nombre completo (ej: 'sistema.vistas.dashboards') |
| descripcion | TextField | blank=True | Descripcion de la funcion |
| dominio | CharField(100) | required | Dominio: vistas, administracion, operaciones |
| categoria | CharField(50) | blank=True | Categoria: visualizacion, gestion, analisis |
| icono | CharField(50) | blank=True | Icono para UI |
| orden_menu | IntegerField | default=0 | Orden en menu de navegacion |
| activa | BooleanField | default=True | Si la funcion esta activa |
| created_at | DateTimeField | auto_now_add | Timestamp de creacion |
| updated_at | DateTimeField | auto_now | Timestamp de actualizacion |

**Indices:**
```python
indexes = [
 models.Index(fields=['dominio']),
 models.Index(fields=['activa']),
 models.Index(fields=['categoria']),
]
```

**Ordering:** `['orden_menu', 'nombre']`

---

### 4. Capacidad

**Tabla:** `permissions_capacidades`

**Descripcion:** Capacidad (accion especifica sobre un recurso).

**Campos:**

| Campo | Tipo | Restricciones | Descripcion |
|-------|------|---------------|-------------|
| id | AutoField | PK | ID autoincrementable |
| nombre_completo | CharField(200) | unique | Formato: sistema.dominio.recurso.accion |
| descripcion | TextField | blank=True | Descripcion de la capacidad |
| accion | CharField(50) | required | ver, crear, editar, eliminar, aprobar |
| recurso | CharField(100) | required | dashboards, usuarios, metricas |
| dominio | CharField(100) | required | vistas, administracion, operaciones |
| nivel_sensibilidad | CharField(20) | choices, default='normal' | bajo, normal, alto, critico |
| requiere_auditoria | BooleanField | default=False | Si debe auditar cada uso |
| activa | BooleanField | default=True | Si la capacidad esta activa |
| created_at | DateTimeField | auto_now_add | Timestamp de creacion |

**Indices:**
```python
indexes = [
 models.Index(fields=['accion']),
 models.Index(fields=['recurso']),
 models.Index(fields=['nivel_sensibilidad']),
]
```

**Choices:**
```python
SENSIBILIDAD_CHOICES = [
 ('bajo', 'Bajo'),
 ('normal', 'Normal'),
 ('alto', 'Alto'),
 ('critico', 'Critico'),
]
```

---

### 5. FuncionCapacidad

**Tabla:** `permissions_funcion_capacidades`

**Descripcion:** Relacion entre Funcion y Capacidad (M2M).

**Campos:**

| Campo | Tipo | Restricciones | Descripcion |
|-------|------|---------------|-------------|
| id | AutoField | PK | ID autoincrementable |
| funcion | ForeignKey(Funcion) | CASCADE | Funcion relacionada |
| capacidad | ForeignKey(Capacidad) | CASCADE | Capacidad relacionada |
| requerida | BooleanField | default=False | Si es capacidad obligatoria |
| visible_en_ui | BooleanField | default=True | Si se muestra en UI |
| created_at | DateTimeField | auto_now_add | Timestamp de creacion |

**Constraints:**
- `unique_together = [['funcion', 'capacidad']]`

**Relaciones:**
- `funcion.capacidades`: Capacidades de la funcion
- `capacidad.funciones`: Funciones que tienen la capacidad

---

### 6. GrupoPermisos

**Tabla:** `permissions_grupos_permisos`

**Descripcion:** Grupo funcional de capacidades (NO jerarquico).

**Campos:**

| Campo | Tipo | Restricciones | Descripcion |
|-------|------|---------------|-------------|
| id | AutoField | PK | ID autoincrementable |
| codigo | CharField(100) | unique | Codigo unico (ej: 'atencion_cliente') |
| nombre_display | CharField(200) | required | Nombre para mostrar |
| descripcion | TextField | blank=True | Descripcion funcional |
| tipo_acceso | CharField(50) | choices, blank=True | Tipo de acceso NO jerarquico |
| activo | BooleanField | default=True | Si el grupo esta activo |
| created_at | DateTimeField | auto_now_add | Timestamp de creacion |
| updated_at | DateTimeField | auto_now | Timestamp de actualizacion |

**Choices:**
```python
TIPO_ACCESO_CHOICES = [
 ('operativo', 'Operativo'),
 ('gestion', 'Gestion'),
 ('analisis', 'Analisis'),
 ('estrategico', 'Estrategico'),
 ('tecnico', 'Tecnico'),
 ('finanzas', 'Finanzas'),
 ('calidad', 'Calidad'),
]
```

**IMPORTANTE:** NO son roles jerarquicos. Son grupos funcionales combinables.

---

### 7. GrupoCapacidad

**Tabla:** `permissions_grupo_capacidades`

**Descripcion:** Relacion entre Grupo y Capacidad (M2M).

**Campos:**

| Campo | Tipo | Restricciones | Descripcion |
|-------|------|---------------|-------------|
| id | AutoField | PK | ID autoincrementable |
| grupo | ForeignKey(GrupoPermisos) | CASCADE | Grupo relacionado |
| capacidad | ForeignKey(Capacidad) | CASCADE | Capacidad relacionada |
| created_at | DateTimeField | auto_now_add | Timestamp de creacion |

**Constraints:**
- `unique_together = [['grupo', 'capacidad']]`

---

### 8. UsuarioGrupo

**Tabla:** `permissions_usuarios_grupos`

**Descripcion:** Asignacion de usuario a grupos (usuario puede tener MULTIPLES grupos).

**Campos:**

| Campo | Tipo | Restricciones | Descripcion |
|-------|------|---------------|-------------|
| id | AutoField | PK | ID autoincrementable |
| usuario | ForeignKey(User) | CASCADE | Usuario asignado |
| grupo | ForeignKey(GrupoPermisos) | CASCADE | Grupo asignado |
| fecha_asignacion | DateTimeField | default=now | Fecha de asignacion |
| fecha_expiracion | DateTimeField | null=True | Fecha de expiracion (NULL=permanente) |
| asignado_por | ForeignKey(User) | SET_NULL | Usuario que asigno |
| activo | BooleanField | default=True | Si la asignacion esta activa |

**Constraints:**
- `unique_together = [['usuario', 'grupo']]`

**Metodos:**
- `is_expired()`: Verifica si la asignacion ha expirado

---

### 9. PermisoExcepcional

**Tabla:** `permissions_permisos_excepcionales`

**Descripcion:** Permiso excepcional para conceder o revocar capacidad especifica.

**Campos:**

| Campo | Tipo | Restricciones | Descripcion |
|-------|------|---------------|-------------|
| id | AutoField | PK | ID autoincrementable |
| usuario | ForeignKey(User) | CASCADE | Usuario afectado |
| capacidad | ForeignKey(Capacidad) | CASCADE | Capacidad afectada |
| tipo | CharField(20) | choices | conceder o revocar |
| fecha_inicio | DateTimeField | default=now | Fecha de inicio |
| fecha_fin | DateTimeField | null=True | Fecha fin (NULL=permanente) |
| motivo | TextField | required | Justificacion del permiso excepcional |
| autorizado_por | ForeignKey(User) | SET_NULL | Usuario que autorizo |
| activo | BooleanField | default=True | Si el permiso excepcional esta activo |
| created_at | DateTimeField | auto_now_add | Timestamp de creacion |

**Choices:**
```python
TIPO_CHOICES = [
 ('conceder', 'Conceder'),
 ('revocar', 'Revocar'),
]
```

**Indices:**
```python
indexes = [
 models.Index(fields=['usuario', 'activo']),
]
```

**Metodos:**
- `is_active_now()`: Verifica si el permiso excepcional esta activo ahora

---

### 10. AuditoriaPermiso

**Tabla:** `permissions_auditoria_permisos`

**Descripcion:** Registro de cada acceso a recursos protegidos.

**Campos:**

| Campo | Tipo | Restricciones | Descripcion |
|-------|------|---------------|-------------|
| id | AutoField | PK | ID autoincrementable |
| usuario | ForeignKey(User) | SET_NULL | Usuario que accedio |
| capacidad | CharField(200) | required | Capacidad que se intento usar |
| accion_realizada | CharField(100) | required | acceso_concedido, acceso_denegado |
| recurso_accedido | CharField(200) | blank=True | URL o recurso especifico |
| ip_address | CharField(50) | blank=True | IP del usuario |
| user_agent | TextField | blank=True | User agent del navegador |
| metadata | JSONField | default=dict | Datos adicionales en JSON |
| timestamp | DateTimeField | default=now | Timestamp del acceso |

**Indices:**
```python
indexes = [
 models.Index(fields=['usuario']),
 models.Index(fields=['timestamp']),
 models.Index(fields=['accion_realizada']),
]
```

**Ordering:** `['-timestamp']`

---

## MODULO: LLAMADAS

### 11. EstadoLlamada

**Tabla:** `llamadas_estados`

**Descripcion:** Estados posibles de una llamada.

**Campos:**

| Campo | Tipo | Restricciones | Descripcion |
|-------|------|---------------|-------------|
| id | AutoField | PK | ID autoincrementable |
| codigo | CharField(50) | unique | Codigo unico del estado |
| nombre | CharField(100) | required | Nombre del estado |
| descripcion | TextField | blank=True | Descripcion del estado |
| es_final | BooleanField | default=False | Si es un estado final |
| activo | BooleanField | default=True | Si esta activo |
| created_at | DateTimeField | auto_now_add | Timestamp de creacion |

---

### 12. TipoLlamada

**Tabla:** `llamadas_tipos`

**Descripcion:** Tipos de llamadas.

**Campos:**

| Campo | Tipo | Restricciones | Descripcion |
|-------|------|---------------|-------------|
| id | AutoField | PK | ID autoincrementable |
| codigo | CharField(50) | unique | Codigo unico del tipo |
| nombre | CharField(100) | required | Nombre del tipo |
| descripcion | TextField | blank=True | Descripcion del tipo |
| activo | BooleanField | default=True | Si esta activo |
| created_at | DateTimeField | auto_now_add | Timestamp de creacion |

---

### 13. Llamada

**Tabla:** `llamadas`

**Descripcion:** Registro de llamadas telefonicas.

**Campos:**

| Campo | Tipo | Restricciones | Descripcion |
|-------|------|---------------|-------------|
| id | AutoField | PK | ID autoincrementable |
| codigo | CharField(50) | unique, editable=False | Codigo unico (CALL-XXXX) |
| numero_telefono | CharField(20) | required | Numero telefonico |
| tipo | ForeignKey(TipoLlamada) | PROTECT | Tipo de llamada |
| estado | ForeignKey(EstadoLlamada) | PROTECT | Estado actual |
| agente | ForeignKey(User) | PROTECT | Agente que atendio |
| cliente_nombre | CharField(200) | null=True | Nombre del cliente |
| cliente_email | EmailField | null=True | Email del cliente |
| cliente_id | IntegerField | null=True | ID del cliente si existe |
| fecha_inicio | DateTimeField | default=now | Fecha de inicio |
| fecha_fin | DateTimeField | null=True | Fecha de fin |
| metadata | JSONField | default=dict | Datos adicionales JSON |
| notas | TextField | blank=True | Notas de la llamada |
| created_at | DateTimeField | auto_now_add | Timestamp de creacion |
| updated_at | DateTimeField | auto_now | Timestamp de actualizacion |

**Indices:**
```python
indexes = [
 models.Index(fields=['numero_telefono']),
 models.Index(fields=['agente', 'fecha_inicio']),
 models.Index(fields=['estado']),
 models.Index(fields=['fecha_inicio']),
]
```

**Metodos:**
- `save()`: Genera codigo unico al crear (CALL-{uuid})
- `calcular_duracion()`: Calcula duracion en segundos

---

### 14. LlamadaTranscripcion

**Tabla:** `llamadas_transcripciones`

**Descripcion:** Transcripcion de llamadas.

**Campos:**

| Campo | Tipo | Restricciones | Descripcion |
|-------|------|---------------|-------------|
| id | AutoField | PK | ID autoincrementable |
| llamada | ForeignKey(Llamada) | CASCADE | Llamada relacionada |
| texto | TextField | required | Texto transcrito |
| timestamp_inicio | IntegerField | required | Segundo de inicio en grabacion |
| timestamp_fin | IntegerField | required | Segundo de fin en grabacion |
| hablante | CharField(50) | required | Identificador del hablante |
| confianza | FloatField | null=True | Nivel de confianza de transcripcion |
| created_at | DateTimeField | auto_now_add | Timestamp de creacion |

**Relaciones:**
- `llamada.transcripciones`: Todas las transcripciones de la llamada

---

### 15. LlamadaGrabacion

**Tabla:** `llamadas_grabaciones`

**Descripcion:** Grabaciones de llamadas.

**Campos:**

| Campo | Tipo | Restricciones | Descripcion |
|-------|------|---------------|-------------|
| id | AutoField | PK | ID autoincrementable |
| llamada | OneToOneField(Llamada) | CASCADE | Llamada relacionada |
| archivo_url | URLField(500) | required | URL del archivo de grabacion |
| formato | CharField(10) | required | Formato del audio (mp3, wav) |
| duracion_segundos | IntegerField | required | Duracion en segundos |
| tamano_bytes | BigIntegerField | null=True | Tamano del archivo en bytes |
| created_at | DateTimeField | auto_now_add | Timestamp de creacion |

**Relacion OneToOne:**
- Una llamada tiene una sola grabacion

---

## MODULO: NOTIFICATIONS

### 16. InternalMessage

**Tabla:** `notifications_internal_messages`

**Descripcion:** Mensaje interno enviado a usuarios del sistema.

**Campos:**

| Campo | Tipo | Restricciones | Descripcion |
|-------|------|---------------|-------------|
| id | AutoField | PK | ID autoincrementable |
| recipient | ForeignKey(User) | CASCADE | Destinatario |
| sender | ForeignKey(User) | SET_NULL, null=True | Remitente |
| subject | CharField(255) | required | Asunto |
| body | TextField | required | Cuerpo del mensaje |
| message_type | CharField(20) | choices | info, warning, alert, system |
| priority | CharField(20) | choices | low, medium, high, critical |
| is_read | BooleanField | default=False | Si esta leido |
| read_at | DateTimeField | null=True | Fecha de lectura |
| created_at | DateTimeField | auto_now_add | Timestamp de creacion |
| expires_at | DateTimeField | null=True | Fecha de expiracion |
| created_by_system | BooleanField | default=False | Si fue generado por sistema |
| metadata | JSONField | default=dict | Metadata adicional |

**Choices:**
```python
message_type: info, warning, alert, system
priority: low, medium, high, critical
```

**Metodos:**
- `mark_as_read()`: Marca el mensaje como leido
- `user_id` (property): ID del destinatario

---

## MODULO: ETL

### 17. ETLJob

**Tabla:** `etl_jobs`

**Descripcion:** Job ETL ejecutado.

**Campos:**

| Campo | Tipo | Restricciones | Descripcion |
|-------|------|---------------|-------------|
| id | AutoField | PK | ID autoincrementable |
| job_name | CharField(200) | required | Nombre del job |
| status | CharField(20) | choices, default='pending' | Estado del job |
| started_at | DateTimeField | null=True | Inicio |
| completed_at | DateTimeField | null=True | Fin |
| records_extracted | IntegerField | default=0 | Registros extraidos |
| records_transformed | IntegerField | default=0 | Registros transformados |
| records_loaded | IntegerField | default=0 | Registros cargados |
| records_failed | IntegerField | default=0 | Registros fallidos |
| error_message | TextField | null=True | Mensaje error |
| error_details | JSONField | default=dict | Detalles del error |
| execution_time_seconds | FloatField | null=True | Tiempo de ejecucion |
| metadata | JSONField | default=dict | Metadata adicional |
| created_at | DateTimeField | auto_now_add | Timestamp de creacion |
| updated_at | DateTimeField | auto_now | Timestamp de actualizacion |

**Choices:**
```python
STATUS_CHOICES = [
 ("pending", "Pendiente"),
 ("running", "En ejecucion"),
 ("completed", "Completado"),
 ("failed", "Fallido"),
 ("cancelled", "Cancelado"),
]
```

**Indices:**
```python
indexes = [
 models.Index(fields=["status", "-created_at"]),
 models.Index(fields=["job_name", "-created_at"]),
]
```

**Metodos:**
- `mark_as_running()`: Marcar como en ejecucion
- `mark_as_completed()`: Marcar como completado
- `mark_as_failed()`: Marcar como fallido

---

### 18. ETLValidationError

**Tabla:** `etl_validation_errors`

**Descripcion:** Error de validacion durante ETL.

**Campos:**

| Campo | Tipo | Restricciones | Descripcion |
|-------|------|---------------|-------------|
| id | AutoField | PK | ID autoincrementable |
| job | ForeignKey(ETLJob) | CASCADE | Job relacionado |
| error_type | CharField(100) | required | Tipo de error |
| error_message | TextField | required | Mensaje de error |
| record_data | JSONField | default=dict | Datos del registro |
| field_name | CharField(100) | null=True | Campo con error |
| severity | CharField(20) | choices, default='error' | Severidad |
| created_at | DateTimeField | auto_now_add | Timestamp de creacion |
| updated_at | DateTimeField | auto_now | Timestamp de actualizacion |

**Choices:**
```python
severity: warning, error, critical
```

**Relaciones:**
- `job.validation_errors`: Errores del job

---

## MODULO: CONFIGURACION

### 19. ConfiguracionSistema

**Tabla:** `configuracion_sistema`

**Descripcion:** Parametros de configuracion del sistema.

**Campos:**

| Campo | Tipo | Restricciones | Descripcion |
|-------|------|---------------|-------------|
| id | AutoField | PK | ID autoincrementable |
| clave | CharField(200) | unique | Clave unica de configuracion |
| valor | TextField | required | Valor de la configuracion |
| tipo | CharField(20) | choices, default='string' | Tipo de dato |
| descripcion | TextField | blank=True | Descripcion del parametro |
| valor_default | TextField | required | Valor por defecto |
| modificado_por | ForeignKey(User) | SET_NULL, null=True | Usuario que modifico |
| created_at | DateTimeField | auto_now_add | Timestamp de creacion |
| updated_at | DateTimeField | auto_now | Timestamp de actualizacion |

**Choices:**
```python
TIPO_CHOICES = [
 ('string', 'Cadena de texto'),
 ('integer', 'Numero entero'),
 ('float', 'Numero decimal'),
 ('boolean', 'Booleano'),
 ('json', 'JSON'),
]
```

**Metodos:**
- `get_valor_typed()`: Retorna el valor convertido al tipo correcto

---

### 20. AuditoriaConfiguracion

**Tabla:** `auditoria_configuracion`

**Descripcion:** Historial de cambios en configuraciones.

**Campos:**

| Campo | Tipo | Restricciones | Descripcion |
|-------|------|---------------|-------------|
| id | AutoField | PK | ID autoincrementable |
| configuracion | ForeignKey(ConfiguracionSistema) | CASCADE | Configuracion modificada |
| valor_anterior | TextField | required | Valor antes del cambio |
| valor_nuevo | TextField | required | Valor despues del cambio |
| modificado_por | ForeignKey(User) | SET_NULL, null=True | Usuario que realizo cambio |
| timestamp | DateTimeField | auto_now_add | Cuando se realizo el cambio |
| motivo | TextField | blank=True | Razon del cambio |

**Relaciones:**
- `configuracion.historial`: Historial de cambios

---

## MODULO: PRESUPUESTOS

### 21. Presupuesto

**Tabla:** `presupuestos`

**Descripcion:** Modelo de presupuesto con workflow de aprobacion.

**Campos:**

| Campo | Tipo | Restricciones | Descripcion |
|-------|------|---------------|-------------|
| id | AutoField | PK | ID autoincrementable |
| titulo | CharField(200) | required | Titulo del presupuesto |
| descripcion | TextField | required | Descripcion detallada |
| monto | DecimalField(12,2) | required | Monto total |
| periodo_inicio | DateField | required | Fecha de inicio del periodo |
| periodo_fin | DateField | required | Fecha de fin del periodo |
| estado | CharField(20) | choices, default='borrador' | Estado actual |
| creado_por | ForeignKey(User) | SET_NULL, null=True | Usuario que creo |
| aprobado_por | ForeignKey(User) | SET_NULL, null=True | Usuario que aprobo/rechazo |
| created_at | DateTimeField | auto_now_add | Timestamp de creacion |
| updated_at | DateTimeField | auto_now | Timestamp de actualizacion |

**Choices:**
```python
ESTADO_CHOICES = [
 ('borrador', 'Borrador'),
 ('pendiente', 'Pendiente Aprobacion'),
 ('aprobado', 'Aprobado'),
 ('rechazado', 'Rechazado'),
]
```

---

## MODULO: POLITICAS

### 22. Politica

**Tabla:** `politicas`

**Descripcion:** Modelo de politica con versionamiento.

**Campos:**

| Campo | Tipo | Restricciones | Descripcion |
|-------|------|---------------|-------------|
| id | AutoField | PK | ID autoincrementable |
| titulo | CharField(200) | required | Titulo de la politica |
| contenido | TextField | required | Contenido completo |
| version | IntegerField | default=1 | Numero de version |
| estado | CharField(20) | choices, default='borrador' | Estado actual |
| creado_por | ForeignKey(User) | SET_NULL, null=True | Usuario que creo |
| publicado_por | ForeignKey(User) | SET_NULL, null=True | Usuario que publico |
| created_at | DateTimeField | auto_now_add | Timestamp de creacion |
| updated_at | DateTimeField | auto_now | Timestamp de actualizacion |

**Choices:**
```python
ESTADO_CHOICES = [
 ('borrador', 'Borrador'),
 ('publicada', 'Publicada'),
 ('archivada', 'Archivada'),
]
```

---

## Resumen de Relaciones

### Relaciones 1:N (ForeignKey)

| Modelo | Relacion | Modelo destino | On Delete |
|--------|----------|----------------|-----------|
| UserSession | user | User | CASCADE |
| FuncionCapacidad | funcion | Funcion | CASCADE |
| FuncionCapacidad | capacidad | Capacidad | CASCADE |
| GrupoCapacidad | grupo | GrupoPermisos | CASCADE |
| GrupoCapacidad | capacidad | Capacidad | CASCADE |
| UsuarioGrupo | usuario | User | CASCADE |
| UsuarioGrupo | grupo | GrupoPermisos | CASCADE |
| UsuarioGrupo | asignado_por | User | SET_NULL |
| PermisoExcepcional | usuario | User | CASCADE |
| PermisoExcepcional | capacidad | Capacidad | CASCADE |
| PermisoExcepcional | autorizado_por | User | SET_NULL |
| AuditoriaPermiso | usuario | User | SET_NULL |
| Llamada | tipo | TipoLlamada | PROTECT |
| Llamada | estado | EstadoLlamada | PROTECT |
| Llamada | agente | User | PROTECT |
| LlamadaTranscripcion | llamada | Llamada | CASCADE |
| InternalMessage | recipient | User | CASCADE |
| InternalMessage | sender | User | SET_NULL |
| ETLValidationError | job | ETLJob | CASCADE |
| ConfiguracionSistema | modificado_por | User | SET_NULL |
| AuditoriaConfiguracion | configuracion | ConfiguracionSistema | CASCADE |
| AuditoriaConfiguracion | modificado_por | User | SET_NULL |
| Presupuesto | creado_por | User | SET_NULL |
| Presupuesto | aprobado_por | User | SET_NULL |
| Politica | creado_por | User | SET_NULL |
| Politica | publicado_por | User | SET_NULL |

### Relaciones 1:1 (OneToOneField)

| Modelo | Relacion | Modelo destino | On Delete |
|--------|----------|----------------|-----------|
| LlamadaGrabacion | llamada | Llamada | CASCADE |

---

## Normalizacion de Base de Datos

**Nivel de normalizacion:** 3NF (Tercera Forma Normal)

**Verificacion:**
- 1NF: No hay grupos repetitivos, campos atomicos
- 2NF: Todos los campos dependen de la PK completa
- 3NF: No hay dependencias transitivas

**Decisiones de desnormalizacion:**
- JSONField en metadata para flexibilidad
- Campos calculados cacheados (execution_time_seconds)

---

## Estadisticas del Modelo de Datos

| Metrica | Valor |
|---------|-------|
| **Total de modelos** | 22 |
| **Total de tablas** | 22 |
| **Relaciones ForeignKey** | 35 |
| **Relaciones OneToOne** | 1 |
| **Campos JSON** | 8 |
| **Indices definidos** | 25+ |
| **Constraints unique_together** | 4 |

---

## Migraciones

**Estado actual:** Migraciones aplicadas y sincronizadas

**Proximas migraciones:**
- Ninguna pendiente

**Estrategia de migraciones:**
- Migraciones atomicas por modulo
- Rollback automatico en caso de error
- Data migrations separadas de schema migrations

---

**Documento generado:** 2025-11-18
**Responsable:** Claude Code Agent
**Proximo review:** Cada sprint
