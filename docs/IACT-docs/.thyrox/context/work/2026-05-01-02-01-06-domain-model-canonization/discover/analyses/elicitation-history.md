```yml
created_at: 2026-05-01 02:01:06
project: IACT-docs
work_package: 2026-05-01-02-01-06-domain-model-canonization
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Análisis 02 — Historia de elicitación del corpus

Reconstruye **cómo se produjeron en realidad** los
artefactos que hoy viven en
``source/requisitos/`` (BR, UC, FR, CNST). El
objetivo es informar el plan de elicitación
adaptada del WP actual con datos verificables, no
con suposiciones sobre el origen de los UCs.

## Fuentes consultadas

Material de ``temp-holding/`` leído para este
análisis:

- ``FASE 01/Ingeniería de Requerimientos/PARTE 0 -
  CONTEXTO Y FUNDAMENTOS - 661ca8.md`` — § 2 modelo
  conceptual y § 4 alcance.
- ``FASE 01/Casos de Uso/PLAN MAESTRO -
  Regeneración de Casos de Uso v4.0.md`` —
  metodología paso a paso, plantilla de UC, catálogo
  de 49 UCs.

Otras fuentes en el inventario (``temp-holding-inventory.md``)
no se leyeron exhaustivamente; se citan donde
amplían un punto.

## Modelo conceptual de elicitación declarado

El proyecto declara una jerarquía de cuatro
niveles de abstracción para los requisitos
(``PARTE 0 § 2.1``):

| Nivel | Categoría | Pregunta clave |
|-------|-----------|----------------|
| 0 | Business Rules (BR) | ¿Qué obliga la organización / la regulación? |
| 1 | Business Requirements (BReq) | ¿Por qué existe el proyecto? |
| 2 | User Requirements (UR / Casos de Uso) | ¿Qué hace el usuario? |
| 3 | Functional Requirements (FR) | ¿Cómo lo hace el sistema? |

El flujo declarado es:
``BR ⇒ BReq ⇒ UR (UCs) ⇒ FR``. Cada nivel se
**transforma** en el siguiente — la elicitación
es por derivación, no por entrevista directa.

Las BR son entradas externas (legales,
regulatorias, organizacionales) que el sistema
debe cumplir. Los BReq se enuncian al inicio del
proyecto. Los UCs se generan por
**transformación** de los BR-tipo-Desencadenador
(``PARTE 0 § 3.2``). Los FR se derivan
descomponiendo cada UC en pasos.

## Método real aplicado a los UCs

``PLAN MAESTRO - Regeneración de Casos de Uso
v4.0`` documenta el procedimiento ejecutado para
producir los UCs:

- Fase 0: crear estructura de directorios,
  plantilla canónica de UC, glosario de actores.
- Fase 1–8: por cada módulo (``MOD_Auth``,
  ``MOD_Users``, ``MOD_Access``, ``MOD_Pipeline``,
  ``MOD_Reports``, ``MOD_Alerts``, ``MOD_Audit``,
  ``MOD_Logs``) crear cada UC con la plantilla
  estándar de **14 secciones** (resumen,
  descripción, diagrama UC, contexto, flujo
  normal, diagrama secuencia, flujos alternos,
  excepciones, diagrama actividad, BR aplicables,
  CNST de arquitectura, FR derivados,
  trazabilidad, historial).

El método **no contempla elicitación con
stakeholders externos** en sus 6 pasos. La fuente
de cada UC es:

- el catálogo predefinido del Plan Maestro (49
  UCs ya nombrados),
- las BRs ya documentadas en
  ``BR_ Busines Requirements/``,
- las CNST ya documentadas en
  ``CNST RESTRICCIONES/``.

Es decir: los UCs se redactaron *contra un
catálogo cerrado* + *normativa preexistente*, no
elicitando nuevas necesidades.

## Comparación de cardinalidades — tres conteos
distintos

Datos verificables:

| Fuente | Cluster IDs | UCs declarados |
|--------|-------------|----------------|
| ``temp-holding/.../PLAN MAESTRO Regeneración v4.0`` § 5 | AUTH 5 + USR 4 + ACC 9 + PIP 4 + RPT 14 + ALR 5 + AUD 4 + LOG 4 | **49** |
| ``source/requisitos/casos-uso/`` (verificado por ``find``) | AUTH 5 + USR 4 + ACC 7 + PERM 10 + PIP 4 + RPT 15 + ALR 5 + AUD 4 + LOG 7 | **61** |
| ``source/requisitos/_metodologia-aplicacion/analisis-dominio.rst § 11`` | "los 97 UCs" | **97** |

**Diferencias entre PLAN v4.0 y source/:**

- **AUTH, USR, PIP, ALR, AUD**: idénticos en
  cluster size.
- **ACC**: PLAN v4.0 = 9 UCs (01–09); source/ = 7
  UCs (01–05, 08, 09). **Faltan 06 y 07** en
  source.
- **PERM**: no existe en PLAN v4.0; source/ tiene
  10 UCs PERM (01–10). **Cluster nuevo añadido
  después de v4.0.**
- **RPT**: PLAN v4.0 = 14 UCs (01–14, todos
  consecutivos); source/ = 15 UCs (01–04, 07–17,
  con gaps en 05 y 06). **Renumerado y expandido.**
- **LOG**: PLAN v4.0 = 4 UCs; source/ = 7 UCs.
  **Cluster expandido.**

## Hallazgos del análisis

### H-T08 — UC_ACC_07 referenciado en USR_01 sí existió

UC_USR_01 referencia ``UC_ACC_07`` (H-07 del WP
previo). El PLAN MAESTRO v4.0 sí lista
**UC_ACC_07: "Asignar Segmento"** con función
RBAC ``USR-010`` y actor ``AGR-007``. La
referencia en ``UC_USR_01`` es **consistente con
la versión v4.0** — el problema es que ACC_07 no
sobrevivió a la migración a source/.

Status: **OBSERVABLE**. La inconsistencia H-07
es residuo de la migración v4.0 → source/, no
referencia inventada. Decisión pendiente: o
re-crear ACC_07 en source/ (porque su función
RBAC ``USR-010`` puede ser necesaria) o limpiar
la referencia en UC_USR_01.

### H-T09 — PLAN v4.0 no menciona stakeholders externos

Los 6 pasos por UC del Plan Maestro
(``§ 3 Metodología paso a paso``) no incluyen ni
*entrevista con stakeholder*, ni *workshop JAD*,
ni *member checking*, ni *prototipo de
confirmación*. La actividad central de la
metodología ``rm-elicitation`` está ausente del
método declarado.

Status: **OBSERVABLE**. El skill ``rm-elicitation``
exige confirmación con stakeholders como gate;
el método real del proyecto no tiene ese gate.
Esto **valida** la deviation que el WP actual
debe documentar: el corpus es producto de
transformación + redacción, no de elicitación.

### H-T10 — Cluster PERM añadido fuera del Plan Maestro v4.0

El cluster PERM (10 UCs) no aparece en el catálogo
del Plan Maestro v4.0. Su agregado posterior
explica varios hallazgos del WP previo:

- H-03: PERM no expone Actor Principal en meta —
  porque su plantilla es distinta (post-v4.0).
- H-08: ACC ↔ PERM coexistencia con 9 pares de
  UCs equivalentes — porque PERM es vista
  alternativa que se añadió sobre ACC ya
  redactado, no se diseñó conjuntamente.

Status: **OBSERVABLE**. El cluster PERM
representa una decisión arquitectónica
posterior (ADR-GOB-008 declarado en cabecera de
UC_PERM_07) que duplicó intencionalmente el
modelo. Es **deuda intencional**, no error.

### H-T11 — Renumeración RPT no documentada

PLAN v4.0 RPT 01–14 todos consecutivos, todos
existen. Source/ RPT 01–04, 07–17 con gaps en 05,
06. Hipótesis razonable: 14 UCs originales se
re-mapearon a IDs nuevos cuando se ampliaron a
17. Pero no hay registro de la renumeración.

Status: **OBSERVABLE**. Indica una segunda ola
de regeneración después de v4.0 que no
respetó el principio de IDs estables.

### H-T12 — Cifra "97 UCs" en analisis-dominio.rst no coincide con ninguna versión documentada

PLAN v4.0 = 49. source/ = 61. analisis-dominio
= 97.

Si hubiera una versión intermedia con ≈97 UCs
debería figurar en ``MODELO DOCUMENTAL IACT/`` o
``GENERACION_DOCUMENTACION/`` con esa cardinalidad.
No se ha encontrado evidencia.

Status: **OBSERVABLE**. La cifra 97 es probable
**estimación inflada** del cajón pedagógico, no
conteo real. Acción: verificar en
``analisis-dominio.rst § 11`` si la cifra es
hipotética y, si lo es, actualizarla a 61 o
marcarla como "objetivo proyectado".

## Implicaciones para el plan de elicitación
adaptada

### Sustancia de la deviation

El skill ``rm-elicitation`` (SKILL.md §
"Actividades") exige:

1. Identificar stakeholders por rol/área.
2. Sesiones presenciales o remotas con técnicas
   de la tabla de 7 técnicas.
3. Confirmar resultados con stakeholders.

El proyecto IACT en su realidad operativa:

1. Stakeholders no están disponibles para sesiones
   de elicitación (proyecto académico /
   reconstrucción).
2. La fuente de verdad efectiva es el corpus
   acumulado en ``source/`` + ``temp-holding/`` +
   código en ``Modules/``.
3. La confirmación posible es con el ejecutor
   (NestorMonroy) como proxy de stakeholder.

La elicitación adaptada del WP actual debe
combinar:

| Técnica adaptada | Fuente | Equivalente al skill |
|------------------|--------|----------------------|
| Análisis de documentos | ``source/`` + ``temp-holding/`` | "Análisis de documentos" (1 de las 7 técnicas) |
| Cruce de catálogos | BR (20) ↔ UC (61) ↔ FR | Validación cruzada |
| Análisis de código | ``Modules/*.py`` | Verificación de comportamiento real |
| Confirmación con ejecutor | Sesión escrita con NestorMonroy | Member checking adaptado |

Tres de las cuatro técnicas son legítimas según
el skill (análisis de documentos, validación
cruzada, confirmación). La adaptación está en
**sustituir el stakeholder externo por el
ejecutor del proyecto** + **sustituir el código
implementado por evidencia de comportamiento**.

### Red flags que persisten

Persisten dos red flags del skill que la
adaptación **no elimina** y deben documentarse
como riesgos:

- *"Solo una fuente de información"* — mitigado
  parcialmente con cruce de catálogos pero el
  ejecutor sigue siendo el único humano consultado.
  → Riesgo R-01 del WP, mantener.
- *"Stakeholders de alto impacto no incluidos"* —
  no hay product owner ni usuarios reales del
  call center que validen que el modelo refleja
  el negocio. → Riesgo R-01 del WP, mantener.

### Lo que la deviation sí permite asegurar

- **Coherencia interna del corpus**: que los UCs
  operen sobre clases del modelo y viceversa.
- **Trazabilidad documental**: BR ⇒ UC ⇒ FR
  declarada en cada UC.
- **Cumplimiento normativo**: CNST_* aplicadas
  uniformemente.
- **Reconciliación del catálogo**: las cifras
  divergentes (49 / 61 / 97) se resuelven con
  fuentes verificables.

### Lo que la deviation NO permite asegurar

- **Encaje con realidad operativa del call
  center**: si el modelo de dominio refleja el
  negocio real, sólo lo confirmaría un product
  owner o un usuario.
- **Completitud frente a stakeholders ausentes**:
  necesidades latentes que sólo emergen en
  conversación con usuarios no se descubrirán.

## Próximos pasos

- **Análisis 03** — leer
  ``RBAC/ANALISIS_ERRORES_MODELO_RBAC_v5_2_0.md``
  + análisis profundo en GENERACION_DOCUMENTACION
  para refinar ``risk-register.md``.
- **Análisis 04** — leer
  ``CLEAN CODE NAMING PRINCIPLES.md``,
  ``STD_001 v2.0.0``, ``NOM_001 v2.0.0`` y la
  estructura del modelo documental v2.2.0 para
  refinar ``exit-conditions.md``.
- Sintetizar ``domain-elicitation.md`` con el
  plan adaptado documentado y firmado.
