---
id: TASK-014-custom-dashboards-admin
tipo: documentacion_features
categoria: features
prioridad: P2
story_points: 5
estado: completado
fecha_inicio: 2025-11-07
fecha_fin: 2025-11-07
asignado: backend-lead
relacionados: ["TASK-005", "TASK-011", "TASK-013"]
---

# TASK-014: Custom Dashboards Django Admin

Implementacion de dashboards personalizados en Django Admin para visualizacion en tiempo real de metricas DORA.

## Contexto

El proyecto IACT requiere un dashboard interactivo para monitorear metricas DORA (DevOps Research and Assessment) en tiempo real. Este dashboard permite al equipo:
- Visualizar estado actual de metricas DORA
- Analizar tendencias historicas
- Tomar decisiones basadas en datos
- Cumplir con objetivos de DevOps Performance


## Técnicas de Prompt Engineering para Agente

Las siguientes técnicas deben aplicarse al ejecutar esta tarea con un agente:

1. **Code Generation** (fundamental_techniques.py)
   - Generar codigo base para nuevas features y componentes

2. **Task Decomposition** (structuring_techniques.py)
   - Dividir features en user stories y tareas implementables

3. **Few-Shot** (fundamental_techniques.py)
   - Usar ejemplos de features similares como referencia

4. **Expert Prompting** (specialized_techniques.py)
   - Aplicar patrones de diseno y mejores practicas de desarrollo

5. **Meta-prompting** (structuring_techniques.py)
   - Generar prompts especializados para diferentes aspectos de la feature

Agente recomendado: FeatureAgent o SDLCDesignAgent
## Objetivos

1. Implementar dashboard principal de metricas DORA
2. Crear widgets de metricas en tiempo real
3. Implementar graficos interactivos con Chart.js
4. Mostrar 4 metricas clave DORA
5. Calcular clasificacion DORA (Elite, High, Medium, Low)
6. Permitir filtrado por periodo (7, 30, 60, 90 dias)

## Metricas DORA Implementadas

### 1. Deployment Frequency

**Definicion:** Frecuencia de deployments a produccion

**Calculo:** Count de registros con `phase_name='deployment'` en periodo

**Visualizacion:**
- Widget: Total deployments y deployments/semana
- Grafico: Bar chart por dia

**Clasificacion:**
- Elite: mayor a 1/dia (mayor a 7/semana)
- High: 1/semana a 1/mes
- Medium: 1/mes a 1/6meses
- Low: menor a 1/6meses

### 2. Lead Time for Changes

**Definicion:** Tiempo desde commit hasta produccion

**Calculo:** Promedio de `duration_seconds` para `phase_name='deployment'`

**Visualizacion:**
- Widget: Horas promedio
- Grafico: Line chart de tendencias

**Clasificacion:**
- Elite: menor a 1 hora
- High: 1 hora a 1 dia
- Medium: 1 dia a 1 semana
- Low: mayor a 1 semana

### 3. Change Failure Rate

**Definicion:** Porcentaje de cambios que requieren rollback o fix

**Calculo:** `(failed_tests / total_tests) * 100` donde `decision='no-go'`

**Visualizacion:**
- Widget: Porcentaje
- Grafico: Line chart de CFR a lo largo del tiempo

**Clasificacion:**
- Elite: menor a 5%
- High: 5-10%
- Medium: 10-15%
- Low: mayor a 15%

### 4. Mean Time to Recovery (MTTR)

**Definicion:** Tiempo promedio para recuperarse de una falla

**Calculo:** Promedio de `duration_seconds` para `phase_name='maintenance'` y `decision='fixed'`

**Visualizacion:**
- Widget: Horas promedio
- Grafico: Line chart de MTTR a lo largo del tiempo

**Clasificacion:**
- Elite: menor a 1 hora
- High: 1 hora a 1 dia
- Medium: 1 dia a 1 semana
- Low: mayor a 1 semana

## Arquitectura

### Componentes

```
dora_metrics/
├── views.py                  # Views de dashboard y APIs
├── urls.py                   # URLs de dashboard y chart endpoints
├── admin.py                  # Admin basico de DORAMetric
├── models.py                 # Modelo DORAMetric
└── templates/
    └── dora_metrics/
        └── dashboard.html    # Template del dashboard
```

### Views Implementadas

#### 1. dora_dashboard(request)

**Ruta:** `/api/dora/dashboard/`

**Funcion:** Renderiza dashboard principal con metricas agregadas

**Parametros:**
- `days` (query param): Periodo en dias (default: 30)

**Retorna:** HTML template con contexto

**Contexto:**
```python
{
    'days': 30,
    'lead_time_hours': 12.5,
    'deployment_frequency': 45,
    'deployment_frequency_per_week': 10.5,
    'change_failure_rate': 8.2,
    'mttr_hours': 2.3,
    'total_cycles': 120,
    'dora_classification': 'High',
    'period_start': '2025-10-08',
    'period_end': '2025-11-07'
}
```

#### 2. deployment_frequency_chart_data(request)

**Ruta:** `/api/dora/charts/deployment-frequency/`

**Funcion:** API endpoint para datos de grafico de deployment frequency

**Retorna:** JSON con labels y data para Chart.js

```json
{
  "labels": ["2025-11-01", "2025-11-02", ...],
  "data": [3, 5, 2, 7, ...]
}
```

#### 3. lead_time_trends_chart_data(request)

**Ruta:** `/api/dora/charts/lead-time-trends/`

**Funcion:** API endpoint para datos de grafico de lead time trends

**Retorna:** JSON con lead time promedio por dia (en horas)

#### 4. change_failure_rate_chart_data(request)

**Ruta:** `/api/dora/charts/change-failure-rate/`

**Funcion:** API endpoint para datos de grafico de CFR

**Retorna:** JSON con CFR porcentual por dia

#### 5. mttr_chart_data(request)

**Ruta:** `/api/dora/charts/mttr/`

**Funcion:** API endpoint para datos de grafico de MTTR

**Retorna:** JSON con MTTR promedio por dia (en horas)

### Calculo de Clasificacion DORA

Funcion `calculate_dora_classification()`:

```python
def calculate_dora_classification(deployment_count, days, lead_time_hours, cfr, mttr_hours):
    # Criterios DORA 2024
    # Cuenta cuantas metricas estan en cada nivel (Elite, High, Medium, Low)
    # Clasificacion general basada en mayoria

    if elite_count >= 3:
        return "Elite"
    elif high_count >= 2:
        return "High"
    elif medium_count >= 2:
        return "Medium"
    else:
        return "Low"
```

**Logica:**
- Evalua cada una de las 4 metricas segun criterios DORA
- Si 3+ metricas son Elite → clasificacion Elite
- Si 2+ metricas son High → clasificacion High
- Si 2+ metricas son Medium → clasificacion Medium
- Caso contrario → clasificacion Low

## Template HTML

### Estructura

```html
<!DOCTYPE html>
<html>
  <head>
    <!-- Chart.js desde CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <!-- CSS custom inline -->
  </head>
  <body>
    <div class="container">
      <header>...</header>

      <div class="controls">
        <!-- Selector de periodo -->
      </div>

      <div class="metrics-grid">
        <!-- 6 cards de metricas -->
      </div>

      <div class="charts-grid">
        <!-- 4 graficos interactivos -->
      </div>
    </div>

    <script>
      <!-- JavaScript para cargar datos y renderizar graficos -->
    </script>
  </body>
</html>
```

### Widgets de Metricas

Cada widget muestra:
- Titulo de metrica
- Valor principal (grande y destacado)
- Unidad
- Subtitulo explicativo
- Color de borde segun clasificacion

**Colores:**
- Elite: Verde (#4CAF50)
- High: Azul (#2196F3)
- Medium: Naranja (#FF9800)
- Low: Rojo (#F44336)

### Graficos

**Tipo de graficos:**
1. Deployment Frequency: Bar chart (barras)
2. Lead Time Trends: Line chart (linea)
3. Change Failure Rate: Line chart (linea)
4. MTTR: Line chart (linea)

**Configuracion Chart.js:**
- Responsive y maintainAspectRatio: false
- Sin legend (solo un dataset)
- Eje Y comenzando en 0
- Altura fija de 300px

## Uso

### Acceder al Dashboard

1. **URL directa:**
   ```
   http://localhost:8000/api/dora/dashboard/
   ```

2. **Filtrar por periodo:**
   ```
   http://localhost:8000/api/dora/dashboard/?days=7
   http://localhost:8000/api/dora/dashboard/?days=30
   http://localhost:8000/api/dora/dashboard/?days=60
   http://localhost:8000/api/dora/dashboard/?days=90
   ```

3. **Selector de periodo:**
   - Usar dropdown en la interfaz
   - Cambia automaticamente la URL

### Interpretar Metricas

**Clasificacion Elite:**
- Objetivo: Alcanzar Elite en las 4 metricas
- Indica DevOps Performance de clase mundial
- Requiere:
  - Deployments multiples por dia
  - Lead time menor a 1 hora
  - CFR menor a 5%
  - MTTR menor a 1 hora

**Clasificacion High:**
- Buen performance DevOps
- Oportunidades de mejora hacia Elite
- Deployments al menos semanales
- Lead time menor a 1 dia

**Clasificacion Medium:**
- Performance promedio
- Requiere optimizaciones significativas
- Deployments mensuales
- Lead time menor a 1 semana

**Clasificacion Low:**
- Performance bajo
- Requiere transformacion DevOps
- Deployments infrecuentes
- Lead time mayor a 1 semana

## Datos de Ejemplo

Para poblar el dashboard con datos de prueba:

```python
# Crear metricas de ejemplo
from dora_metrics.models import DORAMetric
from django.utils import timezone
from datetime import timedelta

# Deployment metrics
for i in range(30):
    DORAMetric.objects.create(
        cycle_id=f"cycle-{i}",
        feature_id=f"feature-{i}",
        phase_name="deployment",
        decision="go",
        duration_seconds=3600 * (i % 24),  # Varia de 0 a 23 horas
        created_at=timezone.now() - timedelta(days=30-i)
    )

# Testing metrics
for i in range(50):
    decision = "go" if i % 10 != 0 else "no-go"  # 10% failure rate
    DORAMetric.objects.create(
        cycle_id=f"cycle-{i}",
        feature_id=f"feature-{i}",
        phase_name="testing",
        decision=decision,
        duration_seconds=1800,
        created_at=timezone.now() - timedelta(days=30-i%30)
    )

# Maintenance metrics (MTTR)
for i in range(10):
    DORAMetric.objects.create(
        cycle_id=f"cycle-{i}",
        feature_id=f"feature-{i}",
        phase_name="maintenance",
        decision="fixed",
        duration_seconds=7200 + (i * 600),  # 2-3.5 horas
        created_at=timezone.now() - timedelta(days=30-i*3)
    )
```

## Integracion con Django Admin

### Registrar en Admin

El modelo `DORAMetric` ya esta registrado en Django Admin:

```python
@admin.register(DORAMetric)
class DORAMetricAdmin(admin.ModelAdmin):
    list_display = ["cycle_id", "feature_id", "phase_name", "decision", "created_at"]
    list_filter = ["phase_name", "decision", "created_at"]
    search_fields = ["cycle_id", "feature_id"]
    readonly_fields = ["created_at"]
```

### Agregar Link al Dashboard

Para agregar link en Django Admin navigation:

```python
# En dora_metrics/admin.py
from django.urls import reverse
from django.utils.html import format_html

class DORAMetricAdmin(admin.ModelAdmin):
    # ... existing config ...

    def changelist_view(self, request, extra_context=None):
        extra_context = extra_context or {}
        extra_context['dashboard_url'] = reverse('dora-dashboard')
        return super().changelist_view(request, extra_context=extra_context)
```

## Compliance

### RNF-002: Restricciones Tecnologicas

**Cumplimiento:**
- NO usa Prometheus (metricas en MySQL)
- NO usa Grafana (dashboard custom Django)
- NO usa Redis (sesiones en database)
- Visualizacion self-hosted con Chart.js CDN

### DORA 2025 AI Capabilities

**Capability 6: AI-accessible Internal Data**
- APIs JSON para metricas (parseable por IA)
- Estructura de datos consistente
- Endpoints RESTful

**Capability 7: Healthy Data Ecosystems**
- Datos centralizados en MySQL
- Modelo de datos limpio (DORAMetric)
- Agregaciones consistentes

## Performance

### Optimizaciones

1. **Database Indexes:**
   ```python
   class Meta:
       indexes = [
           models.Index(fields=['phase_name']),
           models.Index(fields=['created_at']),
           models.Index(fields=['feature_id']),
       ]
   ```

2. **Query Optimization:**
   - Usa `aggregate()` en lugar de iteraciones Python
   - Filtra por fecha antes de agregar
   - Usa `values()` para reducir memoria

3. **Caching (futuro):**
   - Cache de metricas agregadas (5 minutos)
   - Cache de datos de graficos (1 minuto)
   - Invalidacion al crear nueva metrica

### Tiempos Esperados

- Dashboard load: menor a 2 segundos
- Chart data API: menor a 500ms
- Query de metricas: menor a 100ms

## Testing

### Test Manual

```bash
# 1. Acceder al dashboard
curl http://localhost:8000/api/dora/dashboard/?days=30

# 2. Test chart endpoints
curl http://localhost:8000/api/dora/charts/deployment-frequency/?days=30
curl http://localhost:8000/api/dora/charts/lead-time-trends/?days=30
curl http://localhost:8000/api/dora/charts/change-failure-rate/?days=30
curl http://localhost:8000/api/dora/charts/mttr/?days=30

# 3. Verificar JSON valido
curl http://localhost:8000/api/dora/charts/deployment-frequency/?days=30 | jq .
```

### Test de Clasificacion

```python
from dora_metrics.views import calculate_dora_classification

# Test Elite
result = calculate_dora_classification(
    deployment_count=70,  # 10/semana
    days=30,
    lead_time_hours=0.5,  # 30 min
    cfr=3,  # 3%
    mttr_hours=0.8  # 48 min
)
assert result == "Elite"

# Test High
result = calculate_dora_classification(
    deployment_count=15,  # 3.5/semana
    days=30,
    lead_time_hours=12,
    cfr=7,
    mttr_hours=8
)
assert result == "High"
```

## Troubleshooting

### Problema: Dashboard vacio

**Causa:** No hay datos en tabla dora_metrics

**Solucion:**
```python
# Verificar datos
from dora_metrics.models import DORAMetric
print(DORAMetric.objects.count())

# Si count = 0, crear datos de prueba (ver seccion Datos de Ejemplo)
```

### Problema: Graficos no cargan

**Causa:** Error en fetch() de APIs

**Solucion:**
1. Abrir DevTools > Console
2. Verificar errores de red
3. Verificar URLs de APIs son correctas
4. Test manual de API endpoints con curl

### Problema: Chart.js no carga

**Causa:** CDN bloqueado o error de red

**Solucion:**
```html
<!-- Cambiar a version local -->
<script src="/static/js/chart.min.js"></script>

<!-- O usar otro CDN -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js"></script>
```

## Proximos Pasos

### Q1 2026

1. **Autenticacion:**
   - Requerir login para acceder al dashboard
   - Usar `@login_required` decorator

2. **Exportacion:**
   - Export a PDF
   - Export a CSV
   - API para Slack/Teams notifications

3. **Alertas:**
   - Alertas cuando metricas degradan
   - Notificaciones cuando clasificacion baja

### Q2 2026

1. **Predictive Analytics:**
   - Forecasting de metricas (ML)
   - Prediccion de clasificacion futura

2. **Comparativas:**
   - Comparar periodos (mes actual vs anterior)
   - Benchmarking con industria

3. **Drill-down:**
   - Click en metrica para ver detalles
   - Vista de ciclos individuales
   - Filtrado por feature_id

## Referencias

### Documentos Relacionados

- [TASK-005: Sistema de Metrics Interno MySQL](../backend/TASK-005-sistema-metrics-mysql.md)
- [TASK-011: Data Centralization Layer](../arquitectura/TASK-011-data-centralization-layer.md)
- [TASK-013: Cron Jobs Maintenance](../operaciones/TASK-013-cron-jobs-maintenance.md)
- [DORA Metrics Guide](https://dora.dev/quickcheck/)

### Codigo

```bash
api/callcentersite/dora_metrics/
├── views.py                          # Dashboard y chart APIs
├── urls.py                           # URLs configuradas
├── admin.py                          # Django Admin config
├── models.py                         # DORAMetric model
└── templates/dora_metrics/
    └── dashboard.html                # Dashboard template
```

### APIs Externas

- Chart.js: https://www.chartjs.org/
- Chart.js CDN: https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js

## Criterios de Aceptacion

- [COMPLETADO] Dashboard principal implementado
- [COMPLETADO] 6 widgets de metricas (clasificacion + 4 DORA + total cycles)
- [COMPLETADO] 4 graficos interactivos con Chart.js
- [COMPLETADO] Deployment frequency chart (bar)
- [COMPLETADO] Lead time trends chart (line)
- [COMPLETADO] Change failure rate chart (line)
- [COMPLETADO] MTTR chart (line)
- [COMPLETADO] Calculo de clasificacion DORA
- [COMPLETADO] Filtrado por periodo (7, 30, 60, 90 dias)
- [COMPLETADO] APIs JSON para datos de graficos
- [COMPLETADO] Template HTML responsive
- [COMPLETADO] Sin uso de Prometheus/Grafana (RNF-002)

## Resultados

**Estado:** COMPLETADO

**Fecha de completacion:** 2025-11-07

**Componentes implementados:**
1. Dashboard view en /api/dora/dashboard/
2. 4 chart data APIs
3. Template HTML con Chart.js
4. Funcion de clasificacion DORA
5. URLs configuradas

**Metricas visualizadas:**
- Deployment Frequency
- Lead Time for Changes
- Change Failure Rate
- Mean Time to Recovery
- DORA Classification
- Total Cycles

**Impacto:**
- Visibilidad en tiempo real de metricas DORA
- Identificacion rapida de areas de mejora
- Data-driven decision making
- Compliance con DORA 2025 AI Capabilities

---

**VERSION:** 1.0.0
**ESTADO:** COMPLETADO
**STORY POINTS:** 5 SP
**ASIGNADO:** backend-lead
**FECHA:** 2025-11-07
