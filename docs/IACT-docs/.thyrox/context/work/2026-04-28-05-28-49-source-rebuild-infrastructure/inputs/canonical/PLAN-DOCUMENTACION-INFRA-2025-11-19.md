---
id: QA-PLAN-DOCS-INFRA-001
tipo: plan_accion
categoria: documentacion_infraestructura
titulo: Plan para estructurar la documentacion de infraestructura
fecha: 2025-11-19
hora: 10:00:00
version: 1.0.0
basado_en: QA-ANALISIS-ESTRUCTURA-INFRA-001
estado: pendiente
horizonte_temporal: 1_semana
esfuerzo_total_horas: 6
restricciones: ["TDD con cobertura >=80%", "Commits convencionales", "Sin Redis", "Sin envio de correo"]
---

# QA-PLAN-DOCS-INFRA-001: Estructura documental de infraestructura

**ID:** QA-PLAN-DOCS-INFRA-001  
**Basado en:** QA-ANALISIS-ESTRUCTURA-INFRA-001  
**Alcance:** Carpeta `infrastructure/` (Vagrant, box, cpython, workspace) y su reflejo en `docs/infraestructura/`  
**Restricciones obligatorias:** TDD (Red→Green→Refactor) con cobertura mínima de 80 %, commits convencionales, sin Redis, sin envío de correo (backend `api/callcentersite`, frontend `ui`).

---

## SECCION 1: OBJETIVO Y METRICAS DE EXITO

**Objetivo principal:** Crear y validar una estructura documental completa para la carpeta `infrastructure/`, alineada con el modelo de QA de Gobernanza y respetando las restricciones de la plataforma.

**Metricas de exito:**
- Inventario de componentes `infrastructure/` documentado y vinculado a `docs/infraestructura/` (box, cpython, vagrant, workspace) sin huecos de navegación.
- Plantillas README/INDEX generadas o actualizadas para cada subcomponente con propietarios y pruebas requeridas.
- Registro de restricciones “Sin Redis” y “Sin correo” reflejado en guías de despliegue y validaciones automáticas.
- Checklist de QA y plan de pruebas documentado con casos TDD y cobertura ≥80 % para scripts críticos.

---

## SECCION 2: FASES Y TAREAS

### FASE 1: Descubrimiento e inventario (0.75 h)

#### Tarea 1.1: Levantar inventario de infraestructura
**Prioridad:** P1  
**Responsable:** @arquitecto-senior  
**Acciones:**
- Mapear subdirectorios `infrastructure/{box,cpython,vagrant,workspace}` y sus scripts (`bootstrap.sh`, `setup.sh`, `Vagrantfile`, `.env.example`).
- Identificar dependencias externas y restricciones explícitas (sin Redis, sin correo) en scripts y configuraciones.
- Documentar hallazgos en una tabla preliminar dentro de `docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/`.

#### Tarea 1.2: Revisar restricciones en backend y frontend
**Prioridad:** P1  
**Responsable:** @backend-lead + @frontend-lead  
**Acciones:**
- Validar que `api/callcentersite` no declare Redis ni flujos de correo; registrar ubicaciones de configuraciones relevantes para referencia documental.
- Verificar que `ui` no invoque endpoints o SDKs de correo; señalar mocks o flags existentes.
- Incorporar resultados en el resumen ejecutivo del plan (sección riesgos/controles).

### FASE 2: Diseño de estructura documental (2 h)

#### Tarea 2.1: Definir árbol y navegación
**Prioridad:** P1  
**Responsable:** @tech-writer  
**Acciones:**
- Especificar estructura espejo en `docs/infraestructura/` para cada módulo: `box/`, `cpython/`, `vagrant/`, `workspace/` con `README.md` e `INDEX.md`.
- Establecer sección de "Página padre" y "Páginas hijas" siguiendo el patrón de `docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/PLAN-CONSOLIDACION-RAMAS-2025-11-17.md`.
- Definir convenciones de frontmatter (id, tipo, fecha, version, responsable) y bloque de "Validaciones obligatorias" (TDD, cobertura ≥80 %, sin Redis/correo).

#### Tarea 2.2: Diseñar plantillas por componente
**Prioridad:** P1  
**Responsable:** @devops-lead  
**Acciones:**
- Para cada subcarpeta de `infrastructure/`, bosquejar contenido mínimo: propósito, prerequisitos, comandos básicos, pruebas asociadas, riesgos y rollback.
- Incluir checklists de verificación (p. ej., conectividad DB en `box/`, provisioning en `vagrant/`, setup de herramientas en `workspace/`).
- Incorporar enlaces a ADRs cuando se documenten decisiones de plataforma o provider.

### FASE 3: Ejecución y plantillas (2.5 h)

#### Tarea 3.1: Crear/actualizar documentación base
**Prioridad:** P1  
**Responsable:** @tech-writer  
**Acciones:**
- Generar `README.md` e `INDEX.md` para cada módulo con navegación consistente y enlaces relativos validados.
- Integrar sección de "Restricciones operativas" destacando sin Redis y sin correo, más TDD/coverage.
- Añadir ejemplos de comandos (arranque de Vagrant, bootstrap de cpython, setup de workspace) y ubicar artefactos de configuración (`.env.example`).

#### Tarea 3.2: QA y validaciones automáticas
**Prioridad:** P1  
**Responsable:** @qa-lead  
**Acciones:**
- Definir suite mínima de pruebas automatizadas para scripts de infraestructura (lint/shellcheck, pruebas de idempotencia donde aplique) y documentar comandos.
- Alinear con pipeline existente (`scripts/run_all_tests.sh`) asegurando cobertura ≥80 % para nuevas pruebas.
- Documentar criterios de aceptación y pasos de rollback por componente.

### FASE 4: Gobernanza y seguimiento (0.75 h)

#### Tarea 4.1: Registrar tareas y responsables
**Prioridad:** P1  
**Responsable:** @arquitecto-senior  
**Acciones:**
- Añadir este plan a `tareas_activas.md` con prioridad, SP y fecha objetivo.
- Asignar responsables y actualizar estados semanalmente.

#### Tarea 4.2: Cierre y difusión
**Prioridad:** P2  
**Responsable:** @tech-writer  
**Acciones:**
- Publicar checklist de cierre y resultado de validaciones (build de docs, lint, pruebas) en `qa/`.
- Notificar en canal interno la disponibilidad de la nueva estructura documental.

---

## SECCION 3: RIESGOS, SUPUESTOS Y DEPENDENCIAS

- **Riesgo:** Scripts heredados no tienen pruebas; mitigar con TDD y cobertura ≥80 % antes de integrarlos en la doc final.
- **Riesgo:** Dependencias externas no documentadas (providers, plugins Vagrant); mitigación: inventario exhaustivo en Fase 1.
- **Supuesto:** No se habilitarán servicios Redis ni correo; cualquier excepción requiere ADR aprobado y actualización inmediata de la documentación.
- **Dependencias:** Acceso a `api/callcentersite` y `ui` para verificar restricciones y rutas de configuración.

---

## SECCION 4: CRONOGRAMA PROPUESTO

| Fase | Duracion | Ventana | Responsable principal |
|------|----------|---------|-----------------------|
| Fase 1: Descubrimiento | 0.75 h | Dia 1 (mañana) | @arquitecto-senior |
| Fase 2: Diseño | 2 h | Dia 1 (tarde) | @tech-writer |
| Fase 3: Ejecución | 2.5 h | Dia 2 | @tech-writer + @qa-lead |
| Fase 4: Gobernanza | 0.75 h | Dia 3 (mañana) | @arquitecto-senior |

---

## SECCION 5: CHECKLIST DE CONTROL

- [ ] Inventario completado y registrado en `qa/QA-ANALISIS-ESTRUCTURA-INFRA-001`.
- [ ] README/INDEX creados por subcomponente con frontmatter y navegación.
- [ ] Restricciones sin Redis/sin correo documentadas en secciones de "Validaciones obligatorias".
- [ ] Suites de pruebas definidas y coverage esperado ≥80 %.
- [ ] Plan agregado a `tareas_activas.md` con prioridad y SP.
- [ ] Validación de links y build de documentación ejecutada.

