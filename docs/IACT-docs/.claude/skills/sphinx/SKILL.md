---
name: sphinx
description: Professional documentation engine for creating beautiful, multi-format documentation from reStructuredText and Markdown. Use this skill whenever the user mentions documentation, Sphinx, RST files, documentation builds, creating API docs, generating HTML from source files, multi-format publishing, or building technical documentation. Also use when building project documentation, needing to create PDF guides, organizing documentation structure, configuring documentation themes, or automating documentation workflows. This skill handles quick builds, troubleshooting broken builds, configuring extensions, and creating custom directives.
license: Apache 2.0
compatibility: Requires Sphinx >=5.0, Python >=3.11, make (for Makefile)
version: 1.0.0
---

# Sphinx Documentation Builder

Build professional documentation that generates HTML, PDF, ePub, and more from reStructuredText and Markdown sources.

## Quick Start (5 minutes)

### 1. Create new project
```bash
sphinx-quickstart docs/
# Answers: Project name, Author, Release, Language (en)
```

### 2. Create first document

**File: `docs/source/index.rst`**
```rst
Welcome
=======

.. toctree::
   :maxdepth: 2

   guide
   api
```

### 3. Add content
**File: `docs/source/guide.rst`**
```rst
Getting Started
===============

To install::

   pip install myproject

Then use it::

   from myproject import hello
   hello()
```

### 4. Build
```bash
cd docs
make html
# Open build/html/index.html
```

---

## Core Concepts

### Directives (Content Blocks)

Directives create structured blocks. **Syntax:**
```rst
.. directive-name:: argument
   :option: value
   
   Content
```

**10 essential directives:**

| Directive | Purpose | Example |
|-----------|---------|---------|
| `code-block` | Syntax-highlighted code | `.. code-block:: python` |
| `image` | Images | `.. image:: /path/pic.png` |
| `note` / `warning` | Admonitions | `.. note::` |
| `toctree` | Table of contents | `.. toctree:: :maxdepth: 2` |
| `literalinclude` | Include file | `.. literalinclude:: main.py` |
| `automodule` | Python API docs | `.. automodule:: mypackage` |
| `math` | LaTeX equations | `.. math:: x^2 + y^2 = r^2` |
| `figure` | Image with caption | `.. figure:: image.png` |
| `highlight` | Code highlighting | `.. highlight:: python` |
| `raw` | Raw HTML/LaTeX | `.. raw:: html` |

### Roles (Inline Markup)

Inline markup: `:role:`content`

**Common roles:**
- `:code:\`import x`` → inline code
- `:ref:\`label`` → cross-reference
- `:doc:\`/guide/intro`` → document link
- `:py:func:\`os.path.join`` → Python API ref
- `:kbd:\`Ctrl+C`` → keyboard input

### Domains (Language-Specific)

Document APIs for specific languages:

```rst
.. py:function:: parse_config(path: str) -> dict
   
   Parse configuration file.
   
   :param path: File path
   :return: Config dict
   :raises FileNotFoundError: If missing
```

**Supported:** Python, C, C++, JavaScript, Go, Rust, and 10+

### Extensions (Add Functionality)

Extensions enhance Sphinx. **Activate in `conf.py`:**
```python
extensions = [
    'sphinx.ext.autodoc',           # Auto-generate from docstrings
    'sphinx.ext.intersphinx',       # Link to other Sphinx projects
    'sphinx.ext.viewcode',          # Add source links
    'myst_parser',                  # Markdown support
    'sphinxcontrib.plantuml',       # PlantUML diagrams
]
```

### Builders (Output Formats)

Build different formats:
```bash
make html        # Static HTML
make latex       # PDF source
make pdf         # PDF (requires LaTeX)
make epub        # eBook
make linkcheck   # Validate links
```

---

## Common Tasks (with Quick Links)

### Build HTML Documentation
```bash
cd docs
make clean html
open build/html/index.html  # macOS
start build/html/index.html  # Windows
```

### Document Python Code (Autodoc)
```python
# conf.py
extensions = ['sphinx.ext.autodoc']

# In your RST file:
# .. automodule:: mypackage
#    :members:
#    :show-inheritance:
```

### Add Markdown Support
```bash
pip install myst-parser
```
```python
# conf.py
extensions = ['myst_parser']
source_suffix = {'.rst': 'restructuredtext', '.md': 'markdown'}
```

### Change Theme
```python
# conf.py
html_theme = 'pydata_sphinx_theme'
# Or: 'sphinx_rtd_theme', 'furo', 'alabaster'
```

### Generate PDF
```bash
pip install sphinx-latex  # System: apt install texlive-latex-full
make latex
make latexpdf
# PDF in build/latex/
```

### Validate Syntax
```bash
# Treat warnings as errors
make html SPHINXOPTS="-W --keep-going"

# Check links
make linkcheck
```

---

## Architecture

### Build Pipeline

```
Source Files (.rst, .md)
    ↓
Parse & Directives (Sphinx environment)
    ↓
Build Doctree (AST with Sphinx transforms)
    ↓
Resolve (Cross-refs, domains, indices)
    ↓
Transform (Extensions, event hooks)
    ↓
Generate (HTML, PDF, ePub, etc)
    ↓
Output Files
```

### Extension System

All extensions follow same pattern:

```python
def setup(app: Sphinx) -> ExtensionMetadata:
    # Register hooks
    app.connect('config-inited', on_config)
    app.connect('doctree-resolved', on_resolve)
    
    # Register components
    app.add_directive('custom', CustomDirective)
    app.add_role('custom', custom_role)
    
    return {
        'version': '1.0.0',
        'parallel_read_safe': True,
        'parallel_write_safe': True,
    }
```

**Key events:** `config-inited`, `env-before-read-docs`, `doctree-read`, `doctree-resolved`, `build-finished`

For detailed patterns, see `references/extension-development.md`

---

## Examples

### Example 1: Build with Theme
```bash
# Install theme
pip install sphinx-rtd-theme

# Edit conf.py
html_theme = 'sphinx_rtd_theme'
html_theme_options = {
    'logo_only': False,
    'display_version': True,
}

# Build
make clean html
```

### Example 2: Autodoc for Python Project
```rst
API Reference
=============

.. automodule:: mypackage.core
   :members:
   :undoc-members:
   :show-inheritance:
```

See `scripts/` directory for automation helpers.

---

## Troubleshooting

**"Unknown directive"** → Check `extensions` in conf.py  
**Broken cross-refs** → Use `make clean html` and check label names  
**Build too slow** → Run `make clean` or use parallel: `make html -j4`  
**PDF fails** → Install LaTeX: `apt install texlive-latex-full`  

For detailed solutions, see `references/troubleshooting.md`

---

## References

- **Getting started:** [Sphinx Tutorial](https://www.sphinx-doc.org/en/master/tutorial/)
- **Complete docs:** [Sphinx Documentation](https://www.sphinx-doc.org/)
- **Themes:** [Built-in themes](https://www.sphinx-doc.org/en/master/usage/theming.html)
- **Extensions:** [Extensions index](https://www.sphinx-doc.org/en/master/usage/extensions/index.html)

For advanced topics, bundled references, and scripts, see `references/` and `scripts/` directories.
