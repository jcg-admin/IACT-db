---
id: RF-027
tipo: requisito_funcional
titulo: Exportar Reportes DORA (CSV/Excel/PDF)
dominio: backend
owner: equipo-ingenieria
prioridad: media
estado: no_implementado
fecha_creacion: 2025-11-11
trazabilidad_upward:
 - N-004
 - RN-004
 - RF-020
 - RF-025
 - RF-026
verificacion: test
date: 2025-11-13
---

# RF-027: Exportar Reportes DORA (CSV/Excel/PDF)

## 1. Descripción

El sistema DEBE permitir exportar reportes de métricas DORA en múltiples formatos (CSV, Excel, PDF) para análisis externo, presentaciones a stakeholders, y auditorías de compliance.

Formatos soportados:
```
1. CSV: Datos tabulares de métricas (machine-readable)
2. Excel (.xlsx): Datos con formato, gráficos embebidos, múltiples hojas
3. PDF: Reporte ejecutivo con visualizaciones (executive summary)
```

Tipos de reporte:
```
1. Summary Report: Métricas agregadas del período
2. Detailed Report: Datos granulares por ciclo/feature
3. Trend Report: Evolución histórica de métricas
4. Comparison Report: Comparación entre períodos
```

## 2. Auto-CoT con Multiple Paths

<thinking>
Path 1 (Formato CSV):
- Generar tabla con columnas: date, deployment_frequency, lead_time, cfr, mttr, classification
- Incluir metadata: period, total_cycles, generated_at
- Usar Python csv module
- MIME type: text/csv

Path 2 (Formato Excel):
- Usar openpyxl library
- Hoja 1: Summary metrics
- Hoja 2: Detailed data (todas las métricas por día)
- Hoja 3: Charts (gráficos embebidos)
- Aplicar estilos: color-coding según clasificación DORA

Path 3 (Formato PDF):
- Usar reportlab o WeasyPrint
- Sección 1: Executive Summary (clasificación, KPIs)
- Sección 2: Metric Details (4 métricas DORA con gráficos)
- Sección 3: Recommendations (basado en clasificación)
- Footer: Generated timestamp, IACT branding

Self-Consistency Validation:
- Los 3 formatos deben contener mismos datos numéricos
- Período debe ser consistente en metadata
- Clasificación DORA debe coincidir con RF-025
</thinking>

## 3. Endpoints API

### 3.1. Export CSV

```
GET /api/dora-metrics/export/csv/
Query params:
 ?start_date=2025-10-01
 &end_date=2025-10-31
 &report_type=summary # summary, detailed, trend

Response 200:
Content-Type: text/csv
Content-Disposition: attachment; filename="dora_metrics_2025-10-01_2025-10-31.csv"

date,deployment_frequency,lead_time_hours,change_failure_rate,mttr_hours,classification
2025-10-01,2,24.5,10.2,0.8,High
2025-10-02,1,36.2,12.3,1.2,High
...
```

### 3.2. Export Excel

```
GET /api/dora-metrics/export/excel/
Query params:
 ?start_date=2025-10-01
 &end_date=2025-10-31
 &include_charts=true

Response 200:
Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
Content-Disposition: attachment; filename="dora_metrics_2025-10-01_2025-10-31.xlsx"

[Binary Excel file with 3 sheets:
 Sheet 1: "Summary"
 Sheet 2: "Daily Metrics"
 Sheet 3: "Charts"
]
```

### 3.3. Export PDF

```
GET /api/dora-metrics/export/pdf/
Query params:
 ?start_date=2025-10-01
 &end_date=2025-10-31
 &template=executive # executive, detailed

Response 200:
Content-Type: application/pdf
Content-Disposition: attachment; filename="dora_report_2025-10-01_2025-10-31.pdf"

[Binary PDF file with:
 - Cover page with IACT branding
 - Executive Summary
 - 4 Metric Details pages
 - Recommendations page
]
```

## 4. Implementación

### 4.1. CSV Export

```python
import csv
from django.http import HttpResponse
from datetime import datetime

@staff_member_required
def export_csv(request):
 """Export DORA metrics as CSV."""
 # Path 1: Get parameters
 start_date = request.GET.get('start_date')
 end_date = request.GET.get('end_date')
 report_type = request.GET.get('report_type', 'summary')

 # Path 2: Calculate metrics
 if report_type == 'summary':
 # Aggregate metrics for entire period
 metrics_data = calculate_summary_metrics(start_date, end_date)
 elif report_type == 'detailed':
 # Daily breakdown
 metrics_data = calculate_daily_metrics(start_date, end_date)
 elif report_type == 'trend':
 # Weekly/monthly trends
 metrics_data = calculate_trend_metrics(start_date, end_date)

 # Path 3: Generate CSV
 response = HttpResponse(content_type='text/csv')
 response['Content-Disposition'] = \
 f'attachment; filename="dora_metrics_{start_date}_{end_date}.csv"'

 writer = csv.writer(response)

 # Write metadata header
 writer.writerow(['# DORA Metrics Report'])
 writer.writerow(['# Period:', f'{start_date} to {end_date}'])
 writer.writerow(['# Generated:', datetime.now().isoformat()])
 writer.writerow([]) # blank line

 # Write data header
 writer.writerow([
 'Date',
 'Deployment Frequency',
 'Lead Time (hours)',
 'Change Failure Rate (%)',
 'MTTR (hours)',
 'Classification'
 ])

 # Write data rows
 for row in metrics_data:
 writer.writerow([
 row['date'],
 row['deployment_frequency'],
 round(row['lead_time_hours'], 2),
 round(row['cfr'], 2),
 round(row['mttr_hours'], 2),
 row['classification']
 ])

 # Self-Consistency: Verify all rows have same number of columns
 return response
```

### 4.2. Excel Export

```python
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment
from openpyxl.chart import BarChart, Reference
from django.http import HttpResponse
import io

@staff_member_required
def export_excel(request):
 """Export DORA metrics as Excel with charts."""
 start_date = request.GET.get('start_date')
 end_date = request.GET.get('end_date')
 include_charts = request.GET.get('include_charts', 'true') == 'true'

 # Calculate metrics
 summary = calculate_summary_metrics(start_date, end_date)
 daily_data = calculate_daily_metrics(start_date, end_date)

 # Create workbook
 wb = Workbook()

 # Sheet 1: Summary
 ws_summary = wb.active
 ws_summary.title = "Summary"

 # Header styling
 header_font = Font(bold=True, size=14, color="FFFFFF")
 header_fill = PatternFill(start_color="4CAF50", end_color="4CAF50", fill_type="solid")

 ws_summary['A1'] = 'DORA Metrics Summary'
 ws_summary['A1'].font = header_font
 ws_summary['A1'].fill = header_fill

 ws_summary['A2'] = f'Period: {start_date} to {end_date}'

 # Metrics table
 ws_summary['A4'] = 'Metric'
 ws_summary['B4'] = 'Value'
 ws_summary['C4'] = 'Classification'

 metrics = [
 ('Deployment Frequency', summary['deployment_frequency'], summary['df_classification']),
 ('Lead Time (hours)', summary['lead_time_hours'], summary['lt_classification']),
 ('Change Failure Rate (%)', summary['cfr'], summary['cfr_classification']),
 ('MTTR (hours)', summary['mttr_hours'], summary['mttr_classification']),
 ]

 row = 5
 for metric_name, value, classification in metrics:
 ws_summary[f'A{row}'] = metric_name
 ws_summary[f'B{row}'] = value
 ws_summary[f'C{row}'] = classification

 # Color-code classification
 if classification == 'Elite':
 ws_summary[f'C{row}'].fill = PatternFill(start_color="4CAF50", fill_type="solid")
 elif classification == 'High':
 ws_summary[f'C{row}'].fill = PatternFill(start_color="2196F3", fill_type="solid")
 elif classification == 'Medium':
 ws_summary[f'C{row}'].fill = PatternFill(start_color="FF9800", fill_type="solid")
 elif classification == 'Low':
 ws_summary[f'C{row}'].fill = PatternFill(start_color="F44336", fill_type="solid")

 ws_summary[f'C{row}'].font = Font(color="FFFFFF", bold=True)
 row += 1

 ws_summary[f'A{row + 1}'] = 'Overall Classification'
 ws_summary[f'B{row + 1}'] = summary['overall_classification']

 # Sheet 2: Daily Metrics
 ws_daily = wb.create_sheet("Daily Metrics")
 ws_daily.append(['Date', 'Deployments', 'Lead Time (h)', 'CFR (%)', 'MTTR (h)'])

 for row_data in daily_data:
 ws_daily.append([
 row_data['date'],
 row_data['deployment_frequency'],
 round(row_data['lead_time_hours'], 2),
 round(row_data['cfr'], 2),
 round(row_data['mttr_hours'], 2)
 ])

 # Sheet 3: Charts (if requested)
 if include_charts:
 ws_charts = wb.create_sheet("Charts")

 # Deployment Frequency Chart
 chart = BarChart()
 chart.title = "Deployment Frequency"
 chart.x_axis.title = "Date"
 chart.y_axis.title = "Deployments"

 data = Reference(ws_daily, min_col=2, min_row=1, max_row=len(daily_data) + 1)
 cats = Reference(ws_daily, min_col=1, min_row=2, max_row=len(daily_data) + 1)

 chart.add_data(data, titles_from_data=True)
 chart.set_categories(cats)

 ws_charts.add_chart(chart, "A1")

 # Save to BytesIO
 output = io.BytesIO()
 wb.save(output)
 output.seek(0)

 # Create response
 response = HttpResponse(
 output.getvalue(),
 content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
 )
 response['Content-Disposition'] = \
 f'attachment; filename="dora_metrics_{start_date}_{end_date}.xlsx"'

 return response
```

### 4.3. PDF Export

```python
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, PageBreak
from reportlab.lib import colors
from django.http import HttpResponse
import io

@staff_member_required
def export_pdf(request):
 """Export DORA metrics as PDF report."""
 start_date = request.GET.get('start_date')
 end_date = request.GET.get('end_date')
 template = request.GET.get('template', 'executive')

 # Calculate metrics
 summary = calculate_summary_metrics(start_date, end_date)
 overall = calculate_overall_dora_classification(start_date, end_date)

 # Create PDF buffer
 buffer = io.BytesIO()
 doc = SimpleDocTemplate(buffer, pagesize=letter)
 styles = getSampleStyleSheet()
 story = []

 # Cover Page
 title = Paragraph(
 "DORA Metrics Report",
 styles['Title']
 )
 story.append(title)
 story.append(Spacer(1, 12))

 subtitle = Paragraph(
 f"Period: {start_date} to {end_date}",
 styles['Normal']
 )
 story.append(subtitle)
 story.append(Spacer(1, 24))

 # Executive Summary
 summary_title = Paragraph("Executive Summary", styles['Heading1'])
 story.append(summary_title)
 story.append(Spacer(1, 12))

 classification_text = f"""
 <para>
 <b>Overall Classification:</b> {overall['overall_classification']['classification']}
 </para>
 <para>
 {overall['overall_classification']['reasoning']}
 </para>
 """
 story.append(Paragraph(classification_text, styles['Normal']))
 story.append(Spacer(1, 12))

 # Metrics Table
 metrics_data = [
 ['Metric', 'Value', 'Unit', 'Classification'],
 [
 'Deployment Frequency',
 str(summary['deployment_frequency']),
 'per month',
 summary['df_classification']
 ],
 [
 'Lead Time for Changes',
 str(summary['lead_time_hours']),
 'hours',
 summary['lt_classification']
 ],
 [
 'Change Failure Rate',
 str(summary['cfr']),
 '%',
 summary['cfr_classification']
 ],
 [
 'Mean Time to Recovery',
 str(summary['mttr_hours']),
 'hours',
 summary['mttr_classification']
 ],
 ]

 table = Table(metrics_data)
 table.setStyle([
 ('BACKGROUND', (0, 0), (-1, 0), colors.green),
 ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
 ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
 ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
 ('FONTSIZE', (0, 0), (-1, 0), 12),
 ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
 ('BACKGROUND', (0, 1), (-1, -1), colors.beige),
 ('GRID', (0, 0), (-1, -1), 1, colors.black)
 ])

 story.append(table)
 story.append(PageBreak())

 # Recommendations
 if overall['recommendations']:
 rec_title = Paragraph("Recommendations", styles['Heading1'])
 story.append(rec_title)
 story.append(Spacer(1, 12))

 for i, rec in enumerate(overall['recommendations'], 1):
 rec_text = Paragraph(f"{i}. {rec}", styles['Normal'])
 story.append(rec_text)
 story.append(Spacer(1, 6))

 # Build PDF
 doc.build(story)
 buffer.seek(0)

 # Create response
 response = HttpResponse(buffer.getvalue(), content_type='application/pdf')
 response['Content-Disposition'] = \
 f'attachment; filename="dora_report_{start_date}_{end_date}.pdf"'

 return response
```

## 5. Tests

```python
def test_csv_export(self):
 """Test CSV export generates valid CSV."""
 self.client.login(username='staff', password='test')

 # Create test data
 DORAMetric.objects.create(
 cycle_id='C-1',
 phase_name='deployment',
 decision='go',
 duration_seconds=3600
 )

 response = self.client.get(
 '/api/dora-metrics/export/csv/?start_date=2025-10-01&end_date=2025-10-31'
 )

 self.assertEqual(response.status_code, 200)
 self.assertEqual(response['Content-Type'], 'text/csv')
 self.assertIn('attachment', response['Content-Disposition'])

 # Verify CSV content
 content = response.content.decode('utf-8')
 self.assertIn('Date,Deployment Frequency', content)
 self.assertIn('DORA Metrics Report', content)

def test_excel_export(self):
 """Test Excel export generates valid XLSX."""
 self.client.login(username='staff', password='test')

 response = self.client.get(
 '/api/dora-metrics/export/excel/?start_date=2025-10-01&end_date=2025-10-31'
 )

 self.assertEqual(response.status_code, 200)
 self.assertEqual(
 response['Content-Type'],
 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
 )

 # Verify Excel can be opened
 from openpyxl import load_workbook
 import io

 wb = load_workbook(io.BytesIO(response.content))
 self.assertIn('Summary', wb.sheetnames)
 self.assertIn('Daily Metrics', wb.sheetnames)

def test_pdf_export(self):
 """Test PDF export generates valid PDF."""
 self.client.login(username='staff', password='test')

 response = self.client.get(
 '/api/dora-metrics/export/pdf/?start_date=2025-10-01&end_date=2025-10-31'
 )

 self.assertEqual(response.status_code, 200)
 self.assertEqual(response['Content-Type'], 'application/pdf')

 # Verify PDF header
 content = response.content
 self.assertTrue(content.startswith(b'%PDF'))

def test_export_self_consistency(self):
 """Test that all export formats contain same data."""
 self.client.login(username='staff', password='test')

 # Create known test data
 for i in range(10):
 DORAMetric.objects.create(
 cycle_id=f'C-{i}',
 phase_name='deployment',
 decision='go',
 duration_seconds=3600
 )

 # Export in all formats
 csv_response = self.client.get('/api/dora-metrics/export/csv/?start_date=2025-10-01&end_date=2025-10-31')
 excel_response = self.client.get('/api/dora-metrics/export/excel/?start_date=2025-10-01&end_date=2025-10-31')
 pdf_response = self.client.get('/api/dora-metrics/export/pdf/?start_date=2025-10-01&end_date=2025-10-31')

 # All should succeed
 self.assertEqual(csv_response.status_code, 200)
 self.assertEqual(excel_response.status_code, 200)
 self.assertEqual(pdf_response.status_code, 200)

 # CSV should contain "10" deployments
 csv_content = csv_response.content.decode('utf-8')
 # (Further validation of numeric consistency across formats)
```

## 6. Criterios de Aceptación

### Funcionales

1. **CSV Export:**
 - DADO un período de fechas
 - CUANDO solicito export CSV
 - ENTONCES recibo archivo CSV descargable
 - Y contiene todas las métricas DORA
 - Y incluye metadata (período, fecha generación)

2. **Excel Export:**
 - DADO un período de fechas
 - CUANDO solicito export Excel
 - ENTONCES recibo archivo .xlsx descargable
 - Y contiene 3 hojas (Summary, Daily Metrics, Charts)
 - Y tiene formato con color-coding según clasificación

3. **PDF Export:**
 - DADO un período de fechas
 - CUANDO solicito export PDF
 - ENTONCES recibo archivo PDF descargable
 - Y contiene Executive Summary
 - Y contiene tabla de métricas
 - Y contiene recommendations

4. **Permisos:**
 - Solo usuarios staff pueden exportar
 - Usuarios anónimos reciben 302 redirect

### No Funcionales

- Generación de CSV: <1 segundo
- Generación de Excel: <3 segundos
- Generación de PDF: <5 segundos
- Límite de período: máximo 365 días

## 7. Anti-Alucinación Verification

**IMPORTANTE:** Esta funcionalidad NO está implementada en el código actual.

**Estado:** Requiere implementación

**Dependencias externas:**
- openpyxl==3.1.2 (Excel generation)
- reportlab==4.0.7 (PDF generation)
- Agregar a requirements.txt

**Verificación contra DORA Research:**
- Los datos exportados deben usar mismos thresholds que RF-021 a RF-024
- Clasificación debe coincidir con RF-025

**Self-Consistency Guarantees:**
- CSV, Excel, PDF deben contener mismos valores numéricos
- Período debe ser consistente en todos los formatos
- Clasificación DORA debe ser idéntica

## 8. Trazabilidad

- Origen: N-004, RN-004, RF-020
- Depende de: RF-025 (overall classification), RF-026 (dashboard metrics)
- Implementado: **NO IMPLEMENTADO**
- Tests: tests/dora_metrics/test_export.py (pendiente)
- ADR: ADR_2025_003 (DORA metrics integration)

## 9. Tareas de Implementación

**T-001:** Agregar dependencias
```bash
# requirements.txt
openpyxl==3.1.2
reportlab==4.0.7
```

**T-002:** Crear views para export
```
api/callcentersite/dora_metrics/views.py:
- export_csv()
- export_excel()
- export_pdf()
```

**T-003:** Agregar URLs
```python
# urls.py
path('export/csv/', views.export_csv, name='export-csv'),
path('export/excel/', views.export_excel, name='export-excel'),
path('export/pdf/', views.export_pdf, name='export-pdf'),
```

**T-004:** Crear tests
```
tests/dora_metrics/test_export.py
```

**T-005:** Agregar botones de export en dashboard
```html
<!-- dashboard.html -->
<div class="export-controls">
 <a href="{% url 'export-csv' %}?start_date={{ period_start }}&end_date={{ period_end }}">
 Download CSV
 </a>
 <a href="{% url 'export-excel' %}?start_date={{ period_start }}&end_date={{ period_end }}">
 Download Excel
 </a>
 <a href="{% url 'export-pdf' %}?start_date={{ period_start }}&end_date={{ period_end }}">
 Download PDF
 </a>
</div>
```

**Prioridad:** Media
**Estimación:** 5-8 horas development + testing
