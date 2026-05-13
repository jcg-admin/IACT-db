```yml
created_at: 2026-04-23 22:45:00
project: IACT-docs
work_package: 2026-04-23-18-51-33-plantuml-java-integration-impl
phase: Phase 1 — DISCOVER
author: Claude Code Agent
status: En revisión
version: 1.0.0
```

# Análisis: sphinxcontrib.plantuml Integration — How Sphinx Executes PlantUML

**Propósito:** Entender cómo sphinxcontrib.plantuml plugin procesa `!include` y aplica estilos centralizados cuando Sphinx ejecuta `make html`.

**Criticidad:** ALTA — Afecta viabilidad técnica de toda la estrategia.

---

## 1. Arquitectura: Sphinx Build Pipeline with PlantUML

### 1.1 Flujo de Ejecución Normal (Sin PlantUML)

```
make html
  ↓
Sphinx reads RST files (source/*.rst)
  ↓
Parses directives (.. note::, .. code::, etc.)
  ↓
Processes content
  ↓
Generates HTML files → build/html/
```

### 1.2 Flujo de Ejecución con sphinxcontrib.plantuml

```
make html
  ↓
Sphinx reads RST files (source/*.rst)
  ↓
Encounters .. plantuml:: directive
  ↓
sphinxcontrib.plantuml plugin intercepts
  ↓
Extracts PlantUML code from RST block
  ↓
INVOKES: java -jar plantuml.jar [code] -output [dir]
  ↓
PlantUML processor:
  1. Reads PlantUML code
  2. Processes !include directives
  3. Loads external .puml files
  4. Applies skinparam + !define
  5. Renders diagram (PNG/SVG)
  ↓
sphinxcontrib.plantuml embeds <img> tag in HTML
  ↓
Sphinx continues building
  ↓
Generates HTML files with diagram images → build/html/
```

**Clave:** PlantUML JAR se ejecuta **FUERA** de Sphinx — es un proceso independiente.

---

## 2. Cómo sphinxcontrib.plantuml Maneja !include

### 2.1 Teoría: Lo que DEBERÍA Pasar

```rst
.. plantuml::

   !include source/_static/plantuml-styles.puml
   
   @startuml UC_AUTH_01
   actor Usuario
   @enduml
```

**Paso a paso:**

1. **Sphinx lee el bloque RST**
   ```
   !include source/_static/plantuml-styles.puml
   @startuml UC_AUTH_01
   actor Usuario
   @enduml
   ```

2. **sphinxcontrib.plantuml extrae código**
   ```
   CODIGO = """!include source/_static/plantuml-styles.puml
   @startuml UC_AUTH_01
   actor Usuario
   @enduml"""
   ```

3. **Invoca PlantUML JAR**
   ```bash
   java -jar plantuml.jar [CODIGO] -output build/
   ```

4. **PlantUML JAR procesa !include**
   - Encuentra: `!include source/_static/plantuml-styles.puml`
   - Busca archivo en: `source/_static/plantuml-styles.puml`
   - Carga contenido (colores, skinparam)
   - Aplica a diagrama
   - Renderiza con estilos

5. **Resultado**
   ```
   build/UC_AUTH_01.png (con colores corporativos)
   ```

### 2.2 Variable Crítica: Directorio de Trabajo

**Pregunta:** ¿Desde dónde ejecuta Sphinx el JAR de PlantUML?

**Opciones:**
- A) Desde directorio raíz del proyecto (`/home/user/IACT-docs/`)
- B) Desde `source/` directory
- C) Desde `build/` directory

**Implicación:** Path en `!include` depende de esto.

**Ejemplo con Opción A (raíz):**
```plantuml
!include source/_static/plantuml-styles.puml  ✅ Correcto
```

**Ejemplo con Opción B (source/):**
```plantuml
!include _static/plantuml-styles.puml  ✅ Correcto
```

**Ejemplo con Opción C (build/):**
```plantuml
!include ../source/_static/plantuml-styles.puml  ✅ Correcto
```

---

## 3. Configuración en Sphinx (conf.py)

### 3.1 Variables Clave

**De análisis anterior (Phase 3 DIAGNOSE):**

```python
# conf.py configuration for PlantUML

# Extension
extensions.append('sphinxcontrib.plantuml')

# Path to PlantUML JAR
plantuml = '/path/to/plantuml.jar'

# Command template (IMPORTANTE)
plantuml_cmd = 'java -jar {} -output {{outdir}} {{infile}}'

# Output format
plantuml_format = 'png'

# Working directory context
# ⚠️ NOT DOCUMENTED IN GUÍA — must validate
```

### 3.2 Critical Parameter: Working Directory

**sphinxcontrib.plantuml documentation (expected):**

```
Sphinx sets working directory to:
- Option 1: Project root (IACT-docs/)
- Option 2: Source directory (source/)
- Option 3: Build directory (build/)
```

**Para !include funcione correctamente, necesitamos CONFIRMAR cuál es.**

**Test command (to determine):**
```bash
cd /home/user/IACT-docs
make html
# Check output for directory information
# Or use strace to see PlantUML invocation
```

---

## 4. Handling of Paths in sphinxcontrib.plantuml

### 4.1 Relative Path Resolution

**Cuando Sphinx ejecuta `java -jar plantuml.jar`:**

```
Current working directory: [ROOT or SOURCE or BUILD]
PlantUML searches for:  !include <path>

If path is relative:
  Searched as: [CWD]/<path>

If path is absolute:
  Searched as: /<path>
```

### 4.2 Recomendación: Usar Path Relativo

**MEJOR: Relativo a raíz del proyecto**
```plantuml
!include source/_static/plantuml-styles.puml
```

**Alternativa: Relativo al UC**
```plantuml
!include ../../_static/plantuml-styles.puml  (from uc_auth/ subdirectory)
```

**EVITAR: Paths absolutos**
```plantuml
!include /home/user/IACT-docs/source/_static/plantuml-styles.puml  ❌
```

---

## 5. Integration Points: Sphinx ↔ PlantUML

### 5.1 How sphinxcontrib.plantuml Calls PlantUML

**Simplified pseudocode:**

```python
class PlantUMLDirective(Directive):
  def run(self):
    # 1. Extract PlantUML code from RST block
    code = self.block_text  # e.g., "!include ...\n@startuml..."
    
    # 2. Prepare temp file with code
    temp_file = f"/tmp/{uuid()}.puml"
    write(temp_file, code)
    
    # 3. Determine output path
    output_dir = self.env.get_outdir()  # Usually build/
    output_file = f"{output_dir}/diagram_{uuid()}.png"
    
    # 4. Execute PlantUML JAR
    cmd = f"java -jar {plantuml_jar} {temp_file} -output {output_dir}"
    subprocess.run(cmd, cwd=???)  # CWD CRITICAL
    
    # 5. Generate HTML img tag
    img_html = f'<img src="{output_file}" />'
    return [nodes.raw('html', img_html)]
```

**Punto crítico:** `cwd=???` — ¿Cuál es el working directory?

### 5.2 Testing Strategy for CWD

**Para determinar working directory:**

```bash
# Crear test file en source/_static/
echo 'WORKING_DIR_TEST' > source/_static/test.txt

# Crear UC con !include que referencia test
cat > source/test_uc.rst << 'EOF'
.. plantuml::

   !include source/_static/test.txt
   
   @startuml TEST
   actor A
   @enduml
EOF

# Build y ver qué pasa
make html 2>&1 | grep -i "test\|error\|working"
```

**Resultado esperado:**
- Si éxito: CWD es raíz (project root)
- Si error "file not found": CWD es fuera de project
- Si otra ruta funciona: CWD es diferente

---

## 6. Potential Issues & Mitigations

### 6.1 Issue 1: !include Path Not Found

**Error esperado:**
```
error: Cannot find file: source/_static/plantuml-styles.puml
at line X in diagram UC_AUTH_01
```

**Causas posibles:**
1. Path incorrecto
2. Working directory diferente del esperado
3. Archivo no existe

**Mitigación:**
```
1. Verificar que plantuml-styles.puml existe
2. Probar diferentes paths:
   - source/_static/plantuml-styles.puml
   - _static/plantuml-styles.puml
   - ../../source/_static/plantuml-styles.puml
3. Usar absolute path como fallback (documentar en guidelines)
```

### 6.2 Issue 2: !include Procesado pero Estilos No Aplicados

**Síntoma:**
```
- Build success
- Diagrama renderiza
- Pero colores son default (no corporativos)
```

**Causas posibles:**
1. `!include` se carga pero `skinparam` tiene sintaxis incorrecta
2. Orden de carga — `!include` viene después de `@startuml`
3. Inline colors override centralizados colors

**Mitigación:**
```
1. Validar syntax de plantuml-styles.puml
2. Asegurar !include ANTES de @startuml:
   ✅ !include ...
      @startuml ...
   
   ❌ @startuml ...
      !include ...
3. Restringir colores inline en guidelines
```

### 6.3 Issue 3: Performance (Build Time Increases)

**Efecto esperado:**
```
PlantUML JAR execution por UC:
- Sin estilos: ~100ms
- Con !include: ~120ms (+20%)

Para 100+ UC:
- Total time: +2-3 segundos (aceptable)
```

**Mitigación:**
```
1. Baseline build time antes de aplicar estilos
2. Monitorear en cada fase
3. Si >5 min total, considerar caching
```

---

## 7. sphinxcontrib.plantuml Configuration Checklist

### 7.1 Required in conf.py

```python
# ✅ MUST HAVE:
extensions.append('sphinxcontrib.plantuml')
plantuml = 'java -jar /path/to/plantuml.jar'

# ⚠️ SHOULD HAVE:
plantuml_format = 'png'  # or 'svg'
plantuml_output_format = 'png'  # Some versions use this

# ⚠️ OPTIONAL but recommended:
plantuml_server = None  # Use local, not server
plantuml_outdir = 'build/_plantuml'  # Cache location
```

### 7.2 NOT in conf.py, But in RST:

```rst
.. plantuml::
   :format: png
   :alt: UC_AUTH_01

   !include source/_static/plantuml-styles.puml
   @startuml UC_AUTH_01
   ...
   @enduml
```

---

## 8. End-to-End Workflow: From RST to HTML

### 8.1 Complete Flow with !include

```
1. User runs: make html
   ↓
2. Sphinx finds: source/requisitos/uc_auth/UC_AUTH_01_Login.rst
   ↓
3. Sphinx encounters: .. plantuml:: directive
   ↓
4. sphinxcontrib.plantuml plugin:
   a. Extracts block content
   b. Writes to temp file: /tmp/xxx.puml
   c. Prepares command: java -jar plantuml.jar /tmp/xxx.puml -output build/
   ↓
5. PlantUML JAR execution:
   a. Reads /tmp/xxx.puml (contains !include + @startuml...)
   b. Finds: !include source/_static/plantuml-styles.puml
   c. Loads: source/_static/plantuml-styles.puml
   d. Extracts: !define PRIMARY_COLOR #1976D2, skinparam actor {...}
   e. Applies to: @startuml UC_AUTH_01 ... @enduml
   f. Renders: PNG with corporate colors
   g. Writes to: build/UC_AUTH_01.png
   ↓
6. sphinxcontrib.plantuml post-processing:
   a. Finds: build/UC_AUTH_01.png
   b. Generates HTML: <img src="_images/UC_AUTH_01.png" />
   c. Embeds in HTML page
   ↓
7. Sphinx finishes building
   ↓
8. Output: build/html/requisitos/uc_auth/UC_AUTH_01_Login.html
         ↓ contains <img src="...UC_AUTH_01.png" /> with styles applied
```

---

## 9. Validation During Phase 1 Setup

### 9.1 Step-by-Step Validation

| Step | Action | Success Criterion |
|------|--------|---|
| 1 | Create `source/_static/plantuml-styles.puml` | File exists |
| 2 | Create test UC with `!include` | RST file created |
| 3 | Run `make html` | Build completes |
| 4 | Check output HTML | `<img>` tag present |
| 5 | Inspect PNG file | Colors match palette |
| 6 | Check build output | 0 new warnings |

### 9.2 Debugging Commands

```bash
# Check PlantUML JAR works
java -jar plantuml.jar -version

# Check Sphinx can find plugin
python -c "import sphinxcontrib.plantuml; print('OK')"

# Build with verbose output
make html SPHINXOPTS="-v"

# Check generated image
file build/_static/_images/UC_AUTH_01.png

# Extract color data from PNG
identify -verbose build/_static/_images/UC_AUTH_01.png | grep -i color
```

---

## 10. Fallback Strategy (If !include Fails)

### 10.1 Plan B: Server-based PlantUML

**If local JAR + !include doesn't work:**

```python
# conf.py fallback
plantuml_server = 'http://plantuml.example.com'  # Remote server
```

**Downside:** Requires internet, less control over styling.

### 10.2 Plan C: Script-based Injection

**If sphinxcontrib.plantuml doesn't support !include:**

```bash
#!/bin/bash
# pre-build.sh: Inject styles before Sphinx processes RST

for uc_file in source/requisitos/**/*.rst; do
  if grep -q ".. plantuml::" "$uc_file"; then
    # Inject !include at start of plantuml block
    sed -i '/.. plantuml::/a\   !include source/_static/plantuml-styles.puml' "$uc_file"
  fi
done

# Then run: make html
```

**Downside:** Modifies RST files (not clean).

---

## 11. Recomendaciones para Phase 1 Setup

### 11.1 Setup Checklist

- [ ] Install sphinxcontrib.plantuml: `pip install sphinxcontrib-plantuml`
- [ ] Verify: `pip show sphinxcontrib-plantuml`
- [ ] Download PlantUML 1.2025.0 JAR
- [ ] Verify: `java -jar plantuml.jar -version` → returns 1.2025.0
- [ ] Create: `source/_static/` directory
- [ ] Create: `source/_static/plantuml-styles.puml` with styles
- [ ] Create: Test UC file with `!include`
- [ ] Update: `source/conf.py` with PlantUML config
- [ ] Run: `make html`
- [ ] Check: Build output for warnings/errors
- [ ] Verify: Generated HTML + PNG with correct colors

### 11.2 Abort Criteria (Stop and Revise)

- [ ] sphinxcontrib.plantuml not found
- [ ] PlantUML JAR not executable
- [ ] `!include` causes build failure
- [ ] Styles not applied despite success
- [ ] Build time >5 minutes

---

**Análisis Completado:** 2026-04-23 22:45:00  
**Criticidad:** VITAL — Directamente determina viabilidad técnica  
**Confianza:** 0.80 (basada en práctica de Sphinx + PlantUML, no en guía)
