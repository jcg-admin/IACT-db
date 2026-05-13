.. _CNST_006:

============================================================
CNST_006 - Reportes: Rango Máximo 2 Años
============================================================

:Restricción: CNST_006
:Versión: 1.0.0
:Fecha: 2026-01-11
:Estado: VIGENTE
:Prioridad: ALTA
:Ámbito: MOD_Reports - Todos los reportes y exportaciones
:Fundamento: Performance, gestión de recursos, UX
:Proyecto: IACT-2025-001
:Relacionado_Con: CNST_003 (Datos desfasados), CNST_007 (Límites exportación)

.. contents:: Tabla de Contenido
   :depth: 4
   :local:

============================================================
1. RESUMEN EJECUTIVO
============================================================

1.1 Definición de la Restricción
----------------------------------

   **Todos los reportes y consultas en el Sistema IACT tienen un rango 
   temporal MÁXIMO de 2 años (730 días).**
   
   **Características obligatorias:**
   
   1. **Rango Máximo:** Usuario NO puede consultar datos con un rango 
      mayor a 2 años entre fecha_inicio y fecha_fin.
   
   2. **Validación Automática:** El sistema valida el rango ANTES de 
      ejecutar la consulta. Si excede 2 años, rechaza la operación.
   
   3. **Mensaje Claro:** Error muestra el rango solicitado, el límite 
      permitido, y sugerencia de segmentar la consulta.
   
   4. **Aplica a TODO:** Reportes, dashboards, gráficos, exportaciones 
      (CSV, Excel, PDF), consultas API.

1.2 Justificación
------------------

**Performance:**

- Consultas >2 años pueden tardar minutos u horas
- Impacto en BD: Scans de millones de registros
- Timeout de navegador/aplicación
- Bloqueo de recursos para otros usuarios

**Gestión de Recursos:**

- Control de uso de CPU/memoria
- Prevención de queries "exploratorias" masivas
- Protección de estabilidad del sistema
- Uso justo de recursos compartidos

**Experiencia de Usuario:**

- Usuario espera respuestas rápidas (<5 segundos)
- Consultas >2 años raramente son útiles
- Fuerza análisis más enfocados y útiles
- Previene frustración por timeouts

**Modelo de Negocio:**

- Análisis típicos: mensual, trimestral, anual
- Comparaciones año vs año anterior (max 2 años)
- Tendencias de 2 años son suficientes para decisiones
- Análisis >2 años = outliers, mejor hacerlos offline

1.3 Impacto General
--------------------

.. list-table:: Impacto de CNST_006
   :header-rows: 1
   :widths: 30 70

   * - Aspecto
     - Impacto
   * - **Usuario Final**
     - • NO puede consultar rangos >2 años
       • Mensaje de error si intenta
       • Debe segmentar consultas grandes
       • UI muestra rango máximo permitido
   * - **Módulo Afectado**
     - MOD_Reports (todas las funciones)
   * - **Funciones RBAC**
     - • RPT-001: ve_reportes (validación obligatoria)
       • RPT-003: filtra_reportes (validación en filtros)
       • RPT-004-006: exporta_* (validación pre-exportación)
       • RPT-008: ve_graficos (validación en gráficos)
   * - **Infraestructura**
     - • Middleware de validación de rangos
       • Decorator @validate_date_range
       • Índices en BD por fecha
   * - **Performance**
     - • Queries más rápidos (<5 seg típico)
       • Uso controlado de recursos
       • No timeouts por consultas masivas

============================================================
2. ESPECIFICACIÓN TÉCNICA
============================================================

2.1 Límite de Rango
--------------------

.. code-block:: yaml

   RANGO_MAXIMO_DIAS: 730  # 2 años = 365 * 2
   RANGO_MAXIMO_ANOS: 2
   
   Validación:
     fecha_fin - fecha_inicio <= 730 días
   
   Comportamiento:
     - Si rango <= 730 días → Ejecutar consulta
     - Si rango > 730 días → Rechazar con error HTTP 400
   
   Mensaje de error:
     "Rango solicitado: 850 días (2.3 años)
      Rango máximo permitido: 730 días (2 años)
      
      Sugerencia: Segmenta tu consulta en periodos menores.
      Ejemplo: Consulta año 2024, luego año 2025 por separado."
   
   Excepciones: NINGUNA
   
   Casos especiales:
     - fecha_inicio = fecha_fin (1 día) → OK
     - fecha_inicio > fecha_fin → Error (rango inválido)
     - fecha_fin > HOY → Error (fecha futura)

2.2 Validación en Diferentes Contextos
----------------------------------------

**Reportes Tabulares (RPT-001):**

.. code-block:: python

   # Validar al cargar reporte
   GET /api/reports/trimestral?fecha_inicio=2023-01-01&fecha_fin=2025-12-31
   
   # Validación:
   (2025-12-31) - (2023-01-01) = 1,095 días > 730 días
   
   # Respuesta:
   HTTP 400 Bad Request
   {
       "error": "date_range_exceeded",
       "rango_solicitado_dias": 1095,
       "rango_maximo_dias": 730,
       "message": "Rango solicitado excede el límite de 2 años"
   }

**Filtros Dinámicos (RPT-003):**

.. code-block:: python

   # Usuario ajusta filtros en UI
   # Frontend valida ANTES de enviar request
   # Backend valida SIEMPRE (double-check)
   
   if (fecha_fin - fecha_inicio).days > 730:
       return {
           "error": "date_range_exceeded",
           "sugerencia": "Reduce el rango a máximo 2 años"
       }

**Exportaciones (RPT-004, RPT-005, RPT-006):**

.. code-block:: python

   # Validar ANTES de iniciar exportación
   # Evitar procesar datos para luego rechazar
   
   POST /api/reports/export/csv
   {
       "fecha_inicio": "2022-01-01",
       "fecha_fin": "2025-01-01"
   }
   
   # Validación:
   (2025-01-01) - (2022-01-01) = 1,096 días > 730 días
   
   # Respuesta inmediata (NO iniciar exportación):
   HTTP 400 Bad Request

**Gráficos (RPT-008):**

.. code-block:: python

   # Validar al generar gráfico
   # Gráficos con >2 años son ilegibles de todas formas
   
   GET /api/reports/grafico/llamadas-por-dia?inicio=2020-01-01&fin=2026-01-01
   
   # Validación: Rango > 2 años → Rechazar

2.3 Casos de Uso Permitidos
-----------------------------

.. list-table:: Ejemplos de Rangos Válidos
   :header-rows: 1
   :widths: 40 20 40

   * - Caso de Uso
     - Rango
     - ¿Permitido?
   * - Reporte mensual (enero 2026)
     - 31 días
     - ✅ SÍ
   * - Reporte trimestral (Q4 2025)
     - 92 días
     - ✅ SÍ
   * - Reporte anual (2025)
     - 365 días
     - ✅ SÍ
   * - Comparación año vs año anterior
     - 730 días
     - ✅ SÍ (justo en el límite)
   * - Últimos 2 años completos
     - 730 días
     - ✅ SÍ
   * - Últimos 3 años
     - 1,095 días
     - ❌ NO (excede límite)
   * - Histórico completo (5 años)
     - 1,825 días
     - ❌ NO (excede límite)
   * - Rango específico: 2023-01-01 a 2024-12-31
     - 730 días
     - ✅ SÍ
   * - Rango específico: 2022-06-01 a 2025-01-01
     - 945 días
     - ❌ NO (excede límite)

2.4 Sugerencias al Usuario
----------------------------

Cuando se rechaza un rango, el sistema sugiere alternativas:

.. code-block:: yaml

   Caso: Usuario solicita 2020-01-01 a 2026-01-01 (6 años)
   
   Sugerencia del sistema:
     "Tu consulta abarca 2,192 días (6 años).
      El rango máximo permitido es 730 días (2 años).
      
      Opciones:
      
      1. Segmenta por año:
         • 2020: Consulta 2020-01-01 a 2020-12-31
         • 2021: Consulta 2021-01-01 a 2021-12-31
         • ... (exporta cada año por separado)
      
      2. Enfoca tu análisis:
         • ¿Necesitas realmente 6 años?
         • Típicamente, 1-2 años son suficientes
         • Considera comparar 2025 vs 2024
      
      3. Solicita reporte especial:
         • Si necesitas análisis >2 años
         • Contacta equipo de BI
         • Generarán reporte offline"

============================================================
3. FUNCIONES RBAC AFECTADAS
============================================================

3.1 RPT-001: ve_reportes
--------------------------

.. code-block:: yaml

   Función: ve_reportes
   Capacidad: reports:ver
   Módulo: MOD_Reports
   
   Validación CNST_006:
     - SIEMPRE validar rango fecha_inicio → fecha_fin
     - Rechazar si rango > 730 días
     - Mostrar mensaje claro
   
   Proceso:
     1. Usuario selecciona fechas en UI
     2. Frontend valida rango (primera capa)
     3. Usuario envía request
     4. Backend valida rango (segunda capa - obligatoria)
     5. Si OK → Ejecutar query → Mostrar reporte
     6. Si NO → HTTP 400 → Mostrar error
   
   Casos de Uso: UC-017, UC-018, UC-019

3.2 RPT-003: filtra_reportes
-----------------------------

.. code-block:: yaml

   Función: filtra_reportes
   Capacidad: reports:filtrar
   Módulo: MOD_Reports
   
   Validación CNST_006:
     - Validar al aplicar filtros de fecha
     - Validar cambios dinámicos de rango
     - Prevenir "date picker" abuse
   
   Escenario problemático (prevenido):
     Usuario en reporte de 1 mes (OK)
     → Cambia fecha_inicio a 3 años atrás
     → Sistema DEBE validar nuevo rango
     → Rechazar si excede 2 años
   
   Casos de Uso: UC-020, UC-021

3.3 RPT-004/005/006: exporta_csv/excel/pdf
-------------------------------------------

.. code-block:: yaml

   Funciones: exporta_csv, exporta_excel, exporta_pdf
   Capacidades: reports:exportar_csv, reports:exportar_excel, reports:exportar_pdf
   Módulo: MOD_Reports
   
   Validación CNST_006:
     - Validar ANTES de iniciar exportación
     - Crítico: Evitar procesar datos innecesariamente
     - CNST_007 también aplica (límites de registros)
   
   Proceso:
     1. Usuario solicita exportación
     2. Validar rango de fechas (CNST_006)
     3. Validar límite de registros (CNST_007)
     4. Si ambos OK → Iniciar exportación
     5. Si alguno NO → Rechazar inmediatamente
   
   Casos de Uso: UC-022, UC-023, UC-024

3.4 RPT-008: ve_graficos
-------------------------

.. code-block:: yaml

   Función: ve_graficos
   Capacidad: reports:graficos
   Módulo: MOD_Reports
   
   Validación CNST_006:
     - Validar rangos en gráficos
     - Gráficos >2 años = ilegibles
     - Forzar granularidad apropiada
   
   Recomendaciones adicionales:
     - 1-7 días → Granularidad por hora
     - 1-3 meses → Granularidad por día
     - 3-12 meses → Granularidad por semana
     - 1-2 años → Granularidad por mes
   
   Casos de Uso: UC-027, UC-028, UC-029

============================================================
4. IMPLEMENTACIÓN DJANGO
============================================================

4.1 Validador de Rango de Fechas
----------------------------------

.. code-block:: python

   # file: reports/validators.py
   from datetime import timedelta, date
   from django.core.exceptions import ValidationError
   
   class DateRangeValidator:
       """
       Validador de rangos de fechas.
       
       Implementa CNST_006: Rango máximo 2 años (730 días).
       """
       
       MAX_DIAS = 730  # 2 años
       MAX_ANOS = 2
       
       @classmethod
       def validar_rango(cls, fecha_inicio, fecha_fin):
           """
           Valida que el rango no exceda 2 años.
           
           Args:
               fecha_inicio: datetime.date o str (YYYY-MM-DD)
               fecha_fin: datetime.date o str (YYYY-MM-DD)
           
           Raises:
               ValidationError: Si rango es inválido
           
           Returns:
               tuple: (fecha_inicio, fecha_fin) convertidas a date
           """
           # Convertir a date si son strings
           if isinstance(fecha_inicio, str):
               fecha_inicio = date.fromisoformat(fecha_inicio)
           
           if isinstance(fecha_fin, str):
               fecha_fin = date.fromisoformat(fecha_fin)
           
           # Validación 1: fecha_inicio <= fecha_fin
           if fecha_inicio > fecha_fin:
               raise ValidationError({
                   'error': 'invalid_date_range',
                   'message': 'La fecha de inicio debe ser menor o igual a la fecha de fin',
                   'fecha_inicio': str(fecha_inicio),
                   'fecha_fin': str(fecha_fin)
               })
           
           # Validación 2: fecha_fin no puede ser futura
           hoy = date.today()
           if fecha_fin > hoy:
               raise ValidationError({
                   'error': 'future_date',
                   'message': 'La fecha de fin no puede ser futura',
                   'fecha_fin': str(fecha_fin),
                   'fecha_actual': str(hoy)
               })
           
           # Validación 3: Rango máximo 2 años (CNST_006)
           delta = fecha_fin - fecha_inicio
           dias_solicitados = delta.days + 1  # +1 para incluir ambos días
           
           if dias_solicitados > cls.MAX_DIAS:
               anos_solicitados = round(dias_solicitados / 365, 1)
               
               raise ValidationError({
                   'error': 'date_range_exceeded',
                   'message': f'Rango solicitado excede el límite de {cls.MAX_ANOS} años',
                   'rango_solicitado_dias': dias_solicitados,
                   'rango_solicitado_anos': anos_solicitados,
                   'rango_maximo_dias': cls.MAX_DIAS,
                   'rango_maximo_anos': cls.MAX_ANOS,
                   'sugerencia': (
                       f'Segmenta tu consulta en periodos menores. '
                       f'Ejemplo: Consulta cada año por separado.'
                   ),
                   'fecha_inicio': str(fecha_inicio),
                   'fecha_fin': str(fecha_fin)
               })
           
           return fecha_inicio, fecha_fin
       
       @classmethod
       def sugerir_segmentacion(cls, fecha_inicio, fecha_fin):
           """
           Sugiere cómo segmentar un rango grande.
           
           Args:
               fecha_inicio: datetime.date
               fecha_fin: datetime.date
           
           Returns:
               list: Lista de rangos sugeridos
           """
           rangos = []
           actual = fecha_inicio
           
           while actual <= fecha_fin:
               # Segmentar por año
               fin_segmento = min(
                   actual.replace(month=12, day=31),
                   fecha_fin
               )
               
               rangos.append({
                   'inicio': str(actual),
                   'fin': str(fin_segmento),
                   'descripcion': f'Año {actual.year}'
               })
               
               # Siguiente año
               actual = actual.replace(year=actual.year + 1, month=1, day=1)
           
           return rangos

4.2 Decorador de Validación
-----------------------------

.. code-block:: python

   # file: reports/decorators.py
   from functools import wraps
   from django.http import JsonResponse
   from .validators import DateRangeValidator
   from django.core.exceptions import ValidationError
   
   def validate_date_range(param_inicio='fecha_inicio', param_fin='fecha_fin'):
       """
       Decorador que valida rango de fechas en requests.
       
       Implementa CNST_006.
       
       Args:
           param_inicio: Nombre del parámetro de fecha inicio
           param_fin: Nombre del parámetro de fecha fin
       
       Usage:
           @validate_date_range()
           def mi_vista(request):
               # fecha_inicio y fecha_fin ya validadas
               ...
       """
       def decorator(view_func):
           @wraps(view_func)
           def _wrapped_view(request, *args, **kwargs):
               # Obtener parámetros de fecha
               if request.method == 'GET':
                   params = request.GET
               else:
                   params = request.POST or request.data
               
               fecha_inicio = params.get(param_inicio)
               fecha_fin = params.get(param_fin)
               
               if not fecha_inicio or not fecha_fin:
                   return JsonResponse({
                       'error': 'missing_dates',
                       'message': f'Se requieren parámetros {param_inicio} y {param_fin}'
                   }, status=400)
               
               # Validar rango (CNST_006)
               try:
                   fecha_inicio, fecha_fin = DateRangeValidator.validar_rango(
                       fecha_inicio, 
                       fecha_fin
                   )
               except ValidationError as e:
                   return JsonResponse(e.message_dict, status=400)
               
               # Inyectar fechas validadas en request
               request.fecha_inicio_validada = fecha_inicio
               request.fecha_fin_validada = fecha_fin
               
               return view_func(request, *args, **kwargs)
           
           return _wrapped_view
       return decorator

4.3 Ejemplo de Vista con Validación
-------------------------------------

.. code-block:: python

   # file: reports/views.py
   from django.views.generic import TemplateView
   from django.utils.decorators import method_decorator
   from .decorators import validate_date_range
   from core.decorators import require_function
   
   @method_decorator(require_function('ve_reportes'), name='dispatch')
   @method_decorator(validate_date_range(), name='dispatch')
   class ReporteTrimestralView(TemplateView):
       """
       Vista de reporte trimestral.
       
       CNST_006 validado automáticamente por @validate_date_range.
       """
       template_name = 'reportes/trimestral.html'
       
       def get_context_data(self, **kwargs):
           context = super().get_context_data(**kwargs)
           
           # Fechas ya validadas por decorador
           fecha_inicio = self.request.fecha_inicio_validada
           fecha_fin = self.request.fecha_fin_validada
           
           # Ejecutar query (sabemos que rango es válido)
           from llamadas.models import LlamadaIVR
           
           llamadas = LlamadaIVR.objects.filter(
               fecha_llamada__gte=fecha_inicio,
               fecha_llamada__lte=fecha_fin,
               segmento_id=self.request.user.segmento_id  # CNST_005
           )
           
           context['llamadas'] = llamadas
           context['fecha_inicio'] = fecha_inicio
           context['fecha_fin'] = fecha_fin
           context['dias_consultados'] = (fecha_fin - fecha_inicio).days + 1
           
           return context

4.4 API REST con Validación
-----------------------------

.. code-block:: python

   # file: reports/api.py
   from rest_framework.decorators import api_view, permission_classes
   from rest_framework.permissions import IsAuthenticated
   from rest_framework.response import Response
   from .decorators import validate_date_range
   from core.decorators import require_function
   
   @api_view(['GET'])
   @permission_classes([IsAuthenticated])
   @require_function('ve_reportes')
   @validate_date_range()
   def api_reporte_llamadas(request):
       """
       API: Reporte de llamadas por rango de fechas.
       
       GET /api/reports/llamadas?fecha_inicio=2025-01-01&fecha_fin=2025-12-31
       
       CNST_006: Validado automáticamente, máx 2 años.
       """
       # Fechas ya validadas
       fecha_inicio = request.fecha_inicio_validada
       fecha_fin = request.fecha_fin_validada
       
       # Query
       from llamadas.models import LlamadaIVR
       
       llamadas = LlamadaIVR.objects.filter(
           fecha_llamada__gte=fecha_inicio,
           fecha_llamada__lte=fecha_fin,
           segmento_id=request.user.segmento_id
       ).values(
           'fecha_llamada', 
           'centro_id', 
           'duracion_total'
       )
       
       return Response({
           'fecha_inicio': str(fecha_inicio),
           'fecha_fin': str(fecha_fin),
           'total_llamadas': llamadas.count(),
           'llamadas': list(llamadas[:1000])  # Limitar respuesta
       })

============================================================
5. VALIDACIÓN FRONTEND
============================================================

5.1 JavaScript: Validación en UI
----------------------------------

.. code-block:: javascript

   // file: static/js/date-range-validator.js
   
   /**
    * Validador de rangos de fechas (CNST_006)
    */
   class DateRangeValidator {
       static MAX_DIAS = 730;  // 2 años
       
       /**
        * Valida un rango de fechas.
        * 
        * @param {string} fechaInicio - Fecha en formato YYYY-MM-DD
        * @param {string} fechaFin - Fecha en formato YYYY-MM-DD
        * @returns {Object} {valid: boolean, error: string}
        */
       static validar(fechaInicio, fechaFin) {
           const inicio = new Date(fechaInicio);
           const fin = new Date(fechaFin);
           const hoy = new Date();
           
           // Validar que inicio <= fin
           if (inicio > fin) {
               return {
                   valid: false,
                   error: 'La fecha de inicio debe ser menor o igual a la fecha de fin'
               };
           }
           
           // Validar que fin no sea futura
           if (fin > hoy) {
               return {
                   valid: false,
                   error: 'La fecha de fin no puede ser futura'
               };
           }
           
           // Validar rango máximo 2 años
           const diffMs = fin - inicio;
           const diffDias = Math.ceil(diffMs / (1000 * 60 * 60 * 24)) + 1;
           
           if (diffDias > this.MAX_DIAS) {
               const anos = (diffDias / 365).toFixed(1);
               
               return {
                   valid: false,
                   error: `Rango solicitado: ${diffDias} días (${anos} años).\n` +
                          `Rango máximo permitido: ${this.MAX_DIAS} días (2 años).\n\n` +
                          `Reduce el rango o segmenta tu consulta.`,
                   diasSolicitados: diffDias,
                   diasMaximos: this.MAX_DIAS
               };
           }
           
           return {
               valid: true,
               diasConsultados: diffDias
           };
       }
       
       /**
        * Inicializa validación en formulario.
        */
       static initForm(formSelector) {
           const form = document.querySelector(formSelector);
           if (!form) return;
           
           const inputInicio = form.querySelector('[name="fecha_inicio"]');
           const inputFin = form.querySelector('[name="fecha_fin"]');
           
           // Validar al cambiar fechas
           const validarRango = () => {
               const resultado = this.validar(
                   inputInicio.value,
                   inputFin.value
               );
               
               if (!resultado.valid) {
                   // Mostrar error
                   alert(resultado.error);
                   inputFin.value = '';
                   return false;
               }
               
               // Mostrar días consultados
               const badge = form.querySelector('.dias-badge');
               if (badge) {
                   badge.textContent = `${resultado.diasConsultados} días`;
               }
               
               return true;
           };
           
           inputInicio.addEventListener('change', validarRango);
           inputFin.addEventListener('change', validarRango);
           
           // Validar al enviar
           form.addEventListener('submit', (e) => {
               if (!validarRango()) {
                   e.preventDefault();
               }
           });
       }
   }
   
   // Inicializar en todos los formularios de reportes
   document.addEventListener('DOMContentLoaded', () => {
       DateRangeValidator.initForm('#form-reporte');
   });

5.2 HTML: Date Pickers con Límite
-----------------------------------

.. code-block:: html

   <!-- Template de formulario de reporte -->
   <form id="form-reporte" method="GET" action="/reports/trimestral">
       <div class="form-group">
           <label for="fecha_inicio">Fecha Inicio:</label>
           <input 
               type="date" 
               id="fecha_inicio" 
               name="fecha_inicio" 
               required
               max="{{ fecha_maxima }}"
           >
       </div>
       
       <div class="form-group">
           <label for="fecha_fin">Fecha Fin:</label>
           <input 
               type="date" 
               id="fecha_fin" 
               name="fecha_fin" 
               required
               max="{{ fecha_maxima }}"
           >
       </div>
       
       <!-- Indicador de rango -->
       <div class="alert alert-info">
           <strong>Rango:</strong> 
           <span class="dias-badge">-</span>
           <small class="text-muted">(máximo 730 días / 2 años)</small>
       </div>
       
       <button type="submit" class="btn btn-primary">
           Generar Reporte
       </button>
   </form>

============================================================
6. VALIDACIÓN Y TESTING
============================================================

6.1 Tests Unitarios
--------------------

.. code-block:: python

   # file: tests/test_cnst_006.py
   from django.test import TestCase
   from datetime import date, timedelta
   from django.core.exceptions import ValidationError
   from reports.validators import DateRangeValidator
   
   class TestCNST006(TestCase):
       """
       Tests para validar CNST_006: Rango máximo 2 años
       """
       
       def test_rango_valido_1_mes(self):
           """Rango de 1 mes debe ser válido."""
           inicio = date(2025, 1, 1)
           fin = date(2025, 1, 31)
           
           # No debe lanzar excepción
           inicio_val, fin_val = DateRangeValidator.validar_rango(inicio, fin)
           
           self.assertEqual(inicio_val, inicio)
           self.assertEqual(fin_val, fin)
       
       def test_rango_valido_2_anos_exacto(self):
           """Rango de exactamente 2 años (730 días) debe ser válido."""
           inicio = date(2024, 1, 1)
           fin = date(2025, 12, 31)
           
           delta = fin - inicio
           self.assertEqual(delta.days + 1, 730)  # +1 incluye ambos días
           
           # No debe lanzar excepción
           DateRangeValidator.validar_rango(inicio, fin)
       
       def test_rango_invalido_3_anos(self):
           """Rango >2 años debe ser rechazado."""
           inicio = date(2023, 1, 1)
           fin = date(2026, 1, 1)
           
           # Debe lanzar ValidationError
           with self.assertRaises(ValidationError) as context:
               DateRangeValidator.validar_rango(inicio, fin)
           
           error = context.exception.message_dict
           self.assertEqual(error['error'], 'date_range_exceeded')
           self.assertGreater(error['rango_solicitado_dias'], 730)
       
       def test_fecha_inicio_mayor_que_fin(self):
           """fecha_inicio > fecha_fin debe ser rechazado."""
           inicio = date(2025, 12, 31)
           fin = date(2025, 1, 1)
           
           with self.assertRaises(ValidationError) as context:
               DateRangeValidator.validar_rango(inicio, fin)
           
           error = context.exception.message_dict
           self.assertEqual(error['error'], 'invalid_date_range')
       
       def test_fecha_futura(self):
           """Fecha fin futura debe ser rechazada."""
           inicio = date(2025, 1, 1)
           fin = date(2030, 1, 1)  # Futura
           
           with self.assertRaises(ValidationError) as context:
               DateRangeValidator.validar_rango(inicio, fin)
           
           error = context.exception.message_dict
           self.assertEqual(error['error'], 'future_date')

6.2 Tests de Integración
--------------------------

.. code-block:: python

   # file: tests/test_reports_integration.py
   from django.test import TestCase, Client
   from users.models import Usuario
   
   class TestReportsDateRange(TestCase):
       def setUp(self):
           self.client = Client()
           self.usuario = Usuario.objects.create_user(
               username='testuser',
               password='testpass123'
           )
           self.client.login(username='testuser', password='testpass123')
       
       def test_reporte_con_rango_valido(self):
           """Reporte con rango válido debe funcionar."""
           response = self.client.get('/api/reports/llamadas', {
               'fecha_inicio': '2025-01-01',
               'fecha_fin': '2025-12-31'
           })
           
           self.assertEqual(response.status_code, 200)
       
       def test_reporte_con_rango_invalido(self):
           """Reporte con rango >2 años debe ser rechazado."""
           response = self.client.get('/api/reports/llamadas', {
               'fecha_inicio': '2020-01-01',
               'fecha_fin': '2025-12-31'
           })
           
           self.assertEqual(response.status_code, 400)
           data = response.json()
           self.assertEqual(data['error'], 'date_range_exceeded')

============================================================
7. CASOS ESPECIALES
============================================================

7.1 Análisis Multi-Año
------------------------

Si un usuario REALMENTE necesita analizar >2 años:

**Opción 1: Segmentar manualmente**

.. code-block:: python

   # Usuario hace múltiples consultas
   
   # Consulta 1: Año 2023
   GET /api/reports/llamadas?fecha_inicio=2023-01-01&fecha_fin=2023-12-31
   
   # Consulta 2: Año 2024
   GET /api/reports/llamadas?fecha_inicio=2024-01-01&fecha_fin=2024-12-31
   
   # Consulta 3: Año 2025
   GET /api/reports/llamadas?fecha_inicio=2025-01-01&fecha_fin=2025-12-31
   
   # Usuario consolida resultados localmente (Excel, Python, etc.)

**Opción 2: Reporte offline (equipo BI)**

.. code-block:: yaml

   Proceso:
     1. Usuario solicita reporte especial vía ticket
     2. Equipo BI genera reporte offline (sin límite de rango)
     3. Reporte se procesa en horario de baja carga
     4. Resultado se entrega vía archivo compartido
     5. NO impacta sistema productivo

7.2 Agregaciones Pre-calculadas
---------------------------------

Para tendencias de largo plazo, usar agregaciones:

.. code-block:: sql

   -- Tabla de agregaciones mensuales (pre-calculada)
   CREATE TABLE agregaciones_mensuales (
       mes DATE PRIMARY KEY,
       centro_id VARCHAR(10),
       total_llamadas INT,
       duracion_promedio DECIMAL(10,2),
       abandono_porcentaje DECIMAL(5,2),
       -- ... otros KPIs
   );
   
   -- Consulta de 5 años en agregaciones es rápida
   SELECT mes, total_llamadas
   FROM agregaciones_mensuales
   WHERE mes >= '2020-01-01' AND mes <= '2025-01-01';
   
   -- Porque son solo 60 registros (5 años * 12 meses)

============================================================
8. REFERENCIAS
============================================================

8.1 Documentos Relacionados
-----------------------------

:CNST_003: BD IVR readonly, datos desfasados
:CNST_007: Límites de exportación, throttling
:UC_017: Reporte trimestral de llamadas
:UC_018: Reporte de problemas de menú
:UC_019: Reporte de transferencias por centro
:UC_020: Aplicar filtros de fecha
:UC_021: Aplicar filtros de centro
:UC_022-024: Exportar reportes (CSV, Excel, PDF)

8.2 Funciones RBAC Relacionadas
---------------------------------

:RPT_001: ve_reportes
:RPT_003: filtra_reportes
:RPT_004: exporta_csv
:RPT_005: exporta_excel
:RPT_006: exporta_pdf
:RPT_008: ve_graficos

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
     - Versión inicial. Documentación completa de CNST_006:
       Rango máximo 2 años (730 días) para todos los reportes.
       Incluye: validadores, decoradores, frontend, tests.

============================================================

.. note::
   **RECORDATORIO:**
   
   CNST_006 aplica a TODOS los reportes y consultas:
   - Rango máximo: 730 días (2 años)
   - Validación: Frontend + Backend (obligatoria)
   - Rechazo: HTTP 400 con mensaje claro
   - Sugerencia: Segmentar consultas grandes
   
   Esta restricción protege performance y UX del sistema.

**FIN DEL DOCUMENTO CNST_006**
