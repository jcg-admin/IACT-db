---
id: GUIA-testing-001
tipo: guia_operativa
categoria: testing
audiencia: desarrollador
prioridad: P0
tiempo_lectura: 8 minutos
version: 1.0.0
fecha: 2025-11-07
relacionados: []
---

# Ejecutar Tests Backend Localmente

## Proposito

Aprende a ejecutar la suite completa de tests del backend Django en tu entorno local.

## Audiencia

Esta guia esta dirigida a: desarrollador

## Pre-requisitos

- [ ] Backend configurado (Ver GUIA-ONBOARDING-001)
- [ ] Base de datos de test configurada
- [ ] pytest instalado

## Tiempo estimado

Tiempo de lectura: 8 minutos
Tiempo de ejecucion: 16 minutos

## Pasos

### 1. Preparar entorno de tests

Asegúrate de tener las dependencias de testing instaladas.

**Comando**:
```bash
cd api
pip install -r requirements.txt
```

**Output esperado**:
```
Dependencias instaladas
```

### 2. Ejecutar todos los tests

Ejecuta la suite completa de tests con pytest.

**Comando**:
```bash
pytest
```

**Output esperado**:
```
===== XX passed in X.XXs =====
```

### 3. Ejecutar tests con coverage

Ejecuta tests y genera reporte de cobertura.

**Comando**:
```bash
pytest --cov=. --cov-report=html --cov-report=term
```

**Output esperado**:
```
Coverage: 85%
```

### 4. Ejecutar tests de un módulo específico

Ejecuta solo los tests de un módulo particular.

**Comando**:
```bash
pytest tests/test_authentication.py -v
```

**Output esperado**:
```
Tests del módulo ejecutados
```

{PASO_3_DESCRIPCION}

## Validacion

Para validar que completaste correctamente esta guia:

- [ ] pytest ejecuta sin errores
- [ ] Coverage es >= 80%
- [ ] Todos los tests pasan
- [ ] Reporte HTML generado en htmlcov/

## Como interpretar resultados

**Exito**: {DESCRIPCION_EXITO}

**Errores comunes**: Ver seccion Troubleshooting

## Troubleshooting

### Error 1: ImportError al ejecutar tests

**Sintomas**:
```
ModuleNotFoundError: No module named 'X'
```

**Causa**: Dependencia faltante o PYTHONPATH incorrecto

**Solucion**:
```bash
Reinstala dependencias:
pip install -r requirements.txt
# O configura PYTHONPATH:
export PYTHONPATH=$PYTHONPATH:$(pwd)
```

### Error 2: Tests fallan por base de datos

**Sintomas**:
```
django.db.utils.OperationalError
```

**Causa**: Base de datos de test no configurada

**Solucion**:
```bash
Configura TEST_DATABASE en settings:
# Django crea automáticamente test_<database>
# Asegúrate de tener permisos para crear BD
```

**Sintomas**: {ERROR_2_SINTOMAS}

**Causa**: {ERROR_2_CAUSA}

**Solucion**: {ERROR_2_SOLUCION}

## Proximos pasos

Despues de completar esta guia, puedes continuar con:

1. Ejecutar tests frontend (Ver GUIA-TESTING-002)
2. Validar test pyramid (Ver GUIA-TESTING-003)
3. Escribir nuevos tests

## Referencias

- Pytest docs: `https://docs.pytest.org/`
- Script CI backend: `scripts/ci/backend_test.sh`
- Coverage config: `pytest.ini`

## Feedback

Si encuentras problemas con esta guia o tienes sugerencias:
- Crea un issue en GitHub con label `documentation`
- Contacta a: TBD

---

**Mantenedores**: @qa-lead, @backend-lead
**Ultima actualizacion**: 2025-11-07
