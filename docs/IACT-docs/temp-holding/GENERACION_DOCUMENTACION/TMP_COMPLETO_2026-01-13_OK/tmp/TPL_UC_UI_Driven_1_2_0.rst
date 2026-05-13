.. meta::
   :Proyecto: IACT
   :Codigo: UC-IACT-XXX-YY
   :Titulo: [Nombre del UC - UI Driven]
   :Version: 4.0.0
   :Tipo: UI-Driven
   :Modulo: [MOD]
   :Fecha: YYYY-MM-DD
   :Autor: [Nombre BA]

======================================================================
UC-IACT-XXX-YY: [Nombre] (UI-Driven)
======================================================================

**Proyecto:** IACT  
**Enfoque:** UI-Driven (basado en interfaz de usuario)

----------------------------------------------------------------------
INTRODUCCION: UC UI-DRIVEN
----------------------------------------------------------------------

**¿Qué es un UC UI-Driven?**

UC donde la especificación se basa PRIMERO en el diseño de interfaz
de usuario (mockup/wireframe), y luego se derivan los flujos.

**¿Cuándo usar este template?**

- UI/UX es crítico para el caso de uso
- Existe mockup/diseño previo
- Interacciones UI complejas (onChange, onClick, validaciones)
- Frontend-heavy use cases

**Diferencia con UC estándar:**

- UC estándar: Describe LÓGICA de negocio
- UC UI-Driven: Describe INTERACCIÓN visual

**Flujo de trabajo:**

1. Diseñador crea mockup/wireframe
2. BA documenta elementos UI y sus interacciones
3. Desarrollador implementa según spec UI
4. QA valida contra mockup

----------------------------------------------------------------------
1. MOCKUP / WIREFRAME
----------------------------------------------------------------------

**Referencia al Diseño:**

- **Archivo Figma:** [URL al diseño en Figma]
- **Archivo Sketch:** [URL o archivo adjunto]
- **Screenshot:** [Link a imagen PNG/JPG]
- **Versión del diseño:** v1.2.0

**Layout ASCII (Vista general):**

.. code-block:: text

   ┌─────────────────────────────────────────────────────────┐
   │ IACT - Generar Reporte Trimestral              [X]     │
   ├─────────────────────────────────────────────────────────┤
   │                                                         │
   │  Parámetros del Reporte                                │
   │  ┌────────────────────────────────────────────────┐   │
   │  │                                                 │   │
   │  │  Trimestre:  [Q1 ▼]                            │   │
   │  │                                                 │   │
   │  │  Año:        [2024 ▼]                          │   │
   │  │                                                 │   │
   │  │  Segmento:   [OP ▼]                            │   │
   │  │                                                 │   │
   │  └────────────────────────────────────────────────┘   │
   │                                                         │
   │  [ Limpiar ]                    [ Generar Reporte ]   │
   │                                                         │
   │  ─────────────────────────────────────────────────────│
   │                                                         │
   │  Resultados                                            │
   │  ┌────────────────────────────────────────────────┐   │
   │  │                                                 │   │
   │  │  [Tabla de resultados aquí]                    │   │
   │  │                                                 │   │
   │  └────────────────────────────────────────────────┘   │
   │                                                         │
   │  Registros: 1-10 de 45    [< Ant] [Sig >]             │
   │                                                         │
   └─────────────────────────────────────────────────────────┘

----------------------------------------------------------------------
2. ELEMENTOS DE LA INTERFAZ
----------------------------------------------------------------------

**Inputs:**

I-1: Dropdown "Trimestre"
~~~~~~~~~~~~~~~~~~~~~~~~~~

- **ID:** #dropdown-quarter
- **Tipo:** Select/Dropdown
- **Valores:** [Q1, Q2, Q3, Q4]
- **Default:** Q1
- **Obligatorio:** Sí
- **Placeholder:** "Seleccione trimestre"
- **Width:** 150px
- **Validación:** No vacío, valor en lista

I-2: Dropdown "Año"
~~~~~~~~~~~~~~~~~~~

- **ID:** #dropdown-year
- **Tipo:** Select/Dropdown
- **Valores:** [2020, 2021, 2022, 2023, 2024, 2025]
- **Default:** Año actual
- **Obligatorio:** Sí
- **Width:** 150px
- **Validación:** No vacío, valor en lista

I-3: Dropdown "Segmento"
~~~~~~~~~~~~~~~~~~~~~~~~~

- **ID:** #dropdown-segment
- **Tipo:** Select/Dropdown
- **Valores:** [OP - Operaciones, MG - Management, AD - Admin]
- **Default:** OP
- **Obligatorio:** Sí
- **Width:** 250px
- **Validación:** No vacío, valor en lista

**Botones:**

B-1: Botón "Limpiar"
~~~~~~~~~~~~~~~~~~~~

- **ID:** #btn-clear
- **Tipo:** Button (secondary)
- **Texto:** "Limpiar"
- **Color:** Gris (#6c757d)
- **Posición:** Abajo izquierda
- **Disabled:** No
- **Acción:** onClick → limpiar formulario

B-2: Botón "Generar Reporte"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- **ID:** #btn-generate
- **Tipo:** Button (primary)
- **Texto:** "Generar Reporte"
- **Color:** Azul (#007bff)
- **Posición:** Abajo derecha
- **Disabled:** Sí (si form inválido)
- **Acción:** onClick → submit form

**Outputs:**

O-1: Tabla de Resultados
~~~~~~~~~~~~~~~~~~~~~~~~~

- **ID:** #table-results
- **Tipo:** Table (DataTable)
- **Columnas:** [Métrica, Valor, Porcentaje, Comparación]
- **Filas:** Variable (según resultados)
- **Paginación:** Sí (10 por página)
- **Ordenamiento:** Sí (click en header)
- **Exportación:** Botón "Exportar CSV"

O-2: Panel de Paginación
~~~~~~~~~~~~~~~~~~~~~~~~~

- **ID:** #pagination
- **Tipo:** Pagination component
- **Elementos:** [< Anterior] [1] [2] [3] [Siguiente >]
- **Info:** "Registros: 1-10 de 45"

**Mensajes:**

M-1: Toast de Éxito
~~~~~~~~~~~~~~~~~~~

- **ID:** #toast-success
- **Tipo:** Toast notification
- **Posición:** Top-right
- **Duración:** 3 segundos
- **Color:** Verde
- **Icono:** ✓ (checkmark)
- **Texto:** "Reporte generado exitosamente"

M-2: Toast de Error
~~~~~~~~~~~~~~~~~~~

- **ID:** #toast-error
- **Tipo:** Toast notification
- **Posición:** Top-right
- **Duración:** 5 segundos
- **Color:** Rojo
- **Icono:** ✗ (cross)
- **Texto:** Variable según error

M-3: Modal de Carga
~~~~~~~~~~~~~~~~~~~

- **ID:** #modal-loading
- **Tipo:** Modal overlay
- **Spinner:** Sí (rotating)
- **Backdrop:** Semi-transparent
- **Texto:** "Generando reporte, por favor espere..."
- **Cancelable:** No

----------------------------------------------------------------------
3. INTERACCIONES
----------------------------------------------------------------------

**onChange Handlers:**

onChange-1: Cambio en Dropdown "Trimestre"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Trigger:** Usuario selecciona nuevo valor en dropdown

**Acción:**

1. Capturar nuevo valor
2. Validar formato (Q1|Q2|Q3|Q4)
3. Actualizar estado del form
4. Si todos los campos válidos → habilitar botón "Generar"
5. Si algún campo inválido → deshabilitar botón

**Código:**

.. code-block:: javascript

   document.getElementById('dropdown-quarter').addEventListener('change', function(e) {
       const quarter = e.target.value;
       
       // Validar
       if (!['Q1', 'Q2', 'Q3', 'Q4'].includes(quarter)) {
           showError('Trimestre inválido');
           return;
       }
       
       // Actualizar estado
       formState.quarter = quarter;
       
       // Validar formulario completo
       validateForm();
   });

onChange-2: Cambio en Dropdown "Año"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Trigger:** Usuario selecciona año

**Acción:**

1. Capturar valor
2. Validar rango (2020-2025)
3. Actualizar estado
4. Re-validar form completo

**Código:**

.. code-block:: javascript

   document.getElementById('dropdown-year').addEventListener('change', function(e) {
       const year = parseInt(e.target.value);
       
       if (year < 2020 || year > 2025) {
           showError('Año debe estar entre 2020 y 2025');
           return;
       }
       
       formState.year = year;
       validateForm();
   });

**onClick Handlers:**

onClick-1: Click en "Limpiar"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Trigger:** Usuario hace click en botón "Limpiar"

**Acción:**

1. Resetear todos los dropdowns a valores default
2. Limpiar tabla de resultados
3. Ocultar panel de paginación
4. Deshabilitar botón "Generar"

**Código:**

.. code-block:: javascript

   document.getElementById('btn-clear').addEventListener('click', function() {
       // Reset dropdowns
       document.getElementById('dropdown-quarter').value = 'Q1';
       document.getElementById('dropdown-year').value = new Date().getFullYear();
       document.getElementById('dropdown-segment').value = 'OP';
       
       // Clear results
       document.getElementById('table-results').innerHTML = '';
       document.getElementById('pagination').style.display = 'none';
       
       // Reset form state
       formState = {
           quarter: 'Q1',
           year: new Date().getFullYear(),
           segment: 'OP'
       };
       
       // Disable generate button
       document.getElementById('btn-generate').disabled = true;
   });

onClick-2: Click en "Generar Reporte"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Trigger:** Usuario hace click en botón "Generar Reporte"

**Acción:**

1. Deshabilitar botón (prevent double-click)
2. Mostrar modal de carga
3. Enviar request AJAX al backend
4. Esperar respuesta
5. Si éxito:
   - Ocultar modal
   - Renderizar tabla con datos
   - Mostrar paginación
   - Mostrar toast de éxito
   - Re-habilitar botón
6. Si error:
   - Ocultar modal
   - Mostrar toast de error
   - Re-habilitar botón

**Código:**

.. code-block:: javascript

   document.getElementById('btn-generate').addEventListener('click', async function() {
       // Disable button
       this.disabled = true;
       
       // Show loading modal
       showModal('modal-loading');
       
       try {
           // Send request
           const response = await fetch('/api/reports/generate', {
               method: 'POST',
               headers: {
                   'Content-Type': 'application/json',
                   'Authorization': `Bearer ${authToken}`
               },
               body: JSON.stringify({
                   quarter: formState.quarter,
                   year: formState.year,
                   segment: formState.segment
               })
           });
           
           if (!response.ok) {
               throw new Error(`HTTP ${response.status}`);
           }
           
           const data = await response.json();
           
           // Hide loading
           hideModal('modal-loading');
           
           // Render results
           renderTable(data.results);
           renderPagination(data.total, data.page, data.page_size);
           
           // Show success toast
           showToast('toast-success', 'Reporte generado exitosamente');
           
       } catch (error) {
           // Hide loading
           hideModal('modal-loading');
           
           // Show error toast
           showToast('toast-error', `Error: ${error.message}`);
           
       } finally {
           // Re-enable button
           this.disabled = false;
       }
   });

**onSubmit Handler:**

onSubmit-1: Submit del Formulario
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Trigger:** Usuario presiona Enter o hace click en "Generar"

**Acción:**

1. Prevenir submit HTML default (prevent page reload)
2. Validar form completo
3. Si válido → ejecutar onClick-2 (generar reporte)
4. Si inválido → mostrar errores específicos

**Código:**

.. code-block:: javascript

   document.getElementById('form-report').addEventListener('submit', function(e) {
       e.preventDefault();  // CRÍTICO: prevent page reload
       
       // Validate
       const errors = validateForm();
       
       if (errors.length > 0) {
           // Show errors
           errors.forEach(err => showToast('toast-error', err));
           return;
       }
       
       // Trigger generate
       document.getElementById('btn-generate').click();
   });

----------------------------------------------------------------------
4. VALIDACION EN CLIENTE (JavaScript)
----------------------------------------------------------------------

**Función de Validación Completa:**

.. code-block:: javascript

   function validateForm() {
       const errors = [];
       
       // Validar quarter
       const quarter = formState.quarter;
       if (!quarter || !['Q1', 'Q2', 'Q3', 'Q4'].includes(quarter)) {
           errors.push('Trimestre inválido');
       }
       
       // Validar year
       const year = formState.year;
       if (!year || year < 2020 || year > 2025) {
           errors.push('Año debe estar entre 2020 y 2025');
       }
       
       // Validar segment
       const segment = formState.segment;
       if (!segment || !['OP', 'MG', 'AD'].includes(segment)) {
           errors.push('Segmento inválido');
       }
       
       // Update button state
       const btnGenerate = document.getElementById('btn-generate');
       btnGenerate.disabled = (errors.length > 0);
       
       return errors;
   }

----------------------------------------------------------------------
5. RENDERIZADO DE RESULTADOS
----------------------------------------------------------------------

**Función renderTable:**

.. code-block:: javascript

   function renderTable(results) {
       const table = document.getElementById('table-results');
       
       // Clear previous
       table.innerHTML = '';
       
       // Build HTML
       let html = `
           <table class="table table-striped">
               <thead>
                   <tr>
                       <th onclick="sortTable(0)">Métrica ↕</th>
                       <th onclick="sortTable(1)">Valor ↕</th>
                       <th onclick="sortTable(2)">Porcentaje ↕</th>
                       <th onclick="sortTable(3)">Comparación ↕</th>
                   </tr>
               </thead>
               <tbody>
       `;
       
       results.forEach(row => {
           html += `
               <tr>
                   <td>${escapeHtml(row.metric)}</td>
                   <td>${row.value.toLocaleString()}</td>
                   <td>${row.percentage.toFixed(2)}%</td>
                   <td class="${getComparisonClass(row.comparison)}">
                       ${row.comparison > 0 ? '↑' : '↓'} ${Math.abs(row.comparison)}%
                   </td>
               </tr>
           `;
       });
       
       html += `
               </tbody>
           </table>
       `;
       
       table.innerHTML = html;
       table.style.display = 'block';
   }
   
   function getComparisonClass(value) {
       if (value > 0) return 'text-success';
       if (value < 0) return 'text-danger';
       return 'text-muted';
   }

----------------------------------------------------------------------
6. DERIVACION A FR
----------------------------------------------------------------------

Cada interacción UI deriva FR específicos:

onChange-1 → FR-XXX-YY-01: Validar Campo Trimestre
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción:** Validación en cliente de campo quarter

**Input:** String (valor del dropdown)

**Output:** Boolean (válido/inválido)

**Código:** Función validateQuarter()

onClick-2 → FR-XXX-YY-02: Generar Reporte (API Call)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción:** Request AJAX POST a /api/reports/generate

**Input:** JSON {quarter, year, segment}

**Output:** JSON {results, total, page, page_size}

**Código:** Función fetch() con error handling

Render → FR-XXX-YY-03: Renderizar Tabla Resultados
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción:** Construir HTML de tabla con datos

**Input:** Array de objetos result

**Output:** Tabla HTML insertada en DOM

**Código:** Función renderTable()

----------------------------------------------------------------------
REFERENCIAS
----------------------------------------------------------------------

**Estándares:**

- STD_001_Estandares_Documentacion_1_1_0.rst
- NOM_001_Nomenclatura_Proyecto_2_0_0.rst

**Material Pedagógico:**

- PARTE_2C_UI_Driven_IACT_1_0_0.md

**Frameworks UI:**

- Bootstrap 5: https://getbootstrap.com
- DataTables: https://datatables.net

----------------------------------------------------------------------

**Archivo:** TPL_UC_UI_Driven_1_2_0.rst  
**Version:** 1.2.0  
**Fecha:** 2026-01-09  
**Líneas:** ~450

