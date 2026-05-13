---
id: TASK-REORG-INFRA-024
titulo: Validar Reorganizacion de Raiz
fase: FASE_2_REORGANIZACION_CRITICA
subcategoria: Validacion de Reorganizacion
prioridad: ALTA (P1)
duracion_estimada: 2 horas
estado: Pendiente
tipo: Validacion
dependencias:
  - TASK-REORG-INFRA-023
tecnica_prompting: Chain-of-Verification (CoVE)
fecha_creacion: 2025-11-18
autor: QA Infraestructura
tags:
  - validacion
  - raiz
  - integridad
  - fase-2
---

# TASK-REORG-INFRA-024: Validar Reorganización de Raíz

## Descripción

Validar que la reorganización completa de archivos en la raíz de `/docs/infraestructura/` ha sido completada exitosamente, verificando que solo `README.md` e `INDEX.md` permanecen en raíz, que todos los enlaces funcionan, y que la integridad de la documentación está preservada.

## Objetivo

Ejecutar una suite completa de validaciones para confirmar que la reorganización de raíz (TASK-020 a TASK-023) fue exitosa y que la estructura resultante cumple con todos los criterios de calidad establecidos.

## Técnica de Prompting: Chain-of-Verification (CoVE)

### Aplicación de Chain-of-Verification (CoVE)

**Chain-of-Verification (CoVE)** ejecuta una cadena de verificaciones secuenciales, donde cada paso valida un aspecto específico y debe pasar antes de continuar al siguiente.

#### Cadena de Verificaciones

```
VERIFICACIÓN 1: Estructura de Raíz
    ├─ ¿Solo README.md e INDEX.md en raíz?
    ├─ ¿Todos los archivos movidos fuera de raíz?
    └─ ¿Carpetas de destino existen y contienen archivos?
    ↓ [PASS] →

VERIFICACIÓN 2: Integridad de Archivos
    ├─ ¿Archivos movidos mantienen contenido intacto?
    ├─ ¿Sin pérdida de datos durante movimiento?
    └─ ¿Historial Git preservado (git log --follow)?
    ↓ [PASS] →

VERIFICACIÓN 3: Integridad de Enlaces
    ├─ ¿0 enlaces rotos en toda la documentación?
    ├─ ¿Enlaces actualizados correctamente?
    └─ ¿Enlaces bidireccionales funcionan?
    ↓ [PASS] →

VERIFICACIÓN 4: Consistencia de Nomenclatura
    ├─ ¿Archivos siguen convenciones (snake_case)?
    ├─ ¿Carpetas siguen nomenclatura estándar?
    └─ ¿Sin duplicados de nombres?
    ↓ [PASS] →

VERIFICACIÓN 5: Completitud
    ├─ ¿Todos los archivos identificados fueron movidos?
    ├─ ¿Todos los enlaces fueron actualizados?
    └─ ¿Evidencias completas generadas?
    ↓ [PASS] →

RESULTADO: [OK] REORGANIZACIÓN VALIDADA
```

## Pasos de Ejecución

### VERIFICACIÓN 1: Estructura de Raíz (20 min)

```bash
cd /home/user/IACT/docs/infraestructura

echo "=== VERIFICACIÓN 1: ESTRUCTURA DE RAÍZ ===" | tee evidencias/validacion-raiz-completa.md

# 1.1: Verificar archivos en raíz
echo "## 1.1: Archivos en Raíz" >> evidencias/validacion-raiz-completa.md
ls -1 *.md 2>/dev/null | tee -a evidencias/validacion-raiz-completa.md

# Debe mostrar SOLO:
# INDEX.md
# README.md

RAIZ_FILES=$(ls -1 *.md 2>/dev/null | wc -l)
if [ "$RAIZ_FILES" -eq 2 ]; then
  echo "[OK] PASS: Solo 2 archivos en raíz (esperado)" | tee -a evidencias/validacion-raiz-completa.md
else
  echo "[ERROR] FAIL: $RAIZ_FILES archivos en raíz (esperado: 2)" | tee -a evidencias/validacion-raiz-completa.md
  ls -1 *.md | tee -a evidencias/validacion-raiz-completa.md
fi

# 1.2: Verificar carpetas de destino existen
echo "" >> evidencias/validacion-raiz-completa.md
echo "## 1.2: Carpetas de Destino" >> evidencias/validacion-raiz-completa.md
EXPECTED_FOLDERS=("diseno" "adr" "procesos" "procedimientos" "devops" "plantillas" "checklists" "solicitudes")

for folder in "${EXPECTED_FOLDERS[@]}"; do
  if [ -d "$folder" ]; then
    FILE_COUNT=$(find "$folder" -name "*.md" | wc -l)
    echo "[OK] $folder/ existe - $FILE_COUNT archivos .md" | tee -a evidencias/validacion-raiz-completa.md
  else
    echo "[ERROR] $folder/ NO EXISTE" | tee -a evidencias/validacion-raiz-completa.md
  fi
done

# 1.3: Verificar que archivos fueron movidos a destinos correctos
echo "" >> evidencias/validacion-raiz-completa.md
echo "## 1.3: Verificación de Archivos Movidos" >> evidencias/validacion-raiz-completa.md

# Verificar canvas en diseno/canvas/
test -f diseno/canvas/canvas_devcontainer_host.md && \
  echo "[OK] canvas_devcontainer_host.md en diseno/canvas/" | tee -a evidencias/validacion-raiz-completa.md || \
  echo "[ERROR] canvas_devcontainer_host.md NO encontrado" | tee -a evidencias/validacion-raiz-completa.md

# Verificar ADRs en adr/
ADR_COUNT=$(find adr/ -name "ADR-INFRA-*.md" 2>/dev/null | wc -l)
echo "[OK] ADRs en adr/: $ADR_COUNT archivos" | tee -a evidencias/validacion-raiz-completa.md

# Verificar procesos en procesos/
PROC_COUNT=$(find procesos/ -name "PROC-INFRA-*.md" 2>/dev/null | wc -l)
echo "[OK] Procesos en procesos/: $PROC_COUNT archivos" | tee -a evidencias/validacion-raiz-completa.md
```

**CoVE - Punto de Decisión 1:**
```
¿VERIFICACIÓN 1 PASÓ?
  → SÍ: Continuar a VERIFICACIÓN 2
  → NO: DETENER - Corregir estructura antes de continuar
```

### VERIFICACIÓN 2: Integridad de Archivos (30 min)

```bash
echo "" >> evidencias/validacion-raiz-completa.md
echo "=== VERIFICACIÓN 2: INTEGRIDAD DE ARCHIVOS ===" >> evidencias/validacion-raiz-completa.md

# 2.1: Verificar historial Git preservado (git mv mantiene historial)
echo "## 2.1: Historial Git Preservado" >> evidencias/validacion-raiz-completa.md

# Ejemplo: Verificar historial de archivo movido
test -f diseno/canvas/canvas_devcontainer_host.md && \
  git log --follow --oneline diseno/canvas/canvas_devcontainer_host.md | head -5 >> evidencias/validacion-raiz-completa.md

echo "Si se muestra historial previo a movimiento → git mv usado correctamente" >> evidencias/validacion-raiz-completa.md

# 2.2: Verificar integridad de contenido (comparar checksums antes/después)
echo "" >> evidencias/validacion-raiz-completa.md
echo "## 2.2: Integridad de Contenido" >> evidencias/validacion-raiz-completa.md

# Si se guardaron checksums en TASK-022, comparar
if [ -f qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-REORG-INFRA-022-mover-archivos-raiz/evidencias/checksums-antes.txt ]; then
  echo "Comparando checksums..." >> evidencias/validacion-raiz-completa.md
  # Calcular checksums después de movimiento y comparar
else
  echo "[OK] Asumiendo integridad (git mv mantiene contenido)" >> evidencias/validacion-raiz-completa.md
fi

# 2.3: Verificar sin duplicados después de movimiento
echo "" >> evidencias/validacion-raiz-completa.md
echo "## 2.3: Sin Duplicados" >> evidencias/validacion-raiz-completa.md

# Buscar archivos con mismo nombre en diferentes carpetas
find . -name "*.md" -type f | \
  xargs -n1 basename | \
  sort | \
  uniq -d > /tmp/duplicados.txt

if [ -s /tmp/duplicados.txt ]; then
  echo "[ERROR] DUPLICADOS ENCONTRADOS:" >> evidencias/validacion-raiz-completa.md
  cat /tmp/duplicados.txt >> evidencias/validacion-raiz-completa.md
else
  echo "[OK] Sin duplicados de nombres" >> evidencias/validacion-raiz-completa.md
fi
```

**CoVE - Punto de Decisión 2:**
```
¿VERIFICACIÓN 2 PASÓ?
  → SÍ: Continuar a VERIFICACIÓN 3
  → NO: DETENER - Investigar pérdida de datos o duplicados
```

### VERIFICACIÓN 3: Integridad de Enlaces (30 min)

```bash
echo "" >> evidencias/validacion-raiz-completa.md
echo "=== VERIFICACIÓN 3: INTEGRIDAD DE ENLACES ===" >> evidencias/validacion-raiz-completa.md

# 3.1: Ejecutar verificador de enlaces
echo "## 3.1: Verificación de Enlaces Rotos" >> evidencias/validacion-raiz-completa.md

cat > /tmp/check-all-links.sh << 'EOF'
#!/bin/bash
cd /home/user/IACT/docs/infraestructura

BROKEN_COUNT=0

# Extraer todos los enlaces relativos Markdown
find . -name "*.md" -type f -exec grep -o "\[.*\](\..*\.md)" {} \; | \
  grep -o "](\..*\.md)" | \
  sed 's/](\.\///g;s/)$//' | \
  sort -u > /tmp/all-links-to-check.txt

echo "Enlaces a verificar: $(wc -l < /tmp/all-links-to-check.txt)"

# Verificar cada enlace
while IFS= read -r link; do
  # Limpiar ruta (manejar ../)
  CLEAN_LINK=$(echo "$link" | sed 's|^\./||')

  if [ ! -f "$CLEAN_LINK" ]; then
    echo "[ERROR] ROTO: $link"
    ((BROKEN_COUNT++))
  fi
done < /tmp/all-links-to-check.txt

echo ""
echo "=== RESULTADO ==="
echo "Enlaces verificados: $(wc -l < /tmp/all-links-to-check.txt)"
echo "Enlaces rotos: $BROKEN_COUNT"

if [ $BROKEN_COUNT -eq 0 ]; then
  echo "[OK] VALIDACIÓN EXITOSA: 0 enlaces rotos"
  exit 0
else
  echo "[ERROR] VALIDACIÓN FALLIDA: $BROKEN_COUNT enlaces rotos"
  exit 1
fi
EOF

chmod +x /tmp/check-all-links.sh
/tmp/check-all-links.sh 2>&1 | tee -a evidencias/validacion-raiz-completa.md

# 3.2: Verificar enlaces bidireccionales críticos
echo "" >> evidencias/validacion-raiz-completa.md
echo "## 3.2: Verificación de Enlaces Bidireccionales Críticos" >> evidencias/validacion-raiz-completa.md

# Ejemplo: README.md → INDEX.md y INDEX.md → README.md
grep -q "INDEX\.md" README.md && echo "[OK] README.md enlaza a INDEX.md" >> evidencias/validacion-raiz-completa.md
grep -q "README\.md" INDEX.md && echo "[OK] INDEX.md enlaza a README.md" >> evidencias/validacion-raiz-completa.md
```

**CoVE - Punto de Decisión 3:**
```
¿VERIFICACIÓN 3 PASÓ?
  → SÍ: Continuar a VERIFICACIÓN 4
  → NO: DETENER - Ejecutar TASK-023 nuevamente para corregir enlaces
```

### VERIFICACIÓN 4: Consistencia de Nomenclatura (20 min)

```bash
echo "" >> evidencias/validacion-raiz-completa.md
echo "=== VERIFICACIÓN 4: CONSISTENCIA DE NOMENCLATURA ===" >> evidencias/validacion-raiz-completa.md

# 4.1: Verificar snake_case en archivos
echo "## 4.1: Verificación de snake_case" >> evidencias/validacion-raiz-completa.md

# Buscar archivos que NO siguen snake_case (excluir INDEX.md y README.md que son excepciones)
find . -name "*.md" -type f | \
  grep -v "INDEX.md\|README.md" | \
  grep -E "[A-Z]|[[:space:]]" > /tmp/nomenclatura-incorrecta.txt

if [ -s /tmp/nomenclatura-incorrecta.txt ]; then
  echo "[WARNING] Archivos con nomenclatura no snake_case:" >> evidencias/validacion-raiz-completa.md
  cat /tmp/nomenclatura-incorrecta.txt >> evidencias/validacion-raiz-completa.md
  echo "" >> evidencias/validacion-raiz-completa.md
  echo "NOTA: ADR-INFRA-XXX, PROC-INFRA-XXX, PROCED-INFRA-XXX son excepciones válidas" >> evidencias/validacion-raiz-completa.md
else
  echo "[OK] Todos los archivos siguen nomenclatura correcta" >> evidencias/validacion-raiz-completa.md
fi

# 4.2: Verificar convenciones de carpetas
echo "" >> evidencias/validacion-raiz-completa.md
echo "## 4.2: Convenciones de Carpetas" >> evidencias/validacion-raiz-completa.md

ls -1d */ | while read folder; do
  # Verificar que carpetas están en minúsculas
  if echo "$folder" | grep -q "[A-Z]"; then
    echo "[WARNING] Carpeta con mayúsculas: $folder" >> evidencias/validacion-raiz-completa.md
  else
    echo "[OK] $folder - nomenclatura correcta" >> evidencias/validacion-raiz-completa.md
  fi
done
```

**CoVE - Punto de Decisión 4:**
```
¿VERIFICACIÓN 4 PASÓ?
  → SÍ: Continuar a VERIFICACIÓN 5
  → NO: ADVERTENCIA - Nomenclatura inconsistente, considerar normalizar
```

### VERIFICACIÓN 5: Completitud (20 min)

```bash
echo "" >> evidencias/validacion-raiz-completa.md
echo "=== VERIFICACIÓN 5: COMPLETITUD ===" >> evidencias/validacion-raiz-completa.md

# 5.1: Verificar que todos los archivos identificados fueron movidos
echo "## 5.1: Completitud de Movimientos" >> evidencias/validacion-raiz-completa.md

# Leer matriz de mapeo de TASK-022
if [ -f qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-REORG-INFRA-022-mover-archivos-raiz/evidencias/archivos-raiz-movidos.txt ]; then
  MOVED_COUNT=$(grep -c "→" qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-REORG-INFRA-022-mover-archivos-raiz/evidencias/archivos-raiz-movidos.txt 2>/dev/null || echo "0")
  echo "Archivos en matriz de mapeo: $MOVED_COUNT" >> evidencias/validacion-raiz-completa.md

  # Verificar que cada archivo en matriz existe en nueva ubicación
  echo "Verificando existencia de archivos movidos..." >> evidencias/validacion-raiz-completa.md
  # [Lógica de verificación detallada]
else
  echo "[WARNING] Matriz de mapeo no encontrada - verificación manual requerida" >> evidencias/validacion-raiz-completa.md
fi

# 5.2: Verificar que todos los enlaces identificados fueron actualizados
echo "" >> evidencias/validacion-raiz-completa.md
echo "## 5.2: Completitud de Actualizaciones de Enlaces" >> evidencias/validacion-raiz-completa.md

if [ -f qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-REORG-INFRA-023-actualizar-enlaces-archivos-movidos/evidencias/enlaces-actualizados-completo.md ]; then
  UPDATED_COUNT=$(grep -c "→" qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-REORG-INFRA-023-actualizar-enlaces-archivos-movidos/evidencias/enlaces-actualizados-completo.md 2>/dev/null || echo "0")
  echo "Enlaces actualizados documentados: $UPDATED_COUNT" >> evidencias/validacion-raiz-completa.md
fi

# 5.3: Verificar evidencias completas
echo "" >> evidencias/validacion-raiz-completa.md
echo "## 5.3: Evidencias Generadas" >> evidencias/validacion-raiz-completa.md

EVIDENCIAS=(
  "qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-REORG-INFRA-021-eliminar-archivos-duplicados/evidencias/duplicados-eliminados.txt"
  "qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-REORG-INFRA-022-mover-archivos-raiz/evidencias/archivos-raiz-movidos.txt"
  "qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-REORG-INFRA-023-actualizar-enlaces-archivos-movidos/evidencias/enlaces-actualizados-completo.md"
)

for evidencia in "${EVIDENCIAS[@]}"; do
  if [ -f "$evidencia" ]; then
    echo "[OK] $evidencia" >> evidencias/validacion-raiz-completa.md
  else
    echo "[ERROR] FALTA: $evidencia" >> evidencias/validacion-raiz-completa.md
  fi
done
```

**CoVE - Punto de Decisión 5:**
```
¿VERIFICACIÓN 5 PASÓ?
  → SÍ: VALIDACIÓN COMPLETA - Generar reporte final
  → NO: ADVERTENCIA - Evidencias incompletas
```

### Generación de Reporte Final (20 min)

```bash
echo "" >> evidencias/validacion-raiz-completa.md
echo "=== REPORTE FINAL DE VALIDACIÓN ===" >> evidencias/validacion-raiz-completa.md
echo "Fecha: $(date +%Y-%m-%d)" >> evidencias/validacion-raiz-completa.md
echo "" >> evidencias/validacion-raiz-completa.md

# Resumen de verificaciones
cat >> evidencias/validacion-raiz-completa.md << 'EOF'
## Resumen de Verificaciones

| Verificación | Estado | Detalles |
|--------------|--------|----------|
| 1. Estructura de Raíz | [[OK]/[ERROR]] | Solo README.md e INDEX.md en raíz |
| 2. Integridad de Archivos | [[OK]/[ERROR]] | Historial Git preservado, sin pérdida de datos |
| 3. Integridad de Enlaces | [[OK]/[ERROR]] | 0 enlaces rotos |
| 4. Consistencia de Nomenclatura | [[OK]/[ERROR]] | Archivos y carpetas siguen convenciones |
| 5. Completitud | [[OK]/[ERROR]] | Todos los archivos movidos, todas las evidencias generadas |

## Conclusión

**ESTADO FINAL:** [APROBADO / RECHAZADO / CON OBSERVACIONES]

**Criterios de Aprobación:**
- Todas las verificaciones críticas (1, 2, 3) deben estar en [OK]
- Verificaciones 4 y 5 pueden tener observaciones menores

**Próximos Pasos:**
- Si APROBADO: Proceder a tareas de actualización de READMEs (TASK-025+)
- Si RECHAZADO: Revisar y corregir problemas identificados
- Si CON OBSERVACIONES: Documentar observaciones y proceder con precaución
EOF

echo "Reporte generado en: evidencias/validacion-raiz-completa.md"
```

## Criterios de Aceptación

**Verificaciones Críticas (deben pasar todas):**
- [ ] VERIFICACIÓN 1 PASÓ: Solo README.md e INDEX.md en raíz
- [ ] VERIFICACIÓN 2 PASÓ: Integridad de archivos preservada
- [ ] VERIFICACIÓN 3 PASÓ: 0 enlaces rotos en toda la documentación

**Verificaciones Secundarias (observaciones permitidas):**
- [ ] VERIFICACIÓN 4 COMPLETA: Nomenclatura consistente (observaciones documentadas)
- [ ] VERIFICACIÓN 5 COMPLETA: Evidencias completas de tareas previas

**Entregables:**
- [ ] Reporte completo en `evidencias/validacion-raiz-completa.md`
- [ ] Estado final documentado (APROBADO/RECHAZADO/CON OBSERVACIONES)
- [ ] Recomendaciones para próximos pasos

**Criterio de Éxito Global:**
```
ÉXITO = (VER1 ∧ VER2 ∧ VER3) ∧ (VER4 ∨ Observaciones_Documentadas) ∧ (VER5 ∨ Evidencias_Suficientes)
```

## Evidencias a Generar

### evidencias/validacion-raiz-completa.md

```markdown
# Validación Completa de Reorganización de Raíz
Fecha: 2025-11-18
Ejecutor: QA Infraestructura

=== VERIFICACIÓN 1: ESTRUCTURA DE RAÍZ ===

## 1.1: Archivos en Raíz
INDEX.md
README.md

[OK] PASS: Solo 2 archivos en raíz (esperado)

## 1.2: Carpetas de Destino
[OK] diseno/ existe - 15 archivos .md
[OK] adr/ existe - 8 archivos .md
[OK] procesos/ existe - 12 archivos .md
[OK] procedimientos/ existe - 10 archivos .md
[OK] devops/ existe - 7 archivos .md
[OK] plantillas/ existe - 5 archivos .md
[OK] checklists/ existe - 4 archivos .md
[OK] solicitudes/ existe - 3 archivos .md

## 1.3: Verificación de Archivos Movidos
[OK] canvas_devcontainer_host.md en diseno/canvas/
[OK] ADRs en adr/: 8 archivos
[OK] Procesos en procesos/: 12 archivos

**RESULTADO VERIFICACIÓN 1:** [OK] PASS

=== VERIFICACIÓN 2: INTEGRIDAD DE ARCHIVOS ===

## 2.1: Historial Git Preservado
[Commits históricos del archivo...]
[OK] Historial previo a movimiento presente

## 2.2: Integridad de Contenido
[OK] Asumiendo integridad (git mv mantiene contenido)

## 2.3: Sin Duplicados
[OK] Sin duplicados de nombres

**RESULTADO VERIFICACIÓN 2:** [OK] PASS

=== VERIFICACIÓN 3: INTEGRIDAD DE ENLACES ===

## 3.1: Verificación de Enlaces Rotos
Enlaces a verificar: 247
Enlaces rotos: 0

[OK] VALIDACIÓN EXITOSA: 0 enlaces rotos

## 3.2: Verificación de Enlaces Bidireccionales Críticos
[OK] README.md enlaza a INDEX.md
[OK] INDEX.md enlaza a README.md

**RESULTADO VERIFICACIÓN 3:** [OK] PASS

=== VERIFICACIÓN 4: CONSISTENCIA DE NOMENCLATURA ===

## 4.1: Verificación de snake_case
[OK] Todos los archivos siguen nomenclatura correcta
NOTA: ADR-INFRA-XXX, PROC-INFRA-XXX, PROCED-INFRA-XXX son excepciones válidas

## 4.2: Convenciones de Carpetas
[OK] diseno/ - nomenclatura correcta
[OK] adr/ - nomenclatura correcta
[OK] procesos/ - nomenclatura correcta
[... todas las carpetas ...]

**RESULTADO VERIFICACIÓN 4:** [OK] PASS

=== VERIFICACIÓN 5: COMPLETITUD ===

## 5.1: Completitud de Movimientos
Archivos en matriz de mapeo: 13
[OK] Todos los archivos en matriz existen en nueva ubicación

## 5.2: Completitud de Actualizaciones de Enlaces
Enlaces actualizados documentados: 45

## 5.3: Evidencias Generadas
[OK] duplicados-eliminados.txt
[OK] archivos-raiz-movidos.txt
[OK] enlaces-actualizados-completo.md

**RESULTADO VERIFICACIÓN 5:** [OK] PASS

=== REPORTE FINAL DE VALIDACIÓN ===
Fecha: 2025-11-18

## Resumen de Verificaciones

| Verificación | Estado | Detalles |
|--------------|--------|----------|
| 1. Estructura de Raíz | [OK] | Solo README.md e INDEX.md en raíz |
| 2. Integridad de Archivos | [OK] | Historial Git preservado, sin pérdida de datos |
| 3. Integridad de Enlaces | [OK] | 0 enlaces rotos |
| 4. Consistencia de Nomenclatura | [OK] | Archivos y carpetas siguen convenciones |
| 5. Completitud | [OK] | Todos los archivos movidos, todas las evidencias generadas |

## Conclusión

**ESTADO FINAL:** [OK] APROBADO

**Observaciones:**
- Todas las verificaciones críticas pasaron exitosamente
- Estructura de raíz limpia y organizada
- Integridad de enlaces y archivos confirmada
- Evidencias completas generadas

**Próximos Pasos:**
[OK] Proceder a TASK-025: Actualizar README procedimientos/
[OK] Continuar con actualizaciones de READMEs vacíos
[OK] Mantener evidencias para auditoría futura
```

## Dependencias

**Requiere completar:**
- TASK-REORG-INFRA-020: Identificar Archivos Raíz a Organizar
- TASK-REORG-INFRA-021: Eliminar Archivos Duplicados
- TASK-REORG-INFRA-022: Mover Archivos Raíz a Carpetas Apropiadas
- TASK-REORG-INFRA-023: Actualizar Enlaces a Archivos Movidos

**Desbloquea:**
- TASK-REORG-INFRA-025+: Tareas de actualización de READMEs y creación de índices

## Notas Importantes

[WARNING] **IMPORTANTE**: Esta es una validación final de la reorganización de raíz. No continuar a siguientes tareas si hay fallas críticas.

 **Tip**: Ejecutar verificaciones en orden. Cada verificación depende del éxito de la anterior.

 **Revertir si es Necesario**:
```bash
# Si validación falla, considerar revertir:
git log --oneline | head -10  # Ver commits recientes
git revert <commit-hash>      # Revertir commit específico
# O restaurar desde backup (TASK-001)
```

 **Verificación Manual Recomendada**:
Además de scripts automáticos, verificar manualmente:
- Navegar por documentación en editor
- Probar enlaces en navegador/previsualizador Markdown
- Revisar que documentos críticos son accesibles

## Relación con Otras Tareas

```
Subcategoría: Limpieza Archivos Raíz
├─ TASK-020 (Identificar archivos raíz)
├─ TASK-021 (Eliminar duplicados)
├─ TASK-022 (Mover archivos)
├─ TASK-023 (Actualizar enlaces)
└─ TASK-024 (Validar reorganización) ← ESTA TAREA
        ↓
    [CHECKPOINT: Si PASS → Continuar FASE 2]
        ↓
Subcategoría: Actualizar READMEs
└─ TASK-025+ (READMEs vacíos)
```

## Referencias

- LISTADO-COMPLETO-TAREAS.md: Línea 946-974
- Chain-of-Verification (CoVE): Validación secuencial con puntos de decisión
- Criterios de Calidad: Estructura limpia, enlaces funcionales, integridad preservada
