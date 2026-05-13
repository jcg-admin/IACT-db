# ⚡ REFERENCIA RÁPIDA - COMANDOS ESENCIALES

**Proyecto:** IACT Dashboard Analytics  
**Versión:** 1.0.0

---

## 🚀 OPCIÓN EXPRESS (55 minutos)

### 1. Preparación (5 min)
```bash
cd /d/Estadia_IACT/proyecto/documentacion/
mkdir -p documentos_referencia/
```

### 2. Archivos Raíz (10 min)
```bash
# Copiar archivos actualizados
cp readme.rst source/
cp prerequisites.rst source/
cp authors.rst source/
cp licence.rst source/

# Actualizar índice
cp source/index.rst source/index.rst.backup
cp index_actualizado.rst source/index.rst

# Build de prueba
make clean
make html
```

### 3. Conversión Automática (30 min)
```bash
# Copiar y ejecutar script
cp script_conversion_masiva.sh .
chmod +x script_conversion_masiva.sh
./script_conversion_masiva.sh

# Copiar archivos generados
cp /tmp/iact_conversion/modelo_documental_v2_2_0.rst source/normativa/estandares/
cp /tmp/iact_conversion/anexo_a_arbol_v2_2_0.rst source/normativa/estandares/
cp /tmp/iact_conversion/restricciones_sistema_v1_0_0.rst source/normativa/restricciones/
cp /tmp/iact_conversion/modelo_rbac_v5_1_1.rst source/base_cognitiva/
```

### 4. Actualizar Índices (5 min)
```bash
# Editar normativa/estandares/index.rst
nano source/normativa/estandares/index.rst
# Agregar: modelo_documental_v2_2_0 y anexo_a_arbol_v2_2_0

# Editar normativa/restricciones/index.rst
nano source/normativa/restricciones/index.rst
# Agregar: restricciones_sistema_v1_0_0

# Editar base_cognitiva/index.rst
nano source/base_cognitiva/index.rst
# Agregar: modelo_rbac_v5_1_1
```

### 5. Verificación (5 min)
```bash
make clean
make html
make livehtml  # Abrir http://127.0.0.1:8000
```

---

## 🔧 COMANDOS PRINCIPALES

### Build
```bash
# Build limpio
make clean
make html

# Build con servidor live
make livehtml

# Verificar enlaces
make linkcheck
```

### Conversión con Pandoc
```bash
# Archivo individual
pandoc -f markdown -t rst archivo.md -o archivo.rst

# Con tabla de contenidos
pandoc -f markdown -t rst --standalone --toc archivo.md -o archivo.rst

# Unir archivos antes de convertir
cat parte1.md parte2.md > completo.md
pandoc -f markdown -t rst --standalone --toc completo.md -o completo.rst
```

### Búsqueda y Verificación
```bash
# Encontrar todos los .md en source/
find source/ -name "*.md" -type f

# Contar archivos .rst
find source/ -name "*.rst" | wc -l

# Ver errores del build
make html 2>&1 | grep ERROR

# Ver warnings del build
make html 2>&1 | grep WARNING
```

### Git
```bash
# Crear backup antes de cambios
tar -czf ../backup_$(date +%Y%m%d_%H%M%S).tar.gz .

# Ver estado
git status

# Agregar archivos nuevos
git add source/readme.rst source/prerequisites.rst source/authors.rst source/licence.rst

# Commit
git commit -m "docs: agregar archivos raíz e integrar documentos grandes"
```

---

## 📝 EDICIÓN DE ARCHIVOS RST

### Encabezados
```rst
Título Principal
================

Subtítulo
---------

Sub-subtítulo
^^^^^^^^^^^^^
```

### Enlaces
```rst
# Enlace externo
`Texto del enlace <https://ejemplo.com>`_

# Enlace interno a documento
:doc:`Texto </ruta/al/documento>`

# Enlace a sección
:ref:`etiqueta`
```

### Listas
```rst
# Lista con viñetas
* Item 1
* Item 2
  
  * Sub-item 2.1
  * Sub-item 2.2

# Lista numerada
1. Primero
2. Segundo
3. Tercero
```

### Bloques de Código
```rst
.. code-block:: python
   
   def funcion():
       return "Hola"
```

### Tablas
```rst
+----------+----------+
| Columna1 | Columna2 |
+==========+==========+
| Dato 1   | Dato 2   |
+----------+----------+
```

### Imágenes
```rst
.. image:: _static/img/imagen.png
   :alt: Texto alternativo
   :width: 400px
   :align: center
```

---

## 🎯 ESTRUCTURA DE DIRECTORIOS

```
documentacion/
├── source/
│   ├── conf.py
│   ├── index.rst
│   ├── readme.rst              ← NUEVO
│   ├── prerequisites.rst       ← NUEVO
│   ├── authors.rst             ← NUEVO
│   ├── licence.rst             ← NUEVO
│   │
│   ├── base_cognitiva/
│   │   ├── index.rst
│   │   └── modelo_rbac_v5_1_1.rst     ← NUEVO
│   │
│   ├── normativa/
│   │   ├── estandares/
│   │   │   ├── modelo_documental_v2_2_0.rst  ← NUEVO
│   │   │   └── anexo_a_arbol_v2_2_0.rst      ← NUEVO
│   │   └── restricciones/
│   │       └── restricciones_sistema_v1_0_0.rst  ← NUEVO
│   │
│   ├── requisitos/
│   ├── arquitectura_tecnica/
│   └── gestion/
│
├── Makefile
├── requirements.txt
└── documentos_referencia/      ← NUEVO (archivos .md de apoyo)
```

---

## 🔍 TROUBLESHOOTING RÁPIDO

### Problema: `make html` falla
```bash
# Ver error específico
make html 2>&1 | tail -20

# Verificar sintaxis de conf.py
python -c "import source.conf"
```

### Problema: Enlaces rotos
```bash
# Ejecutar linkcheck
make linkcheck

# Ver resultados
cat build/linkcheck/output.txt
```

### Problema: Archivos no aparecen en menú
```bash
# Verificar que están en un toctree
grep -r "archivo_nombre" source/*/index.rst
```

### Problema: Pandoc no convierte bien
```bash
# Usar opciones más compatibles
pandoc -f markdown+pipe_tables -t rst --standalone archivo.md -o archivo.rst
```

---

## ✅ CHECKLIST MÍNIMO

- [ ] Pandoc instalado
- [ ] 4 archivos raíz en `source/`
- [ ] `source/index.rst` actualizado
- [ ] `make html` sin errores
- [ ] Archivos raíz accesibles en http://127.0.0.1:8000

---

## 📞 AYUDA RÁPIDA

### Ver versión de herramientas
```bash
sphinx-build --version
pandoc --version
python --version
make --version
```

### Limpiar todo y empezar de nuevo
```bash
make clean
rm -rf build/
make html
```

### Ver estructura de navegación
```bash
# Ver todos los index.rst
find source/ -name "index.rst"

# Ver toctrees
grep -r ".. toctree::" source/
```

---

**Última actualización:** 2026-01-07  
**Para más detalles:** Consulta GUIA_PASO_A_PASO_IMPLEMENTACION.md

