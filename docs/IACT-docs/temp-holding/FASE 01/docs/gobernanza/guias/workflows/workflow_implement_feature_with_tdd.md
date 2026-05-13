---
id: GUIA-WORKFLOW-IMPLEMENT-FEATURE-TDD
tipo: guia_operativa
categoria: workflows
audiencia: desarrolladores-backend-fullstack
prioridad: P1
tiempo_lectura: 20 minutos
version: 1.0.0
fecha: 2025-01-15
relacionados: ["DOC-GOB-AGENTES", "tdd-feature-agent", "sdlc-agents-reference"]
---

# Workflow: Implementación de Features con TDD Feature Agent

## Descripción

Guía práctica paso a paso para implementar features usando el TDD Feature Agent, que automatiza el ciclo RED-GREEN-REFACTOR garantizando calidad y compliance.

## Pre-requisitos

### Software Requerido

- [ ] Python 3.11+
- [ ] pytest instalado (`pip install pytest pytest-cov`)
- [ ] ruff instalado (`pip install ruff`)
- [ ] mypy instalado (`pip install mypy`)
- [ ] bandit instalado (`pip install bandit`)

### Conocimientos Requeridos

- [ ] Metodología TDD básica
- [ ] Uso de pytest
- [ ] Git y CLI básico

### Configuración del Proyecto

```bash
# Verificar herramientas instaladas
python --version  # >= 3.11
pytest --version
ruff --version
mypy --version
bandit --version

# Configurar API key (si se usa LLM en futuro)
export ANTHROPIC_API_KEY="sk-..." # Opcional por ahora
```

## Flujo de Trabajo Completo

### Paso 1: Recibir Issue o Feature Request

**Input:** Issue de GitHub/GitLab o feature request de stakeholder

**Ejemplo:**
```
Issue #123: Implementar autenticación de usuarios con 2FA

Descripción:
Los usuarios del sistema deben poder autenticarse usando
email/password y activar 2FA con TOTP para mayor seguridad.

Acceptance Criteria:
- Usuarios pueden registrarse con email y password
- Usuarios pueden iniciar sesión
- Usuarios pueden activar 2FA
- Failed login attempts se registran
```

### Paso 2: Preparar Issue Data JSON

**Acción:** Convertir issue a formato JSON estructurado

```bash
# Crear archivo issue_data.json
cat > issue_data.json << 'EOF'
{
  "issue_title": "Implementar autenticación de usuarios con 2FA",
  "acceptance_criteria": [
    "Usuarios pueden registrarse con email y password",
    "Usuarios pueden iniciar sesión con credenciales",
    "Usuarios pueden activar 2FA con TOTP",
    "Failed login attempts son registrados en audit log",
    "Sesiones expiran después de 30 minutos de inactividad"
  ],
  "technical_requirements": [
    "Usar Django authentication backend",
    "Implementar TOTP con biblioteca pyotp",
    "Agregar audit logging para eventos de auth",
    "Cobertura de tests >= 90%",
    "Sin vulnerabilidades de seguridad",
    "Seguir estándares de código del proyecto"
  ],
  "target_module": "callcentersite.apps.users"
}
EOF
```

**Campos Requeridos:**

| Campo | Descripción | Ejemplo |
|-------|-------------|---------|
| `issue_title` | Título descriptivo del feature | "Implementar autenticación 2FA" |
| `acceptance_criteria` | Lista de criterios medibles | ["Usuarios pueden...", "Sistema valida..."] |
| `technical_requirements` | Requisitos técnicos específicos | ["Usar Django auth", "Coverage >= 90%"] |
| `target_module` | Módulo Python donde implementar | "apps.users" |

### Paso 3: Ejecutar TDD Feature Agent

**Acción:** Ejecutar el agente desde CLI

```bash
# Comando básico
python scripts/sdlc_agent.py \
  --phase implementation \
  --issue-file issue_data.json \
  --verbose

# Con configuración personalizada
python scripts/sdlc_agent.py \
  --phase implementation \
  --issue-file issue_data.json \
  --config custom_config.json \
  --verbose
```

**Opciones del CLI:**

| Opción | Descripción | Obligatorio |
|--------|-------------|-------------|
| `--phase implementation` | Fase SDLC a ejecutar | [OK] Sí |
| `--issue-file <path>` | Path al JSON con issue data | [OK] Sí |
| `--config <path>` | Config personalizada | [NO] No |
| `--verbose` | Mostrar logs detallados | [NO] No (recomendado) |
| `--dry-run` | Ejecutar sin guardar artefactos | [NO] No |
| `--format json` | Output en JSON | [NO] No |

### Paso 4: Monitorear Ejecución

**Durante la ejecución verás:**

```
INFO - Starting TDD implementation: Implementar autenticación de usuarios con 2FA
INFO - === RED PHASE: Writing failing tests ===
INFO - Generating unit tests from acceptance criteria
INFO - Generated 15 test cases
INFO - Running tests... (should fail)
INFO - ✓ RED phase complete: 15/15 tests failed as expected

INFO - === GREEN PHASE: Implementing code ===
INFO - Implementing authentication backend
INFO - Implementing 2FA with TOTP
INFO - Running tests... (should pass)
INFO - ✓ GREEN phase complete: 15/15 tests passed

INFO - === REFACTOR PHASE: Optimizing code ===
INFO - Auto-fixing linting issues with ruff
INFO - Running tests again... (should still pass)
INFO - ✓ REFACTOR phase complete: 15/15 tests still passing

INFO - === Validating TDD Constitution ===
INFO - Checking 8 constitution rules...
INFO - ✓ RED_BEFORE_GREEN: PASS
INFO - ✓ TESTS_MUST_FAIL_FIRST: PASS
INFO - ✓ ALL_TESTS_MUST_PASS: PASS
INFO - ✓ TESTS_STAY_GREEN_AFTER_REFACTOR: PASS
INFO - ✓ MINIMUM_COVERAGE: PASS (92.3%)
INFO - ✓ NO_SECURITY_ISSUES: PASS (0 issues)
INFO - ✓ CODE_QUALITY_PASSING: PASS
INFO - ⚠ DOCUMENTATION_REQUIRED: 1/15 functions missing docstring

INFO - === Generating reports ===
INFO - Compliance Score: 95.5/100
INFO - Status: [OK] COMPLIANT
INFO - Execution log: docs/sdlc_outputs/tdd_logs/tdd_execution_implementar_autenticacion_usuarios_con_2fa_20250115_143025.json
INFO - Dashboard: docs/sdlc_outputs/tdd_logs/dashboard_implementar_autenticacion_usuarios_con_2fa.md
```

### Paso 5: Revisar Outputs Generados

**Archivos creados:**

```
docs/sdlc_outputs/tdd_logs/
├── tdd_execution_<feature>_<timestamp>.json      # Log completo en JSON
├── tdd_execution_<feature>_<timestamp>.md        # Reporte Markdown
└── dashboard_<feature>.md                         # Dashboard visual

<target_module>/
├── tests/
│   ├── test_auth.py                               # Tests unitarios
│   └── test_auth_integration.py                   # Tests integración
└── auth.py                                        # Código implementado
```

**Revisar Dashboard:**

```bash
# Ver dashboard en terminal
cat docs/sdlc_outputs/tdd_logs/dashboard_implementar_autenticacion_usuarios_con_2fa.md

# O abrir en editor
code docs/sdlc_outputs/tdd_logs/dashboard_implementar_autenticacion_usuarios_con_2fa.md
```

**El dashboard muestra:**
- [OK] Badges visuales (compliance, coverage, security, quality)
- [METRICA] Métricas detalladas en tablas
- ⏱️ Timeline de ejecución
- [ATENCION] Violations (si las hay)

### Paso 6: Validar Compliance

**Checklist de validación:**

- [ ] **Status:** [OK] COMPLIANT (no [NO] NOT COMPLIANT)
- [ ] **Score:** >= 90/100
- [ ] **CRITICAL violations:** 0
- [ ] **Test Coverage:** >= 90%
- [ ] **Security Issues:** 0
- [ ] **Linting:** Passed
- [ ] **Type Checking:** Passed

**Si hay violations:**

```bash
# Revisar execution log para detalles
cat docs/sdlc_outputs/tdd_logs/tdd_execution_*.json | jq '.constitution_result.violations'

# Output ejemplo:
[
  {
    "rule_code": "DOCUMENTATION_REQUIRED",
    "severity": "MEDIUM",
    "message": "1/15 funciones públicas sin docstrings",
    "evidence": {
      "missing_functions": ["auth.py::validate_totp"]
    }
  }
]
```

### Paso 7: Corregir Violations (si es necesario)

**Para violations MEDIUM/HIGH:**

```bash
# 1. Identificar archivos con issues
cat docs/sdlc_outputs/tdd_logs/tdd_execution_*.json | jq '.constitution_result.violations[].evidence'

# 2. Corregir manualmente
# Ejemplo: agregar docstring faltante
vim callcentersite/apps/users/auth.py

# 3. Re-ejecutar solo validación
pytest tests/ --cov=apps.users --cov-report=term
ruff check apps/users/
mypy apps/users/
bandit -r apps/users/

# 4. Verificar que ahora pase
```

**Para violations CRITICAL:**

[ATENCION] **El agente ya habría fallado** - necesitas re-ejecutar completo.

### Paso 8: Ejecutar Tests Manualmente

**Validación final antes de commit:**

```bash
# 1. Ejecutar todos los tests
cd /home/user/IACT---project
pytest callcentersite/apps/users/tests/ -v

# 2. Verificar coverage
pytest callcentersite/apps/users/tests/ \
  --cov=callcentersite.apps.users \
  --cov-report=term-missing

# 3. Verificar que coverage >= 90%
# Output esperado:
# callcentersite/apps/users/auth.py    95%
# TOTAL                                 92%

# 4. Verificar seguridad
bandit -r callcentersite/apps/users/

# 5. Verificar calidad
ruff check callcentersite/apps/users/
mypy callcentersite/apps/users/
```

### Paso 9: Commit y Push

**Siguiendo git workflow del proyecto:**

```bash
# 1. Revisar cambios
git status
git diff

# 2. Agregar archivos
git add callcentersite/apps/users/
git add docs/sdlc_outputs/tdd_logs/

# 3. Commit con mensaje descriptivo
git commit -m "feat: implement user authentication with 2FA

Implementa autenticación de usuarios con soporte para 2FA:

Features:
- User registration with email/password
- Login with credentials validation
- 2FA activation with TOTP (pyotp)
- Audit logging for auth events
- Session expiration after 30min inactivity

TDD Compliance:
- Score: 95.5/100
- Coverage: 92.3%
- Security issues: 0
- All tests passing (15/15)

Execution log: docs/sdlc_outputs/tdd_logs/tdd_execution_*.json

Closes #123"

# 4. Push a feature branch
git push origin feature/user-auth-2fa
```

### Paso 10: Crear Pull Request

**En GitHub/GitLab:**

```markdown
## Summary
Implementa sistema de autenticación con 2FA usando TDD Feature Agent.

## TDD Compliance
- [OK] Score: 95.5/100
- [OK] Coverage: 92.3%
- [OK] Security: 0 issues
- [OK] Tests: 15/15 passing

## Dashboard
Ver dashboard completo: `docs/sdlc_outputs/tdd_logs/dashboard_*.md`

## Test Plan
- [x] Unit tests (15 casos)
- [x] Integration tests
- [x] Manual testing en staging
- [ ] QA approval pending

## Checklist
- [x] Tests passing
- [x] Coverage >= 90%
- [x] No security issues
- [x] Code reviewed
- [x] Documentation updated
```

---

## Casos de Uso Comunes

### Caso 1: Feature Simple (1-2 archivos)

**Ejemplo:** Agregar campo a modelo existente

```json
{
  "issue_title": "Agregar campo 'phone_number' a User model",
  "acceptance_criteria": [
    "User model tiene campo phone_number",
    "Phone number es validado (formato internacional)",
    "Migraciones generadas correctamente"
  ],
  "technical_requirements": [
    "Usar phonenumbers library para validación",
    "Campo opcional (null=True, blank=True)",
    "Agregar tests para validación"
  ],
  "target_module": "apps.users.models"
}
```

**Tiempo estimado:** 5-10 minutos

### Caso 2: Feature Complejo (múltiples archivos)

**Ejemplo:** Sistema de notificaciones

```json
{
  "issue_title": "Implementar sistema de notificaciones in-app",
  "acceptance_criteria": [
    "Usuarios reciben notificaciones en tiempo real",
    "Notificaciones se marcan como leídas",
    "Usuarios pueden configurar preferencias",
    "Historial de notificaciones disponible"
  ],
  "technical_requirements": [
    "Usar Django Channels para WebSocket",
    "Redis como message broker",
    "PostgreSQL para persistencia",
    "Coverage >= 90% en toda la feature"
  ],
  "target_module": "apps.notifications"
}
```

**Tiempo estimado:** 30-60 minutos

### Caso 3: Refactoring con TDD

**Ejemplo:** Extraer lógica duplicada

```json
{
  "issue_title": "Refactor: extraer validación de permisos a helper",
  "acceptance_criteria": [
    "Función verificar_permiso_y_auditar() creada",
    "Código duplicado eliminado de 7 servicios",
    "Misma funcionalidad mantenida",
    "Tests existentes siguen pasando"
  ],
  "technical_requirements": [
    "Mantener backward compatibility",
    "No cambiar interfaces públicas",
    "Coverage no debe bajar"
  ],
  "target_module": "apps.users.service_helpers"
}
```

**Tiempo estimado:** 15-20 minutos

---

## Troubleshooting

### Problema 1: Tests no fallan en RED phase

**Síntoma:**
```
ERROR - Constitution violation: TESTS_MUST_FAIL_FIRST
ERROR - 0/15 tests failed in RED phase (expected > 0)
```

**Causa:** Tests demasiado genéricos o código ya existe

**Solución:**
```bash
# 1. Verificar que no existe implementación previa
git status
git diff

# 2. Revisar tests generados
cat <target_module>/tests/test_*.py

# 3. Si tests son genéricos, especificar más en technical_requirements
# Ejemplo:
"technical_requirements": [
  "Tests deben validar casos específicos: email inválido, password débil, TOTP incorrecto",
  "Usar pytest.raises para validar excepciones"
]
```

### Problema 2: Coverage bajo (<90%)

**Síntoma:**
```
WARNING - Constitution violation: MINIMUM_COVERAGE
WARNING - Coverage 78.5% is below threshold 90%
```

**Causa:** Tests no cubren todos los code paths

**Solución:**
```bash
# 1. Ver reporte de coverage detallado
pytest --cov=<target_module> --cov-report=html
open htmlcov/index.html

# 2. Identificar líneas no cubiertas (marcadas en rojo)

# 3. Agregar tests para edge cases:
# - Casos de error
# - Validaciones
# - Ramas condicionales

# 4. Re-ejecutar
pytest --cov=<target_module> --cov-report=term-missing
```

### Problema 3: Security issues detectados

**Síntoma:**
```
ERROR - Constitution violation: NO_SECURITY_ISSUES
ERROR - Found 2 security issues (HIGH severity)
```

**Causa:** Código con vulnerabilidades

**Solución:**
```bash
# 1. Ver detalles de issues
bandit -r <target_module> -f json | jq '.results'

# 2. Corregir según tipo:
# - SQL Injection → Usar ORM, no raw SQL
# - Hardcoded secrets → Usar environment variables
# - Weak crypto → Usar hashlib.sha256, no md5

# 3. Re-validar
bandit -r <target_module>
```

### Problema 4: Linting failures

**Síntoma:**
```
WARNING - Constitution violation: CODE_QUALITY_PASSING
WARNING - 15 linting issues found
```

**Causa:** Código no sigue estándares

**Solución:**
```bash
# 1. Auto-fix lo posible
ruff check --fix <target_module>

# 2. Ver issues restantes
ruff check <target_module>

# 3. Corregir manualmente issues que no se auto-fixean
# Ejemplo: unused imports, line too long, etc.

# 4. Re-validar
ruff check <target_module>
```

---

## Mejores Prácticas

### [OK] DO

1. **Preparar issue data completo**
   - Acceptance criteria específicos y medibles
   - Technical requirements detallados
   - Target module correcto

2. **Ejecutar con --verbose**
   - Facilita debugging
   - Muestra progreso en tiempo real

3. **Revisar dashboard antes de commit**
   - Verificar compliance score
   - Revisar violations
   - Validar métricas

4. **Archivar execution logs**
   - Útil para auditoría
   - Trackear mejora de métricas over time

5. **Iterar sobre violations**
   - Corregir MEDIUM/HIGH violations
   - Agregar tests faltantes

### [NO] DON'T

1. **No modificar código generado sin re-ejecutar tests**
   - Siempre re-ejecutar tests después de cambios manuales

2. **No ignorar violations MEDIUM**
   - Aunque no causan fallo, afectan score

3. **No bajar threshold de coverage**
   - Mantener >= 90%

4. **No skippear validación de seguridad**
   - Security issues son críticos en producción

5. **No eliminar execution logs**
   - Son parte del audit trail

---

## Checklist Pre-commit

Antes de hacer commit, verificar:

- [ ] TDD Agent ejecutado exitosamente
- [ ] Status: [OK] COMPLIANT
- [ ] Score >= 90/100
- [ ] Violations CRITICAL: 0
- [ ] Coverage >= 90%
- [ ] Security issues: 0
- [ ] Linting: Passed
- [ ] Type checking: Passed
- [ ] Tests ejecutados manualmente: Passing
- [ ] Dashboard revisado
- [ ] Execution log guardado en `docs/sdlc_outputs/tdd_logs/`
- [ ] Código revisado manualmente
- [ ] Commit message descriptivo con score

---

## Recursos Adicionales

- **Guía técnica completa:** `docs/gobernanza/agentes/tdd-feature-agent.md`
- **Referencia de agentes:** `docs/scripts/sdlc-agents-reference.md`
- **Constitution del proyecto:** `docs/gobernanza/CONSTITUTION.md`
- **DORA Metrics:** `docs/guias/METRICS.md`

---

**Última actualización:** 2025-01-15
**Mantenedor:** Equipo SDLC Agents
**Feedback:** Crear issue en el repositorio
