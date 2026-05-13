---
id: TASK-QA-INFRA-064
tipo: tarea
categoria: validacion
nombre: Validar metadatos YAML 90%+ (Chain-of-Verification)
titulo: Validar frontmatter YAML en documentos criticos
fase: FASE_4_VALIDACION_Y_LIMPIEZA
prioridad: P1_ALTA
duracion_estimada: 4h
estado: pendiente
dependencias: [TASK-QA-INFRA-063]
tecnicas: [Chain-of-Verification, Auto-CoT, Self-Consistency]
---

# TASK-064: Validar Metadatos YAML 90%+

**Objetivo:** Ejecutar validación de frontmatter YAML en documentos de infraestructura, alcanzar ≥90% de documentos con metadatos válidos y completos, usando Chain-of-Verification para garantizar consistencia de datos.

**Responsable:** @qa-engineer
**Restricciones:** No modificar archivos legacy sin frontmatter (registrar como excepción), mantener compatibilidad con parser YAML.
**Técnica de prompting sugerida:** Chain-of-Verification + Auto-CoT + Self-Consistency (`docs/ai/prompting`).

---

## Auto-CoT: Razonamiento Paso a Paso

### Paso 1: Entender Propósito de Metadatos YAML

**Pensamiento**: ¿Por qué validar frontmatter YAML es crítico?

**Importancia:**
1. **Gobernanza**: Metadatos registran responsables y estado
2. **Automatización**: Scripts usan frontmatter para procesar documentos
3. **Auditoría**: ID y timestamp permiten rastrear cambios
4. **Categorización**: tipo/categoria facilitan búsqueda y organización
5. **Workflow**: Estado permite rastrear progreso de tareas

**Campos Requeridos:**
- `id`: Identificador único (ej: CARP-INFRA-001)
- `tipo`: Categoría de documento (tarea, documentacion, procedimiento, etc)
- `titulo`: Descripción corta del contenido
- `estado`: pendiente, en_progreso, completada, archivado
- `categoria`: Clasificación temática (arquitectura, procedimiento, etc)

**Campos Opcionales Importantes:**
- `descripcion`: Detalle adicional
- `responsable`: Quién mantiene
- `prioridad`: P0 (crítica) a P3 (baja)
- `dependencias`: Lista de tareas/docs relacionadas
- `duracion_estimada`: Para tareas

### Paso 2: Preparar Validador de Frontmatter

**Pensamiento**: ¿Qué script usar para validar?

**Script Disponible:**
```bash
# Ubicación
/home/user/IACT/scripts/qa/validate_frontmatter.py

# Características
- Valida sintaxis YAML
- Verifica campos requeridos
- Detecta IDs duplicados
- Genera reportes JSON
```

**Verificación Previa:**
```bash
# Verificar que script existe
ls -la /home/user/IACT/scripts/qa/validate_frontmatter.py

# Verificar Python 3 disponible
python3 --version

# Probar script con --help
python3 /home/user/IACT/scripts/qa/validate_frontmatter.py --help
```

### Paso 3: Ejecutar Validación Inicial (Chain-of-Verification)

**Pensamiento**: ¿Cómo validar de forma confiable y verificable?

**Paso 1 de CoVe: Línea Base**
```bash
# Ejecutar validación con output detallado
python3 /home/user/IACT/scripts/qa/validate_frontmatter.py \
    /home/user/IACT/docs/infraestructura \
    --verbose \
    > /tmp/frontmatter-validacion-inicial.log 2>&1

# Guardar en evidencias
cp /tmp/frontmatter-validacion-inicial.log \
    /home/user/IACT/docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-064-validar-metadatos-yaml/evidencias/01-validacion-inicial.log

# Ejecutar en modo JSON para análisis
python3 /home/user/IACT/scripts/qa/validate_frontmatter.py \
    /home/user/IACT/docs/infraestructura \
    --json \
    > /tmp/frontmatter-validacion-inicial.json

cp /tmp/frontmatter-validacion-inicial.json \
    /home/user/IACT/docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-064-validar-metadatos-yaml/evidencias/01-validacion-inicial.json
```

**Salida Esperada:**
```
===============================================
REPORTE DE VALIDACION DE FRONTMATTER YAML
===============================================
Archivos procesados: XXX
Frontmatter valido: YYY
Errores: ZZZ
Sin frontmatter: NNN
IDs duplicados: MMM
```

### Paso 4: Analizar Resultados Detalladamente

**Pensamiento**: ¿Qué patrones veo en los errores?

**Análisis de Errores - Paso 2 de CoVe:**
```bash
# Extraer solo las líneas de error
grep "ERROR\|error\|\[ERRORES\]" /tmp/frontmatter-validacion-inicial.log \
    > /tmp/errores-detallados.txt

# Contar por tipo de error
grep "Falta campo" /tmp/errores-detallados.txt | cut -d: -f2 | sort | uniq -c

# Extraer archivos con problemas
grep "ERROR" /tmp/errores-detallados.txt | cut -d: -f1 | sort | uniq -c

# Crear reporte de hallazgos
cat > /tmp/analisis-hallazgos.md << 'EOF'
# Análisis de Errores de Frontmatter

## Categorías de Problemas

### 1. Sin Frontmatter (archivos legacy)
- Cantidad: XXX
- Impacto: No pueden usarse en automatización
- Solución: Agregar frontmatter mínimo

### 2. YAML Inválido
- Cantidad: YYY
- Ejemplos: Indentación incorrecta, comillas sin cerrar
- Solución: Corregir sintaxis YAML

### 3. Campos Requeridos Faltantes
- Cantidad: ZZZ
- Campos comúnmente faltantes: id, estado, tipo
- Solución: Agregar campos requeridos

### 4. IDs Duplicados
- Cantidad: NNN
- Impacto: Conflicto en identificación única
- Solución: Renumerar o cambiar prefijo

### 5. Valores Inválidos
- Cantidad: MMM
- Ejemplos: estado=invalid, tipo=desconocido
- Solución: Usar valores permitidos
EOF

cp /tmp/analisis-hallazgos.md \
    /home/user/IACT/docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-064-validar-metadatos-yaml/evidencias/02-analisis-hallazgos.md
```

### Paso 5: Categorizar Documentos por Acción Requerida

**Pensamiento**: ¿Cómo priorizar correcciones?

**Categorización:**
```bash
# Categoría 1: Sin frontmatter (puede ser excepcional)
grep "Sin frontmatter" /tmp/frontmatter-validacion-inicial.log \
    | cut -d: -f1 > /tmp/sin-frontmatter.txt

# Categoría 2: YAML inválido (error crítico)
grep "YAML invalido" /tmp/frontmatter-validacion-inicial.log \
    | cut -d: -f1 > /tmp/yaml-invalido.txt

# Categoría 3: Campos faltantes (corregible)
grep "Falta campo\|Campo vacio" /tmp/frontmatter-validacion-inicial.log \
    | cut -d: -f1 | sort -u > /tmp/campos-faltantes.txt

# Categoría 4: Valores inválidos (corregible)
grep "invalido" /tmp/frontmatter-validacion-inicial.log \
    | cut -d: -f1 | sort -u > /tmp/valores-invalidos.txt

# Categoría 5: IDs duplicados (crítico)
grep "ID duplicado" /tmp/frontmatter-validacion-inicial.log \
    | cut -d: -f1 > /tmp/ids-duplicados.txt

# Reporte de categorización
cat > /tmp/categorizacion.txt << 'EOF'
Sin frontmatter: $(wc -l < /tmp/sin-frontmatter.txt)
YAML inválido: $(wc -l < /tmp/yaml-invalido.txt)
Campos faltantes: $(wc -l < /tmp/campos-faltantes.txt)
Valores inválidos: $(wc -l < /tmp/valores-invalidos.txt)
IDs duplicados: $(wc -l < /tmp/ids-duplicados.txt)
EOF
```

### Paso 6: Planificar Correcciones

**Pensamiento**: ¿Cómo procedo sin romper nada?

**Plan de Corrección Graduada:**
1. **Paso 1**: Corregir YAML inválido (errors que impiden parseo)
2. **Paso 2**: Corregir IDs duplicados (cambiar numbering)
3. **Paso 3**: Agregar campos requeridos faltantes
4. **Paso 4**: Corregir valores inválidos (usar enum válido)
5. **Paso 5**: Documentar excepciones (archivos legacy sin frontmatter)

**Protocolo de Corrección - Paso 3 de CoVe:**
```bash
# Para cada error:
# 1. Identificar archivo
# 2. Leer contenido actual
# 3. Identificar problema específico
# 4. Aplicar corrección
# 5. Validar que YAML es válido
# 6. Documentar cambio

# Ejemplo: Agregar campo faltante
for archivo in $(cat /tmp/campos-faltantes.txt | head -5); do
    echo "Procesando: $archivo"

    # Leer frontmatter actual
    head -20 "$archivo"

    # (Luego: editar archivo para agregar campo faltante)
    # (Usar script o edición manual según caso)

    # Validar después
    python3 /home/user/IACT/scripts/qa/validate_frontmatter.py \
        "$(dirname "$archivo")" --json | jq '.valid'
done
```

### Paso 7: Validación Post-Corrección

**Pensamiento**: ¿Cómo verificar que correcciones funcionan?

**Paso 2 de CoVe: Re-validación**
```bash
# Ejecutar validación nuevamente
python3 /home/user/IACT/scripts/qa/validate_frontmatter.py \
    /home/user/IACT/docs/infraestructura \
    --json > /tmp/frontmatter-validacion-final.json

# Extraer métricas
jq '.summary' /tmp/frontmatter-validacion-final.json

# Comparar con línea base
echo "Inicial:"
jq '.summary' /tmp/frontmatter-validacion-inicial.json

echo "Final:"
jq '.summary' /tmp/frontmatter-validacion-final.json
```

**Criterio de Éxito:**
```
valid_count >= 90% de total_count
broken_links = 0 (si había)
duplicate_ids = 0 (si había)
```

### Paso 8: Documentar Excepciones

**Pensamiento**: ¿Qué archivos legacy pueden quedarse sin frontmatter?

**Justificación de Excepciones:**
```markdown
# Excepciones Documentadas

## Archivos Legacy Sin Frontmatter (Justificado)

### Tipo 1: Archivos Temporales
- Razón: Contenido temporal durante reorganización
- Acción: Será eliminado en siguiente fase
- Documentado en: [referencia]

### Tipo 2: Archivos Externos/Importados
- Razón: Contenido de terceros, no modificable
- Acción: Se referencia pero no se valida
- Documentado en: [referencia]

## Meta de 90%+
- Total archivos: XXX
- Con frontmatter válido: YYY
- Porcentaje: ZZ% (≥90% [COMPLETADO])
- Excepciones documentadas: NNN
```

### Paso 9: Generar Reporte Final

**Pensamiento**: ¿Cómo documentar el trabajo completado?

**Paso 3 de CoVe: Documentación Final**
```json
{
  "fecha_ejecucion": "2025-11-XX",
  "ejecutado_por": "[nombre]",
  "chain_of_verification": {
    "paso_1_linea_base": {
      "fecha": "2025-11-XX",
      "total_archivos": XXX,
      "valid": YYY,
      "errors": ZZZ,
      "sin_frontmatter": NNN
    },
    "paso_2_correcciones": {
      "cantidad_corregidas": AAA,
      "yaml_invalido_corregido": BBB,
      "ids_duplicados_resueltos": CCC,
      "campos_agregados": DDD
    },
    "paso_3_revalidacion": {
      "fecha": "2025-11-XX",
      "total_archivos": XXX,
      "valid": YYY,
      "errors": ZZZ,
      "sin_frontmatter": EEE
    }
  },
  "metricas_finales": {
    "cobertura": "90%+",
    "estado": "COMPLETADA",
    "excepciones_documentadas": NNN
  }
}
```

---

## Self-Consistency: Validación Múltiple

### Enfoque 1: Validación Automatizada Completa

**Proceso:**
```bash
# Ejecutar script de validación 3 veces independientemente
for i in {1..3}; do
    python3 /home/user/IACT/scripts/qa/validate_frontmatter.py \
        /home/user/IACT/docs/infraestructura \
        --json > /tmp/validacion-$i.json
    jq '.summary.valid_count' /tmp/validacion-$i.json
done | tee validacion-repetidas.txt
```

**Resultado esperado:**
```
Ejecutación 1: XXX documentos válidos
Ejecutación 2: XXX documentos válidos
Ejecutación 3: XXX documentos válidos
Convergencia: [COMPLETADO] Resultados idénticos
```

### Enfoque 2: Validación Manual de Muestra

**Proceso:**
```bash
# Seleccionar 10 archivos aleatorios
find /home/user/IACT/docs/infraestructura -name "*.md" \
    | shuf | head -10 > /tmp/muestra-validar.txt

# Para cada archivo:
for archivo in $(cat /tmp/muestra-validar.txt); do
    echo "=== $archivo ==="
    head -15 "$archivo"
    echo ""

    # Validar manualmente:
    # [ ] ¿Tiene frontmatter?
    # [ ] ¿YAML es válido?
    # [ ] ¿Tiene id, tipo, titulo, estado?
    # [ ] ¿Valores son válidos?
done
```

**Documentar:**
```markdown
## Validación Manual de Muestra

Archivo 1: [COMPLETADO] Válido - todos los campos presentes y correctos
Archivo 2: [WARNING] Advertencia - id duplicado
Archivo 3: [ERROR] Error - YAML inválido (indentación)
...

Conclusión: 7/10 válidos (70%) en muestra
```

### Enfoque 3: Análisis de Patrones

**Proceso:**
```bash
# Buscar patrones en documentos válidos vs inválidos
jq '.file_errors[] | .error' /tmp/frontmatter-validacion-inicial.json | sort | uniq -c | sort -rn

# Analizar por tipo de archivo
find /home/user/IACT/docs/infraestructura -name "*.md" | while read f; do
    if python3 /home/user/IACT/scripts/qa/validate_frontmatter.py \
        "$(dirname "$f")" --json 2>/dev/null | jq -e '.valid' > /dev/null; then
        echo "VALID: $f"
    else
        echo "INVALID: $f"
    fi
done | tee analisis-patrones.txt
```

**Análisis:**
```
Patrón 1: Todos los archivos en carpeta X tienen error → Problema global
Patrón 2: Solo archivos creados antes de fecha Y → Legacy sin frontmatter
Patrón 3: Solo documentos tipo Z tienen error → Problema de template
```

### Convergencia

**Validación final:**
```
Enfoque 1 (automático):  XXX válidos (YY%)
Enfoque 2 (manual):      7/10 muestras válidas (70% extrapolado)
Enfoque 3 (patrones):    Identifica razones de errores consistentemente

Conclusión: [COMPLETADO] Convergencia - Meta de 90%+ confirmada
```

---

## Criterios de Aceptación

- [ ] ≥90% documentos con frontmatter YAML válido
- [ ] 0 YAML inválido (sintaxis correcta)
- [ ] 0 IDs duplicados
- [ ] Campos requeridos en ≥90% de documentos
- [ ] Valores válidos según enumeración definida
- [ ] Self-Consistency validada: 3 enfoques ejecutados
- [ ] Chain-of-Verification completada: línea base → corrección → revalidación
- [ ] Excepciones documentadas y justificadas

## Entregables

### 1. Validación Inicial
**Archivo**: `evidencias/01-validacion-inicial.log`
- Output del script (verbose)
- Lista de errores encontrados
- Timestamp

**Archivo**: `evidencias/01-validacion-inicial.json`
- Output en formato JSON
- Resumen de métricas
- Detalle de errores

### 2. Análisis de Hallazgos
**Archivo**: `evidencias/02-analisis-hallazgos.md`
```markdown
# Análisis de Errores de Frontmatter

## Resumen
- Total archivos: XXX
- Válidos: YYY (YY%)
- Inválidos: ZZZ (ZZ%)
- Sin frontmatter: NNN

## Categorías de Problemas
1. Sin frontmatter: AAA
2. YAML inválido: BBB
3. Campos faltantes: CCC
4. Valores inválidos: DDD
5. IDs duplicados: EEE
```

### 3. Plan de Correcciones
**Archivo**: `evidencias/03-plan-correcciones.md`
```markdown
# Plan de Correcciones

## Fase 1: YAML Inválido (Crítico)
- Cantidad: XXX
- Acción: Reparación de sintaxis

## Fase 2: IDs Duplicados (Crítico)
- Cantidad: YYY
- Acción: Renumeración

## Fase 3: Campos Faltantes (Normal)
- Cantidad: ZZZ
- Acción: Agregar campos

## Fase 4: Valores Inválidos (Normal)
- Cantidad: NNN
- Acción: Cambiar a valor válido
```

### 4. Correcciones Aplicadas
**Archivo**: `evidencias/04-correcciones-aplicadas.md`
- Listado de archivos modificados
- Cambios específicos por archivo
- Confirmación de éxito

### 5. Validación Post-Corrección
**Archivo**: `evidencias/05-validacion-final.json`
```json
{
  "fecha": "2025-11-XX",
  "total_archivos": XXX,
  "validos": YYY,
  "porcentaje_cobertura": "90%+",
  "estado": "COMPLETADA"
}
```

### 6. Excepciones Documentadas
**Archivo**: `evidencias/06-excepciones-documentadas.md`
```markdown
# Excepciones Documentadas

## Archivos Sin Frontmatter (Justificado)
- `/ruta/archivo.md`: Razón - será eliminado próxima fase
- ...

## Total
- Excepciones válidas: XXX
- Cobertura real: YY% (≥90% [COMPLETADO])
```

### 7. Reporte de Self-Consistency
**Archivo**: `evidencias/07-self-consistency-reporte.md`
```markdown
# Reporte de Self-Consistency

## Enfoque 1: Validación Automática (3 ejecuciones)
- Ejecución 1: XXX válidos
- Ejecución 2: XXX válidos
- Ejecución 3: XXX válidos
- Convergencia: [COMPLETADO] Idénticos

## Enfoque 2: Validación Manual (10 muestras)
- Muestras válidas: 7/10
- Muestras inválidas: 3/10
- Extrapolación: 70% (nota: posible sesgo)

## Enfoque 3: Análisis de Patrones
- Patrón 1: Legacy files
- Patrón 2: Generated files
- Patrón 3: Incomplete frontmatter
- Convergencia: [COMPLETADO] Patrones identificados consistentemente
```

---

## Checklist de Ejecución

### Fase 1: Preparación
- [ ] Script validate_frontmatter.py ubicado
- [ ] Python 3 disponible
- [ ] Directorio target confirmado
- [ ] Directorio evidencias creado
- [ ] Valores permitidos documentados (VALID_TIPOS, VALID_ESTADOS)

### Fase 2: Validación Inicial (CoVe Paso 1)
- [ ] Script ejecutado con --verbose
- [ ] Script ejecutado con --json
- [ ] Outputs guardados en archivos
- [ ] Métricas extraídas
- [ ] Análisis completado

### Fase 3: Categorización
- [ ] Errores categorizados
- [ ] Hallazgos documentados
- [ ] Impacto evaluado
- [ ] Plan de corrección creado

### Fase 4: Correcciones (CoVe Paso 2)
- [ ] YAML inválido reparado
- [ ] IDs duplicados resueltos
- [ ] Campos faltantes agregados
- [ ] Valores inválidos corregidos
- [ ] Cambios documentados

### Fase 5: Re-validación (CoVe Paso 3)
- [ ] Script ejecutado nuevamente
- [ ] Resultados comparados con línea base
- [ ] Diferencias analizadas
- [ ] Meta de 90%+ alcanzada

### Fase 6: Self-Consistency
- [ ] Validación automática: 3 ejecuciones
- [ ] Validación manual: 10 muestras
- [ ] Análisis de patrones: completado
- [ ] Convergencia documentada

### Fase 7: Documentación
- [ ] Excepciones documentadas
- [ ] Reporte final generado
- [ ] Evidencias organizadas
- [ ] Commit preparado

---

## Guía de Ejecución Rápida

### Paso 1: Validación Inicial (5 min)
```bash
python3 /home/user/IACT/scripts/qa/validate_frontmatter.py \
    /home/user/IACT/docs/infraestructura \
    --verbose 2>&1 | tee 01-validacion-inicial.log

python3 /home/user/IACT/scripts/qa/validate_frontmatter.py \
    /home/user/IACT/docs/infraestructura \
    --json > 01-validacion-inicial.json
```

### Paso 2: Analizar Resultados (10 min)
```bash
jq '.summary' 01-validacion-inicial.json
jq '.file_errors[] | .error' 01-validacion-inicial.json | sort | uniq -c
```

### Paso 3: Categorizar Errores (15 min)
```bash
grep "YAML invalido\|Falta campo\|invalido\|ID duplicado" 01-validacion-inicial.log \
    | cut -d: -f1 | sort | uniq -c
```

### Paso 4: Correcciones (variable)
```bash
# Para cada error:
# 1. Leer archivo
# 2. Identificar problema
# 3. Aplicar corrección
# 4. Verificar con grep o cat
```

### Paso 5: Re-validación (5 min)
```bash
python3 /home/user/IACT/scripts/qa/validate_frontmatter.py \
    /home/user/IACT/docs/infraestructura \
    --json > 05-validacion-final.json

jq '.summary' 05-validacion-final.json
```

### Paso 6: Verificar Cobertura (2 min)
```bash
jq '.summary | {valid_count, total_count, percentage: (.valid_count / .total_count * 100 | round)}' 05-validacion-final.json
```

---

## Técnicas de Prompting

### Auto-CoT
1. **Entender**: Propósito de metadatos YAML
2. **Preparar**: Script y ambiente de validación
3. **Validar**: Ejecutar línea base
4. **Analizar**: Categorizar errores
5. **Planificar**: Estrategia de corrección
6. **Corregir**: Aplicar cambios graduados
7. **Re-validar**: Verificar mejoras
8. **Documentar**: Reportes y excepciones

### Chain-of-Verification
- **Paso 1**: Validación inicial (línea base)
- **Paso 2**: Correcciones basadas en hallazgos
- **Paso 3**: Re-validación confirma mejoras
- Verificabilidad: Cada paso documentado y repetible

### Self-Consistency
1. **Enfoque 1**: Validación automática (3 ejecuciones)
2. **Enfoque 2**: Validación manual (spot-check)
3. **Enfoque 3**: Análisis de patrones
- Convergencia: Todos los enfoques llegan a misma conclusión

---

## Notas Importantes

- **YAML válido**: Prioridad 1, impide cualquier automatización
- **IDs únicos**: Crítico para identificación en sistema
- **Campos requeridos**: Mínimo para gobernanza básica
- **Meta flexible**: 90%+ permite algunas excepciones documentadas
- **Legacy**: Archivos antiguos pueden quedar sin frontmatter si se documenta
- **Convergencia**: Los 3 enfoques de Self-Consistency deben indicar mismo %

---

## Referencias

- Script: `/home/user/IACT/scripts/qa/validate_frontmatter.py`
- YAML syntax: https://yaml.org/
- Chain-of-Verification: Verificabilidad en múltiples pasos
- Auto-CoT: Wei et al. (2022)
- Self-Consistency: Wang et al. (2022)
- Meta de fase: ≥90% documentación con gobernanza visible
