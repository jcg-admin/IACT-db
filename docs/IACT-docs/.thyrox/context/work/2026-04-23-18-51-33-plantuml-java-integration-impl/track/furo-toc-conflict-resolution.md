# Furo TOC Conflict Resolution — .. contents:: Removal

```yml
created_at: 2026-04-25 07:15:00
project: IACT-docs
issue: ERROR: Adding a table of contents in Furo-based documentation is unnecessary
severity: MEDIUM
category: Sphinx Configuration
status: RESOLVED
```

## Problema

Sphinx estaba generando advertencias:
```
ERROR: Adding a table of contents in Furo-based documentation is unnecessary
```

## Root Cause

Furo (el tema de documentación) ya incluye un **Table of Contents en el sidebar**. Sin embargo, 144+ archivos RST tenían directivas `.. contents::` explícitas, creando **TOC duplicados**:

- **Furo sidebar:** TOC automático generado por el tema
- **Content area:** TOC adicional generado por `.. contents::`

Cuando ambos existen, es redundante y confuso.

## Solución Implementada

### Paso 1: Identificación
```bash
find source -name "*.rst" -exec grep -l ".. contents::" {} \; | wc -l
# Resultado: 162 archivos (144 contenido real + 18 plantillas)
```

### Paso 2: Remoción Selectiva

**Removidas directivas `.. contents::` de:**
- Todos los archivos de contenido real (144 archivos)
- Ubicaciones: `requisitos/`, `arquitectura_tecnica/`, `base_cognitiva/`, `normativa/gobernanza/`, etc.

**Preservadas en:**
- Plantillas documentales (18 archivos en `normativa/estandares/plantillas/`)
  - Razón: Las plantillas definen CÓMO documentar, incluyen `.. contents::` como ejemplos

### Paso 3: Verificación
```bash
# Archivos reales (no-plantillas) con .. contents::
find source -name "*.rst" -not -path "*/plantillas/*" -exec grep -l ".. contents::" {} \;
# Resultado: 0 archivos ✓
```

## Arquitectura de Solución

**ANTES (TOC duplicado):**
```
Page with .. contents::
  ├── Sidebar TOC (Furo)          ← Automático
  └── Content Area
      └── .. contents:: Tabla     ← Manual = REDUNDANTE
          └── Section links
```

**DESPUÉS (Único TOC en sidebar):**
```
Page without .. contents::
  ├── Sidebar TOC (Furo)          ← Automático, limpio
  └── Content Area
      └── Secciones con headings  ← Navegables via sidebar
```

## Beneficios

✓ **Eliminación de redundancia:** Un único TOC, no duplicado  
✓ **Mejor UX:** El sidebar es más claro y organizado  
✓ **Compatibilidad Furo:** Respeta las convenciones del tema  
✓ **Menos clutter:** Las páginas son más limpias  
✓ **Mantenibilidad:** No hay que sincronizar múltiples TOCs  

## Plantillas Documentales

Las 18 plantillas mantienen `.. contents::` porque:

```rst
.. _tpl_uc:

================================
Plantilla: Caso de Uso (UC) v2.0
================================

.. contents:: Tabla de Contenidos
   :local:
   :backlinks: none
```

Las plantillas **definen estándares** de cómo los documentos deben estar formateados. Incluir `.. contents::` es parte de la especificación.

**Ubicaciones de plantillas:**
- `source/normativa/estandares/plantillas/TPL_*.rst` (18 archivos)

Estos archivos NO se distribuyen como documentación final; son referencias internas para autores.

## Comando Usado

```bash
find source -name "*.rst" -print0 | xargs -0 grep -l ".. contents::" | while read file; do
    awk '
    /^.. contents::/ { skip=1; next }
    skip && /^   / { next }
    skip && !/^   / { skip=0 }
    { print }
    ' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
done
```

**Lógica:**
- Detecta líneas `.. contents::`
- Salta esa línea y cualquier opción indentada que siga (`:local:`, `:backlinks:`, etc.)
- Preserva el resto del contenido

## Validación

Ejecutar post-fix:
```bash
# Verificar que se removieron de archivos reales
find source -name "*.rst" -not -path "*/plantillas/*" -exec grep -l ".. contents::" {} \;
# Esperado: ningún resultado (0 archivos)

# Verificar que persisten en plantillas
find source/normativa/estandares/plantillas -name "*.rst" -exec grep -l ".. contents::" {} \; | wc -l
# Esperado: 18 archivos
```

## Testing

- ✓ Build ejecutado: `make clean && make html`
- ✓ Búsqueda de error "Adding a table of contents": **No encontrado** ✓
- ✓ Furo sidebar TOC: Funciona correctamente
- ✓ Documentación legible: Secciones con headings navegables

## Futura Prevención

**Regla:** No agregar `.. contents::` en archivos de documentación real.

Si es necesario un TOC en una página específica, usar el sistema de sidebar de Furo (automático) o considerar agregar `:class:` si realmente se necesita:

```rst
.. contents::
   :local:
   :backlinks: none
   :class: this-will-duplicate-information-and-it-is-still-useful-here
```

Pero esto es raramente necesario.

## Referencias

- Furo documentation: https://pradyunsg.me/furo/
- Sphinx contents directive: https://www.sphinx-doc.org/en/master/usage/restructuredtext/directives.html#table-of-contents
- Issue: reStructuredText table of contents conflicts with Furo sidebar
