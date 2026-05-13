---
title: Script: validate_critical_restrictions.sh
date: 2025-11-13
domain: general
status: active
---

# Script: validate_critical_restrictions.sh

**Ubicacion:** `scripts/validate_critical_restrictions.sh`
**Proposito:** Validar restricciones criticas del proyecto IACT (RNF-002)
**Ownership:** Arquitecto Senior
**Prioridad:** P0 (CRITICO - Bloquea merges)

## Descripcion

Script Bash que valida el cumplimiento de restricciones criticas definidas en RNF-002. Se ejecuta en CI/CD para asegurar que el codigo no use tecnologias prohibidas.

## Restricciones Validadas

### 1. NO Email (RNF-003)

**Prohibido:**
- `send_mail()`
- `EmailMessage`
- `smtp.SMTP`
- `smtplib`

**Alternativa:** `InternalMessage` para notificaciones

### 2. NO Sentry

**Prohibido:**
- `import sentry_sdk`
- `from sentry_sdk`
- `sentry` en requirements

**Alternativa:** Logging local con archivos rotativos

### 3. NO Redis/Memcached para Sesiones (RNF-002)

**Prohibido:**
- `redis` en requirements
- `memcached` en requirements

**Alternativa:** Sesiones en base de datos (MySQL/PostgreSQL)

### 4. NO Codigo Peligroso

**Prohibido:**
- `eval()`
- `exec()`
- `pickle.load()`

**Alternativa:** Parsing seguro (JSON, YAML)

### 5. NO WebSockets/SSE

**Prohibido:**
- `websocket`
- `channels` (Django Channels)
- `text/event-stream`
- `EventSource`

**Alternativa:** ETL programado cada 6-12 horas

### 6. Database Router (REQUERIDO)

**Validacion:** Verifica que `database_router.py` exista y proteja BD IVR

**Ubicacion esperada:** `api/callcentersite/callcentersite/database_router.py`

### 7. Session Engine (REQUERIDO)

**Validacion:** Verifica que `SESSION_ENGINE` use base de datos

**Config esperada:**
```python
SESSION_ENGINE = 'django.contrib.sessions.backends.db'
```

### 8. InternalMessage Model (REQUERIDO)

**Validacion:** Verifica que modelo `InternalMessage` exista

**Ubicacion esperada:** `api/callcentersite/callcentersite/apps/notifications/models.py`

## Uso

### Sintaxis Basica

```bash
# Ejecutar desde raiz del proyecto:
./scripts/validate_critical_restrictions.sh

# O con path absoluto:
bash /path/to/scripts/validate_critical_restrictions.sh
```

## Exit Codes

| Codigo | Significado |
|--------|-------------|
| 0 | Todas las restricciones pasan (SUCCESS) |
| 1 | Una o mas restricciones fallan (FAIL) |

## Output

### Cuando TODAS las restricciones pasan:

```
[INFO] Validando restricciones criticas del proyecto IACT...
[INFO] Directorio del proyecto: /home/user/IACT---project

[1] Verificando NO uso de email...
[OK] Sin uso de email

[2] Verificando NO Sentry...
[OK] Sin Sentry

[3] Verificando NO Redis/Memcached...
[OK] Sin Redis/Memcached

[4] Verificando NO codigo peligroso (eval/exec/pickle)...
[OK] Sin codigo peligroso

[5] Verificando NO WebSockets/SSE (real-time updates)...
[OK] Sin WebSockets/SSE

[6] Verificando Database Router...
[OK] Database router existe y protege BD IVR

[7] Verificando configuracion de sesiones...
[OK] SESSION_ENGINE configurado para usar DB

[8] Verificando modelo InternalMessage...
[OK] Modelo InternalMessage existe

=========================================================================
[OK] TODAS LAS RESTRICCIONES CRITICAS PASARON
=========================================================================
```

### Cuando HAY FALLOS:

```
[INFO] Validando restricciones criticas del proyecto IACT...

[1] Verificando NO uso de email...
api/apps/notifications/email_sender.py:15:from django.core.mail import send_mail
[FAIL] FALLO: Se encontro uso de email en el codigo
       Restriccion: NO se permite envio de correos electronicos
       Usar: InternalMessage para notificaciones

[3] Verificando NO Redis/Memcached...
api/callcentersite/requirements/base.txt:redis==4.5.0
[FAIL] FALLO: Redis/Memcached encontrado en requirements
       Restriccion: NO se permite Redis/Memcached para sesiones
       Usar: Sesiones en base de datos

=========================================================================
[FAIL] FALLOS ENCONTRADOS: 2
=========================================================================

ACCIONES REQUERIDAS:
   1. Revisar los fallos reportados arriba
   2. Corregir el codigo segun las restricciones
   3. Volver a ejecutar este script
   4. Consultar: docs/requisitos/restricciones_completas.md
```

## Integracion en CI/CD

### GitHub Actions

El script se ejecuta automaticamente en `backend-ci.yml`:

```yaml
name: Backend CI

on:
  push:
    branches: ['**']
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  validate-restrictions:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Validate critical restrictions
        run: |
          chmod +x scripts/validate_critical_restrictions.sh
          ./scripts/validate_critical_restrictions.sh
```

**Efecto:** Si el script falla, el PR NO puede ser mergeado.

## Troubleshooting

### Fallo 1: Se encontro uso de email

**Error:**
```
[FAIL] FALLO: Se encontro uso de email en el codigo
```

**Causa:** Codigo usa `send_mail()` o `EmailMessage`

**Solucion:**
```python
# INCORRECTO:
from django.core.mail import send_mail
send_mail('Asunto', 'Mensaje', 'from@example.com', ['to@example.com'])

# CORRECTO:
from apps.notifications.models import InternalMessage

InternalMessage.objects.create(
    usuario=usuario,
    tipo='notificacion',
    titulo='Asunto',
    mensaje='Mensaje',
    prioridad='normal'
)
```

### Fallo 2: Redis en requirements

**Error:**
```
[FAIL] FALLO: Redis/Memcached encontrado en requirements
```

**Causa:** `redis` o `memcached` en `requirements/base.txt`

**Solucion:**
```bash
# Remover de requirements:
# requirements/base.txt:
# redis==4.5.0  # <- REMOVER

# Usar sesiones en DB (ya configurado):
# settings/base.py:
SESSION_ENGINE = 'django.contrib.sessions.backends.db'
```

### Fallo 3: Codigo peligroso (eval/exec)

**Error:**
```
[FAIL] FALLO: Codigo peligroso encontrado:
api/utils/parser.py:42:result = eval(expression)
```

**Causa:** Uso de `eval()`, `exec()` o `pickle.load()`

**Solucion:**
```python
# INCORRECTO:
result = eval(expression)  # PELIGROSO

# CORRECTO:
import json
result = json.loads(expression)  # SEGURO

# O usa ast.literal_eval para expresiones Python:
import ast
result = ast.literal_eval(expression)
```

### Fallo 4: WebSockets detectados

**Error:**
```
[FAIL] FALLO: WebSockets/SSE encontrado
```

**Causa:** Uso de Django Channels, WebSockets o SSE

**Solucion:**
```python
# INCORRECTO:
# Actualizaciones en tiempo real con WebSockets
from channels.generic.websocket import WebsocketConsumer

# CORRECTO:
# ETL programado con Celery Beat (o cron)
from django.core.management.base import BaseCommand

class Command(BaseCommand):
    def handle(self, *args, **options):
        # Ejecutar ETL cada 6-12 horas
        SyncService.sync_data_from_ivr()
```

### Fallo 5: Database router no encontrado

**Error:**
```
[FAIL] FALLO: Database router no encontrado
```

**Causa:** Archivo `database_router.py` no existe

**Solucion:**
```bash
# Crear database router:
# api/callcentersite/callcentersite/database_router.py

class IVRReadOnlyRouter:
    """Router que protege BD IVR (solo lectura)."""

    def db_for_write(self, model, **hints):
        if model._meta.app_label == 'ivr':
            raise ValueError("IVR database is READ-ONLY")
        return 'default'

    # ... resto del router
```

### Fallo 6: SESSION_ENGINE no configurado

**Error:**
```
[WARN] WARNING: SESSION_ENGINE no explicitamente configurado
```

**Causa:** `SESSION_ENGINE` no esta en `settings/base.py`

**Solucion:**
```python
# api/callcentersite/callcentersite/settings/base.py

# Configurar sesiones en base de datos:
SESSION_ENGINE = 'django.contrib.sessions.backends.db'
SESSION_COOKIE_AGE = 1209600  # 2 semanas
SESSION_COOKIE_SECURE = True  # Solo HTTPS
SESSION_COOKIE_HTTPONLY = True  # No accesible desde JS
```

### Fallo 7: InternalMessage no encontrado

**Error:**
```
[FAIL] FALLO: InternalMessage no encontrado en models.py
```

**Causa:** Modelo `InternalMessage` no existe

**Solucion:**
```python
# api/callcentersite/callcentersite/apps/notifications/models.py

from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()

class InternalMessage(models.Model):
    """Modelo para notificaciones internas (sin email)."""

    usuario = models.ForeignKey(User, on_delete=models.CASCADE)
    tipo = models.CharField(max_length=50)
    titulo = models.CharField(max_length=200)
    mensaje = models.TextField()
    prioridad = models.CharField(
        max_length=20,
        choices=[('baja', 'Baja'), ('normal', 'Normal'), ('alta', 'Alta')],
        default='normal'
    )
    leido = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'notifications_internal_message'
        ordering = ['-created_at']
```

## Arquitectura del Script

```bash
# Estructura del script:

1. Setup inicial
   - Set -e (exit on error)
   - Definir directorios del proyecto
   |
   v
2. VALIDACION 1: NO Email
   - grep -r "send_mail|EmailMessage|smtp"
   - Si encuentra: FAIL, incrementar contador
   |
   v
3. VALIDACION 2: NO Sentry
   - grep -ri "sentry" en requirements/
   - Si encuentra: FAIL, incrementar contador
   |
   v
4. VALIDACION 3: NO Redis/Memcached
   - grep -ri "redis|memcached" en requirements/
   - Si encuentra: FAIL, incrementar contador
   |
   v
5. VALIDACION 4: NO Codigo Peligroso
   - grep -rn "eval(|exec(|pickle.load"
   - Si encuentra: FAIL, incrementar contador
   |
   v
6. VALIDACION 5: NO WebSockets/SSE
   - grep -r "websocket|channels|EventSource"
   - Si encuentra: FAIL, incrementar contador
   |
   v
7. VALIDACION 6: Database Router Existe
   - Verificar que archivo database_router.py existe
   - Verificar que contiene "raise ValueError" y "READ-ONLY"
   - Si no existe: FAIL, incrementar contador
   |
   v
8. VALIDACION 7: SESSION_ENGINE Correcto
   - grep "SESSION_ENGINE.*db" en settings/base.py
   - Si no encuentra: WARNING (no FAIL)
   |
   v
9. VALIDACION 8: InternalMessage Existe
   - Verificar que archivo notifications/models.py existe
   - grep "class InternalMessage"
   - Si no encuentra: FAIL, incrementar contador
   |
   v
10. RESUMEN
    - Si FAILED == 0: Exit 0 (SUCCESS)
    - Si FAILED > 0: Exit 1 (FAIL)
```

## Mejores Practicas

1. **Ejecutar antes de push:**
   ```bash
   # Validar localmente antes de push:
   ./scripts/validate_critical_restrictions.sh
   ```

2. **Integrar en pre-push hook:**
   ```bash
   # .git/hooks/pre-push
   #!/bin/bash
   ./scripts/validate_critical_restrictions.sh
   ```

3. **CI/CD como gatekeeper:**
   - CI/CD DEBE ejecutar este script
   - PR NO puede mergearse si falla

4. **Documentar excepciones:**
   - Si necesitas tecnologia prohibida, crear ADR
   - Justificar excepcion con arquitecto senior

## Justificacion: Por que estas restricciones?

### NO Redis (RNF-002):
- **Razon:** Cliente no tiene infraestructura Redis
- **Alternativa:** Sesiones en BD MySQL existente
- **Impacto:** Simplifica ops, usa BD existente

### NO Email (RNF-003):
- **Razon:** Sin servidor SMTP, falla compliance
- **Alternativa:** Notificaciones internas en sistema
- **Impacto:** Notificaciones sin dependencias externas

### NO Sentry:
- **Razon:** Datos sensibles no pueden salir del servidor
- **Alternativa:** Logging local con rotacion
- **Impacto:** Control total sobre logs

### NO Codigo Peligroso:
- **Razon:** Seguridad - evitar code injection
- **Alternativa:** Parsing seguro (JSON, YAML)
- **Impacto:** Mayor seguridad

### NO WebSockets/SSE:
- **Razon:** No soportado en infraestructura cliente
- **Alternativa:** ETL batch programado
- **Impacto:** Simplifica arquitectura

## Referencias

- Codigo fuente: `scripts/validate_critical_restrictions.sh`
- RNF-002: `docs/requisitos/rnf-002-restricciones-criticas.md`
- ADRs relevantes: `docs/adr/`
- Database Router: `api/callcentersite/callcentersite/database_router.py`
- InternalMessage: `api/callcentersite/callcentersite/apps/notifications/models.py`

## Ownership

- **Maintainer:** Arquitecto Senior
- **Reviewers:** Tech Lead, DevOps Lead
- **Approvers:** Arquitecto Senior (para excepciones)

---

**Ultima actualizacion:** 2025-11-07
**Version:** 1.0.0
