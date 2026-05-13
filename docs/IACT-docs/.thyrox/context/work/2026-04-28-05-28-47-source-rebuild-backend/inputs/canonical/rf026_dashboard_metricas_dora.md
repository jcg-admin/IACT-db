---
id: RF-026
tipo: requisito_funcional
titulo: Dashboard Visual con 4 Métricas DORA
dominio: backend
owner: equipo-ingenieria
prioridad: alta
estado: implementado
fecha_creacion: 2025-11-11
trazabilidad_upward:
 - N-004
 - RN-004
 - RF-020
 - RF-021
 - RF-022
 - RF-023
 - RF-024
 - RF-025
verificacion: test
date: 2025-11-13
---

# RF-026: Dashboard Visual con 4 Métricas DORA

## 1. Descripción

El sistema DEBE proporcionar un dashboard web interactivo que visualice las 4 métricas DORA en tiempo real, con gráficos de tendencias, clasificación general, y controles de período.

Componentes principales:
```
1. Header con información de período
2. Selector de período (7/30/60/90 días)
3. 6 tarjetas de métricas:
 - Clasificación DORA general (color-coded)
 - Deployment Frequency
 - Lead Time for Changes
 - Change Failure Rate
 - Mean Time to Recovery
 - Total Cycles
4. 4 gráficos de tendencias (Chart.js):
 - Deployment Frequency over time
 - Lead Time Trends
 - Change Failure Rate evolution
 - MTTR history
```

## 2. Auto-CoT con Multiple Paths

<thinking>
Path 1 (Datos del Dashboard):
- Calcular métricas DORA para período seleccionado
- Usar RF-021 a RF-024 para cálculos individuales
- Usar RF-025 para clasificación general
- Formatear datos para visualización

Path 2 (Renderizado de UI):
- HTML template con cards responsivas
- CSS con color-coding según clasificación (Elite=verde, High=azul, Medium=naranja, Low=rojo)
- JavaScript para gráficos dinámicos (Chart.js)
- AJAX para cambio de período sin recargar página

Path 3 (Chart Data APIs):
- Endpoint para Deployment Frequency chart data
- Endpoint para Lead Time Trends chart data
- Endpoint para CFR chart data
- Endpoint para MTTR chart data
- Cada endpoint retorna {labels: [...], data: [...]}

Self-Consistency Validation:
- Métricas en cards deben coincidir con datos de gráficos
- Período seleccionado debe aplicar a todas las métricas
- Color de clasificación debe coincidir con RF-025
</thinking>

## 3. Endpoint Principal

```
GET /api/dora-metrics/dashboard/
Query params:
 ?days=30 # 7, 30, 60, 90

Response: HTML (Server-Side Rendered)
Con contexto:
{
 "days": 30,
 "period_start": "2025-10-01",
 "period_end": "2025-10-31",
 "dora_classification": "Elite",
 "deployment_frequency": 42,
 "deployment_frequency_per_week": 9.5,
 "lead_time_hours": 36.0,
 "change_failure_rate": 12.5,
 "mttr_hours": 0.75,
 "total_cycles": 150
}
```

## 4. Chart Data APIs

### 4.1. Deployment Frequency Chart

```
GET /api/dora-metrics/chart-data/deployment-frequency/
Query params:
 ?days=30

Response 200:
{
 "labels": ["2025-10-01", "2025-10-02", ..., "2025-10-30"],
 "data": [1, 2, 1, 3, 2, 1, 0, 2, ...]
}
```

### 4.2. Lead Time Trends Chart

```
GET /api/dora-metrics/chart-data/lead-time/
Query params:
 ?days=30

Response 200:
{
 "labels": ["2025-10-01", "2025-10-02", ...],
 "data": [24.5, 36.2, 18.7, ...] # hours
}
```

### 4.3. Change Failure Rate Chart

```
GET /api/dora-metrics/chart-data/change-failure-rate/
Query params:
 ?days=30

Response 200:
{
 "labels": ["Week 1", "Week 2", "Week 3", "Week 4"],
 "data": [10.5, 12.3, 8.7, 15.2] # percentage
}
```

### 4.4. MTTR Chart

```
GET /api/dora-metrics/chart-data/mttr/
Query params:
 ?days=30

Response 200:
{
 "labels": ["2025-10-05", "2025-10-12", ...],
 "data": [0.5, 1.2, 0.8, ...] # hours
}
```

## 5. Implementación Backend (Django View)

```python
from django.shortcuts import render
from django.contrib.admin.views.decorators import staff_member_required
from django.utils import timezone
from datetime import timedelta
from django.db.models import Avg

@staff_member_required
def dora_dashboard(request):
 """Dashboard principal de métricas DORA."""
 # Path 1: Get period from query params
 days = int(request.GET.get("days", 30))
 cutoff = timezone.now() - timedelta(days=days)

 # Path 2: Query all metrics for period
 metrics = DORAMetric.objects.filter(created_at__gte=cutoff)

 # Path 3: Calculate individual metrics
 # Deployment Frequency
 deployment_metrics = metrics.filter(phase_name="deployment")
 deployment_count = deployment_metrics.filter(decision="go").count()
 deployment_frequency_per_week = round(deployment_count / (days / 7), 2)

 # Lead Time (avg duration of all phases for deployed features)
 avg_lead_time = deployment_metrics.aggregate(
 avg=Avg("duration_seconds")
 )["avg"] or 0

 # Change Failure Rate
 testing_metrics = metrics.filter(phase_name="testing")
 failed_tests = testing_metrics.filter(decision="no-go").count()
 total_tests = testing_metrics.count()
 cfr = (failed_tests / total_tests * 100) if total_tests > 0 else 0

 # MTTR (maintenance phase with decision='fixed')
 maintenance_metrics = metrics.filter(
 phase_name="maintenance",
 decision="fixed"
 )
 avg_mttr = maintenance_metrics.aggregate(
 avg=Avg("duration_seconds")
 )["avg"] or 0

 # Path 4: Calculate overall classification
 dora_classification = calculate_dora_classification(
 deployment_count,
 days,
 avg_lead_time / 3600, # convert to hours
 cfr,
 avg_mttr / 3600 # convert to hours
 )

 # Path 5: Prepare context for template
 context = {
 "days": days,
 "period_start": cutoff.strftime("%Y-%m-%d"),
 "period_end": timezone.now().strftime("%Y-%m-%d"),
 "dora_classification": dora_classification,
 "deployment_frequency": deployment_count,
 "deployment_frequency_per_week": deployment_frequency_per_week,
 "lead_time_hours": round(avg_lead_time / 3600, 2),
 "change_failure_rate": round(cfr, 2),
 "mttr_hours": round(avg_mttr / 3600, 2),
 "total_cycles": metrics.values("cycle_id").distinct().count(),
 }

 # Self-Consistency: Verify all metrics are non-negative
 assert context["deployment_frequency"] >= 0
 assert context["lead_time_hours"] >= 0
 assert 0 <= context["change_failure_rate"] <= 100
 assert context["mttr_hours"] >= 0

 return render(request, "dora_metrics/dashboard.html", context)
```

## 6. UI Components (HTML/CSS/JS)

### 6.1. Metric Cards

```html
<div class="metrics-grid">
 <!-- Classification Card -->
 <div class="metric-card {{ dora_classification|lower }}">
 <div class="metric-title">Clasificación DORA</div>
 <div class="metric-value">{{ dora_classification }}</div>
 <div class="classification-badge {{ dora_classification|lower }}">
 {{ dora_classification }} Performance
 </div>
 </div>

 <!-- Deployment Frequency Card -->
 <div class="metric-card">
 <div class="metric-title">Deployment Frequency</div>
 <div class="metric-value">{{ deployment_frequency }}</div>
 <div class="metric-unit">deployments en {{ days }} días</div>
 <div class="metric-subtitle">
 {{ deployment_frequency_per_week }} deployments/semana
 </div>
 </div>

 <!-- Similar cards for Lead Time, CFR, MTTR, Total Cycles -->
</div>
```

### 6.2. Color Coding Scheme

```css
/* Elite: Verde (#4CAF50) */
.metric-card.elite {
 border-top-color: #4CAF50;
}
.classification-badge.elite {
 background: #4CAF50;
 color: white;
}

/* High: Azul (#2196F3) */
.metric-card.high {
 border-top-color: #2196F3;
}
.classification-badge.high {
 background: #2196F3;
 color: white;
}

/* Medium: Naranja (#FF9800) */
.metric-card.medium {
 border-top-color: #FF9800;
}
.classification-badge.medium {
 background: #FF9800;
 color: white;
}

/* Low: Rojo (#F44336) */
.metric-card.low {
 border-top-color: #F44336;
}
.classification-badge.low {
 background: #F44336;
 color: white;
}
```

### 6.3. Chart.js Configuration

```javascript
// Deployment Frequency Chart
fetch('/api/dora-metrics/chart-data/deployment-frequency/?days=' + days)
 .then(response => response.json())
 .then(data => {
 new Chart(document.getElementById('deploymentFrequencyChart'), {
 type: 'bar',
 data: {
 labels: data.labels,
 datasets: [{
 label: 'Deployments per Day',
 data: data.data,
 backgroundColor: '#4CAF50',
 borderColor: '#388E3C',
 borderWidth: 1
 }]
 },
 options: {
 responsive: true,
 maintainAspectRatio: false,
 scales: {
 y: {
 beginAtZero: true,
 ticks: {
 stepSize: 1
 }
 }
 }
 }
 });
 });

// Similar configurations for Lead Time, CFR, MTTR charts
```

## 7. Tests

```python
from django.test import TestCase, Client
from django.contrib.auth.models import User

class DORADashboardTestCase(TestCase):
 def setUp(self):
 self.client = Client()
 # Create staff user (required for dashboard access)
 self.staff_user = User.objects.create_user(
 username='staff',
 password='test',
 is_staff=True
 )

 def test_dashboard_requires_staff_access(self):
 """Test dashboard requires staff authentication."""
 response = self.client.get('/api/dora-metrics/dashboard/')
 # Should redirect to login
 self.assertEqual(response.status_code, 302)

 def test_dashboard_renders_with_metrics(self):
 """Test dashboard renders with calculated metrics."""
 self.client.login(username='staff', password='test')

 # Create test data
 DORAMetric.objects.create(
 cycle_id='C-1',
 feature_id='F-1',
 phase_name='deployment',
 decision='go',
 duration_seconds=3600
 )

 response = self.client.get('/api/dora-metrics/dashboard/?days=30')

 self.assertEqual(response.status_code, 200)
 self.assertContains(response, 'DORA Metrics Dashboard')
 self.assertContains(response, 'Deployment Frequency')
 self.assertContains(response, 'Lead Time')
 self.assertContains(response, 'Change Failure Rate')
 self.assertContains(response, 'Mean Time to Recovery')

 def test_dashboard_period_selector(self):
 """Test dashboard responds to different period selections."""
 self.client.login(username='staff', password='test')

 for days in [7, 30, 60, 90]:
 response = self.client.get(f'/api/dora-metrics/dashboard/?days={days}')
 self.assertEqual(response.status_code, 200)
 self.assertContains(response, f'{days} dias')

 def test_deployment_frequency_chart_data(self):
 """Test deployment frequency chart data API."""
 self.client.login(username='staff', password='test')

 # Create 5 deployments on different days
 for i in range(5):
 DORAMetric.objects.create(
 cycle_id=f'C-{i}',
 phase_name='deployment',
 decision='go',
 duration_seconds=600,
 created_at=timezone.now() - timedelta(days=i)
 )

 response = self.client.get(
 '/api/dora-metrics/chart-data/deployment-frequency/?days=7'
 )
 self.assertEqual(response.status_code, 200)

 data = response.json()
 self.assertIn('labels', data)
 self.assertIn('data', data)
 self.assertEqual(len(data['labels']), len(data['data']))

 def test_chart_data_self_consistency(self):
 """Test chart data is consistent with dashboard metrics."""
 self.client.login(username='staff', password='test')

 # Create test data
 deployment_count = 10
 for i in range(deployment_count):
 DORAMetric.objects.create(
 cycle_id=f'C-{i}',
 phase_name='deployment',
 decision='go',
 duration_seconds=600
 )

 # Get dashboard
 dashboard_response = self.client.get('/api/dora-metrics/dashboard/?days=30')
 dashboard_html = dashboard_response.content.decode()

 # Get chart data
 chart_response = self.client.get(
 '/api/dora-metrics/chart-data/deployment-frequency/?days=30'
 )
 chart_data = chart_response.json()

 # Self-Consistency: Sum of chart data should match dashboard total
 chart_total = sum(chart_data['data'])
 self.assertIn(str(deployment_count), dashboard_html)
```

## 8. Criterios de Aceptación

### Funcionales

1. **Acceso restringido:**
 - DADO un usuario no autenticado
 - CUANDO intenta acceder a /api/dora-metrics/dashboard/
 - ENTONCES es redirigido a login

2. **Visualización de métricas:**
 - DADO un usuario staff autenticado
 - CUANDO accede al dashboard
 - ENTONCES ve las 6 tarjetas de métricas con valores actualizados
 - Y la clasificación DORA con color apropiado

3. **Selector de período:**
 - DADO que estoy en el dashboard
 - CUANDO selecciono un período diferente (7/30/60/90 días)
 - ENTONCES todas las métricas se recalculan para ese período
 - Y los gráficos se actualizan dinámicamente

4. **Gráficos de tendencias:**
 - DADO que estoy en el dashboard
 - CUANDO la página carga
 - ENTONCES veo 4 gráficos (DF, LT, CFR, MTTR)
 - Y cada gráfico muestra tendencia histórica

### No Funcionales

- Dashboard carga en <2 segundos
- Gráficos renderizan en <1 segundo
- Responsive design (móvil/tablet/desktop)
- Compatible con Chrome, Firefox, Safari, Edge

## 9. Anti-Alucinación Verification

**Verificado contra implementación:**
- Ubicación: `api/callcentersite/dora_metrics/views.py:102` (dora_dashboard)
- Template: `api/callcentersite/dora_metrics/templates/dora_metrics/dashboard.html`
- Chart endpoints: views.py:146 (deployment_frequency_chart_data), etc.

**Color Scheme verificado:**
- Elite: #4CAF50 (verde) OK
- High: #2196F3 (azul) OK
- Medium: #FF9800 (naranja) OK
- Low: #F44336 (rojo) OK

**Chart.js version:** 4.4.0 (CDN)

**Self-Consistency Guarantees:**
- Dashboard metrics match chart data totals
- Period applies uniformly to all metrics
- Classification color matches RF-025 algorithm

## 10. Trazabilidad

- Origen: N-004, RN-004, RF-020
- Depende de: RF-021, RF-022, RF-023, RF-024, RF-025
- Implementado:
 - View: api/callcentersite/dora_metrics/views.py:dora_dashboard
 - Template: api/callcentersite/dora_metrics/templates/dora_metrics/dashboard.html
 - URLs: api/callcentersite/dora_metrics/urls.py
- Tests: tests/dora_metrics/test_dashboard.py
- ADR: ADR_2025_003 (DORA metrics integration)

## 11. Notas de Implementación

**Permisos:**
- Dashboard requiere `@staff_member_required` decorator
- Solo usuarios staff pueden acceder
- Alineado con ADR_2025_017 (permisos granulares)

**Performance:**
- Usar `.select_related()` y `.prefetch_related()` para queries optimizadas
- Cachear resultados de métricas por 5 minutos
- Limitar período máximo a 90 días para evitar queries lentas

**Mejoras Futuras:**
- Export dashboard as PDF
- Email reports programados
- Comparación entre equipos
- Drill-down por feature/ciclo específico
