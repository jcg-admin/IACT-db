---
id: TASK-REORG-INFRA-036
tipo: tarea_contenido
categoria: adr
fase: FASE_3_CONTENIDO_NUEVO
prioridad: MEDIA
duracion_estimada: 3h
estado: pendiente
dependencias: [TASK-REORG-INFRA-031]
tags: [adr, cpython, python, precompilado, decision, infraestructura]
tecnica_prompting: Template-based Prompting + Auto-CoT + Self-Consistency
fecha_creacion: 2025-11-18
---

# TASK-REORG-INFRA-036: Crear ADR-INFRA-006 (CPython Precompilado Strategy)

## Auto-CoT: Razonamiento de la Decisión de Python

### 1. Identificación del Problema
- **Pregunta central:** ¿Usar CPython precompilado o compilar desde source en DevContainer?
- **Contexto:** DevContainer necesita Python para backend, tooling, etc.
- **Requisito:** Optimizar balance entre build time, compatibility, reproducibilidad

### 2. Evaluación de Opciones (Chain-of-Thought)

**Paso 1: Definir requisitos**
```
- Python 3.10+ (backend requirements)
- reproducible entre devs
- Consistent versioning
- Reasonable build time (< 5 min)
- Vendored dependencies optional
```

**Paso 2: Opciones técnicas**
- **A:** Compilar CPython desde source en Dockerfile
  - Pros: Control total, reproducible
  - Contras: 10+ minutos build time
  - Verdict: No óptimo para dev

- **B:** Precompilado (official Python images)
  - Pros: <10 segundos, mantido, seguro
  - Contras: Less control
  - Verdict: [OK] Óptimo para dev

- **C:** Pyenv en VM
  - Pros: Multiple versions, simple
  - Contras: Runtime install overhead
  - Verdict: Bueno pero menos reproducible

**Paso 3: Considerar reproducibilidad**
```
Precompilado:
- Base image pinned a versión específica [OK]
- Official images auditadas por seguridad [OK]
- Actualizaciones controlables [OK]

Compilado:
- Reproducible en teoría
- Pero build time impacta workflow
```

### 3. Impacto en Arquitectura
- **Positivo:** Build time rápido (< 1 minuto DevContainer startup)
- **Positivo:** Security audits de Python official
- **Positivo:** Compatible con muchas versiones de pip packages
- **Negativo:** Menos control sobre configuración CPython
- **Neutral:** Documentación de python-version.txt requerida

## Descripción de la Tarea

Esta tarea documenta formalmente la estrategia de **usar CPython precompilado** en el Dockerfile del DevContainer, balanceando reproducibilidad con developer experience.

Es el **sexto ADR formal de infraestructura**, definiendo la versión de Python para el proyecto.

## Objetivo

Crear un Architecture Decision Record (ADR) que:
- Documente requisitos de Python en proyecto
- Compare CPython precompilado vs compilado desde source
- Justifique el uso de versiones precompiladas
- Establezca criterios de versionado de Python
- Defina actualización y rotación de versiones

## Alineación

**Canvases de referencia:**
- `/docs/infraestructura/diseno/arquitectura/devcontainer-host-vagrant.md`

**Decisión:** ADR-INFRA-006 especifica la estrategia de Python runtime.

## Contenido a Generar

### Archivo Principal
- **Ubicación:** `/docs/infraestructura/adr/ADR-INFRA-006-cpython-precompilado-strategy.md`
- **Formato:** Markdown con frontmatter YAML
- **Secciones:** 8 secciones completas

### Estructura del ADR

1. **Contexto y Problema**
   - Requisitos de Python en proyecto (backend, tools)
   - Necesidad de reproducibilidad
   - Build time considerations
   - Multiple versions support (future)

2. **Factores de Decisión**
   - Build Time (Alto)
   - Reproducibility (Alto)
   - Security Updates (Alto)
   - Python Compatibility (Medio)
   - Version Control (Medio)

3. **Opciones Consideradas**
   - Compilar CPython desde source
   - Usar CPython precompilado (official images)
   - Pyenv en VM
   - Buildpacks (rechazado)

4. **Decisión**
   - Usar CPython precompilado (official Docker images)

5. **Justificación**
   - Build time: <1 minuto para DevContainer
   - Security: Official images auditadas
   - Reproducibility: Versioning controlado
   - Maintenance: Updates automáticos disponibles

6. **Consecuencias**
   - Positivas: Build time rápido, seguridad
   - Negativas: Menos control sobre compilación
   - Neutrales: Documentación de versioning

7. **Plan de Implementación**
   - Fase 1: Seleccionar versión base (python:3.11-slim)
   - Fase 2: Dockerfile con requirements.txt pinned
   - Fase 3: Setup de pip caching (BuildKit)
   - Fase 4: Testing en múltiples arquitecturas (AMD64, ARM64)

8. **Validación y Métricas**
   - Criterios: DevContainer startup < 1 minuto
   - Medición: Build time, image size
   - Compatibility: Tests passing en dev

## Self-Consistency: Validación de Coherencia

### Checklist de Completitud

- [ ] 8 secciones presentes en el ADR
- [ ] Frontmatter YAML completo
- [ ] Requisitos de Python documentados
- [ ] 4 opciones consideradas
- [ ] Build time análisis
- [ ] Security considerations
- [ ] Version strategy documentada
- [ ] Compatibility matrix
- [ ] Update strategy (minor/patch)
- [ ] Referencias a tooling (pip, requirements.txt)

### Alineación Verificada

| Criterio | Requisito | ADR | Status |
|----------|-----------|-----|--------|
| Python version pinned | Crítico | [ ] | Pendiente |
| Build time < 1min | Crítico | [ ] | Pendiente |
| Security audited | Importante | [ ] | Pendiente |
| Reproducible | Importante | [ ] | Pendiente |
| Multi-arch support | Importante | [ ] | Pendiente |

### Coherencia del Razonamiento

**Verificación Chain-of-Thought:**
```
1. ¿Requisitos claros?
   → Sí: Python 3.10+, <1min build, reproducible

2. ¿Opciones evaluadas?
   → Sí: 4 opciones con análisis

3. ¿Elección óptima?
   → Sí: Precompilado = best balance

4. ¿Impacto considerado?
   → Sí: Positivos/negativos/neutrales

5. ¿Plan realista?
   → Sí: Dockerfile + requirements.txt
```

## Decisión Capturada (Preliminary)

**Opción elegida:** CPython precompilado (official Docker images)

**Justificación:**
- Build time optimizado (<1 minuto)
- Security: Official images auditadas
- Reproducibility: Version pinning en image tag
- Maintenance: Updates automáticos disponibles
- Compatibility: Amplio soporte de pip packages

## Python Version Strategy

```
Dockerfile base:
FROM python:3.11-slim

Rationale:
- 3.11: Latest stable, performance improvements
- slim: ~300MB vs 900MB para full image
- official: Security patches garantizados

Requirements management:
requirements.txt
├─ Pinned versions (pip freeze)
├─ Hash verification (pip hash)
└─ Security scanning (safety, pip-audit)

Docker layer caching:
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
→ Optimizes rebuilds

Multi-arch support:
→ AMD64 (Intel/AMD)
→ ARM64 (Apple Silicon)
```

## Próximos Pasos

1. Desarrollar ADR-INFRA-006 con 8 secciones
2. Documentar version strategy
3. Crear Dockerfile con best practices
4. Testing en AMD64 y ARM64
5. Requirements.txt pinning strategy
6. Security scanning integration

## Referencias

- **Python Official Docker Images:** https://hub.docker.com/_/python
- **pip-audit:** https://github.com/pypa/pip-audit
- **Safety (vulnerability check):** https://safety.readthedocs.io/
- **BuildKit for Docker:** https://docs.docker.com/build/buildkit/
- **Plantilla ADR:** `/docs/gobernanza/adr/plantilla_adr.md`

## Criterios de Aceptación

- [ ] ADR-INFRA-006 creado con 8 secciones
- [ ] Python version strategy documented
- [ ] Dockerfile with best practices
- [ ] Build time < 1 minute verified
- [ ] Multi-arch compatibility confirmed (AMD64, ARM64)
- [ ] Security scanning integrated
- [ ] Chain-of-Thought validado

---

**Estado:** PENDIENTE
**Fecha Creación:** 2025-11-18
**Fase:** FASE_3_CONTENIDO_NUEVO
**Responsable:** Equipo de Arquitectura + Backend
