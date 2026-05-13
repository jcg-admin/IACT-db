.. meta::
   :Proyecto: IACT
   :Codigo: UC-IACT-XXX-YY
   :Tecnica: UI-Driven
   :Version: 4.0.0

======================================================================
UC-IACT-XXX-YY: [Nombre] (UI-Driven)
======================================================================

MOCKUP/WIREFRAME
~~~~~~~~~~~~~~~~
**Archivo:** [mockup.png]
**Herramienta:** [Figma/Sketch]

ELEMENTOS UI
~~~~~~~~~~~~

Entrada:
- Dropdown #id: valores [A,B,C], default=A
- Input #id: tipo=text, validación=email

Acción:
- Button #btn-submit: onClick=submitForm()

Salida:
- Table #results: columnas [A,B,C]
- Chart #chart: tipo=bar, librería=Chart.js

INTERACCIONES
~~~~~~~~~~~~~

onChange Dropdown:
1. Validar valor
2. Habilitar botón si todos llenos

onClick Submit:
1. Mostrar loading
2. POST /api/endpoint
3. Renderizar resultados
4. Mostrar toast éxito

DERIVACION FR:
- FR-XXX-01: Validar dropdown
- FR-XXX-02: Enviar AJAX request
- FR-XXX-03: Renderizar tabla

**Archivo:** TPL_UC_UI_Driven_1_1_0.rst
**Version:** 1.1.0
