# Makefile para la documentación generada con Sphinx + uv
#
# Este proyecto usa 'uv' para gestión de dependencias (rápido, moderno).
# Flujo recomendado antes de ejecutar 'make':
#
#   uv sync                        # Instala dependencias del pyproject.toml
#   source .venv/bin/activate      # Activa el entorno virtual
#   make html                      # Genera documentación
#
# ========================================================================================
# FLUJOS RECOMENDADOS (por situación)
#
#   Edición continua (edit + preview):
#     make livehtml                # sphinx-autobuild en http://127.0.0.1:8000
#                                  # Watch + incremental + browser reload
#
#   Build incremental (uso diario):
#     make html                    # Solo procesa archivos cambiados (~9s)
#
#   Reset rápido (HTML+doctrees, preserva cache PlantUML):
#     make clean-fast && make html # ~30-90s. Usar si hay duda con cache HTML.
#
#   Reset total (incluye cache PlantUML, lento):
#     make clean && make html      # ~6 min. Solo si cambió conf.py o cache corrupto.
#
#   Pre-merge / CI gate (estricto, detecta cross-refs rotas):
#     SPHINX_NITPICKY=1 make html
#
#   Build serial (debug):
#     SPHINXOPTS="" make html      # Override del default `-j auto`
#
# Decisiones documentadas en WP:
#   .thyrox/context/work/2026-04-29-14-28-18-build-performance/
#
# ========================================================================================
# INSTALACIÓN INICIAL:
#
#   Si no tienes 'uv' instalado:
#     pip install uv  (o)  apt-get install uv  (o)  brew install uv
#
# ========================================================================================
# NOTA IMPORTANTE PARA WINDOWS (Git Bash):
#
# Para activar el entorno virtual, usar:
#   source .venv/Scripts/activate
#
# El comando de activación '.venv\Scripts\Activate.ps1' es solo para PowerShell.
# ========================================================================================
# CAMBIOS DESDE REQUIREMENTS.TXT:
#
# - requirements.txt eliminado (migration a pyproject.toml + uv.lock)
# - uv reemplaza pip: 10x más rápido, resolución determinística
# - pyproject.toml: fuente única de verdad (estándar PEP 517/518)
# - uv.lock: lock file determinístico (reproducible en CI/CD)
# ========================================================================================

# Directorio del entorno virtual (si existe)
VENV            = .venv

# Estas variables pueden definirse desde la línea de comandos.
# Default: -j auto activa build paralelo (usa todos los cores).
# Override con: SPHINXOPTS="" make html  (serial)
SPHINXOPTS      ?= -j auto

# Selección de sphinx-build:
# Preferir el ejecutable del venv (Linux/Mac primero, Windows después).
# Solo cae al sphinx-build global si ningún venv está presente.
ifneq ("$(wildcard $(VENV)/bin/sphinx-build)","")
SPHINXBUILD     = $(VENV)/bin/sphinx-build
else ifneq ("$(wildcard $(VENV)/Scripts/sphinx-build.exe)","")
SPHINXBUILD     = $(VENV)/Scripts/sphinx-build.exe
else
SPHINXBUILD     = sphinx-build
endif

# Selección de sphinx-autobuild (mismo patrón).
ifneq ("$(wildcard $(VENV)/bin/sphinx-autobuild)","")
SPHINXAUTOBUILD = $(VENV)/bin/sphinx-autobuild
else ifneq ("$(wildcard $(VENV)/Scripts/sphinx-autobuild.exe)","")
SPHINXAUTOBUILD = $(VENV)/Scripts/sphinx-autobuild.exe
else
SPHINXAUTOBUILD = sphinx-autobuild
endif

PAPER           =
BUILDDIR        = build

# Verificación amigable para comprobar que sphinx-build está instalado.
# Si no se encuentra el comando, se muestra un mensaje de error claro.
ifeq ($(shell which $(SPHINXBUILD) >/dev/null 2>&1; echo $$?), 1)
$(error El comando '$(SPHINXBUILD)' no fue encontrado. Asegúrate de tener Sphinx instalado. \
Si ya está instalado, configura la variable de entorno SPHINXBUILD con la ruta completa del ejecutable \
o agrega dicho directorio a tu PATH. Si no tienes Sphinx, descárgalo en http://sphinx-doc.org/)
endif

# Variables internas utilizadas por los distintos targets.
# Especifican tamaño de papel para construcciones LaTeX.
PAPEROPT_a4     = -D latex_paper_size=a4
PAPEROPT_letter = -D latex_paper_size=letter

# Opciones generales que usan la mayoría de los builders.
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) source

# El builder de internacionalización (i18n) no puede compartir doctrees con los demás.
I18NSPHINXOPTS  = $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) source

# Declaración de targets lógicos para evitar conflictos con archivos existentes.
help: help-uv help-sphinx

help-uv:
	@echo "UV Targets (Dependency Management):"
	@echo "  make sync              Instala dependencias con uv (ejecutar primero)"
	@echo "  make update-deps       Actualiza uv.lock y resuelve dependencias"
	@echo ""

help-sphinx:
	@echo "Sphinx Targets (Documentation Building):"
	@echo "  make html              Genera documentación HTML (DEFAULT)"
	@echo "  make livehtml           HTML con auto-rebuild en cambios"
	@echo "  make clean             Limpia archivos generados"
	@echo "  make latexpdf          Genera PDF (requiere LaTeX)"
	@echo "  make linkcheck         Valida enlaces externos"
	@echo ""

help-plantuml:
	@echo "PlantUML Targets (Validation & Styles):"
	@echo "  make validate-plantuml Valida sintaxis de diagramas PlantUML"
	@echo "  make plantuml-styles   Verifica que plantuml-styles.puml esté en _static/"
	@echo ""

.PHONY: sync update-deps help help-uv help-sphinx help-plantuml requirements help clean html livehtml freeze dirhtml singlehtml pickle json htmlhelp \
qthelp devhelp epub latex latexpdf latexpdfja text man texinfo info \
gettext changes linkcheck doctest xml pseudoxml validate-plantuml plantuml-styles \
check-bootstrap

sync:
	@echo "Instalando dependencias con uv..."
	@uv sync --no-dev
	@echo "✅ Dependencias instaladas. Ejecuta: make html"

update-deps:
	@echo "Actualizando uv.lock..."
	@uv lock
	@uv sync
	@echo "✅ Dependencias actualizadas"

# Target documental para indicar el uso de requirements.txt
requirements:
	@echo "Instale las dependencias necesarias ejecutando:"
	@echo "  pip install -r requirements.txt"

# Muestra una guía rápida de los targets disponibles.
help: help-uv help-sphinx help-plantuml
	@echo ""
	@echo "RECOMENDADO PARA EMPEZAR:"
	@echo "  1. make sync           # Instala dependencias"
	@echo "  2. make html           # Genera documentación con estilos PlantUML"
	@echo "  3. make validate-plantuml  # Valida diagramas PlantUML"
	@echo ""
	@echo "Para ver más targets, usa:"
	@echo "  make help-sphinx       # Todos los builders de Sphinx"
	@echo "  make help-plantuml     # Validación de PlantUML"
	@echo ""

# Elimina TODO el contenido generado, incluyendo cache de PlantUML.
# WHEN: cambios en conf.py, theme/extensions, debug de cache corrupto.
# COSTO: ~6 min en clean rebuild (re-render de todos los diagramas).
clean:
	rm -rf $(BUILDDIR)/*

# Clean selectivo — preserva cache PlantUML (build/html/_plantuml/)
# y otros assets cacheados (_images, _static).
# WHEN: uso diario. Reset HTML+doctrees sin regenerar diagramas.
# COSTO ESPERADO: ~30-90s vs ~6min de clean total.
# WP origen: 2026-04-29-14-28-18-build-performance.
clean-fast:
	rm -rf $(BUILDDIR)/doctrees
	@if [ -d $(BUILDDIR)/html ]; then \
		find $(BUILDDIR)/html -mindepth 1 -maxdepth 1 \
			-not -name "_plantuml" \
			-not -name "_images" \
			-not -name "_static" \
			-exec rm -rf {} +; \
	fi

# Guard de bootstrap — verifica que setup.sh fue ejecutado.
# Falla con mensaje accionable si falta plantuml.jar o el venv.
check-bootstrap:
	@missing=""; \
	if [ ! -f tools/plantuml.jar ]; then \
		missing="$$missing\n  - tools/plantuml.jar (descargado por setup.sh)"; \
	fi; \
	if [ ! -x .venv/bin/sphinx-build ] && [ ! -f .venv/Scripts/sphinx-build.exe ]; then \
		missing="$$missing\n  - .venv/ (creado por uv sync dentro de setup.sh)"; \
	fi; \
	if [ -n "$$missing" ]; then \
		printf "\033[31mERROR:\033[0m bootstrap incompleto. Faltan:%b\n\n" "$$missing"; \
		printf "Ejecutá primero:\n  \033[1mbash scripts/setup.sh\033[0m\n\n"; \
		exit 1; \
	fi

# Builder para HTML estándar.
html: check-bootstrap
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
	@echo
	@echo "Construcción finalizada. Los archivos HTML están en $(BUILDDIR)/html."

# Servidor con Live Reload (sphinx-autobuild).
# WHEN: ciclo edit-preview de documentacion. Watches source/,
# rebuilda incremental + recarga browser en cada save.
# Browser: http://127.0.0.1:8000
# Detener con Ctrl+C.
livehtml:
	@echo "Iniciando sphinx-autobuild en http://127.0.0.1:8000"
	@echo "Detenga con Ctrl+C."
	$(SPHINXAUTOBUILD) $(SPHINXOPTS) source $(BUILDDIR)/html
	@echo

# Builder para HTML con estructura basada en directorios.
dirhtml:
	$(SPHINXBUILD) -b dirhtml $(ALLSPHINXOPTS) $(BUILDDIR)/dirhtml
	@echo
	@echo "Construcción finalizada. Los archivos HTML están en $(BUILDDIR)/dirhtml."

# Builder para un único archivo HTML.
singlehtml:
	$(SPHINXBUILD) -b singlehtml $(ALLSPHINXOPTS) $(BUILDDIR)/singlehtml
	@echo
	@echo "Construcción finalizada. El archivo HTML está en $(BUILDDIR)/singlehtml."

# Builder para formato pickle.
pickle:
	$(SPHINXBUILD) -b pickle $(ALLSPHINXOPTS) $(BUILDDIR)/pickle
	@echo
	@echo "Construcción finalizada; ahora puedes procesar los archivos pickle."

# Builder para formato JSON.
json:
	$(SPHINXBUILD) -b json $(ALLSPHINXOPTS) $(BUILDDIR)/json
	@echo
	@echo "Construcción finalizada; ahora puedes procesar los archivos JSON."

# Builder para HTML Help (Windows).
htmlhelp:
	$(SPHINXBUILD) -b htmlhelp $(ALLSPHINXOPTS) $(BUILDDIR)/htmlhelp
	@echo
	@echo "Construcción finalizada. Puedes abrir el proyecto .hhp en $(BUILDDIR)/htmlhelp."

# Builder para documentación estilo QtHelp.
qthelp:
	$(SPHINXBUILD) -b qthelp $(ALLSPHINXOPTS) $(BUILDDIR)/qthelp
	@echo
	@echo "Construcción finalizada. Ejecuta qcollectiongenerator con el archivo .qhcp."

# Builder para documentación compatible con Devhelp.
devhelp:
	$(SPHINXBUILD) -b devhelp $(ALLSPHINXOPTS) $(BUILDDIR)/devhelp
	@echo
	@echo "Construcción finalizada."

# Builder para generar un archivo ePub.
epub:
	$(SPHINXBUILD) -b epub $(ALLSPHINXOPTS) $(BUILDDIR)/epub
	@echo
	@echo "Construcción finalizada. El archivo ePub está en $(BUILDDIR)/epub."

# Builder para generar archivos LaTeX.
latex:
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	@echo
	@echo "Construcción finalizada. Los archivos LaTeX están en $(BUILDDIR)/latex."

# Builder para generar archivos PDF a partir de LaTeX.
latexpdf:
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	@echo "Ejecutando pdflatex..."
	$(MAKE) -C $(BUILDDIR)/latex all-pdf
	@echo "pdflatex finalizado. Los archivos PDF están en $(BUILDDIR)/latex."

# Builder para PDF con platex/dvipdfmx (común en documentación japonesa).
latexpdfja:
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	@echo "Ejecutando platex y dvipdfmx..."
	$(MAKE) -C $(BUILDDIR)/latex all-pdf-ja
	@echo "Conversión finalizada. Los PDF están en $(BUILDDIR)/latex."

# Builder para generar archivos de texto plano.
text:
	$(SPHINXBUILD) -b text $(ALLSPHINXOPTS) $(BUILDDIR)/text
	@echo
	@echo "Construcción finalizada. Los archivos de texto están en $(BUILDDIR)/text."

# Builder para generar páginas de manual tipo man.
man:
	$(SPHINXBUILD) -b man $(ALLSPHINXOPTS) $(BUILDDIR)/man
	@echo
	@echo "Construcción finalizada. Los archivos man están en $(BUILDDIR)/man."

# Builder para Texinfo.
texinfo:
	$(SPHINXBUILD) -b texinfo $(ALLSPHINXOPTS) $(BUILDDIR)/texinfo
	@echo
	@echo "Construcción finalizada. Los archivos Texinfo están en $(BUILDDIR)/texinfo."

# Builder para generar archivos Info.
info:
	$(SPHINXBUILD) -b texinfo $(ALLSPHINXOPTS) $(BUILDDIR)/texinfo
	@echo "Ejecutando makeinfo..."
	make -C $(BUILDDIR)/texinfo info
	@echo "makeinfo finalizado. Los archivos Info están en $(BUILDDIR)/texinfo."

# Builder para generar catálogos de internacionalización.
gettext:
	$(SPHINXBUILD) -b gettext $(I18NSPHINXOPTS) $(BUILDDIR)/locale
	@echo
	@echo "Construcción finalizada. Los catálogos están en $(BUILDDIR)/locale."

# Builder para generar un resumen de cambios.
changes:
	$(SPHINXBUILD) -b changes $(ALLSPHINXOPTS) $(BUILDDIR)/changes
	@echo
	@echo "El archivo de resumen está en $(BUILDDIR)/changes."

# Builder para validar integridad de enlaces externos.
linkcheck:
	$(SPHINXBUILD) -b linkcheck $(ALLSPHINXOPTS) $(BUILDDIR)/linkcheck
	@echo
	@echo "Validación completada. Revisa $(BUILDDIR)/linkcheck/output.txt para detalles."

# Builder para ejecutar doctests incluidos en la documentación.
doctest:
	$(SPHINXBUILD) -b doctest $(ALLSPHINXOPTS) $(BUILDDIR)/doctest
	@echo "Ejecución de doctests finalizada. Consulta $(BUILDDIR)/doctest/output.txt."

# Builder para generar archivos XML nativos.
xml:
	$(SPHINXBUILD) -b xml $(ALLSPHINXOPTS) $(BUILDDIR)/xml
	@echo
	@echo "Construcción finalizada. Los archivos XML están en $(BUILDDIR)/xml."

# Builder para generar pseudo-XML legible para depuración.
pseudoxml:
	$(SPHINXBUILD) -b pseudoxml $(ALLSPHINXOPTS) $(BUILDDIR)/pseudoxml
	@echo
	@echo "Construcción finalizada. Los archivos pseudo-XML están en $(BUILDDIR)/pseudoxml."

# ========================================================================================
# PLANTUML TARGETS — Validación y gestión de estilos centralizados
# ========================================================================================

# Target: Verificar que plantuml-styles.puml está en el directorio correcto
plantuml-styles:
	@echo "Verificando PlantUML centralized styles..."
	@[ -f source/_static/plantuml-styles.puml ] && echo "✓ plantuml-styles.puml encontrado en source/_static/" || \
		echo "✗ ERROR: plantuml-styles.puml no encontrado en source/_static/"
	@echo ""
	@echo "Archivos de documentación PlantUML:"
	@[ -f discover/color-palette.md ] && echo "  ✓ discover/color-palette.md" || echo "  ✗ discover/color-palette.md (faltante)"
	@[ -f discover/GUIDELINES.md ] && echo "  ✓ discover/GUIDELINES.md" || echo "  ✗ discover/GUIDELINES.md (faltante)"
	@[ -f discover/test-uc-diagram.md ] && echo "  ✓ discover/test-uc-diagram.md" || echo "  ✗ discover/test-uc-diagram.md (faltante)"
	@[ -f discover/test-component-diagram.md ] && echo "  ✓ discover/test-component-diagram.md" || echo "  ✗ discover/test-component-diagram.md (faltante)"
	@echo ""

# Target: Validar sintaxis de archivos PlantUML
validate-plantuml:
	@echo "Validando sintaxis PlantUML..."
	@which plantuml > /dev/null || (echo "✗ ERROR: plantuml no está instalado"; exit 1)
	@echo "PlantUML version: $$(plantuml -version 2>&1 | head -1)"
	@echo ""
	@echo "Validando diagramas de test..."
	@if [ -f discover/test-plantuml-styles.puml ]; then \
		plantuml discover/test-plantuml-styles.puml -o /tmp/test-plantuml 2>&1 && echo "✓ test-plantuml-styles.puml compila sin errores" || echo "✗ test-plantuml-styles.puml tiene errores de sintaxis"; \
	fi
	@echo ""
	@echo "Nota: Los diagramas en formato markdown (.md) se validan durante 'make html' via sphinxcontrib-plantuml"
	@echo ""