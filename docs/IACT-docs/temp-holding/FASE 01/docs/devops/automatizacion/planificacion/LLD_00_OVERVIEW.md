---
title: LLD - Overview y Estructura Modular
issue_number: IACT-AUTO-001
date: 2025-11-13
fase: design
subfase: lld_overview
proyecto: IACT---project
parent_doc: HLD_SISTEMA_AUTOMATIZACION.md
status: in_progress
version: 1.0
---

# Low-Level Design: Overview y Estructura Modular

**Issue**: IACT-AUTO-001
**Fase**: FASE 3 - DESIGN (Low-Level Design)
**Fecha**: 2025-11-13
**Parent**: HLD_SISTEMA_AUTOMATIZACION.md v2.0

---

## Auto-CoT: Descomposicion del LLD en Modulos

Aplicando **Auto-CoT** (Automatic Chain-of-Thought), descompongo el Low-Level Design en módulos especializados:

### Razon de Modularizacion

**Problema**: LLD monolítico (1 archivo) sería:
- Difícil de navegar (3000+ líneas)
- Difícil de mantener (cambios en 1 componente afectan todo)
- Difícil de revisar (PRs gigantes)
- Difícil de versionar (conflictos Git frecuentes)

**Solucion**: Dividir en módulos independientes por componente

---

## Estructura del LLD (6 Documentos)

```
docs/devops/automatizacion/planificacion/
├── LLD_00_OVERVIEW.md              # Este archivo - Índice maestro
├── LLD_01_CONSTITUCION.md          # Sistema constitución (.constitucion.yaml, scripts/constitucion.sh)
├── LLD_02_CI_LOCAL.md              # Pipeline CI/CD local (.ci-local.yaml, scripts/ci-local.sh)
├── LLD_03_DEVCONTAINER.md          # Integración DevContainer lifecycle
├── LLD_04_SCRIPTS_HELPERS.md       # Scripts auxiliares (check_ui_api_coherence.sh, etc.)
└── LLD_05_INSTALACION.md           # Procedimientos instalación y deployment
```

---

## LLD_01_CONSTITUCION.md

**Contenido**:
1. Especificación completa .constitucion.yaml
   - Esquema YAML detallado
   - 5 principios con metadata completa
   - 6 reglas con condiciones, acciones, mensajes
   - Sistema evolución reglas
   - Métricas y reportes

2. Especificación scripts/constitucion.sh
   - Código completo línea por línea
   - Funciones evaluación por tipo
   - Manejo errores y logging
   - Exit codes y outputs

3. Helper scripts
   - check_ui_api_coherence.sh
   - validate_devcontainer_env.sh

**Tamaño estimado**: 500-800 líneas
**Audiencia**: Desarrollador implementando sistema constitución

---

## LLD_02_CI_LOCAL.md

**Contenido**:
1. Especificación .ci-local.yaml
   - Esquema YAML configuración pipeline
   - 4 stages (lint, test, build, validate)
   - Jobs por stage con comandos exactos
   - Paralelización y fail-fast
   - Logging y artifacts

2. Especificación scripts/ci-local.sh
   - Código completo orquestador
   - Lógica paralelización
   - Agregación resultados
   - Generación reportes

3. Integración scripts existentes
   - Como orquestar run_all_tests.sh
   - Como orquestar validate_security_config.sh
   - Como orquestar validate_database_router.sh

**Tamaño estimado**: 600-900 líneas
**Audiencia**: Desarrollador implementando CI local

---

## LLD_03_DEVCONTAINER.md

**Contenido**:
1. Modificaciones infrastructure/devcontainer/scripts/post_create.sh
   - Código a agregar al final
   - Validación constitución en setup
   - Instalación hooks automática
   - Mensajes informativos

2. Modificaciones infrastructure/devcontainer/scripts/post_start.sh
   - Recordatorios sistema activo
   - Quick checks

3. Flujo completo lifecycle
   - initializeCommand → onCreateCommand → updateContentCommand → postCreateCommand → postStartCommand
   - Validaciones en cada etapa

**Tamaño estimado**: 300-400 líneas
**Audiencia**: Desarrollador integrando con DevContainer

---

## LLD_04_SCRIPTS_HELPERS.md

**Contenido**:
1. Scripts nuevos a crear
   - check_ui_api_coherence.sh (detección cambios API sin tests UI)
   - validate_devcontainer_env.sh (validación entorno)
   - validate_constitution_schema.sh (validación .constitucion.yaml)

2. Modificaciones scripts existentes
   - install_hooks.sh: mensaje sobre constitución
   - git-hooks/pre-push: invocar constitucion.sh

3. Utilidades compartidas
   - scripts/utils/logging.sh (funciones logging compartidas)
   - scripts/utils/colors.sh (colores terminal)

**Tamaño estimado**: 400-500 líneas
**Audiencia**: Desarrollador implementando scripts

---

## LLD_05_INSTALACION.md

**Contenido**:
1. Procedimiento instalación completa
   - Paso 1: Copiar .constitucion.yaml
   - Paso 2: Copiar .ci-local.yaml
   - Paso 3: Crear scripts nuevos
   - Paso 4: Modificar scripts existentes
   - Paso 5: Instalar hooks
   - Paso 6: Validar instalación

2. Checklist pre-deployment
   - Dependencias (yq, jq, Python 3.9+)
   - Permisos scripts
   - Tests instalación

3. Rollback procedure
   - Como revertir cambios
   - Backups necesarios

**Tamaño estimado**: 200-300 líneas
**Audiencia**: DevOps/Tech Lead haciendo deployment

---

## Beneficios de Modularización

**Mantenibilidad**:
- Cambio en constitución NO afecta CI local
- Cambio en CI local NO afecta DevContainer
- Cada módulo es independiente

**Revisabilidad**:
- PRs más pequeños (review 1 módulo a la vez)
- Fácil entender cambios específicos

**Versionamiento**:
- Menos conflictos Git (desarrolladores trabajan en módulos diferentes)
- Historial más claro

**Navegabilidad**:
- Desarrollador busca "como implementar CI local" → lee LLD_02
- Desarrollador busca "como funciona constitución" → lee LLD_01

**Reusabilidad**:
- LLD_01 puede referenciarse independientemente
- Otros proyectos pueden adoptar solo LLD_02 (CI local)

---

## Como Usar estos Documentos

### Para Implementar Sistema Completo

**Orden recomendado**:
1. Leer LLD_00_OVERVIEW.md (este documento)
2. Implementar LLD_01_CONSTITUCION.md (sistema base)
3. Implementar LLD_04_SCRIPTS_HELPERS.md (dependencias)
4. Implementar LLD_02_CI_LOCAL.md (orquestación)
5. Implementar LLD_03_DEVCONTAINER.md (integración)
6. Seguir LLD_05_INSTALACION.md (deployment)

### Para Implementar Solo Constitución

**Orden**:
1. LLD_01_CONSTITUCION.md
2. LLD_04_SCRIPTS_HELPERS.md (solo scripts necesarios)
3. LLD_05_INSTALACION.md (sección constitución)

### Para Implementar Solo CI Local

**Orden**:
1. LLD_02_CI_LOCAL.md
2. LLD_04_SCRIPTS_HELPERS.md (solo orquestación)
3. LLD_05_INSTALACION.md (sección CI)

---

## Referencias Cruzadas

**Desde HLD**:
- HLD Sección 3.1 → LLD_01_CONSTITUCION.md
- HLD Sección 3.2 → LLD_02_CI_LOCAL.md
- HLD Sección 3.3 → LLD_03_DEVCONTAINER.md

**Hacia Testing Plan** (FASE 4):
- LLD_01 → TESTING tests constitución
- LLD_02 → TESTING tests CI local
- LLD_03 → TESTING tests DevContainer

**Hacia Deployment Plan** (FASE 5):
- Todos los LLDs → DEPLOYMENT implementación

---

## Estado Actual

**Completados**:
- [x] LLD_00_OVERVIEW.md (este documento - Master Index)
- [x] LLD_01_CONSTITUCION.md (Sistema Constitucion - 1600+ lineas)
- [x] LLD_02_CI_LOCAL.md (Pipeline CI/CD Local - 1100+ lineas)
- [x] LLD_03_DEVCONTAINER.md (Integracion DevContainer - 600+ lineas)
- [x] LLD_04_SCRIPTS_HELPERS.md (Scripts Auxiliares - 525+ lineas)
- [x] LLD_05_INSTALACION.md (Procedimientos Deployment - 400+ lineas)

**Total**: 5 modulos LLD completados (4200+ lineas documentacion tecnica)

**Estado FASE 3 (Design - LLD)**: COMPLETO 100%

---

## Próximos Pasos

1. ~~Completar todos los LLDs~~ COMPLETO
2. Commit y push LLDs a branch
3. **Continuar a FASE 4 (Testing Plan)**:
   - Testing Strategy (TDD RED)
   - Unit tests especificacion
   - Integration tests especificacion
   - End-to-end tests especificacion
4. FASE 5 (Deployment Plan - TDD GREEN)
5. FASE 6 (Maintenance Plan)

---

**Metodología**:
- Auto-CoT: Descomposición modular aplicada
- Self-Consistency: Cada módulo validado independientemente
- TDD: Testing plan seguirá esta estructura modular

**Status**: LLD OVERVIEW COMPLETO
**Fecha**: 2025-11-13
**Autor**: SDLC Agent / DevOps Team
