# ACCIONES INMEDIATAS - Integración Documentación IACT

**Fecha:** 2026-01-07  
**Prioridad:** ALTA

---

## SITUACIÓN ACTUAL

✅ **YA TIENES:**
- Sphinx 8.2.3 funcionando
- Build exitoso (294 warnings)
- Estructura de 5 dominios operativa
- conf.py y index.rst configurados

🔄 **NECESITAS ACTUALIZAR:**
- 4 archivos raíz (readme, prerequisites, authors, licence)

❌ **PROBLEMAS A CORREGIR:**
- 1 error de indentación
- 2 labels duplicados
- 290+ warnings de UCs pendientes (normal)

---

## ACCIONES REQUERIDAS AHORA

### 1. Reemplazar Archivos Raíz (5 minutos)

```bash
# Desde donde tengas los archivos descargados
cd /d/Estadia_IACT/proyecto/documentacion/

# Hacer backup de los actuales (opcional)
mkdir backup_$(date +%Y%m%d)
cp readme.rst authors.rst licence.rst prerequisites.rst backup_$(date +%Y%m%d)/

# Reemplazar con versiones actualizadas
cp /ruta/de/descarga/readme.rst .
cp /ruta/de/descarga/prerequisites.rst .
cp /ruta/de/descarga/authors.rst .
cp /ruta/de/descarga/licence.rst .
```

### 2. Corregir Error de Indentación (2 minutos)

**Archivo:** `source/requisitos/casos_uso/pipeline/index.rst`  
**Línea:** 3

Abre el archivo y verifica que no haya espacios/tabs incorrectos.

### 3. Corregir Label Duplicado (2 minutos)

**Archivo:** `source/normativa/gobernanza/GOB_05_Control_Versiones.rst`  
**Línea:** 12 y 200

Busca la línea que contiene:
```rst
.. _gobernanza-index:
```

Elimina o renombra uno de los labels duplicados.

### 4. Rebuild y Verificar (1 minuto)

```bash
make clean
make html
```

**Resultado esperado:** Warnings reducidos a ~290 (solo UCs faltantes).

---

## PREGUNTAS PARA TI

### A. Sobre `source/index.rst`

**Necesito ver tu archivo `source/index.rst` para saber:**
- ¿Cómo están referenciados actualmente readme, authors, etc.?
- ¿Desde la raíz (`../readme`) o desde source (`readme`)?

**Por favor comparte:**
```bash
cat source/index.rst
```

### B. Sobre Documentos Grandes

Tienes 4 documentos en Markdown:
1. MODELO_DOCUMENTAL_v2_2_0 (~800 líneas)
2. ANEXO_A_ARBOL_COMPLETO (~500 líneas)  
3. RESTRICCIONES_COMPLETAS (~1130 líneas)
4. MODELO_RBAC_v5_1_1 (~1650 líneas)

**Pregunta:** ¿Los quieres integrar como:
- **Opción A:** Dejarlos en Markdown (.md) - MyST los procesará
- **Opción B:** Convertirlos a RST (.rst) - más nativo Sphinx

**Mi recomendación:** Opción A (mantener .md) porque ya tienes MyST Parser.

### C. Sobre Estructura de Dominios

Tu estructura actual difiere ligeramente del Modelo Documental v2.2.0:

**Tu estructura:**
- `gestion/` (no está en modelo v2.2.0)
- `objetivos/` (modelo: `objetivos_negocio/`)
- `requisitos_funcionales/` (modelo: `funcionales/`)

**Pregunta:** ¿Prefieres:
- **Opción A:** Mantener tu nomenclatura actual (ya funciona)
- **Opción B:** Renombrar para seguir modelo v2.2.0
- **Opción C:** Crear alias/links

**Mi recomendación:** Opción A (mantener lo que tienes) y documentar las diferencias.

---

## DECISIONES PENDIENTES

| Decisión | Opciones | Recomendación |
|----------|----------|---------------|
| Formato docs grandes | A) .md B) .rst | **A) Mantener .md** |
| Nomenclatura subdominios | A) Actual B) Modelo v2.2.0 | **A) Mantener actual** |
| Dominio gestion/ | A) Mantener B) Renombrar | **A) Mantener** |
| Crear evidencia/ | A) Sí B) No | **A) Sí** (falta según modelo) |

---

## TIEMPO ESTIMADO

| Tarea | Tiempo |
|-------|--------|
| Reemplazar archivos raíz | 5 min |
| Corregir indentación | 2 min |
| Corregir label duplicado | 2 min |
| Rebuild y verificar | 1 min |
| **TOTAL** | **10 minutos** |

---

## SIGUIENTE FASE (después de lo anterior)

1. **Integrar documentos grandes** (~30 min)
2. **Crear subdominios faltantes** (~1 hora, opcional)
3. **Reducir warnings restantes** (~2 horas, crear UCs pendientes)

---

## COMANDOS RÁPIDOS

```bash
# Todo en uno (después de reemplazar archivos raíz)
cd /d/Estadia_IACT/proyecto/documentacion/
make clean
make html

# Si todo está bien, iniciar servidor
make livehtml
```

---

**CONTACTO INMEDIATO NECESARIO:**
1. Comparte tu `source/index.rst`
2. Decide sobre formato de documentos grandes
3. Ejecuta las 4 acciones inmediatas

