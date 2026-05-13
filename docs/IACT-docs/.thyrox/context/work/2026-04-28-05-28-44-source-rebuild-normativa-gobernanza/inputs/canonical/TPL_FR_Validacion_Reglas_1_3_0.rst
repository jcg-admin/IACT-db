.. meta::
   :Proyecto: IACT
   :Codigo: FR-MOD-NN-ZZ
   :Titulo: Titulo del Functional Requirement - Validacion
   :Version: 1.0.0
   :Derivado_De: UC-IACT-MOD-NN paso X
   :Tipo: Validacion
   :Fecha: YYYY-MM-DD
   :Autor: Nombre del Developer
   :Estado: DRAFT|REVIEW|APPROVED|IMPLEMENTED

======================================================================
FR-MOD-NN-ZZ: Titulo del Functional Requirement - Validacion
======================================================================

**Proyecto:** IACT - IVR Analytics & Customer Tracking  
**Derivado De:** UC-IACT-MOD-NN paso X  
**Tipo:** Validacion  
**Estado:** DRAFT|REVIEW|APPROVED|IMPLEMENTED  
**Prioridad:** Alta|Media|Baja  
**Clasificacion:** C2 - INTERNAL

----------------------------------------------------------------------
INTRODUCCION AL TEMPLATE
----------------------------------------------------------------------

Este template documenta Functional Requirements cuya funcion principal
es validar inputs de usuario o datos del sistema antes de procesarlos.

**Cuando Usar Este Template:**

Use este template cuando:

1. El FR valida inputs de formularios o APIs
2. Hay multiples reglas de validacion (V-1 a V-N)
3. Necesita validacion client-side Y server-side
4. Mensajes de error especificos son importantes
5. Requiere sanitizacion de inputs

**Cuando NO Usar Este Template:**

NO use este template para:

- FR que no validan datos
- Validaciones triviales (solo una regla simple)
- Calculos o queries

**Tipos de Validacion:**

1. **Tipo de Dato:** ¿Es string/int/float/date?
2. **Rango:** ¿Esta en min-max?
3. **Conjunto:** ¿Esta en lista permitida?
4. **Formato:** ¿Cumple regex/patron?
5. **Longitud:** ¿Cumple min/max caracteres?
6. **Existencia:** ¿Existe en BD?
7. **Unicidad:** ¿Es unico en BD?
8. **Relacion:** ¿Cumple constraint de FK?
9. **Logica Negocio:** ¿Cumple regla custom?

**Principios de Validacion:**

1. **Fail Fast:** Validar antes de procesar
2. **Client-Side:** Feedback inmediato al usuario
3. **Server-Side:** SIEMPRE validar (seguridad)
4. **Mensajes Claros:** Usuario debe entender que esta mal
5. **Sanitizacion:** Limpiar inputs peligrosos

**Estructura de Este Template:**

1. Catalogo completo de reglas V-1 a V-N
2. Validacion client-side (JavaScript/React)
3. Validacion server-side (Python)
4. Mensajes de error especificos
5. Tests exhaustivos

----------------------------------------------------------------------
1. CATALOGO DE VALIDACIONES
----------------------------------------------------------------------

**Proposito:**

Documentar cada regla de validacion con codigo, mensaje de error,
y ejemplos.

**Formato por Regla:**

V-N: Titulo de la Validacion

**Condicion:** Que debe cumplirse

**Tipo:** Tipo de validacion (ver lista arriba)

**Mensaje Error:** Mensaje exacto si falla

**Valores Validos:** Ejemplos que pasan validacion

**Valores Invalidos:** Ejemplos que fallan validacion

**Codigo:**

.. code-block:: python

   if not condicion:
       raise ValidationError("mensaje")

**EJEMPLO COMPLETO (FR-RPT-01-01):**

**FR-RPT-01-01: Validar Parametros de Reporte Trimestral**

**Inputs a Validar:**

- quarter: Trimestre (Q1, Q2, Q3, Q4)
- year: Año (2020 a año actual)
- segment: Segmento (OP, MG)

V-1: Quarter Valido
~~~~~~~~~~~~~~~~~~~

**Condicion:**

El parametro quarter debe ser exactamente uno de los valores:
Q1, Q2, Q3, Q4 (case-sensitive)

**Tipo:** Conjunto (whitelist)

**Mensaje Error:**

"Trimestre inválido: debe ser Q1, Q2, Q3 o Q4"

**Valores Validos:**

- 'Q1' → PASS
- 'Q2' → PASS
- 'Q3' → PASS
- 'Q4' → PASS

**Valores Invalidos:**

- 'q1' → FAIL (lowercase)
- 'Q5' → FAIL (no existe)
- '1' → FAIL (solo numero)
- 'Quarter1' → FAIL (formato incorrecto)
- '' → FAIL (vacio)
- None → FAIL (null)

**Codigo Python:**

.. code-block:: python

   VALID_QUARTERS = ['Q1', 'Q2', 'Q3', 'Q4']
   
   if quarter not in VALID_QUARTERS:
       raise ValidationError(
           f"Trimestre inválido: {quarter}. "
           f"Debe ser uno de: {', '.join(VALID_QUARTERS)}"
       )

V-2: Year en Rango Valido
~~~~~~~~~~~~~~~~~~~~~~~~~~

**Condicion:**

El año debe ser un entero entre 2020 y el año actual (inclusive)

**Tipo:** Rango numérico

**Mensaje Error:**

"Año inválido: debe estar entre 2020 y YYYY"

**Valores Validos:**

- 2020 → PASS (min)
- 2024 → PASS (actual)
- 2022 → PASS (medio)

**Valores Invalidos:**

- 2019 → FAIL (menor min)
- 2025 → FAIL (mayor actual si actual = 2024)
- '2024' → FAIL (string, no int)
- 2024.5 → FAIL (float, no int)
- -2024 → FAIL (negativo)
- 0 → FAIL (fuera de rango)

**Codigo Python:**

.. code-block:: python

   from datetime import datetime
   
   CURRENT_YEAR = datetime.now().year
   MIN_YEAR = 2020
   
   # Validar tipo
   if not isinstance(year, int):
       raise ValidationError(
           f"Año debe ser entero, recibido: {type(year).__name__}"
       )
   
   # Validar rango
   if not (MIN_YEAR <= year <= CURRENT_YEAR):
       raise ValidationError(
           f"Año inválido: {year}. "
           f"Debe estar entre {MIN_YEAR} y {CURRENT_YEAR}"
       )

V-3: Segment Valido
~~~~~~~~~~~~~~~~~~~

**Condicion:**

El segmento debe ser 'OP' (Operaciones) o 'MG' (Management)

**Tipo:** Conjunto (enum)

**Mensaje Error:**

"Segmento inválido: debe ser OP o MG"

**Valores Validos:**

- 'OP' → PASS
- 'MG' → PASS

**Valores Invalidos:**

- 'op' → FAIL (lowercase)
- 'Operations' → FAIL (nombre completo)
- 'O' → FAIL (abreviacion)
- 'OP,MG' → FAIL (multiple)
- '' → FAIL (vacio)

**Codigo Python:**

.. code-block:: python

   VALID_SEGMENTS = ['OP', 'MG']
   
   if segment not in VALID_SEGMENTS:
       raise ValidationError(
           f"Segmento inválido: {segment}. "
           f"Debe ser uno de: {', '.join(VALID_SEGMENTS)}"
       )

V-4: Trimestre No en el Futuro
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Condicion:**

El trimestre consultado no debe estar en el futuro. Por ejemplo,
si estamos en Q2 2024, no se puede consultar Q3 2024.

**Tipo:** Logica de negocio temporal

**Mensaje Error:**

"No se puede consultar trimestre futuro: QX YYYY"

**Valores Validos:**

Asumiendo fecha actual: 15 Mayo 2024 (Q2)

- Q1 2024 → PASS (pasado)
- Q2 2024 → PASS (actual)
- Q4 2023 → PASS (pasado)
- Q1 2020 → PASS (pasado lejano)

**Valores Invalidos:**

- Q3 2024 → FAIL (futuro)
- Q4 2024 → FAIL (futuro)
- Q1 2025 → FAIL (futuro lejano)

**Codigo Python:**

.. code-block:: python

   from datetime import datetime
   
   # Mapeo trimestre a mes de inicio
   QUARTER_START_MONTH = {
       'Q1': 1,  # Enero
       'Q2': 4,  # Abril
       'Q3': 7,  # Julio
       'Q4': 10  # Octubre
   }
   
   # Fecha del trimestre consultado
   query_date = datetime(year, QUARTER_START_MONTH[quarter], 1)
   
   # Fecha actual
   current_date = datetime.now()
   
   # Validar no futuro
   if query_date > current_date:
       raise ValidationError(
           f"No se puede consultar trimestre futuro: {quarter} {year}"
       )

V-5: Tipos de Datos Correctos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Condicion:**

Cada parametro debe tener el tipo de dato correcto:
- quarter: str
- year: int
- segment: str

**Tipo:** Tipo de dato

**Mensaje Error:**

"Tipo incorrecto para PARAMETRO: esperado TIPO, recibido TIPO"

**Codigo Python:**

.. code-block:: python

   # Validar quarter es string
   if not isinstance(quarter, str):
       raise ValidationError(
           f"Tipo incorrecto para quarter: "
           f"esperado str, recibido {type(quarter).__name__}"
       )
   
   # Validar year es int
   if not isinstance(year, int):
       raise ValidationError(
           f"Tipo incorrecto para year: "
           f"esperado int, recibido {type(year).__name__}"
       )
   
   # Validar segment es string
   if not isinstance(segment, str):
       raise ValidationError(
           f"Tipo incorrecto para segment: "
           f"esperado str, recibido {type(segment).__name__}"
       )

V-6: Parametros No Vacios
~~~~~~~~~~~~~~~~~~~~~~~~~~

**Condicion:**

Ningún parámetro puede ser vacío, None, o solo espacios en blanco

**Tipo:** Presencia/Required

**Mensaje Error:**

"PARAMETRO es requerido y no puede estar vacío"

**Codigo Python:**

.. code-block:: python

   # Validar quarter no vacio
   if not quarter or (isinstance(quarter, str) and not quarter.strip()):
       raise ValidationError("Quarter es requerido y no puede estar vacío")
   
   # Validar year no None
   if year is None:
       raise ValidationError("Year es requerido")
   
   # Validar segment no vacio
   if not segment or (isinstance(segment, str) and not segment.strip()):
       raise ValidationError("Segment es requerido y no puede estar vacío")

----------------------------------------------------------------------
2. VALIDACION CLIENT-SIDE
----------------------------------------------------------------------

**Proposito:**

Validar en el navegador para feedback inmediato al usuario, ANTES
de enviar al servidor.

**Tecnologias:**

- JavaScript vanilla
- React con hooks
- HTML5 validation attributes

**Ventajas:**

- Feedback inmediato (UX)
- Reduce carga del servidor
- Menos llamadas API fallidas

**Limitaciones:**

- Usuario puede desactivar JavaScript
- Usuario puede manipular validation
- SIEMPRE validar server-side tambien

**CODIGO COMPLETO (FR-RPT-01-01):**

**React Component con Validacion:**

.. code-block:: javascript

   import React, { useState } from 'react';
   
   function QuarterlyReportForm() {
       const [formData, setFormData] = useState({
           quarter: '',
           year: new Date().getFullYear(),
           segment: 'OP'
       });
       
       const [errors, setErrors] = useState({});
       
       // Constantes de validacion
       const VALID_QUARTERS = ['Q1', 'Q2', 'Q3', 'Q4'];
       const VALID_SEGMENTS = ['OP', 'MG'];
       const MIN_YEAR = 2020;
       const CURRENT_YEAR = new Date().getFullYear();
       
       /**
        * Validates all form inputs.
        * Returns object with errors or empty object if valid.
        */
       const validateForm = () => {
           const newErrors = {};
           
           // V-1: Quarter valido
           if (!formData.quarter) {
               newErrors.quarter = 'Trimestre es requerido';
           } else if (!VALID_QUARTERS.includes(formData.quarter)) {
               newErrors.quarter = `Trimestre inválido. Debe ser: ${VALID_QUARTERS.join(', ')}`;
           }
           
           // V-2: Year valido
           if (!formData.year) {
               newErrors.year = 'Año es requerido';
           } else if (typeof formData.year !== 'number') {
               newErrors.year = 'Año debe ser un número';
           } else if (formData.year < MIN_YEAR || formData.year > CURRENT_YEAR) {
               newErrors.year = `Año debe estar entre ${MIN_YEAR} y ${CURRENT_YEAR}`;
           }
           
           // V-3: Segment valido
           if (!formData.segment) {
               newErrors.segment = 'Segmento es requerido';
           } else if (!VALID_SEGMENTS.includes(formData.segment)) {
               newErrors.segment = `Segmento inválido. Debe ser: ${VALID_SEGMENTS.join(', ')}`;
           }
           
           // V-4: Trimestre no futuro
           if (formData.quarter && formData.year) {
               const quarterStartMonth = {
                   'Q1': 0, 'Q2': 3, 'Q3': 6, 'Q4': 9
               };
               
               const queryDate = new Date(
                   formData.year, 
                   quarterStartMonth[formData.quarter], 
                   1
               );
               
               const currentDate = new Date();
               
               if (queryDate > currentDate) {
                   newErrors.quarter = `No se puede consultar trimestre futuro: ${formData.quarter} ${formData.year}`;
               }
           }
           
           return newErrors;
       };
       
       /**
        * Validates single field on change for immediate feedback.
        */
       const validateField = (name, value) => {
           const newErrors = { ...errors };
           
           switch(name) {
               case 'quarter':
                   if (!value) {
                       newErrors.quarter = 'Trimestre es requerido';
                   } else if (!VALID_QUARTERS.includes(value)) {
                       newErrors.quarter = 'Trimestre inválido';
                   } else {
                       delete newErrors.quarter;
                   }
                   break;
               
               case 'year':
                   const yearNum = parseInt(value);
                   if (!yearNum) {
                       newErrors.year = 'Año es requerido';
                   } else if (yearNum < MIN_YEAR || yearNum > CURRENT_YEAR) {
                       newErrors.year = `Año debe estar entre ${MIN_YEAR} y ${CURRENT_YEAR}`;
                   } else {
                       delete newErrors.year;
                   }
                   break;
               
               case 'segment':
                   if (!value) {
                       newErrors.segment = 'Segmento es requerido';
                   } else if (!VALID_SEGMENTS.includes(value)) {
                       newErrors.segment = 'Segmento inválido';
                   } else {
                       delete newErrors.segment;
                   }
                   break;
           }
           
           setErrors(newErrors);
       };
       
       const handleChange = (e) => {
           const { name, value } = e.target;
           
           // Update form data
           setFormData(prev => ({
               ...prev,
               [name]: name === 'year' ? parseInt(value) : value
           }));
           
           // Validate field immediately
           validateField(name, value);
       };
       
       const handleSubmit = async (e) => {
           e.preventDefault();
           
           // Validate all fields
           const validationErrors = validateForm();
           
           if (Object.keys(validationErrors).length > 0) {
               setErrors(validationErrors);
               return;
           }
           
           // Clear errors
           setErrors({});
           
           // Submit to server
           try {
               const response = await fetch('/api/reports/quarterly', {
                   method: 'POST',
                   headers: { 'Content-Type': 'application/json' },
                   body: JSON.stringify(formData)
               });
               
               if (!response.ok) {
                   const errorData = await response.json();
                   setErrors(errorData.errors || { general: 'Error al generar reporte' });
                   return;
               }
               
               // Success handling
               const data = await response.json();
               console.log('Report generated:', data);
               
           } catch (error) {
               setErrors({ general: 'Error de conexión. Intente nuevamente.' });
           }
       };
       
       return (
           <form onSubmit={handleSubmit}>
               <div className="form-group">
                   <label htmlFor="quarter">Trimestre:</label>
                   <select
                       id="quarter"
                       name="quarter"
                       value={formData.quarter}
                       onChange={handleChange}
                       className={errors.quarter ? 'error' : ''}
                       required
                   >
                       <option value="">Seleccione...</option>
                       {VALID_QUARTERS.map(q => (
                           <option key={q} value={q}>{q}</option>
                       ))}
                   </select>
                   {errors.quarter && (
                       <span className="error-message">{errors.quarter}</span>
                   )}
               </div>
               
               <div className="form-group">
                   <label htmlFor="year">Año:</label>
                   <input
                       type="number"
                       id="year"
                       name="year"
                       value={formData.year}
                       onChange={handleChange}
                       min={MIN_YEAR}
                       max={CURRENT_YEAR}
                       className={errors.year ? 'error' : ''}
                       required
                   />
                   {errors.year && (
                       <span className="error-message">{errors.year}</span>
                   )}
               </div>
               
               <div className="form-group">
                   <label htmlFor="segment">Segmento:</label>
                   <select
                       id="segment"
                       name="segment"
                       value={formData.segment}
                       onChange={handleChange}
                       className={errors.segment ? 'error' : ''}
                       required
                   >
                       {VALID_SEGMENTS.map(s => (
                           <option key={s} value={s}>{s}</option>
                       ))}
                   </select>
                   {errors.segment && (
                       <span className="error-message">{errors.segment}</span>
                   )}
               </div>
               
               {errors.general && (
                   <div className="error-message general">
                       {errors.general}
                   </div>
               )}
               
               <button type="submit">Generar Reporte</button>
           </form>
       );
   }
   
   export default QuarterlyReportForm;

----------------------------------------------------------------------
3. VALIDACION SERVER-SIDE
----------------------------------------------------------------------

**Proposito:**

Validar en el servidor para SEGURIDAD. Nunca confiar en validacion
client-side.

**Codigo Python Completo:**

.. code-block:: python

   """
   Server-side validation for FR-RPT-01-01
   
   Implements all validation rules V-1 through V-6
   """
   
   from datetime import datetime
   from django.core.exceptions import ValidationError
   
   # Constants
   VALID_QUARTERS = ['Q1', 'Q2', 'Q3', 'Q4']
   VALID_SEGMENTS = ['OP', 'MG']
   MIN_YEAR = 2020
   
   QUARTER_START_MONTH = {
       'Q1': 1, 'Q2': 4, 'Q3': 7, 'Q4': 10
   }
   
   def validate_quarterly_report_parameters(quarter, year, segment):
       """
       Validates all parameters for quarterly report.
       
       Implements FR-RPT-01-01: Validar Parametros Reporte
       
       Args:
           quarter (str): Q1, Q2, Q3, Q4
           year (int): 2020-current
           segment (str): OP, MG
       
       Raises:
           ValidationError: If any validation fails
       
       Returns:
           dict: Sanitized parameters
       """
       errors = {}
       
       # V-6: Parametros no vacios
       if not quarter:
           errors['quarter'] = 'Quarter es requerido y no puede estar vacío'
       
       if year is None:
           errors['year'] = 'Year es requerido'
       
       if not segment:
           errors['segment'] = 'Segment es requerido y no puede estar vacío'
       
       if errors:
           raise ValidationError(errors)
       
       # V-5: Tipos de datos correctos
       if not isinstance(quarter, str):
           errors['quarter'] = (
               f"Tipo incorrecto para quarter: "
               f"esperado str, recibido {type(quarter).__name__}"
           )
       
       if not isinstance(year, int):
           errors['year'] = (
               f"Tipo incorrecto para year: "
               f"esperado int, recibido {type(year).__name__}"
           )
       
       if not isinstance(segment, str):
           errors['segment'] = (
               f"Tipo incorrecto para segment: "
               f"esperado str, recibido {type(segment).__name__}"
           )
       
       if errors:
           raise ValidationError(errors)
       
       # Sanitize strings (strip whitespace)
       quarter = quarter.strip().upper()
       segment = segment.strip().upper()
       
       # V-1: Quarter valido
       if quarter not in VALID_QUARTERS:
           errors['quarter'] = (
               f"Trimestre inválido: {quarter}. "
               f"Debe ser uno de: {', '.join(VALID_QUARTERS)}"
           )
       
       # V-2: Year en rango valido
       current_year = datetime.now().year
       
       if not (MIN_YEAR <= year <= current_year):
           errors['year'] = (
               f"Año inválido: {year}. "
               f"Debe estar entre {MIN_YEAR} y {current_year}"
           )
       
       # V-3: Segment valido
       if segment not in VALID_SEGMENTS:
           errors['segment'] = (
               f"Segmento inválido: {segment}. "
               f"Debe ser uno de: {', '.join(VALID_SEGMENTS)}"
           )
       
       if errors:
           raise ValidationError(errors)
       
       # V-4: Trimestre no en el futuro
       query_date = datetime(year, QUARTER_START_MONTH[quarter], 1)
       current_date = datetime.now()
       
       if query_date > current_date:
           errors['quarter'] = (
               f"No se puede consultar trimestre futuro: {quarter} {year}"
           )
       
       if errors:
           raise ValidationError(errors)
       
       # Return sanitized parameters
       return {
           'quarter': quarter,
           'year': year,
           'segment': segment
       }

**Uso en View:**

.. code-block:: python

   from django.http import JsonResponse
   from django.views.decorators.http import require_http_methods
   from django.core.exceptions import ValidationError
   import json
   
   @require_http_methods(["POST"])
   def generate_quarterly_report(request):
       """API endpoint for generating quarterly report."""
       
       try:
           # Parse request
           data = json.loads(request.body)
           
           # Validate parameters
           params = validate_quarterly_report_parameters(
               quarter=data.get('quarter'),
               year=data.get('year'),
               segment=data.get('segment')
           )
           
           # Execute report generation
           results = execute_quarterly_report_query(**params)
           
           return JsonResponse({
               'status': 'success',
               'results': results
           })
           
       except ValidationError as e:
           return JsonResponse({
               'status': 'error',
               'errors': e.message_dict
           }, status=400)
       
       except Exception as e:
           logger.error(f"Error generating report: {e}", exc_info=True)
           return JsonResponse({
               'status': 'error',
               'message': 'Error interno del servidor'
           }, status=500)

----------------------------------------------------------------------
4. TESTING DE VALIDACIONES
----------------------------------------------------------------------

**Proposito:**

Tests exhaustivos para cada regla V-N, casos validos e invalidos.

**TESTS COMPLETOS (FR-RPT-01-01):**

.. code-block:: python

   import pytest
   from django.core.exceptions import ValidationError
   from reports.validators import validate_quarterly_report_parameters
   
   class TestFRRPT0101Validation:
       """Tests for FR-RPT-01-01: Validar Parametros Reporte."""
       
       # ====================================
       # V-1: Quarter Valido
       # ====================================
       
       def test_v1_quarter_valid_q1(self):
           """Test V-1: Q1 is valid."""
           params = validate_quarterly_report_parameters('Q1', 2024, 'OP')
           assert params['quarter'] == 'Q1'
       
       def test_v1_quarter_valid_all_quarters(self):
           """Test V-1: All quarters Q1-Q4 are valid."""
           for quarter in ['Q1', 'Q2', 'Q3', 'Q4']:
               params = validate_quarterly_report_parameters(quarter, 2024, 'OP')
               assert params['quarter'] == quarter
       
       def test_v1_quarter_invalid_lowercase(self):
           """Test V-1: Lowercase 'q1' should fail."""
           with pytest.raises(ValidationError, match="Trimestre inválido"):
               validate_quarterly_report_parameters('q1', 2024, 'OP')
       
       def test_v1_quarter_invalid_q5(self):
           """Test V-1: Q5 does not exist."""
           with pytest.raises(ValidationError, match="Trimestre inválido"):
               validate_quarterly_report_parameters('Q5', 2024, 'OP')
       
       def test_v1_quarter_invalid_number(self):
           """Test V-1: Just number '1' is invalid."""
           with pytest.raises(ValidationError, match="Trimestre inválido"):
               validate_quarterly_report_parameters('1', 2024, 'OP')
       
       # ====================================
       # V-2: Year Valido
       # ====================================
       
       def test_v2_year_valid_2024(self):
           """Test V-2: Current year 2024 is valid."""
           params = validate_quarterly_report_parameters('Q1', 2024, 'OP')
           assert params['year'] == 2024
       
       def test_v2_year_valid_min_2020(self):
           """Test V-2: Minimum year 2020 is valid."""
           params = validate_quarterly_report_parameters('Q1', 2020, 'OP')
           assert params['year'] == 2020
       
       def test_v2_year_invalid_too_old(self):
           """Test V-2: Year 2019 is before minimum."""
           with pytest.raises(ValidationError, match="Año inválido"):
               validate_quarterly_report_parameters('Q1', 2019, 'OP')
       
       def test_v2_year_invalid_future(self):
           """Test V-2: Future year should fail."""
           from datetime import datetime
           future_year = datetime.now().year + 1
           
           with pytest.raises(ValidationError, match="Año inválido"):
               validate_quarterly_report_parameters('Q1', future_year, 'OP')
       
       def test_v2_year_invalid_type_string(self):
           """Test V-2: String '2024' should fail (must be int)."""
           with pytest.raises(ValidationError, match="Tipo incorrecto"):
               validate_quarterly_report_parameters('Q1', '2024', 'OP')
       
       def test_v2_year_invalid_type_float(self):
           """Test V-2: Float 2024.5 should fail."""
           with pytest.raises(ValidationError, match="Tipo incorrecto"):
               validate_quarterly_report_parameters('Q1', 2024.5, 'OP')
       
       # ====================================
       # V-3: Segment Valido
       # ====================================
       
       def test_v3_segment_valid_op(self):
           """Test V-3: OP is valid."""
           params = validate_quarterly_report_parameters('Q1', 2024, 'OP')
           assert params['segment'] == 'OP'
       
       def test_v3_segment_valid_mg(self):
           """Test V-3: MG is valid."""
           params = validate_quarterly_report_parameters('Q1', 2024, 'MG')
           assert params['segment'] == 'MG'
       
       def test_v3_segment_invalid_lowercase(self):
           """Test V-3: Lowercase 'op' should fail."""
           with pytest.raises(ValidationError, match="Segmento inválido"):
               validate_quarterly_report_parameters('Q1', 2024, 'op')
       
       def test_v3_segment_invalid_unknown(self):
           """Test V-3: Unknown segment 'XX' should fail."""
           with pytest.raises(ValidationError, match="Segmento inválido"):
               validate_quarterly_report_parameters('Q1', 2024, 'XX')
       
       # ====================================
       # V-4: Trimestre No Futuro
       # ====================================
       
       def test_v4_quarter_not_future_past(self):
           """Test V-4: Past quarter is valid."""
           params = validate_quarterly_report_parameters('Q1', 2023, 'OP')
           assert params is not None
       
       def test_v4_quarter_not_future_fails(self):
           """Test V-4: Future quarter should fail."""
           from datetime import datetime
           
           # Asumiendo estamos en Q2 2024
           # Q3 2024 es futuro
           with pytest.raises(ValidationError, match="trimestre futuro"):
               validate_quarterly_report_parameters('Q3', 2024, 'OP')
       
       # ====================================
       # V-6: Parametros No Vacios
       # ====================================
       
       def test_v6_quarter_empty(self):
           """Test V-6: Empty quarter should fail."""
           with pytest.raises(ValidationError, match="requerido"):
               validate_quarterly_report_parameters('', 2024, 'OP')
       
       def test_v6_quarter_none(self):
           """Test V-6: None quarter should fail."""
           with pytest.raises(ValidationError, match="requerido"):
               validate_quarterly_report_parameters(None, 2024, 'OP')
       
       def test_v6_year_none(self):
           """Test V-6: None year should fail."""
           with pytest.raises(ValidationError, match="requerido"):
               validate_quarterly_report_parameters('Q1', None, 'OP')
       
       def test_v6_segment_empty(self):
           """Test V-6: Empty segment should fail."""
           with pytest.raises(ValidationError, match="requerido"):
               validate_quarterly_report_parameters('Q1', 2024, '')

----------------------------------------------------------------------
REFERENCIAS
----------------------------------------------------------------------

**Estandares:**

- STD_001_Estandares_Documentacion_1_1_0.rst
- NOM_001_Nomenclatura_Proyecto_2_0_0.rst

**Material Pedagogico:**

- PARTE_4_Functional_Requirements_IACT_1_0_0.md

**Documentos Relacionados:**

- UC-IACT-RPT-01-Consultar-Reporte-Trimestral-4-0-0.rst
- FR-RPT-01-01-Validar-Parametros-1-0-0.rst

----------------------------------------------------------------------

.. note::
   CHECKLIST FR VALIDACION:
   
   - Catalogo completo de reglas V-1 a V-N
   - Cada regla con mensaje de error especifico
   - Ejemplos de valores validos e invalidos
   - Codigo de validacion client-side (JavaScript/React)
   - Codigo de validacion server-side (Python)
   - NUNCA confiar solo en client-side
   - Tests exhaustivos para cada regla
   - Tests de casos borde
   - Tests de mensajes de error

----------------------------------------------------------------------

**Archivo:** TPL_FR_Validacion_Reglas_1_3_0.rst  
**Version Template:** 1.3.0  
**Fecha Creacion Template:** 2026-01-11  
**Autor Template:** Sistema de Regeneracion IACT  
**Lineas Totales:** aproximadamente 850
