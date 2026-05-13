# -*- coding: utf-8 -*-
import sys
import os

# Path setup necesario para autodoc (documentar código Python)
# Permite importar módulos del proyecto para generar documentación automática
# sys.path.insert(0, os.path.abspath('../../backend'))  # Descomenta cuando tengas el backend

# -- Información General del Proyecto IACT --
project = 'IACT - Sistema de Dashboard Analytics'
copyright = '2025, Equipo IACT'
author = 'Equipo de Desarrollo IACT'

# Versión del Proyecto
version = '1.0'
release = '1.0.0'

# -- Extensiones --
extensions = [
    # Extensiones de trazabilidad y requerimientos
    'sphinx.ext.intersphinx',
    'sphinx.ext.todo',
    'sphinx.ext.autosectionlabel',

    # Extensiones para documentar código Python
    'sphinx.ext.autodoc',  # Documentación automática desde docstrings
    'sphinx.ext.autosummary',  # Resúmenes automáticos de módulos
    'sphinx.ext.viewcode',  # Enlaces al código fuente
    'sphinx.ext.napoleon',  # Soporte para docstrings Google/NumPy style

    # Extensiones de interactividad y diseño
    'sphinx_design',
    'sphinx_copybutton',
    'sphinx_tabs.tabs',

    # PlantUML para diagramas
    'sphinxcontrib.plantuml',

    # Extensiones recomendadas (adicionales)
    'sphinx_autodoc_typehints',  # Type hints support
    'sphinxcontrib.spelling',     # Spell checking
]

# -- Configuración de Autodoc --
# Generar automáticamente documentación de miembros
autodoc_default_options = {
    'members': True,  # Documentar todos los miembros
    'member-order': 'bysource',  # Orden según aparecen en el código
    'special-members': '__init__',  # Incluir __init__
    'undoc-members': True,  # Incluir miembros sin docstring
    'exclude-members': '__weakref__'
}

# Configuración de Autosummary
autosummary_generate = True  # Generar archivos stub automáticamente

# Configuración de Napoleon (docstrings estilo Google/NumPy)
napoleon_google_docstring = True
napoleon_numpy_docstring = True
napoleon_include_init_with_doc = True
napoleon_include_private_with_doc = False
napoleon_include_special_with_doc = True
napoleon_use_admonition_for_examples = True
napoleon_use_admonition_for_notes = True
napoleon_use_admonition_for_references = False
napoleon_use_ivar = False
napoleon_use_param = True
napoleon_use_rtype = True
napoleon_type_aliases = None

# Configuración de Type Hints
typehints_fully_qualified = False
always_document_param_types = True

# -- Configuración de Archivos --
templates_path = ['_templates']
source_suffix = '.rst'
master_doc = 'index'

# Excluye carpetas de build y entornos virtuales
exclude_patterns = [
    '_build',
    'Thumbs.db',
    '.DS_Store',
    'venv',
    '.git'
]

# -- Configuración de Lenguaje --
language = 'es'
html_search_language = 'es'

# Dominio primario (útil para documentación de APIs)
primary_domain = 'py'

# -- Estética y Resaltado --
pygments_style = 'sphinx'

# Comillas tipográficas inteligentes
smartquotes = True
smartquotes_action = 'De'  # (D)ashes y (e)llipses

# -- Configuración de Lexers --
# Ignorar warnings de lexers desconocidos (plantuml, mermaid, cql)
suppress_warnings = ['misc.highlighting_failure']

# -- Configuración de Salida HTML (Tema FURO) --
html_theme = 'furo'
html_title = 'IACT Docs'

html_static_path = ['_static']

# Archivos CSS y JS personalizados
html_css_files = [
    'css/custom.css',
]

html_js_files = [
    'js/custom.js'
]

# Opciones del tema FURO (Colores corporativos IACT)
html_theme_options = {
    'dark_css_variables': {
        'color-brand-primary': '#199cd7',
        'color-brand-content': '#199cd7',
        'color-sidebar-link-text--top-level': '#4ab8ea',
    },
    'sidebar_hide_name': True,
    'navigation_with_keys': True,  # Navegación con flechas del teclado
}

# Mostrar información de Sphinx
html_show_sphinx = True

# No copiar archivos fuente .rst al build
html_copy_source = False

# Logo y Favicon
html_favicon = '_static/img/favicon.ico'
html_logo = '_static/img/logo.svg'

# -- Configuración del Corrector Ortográfico --
spelling_word_list_filename = 'spelling_wordlist.txt'

# Excluir patrones de archivos del corrector
spelling_exclude_patterns = []

# -- Configuración del Botón de Copiado --
# Excluir prompts y salidas de consola
copybutton_exclude = '.linenos, .gp, .go'
copybutton_prompt_text = "$ "

# -- Configuración de Autosectionlabel --
# Permite referenciar secciones automáticamente con prefijos
autosectionlabel_prefix_document = True
autosectionlabel_maxdepth = 2

# -- Configuración de Salida LaTeX / PDF --
latex_elements = {}

latex_documents = [
    ('index', 'iact.tex', 'IACT - Documentación del Proyecto',
     'Equipo IACT', 'manual'),
]

# -- Configuración de Salida Man Pages --
man_pages = [
    ('index', 'iact', 'IACT - Documentación del Proyecto',
     ['Equipo IACT'], 1)
]

# -- Configuración de Salida Texinfo --
texinfo_documents = [
    ('index', 'iact', 'IACT - Documentación del Proyecto',
     'Equipo IACT', 'iact', 'Documentación centralizada del proyecto IACT.', 'Misceláneo'),
]

# -- Configuración de Salida EPUB --
epub_title = 'IACT - Documentación del Proyecto'
epub_author = 'Equipo IACT'
epub_publisher = 'Equipo IACT'
epub_copyright = '2025, Equipo IACT'
epub_exclude_files = ['search.html']

# -- Configuración de PlantUML --
# Resolución del binario:
#   1. Si PLANTUML_BIN está en env (CI/override), usar eso.
#   2. Si existe el wrapper bundled tools/bin/plantuml (descargado por
#      scripts/setup.sh), usarlo — preferido porque garantiza versión.
#   3. Fallback a 'plantuml' en PATH (paquete del sistema).
import os as _os
_repo_root = _os.path.dirname(_os.path.dirname(_os.path.abspath(__file__)))
_bundled_plantuml = _os.path.join(_repo_root, 'tools', 'bin', 'plantuml')
plantuml = _os.environ.get('PLANTUML_BIN') or (
    _bundled_plantuml if _os.path.isfile(_bundled_plantuml) else 'plantuml'
)
plantuml_output_format = 'png'
plantuml_latex_output_format = 'pdf'

# Usar ubicación estándar de sphinxcontrib.plantuml (_images/)
# El hook post-build reorganiza metadatos pero mantiene referencias HTML válidas
# NO personalizar plantuml_output_dir para evitar mismatch con referencias HTML

# Hook post-build para reorganizar archivos de imagen
def setup(app):
    """Configurar hooks post-build para organizar imagen de forma centralizada."""
    # Temporalmente deshabilitado para investigar PlantUML error
    # app.connect('build-finished', reorganize_static_assets)
    pass

def reorganize_static_assets(app, exception):
    """
    Post-build hook: reorganiza PlantUML diagrams por módulo/tipo basado en metadatos.
    Los archivos quedan en _images/ (ubicación estándar de sphinxcontrib.plantuml)
    y se organizan en subdirectorios según @IACT-DIAGRAM metadata.
    """
    import shutil
    from pathlib import Path

    if exception:
        return  # No reorganizar si la build falló

    build_dir = Path(app.outdir)
    images_dir = build_dir / '_images'

    if not images_dir.exists():
        return  # No hay imágenes para reorganizar

    # Reorganizar PlantUML diagrams en _images/ por módulo/tipo basado en metadatos
    reorganize_by_plantuml_metadata(images_dir, app.srcdir)


def reorganize_by_plantuml_metadata(diagrams_dir, source_dir):
    """
    Lee metadatos @IACT-DIAGRAM de archivos RST
    y reorganiza PNGs en diagrams/{modulo}/{tipo}/
    """
    from pathlib import Path
    import shutil

    if not diagrams_dir.exists():
        return

    # Paso 1: Extraer metadatos de todos los RST files
    metadata_map = extract_diagram_metadata(source_dir)

    # Paso 2: Crear estructura de directorios
    modulos = {
        "requisitos": ["use-case", "activity", "state"],
        "arquitectura_tecnica": ["component", "deployment", "sequence", "activity"],
        "base_cognitiva": ["use-case", "activity"],
        "normativa": ["diagram"],
        "gestion": ["diagram"],
        "plantuml-guide": ["use-case", "component", "sequence", "activity", "diagram"],
    }

    for modulo, tipos in modulos.items():
        for tipo in tipos:
            dest_dir = diagrams_dir / modulo / tipo
            dest_dir.mkdir(parents=True, exist_ok=True)

    # Paso 3: Reorganizar PNGs basándose en metadatos
    hash_dirs = sorted([d for d in diagrams_dir.iterdir() if d.is_dir() and len(d.name) == 2])

    # Distribuir diagrams con metadatos primero, luego defaults
    diagrams_with_metadata = []
    for rst_file, diagram_list in metadata_map.items():
        for modulo, tipo in diagram_list:
            diagrams_with_metadata.append((modulo, tipo))

    # Usar metadatos en round-robin
    metadata_index = 0

    for hash_dir in hash_dirs:
        pngs = list(hash_dir.glob("*.png"))
        if not pngs:
            continue

        # Usar metadatos en orden, si disponibles
        if diagrams_with_metadata and metadata_index < len(diagrams_with_metadata):
            modulo, tipo = diagrams_with_metadata[metadata_index]
            metadata_index += 1
        else:
            modulo, tipo = "plantuml-guide", "diagram"  # Default

        dest = diagrams_dir / modulo / tipo
        dest.mkdir(parents=True, exist_ok=True)

        for png in pngs:
            try:
                shutil.move(str(png), str(dest / png.name))
            except Exception:
                pass

    # Limpiar directorios vacíos
    for hash_dir in hash_dirs:
        try:
            hash_dir.rmdir()
        except Exception:
            pass


def extract_diagram_metadata(source_dir):
    """
    Extrae metadatos @IACT-DIAGRAM de bloques PlantUML en RST files.
    Retorna dict: {rst_file: [(modulo, tipo), ...]}
    """
    import re
    from pathlib import Path

    metadata_map = {}

    # Buscar todos los archivos RST (excluir archivos de documentación de estándares)
    exclude_files = {'METADATA-STANDARD.rst', 'GUIDELINES.rst', 'color-palette.rst'}

    for rst_file in Path(source_dir).rglob("*.rst"):
        if rst_file.name in exclude_files:
            continue
        try:
            with open(rst_file, 'r', encoding='utf-8') as f:
                lines = f.readlines()
        except Exception:
            continue

        # Buscar bloques .. uml::
        in_uml_block = False
        uml_content_lines = []
        diagrams = []

        for i, line in enumerate(lines):
            if '.. uml::' in line:
                in_uml_block = True
                uml_content_lines = []
                continue

            if in_uml_block:
                # Detectar fin del bloque (línea no indentada o siguiente directiva)
                if line.strip() and not line[0].isspace() and not line.startswith('#'):
                    in_uml_block = False
                    # Procesar bloque completado
                    block_text = ''.join(uml_content_lines)
                    modulo, tipo = extract_metadata_from_block(block_text)
                    if modulo and tipo:
                        diagrams.append((modulo, tipo))
                    uml_content_lines = []
                else:
                    uml_content_lines.append(line)

        # Procesar último bloque si existe
        if uml_content_lines:
            block_text = ''.join(uml_content_lines)
            modulo, tipo = extract_metadata_from_block(block_text)
            if modulo and tipo:
                diagrams.append((modulo, tipo))

        if diagrams:
            metadata_map[str(rst_file)] = diagrams

    return metadata_map


def extract_metadata_from_block(block_text):
    """
    Extrae module y type de un bloque PlantUML.
    Busca líneas con ' module: y ' type: después de @IACT-DIAGRAM
    """
    import re

    modulo = None
    tipo = None
    found_marker = False

    lines = block_text.split('\n')
    for i, line in enumerate(lines):
        # Buscar marcador @IACT-DIAGRAM
        if '@IACT-DIAGRAM' in line:
            found_marker = True
            continue

        if found_marker:
            # Buscar module en líneas siguientes (dentro de comentarios)
            if 'module:' in line and "'" in line:
                modulo_match = re.search(r'module:\s*([\w-]+)', line)
                if modulo_match:
                    modulo = modulo_match.group(1)

            # Buscar type en líneas siguientes
            if 'type:' in line and "'" in line:
                tipo_match = re.search(r'type:\s*([\w-]+)', line)
                if tipo_match:
                    tipo = tipo_match.group(1)

            # Parar si encontramos ambos o si salimos de comentarios
            if modulo and tipo:
                break
            if not line.strip().startswith("'") and line.strip():
                break

    return modulo, tipo