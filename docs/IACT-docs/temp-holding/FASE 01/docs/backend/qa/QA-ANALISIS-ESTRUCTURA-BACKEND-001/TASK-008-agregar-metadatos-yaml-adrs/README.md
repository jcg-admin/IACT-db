---
id: TASK-REORG-BACK-008
tipo: tarea
categoria: reorganizacion
titulo: Agregar Metadatos YAML a ADRs
fase: FASE_2
prioridad: MEDIA
duracion_estimada: 15min
estado: pendiente
dependencias:
 - TASK-007
---

# TASK-REORG-BACK-008: Agregar Metadatos YAML a ADRs

**Fase:** FASE 2 - Reorganizacion Critica (Subcarpeta adr/)
**Prioridad:** MEDIA
**Duracion Estimada:** 15 minutos
**Responsable:** Tech Writer
**Estado:** PENDIENTE

---

## Objetivo

Asegurar que todos los ADRs creados en TASK-007 tengan frontmatter YAML completo y consistente, validando que los metadatos sigan el esquema estandarizado del proyecto.

---

## Prerequisitos

- [ ] TASK-007 completada (5+ ADRs creados)
- [ ] ADRs existen en `/home/user/IACT/docs/backend/adr/`
- [ ] Conocimiento de formato YAML
- [ ] Acceso de escritura a archivos ADR

---

## Pasos de Ejecucion

### Self-Consistency: Esquema de Metadatos

**Razonamiento:** Usaremos Self-Consistency para validar que todos los ADRs tengan metadatos consistentes siguiendo el mismo esquema.

**Esquema YAML Estandar para ADRs:**
```yaml
---
id: ADR-BACK-XXX # Formato: ADR-BACK-001, ADR-BACK-002, etc.
tipo: adr # Siempre "adr"
categoria: [valor] # arquitectura|tecnologia|bd|api|seguridad
titulo: [Titulo Descriptivo] # Titulo corto sin "ADR-BACK-XXX:"
estado: [valor] # aceptada|propuesta|rechazada|deprecada|supersedida
fecha: YYYY-MM-DD # Fecha de la decision
autor: [Nombre o Equipo] # Quien tomo la decision
supersedida_por: ADR-BACK-XXX # (opcional) Si estado=supersedida
relacionada_con: [ADR-BACK-XXX, ...] # (opcional) ADRs relacionados
---
```

### Paso 1: Listar ADRs Existentes

```bash
# Listar todos los ADRs
ls -1 /home/user/IACT/docs/backend/adr/ADR-BACK-*.md | \
 tee /home/user/IACT/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-008-agregar-metadatos-yaml-adrs/evidencias/lista-adrs.txt

# Contar ADRs
adr_count=$(ls /home/user/IACT/docs/backend/adr/ADR-BACK-*.md 2>/dev/null | wc -l)
echo "Total ADRs a validar: $adr_count"
```

**Resultado Esperado:** Lista de 5+ ADRs

### Paso 2: Validar Existencia de Frontmatter YAML

```bash
# Validar que cada ADR tiene frontmatter YAML
for adr in /home/user/IACT/docs/backend/adr/ADR-BACK-*.md; do
 filename=$(basename "$adr")

 # Verificar que empieza con ---
 first_line=$(head -n 1 "$adr")
 if [ "$first_line" = "---" ]; then
 echo "OK $filename - Tiene frontmatter YAML"
 else
 echo " $filename - NO tiene frontmatter YAML"
 fi
done | tee /home/user/IACT/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-008-agregar-metadatos-yaml-adrs/evidencias/validacion-yaml-existencia.log
```

**Resultado Esperado:** Todos los ADRs tienen frontmatter YAML

### Paso 3: Validar Campos Obligatorios en YAML

**Self-Consistency Check:** Verificar que cada ADR tiene los 6 campos obligatorios.

```bash
# Validar campos obligatorios
cat > /tmp/validate-adr-yaml.sh << 'SCRIPT'
#!/bin/bash

adr_file="$1"
filename=$(basename "$adr_file")

echo "Validando: $filename"

# Extraer frontmatter YAML (entre primera y segunda ocurrencia de ---)
yaml_content=$(sed -n '/^---$/,/^---$/p' "$adr_file" | sed '1d;$d')

# Verificar cada campo obligatorio
fields=("id" "tipo" "categoria" "titulo" "estado" "fecha")
all_ok=true

for field in "${fields[@]}"; do
 if echo "$yaml_content" | grep -q "^${field}:"; then
 echo " OK Campo '$field' presente"
 else
 echo " Campo '$field' FALTA"
 all_ok=false
 fi
done

# Validar valores especificos
# tipo debe ser "adr"
tipo_value=$(echo "$yaml_content" | grep "^tipo:" | cut -d':' -f2 | xargs)
if [ "$tipo_value" = "adr" ]; then
 echo " OK tipo='adr' correcto"
else
 echo " tipo='$tipo_value' incorrecto (debe ser 'adr')"
 all_ok=false
fi

# categoria debe ser uno de los valores permitidos
categoria_value=$(echo "$yaml_content" | grep "^categoria:" | cut -d':' -f2 | xargs)
case "$categoria_value" in
 arquitectura|tecnologia|bd|api|seguridad)
 echo " OK categoria='$categoria_value' valida"
 ;;
 *)
 echo " categoria='$categoria_value' invalida"
 all_ok=false
 ;;
esac

# estado debe ser uno de los valores permitidos
estado_value=$(echo "$yaml_content" | grep "^estado:" | cut -d':' -f2 | xargs)
case "$estado_value" in
 aceptada|propuesta|rechazada|deprecada|supersedida)
 echo " OK estado='$estado_value' valido"
 ;;
 *)
 echo " estado='$estado_value' invalido"
 all_ok=false
 ;;
esac

# fecha debe tener formato YYYY-MM-DD
fecha_value=$(echo "$yaml_content" | grep "^fecha:" | cut -d':' -f2 | xargs)
if echo "$fecha_value" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'; then
 echo " OK fecha='$fecha_value' formato correcto"
else
 echo " fecha='$fecha_value' formato incorrecto (debe ser YYYY-MM-DD)"
 all_ok=false
fi

if $all_ok; then
 echo " OKOKOK $filename - YAML VALIDO"
else
 echo " $filename - YAML INVALIDO"
fi

echo ""
SCRIPT

chmod +x /tmp/validate-adr-yaml.sh

# Ejecutar validacion para cada ADR
for adr in /home/user/IACT/docs/backend/adr/ADR-BACK-*.md; do
 /tmp/validate-adr-yaml.sh "$adr"
done | tee /home/user/IACT/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-008-agregar-metadatos-yaml-adrs/evidencias/validacion-yaml-campos.log
```

**Resultado Esperado:** Todos los ADRs tienen 6 campos obligatorios con valores validos

### Paso 4: Generar Reporte de Metadatos

```bash
# Crear reporte consolidado de metadatos
cat > /home/user/IACT/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-008-agregar-metadatos-yaml-adrs/evidencias/reporte-metadatos.md << 'EOF'
# Reporte de Metadatos YAML - ADRs Backend

## Fecha Validacion
2025-11-18

## ADRs Validados

| Archivo | ID | Categoria | Estado | Fecha | YAML Valido |
|---------|-----|-----------|--------|-------|-------------|
| ADR-BACK-001-[nombre].md | ADR-BACK-001 | [cat] | [estado] | YYYY-MM-DD | OK / |
| ADR-BACK-002-[nombre].md | ADR-BACK-002 | [cat] | [estado] | YYYY-MM-DD | OK / |
| ADR-BACK-003-[nombre].md | ADR-BACK-003 | [cat] | [estado] | YYYY-MM-DD | OK / |
| ADR-BACK-004-[nombre].md | ADR-BACK-004 | [cat] | [estado] | YYYY-MM-DD | OK / |
| ADR-BACK-005-[nombre].md | ADR-BACK-005 | [cat] | [estado] | YYYY-MM-DD | OK / |

## Estadisticas

- **Total ADRs:** [X]
- **YAML Valido:** [X]
- **YAML Invalido:** [X]
- **Campos Faltantes:** [Lista de campos faltantes si existen]

## Distribucion por Categoria
- **arquitectura:** [X]
- **tecnologia:** [X]
- **bd:** [X]
- **api:** [X]
- **seguridad:** [X]

## Distribucion por Estado
- **aceptada:** [X]
- **propuesta:** [X]
- **rechazada:** [X]
- **deprecada:** [X]
- **supersedida:** [X]

## Campos Opcionales Usados
- **supersedida_por:** [X ADRs]
- **relacionada_con:** [X ADRs]
- **autor:** [X ADRs]

## Problemas Encontrados
- [ ] Ningun problema
- [ ] [Descripcion de problema 1]
- [ ] [Descripcion de problema 2]

## Acciones Correctivas
1. [Accion correctiva si hay problemas]

## Conclusion
- [ ] Todos los ADRs tienen metadatos YAML validos
- [ ] Todos los ADRs cumplen esquema estandarizado
- [ ] No se requieren correcciones

EOF

echo "Reporte de metadatos creado - Completar con datos reales"
```

**Resultado Esperado:** Archivo reporte-metadatos.md creado

### Paso 5: Verificar Consistencia de IDs

**Self-Consistency Check:** Verificar que los IDs en YAML coinciden con nombres de archivo.

```bash
# Validar consistencia ID YAML vs nombre archivo
for adr in /home/user/IACT/docs/backend/adr/ADR-BACK-*.md; do
 filename=$(basename "$adr")

 # Extraer ID del filename (ADR-BACK-XXX)
 id_from_file=$(echo "$filename" | grep -oE 'ADR-BACK-[0-9]+')

 # Extraer ID del YAML
 id_from_yaml=$(grep "^id:" "$adr" | cut -d':' -f2 | xargs)

 if [ "$id_from_file" = "$id_from_yaml" ]; then
 echo "OK $filename - ID consistente: $id_from_yaml"
 else
 echo " $filename - ID inconsistente: archivo=$id_from_file, YAML=$id_from_yaml"
 fi
done | tee /home/user/IACT/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-008-agregar-metadatos-yaml-adrs/evidencias/validacion-consistencia-ids.log
```

**Resultado Esperado:** Todos los IDs son consistentes entre archivo y YAML

### Paso 6: Validar Formato de Fechas

```bash
# Validar formato de fechas YYYY-MM-DD
for adr in /home/user/IACT/docs/backend/adr/ADR-BACK-*.md; do
 filename=$(basename "$adr")

 fecha=$(grep "^fecha:" "$adr" | cut -d':' -f2 | xargs)

 if echo "$fecha" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'; then
 echo "OK $filename - Fecha valida: $fecha"
 else
 echo " $filename - Fecha invalida: $fecha (debe ser YYYY-MM-DD)"
 fi
done | tee /home/user/IACT/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-008-agregar-metadatos-yaml-adrs/evidencias/validacion-fechas.log
```

**Resultado Esperado:** Todas las fechas tienen formato YYYY-MM-DD

### Paso 7: Crear Resumen de Validacion Final

```bash
# Consolidar todas las validaciones
cat > /home/user/IACT/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-008-agregar-metadatos-yaml-adrs/evidencias/resumen-validacion.txt << 'EOF'
=============================================================
RESUMEN VALIDACION METADATOS YAML - ADRs Backend
=============================================================
Fecha: 2025-11-18

VALIDACIONES EJECUTADAS:
1. Existencia de frontmatter YAML
2. Presencia de 6 campos obligatorios
3. Valores validos en tipo, categoria, estado
4. Formato de fecha YYYY-MM-DD
5. Consistencia ID archivo vs YAML

RESULTADOS:
- Total ADRs validados: [X]
- ADRs con YAML valido: [X]
- ADRs con problemas: [X]

ESTADO: [OK TODOS VALIDOS / HAY PROBLEMAS]

Ver archivos de evidencias para detalles:
- validacion-yaml-existencia.log
- validacion-yaml-campos.log
- validacion-consistencia-ids.log
- validacion-fechas.log
- reporte-metadatos.md

=============================================================
EOF

cat /home/user/IACT/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/TASK-008-agregar-metadatos-yaml-adrs/evidencias/resumen-validacion.txt
```

**Resultado Esperado:** Resumen consolidado de validaciones

---

## Criterios de Exito

- [ ] Todos los ADRs tienen frontmatter YAML
- [ ] Todos los ADRs tienen 6 campos obligatorios: id, tipo, categoria, titulo, estado, fecha
- [ ] Campo `tipo` es "adr" en todos los ADRs
- [ ] Campo `categoria` tiene valores validos: arquitectura/tecnologia/bd/api/seguridad
- [ ] Campo `estado` tiene valores validos: aceptada/propuesta/rechazada/deprecada/supersedida
- [ ] Campo `fecha` tiene formato YYYY-MM-DD
- [ ] IDs en YAML coinciden con nombres de archivo
- [ ] Se creo reporte-metadatos.md con estadisticas

---

## Validacion

```bash
# Validacion final automatizada
echo "=== VALIDACION FINAL METADATOS YAML ==="

# 1. Contar ADRs
total_adrs=$(ls /home/user/IACT/docs/backend/adr/ADR-BACK-*.md 2>/dev/null | wc -l)
echo "Total ADRs: $total_adrs"

# 2. Contar ADRs con YAML
adrs_con_yaml=$(grep -l "^---$" /home/user/IACT/docs/backend/adr/ADR-BACK-*.md 2>/dev/null | wc -l)
echo "ADRs con YAML: $adrs_con_yaml"

# 3. Verificar campos obligatorios en todos
echo "Verificando campos obligatorios..."
all_valid=true
for adr in /home/user/IACT/docs/backend/adr/ADR-BACK-*.md; do
 for field in id tipo categoria titulo estado fecha; do
 if ! grep -q "^${field}:" "$adr"; then
 echo " $(basename $adr) - Falta campo $field"
 all_valid=false
 fi
 done
done

if $all_valid; then
 echo "OK Todos los ADRs tienen campos obligatorios"
else
 echo " Algunos ADRs tienen campos faltantes"
fi

# 4. Resultado final
if [ $total_adrs -eq $adrs_con_yaml ] && $all_valid; then
 echo ""
 echo "OKOKOK VALIDACION EXITOSA - Todos los ADRs tienen metadatos YAML validos"
else
 echo ""
 echo " VALIDACION FALLIDA - Revisar logs de evidencias"
fi
```

**Salida Esperada:** VALIDACION EXITOSA - Todos los ADRs validos

---

## Rollback

Si se encuentran problemas en metadatos:

```bash
# No hay rollback necesario - solo corregir archivos con problemas
# Usar logs de evidencias para identificar archivos con errores

# Para corregir un ADR especifico:
# 1. Abrir archivo
# 2. Editar frontmatter YAML
# 3. Re-ejecutar validaciones (Pasos 2-6)

echo "Ver logs en evidencias/ para identificar archivos a corregir"
```

---

## Riesgos

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|-----------|
| Errores de sintaxis YAML | MEDIA | MEDIO | Validar con script automatizado |
| Valores incorrectos en campos enum | BAJA | BAJO | Validar contra valores permitidos |
| Fechas con formato incorrecto | MEDIA | BAJO | Script valida formato YYYY-MM-DD |
| IDs inconsistentes | BAJA | MEDIO | Validar ID YAML vs nombre archivo |

---

## Evidencias a Capturar

1. `lista-adrs.txt` - Lista de ADRs a validar
2. `validacion-yaml-existencia.log` - Validacion existencia frontmatter
3. `validacion-yaml-campos.log` - Validacion campos obligatorios y valores
4. `validacion-consistencia-ids.log` - Validacion consistencia IDs
5. `validacion-fechas.log` - Validacion formato fechas
6. `reporte-metadatos.md` - Reporte consolidado (ENTREGABLE PRINCIPAL)
7. `resumen-validacion.txt` - Resumen final de validaciones

---

## Notas

- **Self-Consistency:** Se valida que todos los ADRs sigan el mismo esquema YAML
- Los campos opcionales (supersedida_por, relacionada_con) no se validan en esta tarea
- Si un ADR tiene YAML invalido, corregir manualmente y re-ejecutar validaciones
- El script de validacion puede reutilizarse en futuras tareas de QA
- Mantener esquema YAML consistente facilita automatizacion futura (indices, reportes, etc.)

---

## Tiempo de Ejecucion

**Inicio:** __:__
**Fin:** __:__
**Duracion Real:** __ minutos

---

## Checklist de Finalizacion

- [ ] Todos los ADRs tienen frontmatter YAML
- [ ] Todos los ADRs tienen 6 campos obligatorios
- [ ] Script de validacion ejecutado para todos los ADRs
- [ ] Reporte-metadatos.md creado con estadisticas
- [ ] Validacion de consistencia IDs ejecutada
- [ ] Validacion de fechas ejecutada
- [ ] Resumen-validacion.txt creado
- [ ] 7 archivos de evidencias generados
- [ ] Tarea marcada como COMPLETADA en INDICE.md

---

**Tarea creada:** 2025-11-18
**Ultima actualizacion:** 2025-11-18
**Version:** 1.0.0
**Estado:** PENDIENTE
