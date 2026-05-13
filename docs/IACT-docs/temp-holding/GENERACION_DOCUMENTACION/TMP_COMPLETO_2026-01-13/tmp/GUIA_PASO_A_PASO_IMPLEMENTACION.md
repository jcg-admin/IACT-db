# GUÍA PASO A PASO: IMPLEMENTACIÓN COMPLETA

**Proyecto:** IACT Dashboard Analytics  
**Versión:** 1.0.0  
**Fecha:** 2026-01-07  
**Tiempo Estimado Total:** 10-12 horas

---

## ÍNDICE

1. [Preparación del Entorno](#fase-1-preparación)
2. [Integración de Archivos Raíz](#fase-2-archivos-raíz)
3. [Conversión de Documentos Grandes](#fase-3-documentos-grandes)
4. [Conversión de Archivos .md del Proyecto](#fase-4-archivos-md-proyecto)
5. [Actualización de Índices](#fase-5-actualización-índices)
6. [Actualización de conf.py](#fase-6-configuración)
7. [Limpieza Final](#fase-7-limpieza)
8. [Verificación Completa](#fase-8-verificación)

---

## FASE 1: PREPARACIÓN DEL ENTORNO

**Tiempo:** 30 minutos  
**Prioridad:** ALTA

### 1.1 Instalar Pandoc

#### Windows (Git Bash)
```bash
# Descargar desde: https://pandoc.org/installing.html
# Ejecutar instalador
# Verificar:
pandoc --version
```

#### Linux (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install pandoc -y
pandoc --version
```

#### macOS
```bash
brew install pandoc
pandoc --version
```

**Resultado esperado:** `pandoc 3.x.x` o superior

### 1.2 Crear Estructura de Respaldo

```bash
# Ir al directorio del proyecto
cd /d/Estadia_IACT/proyecto/documentacion/

# Crear backup completo
mkdir -p ../backups
tar -czf ../backups/backup_$(date +%Y%m%d_%H%M%S).tar.gz .

# Verificar backup
ls -lh ../backups/
```

### 1.3 Crear Carpeta para Documentos de Referencia

```bash
# Fuera de source/ - no se procesará por Sphinx
mkdir -p documentos_referencia/
mkdir -p documentos_referencia/markdown_originales/
mkdir -p documentos_referencia/analisis/

# Verificar
tree -L 2 documentos_referencia/
```

### 1.4 Mover Documentos .md de Apoyo

```bash
# Mover archivos .md que NO van en el proyecto
# (Si tienes estos archivos en el directorio actual)

mv ANALISIS_*.md documentos_referencia/analisis/ 2>/dev/null || true
mv PLAN_*.md documentos_referencia/analisis/ 2>/dev/null || true
mv ACCIONES_*.md documentos_referencia/analisis/ 2>/dev/null || true

# Verificar
ls -l documentos_referencia/analisis/
```

---

## FASE 2: INTEGRACIÓN DE ARCHIVOS RAÍZ

**Tiempo:** 10 minutos  
**Prioridad:** ALTA

### 2.1 Copiar Archivos Actualizados a source/

```bash
# Asegúrate de estar en el directorio del proyecto
cd /d/Estadia_IACT/proyecto/documentacion/

# Copiar los 4 archivos raíz actualizados
cp readme.rst source/
cp prerequisites.rst source/
cp authors.rst source/
cp licence.rst source/

# Verificar que se copiaron
ls -l source/*.rst | grep -E "(readme|prerequisites|authors|licence)"
```

**Resultado esperado:**
```
-rw-r--r-- 1 user group  5234 Jan 07 16:30 source/authors.rst
-rw-r--r-- 1 user group  3456 Jan 07 16:30 source/licence.rst
-rw-r--r-- 1 user group 14567 Jan 07 16:30 source/prerequisites.rst
-rw-r--r-- 1 user group 12345 Jan 07 16:30 source/readme.rst
```

### 2.2 Actualizar source/index.rst

**Opción A: Reemplazar completo (Recomendado)**

```bash
# Hacer backup del actual
cp source/index.rst source/index.rst.backup_$(date +%Y%m%d)

# Reemplazar con versión actualizada
cp index_actualizado.rst source/index.rst
```

**Opción B: Editar manualmente**

```bash
# Abrir en editor
nano source/index.rst
# o
code source/index.rst
```

Agregar ANTES del primer `.. toctree::` (alrededor de la línea 32):

```rst
.. toctree::
   :maxdepth: 1
   :caption: Información General
   
   readme
   prerequisites
   authors
   licence

```

### 2.3 Verificación Rápida

```bash
# Build rápido para verificar
make clean
make html

# Verificar que no hay errores con los archivos raíz
make html 2>&1 | grep -E "(readme|prerequisites|authors|licence)"
```

---

## FASE 3: CONVERSIÓN DE DOCUMENTOS GRANDES

**Tiempo:** 2-3 horas  
**Prioridad:** ALTA

### 3.1 Preparar Directorio de Trabajo

```bash
# Crear directorio temporal
mkdir -p /tmp/iact_conversion
cd /tmp/iact_conversion

# Copiar archivos fuente
cp /d/Estadia_IACT/proyecto/MODELO_DOCUMENTAL_*.md .
cp /d/Estadia_IACT/proyecto/ANEXO_A_*.md .
cp /d/Estadia_IACT/proyecto/RESTRICCIONES_*.md .
cp /d/Estadia_IACT/proyecto/MODELO_RBAC_*.md .
```

### 3.2 Documento 1: MODELO_DOCUMENTAL_v2_2_0

```bash
# Paso 1: Unir las 2 partes
cat MODELO_DOCUMENTAL_IACT_v2_2_0_PARTE1.md \
    MODELO_DOCUMENTAL_IACT_v2_2_0_PARTE2.md \
    > modelo_documental_combined.md

# Paso 2: Convertir a RST
pandoc -f markdown -t rst \
    --standalone \
    --toc \
    --columns=100 \
    modelo_documental_combined.md \
    -o modelo_documental_v2_2_0.rst

# Paso 3: Verificar conversión
head -50 modelo_documental_v2_2_0.rst

# Paso 4: Revisar manualmente
nano modelo_documental_v2_2_0.rst

# Cosas a verificar:
# - Encabezados tienen el formato correcto (=== y ---)
# - Tablas están bien formateadas
# - Bloques de código tienen .. code-block:: directive
# - No hay caracteres extraños
```

**Ajustes manuales comunes:**

```rst
# ANTES (incorrecto):
# Título
===

# DESPUÉS (correcto):
Título
======

# ANTES (incorrecto):
## Subtítulo
---

# DESPUÉS (correcto):
Subtítulo
---------
```

### 3.3 Documento 2: ANEXO_A_ARBOL_COMPLETO

```bash
# Paso 1: Unir partes
cat ANEXO_A_ARBOL_COMPLETO_PARTE1.md \
    ANEXO_A_ARBOL_COMPLETO_PARTE2.md \
    > anexo_a_combined.md

# Paso 2: Convertir
pandoc -f markdown -t rst \
    --standalone \
    --columns=100 \
    anexo_a_combined.md \
    -o anexo_a_arbol_v2_2_0.rst

# Paso 3: Revisar
nano anexo_a_arbol_v2_2_0.rst
```

### 3.4 Documento 3: RESTRICCIONES_COMPLETAS

```bash
# Convertir directamente (archivo único)
pandoc -f markdown -t rst \
    --standalone \
    --toc \
    --columns=100 \
    RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md \
    -o restricciones_sistema_v1_0_0.rst

# Revisar
nano restricciones_sistema_v1_0_0.rst
```

### 3.5 Documento 4: MODELO_RBAC

```bash
# Convertir
pandoc -f markdown -t rst \
    --standalone \
    --toc \
    --columns=100 \
    MODELO_RBAC_IACT_v5_1_1.md \
    -o modelo_rbac_v5_1_1.rst

# Revisar
nano modelo_rbac_v5_1_1.rst
```

### 3.6 Copiar a Ubicaciones Finales

```bash
# Volver al proyecto
cd /d/Estadia_IACT/proyecto/documentacion/

# Copiar documentos convertidos
cp /tmp/iact_conversion/modelo_documental_v2_2_0.rst \
   source/normativa/estandares/

cp /tmp/iact_conversion/anexo_a_arbol_v2_2_0.rst \
   source/normativa/estandares/

cp /tmp/iact_conversion/restricciones_sistema_v1_0_0.rst \
   source/normativa/restricciones/

cp /tmp/iact_conversion/modelo_rbac_v5_1_1.rst \
   source/base_cognitiva/

# Verificar
ls -l source/normativa/estandares/*.rst
ls -l source/normativa/restricciones/*.rst
ls -l source/base_cognitiva/*.rst
```

---

## FASE 4: CONVERSIÓN DE ARCHIVOS .md DEL PROYECTO

**Tiempo:** 1-2 horas  
**Prioridad:** MEDIA

### 4.1 Usar Script Automatizado (Recomendado)

```bash
# Copiar script a la raíz del proyecto
cp script_conversion_masiva.sh /d/Estadia_IACT/proyecto/documentacion/

# Ejecutar
cd /d/Estadia_IACT/proyecto/documentacion/
./script_conversion_masiva.sh
```

### 4.2 O Conversión Manual por Directorio

#### 4.2.1 Arquitectura Técnica

```bash
cd source/arquitectura_tecnica/arquitectura/

# Convertir todos los .md
for file in *.md; do
    echo "Convirtiendo: $file"
    pandoc -f markdown -t rst "$file" -o "${file%.md}.rst"
done

# Convertir en subdirectorios
cd patrones/
for file in *.md; do
    pandoc -f markdown -t rst "$file" -o "${file%.md}.rst"
done

cd ../..
```

#### 4.2.2 Base Cognitiva

```bash
cd source/base_cognitiva/

# Convertir archivos individuales
pandoc -f markdown -t rst glosario_babok_pmbok_iso.md \
    -o glosario_babok_pmbok_iso.rst

pandoc -f markdown -t rst glossary.md \
    -o glossary.rst

cd ..
```

#### 4.2.3 Gestión

```bash
cd source/gestion/

pandoc -f markdown -t rst plantilla_adr.md \
    -o plantilla_adr.rst

cd ..
```

#### 4.2.4 Requisitos No Funcionales

```bash
cd source/requisitos/requisitos_no_funcionales/

for file in *.md; do
    pandoc -f markdown -t rst "$file" -o "${file%.md}.rst"
done

cd ../..
```

---

## FASE 5: ACTUALIZACIÓN DE ÍNDICES

**Tiempo:** 1 hora  
**Prioridad:** MEDIA

### 5.1 Actualizar normativa/estandares/index.rst

```bash
nano source/normativa/estandares/index.rst
```

**Agregar:**

```rst
.. toctree::
   :maxdepth: 2
   :caption: Documentación del Modelo
   
   modelo_documental_v2_2_0
   anexo_a_arbol_v2_2_0
```

### 5.2 Actualizar normativa/restricciones/index.rst

```bash
nano source/normativa/restricciones/index.rst
```

**Agregar:**

```rst
.. toctree::
   :maxdepth: 2
   
   restricciones_sistema_v1_0_0
```

### 5.3 Actualizar base_cognitiva/index.rst

```bash
nano source/base_cognitiva/index.rst
```

**Agregar:**

```rst
.. toctree::
   :maxdepth: 2
   :caption: Modelos y Fundamentos
   
   modelo_rbac_v5_1_1
   IACT_Glossary_v1_0_0
   glosario_babok_pmbok_iso
   glossary
```

### 5.4 Actualizar Otros Índices Afectados

Para cada directorio donde convertiste archivos .md, actualiza su index.rst:

```bash
# Ejemplo: arquitectura_tecnica/arquitectura/index.rst
nano source/arquitectura_tecnica/arquitectura/index.rst
```

Cambiar referencias de `.md` a `.rst`:

```rst
# ANTES:
.. toctree::
   
   README
   STORAGE_ARCHITECTURE

# DESPUÉS:
.. toctree::
   
   README
   STORAGE_ARCHITECTURE
```

---

## FASE 6: ACTUALIZACIÓN DE conf.py

**Tiempo:** 15 minutos  
**Prioridad:** MEDIA

### 6.1 Editar conf.py

```bash
nano source/conf.py
```

### 6.2 Comentar/Eliminar MyST Parser

**Buscar en extensions:**

```python
extensions = [
    # ... otras extensiones ...
    # 'myst_parser',  # ← COMENTAR o ELIMINAR
    # ... más extensiones ...
]
```

### 6.3 Eliminar Configuración MyST

**Buscar y eliminar/comentar:**

```python
# ELIMINAR O COMENTAR esta sección completa:
# myst_enable_extensions = [
#     "colon_fence",
#     "deflist",
#     "tasklist",
# ]
```

### 6.4 Actualizar source_suffix

```python
# Cambiar de:
source_suffix = '.rst'

# A (más explícito):
source_suffix = {
    '.rst': 'restructuredtext',
}
```

### 6.5 Guardar y Verificar

```bash
# Guardar archivo (Ctrl+X, Y, Enter en nano)

# Verificar sintaxis Python
python -m py_compile source/conf.py

# Si no hay errores, está bien
echo $?  # Debe mostrar 0
```

---

## FASE 7: LIMPIEZA FINAL

**Tiempo:** 30 minutos  
**Prioridad:** BAJA (pero recomendado)

### 7.1 Verificar Archivos .md Convertidos

```bash
# Listar todos los .md que quedan en source/
find source/ -name "*.md" -type f

# Verificar que todos tienen su .rst equivalente
for md in $(find source/ -name "*.md"); do
    rst="${md%.md}.rst"
    if [ -f "$rst" ]; then
        echo "✓ $md → $rst"
    else
        echo "✗ FALTA: $rst para $md"
    fi
done
```

### 7.2 Eliminar Archivos .md de source/

**IMPORTANTE:** Solo hacer después de verificar que todo funciona.

```bash
# Listar primero
find source/ -name "*.md" -type f > /tmp/md_files_to_delete.txt
cat /tmp/md_files_to_delete.txt

# Revisar la lista cuidadosamente

# Si todo está bien, eliminar
find source/ -name "*.md" -type f -delete

# Verificar que se eliminaron
find source/ -name "*.md" -type f
# No debe mostrar nada
```

### 7.3 Actualizar .gitignore

```bash
nano .gitignore
```

**Agregar:**

```gitignore
# Prevenir archivos Markdown en el proyecto
source/**/*.md

# Documentos de referencia (fuera de source/)
documentos_referencia/

# Archivos temporales de conversión
/tmp/iact_conversion/
```

### 7.4 Eliminar .readthedocs.yaml

```bash
# Como es proyecto interno
rm .readthedocs.yaml

# Verificar
ls -la | grep readthedocs
# No debe mostrar nada
```

---

## FASE 8: VERIFICACIÓN COMPLETA

**Tiempo:** 30 minutos  
**Prioridad:** ALTA

### 8.1 Build Limpio

```bash
# Limpiar build anterior
make clean

# Build completo
make html 2>&1 | tee build_log.txt
```

### 8.2 Analizar Warnings y Errores

```bash
# Contar errores
grep -c "ERROR" build_log.txt

# Contar warnings
grep -c "WARNING" build_log.txt

# Ver errores específicos
grep "ERROR" build_log.txt

# Ver warnings específicos
grep "WARNING" build_log.txt | head -20
```

**Errores esperados:** 0  
**Warnings esperados:** ~250-290 (UCs pendientes - normal)

### 8.3 Verificar Enlaces Internos

```bash
# Verificar enlaces rotos
make linkcheck 2>&1 | tee linkcheck_log.txt

# Revisar resultados
grep -E "(broken|redirect)" linkcheck_log.txt
```

### 8.4 Verificar en Navegador

```bash
# Iniciar servidor con live reload
make livehtml
```

**Abrir:** http://127.0.0.1:8000

**Checklist visual:**

- [ ] Menú lateral muestra "Información General"
- [ ] Los 4 archivos raíz son accesibles
- [ ] Documentos grandes aparecen en sus secciones
- [ ] No hay errores de rendering
- [ ] Tablas se ven correctamente
- [ ] Bloques de código tienen highlighting
- [ ] Navegación funciona (links internos)
- [ ] Búsqueda funciona
- [ ] Imágenes se muestran (si hay)

### 8.5 Verificar Búsqueda

En http://127.0.0.1:8000:

1. Usar la barra de búsqueda
2. Buscar: "RBAC"
3. Debe encontrar el documento modelo_rbac_v5_1_1
4. Buscar: "restricciones"
5. Debe encontrar restricciones_sistema_v1_0_0

### 8.6 Generar Reporte Final

```bash
cat > /tmp/reporte_implementacion.txt << 'EOF'
REPORTE DE IMPLEMENTACIÓN - SPHINX IACT
========================================

Fecha: $(date)

ARCHIVOS PROCESADOS:
-------------------
$(find source/ -name "*.rst" | wc -l) archivos .rst en total

ARCHIVOS .md RESTANTES:
----------------------
$(find source/ -name "*.md" | wc -l) archivos .md

BUILD STATUS:
------------
Errores: $(grep -c "ERROR" build_log.txt || echo 0)
Warnings: $(grep -c "WARNING" build_log.txt || echo 0)

DOCUMENTOS GRANDES:
------------------
$(ls -lh source/normativa/estandares/modelo_documental_v2_2_0.rst 2>/dev/null && echo "✓ MODELO_DOCUMENTAL" || echo "✗ MODELO_DOCUMENTAL falta")
$(ls -lh source/normativa/estandares/anexo_a_arbol_v2_2_0.rst 2>/dev/null && echo "✓ ANEXO_A" || echo "✗ ANEXO_A falta")
$(ls -lh source/normativa/restricciones/restricciones_sistema_v1_0_0.rst 2>/dev/null && echo "✓ RESTRICCIONES" || echo "✗ RESTRICCIONES falta")
$(ls -lh source/base_cognitiva/modelo_rbac_v5_1_1.rst 2>/dev/null && echo "✓ MODELO_RBAC" || echo "✗ MODELO_RBAC falta")

ARCHIVOS RAÍZ:
-------------
$(ls -lh source/readme.rst 2>/dev/null && echo "✓ readme.rst" || echo "✗ readme.rst falta")
$(ls -lh source/prerequisites.rst 2>/dev/null && echo "✓ prerequisites.rst" || echo "✗ prerequisites.rst falta")
$(ls -lh source/authors.rst 2>/dev/null && echo "✓ authors.rst" || echo "✗ authors.rst falta")
$(ls -lh source/licence.rst 2>/dev/null && echo "✓ licence.rst" || echo "✗ licence.rst falta")

EOF

cat /tmp/reporte_implementacion.txt
```

---

## CHECKLIST FINAL

### Pre-Implementación
- [ ] Pandoc instalado
- [ ] Backup del proyecto creado
- [ ] Carpeta documentos_referencia/ creada

### Implementación
- [ ] 4 archivos raíz copiados a source/
- [ ] source/index.rst actualizado
- [ ] 4 documentos grandes convertidos a .rst
- [ ] Archivos .md del proyecto convertidos
- [ ] Índices de subdominios actualizados
- [ ] conf.py actualizado (sin MyST)
- [ ] Archivos .md eliminados de source/
- [ ] .gitignore actualizado
- [ ] .readthedocs.yaml eliminado

### Verificación
- [ ] make clean ejecutado
- [ ] make html sin errores
- [ ] Warnings solo de UCs pendientes
- [ ] make linkcheck ejecutado
- [ ] Navegación funciona en navegador
- [ ] Búsqueda funciona
- [ ] Todos los documentos accesibles

---

## SOPORTE Y TROUBLESHOOTING

### Problema: pandoc no convierte tablas correctamente

**Solución:**
```bash
# Usar formato de tabla más compatible
pandoc -f markdown+pipe_tables -t rst archivo.md -o archivo.rst
```

### Problema: Caracteres especiales mal convertidos

**Solución:**
```bash
# Especificar encoding UTF-8
pandoc -f markdown -t rst --from=markdown+tex_math_dollars \
    --to=rst --standalone --columns=100 archivo.md -o archivo.rst
```

### Problema: Build falla después de actualizar conf.py

**Solución:**
```bash
# Verificar sintaxis Python
python -c "import source.conf"

# Si hay error, revisar:
# 1. Comillas balanceadas
# 2. Comas en listas
# 3. Paréntesis/corchetes cerrados
```

### Problema: Enlaces internos no funcionan

**Solución:**
En archivos .rst convertidos, cambiar:

```rst
# ANTES:
[texto](../otro/archivo.md)

# DESPUÉS:
:doc:`texto </otro/archivo>`
```

---

**FIN DE LA GUÍA**

¡Buena suerte con la implementación! 🚀

