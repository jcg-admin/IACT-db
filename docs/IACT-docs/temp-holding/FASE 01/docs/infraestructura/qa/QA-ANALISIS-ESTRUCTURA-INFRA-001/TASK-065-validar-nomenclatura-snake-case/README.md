---
id: TASK-QA-INFRA-065
tipo: tarea
categoria: validacion
nombre: Validar nomenclatura snake_case (Auto-CoT)
titulo: Validar nomenclatura consistente en archivos y carpetas
fase: FASE_4_VALIDACION_Y_LIMPIEZA
prioridad: P1_ALTA
duracion_estimada: 2h
estado: pendiente
dependencias: [TASK-QA-INFRA-064]
tecnicas: [Auto-CoT, Self-Consistency, Chain-of-Verification]
---

# TASK-065: Validar Nomenclatura snake_case

**Objetivo:** Validar que archivos y carpetas en infraestructura siguen convención snake_case (lowercase-with-dashes), alcanzar ≥95% cumplimiento usando Auto-CoT para razonamiento sistemático.

**Responsable:** @qa-engineer
**Restricciones:** Permitir excepciones para archivos especiales (README, LICENSE, Dockerfile, etc), mantener compatibilidad con git.
**Técnica de prompting sugerida:** Auto-CoT + Self-Consistency + Chain-of-Verification (`docs/ai/prompting`).

---

## Auto-CoT: Razonamiento Paso a Paso

### Paso 1: Entender Propósito de Nomenclatura Consistente

**Pensamiento**: ¿Por qué nomenclatura consistente es importante?

**Importancia:**
1. **Consistencia**: Patrón predecible facilita navegación
2. **Herramientas**: Scripts y automación dependen de patrones
3. **Legibilidad**: snake_case es más legible que camelCase en terminal
4. **Escalabilidad**: Nuevos archivos siguen mismo patrón
5. **Profesionalismo**: Código limpio refleja calidad

**Convención Elegida: snake_case**
```
[COMPLETADO] Válido:
- archivo-documento.md
- carpeta-principal
- script-validacion.sh
- index-tareas.json

[ERROR] Inválido:
- archivoDocumento.md (camelCase)
- ARCHIVO-DOCUMENTO.md (UPPERCASE)
- archivo documento.md (espacios)
- archivo_documento.md (guiones preferibles)
```

**Excepciones Permitidas:**
```
[COMPLETADO] Permitidas (sin validación):
- README.md, README.en.md
- LICENSE, CHANGELOG
- Dockerfile, docker-compose.yml
- Makefile, .gitignore
- package.json, package-lock.json
- .env, .env.example
```

### Paso 2: Preparar Validador de Nomenclatura

**Pensamiento**: ¿Qué script usar para validar?

**Script Disponible:**
```bash
# Ubicación
/home/user/IACT/scripts/qa/validate_naming.sh

# Características
- Valida archivos y carpetas
- Detecta nombres inválidos
- Sugiere correcciones
- Modo strict/verbose
- Modo --fix para sugerencias
```

**Verificación Previa:**
```bash
# Verificar script existe y es ejecutable
ls -la /home/user/IACT/scripts/qa/validate_naming.sh

# Probar con --help
bash /home/user/IACT/scripts/qa/validate_naming.sh --help
```

### Paso 3: Ejecutar Validación Inicial

**Pensamiento**: ¿Cómo crear línea base de cumplimiento?

**Ejecución de Script:**
```bash
# Validación estándar
bash /home/user/IACT/scripts/qa/validate_naming.sh \
    /home/user/IACT/docs/infraestructura \
    > /tmp/nomenclatura-validacion-inicial.log 2>&1

# Validación verbose (más detalles)
bash /home/user/IACT/scripts/qa/validate_naming.sh \
    /home/user/IACT/docs/infraestructura \
    --verbose \
    > /tmp/nomenclatura-validacion-inicial-verbose.log 2>&1

# Guardar en evidencias
cp /tmp/nomenclatura-validacion-inicial.log \
    /home/user/IACT/docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-065-validar-nomenclatura-snake-case/evidencias/01-validacion-inicial.log
```

**Salida Esperada:**
```
===============================================
REPORTE DE VALIDACION DE NOMENCLATURA
===============================================
Total procesados: XXX
Nombres validos: YYY (YY%)
Nombres invalidos: ZZZ (ZZ%)
```

### Paso 4: Analizar Nombres Inválidos

**Pensamiento**: ¿Qué patrones de nombres son problemáticos?

**Análisis de Patrones:**
```bash
# Extraer solo nombres inválidos
grep "WARNING\|ADVERTENCIA" /tmp/nomenclatura-validacion-inicial-verbose.log \
    > /tmp/nombres-invalidos.txt

# Categorizar por tipo de problema
# Patrón 1: MAYUSCULAS
grep -i "camelcase\|uppercase" /tmp/nombres-invalidos.txt \
    | wc -l

# Patrón 2: Espacios
grep " " /tmp/nombres-invalidos.txt \
    | wc -l

# Patrón 3: Caracteres especiales
grep "[^a-z0-9._-]" /tmp/nombres-invalidos.txt \
    | wc -l

# Crear análisis
cat > /tmp/analisis-nomenclatura.md << 'EOF'
# Análisis de Nombres Inválidos

## Patrones Encontrados

### Patrón 1: MAYUSCULAS
- Ejemplos: API_CONFIG.md, AuthHandler.js
- Cantidad: XXX
- Solución: Convertir a minúsculas

### Patrón 2: camelCase
- Ejemplos: miArchivo.md, configDatabase.json
- Cantidad: YYY
- Solución: Cambiar a snake_case (guiones)

### Patrón 3: Espacios
- Ejemplos: "mi archivo.md", "nombre documento.txt"
- Cantidad: ZZZ
- Solución: Reemplazar espacios con guiones

### Patrón 4: Caracteres especiales
- Ejemplos: archivo@v1.md, config#2.json
- Cantidad: NNN
- Solución: Remover caracteres especiales

### Patrón 5: Excepciones válidas
- README, LICENSE, Dockerfile
- Cantidad: MMM (no contar como error)
```

### Paso 5: Categorizar por Criticidad

**Pensamiento**: ¿Qué nombres requieren cambio inmediato?

**Categorización:**
```bash
# Crítico: Nombres con caracteres especiales que rompan scripts
grep -E "[\s\$\&\*\%\#\@\!]" /tmp/nombres-invalidos.txt \
    > /tmp/critico-cambiar.txt

# Alto: camelCase que viola convención
grep -E "[a-z][A-Z]" /tmp/nombres-invalidos.txt \
    > /tmp/alto-cambiar.txt

# Medio: MAYUSCULAS que no son excepciones
grep -E "^[A-Z]" /tmp/nombres-invalidos.txt \
    | grep -v "README\|LICENSE\|Dockerfile\|Makefile" \
    > /tmp/medio-cambiar.txt

# Reportar
cat > /tmp/categorizacion-nomenclatura.txt << 'EOF'
Crítico (cambiar primero): $(wc -l < /tmp/critico-cambiar.txt)
Alto (cambiar después): $(wc -l < /tmp/alto-cambiar.txt)
Medio (cambiar luego): $(wc -l < /tmp/medio-cambiar.txt)
EOF
```

### Paso 6: Planificar Correcciones

**Pensamiento**: ¿Cómo cambiar nombres sin romper referencias?

**Protocolo de Cambio:**
```bash
# Para cada archivo/carpeta a cambiar:

# 1. Verificar que cambio no romperá nada
OLD_NAME="archivo-incorrecto.md"
NEW_NAME="archivo-correcto.md"

# Buscar referencias
grep -r "$OLD_NAME" /home/user/IACT/docs/infraestructura \
    | head -5

# 2. Crear lista de cambios antes de aplicar
echo "$OLD_NAME → $NEW_NAME" >> /tmp/cambios-planeados.txt

# 3. Aplicar cambio (cuando esté listo)
# git mv "$OLD_NAME" "$NEW_NAME"  # Para archivos en git
# mv "$OLD_NAME" "$NEW_NAME"      # Para archivos sin seguimiento

# 4. Actualizar referencias en otros archivos
# sed -i "s|$OLD_NAME|$NEW_NAME|g" archivo-que-referencia.md

# 5. Validar cambio
# grep "$NEW_NAME" archivo-que-referencia.md
```

### Paso 7: Validación Post-Corrección

**Pensamiento**: ¿Cómo verificar que cambios son correctos?

**Re-ejecución de Script:**
```bash
# Ejecutar validación nuevamente
bash /home/user/IACT/scripts/qa/validate_naming.sh \
    /home/user/IACT/docs/infraestructura \
    > /tmp/nomenclatura-validacion-final.log 2>&1

# Comparar resultados
echo "=== ANTES ==="
grep "Nombres validos\|Nombres invalidos" /tmp/nomenclatura-validacion-inicial.log

echo "=== DESPUÉS ==="
grep "Nombres validos\|Nombres invalidos" /tmp/nomenclatura-validacion-final.log

# Meta: ≥95% válidos
```

### Paso 8: Documentar Excepciones

**Pensamiento**: ¿Qué nombres deben quedar como están?

**Justificación de Excepciones:**
```markdown
# Excepciones Permitidas

## Archivos Estándar Reconocidos
- README.md: Convención universal
- LICENSE: Nombre estándar de licencia
- Dockerfile: Estándar Docker
- Makefile: Estándar Unix
- .gitignore: Archivo de configuración sistema
- .env, .env.example: Archivos de configuración

## Total
- Válidos: XXX (incluyendo excepciones)
- Inválidos: YYY
- Porcentaje: ZZ% (≥95% [COMPLETADO])
- Excepciones: NNN

## Decisión Final
Excepciones son justificadas y documentadas. Meta de 95%+ alcanzada.
```

### Paso 9: Generar Reporte Final

**Pensamiento**: ¿Cómo documentar el trabajo completado?

**Reporte de Cierre:**
```json
{
  "fecha_ejecucion": "2025-11-XX",
  "ejecutado_por": "[nombre]",
  "nomenclatura_validacion": {
    "linea_base": {
      "total": XXX,
      "validos": YYY,
      "invalidos": ZZZ,
      "porcentaje": "YY%"
    },
    "cambios_realizados": {
      "archivos_renombrados": AAA,
      "referencias_actualizadas": BBB,
      "git_changes": CCC
    },
    "resultado_final": {
      "total": XXX,
      "validos": ZZZ,
      "invalidos": WWW,
      "porcentaje": "ZZ%",
      "excepciones_documentadas": NNN
    }
  },
  "estado": "COMPLETADA",
  "meta_alcanzada": "[COMPLETADO] 95%+ cumplimiento"
}
```

---

## Self-Consistency: Validación Múltiple

### Enfoque 1: Validación por Tipo de Elemento

**Proceso:**
```bash
# Validar solo archivos
find /home/user/IACT/docs/infraestructura -type f | while read f; do
    name=$(basename "$f")
    if [[ "$name" =~ [A-Z] ]]; then
        echo "[WARNING] $f"
    elif [[ "$name" =~ " " ]]; then
        echo "[ERROR] $f"
    fi
done > /tmp/archivos-invalidos.txt

# Validar solo carpetas
find /home/user/IACT/docs/infraestructura -type d | while read d; do
    name=$(basename "$d")
    if [[ "$name" =~ [A-Z] ]]; then
        echo "[WARNING] $d"
    elif [[ "$name" =~ " " ]]; then
        echo "[ERROR] $d"
    fi
done > /tmp/carpetas-invalidas.txt

# Contar
echo "Archivos inválidos: $(wc -l < /tmp/archivos-invalidos.txt)"
echo "Carpetas inválidas: $(wc -l < /tmp/carpetas-invalidas.txt)"
```

### Enfoque 2: Validación Manual Aleatorio

**Proceso:**
```bash
# Seleccionar 20 elementos aleatorios
find /home/user/IACT/docs/infraestructura \( -type f -o -type d \) \
    | shuf | head -20 > /tmp/muestra-nomenclatura.txt

# Verificar manualmente cada uno
while read item; do
    name=$(basename "$item")

    # Checklist:
    # [ ] ¿Solo lowercase?
    # [ ] ¿Sin espacios?
    # [ ] ¿Solo guiones como separador?
    # [ ] ¿Sin caracteres especiales?
    # [ ] ¿Excepción justificada si no cumple?

    echo "Validando: $name"
    # Análisis manual...
done < /tmp/muestra-nomenclatura.txt
```

**Resultado:**
```
Muestreo: 20 elementos
Válidos: 18 (90%)
Inválidos: 2 (10%)
Excepciones: 0
Nota: Validación manual converge con script
```

### Enfoque 3: Análisis de Patrón en Git

**Proceso:**
```bash
# Verificar historial de cambios de nombres
git log --diff-filter=R --name-status --oneline | head -20

# Patrón: ¿Qué caracteres fueron utilizados en renombraciones?
git log -p -S"mv " -- . | grep "mv " | head -10

# Conclusión: Patrones históricos confirman preferencia por snake_case
```

### Convergencia

**Validación final:**
```
Enfoque 1 (script):    XXX válidos (YY%)
Enfoque 2 (manual):    18/20 válidos (90%)
Enfoque 3 (historia):  Patrón histórico confirma snake_case como estándar

Conclusión: [COMPLETADO] Convergencia - Meta de 95%+ confirmada
```

---

## Criterios de Aceptación

- [ ] ≥95% archivos y carpetas en snake_case (lowercase-with-dashes)
- [ ] Excepciones permitidas documentadas (README, LICENSE, etc)
- [ ] 0 archivos con espacios en nombre
- [ ] 0 archivos con caracteres especiales problemáticos
- [ ] Referencias internas actualizadas si cambios aplicados
- [ ] Self-Consistency validada: 3 enfoques ejecutados
- [ ] Chain-of-Verification completada: línea base → cambios → revalidación
- [ ] Reporte final completo con excepciones justificadas

## Entregables

### 1. Validación Inicial
**Archivo**: `evidencias/01-validacion-inicial.log`
- Output completo del script
- Resumen de válidos/inválidos
- Timestamp

**Archivo**: `evidencias/01-validacion-inicial-verbose.log`
- Output detallado del script con --verbose
- Sugerencias de corrección

### 2. Análisis de Patrones
**Archivo**: `evidencias/02-analisis-patrones-nomenclatura.md`
```markdown
# Análisis de Patrones de Nombres Inválidos

## Patrones Identificados
1. MAYUSCULAS: XXX (ej: CONFIG.md)
2. camelCase: YYY (ej: miArchivo.md)
3. Espacios: ZZZ (ej: "mi archivo.md")
4. Caracteres especiales: NNN (ej: config@v1.md)

## Distribución
- Crítico (cambiar inmediato): AAA
- Alto (cambiar pronto): BBB
- Medio (cambiar después): CCC

## Soluciones
- Crítico: Reemplazar caracteres especiales
- Alto: Convertir a snake_case
- Medio: Revisión caso-por-caso
```

### 3. Plan de Cambios
**Archivo**: `evidencias/03-plan-cambios-nomenclatura.md`
```markdown
# Plan de Cambios de Nomenclatura

## Cambios Planeados
1. archivo-incorrecto.md → archivo-correcto.md
2. ConfigAPI.json → config-api.json
3. ... (lista de todos los cambios)

## Referencias a Actualizar
- Archivos que referencian cambios
- Comandos a ejecutar
- Validaciones post-cambio

## Orden de Aplicación
1. Primer lote (críticos): 5 cambios
2. Segundo lote (altos): 8 cambios
3. Tercer lote (medios): 3 cambios
```

### 4. Cambios Aplicados
**Archivo**: `evidencias/04-cambios-aplicados.md`
```markdown
# Cambios Aplicados

## Archivos Renombrados
1. archivo-viejo.md → archivo-nuevo.md [COMPLETADO]
2. ConfigAPI.json → config-api.json [COMPLETADO]
...

## Referencias Actualizadas
- archivo-referencia.md: 3 referencias actualizadas
- indice.md: 1 referencia actualizada
...

## Validación
- [ ] Todos los cambios verificados
- [ ] Referencias correctas
- [ ] Sin archivos rotos
```

### 5. Validación Post-Cambios
**Archivo**: `evidencias/05-validacion-final.log`
- Output del script post-cambios
- Comparación antes/después
- Confirmación de mejora

### 6. Excepciones Documentadas
**Archivo**: `evidencias/06-excepciones-documentadas.md`
```markdown
# Excepciones Permitidas

## Archivos Especiales (Sin Validación)
- README.md: Convención universal
- LICENSE: Estándar legal
- Dockerfile: Estándar Docker
- Makefile: Estándar Unix
...

## Total de Excepciones
- Cantidad: XXX
- Justificadas: [COMPLETADO] Sí
- Documentadas: [COMPLETADO] Sí

## Cobertura Real
- Válidos: YYY
- Inválidos: ZZZ
- Excepciones: NNN
- Porcentaje: AA% (≥95% [COMPLETADO])
```

### 7. Reporte de Self-Consistency
**Archivo**: `evidencias/07-self-consistency-reporte.md`
```markdown
# Reporte de Self-Consistency

## Enfoque 1: Validación por Tipo
- Archivos inválidos: XXX
- Carpetas inválidas: YYY
- Total: ZZZ

## Enfoque 2: Validación Manual
- Muestras: 20
- Válidas: 18 (90%)
- Inválidas: 2 (10%)

## Enfoque 3: Análisis Histórico
- Patrón en git log: snake_case preferido
- Renombraciones históricas: Confirman estándar
- Conclusión: Cambios alineados con historia

## Convergencia
- Todos los enfoques convergen en ~95% válidos
- Excepciones son consistentes
- Meta alcanzada: [COMPLETADO] CONFIRMADA
```

### 8. Reporte Final
**Archivo**: `evidencias/08-reporte-final.json`
```json
{
  "fecha": "2025-11-XX",
  "ejecutado_por": "[nombre]",
  "metricas": {
    "total_elementos": XXX,
    "validos": YYY,
    "inválidos": ZZZ,
    "excepciones": NNN,
    "cobertura": "AA%"
  },
  "cambios": {
    "archivos_renombrados": BBB,
    "referencias_actualizadas": CCC,
    "git_commits": DDD
  },
  "validacion": {
    "self_consistency": "[COMPLETADO] CONVERGENCIA",
    "meta_95_percent": true,
    "estado": "COMPLETADA"
  }
}
```

---

## Checklist de Ejecución

### Fase 1: Preparación
- [ ] Script validate_naming.sh ubicado y ejecutable
- [ ] Directorio target confirmado
- [ ] Directorio evidencias creado
- [ ] Excepciones permitidas documentadas

### Fase 2: Validación Inicial
- [ ] Script ejecutado sin --verbose
- [ ] Script ejecutado con --verbose
- [ ] Outputs guardados en archivos
- [ ] Análisis de patrones completado
- [ ] Categorización por criticidad realizada

### Fase 3: Planificación
- [ ] Lista de cambios creada
- [ ] Orden de aplicación definido
- [ ] Referencias a actualizar identificadas
- [ ] Validaciones post-cambio planeadas

### Fase 4: Aplicación de Cambios
- [ ] Cambios críticos aplicados
- [ ] Cambios altos aplicados
- [ ] Cambios medios aplicados
- [ ] Referencias actualizadas
- [ ] Validación de cada cambio

### Fase 5: Re-validación
- [ ] Script ejecutado nuevamente
- [ ] Resultados comparados
- [ ] Mejora verificada
- [ ] Meta de 95%+ alcanzada

### Fase 6: Self-Consistency
- [ ] Validación por tipo: completada
- [ ] Validación manual: 20 elementos
- [ ] Análisis histórico: completado
- [ ] Convergencia documentada

### Fase 7: Documentación
- [ ] Excepciones documentadas
- [ ] Reporte final generado
- [ ] Evidencias organizadas
- [ ] Commit preparado

---

## Guía de Ejecución Rápida

### Paso 1: Validación Inicial (2 min)
```bash
bash /home/user/IACT/scripts/qa/validate_naming.sh \
    /home/user/IACT/docs/infraestructura 2>&1 | tee 01-validacion.log
```

### Paso 2: Análisis Detallado (5 min)
```bash
bash /home/user/IACT/scripts/qa/validate_naming.sh \
    /home/user/IACT/docs/infraestructura --verbose 2>&1 | tee 01-validacion-verbose.log

grep "WARNING\|ADVERTENCIA" 01-validacion-verbose.log | head -20
```

### Paso 3: Identificar Cambios Necesarios (5 min)
```bash
# Extraer cambios sugeridos
grep "Sugerencia:" 01-validacion-verbose.log | tee cambios-sugeridos.txt

# Contar por tipo
wc -l cambios-sugeridos.txt
```

### Paso 4: Aplicar Cambios (variable)
```bash
# Para cada cambio en archivo:
# 1. Verificar referencias: grep -r "nombre-viejo"
# 2. Aplicar cambio: git mv "viejo" "nuevo" o mv "viejo" "nuevo"
# 3. Actualizar referencias: sed -i 's|viejo|nuevo|g' archivos
```

### Paso 5: Re-validación (2 min)
```bash
bash /home/user/IACT/scripts/qa/validate_naming.sh \
    /home/user/IACT/docs/infraestructura 2>&1 | tee 05-validacion-final.log

grep "Nombres validos\|Nombres invalidos" 05-validacion-final.log
```

### Paso 6: Verificar Meta (1 min)
```bash
# Extraer porcentaje
grep "%" 05-validacion-final.log | tail -3
# Verificar que sea ≥95%
```

---

## Técnicas de Prompting

### Auto-CoT (Chain-of-Thought)
1. **Entender**: Propósito (consistencia, escalabilidad)
2. **Preparar**: Script y exceptions
3. **Validar**: Línea base inicial
4. **Analizar**: Patrones de nombres inválidos
5. **Categorizar**: Por criticidad
6. **Planificar**: Orden y referencias
7. **Aplicar**: Cambios graduados
8. **Re-validar**: Verificar mejoras
9. **Documentar**: Excepciones y resultados

### Self-Consistency
1. **Enfoque 1**: Validación por tipo de elemento
2. **Enfoque 2**: Validación manual spot-check
3. **Enfoque 3**: Análisis histórico (git log)
- Convergencia: Todos los enfoques llegan a ~95% válidos

### Chain-of-Verification
- **Paso 1**: Validación inicial (línea base)
- **Paso 2**: Cambios planificados y documentados
- **Paso 3**: Re-validación confirma mejoras

---

## Notas Importantes

- **Excepciones**: README, LICENSE, Dockerfile, Makefile son estándar
- **Conversión**: Usar script --fix para ver sugerencias antes de cambiar
- **Referencias**: Buscar y actualizar todas las referencias a archivos renombrados
- **Git**: Usar `git mv` si archivo está en control de versión
- **Meta**: 95%+ es meta realista, permite algunas excepciones documentadas
- **Convergencia**: Self-Consistency debe mostrar consistencia entre enfoques

---

## Referencias

- Script: `/home/user/IACT/scripts/qa/validate_naming.sh`
- Convención: snake_case (lowercase-with-dashes)
- Excepciones: README, LICENSE, Dockerfile, Makefile, etc
- Auto-CoT: Wei et al. (2022) - Chain-of-Thought Prompting
- Self-Consistency: Wang et al. (2022) - Multiple Generation Paths
- Meta de fase: ≥95% nomenclatura consistente
