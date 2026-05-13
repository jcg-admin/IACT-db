---
id: GUIA-RAPIDA-PLANTILLAS
tipo: guia_referencia_rapida
categoria: qa_evidencias
fecha: 2025-11-18
version: 1.0.0
---

# Guia Rapida de Uso de Plantillas de Evidencias

## Indice Rapido

```
plantillas-evidencias/
├── README.md                                    (Documentacion completa)
├── GUIA-RAPIDA-USO.md                          (Este archivo - referencia rapida)
├── PLANTILLA-CHECKLIST-TAREAS.md               (Auto-CoT + Self-Consistency)
├── PLANTILLA-RESUMEN-EJECUCION.md              (Auto-CoT)
└── PLANTILLA-VALIDACION-COMPLETITUD.md         (Self-Consistency)
```

---

## Cuando Usar Cada Plantilla

| Plantilla | Cuando Usar | Tiempo Estimado | Tecnica |
|-----------|-------------|-----------------|---------|
| **CHECKLIST-TAREAS** | ANTES, DURANTE y DESPUES de ejecutar tarea | Durante ejecucion | Auto-CoT + Self-Consistency |
| **RESUMEN-EJECUCION** | DESPUES de completar tarea | 20-30 min | Auto-CoT |
| **VALIDACION-COMPLETITUD** | ANTES de marcar tarea como COMPLETADA | 15-20 min | Self-Consistency |

---

## Flujo Rapido de Uso

### PASO 1: Copiar CHECKLIST
```bash
cp plantillas-evidencias/PLANTILLA-CHECKLIST-TAREAS.md \
   TASK-REORG-INFRA-XXX/evidencias/CHECKLIST-TAREAS.md
```

### PASO 2: Personalizar CHECKLIST
- Reemplazar [TASK-REORG-INFRA-XXX] con ID real
- Reemplazar [CORCHETES] con info especifica
- Definir sub-tareas especificas
- Establecer validaciones

### PASO 3: Ejecutar Tarea Siguiendo CHECKLIST
- Marcar [x] items completados
- Documentar razonamiento en secciones Auto-CoT
- Registrar problemas/soluciones
- Actualizar tiempos reales

### PASO 4: Crear RESUMEN-EJECUCION
```bash
cp plantillas-evidencias/PLANTILLA-RESUMEN-EJECUCION.md \
   TASK-REORG-INFRA-XXX/evidencias/RESUMEN-EJECUCION.md
```

- Documentar Auto-CoT completo (4 fases)
- Registrar metricas
- Listar artifacts creados
- Documentar problemas/soluciones

### PASO 5: Crear VALIDACION-COMPLETITUD
```bash
cp plantillas-evidencias/PLANTILLA-VALIDACION-COMPLETITUD.md \
   TASK-REORG-INFRA-XXX/evidencias/VALIDACION-COMPLETITUD.md
```

- Validar desde 6 perspectivas
- Calcular score de completitud
- Emitir recomendacion (APROBAR/RECHAZAR)

### PASO 6: Revisar Score
- Si score >= 90: APROBAR
- Si score 75-89: APROBAR CON EXCEPCIONES
- Si score < 75: RETRABAJO

---

## Checklist de Verificacion Rapida

Antes de marcar tarea como COMPLETADA, verificar:

- [ ] CHECKLIST-TAREAS.md creado y completado
- [ ] RESUMEN-EJECUCION.md creado y completo
- [ ] VALIDACION-COMPLETITUD.md creado y completo
- [ ] Score de completitud >= 75%
- [ ] Todos los criterios de aceptacion cumplidos
- [ ] Evidencias especificas generadas (logs, outputs, etc)
- [ ] Sin items marcados como [!] (bloqueados)

---

## Atajos de Personalizacion

### En TODAS las plantillas, reemplazar:

| Placeholder | Reemplazar con | Ejemplo |
|-------------|----------------|---------|
| [TASK-ID] | ID de la tarea sin prefijo | 003 |
| [TASK-REORG-INFRA-XXX] | ID completo de la tarea | TASK-REORG-INFRA-003 |
| [YYYY-MM-DD] | Fecha actual | 2025-11-18 |
| [Nombre descriptivo] | Nombre de la tarea | Crear READMEs para Carpetas Nuevas |
| [Nombre del responsable] | Tu nombre o equipo | QA Infrastructure Team |

### Comandos sed para automatizar (Linux/Mac):

```bash
# Navegar a carpeta de evidencias
cd TASK-REORG-INFRA-XXX/evidencias/

# Reemplazar ID de tarea
sed -i 's/\[TASK-ID\]/003/g' *.md
sed -i 's/\[TASK-REORG-INFRA-XXX\]/TASK-REORG-INFRA-003/g' *.md

# Reemplazar fecha
sed -i 's/\[YYYY-MM-DD\]/2025-11-18/g' *.md

# Reemplazar responsable
sed -i 's/\[Nombre del responsable\]/QA Infrastructure Team/g' *.md
```

---

## Secciones Criticas (NO Omitir)

### En CHECKLIST-TAREAS.md:
- Fase 1.1: Comprension del Problema
- Fase 2.X: Todas las sub-tareas de ejecucion
- Fase 3.5: Validacion de Criterios de Aceptacion
- Fase 3.6: Validacion Self-Consistency
- Resumen de Metricas

### En RESUMEN-EJECUCION.md:
- Resumen Ejecutivo
- Auto-CoT: Razonamiento Paso a Paso (4 fases completas)
- Artifacts Creados
- Criterios de Aceptacion - Estado
- Validacion Final

### En VALIDACION-COMPLETITUD.md:
- Perspectiva 1: Validacion de Existencia
- Perspectiva 3: Validacion de Contenido
- Perspectiva 6: Validacion de Criterios
- Score de Completitud
- Validacion Final (con recomendacion)

---

## Secciones Opcionales (Eliminar si No Aplican)

### Pueden eliminarse si no aplican:

- **RESUMEN-EJECUCION.md:**
  - Seccion "Self-Consistency" (si solo usaste Auto-CoT)
  - "Problema 2, 3, N" (si solo hubo 1 problema)
  - "Notas Finales" (si no hay notas adicionales)

- **VALIDACION-COMPLETITUD.md:**
  - Perspectiva 2: Estructura (si no hay archivos con estructura especifica)
  - Perspectiva 4: Calidad (si no hay estandares de calidad definidos)
  - Perspectiva 5: Self-Consistency (si validacion simple es suficiente)

- **CHECKLIST-TAREAS.md:**
  - Items marcados [?] (opcionales)
  - Sub-tareas no aplicables a tu tarea especifica

---

## Niveles de Detalle Recomendados

### Tarea SIMPLE (< 1 hora):
- **CHECKLIST:** Nivel basico (3-5 sub-tareas)
- **RESUMEN-EJECUCION:** 2-3 paginas
- **VALIDACION-COMPLETITUD:** 3 perspectivas minimo

### Tarea MEDIA (1-3 horas):
- **CHECKLIST:** Nivel medio (5-10 sub-tareas)
- **RESUMEN-EJECUCION:** 3-5 paginas
- **VALIDACION-COMPLETITUD:** 4-5 perspectivas

### Tarea COMPLEJA (> 3 horas):
- **CHECKLIST:** Nivel detallado (10+ sub-tareas)
- **RESUMEN-EJECUCION:** 5-8 paginas
- **VALIDACION-COMPLETITUD:** 6 perspectivas completas

---

## Esquema Visual del Flujo

```
    INICIO TAREA
         |
         v
    [CHECKLIST]  <--- Copiar plantilla
         |
         v
    Personalizar
         |
         v
    FASE 1: Preparacion
    - Comprension
    - Planificacion         [Auto-CoT]
         |
         v
    FASE 2: Ejecucion
    - Sub-tarea 1
    - Sub-tarea 2           [Auto-CoT]
    - Sub-tarea N
         |
         v
    FASE 3: Validacion
    - 6 Perspectivas        [Self-Consistency]
         |
         v
    [RESUMEN-EJECUCION]  <--- Copiar plantilla
    - Documentar Auto-CoT
    - Metricas
    - Artifacts
         |
         v
    [VALIDACION-COMPLETITUD]  <--- Copiar plantilla
    - 6 Perspectivas
    - Score de Completitud
         |
         v
    Score >= 75?
         |
    SI / NO
    |     |
    v     v
APROBAR  RETRABAJO
    |
    v
FIN TAREA
```

---

## Ejemplos de Comandos Frecuentes

### Copiar todas las plantillas de una vez:

```bash
# Crear carpeta evidencias si no existe
mkdir -p TASK-REORG-INFRA-XXX/evidencias

# Copiar las 3 plantillas
cp plantillas-evidencias/PLANTILLA-CHECKLIST-TAREAS.md \
   TASK-REORG-INFRA-XXX/evidencias/CHECKLIST-TAREAS.md

cp plantillas-evidencias/PLANTILLA-RESUMEN-EJECUCION.md \
   TASK-REORG-INFRA-XXX/evidencias/RESUMEN-EJECUCION.md

cp plantillas-evidencias/PLANTILLA-VALIDACION-COMPLETITUD.md \
   TASK-REORG-INFRA-XXX/evidencias/VALIDACION-COMPLETITUD.md

# Verificar
ls -la TASK-REORG-INFRA-XXX/evidencias/
```

### Verificar que plantillas estan completas:

```bash
cd TASK-REORG-INFRA-XXX/evidencias/

# Buscar placeholders no reemplazados
grep -r "\[TASK-" *.md
grep -r "\[YYYY-" *.md
grep -r "\[Nombre" *.md

# Si no hay output, todas las plantillas estan personalizadas
```

### Calcular score de completitud rapido:

```bash
# Contar criterios cumplidos vs totales en VALIDACION-COMPLETITUD.md
grep -c "\[x\]" VALIDACION-COMPLETITUD.md
grep -c "\[ \]" VALIDACION-COMPLETITUD.md

# Score = cumplidos / (cumplidos + pendientes) * 100
```

---

## Errores Comunes a Evitar

| Error | Impacto | Solucion |
|-------|---------|----------|
| No personalizar placeholders [CORCHETES] | Evidencia no especifica | Buscar y reemplazar TODOS los placeholders |
| Omitir validaciones Self-Consistency | Bajo score de completitud | Ejecutar TODAS las perspectivas |
| No documentar razonamiento Auto-CoT | Evidencia superficial | Documentar PORQUE, no solo QUE |
| Llenar evidencias al final | Informacion incompleta | Actualizar DURANTE ejecucion |
| No ejecutar comandos de validacion | Validacion no verificable | Ejecutar y registrar outputs |
| Usar emojis en contenido | Inconsistencia de formato | Eliminar todos los emojis |
| Marcar [x] sin validar | Falsos positivos | Solo marcar si validacion PASS |
| No calcular score de completitud | No hay metrica objetiva | Calcular score en VALIDACION-COMPLETITUD |

---

## Referencias Rapidas

| Necesito... | Ver... |
|-------------|--------|
| Documentacion completa de plantillas | [README.md](./README.md) |
| Ejemplo de evidencias completas | [TASK-003/evidencias/](../TASK-REORG-INFRA-003-crear-readmes-carpetas-nuevas/evidencias/) |
| Ejemplo de Auto-CoT + Self-Consistency | [PROCESO-AUTO-COT-SELF-CONSISTENCY.md](../TASK-REORG-INFRA-004-mapeo-migracion-documentos/evidencias/PROCESO-AUTO-COT-SELF-CONSISTENCY.md) |
| Lista de todas las tareas TASK-REORG-INFRA | [LISTADO-COMPLETO-TAREAS.md](../LISTADO-COMPLETO-TAREAS.md) |

---

## Contacto y Soporte

**Responsable:** QA Infrastructure Team

**Preguntas Frecuentes:** Ver README.md seccion "Preguntas Frecuentes"

**Reportar Problemas:** Crear issue en repositorio con tag `plantillas-evidencias`

**Sugerencias de Mejora:** Contactar a QA Infrastructure Team

---

**Version:** 1.0.0
**Ultima Actualizacion:** 2025-11-18
**Estado:** Activo
