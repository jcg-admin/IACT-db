---
id: DOC-CHECKLIST-INDEX
estado: activo
propietario: equipo-qa
ultima_actualizacion: 2025-11-02
relacionados: ["DOC-INDEX-GENERAL", "DOC-QA-INDEX", "DOC-GOB-INDEX"]
date: 2025-11-13
---
# Checklists - Proyecto IACT

Este espacio contiene checklists operativos y de calidad para asegurar consistencia en procesos repetitivos del proyecto IACT.

## Página padre
- [Índice de espacios documentales](../index.md)

## Información clave

### Propósito

Los checklists sirven para:

- OK Asegurar que no se olviden pasos críticos
- OK Mantener calidad consistente entre diferentes personas
- OK Facilitar onboarding de nuevos miembros
- OK Documentar mejores prácticas
- OK Base para automatización futura

### Tipos de Checklists

1. **Desarrollo**: Proceso de escribir código
2. **Testing**: Verificación de calidad
3. **Deployment**: Proceso de release
4. **Code Review**: Revisión de PRs
5. **Onboarding**: Incorporación de nuevos desarrolladores
6. **Incident Response**: Respuesta a incidentes

## Checklists Disponibles

### 1. Checklist de Pre-Commit

**Usar antes de hacer commit:**

- [ ] Código formateado con Black
  ```bash
  black .
  ```

- [ ] Imports ordenados con isort
  ```bash
  isort .
  ```

- [ ] Linting pasado sin errores críticos
  ```bash
  pylint **/*.py
  flake8 .
  ```

- [ ] Type hints verificados (futuro)
  ```bash
  mypy .
  ```

- [ ] Tests unitarios pasan
  ```bash
  pytest
  ```

- [ ] Cobertura >= 80% para archivos modificados
  ```bash
  pytest --cov=. --cov-report=term-missing
  ```

- [ ] No hay código comentado innecesario
- [ ] No hay `print()` o `console.log()` de debugging
- [ ] No hay TODOs sin issue asociado
- [ ] Variables de entorno no committeadas
- [ ] Secrets no expuestos en código

### 2. Checklist de Pull Request

**Antes de crear PR:**

- [ ] Rama sigue convención `feature/nombre-timestamp`
- [ ] Commits siguen Conventional Commits
- [ ] Todos los tests pasan localmente
- [ ] Cobertura cumple mínimo 80%
- [ ] Documentación actualizada (si aplica)
- [ ] CHANGELOG.md actualizado (si es release)
- [ ] Screenshots incluidos (si es cambio visual)
- [ ] Migraciones generadas (si cambió modelos)

**Descripción de PR debe incluir:**

- [ ] **Summary**: Qué cambió y por qué (3-5 bullets)
- [ ] **Test Plan**: Cómo se probó
  - [ ] Tests unitarios agregados/actualizados
  - [ ] Tests de integración (si aplica)
  - [ ] Verificación manual realizada
- [ ] **Related Issues**: Links a issues (#123)
- [ ] **Breaking Changes**: Documentar si aplica
- [ ] **Deployment Notes**: Pasos especiales (si aplica)

**Revisar antes de marcar "Ready for Review":**

- [ ] CI pasó (cuando se implemente)
- [ ] Sin conflictos con rama base
- [ ] Self-review completado
- [ ] Reviewers asignados
- [ ] Labels apropiados (bug, feature, docs, etc.)

### 3. Checklist de Code Review

**Como revisor, verificar:**

**Funcionalidad:**
- [ ] Código hace lo que dice que hace
- [ ] Edge cases considerados
- [ ] Validación de inputs implementada
- [ ] Manejo de errores apropiado

**Calidad:**
- [ ] Código es legible y mantenible
- [ ] Sigue lineamientos del proyecto
- [ ] No hay código duplicado (DRY)
- [ ] Nombres de variables/funciones descriptivos
- [ ] Complejidad ciclomática razonable

**Tests:**
- [ ] Tests cubren casos happy path
- [ ] Tests cubren casos de error
- [ ] Tests son determinísticos (no flaky)
- [ ] Tests tienen nombres descriptivos
- [ ] Mocks usados apropiadamente

**Seguridad:**
- [ ] No hay SQL injection posible
- [ ] Inputs son sanitizados
- [ ] Secrets no expuestos
- [ ] Autenticación/autorización correcta

**Performance:**
- [ ] No hay N+1 queries
- [ ] Índices en DB apropiados
- [ ] Caching considerado (si aplica)
- [ ] Queries optimizadas

**Documentación:**
- [ ] Docstrings completos
- [ ] Comentarios explican "por qué", no "qué"
- [ ] README actualizado (si aplica)
- [ ] ADR creado (si decisión arquitectónica)

### 4. Checklist de Testing

**Tests Unitarios:**

- [ ] Cada función pública tiene test
- [ ] Casos happy path cubiertos
- [ ] Casos de error cubiertos
- [ ] Edge cases identificados y probados
- [ ] Tests siguen patrón Arrange-Act-Assert
- [ ] Nombres de test descriptivos
- [ ] Tests son independientes (no orden)
- [ ] Mocks usados apropiadamente
- [ ] Assertions específicas (no solo `assert True`)

**Tests de Integración:**

- [ ] Flujos end-to-end probados
- [ ] Integración con DB probada
- [ ] APIs externas mockeadas
- [ ] Transacciones manejadas correctamente
- [ ] Setup y teardown apropiados

**Cobertura:**

- [ ] Coverage >= 80% global
- [ ] Coverage 100% en servicios críticos
- [ ] Líneas no cubiertas justificadas
- [ ] Branch coverage verificado

### 5. Checklist de Deployment

**Pre-Deployment:**

- [ ] Todos los tests pasan
- [ ] Code review aprobado
- [ ] Merge a rama develop/main
- [ ] Tag de versión creado (`v1.2.3`)
- [ ] CHANGELOG.md actualizado
- [ ] Migraciones revisadas
- [ ] Backup de DB realizado
- [ ] Ventana de mantenimiento comunicada

**Deployment:**

- [ ] Deployment a staging exitoso
- [ ] Smoke tests en staging pasaron
- [ ] Aprobación de stakeholders
- [ ] Deployment a producción ejecutado
- [ ] Migraciones aplicadas sin errores
- [ ] Servicios reiniciados
- [ ] Health checks pasaron

**Post-Deployment:**

- [ ] Smoke tests en producción pasaron
- [ ] Monitoreo de métricas (30 min)
- [ ] Logs revisados para errores
- [ ] Rollback plan listo (si se necesita)
- [ ] Comunicación a stakeholders
- [ ] Documentación actualizada
- [ ] Post-mortem agendado (si hubo issues)

### 6. Checklist de Onboarding

**Día 1:**

- [ ] Acceso a GitHub configurado
- [ ] Agregado a organización 2-Coatl
- [ ] Acceso a Slack/Teams
- [ ] Lectura de README.md
- [ ] Lectura de [Convenciones](../../.github/claude-code-conventions.md)

**Primera Semana:**

- [ ] Vagrant configurado y funcionando
- [ ] Entorno virtual Python creado
- [ ] Tests corriendo localmente
- [ ] Primer commit realizado
- [ ] Primer PR creado (pequeño cambio)
- [ ] Lectura de [Arquitectura](../arquitectura/readme.md)
- [ ] Lectura de [Lineamientos de Código](../arquitectura/lineamientos_codigo.md)

**Primer Mes:**

- [ ] Feature completa implementada
- [ ] Familiarizado con codebase principal
- [ ] Participación en code reviews
- [ ] Comprensión de flujo de deployment
- [ ] Conocimiento de herramientas de monitoreo

### 7. Checklist de Incident Response

**Detección:**

- [ ] Incidente confirmado
- [ ] Severidad determinada (P0-P4)
- [ ] Stakeholders notificados
- [ ] Incident lead asignado

**Investigación:**

- [ ] Logs revisados
- [ ] Métricas analizadas
- [ ] Hipótesis de causa formulada
- [ ] Timeline del incidente documentado

**Mitigación:**

- [ ] Workaround implementado (si aplica)
- [ ] Clientes impactados identificados
- [ ] Comunicación a usuarios (si aplica)
- [ ] Rollback ejecutado (si necesario)

**Resolución:**

- [ ] Root cause identificada
- [ ] Fix implementado
- [ ] Tests agregados para prevenir regresión
- [ ] Deploy de fix completado
- [ ] Verificación de resolución

**Post-Incident:**

- [ ] Post-mortem agendado
- [ ] Timeline documentado
- [ ] Action items identificados
- [ ] Responsables asignados
- [ ] Mejoras implementadas

### 8. Checklist de Security Review

**Código:**

- [ ] No hay secrets hardcodeados
- [ ] Inputs validados y sanitizados
- [ ] Outputs encoded apropiadamente
- [ ] SQL injection prevenido (usar ORM)
- [ ] XSS prevenido
- [ ] CSRF protection habilitado

**Autenticación/Autorización:**

- [ ] Passwords hasheados (no plaintext)
- [ ] Session management seguro
- [ ] Permisos verificados en cada endpoint
- [ ] Roles y permisos documentados

**Datos:**

- [ ] PII identificado y protegido
- [ ] Datos sensibles encriptados at rest
- [ ] TLS/SSL para datos in transit
- [ ] Backups encriptados

**Dependencias:**

- [ ] Dependencias actualizadas
- [ ] Vulnerabilidades conocidas verificadas
  ```bash
  pip-audit
  safety check
  ```

## Uso de Checklists

### En Pull Requests

Incluir checklist relevante en descripción:

```markdown
## Checklist de PR

- [x] Tests pasan
- [x] Cobertura >= 80%
- [x] Documentación actualizada
- [ ] CHANGELOG.md actualizado (N/A - no es release)
```

### En Issues

Para tareas complejas, incluir checklist de sub-tareas:

```markdown
## Implementar ETL para llamadas

- [ ] Crear extractor IVR
- [ ] Crear transformer de datos
- [ ] Crear loader a PostgreSQL
- [ ] Agregar tests unitarios
- [ ] Agregar tests de integración
- [ ] Documentar en diseño detallado
```

### Automatización (Futuro)

Muchos de estos checks pueden automatizarse:

```yaml
# .github/workflows/pr-checks.yml
name: PR Checks

on: pull_request

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run linting
        run: |
          pip install pylint flake8 black isort
          black --check .
          isort --check .
          pylint **/*.py
          flake8 .
      - name: Run tests
        run: pytest --cov=. --cov-fail-under=80
```

## Estado de cumplimiento

| Checklist | Estado | Automatizado |
|-----------|--------|--------------|
| Pre-Commit | OK Documentado | WARNING Parcial (pre-commit hooks) |
| Pull Request | OK Documentado | NO No |
| Code Review | OK Documentado | NO No |
| Testing | OK Documentado | WARNING Parcial (pytest) |
| Deployment | OK Documentado | NO No |
| Onboarding | OK Documentado | NO No |
| Incident Response | OK Documentado | NO No |
| Security Review | OK Documentado | WARNING Parcial (safety, pip-audit) |

## Acciones prioritarias

- [ ] Configurar pre-commit hooks automáticos
- [ ] Crear GitHub Actions para validar PRs
- [ ] Crear templates de PR con checklists
- [ ] Crear templates de issues con checklists
- [ ] Automatizar security scans en CI
- [ ] Crear dashboard de métricas de calidad

## Recursos relacionados

- [Gobernanza](../gobernanza/readme.md)
- [QA - Estrategia](../qa/estrategia_qa.md)
- [Lineamientos de Código](../arquitectura/lineamientos_codigo.md)
- [Convenciones de Claude Code](../../.github/claude-code-conventions.md)
- [Backend - Checklists](../backend/checklists/readme.md)
- [Frontend - Checklists](../frontend/checklists/readme.md)
