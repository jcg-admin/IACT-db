---
id: PROCED-BACK-001
tipo: procedimiento
categoria: testing
titulo: Procedimiento de Ejecucion de Tests Backend
version: 1.0.0
fecha_creacion: 2025-11-18
fecha_actualizacion: 2025-11-18
estado: activo
responsable: Equipo de Desarrollo Backend
frecuencia: continua
---

# PROCED-BACK-001: Ejecucion de Tests Backend

**ID:** PROCED-BACK-001
**Version:** 1.0.0
**Fecha:** 2025-11-18
**Categoria:** Testing / Backend / Calidad

---

## 1. PROPOSITO

### 1.1 Objetivo
Establecer un procedimiento sistematico para ejecutar la suite completa de tests del backend, garantizando la calidad del codigo y la deteccion temprana de regresiones antes de integrar cambios.

### 1.2 Problemas que Resuelve
- Regresiones no detectadas antes de deployment
- Falta de confianza en cambios realizados
- Inconsistencia en resultados de tests entre desarrolladores
- Tests ejecutados parcialmente o incorrectamente
- Falta de documentacion de fallos encontrados

### 1.3 Beneficios Esperados
- Deteccion temprana de bugs (antes de integracion)
- Cobertura de codigo verificada y mantenida
- Confianza en estabilidad de cambios
- Tiempo reducido en debugging post-deployment
- Documentacion de estado de calidad del codigo

---

## 2. ALCANCE

### 2.1 Incluye
- Ejecucion de tests unitarios de todas las apps Django
- Ejecucion de tests de integracion
- Ejecucion de tests funcionales
- Verificacion de cobertura de codigo
- Generacion de reportes de tests
- Validacion de fixtures y datos de prueba
- Tests de modelos, vistas, serializadores y APIs

### 2.2 Excluye
- Tests end-to-end (E2E) de frontend
- Tests de performance y carga
- Tests de penetracion y seguridad
- Tests manuales de UI/UX
- Deployment a ambientes

### 2.3 Frecuencia de Ejecucion
- **Obligatorio:** Antes de cada commit/push
- **Continuo:** En pipeline CI/CD
- **Pre-PR:** Antes de crear Pull Request
- **Pre-Release:** Antes de cada deployment

---

## 3. ROLES Y RESPONSABILIDADES

### 3.1 Matriz RACI

| Actividad | Desarrollador | QA Engineer | Tech Lead | DevOps |
|-----------|---------------|-------------|-----------|--------|
| Preparar entorno de tests | R | C | I | C |
| Ejecutar suite de tests | R | C | I | I |
| Analizar resultados | R | A | C | I |
| Documentar fallos | R | C | I | I |
| Corregir tests fallidos | R | C | A | I |
| Validar cobertura | C | R | A | I |

**Leyenda:**
- R: Responsable de ejecutar
- A: Aprobador final
- C: Consultado durante proceso
- I: Informado de resultados

### 3.2 Perfiles Requeridos

**Desarrollador Backend:**
- Conocimiento de pytest y Django testing
- Familiaridad con estructura de proyecto Django
- Capacidad de analisis de fallos de tests
- Conocimiento de fixtures y mocking

**QA Engineer (Validacion):**
- Experiencia en metricas de calidad
- Conocimiento de cobertura de codigo
- Capacidad de analisis de reportes

---

## 4. PREREQUISITOS

### 4.1 Tecnicos
- [ ] Python 3.x instalado y configurado
- [ ] Entorno virtual activado
- [ ] Dependencias instaladas (requirements.txt)
- [ ] Base de datos de test configurada
- [ ] pytest y pytest-django instalados
- [ ] Variables de entorno configuradas

### 4.2 Organizacionales
- [ ] Codigo actualizado desde repositorio
- [ ] Migraciones de base de datos aplicadas
- [ ] Sin cambios pendientes de commit
- [ ] Tiempo estimado reservado (30-60 min)

### 4.3 Conocimientos
- [ ] pytest: comandos basicos y opciones
- [ ] Django testing framework
- [ ] Interpretacion de mensajes de error
- [ ] Fixtures y factories de Django

---

## 5. PROCEDIMIENTO DETALLADO

### ETAPA 1: PREPARACION DEL ENTORNO (10 minutos)

#### Paso 1.1: Verificar Entorno Virtual
```bash
# Verificar que entorno virtual esta activo
which python
# Debe mostrar path dentro de venv/bin/python

# Si no esta activo, activar
source venv/bin/activate
```

**Criterio de Exito:** Entorno virtual activo confirmado

#### Paso 1.2: Actualizar Dependencias
```bash
# Verificar que todas las dependencias esten instaladas
pip list | grep -E 'pytest|Django'

# Si falta alguna, instalar
pip install -r requirements.txt
pip install pytest pytest-django pytest-cov
```

**Criterio de Exito:** Todas las dependencias instaladas correctamente

#### Paso 1.3: Verificar Configuracion de Base de Datos
```bash
# Verificar variable de entorno para tests
echo $DJANGO_SETTINGS_MODULE

# Debe ser settings.test o similar
export DJANGO_SETTINGS_MODULE=config.settings.test
```

**Criterio de Exito:** Variable de entorno configurada

#### Paso 1.4: Limpiar Cache y Archivos Temporales
```bash
# Limpiar archivos .pyc
find . -type f -name "*.pyc" -delete
find . -type d -name "__pycache__" -delete

# Limpiar coverage anterior
rm -f .coverage
rm -rf htmlcov/
```

**Criterio de Exito:** Cache limpio

---

### ETAPA 2: EJECUCION DE TESTS UNITARIOS (20 minutos)

#### Paso 2.1: Ejecutar Tests de Modelos
```bash
# Tests de modelos por app
pytest apps/permissions/tests/test_models.py -v
pytest apps/audit/tests/test_models.py -v
pytest apps/analytics/tests/test_models.py -v
```

**Criterio de Exito:** Todos los tests de modelos pasan (100%)

#### Paso 2.2: Ejecutar Tests de Serializadores
```bash
# Tests de serializadores
pytest apps/permissions/tests/test_serializers.py -v
pytest apps/audit/tests/test_serializers.py -v
pytest apps/analytics/tests/test_serializers.py -v
```

**Criterio de Exito:** Todos los tests de serializadores pasan

#### Paso 2.3: Ejecutar Tests de Vistas
```bash
# Tests de vistas y APIs
pytest apps/permissions/tests/test_views.py -v
pytest apps/audit/tests/test_views.py -v
pytest apps/analytics/tests/test_views.py -v
```

**Criterio de Exito:** Todos los tests de vistas pasan

#### Paso 2.4: Documentar Fallos (si existen)
Si algun test falla:
```bash
# Re-ejecutar solo tests fallidos con mas detalle
pytest --lf -vv --tb=long

# Capturar output completo
pytest --lf -vv --tb=long > /tmp/test_failures.log 2>&1
```

**Documentar:**
- Nombre del test fallido
- Mensaje de error
- Traceback completo
- Archivos involucrados

---

### ETAPA 3: EJECUCION DE TESTS DE INTEGRACION (15 minutos)

#### Paso 3.1: Ejecutar Tests de Integracion
```bash
# Tests de integracion entre modulos
pytest tests/integration/ -v

# Tests de flujos completos
pytest apps/permissions/tests/test_integration.py -v
```

**Criterio de Exito:** Tests de integracion pasan sin errores

#### Paso 3.2: Validar Transacciones de Base de Datos
```bash
# Tests que verifican ACID
pytest -k "transaction" -v
```

**Criterio de Exito:** Integridad de datos mantenida

#### Paso 3.3: Verificar Fixtures
```bash
# Verificar que fixtures cargan correctamente
pytest --fixtures

# Tests que dependen de fixtures
pytest -k "fixture" -v
```

**Criterio de Exito:** Fixtures disponibles y funcionales

---

### ETAPA 4: SUITE COMPLETA CON COBERTURA (20 minutos)

#### Paso 4.1: Ejecutar Suite Completa
```bash
# Ejecutar todos los tests con cobertura
pytest --cov=apps --cov-report=html --cov-report=term -v

# Guardar reporte en archivo
pytest --cov=apps --cov-report=html --cov-report=term -v > /tmp/test_report.txt 2>&1
```

**Criterio de Exito:** Suite completa ejecutada

#### Paso 4.2: Analizar Cobertura
```bash
# Ver resumen de cobertura
pytest --cov=apps --cov-report=term-missing

# Generar reporte HTML
pytest --cov=apps --cov-report=html
# Ver en: htmlcov/index.html
```

**Metricas esperadas:**
- Cobertura global: >= 80%
- Cobertura de modelos criticos: >= 95%
- Cobertura de APIs: >= 85%

#### Paso 4.3: Identificar Areas Sin Cobertura
```bash
# Ver lineas no cubiertas
pytest --cov=apps --cov-report=term-missing | grep -A 5 "TOTAL"

# Generar reporte detallado
coverage report -m > /tmp/coverage_detailed.txt
```

**Documentar:**
- Archivos con baja cobertura (< 70%)
- Funciones sin tests
- Branches no cubiertos

---

### ETAPA 5: VALIDACION Y REPORTES (10 minutos)

#### Paso 5.1: Verificar Resultados
```bash
# Resumen final
pytest --collect-only | grep "test session starts"
pytest -v --tb=no | tail -20
```

**Checklist de Validacion:**
- [ ] 0 tests fallidos
- [ ] 0 errores de sintaxis
- [ ] Cobertura >= 80%
- [ ] Todos los fixtures funcionales
- [ ] Sin warnings criticos

#### Paso 5.2: Generar Reporte de Tests
Crear documento:
```
docs/backend/testing/REPORTE-TESTS-YYYY-MM-DD.md
```

**Contenido minimo:**
- Fecha y hora de ejecucion
- Total de tests ejecutados
- Tests pasados/fallidos/skipped
- Cobertura por modulo
- Tiempo total de ejecucion
- Issues encontrados (si aplica)

#### Paso 5.3: Actualizar Metricas
Registrar en sistema de tracking:
- Numero total de tests
- Cobertura actual
- Trend de cobertura (vs semana anterior)
- Tiempo de ejecucion

---

### ETAPA 6: MANEJO DE FALLOS (Si aplica)

#### Paso 6.1: Analizar Tests Fallidos
Para cada test fallido:
```bash
# Ejecutar test individual con debug
pytest path/to/test_file.py::TestClass::test_method -vv --pdb
```

**Documentar:**
- Causa raiz del fallo
- Codigo afectado
- Prioridad de correccion

#### Paso 6.2: Crear Issues
Si fallos son criticos:
- Crear issue en sistema de tracking
- Etiquetar como: bug, tests, high-priority
- Asignar a desarrollador responsable

#### Paso 6.3: Bloquear Merge (Si aplica)
Si hay tests criticos fallando:
- NO aprobar Pull Request
- Marcar como "blocked"
- Notificar a Tech Lead

---

## 6. ARTEFACTOS GENERADOS

### 6.1 Reportes de Tests

| Archivo | Ubicacion | Formato |
|---------|-----------|---------|
| Reporte HTML | htmlcov/index.html | HTML |
| Reporte de cobertura | .coverage | Binary |
| Log de ejecucion | /tmp/test_report.txt | Text |
| Reporte detallado | docs/backend/testing/REPORTE-TESTS-YYYY-MM-DD.md | Markdown |

### 6.2 Metricas Capturadas

- Total de tests ejecutados
- Tests pasados/fallidos/skipped
- Cobertura por modulo (%)
- Tiempo de ejecucion (segundos)
- Lineas cubiertas/no cubiertas

---

## 7. CRITERIOS DE EXITO

### 7.1 Cuantitativos
- [ ] 100% de tests pasados (0 fallos)
- [ ] Cobertura global >= 80%
- [ ] Cobertura de codigo critico >= 95%
- [ ] Tiempo de ejecucion <= 5 minutos

### 7.2 Cualitativos
- [ ] Sin warnings criticos
- [ ] Fixtures funcionales
- [ ] Base de datos de test limpia
- [ ] Reportes generados correctamente

### 7.3 Metricas de Calidad
- [ ] Sin deprecation warnings
- [ ] Sin errores de importacion
- [ ] Sin tests skipped sin justificacion
- [ ] Documentacion de tests actualizada

---

## 8. VALIDACION POST-EJECUCION

### 8.1 Checklist de Validacion
- [ ] Suite completa ejecutada sin interrupciones
- [ ] Todos los tests pasaron exitosamente
- [ ] Cobertura verificada y documentada
- [ ] Reporte generado y almacenado
- [ ] Issues creados para fallos (si aplica)

### 8.2 Comandos de Validacion
```bash
# Verificar que no hay tests fallidos
pytest --collect-only -q | grep "test session"

# Verificar cobertura minima
coverage report | grep "TOTAL" | awk '{print $4}' | grep -E '^[89][0-9]%|^100%'

# Verificar que reporte existe
ls -lh htmlcov/index.html
```

---

## 9. ROLLBACK

### 9.1 Si Tests Fallan Despues de Cambios

**Accion Inmediata:**
```bash
# Revertir cambios no commiteados
git checkout -- .

# Si ya se hizo commit
git revert HEAD

# Volver a ejecutar tests
pytest -v
```

### 9.2 Si Base de Datos de Test Corrupta
```bash
# Recrear base de datos de test
python manage.py migrate --database=test --run-syncdb

# Recargar fixtures
python manage.py loaddata test_fixtures.json
```

### 9.3 Si Entorno Inconsistente
```bash
# Recrear entorno virtual
deactivate
rm -rf venv/
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

---

## 10. RIESGOS Y MITIGACIONES

### 10.1 Riesgos Tecnicos

| Riesgo | Probabilidad | Impacto | Mitigacion | Plan Contingencia |
|--------|-------------|---------|-----------|-------------------|
| Tests intermitentes (flaky) | ALTA | MEDIO | Aislar y documentar | Marcar como xfail temporalmente |
| Dependencias externas fallan | MEDIA | ALTO | Usar mocking | Verificar conectividad |
| Base de datos de test no limpia | MEDIA | MEDIO | Usar transaccional testing | Recrear DB de test |
| Timeout en tests lentos | BAJA | BAJO | Optimizar fixtures | Aumentar timeout |

### 10.2 Riesgos Organizacionales

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|-----------|
| Desarrollador omite tests | MEDIA | ALTO | Hooks de pre-commit |
| Tests no actualizados con codigo | ALTA | ALTO | Code review obligatorio |
| Cobertura falsa (tests vacios) | BAJA | ALTO | Revision de calidad de tests |

---

## 11. MEJORES PRACTICAS

### 11.1 Antes de Ejecutar
1. Actualizar codigo desde repositorio principal
2. Aplicar migraciones pendientes
3. Verificar que entorno esta limpio
4. Revisar cambios realizados

### 11.2 Durante Ejecucion
1. Ejecutar tests en orden (unitarios -> integracion)
2. No ignorar warnings
3. Documentar fallos inmediatamente
4. Verificar cobertura continuamente

### 11.3 Despues de Ejecutar
1. Revisar reporte de cobertura
2. Actualizar documentacion si es necesario
3. Crear issues para problemas encontrados
4. Notificar resultados a equipo

---

## 12. HERRAMIENTAS Y REFERENCIAS

### 12.1 Herramientas Requeridas
- Python 3.x
- pytest 7.x+
- pytest-django
- pytest-cov
- coverage.py
- Django testing framework

### 12.2 Comandos Utiles
```bash
# Ejecutar tests especificos
pytest apps/permissions/tests/test_models.py::TestPermissionModel::test_create

# Ejecutar tests con palabra clave
pytest -k "permission" -v

# Ejecutar solo tests modificados
pytest --testmon

# Ejecutar con profiling
pytest --profile

# Ejecutar en paralelo
pytest -n auto
```

### 12.3 Documentos Relacionados
- docs/backend/testing/GUIA-TESTING.md
- docs/backend/testing/FIXTURES.md
- docs/backend/lineamientos_codigo.md
- PROCED-BACK-002: Deployment a Staging

### 12.4 Referencias Externas
- pytest documentation: https://docs.pytest.org/
- Django testing: https://docs.djangoproject.com/en/stable/topics/testing/
- pytest-django: https://pytest-django.readthedocs.io/

---

## 13. CONTROL DE CAMBIOS

### Version 1.0.0 (2025-11-18)
- Creacion inicial del procedimiento
- Basado en estructura de proyecto IACT
- Incluye tests unitarios, integracion y cobertura
- 6 etapas definidas

### Proximas Versiones
- v1.1.0: Agregar tests de performance
- v1.2.0: Integracion con CI/CD pipeline
- v2.0.0: Tests automatizados con GitHub Actions

---

## 14. APROBACIONES

| Rol | Nombre | Firma | Fecha |
|-----|--------|-------|-------|
| Autor | Equipo Backend | ________ | 2025-11-18 |
| Revisor Tecnico | [Pendiente] | ________ | YYYY-MM-DD |
| Aprobador | Tech Lead | ________ | YYYY-MM-DD |

---

## 15. ANEXOS

### Anexo A: Checklist Rapido

**Pre-Ejecucion:**
- [ ] Entorno virtual activo
- [ ] Dependencias instaladas
- [ ] Variables de entorno configuradas
- [ ] Cache limpio

**Ejecucion:**
- [ ] Tests unitarios ejecutados
- [ ] Tests de integracion ejecutados
- [ ] Suite completa con cobertura
- [ ] Reportes generados

**Post-Ejecucion:**
- [ ] Todos los tests pasaron
- [ ] Cobertura >= 80%
- [ ] Reporte documentado
- [ ] Issues creados (si aplica)

### Anexo B: Ejemplo de Comando Completo
```bash
# Comando completo recomendado
pytest \
  --cov=apps \
  --cov-report=html \
  --cov-report=term-missing \
  --cov-fail-under=80 \
  --verbose \
  --tb=short \
  --strict-markers \
  --junit-xml=test-results.xml
```

### Anexo C: Tiempo Estimado por Etapa

| Etapa | Tiempo | Acumulado |
|-------|--------|-----------|
| Preparacion | 10 min | 10 min |
| Tests unitarios | 20 min | 30 min |
| Tests integracion | 15 min | 45 min |
| Suite completa | 20 min | 65 min |
| Validacion | 10 min | 75 min |

**Tiempo total estimado: 75 minutos**
**Con experiencia: 45-60 minutos**

---

**Procedimiento creado:** 2025-11-18
**Ultima revision:** 2025-11-18
**Proxima revision programada:** 2026-02-18 (3 meses)
**Estado:** ACTIVO
**Version:** 1.0.0
