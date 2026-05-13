```yml
created_at: 2026-05-01 02:01:06
project: IACT-docs
work_package: 2026-05-01-02-01-06-domain-model-canonization
phase: Phase 1 — DISCOVER (analysis registered late)
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Análisis 07 — Convenciones del proyecto y sincronización con cajón pedagógico

Análisis registrado en respuesta al feedback del
ejecutor durante Stage 12 STANDARDIZE (2026-05-01):
verificar que la promoción a ``source/`` respete
las convenciones declaradas del proyecto y
detectar desfases con artefactos preexistentes
que se autodeclaran canónicos.

## Fuentes consultadas

- ``source/requisitos/_metodologia-aplicacion/analisis-dominio.rst``
  §§ 7, 11, 14, 15.
- ``source/requisitos/_metodologia-aplicacion/diagramas-uml.rst``
  § 1 (ejemplo de class diagram).
- ``source/base-cognitiva/_uml/cuando-usar-cada-diagrama.rst``
  (política PlantUML).
- Listado completo de
  ``source/base-cognitiva/_uml/uml-01..13`` (serie
  pedagógica).

## 1. Convenciones encontradas

### 1.1 Política técnica

| Convención | Fuente | Aplicación al WP |
|------------|--------|------------------|
| PlantUML obligatorio (no Mermaid) | ``cuando-usar-cada-diagrama.rst`` | Cumplido — los 8 diagramas son ``.. uml::`` |
| Include ``../../_static/plantuml-styles.puml`` | múltiples ejemplos del cajón | Cumplido en mi artefacto promovido |
| ``allowmixing`` solo cuando se mezclan tipos | observado en correcciones de build previas | Cumplido — sólo class diagrams puros, sin ``allowmixing`` |
| ≤ 3-5 responsabilidades por clase | ``analisis-dominio.rst § 14`` (CRC) | Cumplido — clases más cargadas (User, Report) tienen ≤5 operaciones |

### 1.2 Convenciones idiomáticas (estado heredado)

Estado **previo** a este WP:

| Documento | Idioma de identificadores | Idioma de prosa |
|-----------|---------------------------|-----------------|
| ``modelo-rbac-iact.rst`` v5.4.0 | Inglés (corregido por Z.1.C) | Español |
| ``analisis-dominio.rst § 7`` | Español (Usuario, Sesion, Reporte) | Español |
| ``diagramas-uml.rst § 1`` ejemplo | Español (Llamada, ``getDuracion``) | Español |
| NOM_001 § 2.3 | Identificadores en INGLÉS; descriptivos en ESPAÑOL | Español |

### 1.3 Decisión idiomática del WP actual

Decisión confirmada por el ejecutor el 2026-05-01:
*"las clases y funciones iban a estar en inglés"*.

Esa decisión **supersede** la convención histórica
española de ``analisis-dominio.rst § 7`` y unifica
con la convención inglesa ya aplicada al modelo
RBAC v5.4.0. La unificación reduce la fricción de
nomenclatura cruzada entre clases del dominio y
funciones que operan sobre ellas.

Para el WP actual:

- **Identificadores** (clase, atributo, operación,
  enum) en inglés PascalCase / snake_case /
  UPPER_SNAKE.
- **Prosa, comentarios PlantUML, notas** en
  español al integrar a ``source/``.

Confirmado en commit ``d8337f0`` y aplicado en
``modelo-dominio-iact.rst`` v1.0.0.

## 2. Auto-declaración canónica de
``analisis-dominio.rst``

### 2.1 Hallazgo

``analisis-dominio.rst § 15.4`` declara
literalmente:

   *"Este documento (analisis-dominio.rst) y sus
   hermanos forman el modelo de dominio canónico
   de IACT."*

Y enumera entonces:

- §§ 1-7: extracción del modelo (sustantivos →
  clases, etc.).
- § 7: diagrama de clases consolidado del
  dominio.
- § 8: responsabilidades canónicas.
- §§ 12-14: métodos complementarios.

### 2.2 Conflicto con el WP actual

El WP ``2026-05-01-02-01-06-domain-model-canonization``
produce ``source/arquitectura-tecnica/modelo-dominio-iact.rst``
v1.0.0 con 25 clases. ``analisis-dominio.rst § 7``
mantiene un diagrama embebido con 14 clases en
español, varias de las cuales están desactualizadas
o eliminadas.

### 2.3 Comparación detallada

| Categoría | analisis-dominio.rst § 7 | modelo-dominio-iact.rst |
|-----------|--------------------------|-------------------------|
| Idioma | Español | Inglés |
| Conteo de clases | 14 | 25 |
| Bounded contexts | 6 paquetes informales | 7 contextos formales (PERM subsumido en RBAC) |
| ``SegmentoDatos`` | Presente | Ausente (Z.1.C Camino C) |
| ``ExportJob``, ``ScheduledReport``, ``SavedView``, ``Subscription``, ``ApplicationLog``, ``ETLLog``, ``InfrastructureLog``, ``SystemHealth``, ``TechnicalMetric``, ``Function``, ``FunctionGroup``, ``AccessGroup``, ``Assignment``, ``ExceptionalPermission``, ``SeparationRule`` | Ausentes | Presentes |
| Decisiones D-01..D-11 (Z.2) | No reflejadas | Importadas como vinculantes |
| Constraints citadas en versiones vigentes | No (cita BR_012 que ya no existe, no cita CNST-019/020 v3.0.0) | Sí (BR-009 v2.0.0, CNST-019 v3.0.0, etc.) |

### 2.4 Cifra "97 UCs"

``analisis-dominio.rst § 11`` titula *"Decisiones
por aplicar a cada uno de los 97 UCs"*. La cifra
no tiene respaldo (Análisis 06 H-T20). El conteo
verificado es 61.

### 2.5 Ubiquitous language IACT con concepto eliminado

``analisis-dominio.rst § 15.4`` lista entre el
vocabulario común *"Segmento (BR_012)"*. Z.1.C
eliminó este concepto y los archivos asociados
(``br-012-usuario-segmento-unico.rst``,
``uc-acc-06-gestionar-segmentos.rst``,
``uc-acc-07-asignar-segmento.rst``).

## 3. Plan de reconciliación

### 3.1 Acción A — Promover modelo-dominio-iact.rst (HECHO)

``source/arquitectura-tecnica/modelo-dominio-iact.rst``
v1.0.0 promovido. Toctree de
``arquitectura-tecnica/index.rst`` actualizado
para incluirlo bajo "Modelos arquitectónicos".
Build verde 0/0/0 verificado.

### 3.2 Acciones B / C / D — pendientes de decisión del ejecutor

**B. Corregir ``analisis-dominio.rst § 11``**
(*"97 UCs"* → cifra vigente).

**C. Actualizar ``analisis-dominio.rst § 15.4``**
para que el reclamo *"modelo canónico"* apunte a
``modelo-dominio-iact.rst``; § 7 queda como
ejemplo pedagógico, no como artefacto canónico.

**D. Eliminar la mención a "Segmento (BR_012)"**
del ubiquitous language IACT en § 15.4 (Z.1.C
descartó el concepto).

Las tres acciones tocan el cajón
``_metodologia-aplicacion/`` (pedagógico). El
ejecutor debe decidir si:

- se hacen aquí dentro de Stage 12, o
- se difieren a un sub-WP de saneamiento del
  cajón pedagógico.

### 3.3 Acción E — no tocar
``diagramas-uml.rst § 1`` (DECIDIDO)

El ejemplo ``class Llamada {…}`` con atributos y
operaciones en español es **pedagógico**. Cumple
su rol didáctico mostrando la estructura de un
diagrama de clases UML. No debe alterarse para
adoptar la nueva convención inglesa, porque
perdería su función de ejemplo accesible.

### 3.4 Acción F — registrar este análisis (HECHO)

Este documento.

## 4. Hallazgos del análisis

| ID | Tipo | Descripción |
|----|------|-------------|
| H-T21 | OBSERVABLE | El cajón pedagógico ``analisis-dominio.rst`` se autodeclara canónico (§ 15.4) y mantiene un diagrama de clases embebido (§ 7) con 14 clases en español. Conflicto resuelto a favor de ``modelo-dominio-iact.rst`` (25 clases en inglés, decisiones D-01..D-11 importadas, constraints en versiones vigentes). |
| H-T22 | OBSERVABLE | El ejemplo de clase ``Llamada`` en ``diagramas-uml.rst § 1`` mantiene la convención española como material didáctico. Mantenerlo así es legítimo: el cajón pedagógico enseña cómo se hace un diagrama; el cajón canónico declara cómo es el modelo del proyecto. |
| H-T23 | OBSERVABLE | Tres puntos de desincronización del cajón pedagógico requieren atención (acciones B, C, D). Pendientes de decisión sobre si se aplican aquí o en sub-WP de saneamiento. |
| H-T24 | OBSERVABLE | El uso de ``make clean`` en cada rebuild fue innecesario. El ejecutor recordó que el build incremental es la convención del proyecto; ``make clean`` solo aplica en cambios de estructura (paths, configuración Sphinx). Aplicado a partir de aquí. |

Sin SPECULATIVE.

## 5. Próximos pasos

- Commit del Stage 12 STANDARDIZE con el modelo
  promovido + este análisis.
- Decisión del ejecutor sobre acciones B/C/D.
- Si se aplican aquí, ejecutar y verificar
  build incremental 0/0/0.
- Si se difieren, abrir sub-WP de saneamiento del
  cajón pedagógico (``_metodologia-aplicacion/``).
