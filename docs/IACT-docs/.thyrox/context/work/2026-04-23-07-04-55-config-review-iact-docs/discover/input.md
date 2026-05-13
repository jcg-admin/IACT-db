# IACT-docs Project Configuration Analysis — Input for Calibration

**Date:** 2026-04-23
**Source:** Complete project configuration review
**Objective:** Epistemological calibration of project configuration state

## Project Overview

Name: IACT-docs — Documentación del Sistema IACT
Type: Technical documentation using Sphinx
Status: Active development with THYROX integration
Code: IACT-2025-001
Version: 1.0.0

## Sphinx Configuration (source/conf.py)

### Project Metadata
- project = 'IACT - Sistema de Dashboard Analytics'
- copyright = '2025, Equipo IACT'
- author = 'Equipo de Desarrollo IACT'
- version = '1.0'
- release = '1.0.0'

### Active Extensions (16 total)

Extensiones instaladas y activas:
1. sphinx.ext.intersphinx — Referências cruzadas
2. sphinx.ext.todo — Tareas pendientes
3. sphinx.ext.coverage — Cobertura de documentación
4. sphinx.ext.mathjax — Matemáticas
5. sphinx.ext.autodoc — Documentación desde docstrings
6. sphinx.ext.autosummary — Resúmenes automáticos
7. sphinx.ext.viewcode — Enlaces a código fuente
8. sphinx.ext.napoleon — Soporte Google/NumPy docstrings
9. sphinx_autodoc_typehints — Type hints en docs
10. sphinx_design — Componentes de diseño
11. sphinx_copybutton — Botones copiar código
12. sphinx_tabs.tabs — Pestañas tabuladas
13. sphinx_toolbox.collapse — Elementos colapsables
14. notfound.extension — Página 404 personalizada
15. myst_parser — Parser MyST
16. sphinx-prompt — Prompts de consola

Extensión adicional comentada:
- sphinxcontrib.spelling — Corrector ortográfico (habilitado)
- sphinxcontrib.openapi — OpenAPI docs (comentado)

### Theme Configuration

Theme: Furo
Colors (Corporativos IACT):
- color-brand-primary: #199cd7 (Azul IACT)
- color-brand-content: #199cd7
- color-sidebar-link-text--top-level: #4ab8ea (Azul claro)

Other options:
- sidebar_hide_name: True
- navigation_with_keys: True

### Build Configuration

- html_theme = 'furo'
- html_title = 'IACT Docs'
- language = 'es' (Spanish)
- primary_domain = 'py' (Python)
- html_copy_source = False
- html_show_sphinx = True

Static files:
- html_static_path = ['_static']
- html_css_files = ['css/custom.css']
- html_js_files = ['js/custom.js']
- html_favicon = '_static/img/favicon.ico'
- html_logo = '_static/img/logo.svg'

### Export Targets Configured

- LaTeX/PDF: texinfo_documents, latex_documents configured
- EPUB: epub_title, epub_author, epub_publisher configured
- Man pages: man_pages configured
- HTML Help: htmlhelp configured
- Qt Help: qthelp configured

## Dependencies (requirements.txt)

Total packages: 86

Major dependencies:
- Sphinx: 8.2.3 (core)
- Furo: 2025.9.25 (theme)
- Jinja2: 3.1.6 (templating)
- Pygments: 2.19.2 (syntax highlighting)
- Babel: 2.17.0 (i18n)
- Werkzeug, docutils, alabaster, imagesize, etc.

Extension-specific:
- sphinx-autodoc-typehints: 3.5.2
- sphinx-copybutton: 0.5.2
- sphinx-tabs: 3.4.5
- sphinx-toolbox: 4.1.0
- sphinx-design: 0.6.1
- myst-parser: 4.0.1

Quality tools:
- PyYAML: 6.0.3
- jsonschema: 4.25.1
- markdown-it-py: 3.0.0
- pymdown-extensions, etc.

## Project Structure

Directories:
- source/ — Documentation source (RST + Markdown)
- source/conf.py — Sphinx configuration
- source/_static/ — Static assets (CSS, JS, images)
- source/_templates/ — Custom templates
- build/ — Generated output (ignored)
- .venv/ — Python virtual environment
- .claude/ — Claude Code configuration (27 agents, THYROX skills)
- .thyrox/ — THYROX work packages and context

Documentation sections:
- arquitectura_tecnica/
- base_cognitiva/
- gestion/
- normativa/ (restricciones, procedimientos, gobernanza)
- requisitos/ (casos_uso, reglas_negocio, objetivos)

## Build System

Makefile provided with targets:
- make html — Build HTML
- make livehtml — Build with live reload
- make latexpdf — Build PDF
- make epub — Build EPUB
- make clean — Remove build output
- make linkcheck — Validate external links

Build directory: build/
Doctrees: build/doctrees/

## Git Configuration

- Remote: http://127.0.0.1:40231/git/jcg-admin/IACT-docs
- Branches: feature/project-setup (active), develop
- Recent commits include Sphinx config updates, documentation updates
- .gitignore configured (build/, .venv/, .DS_Store, Thumbs.db)
- .gitattributes present

## RBAC Model

Documented in normativa/:
- Version: 5.1.1
- 8 functional modules
- 44 atomic functions
- 10 function groups
- 3 SoD restrictions
- 5 data segments

## System Constraints (CNST)

8 documented constraints:
1. CNST_001: No email transmission
2. CNST_002: Single session per user, 15min timeout
3. CNST_003: IVR DB read-only
4. CNST_004: Alerts only via internal mailbox
5. CNST_005: Flat RBAC with SoD
6. CNST_006: Max 2-year report range
7. CNST_007: Export limits and throttling
8. CNST_008: Immutable audit logs, no PII

## Security Compliance

Standards applied:
- Django Security Best Practices
- DRF Secure Code Checklist
- OWASP Top 10
- NIST RBAC
- ISO 27001 (relevant controls)

Documented practices:
- JWT authentication
- RBAC + SoD
- Complete audit trail
- Rate limiting + throttling
- Input validation
- HTTPS in transit

## Issues/Gaps Identified

1. .readthedocs.yaml — Removed in recent commit (potential CI/CD impact)
2. diagnose_postgres.sh — Removed (purpose unclear)
3. Sphinx autodoc path commented out — Backend integration pending
4. OpenAPI extension commented — Not yet integrated
5. origin/HEAD reference — Missing (resolved manually)
6. No CI/CD pipeline documented in project

## Recent Changes (from commits)

- Merge of develop branch (April 23)
- Addition of .claude/agents/ (30+ agents)
- Addition of .claude/skills/thyrox/ (THYROX methodology)
- Update of authors.rst, licence.rst, prerequisites.rst, readme.rst
- Removal of .readthedocs.yaml and diagnose_postgres.sh

## Integration with THYROX Framework

New additions from develop merge:
- .claude/CLAUDE.md — Persistent context for Claude Code
- .claude/agents/ — 23+ native agents
- .thyrox/context/ — Work packages and state management
- .thyrox/registry/ — Agent and skill definitions
- .thyrox/guidelines/ — Tech-stack guidelines

Impact on project:
- Framework now manages project organization and workflows
- Work packages created for configuration audits
- Multi-agent orchestration available

## Observations

1. Configuration is operationally complete — Sphinx builds successfully
2. Dependencies are installed and requirements.txt updated
3. THYROX integration recent and incomplete in some areas (e.g., .readthedocs.yaml removal)
4. No automated CI/CD validation documented
5. Documentation comprehensive but scattered across multiple sections
6. Spanish language configuration consistent throughout
7. Theme customization applied correctly with corporate colors
