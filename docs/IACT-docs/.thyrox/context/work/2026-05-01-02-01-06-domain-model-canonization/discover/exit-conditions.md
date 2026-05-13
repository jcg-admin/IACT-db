```yml
created_at: 2026-05-01 02:01:06
project: IACT-docs
work_package: 2026-05-01-02-01-06-domain-model-canonization
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
version: 2.0.0
```

# Exit Conditions — Canonización del modelo de dominio

> Versión 2.0.0 — refinada tras los seis análisis
> de Stage 1 DISCOVER. Las condiciones se reordenan
> en torno a la **verificación de política
> declarada** (CLEAN CODE + NOM_001 + STD_001 +
> programa Z) en lugar de proposición de política
> nueva. Sólo el ejecutor ordena cierre (I-011).

## 1. Entregables publicados

- [ ] ``discover/domain-elicitation.md`` — plan
  de elicitación adaptada con deviation explícita
  documentada (referencia ``rm-elicitation``
  SKILL.md).
- [ ] ``discover/risk-register.md`` v2.0.0 — 10
  riesgos vigentes (R-01..R-08, R-12, R-15).
- [ ] ``discover/exit-conditions.md`` v2.0.0 —
  este archivo.
- [ ] ``discover/analyses/`` — los seis análisis
  registrados (01..06) commiteados.
- [ ] ``analyze/domain-class-candidates.md`` —
  sustantivos del corpus filtrados por Abbott +
  IEEE 830 quality check + 11 decisiones de Z.2
  importadas como precedente.
- [ ] ``design/iact-domain-model.md`` — diagrama
  PlantUML canónico descompuesto por bounded
  context.
- [ ] ``pilot/uc-vs-domain-validation.md`` —
  matriz UC × clase con las 5 categorías de
  Z.2.A integradas.
- [ ] ``track/lessons-learned.md`` al cierre,
  incluyendo R-10 como lección aprendida ya
  consumada (renombrado masivo std007).

## 2. Calidad del modelo de clases

### Estructura mínima por clase

- [ ] Cada clase tiene: nombre canónico
  PascalCase, ≥1 atributo, ≥1 operación, ≥1
  asociación con otra clase o nota explícita
  "isla intencional".
- [ ] Cada clase está agrupada en un bounded
  context: Auth, RBAC, Reportes/Métricas,
  Pipeline ETL, Alertas, Auditoría, Logs (7
  contextos derivados de los 9 clusters de UC; el
  cluster PERM se subsume bajo RBAC como vista
  técnica per Z.2.A § Cat 5).
- [ ] Asociaciones con cardinalidad explícita
  (``1``, ``0..1``, ``*``, ``1..*``).
- [ ] Restricciones canónicas y reglas de negocio
  citadas como notas en las clases / asociaciones
  que las llevan, **en versiones vigentes**:
  BR-009 v2.0.0 (alcance global, no eliminar),
  BR-011 v2.0.0, CNST-019 v3.0.0 (export async
  abstracto), CNST-020 v3.0.0 (throttling
  abstracto). Concepto Segmento **no debe
  aparecer** (Z.1.C eliminó).

### Verificación contra principios CLEAN CODE

- [ ] Cada nombre de clase pasa el principio
  *intention-revealing* (revelar el qué sin
  necesidad de comentario).
- [ ] Sin codificaciones tipo ``cFuncion``,
  ``mUsuario`` (principio 6 sin codificaciones).
- [ ] Una palabra por concepto a través de TODOS
  los UCs (principio 8) — no convivencia
  simultánea de ``Asignacion`` y ``Mapeo`` para
  el mismo concepto.
- [ ] Distinciones con sentido (principio 3) —
  no añadir ``*Info``, ``*Data`` salvo que
  aporten semántica.

### Verificación contra NOM_001

- [ ] Clases del dominio en PascalCase con
  vocabulario español descriptivo
  (``EjecucionETL``, ``BuzonInterno``).
- [ ] Atributos en español descriptivo
  (``fecha_asignacion``, no ``assigned_at``) —
  R-12: separar dominio de implementación SQL.
- [ ] Frontmatter del artefacto con SemVer 2.0.0
  obligatorio.

### Verificación contra STD_001

- [ ] Texto narrativo del artefacto sin emojis
  ni iconos Unicode decorativos prohibidos.
- [ ] Sin box drawing characters; ASCII estándar.
- [ ] Sin símbolos matemáticos decorativos cuando
  no son matemática real (PlantUML usa flechas y
  signos, eso es sintaxis y está permitido).

## 3. Reconciliación de cifras

- [ ] Causa raíz de la discrepancia documentada
  en ``analyze/domain-class-candidates.md`` § 1.
  La conclusión esperada (per Análisis 06): el
  conteo correcto es **61 UCs**, derivable de
  PLAN MAESTRO v4.0 (49) + cluster PERM
  posterior (+10) + cambios programa Z (+6 −2
  consolidados Larman, ajustes residuales).
- [ ] ``analisis-dominio.rst § 11`` corregido a
  "61 UCs" (R-03), o registrado como TD para WP
  posterior si se decide no tocar el cajón
  pedagógico aquí.
- [ ] Conteo final del modelo de clases (no de
  UCs) declarado explícito al cierre del Stage 7
  DESIGN.

## 4. Cobertura UC × clase (matriz)

- [ ] **100 %** de los 61 UCs apuntan a ≥1 clase
  del modelo. Las 5 categorías de Z.2.A se
  reflejan en columnas de la matriz:
  - Cat 1 (~36 UCs OK) → mapping directo.
  - Cat 2 (5 UCs mismatch nominal) → la matriz
    cita la clase canónica + nota del mismatch.
  - Cat 3 (3 UCs históricos restaurados v5.4.0)
    → la matriz cita las funciones restauradas.
  - Cat 4 (4–5 UCs variantes filtradas) → comparten
    clase con su UC base + nota de filtro.
  - Cat 5 (10 UCs PERM vista técnica) → mapping
    a las clases del bounded context RBAC.
- [ ] **100 %** de las clases aparecen como
  sujeto / objeto en ≥1 UC. Si hay clase
  huérfana, se justifica o se elimina.
- [ ] La matriz vive en
  ``pilot/uc-vs-domain-validation.md`` con
  formato tabular reproducible.

## 5. Lenguaje ubicuo (glosario)

- [ ] Glosario publicado con ≥20 términos,
  cubriendo: entidades del dominio, funciones
  RBAC vigentes (61 funciones v5.4.0), módulos
  de implementación (Python apps), constraints
  vigentes, agrupadores (AGR-*).
- [ ] Cada término distingue tres niveles cuando
  aplique:
  - **Concepto del dominio** (clase ``Sesion``).
  - **Función RBAC** (``view_own_sessions``
    AUTH-001 v5.4.0).
  - **Módulo de implementación** (``auth_app``).
- [ ] Cada concepto tiene **un solo nombre** a
  través del corpus (CLEAN CODE principio 8).
  Verificación cruzada por grep contra los 61
  UCs.

## 6. Calidad del diagrama

- [ ] PlantUML descompuesto por bounded context
  (≤7 sub-diagramas) + un overview que sólo
  muestra puentes inter-contexto (R-06).
- [ ] ``make html`` con **0 warnings, 0 errors**
  (gate I-015).
- [ ] Sintaxis PlantUML valida con render local
  antes de promover.
- [ ] Diagrama renderiza limpio en build de
  Sphinx con ``SPHINX_NITPICKY=1``.

## 7. Anti-patrones prohibidos (lista negativa)

Derivados de los errores históricos catalogados
en Análisis 03 (E-01..E-05):

- [ ] **Prohibido**: nombres de clases que
  dependan de saber un ID alfanumérico
  (``UC_PERM_07_Class``).
- [ ] **Prohibido**: convivencia simultánea de
  dos nombres distintos para el mismo concepto
  (E-01, E-02).
- [ ] **Prohibido**: convención SQL en atributos
  del dominio (``assigned_at``, ``created_at``)
  (E-04, R-12).
- [ ] **Prohibido**: aparición del concepto
  ``Segmento`` o ``SegmentoDatos`` (Z.1.C lo
  eliminó por Camino C).
- [ ] **Prohibido**: usar versiones obsoletas de
  constraints (``CNST-019 v2.x``,
  ``BR-009 v1.x``). Siempre versiones vigentes
  v5.4.0-era.

## 8. Gates THYROX

- [ ] **I-011** — cierre solo por orden
  explícita del ejecutor.
- [ ] **I-012** — ningún hallazgo SPECULATIVE
  en conclusiones del modelo.
- [ ] **I-013** — claims heredados del WP previo
  (``uc-inventory.md``,
  ``uc-relationships-analysis.md`` hipotético)
  re-verificados contra el modelo antes de
  propagarse.
- [ ] **I-015** — ``validate-phase-completion.sh``
  exit 0 antes de cerrar (working tree clean,
  remote sync, build success, recent commits).

## 9. Importación obligatoria de outputs previos
(R-15)

- [ ] Al iniciar Stage 3 ANALYZE, el WP cita
  como fuentes los siguientes documentos
  cerrados:
  - ``2026-04-30-00-44-07-rbac-missing-ucs-discovery/discover/deep-review-missing-ucs.md``
    (genealogía + 5 categorías).
  - ``2026-04-30-00-37-45-rbac-modelo-conceptual-cleanup/track/wp-modelo-conceptual-cleanup-changelog.md``
    (10 funciones nuevas, 6 renames, 4
    constraints).
  - ``2026-04-30-00-37-45-rbac-modelo-conceptual-cleanup/analyze/srp-audit/decisions-log.md``
    (D-01..D-11).
  - ``2026-04-30-00-07-08-rbac-functions-count-audit/track/z1c-changelog.md``
    (segmento descartado, distribución
    confirmada).
- [ ] Las decisiones D-01..D-11 de Z.2 se citan
  explícitamente cuando justifican una elección
  de naming / responsabilidad en el modelo de
  clases.

## 10. Confirmación con ejecutor

- [ ] El ejecutor confirma por commit explícito
  los cinco puntos del § 8 de
  ``domain-elicitation.md`` antes de cerrar
  Stage 1.
- [ ] El ejecutor revisa el PlantUML
  renderizado, la matriz UC × clase y el
  glosario antes de promover el modelo a
  ``source/`` (Stage 12 STANDARDIZE).

## 11. Dependencias hacia el WP previo

- [ ] El WP
  ``2026-04-30-22-45-55-rm-uc-relationships-analysis``
  permanece **abierto** durante este trabajo.
- [ ] Al cerrar este WP, se anota en el WP
  previo (en su ``track/``) que ahora puede
  retomarse el análisis de relaciones de UC
  sobre base validada por el modelo de clases.

## 12. Resumen de gates obligatorios al cierre

| Gate | Verificación | Bloqueante |
|------|--------------|:----------:|
| Build 0/0/0 | ``make html`` exit 0 sin warnings | Sí |
| Cobertura UC × clase 100 % | Matriz | Sí |
| Lenguaje ubicuo | Glosario + grep cruzado | Sí |
| CLEAN CODE compliance | Checklist por clase | Sí |
| NOM_001 compliance | PascalCase + SemVer | Sí |
| STD_001 compliance | Sin emojis prohibidos | Sí |
| Cifra 97 → 61 reconciliada | Documento o TD | Sí |
| Concepto Segmento ausente | Grep modelo | Sí |
| Constraints en versiones vigentes | Inspección | Sí |
| Confirmación ejecutor | Commit explícito | Sí |
| Sin claims SPECULATIVE | Inspección | Sí |
