# CHECKLIST: Ejecución TASK-REORG-INFRA-011

**Objetivo**: Guía paso a paso para consolidar planificación dispersa

**Fecha Inicio**: Por establecer
**Fecha Estimada de Cierre**: +3 horas desde inicio
**Responsable**: IACT Infrastructure Team

---

## FASE 1: PREPARACIÓN Y ANÁLISIS

### Paso 1: Verificar Dependencias
- [ ] Confirmar que TASK-REORG-INFRA-004 está completado
- [ ] Revisar que no hay cambios en progreso en directorios de planificación
- [ ] Hacer backup de la rama actual (git stash si es necesario)
- [ ] Crear rama feature si aplica

### Paso 2: Mapeo Exhaustivo
- [ ] Ejecutar script de análisis de todos `*plan*.md`
- [ ] Documentar rutas actuales de todos los archivos
- [ ] Identificar archivos obsoletos vs activos
- [ ] Documentar dependencias entre planes
- [ ] Revisar referencias cruzadas (grep/rg)

**Archivo de Referencia**: `ANALISIS-PLANIFICACION-DISPERSA.md`

---

## FASE 2: PREPARACIÓN DE ESTRUCTURA

### Paso 3: Crear Directorios Destino

#### Gobernanza
- [ ] Crear `/docs/gobernanza/planificacion/` si no existe
- [ ] Crear subdirectorio `planes_remediacion/`
- [ ] Crear subdirectorio `planes_generales/`
- [ ] Crear subdirectorio `roadmaps/`
- [ ] Crear `README.md` con índice

#### Infraestructura
- [ ] Crear `/docs/infraestructura/planificacion/` si no existe
- [ ] Crear subdirectorio `especificaciones/`
- [ ] Crear subdirectorio `release_management/`
- [ ] Crear subdirectorio `deployment/`
- [ ] Crear `README.md` con índice

#### IA
- [ ] Crear `/docs/ai/planificacion/` si no existe
- [ ] Crear subdirectorio `ejecucion/`
- [ ] Crear subdirectorio `release_management/`
- [ ] Crear subdirectorio `validation/`
- [ ] Crear `README.md` con índice

#### Backend
- [ ] Crear `/docs/backend/planificacion/` si no existe
- [ ] Crear subdirectorio `deployment/`
- [ ] Crear subdirectorio `documentacion/`
- [ ] Crear subdirectorio `qa/`
- [ ] Crear `README.md` con índice

#### Frontend
- [ ] Crear `/docs/frontend/planificacion/` si no existe
- [ ] Crear subdirectorio `release_management/`
- [ ] Crear subdirectorio `ui_ux/`
- [ ] Crear `README.md` con índice

#### DevOps
- [ ] Validar `/docs/devops/git/planificacion/` existe
- [ ] Validar `/docs/devops/automatizacion/planificacion/` existe
- [ ] Crear `README.md` en ambas si no existen
- [ ] Verificar contenido es consistente

### Paso 4: Crear Archivos README.md

**Template para cada README.md**:
```markdown
# Planes y Planificación - [MÓDULO]

## Índice de Planes

### [Categoría 1]
- [Nombre Plan](./subcarpeta/archivo.md)

### [Categoría 2]
- [Nombre Plan](./subcarpeta/archivo.md)

## Cómo Agregar Nuevos Planes
1. Colocar en subcarpeta temática apropiada
2. Actualizar este índice
3. Listar en línea de referencia
```

- [ ] README.md para `/docs/gobernanza/planificacion/`
- [ ] README.md para `/docs/infraestructura/planificacion/`
- [ ] README.md para `/docs/ai/planificacion/`
- [ ] README.md para `/docs/backend/planificacion/`
- [ ] README.md para `/docs/frontend/planificacion/`
- [ ] Actualizar README.md en `/docs/devops/git/planificacion/`
- [ ] Actualizar README.md en `/docs/devops/automatizacion/planificacion/`

---

## FASE 3: MIGRACIÓN DE ARCHIVOS

### Paso 5: Migrar Gobernanza
```bash
# Mover desde /docs/gobernanza/plans/
- [ ] REV_20251112_remediation_plan.md → ../planificacion/planes_remediacion/
- [ ] Otros archivos de plans/ → ../planificacion/planes_remediacion/

# Integrar en /docs/gobernanza/planificacion/
- [ ] Verificar PLAN_REMEDIACION_DOCS_GOBERNANZA.md en destino
- [ ] Consolidar contenido duplicado si existe
- [ ] plan_general.md → planes_generales/ si existe
```

### Paso 6: Migrar Infraestructura
```bash
# Desde /docs/infraestructura/plan/
- [ ] SPEC_INFRA_001_cpython_precompilado_plan.md → planificacion/especificaciones/
- [ ] Otros archivos → planificacion/especificaciones/

# Desde /docs/infraestructura/plans/
- [ ] Todos los archivos → planificacion/release_management/ o deployment/

# Desde /docs/infraestructura/planificacion_y_releases/
- [ ] Mover a planificacion/release_management/ o planificacion/deployment/

# Eliminar directorios antiguos
- [ ] Crear .gitkeep en plan/, plans/, planificacion_y_releases/
- [ ] Documentar eliminación en log
```

### Paso 7: Migrar IA
```bash
# Desde /docs/ai/plans/
- [ ] EXECPLAN_prompt_techniques_catalog.md → planificacion/ejecucion/
- [ ] EXECPLAN_meta_agente_codex.md → planificacion/ejecucion/
- [ ] EXECPLAN_context_memory_management.md → planificacion/ejecucion/
- [ ] EXECPLAN_codex_mcp_multi_llm.md → planificacion/ejecucion/
- [ ] EXECPLAN_agents_domain_alignment.md → planificacion/ejecucion/

# Desde raíz /docs/ai/
- [ ] PLAN_EJECUCION_COMPLETO.md → planificacion/ejecucion/

# Desde /docs/ai/planificacion_y_releases/
- [ ] issue_plan_validation_agent.md → planificacion/release_management/
- [ ] Otros → planificacion/release_management/ o validation/

# Limpiar directorios
- [ ] Crear .gitkeep en plans/, planificacion_y_releases/
```

### Paso 8: Migrar Backend
```bash
# Desde raíz /docs/backend/
- [ ] planificacion_documentacion.md → planificacion/documentacion/

# Desde /docs/backend/deployment/
- [ ] deployment_plan.md → planificacion/deployment/
  (considerar mantener copia en deployment/ para acceso directo)

# Verificar QA references
- [ ] TASK-030, TASK-025, TASK-044 en qa/ → revisar si necesitan actualización
```

### Paso 9: Migrar Frontend
```bash
# Desde /docs/frontend/plans/
- [ ] Todos los archivos → planificacion/release_management/ o ui_ux/

# Desde /docs/frontend/planificacion_y_releases/
- [ ] Mover a planificacion/release_management/

# Limpiar directorios antiguos
- [ ] Crear .gitkeep en plans/, planificacion_y_releases/
```

### Paso 10: Validar DevOps
```bash
# Git planificación
- [ ] Verificar TESTING_PLAN_GIT_DOCS.md
- [ ] Verificar MAINTENANCE_PLAN_GIT_DOCS.md
- [ ] Verificar DEPLOYMENT_PLAN_GIT_DOCS.md

# Automatización planificación
- [ ] Verificar MAINTENANCE_PLAN.md
- [ ] Verificar TESTING_PLAN.md
- [ ] Verificar DEPLOYMENT_PLAN.md

# Confirmar estructura correcta
- [ ] Todos los archivos están en planificacion/
- [ ] README.md existe en ambos lugares
```

---

## FASE 4: ACTUALIZACIÓN DE REFERENCIAS

### Paso 11: Actualizar Enlaces Internos

**Buscar y reemplazar patrones**:
```
docs/gobernanza/plans/ → docs/gobernanza/planificacion/planes_remediacion/
docs/infraestructura/plan/ → docs/infraestructura/planificacion/especificaciones/
docs/infraestructura/plans/ → docs/infraestructura/planificacion/release_management/
docs/ai/plans/ → docs/ai/planificacion/ejecucion/
docs/ai/PLAN_EJECUCION → docs/ai/planificacion/ejecucion/PLAN_EJECUCION
docs/backend/deployment/ → docs/backend/planificacion/deployment/
docs/frontend/plans/ → docs/frontend/planificacion/release_management/
```

- [ ] Ejecutar grep exhaustivo para encontrar todas las referencias
- [ ] Documentar archivos afectados
- [ ] Actualizar referencias en markdown files
- [ ] Actualizar referencias en código (si aplica)
- [ ] Verificar no hay referencias rotas (validar links)

### Paso 12: Actualizar Documentación Principal

- [ ] Actualizar índice maestro de documentación
- [ ] Actualizar instrucciones de contribución
- [ ] Actualizar guía de estructura de carpetas
- [ ] Crear "Convenciones de Planes" document
- [ ] Actualizar wiki/documentation site

---

## FASE 5: VALIDACIÓN Y DOCUMENTACIÓN

### Paso 13: Verificación Self-Consistency

**Validación 1: Cobertura de Planes**
```bash
# Ejecutar análisis
find /home/user/IACT -type f -name "*plan*.md" | grep -v ".git"
```

- [ ] Confirmar 0 archivos `*plan*.md` en raíces de módulos (excepto en planificacion/)
- [ ] Confirmar 0 archivos `*plan*.md` en `plan/`, `plans/`
- [ ] Confirmar todos están en `planificacion/` o subdirectorios

**Validación 2: Links**
```bash
# Verificar no hay referencias rotas
grep -r "docs/gobernanza/plans/" /home/user/IACT --include="*.md"
grep -r "docs/infraestructura/plan/" /home/user/IACT --include="*.md"
# ... etc para cada ruta antigua
```

- [ ] Confirmar 0 referencias a rutas antiguas
- [ ] Confirmar todos los links internos funcionan
- [ ] Validar cross-references entre planes

**Validación 3: Completitud**
- [ ] Todos los README.md tienen índices actualizados
- [ ] Todos los planes tienen categorización clara
- [ ] No hay duplicación de contenido
- [ ] Metadatos están presentes en archivos key

**Validación 4: Integridad**
- [ ] Verificar filesize total no cambió (no se perdió contenido)
- [ ] Verificar timestamps de últimas modificaciones
- [ ] Hacer git diff para verificar cambios esperados

### Paso 14: Documentar Resultados

- [ ] Crear REPORTE_MIGRACION.md con resultados
- [ ] Documentar:
  - Archivos movidos (cantidad)
  - Directorios creados
  - Referencias actualizadas (cantidad)
  - Problemas encontrados
  - Tiempo total de ejecución
  - Anomalías o excepciones

### Paso 15: Git Commit

```bash
# Hacer commits descriptivos por fase
- [ ] git add [archivos migrados]
- [ ] git commit -m "TASK-REORG-INFRA-011: Consolidar planificación - Fase [N]"
- [ ] Repetir para cada fase significativa
```

- [ ] Crear commit final de consolidación
- [ ] Agregar este checklist completado como evidencia
- [ ] Push a rama feature
- [ ] Crear Pull Request si aplica

---

## VALIDACIÓN FINAL

### Paso 16: Self-Consistency Final Check

**Verificación Exhaustiva**:
```bash
# 1. Confirmar estructura
tree /docs/*/planificacion/ -L 2

# 2. Contar archivos
find /docs/*/planificacion -type f -name "*.md" | wc -l
(Comparar con número original)

# 3. Buscar archivos huérfanos
find /docs -type f -name "*plan*.md" | grep -v "planificacion"

# 4. Validar índices
grep -l "^#.*ndice\|^##.*ndice" /docs/*/planificacion/README.md
```

- [ ] Paso 1: Estructura confirmada
- [ ] Paso 2: Cuenta de archivos match
- [ ] Paso 3: 0 archivos huérfanos encontrados
- [ ] Paso 4: Todos los índices existen

---

## CHECKLIST DE CIERRE

### Documentación
- [ ] README.md de tarea completado
- [ ] ANALISIS-PLANIFICACION-DISPERSA.md creado
- [ ] REPORTE_MIGRACION.md creado
- [ ] Este checklist completado
- [ ] Guía de convenciones de planes creada

### Código/Cambios
- [ ] Todos los archivos movidos correctamente
- [ ] Todos los links actualizados
- [ ] Todos los directorios antiguos marcados con .gitkeep
- [ ] Estructura matches propuesta

### Validación
- [ ] Self-Consistency check pasó
- [ ] 0 links rotos
- [ ] 0 archivos perdidos
- [ ] Métrica de éxito alcanzada (100% consolidado)

### Git
- [ ] Commits realizados
- [ ] Rama feature actualizada
- [ ] Pull Request creado (si aplica)
- [ ] Cambios visible en git log

### Follow-up
- [ ] Team notificado de cambios
- [ ] Documentación actualizada en wiki
- [ ] Instrucciones de contribución revisadas
- [ ] FAQ actualizado

---

## MÉTRICAS DE ÉXITO - VERIFICACIÓN FINAL

| Métrica | Objetivo | Actual | Estado |
|---------|----------|--------|--------|
| Archivos `*plan*.md` fuera `planificacion/` | 0 | ? | [ ] |
| Directorios planes dispersos activos | 0 | ? | [ ] |
| README.md en cada `planificacion/` | 7 | ? | [ ] |
| Links rotos encontrados | 0 | ? | [ ] |
| Cobertura self-consistency | 100% | ? | [ ] |
| Duración total ejecución | <= 3h | ? | [ ] |

---

## NOTAS Y CONSIDERACIONES

### Riesgos Mitigados
- [ ] Validar cambios no rompen builds
- [ ] Verificar CI/CD pipelines aún funcionan
- [ ] Confirmar documentación sitio actualizado

### Decisiones Documentadas
- [ ] Decisión sobre directorios `.gitkeep`: Mantener temporalmente
- [ ] Decisión sobre duplicación: Consolidar hacia `planificacion/`
- [ ] Decisión sobre estructura temática: Usar subdirectorios por tipo

### Escalabilidad
- [ ] Estructura permite agregar nuevos planes fácilmente
- [ ] Convenciones claras para futuros contribuyentes
- [ ] Índices facilitarán búsqueda y descubrimiento

---

**Checklist Versión**: 1.0
**Última Actualización**: 2025-11-18
**Responsable Ejecución**: [Por asignar]
**Fecha de Completación**: [Por establecer]

---

## Firma de Finalización

- [ ] **Iniciador**: _________________ Fecha: _______
- [ ] **Ejecutor**: _________________ Fecha: _______
- [ ] **Revisor**: _________________ Fecha: _______

