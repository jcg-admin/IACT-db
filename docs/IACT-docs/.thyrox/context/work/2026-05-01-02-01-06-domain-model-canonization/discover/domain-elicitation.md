```yml
created_at: 2026-05-01 02:01:06
project: IACT-docs
work_package: 2026-05-01-02-01-06-domain-model-canonization
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Plan de elicitación adaptada con deviation explícita

Plan de elicitación del modelo de dominio canónico
de IACT, adaptado a la realidad del proyecto y
documentado como **deviation explícita** del skill
``rm-elicitation``. Sintetiza los seis análisis ya
registrados en este WP (``discover/analyses/``).

## 1. Pre-condición declarada por el skill

``rm-elicitation`` SKILL.md exige (verbatim de §
"Pre-condición"):

- Work package activo con contexto inicial.
- Stakeholders identificados.
- Para re-elicitaciones: gaps documentados.

Y exige (§ "Actividades"):

1. Planificar elicitación.
2. Aplicar técnicas con stakeholders.
3. Conducir las sesiones.
4. **Confirmar resultados con stakeholders**
   (member checking, walkthroughs, prototipos).

Red flag declarado: *"sin confirmación con
stakeholders, los resultados son la
interpretación del analista, no los requisitos
del cliente"*.

## 2. Deviation aplicada

### Por qué hay deviation

El proyecto IACT no tiene **stakeholders externos
disponibles** para sesiones de elicitación
(sustancia confirmada por el Análisis 02:
``elicitation-history.md`` § "Implicaciones para
el plan"). El corpus existente
(``source/requisitos/``) es producto de **al menos
una regeneración completa** anclada en planes
documentados (``PLAN_REGENERACION_COMPLETA_DESDE_CERO``,
``PLAN MAESTRO Casos de Uso v4.0``) y no de
elicitación con clientes reales.

Adicionalmente, los WPs cerrados del programa Z
(``modelo-rbac-improvement``: Z.1.C, Z.2, Z.2.A)
ya hicieron deep review del corpus + análisis
genealógico de 7 versiones del modelo RBAC +
clasificación de los 61 UCs en 5 categorías. Esos
outputs son **funcionalmente equivalentes a una
elicitación validada**: el corpus actual no es
arbitrario — es resultado de decisiones revisadas y
formalizadas.

### Qué se sustituye y por qué

| Actividad del skill | Sustitución aplicada | Justificación |
|---------------------|---------------------|---------------|
| Stakeholders externos | Ejecutor (NestorMonroy) como proxy + outputs de programa Z como elicitación previa | No hay product owner ni usuarios reales del call center disponibles. El programa Z formalizó las decisiones del proyecto. |
| Sesiones presenciales | Análisis de documentos + sesión de validación escrita con ejecutor | Análisis de documentos es 1 de las 7 técnicas legítimas del skill (§ 2 tabla de técnicas). |
| Workshop JAD multi-stakeholder | Cross-check entre tres fuentes documentales | Modelo RBAC v5.4.0 ↔ 61 UCs ↔ BR/CNST vigentes — tres fuentes que se validan entre sí. |
| Prototipo de confirmación | Diagrama PlantUML revisado por ejecutor antes de promover | Corresponde al "prototipo low-fi" del catálogo del skill aplicado al diagrama de clases. |
| Member checking | Confirmación escrita por commit del ejecutor antes de cierre | Equivalente formalizado en git. |

### Lo que la deviation **sí** garantiza

- **Coherencia interna**: el modelo de clases
  encajará con los 61 UCs vigentes y con el modelo
  RBAC v5.4.0.
- **Trazabilidad**: cada clase del modelo cita el
  UC y la función RBAC que la justifican.
- **Cumplimiento normativo**: BR-009 v2.0.0,
  CNST-019/020 v3.0.0 y demás constraints
  vigentes.
- **Versionamiento**: SemVer 2.0.0 en el
  artefacto producido (NOM_001).

### Lo que la deviation **no** puede garantizar

- **Ajuste con realidad operativa del call
  center**: si el modelo refleja el negocio real,
  sólo lo confirmaría un product owner o usuarios
  del sistema. Riesgo R-01 del ``risk-register``
  refinado.
- **Necesidades latentes**: las que sólo emergen
  en conversación con usuarios no se descubrirán
  aquí.

## 3. Stakeholders identificados (modelo adaptado)

Por sustitución, los "stakeholders" del WP son:

| Rol | Sustituto | Cómo se consulta |
|-----|----------|------------------|
| Product owner | Ejecutor | Confirmación escrita por commit |
| Arquitecto | Modelo RBAC v5.4.0 + ADRs vigentes (ADR-GOB-008, ADR-GOB-009, ADR-DEVOPS-001) | Lectura |
| Analista de negocio | BR vigentes (20 + reescrituras Z.2) + FR derivados | Lectura |
| Auditor de calidad | STD_001 + STD_007 + NOM_001 + CLEAN CODE NAMING | Verificación cruzada |
| Memoria histórica | Programa Z (Z.1.C, Z.2, Z.2.A) + std007-* + emoji-tables-audit | Importación de outputs |

## 4. Técnicas aplicadas

### T-01 — Análisis de documentos (técnica del skill)

Fuentes primarias del corpus vigente:

- ``source/arquitectura-tecnica/rbac/modelo-rbac-iact.rst``
  v5.4.0 (61 funciones).
- ``source/requisitos/casos-uso/`` (61 UCs, 9
  clusters AUTH/USR/ACC/PERM/RPT/ALR/PIP/AUD/LOG).
- ``source/requisitos/business-requirements/``
  (BRs vigentes, incluida BR-009 v2.0.0,
  BR-011 v2.0.0).
- ``source/normativa/restricciones/`` (CNST
  vigentes, incluidas CNST-019 v3.0.0,
  CNST-020 v3.0.0).
- ``source/requisitos/_metodologia-aplicacion/analisis-dominio.rst``
  § 7 (extracto del diagrama integrado — usar como
  referencia, no como canónico).

Salida: lista de sustantivos candidatos a clase
del dominio (Stage 3 ANALYZE — futuro
``analyze/domain-class-candidates.md``).

### T-02 — Cross-catalog validation

Validar consistencia entre tres fuentes:

| Eje | Fuente A | Fuente B | Verificación |
|-----|----------|----------|--------------|
| Funciones ↔ UCs | Modelo RBAC v5.4.0 (61) | UCs en source/ (61) | Matriz por Z.2.A 5 categorías |
| UCs ↔ BR | UCs (61) | BR vigentes | Cada UC cita ≥1 BR origen |
| Clases ↔ UCs | Clases candidatas | UCs (61) | Cada clase aparece como sujeto/objeto en ≥1 UC |
| Clases ↔ Constraints | Clases candidatas | CNST vigentes | Cada CNST citada en ≥1 clase |

Salida: matriz UC × clase (Stage 9 PILOT —
``pilot/uc-vs-domain-validation.md``).

### T-03 — Análisis de código (verificación
real-comportamiento)

Fuentes en ``temp-holding/Modules/`` y
``source/`` que encarnan el modelo:

- ``temp-holding/Modules/call_center_privilege_models.py``
  — modelos Django del RBAC.
- ``temp-holding/Modules/module_system_models.py``
  — modelos Django del sistema.

Uso: validar que las entidades del modelo
conceptual tienen correspondencia en el código (no
para ingeniería inversa — para confirmar que el
concepto es real, no especulado).

Limitación: el código en ``temp-holding/`` puede
reflejar versiones previas. Si discrepa con el
modelo RBAC v5.4.0, gana el modelo (más reciente y
auditado).

### T-04 — Confirmación escrita por ejecutor

Antes de promover el diagrama de clases canónico
desde ``design/iact-domain-model.md`` a un
artefacto en ``source/``, el ejecutor:

- revisa el PlantUML renderizado,
- valida la matriz UC × clase,
- confirma el glosario de lenguaje ubicuo,
- aprueba por commit explícito.

Sin esa confirmación, el WP no avanza a Stage 12
STANDARDIZE.

## 5. Materiales de apoyo importados

El WP importa los siguientes outputs como insumo
sin re-derivarlos (riesgo R-15):

| Output importado | Fuente | Uso en este WP |
|------------------|--------|----------------|
| Genealogía v4.0..v5.4.0 del modelo RBAC | Z.2.A § 1 + Z.1.C § "Genealogia" | Contexto histórico del modelo |
| Clasificación 5 categorías de UCs | Z.2.A § 3 (Cat 1..5) | Estructura de la matriz UC × clase |
| 11 decisiones D-01..D-11 | Z.2 ``analyze/srp-audit/decisions-log.md`` | Justificación de naming / responsabilidades de clases |
| Inventario verificado de 61 UCs | WP previo ``rm-uc-relationships-analysis/discover/uc-inventory.md`` | Lista de UCs a validar contra modelo |
| Constraints vigentes (versiones) | Z.2 changelog § "Constraints reescritas" | Citar la versión correcta en cada clase |

## 6. Preguntas guía (en lugar de preguntas a
stakeholders)

Las preguntas que el WP responde mediante
análisis del corpus + outputs importados:

1. ¿Cuáles son los **sustantivos** del corpus que
   tienen identidad propia, persistencia y
   operaciones de negocio? (Filtro de Abbott —
   referencia ``analisis-dominio.rst § 12``.)
2. ¿Qué bounded contexts emergen naturalmente
   del catálogo de UCs? (Hipótesis: Auth, RBAC,
   Reports/Metrics, Pipeline ETL, Alerts, Audit,
   Logs.)
3. ¿Qué relaciones (asociación, agregación,
   composición, generalización) capturan la
   estructura del dominio sin redundar con el
   modelo RBAC?
4. ¿Cuáles clases tienen **estado dinámico**
   (Sesion, Alerta, EjecucionETL) que requieren
   diagramas de estado complementarios? (Diferido
   a WP posterior.)
5. ¿Qué nombres canónicos seguirán los
   identificadores del modelo (clases, atributos,
   operaciones, asociaciones) según CLEAN CODE +
   NOM_001?

## 7. Calendario y modalidad

| Hito | Salida | Verificación |
|------|--------|--------------|
| Stage 1 cerrado | Este documento + risk-register + exit-conditions refinados | Análisis 01..06 registrados |
| Stage 3 ANALYZE | ``analyze/domain-class-candidates.md`` | IEEE 830 aplicado a sustantivos |
| Stage 7 DESIGN | ``design/iact-domain-model.md`` | PlantUML canónico |
| Stage 9 PILOT | ``pilot/uc-vs-domain-validation.md`` | Matriz 100 % cobertura |
| Stage 12 STANDARDIZE | Promoción del diagrama a ``source/`` | Confirmación ejecutor |

Modalidad: 100 % asíncrona (lectura + escritura +
commit). No hay sesiones síncronas.

## 8. Confirmación con ejecutor

Antes de cerrar Stage 1 DISCOVER, el ejecutor
confirma:

- [x] Esta deviation es aceptable para este WP.
- [x] Los stakeholders sustitutos (programa Z +
  ejecutor) son fuente suficiente para el alcance.
- [x] La cifra **vigente** de UCs es **61** (no
  49, no 97). **Matización del ejecutor
  (2026-05-01):** la cifra puede cambiar como
  resultado de los análisis posteriores de UC
  (Stage 3 ANALYZE en adelante) — si emergen
  consolidaciones, divisiones o nuevos UCs, el
  conteo se ajusta y el modelo de clases evoluciona
  en consecuencia. ``analisis-dominio.rst § 11``
  debe corregirse a la cifra final cuando se
  estabilice.
- [x] El concepto ``SegmentoDatos`` (eliminado
  por Z.1.C) **no aparece** en el modelo de
  clases que produzca este WP.
- [x] La validación final del modelo será por
  commit explícito, no por sesión externa.

Confirmación registrada por el ejecutor el
2026-05-01 vía mensaje de sesión + commit
posterior. Stage 1 DISCOVER queda cerrado
materialmente; el WP avanza a Stage 3 ANALYZE.

## 9. Limitaciones declaradas

- Necesidades latentes del usuario real no
  detectables.
- Ambigüedades del corpus que sólo se resolverían
  preguntando al autor original quedan
  registradas como "pendiente de validación con
  product owner futuro".
- El modelo producido es **el primer canónico
  del proyecto** — versiones futuras pueden
  evolucionar con DDD aplicado en próximos WPs.

## 10. Trazabilidad a los seis análisis

| Análisis | Nombre | Aporte a este plan |
|----------|--------|--------------------|
| 01 | ``temp-holding-inventory.md`` | Mapa de fuentes secundarias |
| 02 | ``elicitation-history.md`` | Confirmación de la deviation (PLAN v4.0 sin elicitación stakeholder) |
| 03 | ``historical-risks.md`` | Patrones de error a evitar |
| 04 | ``quality-criteria.md`` | Política declarada vigente |
| 05 | ``previous-wps-fixes-applied.md`` | Lista de WPs cerrados a importar |
| 06 | ``canonical-state-z-program.md`` | Estado canónico del corpus al iniciar este WP |
