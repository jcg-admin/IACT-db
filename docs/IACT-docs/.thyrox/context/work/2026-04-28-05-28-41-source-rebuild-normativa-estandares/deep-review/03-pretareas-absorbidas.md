```yml
created_at: 2026-04-28 07:30:00
project: IACT-docs
work_package: 2026-04-28-05-28-41-source-rebuild-normativa-estandares
phase: Phase 11 — TRACK (artefacto deep-review)
agent_id: aec2d6b3ee3b4b67b
invocation_bound: 4 artefactos · 5 pre-tareas · ≤8 hallazgos · ≤400 palabras
author: deep-review agent (invocado por orquestador)
status: Aprobado
version: 1.0.0
```

# Deep-Review 03 — Cumplimiento de Pre-tareas Absorbidas

Output verbatim del agente `deep-review` invocado para verificar
que las 5 pre-tareas declaradas en wp-state.md se cumplieron.

## Tabla de cumplimiento

| Pre-tarea | Estado | Evidencia |
|---|---|---|
| 1. Sub-orden STDs → templates → resto | **Parcial** | ``index.rst`` agrupa 3 toctrees: STDs (L29-37), Guías técnicas (L39-45), Plantillas (L47-51). El orden declarado fue "STDs → templates → resto", pero el index implementa "STDs → guías → plantillas". Templates van al final, no en posición 2. |
| 2. Triage de templates con 5 inputs obligatorios | **Parcial** | ``discover/normativa-estandares-analysis.md`` §2.4 (L105-114) lista los 5 inputs y declara "estos análisis confirman que los templates v1.3.0 son la versión curada", pero no hay cita textual ni decisión específica trazada a cada uno de los 5 documentos. Los 10 ``PROPUESTA_TEMPLATE_*.txt`` se mencionan agregados, sin evidencia de lectura individual. |
| 3. Conservación de 7 variantes UC | **Completa** | Verificadas en filesystem 7 variantes: ``Actor_Secundario``, ``CRUD_Operaciones``, ``Construccion_7_Pasos``, ``Larman_Contratos``, ``Stakeholder_Driven``, ``Temporal_Schedulers``, ``UI_Driven``. Más ``TPL_UC_Casos_de_Uso`` (genérico). ``plantillas/index.rst`` L57-66 las agrupa explícitamente bajo "Casos de Uso (7 patrones)". |
| 4. STD_Naming_Identificadores | **Completa** | Cubre los 3 principios: clean code (§3.1), autoexplicativo (§3.2), sin abreviaturas dominio (§3.3 con ejemplo ``validateSoD → validateRoleConflict``). §4 cubre convenciones por lenguaje del stack real (Python/DRF, JS/TS/React, SQL Postgres+MySQL, Bash). |
| 5. STD_Profesional_Documentacion | **Completa** | §3.2 tabla L96-129 cubre las 6 frases prohibidas declaradas (+2 adicionales). Cubre headings (§4.1), tono (§3.1), inglés y español (§3.1, §5). Incluye trazabilidad al audit del WP #1. |

## Gaps específicos

### Pre-tarea 1 (sub-orden) — severidad: BAJA

El estándar absorbido decía "STDs → templates → resto". El
``index.rst`` real coloca "Guías técnicas" antes de "Plantillas",
invirtiendo "templates" y "resto". Ambigüedad: si "Guías
técnicas" cuenta como "resto", el orden está mal; si las guías
son parte del bloque STDs, faltó documentar esa decisión.
Funcionalmente legible.

### Pre-tarea 2 (triage con 5 inputs) — severidad: MEDIA

El analysis declara consulta agregada pero no traza
decisión-a-input. Por ejemplo, la conservación de las 7 variantes
UC se justifica por "Decision 6 strategy v2.0" del padre, no por
``ANALISIS_NOMENCLATURA_TPL`` o ``PLAN_GENERACION_TPL``. Los 10
``PROPUESTA_TEMPLATE_*.txt`` no aparecen referenciados en ninguna
decisión específica. **Riesgo:** decisiones de los inputs pueden
no haberse absorbido.

## Recomendación final del agente

**Cerrar con deuda** (consistente con el estado declarado
``CERRADO con warnings menores diferidos``):

- Output funcional cumple: 6 STDs + 3 guías + 28 templates con
  naming correcto, 7 UC preservadas, 2 STDs nuevos completos.
- Deuda a registrar:
  - **D-NE-2:** Aclarar/corregir orden en ``estandares/index.rst``
    (STDs → plantillas → guías) o documentar por qué guías van
    antes.
  - **D-NE-3:** Agregar a
    ``discover/normativa-estandares-analysis.md`` §2.4 una
    sub-sección "Decisiones absorbidas por input" mapeando
    explícitamente cada uno de los 5 inputs a las decisiones que
    lo citan.
- Los 10 warnings de build ya están aceptados como deuda diferida
  en wp-state.md (L14).
