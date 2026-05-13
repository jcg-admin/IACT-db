---
title: Scripts IACT - Quickstart
date: 2025-11-13
domain: general
status: active
---

# Scripts IACT - Quickstart

Comandos mas usados del proyecto IACT.

## Setup Inicial

```bash
# Clonar proyecto
git clone https://github.com/2-Coatl/IACT---project.git
cd IACT---project

# Instalar dependencias backend
cd api && pip install -r requirements.txt

# Instalar dependencias frontend
cd ../frontend && npm install

# Configurar .env
cp .env.example .env
# Editar .env con tus valores

# Instalar git hooks
./scripts/install_hooks.sh
```

## Desarrollo Diario

### Ejecutar Tests

```bash
# Backend tests
./scripts/ci/backend_test.sh mysql

# Frontend tests
./scripts/ci/frontend_test.sh

# Todos los tests
./scripts/run_all_tests.sh

# Validar test pyramid
./scripts/ci/test_pyramid_check.sh
```

### Validaciones

```bash
# Validar restricciones criticas (RNF-002)
./scripts/validate_critical_restrictions.sh

# Validar seguridad
./scripts/validate_security_config.sh

# Validar estructura de docs
./scripts/validar_estructura_docs.sh

# Validar que no hay emojis
python scripts/check_no_emojis.py
```

## SDLC Agents

### Planning

```bash
# Generar issue desde feature request
python scripts/sdlc_agent.py \
  --phase planning \
  --input "Feature: Sistema de notificaciones push"

# Output: docs/sdlc_outputs/planning/issue-XXX.md
```

### Design

```bash
# Generar HLD, LLD, ADRs
python scripts/sdlc_agent.py \
  --phase design \
  --input "Feature: API de reportes"

# Output: docs/sdlc_outputs/design/
```

### Testing

```bash
# Generar test strategy
python scripts/sdlc_agent.py \
  --phase testing \
  --input "Feature: Payment processing"

# Output: docs/sdlc_outputs/testing/
```

### Pipeline Completo

```bash
# Ejecutar todas las fases
python scripts/sdlc_agent.py \
  --pipeline \
  --input "Feature: Dashboard de metricas"

# Con auto-proceed (sin pausas)
python scripts/sdlc_agent.py \
  --pipeline \
  --input "Feature: ..." \
  --auto-proceed
```

## DORA Metrics

```bash
# Ver metricas ultimos 30 dias
python scripts/dora_metrics.py --repo 2-Coatl/IACT---project

# Periodo especifico
python scripts/dora_metrics.py \
  --start 2025-01-01 \
  --end 2025-01-31

# JSON output
python scripts/dora_metrics.py \
  --repo 2-Coatl/IACT---project \
  --format json

# Metricas de documentacion
python scripts/dora_metrics.py --docs-only
```

## Documentacion

### Generar Guias

```bash
# Generar guias P0
python scripts/generate_guides.py --priority P0

# Dry-run (no guarda archivos)
python scripts/generate_guides.py --priority P0 --dry-run
```

### Requisitos

```bash
# Validar frontmatter
python scripts/requisitos/validar_frontmatter.py

# Generar indices
python scripts/requisitos/generar_indices.py

# Contar requisitos
./scripts/requisitos/contar_requisitos.sh

# Listar todos
./scripts/requisitos/listar_requisitos.sh
```

## Deployment

### Deploy

```bash
# Deploy a staging
./scripts/deploy.sh staging

# Deploy a production (requiere aprobacion)
./scripts/deploy.sh production

# Health check
./scripts/health_check.sh staging
```

### Rollback

```bash
# Rollback a version anterior
./scripts/deploy/rollback.sh <backup_file>
```

## Backup y Recovery

### Backup

```bash
# Backup MySQL
./scripts/disaster_recovery/backup_mysql.sh

# Backup Cassandra
./scripts/disaster_recovery/backup_cassandra.sh
```

### Restore

```bash
# Restore MySQL
./scripts/disaster_recovery/restore_mysql.sh <backup_file>

# Test DR procedures
./scripts/disaster_recovery/test_dr.sh
```

## Utilidades

### Limpieza

```bash
# Limpiar sesiones antiguas
./scripts/cleanup_sessions.sh

# Limpiar branches mergeadas
./scripts/cleanup_branches.sh

# Limpiar emojis
./scripts/clean_emojis.sh
```

### Sincronizacion

```bash
# Sincronizar documentacion
python scripts/sync_documentation.py

# Sync completo
./scripts/complete_sync.sh
```

## Troubleshooting

### Script no ejecuta

```bash
# Dar permisos
chmod +x scripts/mi_script.sh
```

### Python module not found

```bash
# Agregar al PYTHONPATH
export PYTHONPATH=$PYTHONPATH:$(pwd)

# O ejecutar desde raiz
cd /home/user/IACT---project
python scripts/sdlc_agent.py ...
```

### GITHUB_TOKEN no configurado

```bash
# Crear token en GitHub
# Settings -> Developer settings -> Personal access tokens

# Exportar
export GITHUB_TOKEN="ghp_..."

# O agregar a .env
echo "GITHUB_TOKEN=ghp_..." >> .env
```

## Casos de Uso Comunes

### Nuevo Feature

```bash
# 1. Planning
python scripts/sdlc_agent.py --phase planning --input "Feature: X"

# 2. Feasibility
python scripts/sdlc_agent.py --phase feasibility --input "Feature: X"

# 3. Design
python scripts/sdlc_agent.py --phase design --input "Feature: X"

# 4. Implementacion (manual)
# Codificar segun diseño

# 5. Testing
./scripts/ci/backend_test.sh all
./scripts/ci/test_pyramid_check.sh

# 6. Validaciones
./scripts/validate_critical_restrictions.sh

# 7. Deploy
./scripts/deploy.sh staging
```

### PR Checklist

```bash
# Antes de crear PR
./scripts/ci/backend_test.sh all
./scripts/ci/frontend_test.sh
./scripts/ci/test_pyramid_check.sh
./scripts/validate_critical_restrictions.sh
python scripts/check_no_emojis.py

# Si todo pasa, crear PR
gh pr create --title "..." --body "..."
```

### Weekly Review

```bash
# Metricas DORA
python scripts/dora_metrics.py --format markdown > reports/weekly_$(date +%Y%m%d).md

# Contar requisitos
./scripts/requisitos/contar_requisitos.sh

# Validar documentacion
./scripts/validar_estructura_docs.sh
```

## Variables de Entorno

```bash
# GitHub
export GITHUB_TOKEN="ghp_..."

# Database
export DB_USER="user"
export DB_PASSWORD="pass"
export DB_HOST="localhost"
export DB_PORT="3306"

# Deployment
export DEPLOY_ENV="staging"
```

## Recursos

- [README completo](./README.md)
- [Guia SDLC Agent](./sdlc-agent-guide.md)
- [Referencia Agentes](./sdlc-agents-reference.md)
- [Matriz de Scripts](./SCRIPTS_MATRIX.md)

---

**Tip:** Guarda este documento en tus favoritos para referencia rapida.
