---
id: INDEX-PLANTILLAS-EVIDENCIAS
tipo: indice
categoria: qa_evidencias
fecha_creacion: 2025-11-18
version: 1.0.0
---

# Indice de Plantillas de Evidencias TASK-REORG-INFRA

## Resumen Ejecutivo

Este directorio contiene **3 plantillas genéricas** para documentar evidencias de tareas TASK-REORG-INFRA, aplicando técnicas avanzadas de prompting: **Auto-CoT** (Automatic Chain-of-Thought) y **Self-Consistency**.

**Ubicación:** `/home/user/IACT/docs/infrastructure/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/plantillas-evidencias/`

---

## Archivos en este Directorio

| Archivo | Tipo | Líneas | Propósito | Técnica |
|---------|------|--------|-----------|---------|
| **README.md** | Documentación | ~680 | Documentación completa de plantillas | - |
| **GUIA-RAPIDA-USO.md** | Referencia | ~350 | Guía rápida de uso | - |
| **INDEX.md** | Índice | ~120 | Este archivo - índice general | - |
| **PLANTILLA-CHECKLIST-TAREAS.md** | Plantilla | ~600 | Checklist de ejecución paso a paso | Auto-CoT + Self-Consistency |
| **PLANTILLA-RESUMEN-EJECUCION.md** | Plantilla | ~410 | Documentar razonamiento de ejecución | Auto-CoT |
| **PLANTILLA-VALIDACION-COMPLETITUD.md** | Plantilla | ~580 | Validar completitud desde múltiples perspectivas | Self-Consistency |

**Total:** 6 archivos (~2,740 líneas de documentación y plantillas)

---

## Las 3 Plantillas Principales

### 1. PLANTILLA-CHECKLIST-TAREAS.md

**Tamaño:** ~600 líneas
**Técnica:** Auto-CoT + Self-Consistency (Combinadas)
**Propósito:** Guiar ejecución de tarea paso a paso

**Estructura:**
```
├── FASE 1: Preparación (Auto-CoT)
│   ├── 1.1. Comprensión del Problema
│   ├── 1.2. Recolección de Información
│   ├── 1.3. Planificación de Estrategia
│   └── 1.4. Preparación de Entorno
│
├── FASE 2: Ejecución (Auto-CoT Paso a Paso)
│   ├── 2.1. [Sub-tarea 1]
│   ├── 2.2. [Sub-tarea 2]
│   └── 2.N. [Sub-tarea N]
│
├── FASE 3: Validación (Self-Consistency)
│   ├── 3.1. Validación de Existencia
│   ├── 3.2. Validación de Estructura
│   ├── 3.3. Validación de Contenido
│   ├── 3.4. Validación de Calidad
│   ├── 3.5. Validación de Criterios
│   └── 3.6. Validación Self-Consistency
│
├── FASE 4: Documentación de Evidencias
│   ├── 4.1. Crear Archivos de Evidencia
│   └── 4.2. Actualizar Documentación
│
└── FASE 5: Finalización
    ├── 5.1. Revisión Final
    ├── 5.2. Commit y Push
    └── 5.3. Notificación y Handoff
```

**Secciones Adicionales:**
- Resumen de Métricas (tiempo, completitud, calidad)
- Problemas Encontrados
- Lecciones Aprendidas
- Estado Final

**Cuándo Usar:** ANTES, DURANTE y DESPUÉS de ejecutar tarea

---

### 2. PLANTILLA-RESUMEN-EJECUCION.md

**Tamaño:** ~410 líneas
**Técnica:** Auto-CoT (Automatic Chain-of-Thought)
**Propósito:** Documentar razonamiento paso a paso de ejecución

**Estructura:**
```
├── Resumen Ejecutivo
│
├── Auto-CoT: Razonamiento Paso a Paso
│   ├── Fase 1: Comprensión del Problema
│   ├── Fase 2: Planificación de Solución
│   ├── Fase 3: Ejecución
│   └── Fase 4: Validación de Resultados
│
├── Técnicas de Prompting Aplicadas
│   ├── 1. Auto-CoT
│   └── 2. Self-Consistency [OPCIONAL]
│
├── Artifacts Creados
├── Métricas de Ejecución
├── Problemas Encontrados y Soluciones
├── Criterios de Aceptación - Estado
├── Archivos de Evidencia Generados
├── Comparación: Estimado vs Real
├── Próximos Pasos
└── Validación Final
```

**Cuándo Usar:** DESPUÉS de completar tarea (documentación post-ejecución)

---

### 3. PLANTILLA-VALIDACION-COMPLETITUD.md

**Tamaño:** ~580 líneas
**Técnica:** Self-Consistency (Validación Múltiple)
**Propósito:** Validar completitud desde múltiples perspectivas independientes

**Estructura:**
```
├── PERSPECTIVA 1: Validación de Existencia
│   └── ¿Los artifacts existen físicamente?
│
├── PERSPECTIVA 2: Validación de Estructura
│   └── ¿Tienen la estructura correcta?
│
├── PERSPECTIVA 3: Validación de Contenido
│   └── ¿El contenido es completo y coherente?
│
├── PERSPECTIVA 4: Validación de Calidad
│   └── ¿Cumplen estándares de calidad?
│
├── PERSPECTIVA 5: Validación Self-Consistency
│   └── ¿Son consistentes entre perspectivas?
│
├── PERSPECTIVA 6: Validación de Criterios
│   └── ¿Se cumplen criterios de aceptación?
│
├── Matriz de Validación Cruzada
│
├── Score de Completitud
│   └── Cálculo ponderado: 90-100 = EXCELENTE
│
└── Validación Final
    └── Recomendación: APROBAR / APROBAR CON EXCEPCIONES / RECHAZAR
```

**Cuándo Usar:** ANTES de marcar tarea como COMPLETADA (validación pre-aprobación)

---

## Flujo de Trabajo Completo

```
INICIO TAREA
     |
     v
[1] Copiar PLANTILLA-CHECKLIST-TAREAS.md
     |
     v
[2] Personalizar checklist
    (reemplazar [CORCHETES])
     |
     v
[3] Ejecutar tarea siguiendo checklist
    - Marcar [x] items completados
    - Documentar razonamiento Auto-CoT
    - Actualizar tiempos reales
     |
     v
[4] Copiar PLANTILLA-RESUMEN-EJECUCION.md
    - Documentar Auto-CoT completo
    - Registrar métricas
    - Listar artifacts
     |
     v
[5] Copiar PLANTILLA-VALIDACION-COMPLETITUD.md
    - Validar desde 6 perspectivas
    - Calcular score de completitud
    - Emitir recomendación
     |
     v
[6] Revisar score
    - >= 90: APROBAR
    - 75-89: APROBAR CON EXCEPCIONES
    - < 75: RETRABAJO
     |
     v
FIN TAREA
```

---

## Estructura de Evidencias Esperada

Para cada TASK-REORG-INFRA-XXX:

```
TASK-REORG-INFRA-XXX/
├── README.md                           (Descripción de la tarea)
└── evidencias/
    ├── CHECKLIST-TAREAS.md             (Copiado de plantilla)
    ├── RESUMEN-EJECUCION.md            (Copiado de plantilla)
    ├── VALIDACION-COMPLETITUD.md       (Copiado de plantilla)
    ├── [evidencia-especifica-1.txt]    (Logs, outputs, etc)
    ├── [evidencia-especifica-2.log]
    └── [evidencia-especifica-N]
```

**Archivos Obligatorios:** CHECKLIST-TAREAS.md, RESUMEN-EJECUCION.md, VALIDACION-COMPLETITUD.md

---

## Técnicas de Prompting Aplicadas

### Auto-CoT (Automatic Chain-of-Thought)

**Concepto:** Documentar razonamiento paso a paso, no solo resultados.

**Aplicado en:**
- PLANTILLA-RESUMEN-EJECUCION.md (principal)
- PLANTILLA-CHECKLIST-TAREAS.md (Fases 1 y 2)

**Formato:**
```
Paso X: [Acción]
- Razonamiento: [Por qué este paso]
- Comando: [Qué usé]
- Resultado: [Qué obtuve]
- Validación: [Cómo verifiqué]
```

**Beneficios:**
- Transparencia de razonamiento
- Facilita auditoría
- Permite replicar lógica
- Identifica gaps en razonamiento

---

### Self-Consistency (Validación Múltiple)

**Concepto:** Un resultado es válido si se confirma desde múltiples perspectivas independientes.

**Aplicado en:**
- PLANTILLA-VALIDACION-COMPLETITUD.md (principal)
- PLANTILLA-CHECKLIST-TAREAS.md (Fase 3)

**Perspectivas:**
1. Existencia física
2. Estructura interna
3. Contenido completo
4. Calidad técnica
5. Consistencia cruzada
6. Criterios originales

**Beneficios:**
- Reduce falsos positivos
- Detecta inconsistencias sutiles
- Proporciona confianza objetiva
- Identifica gaps específicos

---

## Ejemplos de Uso

### Ejemplo Real: TASK-REORG-INFRA-003

**Tarea:** Crear READMEs para Carpetas Nuevas

**Evidencias Generadas:**
- `TAREA-COMPLETADA.md` (equivalente a RESUMEN-EJECUCION)
- `validacion-readmes.md` (equivalente a VALIDACION-COMPLETITUD)
- `readmes-creados.txt` (evidencia específica)

**Técnicas Aplicadas:**
- Auto-CoT: 6 pasos documentados
- Self-Consistency: Validación de 13/13 READMEs desde múltiples perspectivas

**Resultado:** 100% completitud, 13/13 READMEs validados

**Ubicación:** `docs/infrastructure/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-REORG-INFRA-003-crear-readmes-carpetas-nuevas/evidencias/`

---

### Ejemplo Real: TASK-REORG-INFRA-004

**Tarea:** Mapeo de Migración de Documentos

**Evidencias Generadas:**
- `PROCESO-AUTO-COT-SELF-CONSISTENCY.md` (ejemplo completo de ambas técnicas)
- Matriz de 24 entradas de mapeo
- Análisis de duplicados

**Técnicas Aplicadas:**
- Auto-CoT: 7 pasos de razonamiento sobre categorización
- Self-Consistency: Inventario exhaustivo, validación de duplicados, coherencia
- Tabular CoT: Matriz estructurada de decisiones

**Resultado:** 100% cobertura, 24 items mapeados, 2 duplicados identificados

**Ubicación:** `docs/infrastructure/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-REORG-INFRA-004-mapeo-migracion-documentos/evidencias/`

---

## Comandos Rápidos

### Copiar todas las plantillas:

```bash
# Crear carpeta evidencias
mkdir -p TASK-REORG-INFRA-XXX/evidencias

# Copiar plantillas
cd /home/user/IACT/docs/infrastructure/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/

cp plantillas-evidencias/PLANTILLA-CHECKLIST-TAREAS.md \
   TASK-REORG-INFRA-XXX/evidencias/CHECKLIST-TAREAS.md

cp plantillas-evidencias/PLANTILLA-RESUMEN-EJECUCION.md \
   TASK-REORG-INFRA-XXX/evidencias/RESUMEN-EJECUCION.md

cp plantillas-evidencias/PLANTILLA-VALIDACION-COMPLETITUD.md \
   TASK-REORG-INFRA-XXX/evidencias/VALIDACION-COMPLETITUD.md
```

### Verificar placeholders no reemplazados:

```bash
cd TASK-REORG-INFRA-XXX/evidencias/
grep -r "\[TASK-" *.md
grep -r "\[YYYY-" *.md
# Si no hay output, plantillas están personalizadas
```

---

## Métricas de Calidad

### Score de Completitud (VALIDACION-COMPLETITUD.md)

| Rango | Interpretación | Acción |
|-------|----------------|--------|
| 90-100 | EXCELENTE | APROBAR sin reservas |
| 75-89 | BUENO | APROBAR con seguimiento menor |
| 60-74 | ACEPTABLE | Requiere mejoras antes de aprobar |
| < 60 | INSUFICIENTE | RECHAZAR - requiere retrabajo |

### Tiempo Estimado por Plantilla

| Plantilla | Tiempo Estimado | Fase |
|-----------|----------------|------|
| CHECKLIST-TAREAS | Durante ejecución (~10% overhead) | ANTES/DURANTE/DESPUÉS |
| RESUMEN-EJECUCION | 20-30 minutos | DESPUÉS |
| VALIDACION-COMPLETITUD | 15-20 minutos | ANTES de aprobar |
| **TOTAL** | **~30-50 minutos** | **Por tarea** |

---

## Referencias

### Documentación

- [README.md](./README.md) - Documentación completa de plantillas
- [GUIA-RAPIDA-USO.md](./GUIA-RAPIDA-USO.md) - Referencia rápida de uso

### Ejemplos

- [TASK-003/evidencias/](../TASK-REORG-INFRA-003-crear-readmes-carpetas-nuevas/evidencias/) - Ejemplo de evidencias completas
- [PROCESO-AUTO-COT-SELF-CONSISTENCY.md](../TASK-REORG-INFRA-004-mapeo-migracion-documentos/evidencias/PROCESO-AUTO-COT-SELF-CONSISTENCY.md) - Ejemplo de ambas técnicas

### Relacionados

- [LISTADO-COMPLETO-TAREAS.md](../LISTADO-COMPLETO-TAREAS.md) - Lista de todas las tareas TASK-REORG-INFRA

---

## Historial de Versiones

| Versión | Fecha | Cambios |
|---------|-------|---------|
| 1.0.0 | 2025-11-18 | Creación inicial de 3 plantillas + documentación |

---

## Mantenimiento

**Responsable:** QA Infrastructure Team

**Actualizar cuando:**
- Se identifican mejoras de proceso
- Se agregan nuevas técnicas de prompting
- Se detectan gaps en plantillas
- Feedback de usuarios

**Próxima Revisión:** 2025-12-18 (1 mes después de creación)

---

**Creado:** 2025-11-18
**Versión:** 1.0.0
**Estado:** Activo
