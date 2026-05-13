# PlantUML Rendering Error — Root Cause Analysis & Prevention

```yml
created_at: 2026-04-25 06:58:00
project: IACT-docs
work_package: 2026-04-23-18-51-33-plantuml-java-integration-impl
phase: Phase 11 — TRACK/EVALUATE
author: claude
status: Aprobado
severity: HIGH
category: Configuration Mismatch
```

## Problema Observado

PlantUML diagrams estaban siendo **generados pero NO embebidos** en el HTML:
- Los PNGs existían en disco (161 archivos creados correctamente)
- El HTML tenía `<figure>` vacíos (solo caption, sin `<img>` tag)
- Las referencias HTML apuntaban a `_images/plantuml-*.png`
- Pero los archivos estaban en `_static/img/diagrams/plantuml-guide/...`
- **Resultado:** Figura visible en TOC pero sin imagen

---

## Root Causes (Dos problemas encadenados)

### Causa 1: Include Path Incorrecto — SINTAXIS

**Nivel:** Inmediato / Obvio

**Lo que pasó:**
```puml
!include ../_static/plantuml-styles.puml
```

**Resolución en disco:**
- Archivo RST: `source/plantuml-guide/ejemplos/etl-pipeline.rst`
- Camino relativo `../_static/` → `source/plantuml-guide/_static/` ❌
- Debería ser: `source/_static/` ✓

**Corrección:**
```puml
!include ../../_static/plantuml-styles.puml
```

**Por qué no fue obvio:**
- PlantUML procesa en working directory temporal, no desde la ubicación del RST
- El error de include falla **silenciosamente** en sphinxcontrib.plantuml
- La imagen se genera (aunque posiblemente corrupta) → no hay error en logs
- Sphinx sigue procesando como si todo estuviera bien

### Causa 2: Configuration Mismatch — ARQUITECTÓNICO

**Nivel:** Sistémico / Diseño

**Lo que pasó:**
```python
# en conf.py
plantuml_output_dir = '_static/img/diagrams'
```

**El mismatch:**
1. `plantuml_output_dir` le dice a sphinxcontrib dónde **guardar** los PNGs
2. sphinxcontrib.plantuml genera referencias HTML que apuntan a `_images/` (su ubicación por defecto)
3. **Desconexión:** Archivos en `_static/img/diagrams/` pero referencias a `_images/`
4. Post-build hook mueve archivos a `_static/img/` DESPUÉS de que HTML fue generado
5. Referencias HTML quedan rotas permanentemente

**Cadena causal:**
```
conf.py: plantuml_output_dir = '_static/img/diagrams'
    ↓
sphinxcontrib build phase:
    - Genera PNGs → guarda en _static/img/diagrams/
    - Genera HTML referencias → apunta a _images/
    ↓
Post-build hook:
    - Intenta reorganizar desde _images/ a _static/img/
    - Pero los archivos ya están en _static/img/ (no en _images/)
    ↓
Final HTML:
    <img src="../../_images/plantuml-xxx.png" />  [Link roto]
    [PNG existe en _static/img/diagrams/... pero no se referencia]
```

**Por qué pasó:**
- La documentación de sphinxcontrib.plantuml no es clara sobre este comportamiento
- `plantuml_output_dir` parece que cambiaría TODO (ubicación + referencias) pero solo cambia ubicación de guardado
- El hook post-build se ejecuta DESPUÉS de que el HTML ya está generado
- No hay validación de que referencias HTML sean consistentes con ubicaciones reales

---

## Síntomas & Diagnóstico

### Síntoma 1: HTML sin imágenes
```html
<figure class="align-default" id="id1">
<figcaption>
  <p><span class="caption-text">Mi Diagrama</span></p>
</figcaption>
</figure>  <!-- Vacío: NO hay <img> adentro -->
```

### Síntoma 2: Archivos PNG existe pero no se pueden encontrar
```bash
$ find build/html -name "plantuml-*.png"
build/html/_static/img/diagrams/plantuml-guide/activity/04ea007f...png
build/html/_static/img/raster/plantuml-04ea007f...png

$ grep "img.*plantuml" build/html/plantuml-guide/ejemplos/etl-pipeline.html
<img src="../../_images/plantuml-04ea007f...png" />
```

### Cómo Diagnosticar:
1. ✓ Build completa sin errores → no significa que los diagramas se vean
2. ✓ Verificar: `grep -r ".. uml::" source/ | wc -l` (directivas PlantUML)
3. ✓ Verificar: `grep -r "<img.*plantuml" build/html | wc -l` (referencias embebidas)
4. ✓ Si (1) > (3), hay diagrams sin embeber
5. ✓ Revisar: `find build/html -name "plantuml-*.png" | sort | uniq -c`
6. ✓ Comparar ubicaciones en HTML vs disco

---

## Solución Implementada

### Opción Elegida: Usar Ubicación Estándar de sphinxcontrib

**Cambio en conf.py:**
```python
# ANTES:
plantuml_output_dir = '_static/img/diagrams'

# DESPUÉS:
# (Removido completamente — usar default de sphinxcontrib: _images/)
```

**Beneficios:**
- ✓ sphinxcontrib genera PNGs en `_images/`
- ✓ sphinxcontrib genera referencias HTML a `_images/`
- ✓ Referencias + ubicaciones son CONSISTENTES
- ✓ Sin mismatch = sin sorpresas

**Post-build hook actualizado:**
```python
def reorganize_static_assets(app, exception):
    # Organizar metadatos PlantUML en _images/diagrams/{module}/{type}/
    # Copiar PNGs PlantUML a _images/ (ya están ahí por defecto)
    # RESULTADO: Archivos en ubicación correcta, referencias correctas
```

**Costo:**
- Diagrams terminan en `_images/` en lugar de `_static/img/diagrams/`
- Esto es BIEN — `_images/` es donde Sphinx espera encontrar images
- Mantiene la compatibilidad y reduce complejidad

---

## Cómo No Volver a Pasar

### 1. Regla de Arquitectura (ADR)

**Para agregar a CLAUDE.md o nuevo ADR:**

```markdown
## PlantUML + Sphinx Integration

NO personalizar `plantuml_output_dir` en conf.py.

Razón: Causa mismatch entre ubicación de guardado y referencias HTML.
sphinxcontrib.plantuml siempre genera referencias a _images/, 
aunque se configure para guardar en otro lado.

Usar defaults:
- PNGs se guardan en: build/html/_images/
- Referencias HTML apuntan a: ../../_images/
- Post-build hook reorganiza METADATOS, no files

Validación: 
  grep -c ".. uml::" source/**/*.rst 
  grep -c "<img.*plantuml" build/html/**/*.html
  Deben ser iguales ± 1 (por metadata examples)
```

### 2. Pre-build Validation Script

**Crear script para verificar consistencia:**

```bash
#!/bin/bash
# scripts/validate-plantuml.sh

echo "PlantUML Consistency Check"
echo "=========================="

# Contar directivas
DIRECTIVES=$(find source -name "*.rst" -exec grep -c ".. uml::" {} \; | awk '{s+=$1} END {print s}')
echo "PlantUML directives found: $DIRECTIVES"

# Verificar que no hay custom plantuml_output_dir
if grep -q "plantuml_output_dir.*=" source/conf.py; then
    echo "❌ ERROR: custom plantuml_output_dir found in conf.py"
    echo "   Remove it to use sphinxcontrib defaults"
    exit 1
fi

# Verificar que no hay malos include paths
BAD_INCLUDES=$(find source -name "*.rst" -exec grep "!include.*/_static" {} \; | grep -v "../../_static" | wc -l)
if [ "$BAD_INCLUDES" -gt 0 ]; then
    echo "❌ ERROR: Found $BAD_INCLUDES include paths with wrong depth"
    echo "   All !include should use: ../../_static/plantuml-styles.puml"
    exit 1
fi

echo "✓ All checks passed"
```

**Integrar en Makefile:**
```makefile
validate: validate-plantuml
	echo "All validations passed"

validate-plantuml:
	@bash scripts/validate-plantuml.sh

html: validate html-build
```

### 3. Post-build Validation

**Agregar al hook post-build:**

```python
def validate_plantuml_references(build_dir):
    """
    Verifica que todas las referencias HTML a PlantUML existan
    """
    import re
    from pathlib import Path
    
    html_files = build_dir.glob("**/*.html")
    broken_refs = []
    
    for html_file in html_files:
        with open(html_file) as f:
            content = f.read()
            # Buscar referencias a plantuml PNGs
            refs = re.findall(r'src="([^"]*plantuml-[^"]*\.png)"', content)
            for ref in refs:
                # Resolver ruta relativa
                full_path = (html_file.parent / ref).resolve()
                if not full_path.exists():
                    broken_refs.append({
                        'html': html_file.name,
                        'reference': ref,
                        'resolved': full_path
                    })
    
    if broken_refs:
        raise RuntimeError(f"Found {len(broken_refs)} broken PlantUML references:\n" + 
                          "\n".join(str(r) for r in broken_refs))
    
    return True
```

### 4. Documentation Standard

**Agregar a GUIDELINES.rst:**

```rst
Include Path Correctness
========================

CORRECTO:
  El archivo RST está en: source/plantuml-guide/ejemplos/diagrama.rst
  Debe incluir:
  
  .. code-block:: puml
  
     !include ../../_static/plantuml-styles.puml
  
  Explicación:
    ../../  = Sube 2 niveles: ejemplos/ → plantuml-guide/ → source/
    _static/ = Directorio desde source/ root
    Ruta final: source/_static/plantuml-styles.puml ✓

INCORRECTO (Errores comunes):
  !include ../_static/...     (Sube solo 1 nivel)
  !include ../../_static/plantuml-styles.puml (correcto)
  !include /source/_static/... (paths absolutos no funcionan)

Verificar: 
  - Contar /../../_static/ en el archivo
  - Deben ser EXACTAMENTE 2 puntos (..)
```

---

## Lecciones Aprendidas

### 1. Configuration Magic vs Explicit Defaults

**Lección:** Personalizar configuración es peligroso si no se entiende completamente.

- `plantuml_output_dir` parecía "helpful" — centralizar en `_static/`
- Resultó en conflicto invisible entre generador y referencias
- **Mejor:** Usar defaults conocidos, personalizar solo si es ABSOLUTAMENTE necesario

### 2. Silent Failures en Herramientas Integradas

**Lección:** sphinxcontrib.plantuml no valida consistencia entre:
- Donde guarda archivos
- Donde genera referencias HTML

- El include path incorrecto falla silenciosamente
- El archivo se crea de todas formas (corrupto pero existe)
- Sphinx continúa como si nada hubiera pasado

**Prevención:** Siempre validar post-build que referencias = archivos

### 3. Two-Phase Build == Hidden Timing Bugs

**Lección:** Cuando hay múltiples fases (sphinxcontrib genera, luego hook post-build reorganiza):
- Las referencias HTML se generan en Fase 1
- Los archivos se mueven en Fase 2
- Si Fase 1 y Fase 2 tienen supuestos diferentes → bug garantizado

**Prevención:** 
- Post-build hooks NO pueden "fijar" referencias generadas en Fase 1
- Solo pueden reorganizar archivos (sin que afecte HTML generado)
- Mejor: Alinear configuración para que Fase 1 + Fase 2 sean consistentes

### 4. Testing Strategy

**Lo que debería haber existido:**

```python
def test_plantuml_diagrams():
    """Verifica que TODOS los diagramas se embeben en HTML"""
    import re
    from pathlib import Path
    
    source_dir = Path("source")
    build_dir = Path("build/html")
    
    # Contar directivas
    uml_directives = 0
    for rst_file in source_dir.rglob("*.rst"):
        with open(rst_file) as f:
            uml_directives += f.read().count(".. uml::")
    
    # Contar referencias embebidas
    embedded = 0
    for html_file in build_dir.rglob("*.html"):
        with open(html_file) as f:
            embedded += len(re.findall(r'<img.*plantuml-.*png', f.read()))
    
    # Validar
    assert embedded == uml_directives, \
        f"Mismatch: {uml_directives} directives but only {embedded} embedded"
    
    # Validar que archivos existen
    images_dir = build_dir / "_images"
    png_count = len(list(images_dir.glob("plantuml-*.png")))
    assert png_count == embedded, \
        f"Mismatch: {embedded} embedded but only {png_count} PNG files"
```

---

## Checklist para Nuevos Diagramas

Cuando agregues un nuevo `.. uml::` diagrama:

- [ ] Sintaxis correcta: `.. uml::` en RST
- [ ] Include path correcto: `!include ../../_static/plantuml-styles.puml`
  - Contar `/../..//` — debe ser EXACTAMENTE 2
- [ ] Metadata presente: `@IACT-DIAGRAM` + module + type
- [ ] Build local: `make clean && make html`
- [ ] Verificación:
  ```bash
  # Debe existir en _images/
  find build/html/_images -name "plantuml-*.png" | wc -l
  
  # Debe estar embebido en HTML
  grep -c "img.*plantuml.*png" build/html/[ruta]/archivo.html
  # Output debe ser 1 (o N si N diagramas en ese archivo)
  ```
- [ ] Commit: Source + build artifacts

---

## Referencias

- sphinxcontrib.plantuml docs: https://pypi.org/project/sphinxcontrib-plantuml/
- Sphinx image handling: https://www.sphinx-doc.org/en/master/usage/markup/images.html
- Commits asociados:
  - 9d86b12: `fix(plantuml): correct include path`
  - d1b5639: `refactor(plantuml): use standard sphinxcontrib output location`
  - 4dad202: `chore(build): update artifacts after PlantUML refactoring`
