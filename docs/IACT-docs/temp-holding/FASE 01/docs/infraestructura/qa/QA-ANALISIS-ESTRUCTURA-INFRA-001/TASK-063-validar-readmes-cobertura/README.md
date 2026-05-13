---
id: TASK-QA-INFRA-063
tipo: tarea
categoria: validacion
nombre: Validar READMEs 100% cobertura (Self-Consistency)
titulo: Validar que todas las carpetas tienen READMEs completos
fase: FASE_4_VALIDACION_Y_LIMPIEZA
prioridad: P0_CRITICA
duracion_estimada: 4h
estado: pendiente
dependencias: [TASK-QA-INFRA-062]
tecnicas: [Self-Consistency, Auto-CoT, Chain-of-Verification]
---

# TASK-063: Validar READMEs 100% Cobertura

**Objetivo:** Garantizar que 100% de carpetas en infraestructura tienen README.md completo con estructura consistente, usando Self-Consistency para validación múltiple de cobertura.

**Responsable:** @qa-engineer
**Restricciones:** Sin crear READMEs para carpetas .git, node_modules, o directorios técnicos del sistema.
**Técnica de prompting sugerida:** Self-Consistency + Auto-CoT + Chain-of-Verification (`docs/ai/prompting`).

---

## Auto-CoT: Razonamiento Paso a Paso

### Paso 1: Entender Propósito de READMEs

**Pensamiento**: ¿Por qué 100% de cobertura de READMEs?

**Importancia:**
1. **Navegación**: Cada carpeta debe explicar su propósito
2. **Onboarding**: Nuevos miembros entiendan estructura
3. **Documentación**: Mapa completo de proyecto
4. **Gobernanza**: Cada carpeta tiene responsable asignado
5. **Coherencia**: Estructura consistente en todo el proyecto

**Definición de "README Completo":**
- [ ] Archivo `README.md` existe en carpeta
- [ ] Contiene frontmatter YAML (metadatos)
- [ ] Título/descripción de propósito
- [ ] Estructura/contenido principal
- [ ] Enlaces a documentación relacionada
- [ ] Información de mantenedor si aplica

### Paso 2: Mapear Estructura de Carpetas Objetivo

**Pensamiento**: ¿Cuál es la estructura que debo validar?

**Identificación de Carpetas:**
```bash
# Listar todas las carpetas en infraestructura (excluyendo .git)
find /home/user/IACT/docs/infraestructura \
    -type d \
    ! -path "*/\.*" \
    ! -path "*/.git/*" \
    ! -path "*/node_modules/*" \
    | sort > /tmp/todas-carpetas.txt

# Contar total de carpetas
wc -l /tmp/todas-carpetas.txt
```

**Carpetas Críticas que SÍ necesitan README:**
- `docs/infraestructura/` (principal)
- `docs/infraestructura/diseno/` (grupo)
- `docs/infraestructura/diseno/arquitectura/`
- `docs/infraestructura/procedimientos/`
- `docs/infraestructura/qa/`
- Todas las subcarpetas con contenido

**Carpetas que NO necesitan README:**
- `evidencias/` (solo evidencia de tareas)
- `TASK-*` (tareas, verificar si necesitan)
- `.git/` (sistema)

### Paso 3: Búsqueda Inicial de READMEs - Enfoque 1 (Búsqueda Sistemática)

**Pensamiento**: ¿Cómo encontrar todos los READMEs?

**Enfoque 1: find command**
```bash
# Encontrar todos los READMEs
find /home/user/IACT/docs/infraestructura \
    -name "README.md" \
    -o -name "readme.md" \
    -o -name "ReadMe.md" \
    | sort > /tmp/readmes-encontrados.txt

# Contar READMEs
wc -l /tmp/readmes-encontrados.txt

# Crear lista de carpetas con README
find /home/user/IACT/docs/infraestructura \
    -name "README.md" \
    -exec dirname {} \; \
    | sort > /tmp/carpetas-con-readme.txt
```

**Enfoque 2: Búsqueda por patrón**
```bash
# Buscar archivos que empiezan con R y terminan con .md
find /home/user/IACT/docs/infraestructura \
    -iname "readme*" \
    | head -20
```

**Enfoque 3: Búsqueda por contenido**
```bash
# Buscar archivos con "README" en encabezado
grep -r "^# README" /home/user/IACT/docs/infraestructura/ \
    --include="*.md" | cut -d: -f1 | sort -u
```

### Paso 4: Comparar y Encontrar Brechas

**Pensamiento**: ¿Qué carpetas SÍ necesitan README pero no tienen?

**Análisis de Brechas:**
```bash
# Carpetas con README
cat /tmp/carpetas-con-readme.txt | head -10

# Carpetas SIN README (en estructura principal)
comm -23 \
    <(find /home/user/IACT/docs/infraestructura -mindepth 1 -maxdepth 3 -type d ! -path "*/\.*" | sort) \
    <(find /home/user/IACT/docs/infraestructura -name "README.md" -exec dirname {} \; | sort) \
    > /tmp/carpetas-sin-readme.txt

# Ver carpetas que faltan README
cat /tmp/carpetas-sin-readme.txt | head -20
```

### Paso 5: Validación de Contenido - Self-Consistency Enfoque 1

**Pensamiento**: ¿Son los READMEs completos y correcto?

**Enfoque 1: Verificación de Estructura YAML**
```bash
# Para cada README, verificar frontmatter
for readme in $(find /home/user/IACT/docs/infraestructura -name "README.md"); do
    # Verificar que tiene frontmatter
    if grep -q "^---" "$readme"; then
        echo "[OK] $readme tiene frontmatter"
    else
        echo "[ERROR] $readme SIN frontmatter"
    fi
done | grep "[ERROR]" > /tmp/readmes-sin-frontmatter.txt
```

**Enfoque 2: Verificación de Contenido Mínimo**
```bash
# Verificar que cada README tiene al menos:
# - Título (# o ## al inicio)
# - Descripción
# - Enlaces o estructura

for readme in $(find /home/user/IACT/docs/infraestructura -name "README.md"); do
    lines=$(wc -l < "$readme")

    if [ "$lines" -lt 5 ]; then
        echo "CORTO: $readme ($lines líneas)"
    fi
done > /tmp/readmes-muy-cortos.txt
```

**Enfoque 3: Verificación Manual Spot-Check**
```bash
# Seleccionar 10 READMEs aleatorios y verificar manualmente
find /home/user/IACT/docs/infraestructura -name "README.md" \
    | shuf | head -10 > /tmp/readmes-verificar-manual.txt

# Para cada README en la lista:
# 1. Ver contenido
# 2. Verificar que explica propósito
# 3. Verificar que tiene estructura coherente
# 4. Documentar en evidencias
```

### Paso 6: Auto-CoT para Decisiones sobre READMEs Faltantes

**Pensamiento**: ¿Qué hago con carpetas sin README?

**Decisión 1: ¿Carpeta necesita contenido?**
```
Si: contenido documentación → SÍ necesita README
Si: solo archivos técnicos (config, logs) → Evaluar caso por caso
Si: carpeta vacía → NO necesita README
Si: carpeta legacy/temporal → NO necesita README
```

**Decisión 2: ¿README ya existe bajo otro nombre?**
```bash
# Buscar INDEX, GUIA, DOCUMENTACION, etc
for carpeta in $(cat /tmp/carpetas-sin-readme.txt | head -5); do
    echo "Carpeta: $carpeta"
    ls -la "$carpeta" | grep -iE "index|guide|documentation|readme"
done
```

**Decisión 3: ¿Contenido debería estar en README del padre?**
```
Si: carpeta es sub-componente muy pequeño → Link en padre
Si: carpeta es componente autónomo → Propio README
```

### Paso 7: Documentar Estado Actual

**Pensamiento**: ¿Cómo registrar lo que encontramos?

**Reporte de Estado:**
```markdown
# Reporte de Cobertura de READMEs - Validación Inicial

## Resumen
- Total carpetas con contenido: XXX
- Carpetas con README: YYY (YY%)
- Carpetas sin README: ZZZ (ZZ%)
- Carpetas que necesitan README: AAA

## Categorías de Falta

### 1. Carpetas principales sin README
- /docs/infraestructura/carpeta-A
- /docs/infraestructura/carpeta-B

### 2. Sub-carpetas sin README
- (por completar)

### 3. READMEs incompletos
- (por completar)

## Acción Requerida
- [ ] Crear README para carpetas críticas
- [ ] Actualizar READMEs incompletos
- [ ] Validar frontmatter en todos
- [ ] Ejecutar validación final
```

### Paso 8: Plan de Correcciones

**Pensamiento**: ¿Cómo procedo a completar cobertura?

**Priorización:**
1. **Alta Prioridad**: Carpetas de documentación principal
2. **Media Prioridad**: Sub-carpetas de componentes importantes
3. **Baja Prioridad**: Carpetas técnicas/config

**Plantilla de README:**
```markdown
---
id: CARP-INFRA-XXX
tipo: documentacion
categoria: guia
titulo: [Nombre de la Carpeta]
descripcion: Breve descripción del propósito
---

# [Nombre de la Carpeta]

## Propósito
[Explicar qué contiene esta carpeta y por qué existe]

## Estructura
- [Sub-carpeta A]: [descripción]
- [Sub-carpeta B]: [descripción]

## Documentación Relacionada
- [Link a README padre]
- [Link a documentación relacionada]

## Mantenedor
[Quién mantiene esta carpeta]
```

### Paso 9: Validación Post-Corrección

**Pensamiento**: ¿Cómo verificar que completé la cobertura?

**Re-validación:**
```bash
# Ejecutar búsqueda de READMEs nuevamente
find /home/user/IACT/docs/infraestructura \
    -name "README.md" \
    | wc -l

# Comparar con línea base
# Meta: 100% de carpetas necesarias tienen README
```

---

## Self-Consistency: Validación Múltiple

### Enfoque 1: Búsqueda Sistemática (find)

**Proceso:**
1. Usar `find /docs/infraestructura -name "README.md"` (case-sensitive)
2. Usar `find /docs/infraestructura -iname "readme.md"` (case-insensitive)
3. Usar `find /docs/infraestructura -name "README*"` (variaciones)
4. Contar resultados en cada búsqueda
5. Verificar convergencia

**Resultado esperado:**
```
find -name "README.md": XXX resultados
find -iname "readme.md": XXX resultados (mismo número)
find -name "README*": XXX+ resultados (incluye README.en, README.es, etc)
```

### Enfoque 2: Búsqueda por Contenido

**Proceso:**
1. Buscar archivos que contengan "---" (frontmatter)
2. Buscar archivos que empiezan con "#" (títulos markdown)
3. Buscar archivos en raíces de carpeta
4. Validar que coinciden con encuentros de find

**Validación:**
```bash
# Archivos markdown con frontmatter en raíces de carpeta
find /home/user/IACT/docs/infraestructura -maxdepth 2 -name "*.md" | while read f; do
    if grep -q "^---" "$f"; then
        basename "$(dirname "$f")"
    fi
done | sort -u > /tmp/carpetas-con-documentacion-frontmatter.txt

# Comparar con resultado de find README.md
sort -u /tmp/carpetas-con-readme.txt > /tmp/readme-list.txt
sort -u /tmp/carpetas-con-documentacion-frontmatter.txt > /tmp/frontmatter-list.txt

# Diferencias
diff /tmp/readme-list.txt /tmp/frontmatter-list.txt
```

### Enfoque 3: Validación Manual Estratégica

**Proceso:**
1. Seleccionar carpetas aleatorias (10% del total)
2. Navegar manualmente a cada una
3. Verificar presencia de README.md
4. Verificar contenido es relevante
5. Documentar discrepancias

**Checklist Manual:**
```
Carpeta: [nombre]
- [ ] README.md existe: SI / NO
- [ ] Tiene frontmatter: SI / NO
- [ ] Tiene título: SI / NO
- [ ] Tiene descripción: SI / NO
- [ ] Estructura clara: SI / NO
- [ ] Notas: [cualquier observación]
```

### Convergencia de Enfoques

**Validación final:**
```
Enfoque 1 (find):        XXX READMEs encontrados
Enfoque 2 (contenido):   XXX carpetas con documentación
Enfoque 3 (manual):      100% de muestras válidas

Conclusión: [COMPLETADO] Convergencia - Todos los enfoques indican XXX READMEs
```

---

## Criterios de Aceptación

- [ ] 100% de carpetas de documentación tienen README.md
- [ ] 100% de READMEs contienen frontmatter YAML válido
- [ ] 100% de READMEs contienen descripción del propósito
- [ ] ≥90% de READMEs contienen estructura/navegación
- [ ] Self-Consistency validada: 3 enfoques ejecutados
- [ ] Convergencia documentada entre enfoques
- [ ] Reporte final completo en evidencias

## Entregables

### 1. Inventario Inicial de Carpetas
**Archivo**: `evidencias/01-inventario-carpetas-inicial.txt`
```
Total carpetas: XXX
Carpetas con contenido: YYY
Carpetas que necesitan README: ZZZ
```

### 2. Análisis de Cobertura - Enfoque 1 (find)
**Archivo**: `evidencias/02a-busqueda-find-results.txt`
```
Comando: find /docs/infraestructura -name "README.md"
Resultados: XXX archivos encontrados
Carpetas con README: YYY
```

### 3. Análisis de Cobertura - Enfoque 2 (contenido)
**Archivo**: `evidencias/02b-busqueda-contenido-results.txt`
```
Archivos con frontmatter: XXX
Archivos con título: XXX
Archivos con descripción: XXX
```

### 4. Análisis de Cobertura - Enfoque 3 (manual)
**Archivo**: `evidencias/02c-validacion-manual-results.md`
```markdown
## Muestreo Manual (10% de carpetas)

Carpeta 1: [COMPLETADO] README completo
Carpeta 2: [WARNING] README incompleto - sin estructura
Carpeta 3: [ERROR] Sin README
...

Conclusión: 70% de muestras válidas, necesita corrección
```

### 4. Reporte de READMEs Faltantes
**Archivo**: `evidencias/03-readmes-faltantes.md`
```markdown
# READMEs Faltantes - Listado Completo

## Carpetas que Necesitan README (Crítico)
1. /docs/infraestructura/carpeta-A - [razón]
2. /docs/infraestructura/carpeta-B - [razón]

## Carpetas con README Incompleto (Revisión)
1. /docs/infraestructura/carpeta-C - [qué falta]
2. /docs/infraestructura/carpeta-D - [qué falta]

## Total
- Faltantes: X
- Incompletos: Y
- Válidos: Z
```

### 5. READMEs Creados/Actualizados
**Archivo**: `evidencias/04-readmes-creados-actualizados.md`
```markdown
# READMEs Creados y Actualizados

## Nuevos
1. /docs/infraestructura/carpeta-A/README.md - [fecha creación]
2. /docs/infraestructura/carpeta-B/README.md - [fecha creación]

## Actualizados
1. /docs/infraestructura/carpeta-C/README.md - [cambios aplicados]
2. /docs/infraestructura/carpeta-D/README.md - [cambios aplicados]

## Validación Post-Cambio
- Total READMEs: Z
- Cobertura: 100%
```

### 6. Reporte Final de Validación
**Archivo**: `evidencias/05-validacion-final-reporte.json`
```json
{
  "fecha": "2025-11-XX",
  "resumen": {
    "total_carpetas": XXX,
    "carpetas_con_readme": YYY,
    "cobertura_porcentaje": "100%",
    "estado": "COMPLETADA"
  },
  "self_consistency": {
    "enfoque_1_find": XXX,
    "enfoque_2_contenido": XXX,
    "enfoque_3_manual": "100%",
    "convergencia": "[COMPLETADO] CONFIRMADA"
  }
}
```

---

## Checklist de Ejecución

### Fase 1: Preparación
- [ ] Directorio target confirmado
- [ ] Directorio de evidencias creado
- [ ] Parámetros de búsqueda definidos (qué es "carpeta con contenido")
- [ ] Plantilla de README disponible

### Fase 2: Búsqueda Inicial (Enfoque 1)
- [ ] find executed para buscar README.md
- [ ] find executed para buscar readme.md (case-insensitive)
- [ ] Resultados capturados en archivo
- [ ] Conteo realizado
- [ ] Análisis de gaps completado

### Fase 3: Búsqueda Alternativa (Enfoque 2)
- [ ] Búsqueda por contenido (frontmatter) ejecutada
- [ ] Búsqueda por estructura (títulos) ejecutada
- [ ] Resultados comparados con Enfoque 1
- [ ] Discrepancias analizadas

### Fase 4: Validación Manual (Enfoque 3)
- [ ] 10% de carpetas seleccionadas aleatoriamente
- [ ] Verificación manual completada
- [ ] Checklist documentado
- [ ] Resultados registrados

### Fase 5: Convergencia
- [ ] Tres enfoques ejecutados
- [ ] Resultados comparados
- [ ] Convergencia documentada
- [ ] Conclusiones extraídas

### Fase 6: Correcciones
- [ ] Carpetas faltantes identificadas
- [ ] READMEs creados/actualizados
- [ ] Frontmatter validado
- [ ] Contenido revisado

### Fase 7: Re-validación
- [ ] Búsqueda final ejecutada
- [ ] Cobertura verificada (100%)
- [ ] Convergencia re-confirmada
- [ ] Reporte final generado

---

## Guía de Ejecución Rápida

### Búsqueda Enfoque 1 (5 min)
```bash
find /home/user/IACT/docs/infraestructura -name "README.md" | tee busqueda-1.txt | wc -l
find /home/user/IACT/docs/infraestructura -iname "readme.md" | tee busqueda-1b.txt | wc -l
```

### Búsqueda Enfoque 2 (10 min)
```bash
# Archivos markdown en raíces de carpeta con frontmatter
find /home/user/IACT/docs/infraestructura -maxdepth 2 -name "*.md" \
    -exec grep -l "^---" {} \; | tee busqueda-2.txt | wc -l
```

### Validación Manual (30 min)
```bash
# Seleccionar 10% aleatorio
find /home/user/IACT/docs/infraestructura -name "README.md" \
    | shuf | head -10 > verificar-manual.txt

# Para cada uno: cat y evaluar manualmente
while read f; do
    echo "=== $f ==="
    head -20 "$f"
done < verificar-manual.txt
```

### Convergencia (5 min)
```bash
# Comparar conteos
echo "Enfoque 1: $(wc -l < busqueda-1.txt)"
echo "Enfoque 2: $(wc -l < busqueda-2.txt)"
# Deben ser iguales o muy similares
```

### Crear Reporte Final (10 min)
```bash
cat > reporte-final.md << 'EOF'
# Reporte Final - Validación de READMEs

## Resumen
- Carpetas analizadas: XXX
- Cobertura: YYY%
- Estado: [COMPLETADO] COMPLETADA

## Self-Consistency
- Enfoque 1 (find): XXX resultados
- Enfoque 2 (contenido): XXX resultados
- Enfoque 3 (manual): 100% válidos
- Convergencia: [COMPLETADO] CONFIRMADA
EOF
```

---

## Técnicas de Prompting

### Auto-CoT
1. **Entender**: Propósito de READMEs (navegación, onboarding)
2. **Definir**: Qué es un README "completo"
3. **Mapear**: Estructura de carpetas objetivo
4. **Buscar**: Ubicar READMEs existentes (3 métodos)
5. **Analizar**: Identificar gaps
6. **Decidir**: Qué carpetas necesitan README
7. **Crear**: READMEs faltantes
8. **Validar**: Verificar 100% cobertura

### Self-Consistency
1. **Enfoque 1**: Búsqueda sistemática con find
2. **Enfoque 2**: Búsqueda por contenido (análisis de archivos)
3. **Enfoque 3**: Validación manual (spot-check)
- Convergencia: Todos los enfoques deben indicar mismo cobertura %

### Chain-of-Verification
1. Búsqueda inicial → Inventario de READMEs existentes
2. Análisis → Identificación de gaps
3. Creación → READMEs faltantes creados
4. Validación → Búsqueda final confirma 100%

---

## Notas Importantes

- **Excepciones**: No crear README para carpetas técnicas (.git, node_modules, etc)
- **Formato**: Usar plantilla consistente para nuevos READMEs
- **Frontmatter**: Todos deben tener metadatos YAML con id, titulo, etc
- **Navegación**: READMEs deben enlazar hacia arriba (padre) y abajo (hijos)
- **Contenido**: Explicar propósito y estructura de la carpeta
- **Convergencia**: Self-Consistency debe mostrar consistencia entre 3 enfoques

---

## Referencias

- Plantilla: `docs/infraestructura/plantillas/README-template.md`
- Script correlativo: TASK-063 relacionado con TASK-062 (enlaces)
- Técnica: Self-Consistency + Auto-CoT
- Meta de fase: 100% cobertura de documentación navegable
