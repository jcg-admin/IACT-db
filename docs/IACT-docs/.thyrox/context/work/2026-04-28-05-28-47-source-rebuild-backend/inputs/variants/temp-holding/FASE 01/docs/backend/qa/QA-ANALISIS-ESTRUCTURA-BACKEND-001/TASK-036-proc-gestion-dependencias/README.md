# TASK-036: Crear PROC-BACK-002-gestion-dependencias.md

## Información General
- **Fase**: FASE 3 - Procesos
- **Duración Estimada**: 30 minutos
- **Prioridad**: MEDIA
- **Tipo**: Proceso Documentación
- **Metodología**: Auto-CoT + Self-Consistency

## Objetivo
Crear un proceso documentado para la gestión de dependencias del backend, incluyendo instalación, actualización, y resolución de conflictos.

## Auto-CoT: Razonamiento en Cadena

### Paso 1: Identificación de Dependencias Actuales
**Pregunta**: ¿Qué dependencias usa el proyecto?
**Razonamiento**:
- Revisar requirements.txt
- Examinar Pipfile/pyproject.toml (si existen)
- Identificar dependencias de desarrollo vs producción
- Analizar versiones y constraints

### Paso 2: Workflow de Gestión
**Pregunta**: ¿Cómo gestionar dependencias de forma segura?
**Razonamiento**:
1. Instalación controlada
2. Actualización gradual
3. Testing de compatibilidad
4. Documentación de cambios
5. Rollback si es necesario

### Paso 3: Prevención de Problemas
**Pregunta**: ¿Cómo evitar conflictos de dependencias?
**Razonamiento**:
- Versionado explícito
- Uso de virtual environments
- Lock files
- Auditorías de seguridad
- Monitoreo de deprecaciones

## Self-Consistency: Validación Cruzada

### Verificación 1: Completitud
- ¿Se cubren todos los tipos de dependencias?
- ¿Se incluye proceso de rollback?
- ¿Se documenta troubleshooting?

### Verificación 2: Seguridad
- ¿Se incluyen auditorías de seguridad?
- ¿Se validan fuentes de paquetes?
- ¿Se documentan vulnerabilidades conocidas?

### Verificación 3: Mantenibilidad
- ¿El proceso es sostenible a largo plazo?
- ¿Es fácil de seguir para nuevos miembros?
- ¿Se automatiza lo automatizable?

## Estructura del Entregable: PROC-BACK-002-gestion-dependencias.md

```markdown
# PROC-BACK-002: Gestión de Dependencias Backend

## Metadata
- **ID**: PROC-BACK-002
- **Versión**: 1.0
- **Fecha**: 2025-11-18
- **Owner**: Equipo Backend
- **Revisión**: Trimestral

## Propósito
Establecer un proceso estándar para la gestión de dependencias Python del backend, asegurando estabilidad, seguridad y reproducibilidad.

## Alcance
- Instalación de nuevas dependencias
- Actualización de dependencias existentes
- Auditorías de seguridad
- Resolución de conflictos
- No aplica a: dependencias del sistema (apt, yum)

## Estructura de Archivos de Dependencias

```
backend/
 requirements/
 base.txt # Dependencias comunes
 development.txt # Dependencias de desarrollo
 production.txt # Dependencias de producción
 testing.txt # Dependencias de testing
 requirements.txt # Apunta a production
 requirements-lock.txt # Versiones exactas (pip freeze)
```

## Categorías de Dependencias

| Categoría | Archivo | Propósito | Ejemplos |
|-----------|---------|-----------|----------|
| Core | base.txt | Framework y libs esenciales | Django, DRF, psycopg2 |
| Development | development.txt | Herramientas de desarrollo | black, flake8, ipython |
| Testing | testing.txt | Testing y cobertura | pytest, factory-boy, faker |
| Production | production.txt | Solo para producción | gunicorn, sentry-sdk |

## Proceso 1: Agregar Nueva Dependencia

### 1.1 Investigación (10-15 minutos)
- [ ] Verificar que la dependencia es necesaria
- [ ] Evaluar alternativas
- [ ] Revisar reputación y mantenimiento
 - GitHub stars y actividad
 - Última versión y fecha
 - Issues abiertas vs cerradas
- [ ] Verificar compatibilidad con Python version
- [ ] Verificar licencia (compatible con proyecto)

**Checklist de Evaluación:**
```markdown
## Evaluación: [nombre-paquete]
- Propósito: [descripción]
- Alternativas evaluadas: [lista]
- Repositorio: [URL]
- Stars: [número] | Última actualización: [fecha]
- Licencia: [tipo]
- Python support: [versiones]
- Mantenedores activos: [sí/no]
- Dependencias transitivas: [número]
- Tamaño: [MB]
```

### 1.2 Instalación Local (5 minutos)
```bash
# Activar virtual environment
source venv/bin/activate

# Instalar en entorno de desarrollo
pip install package-name

# Verificar instalación
pip show package-name

# Probar importación
python -c "import package_name; print(package_name.__version__)"
```

### 1.3 Testing de Compatibilidad (15-30 minutos)
```bash
# Ejecutar suite de tests completa
pytest

# Verificar que no hay conflictos
pip check

# Revisar warnings de deprecación
python -W all manage.py check
```

### 1.4 Agregar a Requirements (5 minutos)
```bash
# Determinar categoría correcta
# Agregar a archivo correspondiente con versión específica

# requirements/base.txt
package-name==1.2.3 # Descripción del uso

# Regenerar lock file
pip freeze > requirements-lock.txt

# Actualizar requirements.txt si es necesario
```

### 1.5 Documentación (10 minutos)
```markdown
# Actualizar docs/backend/DEPENDENCIES.md

## [Nombre Paquete]
- **Versión**: 1.2.3
- **Categoría**: [Core/Development/Testing/Production]
- **Propósito**: [Descripción]
- **Instalado en**: [Fecha]
- **Razón**: [Por qué se agregó]
- **Configuración**: [Si requiere config]
```

### 1.6 Commit y PR
```bash
git add requirements/
git commit -m "build(deps): add package-name v1.2.3

Add package-name for [propósito].

Tested:
- All tests passing
- No conflicts detected
- Compatible with Python 3.9+
"
```

## Proceso 2: Actualizar Dependencias

### 2.1 Auditoría Regular (Mensual)
```bash
# Verificar dependencias desactualizadas
pip list --outdated

# Verificar vulnerabilidades de seguridad
pip-audit

# Alternativamente con safety
safety check --json
```

### 2.2 Actualización Menor (Patch/Minor)
```bash
# Para updates de seguridad o bug fixes (1.2.3 -> 1.2.4)

# Actualizar en entorno de desarrollo
pip install --upgrade package-name

# Verificar nueva versión
pip show package-name

# Ejecutar tests
pytest

# Si todo OK, actualizar requirements
# requirements/base.txt
package-name==1.2.4 # Updated for security fix CVE-XXXX

# Actualizar lock file
pip freeze > requirements-lock.txt
```

### 2.3 Actualización Mayor (Major)
```bash
# Para cambios breaking (1.x.x -> 2.0.0)

# IMPORTANTE: Requiere más cuidado

# 1. Leer CHANGELOG y migration guide
# 2. Crear branch específico
git checkout -b update/package-name-v2

# 3. Actualizar en entorno aislado
pip install --upgrade package-name

# 4. Revisar deprecation warnings
python -W all manage.py check

# 5. Actualizar código afectado
# ... hacer cambios necesarios ...

# 6. Ejecutar tests extensivos
pytest -v
pytest --cov

# 7. Si falla, considerar rollback
pip install package-name==1.9.9
```

### 2.4 Actualización Masiva
```bash
# CUIDADO: Solo en entorno de desarrollo aislado

# Crear backup de requirements
cp requirements-lock.txt requirements-lock.txt.backup

# Actualizar todo (NO RECOMENDADO en producción)
pip install --upgrade -r requirements/base.txt

# Mejor: Actualizar grupo específico
pip install --upgrade pytest pytest-django pytest-cov

# Ejecutar suite completa de tests
pytest --cov

# Si todo OK, generar nuevo lock file
pip freeze > requirements-lock.txt

# Si falla, restaurar
cp requirements-lock.txt.backup requirements-lock.txt
pip install -r requirements-lock.txt
```

## Proceso 3: Remover Dependencias

### 3.1 Identificar Dependencias No Usadas
```bash
# Usar pipdeptree para visualizar
pipdeptree

# Usar pip-autoremove (con cuidado)
pip-autoremove package-name --dry-run
```

### 3.2 Desinstalación Segura
```bash
# 1. Verificar que no se usa
grep -r "import package_name" backend/

# 2. Desinstalar localmente
pip uninstall package-name

# 3. Ejecutar tests
pytest

# 4. Remover de requirements
# Editar archivo correspondiente

# 5. Actualizar lock file
pip freeze > requirements-lock.txt

# 6. Commit
git add requirements/
git commit -m "build(deps): remove unused package-name"
```

## Proceso 4: Resolución de Conflictos

### 4.1 Identificar Conflictos
```bash
# pip mostrará errores como:
# ERROR: package-a 1.0 requires package-b>=2.0, but you have package-b 1.5

# Verificar manualmente
pip check
```

### 4.2 Resolver Conflictos
```bash
# Estrategia 1: Actualizar dependencia conflictiva
pip install --upgrade package-b

# Estrategia 2: Downgrade de package-a
pip install package-a==0.9

# Estrategia 3: Usar pipdeptree para analizar
pipdeptree -p package-a

# Estrategia 4: Crear virtual environment limpio
python -m venv venv-clean
source venv-clean/bin/activate
pip install -r requirements.txt
```

## Proceso 5: Auditoría de Seguridad

### 5.1 Auditoría Automática (Semanal)
```bash
# Usando pip-audit (recomendado)
pip-audit --format json > audit-report.json

# Usando safety
safety check --save-json safety-report.json

# Revisar vulnerabilidades
cat audit-report.json | jq '.vulnerabilities'
```

### 5.2 Respuesta a Vulnerabilidades

| Severidad | Acción | SLA |
|-----------|--------|-----|
| Critical | Hotfix inmediato | 24 horas |
| High | Actualizar en próximo sprint | 1 semana |
| Medium | Planificar actualización | 1 mes |
| Low | Revisar en auditoría regular | 3 meses |

```bash
# Para vulnerabilidades críticas
# 1. Verificar fix disponible
pip index versions package-name

# 2. Actualizar a versión segura
pip install package-name==1.2.4 # versión sin CVE

# 3. Testing urgente
pytest -v --cov

# 4. Deploy inmediato si crítico
# Seguir PROC-DEPLOY-HOTFIX
```

## Herramientas Recomendadas

| Herramienta | Propósito | Comando |
|-------------|-----------|---------|
| pip | Gestión de paquetes | `pip install/uninstall` |
| pip-audit | Auditoría seguridad | `pip-audit` |
| pipdeptree | Árbol dependencias | `pipdeptree` |
| pip-autoremove | Remover no usados | `pip-autoremove` |
| safety | Security checks | `safety check` |

## Automatización

### Pre-commit Hook
```yaml
# .pre-commit-config.yaml
repos:
 - repo: https://github.com/Lucas-C/pre-commit-hooks-safety
 rev: v1.3.0
 hooks:
 - id: python-safety-dependencies-check
```

### GitHub Actions
```yaml
# .github/workflows/dependency-check.yml
name: Dependency Security Check

on:
 schedule:
 - cron: '0 0 * * 1' # Weekly
 pull_request:
 paths:
 - 'requirements/**'

jobs:
 security:
 runs-on: ubuntu-latest
 steps:
 - uses: actions/checkout@v3
 - name: Run pip-audit
 run: |
 pip install pip-audit
 pip-audit --requirement requirements.txt
```

## Troubleshooting Común

### Error: "No matching distribution found"
```bash
# Solución 1: Verificar nombre del paquete
pip search package-name

# Solución 2: Verificar compatibilidad Python
# Revisar en PyPI supported Python versions

# Solución 3: Actualizar pip
pip install --upgrade pip
```

### Error: "Conflicting dependencies"
```bash
# Ver dependencias en conflicto
pipdeptree --warn conflict

# Resolver manualmente en requirements
# Especificar versiones compatibles
```

### Error: "Import error after install"
```bash
# Verificar instalación correcta
pip show package-name

# Reinstalar
pip uninstall package-name
pip install package-name

# Verificar virtual environment activo
which python
```

## Best Practices

1. **Siempre especificar versiones exactas** en producción
 ```txt
 # [ERROR] NO
 django

 # [OK] SÍ
 django==4.2.7
 ```

2. **Separar dependencias por entorno**
 ```txt
 requirements/
 base.txt
 development.txt
 production.txt
 testing.txt
 ```

3. **Usar virtual environments**
 ```bash
 python -m venv venv
 source venv/bin/activate
 ```

4. **Documentar dependencias nuevas**
 - Agregar comentario en requirements
 - Actualizar DEPENDENCIES.md
 - Incluir en commit message

5. **Auditorías regulares**
 - Seguridad: Semanal
 - Actualizaciones: Mensual
 - Limpieza: Trimestral

## Métricas

| Métrica | Objetivo | Medición |
|---------|----------|----------|
| Vulnerabilidades Critical | 0 | `pip-audit` |
| Dependencias Outdated | < 10% | `pip list --outdated` |
| Tiempo Actualización Security | < 48h | Manual |
| Cobertura Tests Post-Update | ≥ 80% | `pytest --cov` |

## Referencias
- [Python Packaging Guide](https://packaging.python.org/)
- [pip Documentation](https://pip.pypa.io/)
- [pip-audit](https://github.com/pypa/pip-audit)
- docs/backend/SECURITY.md

## Changelog
- v1.0 (2025-11-18): Versión inicial
```

## Entregables
- [ ] PROC-BACK-002-gestion-dependencias.md creado
- [ ] Procesos de instalación/actualización/remoción documentados
- [ ] Auditoría de seguridad incluida
- [ ] Troubleshooting documentado
- [ ] Validación Self-Consistency completada

## Criterios de Aceptación
1. [OK] Proceso completo de gestión documentado
2. [OK] Todas las operaciones cubiertas (agregar, actualizar, remover)
3. [OK] Auditoría de seguridad documentada
4. [OK] Herramientas y comandos incluidos
5. [OK] Troubleshooting común documentado
6. [OK] Best practices especificadas
7. [OK] Automatización sugerida

## Notas
- Revisar requirements.txt actual del proyecto
- Incluir herramientas realmente usadas
- Considerar poetry o pipenv si el proyecto los usa
- Actualizar según stack tecnológico real
