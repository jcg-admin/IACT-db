.. meta::
   :Proyecto: IACT
   :Codigo: UC-IACT-MOD-NN
   :Titulo: Nombre del Use Case UI-Driven
   :Version: 4.0.0
   :Actor_Principal: Rol del Actor
   :Tipo: UI-Driven
   :Fecha: YYYY-MM-DD
   :Autor: Nombre del Business Analyst
   :Estado: DRAFT|REVIEW|APPROVED|IMPLEMENTED

======================================================================
UC-IACT-MOD-NN: Nombre del Use Case UI-Driven
======================================================================

**Proyecto:** IACT - IVR Analytics & Customer Tracking  
**Actor Principal:** Rol del Actor Principal  
**Tipo:** UI-Driven  
**Estado:** DRAFT|REVIEW|APPROVED|IMPLEMENTED  
**Prioridad:** Alta|Media|Baja  
**Clasificacion:** C2 - INTERNAL

----------------------------------------------------------------------
INTRODUCCION AL TEMPLATE
----------------------------------------------------------------------

Este template documenta Use Cases cuya especificacion se centra en
la interfaz de usuario, elementos visuales, interacciones y flujo
desde la perspectiva del UI/UX.

**Cuando Usar Este Template:**

Use este template cuando:

1. El UC es principalmente interactivo via UI
2. La experiencia de usuario es critica para el exito
3. Hay wireframes o mockups disponibles
4. Los elementos UI son complejos (forms, tablas, graficos)
5. Las interacciones UI derivan multiples FR

**Cuando NO Usar Este Template:**

NO use este template para:

- UC temporales/cron jobs sin UI
- APIs backend sin interfaz
- UC simples con UI trivial

**Diferencia vs UC Normal:**

UC Normal:
- Enfoque en flujo de negocio
- Pasos genericos: "Sistema muestra datos"

UC UI-Driven:
- Enfoque en elementos UI especificos
- Pasos detallados: "Sistema muestra dropdown con opciones Q1-Q4"
- Incluye wireframes, CSS, handlers JavaScript

**Estructura de Este Template:**

1. Mockup/Wireframe de la pantalla
2. Elementos UI detallados (inputs, buttons, outputs)
3. Interacciones y event handlers
4. Mensajes y modales
5. Derivacion de FR desde interacciones UI

----------------------------------------------------------------------
1. MOCKUP/WIREFRAME
----------------------------------------------------------------------

**Proposito:**

Documentar visualmente como se ve la pantalla o interfaz del UC.

**Referencia a Diseño:**

Si existe diseño formal:
- Link a Figma/Sketch/Adobe XD: URL
- Archivo de diseño: nombre_archivo.fig
- Version del diseño: vX.Y
- Fecha del diseño: YYYY-MM-DD

**Wireframe ASCII:**

Representacion simple en texto de la interfaz:

.. code-block:: text

   +--------------------------------------------------+
   |  Titulo de la Pantalla                          |
   +--------------------------------------------------+
   |                                                  |
   |  [Elemento 1]     [Elemento 2]                  |
   |                                                  |
   |  [ Boton Primario ]  [ Boton Secundario ]       |
   |                                                  |
   +--------------------------------------------------+

**Secciones de la Pantalla:**

Describir las secciones logicas:

1. Header: Que contiene
2. Body/Content: Que contiene
3. Footer: Que contiene
4. Sidebar si aplica

**EJEMPLO COMPLETO (UC-RPT-01):**

**Referencia a Diseño:**

- Link Figma: https://figma.com/file/abc123/IACT-Reportes
- Archivo: IACT_Reportes_Trimestrales_v2.1.fig
- Version: v2.1
- Fecha: 2024-10-15
- Disenador: Juan Perez (UX Team)

**Wireframe ASCII - Pantalla de Reportes Trimestrales:**

.. code-block:: text

   +----------------------------------------------------------------+
   |  IACT - Reportes Trimestrales                     [User: Ana] |
   +----------------------------------------------------------------+
   |                                                                |
   |  [Home] > [Reportes] > Metricas Trimestrales                  |
   |                                                                |
   |  +----------------------------------------------------------+  |
   |  | PARAMETROS DE CONSULTA                                   |  |
   |  +----------------------------------------------------------+  |
   |  |                                                          |  |
   |  |  Trimestre:   [Q1 v]    Ano: [2024 v]   Segmento: [OP v]|  |
   |  |                                                          |  |
   |  |  [ Generar Reporte ]  [ Limpiar ]                       |  |
   |  |                                                          |  |
   |  +----------------------------------------------------------+  |
   |                                                                |
   |  +----------------------------------------------------------+  |
   |  | RESULTADOS                                               |  |
   |  +----------------------------------------------------------+  |
   |  |                                                          |  |
   |  |  +----------------------------------------------------+  |  |
   |  |  | GRAFICOS                                           |  |  |
   |  |  |                                                    |  |  |
   |  |  |  [Grafico de Lineas: Llamadas por Dia]           |  |  |
   |  |  |                                                    |  |  |
   |  |  |  [KPI: Tasa Abandono] 12.5%                      |  |  |
   |  |  |                                                    |  |  |
   |  |  +----------------------------------------------------+  |  |
   |  |                                                          |  |
   |  |  +----------------------------------------------------+  |  |
   |  |  | TABLA DE DATOS                                     |  |  |
   |  |  +----+-------------+------+-------+--------+---------+ |  |
   |  |  |Dia |Total Llam.  |Comp. |Aband. |Dur.Prom|Tasa Ab. | |  |
   |  |  +----+-------------+------+-------+--------+---------+ |  |
   |  |  |7/1 |1,250        |1,100 |150    |245.67s |12.0%    | |  |
   |  |  |7/2 |1,180        |1,050 |130    |238.42s |11.0%    | |  |
   |  |  |... |...          |...   |...    |...     |...      | |  |
   |  |  +----+-------------+------+-------+--------+---------+ |  |
   |  |                                                          |  |
   |  |  [ Exportar Excel ]  [ Exportar PDF ]                   |  |
   |  |                                                          |  |
   |  +----------------------------------------------------------+  |
   |                                                                |
   +----------------------------------------------------------------+

**Secciones:**

1. **Header Global:**
   - Logo IACT
   - Titulo aplicacion
   - User info (nombre, avatar)
   - Logout link

2. **Breadcrumb:**
   - Navegacion: Home > Reportes > Metricas Trimestrales

3. **Panel Parametros:**
   - Form con 3 dropdowns
   - 2 botones accion

4. **Panel Resultados:**
   - Subseccion graficos
   - Subseccion tabla datos
   - Botones exportar

5. **Footer (no mostrado):**
   - Copyright
   - Links ayuda

----------------------------------------------------------------------
2. ELEMENTOS UI - INPUTS
----------------------------------------------------------------------

**Proposito:**

Documentar cada elemento de entrada (inputs) en detalle.

**Formato por Input:**

**Nombre del Input:**

- Tipo: Dropdown|Textfield|Checkbox|Radio|Date|etc
- ID/Name: HTML id y name
- Label: Texto del label
- Placeholder: Texto placeholder si aplica
- Opciones: Lista de opciones si dropdown/radio
- Valor por defecto: Valor inicial
- Validacion: Reglas de validacion
- Requerido: SI|NO
- Tamano: Width en px o %

**EJEMPLO COMPLETO (UC-RPT-01):**

**Input 1: Trimestre**

- Tipo: Dropdown (select)
- ID: dropdown-quarter
- Name: quarter
- Label: "Trimestre:"
- Opciones:
  
  .. code-block:: javascript
  
     [
       { value: 'Q1', label: 'Q1 - Ene-Mar' },
       { value: 'Q2', label: 'Q2 - Abr-Jun' },
       { value: 'Q3', label: 'Q3 - Jul-Sep' },
       { value: 'Q4', label: 'Q4 - Oct-Dic' }
     ]

- Valor por defecto: Trimestre actual
- Validacion: Debe seleccionar una opcion
- Requerido: SI
- Tamano: 150px width
- CSS Classes: form-select, quarter-selector

**Input 2: Ano**

- Tipo: Dropdown (select)
- ID: dropdown-year
- Name: year
- Label: "Año:"
- Opciones: Generadas dinamicamente 2020 a ano actual
  
  .. code-block:: javascript
  
     const currentYear = new Date().getFullYear();
     const years = [];
     for (let y = 2020; y <= currentYear; y++) {
       years.push({ value: y, label: y.toString() });
     }

- Valor por defecto: Ano actual
- Validacion: Debe estar entre 2020 y ano actual
- Requerido: SI
- Tamano: 100px width
- CSS Classes: form-select, year-selector

**Input 3: Segmento**

- Tipo: Dropdown (select)
- ID: dropdown-segment
- Name: segment
- Label: "Segmento:"
- Opciones:
  
  .. code-block:: javascript
  
     [
       { value: 'OP', label: 'OP - Operaciones' },
       { value: 'MG', label: 'MG - Management' }
     ]

- Valor por defecto: 'OP'
- Validacion: Debe seleccionar una opcion valida
- Requerido: SI
- Tamano: 180px width
- CSS Classes: form-select, segment-selector

----------------------------------------------------------------------
3. ELEMENTOS UI - BOTONES
----------------------------------------------------------------------

**Formato por Boton:**

**Nombre del Boton:**

- Tipo: Primary|Secondary|Danger|Link
- ID: HTML id
- Texto: Texto del boton
- Icono: Icono si aplica
- Accion: Que hace al hacer click
- Estado inicial: Enabled|Disabled
- Color: Color del boton
- Tamano: Small|Medium|Large

**EJEMPLO COMPLETO (UC-RPT-01):**

**Boton 1: Generar Reporte**

- Tipo: Primary
- ID: btn-generate-report
- Texto: "Generar Reporte"
- Icono: Icon de grafico (chart-bar)
- Accion: Ejecuta validacion y genera reporte
- Estado inicial: Enabled
- Color: Azul (brand primary, #0066CC)
- Tamano: Medium (140px width, 40px height)
- CSS Classes: btn, btn-primary, btn-generate
- Handler: onClick={() => handleGenerateReport()}

**Boton 2: Limpiar**

- Tipo: Secondary
- ID: btn-clear-form
- Texto: "Limpiar"
- Icono: Icon de X (times-circle)
- Accion: Resetea form a valores por defecto
- Estado inicial: Enabled
- Color: Gris (neutral, #6C757D)
- Tamano: Medium (100px width, 40px height)
- CSS Classes: btn, btn-secondary, btn-clear
- Handler: onClick={() => handleClearForm()}

**Boton 3: Exportar Excel**

- Tipo: Secondary
- ID: btn-export-excel
- Texto: "Exportar Excel"
- Icono: Icon de Excel (file-excel)
- Accion: Descarga reporte en formato XLSX
- Estado inicial: Disabled (hasta que hay resultados)
- Color: Verde (#28A745)
- Tamano: Medium (140px width, 40px height)
- CSS Classes: btn, btn-success, btn-export
- Handler: onClick={() => handleExportExcel()}

**Boton 4: Exportar PDF**

- Tipo: Secondary
- ID: btn-export-pdf
- Texto: "Exportar PDF"
- Icono: Icon de PDF (file-pdf)
- Accion: Descarga reporte en formato PDF
- Estado inicial: Disabled (hasta que hay resultados)
- Color: Rojo (#DC3545)
- Tamano: Medium (130px width, 40px height)
- CSS Classes: btn, btn-danger, btn-export
- Handler: onClick={() => handleExportPDF()}

----------------------------------------------------------------------
4. ELEMENTOS UI - OUTPUTS
----------------------------------------------------------------------

**Formato por Output:**

**Nombre del Output:**

- Tipo: Table|Chart|Card|Text|Modal|etc
- Descripcion: Que muestra
- Estructura: Detalles de la estructura
- Actualizacion: Cuando se actualiza

**EJEMPLO COMPLETO (UC-RPT-01):**

**Output 1: Grafico de Lineas - Llamadas por Dia**

- Tipo: Line Chart (usando Chart.js)
- ID: chart-calls-daily
- Descripcion: Serie temporal de llamadas totales por dia del trimestre
- Datos:
  
  - Eje X: Fechas (dias del trimestre)
  - Eje Y: Numero de llamadas
  - Serie 1: Total llamadas (linea azul)
  - Serie 2: Completadas (linea verde)
  - Serie 3: Abandonadas (linea roja)

- Opciones:
  
  - Responsive: true
  - Legend: Mostrar arriba
  - Tooltip: Mostrar valores al hover
  - Grid: Lineas horizontales

- Tamano: 100% width, 300px height
- Actualizacion: Cuando se generan nuevos resultados

**Codigo Chart.js:**

.. code-block:: javascript

   const chartData = {
     labels: results.map(r => r.dia),
     datasets: [
       {
         label: 'Total Llamadas',
         data: results.map(r => r.total_llamadas),
         borderColor: '#0066CC',
         backgroundColor: 'rgba(0, 102, 204, 0.1)',
         tension: 0.4
       },
       {
         label: 'Completadas',
         data: results.map(r => r.completadas),
         borderColor: '#28A745',
         backgroundColor: 'rgba(40, 167, 69, 0.1)',
         tension: 0.4
       },
       {
         label: 'Abandonadas',
         data: results.map(r => r.abandonadas),
         borderColor: '#DC3545',
         backgroundColor: 'rgba(220, 53, 69, 0.1)',
         tension: 0.4
       }
     ]
   };

**Output 2: KPI Card - Tasa de Abandono**

- Tipo: Card con metrica destacada
- ID: card-abandon-rate
- Descripcion: Tasa de abandono promedio del trimestre
- Estructura:
  
  - Titulo: "Tasa de Abandono"
  - Valor: Porcentaje con 2 decimales, grande
  - Color del valor: Rojo si mayor 15%, Amarillo si 10-15%, Verde si menor 10%
  - Icono: Semaforo segun umbral

- Tamano: 200px width, 120px height
- Posicion: Junto al grafico

**Codigo React:**

.. code-block:: javascript

   function KPICard({ rate }) {
     const getColor = (r) => {
       if (r > 15) return 'danger';
       if (r > 10) return 'warning';
       return 'success';
     };
     
     return (
       <div className={`kpi-card kpi-${getColor(rate)}`}>
         <h4>Tasa de Abandono</h4>
         <div className="kpi-value">{rate.toFixed(2)}%</div>
       </div>
     );
   }

**Output 3: Tabla de Datos**

- Tipo: Data Table (usando DataTables.js o React Table)
- ID: table-results
- Descripcion: Tabla con metricas diarias del trimestre
- Columnas:
  
  1. Dia (fecha, formato DD/MM)
  2. Total Llamadas (integer con separador de miles)
  3. Completadas (integer)
  4. Abandonadas (integer)
  5. Duracion Promedio (float, formato XXX.XX s)
  6. Tasa Abandono (float, formato XX.XX %)

- Features:
  
  - Sorting: Todas las columnas
  - Pagination: 20 filas por pagina
  - Search: Buscar en cualquier campo

- Tamano: 100% width, auto height
- CSS Classes: table, table-striped, table-hover

**Codigo HTML:**

.. code-block:: html

   <table id="table-results" class="table table-striped">
     <thead>
       <tr>
         <th>Día</th>
         <th>Total Llamadas</th>
         <th>Completadas</th>
         <th>Abandonadas</th>
         <th>Duración Prom.</th>
         <th>Tasa Abandono</th>
       </tr>
     </thead>
     <tbody>
       <!-- Rows generadas dinamicamente -->
     </tbody>
   </table>

----------------------------------------------------------------------
5. INTERACCIONES Y EVENT HANDLERS
----------------------------------------------------------------------

**Proposito:**

Documentar todos los event handlers y la logica de interaccion.

**Formato por Handler:**

**Handler: nombre_handler**

- Evento: onChange|onClick|onSubmit|onLoad|etc
- Elemento: ID del elemento que dispara
- Accion: Que hace el handler
- Validaciones: Si valida algo
- Llamadas API: Si hace fetch/axios
- Actualizacion UI: Que elementos actualiza

**EJEMPLO COMPLETO (UC-RPT-01):**

**Handler 1: onChange - Dropdown Quarter**

- Evento: onChange
- Elemento: dropdown-quarter
- Accion: Actualiza estado del form, limpia resultados previos

**Codigo React:**

.. code-block:: javascript

   const handleQuarterChange = (event) => {
     const newQuarter = event.target.value;
     
     // Update state
     setQuarter(newQuarter);
     
     // Clear previous results
     setResults([]);
     setChartData(null);
     
     // Enable generate button if all params valid
     validateForm();
   };

**Handler 2: onClick - Boton Generar Reporte**

- Evento: onClick
- Elemento: btn-generate-report
- Accion: Valida params, hace API call, actualiza UI con resultados

**Codigo React Completo:**

.. code-block:: javascript

   const handleGenerateReport = async () => {
     try {
       // 1. Validar parametros
       if (!validateParams()) {
         showErrorToast('Parámetros inválidos');
         return;
       }
       
       // 2. Deshabilitar boton y mostrar loading
       setIsLoading(true);
       setButtonDisabled(true);
       
       // 3. Llamada API
       const response = await fetch('/api/reports/quarterly', {
         method: 'POST',
         headers: {
           'Content-Type': 'application/json',
           'Authorization': `Bearer ${authToken}`
         },
         body: JSON.stringify({
           quarter: quarter,
           year: year,
           segment: segment
         })
       });
       
       // 4. Manejar respuesta
       if (!response.ok) {
         if (response.status === 403) {
           // Requiere aprobacion (FA-2)
           const data = await response.json();
           showApprovalModal(data.message);
           return;
         }
         throw new Error('Error en la consulta');
       }
       
       const data = await response.json();
       
       // 5. Actualizar UI con resultados
       setResults(data.results);
       setChartData(prepareChartData(data.results));
       setAbandonRate(calculateAbandonRate(data.results));
       
       // 6. Habilitar botones de exportar
       setExportButtonsDisabled(false);
       
       // 7. Scroll a resultados
       document.getElementById('results-section').scrollIntoView({
         behavior: 'smooth'
       });
       
       // 8. Success toast
       showSuccessToast('Reporte generado exitosamente');
       
     } catch (error) {
       // Manejo de errores
       console.error('Error generating report:', error);
       showErrorToast('Error al generar reporte. Intente nuevamente.');
       
     } finally {
       // Cleanup
       setIsLoading(false);
       setButtonDisabled(false);
     }
   };
   
   // Helper functions
   function validateParams() {
     const validQuarters = ['Q1', 'Q2', 'Q3', 'Q4'];
     const currentYear = new Date().getFullYear();
     const validSegments = ['OP', 'MG'];
     
     return (
       validQuarters.includes(quarter) &&
       year >= 2020 && year <= currentYear &&
       validSegments.includes(segment)
     );
   }
   
   function prepareChartData(results) {
     return {
       labels: results.map(r => formatDate(r.dia)),
       datasets: [
         {
           label: 'Total Llamadas',
           data: results.map(r => r.total_llamadas),
           borderColor: '#0066CC'
         },
         {
           label: 'Completadas',
           data: results.map(r => r.completadas),
           borderColor: '#28A745'
         },
         {
           label: 'Abandonadas',
           data: results.map(r => r.abandonadas),
           borderColor: '#DC3545'
         }
       ]
     };
   }
   
   function calculateAbandonRate(results) {
     const totalCalls = results.reduce((sum, r) => 
       sum + r.total_llamadas, 0
     );
     const totalAbandoned = results.reduce((sum, r) => 
       sum + r.abandonadas, 0
     );
     
     if (totalCalls === 0) return 0;
     return (totalAbandoned / totalCalls) * 100;
   }

**Handler 3: onClick - Boton Limpiar**

- Evento: onClick
- Elemento: btn-clear-form
- Accion: Resetea form a valores default

**Codigo:**

.. code-block:: javascript

   const handleClearForm = () => {
     // Reset to defaults
     const currentQuarter = getCurrentQuarter();
     const currentYear = new Date().getFullYear();
     
     setQuarter(currentQuarter);
     setYear(currentYear);
     setSegment('OP');
     
     // Clear results
     setResults([]);
     setChartData(null);
     setAbandonRate(0);
     
     // Disable export buttons
     setExportButtonsDisabled(true);
   };

**Handler 4: onClick - Exportar Excel**

- Evento: onClick
- Elemento: btn-export-excel
- Accion: Genera archivo XLSX y descarga

**Codigo:**

.. code-block:: javascript

   const handleExportExcel = () => {
     // Usar libreria xlsx
     const XLSX = require('xlsx');
     
     // Preparar datos
     const ws_data = [
       ['Día', 'Total Llamadas', 'Completadas', 'Abandonadas', 
        'Duración Prom.', 'Tasa Abandono'],
       ...results.map(r => [
         formatDate(r.dia),
         r.total_llamadas,
         r.completadas,
         r.abandonadas,
         r.duracion_promedio.toFixed(2),
         ((r.abandonadas / r.total_llamadas) * 100).toFixed(2)
       ])
     ];
     
     // Crear workbook
     const wb = XLSX.utils.book_new();
     const ws = XLSX.utils.aoa_to_sheet(ws_data);
     
     XLSX.utils.book_append_sheet(wb, ws, 'Reporte');
     
     // Descargar
     const filename = `Reporte_${quarter}_${year}_${segment}.xlsx`;
     XLSX.writeFile(wb, filename);
     
     // Toast
     showSuccessToast('Reporte exportado a Excel');
   };

----------------------------------------------------------------------
6. MENSAJES Y MODALES
----------------------------------------------------------------------

**Tipos de Mensajes:**

1. Toast notifications (temporales, esquina pantalla)
2. Alert banners (persistentes, top de pantalla)
3. Modales (requieren accion usuario)

**EJEMPLO COMPLETO (UC-RPT-01):**

**Toast 1: Success - Reporte Generado**

- Tipo: Success Toast
- Titulo: "Éxito"
- Mensaje: "Reporte generado exitosamente"
- Duracion: 3 segundos
- Posicion: Top-right
- Color: Verde
- Icono: Check circle

**Toast 2: Error - Falla Generacion**

- Tipo: Error Toast
- Titulo: "Error"
- Mensaje: "Error al generar reporte. Intente nuevamente."
- Duracion: 5 segundos
- Posicion: Top-right
- Color: Rojo
- Icono: Exclamation circle

**Modal 1: Aprobacion Requerida (FA-2)**

- Tipo: Modal informativo
- Titulo: "Aprobación Requerida"
- Mensaje:
  
  "Su consulta requiere aprobación del supervisor debido al volumen
  de datos (count registros).
  
  Le notificaremos cuando sea aprobada o rechazada.
  
  Tiempo estimado de respuesta: 2-4 horas."

- Botones: "OK" (cierra modal)
- Cerrable: Click fuera NO cierra, solo boton OK
- Tamano: 500px width, auto height

**Codigo React:**

.. code-block:: javascript

   function ApprovalModal({ count, onClose }) {
     return (
       <Modal show={true} onHide={onClose} backdrop="static">
         <Modal.Header closeButton>
           <Modal.Title>Aprobación Requerida</Modal.Title>
         </Modal.Header>
         <Modal.Body>
           <p>
             Su consulta requiere aprobación del supervisor debido al
             volumen de datos ({count.toLocaleString()} registros).
           </p>
           <p>
             Le notificaremos cuando sea aprobada o rechazada.
           </p>
           <p>
             <strong>Tiempo estimado de respuesta:</strong> 2-4 horas
           </p>
         </Modal.Body>
         <Modal.Footer>
           <Button variant="primary" onClick={onClose}>
             OK
           </Button>
         </Modal.Footer>
       </Modal>
     );
   }

----------------------------------------------------------------------
7. DERIVACION DE FUNCTIONAL REQUIREMENTS
----------------------------------------------------------------------

**Proposito:**

Mapear cada interaccion UI a los FR que debe implementar.

**Formato de Tabla:**

.. list-table::
   :header-rows: 1
   :widths: 15 35 50

   * - Interaccion UI
     - Elemento
     - FR Derivado
   * - onChange
     - dropdown-quarter
     - FR-XXX-NN-ZZ

**EJEMPLO COMPLETO (UC-RPT-01):**

.. list-table::
   :header-rows: 1
   :widths: 15 35 50

   * - Interaccion
     - Elemento
     - FR Derivado
   * - onChange
     - dropdown-quarter
     - FR-RPT-01-01: Validar Parametros (validacion inline)
   * - onChange
     - dropdown-year
     - FR-RPT-01-01: Validar Parametros
   * - onChange
     - dropdown-segment
     - FR-RPT-01-01: Validar Parametros
   * - onClick
     - btn-generate-report
     - FR-RPT-01-02: Validar Form Completo
   * - onClick
     - btn-generate-report
     - FR-RPT-01-03: Mostrar Loading State
   * - onClick
     - btn-generate-report
     - FR-RPT-01-04: Calcular Count Registros
   * - onClick
     - btn-generate-report
     - FR-RPT-01-05: Evaluar Umbral Aprobacion
   * - onClick
     - btn-generate-report
     - FR-RPT-01-06: Ejecutar Query Principal
   * - onLoad
     - chart-calls-daily
     - FR-RPT-01-08: Generar Graficos Visuales
   * - onLoad
     - table-results
     - FR-RPT-01-09: Renderizar Tabla Datos
   * - onClick
     - btn-export-excel
     - FR-RPT-01-12: Exportar a Excel
   * - onClick
     - btn-export-pdf
     - FR-RPT-01-13: Exportar a PDF

----------------------------------------------------------------------
REFERENCIAS
----------------------------------------------------------------------

**Estandares:**

- STD_001_Estandares_Documentacion_1_1_0.rst
- NOM_001_Nomenclatura_Proyecto_2_0_0.rst

**Material Pedagogico:**

- PARTE_2_Documentar_Use_Cases_IACT_1_0_0.md

**Librerias UI:**

- React 18
- Chart.js 4.x
- Bootstrap 5
- DataTables.js
- xlsx (SheetJS)

----------------------------------------------------------------------

.. note::
   CHECKLIST UI-DRIVEN:
   
   - Mockup/wireframe ASCII completo
   - Todos los inputs documentados con tipos y validaciones
   - Todos los botones con handlers especificos
   - Outputs (tablas, graficos) con estructura detallada
   - Event handlers con codigo JavaScript/React funcional
   - Mensajes y modales especificados
   - Derivacion FR desde interacciones UI
   - Codigo es funcional, no pseudocodigo

----------------------------------------------------------------------

**Archivo:** TPL_UC_UI_Driven_1_3_0.rst  
**Version Template:** 1.3.0  
**Fecha Creacion Template:** 2026-01-11  
**Autor Template:** Sistema de Regeneracion IACT  
**Lineas Totales:** aproximadamente 750
