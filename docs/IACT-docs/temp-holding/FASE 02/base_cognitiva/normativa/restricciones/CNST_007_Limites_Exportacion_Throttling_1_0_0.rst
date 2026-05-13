.. _CNST_007:

============================================================
CNST_007 - Límites de Exportación y Throttling
============================================================

:Restricción: CNST_007
:Versión: 1.0.0
:Fecha: 2026-01-11
:Estado: VIGENTE
:Prioridad: ALTA
:Ámbito: MOD_Reports - Exportaciones (CSV, Excel, PDF)
:Fundamento: Performance, gestión de recursos, prevención de abuso
:Proyecto: IACT-2025-001
:Relacionado_Con: CNST_006 (Rango 2 años), CNST_003 (Datos desfasados)

.. contents:: Tabla de Contenido
   :depth: 4
   :local:

============================================================
1. RESUMEN EJECUTIVO
============================================================

1.1 Definición de la Restricción
----------------------------------

   **Las exportaciones de reportes en el Sistema IACT tienen límites 
   estrictos de cantidad de registros y frecuencia (throttling).**
   
   **Límites por formato de exportación:**
   
   .. list-table:: Límites de Exportación
      :header-rows: 1
      :widths: 20 20 20 20 20

      * - Formato
        - Max Registros
        - Límite Diario
        - Timeout
        - Tamaño Aprox.
      * - **CSV**
        - 100,000
        - 10 exportaciones
        - 60 segundos
        - ~15-20 MB
      * - **Excel**
        - 50,000
        - 5 exportaciones
        - 90 segundos
        - ~10-15 MB
      * - **PDF**
        - 10,000
        - 3 exportaciones
        - 120 segundos
        - ~5-10 MB

1.2 Justificación
------------------

**Performance:**

- Exportaciones grandes consumen CPU, memoria, I/O
- Timeout de servidor (60-120 segundos)
- Impacto en otros usuarios concurrentes
- Balance entre utilidad y recursos

**Prevención de Abuso:**

- Throttling previene extracciones masivas automatizadas
- Control de uso justo de recursos
- Detección de comportamiento anómalo
- Protección contra scraping

**Experiencia de Usuario:**

- Archivos >20 MB son difíciles de abrir
- Excel con >50K filas se congela
- PDFs >10K páginas son inmanejables
- Forzar análisis enfocados

**Compliance:**

- Control de exportación de datos sensibles
- Trazabilidad de qué se exporta
- Auditoría de descargas
- Prevención de fugas de datos

1.3 Impacto General
--------------------

.. list-table:: Impacto de CNST_007
   :header-rows: 1
   :widths: 30 70

   * - Aspecto
     - Impacto
   * - **Usuario Final**
     - • NO puede exportar >100K registros (CSV)
       • Límite diario: 10 CSV, 5 Excel, 3 PDF
       • Mensaje claro si excede límites
       • Debe segmentar exportaciones grandes
   * - **Módulo Afectado**
     - MOD_Reports (funciones de exportación)
   * - **Funciones RBAC**
     - • RPT-004: exporta_csv (100K, 10/día)
       • RPT-005: exporta_excel (50K, 5/día)
       • RPT-006: exporta_pdf (10K, 3/día)
   * - **Infraestructura**
     - • Tabla de control de throttling
       • Cron job para reset diario
       • Monitor de exportaciones activas
   * - **Auditoría**
     - • Log de cada exportación
       • Usuario, timestamp, formato, registros
       • Detección de patrones sospechosos

============================================================
2. ESPECIFICACIÓN TÉCNICA
============================================================

2.1 Límites por Formato
-------------------------

**2.1.1 CSV (exporta_csv - RPT-004)**

.. code-block:: yaml

   Formato: CSV (Comma-Separated Values)
   
   Límites:
     - Max registros: 100,000
     - Max exportaciones diarias: 10
     - Timeout: 60 segundos
     - Tamaño estimado: 15-20 MB
   
   Características:
     - Delimitador: coma (,)
     - Encoding: UTF-8 con BOM
     - Fechas: YYYY-MM-DD
     - Números: Punto decimal (12345.67)
     - Sin formato, solo datos
   
   Uso típico:
     - Importar a Excel para análisis
     - Procesar con Python/R
     - Backup de datos

**2.1.2 Excel (exporta_excel - RPT-005)**

.. code-block:: yaml

   Formato: Excel (.xlsx)
   
   Límites:
     - Max registros: 50,000
     - Max exportaciones diarias: 5
     - Timeout: 90 segundos
     - Tamaño estimado: 10-15 MB
   
   Características:
     - Formato: XLSX (Excel 2007+)
     - Con formato: Headers en negrita, filtros
     - Columnas auto-width
     - Fechas con formato local
     - Números con separadores de miles
   
   Uso típico:
     - Presentaciones ejecutivas
     - Análisis con tablas dinámicas
     - Compartir con stakeholders

**2.1.3 PDF (exporta_pdf - RPT-006)**

.. code-block:: yaml

   Formato: PDF
   
   Límites:
     - Max registros: 10,000
     - Max exportaciones diarias: 3
     - Timeout: 120 segundos
     - Tamaño estimado: 5-10 MB
   
   Características:
     - Formato: PDF/A (archivable)
     - Con logo y headers
     - Paginación automática
     - Tabla responsive
     - Watermark: "Confidencial - IACT"
   
   Uso típico:
     - Reportes oficiales
     - Auditorías
     - Archivo permanente

2.2 Throttling (Rate Limiting)
--------------------------------

.. code-block:: yaml

   Ventana: 24 horas (rolling)
   Reset: Diario a las 00:00 UTC
   
   Contador por usuario + formato:
     - Juan → CSV: 3/10 hoy
     - Juan → Excel: 1/5 hoy
     - Juan → PDF: 0/3 hoy
   
   Comportamiento:
     - Si usuario alcanza límite:
       → Rechazar exportación
       → HTTP 429 Too Many Requests
       → Mensaje: "Límite diario alcanzado (10/10 CSV)"
       → Sugerencia: "Intenta mañana o usa otro formato"
     
     - Si usuario está cerca del límite:
       → Advertencia: "Quedan 2 exportaciones CSV hoy"
   
   Excepciones: NINGUNA
   
   Bypass (solo con aprobación):
     - Usuarios con función especial: aumenta_limite_exportacion
     - Límite aumentado: 2x (20 CSV, 10 Excel, 6 PDF)
     - Requiere justificación + aprobación de supervisor

2.3 Validaciones Pre-Exportación
----------------------------------

**Validación 1: Límite de Registros**

.. code-block:: python

   def validar_limite_registros(formato, count_registros):
       limites = {
           'csv': 100_000,
           'excel': 50_000,
           'pdf': 10_000
       }
       
       limite = limites[formato]
       
       if count_registros > limite:
           raise ExportLimitExceeded(
               f"Exportación de {count_registros:,} registros excede "
               f"el límite de {limite:,} para formato {formato.upper()}"
           )

**Validación 2: Throttling**

.. code-block:: python

   def validar_throttling(usuario, formato):
       limites_diarios = {
           'csv': 10,
           'excel': 5,
           'pdf': 3
       }
       
       # Contar exportaciones hoy
       count_hoy = ExportLog.objects.filter(
           usuario=usuario,
           formato=formato,
           fecha__gte=timezone.now().replace(hour=0, minute=0)
       ).count()
       
       limite = limites_diarios[formato]
       
       if count_hoy >= limite:
           raise ThrottlingExceeded(
               f"Límite diario de {limite} exportaciones {formato.upper()} "
               f"alcanzado ({count_hoy}/{limite})"
           )

**Validación 3: Rango de Fechas (CNST_006)**

.. code-block:: python

   def validar_rango_fechas(fecha_inicio, fecha_fin):
       # CNST_006: Max 2 años
       delta = fecha_fin - fecha_inicio
       
       if delta.days > 730:
           raise DateRangeExceeded(
               "Rango de fechas excede 2 años (CNST_006)"
           )

**Orden de Validación:**

.. code-block:: text

   1. Validar RBAC (usuario tiene función exporta_*)
   2. Validar rango de fechas (CNST_006)
   3. Contar registros a exportar
   4. Validar límite de registros (CNST_007)
   5. Validar throttling diario (CNST_007)
   6. Si TODO OK → Iniciar exportación
   7. Si ALGUNO falla → Rechazar inmediatamente

============================================================
3. FUNCIONES RBAC AFECTADAS
============================================================

3.1 RPT-004: exporta_csv
--------------------------

.. code-block:: yaml

   Función: exporta_csv
   Capacidad: reports:exportar_csv
   Módulo: MOD_Reports
   
   Límites CNST_007:
     - Max registros: 100,000
     - Límite diario: 10 exportaciones
     - Timeout: 60 segundos
   
   Proceso:
     1. Usuario solicita exportación CSV
     2. Validar RBAC (tiene función exporta_csv)
     3. Validar rango fechas (CNST_006)
     4. Contar registros (SELECT COUNT(*))
     5. Validar límite 100K (CNST_007)
     6. Validar throttling 10/día (CNST_007)
     7. Si OK → Generar CSV → Descargar
     8. Registrar en export_logs (auditoría)
   
   Caso de Uso: UC-022

3.2 RPT-005: exporta_excel
---------------------------

.. code-block:: yaml

   Función: exporta_excel
   Capacidad: reports:exportar_excel
   Módulo: MOD_Reports
   
   Límites CNST_007:
     - Max registros: 50,000
     - Límite diario: 5 exportaciones
     - Timeout: 90 segundos
   
   Características adicionales:
     - Formato con estilos (headers, filtros)
     - Múltiples hojas (si aplica)
     - Auto-width de columnas
     - Números con formato
   
   Caso de Uso: UC-023

3.3 RPT-006: exporta_pdf
-------------------------

.. code-block:: yaml

   Función: exporta_pdf
   Capacidad: reports:exportar_pdf
   Módulo: MOD_Reports
   
   Límites CNST_007:
     - Max registros: 10,000
     - Límite diario: 3 exportaciones
     - Timeout: 120 segundos
   
   Características adicionales:
     - Logo corporativo
     - Headers y footers
     - Paginación
     - Watermark "Confidencial"
     - Metadata (autor, fecha, etc.)
   
   Caso de Uso: UC-024

============================================================
4. MODELO DE DATOS
============================================================

4.1 Tabla: export_logs
------------------------

.. code-block:: sql

   CREATE TABLE export_logs (
       export_id BIGINT AUTO_INCREMENT PRIMARY KEY,
       usuario_id INT NOT NULL,
       formato ENUM('csv', 'excel', 'pdf') NOT NULL,
       
       -- Query ejecutado
       reporte_tipo VARCHAR(100) NOT NULL,
       fecha_inicio DATE NOT NULL,
       fecha_fin DATE NOT NULL,
       filtros_aplicados JSON,
       
       -- Resultados
       registros_exportados INT NOT NULL,
       duracion_segundos INT,
       tamano_archivo_bytes BIGINT,
       
       -- Control
       fecha_exportacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
       ip_address VARCHAR(45),
       user_agent VARCHAR(500),
       
       -- Estado
       estado ENUM('SUCCESS', 'FAILED', 'TIMEOUT') NOT NULL DEFAULT 'SUCCESS',
       error_message TEXT,
       
       -- Auditoría
       archivo_generado VARCHAR(500),  -- Path o hash del archivo
       descargado BOOLEAN DEFAULT TRUE,
       
       CONSTRAINT fk_export_usuario FOREIGN KEY (usuario_id) 
           REFERENCES usuarios(usuario_id),
       
       INDEX idx_export_usuario_fecha (usuario_id, fecha_exportacion DESC),
       INDEX idx_export_formato (formato),
       INDEX idx_export_estado (estado)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

4.2 Tabla: export_throttling
------------------------------

.. code-block:: sql

   CREATE TABLE export_throttling (
       throttle_id BIGINT AUTO_INCREMENT PRIMARY KEY,
       usuario_id INT NOT NULL,
       formato ENUM('csv', 'excel', 'pdf') NOT NULL,
       fecha_ventana DATE NOT NULL,  -- Día al que pertenece
       
       count_exportaciones INT NOT NULL DEFAULT 1,
       limite_diario INT NOT NULL,  -- 10, 5, o 3 según formato
       
       ultima_exportacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
       
       CONSTRAINT fk_throttle_usuario FOREIGN KEY (usuario_id) 
           REFERENCES usuarios(usuario_id),
       
       UNIQUE INDEX uk_throttle_usuario_formato_fecha (
           usuario_id, formato, fecha_ventana
       ),
       INDEX idx_throttle_fecha (fecha_ventana)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

4.3 Vista: Estado de Throttling
---------------------------------

.. code-block:: sql

   CREATE VIEW vw_export_throttling_status AS
   SELECT 
       u.usuario_id,
       u.username,
       
       -- CSV
       COALESCE(csv.count_exportaciones, 0) AS csv_exportaciones_hoy,
       10 AS csv_limite_diario,
       10 - COALESCE(csv.count_exportaciones, 0) AS csv_disponibles,
       
       -- Excel
       COALESCE(excel.count_exportaciones, 0) AS excel_exportaciones_hoy,
       5 AS excel_limite_diario,
       5 - COALESCE(excel.count_exportaciones, 0) AS excel_disponibles,
       
       -- PDF
       COALESCE(pdf.count_exportaciones, 0) AS pdf_exportaciones_hoy,
       3 AS pdf_limite_diario,
       3 - COALESCE(pdf.count_exportaciones, 0) AS pdf_disponibles
       
   FROM usuarios u
   LEFT JOIN export_throttling csv 
       ON u.usuario_id = csv.usuario_id 
       AND csv.formato = 'csv'
       AND csv.fecha_ventana = CURDATE()
   LEFT JOIN export_throttling excel 
       ON u.usuario_id = excel.usuario_id 
       AND excel.formato = 'excel'
       AND excel.fecha_ventana = CURDATE()
   LEFT JOIN export_throttling pdf 
       ON u.usuario_id = pdf.usuario_id 
       AND pdf.formato = 'pdf'
       AND pdf.fecha_ventana = CURDATE()
   WHERE u.activo = TRUE;

============================================================
5. IMPLEMENTACIÓN DJANGO
============================================================

5.1 Servicio de Exportación
-----------------------------

.. code-block:: python

   # file: reports/export_service.py
   from django.utils import timezone
   from datetime import timedelta, date
   from .models import ExportLog, ExportThrottling
   import csv
   import openpyxl
   from reportlab.lib.pagesizes import letter
   from reportlab.platypus import SimpleDocTemplate, Table
   
   class ExportService:
       """
       Servicio de exportación de reportes.
       
       Implementa CNST_007: Límites de exportación y throttling.
       """
       
       LIMITES_REGISTROS = {
           'csv': 100_000,
           'excel': 50_000,
           'pdf': 10_000
       }
       
       LIMITES_DIARIOS = {
           'csv': 10,
           'excel': 5,
           'pdf': 3
       }
       
       TIMEOUTS = {
           'csv': 60,
           'excel': 90,
           'pdf': 120
       }
       
       @classmethod
       def exportar(cls, formato, usuario, queryset, filename, 
                   fecha_inicio=None, fecha_fin=None):
           """
           Exporta un queryset al formato especificado.
           
           Args:
               formato: 'csv', 'excel', o 'pdf'
               usuario: Usuario que solicita la exportación
               queryset: QuerySet de Django a exportar
               filename: Nombre del archivo (sin extensión)
               fecha_inicio, fecha_fin: Rango de fechas (opcional)
           
           Returns:
               dict: Información de la exportación
           
           Raises:
               ExportLimitExceeded: Si excede límite de registros
               ThrottlingExceeded: Si excede límite diario
               ExportTimeout: Si excede timeout
           """
           # 1. Validar límite de registros
           count = queryset.count()
           limite_registros = cls.LIMITES_REGISTROS[formato]
           
           if count > limite_registros:
               raise ExportLimitExceeded(
                   formato=formato,
                   count=count,
                   limite=limite_registros
               )
           
           # 2. Validar throttling
           cls._validar_throttling(usuario, formato)
           
           # 3. Generar archivo según formato
           inicio = timezone.now()
           
           try:
               if formato == 'csv':
                   archivo_path = cls._exportar_csv(queryset, filename)
               elif formato == 'excel':
                   archivo_path = cls._exportar_excel(queryset, filename)
               elif formato == 'pdf':
                   archivo_path = cls._exportar_pdf(queryset, filename)
               
               duracion = (timezone.now() - inicio).total_seconds()
               
               # Validar timeout
               if duracion > cls.TIMEOUTS[formato]:
                   raise ExportTimeout(
                       formato=formato,
                       duracion=duracion,
                       timeout=cls.TIMEOUTS[formato]
                   )
               
               # 4. Registrar exportación exitosa
               cls._registrar_exportacion(
                   usuario=usuario,
                   formato=formato,
                   count=count,
                   duracion=duracion,
                   archivo=archivo_path,
                   fecha_inicio=fecha_inicio,
                   fecha_fin=fecha_fin,
                   estado='SUCCESS'
               )
               
               # 5. Incrementar contador de throttling
               cls._incrementar_throttling(usuario, formato)
               
               return {
                   'success': True,
                   'archivo': archivo_path,
                   'registros': count,
                   'duracion_segundos': duracion,
                   'formato': formato
               }
           
           except Exception as e:
               # Registrar fallo
               cls._registrar_exportacion(
                   usuario=usuario,
                   formato=formato,
                   count=count,
                   duracion=(timezone.now() - inicio).total_seconds(),
                   estado='FAILED',
                   error=str(e)
               )
               raise
       
       @classmethod
       def _validar_throttling(cls, usuario, formato):
           """Valida límite diario de exportaciones."""
           hoy = date.today()
           
           throttle, created = ExportThrottling.objects.get_or_create(
               usuario=usuario,
               formato=formato,
               fecha_ventana=hoy,
               defaults={
                   'count_exportaciones': 0,
                   'limite_diario': cls.LIMITES_DIARIOS[formato]
               }
           )
           
           if throttle.count_exportaciones >= throttle.limite_diario:
               raise ThrottlingExceeded(
                   formato=formato,
                   count=throttle.count_exportaciones,
                   limite=throttle.limite_diario
               )
       
       @classmethod
       def _incrementar_throttling(cls, usuario, formato):
           """Incrementa contador de throttling."""
           hoy = date.today()
           
           throttle = ExportThrottling.objects.get(
               usuario=usuario,
               formato=formato,
               fecha_ventana=hoy
           )
           
           throttle.count_exportaciones += 1
           throttle.ultima_exportacion = timezone.now()
           throttle.save()
       
       @classmethod
       def _exportar_csv(cls, queryset, filename):
           """Genera archivo CSV."""
           import tempfile
           import os
           
           # Crear archivo temporal
           fd, path = tempfile.mkstemp(suffix='.csv', prefix=filename)
           
           with os.fdopen(fd, 'w', encoding='utf-8-sig', newline='') as csvfile:
               # Obtener campos
               if queryset.exists():
                   fields = [f.name for f in queryset.model._meta.fields]
               else:
                   fields = []
               
               writer = csv.DictWriter(csvfile, fieldnames=fields)
               writer.writeheader()
               
               # Escribir datos
               for obj in queryset.iterator(chunk_size=1000):
                   row = {field: getattr(obj, field) for field in fields}
                   writer.writerow(row)
           
           return path
       
       @classmethod
       def _exportar_excel(cls, queryset, filename):
           """Genera archivo Excel."""
           import tempfile
           
           # Crear archivo temporal
           fd, path = tempfile.mkstemp(suffix='.xlsx', prefix=filename)
           
           wb = openpyxl.Workbook()
           ws = wb.active
           ws.title = 'Reporte'
           
           # Headers
           if queryset.exists():
               fields = [f.name for f in queryset.model._meta.fields]
               ws.append(fields)
               
               # Aplicar estilo a headers
               for cell in ws[1]:
                   cell.font = openpyxl.styles.Font(bold=True)
                   cell.fill = openpyxl.styles.PatternFill(
                       start_color='CCCCCC', 
                       fill_type='solid'
                   )
               
               # Datos
               for obj in queryset.iterator(chunk_size=1000):
                   row = [getattr(obj, field) for field in fields]
                   ws.append(row)
               
               # Auto-width
               for column in ws.columns:
                   max_length = 0
                   column_letter = column[0].column_letter
                   for cell in column:
                       if cell.value:
                           max_length = max(max_length, len(str(cell.value)))
                   ws.column_dimensions[column_letter].width = min(max_length + 2, 50)
           
           wb.save(path)
           return path
       
       @classmethod
       def _exportar_pdf(cls, queryset, filename):
           """Genera archivo PDF."""
           import tempfile
           
           # Crear archivo temporal
           fd, path = tempfile.mkstemp(suffix='.pdf', prefix=filename)
           
           doc = SimpleDocTemplate(path, pagesize=letter)
           elements = []
           
           # Datos para tabla
           if queryset.exists():
               fields = [f.name for f in queryset.model._meta.fields]
               
               data = [fields]  # Headers
               for obj in queryset.iterator(chunk_size=1000):
                   row = [str(getattr(obj, field)) for field in fields]
                   data.append(row)
               
               # Crear tabla
               table = Table(data)
               table.setStyle([
                   ('BACKGROUND', (0, 0), (-1, 0), 'grey'),
                   ('TEXTCOLOR', (0, 0), (-1, 0), 'white'),
                   ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
                   ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                   ('FONTSIZE', (0, 0), (-1, 0), 10),
                   ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
                   ('GRID', (0, 0), (-1, -1), 1, 'black')
               ])
               
               elements.append(table)
           
           doc.build(elements)
           return path
       
       @classmethod
       def obtener_estado_throttling(cls, usuario):
           """Obtiene estado actual de throttling del usuario."""
           hoy = date.today()
           
           estado = {}
           for formato in ['csv', 'excel', 'pdf']:
               throttle = ExportThrottling.objects.filter(
                   usuario=usuario,
                   formato=formato,
                   fecha_ventana=hoy
               ).first()
               
               if throttle:
                   count = throttle.count_exportaciones
               else:
                   count = 0
               
               limite = cls.LIMITES_DIARIOS[formato]
               
               estado[formato] = {
                   'exportaciones_hoy': count,
                   'limite_diario': limite,
                   'disponibles': limite - count,
                   'porcentaje_usado': int((count / limite) * 100)
               }
           
           return estado

5.2 Excepciones Personalizadas
--------------------------------

.. code-block:: python

   # file: reports/exceptions.py
   
   class ExportLimitExceeded(Exception):
       """Excepción cuando se excede límite de registros."""
       
       def __init__(self, formato, count, limite):
           self.formato = formato
           self.count = count
           self.limite = limite
           
           super().__init__(
               f"Exportación de {count:,} registros excede el límite de "
               f"{limite:,} para formato {formato.upper()} (CNST_007)"
           )
   
   class ThrottlingExceeded(Exception):
       """Excepción cuando se excede límite diario."""
       
       def __init__(self, formato, count, limite):
           self.formato = formato
           self.count = count
           self.limite = limite
           
           super().__init__(
               f"Límite diario de {limite} exportaciones {formato.upper()} "
               f"alcanzado ({count}/{limite}) (CNST_007)"
           )
   
   class ExportTimeout(Exception):
       """Excepción cuando exportación excede timeout."""
       
       def __init__(self, formato, duracion, timeout):
           self.formato = formato
           self.duracion = duracion
           self.timeout = timeout
           
           super().__init__(
               f"Exportación {formato.upper()} tardó {duracion:.1f}s, "
               f"excede timeout de {timeout}s (CNST_007)"
           )

============================================================
6. EJEMPLOS DE IMPLEMENTACIÓN
============================================================

6.1 Ejemplo: Exportar CSV
---------------------------

.. code-block:: python

   # file: reports/views.py
   from rest_framework.decorators import api_view
   from rest_framework.response import Response
   from django.http import FileResponse
   from .export_service import ExportService
   from .exceptions import ExportLimitExceeded, ThrottlingExceeded
   from core.decorators import require_function
   
   @api_view(['POST'])
   @require_function('exporta_csv')
   def exportar_csv(request):
       """
       Exporta reporte a CSV.
       
       POST /api/reports/export/csv
       {
           "reporte": "llamadas",
           "fecha_inicio": "2025-01-01",
           "fecha_fin": "2025-12-31"
       }
       """
       # Obtener datos
       from llamadas.models import LlamadaIVR
       
       queryset = LlamadaIVR.objects.filter(
           fecha_llamada__gte=request.data['fecha_inicio'],
           fecha_llamada__lte=request.data['fecha_fin'],
           segmento_id=request.user.segmento_id  # CNST_005
       )
       
       try:
           # Exportar (valida límites automáticamente)
           resultado = ExportService.exportar(
               formato='csv',
               usuario=request.user,
               queryset=queryset,
               filename='reporte_llamadas',
               fecha_inicio=request.data['fecha_inicio'],
               fecha_fin=request.data['fecha_fin']
           )
           
           # Retornar archivo
           return FileResponse(
               open(resultado['archivo'], 'rb'),
               as_attachment=True,
               filename=f"reporte_llamadas_{request.data['fecha_inicio']}.csv"
           )
       
       except ExportLimitExceeded as e:
           return Response({
               'error': 'export_limit_exceeded',
               'message': str(e),
               'registros_solicitados': e.count,
               'limite_maximo': e.limite,
               'sugerencia': 'Reduce el rango de fechas o aplica más filtros'
           }, status=400)
       
       except ThrottlingExceeded as e:
           return Response({
               'error': 'throttling_exceeded',
               'message': str(e),
               'exportaciones_hoy': e.count,
               'limite_diario': e.limite,
               'sugerencia': 'Espera hasta mañana o usa otro formato'
           }, status=429)

6.2 Ejemplo: Ver Estado de Throttling
---------------------------------------

.. code-block:: python

   @api_view(['GET'])
   def ver_estado_throttling(request):
       """
       Muestra estado actual de throttling del usuario.
       
       GET /api/reports/export/status
       """
       estado = ExportService.obtener_estado_throttling(request.user)
       
       return Response({
           'usuario': request.user.username,
           'fecha': date.today().isoformat(),
           'limites': estado
       })
   
   # Respuesta ejemplo:
   # {
   #     "usuario": "juan.perez",
   #     "fecha": "2026-01-11",
   #     "limites": {
   #         "csv": {
   #             "exportaciones_hoy": 3,
   #             "limite_diario": 10,
   #             "disponibles": 7,
   #             "porcentaje_usado": 30
   #         },
   #         "excel": {
   #             "exportaciones_hoy": 1,
   #             "limite_diario": 5,
   #             "disponibles": 4,
   #             "porcentaje_usado": 20
   #         },
   #         "pdf": {
   #             "exportaciones_hoy": 0,
   #             "limite_diario": 3,
   #             "disponibles": 3,
   #             "porcentaje_usado": 0
   #         }
   #     }
   # }

============================================================
7. VALIDACIÓN Y TESTING
============================================================

7.1 Tests Unitarios
--------------------

.. code-block:: python

   # file: tests/test_cnst_007.py
   from django.test import TestCase
   from reports.export_service import ExportService
   from reports.exceptions import ExportLimitExceeded, ThrottlingExceeded
   from users.models import Usuario
   from llamadas.models import LlamadaIVR
   
   class TestCNST007(TestCase):
       """
       Tests para validar CNST_007: Límites de exportación
       """
       
       def setUp(self):
           self.usuario = Usuario.objects.create(username='test_user')
       
       def test_limite_csv_100k(self):
           """CSV debe rechazar >100K registros."""
           # Simular 150K registros
           queryset = LlamadaIVR.objects.all()
           
           # Mock del count
           queryset.count = lambda: 150_000
           
           with self.assertRaises(ExportLimitExceeded) as context:
               ExportService.exportar(
                   formato='csv',
                   usuario=self.usuario,
                   queryset=queryset,
                   filename='test'
               )
           
           exc = context.exception
           self.assertEqual(exc.count, 150_000)
           self.assertEqual(exc.limite, 100_000)
       
       def test_throttling_csv_10_diario(self):
           """CSV debe permitir máximo 10 exportaciones/día."""
           from reports.models import ExportThrottling
           from datetime import date
           
           # Simular 10 exportaciones ya hechas
           ExportThrottling.objects.create(
               usuario=self.usuario,
               formato='csv',
               fecha_ventana=date.today(),
               count_exportaciones=10,
               limite_diario=10
           )
           
           # Intentar exportación #11
           queryset = LlamadaIVR.objects.all()
           queryset.count = lambda: 1000
           
           with self.assertRaises(ThrottlingExceeded):
               ExportService.exportar(
                   formato='csv',
                   usuario=self.usuario,
                   queryset=queryset,
                   filename='test'
               )

============================================================
8. REFERENCIAS
============================================================

8.1 Documentos Relacionados
-----------------------------

:CNST_006: Reportes con rango máximo 2 años
:CNST_003: BD IVR readonly, datos desfasados
:CNST_001: NO Email (no envío de exportaciones)
:UC_022: Exportar reporte a CSV
:UC_023: Exportar reporte a Excel
:UC_024: Exportar reporte a PDF

8.2 Funciones RBAC Relacionadas
---------------------------------

:RPT_004: exporta_csv
:RPT_005: exporta_excel
:RPT_006: exporta_pdf

============================================================
9. HISTORIAL DE CAMBIOS
============================================================

.. list-table:: Historial de Versiones
   :header-rows: 1
   :widths: 15 15 70

   * - Versión
     - Fecha
     - Cambios
   * - 1.0.0
     - 2026-01-11
     - Versión inicial. Documentación completa de CNST_007:
       Límites de exportación (CSV 100K, Excel 50K, PDF 10K) y
       throttling diario (10, 5, 3 respectivamente). Incluye:
       implementación completa, excepciones, tests.

============================================================

.. note::
   **RECORDATORIO:**
   
   CNST_007 define límites estrictos de exportación:
   - CSV: 100K registros, 10/día, 60s timeout
   - Excel: 50K registros, 5/día, 90s timeout
   - PDF: 10K registros, 3/día, 120s timeout
   
   Estos límites son OBLIGATORIOS y NO NEGOCIABLES.
   Protegen performance y previenen abuso del sistema.

**FIN DEL DOCUMENTO CNST_007**
