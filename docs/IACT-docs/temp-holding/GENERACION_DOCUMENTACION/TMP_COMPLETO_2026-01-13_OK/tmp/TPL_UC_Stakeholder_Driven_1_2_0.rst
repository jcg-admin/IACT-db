.. meta::
   :Proyecto: IACT
   :Codigo: UC-IACT-XXX-YY
   :Titulo: [Nombre - Stakeholder Driven]
   :Version: 4.0.0
   :Tipo: Stakeholder-Driven
   :Stakeholder: [Nombre del Stakeholder]
   :Fecha: YYYY-MM-DD

======================================================================
UC-IACT-XXX-YY: [Nombre] (Stakeholder-Driven)
======================================================================

**Basado en narrativa del Stakeholder:** [Nombre + Rol]

----------------------------------------------------------------------
INTRODUCCION
----------------------------------------------------------------------

**UC Stakeholder-Driven** se documenta desde la narrativa textual
proporcionada directamente por el stakeholder, preservando su voz
y extrayendo requisitos.

**Cuándo usar:** Cuando stakeholder proporciona descripción detallada
en sus propias palabras.

----------------------------------------------------------------------
1. INFORMACION DEL STAKEHOLDER
----------------------------------------------------------------------

**Identificación:**

- **Nombre completo:** [Nombre Apellido]
- **Rol/Cargo:** [Título del puesto]
- **Área/Departamento:** [Departamento]
- **Email:** [email@empresa.com]
- **Teléfono:** [+XX XXX XXX XXXX]

**Contexto:**

- **Fecha entrevista:** YYYY-MM-DD
- **Método:** [Presencial|Virtual|Email|Workshop]
- **Duración:** [N] minutos
- **Acta reunión:** [Link o archivo]

----------------------------------------------------------------------
2. NARRATIVA TEXTUAL DEL STAKEHOLDER
----------------------------------------------------------------------

**Quote literal (preservar voz del stakeholder):**

   "[Aquí va el texto EXACTO que dijo el stakeholder, preservando
   su forma de hablar, términos que usa, ejemplos que da, etc.
   
   Puede ser varios párrafos. Lo importante es NO parafrasear,
   mantener las palabras originales.
   
   Ejemplo:
   
   'Mira, lo que necesitamos es poder ver los reportes trimestrales
   de una forma más rápida. Ahorita tengo que pedirle a sistemas
   que me saquen los números, y a veces se tardan días. Yo necesito
   ver cuántas llamadas tuvimos este trimestre, cuántas se
   abandonaron, y comparar con el trimestre anterior. También
   necesito verlo por segmento, porque operaciones tiene un
   comportamiento diferente a management.
   
   Lo ideal sería que yo pudiera generar el reporte yo mismo,
   seleccionando el trimestre y el segmento, y que me salga una
   tabla con los números. Y si pudiera exportarlo a Excel para
   llevarme a las juntas ejecutivas, sería perfecto.']"

**Contexto adicional capturado:**

- Problema actual: [Descripción del pain point]
- Frecuencia de uso: [Diaria|Semanal|Mensual|Trimestral]
- Usuarios afectados: [N personas del área]
- Impacto si NO se implementa: [Descripción]
- Prioridad según stakeholder: [Alta|Media|Baja]

----------------------------------------------------------------------
3. REQUISITOS EXTRAIDOS
----------------------------------------------------------------------

**Del análisis de la narrativa, se identifican:**

**Use Case Principal:**

UC-IACT-RPT-01: Consultar Reporte Trimestral

**Actor:**

- Gerente de Operaciones (rol del stakeholder)

**Objetivo:**

Generar reportes trimestrales de métricas IVR de forma autónoma,
sin depender de área de sistemas.

**Funcionalidad Core:**

1. Seleccionar trimestre (Q1, Q2, Q3, Q4)
2. Seleccionar año
3. Seleccionar segmento (OP, MG, AD)
4. Generar reporte con métricas:
   - Total de llamadas
   - Llamadas abandonadas
   - Tasa de abandono
   - Comparación con trimestre anterior
5. Exportar a Excel

**Business Rules Identificadas:**

- BR-IACT-053: Cálculo de tasa de abandono
  (derivado de "cuántas se abandonaron")
  
- BR-IACT-054: Comparación trimestral
  (derivado de "comparar con trimestre anterior")
  
- BR-IACT-055: Segmentación por área
  (derivado de "por segmento, operaciones vs management")

**Requisitos No Funcionales:**

- RNF-1: Tiempo respuesta < 5 segundos
  (derivado de "de una forma más rápida")
  
- RNF-2: Self-service (sin IT)
  (derivado de "yo pudiera generar el reporte yo mismo")
  
- RNF-3: Exportación Excel
  (derivado de "exportarlo a Excel para juntas")

----------------------------------------------------------------------
4. VALIDACION CON STAKEHOLDER
----------------------------------------------------------------------

**Checklist de Validación:**

.. list-table::
   :header-rows: 1
   :widths: 60 20 20

   * - Requisito Extraído
     - Validado
     - Notas
   * - UC: Consultar Reporte Trimestral
     - [ ]
     - 
   * - Actor: Gerente de Operaciones
     - [ ]
     - 
   * - Selección trimestre/año/segmento
     - [ ]
     - 
   * - Métricas: total, abandonadas, tasa
     - [ ]
     - 
   * - Comparación trimestral
     - [ ]
     - 
   * - Exportación Excel
     - [ ]
     - 
   * - Tiempo respuesta < 5 seg
     - [ ]
     - 

**Firma de Aprobación:**

______________________________
[Nombre del Stakeholder]
[Cargo]
Fecha: _______________

----------------------------------------------------------------------
REFERENCIAS
----------------------------------------------------------------------

- STD_001_Estandares_Documentacion_1_1_0.rst
- NOM_001_Nomenclatura_Proyecto_2_0_0.rst

**Archivo:** TPL_UC_Stakeholder_Driven_1_2_0.rst  
**Líneas:** ~280

