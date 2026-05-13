# Sphinx configuration file template

project = 'My Project'
author = 'Your Name'
release = '1.0.0'

# Extensions (alphabetical)
extensions = [
    'sphinx.ext.autodoc',              # Auto-generate from docstrings
    'sphinx.ext.intersphinx',          # Link to other Sphinx projects
    'sphinx.ext.todo',                 # TODO markup support
    'sphinx.ext.viewcode',             # Add source code links
    'myst_parser',                     # Markdown support
    'sphinxcontrib.plantuml',          # PlantUML diagrams
]

# Source files
source_suffix = {
    '.rst': 'restructuredtext',
    '.md': 'markdown',
}

# Theme and HTML output
html_theme = 'pydata_sphinx_theme'
html_theme_options = {
    'navbar_align': 'left',
    'show_nav_depth': 2,
    'logo_only': False,
}
html_static_path = ['_static']

# Autodoc configuration
autodoc_default_options = {
    'members': True,
    'inherited-members': True,
    'show-inheritance': True,
}

# Intersphinx - Link to other projects
intersphinx_mapping = {
    'python': ('https://docs.python.org/3', None),
    'sphinx': ('https://www.sphinx-doc.org/en/master/', None),
}

# Language
language = 'en'
source_encoding = 'utf-8'
