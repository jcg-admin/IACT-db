# PLAN DE ACCIÓN EXACTO - Integración Archivos IACT

**Fecha:** 2026-01-07  
**Proyecto:** IACT Dashboard Analytics  
**Estructura:** YA FUNCIONAL (Sphinx 8.2.3 + Furo)

---

## SITUACIÓN ACTUAL DETECTADA

### ✅ Configuración Existente (Excelente)

**conf.py:**
- ✅ Sphinx 8.2.3
- ✅ Tema Furo con colores IACT (#199cd7)
- ✅ MyST Parser (soporta Markdown)
- ✅ 20+ extensiones configuradas
- ✅ Lenguaje: Español
- ✅ Logo y favicon configurados

**index.rst:**
- ✅ 5 Dominios en navegación:
  1. Base Cognitiva
  2. Normativa
  3. Requisitos
  4. Arquitectura Técnica
  5. Gestión

### ❌ Archivos Raíz NO en Navegación

**Problema:** Los archivos raíz (readme, prerequisites, authors, licence) están en `/raíz/` pero **NO aparecen en el menú de Sphinx** porque:
1. NO están en `source/`
2. NO están referenciados en ningún `toctree`

---

## SOLUCIÓN: 3 PASOS (15 MINUTOS)

### PASO 1: Copiar Archivos Actualizados a source/ (5 min)

```bash
# Ir al directorio del proyecto
cd /d/Estadia_IACT/proyecto/documentacion/

# Copiar los 4 archivos actualizados a source/
cp readme.rst source/
cp prerequisites.rst source/
cp authors.rst source/
cp licence.rst source/

# Verificar que se copiaron
ls -l source/*.rst | grep -E "(readme|prerequisites|authors|licence)"
```

### PASO 2: Actualizar source/index.rst (5 min)

Edita `source/index.rst` y agrega una nueva sección de toctree **ANTES** de "Base Cognitiva":

**Ubicación:** Línea 32 (antes del primer toctree)

**Agregar:**

```rst
.. toctree::
   :maxdepth: 1
   :caption: Información General
   
   readme
   prerequisites
   authors
   licence

```

**Resultado:** El archivo quedará así:

```rst
.. IACT - Sistema de Dashboard Analytics documentation master file

====================================================
IACT - Sistema de Dashboard Analytics
====================================================

.. image:: _static/img/logo.svg
   :alt: IACT Logo
   :align: center
   :width: 200px

----

Bienvenido a la Documentación del Proyecto IACT
================================================

El proyecto IACT es una solución de **Dashboard Analytics** que conecta datos operativos con necesidades de análisis de negocio mediante un proceso ETL robusto y trazable.

Arquitectura del Sistema
------------------------

* **Fuente de Datos:** MySQL (operativa, solo lectura)
* **Destino Analítico:** PostgreSQL (optimizado para consultas)
* **Backend:** Django REST Framework
* **Frontend:** React (Dashboard)

Estructura de la Documentación
==============================

Esta documentación sigue el **Modelo Documental IACT v2.0.0**, organizado en 5 Dominios Primarios que gobiernan 21 Subdominios especializados.

.. toctree::
   :maxdepth: 1
   :caption: Información General
   
   readme
   prerequisites
   authors
   licence

.. toctree::
   :maxdepth: 2
   :caption: Base Cognitiva

   base_cognitiva/index

.. toctree::
   :maxdepth: 2
   :caption: Normativa

   normativa/index

.. toctree::
   :maxdepth: 2
   :caption: Requisitos

   requisitos/index

.. toctree::
   :maxdepth: 2
   :caption: Arquitectura Técnica

   arquitectura_tecnica/index

.. toctree::
   :maxdepth: 2
   :caption: Gestión

   gestion/index

Índices y Búsqueda
==================

* :ref:`genindex`
* :ref:`search`

----

.. note::
   **Versión:** 1.0.0  
   **Fecha:** 2025  
   **Equipo:** IACT Development Team
```

### PASO 3: Rebuild y Verificar (5 min)

```bash
# Limpiar build anterior
make clean

# Construir de nuevo
make html

# Iniciar servidor live reload
make livehtml
```

**Abrir en navegador:**
- URL: http://127.0.0.1:8000
- Verificar que en el menú lateral aparece la sección "Información General" con los 4 archivos

---

## RESULTADO ESPERADO

### Menú de Navegación (Sidebar)

```
IACT - Sistema de Dashboard Analytics
├── Información General  ← NUEVO
│   ├── Sistema IACT - Documentación Oficial
│   ├── Requisitos Previos y Configuración del Entorno
│   ├── Equipo de Desarrollo
│   └── Licencia
├── Base Cognitiva
├── Normativa
├── Requisitos
├── Arquitectura Técnica
└── Gestión
```

### Warnings Reducidos

**Antes:** 294 warnings  
**Después:** ~290 warnings (solo UCs pendientes - normal)

---

## INTEGRACIÓN DE DOCUMENTOS GRANDES (OPCIONAL)

Tienes 4 documentos Markdown grandes para integrar. Como **YA TIENES MyST Parser configurado**, puedes dejarlos en Markdown (.md).

### Dónde Colocarlos

| Documento | Destino Recomendado |
|-----------|---------------------|
| MODELO_DOCUMENTAL_v2_2_0.md | `source/normativa/estandares/` |
| ANEXO_A_ARBOL_COMPLETO.md | `source/normativa/estandares/` |
| RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md | `source/normativa/restricciones/` |
| MODELO_RBAC_IACT_v5_1_1.md | `source/base_cognitiva/` o `source/normativa/` |

### Comandos para Copiar

```bash
# Crear directorios si no existen
mkdir -p source/normativa/estandares
mkdir -p source/normativa/restricciones

# Copiar documentos
cp MODELO_DOCUMENTAL_v2_2_0_PARTE1.md source/normativa/estandares/modelo_documental_parte1.md
cp MODELO_DOCUMENTAL_v2_2_0_PARTE2.md source/normativa/estandares/modelo_documental_parte2.md
cp ANEXO_A_ARBOL_COMPLETO_PARTE1.md source/normativa/estandares/anexo_a_parte1.md
cp ANEXO_A_ARBOL_COMPLETO_PARTE2.md source/normativa/estandares/anexo_a_parte2.md
cp RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md source/normativa/restricciones/restricciones_completas.md
cp MODELO_RBAC_IACT_v5_1_1.md source/base_cognitiva/modelo_rbac.md
```

### Actualizar index.rst de Subdominios

**Ejemplo para `source/normativa/estandares/index.rst`:**

Agregar al toctree:

```rst
.. toctree::
   :maxdepth: 1
   
   modelo_documental_parte1
   modelo_documental_parte2
   anexo_a_parte1
   anexo_a_parte2
```

**Ejemplo para `source/normativa/restricciones/index.rst`:**

```rst
.. toctree::
   :maxdepth: 1
   
   restricciones_completas
```

---

## CORRECCIONES ADICIONALES (OPCIONAL)

### Corregir Error de Indentación

**Archivo:** `source/requisitos/casos_uso/pipeline/index.rst`  
**Línea:** 3

```bash
# Editar el archivo
nano source/requisitos/casos_uso/pipeline/index.rst

# O con VS Code
code source/requisitos/casos_uso/pipeline/index.rst
```

Buscar la línea 3 y corregir la indentación incorrecta.

### Corregir Label Duplicado

**Archivo:** `source/normativa/gobernanza/GOB_05_Control_Versiones.rst`  
**Líneas:** 12 y 200

Buscar:
```rst
.. _gobernanza-index:
```

Cambiar uno de ellos a:
```rst
.. _gob-05-control-versiones:
```

---

## VERIFICACIÓN FINAL

### Checklist

- [ ] Archivos copiados a `source/`
- [ ] `source/index.rst` actualizado con nueva sección
- [ ] `make clean` ejecutado
- [ ] `make html` ejecutado sin errores
- [ ] Servidor live reload iniciado
- [ ] Menú muestra "Información General" con 4 archivos
- [ ] Documentos grandes copiados (opcional)
- [ ] Error de indentación corregido (opcional)
- [ ] Label duplicado corregido (opcional)

### Comandos de Verificación

```bash
# Contar archivos en source/
ls source/*.rst | wc -l
# Debe mostrar al menos 5 (index + 4 archivos raíz)

# Verificar que el build funciona
make html 2>&1 | grep -E "(ERROR|succeeded)"

# Ver el resultado
make livehtml
```

---

## TIEMPO ESTIMADO

| Tarea | Tiempo |
|-------|--------|
| Copiar archivos a source/ | 2 min |
| Editar index.rst | 3 min |
| Rebuild y verificar | 5 min |
| **TOTAL** | **10 min** |

**Con documentos grandes:** +15 min  
**Con correcciones adicionales:** +10 min

---

## NOTAS IMPORTANTES

### 1. MyST Parser Ya Configurado

Tu `conf.py` ya tiene:
```python
extensions = [
    ...
    'myst_parser',
    ...
]
```

Por eso puedes usar archivos `.md` directamente sin convertir a `.rst`.

### 2. Tema Furo con Colores IACT

Los colores están configurados:
```python
html_theme_options = {
    'dark_css_variables': {
        'color-brand-primary': '#199cd7',
        'color-brand-content': '#199cd7',
    },
}
```

### 3. No Necesitas .readthedocs.yaml

Como es un proyecto interno, puedes eliminarlo:
```bash
rm .readthedocs.yaml
```

---

## PRÓXIMOS PASOS (DESPUÉS DE LO ANTERIOR)

1. Crear dominio `evidencia/` (falta según modelo v2.2.0)
2. Crear subdominios pendientes en `arquitectura_tecnica/`
3. Completar UCs faltantes (para reducir los 290 warnings)
4. Agregar custom CSS si quieres personalizar más
5. Configurar CI/CD para builds automáticos

---

**¿LISTO PARA EJECUTAR?**

Empieza con el PASO 1 y avísame si encuentras algún problema.

