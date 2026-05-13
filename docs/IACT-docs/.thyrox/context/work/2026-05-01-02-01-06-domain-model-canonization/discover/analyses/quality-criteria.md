```yml
created_at: 2026-05-01 02:01:06
project: IACT-docs
work_package: 2026-05-01-02-01-06-domain-model-canonization
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Análisis 04 — Criterios de calidad declarados

Extrae criterios de calidad **ya declarados** en
el proyecto que aplican al artefacto del WP
actual (diagrama de clases canónico + glosario
ubicuo + matriz UC × clase) para refinar
``exit-conditions.md``.

## Fuentes consultadas

- ``temp-holding/FASE 01/CLEAN CODE NAMING PRINCIPLES.md``
  (100 líneas) — 13 principios de naming
  declarados, citando a Martin (*Clean Code*) y a
  Bob (*Clean Architecture*).
- ``temp-holding/FASE 01/NOM_001_Nomenclatura_Proyecto_IACT_2_0_0.rst``
  (810 líneas) — nomenclatura canónica del
  proyecto (separadores, capitalización, idioma,
  versionado, plantillas por tipo de artefacto).
- ``temp-holding/FASE 01/STD_001_Estandares_Documentacion_Sin_Emojis_2_0_0.rst``
  (≥414 líneas) — estándar de documentación sin
  emojis y elementos visuales prohibidos.

## Síntesis de principios aplicables al modelo de dominio

### Categoría 1 — Naming del modelo

De ``CLEAN CODE NAMING PRINCIPLES`` (13
principios). Aplicación directa al diagrama de
clases canónico:

| Principio | Aplicación al modelo de clases IACT |
|-----------|-------------------------------------|
| Nombres revelan intención | El nombre de la clase expresa qué representa, sin requerir comentario aparte. ``Sesion`` revela intención; ``UserData`` no. |
| Evitar desinformación | No bautizar como ``Lista*`` lo que no es lista, ni como ``*Manager`` algo que no gestiona. |
| Distinciones con sentido | ``ReporteHistorico`` vs ``Reporte`` solo si la diferencia es semántica real — no por relleno. |
| Nombres pronunciables | ``ConfiguracionUmbral`` antes que ``CnfgUmb``. |
| Nombres buscables | Términos suficientemente específicos para grep univocidad — evitar ``Grupo`` solo cuando podría ser ``GrupoPermisos``, ``GrupoFunciones``, ``GrupoUsuarios``. |
| Sin codificaciones | No prefijar tipos (``cFuncion``, ``mUsuario``). |
| Sin asignaciones mentales | El lector no debe traducir ``USR-010`` a "función ACC_07 Asignar Segmento" — eso pasó en el corpus actual y produjo H-T08. |
| Una palabra por concepto | Si el dominio dice ``Asignacion``, no aparece como ``Mapeo`` / ``Vinculo`` / ``Atribucion`` en otros UCs. |

Principios 9–13 (architecture reveals intent,
frameworks as plugins, dependencies inward, use
cases drive architecture, testability without
framework) son arquitectónicos — no aplican
directamente al diagrama de clases del dominio
pero sí al producto final de proyecto. No se
incluyen como exit conditions del WP actual.

### Categoría 2 — Nomenclatura formal

De ``NOM_001 v2.0.0``:

| Regla | Texto canónico |
|-------|----------------|
| Separadores | Guión bajo entre componentes (``UC_ACC_001``); guión medio en descriptivos multi-palabra (``Business-Rules``); espacios prohibidos. |
| Capitalización | Prefijos MAYÚSCULAS (``UC``, ``BR``); códigos módulo MAYÚSCULAS (``AUTH``, ``USR``); descriptivos PascalCase (``Iniciar_Sesion``); extensiones minúsculas (``.rst``). |
| Idioma | Identificadores en INGLÉS (``UC``, ``AUTH``); descriptivos en ESPAÑOL (``Iniciar_Sesion``); contenido en ESPAÑOL. |
| Dígitos | Artefactos por módulo: 2 dígitos (UC). Globales: 3 dígitos (BR, CNST, STD). |
| Versionado | SemVer 2.0.0 obligatorio en todos los artefactos: ``[MAJOR]_[MINOR]_[PATCH]``. |

Implicación para el WP actual: las **clases del
dominio** son artefactos conceptuales, no
artefactos versionables al estilo NOM_001. La
norma aplica al **archivo que contiene el
diagrama**, no a las clases en sí. Las clases
siguen las reglas de naming (Categoría 1) y
adoptan PascalCase como convención propia
(``EjecucionETL``, ``BuzonInterno``).

### Categoría 3 — Documentación sin emojis

De ``STD_001 v2.0.0`` (sin emojis, sin elementos
decorativos):

| Categoría prohibida | Alternativa permitida |
|---------------------|----------------------|
| Emojis (✅, ❌, 🔴, ✨, etc.) | Sistema de prefijos: ``[OK]``, ``[ERROR]``, ``[ALTO]``, ``[NUEVO]`` |
| Iconos Unicode decorativos | Texto descriptivo en su lugar |
| Box drawing characters (┌, ─, └) | ASCII estándar: ``+``, ``-``, ``|`` |
| Símbolos matemáticos decorativos | Sintaxis textual (``->`` en lugar de ``→`` cuando no es matemática real) |

Excepciones: ecuaciones matemáticas reales,
diagramas técnicos ASCII, ejemplos de código
externo, capturas de pantalla.

Implicación para el WP actual: el diagrama
PlantUML usa flechas y símbolos (``-->``,
``..>``, ``*--``) que son sintaxis matemática del
lenguaje, no decoración. Permitido. El
**texto narrativo** del artefacto sí cumple
STD_001 — sin emojis, sin box drawing.

## Mapeo a exit conditions del WP

### Exit conditions ya cubiertas en el draft

El ``exit-conditions.md`` actual ya cubre:

- Cobertura UC × clase 100% (covered).
- Lenguaje ubicuo (covered, conceptual).
- Diagrama descompuesto por bounded context
  (covered).
- Make html con 0 warnings, 0 errors (covered).

### Exit conditions a añadir tras este análisis

| Nuevo criterio | Origen | Verificación |
|---------------|--------|--------------|
| Cada nombre de clase pasa los 8 principios de naming (Categoría 1) | CLEAN CODE | Checklist por clase al promoverla |
| Convención de capitalización: clases en PascalCase, atributos en snake_case | NOM_001 + práctica del corpus | Linter / regex check |
| Idioma: nombres de clases y atributos en español (descriptivos del dominio); identificadores formales en inglés cuando corresponda | NOM_001 § 2.3 | Inspección visual |
| Texto narrativo del artefacto sin emojis ni elementos decorativos prohibidos | STD_001 | Grep contra catálogo prohibido |
| El glosario ubicuo asigna **una sola palabra por concepto** (principio 8) y la registra como vinculante | CLEAN CODE § 8 | Cross-check entre todos los UCs y el modelo |
| Versionado SemVer del artefacto del modelo en su frontmatter | NOM_001 § 3 | Lectura del YAML del documento |
| Sin codificaciones tipo ``cFuncion``, ``mUsuario``, ``__user`` | CLEAN CODE § 6 | Inspección visual |

### Reglas anti-patrón explícitas

Lista negativa derivada de E-01..E-05 del análisis
de riesgos históricos (análisis 03):

- **Prohibido**: nombres de clases que dependan
  de saber el ID numérico (``USR-010`` → "Asignar
  Segmento" → ``AsignarSegmento``). El nombre
  vale por sí solo (E-05).
- **Prohibido**: convivencia de
  ``manage_sessions`` y ``gestiona_sesiones``
  para el mismo concepto (E-01, E-02).
- **Prohibido**: convención SQL en atributos del
  dominio (``assigned_at`` cuando el concepto es
  ``fecha_asignacion``) (E-04).
- **Prohibido**: ID alfanumérico en el nombre de
  la clase (``UC_PERM_07_Class``) (E-05).

## Hallazgos del análisis

### H-T16 — El proyecto ya declaró su política de naming

CLEAN CODE NAMING PRINCIPLES no es propuesta
nueva de este WP — es política preexistente,
acumulada con el resto del corpus normativo. Por
lo tanto las exit conditions que la aplican son
**verificación de cumplimiento de política
declarada**, no propuesta de nueva política.

Status: **OBSERVABLE**. Implicación: el WP no
debe re-discutir los principios — debe asegurar
que el modelo de clases los cumple.

### H-T17 — Tres documentos de calidad sin un gate central

CLEAN CODE NAMING + NOM_001 + STD_001 cubren tres
ejes de calidad complementarios pero **no
existe un check formal único** que evalúe si un
artefacto pasa los tres. Cada uno se aplica
ad-hoc.

Status: **OBSERVABLE**. Recomendación al cierre
del WP: dejar en ``track/lessons-learned.md``
una propuesta de gate consolidado para artefactos
del dominio.

### H-T18 — STD_001 v2.0.0 prohíbe lo que el corpus actual usa parcialmente

El propio ``ANALISIS_ERRORES_MODELO_RBAC_v5_2_0.md``
(análisis 03) usa emojis prohibidos por STD_001
(🔴 CRÍTICA, ✅, ❌). Esto refuerza el patrón
H-T14 (revisión reactiva): la política existe
pero no se aplica preventivamente.

Status: **OBSERVABLE**. Implicación: el WP
actual debe **demostrar conformidad** desde la
primera versión del artefacto, no acumular para
corregir después.

## Refinamientos propuestos a ``exit-conditions.md``

| Sección actual | Acción propuesta |
|----------------|------------------|
| "Calidad del modelo de clases" | Añadir 4 sub-criterios derivados de CLEAN CODE (intention-revealing, no codificaciones, pronounceable, one word per concept). |
| "Lenguaje ubicuo" | Añadir verificación cruzada: cada concepto del glosario aparece con un solo nombre en TODOS los UCs (E-05 prevention). |
| "Calidad del diagrama" | Especificar que el texto narrativo cumple STD_001 (sin emojis prohibidos). |
| "Reglas de campos" | Documentar SemVer del artefacto en su frontmatter (NOM_001 § 3). |
| **Nueva sección** "Anti-patrones prohibidos" | Lista negativa derivada de E-01..E-05 del análisis 03. |

## Próximo paso

Sintetizar los cuatro análisis (inventario,
elicitation-history, historical-risks,
quality-criteria) en los tres artefactos
finales del Stage 1 DISCOVER:

1. ``discover/domain-elicitation.md`` — plan de
   elicitación adaptada con deviation explícita.
2. ``discover/risk-register.md`` (refinamiento
   del draft existente con riesgos R-09..R-14).
3. ``discover/exit-conditions.md`` (refinamiento
   del draft existente con criterios derivados
   de CLEAN CODE / NOM_001 / STD_001).

Tras los tres, el Stage 1 DISCOVER queda cerrado
y se puede pasar a Stage 3 ANALYZE
(``analyze/domain-class-candidates.md``).
