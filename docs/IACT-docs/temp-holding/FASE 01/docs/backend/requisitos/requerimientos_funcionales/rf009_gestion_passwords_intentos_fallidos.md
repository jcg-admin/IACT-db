---
id: RF-009
tipo: funcional
titulo: Gestión de contraseñas seguras e intentos fallidos
dominio: backend
owner: equipo-backend
prioridad: critica
estado: pendiente
fecha_creacion: 2025-11-04
modulo: authentication
categoria: security

trazabilidad_upward:
 - RN-C01-07 # Complejidad de Contraseñas
 - RN-C01-08 # Intentos Fallidos Limitados
 - RN-C01-09 # Bloqueo Temporal de Cuenta
 - RN-C01-10 # Hash Seguro de Passwords

trazabilidad_downward:
 - TEST-009 # Tests de passwords e intentos fallidos

stakeholders:
 - usuarios-finales
 - administradores-sistema
 - gerentes-seguridad

iso29148_clause: "9.6.4"
verificacion_metodo: test
date: 2025-11-13
---

# RF-009: Gestión de Contraseñas Seguras e Intentos Fallidos

## 1. Descripción del Requisito

### 1.1 Declaración del Requisito (ISO 29148 Format)

**El sistema DEBERÁ** validar que las contraseñas cumplan requisitos de complejidad (8-100 chars, mayúsculas, minúsculas, dígitos, especiales, no reutilizar últimas 5) **almacenando** contraseñas como hash bcrypt con cost factor 12 **limitando** intentos de login a 3 fallidos consecutivos **bloqueando** automáticamente la cuenta por 15 minutos exactos al tercer intento **permitiendo** desbloqueo automático tras el tiempo o desbloqueo manual por administrador (role R016) **notificando** al usuario vía buzón interno sobre bloqueos y desbloqueos.

### 1.2 Descripción Detallada

**Contexto:**
Las contraseñas débiles y los ataques de fuerza bruta son vectores comunes de compromiso de cuentas. El sistema necesita mecanismos robustos para prevenir ambos.

**Necesidad:**
- Contraseñas fuertes que resistan ataques de diccionario
- Hash seguro que resista ataques de rainbow tables
- Prevención de reutilización de contraseñas
- Protección contra ataques de fuerza bruta mediante límite de intentos
- Bloqueo temporal automático de cuentas comprometidas
- Mecanismo de desbloqueo para usuarios legítimos

**Comportamiento esperado:**
1. **Complejidad:** Validar contraseñas nuevas contra reglas de complejidad
2. **Historial:** NO permitir reutilizar últimas 5 contraseñas
3. **Hashing:** Almacenar contraseñas con bcrypt cost factor 12
4. **Intentos fallidos:** Incrementar contador en cada login fallido
5. **Bloqueo:** Bloquear cuenta automáticamente al 3er intento fallido
6. **Desbloqueo automático:** Desbloquear tras 15 minutos exactos
7. **Desbloqueo manual:** Permitir a admins (role R016) desbloquear
8. **Notificaciones:** Informar usuario sobre bloqueos/desbloqueos vía buzón interno

## 2. Criterios de Aceptación

### 2.1 Criterios Funcionales

#### Escenario 1: Validación de complejidad - contraseña válida

```gherkin
Given un usuario creando o cambiando contraseña
When el usuario proporciona contraseña "SecureP@ss123"
Then el sistema valida que tiene:
 | Longitud | 8-100 caracteres | - (13 chars) |
 | Mayúscula | Al menos 1 | - (S, P) |
 | Minúscula | Al menos 1 | - (e,c,u...) |
 | Dígito | Al menos 1 | - (1,2,3) |
 | Especial | Al menos 1 | - (@) |
 | No contiene username | Verificado | - |
 And el sistema acepta la contraseña
 And el sistema hashea con bcrypt cost factor 12
```

#### Escenario 2: Validación de complejidad - contraseña inválida

```gherkin
Given un usuario creando contraseña
When el usuario proporciona contraseña "simple123"
Then el sistema rechaza la contraseña
 And el sistema retorna errores:
 [
 "Debe contener al menos una letra mayúscula",
 "Debe contener al menos un carácter especial"
 ]
 And el sistema NO almacena la contraseña
```

#### Escenario 3: Contraseña contiene username - rechazada

```gherkin
Given un usuario con username="juan.perez"
When el usuario intenta establecer contraseña "JuanPerez123!"
Then el sistema rechaza la contraseña
 And el sistema retorna:
 ["La contraseña no puede contener el username"]
```

#### Escenario 4: Reutilización de contraseña reciente - rechazada

```gherkin
Given un usuario que cambió su contraseña hace 1 mes a "OldP@ss123"
 And esa contraseña está en su historial (últimas 5)
When el usuario intenta establecer nuevamente "OldP@ss123"
Then el sistema rechaza la contraseña
 And el sistema retorna:
 ["No puedes reutilizar ninguna de tus últimas 5 contraseñas"]
 And el sistema NO almacena la contraseña
```

#### Escenario 5: Hash bcrypt con cost factor 12

```gherkin
Given un usuario con contraseña válida "SecureP@ss123"
When el sistema hashea la contraseña
Then el sistema usa algoritmo bcrypt
 And el sistema usa cost factor 12
 And el sistema genera salt automático único
 And el hash resultante tiene formato: "$2b$12$..."
 And el hash es diferente incluso para misma contraseña (salt único)
```

#### Escenario 6: Primer intento fallido - contador incrementa

```gherkin
Given un usuario "alice" con failed_login_attempts=0
 And el usuario NO está bloqueado
When el usuario intenta login con password incorrecta
Then el sistema incrementa failed_login_attempts a 1
 And el sistema actualiza last_failed_login_at=<now>
 And el sistema retorna:
 {
 "error": "Credenciales inválidas",
 "attempts_remaining": 2
 }
 And el sistema NO bloquea la cuenta
```

#### Escenario 7: Tercer intento fallido - bloqueo automático

```gherkin
Given un usuario "bob" con failed_login_attempts=2
 And el usuario NO está bloqueado aún
When el usuario intenta login con password incorrecta (3er intento)
Then el sistema incrementa failed_login_attempts a 3
 And el sistema establece is_locked=True
 And el sistema establece locked_until=<now + 15 minutos>
 And el sistema establece lock_reason='MAX_FAILED_ATTEMPTS'
 And el sistema retorna HTTP 403 Forbidden
 And el sistema retorna:
 {
 "error": "Cuenta bloqueada",
 "locked_until": "2025-11-04T11:15:00Z",
 "minutes_remaining": 15
 }
 And el sistema audita evento USER_LOCKED con:
 | event_type | USER_LOCKED |
 | user_id | <user_id> |
 | details | {"reason": "max_failed_attempts", "attempts": 3} |
 And el sistema envía notificación a buzón interno:
 "Tu cuenta ha sido bloqueada por 15 minutos debido a múltiples intentos
 fallidos de login. Será desbloqueada automáticamente a las 11:15:00."
```

#### Escenario 8: Desbloqueo automático tras 15 minutos

```gherkin
Given un usuario "carol" con is_locked=True
 And el usuario tiene locked_until=<10:00:00>
 And la hora actual es 10:16:00 (16 minutos después)
When el usuario intenta login con credenciales válidas
Then el sistema detecta que locked_until ya pasó
 And el sistema desbloquea automáticamente:
 | is_locked | False |
 | locked_until | NULL |
 | failed_login_attempts | 0 |
 | lock_reason | NULL |
 And el sistema audita evento USER_UNLOCKED con:
 | details | {"reason": "automatic_timeout"} |
 And el sistema permite el login exitoso
 And el sistema retorna tokens JWT normalmente
```

#### Escenario 9: Desbloqueo manual por administrador

```gherkin
Given un administrador "admin" con role R016
 And un usuario "dave" con is_locked=True
 And el usuario aún tiene tiempo restante de bloqueo
When el administrador ejecuta desbloqueo manual de "dave"
Then el sistema verifica que admin tiene role R016
 And el sistema desbloquea la cuenta:
 | is_locked | False |
 | locked_until | NULL |
 | failed_login_attempts | 0 |
 | lock_reason | NULL |
 And el sistema audita evento USER_UNLOCKED con:
 | performed_by | <admin_id> |
 | details | {"reason": "manual_unlock_by_admin"} |
 And el sistema notifica al usuario vía buzón interno:
 "Tu cuenta ha sido desbloqueada por un administrador."
```

#### Escenario 10: Login exitoso resetea contador de intentos

```gherkin
Given un usuario "eve" con failed_login_attempts=2
 And el usuario NO está bloqueado
When el usuario hace login exitoso con credenciales válidas
Then el sistema resetea failed_login_attempts a 0
 And el sistema establece last_failed_login_at=NULL
 And el sistema NO incrementa el contador
 And el usuario puede hacer login normalmente
```

#### Escenario 11: Contador NO se resetea por tiempo

```gherkin
Given un usuario "frank" con failed_login_attempts=2
 And last_failed_login_at=<hace 7 días>
When el sistema verifica el estado de la cuenta
Then el sistema mantiene failed_login_attempts=2
 And el contador NO se resetea automáticamente por tiempo
 And el contador solo se resetea con login exitoso o desbloqueo
```

#### Escenario 12: Historial de contraseñas - mantener últimas 5

```gherkin
Given un usuario que ha cambiado su contraseña 7 veces
When el sistema almacena la 8va contraseña
Then el sistema guarda el hash anterior en password_history
 And el sistema mantiene solo las últimas 5 contraseñas en historial
 And el sistema elimina la contraseña más antigua (1ra de las 7)
 And el total de contraseñas en historial es 5
```

### 2.2 Criterios No Funcionales Asociados

| Aspecto | Criterio | Target | Medición |
|---------|----------|--------|----------|
| **Seguridad** | Algoritmo hash | bcrypt cost 12 | Code review |
| **Seguridad** | Complejidad mínima | 8 caracteres + reglas | Test |
| **Bloqueo** | Duración exacta | 15 minutos | Test |
| **Performance** | Tiempo de hash | < 500 ms | Test |
| **Intentos** | Límite | 3 exactos | Test |

## 3. Especificación Técnica

### 3.1 Componentes Afectados

| Componente | Ubicación | Tipo de Cambio |
|------------|-----------|----------------|
| PasswordValidator | `apps/authentication/validators.py` | nuevo |
| PasswordService | `apps/authentication/services.py` | nuevo |
| handle_failed_login | `apps/authentication/services.py` | nuevo |
| unlock_user_manual | `apps/authentication/services.py` | nuevo |
| User model | `apps/users/models.py` | modificar |
| PasswordHistory model | `apps/users/models.py` | nuevo |
| AuditLog model | `apps/audit/models.py` | existente |
| InternalMessage model | `apps/notifications/models.py` | existente |

### 3.2 Interfaces

#### 3.2.1 Validador de Complejidad

```python
import re
from django.core.exceptions import ValidationError

def validate_password_complexity(password: str, user=None) -> None:
 """
 Validar complejidad de contraseña

 Args:
 password: Contraseña a validar
 user: Usuario (para validar username/nombre)

 Raises:
 ValidationError: Si no cumple complejidad
 """
 errors = []

 # Longitud
 if len(password) < 8:
 errors.append('La contraseña debe tener al menos 8 caracteres')
 if len(password) > 100:
 errors.append('La contraseña no puede tener más de 100 caracteres')

 # Mayúsculas
 if not re.search(r'[A-Z]', password):
 errors.append('Debe contener al menos una letra mayúscula')

 # Minúsculas
 if not re.search(r'[a-z]', password):
 errors.append('Debe contener al menos una letra minúscula')

 # Dígitos
 if not re.search(r'\d', password):
 errors.append('Debe contener al menos un dígito')

 # Caracteres especiales
 if not re.search(r'[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]', password):
 errors.append('Debe contener al menos un carácter especial')

 # Validar contra datos del usuario
 if user:
 password_lower = password.lower()
 if user.username.lower() in password_lower:
 errors.append('La contraseña no puede contener el username')
 if user.first_name and user.first_name.lower() in password_lower:
 errors.append('La contraseña no puede contener tu nombre')
 if user.last_name and user.last_name.lower() in password_lower:
 errors.append('La contraseña no puede contener tu apellido')

 if errors:
 raise ValidationError(errors)
```

#### 3.2.2 Servicio de Hashing

```python
import bcrypt

def hash_password(password: str) -> str:
 """
 Hashear contraseña con bcrypt cost 12

 Args:
 password: Contraseña en texto plano

 Returns:
 str: Hash bcrypt
 """
 password_bytes = password.encode('utf-8')
 salt = bcrypt.gensalt(rounds=12) # Cost factor 12
 hashed = bcrypt.hashpw(password_bytes, salt)
 return hashed.decode('utf-8')

def verify_password(password: str, hashed: str) -> bool:
 """
 Verificar contraseña contra hash

 Args:
 password: Contraseña en texto plano
 hashed: Hash bcrypt

 Returns:
 bool: True si coincide
 """
 password_bytes = password.encode('utf-8')
 hash_bytes = hashed.encode('utf-8')
 return bcrypt.checkpw(password_bytes, hash_bytes)
```

#### 3.2.3 Gestión de Intentos Fallidos

```python
from datetime import timedelta
from django.utils.timezone import now

def handle_failed_login(username: str) -> None:
 """
 Incrementar intentos fallidos y bloquear si es necesario

 Args:
 username: Username que intentó login
 """
 try:
 user = User.objects.get(username=username)
 except User.DoesNotExist:
 # No revelar si usuario existe
 return

 # Incrementar contador (NO se resetea por tiempo)
 user.failed_login_attempts += 1
 user.last_failed_login_at = now()

 # Bloquear al 3er intento
 if user.failed_login_attempts >= 3:
 user.is_locked = True
 user.locked_until = now() + timedelta(minutes=15)
 user.lock_reason = 'MAX_FAILED_ATTEMPTS'

 # Notificar vía buzón interno
 InternalMessage.create(
 user_id=user.id,
 subject='Cuenta bloqueada',
 body=f'Tu cuenta ha sido bloqueada por 15 minutos.\n\n'
 f'Será desbloqueada automáticamente a las '
 f'{user.locked_until.strftime("%H:%M:%S")}.',
 severity='WARNING',
 created_by_system=True
 )

 # Auditar bloqueo
 AuditLog.create(
 event_type='USER_LOCKED',
 user_id=user.id,
 details={
 'reason': 'max_failed_attempts',
 'attempts': 3
 }
 )

 user.save()
```

### 3.3 Reglas de Negocio

| ID | Regla | Descripción |
|----|-------|-------------|
| BR-RN-C01-07-01 | Longitud 8-100 caracteres | Obligatorio |
| BR-RN-C01-07-02 | Al menos 1 mayúscula | Obligatorio |
| BR-RN-C01-07-03 | Al menos 1 minúscula | Obligatorio |
| BR-RN-C01-07-04 | Al menos 1 dígito | Obligatorio |
| BR-RN-C01-07-05 | Al menos 1 carácter especial | Obligatorio |
| BR-RN-C01-07-06 | No contener username | Obligatorio |
| BR-RN-C01-07-07 | No reutilizar últimas 5 | Obligatorio |
| BR-RN-C01-08-01 | Máximo 3 intentos fallidos | Bloqueo automático |
| BR-RN-C01-08-02 | Contador NO resetea por tiempo | Solo con login exitoso |
| BR-RN-C01-09-01 | Bloqueo exacto 15 minutos | No negociable |
| BR-RN-C01-09-02 | Desbloqueo automático | Al pasar locked_until |
| BR-RN-C01-09-03 | Desbloqueo manual | Solo role R016 |
| BR-RN-C01-10-01 | Hash bcrypt obligatorio | Cost factor 12 |
| BR-RN-C01-10-02 | Salt único por password | Automático en bcrypt |

### 3.4 Modelo PasswordHistory

```python
from django.db import models

class PasswordHistory(models.Model):
 user = models.ForeignKey(User, on_delete=models.CASCADE)
 password_hash = models.CharField(max_length=255)
 created_at = models.DateTimeField(auto_now_add=True)

 class Meta:
 db_table = 'password_history'
 ordering = ['-created_at']
 indexes = [
 models.Index(fields=['user', '-created_at']),
 ]
```

### 3.5 Campos Adicionales en User Model

```python
class User(models.Model):
 # ... campos existentes ...

 # Autenticación
 password_hash = models.CharField(max_length=255)
 password_changed_at = models.DateTimeField(null=True)

 # Intentos fallidos y bloqueo
 failed_login_attempts = models.IntegerField(default=0)
 last_failed_login_at = models.DateTimeField(null=True)
 is_locked = models.BooleanField(default=False)
 locked_until = models.DateTimeField(null=True)
 lock_reason = models.CharField(max_length=50, null=True)
```

## 4. Dependencias

### 4.1 Requisitos Prerequisitos

- bcrypt library instalada (`pip install bcrypt`)
- User model debe existir
- AuditLog model debe existir
- InternalMessage model debe existir

### 4.2 Requisitos Relacionados

- **RF-005:** Login (usa validación y gestión de intentos fallidos)
- **RF-001:** Sistema de permisos (role R016 para desbloqueo manual)

### 4.3 Restricciones del Proyecto

Del documento `restricciones_y_lineamientos.md`:

- **RESTR-001:** NO email - notificaciones solo por buzón interno
- **RESTR-008:** Auditoría obligatoria (bloqueos/desbloqueos)

## 5. Casos de Prueba

### 5.1 Tests Unitarios - Complejidad de Contraseñas

- [ ] **TEST-009-001:** test_password_valida_cumple_complejidad
- [ ] **TEST-009-002:** test_password_rechazada_sin_mayuscula
- [ ] **TEST-009-003:** test_password_rechazada_sin_minuscula
- [ ] **TEST-009-004:** test_password_rechazada_sin_digito
- [ ] **TEST-009-005:** test_password_rechazada_sin_caracter_especial
- [ ] **TEST-009-006:** test_password_rechazada_menor_8_caracteres
- [ ] **TEST-009-007:** test_password_rechazada_mayor_100_caracteres
- [ ] **TEST-009-008:** test_password_rechazada_contiene_username
- [ ] **TEST-009-009:** test_password_rechazada_reutiliza_reciente

### 5.2 Tests Unitarios - Hashing

- [ ] **TEST-009-010:** test_hash_bcrypt_cost_factor_12
- [ ] **TEST-009-011:** test_hash_bcrypt_salt_unico
- [ ] **TEST-009-012:** test_verify_password_exitoso
- [ ] **TEST-009-013:** test_verify_password_fallido

### 5.3 Tests Unitarios - Intentos Fallidos

- [ ] **TEST-009-014:** test_primer_intento_fallido_incrementa_contador
- [ ] **TEST-009-015:** test_tercer_intento_fallido_bloquea_cuenta
- [ ] **TEST-009-016:** test_login_exitoso_resetea_contador
- [ ] **TEST-009-017:** test_contador_no_resetea_por_tiempo
- [ ] **TEST-009-018:** test_notificacion_buzon_interno_al_bloquear

### 5.4 Tests Unitarios - Bloqueo y Desbloqueo

- [ ] **TEST-009-019:** test_desbloqueo_automatico_tras_15_minutos
- [ ] **TEST-009-020:** test_desbloqueo_manual_por_admin_con_role_r016
- [ ] **TEST-009-021:** test_desbloqueo_manual_rechazado_sin_role_r016
- [ ] **TEST-009-022:** test_auditoria_user_locked
- [ ] **TEST-009-023:** test_auditoria_user_unlocked

### 5.5 Tests de Integración

- [ ] **TEST-009-INT-001:** test_flujo_completo_3_intentos_bloqueo_desbloqueo
- [ ] **TEST-009-INT-002:** test_cambio_password_valida_complejidad_e_historial

## 6. Definición de Hecho (Definition of Done)

- [ ] Código implementado y revisado
- [ ] 23 tests unitarios implementados y pasando
- [ ] Tests de integración implementados y pasando
- [ ] Coverage >= 95% para PasswordService
- [ ] bcrypt configurado con cost factor 12
- [ ] Validador de complejidad implementado
- [ ] Gestión de intentos fallidos implementada
- [ ] Bloqueo/desbloqueo automático implementado
- [ ] Desbloqueo manual implementado (role R016)
- [ ] Historial de contraseñas implementado
- [ ] Auditoría verificada para bloqueos/desbloqueos
- [ ] Notificaciones por buzón interno verificadas

## 7. Trazabilidad

### 7.1 Trazabilidad Upward (Origen)

Este requisito deriva de las reglas de negocio:
- **RN-C01-07:** Complejidad de Contraseñas
- **RN-C01-08:** Intentos Fallidos Limitados
- **RN-C01-09:** Bloqueo Temporal de Cuenta
- **RN-C01-10:** Hash Seguro de Passwords

### 7.2 Trazabilidad Downward (Derivados)

| Tipo | ID | Título | Ubicación |
|------|----|--------|-----------|
| Test | TEST-009 | Tests de passwords | `tests/authentication/test_passwords.py` |
| Código | IMPL-009 | PasswordService | `apps/authentication/services.py` |

## 8. Referencias

### 8.1 Documentos Relacionados

- Reglas de negocio: `docs/backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md` (líneas 1134-1524)
- Restricciones: `docs/backend/requisitos/restricciones_y_lineamientos.md`

### 8.2 Estándares Aplicados

- **NIST SP 800-63B:** Digital Identity Guidelines - Authentication
- **OWASP ASVS:** Password Security Requirements
- **ISO/IEC/IEEE 29148:2018:** Clause 9.6 - Software Requirements Specification

## Control de Cambios

| Versión | Fecha | Autor | Descripción del Cambio |
|---------|-------|-------|------------------------|
| 1.0 | 2025-11-04 | claude | Documentación inicial basada en RN-C01-07 a RN-C01-10 |
