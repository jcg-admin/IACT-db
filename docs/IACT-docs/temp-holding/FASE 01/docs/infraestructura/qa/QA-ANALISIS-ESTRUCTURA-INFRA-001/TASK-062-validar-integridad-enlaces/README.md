---
id: TASK-QA-INFRA-062
tipo: tarea
categoria: validacion
nombre: Validar integridad de enlaces (Chain-of-Verification)
titulo: Validar integridad de enlaces en documentación
fase: FASE_4_VALIDACION_Y_LIMPIEZA
prioridad: P0_CRITICA
duracion_estimada: 4h
estado: pendiente
dependencias: [TASK-QA-INFRA-061]
tecnicas: [Chain-of-Verification, Self-Consistency, Auto-CoT]
---

# TASK-062: Validar Integridad de Enlaces

**Objetivo:** Ejecutar validación completa de enlaces en toda la documentación de infraestructura, identificar y corregir todos los enlaces rotos utilizando técnicas de Chain-of-Verification para garantizar consistencia.

**Responsable:** @qa-engineer
**Restricciones:** Sin cambios a archivos de configuración sensibles, validación solo lectura en primera pasada.
**Técnica de prompting sugerida:** Chain-of-Verification + Self-Consistency (`docs/ai/prompting`).

---

## Auto-CoT: Razonamiento Paso a Paso

### Paso 1: Entender el Propósito de Validación de Enlaces

**Pensamiento**: ¿Por qué validar enlaces es crítico?

**Importancia:**
1. **Navegación**: Enlaces rotos impiden acceso a documentación clave
2. **Experiencia**: Usuarios no pueden encontrar información relacionada
3. **SEO**: Enlaces rotos afectan crawlability y ranking
4. **Mantenibilidad**: Documenta estructura actual del proyecto
5. **Auditoría**: Verifica que reorganización completó correctamente

**Alcance de Validación:**
- Enlaces internos relativos (ej: `./docs/componente/README.md`)
- Enlaces absolutos dentro del repo (ej: `/docs/infraestructura/...`)
- Enlaces a anclas internas (ej: `#seccion-principal`)
- Enlaces externos (registro, no corrección)

### Paso 2: Preparar Ambiente de Validación

**Pensamiento**: ¿Qué necesito antes de validar?

**Preparación:**
1. Ubicar script de validación: `/scripts/qa/validate_links.sh`
2. Verificar permisos de ejecución
3. Preparar directorio de infraestructura como target
4. Crear directorio para logs/reportes
5. Documentar baseline antes de correcciones

**Verificación Previa:**
```bash
# Verificar script existe y es ejecutable
ls -la /home/user/IACT/scripts/qa/validate_links.sh

# Verificar directorio target
ls -la /home/user/IACT/docs/infraestructura/
```

### Paso 3: Ejecutar Validación Inicial (Chain-of-Verification)

**Pensamiento**: ¿Cómo validar de forma confiable?

**Chain-of-Verification - Paso 1: Línea Base**
```bash
# Ejecutar validación con output detallado
/home/user/IACT/scripts/qa/validate_links.sh \
    /home/user/IACT/docs/infraestructura \
    --verbose \
    > /tmp/enlaces-validacion-inicial.log 2>&1

# Guardar reporte en evidencias
cp /tmp/enlaces-validacion-inicial.log \
    /home/user/IACT/docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-062-validar-integridad-enlaces/evidencias/01-validacion-inicial.log
```

**Salida Esperada:**
```
===============================================
REPORTE DE VALIDACION DE ENLACES
===============================================
Archivos procesados: XXX
Enlaces validos: YYY
Enlaces rotos: ZZZ
Enlaces externos: NNN
Enlaces a anclas: MMM
```

### Paso 4: Analizar Resultados y Documentar Hallazgos

**Pensamiento**: ¿Qué representa cada tipo de enlace?

**Self-Consistency - Enfoque 1: Análisis Cuantitativo**
```bash
# Extraer solo enlaces rotos
grep "\[BROKEN\]" /tmp/enlaces-validacion-inicial.log | \
    sed 's/.*\[BROKEN\] //' > /tmp/enlaces-rotos.txt

# Contar por tipo de problema
wc -l /tmp/enlaces-rotos.txt

# Agrupar por archivo origen
grep "ERROR:" /tmp/enlaces-validacion-inicial.log | \
    cut -d: -f1 | sort | uniq -c
```

**Self-Consistency - Enfoque 2: Análisis Cualitativo**
```bash
# Visualizar estructuras de enlaces rotos
cat /tmp/enlaces-rotos.txt | head -20

# Identificar patrones comunes
# Ej: carpetas eliminadas, nombres cambiados, rutas incorrectas
```

**Self-Consistency - Enfoque 3: Validación Cruzada**
- Buscar archivos citados que ya no existen
- Verificar si contenido fue movido a otra ubicación
- Confirmar cambios de estructura en reorganización anterior

### Paso 5: Documentar Hallazgos Antes de Corregir

**Pensamiento**: ¿Cómo registrar el estado antes de cambios?

**Reporte de Hallazgos:**
```markdown
# Reporte de Enlaces Rotos - Validación Inicial

**Fecha**: YYYY-MM-DD
**Ejecutado por**: [nombre]
**Directorio**: /home/user/IACT/docs/infraestructura

## Resumen
- Total archivos: XXX
- Total enlaces: YYY
- Enlaces válidos: AAA (XX%)
- Enlaces rotos: BBB (YY%)
- Enlaces externos: CCC
- Anclas internas: DDD

## Categorías de Problemas

### 1. Archivos Movidos/Renombrados
...

### 2. Carpetas Eliminadas
...

### 3. Rutas Incorrectas
...

## Acción Requerida
- [ ] Verificar cada enlace roto
- [ ] Buscar ubicación correcta
- [ ] Actualizar referencia
```

### Paso 6: Realizar Correcciones (Chain-of-Verification)

**Pensamiento**: ¿Cómo corregir sin introducir nuevos errores?

**Protocolo de Corrección - Paso 1: Identificación**
```bash
# Para cada enlace roto, identificar qué pasó
# Ejemplo: archivo movido de docs/A/B.md a docs/X/Y.md

# Buscar archivo por nombre
find /home/user/IACT/docs/infraestructura -name "nombre_archivo.md"

# Verificar si contenido existe en otra ubicación
grep -r "contenido_unico" /home/user/IACT/docs/infraestructura
```

**Protocolo de Corrección - Paso 2: Validación Previa**
```bash
# Antes de cambiar, verificar
# 1. ¿Archivo nuevo existe?
# 2. ¿Es el contenido correcto?
# 3. ¿Ruta relativa será válida desde archivo que enlaza?
```

**Protocolo de Corrección - Paso 3: Cambio Controlado**
```bash
# Usar sed para cambios controlados con validación
# Ejemplo: cambiar enlace específico
# sed -i 's|docs/viejo/archivo.md|docs/nuevo/archivo.md|g' archivo-fuente.md

# Verificar el cambio
git diff archivo-fuente.md
```

### Paso 7: Validación Post-Corrección

**Pensamiento**: ¿Cómo verificar que correcciones funcionan?

**Chain-of-Verification - Re-validación:**
```bash
# Ejecutar validación nuevamente
/home/user/IACT/scripts/qa/validate_links.sh \
    /home/user/IACT/docs/infraestructura \
    --json > /tmp/validacion-post-correccion.json

# Comparar resultados
jq '.summary' /tmp/validacion-post-correccion.json
```

**Criterio de Éxito:**
```json
{
  "broken_links": 0,
  "valid_links": "100%"
}
```

### Paso 8: Generar Reporte Final

**Pensamiento**: ¿Cómo documentar el trabajo completado?

**Reporte Final - Estructura:**
```markdown
# Reporte Final de Validación de Enlaces - TASK-062

## Resumen Ejecutivo
- Validación completada: YYYY-MM-DD HH:MM
- Estado: [COMPLETADO] COMPLETADA (0 enlaces rotos)
- Documentación: 100% verificada

## Cambios Realizados
1. Enlace X: old-path → new-path
2. Enlace Y: updated relative reference
...

## Métricas Finales
- Enlaces válidos: 100%
- Tasa de cobertura: 100%
- Documentación: Completa

## Validación Cruzada
- [COMPLETADO] Re-ejecución de script confirma 0 errores
- [COMPLETADO] Muestreo aleatorio: 100% de enlaces verificados manualmente
- [COMPLETADO] Navegación: Todas las rutas accesibles
```

---

## Self-Consistency: Validación Múltiple

### Enfoque 1: Validación por Categoría de Archivo

**Validar por tipo de documento:**
```bash
# Validar solo READMEs
find /home/user/IACT/docs/infraestructura -name "README.md" | while read f; do
    echo "Validando: $f"
    grep -oP '\[.*?\]\(\K[^)]+' "$f" | head -5
done

# Validar solo índices
find /home/user/IACT/docs/infraestructura -name "INDEX*.md" | wc -l

# Validar documentación técnica
find /home/user/IACT/docs/infraestructura -name "*.md" | grep -E "arquitectura|diseno|procedimiento"
```

### Enfoque 2: Validación por Ubicación

**Validar subsecciones:**
```bash
# Infra - Arquitectura
/home/user/IACT/scripts/qa/validate_links.sh \
    /home/user/IACT/docs/infraestructura/diseno/arquitectura

# Infra - Procedimientos
/home/user/IACT/scripts/qa/validate_links.sh \
    /home/user/IACT/docs/infraestructura/procedimientos

# Infra - QA
/home/user/IACT/scripts/qa/validate_links.sh \
    /home/user/IACT/docs/infraestructura/qa
```

### Enfoque 3: Muestreo Manual

**Verificación manual spot-check:**
1. Seleccionar 10% de enlaces aleatorios
2. Verificar manualmente cada uno
3. Confirmar:
   - Archivo existe
   - Contenido es relevante
   - Ruta es correcta
4. Documentar hallazgos

---

## Criterios de Aceptación

- [ ] Script ejecutado exitosamente
- [ ] 0 enlaces rotos en documentación crítica
- [ ] ≥95% enlaces válidos en documentación general
- [ ] Todas las correcciones documentadas
- [ ] Reporte final generado en evidencias
- [ ] Self-Consistency validada: 3 enfoques ejecutados
- [ ] Chain-of-Verification completada: validación inicial → corrección → re-validación

## Entregables

### 1. Reporte de Validación Inicial
**Archivo**: `evidencias/01-validacion-inicial.log`
- Output completo de validación
- Timestamp de ejecución
- Lista de enlaces rotos

### 2. Análisis de Hallazgos
**Archivo**: `evidencias/02-analisis-hallazgos.md`
- Categorización de problemas
- Impacto de cada problema
- Solución propuesta para cada uno

### 3. Correcciones Aplicadas
**Archivo**: `evidencias/03-correcciones-aplicadas.md`
- Antes y después de cada cambio
- Justificación de cada corrección
- Confirmación de cambio exitoso

### 4. Reporte Final de Validación
**Archivo**: `evidencias/04-validacion-final-reporte.json`
```json
{
  "fecha_ejecucion": "2025-11-XX",
  "validacion_inicial": {
    "archivos": XXX,
    "enlaces_validos": YYY,
    "enlaces_rotos": ZZZ
  },
  "correcciones": {
    "total": AAA,
    "exitosas": BBB,
    "fallidas": CCC
  },
  "validacion_final": {
    "enlaces_validos": "100%",
    "estado": "COMPLETADA"
  }
}
```

### 5. Evidencia de Self-Consistency
**Archivo**: `evidencias/05-self-consistency-validacion.md`
- Resultados de 3 enfoques diferentes
- Convergencia de hallazgos
- Confianza en resultados

---

## Checklist de Ejecución

### Fase 1: Preparación
- [ ] Script validar_links.sh ubicado y verificado
- [ ] Directorio target confirmado
- [ ] Directorio de evidencias creado
- [ ] Baseline documentado

### Fase 2: Validación Inicial
- [ ] Validación ejecutada correctamente
- [ ] Output capturado en log
- [ ] Errors identificados
- [ ] Documentación completada

### Fase 3: Análisis
- [ ] Categorización de problemas
- [ ] Hallazgos documentados
- [ ] Soluciones identificadas
- [ ] Self-Consistency ejecutada (3 enfoques)

### Fase 4: Correcciones
- [ ] Cada enlace rotos investigado
- [ ] Ubicación correcta encontrada o determinada fija
- [ ] Cambios aplicados controladamente
- [ ] Cambios documentados

### Fase 5: Re-validación
- [ ] Script ejecutado nuevamente
- [ ] Resultados comparados
- [ ] Diferencias analizadas
- [ ] Chain-of-Verification completada

### Fase 6: Documentación
- [ ] Reporte final generado
- [ ] Evidencias organizadas
- [ ] Conclusiones registradas
- [ ] Commit preparado

---

## Guía de Ejecución Rápida

### Paso 1: Validación Inicial (5 min)
```bash
bash /home/user/IACT/scripts/qa/validate_links.sh \
    /home/user/IACT/docs/infraestructura \
    --verbose 2>&1 | tee validacion-inicial.log
```

### Paso 2: Análisis de Problemas (30 min)
```bash
# Extraer enlaces rotos
grep "\[BROKEN\]" validacion-inicial.log > enlaces-rotos.txt

# Analizar por archivo
grep "ERROR:" validacion-inicial.log | cut -d: -f1 | sort | uniq -c
```

### Paso 3: Correcciones (variable)
```bash
# Para cada enlace roto:
# 1. Buscar archivo nuevo
# 2. Actualizar referencia
# 3. Verificar cambio
```

### Paso 4: Re-validación (5 min)
```bash
bash /home/user/IACT/scripts/qa/validate_links.sh \
    /home/user/IACT/docs/infraestructura \
    --json > validacion-final.json
```

### Paso 5: Generar Reportes (15 min)
```bash
# Crear reporte final
cat > validacion-final-reporte.md << EOF
# Validación de Enlaces - Reporte Final
...
EOF
```

---

## Técnicas de Prompting

### Auto-CoT (Chain-of-Thought)
1. **Paso 1**: Entender qué se valida (enlaces)
2. **Paso 2**: Preparar ambiente (script, logs)
3. **Paso 3**: Ejecutar validación (script bash)
4. **Paso 4**: Analizar resultados (parsing)
5. **Paso 5**: Documentar hallazgos (markdown)
6. **Paso 6**: Aplicar correcciones (sed/scripts)
7. **Paso 7**: Re-validar (script bash)
8. **Paso 8**: Generar reportes (json/markdown)

### Chain-of-Verification
1. **Verificación 1**: Ejecutar validación automática
2. **Verificación 2**: Analizar resultados de forma independiente
3. **Verificación 3**: Aplicar correcciones con validación previa
4. **Verificación 4**: Re-ejecutar validación automatizada
5. **Verificación 5**: Validación manual spot-check (10%)

### Self-Consistency
1. **Enfoque 1**: Análisis cuantitativo (métricas)
2. **Enfoque 2**: Análisis cualitativo (categorización)
3. **Enfoque 3**: Validación cruzada (manual)
- Convergencia: Todos los enfoques deben llegar a misma conclusión

---

## Notas Importantes

- **Cambios Graduales**: No cambiar todos los enlaces de una vez, hacer por sección
- **Documentación**: Cada corrección debe documentarse en evidencias
- **Validación Cruzada**: Confirmar manualmente enlaces críticos (READMEs, índices)
- **Git**: Preparar commits por categoría de cambio
- **Reportes**: Self-Consistency debe mostrar convergencia de enfoques

---

## Referencias

- Script: `/home/user/IACT/scripts/qa/validate_links.sh`
- Técnica: Chain-of-Verification + Self-Consistency
- Documentación: `docs/ai/prompting/`
- Meta de fase: 100% documentación navegable
