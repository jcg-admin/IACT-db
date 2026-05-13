---
id: QA-ANALISIS-REORG-ESTRUCTURA-INFRA-001
tipo: analisis_reorganizacion
categoria: qa_infraestructura
estado: en_progreso
fecha_inicio: 2025-11-18
version: 1.0.0
responsable: equipo-infraestructura
prioridad: alta
relacionados:
  - QA-ANALISIS-ESTRUCTURA-INFRA-001
  - docs/gobernanza/qa/QA-ANALISIS-RAMAS-001
  - docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001
tags:
  - reorganizacion
  - estructura
  - infraestructura
  - qa
  - gobernanza
---

# README - Análisis y Reorganización Estructural de docs/infraestructura/

## Información del Análisis

- **ID:** QA-ANALISIS-REORG-ESTRUCTURA-INFRA-001
- **Tipo:** Análisis de reorganización estructural completa
- **Fecha de inicio:** 2025-11-18
- **Estado:** En progreso
- **Responsable:** Equipo de Infraestructura
- **Duración estimada:** 4-6 semanas
- **Esfuerzo estimado:** 28-38 persona-días

---

## 1. RESUMEN EJECUTIVO

### 1.1 Propósito

Este análisis documenta la reorganización completa de la estructura de documentación del dominio `docs/infraestructura/` para alinearla con el modelo de referencia establecido en `docs/gobernanza/`.

### 1.2 Alcance

**Incluye:**
- Reorganización de estructura de carpetas completa
- Creación de carpetas faltantes (13+ carpetas nuevas)
- Consolidación de documentos dispersos
- Creación de ADRs formales (5+)
- Creación de procesos y procedimientos formales (10+)
- Creación de plantillas reutilizables (8+)
- Creación de catálogos técnicos (4+)
- Matrices de trazabilidad
- Documentación de visión y roadmap
- Canvas de arquitectura (DevContainer Host, Pipeline CI/CD)

**NO incluye:**
- Cambios en código de `infrastructure/`
- Modificación de configuraciones de Vagrant
- Cambios en scripts de provisión

### 1.3 Objetivos

1. **Environmental Consistency**: Mantener consistencia documental entre desarrollo y producción
2. **Operational Equivalence**: Documentar operaciones de forma equivalente a otros dominios
3. **Deterministic Execution**: Procedimientos deterministas y reproducibles
4. **Unified Toolchain**: Documentación unificada con otros dominios del proyecto

---

## 2. SITUACIÓN ACTUAL

### 2.1 Análisis Cuantitativo

| Métrica | Valor Actual | Objetivo |
|---------|--------------|----------|
| Carpetas principales | 22 | 33+ |
| Archivos markdown | 95 | 180+ |
| READMEs presentes | 35/50 (70%) | 100% |
| Archivos con frontmatter | 14/95 (15%) | 90%+ |
| ADRs formales | 1 | 8+ |
| Procesos documentados | 0 | 5+ |
| Procedimientos documentados | 0 | 6+ |
| Plantillas | 4 | 12+ |
| Puntuación de calidad | 60-65/100 | 85-90/100 |

### 2.2 Estructura Actual

```
docs/infraestructura/
├── adr/                    # 1 ADR, falta índice
├── checklists/             # README vacío
├── cpython_precompilado/   # 7 archivos - bien documentado
├── devops/                 # README vacío
├── diseno/                 # 5 archivos - falta organización interna
├── plan/                   # Sin estructura formal
├── procedimientos/         # README vacío - CRÍTICO
├── qa/                     # 31 archivos - mejor documentado
├── requisitos/             # 18 archivos - bien estructurado
├── specs/                  # Sin README
└── Nivel raíz              # 15 archivos sin categorizar
```

### 2.3 Problemas Identificados

**CRÍTICOS (P0):**
1. **2 archivos duplicados** - `index.md` y `spec_infra_001_cpython_precompilado.md` en raíz
2. **4 READMEs vacíos** - `procedimientos/`, `devops/`, `checklists/`, `solicitudes/`
3. **ADRs sin índice** - Solo 1 ADR visible, falta `INDICE_ADRs.md`
4. **Sin procesos formales** - Ningún `PROC-INFRA-XXX.md` documentado
5. **Sin procedimientos formales** - Ningún `PROCED-INFRA-XXX.md` documentado

**ALTOS (P1):**
1. **Carpetas faltantes vs gobernanza** - 13+ carpetas no existen
2. **Documentos sin frontmatter YAML** - 81/95 archivos (85%)
3. **15 archivos raíz sin categorizar** - Necesitan moverse a carpetas apropiadas
4. **Canvas de arquitectura faltantes** - DevContainer Host y Pipeline CI/CD
5. **Matrices de trazabilidad incompletas** - Falta RTM ADR-planes-requisitos

**MEDIOS (P2):**
1. **Nomenclatura inconsistente** - Mezcla de snake_case y kebab-case
2. **Enlaces rotos** - Sin validación automatizada
3. **Plantillas incompletas** - Solo 4 de 12+ necesarias
4. **Catálogos técnicos faltantes** - Sin catálogo de servicios/componentes

---

## 3. ESTRUCTURA OBJETIVO

### 3.1 Modelo de Referencia: docs/gobernanza/

Basado en el análisis exhaustivo de `docs/gobernanza/`, la estructura objetivo debe incluir:

```
docs/infraestructura/
├── adr/                    # Architecture Decision Records (8+ ADRs)
│   ├── INDICE_ADRs.md
│   ├── ADR-INFRA-001-vagrant-devcontainer-host.md
│   ├── ADR-INFRA-002-pipeline-cicd-devcontainer.md
│   └── ...
├── catalogos/              # Catálogos de componentes
│   ├── README.md
│   ├── CATALOGO-SERVICIOS-INFRA.md
│   ├── CATALOGO-VMS-VAGRANT.md
│   └── ...
├── checklists/             # Listas de verificación
│   ├── README.md
│   ├── CHECKLIST-PROVISION-VM.md
│   └── ...
├── ci_cd/                  # CI/CD específico de infraestructura
│   ├── README.md
│   ├── pipeline-devcontainer-ci.md
│   └── ...
├── diseno/                 # Diseño consolidado
│   ├── README.md
│   ├── arquitectura/
│   │   ├── README.md
│   │   ├── canvas-devcontainer-host.md
│   │   ├── canvas-pipeline-cicd.md
│   │   └── ...
│   ├── detallado/
│   ├── database/
│   └── ...
├── ejemplos/               # Ejemplos de código/configuración
│   └── README.md
├── estilos/                # Guías de estilo para IaC
│   └── README.md
├── glosarios/              # Glosario técnico de infraestructura
│   └── README.md
├── gobernanza/             # Gobernanza específica de infraestructura
│   └── README.md
├── guias/                  # Guías técnicas operativas
│   ├── README.md
│   └── ...
├── metodologias/           # Metodologías aplicadas (IaC, GitOps)
│   └── README.md
├── planificacion/          # Planificación consolidada
│   └── README.md
├── plans/                  # Planes de implementación
│   └── README.md
├── plantillas/             # Plantillas de documentos
│   ├── README.md
│   ├── plantilla-adr-infraestructura.md
│   ├── plantilla-procedimiento-infra.md
│   ├── plantilla-vm-vagrant.md
│   └── ...
├── procedimientos/         # Procedimientos operativos (PROCED-INFRA-XXX)
│   ├── README.md
│   ├── PROCED-INFRA-001-provision-vm-vagrant.md
│   ├── PROCED-INFRA-002-configurar-devcontainer-host.md
│   ├── PROCED-INFRA-003-ejecutar-pipeline-cicd.md
│   ├── PROCED-INFRA-004-backup-restauracion-vm.md
│   └── ...
├── procesos/               # Procesos high-level (PROC-INFRA-XXX)
│   ├── README.md
│   ├── PROC-INFRA-001-gestion-infraestructura-vm.md
│   ├── PROC-INFRA-002-ciclo-vida-devcontainer.md
│   ├── PROC-INFRA-003-integracion-continua-infra.md
│   └── ...
├── qa/                     # Quality Assurance
│   ├── README.md
│   ├── QA-ANALISIS-ESTRUCTURA-INFRA-001/
│   └── ...
├── referencias/            # Referencias técnicas
│   └── README.md
├── requisitos/             # Requisitos de infraestructura
│   └── README.md (ya existe, mejorar)
├── seguridad/              # Seguridad específica de infra
│   └── README.md
├── sesiones/               # Sesiones de trabajo
│   └── README.md
├── solicitudes/            # Solicitudes y cambios
│   └── README.md
├── templates/              # Templates adicionales
│   └── README.md
├── testing/                # Testing y pruebas de infra
│   └── README.md
├── trazabilidad/           # Matrices de trazabilidad
│   ├── README.md
│   ├── RTM-INFRA-001-adr-requisitos.md
│   └── ...
└── vision_y_alcance/       # Visión estratégica
    ├── README.md
    ├── VISION-INFRA-2025.md
    └── ROADMAP-INFRA-2025.md
```

### 3.2 Carpetas Nuevas a Crear (13)

1. `catalogos/` - Catálogos de servicios y componentes
2. `ci_cd/` - CI/CD específico de infraestructura
3. `ejemplos/` - Ejemplos de configuración
4. `estilos/` - Guías de estilo IaC
5. `glosarios/` - Glosario técnico
6. `gobernanza/` - Gobernanza específica
7. `guias/` - Guías técnicas
8. `metodologias/` - Metodologías (IaC, GitOps)
9. `planificacion/` - Planificación consolidada
10. `plans/` - Planes de implementación
11. `seguridad/` - Seguridad de infra
12. `testing/` - Testing de infra
13. `vision_y_alcance/` - Visión y roadmap

---

## 4. GAPS IDENTIFICADOS

### 4.1 Gaps de Estructura (13 carpetas faltantes)

```
FALTANTE                    PRIORIDAD    IMPACTO
----------------------------------------
catalogos/                  P1           Alto - Sin inventario de servicios
ci_cd/                      P1           Alto - Pipeline sin documentar
ejemplos/                   P2           Medio - Dificulta onboarding
estilos/                    P2           Medio - Inconsistencia en IaC
glosarios/                  P2           Medio - Términos sin definir
gobernanza/                 P1           Alto - Sin marcos de decisión
guias/                      P1           Alto - Operaciones sin guiar
metodologias/               P2           Medio - Sin marco metodológico
planificacion/              P1           Alto - Planificación dispersa
plans/                      P1           Alto - Sin planes formales
seguridad/                  P0           Crítico - Sin doc de seguridad
testing/                    P1           Alto - Tests sin documentar
vision_y_alcance/           P1           Alto - Sin dirección estratégica
```

### 4.2 Gaps de Contenido

**ADRs faltantes (7+):**
- ADR-INFRA-001: Vagrant como DevContainer Host
- ADR-INFRA-002: Pipeline CI/CD sobre DevContainer
- ADR-INFRA-003: Podman vs Docker en VM
- ADR-INFRA-004: Estrategia de networking VM
- ADR-INFRA-005: Gestión de secretos en DevContainer
- ADR-INFRA-006: CPython precompilado strategy
- ADR-INFRA-007: Dual database (MariaDB/PostgreSQL)

**Procesos faltantes (5+):**
- PROC-INFRA-001: Gestión de infraestructura VM
- PROC-INFRA-002: Ciclo de vida DevContainer
- PROC-INFRA-003: Integración continua de infraestructura
- PROC-INFRA-004: Gestión de cambios de infraestructura
- PROC-INFRA-005: Monitoreo y observabilidad

**Procedimientos faltantes (6+):**
- PROCED-INFRA-001: Provisión de VM Vagrant
- PROCED-INFRA-002: Configurar DevContainer Host
- PROCED-INFRA-003: Ejecutar pipeline CI/CD
- PROCED-INFRA-004: Backup y restauración de VM
- PROCED-INFRA-005: Troubleshooting DevContainer
- PROCED-INFRA-006: Actualizar toolchain CPython

**Canvas de arquitectura (2):**
- Canvas DevContainer Host con Vagrant
- Canvas Pipeline CI/CD sobre DevContainer Host

**Plantillas faltantes (8+):**
- Plantilla ADR infraestructura
- Plantilla procedimiento infraestructura
- Plantilla VM Vagrant
- Plantilla DevContainer feature
- Plantilla runbook
- Plantilla checklist provision
- Plantilla requisito no funcional
- Plantilla catálogo de servicios

**Catálogos faltantes (4+):**
- Catálogo de servicios de infraestructura
- Catálogo de VMs Vagrant
- Catálogo de DevContainer features
- Catálogo de scripts de provisión

### 4.3 Gaps de Calidad

| Aspecto | Actual | Objetivo | Gap |
|---------|--------|----------|-----|
| READMEs completos | 70% | 100% | 30% |
| Frontmatter YAML | 15% | 90% | 75% |
| ADRs formales | 1 | 8+ | 7+ |
| Nomenclatura correcta | 60% | 95% | 35% |
| Enlaces válidos | 45% | 95% | 50% |
| Procesos documentados | 0 | 5+ | 5+ |
| Procedimientos documentados | 0 | 6+ | 6+ |

---

## 5. BENEFICIOS DE LA REORGANIZACIÓN

### 5.1 Beneficios Operacionales

1. **Navegación mejorada**: Estructura clara y predecible basada en modelo probado
2. **Onboarding acelerado**: Documentación completa y organizada reduce tiempo de ramp-up
3. **Decisiones documentadas**: ADRs formales capturan contexto y rationale
4. **Operaciones estandarizadas**: Procedimientos formales reducen errores
5. **Trazabilidad completa**: Matrices vinculan requisitos-diseño-implementación

### 5.2 Beneficios Estratégicos

1. **Alineación con gobernanza**: Consistencia con modelo de referencia del proyecto
2. **Escalabilidad**: Estructura soporta crecimiento sin reorganizaciones futuras
3. **Calidad asegurada**: Plantillas y checklists garantizan completitud
4. **Conocimiento preservado**: Documentación formal captura decisiones y contexto
5. **Colaboración facilitada**: Estructura común reduce fricción entre equipos

### 5.3 Beneficios Técnicos

1. **Environmental Consistency**: Mismo entorno dev/CI/CD documentado
2. **Operational Equivalence**: Operaciones reproducibles y documentadas
3. **Deterministic Execution**: Procedimientos paso a paso garantizan resultados
4. **Unified Toolchain**: Herramientas documentadas en un solo lugar
5. **Automated Validation**: Scripts y tests documentados para validación

---

## 6. RIESGOS Y MITIGACIONES

### 6.1 Riesgos Identificados

| ID | Riesgo | Probabilidad | Impacto | Mitigación |
|----|--------|--------------|---------|------------|
| R-001 | Documentos movidos rompen enlaces existentes | Media | Alto | Crear matriz de mapeo antes de mover, validar enlaces post-migración |
| R-002 | Confusión durante transición por estructura dual | Alta | Medio | Comunicar cambios, mantener índices actualizados, fase de transición corta |
| R-003 | Sobrecarga de documentación (demasiados docs) | Baja | Medio | Priorizar documentos P0/P1, crear plantillas para reducir esfuerzo |
| R-004 | Inconsistencia en aplicación de plantillas | Media | Medio | Validación automatizada de frontmatter, pre-commit hooks |
| R-005 | Resistencia al cambio por complejidad percibida | Media | Alto | Comunicar beneficios, proveer guías, involucrar early adopters |
| R-006 | Drift futuro entre gobernanza y infraestructura | Media | Alto | Validación periódica de estructura, auditorías trimestrales |
| R-007 | Tiempo de ejecución excede estimación | Alta | Medio | Trabajo en paralelo con múltiples agentes, priorización P0/P1 |

### 6.2 Estrategias de Mitigación

1. **Backup previo**: Git tag antes de iniciar reorganización
2. **Mapeo documentado**: `MAPEO-MIGRACION-DOCS.md` con ubicación antigua → nueva
3. **Validación automatizada**: Scripts para validar enlaces, frontmatter, nomenclatura
4. **Rollback plan**: Procedimiento documentado para revertir cambios
5. **Comunicación proactiva**: Anuncios antes, durante y después de la reorganización
6. **Ejecución en fases**: 4 fases incrementales con validación entre fases

---

## 7. RECOMENDACIONES INICIALES

### 7.1 Antes de Iniciar

1. **Crear backup completo**: `git tag QA-INFRA-REORG-BACKUP-2025-11-18`
2. **Revisar tareas activas**: Asegurar no hay conflictos con trabajo en progreso
3. **Comunicar a stakeholders**: Notificar inicio de reorganización
4. **Configurar branch**: Trabajar en branch dedicado `feature/qa-reorg-infra-estructura`
5. **Preparar herramientas**: Scripts de validación, plantillas, matriz de mapeo

### 7.2 Durante Ejecución

1. **Trabajo en fases**: Ejecutar 4 fases secuenciales con validación entre fases
2. **Validación continua**: Validar enlaces y estructura después de cada fase
3. **Documentar evidencias**: Capturar evidencias en carpetas `evidencias/` de cada tarea
4. **Actualizar índices**: Mantener `INDICE.md` y `README.md` actualizados
5. **Commits frecuentes**: Commits atómicos por tarea con mensajes convencionales

### 7.3 Después de Completar

1. **Validación final**: Ejecutar suite completa de validaciones
2. **Peer review**: Revisión por equipo de arquitectura/gobernanza
3. **Actualizar gobernanza**: Registrar cambios en `docs/gobernanza/`
4. **Comunicar completitud**: Anunciar finalización y nuevas ubicaciones
5. **Lecciones aprendidas**: Documentar aprendizajes en `LECCIONES-APRENDIDAS.md`

---

## 8. ESTIMACIÓN DE ESFUERZO

### 8.1 Resumen por Fase

| Fase | Duración | Esfuerzo | Tareas |
|------|----------|----------|--------|
| FASE 1: PREPARACIÓN | 1 semana | 5-7 días | 5 tareas |
| FASE 2: REORGANIZACIÓN CRÍTICA | 2 semanas | 10-14 días | 25 tareas |
| FASE 3: CONTENIDO NUEVO | 2 semanas | 10-14 días | 24 tareas |
| FASE 4: VALIDACIÓN Y LIMPIEZA | 1 semana | 3-5 días | 11 tareas |
| **TOTAL** | **6 semanas** | **28-40 días** | **65 tareas** |

### 8.2 Desglose Detallado

**FASE 1 - PREPARACIÓN (1 semana):**
- Crear backup completo (4h)
- Crear 13 carpetas nuevas con READMEs (8h)
- Crear mapeo de migración (4h)
- Configurar herramientas de validación (4h)
- Comunicar inicio (2h)

**FASE 2 - REORGANIZACIÓN CRÍTICA (2 semanas):**
- Consolidar diseño (arquitectura/, detallado/, database/) (16h)
- Consolidar planificación (8h)
- Reorganizar sesiones (8h)
- Mover archivos raíz a carpetas apropiadas (12h)
- Eliminar duplicados (2h)
- Actualizar enlaces (12h)
- Validar estructura (4h)

**FASE 3 - CONTENIDO NUEVO (2 semanas):**
- Crear 8 ADRs formales (32h)
- Crear 5 procesos (PROC-INFRA-XXX) (20h)
- Crear 6 procedimientos (PROCED-INFRA-XXX) (24h)
- Crear 2 Canvas de arquitectura (16h)
- Crear 4 catálogos técnicos (16h)
- Crear 8 plantillas (16h)
- Crear visión y roadmap (8h)
- Crear matrices de trazabilidad (12h)

**FASE 4 - VALIDACIÓN Y LIMPIEZA (1 semana):**
- Validar integridad de enlaces (4h)
- Validar READMEs (100% cobertura) (8h)
- Validar metadatos YAML (8h)
- Validar nomenclatura (4h)
- Limpiar emojis (2h)
- Actualizar README principal (4h)
- Actualizar INDEX (4h)
- Crear CHANGELOG (4h)
- Lecciones aprendidas (4h)

---

## 9. MÉTRICAS DE ÉXITO

### 9.1 Métricas Cuantitativas

| Métrica | Baseline | Objetivo | Medición |
|---------|----------|----------|----------|
| Carpetas principales | 22 | 33+ | Conteo directo |
| READMEs completos | 70% | 100% | find . -name README.md |
| Frontmatter YAML | 15% | 90%+ | Script validación |
| ADRs formales | 1 | 8+ | Conteo en adr/ |
| Procesos documentados | 0 | 5+ | Conteo PROC-INFRA-* |
| Procedimientos | 0 | 6+ | Conteo PROCED-INFRA-* |
| Enlaces válidos | 45% | 95%+ | Script validación |
| Nomenclatura correcta | 60% | 95%+ | Script validación |
| Puntuación calidad | 60-65 | 85-90 | Scorecard compuesto |

### 9.2 Métricas Cualitativas

1. **Navegabilidad**: Usuarios encuentran documentos en <2 minutos
2. **Completitud**: Cada componente tiene documentación completa
3. **Consistencia**: Estructura idéntica a docs/gobernanza/
4. **Usabilidad**: Nuevos miembros pueden onboarding sin ayuda
5. **Mantenibilidad**: Documentación fácil de actualizar

### 9.3 Criterios de Aceptación

- [ ] Estructura de carpetas idéntica a `docs/gobernanza/`
- [ ] 100% de carpetas tienen README.md completo
- [ ] 90%+ de archivos tienen frontmatter YAML
- [ ] 8+ ADRs formales creados
- [ ] 5+ procesos formales documentados
- [ ] 6+ procedimientos formales documentados
- [ ] 2 Canvas de arquitectura creados
- [ ] 4+ catálogos técnicos creados
- [ ] Matrices de trazabilidad completas
- [ ] 95%+ enlaces válidos
- [ ] 95%+ nomenclatura correcta
- [ ] Sin emojis en ningún archivo
- [ ] CHANGELOG completado
- [ ] Lecciones aprendidas documentadas

---

## 10. PRÓXIMOS PASOS

### 10.1 Pasos Inmediatos (Esta Semana)

1. [ ] Revisar y aprobar este análisis
2. [ ] Crear `PLAN-REORGANIZACION-ESTRUCTURA-INFRA-2025-11-18.md`
3. [ ] Crear `LISTADO-COMPLETO-TAREAS.md`
4. [ ] Crear todas las tareas individuales (TASK-001 a TASK-065)
5. [ ] Comunicar inicio de reorganización
6. [ ] Crear git tag de backup

### 10.2 Pasos a Corto Plazo (Próximas 2 Semanas)

1. [ ] Ejecutar FASE 1: PREPARACIÓN
2. [ ] Ejecutar FASE 2: REORGANIZACIÓN CRÍTICA
3. [ ] Validar estructura post-reorganización
4. [ ] Comunicar progreso a stakeholders

### 10.3 Pasos a Mediano Plazo (Semanas 3-6)

1. [ ] Ejecutar FASE 3: CONTENIDO NUEVO
2. [ ] Ejecutar FASE 4: VALIDACIÓN Y LIMPIEZA
3. [ ] Peer review completo
4. [ ] Merge a rama principal
5. [ ] Comunicar completitud

---

## 11. REFERENCIAS

### 11.1 Documentos de Referencia

- `docs/gobernanza/` - Modelo de estructura objetivo
- `docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/` - Modelo de análisis QA
- `docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/` - Modelo de reorganización
- `docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/` - Análisis previo

### 11.2 Herramientas y Scripts

- Validación de enlaces: `scripts/validate_links.sh` (a crear)
- Validación de frontmatter: `scripts/validate_frontmatter.py` (a crear)
- Validación de nomenclatura: `scripts/validate_naming.sh` (a crear)
- Limpieza de emojis: `scripts/clean_emojis.sh` (a crear)

### 11.3 Técnicas de Prompting Aplicadas

Este análisis aplica las siguientes técnicas documentadas en `docs/ai/prompting/`:

1. **Auto-CoT (Chain of Thought)**: Razonamiento paso a paso en análisis
2. **Self-Consistency**: Validación cruzada de hallazgos
3. **Tabular CoT**: Estructuras tabulares para análisis complejos
4. **Decomposed Prompting**: Descomposición de tareas grandes
5. **Chain-of-Verification**: Verificación en múltiples niveles

---

## 12. HISTORIAL DE CAMBIOS

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2025-11-18 | Equipo Infraestructura | Creación inicial del análisis de reorganización |

---

## 13. CONTACTO Y SOPORTE

Para preguntas o sugerencias sobre este análisis:

- **Responsable:** Equipo de Infraestructura
- **Ubicación:** `docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/`
- **Documentos relacionados:** Ver sección 11.1

---

**Última actualización:** 2025-11-18
