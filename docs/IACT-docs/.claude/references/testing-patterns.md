```yml
type: Reference
title: Testing Patterns — Patrones Prácticos de Testing con Claude Code
category: Desarrollo — Testing
version: 1.0
created_at: 2026-04-13
owner: thyrox (cross-phase)
purpose: SDD práctico, CI/CD con claude -p, code review automation y patrones de testing
```

# Testing Patterns — Patrones Prácticos de Testing con Claude Code

Guía de patrones concretos: CI/CD integration, code review automation, y SDD práctico.
Para la teoría completa de SDD, ver [sdd.md](sdd.md).

---

## SDD en una frase

**Specification-Driven Development** = escribir la especificación antes del código, donde la especificación toma la forma de tests (TDD) y/o contratos (DbC).

```
Specify → Plan → Implement → Validate → (ciclo)
```

Ver [sdd.md](sdd.md) para el ciclo completo, tipos de especificación y cuando usar cada uno.

---

## Collaborative Tests — Claude escribe tests, humano valida

El patrón más efectivo de testing con Claude Code:

**Flujo:**
1. Humano describe el comportamiento en lenguaje natural
2. Claude genera tests que capturan ese comportamiento
3. Humano revisa que los tests capturen la lógica de negocio correcta
4. Claude implementa el código que hace pasar los tests

```bash
claude -p "Write tests for the UserRegistration component. 
Focus on: email validation, duplicate email handling, 
password strength requirements. Use Jest + React Testing Library."
```

**Por qué funciona:**
- Claude es bueno generando casos edge que los humanos olvidan
- El humano valida la intención de negocio (que Claude no puede conocer)
- Separación clara de responsabilidades

---

## Contratos (DbC) — especificación formal

Los contratos documentan precondiciones, postcondiciones e invariantes:

```python
def withdraw(account: Account, amount: float) -> float:
    """
    Precondición:  amount > 0
    Precondición:  account.balance >= amount
    Postcondición: account.balance == old(account.balance) - amount
    Postcondición: return == amount
    Invariante:    account.balance >= 0
    """
    ...
```

**Claude puede:**
- Generar contratos a partir de código existente (inferir intenciones)
- Verificar que la implementación respeta los contratos
- Detectar violaciones de precondiciones/postcondiciones en code review

---

## Test Amplification — Claude amplía tests existentes

Dado un test existente, Claude genera variantes con edge cases:

```bash
claude -p "Given this test:

$(cat tests/auth.test.ts)

Add edge case tests for:
- Empty string inputs
- Very long strings (>1000 chars)
- Unicode characters
- SQL injection attempts
- Concurrent requests"
```

**Casos de uso:**
- Aumentar cobertura rápidamente
- Descubrir edge cases antes de shipping
- Hardening de tests existentes

---

## CI/CD Integration

### Pattern básico — query + output json

```bash
# En GitHub Actions / GitLab CI
claude -p "Run the test suite and report any failures" \
  --max-turns 5 \
  --output-format json | jq -r '.result'
```

### Pattern para code review automático en PR

```bash
# Obtener el diff del PR
PR_DIFF=$(git diff origin/main...HEAD)

claude -p "Review this PR diff for:
- Security vulnerabilities
- Performance issues
- Code style violations
- Missing error handling

Diff:
$PR_DIFF" \
  --output-format json \
  --max-turns 3
```

### GitHub Actions — ejemplo completo

```yaml
name: Claude Code Review
on: [pull_request]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      
      - name: Code Review with Claude
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          DIFF=$(git diff origin/main...HEAD)
          REVIEW=$(claude -p "Review this diff: $DIFF" \
            --output-format json \
            --max-turns 3 | jq -r '.result')
          echo "$REVIEW" >> $GITHUB_STEP_SUMMARY
```

### Pattern para test generation en CI

```bash
# Generar tests para archivos modificados
CHANGED_FILES=$(git diff --name-only origin/main...HEAD | grep "\.ts$")

for file in $CHANGED_FILES; do
  claude -p "Generate unit tests for: $(cat $file)" \
    --output-format json \
    --max-turns 2 > "tests/${file%.ts}.test.ts"
done
```

---

## Code Review con Skills

Crear un skill de code review reutilizable:

```yaml
# .claude/skills/code-review/SKILL.md
---
name: code-review
description: Realiza code review de cambios en el repositorio
user-invocable: true
---

Analiza los cambios en el repositorio:
1. git diff para ver cambios
2. Revisa: seguridad, performance, style, errores
3. Genera reporte con: crítico/advertencia/sugerencia
```

**Uso:**
```bash
claude /code-review
```

---

## Cuándo usar cada tipo de especificación

| Tipo | Cuándo | Ejemplo |
|------|--------|---------|
| **Unit tests (TDD)** | Lógica de negocio pura, funciones con I/O claro | `calculateTax(amount, rate)` |
| **Integration tests** | Interacción entre componentes | `UserService + Database + Cache` |
| **Contratos (DbC)** | APIs críticas, código con invariantes fuertes | `BankAccount.withdraw()` |
| **Collaborative tests** | Comportamiento emergente, UI/UX | `UserRegistration flow` |
| **Test amplification** | Aumentar cobertura de tests existentes | Ampliar tests de auth |
| **CI/CD review** | Revisión automática en PR | Code review en cada PR |

---

## Patrones de validación continua

### Pre-commit hook con Claude

```bash
# .claude/scripts/pre-commit-review.sh
#!/bin/bash
STAGED=$(git diff --cached --name-only | grep "\.ts$")
if [ -n "$STAGED" ]; then
  claude -p "Quick security review of staged changes: $(git diff --cached)" \
    --max-turns 2 \
    --bare \
    --output-format text
fi
```

### Validación de specs antes de ejecutar

```bash
claude -p "Verify that the implementation in src/ matches the spec in docs/spec.md.
Report any discrepancies." \
  --output-format json
```

---

## Anti-patrones

### ❌ Tests sin validación humana de la lógica de negocio

Claude genera tests técnicamente correctos pero que no capturan la intención real.
**Correcto:** Siempre revisar los tests generados antes de merge.

### ❌ CI review sin presupuesto de tokens

```bash
# MAL — puede agotar quota con diffs grandes
claude -p "Review: $(git diff HEAD~100)"

# BIEN — limitar scope
claude -p "Review: $(git diff HEAD~1)" --max-turns 3
```

### ❌ Usar claude en CI sin --output-format json

El text output puede cambiar de formato. JSON es estable para parsing.
