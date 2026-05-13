# ANÁLISIS COMPLETO: PROYECTO SPHINX IACT - RST PURO

**Versión:** 1.0.0  
**Fecha:** 2026-01-07  
**Decisión Arquitectónica:** Solo archivos .rst en el proyecto  
**Archivos .md:** Solo referencia externa, NO en repositorio

---

## RESUMEN EJECUTIVO

### Decisión Clave
- ✅ **Proyecto:** Solo archivos .rst
- ❌ **NO usar:** Archivos .md dentro del proyecto
- 📝 **Archivos .md:** Solo documentos de apoyo/referencia externos

### Implicaciones
1. Los 4 documentos grandes en Markdown deben **CONVERTIRSE a .rst**
2. MyST Parser configurado pero **NO se usará**
3. Toda la documentación será nativa Sphinx (.rst)
4. Mejor rendimiento de build (no procesamiento Markdown)

---

## 1. INVENTARIO COMPLETO DE ARCHIVOS

### 1.1 Archivos Raíz (Nivel Proyecto)

| Archivo | Ubicación Actual | Destino | Formato | Estado |
|---------|------------------|---------|---------|--------|
| readme.rst | `/raíz/` | `source/` | RST | ✅ Actualizado |
| prerequisites.rst | `/raíz/` | `source/` | RST | ✅ Actualizado |
| authors.rst | `/raíz/` | `source/` | RST | ✅ Actualizado |
| licence.rst | `/raíz/` | `source/` | RST | ✅ Actualizado |
| Makefile | `/raíz/` | `/raíz/` | Makefile | ✅ OK |
| requirements.txt | `/raíz/` | `/raíz/` | TXT | ✅ OK |
| .gitignore | `/raíz/` | `/raíz/` | TXT | ✅ OK |
| .readthedocs.yaml | `/raíz/` | N/A | YAML | ❌ ELIMINAR |

### 1.2 Archivos de Configuración (source/)

| Archivo | Formato | Estado | Acción |
|---------|---------|--------|--------|
| conf.py | Python | ✅ OK | Actualizar (quitar MyST si no se usa) |
| index.rst | RST | ✅ OK | Actualizar con sección "Información General" |

### 1.3 Documentos Grandes a Convertir (Markdown → RST)

| Documento Origen | Tamaño | Destino Final | Archivo RST |
|------------------|--------|---------------|-------------|
| MODELO_DOCUMENTAL_v2_2_0 (2 partes) | ~800 líneas | `normativa/estandares/` | `modelo_documental_v2_2_0.rst` |
| ANEXO_A_ARBOL_COMPLETO (2 partes) | ~500 líneas | `normativa/estandares/` | `anexo_a_arbol_v2_2_0.rst` |
| RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT | ~1130 líneas | `normativa/restricciones/` | `restricciones_sistema_v1_0_0.rst` |
| MODELO_RBAC_IACT_v5_1_1 | ~1650 líneas | `base_cognitiva/` o `arquitectura_tecnica/` | `modelo_rbac_v5_1_1.rst` |

**Total a convertir:** ~4080 líneas de Markdown → RST

### 1.4 Diagrama de Contexto (PlantUML)

| Archivo Origen | Formato | Destino | Acción |
|----------------|---------|---------|--------|
| sistema_iact_contexto.puml | PlantUML | `arquitectura_tecnica/diagramas/` | Copiar directamente |

---

## 2. ESTRUCTURA FINAL DEL PROYECTO (SOLO RST)

```
documentacion/
├── Makefile
├── requirements.txt
├── .gitignore
│
├── source/
│   ├── conf.py                              # Configuración Sphinx
│   ├── index.rst                            # Índice principal
│   │
│   ├── readme.rst                           # ← NUEVO (copiado)
│   ├── prerequisites.rst                    # ← NUEVO (copiado)
│   ├── authors.rst                          # ← NUEVO (copiado)
│   ├── licence.rst                          # ← NUEVO (copiado)
│   │
│   ├── _static/
│   │   ├── css/
│   │   ├── js/
│   │   └── img/
│   │       ├── logo.svg
│   │       └── favicon.ico
│   │
│   ├── _templates/
│   │   ├── sidebar/
│   │   ├── base.html
│   │   └── page.html
│   │
│   ├── base_cognitiva/
│   │   ├── index.rst
│   │   ├── modelo_rbac_v5_1_1.rst           # ← NUEVO (convertido de MD)
│   │   ├── _metadata/
│   │   ├── _fundamentos_conceptuales/
│   │   ├── _ontologia_sbvr/
│   │   ├── _taxonomias_y_metamodelos/
│   │   ├── glosario_babok_pmbok_iso.md      # ← CONVERTIR a .rst
│   │   ├── glossary.md                      # ← CONVERTIR a .rst
│   │   └── IACT_Glossary_v1_0_0.rst
│   │
│   ├── normativa/
│   │   ├── index.rst
│   │   ├── estandares/
│   │   │   ├── index.rst
│   │   │   ├── modelo_documental_v2_2_0.rst # ← NUEVO (convertido)
│   │   │   ├── anexo_a_arbol_v2_2_0.rst     # ← NUEVO (convertido)
│   │   │   └── plantillas/                   # Pendiente según modelo v2.2.0
│   │   ├── gobernanza/
│   │   ├── procedimientos/
│   │   └── restricciones/
│   │       ├── index.rst
│   │       └── restricciones_sistema_v1_0_0.rst  # ← NUEVO (convertido)
│   │
│   ├── requisitos/
│   │   ├── index.rst
│   │   ├── objetivos/
│   │   ├── reglas_negocio/
│   │   ├── casos_uso/
│   │   ├── requisitos_funcionales/
│   │   ├── requisitos_no_funcionales/
│   │   └── rtm/
│   │
│   ├── arquitectura_tecnica/
│   │   ├── index.rst
│   │   ├── arquitectura/
│   │   ├── despliegue/
│   │   ├── diseño_detallado/
│   │   └── diagramas/
│   │       └── sistema_iact_contexto.puml   # ← NUEVO (copiado)
│   │
│   └── gestion/
│       ├── index.rst
│       ├── evidencia/
│       ├── manuales_usuarios/
│       └── pm/
│
├── build/                                    # Generado automáticamente
│   └── html/
│
└── documentos_referencia/                    # ← NUEVO (fuera de source/)
    ├── ANALISIS_ESTRUCTURA_SPHINX_IACT.md
    ├── PLAN_IMPLEMENTACION_SPHINX_IACT.md
    ├── ANALISIS_REAL_ESTRUCTURA_EXISTENTE.md
    ├── ACCIONES_INMEDIATAS.md
    └── PLAN_ACCION_EXACTO_IACT.md
```

### Notas sobre la Estructura

1. **Archivos .md en source/base_cognitiva/:**
   - `glosario_babok_pmbok_iso.md` → Convertir a .rst
   - `glossary.md` → Convertir a .rst

2. **Carpeta documentos_referencia/:**
   - Nueva carpeta FUERA de source/
   - Contiene todos los documentos .md de apoyo
   - NO se procesa por Sphinx
   - Solo para referencia del equipo

3. **Archivos .md en arquitectura_tecnica/arquitectura/:**
   - Ver log: varios archivos .md
   - Decisión: ¿Convertir todos a .rst o mantener?

---

## 3. ARCHIVOS MARKDOWN DETECTADOS EN EL PROYECTO

### 3.1 Del Log de Build (autosummary)

Archivos .md actualmente en el proyecto:

```
arquitectura_tecnica/arquitectura/
├── Diagramas de Referencia - README.md
├── OBSERVABILITY_LAYERS.md
├── README.md
├── STORAGE_ARCHITECTURE.md
├── TASK-010-logging_estructurado_json.md
├── TASK-011-data_centralization_layer.md
├── TASK-029-data_quality_framework.md
├── lineamientos_codigo.md
└── patrones/
    └── DESIGN_PATTERNS_GUIDE.md

base_cognitiva/
├── glosario_babok_pmbok_iso.md
└── glossary.md

gestion/
└── plantilla_adr.md

requisitos/requisitos_no_funcionales/
├── RNF-PROC-001_PROCESO_SDLC.md
└── RNF-PROC-002_METRICAS_PROCESO.md
```

**Total detectado:** ~14 archivos .md

### 3.2 Decisión sobre Archivos .md Existentes

| Opción | Descripción | Pros | Contras |
|--------|-------------|------|---------|
| **A) Convertir TODO a .rst** | Convertir todos los .md a .rst | Consistencia 100%, mejor rendimiento | Trabajo manual, ~14 archivos |
| **B) Mantener algunos .md** | Solo arquitectura/READMEs en .md, resto .rst | Menos trabajo, READMEs típicamente .md | Inconsistencia, necesita MyST |
| **C) Híbrido controlado** | Solo READMEs técnicos en .md, documentación formal en .rst | Balance | Requiere criterio claro |

**Recomendación:** **Opción A** (Convertir TODO a .rst)

**Razón:**
- Proyecto formal de documentación
- Mejor rendimiento sin MyST
- Consistencia total
- No depender de extensión externa

---

## 4. PROCESO DE CONVERSIÓN MARKDOWN → RST

### 4.1 Herramientas de Conversión

#### Opción 1: Pandoc (Recomendado)

```bash
# Instalar pandoc
# Ubuntu/Debian
sudo apt-get install pandoc

# macOS
brew install pandoc

# Windows
# Descargar desde https://pandoc.org/installing.html

# Verificar instalación
pandoc --version
```

**Comando básico:**
```bash
pandoc -f markdown -t rst input.md -o output.rst
```

#### Opción 2: Script Python

```python
#!/usr/bin/env python3
import pypandoc

def convert_md_to_rst(md_file, rst_file):
    """Convierte Markdown a RST usando pypandoc"""
    output = pypandoc.convert_file(md_file, 'rst', outputfile=rst_file)
    print(f"Convertido: {md_file} → {rst_file}")

# Uso
convert_md_to_rst('documento.md', 'documento.rst')
```

### 4.2 Post-Procesamiento Necesario

Después de conversión automática, revisar:

1. **Encabezados:** Ajustar niveles
   ```rst
   # Nivel 1 (MD) → 
   ================
   Nivel 1 (RST)
   ================
   
   ## Nivel 2 (MD) →
   Nivel 2 (RST)
   ----------------
   ```

2. **Tablas:** Verificar formato
   ```rst
   +--------+--------+
   | Col 1  | Col 2  |
   +========+========+
   | Dato   | Dato   |
   +--------+--------+
   ```

3. **Bloques de código:** Verificar syntax highlighting
   ```rst
   .. code-block:: python
      
      def funcion():
          pass
   ```

4. **Enlaces:** Ajustar referencias
   ```rst
   `Texto del enlace <URL>`_
   :doc:`/ruta/al/documento`
   :ref:`etiqueta`
   ```

5. **Imágenes:** Ajustar rutas
   ```rst
   .. image:: _static/img/imagen.png
      :alt: Texto alternativo
      :width: 400px
   ```

### 4.3 Script de Conversión Masiva

```bash
#!/bin/bash
# convert_all_md_to_rst.sh

# Función para convertir un archivo
convert_file() {
    local md_file="$1"
    local rst_file="${md_file%.md}.rst"
    
    echo "Convirtiendo: $md_file → $rst_file"
    pandoc -f markdown -t rst "$md_file" -o "$rst_file"
    
    # Opcional: eliminar .md después de conversión exitosa
    # rm "$md_file"
}

# Encontrar todos los .md en source/ y convertir
find source/ -name "*.md" -type f | while read md_file; do
    convert_file "$md_file"
done

echo "✅ Conversión completada"
```

**Uso:**
```bash
chmod +x convert_all_md_to_rst.sh
./convert_all_md_to_rst.sh
```

---

## 5. CONVERSIÓN DE DOCUMENTOS GRANDES

### 5.1 Proceso Detallado

#### Documento 1: MODELO_DOCUMENTAL_v2_2_0

**Paso 1: Unir las 2 partes**
```bash
cat MODELO_DOCUMENTAL_v2_2_0_PARTE1.md \
    MODELO_DOCUMENTAL_v2_2_0_PARTE2.md \
    > /tmp/modelo_documental_completo.md
```

**Paso 2: Convertir a RST**
```bash
pandoc -f markdown -t rst \
    --standalone \
    --toc \
    /tmp/modelo_documental_completo.md \
    -o /tmp/modelo_documental_v2_2_0.rst
```

**Paso 3: Post-procesar**
```bash
# Revisar encabezados manualmente
nano /tmp/modelo_documental_v2_2_0.rst

# Verificar que se vea bien
cat /tmp/modelo_documental_v2_2_0.rst | head -50
```

**Paso 4: Copiar a destino**
```bash
cp /tmp/modelo_documental_v2_2_0.rst \
   source/normativa/estandares/
```

#### Documento 2: ANEXO_A_ARBOL_COMPLETO

```bash
# Unir partes
cat ANEXO_A_ARBOL_COMPLETO_PARTE1.md \
    ANEXO_A_ARBOL_COMPLETO_PARTE2.md \
    > /tmp/anexo_a_completo.md

# Convertir
pandoc -f markdown -t rst \
    --standalone \
    /tmp/anexo_a_completo.md \
    -o /tmp/anexo_a_arbol_v2_2_0.rst

# Post-procesar y copiar
cp /tmp/anexo_a_arbol_v2_2_0.rst \
   source/normativa/estandares/
```

#### Documento 3: RESTRICCIONES_COMPLETAS

```bash
# Convertir (archivo grande, usar staging)
pandoc -f markdown -t rst \
    --standalone \
    --toc \
    RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md \
    -o /tmp/restricciones_sistema_v1_0_0.rst

# Verificar tamaño
wc -l /tmp/restricciones_sistema_v1_0_0.rst

# Copiar
cp /tmp/restricciones_sistema_v1_0_0.rst \
   source/normativa/restricciones/
```

#### Documento 4: MODELO_RBAC

```bash
# Convertir
pandoc -f markdown -t rst \
    --standalone \
    --toc \
    MODELO_RBAC_IACT_v5_1_1.md \
    -o /tmp/modelo_rbac_v5_1_1.rst

# Copiar
cp /tmp/modelo_rbac_v5_1_1.rst \
   source/base_cognitiva/
```

### 5.2 Checklist de Conversión

Para cada documento convertido:

- [ ] Unir partes (si aplica)
- [ ] Convertir con pandoc
- [ ] Revisar encabezados (niveles correctos)
- [ ] Verificar tablas (formato RST)
- [ ] Verificar bloques de código (syntax highlighting)
- [ ] Verificar enlaces (internos y externos)
- [ ] Verificar listas (viñetas y numeradas)
- [ ] Ajustar imágenes/diagramas (si hay)
- [ ] Build de prueba (`make html`)
- [ ] Verificar en navegador
- [ ] Copiar a ubicación final

---

## 6. ACTUALIZACIÓN DE conf.py

### 6.1 Cambios Recomendados

**Quitar MyST Parser (ya no se usa):**

```python
# ANTES
extensions = [
    # ...
    'myst_parser',  # ← ELIMINAR
    # ...
]

# DESPUÉS
extensions = [
    'sphinx.ext.intersphinx',
    'sphinx.ext.todo',
    'sphinx.ext.coverage',
    'sphinx.ext.mathjax',
    'sphinx.ext.autosectionlabel',
    'sphinx.ext.ifconfig',
    'sphinx.ext.autodoc',
    'sphinx.ext.autosummary',
    'sphinx.ext.viewcode',
    'sphinx.ext.napoleon',
    'sphinx_autodoc_typehints',
    'sphinx_design',
    'sphinx_copybutton',
    'sphinx_tabs.tabs',
    'sphinx_toolbox.collapse',
    'notfound.extension',
    # 'myst_parser',  # ← COMENTADO o ELIMINADO
    'sphinx-prompt',
    'sphinx_jinja',
    'sphinxcontrib.spelling',
]

# ELIMINAR configuración de MyST
# myst_enable_extensions = [...]  # ← ELIMINAR esta sección completa
```

**Agregar extensión para PlantUML (si usas diagramas):**

```python
extensions = [
    # ...
    'sphinxcontrib.plantuml',  # Para diagramas PlantUML
]

# Configuración PlantUML
plantuml = 'java -jar /path/to/plantuml.jar'
# O si está en PATH:
# plantuml = 'plantuml'
```

### 6.2 Configuración Optimizada Final

```python
# source_suffix: Solo RST
source_suffix = {
    '.rst': 'restructuredtext',
}

# O simplemente:
source_suffix = '.rst'
```

---

## 7. ACTUALIZACIÓN DE ÍNDICES

### 7.1 source/index.rst

**Agregar sección "Información General":**

```rst
.. toctree::
   :maxdepth: 1
   :caption: Información General
   
   readme
   prerequisites
   authors
   licence
```

### 7.2 source/normativa/estandares/index.rst

**Agregar documentos convertidos:**

```rst
.. toctree::
   :maxdepth: 2
   :caption: Estándares del Proyecto
   
   modelo_documental_v2_2_0
   anexo_a_arbol_v2_2_0
   
.. toctree::
   :maxdepth: 1
   :caption: Plantillas (TPL)
   
   plantillas/index
```

### 7.3 source/normativa/restricciones/index.rst

```rst
.. toctree::
   :maxdepth: 2
   
   restricciones_sistema_v1_0_0
```

### 7.4 source/base_cognitiva/index.rst

```rst
.. toctree::
   :maxdepth: 2
   :caption: Modelos y Fundamentos
   
   modelo_rbac_v5_1_1
   IACT_Glossary_v1_0_0
```

---

## 8. PLAN DE MIGRACIÓN COMPLETO

### FASE 1: Preparación (30 min)

```bash
# 1.1 Crear carpeta para documentos de referencia
mkdir -p documentos_referencia/

# 1.2 Mover documentos .md de apoyo (fuera de source/)
mv ANALISIS_*.md documentos_referencia/
mv PLAN_*.md documentos_referencia/
mv ACCIONES_*.md documentos_referencia/

# 1.3 Instalar pandoc
sudo apt-get install pandoc  # o brew install pandoc

# 1.4 Verificar instalación
pandoc --version
```

### FASE 2: Conversión de Documentos Grandes (1-2 horas)

```bash
# 2.1 Crear directorio temporal de trabajo
mkdir -p /tmp/conversion_rst/

# 2.2 Unir y convertir MODELO_DOCUMENTAL
cat MODELO_DOCUMENTAL_v2_2_0_PARTE1.md \
    MODELO_DOCUMENTAL_v2_2_0_PARTE2.md \
    > /tmp/conversion_rst/modelo_documental.md

pandoc -f markdown -t rst --standalone --toc \
    /tmp/conversion_rst/modelo_documental.md \
    -o /tmp/conversion_rst/modelo_documental_v2_2_0.rst

# 2.3 Unir y convertir ANEXO_A
cat ANEXO_A_ARBOL_COMPLETO_PARTE1.md \
    ANEXO_A_ARBOL_COMPLETO_PARTE2.md \
    > /tmp/conversion_rst/anexo_a.md

pandoc -f markdown -t rst --standalone \
    /tmp/conversion_rst/anexo_a.md \
    -o /tmp/conversion_rst/anexo_a_arbol_v2_2_0.rst

# 2.4 Convertir RESTRICCIONES
pandoc -f markdown -t rst --standalone --toc \
    RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md \
    -o /tmp/conversion_rst/restricciones_sistema_v1_0_0.rst

# 2.5 Convertir MODELO_RBAC
pandoc -f markdown -t rst --standalone --toc \
    MODELO_RBAC_IACT_v5_1_1.md \
    -o /tmp/conversion_rst/modelo_rbac_v5_1_1.rst
```

### FASE 3: Revisión y Ajuste Manual (2-3 horas)

```bash
# Para cada archivo convertido:
nano /tmp/conversion_rst/modelo_documental_v2_2_0.rst

# Verificar:
# - Encabezados correctos
# - Tablas bien formateadas
# - Bloques de código con syntax highlighting
# - Enlaces funcionan
# - No hay caracteres extraños
```

### FASE 4: Conversión de Archivos .md Existentes (1-2 horas)

```bash
# 4.1 Convertir archivos en arquitectura_tecnica/
cd source/arquitectura_tecnica/arquitectura/

for file in *.md; do
    pandoc -f markdown -t rst "$file" -o "${file%.md}.rst"
done

# 4.2 Convertir archivos en base_cognitiva/
cd ../../base_cognitiva/

pandoc -f markdown -t rst glosario_babok_pmbok_iso.md \
    -o glosario_babok_pmbok_iso.rst

pandoc -f markdown -t rst glossary.md -o glossary.rst

# 4.3 Convertir archivos en gestion/
cd ../gestion/
pandoc -f markdown -t rst plantilla_adr.md -o plantilla_adr.rst

# 4.4 Convertir archivos en requisitos/requisitos_no_funcionales/
cd ../requisitos/requisitos_no_funcionales/

for file in *.md; do
    pandoc -f markdown -t rst "$file" -o "${file%.md}.rst"
done
```

### FASE 5: Integración y Actualización de Índices (1 hora)

```bash
# 5.1 Copiar archivos raíz actualizados
cd /d/Estadia_IACT/proyecto/documentacion/
cp readme.rst source/
cp prerequisites.rst source/
cp authors.rst source/
cp licence.rst source/

# 5.2 Copiar documentos grandes convertidos
cp /tmp/conversion_rst/modelo_documental_v2_2_0.rst \
   source/normativa/estandares/

cp /tmp/conversion_rst/anexo_a_arbol_v2_2_0.rst \
   source/normativa/estandares/

cp /tmp/conversion_rst/restricciones_sistema_v1_0_0.rst \
   source/normativa/restricciones/

cp /tmp/conversion_rst/modelo_rbac_v5_1_1.rst \
   source/base_cognitiva/

# 5.3 Actualizar source/index.rst
# (usar el archivo index_actualizado.rst proporcionado)
cp index_actualizado.rst source/index.rst

# 5.4 Actualizar índices de subdominios
# Editar manualmente cada index.rst para incluir los nuevos archivos
```

### FASE 6: Actualizar conf.py (15 min)

```bash
# Editar conf.py
nano source/conf.py

# Cambios:
# 1. Comentar o eliminar 'myst_parser' de extensions
# 2. Eliminar configuración myst_enable_extensions
# 3. Cambiar source_suffix a solo '.rst'
# 4. Guardar y cerrar
```

### FASE 7: Limpieza de Archivos .md (30 min)

```bash
# 7.1 Eliminar archivos .md del source/ (después de verificar conversión)
find source/ -name "*.md" -type f

# 7.2 Revisar lista y confirmar
# Si todo está convertido y verificado:
find source/ -name "*.md" -type f -delete

# 7.3 Actualizar .gitignore
echo "*.md" >> .gitignore  # Prevenir nuevos .md en el proyecto
echo "documentos_referencia/" >> .gitignore  # Excluir carpeta de referencia
```

### FASE 8: Build y Verificación (30 min)

```bash
# 8.1 Limpiar build anterior
make clean

# 8.2 Build completo
make html

# 8.3 Verificar warnings
make html 2>&1 | tee build_log.txt

# 8.4 Revisar errores específicos
grep -E "ERROR|WARNING" build_log.txt

# 8.5 Iniciar servidor
make livehtml

# 8.6 Verificar en navegador
# Abrir: http://127.0.0.1:8000
# Verificar:
# - Navegación funciona
# - Todos los documentos aparecen
# - Enlaces internos funcionan
# - Tablas se ven bien
# - Bloques de código tienen highlighting
```

---

## 9. CHECKLIST COMPLETO DE VERIFICACIÓN

### Pre-Conversión
- [ ] Pandoc instalado y funcional
- [ ] Backup del proyecto completo
- [ ] Carpeta documentos_referencia/ creada
- [ ] Documentos .md de apoyo movidos fuera de source/

### Conversión
- [ ] 4 documentos grandes convertidos
- [ ] ~14 archivos .md del proyecto convertidos
- [ ] Todos los archivos .rst revisados manualmente
- [ ] Encabezados ajustados
- [ ] Tablas verificadas
- [ ] Bloques de código con highlighting
- [ ] Enlaces funcionan

### Integración
- [ ] Archivos raíz copiados a source/
- [ ] Documentos grandes en ubicaciones correctas
- [ ] source/index.rst actualizado
- [ ] Índices de subdominios actualizados
- [ ] conf.py actualizado (sin MyST)
- [ ] .gitignore actualizado

### Limpieza
- [ ] Archivos .md eliminados de source/
- [ ] .readthedocs.yaml eliminado
- [ ] Archivos temporales eliminados

### Verificación
- [ ] `make clean` ejecutado
- [ ] `make html` sin errores
- [ ] Warnings reducidos a mínimo
- [ ] Navegación funciona
- [ ] Enlaces internos funcionan
- [ ] Búsqueda funciona
- [ ] Todos los documentos accesibles

---

## 10. ESTRUCTURA FINAL (SOLO RST)

```
documentacion/
├── Makefile
├── requirements.txt
├── .gitignore                       # Actualizado (excluye *.md)
│
├── source/                          # TODO EN .rst
│   ├── conf.py                      # Sin MyST Parser
│   ├── index.rst                    # Con "Información General"
│   ├── readme.rst
│   ├── prerequisites.rst
│   ├── authors.rst
│   ├── licence.rst
│   │
│   ├── _static/
│   ├── _templates/
│   │
│   ├── base_cognitiva/              # Todo .rst
│   │   ├── index.rst
│   │   ├── modelo_rbac_v5_1_1.rst
│   │   ├── glosario_babok_pmbok_iso.rst  (convertido)
│   │   ├── glossary.rst              (convertido)
│   │   └── IACT_Glossary_v1_0_0.rst
│   │
│   ├── normativa/                   # Todo .rst
│   │   ├── estandares/
│   │   │   ├── modelo_documental_v2_2_0.rst  (convertido)
│   │   │   └── anexo_a_arbol_v2_2_0.rst      (convertido)
│   │   ├── restricciones/
│   │   │   └── restricciones_sistema_v1_0_0.rst  (convertido)
│   │   └── ...
│   │
│   ├── requisitos/                  # Todo .rst
│   ├── arquitectura_tecnica/        # Todo .rst (convertidos)
│   └── gestion/                     # Todo .rst (convertidos)
│
├── build/
│   └── html/
│
└── documentos_referencia/           # Fuera de source/, .gitignore
    ├── ANALISIS_ESTRUCTURA_SPHINX_IACT.md
    ├── PLAN_IMPLEMENTACION_SPHINX_IACT.md
    └── PLAN_ACCION_EXACTO_IACT.md
```

---

## 11. MÉTRICAS DEL PROYECTO

| Métrica | Cantidad |
|---------|----------|
| **Archivos .rst en proyecto** | ~300+ |
| **Archivos .md a convertir** | ~18 |
| **Documentos grandes (líneas)** | ~4080 |
| **Tiempo estimado conversión** | 6-8 horas |
| **Tiempo estimado integración** | 3-4 horas |
| **Tiempo total estimado** | 9-12 horas |

---

## 12. BENEFICIOS DE RST PURO

### Ventajas Técnicas
1. ✅ **Rendimiento:** Build más rápido (no procesamiento Markdown)
2. ✅ **Consistencia:** Un solo formato en todo el proyecto
3. ✅ **Nativo Sphinx:** Mejor integración con todas las features
4. ✅ **Mantenibilidad:** Un solo formato para aprender y mantener

### Ventajas Operativas
1. ✅ **Sin dependencias extras:** No necesita MyST Parser
2. ✅ **Debugging más fácil:** Errores más claros
3. ✅ **Búsqueda más rápida:** Índice de búsqueda optimizado
4. ✅ **Portabilidad:** Compatible con cualquier Sphinx

---

## 13. RIESGOS Y MITIGACIONES

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| Errores en conversión | Media | Alto | Revisar manualmente cada archivo |
| Pérdida de formato | Media | Medio | Post-procesamiento cuidadoso |
| Enlaces rotos | Alta | Alto | Verificar con linkcheck después |
| Tiempo excedido | Media | Medio | Priorizar documentos críticos |
| Caracteres especiales | Media | Bajo | Revisar encoding UTF-8 |

---

## 14. SIGUIENTES PASOS INMEDIATOS

### Prioridad ALTA (Hacer YA)
1. Instalar pandoc
2. Crear carpeta documentos_referencia/
3. Mover documentos .md de apoyo
4. Convertir 4 documentos grandes
5. Actualizar source/index.rst

### Prioridad MEDIA (Esta semana)
1. Convertir ~14 archivos .md del proyecto
2. Actualizar conf.py (quitar MyST)
3. Actualizar índices de subdominios
4. Build y verificación completa

### Prioridad BAJA (Próxima semana)
1. Limpieza de archivos .md
2. Actualizar .gitignore
3. Documentar proceso de conversión
4. Capacitar al equipo en RST

---

**FIN DEL ANÁLISIS COMPLETO**

**Versión:** 1.0.0  
**Fecha:** 2026-01-07  
**Decisión:** Solo RST en proyecto, sin Markdown  
**Próximo Documento:** Script de conversión automatizada

