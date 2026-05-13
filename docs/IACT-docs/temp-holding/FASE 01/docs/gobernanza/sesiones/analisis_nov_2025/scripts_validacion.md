---
title: Scripts de Validación - Proyecto IACT
date: 2025-11-13
domain: general
status: active
---

# Scripts de Validación - Proyecto IACT

Este directorio contiene scripts shell para validar el cumplimiento de las restricciones del proyecto y la configuración de seguridad.

## Scripts Disponibles

### 1. `validate_critical_restrictions.sh`
**Propósito**: Valida que se cumplan las restricciones críticas del proyecto

**Qué verifica**:
- NO uso de email (send_mail, smtp)
- NO Sentry
- NO Redis/Memcached para sesiones
- NO código peligroso (eval, exec, pickle.load)
- NO WebSockets/SSE (real-time updates)
- Database Router existe y protege BD IVR
- SESSION_ENGINE configurado para DB
- Modelo InternalMessage existe

**Uso**:
```bash
./scripts/validate_critical_restrictions.sh
```

**Cuándo ejecutar**:
- Antes de cada commit (pre-commit hook)
- En CI/CD pipeline
- Antes de deploy a producción

---

### 2. `validate_security_config.sh`
**Propósito**: Valida la configuración de seguridad del proyecto Django/DRF

**Qué verifica**:
- Django check --deploy
- Bandit (SAST - Static Application Security Testing)
- Safety check (CVE scan en dependencias)
- Ruff linting
- Configuraciones de seguridad en settings:
  - DEBUG = False en producción
  - HSTS configurado
  - Cookies seguras (SESSION_COOKIE_SECURE, CSRF_COOKIE_SECURE)
- Configuración JWT:
  - Access token 15 minutos
  - Refresh token 7 días
  - Rotación y blacklist activos
- Throttling configurado

**Uso**:
```bash
./scripts/validate_security_config.sh
```

**Requisitos previos**:
```bash
pip install bandit safety ruff
```

**Cuándo ejecutar**:
- Antes de cada release
- En CI/CD pipeline
- Auditorías de seguridad trimestrales

**Reportes generados**:
- `reports/bandit-report.json`
- `reports/safety-report.json`
- `reports/ruff-report.json`

---

### 3. `validate_database_router.sh`
**Propósito**: Valida que el Database Router proteja correctamente la BD IVR

**Qué verifica**:
- IVRReadOnlyRouter existe
- Router configurado en DATABASE_ROUTERS
- Tests unitarios:
  - Lectura de IVR enrutada a `ivr_readonly`
  - Escritura a IVR BLOQUEADA (ValueError)
  - Migraciones en IVR BLOQUEADAS
  - Modelos normales enrutados a `default`

**Uso**:
```bash
./scripts/validate_database_router.sh
```

**Cuándo ejecutar**:
- Después de cambios en database_router.py
- Antes de deploy a producción
- Tests de integración

---

## Uso en CI/CD

### GitHub Actions / GitLab CI

```yaml
# .github/workflows/validate-restrictions.yml
name: Validate Restrictions

on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.12'

      - name: Install dependencies
        run: |
          pip install -r api/callcentersite/requirements/base.txt
          pip install bandit safety ruff

      - name: Validate Critical Restrictions
        run: ./scripts/validate_critical_restrictions.sh

      - name: Validate Security Config
        run: ./scripts/validate_security_config.sh

      - name: Validate Database Router
        run: ./scripts/validate_database_router.sh

      - name: Upload Reports
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: security-reports
          path: reports/
```

---

## Pre-commit Hook

Para ejecutar validaciones automáticamente antes de cada commit:

### Opción 1: Pre-commit Hook Manual

```bash
# Crear .git/hooks/pre-commit
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash

echo "Ejecutando validaciones pre-commit..."

# Validar restricciones críticas
./scripts/validate_critical_restrictions.sh
if [ $? -ne 0 ]; then
    echo ""
    echo "[FAIL] Pre-commit hook falló: Restricciones críticas no cumplidas"
    echo "   Corrige los errores antes de hacer commit"
    exit 1
fi

echo "[OK] Pre-commit validations passed"
exit 0
EOF

chmod +x .git/hooks/pre-commit
```

### Opción 2: Pre-commit Framework

```yaml
# .pre_commit_config.yaml
repos:
  - repo: local
    hooks:
      - id: validate-restrictions
        name: Validate Critical Restrictions
        entry: ./scripts/validate_critical_restrictions.sh
        language: script
        pass_filenames: false
        always_run: true
```

Instalar:
```bash
pip install pre-commit
pre-commit install
```

---

## Interpretación de Resultados

### Exit Codes

- `0`: OK Todas las validaciones pasaron
- `1`: NO Fallos encontrados - BLOQUEA deploy
- Otros: Error en ejecución del script

### Niveles de Severidad

| Nivel | Descripción | Acción |
|-------|-------------|--------|
| OK | Validación pasó | Ninguna |
| WARNING | Problema no crítico | Revisar antes de producción |
| FAIL | Problema crítico | DEBE corregirse |

---

## Troubleshooting

### Error: "python: command not found"

```bash
# Asegúrate de estar en un entorno virtual
cd api/callcentersite
python -m venv .venv
source .venv/bin/activate
pip install -r requirements/base.txt
```

### Error: "bandit/safety/ruff not found"

```bash
pip install bandit safety ruff
```

### Error: "Django settings module not found"

```bash
# Asegúrate de estar en el directorio correcto
cd api/callcentersite
export DJANGO_SETTINGS_MODULE=callcentersite.settings.development
```

### Permisos de ejecución

```bash
chmod +x scripts/*.sh
```

---

## Mantenimiento

### Agregar nueva validación

1. Edita el script apropiado
2. Agrega el nuevo check con numeración
3. Actualiza el contador de fallos si aplica
4. Documenta en este README

### Actualizar restricciones

1. Edita `docs/requisitos/restricciones_completas.md`
2. Actualiza los scripts según nuevas restricciones
3. Actualiza `docs/qa/checklist_auditoria_restricciones.md`
4. Ejecuta todos los scripts para validar

---

## Recursos Relacionados

- [Restricciones Completas](../docs/requisitos/restricciones_completas.md)
- [Checklist de Auditoría](../docs/qa/checklist_auditoria_restricciones.md)
- [Procedimiento QA](../docs/gobernanza/procesos/procedimiento_qa.md)

---

## Checklist Rápido

Antes de deploy a producción, ejecutar en orden:

```bash
# 1. Validar restricciones críticas
./scripts/validate_critical_restrictions.sh

# 2. Validar configuración de seguridad
./scripts/validate_security_config.sh

# 3. Validar database router
./scripts/validate_database_router.sh

# 4. Revisar reportes
ls -lh reports/

# 5. Si todo OK, proceder con deploy
```

---

**Última actualización**: 2025-11-04
**Mantenido por**: Equipo QA
