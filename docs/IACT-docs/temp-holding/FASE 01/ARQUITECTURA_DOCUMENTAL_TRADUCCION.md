# ARQUITECTURA DOCUMENTAL PARA PROCEDIMIENTOS DE TRADUCCIÓN
## Modelo Específico v1.0.0

---

## ANÁLISIS: ¿Por qué IACT no aplica directamente?

### Dominios IACT (para software):
```
❌ arquitectura_tecnica/    → APIs, bases de datos, deployment
❌ diseño_detallado/         → Modelos de datos, esquemas
❌ requisitos/casos_uso/     → Casos de uso de sistema
✅ base_cognitiva/           → Glosarios, taxonomías (SÍ APLICA)
✅ normativa/                → Procedimientos, estándares (SÍ APLICA)
⚠️ gestión/                  → Manuales, evidencia (APLICA PARCIAL)
```

### Lo que REALMENTE necesitamos para traducción:
```
✓ Glosario de términos de traducción
✓ Taxonomías de tipos de traducción/documentos
✓ Procedimientos paso a paso
✓ Estándares por medio (LaTeX, Sphinx, Markdown)
✓ Reglas de traducción operativas
✓ Escenarios de traducción comunes
✓ Herramientas y equivalencias por medio
✓ Ejemplos prácticos y casos de estudio
✓ Matrices de decisión
```

---

## PROPUESTA: ARQUITECTURA DOCUMENTAL DE TRADUCCIÓN

### Estructura Completa

```
source/
│
├── index.rst                                    # Página principal
│
├── 01_fundamentos/                              # Base conceptual
│   ├── index.rst
│   ├── glosario_traduccion.rst                 # Términos clave
│   ├── principios_fundamentales.rst            # Fidelidad, precisión, etc.
│   ├── taxonomias/
│   │   ├── index.rst
│   │   ├── tipos_traduccion.rst               # Técnica, académica, literaria
│   │   ├── tipos_documento.rst                # Libros, artículos, manuales
│   │   └── niveles_fidelidad.rst              # Alta, media, adaptación
│   └── metamodelos/
│       ├── index.rst
│       ├── estructura_libro.rst
│       ├── estructura_articulo.rst
│       └── estructura_manual.rst
│
├── 02_procedimientos/                           # Cómo hacer las traducciones
│   ├── index.rst
│   ├── workflow_general.rst                    # Flujo completo de trabajo
│   ├── modo_alta_fidelidad/
│   │   ├── index.rst
│   │   ├── procedimiento.rst
│   │   ├── checklist.rst
│   │   └── ejemplos.rst
│   ├── modo_marcado_visual/
│   │   ├── index.rst
│   │   ├── procedimiento.rst
│   │   ├── checklist.rst
│   │   └── ejemplos.rst
│   ├── verificacion_calidad/
│   │   ├── index.rst
│   │   ├── checklist_contenido.rst
│   │   ├── checklist_terminos.rst
│   │   ├── checklist_formato.rst
│   │   └── checklist_fidelidad.rst
│   └── correccion_errores/
│       ├── index.rst
│       ├── protocolo_autocorreccion.rst
│       └── errores_comunes.rst
│
├── 03_estandares/                               # Normas y guías
│   ├── index.rst
│   ├── terminologia/
│   │   ├── index.rst
│   │   ├── primera_aparicion.rst              # español (inglés)
│   │   ├── usos_posteriores.rst               # solo español
│   │   ├── excepciones.rst                    # nombres propios, acrónimos
│   │   └── glosarios_por_dominio.rst          # BPM, Software, UML
│   ├── formato_por_medio/
│   │   ├── index.rst
│   │   ├── estandares_latex.rst
│   │   ├── estandares_sphinx.rst
│   │   └── estandares_markdown.rst
│   ├── calidad/
│   │   ├── index.rst
│   │   ├── criterios_fidelidad.rst
│   │   ├── criterios_precision.rst
│   │   └── criterios_consistencia.rst
│   └── restricciones/
│       ├── index.rst
│       ├── uso_emojis.rst
│       ├── elementos_visuales.rst
│       └── modificaciones_contenido.rst
│
├── 04_reglas_operativas/                        # Reglas específicas
│   ├── index.rst
│   ├── reglas_traduccion/
│   │   ├── index.rst
│   │   ├── RT_001_primera_aparicion_terminos.rst
│   │   ├── RT_002_nombres_propios.rst
│   │   ├── RT_003_acronimos.rst
│   │   ├── RT_004_referencias_cruzadas.rst
│   │   ├── RT_005_formulas_matematicas.rst
│   │   ├── RT_006_codigo_fuente.rst
│   │   ├── RT_007_tablas.rst
│   │   ├── RT_008_imagenes_diagramas.rst
│   │   ├── RT_009_jerarquia_titulos.rst
│   │   └── RT_010_listas_enumeraciones.rst
│   ├── escenarios_traduccion/
│   │   ├── index.rst
│   │   ├── ET_001_libro_tecnico_academico.rst
│   │   ├── ET_002_documentacion_software.rst
│   │   ├── ET_003_tutorial_didactico.rst
│   │   ├── ET_004_articulo_cientifico.rst
│   │   ├── ET_005_manual_usuario.rst
│   │   └── ET_006_apuntes_clase.rst
│   └── matrices_decision/
│       ├── index.rst
│       ├── MD_001_modo_1_vs_modo_2.rst
│       ├── MD_002_seleccion_medio.rst
│       └── MD_003_nivel_fidelidad.rst
│
├── 05_herramientas_medios/                      # Específico por formato
│   ├── index.rst
│   ├── latex/
│   │   ├── index.rst
│   │   ├── comandos_nativos.rst               # \textbf, \textit, etc.
│   │   ├── paquetes_disponibles.rst
│   │   ├── sistema_referencias.rst            # \ref, \vref, \label
│   │   ├── marcado_pedagogico.rst             # quote, textbf, etc.
│   │   └── ejemplos_completos.rst
│   ├── sphinx/
│   │   ├── index.rst
│   │   ├── directivas_rst.rst                 # .. note::, .. warning::
│   │   ├── extensiones_disponibles.rst
│   │   ├── sistema_referencias.rst            # :ref:, :doc:, :term:
│   │   ├── marcado_pedagogico.rst             # admonitions, etc.
│   │   └── ejemplos_completos.rst
│   ├── markdown/
│   │   ├── index.rst
│   │   ├── sintaxis_basica.rst
│   │   ├── variantes.rst                      # GFM, CommonMark, etc.
│   │   ├── marcado_pedagogico.rst
│   │   └── ejemplos_completos.rst
│   └── equivalencias/
│       ├── index.rst
│       ├── tabla_maestra_cross_medio.rst
│       ├── conceptos_clave.rst
│       ├── definiciones.rst
│       ├── ejemplos.rst
│       ├── advertencias.rst
│       └── referencias.rst
│
├── 06_casos_practicos/                          # Ejemplos reales
│   ├── index.rst
│   ├── antes_despues/
│   │   ├── index.rst
│   │   ├── caso_01_latex_libro.rst
│   │   ├── caso_02_sphinx_proyecto.rst
│   │   ├── caso_03_markdown_tutorial.rst
│   │   └── caso_04_pdf_ocr.rst
│   ├── errores_comunes/
│   │   ├── index.rst
│   │   ├── error_01_no_marcar_primera_aparicion.rst
│   │   ├── error_02_traducir_nombres_propios.rst
│   │   ├── error_03_perder_formato.rst
│   │   ├── error_04_traducir_codigo.rst
│   │   ├── error_05_inconsistencia_terminologica.rst
│   │   ├── error_06_emojis_no_solicitados.rst
│   │   └── error_07_entrega_fragmentada.rst
│   ├── casos_exito/
│   │   ├── index.rst
│   │   ├── exito_01_libro_BPM.rst
│   │   ├── exito_02_manual_latex.rst
│   │   └── exito_03_docs_iact.rst
│   └── ejercicios_practica/
│       ├── index.rst
│       ├── ejercicio_01_terminos_tecnicos.rst
│       ├── ejercicio_02_referencias.rst
│       └── ejercicio_03_marcado_pedagogico.rst
│
├── 07_guias_uso/                                # Cómo usar estos procedimientos
│   ├── index.rst
│   ├── guia_rapida.rst                         # Inicio rápido
│   ├── tutorial_completo.rst                   # Paso a paso detallado
│   ├── faq.rst                                 # Preguntas frecuentes
│   ├── troubleshooting.rst                     # Resolución de problemas
│   └── glosario_visual.rst                     # Guía visual de símbolos
│
├── 08_prompts/                                  # Prompts de producción
│   ├── index.rst
│   ├── prompt_maestro_latex.rst
│   ├── prompt_maestro_sphinx.rst
│   ├── prompt_maestro_markdown.rst
│   ├── prompts_condicionales/
│   │   ├── index.rst
│   │   ├── caso_a_traduccion_estandar.rst
│   │   ├── caso_b_contenido_traducido.rst
│   │   ├── caso_c_sin_archivo_objetivo.rst
│   │   ├── caso_d_contenido_extenso.rst
│   │   └── caso_e_referencias_complejas.rst
│   └── plantillas/
│       ├── index.rst
│       ├── plantilla_verificacion_contextual.rst
│       ├── plantilla_reporte_final.rst
│       └── plantilla_glosario.rst
│
├── 09_referencias/                              # Material de consulta
│   ├── index.rst
│   ├── bibliografia.rst
│   ├── recursos_externos.rst
│   ├── documentacion_oficial/
│   │   ├── index.rst
│   │   ├── latex_oficial.rst
│   │   ├── sphinx_oficial.rst
│   │   └── markdown_specs.rst
│   └── cheatsheets/
│       ├── index.rst
│       ├── cheatsheet_latex.rst
│       ├── cheatsheet_sphinx.rst
│       └── cheatsheet_markdown.rst
│
└── 10_apendices/                                # Información adicional
    ├── index.rst
    ├── historia_versiones.rst
    ├── contribuidores.rst
    ├── licencia.rst
    └── roadmap.rst
```

---

## JUSTIFICACIÓN DE LA ESTRUCTURA

### 01_fundamentos/
**¿Por qué?** Establece la base conceptual de traducción técnica.
**Contenido:** Glosario, principios, taxonomías de tipos de traducción/documentos.

### 02_procedimientos/
**¿Por qué?** Documentos operativos paso a paso.
**Contenido:** Workflows completos, procedimientos por modo, verificación, corrección.

### 03_estandares/
**¿Por qué?** Normas y criterios de calidad.
**Contenido:** Terminología, formato por medio, criterios de calidad, restricciones.

### 04_reglas_operativas/
**¿Por qué?** Reglas específicas aplicables y escenarios concretos.
**Contenido:** Reglas RT_001-010, escenarios de traducción, matrices de decisión.

### 05_herramientas_medios/
**¿Por qué?** Información técnica específica por formato.
**Contenido:** LaTeX, Sphinx, Markdown - comandos, directivas, equivalencias.

### 06_casos_practicos/
**¿Por qué?** Aprendizaje por ejemplo.
**Contenido:** Antes/después, errores comunes, casos de éxito, ejercicios.

### 07_guias_uso/
**¿Por qué?** Facilitar adopción del procedimiento.
**Contenido:** Guía rápida, tutorial, FAQ, troubleshooting.

### 08_prompts/
**¿Por qué?** Automatización y reutilización.
**Contenido:** Prompts maestros por medio, casos condicionales, plantillas.

### 09_referencias/
**¿Por qué?** Material de consulta adicional.
**Contenido:** Bibliografía, documentación oficial, cheatsheets.

### 10_apendices/
**¿Por qué?** Información complementaria del proyecto.
**Contenido:** Versiones, contribuidores, licencia, roadmap.

---

## MAPEO DEL CONTENIDO EXISTENTE

### Documentos Actuales → Nueva Estructura

| Documento Actual | Ubicación en Nueva Estructura |
|------------------|-------------------------------|
| procedimiento_traduccion.md | 02_procedimientos/workflow_general.rst |
| procedimiento_integrado.md | 02_procedimientos/modo_marcado_visual/procedimiento.rst |
| principios_alta_fidelidad.md | 03_estandares/calidad/criterios_fidelidad.rst |
| matriz_decision_fidelidad.md | 04_reglas_operativas/matrices_decision/MD_001_modo_1_vs_modo_2.rst |
| adaptacion_medio_especifico.md | 05_herramientas_medios/equivalencias/tabla_maestra_cross_medio.rst |
| flujo_traduccion.md | 02_procedimientos/workflow_general.rst (con diagramas) |
| guia_rapida.md | 07_guias_uso/guia_rapida.rst |
| analisis_chat_499a2182.md | 10_apendices/historia_versiones.rst |
| PROMPT_MAESTRO_SPHINX_TRADUCCION.md | 08_prompts/prompt_maestro_sphinx.rst |

### Nuevo Contenido a Crear

**Prioridad Alta:**
1. 01_fundamentos/glosario_traduccion.rst
2. 02_procedimientos/modo_alta_fidelidad/procedimiento.rst
3. 03_estandares/terminologia/primera_aparicion.rst
4. 04_reglas_operativas/reglas_traduccion/RT_001-010.rst
5. 05_herramientas_medios/latex/comandos_nativos.rst
6. 05_herramientas_medios/sphinx/directivas_rst.rst
7. 06_casos_practicos/errores_comunes/error_01-07.rst
8. 07_guias_uso/tutorial_completo.rst

**Prioridad Media:**
1. 01_fundamentos/taxonomias/tipos_traduccion.rst
2. 04_reglas_operativas/escenarios_traduccion/ET_001-006.rst
3. 05_herramientas_medios/equivalencias/tabla_maestra_cross_medio.rst
4. 06_casos_practicos/antes_despues/caso_01-04.rst
5. 08_prompts/prompt_maestro_latex.rst
6. 08_prompts/prompt_maestro_markdown.rst

**Prioridad Baja:**
1. 09_referencias/bibliografia.rst
2. 09_referencias/cheatsheets/*.rst
3. 10_apendices/contribuidores.rst

---

## VENTAJAS DE ESTA ESTRUCTURA

### ✅ Ventajas sobre IACT puro

1. **Específica para traducción**
   - No hay conceptos irrelevantes (APIs, bases de datos)
   - Cada sección tiene propósito claro en el dominio

2. **Orientada al usuario traductor**
   - Progresión lógica: fundamentos → procedimientos → práctica
   - Fácil localización de información
   - Ejemplos abundantes

3. **Modular y escalable**
   - Fácil añadir nuevos medios (HTML, AsciiDoc, etc.)
   - Fácil añadir nuevos escenarios
   - Fácil añadir nuevas reglas

4. **Pedagógica**
   - De lo conceptual a lo práctico
   - Casos de estudio reales
   - Ejercicios de práctica

5. **Operativa**
   - Prompts listos para usar
   - Checklists aplicables
   - Matrices de decisión claras

---

## CONFIGURACIÓN SPHINX PARA ESTA ESTRUCTURA

### conf.py - Ajustes Recomendados

```python
# Información del proyecto
project = 'Procedimientos de Traducción Técnica'
author = 'Equipo de Traducción'
version = '1.0'
release = '1.0.0'

# Idioma
language = 'es'

# Extensiones necesarias
extensions = [
    'sphinx.ext.autodoc',
    'sphinx.ext.intersphinx',
    'sphinx.ext.todo',
    'sphinx.ext.viewcode',
    'sphinx_design',
    'sphinx_copybutton',
    'sphinx-tabs',
    'sphinx_toolbox',
    'myst_parser',
]

# Tema
html_theme = 'furo'

# Colores personalizados (opcional)
html_theme_options = {
    'dark_css_variables': {
        'color-brand-primary': '#199cd7',
        'color-brand-content': '#199cd7',
    },
}

# Numeración de secciones
numfig = True
numfig_format = {
    'figure': 'Figura %s',
    'table': 'Tabla %s',
    'code-block': 'Listado %s',
    'section': 'Sección %s',
}

# TOC global
html_sidebars = {
    '**': [
        'sidebar/search.html',
        'sidebar/scroll-start.html',
        'sidebar/navigation.html',
        'sidebar/scroll-end.html',
    ]
}
```

### index.rst - Página Principal

```rst
Procedimientos de Traducción Técnica
=====================================

Versión 1.0.0

Bienvenido a la documentación completa de procedimientos de traducción técnica.
Esta documentación cubre metodologías, estándares, herramientas y casos prácticos
para traducción de alta calidad de documentación técnica.

.. toctree::
   :maxdepth: 2
   :caption: Contenido Principal
   :numbered:

   01_fundamentos/index
   02_procedimientos/index
   03_estandares/index
   04_reglas_operativas/index
   05_herramientas_medios/index
   06_casos_practicos/index
   07_guias_uso/index
   08_prompts/index
   09_referencias/index
   10_apendices/index

Inicio Rápido
-------------

Si eres nuevo, comienza aquí:

1. :doc:`07_guias_uso/guia_rapida` - Introducción de 5 minutos
2. :doc:`01_fundamentos/principios_fundamentales` - Conceptos base
3. :doc:`02_procedimientos/workflow_general` - Proceso completo
4. :doc:`06_casos_practicos/antes_despues/caso_01_latex_libro` - Ejemplo práctico

Búsqueda Rápida
---------------

* **¿Cómo traduzco un libro LaTeX?** → :doc:`08_prompts/prompt_maestro_latex`
* **¿Qué modo uso?** → :doc:`04_reglas_operativas/matrices_decision/MD_001_modo_1_vs_modo_2`
* **¿Cómo marco conceptos clave?** → :doc:`05_herramientas_medios/equivalencias/conceptos_clave`
* **Errores comunes** → :doc:`06_casos_practicos/errores_comunes/index`

Índices y Tablas
----------------

* :ref:`genindex`
* :ref:`search`
* :doc:`01_fundamentos/glosario_traduccion`
```

---

## COMPARACIÓN: IACT vs TRADUCCIÓN

| Aspecto | IACT (Software) | Traducción (Documentación) |
|---------|-----------------|----------------------------|
| **Dominio 1** | base_cognitiva | 01_fundamentos |
| **Dominio 2** | normativa | 02_procedimientos |
| **Dominio 3** | requisitos | 03_estandares |
| **Dominio 4** | arquitectura_tecnica | 04_reglas_operativas |
| **Dominio 5** | gestion | 05_herramientas_medios |
| **Adicionales** | - | 06_casos_practicos |
|  |  | 07_guias_uso |
|  |  | 08_prompts |
|  |  | 09_referencias |
|  |  | 10_apendices |

**Observación:** La estructura de traducción tiene 10 secciones principales vs 5 dominios IACT,
porque el enfoque es diferente (procedimientos vs desarrollo de software).

---

## PRÓXIMOS PASOS RECOMENDADOS

### Fase 1: Estructura Base (1 sesión)
```bash
# Crear estructura completa de directorios
mkdir -p source/{01_fundamentos,02_procedimientos,03_estandares,04_reglas_operativas,05_herramientas_medios,06_casos_practicos,07_guias_uso,08_prompts,09_referencias,10_apendices}

# Crear index.rst en cada carpeta principal
for dir in source/0*_*/; do
    touch "${dir}index.rst"
done
```

### Fase 2: Contenido Crítico (2-3 sesiones)
1. Migrar documentos existentes a nueva estructura
2. Crear glosario de traducción
3. Documentar procedimiento alta fidelidad
4. Documentar procedimiento marcado visual
5. Crear tabla de equivalencias cross-medio

### Fase 3: Casos Prácticos (2-3 sesiones)
1. Documentar 7 errores comunes con ejemplos
2. Crear 3 casos antes/después
3. Crear 3 ejercicios de práctica
4. Documentar casos de éxito

### Fase 4: Prompts y Automatización (1-2 sesiones)
1. Integrar prompts maestros
2. Crear plantillas reutilizables
3. Documentar casos condicionales

### Fase 5: Pulido y Referencias (1 sesión)
1. Crear cheatsheets
2. Compilar bibliografía
3. Escribir FAQ
4. Actualizar roadmap

---

## CONCLUSIÓN

Esta arquitectura está **específicamente diseñada** para documentar procedimientos
de traducción técnica, a diferencia de IACT que está diseñada para documentar
proyectos de desarrollo de software.

**Ventajas clave:**
- ✅ Estructura lógica para traductores
- ✅ Progresión pedagógica clara
- ✅ Casos prácticos abundantes
- ✅ Prompts operativos listos
- ✅ Escalable a nuevos medios
- ✅ Sin conceptos irrelevantes

**¿Proceder con esta estructura?**
