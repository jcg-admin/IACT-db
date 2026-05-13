---
title: UBICACIÓN CORRECTA DE ARCHIVOS DUPLICADOS
date: 2025-11-13
domain: general
status: active
---

# UBICACIÓN CORRECTA DE ARCHIVOS DUPLICADOS

Según la estructura propuesta donde:
- **docs/ raíz**: Documentación GENERAL/TRANSVERSAL del proyecto
- **docs/implementacion/**: Documentación ESPECÍFICA de implementación por área

---

## Análisis por Archivo

### 1. checklist_desarrollo.md

**Naturaleza**: Checklist de desarrollo transversal

**Ubicación correcta**: `docs/checklists/checklist_desarrollo.md` OK

**Razón**: 
- Es un checklist que aplica a TODO el desarrollo del proyecto
- Contiene reglas generales (output profesional, linters, tests)
- No es específico de backend, frontend o infrastructure
- La versión general (883 bytes) es más completa que el stub de backend (299 bytes)

**Acción**:
- OK MANTENER: `docs/checklists/checklist_desarrollo.md`
- NO ELIMINAR: `docs/backend/checklists/checklist_desarrollo.md`

---

### 2. checklist_testing.md

**Naturaleza**: Checklist de testing transversal

**Ubicación correcta**: `docs/checklists/checklist_testing.md` OK

**Razón**:
- Aplica a tests de cualquier capa (backend, frontend, infrastructure)
- Es documentación general de QA

**Acción**:
- OK MANTENER: `docs/checklists/checklist_testing.md`
- NO ELIMINAR: `docs/backend/checklists/checklist_testing.md` (idéntico)

---

### 3. checklist_trazabilidad_requisitos.md

**Naturaleza**: Checklist de trazabilidad transversal

**Ubicación correcta**: `docs/checklists/checklist_trazabilidad_requisitos.md` OK

**Razón**:
- La trazabilidad de requisitos es un proceso general del proyecto
- Aplica a requisitos de cualquier área

**Acción**:
- OK MANTENER: `docs/checklists/checklist_trazabilidad_requisitos.md`
- NO ELIMINAR: `docs/backend/checklists/checklist_trazabilidad_requisitos.md` (idéntico)

---

### 4. checklist_cambios_documentales.md

**Naturaleza**: Checklist de gobernanza documental

**Ubicación correcta**: `docs/checklists/checklist_cambios_documentales.md` OK

**Razón**:
- Es un proceso de gobernanza que aplica a TODA la documentación
- No es específico de infrastructure

**Acción**:
- OK MANTENER: `docs/checklists/checklist_cambios_documentales.md`
- NO ELIMINAR: `docs/infraestructura/checklists/checklist_cambios_documentales.md` (idéntico)

---

### 5. contenedores_devcontainer.md

**Naturaleza**: Documentación de infraestructura de desarrollo general

**Ubicación correcta**: `docs/devops/contenedores_devcontainer.md` OK

**Razón**:
- Los devcontainers son configuración GENERAL del entorno de desarrollo
- Aplican a todo el proyecto (backend, frontend, infrastructure)
- No es documentación específica de implementación de infrastructure
- La versión general (8.5KB) es mucho más completa que el stub (1.9KB)

**Acción**:
- OK MANTENER: `docs/devops/contenedores_devcontainer.md`
- NO ELIMINAR: `docs/infraestructura/devops/contenedores_devcontainer.md` (stub)

---

### 6. github_copilot_codespaces.md

**Naturaleza**: Runbook operativo de infraestructura de desarrollo

**Ubicación correcta**: `docs/devops/runbooks/github_copilot_codespaces.md` WARNING

**Razón**:
- Es un runbook operativo que aplica al entorno general de desarrollo
- No es específico de la implementación de infrastructure como área

**PERO**: Las dos versiones tienen contenido diferente (9.5KB vs 13.6KB)

**Acción**:
- REVISAR MANUALMENTE: Comparar ambas versiones para determinar cuál es más actual
- Luego mantener solo una en `docs/devops/runbooks/`
- Eliminar la versión en `docs/infraestructura/`

---

### 7. lineamientos_codigo.md

**Naturaleza**: Lineamientos arquitectónicos generales

**Ubicación correcta**: `docs/arquitectura/lineamientos_codigo.md` OK

**Razón**:
- Los lineamientos de código son TRANSVERSALES a todo el proyecto
- Aunque el backend tenga especificidades, la base debe ser general
- La versión general (11KB) es 18x más completa que el stub de backend (618 bytes)

**Acción**:
- OK MANTENER: `docs/arquitectura/lineamientos_codigo.md`
- WARNING OPCIONES para `docs/backend/arquitectura/lineamientos_codigo.md`:
  - **Opción A**: Eliminar el stub
  - **Opción B**: Expandir con lineamientos ESPECÍFICOS de Django/Python (herencia del general)

**Recomendación**: Opción B - Expandir con:
```markdown
# Lineamientos de Código - Backend

Este documento extiende los [lineamientos generales](../../../arquitectura/lineamientos_codigo.md) con especificaciones para el backend Django.

## Herencia
Ver lineamientos base en: `docs/arquitectura/lineamientos_codigo.md`

## Específicos de Backend Django
- Convenciones de models.py
- Estructura de services.py
- Patrones de views y serializers
- etc.
```

---

### 8. lineamientos_gobernanza.md

**Naturaleza**: Lineamientos de gobernanza

**Ubicación correcta**: `docs/gobernanza/lineamientos_gobernanza.md` WARNING

**Razón**:
- La gobernanza puede tener aspectos generales Y específicos por área
- Ambas versiones son pequeñas (358 vs 417 bytes) y diferentes

**Acción**:
- REVISAR MANUALMENTE: Comparar contenido
- Si el contenido de infrastructure es un SUBSET del general -> Eliminar versión de infrastructure
- Si el contenido de infrastructure tiene ESPECIFICIDADES -> Mantener ambas con herencia clara

---

### 9. reprocesar_etl_fallido.md

**Naturaleza**: Runbook operativo

**Ubicación correcta**: `docs/devops/runbooks/reprocesar_etl_fallido.md` OK

**Razón**:
- Los runbooks operativos deben estar CENTRALIZADOS en devops
- Aunque sea específico del ETL backend, el equipo de DevOps necesita acceso directo
- La versión general (9.6KB) es 8x más completa que el stub (1.2KB)

**Acción**:
- OK MANTENER: `docs/devops/runbooks/reprocesar_etl_fallido.md`
- NO ELIMINAR: `docs/backend/devops/runbooks/reprocesar_etl_fallido.md` (stub)

**Nota**: Si el backend necesita documentación de diseño del ETL, eso va en `docs/backend/diseno/` (no runbooks)

---

### 10. verificar_servicios.md

**Naturaleza**: Runbook operativo de verificación

**Ubicación correcta**: `docs/devops/runbooks/verificar_servicios.md` OK

**Razón**:
- Runbook operativo transversal (verifica TODOS los servicios)
- Debe estar centralizado para el equipo de DevOps/SRE
- Versión general (7.5KB) es 7x más completa

**Acción**:
- OK MANTENER: `docs/devops/runbooks/verificar_servicios.md`
- NO ELIMINAR: `docs/infraestructura/devops/runbooks/verificar_servicios.md` (stub)

---

### 11. post_create.md

**Naturaleza**: Runbook de inicialización de entorno

**Ubicación correcta**: `docs/devops/runbooks/post_create.md` OK

**Razón**:
- Script de post-create aplica al entorno general de desarrollo
- No es específico de la implementación de infrastructure
- Versión general (8KB) es 8x más completa

**Acción**:
- OK MANTENER: `docs/devops/runbooks/post_create.md`
- NO ELIMINAR: `docs/infraestructura/devops/runbooks/post_create.md` (stub)

---

### 12. ADR_2025_001-vagrant-mod-wsgi.md

**Naturaleza**: ADR (Architecture Decision Record)

**Ubicación correcta**: `docs/arquitectura/adr/ADR_2025_001-vagrant-mod-wsgi.md` OK

**Razón**:
- Los ADRs deben estar CENTRALIZADOS en un solo lugar
- Son decisiones arquitectónicas del PROYECTO, no de un área específica
- Aunque el ADR sea sobre Vagrant (infra), la decisión afecta a todo el proyecto
- Versión general (7.5KB) es 6x más completa

**Acción**:
- OK MANTENER: `docs/arquitectura/adr/`
- NO ELIMINAR: `docs/infraestructura/arquitectura/adr/` (stub)

**Principio**: Un proyecto debe tener UNA ÚNICA fuente de ADRs

---

### 13. plantilla_adr.md

**Naturaleza**: Plantilla de ADR

**Ubicación correcta**: `docs/arquitectura/adr/plantilla_adr.md` OK

**Alternativa aceptable**: `docs/plantillas/plantilla_adr.md`

**Razón**:
- Las plantillas deben estar en un lugar centralizado
- Todos los equipos (backend, frontend, infrastructure) deben usar la MISMA plantilla
- Versión general (4.6KB) es 6.5x más completa

**Acción**:
- OK MANTENER: `docs/arquitectura/adr/plantilla_adr.md`
- NO ELIMINAR: `docs/infraestructura/arquitectura/adr/plantilla_adr.md` (simplificada)

---

## RESUMEN DE UBICACIONES

### Checklists → `docs/checklists/`
- OK: checklist_desarrollo.md
- OK: checklist_testing.md
- OK: checklist_trazabilidad_requisitos.md
- OK: checklist_cambios_documentales.md

### DevOps → `docs/devops/`
- OK: contenedores_devcontainer.md
- OK: runbooks/github_copilot_codespaces.md (revisar cuál versión)
- OK: runbooks/reprocesar_etl_fallido.md
- OK: runbooks/verificar_servicios.md
- OK: runbooks/post_create.md

### Arquitectura → `docs/arquitectura/`
- OK: lineamientos_codigo.md
- OK: adr/ADR_2025_001-vagrant-mod-wsgi.md
- OK: adr/plantilla_adr.md

### Gobernanza → `docs/gobernanza/`
- WARNING: lineamientos_gobernanza.md (revisar si mantener ambos)

---

## PRINCIPIO DE DECISIÓN

**Regla de oro**: Preguntarse:

1. **¿Es transversal/general?** → `docs/` raíz
   - Aplica a todo el proyecto
   - Usado por múltiples equipos
   - Ej: runbooks, ADRs, checklists, lineamientos

2. **¿Es específico de implementación?** → `docs/implementacion/{area}/`
   - Requisitos específicos de un área
   - Diseño detallado de componentes
   - Documentación técnica de código
   - Ej: requisitos RF-001 del backend, diseño de componentes React

3. **¿Hay duda?** → Documentación operativa y de gobernanza suele ser GENERAL

---

## ACCIONES RECOMENDADAS

### Eliminar inmediatamente (10 archivos):
```bash
# Duplicados idénticos
rm docs/backend/checklists/checklist_testing.md
rm docs/backend/checklists/checklist_trazabilidad_requisitos.md
rm docs/infraestructura/checklists/checklist_cambios_documentales.md

# Stubs de backend
rm docs/backend/checklists/checklist_desarrollo.md
rm docs/backend/devops/runbooks/reprocesar_etl_fallido.md

# Stubs de infrastructure
rm docs/infraestructura/devops/contenedores_devcontainer.md
rm docs/infraestructura/devops/runbooks/verificar_servicios.md
rm docs/infraestructura/devops/runbooks/post_create.md
rm docs/infraestructura/arquitectura/adr/ADR_2025_001-vagrant-mod-wsgi.md
rm docs/infraestructura/arquitectura/adr/plantilla_adr.md
```

### Revisar manualmente (2 archivos):
1. Comparar `github_copilot_codespaces.md` (ambas versiones extensas)
2. Comparar `lineamientos_gobernanza.md` (contenido diferente)

### Considerar expandir (1 archivo):
- `docs/backend/arquitectura/lineamientos_codigo.md` 
  → Expandir con lineamientos específicos de Django, o eliminar

