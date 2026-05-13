# PLAN DE IMPLEMENTACIÓN COMPLETO: ESTRUCTURA SPHINX IACT

**Versión:** 1.0.0  
**Fecha:** 2026-01-07  
**Proyecto:** IACT-2025-001  
**Basado en:** ANALISIS_ESTRUCTURA_SPHINX_IACT.md v1.0.0

---

## RESUMEN EJECUTIVO

Este documento proporciona el plan de acción paso a paso para implementar la estructura de documentación Sphinx del proyecto IACT según el Modelo Documental v2.2.0.

### Objetivos

1. Crear estructura completa de directorios (~30 carpetas)
2. Generar archivos index.rst necesarios (~28 archivos)
3. Configurar Sphinx correctamente
4. Integrar los 4 archivos raíz
5. Lograr primer build exitoso

### Tiempo Estimado
- **Fase 0 + Fase 1:** 2-4 horas
- **Fase 2:** 4-6 horas  
- **Fase 3:** 6-8 horas
- **Total Fases Críticas:** 12-18 horas

---

## FASE 0: PREPARACIÓN DEL ENTORNO

### 0.1 Verificar Herramientas

```bash
# Verificar Python
python --version  # Debe ser 3.11+

# Verificar pip
pip --version

# Verificar virtualenv
python -m venv --help
```

### 0.2 Crear Entorno Virtual

```bash
# En la raíz del proyecto
python -m venv .venv

# Windows Git Bash
source .venv/Scripts/activate

# Linux/macOS
source .venv/bin/activate
```

### 0.3 Instalar Dependencias

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

**Verificar instalación:**
```bash
sphinx-build --version  # Debe mostrar 8.2.3
```

---

## FASE 1: ESTRUCTURA BASE Y ARCHIVOS CRÍTICOS

### 1.1 Crear Estructura de Directorios Base

**Script bash completo:**

```bash
#!/bin/bash
# crear_estructura_base.sh

# Crear directorio source si no existe
mkdir -p source

# Crear subdirectorios principales
mkdir -p source/_static/{css,js,img}
mkdir -p source/_templates/sidebar

# Crear los 5 dominios
mkdir -p source/base_cognitiva
mkdir -p source/requisitos
mkdir -p source/arquitectura_tecnica
mkdir -p source/normativa
mkdir -p source/evidencia

echo "✅ Estructura base creada"
```

**Ejecutar:**
```bash
chmod +x crear_estructura_base.sh
./crear_estructura_base.sh
```

### 1.2 Crear conf.py

**Ubicación:** `source/conf.py`

**Método de creación (usar staging /tmp):**

```bash
cat > /tmp/conf.py << 'CONFPY'
# Configuration file for the Sphinx documentation builder.
# Sistema IACT - Interactive Analytics & Customer Tracking

import os
import sys

# -- Project information -----------------------------------------------------
project = 'Sistema IACT'
copyright = '2025-2026, [Nombre de tu Empresa]'
author = 'Equipo IACT'
version = '1.0'
release = '1.0.0'

# -- General configuration ---------------------------------------------------
extensions = [
    'sphinx.ext.autodoc',
    'sphinx.ext.napoleon',
    'sphinx.ext.viewcode',
    'sphinx.ext.todo',
    'sphinx.ext.graphviz',
    'sphinx_design',
    'sphinx_copybutton',
    'sphinx_tabs.tabs',
    'myst_parser',
    'sphinx.ext.autosectionlabel',
]

templates_path = ['_templates']
exclude_patterns = []
language = 'es'

# -- Options for HTML output -------------------------------------------------
html_theme = 'furo'
html_static_path = ['_static']
html_title = 'Sistema IACT - Documentación'

html_theme_options = {
    "sidebar_hide_name": False,
    "navigation_with_keys": True,
    "light_css_variables": {
        "color-brand-primary": "#3498DB",
        "color-brand-content": "#2C3E50",
    },
}

# -- MyST Parser configuration -----------------------------------------------
myst_enable_extensions = [
    "colon_fence",
    "deflist",
    "tasklist",
]

# -- Autodoc configuration ---------------------------------------------------
autodoc_member_order = 'bysource'
autodoc_typehints = 'description'

# -- Napoleon configuration --------------------------------------------------
napoleon_google_docstring = True
napoleon_numpy_docstring = True
napoleon_include_init_with_doc = True

# -- Todo configuration ------------------------------------------------------
todo_include_todos = True

# -- Autosection label -------------------------------------------------------
autosectionlabel_prefix_document = True
CONFPY

# Copiar a source/
cp /tmp/conf.py source/conf.py
```

### 1.3 Crear index.rst Principal

**Ubicación:** `source/index.rst`

```bash
cat > /tmp/index.rst << 'INDEXRST'
=====================================
Sistema IACT - Documentación Oficial
=====================================

Bienvenido a la documentación oficial del Sistema IACT (Interactive Analytics & Customer Tracking).

.. note::
   Esta documentación está en desarrollo activo. Versión actual: |version|

¿Qué es IACT?
=============

El Sistema IACT es una plataforma empresarial diseñada para el análisis y seguimiento 
de interacciones con clientes en el contexto de operaciones de call center y contact center.

Características Principales
============================

* Registro y seguimiento de llamadas telefónicas
* Análisis de métricas operacionales y de servicio
* Generación de reportes y dashboards ejecutivos
* Sistema de alertas y notificaciones internas
* Gestión avanzada de permisos mediante RBAC
* Auditoría completa de operaciones

Navegación
==========

.. toctree::
   :maxdepth: 2
   :caption: Información General
   
   readme
   prerequisites
   authors
   licence

.. toctree::
   :maxdepth: 2
   :caption: Dominios del Proyecto
   
   base_cognitiva/index
   requisitos/index
   arquitectura_tecnica/index
   normativa/index
   evidencia/index

.. toctree::
   :maxdepth: 1
   :caption: Documentación de Referencia
   
   normativa/estandares/modelo_documental
   normativa/estandares/anexo_a_arbol

Información del Proyecto
=========================

:Versión: |release|
:Fecha: Enero 2026
:Código Proyecto: IACT-2025-001
:Estado: En Desarrollo Activo

Índices y Tablas
================

* :ref:`genindex`
* :ref:`search`
INDEXRST

cp /tmp/index.rst source/index.rst
```

### 1.4 Copiar Archivos Raíz a source/

```bash
# Copiar los 4 archivos actualizados
cp readme.rst source/
cp prerequisites.rst source/
cp authors.rst source/
cp licence.rst source/
```

### 1.5 Crear .gitignore

```bash
cat > .gitignore << 'GITIGNORE'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
.venv/
venv/
ENV/
env/

# Sphinx
build/
_build/
.doctrees/

# IDEs
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Temporary files
*.tmp
*.bak
GITIGNORE
```

### 1.6 Verificación FASE 1

```bash
# Verificar estructura creada
tree -L 2 source/

# Debe mostrar:
# source/
# ├── _static/
# ├── _templates/
# ├── base_cognitiva/
# ├── requisitos/
# ├── arquitectura_tecnica/
# ├── normativa/
# ├── evidencia/
# ├── conf.py
# ├── index.rst
# ├── readme.rst
# ├── prerequisites.rst
# ├── authors.rst
# └── licence.rst
```

### 1.7 Primer Build de Prueba

```bash
# Desde la raíz del proyecto
make html

# Si hay errores, revisar:
# 1. conf.py está bien formado
# 2. index.rst no referencia archivos inexistentes
# 3. Todas las extensiones están instaladas
```

**Resultado Esperado:**
```
Build succeeded, X warnings.
The HTML pages are in build/html.
```

**Abrir en navegador:**
```bash
# Windows
start build/html/index.html

# Linux
xdg-open build/html/index.html

# macOS
open build/html/index.html
```

---

## FASE 2: CREAR ÍNDICES DE DOMINIOS

### 2.1 Script para Crear Índices de Dominios

```bash
#!/bin/bash
# crear_indices_dominios.sh

# Función para crear index.rst de dominio
crear_index_dominio() {
    local dominio=$1
    local titulo=$2
    local descripcion=$3
    
    cat > "source/${dominio}/index.rst" << EOF
$(printf '=%.0s' {1..${#titulo}})
${titulo}
$(printf '=%.0s' {1..${#titulo}})

${descripcion}

.. toctree::
   :maxdepth: 2
   :caption: Contenido
   
   


Estado
======

.. note::
   Sección en construcción. Última actualización: $(date +%Y-%m-%d)

Referencias
===========

* :doc:\`/index\`
* :doc:\`Modelo Documental </normativa/estandares/modelo_documental>\`
EOF
}

# Crear índices
crear_index_dominio "base_cognitiva" "Base Cognitiva" "Conocimiento fundamental y ontologías del proyecto IACT."

crear_index_dominio "requisitos" "Requisitos del Sistema" "Especificación completa de requisitos del sistema IACT."

crear_index_dominio "arquitectura_tecnica" "Arquitectura Técnica" "Diseño e implementación del sistema IACT."

crear_index_dominio "normativa" "Normativa y Gobernanza" "Estándares, procedimientos y políticas del proyecto."

crear_index_dominio "evidencia" "Evidencia y Trazabilidad" "Pruebas, verificación y matrices de trazabilidad."

echo "✅ Índices de dominios creados"
```

**Ejecutar:**
```bash
chmod +x crear_indices_dominios.sh
./crear_indices_dominios.sh
```


### 2.2 Crear Subdominios de base_cognitiva

```bash
# Crear subdominios (algunos privados con prefijo _)
mkdir -p source/base_cognitiva/_metadata
mkdir -p source/base_cognitiva/glosario
mkdir -p source/base_cognitiva/_fundamentos_conceptuales
mkdir -p source/base_cognitiva/_ontologia_sbvr
mkdir -p source/base_cognitiva/_taxonomias_y_metamodelos/{taxonomias,metamodelos}
mkdir -p source/base_cognitiva/_metodologias_analiticas

# Crear índice básico del glosario (único público)
cat > source/base_cognitiva/glosario/index.rst << 'EOF'
=========
Glosario
=========

Términos y definiciones del proyecto IACT.

.. toctree::
   :maxdepth: 1
   
   

Estado: Congelado
==================

Este glosario está congelado según la gobernanza del proyecto.
EOF
```

### 2.3 Crear Subdominios de requisitos

```bash
# Crear subdominios
mkdir -p source/requisitos/objetivos_negocio
mkdir -p source/requisitos/reglas_negocio
mkdir -p source/requisitos/casos_uso/{auth,users,access,pipeline,reports,alerts,audit,logs}
mkdir -p source/requisitos/funcionales/{auth,users,access,pipeline,reports,alerts,audit,logs}
mkdir -p source/requisitos/no_funcionales

# Script para crear índices
for subdom in objetivos_negocio reglas_negocio casos_uso funcionales no_funcionales; do
    cat > "source/requisitos/${subdom}/index.rst" << EOF
$(echo ${subdom^} | tr '_' ' ')
$(printf '=%.0s' {1..50})

Contenido de ${subdom}.

.. toctree::
   :maxdepth: 2
   
   
EOF
done
```

### 2.4 Crear Subdominios de arquitectura_tecnica

```bash
# Crear subdominios
mkdir -p source/arquitectura_tecnica/modulos
mkdir -p source/arquitectura_tecnica/restricciones
mkdir -p source/arquitectura_tecnica/decisiones
mkdir -p source/arquitectura_tecnica/vistas
mkdir -p source/arquitectura_tecnica/flujos_datos
mkdir -p source/arquitectura_tecnica/apis
mkdir -p source/arquitectura_tecnica/modelos_datos

# Crear índices básicos
for subdom in modulos restricciones decisiones vistas flujos_datos apis modelos_datos; do
    titulo=$(echo ${subdom^} | tr '_' ' ')
    cat > "source/arquitectura_tecnica/${subdom}/index.rst" << EOF
${titulo}
$(printf '=%.0s' {1..50})

.. toctree::
   :maxdepth: 2
   
   
EOF
done
```

### 2.5 Crear Subdominios de normativa

```bash
# Crear subdominios
mkdir -p source/normativa/estandares/plantillas
mkdir -p source/normativa/procedimientos
mkdir -p source/normativa/politicas

# Crear índices
cat > source/normativa/estandares/index.rst << 'EOF'
==========
Estándares
==========

Estándares del proyecto IACT.

.. toctree::
   :maxdepth: 2
   :caption: Estándares Base
   
   

.. toctree::
   :maxdepth: 1
   :caption: Plantillas (TPL)
   
   plantillas/index
EOF

cat > source/normativa/procedimientos/index.rst << 'EOF'
==============
Procedimientos
==============

Procedimientos operativos del proyecto.

.. toctree::
   :maxdepth: 1
   
   
EOF

cat > source/normativa/politicas/index.rst << 'EOF'
=========
Políticas
=========

Políticas del proyecto IACT.

.. toctree::
   :maxdepth: 1
   
   
EOF

cat > source/normativa/estandares/plantillas/index.rst << 'EOF'
======================
Plantillas de Artefactos
======================

Templates para generación de artefactos.

.. toctree::
   :maxdepth: 1
   
   
EOF
```

### 2.6 Crear Subdominios de evidencia

```bash
# Crear subdominios
mkdir -p source/evidencia/pruebas/{auth,users,access,pipeline,reports,alerts,audit,logs}
mkdir -p source/evidencia/trazabilidad

# Crear índices
cat > source/evidencia/pruebas/index.rst << 'EOF'
=======
Pruebas
=======

Casos de prueba del sistema.

.. toctree::
   :maxdepth: 2
   
   

Estado: Pendiente
=================

Los casos de prueba se generarán después de completar los requisitos funcionales.
EOF

cat > source/evidencia/trazabilidad/index.rst << 'EOF'
==============
Trazabilidad
==============

Matrices de trazabilidad del proyecto.

.. toctree::
   :maxdepth: 1
   
   

Estado: Congelado
=================

Las matrices de trazabilidad están congeladas según la gobernanza del proyecto.
EOF
```

### 2.7 Actualizar Índices de Dominio con Subdominios

**Ejemplo para requisitos/index.rst:**

```bash
cat > source/requisitos/index.rst << 'EOF'
======================
Requisitos del Sistema
======================

Especificación completa de requisitos del sistema IACT.

Estructura
==========

Este dominio contiene:

* **Objetivos de Negocio (BReq):** 8 objetivos principales
* **Reglas de Negocio (BR):** 20 reglas congeladas
* **Casos de Uso (UC):** 49 casos de uso en 8 módulos
* **Requisitos Funcionales (FR):** ~392 requisitos (55 generados)
* **Requisitos No Funcionales (NFR):** ~20 requisitos

.. toctree::
   :maxdepth: 2
   :caption: Subdominios
   
   objetivos_negocio/index
   reglas_negocio/index
   casos_uso/index
   funcionales/index
   no_funcionales/index

Estado
======

.. note::
   Generación de FR en progreso: 55/~392 (14%)
   
   * MOD_Auth: ✅ Completo (21 FR)
   * MOD_Users: ✅ Completo (17 FR)
   * MOD_Access: 🔄 Parcial (17 FR)
   * Otros módulos: ⏳ Pendiente

Referencias
===========

* :doc:`/normativa/estandares/modelo_documental`
* :doc:`/arquitectura_tecnica/modulos/index`
EOF
```

### 2.8 Verificación FASE 2

```bash
# Contar índices creados
find source/ -name "index.rst" | wc -l
# Debe mostrar al menos 28 archivos

# Build de prueba
make clean
make html

# Verificar warnings
# Deben ser solo sobre toctrees vacíos (normal en esta fase)
```

---

## FASE 3: CONVERSIÓN E INTEGRACIÓN DE DOCUMENTOS MARKDOWN

### 3.1 Instalar pandoc (si no está instalado)

```bash
# Ubuntu/Debian
sudo apt-get install pandoc

# macOS
brew install pandoc

# Windows (descargar desde pandoc.org)

# Verificar
pandoc --version
```

### 3.2 Convertir MODELO_DOCUMENTAL_IACT

**Paso 1: Unir las 2 partes**

```bash
cat MODELO_DOCUMENTAL_IACT_v2_2_0_PARTE1.md \
    MODELO_DOCUMENTAL_IACT_v2_2_0_PARTE2.md \
    > /tmp/MODELO_DOCUMENTAL_COMPLETO.md
```

**Paso 2: Convertir a RST**

```bash
pandoc -f markdown -t rst \
    /tmp/MODELO_DOCUMENTAL_COMPLETO.md \
    -o /tmp/modelo_documental_v2_2_0.rst
```

**Paso 3: Post-procesamiento**

```bash
# Ajustar encabezados (Sphinx usa = para nivel 1, - para nivel 2, etc.)
# Esto requiere edición manual o script específico

# Copiar a destino
cp /tmp/modelo_documental_v2_2_0.rst \
   source/normativa/estandares/modelo_documental.rst
```

### 3.3 Convertir ANEXO_A_ARBOL_COMPLETO

```bash
# Unir partes
cat ANEXO_A_ARBOL_COMPLETO_PARTE1.md \
    ANEXO_A_ARBOL_COMPLETO_PARTE2.md \
    > /tmp/ANEXO_A_COMPLETO.md

# Convertir
pandoc -f markdown -t rst \
    /tmp/ANEXO_A_COMPLETO.md \
    -o /tmp/anexo_a_arbol_v2_2_0.rst

# Copiar
cp /tmp/anexo_a_arbol_v2_2_0.rst \
   source/normativa/estandares/anexo_a_arbol.rst
```

### 3.4 Convertir RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT

```bash
# Convertir (archivo grande, usar staging)
pandoc -f markdown -t rst \
    RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md \
    -o /tmp/restricciones_sistema_v1_0_0.rst

# Copiar
cp /tmp/restricciones_sistema_v1_0_0.rst \
   source/arquitectura_tecnica/restricciones/restricciones_completas.rst
```

### 3.5 Convertir MODELO_RBAC_IACT

```bash
# Convertir
pandoc -f markdown -t rst \
    MODELO_RBAC_IACT_v5_1_1.md \
    -o /tmp/modelo_rbac_v5_1_1.rst

# Copiar
cp /tmp/modelo_rbac_v5_1_1.rst \
   source/arquitectura_tecnica/modulos/modelo_rbac.rst
```

### 3.6 Actualizar index.rst para Referencias a Documentos Convertidos

**En source/index.rst:**

```rst
.. toctree::
   :maxdepth: 1
   :caption: Documentación de Referencia
   
   normativa/estandares/modelo_documental
   normativa/estandares/anexo_a_arbol
   arquitectura_tecnica/restricciones/restricciones_completas
   arquitectura_tecnica/modulos/modelo_rbac
```

### 3.7 Verificación FASE 3

```bash
# Build completo
make clean
make html

# Verificar que los 4 documentos aparecen en el menú
# Abrir en navegador y verificar enlaces
```

---

## FASE 4: OPTIMIZACIÓN Y AJUSTES FINALES

### 4.1 Crear Custom CSS

```bash
cat > source/_static/css/custom.css << 'CSS'
/* Estilos personalizados para IACT */

/* Logo y branding */
.sidebar-brand-text {
    color: #3498DB !important;
    font-weight: bold;
}

/* Tablas más legibles */
table.docutils {
    border-collapse: collapse;
    width: 100%;
}

table.docutils th {
    background-color: #3498DB;
    color: white;
    padding: 8px;
}

table.docutils td {
    padding: 8px;
    border: 1px solid #ddd;
}

/* Notas y advertencias */
.admonition.note {
    background-color: #E8F4F8;
    border-left: 4px solid #3498DB;
}

.admonition.warning {
    background-color: #FFF4E5;
    border-left: 4px solid #F39C12;
}

/* Bloques de código */
pre {
    background-color: #F8F9FA;
    border: 1px solid #E9ECEF;
    border-radius: 4px;
    padding: 12px;
}
CSS
```

### 4.2 Configurar Logo (opcional)

```bash
# Colocar logo en _static/img/
# Si no tienes logo, crear uno placeholder:
echo "IACT Logo Placeholder" > source/_static/img/logo.txt
```

### 4.3 Crear Custom Template (opcional)

```bash
cat > source/_templates/page.html << 'HTML'
{% extends "!page.html" %}

{% block footer %}
{{ super() }}
<div class="custom-footer">
    <p>Sistema IACT - {{ copyright }}</p>
    <p>Documentación v{{ version }} - Última actualización: {{ last_updated }}</p>
</div>
{% endblock %}
HTML
```

### 4.4 Configurar Build Automation

```bash
# Crear script de build
cat > build_docs.sh << 'BASH'
#!/bin/bash
set -e

echo "🔧 Limpiando build anterior..."
make clean

echo "📚 Construyendo documentación..."
make html

echo "✅ Build completado!"
echo "📂 Archivos en: build/html/index.html"

# Abrir en navegador (opcional)
if [ "$1" == "--open" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open build/html/index.html
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        xdg-open build/html/index.html
    fi
fi
BASH

chmod +x build_docs.sh
```

### 4.5 Validación Final

```bash
# Build limpio
./build_docs.sh

# Verificar sin warnings
make html 2>&1 | grep -i warning

# Validar enlaces internos
make linkcheck

# Verificar búsqueda funciona
# (abrir HTML y probar búsqueda)
```

---

## CHECKLIST DE COMPLETITUD

### ✅ FASE 0: Preparación
- [ ] Python 3.11+ instalado
- [ ] Entorno virtual creado y activado
- [ ] requirements.txt instalado
- [ ] sphinx-build funcional

### ✅ FASE 1: Estructura Base
- [ ] source/ creado
- [ ] source/_static/ con subdirectorios
- [ ] source/_templates/ creado
- [ ] Los 5 dominios creados
- [ ] conf.py creado y configurado
- [ ] source/index.rst creado
- [ ] 4 archivos raíz copiados a source/
- [ ] .gitignore creado
- [ ] Primer build exitoso

### ✅ FASE 2: Índices de Dominios
- [ ] 5 índices de dominio creados
- [ ] ~23 subdominios creados
- [ ] ~28 index.rst totales
- [ ] Build sin errores

### ✅ FASE 3: Conversión Markdown
- [ ] MODELO_DOCUMENTAL convertido
- [ ] ANEXO_A convertido
- [ ] RESTRICCIONES convertidas
- [ ] MODELO_RBAC convertido
- [ ] Documentos referenciados en index principal
- [ ] Build exitoso con documentos

### ✅ FASE 4: Optimización
- [ ] Custom CSS creado
- [ ] Logo configurado (si aplica)
- [ ] Script de build automatizado
- [ ] Validación linkcheck pasada
- [ ] Búsqueda funcional

---

## MÉTRICAS DE ÉXITO

| Métrica | Objetivo | Status |
|---------|----------|--------|
| Directorios creados | ~30 | [ ] |
| Archivos index.rst | ~28 | [ ] |
| Archivos raíz integrados | 4/4 | [ ] |
| Documentos MD convertidos | 4/4 | [ ] |
| Build exitoso | Sí | [ ] |
| Warnings | 0 | [ ] |
| Enlaces rotos | 0 | [ ] |
| Búsqueda funcional | Sí | [ ] |

---

## PRÓXIMOS PASOS (POST-IMPLEMENTACIÓN)

### Corto Plazo
1. Migrar artefactos congelados (20 BR, 10 CNST, 8 MOD)
2. Crear plantillas reutilizables de artefactos
3. Documentar flujo de actualización

### Medio Plazo
1. Completar generación de FR (~337 pendientes)
2. Generar casos de prueba (TST)
3. Automatizar publicación

### Largo Plazo
1. Integrar con CI/CD
2. Implementar versionado automático
3. Capacitar equipo en mantenimiento

---

## TROUBLESHOOTING COMÚN

### Problema: Build falla con "extension not found"

**Solución:**
```bash
pip install --upgrade sphinx-design sphinx-copybutton
```

### Problema: Warnings sobre toctree vacíos

**Solución:** Normal durante construcción. Comentar con `..` las líneas vacías:

```rst
.. toctree::
   :maxdepth: 2
   
   .. archivo1
   .. archivo2
```

### Problema: Documentos MD no se ven bien

**Solución:** Post-procesar con script:

```bash
# Ajustar encabezados
sed -i 's/^# /======\\n/g' archivo.rst
```

### Problema: Búsqueda no funciona

**Solución:**
```bash
make clean
make html
# La búsqueda se genera durante el build
```

---

**FIN DEL PLAN**

**Versión:** 1.0.0  
**Fecha:** 2026-01-07  
**Siguiente Revisión:** Post-FASE 4  
**Documento Relacionado:** ANALISIS_ESTRUCTURA_SPHINX_IACT.md v1.0.0

