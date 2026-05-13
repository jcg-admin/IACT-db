---
name: pm-closing
description: "Use when formally closing a PMBOK project or phase. pm:closing — obtain final acceptance, document lessons learned by knowledge area, archive project artifacts, release resources, close contracts."
allowed-tools: Read Glob Grep Bash Write Edit
effort: medium
disable-model-invocation: true
metadata:
  triggers: ["project closure", "project closeout", "lessons learned PMBOK", "PMBOK closing", "final acceptance"]
updated_at: 2026-04-17 00:00:00
---

# /pm-closing — PMBOK: Closing

> *"A project that ends without formal closure leaves loose ends: contracts still open, lessons not captured, and team members uncertain whether the work is truly done. Closing is the discipline of making endings official."*

Ejecuta el **Grupo de Proceso Closing** de PMBOK. Obtiene la aceptación formal del producto del proyecto, documenta lecciones aprendidas por Knowledge Area, archiva los artefactos del proyecto, libera los recursos del equipo, y cierra contratos con proveedores.

**THYROX Stage:** Stage 11 TRACK/EVALUATE / Stage 12 STANDARDIZE.

**Outputs clave:** Final Acceptance Document · Lessons Learned · Project Archives.

---

## Pre-condición

Requiere: `{wp}/pm-executing.md` o `{wp}/pm-monitoring.md` con:
- Todos los deliverables verificados contra el scope baseline
- Defectos críticos resueltos o formalmente aceptados
- Performance dentro de los umbrales aprobados de EVM

---

## Cuándo usar este paso

- Cuando todos los deliverables del proyecto han sido completados y verificados
- Al cerrar una fase de un proyecto multi-fase (phase gate closure)
- Cuando el proyecto es terminado prematuramente — incluso los proyectos cancelados requieren cierre formal

## Cuándo NO usar este paso

- Si hay deliverables pendientes — cerrar con trabajo incompleto invalida la aceptación
- Si hay contratos abiertos con proveedores — resolver antes del cierre formal
- Si el sponsor no está disponible para la aceptación — Closing sin aceptación formal es cierre administrativo, no cierre del proyecto

---

## Knowledge Areas activas en Closing

| Knowledge Area | Intensidad | Entregable clave |
|---------------|-----------|-----------------|
| Integration Management | **Alta** | Close Project/Phase, Final Acceptance |
| Procurement Management | **Alta** | Close Procurements (si hay contratos) |
| Stakeholder Management | Media | Comunicación de cierre a todos los stakeholders |
| HR Management | Media | Release del equipo, performance evaluations |
| Communications Management | Media | Final project report |
| Risk Management | Baja | Cierre del Risk Register, lecciones de riesgos |
| Scope / Schedule / Cost / Quality | Baja | Solo validación final vs baseline |

---

## Actividades

### 1. Obtener la aceptación formal del producto

La aceptación formal es el output más importante de Closing:

| Actividad | Descripción | Artefacto |
|-----------|-------------|-----------|
| **Verificar deliverables vs scope baseline** | Confirmar que todos los deliverables del WBS fueron completados | Scope verification checklist |
| **Presentación de cierre al sponsor** | Demostrar el producto terminado contra los objetivos del Charter | Presentación de cierre |
| **Product Acceptance Sign-off** | Firma formal del sponsor/cliente indicando que el producto cumple los requisitos | Final Acceptance Document |
| **Outstanding issues log** | Defectos o pendientes que se transfieren a operaciones o mantenimiento | Issues log de transferencia |

**Criterios de aceptación:**

| Tipo de criterio | Cómo verificar |
|-----------------|---------------|
| **Funcional** | Todos los requisitos Must Have del scope baseline implementados |
| **No funcional** | Performance, seguridad, disponibilidad dentro de los umbrales acordados |
| **Contractual** (si aplica) | Todos los deliverables contractuales entregados y aceptados |
| **Calidad** | Defectos críticos = 0 en producción |

### 2. Lecciones aprendidas por Knowledge Area

Las lecciones aprendidas son el activo más valioso del proyecto para proyectos futuros:

| Knowledge Area | Dimensiones a revisar |
|---------------|----------------------|
| **Integration** | ¿El Charter fue realista? ¿El Change Control funcionó? ¿Los procesos de integración fueron eficientes? |
| **Scope** | ¿El scope creció? ¿El WBS fue suficientemente detallado? ¿Hubo scope creep no gestionado? |
| **Schedule** | ¿Las estimaciones fueron realistas? ¿El Critical Path fue gestionado activamente? ¿Las dependencias fueron identificadas? |
| **Cost** | ¿El presupuesto fue suficiente? ¿Las varianzas de costo fueron anticipadas? ¿El EVM detectó problemas a tiempo? |
| **Quality** | ¿Los estándares de calidad fueron claros desde el inicio? ¿Las inspecciones detectaron defectos temprano? |
| **HR / Resource** | ¿El equipo tuvo las competencias necesarias? ¿La planificación de recursos fue correcta? |
| **Communications** | ¿Los stakeholders estuvieron bien informados? ¿El plan de comunicaciones fue seguido? |
| **Risk** | ¿Los riesgos identificados ocurrieron? ¿Hubo riesgos no identificados? ¿Los planes de respuesta funcionaron? |
| **Procurement** | ¿Los proveedores entregaron según contrato? ¿Los contratos fueron bien estructurados? |
| **Stakeholder** | ¿Los stakeholders estuvieron engaged durante el proyecto? ¿Hubo resistencia al cambio? |

**Formato recomendado por lección:**

| Campo | Descripción |
|-------|-------------|
| **Knowledge Area** | Área PMBOK afectada |
| **Situación** | Qué ocurrió (sin juicio, factual) |
| **Impacto** | Cómo afectó al proyecto (tiempo/costo/calidad/satisfacción) |
| **Acción recomendada** | Qué hacer diferente en el próximo proyecto |
| **Aplicabilidad** | Tipos de proyectos donde aplica esta lección |

### 3. Archivo de artefactos del proyecto

Los documentos del proyecto deben estar organizados y accesibles para proyectos futuros:

| Categoría | Artefactos a archivar |
|-----------|----------------------|
| **Iniciación** | Project Charter, Stakeholder Register inicial |
| **Planificación** | Project Management Plan y todos sus planes subsidiarios |
| **Scope** | WBS y WBS Dictionary, Scope Baseline |
| **Schedule** | Cronograma final vs baseline, Critical Path |
| **Cost** | Cost Baseline, EVM reports, cierre financiero |
| **Calidad** | Quality Management Plan, inspection reports, defect log |
| **Riesgos** | Risk Register final — riesgos que ocurrieron vs los que no |
| **Comunicaciones** | Actas de reuniones clave, reports de status, decisiones |
| **Ejecución** | Change log, issue log, performance reports |
| **Cierre** | Final Acceptance, Lessons Learned, este documento |

> **Regla de archivo:** Si una lección aprendida no está archivada y accesible, no existe para el próximo proyecto.

### 4. Release del equipo

El cierre formal incluye gestionar la transición del equipo:

| Actividad | Descripción |
|-----------|-------------|
| **Performance evaluations** | Evaluaciones de desempeño de los miembros del equipo |
| **Knowledge transfer** | Documentar conocimiento especializado antes de que el equipo se disperse |
| **Release formal** | Confirmar con los managers funcionales la liberación de los recursos |
| **Recognition** | Reconocimiento formal de las contribuciones del equipo |

### 5. Cierre de contratos (si aplica)

Para proyectos con proveedores externos:

| Paso | Descripción |
|------|-------------|
| **Verificar entregables contractuales** | Confirmar que todos los deliverables del contrato fueron recibidos y aceptados |
| **Procesar pagos finales** | Asegurar que todos los pagos pendientes han sido procesados |
| **Obtener cierre formal del proveedor** | Documento de cierre o release del contrato |
| **Documentar performance del proveedor** | Para decisiones de futuras contrataciones |

### 6. Final Project Report

Un reporte de cierre conciso para el registro de la organización:

| Sección | Contenido |
|---------|-----------|
| **Resumen ejecutivo** | Qué se logró, en qué tiempo, con qué costo |
| **Objectives achieved** | Cada objetivo del Charter: logrado / parcialmente logrado / no logrado |
| **Performance vs baseline** | Schedule variance final, Cost variance final, calidad |
| **Key decisions made** | Decisiones importantes que afectaron el proyecto |
| **Top lecciones aprendidas** | 3-5 lecciones más aplicables a proyectos futuros |
| **Recommendations** | Para el equipo de operaciones o para el próximo proyecto |

---

## Criterio de completitud — proyecto cerrado

**Cierre completo (todos los siguientes deben cumplirse):**
1. Final Acceptance Document firmado por el sponsor o cliente
2. Lecciones aprendidas documentadas por Knowledge Area
3. Artefactos del proyecto archivados en el repositorio organizacional
4. Equipo liberado formalmente
5. Contratos cerrados (si aplica)
6. Final Project Report entregado

**Cierre de fase (para proyectos multi-fase):**
- Final Acceptance de la fase (no del proyecto completo)
- Lecciones de la fase documentadas
- Artefactos de la fase archivados
- Autorización para iniciar la siguiente fase

---

## Artefacto esperado

`{wp}/pm-closing.md`

usar template: [closure-report-template.md](./assets/closure-report-template.md)

---

## Red Flags — señales de Closing mal ejecutado

- **Proyecto que "termina" sin Final Acceptance** — si el equipo simplemente deja de trabajar sin firma de cierre, el proyecto nunca fue oficialmente terminado — pueden aparecer requests de trabajo adicional como si el scope no estuviera cerrado
- **Lecciones aprendidas escritas en la última hora** — las lecciones que se documentan con prisa al final del proyecto son superficiales. Las mejores lecciones se capturan durante el proyecto en el issue log y se consolidan en Closing
- **Contratos no cerrados formalmente** — un contrato sin cierre puede generar disputas sobre deliverables adicionales o pagos meses después del final del proyecto
- **Equipo dispersado antes del cierre** — si los miembros clave del equipo son reasignados antes del cierre, el conocimiento del proyecto se pierde y el Final Acceptance no puede completarse correctamente
- **Archivo de artefactos en carpetas personales** — si los documentos del proyecto solo existen en la laptop del PM, son inaccesibles para proyectos futuros
- **Final Project Report omitido por presión** — el reporte final es el único artefacto que captura el story completo del proyecto; sin él, la organización no aprende de la experiencia

---

## Estado en now.md

**Al INICIAR este step:**
```yaml
methodology_step: pm:closing
flow: pm
pm_process_group: closing
```

**Al COMPLETAR** (proyecto cerrado):
```yaml
methodology_step: pm:closing  # completado — proyecto PMBOK cerrado
flow: pm
pm_process_group: closing
```

## Siguiente paso

- Proyecto cerrado → iniciar Stage siguiente THYROX (TRACK/EVALUATE o STANDARDIZE)
- Cierre de fase → iniciar nuevo Initiating para la siguiente fase (si el proyecto es multi-fase)

---

## Limitaciones

- La aceptación formal del producto no garantiza satisfacción del usuario a largo plazo — planificar una revisión post-implementación 30-60 días después del cierre
- Las lecciones aprendidas solo tienen valor si son accesibles y consultadas en proyectos futuros — el archivo debe estar en un repositorio organizacional, no en el repositorio personal del PM
- En proyectos cancelados, el cierre es igualmente importante: documentar por qué se canceló, qué se completó, qué se entregó, y las lecciones para no repetir el patrón

---

## Reference Files

### Assets
- [closure-report-template.md](./assets/closure-report-template.md) — Template completo: Final Acceptance, EVM final, lecciones aprendidas por área PMBOK, artefactos archivados, release del equipo, cierre de contratos

### References
- [project-closure-guide.md](./references/project-closure-guide.md) — Checklist de cierre paso a paso, lecciones aprendidas efectivas, cierre de fase vs cierre de proyecto, proyectos cancelados, post-implementation review
