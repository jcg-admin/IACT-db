---
id: TASK-REORG-BACK-009
tipo: tarea
categoria: reorganizacion
titulo: Crear INDICE_ADRs.md
fase: FASE_2
prioridad: MEDIA
duracion_estimada: 10min
estado: pendiente
dependencias:
 - TASK-007
 - TASK-008
---

# TASK-REORG-BACK-009: Crear INDICE_ADRs.md

**Fase:** FASE 2 - Reorganizacion Critica (Subcarpeta adr/)
**Prioridad:** MEDIA
**Duracion Estimada:** 10 minutos
**Responsable:** Tech Writer
**Estado:** PENDIENTE

---

## Objetivo

Crear un indice centralizado de todos los ADRs (Architecture Decision Records) del backend, facilitando la navegacion y consulta de decisiones arquitectonicas documentadas.

---

## Prerequisitos

- [ ] TASK-007 completada (ADRs creados)
- [ ] TASK-008 completada (metadatos YAML validados)
- [ ] Carpeta `/home/user/IACT/docs/backend/adr/` existe con ADRs
- [ ] ADRs tienen metadatos YAML validos

---

## Pasos de Ejecucion

### Paso 1: Crear Estructura Base del Indice

```bash
# Crear archivo INDICE_ADRs.md
cat > /home/user/IACT/docs/backend/adr/INDICE_ADRs.md << 'EOF'
---
id: INDICE-ADRs-BACKEND
tipo: indice
categoria: arquitectura
titulo: Indice de Architecture Decision Records - Backend
version: 1.0.0
fecha_creacion: 2025-11-18
estado: activo
---

# Indice de Architecture Decision Records - Backend

Este documento contiene el indice completo de todas las decisiones arquitectonicas documentadas para el backend del proyecto.

**Ultima actualizacion:** 2025-11-18
**Total ADRs:** [PENDIENTE]

---

## Que es un ADR?

Un Architecture Decision Record (ADR) es un documento que captura una decision arquitectonica importante, junto con su contexto y consecuencias. Los ADRs ayudan a:

- Entender por que se tomaron ciertas decisiones
- Documentar alternativas consideradas
- Facilitar onboarding de nuevos desarrolladores
- Mantener historial de evolucio arquitectonica

---

## Convenciones

- **ID:** ADR-BACK-XXX (numeracion secuencial)
- **Estado:** aceptada | propuesta | rechazada | deprecada | supersedida
- **Categoria:** arquitectura | tecnologia | bd | api | seguridad

---

## Indice por ID

| ID | Titulo | Categoria | Estado | Fecha | Archivo |
|----|--------|-----------|--------|-------|---------|
| [ID] | [Titulo] | [Cat] | [Estado] | YYYY-MM-DD | [ADR-BACK-XXX-nombre.md](./ADR-BACK-XXX-nombre.md) |

---

## Indice por Categoria

### Arquitectura
- [ADR-BACK-XXX: Titulo](./ADR-BACK-XXX-nombre.md) - Estado: [estado]

### Tecnologia
- [ADR-BACK-XXX: Titulo](./ADR-BACK-XXX-nombre.md) - Estado: [estado]

### Base de Datos
- [ADR-BACK-XXX: Titulo](./ADR-BACK-XXX-nombre.md) - Estado: [estado]

### APIs
- [ADR-BACK-XXX: Titulo](./ADR-BACK-XXX-nombre.md) - Estado: [estado]

### Seguridad
- [ADR-BACK-XXX: Titulo](./ADR-BACK-XXX-nombre.md) - Estado: [estado]

---

## Indice por Estado

### Aceptadas
- [ADR-BACK-XXX: Titulo](./ADR-BACK-XXX-nombre.md) - Categoria: [cat]

### Propuestas
- (ninguna)

### Deprecadas
- (ninguna)

### Supersedidas
- (ninguna)

### Rechazadas
- (ninguna)

---

## Estadisticas

- **Total ADRs:** [X]
- **Aceptadas:** [X]
- **Propuestas:** [X]
- **Deprecadas:** [X]
- **Supersedidas:** [X]
- **Rechazadas:** [X]

**Por Categoria:**
- Arquitectura: [X]
- Tecnologia: [X]
- Base de Datos: [X]
- APIs: [X]
- Seguridad: [X]

---

## Como Crear un Nuevo ADR

1. Usar plantilla en `docs/backend/plantillas/plantilla-adr-backend.md`
2. Asignar siguiente ID secuencial (ADR-BACK-XXX)
3. Completar todas las secciones obligatorias
4. Agregar metadatos YAML
5. Guardar en `docs/backend/adr/`
6. Actualizar este indice

---

## Referencias

- [Plantilla ADR Backend](../plantillas/plantilla-adr-backend.md)
- [Documentacion ADRs](https://adr.github.io/)
- [Michael Nygard ADR Template](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions)

---

**Documento creado:** 2025-11-18
**Ultima actualizacion:** 2025-11-18
**Version:** 1.0.0
EOF

echo "OK INDICE_ADRs.md creado (estructura base)"
```

**Resultado Esperado:** Archivo INDICE_ADRs.md creado con estructura

### Paso 2: Extraer Informacion de ADRs

```bash
# Script para extraer metadatos de cada ADR
cat > /tmp/extract-adr-metadata.sh << 'SCRIPT'
#!/bin/bash

# Crear archivo temporal para datos
> /tmp/adr-data.txt

for adr in /home/user/IACT/docs/backend/adr/ADR-BACK-*.md; do
 [ -f "$adr" ] || continue

 filename=$(basename "$adr")

 # Extraer YAML frontmatter
 yaml_content=$(sed -n '/^---$/,/^---$/p' "$adr" | sed '1d;$d')

 # Extraer campos
 id=$(echo "$yaml_content" | grep "^id:" | cut -d':' -f2 | xargs)
 titulo=$(echo "$yaml_content" | grep "^titulo:" | cut -d':' -f2- | xargs)
 categoria=$(echo "$yaml_content" | grep "^categoria:" | cut -d':' -f2 | xargs)
 estado=$(echo "$yaml_content" | grep "^estado:" | cut -d':' -f2 | xargs)
 fecha=$(echo "$yaml_content" | grep "^fecha:" | cut -d':' -f2 | xargs)

 # Guardar en formato CSV
 echo "$id|$titulo|$categoria|$estado|$fecha|$filename" >> /tmp/adr-data.txt
done

# Ordenar por ID
sort /tmp/adr-data.txt > /tmp/adr-data-sorted.txt

echo "Metadatos extraidos de $(wc -l < /tmp/adr-data-sorted.txt) ADRs"
cat /tmp/adr-data-sorted.txt
SCRIPT

chmod +x /tmp/extract-adr-metadata.sh
/tmp/extract-adr-metadata.sh | tee /home/user/IACT/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-009-crear-indice-adrs/evidencias/metadatos-extraidos.txt
```

**Resultado Esperado:** Archivo con metadatos de todos los ADRs

### Paso 3: Generar Tabla "Indice por ID"

```bash
# Generar tabla de indice por ID
cat > /tmp/generate-index-by-id.sh << 'SCRIPT'
#!/bin/bash

echo "| ID | Titulo | Categoria | Estado | Fecha | Archivo |"
echo "|----|--------|-----------|--------|-------|---------|"

while IFS='|' read -r id titulo categoria estado fecha filename; do
 # Convertir categoria a capitalize
 cat_display=$(echo "$categoria" | sed 's/bd/Base de Datos/; s/api/APIs/; s/\b\(.\)/\u\1/g')

 # Generar link relativo
 link="./$filename"

 echo "| $id | $titulo | $cat_display | $estado | $fecha | [$filename]($link) |"
done < /tmp/adr-data-sorted.txt
SCRIPT

chmod +x /tmp/generate-index-by-id.sh
/tmp/generate-index-by-id.sh > /tmp/tabla-indice-id.md

cat /tmp/tabla-indice-id.md | tee /home/user/IACT/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-009-crear-indice-adrs/evidencias/tabla-indice-id.md
```

**Resultado Esperado:** Tabla markdown con ADRs por ID

### Paso 4: Generar Seccion "Indice por Categoria"

```bash
# Generar indice por categoria
cat > /tmp/generate-index-by-category.sh << 'SCRIPT'
#!/bin/bash

declare -A categorias
categorias[arquitectura]="Arquitectura"
categorias[tecnologia]="Tecnologia"
categorias[bd]="Base de Datos"
categorias[api]="APIs"
categorias[seguridad]="Seguridad"

for cat_key in arquitectura tecnologia bd api seguridad; do
 cat_name="${categorias[$cat_key]}"
 echo "### $cat_name"

 found=false
 while IFS='|' read -r id titulo categoria estado fecha filename; do
 if [ "$categoria" = "$cat_key" ]; then
 echo "- [$id: $titulo](./$filename) - Estado: $estado"
 found=true
 fi
 done < /tmp/adr-data-sorted.txt

 if ! $found; then
 echo "- (ninguna)"
 fi

 echo ""
done
SCRIPT

chmod +x /tmp/generate-index-by-category.sh
/tmp/generate-index-by-category.sh > /tmp/indice-por-categoria.md

cat /tmp/indice-por-categoria.md | tee /home/user/IACT/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-009-crear-indice-adrs/evidencias/indice-por-categoria.md
```

**Resultado Esperado:** Indice organizado por categoria

### Paso 5: Generar Seccion "Indice por Estado"

```bash
# Generar indice por estado
cat > /tmp/generate-index-by-status.sh << 'SCRIPT'
#!/bin/bash

declare -A estados
estados[aceptada]="Aceptadas"
estados[propuesta]="Propuestas"
estados[deprecada]="Deprecadas"
estados[supersedida]="Supersedidas"
estados[rechazada]="Rechazadas"

for estado_key in aceptada propuesta deprecada supersedida rechazada; do
 estado_name="${estados[$estado_key]}"
 echo "### $estado_name"

 found=false
 while IFS='|' read -r id titulo categoria estado fecha filename; do
 if [ "$estado" = "$estado_key" ]; then
 echo "- [$id: $titulo](./$filename) - Categoria: $categoria"
 found=true
 fi
 done < /tmp/adr-data-sorted.txt

 if ! $found; then
 echo "- (ninguna)"
 fi

 echo ""
done
SCRIPT

chmod +x /tmp/generate-index-by-status.sh
/tmp/generate-index-by-status.sh > /tmp/indice-por-estado.md

cat /tmp/indice-por-estado.md | tee /home/user/IACT/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-009-crear-indice-adrs/evidencias/indice-por-estado.md
```

**Resultado Esperado:** Indice organizado por estado

### Paso 6: Generar Estadisticas

```bash
# Generar estadisticas
cat > /tmp/generate-statistics.sh << 'SCRIPT'
#!/bin/bash

total=$(wc -l < /tmp/adr-data-sorted.txt)

# Por estado
aceptadas=$(grep -c "|aceptada|" /tmp/adr-data-sorted.txt || echo 0)
propuestas=$(grep -c "|propuesta|" /tmp/adr-data-sorted.txt || echo 0)
deprecadas=$(grep -c "|deprecada|" /tmp/adr-data-sorted.txt || echo 0)
supersedidas=$(grep -c "|supersedida|" /tmp/adr-data-sorted.txt || echo 0)
rechazadas=$(grep -c "|rechazada|" /tmp/adr-data-sorted.txt || echo 0)

# Por categoria
cat_arquitectura=$(grep -c "|arquitectura|" /tmp/adr-data-sorted.txt || echo 0)
cat_tecnologia=$(grep -c "|tecnologia|" /tmp/adr-data-sorted.txt || echo 0)
cat_bd=$(grep -c "|bd|" /tmp/adr-data-sorted.txt || echo 0)
cat_api=$(grep -c "|api|" /tmp/adr-data-sorted.txt || echo 0)
cat_seguridad=$(grep -c "|seguridad|" /tmp/adr-data-sorted.txt || echo 0)

cat << EOF
- **Total ADRs:** $total
- **Aceptadas:** $aceptadas
- **Propuestas:** $propuestas
- **Deprecadas:** $deprecadas
- **Supersedidas:** $supersedidas
- **Rechazadas:** $rechazadas

**Por Categoria:**
- Arquitectura: $cat_arquitectura
- Tecnologia: $cat_tecnologia
- Base de Datos: $cat_bd
- APIs: $cat_api
- Seguridad: $cat_seguridad
EOF
SCRIPT

chmod +x /tmp/generate-statistics.sh
/tmp/generate-statistics.sh > /tmp/estadisticas.txt

cat /tmp/estadisticas.txt | tee /home/user/IACT/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-009-crear-indice-adrs/evidencias/estadisticas.txt
```

**Resultado Esperado:** Estadisticas de ADRs

### Paso 7: Ensamblar INDICE_ADRs.md Final

```bash
# Actualizar INDICE_ADRs.md con contenido generado
# Nota: Este paso requiere edicion manual para insertar las secciones generadas

echo "Los siguientes archivos estan listos para insertar en INDICE_ADRs.md:"
echo "1. /tmp/tabla-indice-id.md - Reemplazar seccion 'Indice por ID'"
echo "2. /tmp/indice-por-categoria.md - Reemplazar seccion 'Indice por Categoria'"
echo "3. /tmp/indice-por-estado.md - Reemplazar seccion 'Indice por Estado'"
echo "4. /tmp/estadisticas.txt - Reemplazar seccion 'Estadisticas'"

# Guardar script de ensamblaje para referencia futura
cat > /home/user/IACT/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-009-crear-indice-adrs/evidencias/script-ensamblar-indice.sh << 'SCRIPT'
#!/bin/bash
# Script para re-generar INDICE_ADRs.md en futuras actualizaciones

# 1. Extraer metadatos
/tmp/extract-adr-metadata.sh

# 2. Generar secciones
/tmp/generate-index-by-id.sh > /tmp/tabla-indice-id.md
/tmp/generate-index-by-category.sh > /tmp/indice-por-categoria.md
/tmp/generate-index-by-status.sh > /tmp/indice-por-estado.md
/tmp/generate-statistics.sh > /tmp/estadisticas.txt

# 3. Ensamblar (requiere edicion manual de template)
echo "Secciones generadas - Insertar manualmente en INDICE_ADRs.md"
SCRIPT

chmod +x /home/user/IACT/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-009-crear-indice-adrs/evidencias/script-ensamblar-indice.sh

echo "OK Archivos de evidencias creados"
echo "OK Script de ensamblaje guardado en evidencias/"
```

**Resultado Esperado:** Secciones generadas listas para ensamblar

### Paso 8: Validar INDICE_ADRs.md

```bash
# Validar que el indice existe y tiene contenido
test -f /home/user/IACT/docs/backend/adr/INDICE_ADRs.md && echo "OK INDICE_ADRs.md existe" || echo " Falta INDICE_ADRs.md"

# Validar que tiene frontmatter YAML
head -n 1 /home/user/IACT/docs/backend/adr/INDICE_ADRs.md | grep -q "^---$" && echo "OK Tiene frontmatter YAML" || echo " Falta YAML"

# Validar que tiene las secciones principales
grep -q "## Indice por ID" /home/user/IACT/docs/backend/adr/INDICE_ADRs.md && echo "OK Seccion Indice por ID" || echo " Falta seccion"
grep -q "## Indice por Categoria" /home/user/IACT/docs/backend/adr/INDICE_ADRs.md && echo "OK Seccion Indice por Categoria" || echo " Falta seccion"
grep -q "## Indice por Estado" /home/user/IACT/docs/backend/adr/INDICE_ADRs.md && echo "OK Seccion Indice por Estado" || echo " Falta seccion"
grep -q "## Estadisticas" /home/user/IACT/docs/backend/adr/INDICE_ADRs.md && echo "OK Seccion Estadisticas" || echo " Falta seccion"

# Contar links a ADRs
link_count=$(grep -c "ADR-BACK-" /home/user/IACT/docs/backend/adr/INDICE_ADRs.md || echo 0)
echo "Links a ADRs encontrados: $link_count"
```

**Resultado Esperado:** INDICE_ADRs.md valido con todas las secciones

---

## Criterios de Exito

- [ ] Archivo `INDICE_ADRs.md` creado en `/home/user/IACT/docs/backend/adr/`
- [ ] Indice tiene frontmatter YAML con metadatos
- [ ] Seccion "Indice por ID" con tabla de todos los ADRs
- [ ] Seccion "Indice por Categoria" con ADRs agrupados
- [ ] Seccion "Indice por Estado" con ADRs agrupados
- [ ] Seccion "Estadisticas" con conteos por estado y categoria
- [ ] Todos los links a ADRs son relativos y funcionales
- [ ] Total de ADRs en indice coincide con archivos en carpeta

---

## Validacion

```bash
# Validacion final
echo "=== VALIDACION INDICE_ADRs.md ==="

# Archivo existe
test -f /home/user/IACT/docs/backend/adr/INDICE_ADRs.md && echo "OK Archivo existe" || echo " Archivo no existe"

# Total ADRs en carpeta vs indice
adrs_carpeta=$(ls /home/user/IACT/docs/backend/adr/ADR-BACK-*.md 2>/dev/null | wc -l)
adrs_indice=$(grep -c "ADR-BACK-[0-9]" /home/user/IACT/docs/backend/adr/INDICE_ADRs.md || echo 0)

echo "ADRs en carpeta: $adrs_carpeta"
echo "ADRs en indice: $adrs_indice"

if [ $adrs_carpeta -eq $adrs_indice ]; then
 echo "OK Totales coinciden"
else
 echo " Totales NO coinciden"
fi

# Secciones principales
sections_found=0
grep -q "## Indice por ID" /home/user/IACT/docs/backend/adr/INDICE_ADRs.md && ((sections_found++))
grep -q "## Indice por Categoria" /home/user/IACT/docs/backend/adr/INDICE_ADRs.md && ((sections_found++))
grep -q "## Indice por Estado" /home/user/IACT/docs/backend/adr/INDICE_ADRs.md && ((sections_found++))
grep -q "## Estadisticas" /home/user/IACT/docs/backend/adr/INDICE_ADRs.md && ((sections_found++))

echo "Secciones encontradas: $sections_found/4"
test $sections_found -eq 4 && echo "OK Todas las secciones presentes" || echo " Faltan secciones"
```

**Salida Esperada:** Archivo existe, totales coinciden, 4/4 secciones presentes

---

## Rollback

Si es necesario recrear el indice:

```bash
# Eliminar INDICE_ADRs.md
rm /home/user/IACT/docs/backend/adr/INDICE_ADRs.md

# Reintentar desde Paso 1
```

---

## Riesgos

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|-----------|
| Links relativos rotos | BAJA | BAJO | Validar formato de links |
| Desincronizacion futura | ALTA | MEDIO | Documentar como actualizar indice |
| Errores en estadisticas | BAJA | BAJO | Validar con conteo manual |

---

## Evidencias a Capturar

1. `metadatos-extraidos.txt` - Metadatos de todos los ADRs
2. `tabla-indice-id.md` - Tabla generada de indice por ID
3. `indice-por-categoria.md` - Indice por categoria generado
4. `indice-por-estado.md` - Indice por estado generado
5. `estadisticas.txt` - Estadisticas de ADRs
6. `script-ensamblar-indice.sh` - Script para regenerar indice en futuro
7. Archivo `INDICE_ADRs.md` en `/home/user/IACT/docs/backend/adr/` (ENTREGABLE PRINCIPAL)

---

## Notas

- El INDICE_ADRs.md es un documento vivo que debe actualizarse cuando se agregan ADRs
- Los scripts en /tmp/ pueden guardarse permanentemente para automatizar actualizaciones
- Considerar crear un pre-commit hook para auto-actualizar indice
- El script-ensamblar-indice.sh facilita regeneracion futura del indice

---

## Tiempo de Ejecucion

**Inicio:** __:__
**Fin:** __:__
**Duracion Real:** __ minutos

---

## Checklist de Finalizacion

- [ ] INDICE_ADRs.md creado en docs/backend/adr/
- [ ] Indice tiene frontmatter YAML
- [ ] Tabla "Indice por ID" completa
- [ ] Seccion "Indice por Categoria" completa
- [ ] Seccion "Indice por Estado" completa
- [ ] Seccion "Estadisticas" completa
- [ ] Scripts de generacion ejecutados
- [ ] Validacion ejecutada exitosamente
- [ ] 6 archivos de evidencias generados
- [ ] Tarea marcada como COMPLETADA en INDICE.md

---

**Tarea creada:** 2025-11-18
**Ultima actualizacion:** 2025-11-18
**Version:** 1.0.0
**Estado:** PENDIENTE
