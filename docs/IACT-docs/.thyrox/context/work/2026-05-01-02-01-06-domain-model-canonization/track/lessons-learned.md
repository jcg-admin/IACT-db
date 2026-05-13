```yml
created_at: 2026-05-01 02:01:06
project: IACT-docs
work_package: 2026-05-01-02-01-06-domain-model-canonization
phase: Phase 11 — TRACK/EVALUATE
author: NestorMonroy
status: Aprobado
version: 1.0.0
language: es
```

# Lessons Learned — Canonización del Modelo de Dominio IACT

Cierre del WP. Resumen de decisiones tomadas,
patrones que funcionaron, y patrones que evitar
en WPs futuros del proyecto.

## Resultado entregado

- ``source/arquitectura-tecnica/modelo-dominio-iact.rst``
  v1.0.0 — modelo canónico con 25 clases en 7
  bounded contexts, identificadores en inglés,
  prosa en español, 8 diagramas PlantUML, build
  0/0/0 incremental verificado.
- ``analisis-dominio.rst`` reconciliado: § 11
  corregido (97 → 61 UCs), § 15.4 redirige el
  reclamo "canónico" al nuevo artefacto, ubiquitous
  language depurado del concepto Segmento.
- 7 análisis registrados en ``discover/analyses/``
  documentando el camino completo.
- Pilot validation: 100 % cobertura UC × clase
  bidireccional (61 UCs ↔ 25 clases).

## Decisiones tomadas (DEC-01..DEC-07)

### DEC-01 — Cerrar WP previo y abrir uno nuevo

El WP previo
``2026-04-30-22-45-55-rm-uc-relationships-analysis``
analizó relaciones entre UCs sobre supuestos
no validados. Se mantuvo abierto con su artefacto
marcado como hipótesis y se abrió este WP para
construir la base que aquel necesitaba.

### DEC-02 — Adaptar elicitación a la realidad del proyecto

No hay stakeholders externos disponibles. Se
adaptó el skill ``rm-elicitation`` documentando
deviation explícita: el corpus + ejecutor + outputs
del programa Z funcionan como sustituto de
elicitación validada.

### DEC-03 — Importar decisiones de WPs cerrados en lugar de re-derivarlas

El programa Z (Z.1.C, Z.2, Z.2.A) ya había
clasificado los 61 UCs en 5 categorías y producido
11 decisiones D-01..D-11. Se importaron como
vinculantes en lugar de re-procesar el corpus.
Riesgo R-15 ("no re-derivar lo cerrado") activo
durante todo el WP.

### DEC-04 — Convención idiomática unificada

Identificadores en inglés (consistencia con modelo
RBAC v5.4.0 corregido por Z.1.C); prosa, comentarios
PlantUML y notas en español al integrar a
``source/``. Decisión confirmada por el ejecutor el
2026-05-01.

### DEC-05 — Rechazar abstracción prematura

H-A05 (superclase ``ReportRequest`` para
``ScheduledReport`` / ``ExportJob`` / ``SavedView``)
se rechazó: comparten 3 campos y 0 comportamiento;
el costo cognitivo supera al beneficio.

### DEC-06 — Mantener cohesión por módulo

H-A06 (separar contexto Monitoring para
``SystemHealth`` / ``TechnicalMetric``) se rechazó:
conviven con logs por retención (CNST-024) y por
módulo (MOD_Logs); separar produciría dos contextos
de una clase cada uno sin compartir concerns.

### DEC-07 — Sincronizar el cajón pedagógico con el canónico

Aplicadas en este mismo WP las acciones B, C, D
sobre ``analisis-dominio.rst`` (corregir conteo,
redirigir reclamo canónico, eliminar Segmento del
ubiquitous language). El cajón pedagógico queda
como soporte metodológico ("cómo se construye"); el
nuevo artefacto en ``arquitectura-tecnica/`` es el
canónico ("cuál es").

## Lo que funcionó bien

### LF-01 — Análisis previo registrado por separado

Los 7 análisis (inventario, historia de elicitación,
riesgos históricos, criterios de calidad, fixes ya
aplicados, estado canónico Z, convenciones)
permitieron que cada decisión final tuviera un
ancla verificable. Si un riesgo o criterio se
descartó, se puede señalar exactamente por qué.

### LF-02 — Importar outputs de WPs cerrados

Z.2.A entregó 5 categorías clasificadas; Z.2 entregó
11 decisiones D-01..D-11; Z.1.C entregó la
genealogía de funciones. No se procesó nada de eso
de nuevo. Ahorro de trabajo grande, sin pérdida de
calidad.

### LF-03 — Build incremental como gate por WP

El gate "build 0 warnings / 0 errors" aplicado al
final de cada Stage (sin necesidad de ``make
clean``) detectó cualquier warning estructural sin
costo de tiempo significativo.

### LF-04 — Verificación de convenciones antes de promover

Antes del Stage 12 STANDARDIZE el ejecutor pidió
revisar ``analisis-dominio.rst`` y
``base-cognitiva/_uml/`` para confirmar que el
modelo respeta convenciones declaradas. Resultó en
el Análisis 07 que detectó tres puntos de
sincronización pendientes (B/C/D) que se aplicaron
en el mismo WP.

## Lo que se debe evitar en futuros WPs

### LE-01 — No saltar a producir entregables sin validar la base

El primer intento de Stage 3 ANALYZE produjo
``uc-relationships-analysis.md`` sobre supuestos no
validados. El ejecutor lo señaló y forzó pivot a
canonización del modelo de dominio primero. Lección:
si los UCs / clases / constraints están en flujo,
canonizar primero, analizar relaciones después.

### LE-02 — No replicar el trabajo de WPs cerrados

Los Análisis 02 y 03 de este WP recorrieron
parcialmente el mismo camino que Z.2.A había
recorrido un día antes. El Análisis 05 lo detectó y
permitió descartar 5 riesgos (R-09, R-10, R-11,
R-13, R-14). La lección: leer cierres de WPs
relacionados al inicio, no al final.

### LE-03 — No usar ``make clean`` por defecto

Acelera el ciclo enormemente usar build incremental.
``make clean`` reservado para cambios de
estructura (paths, configuración Sphinx). Aplicado
desde mediados de Stage 12.

### LE-04 — No producir documentos en idioma no acordado

Antes de redactar un artefacto extenso, confirmar
la convención idiomática vigente. La decisión
"identificadores en inglés" del 2026-05-01 fue
tardía respecto al borrador inicial del modelo.
Lección: levantar el tema antes de redactar 500+
líneas.

## Métricas finales

| Métrica | Valor |
|---------|-------|
| Stages ejecutados | 5 (1, 3, 7, 9, 12) |
| Análisis registrados | 7 (en ``discover/analyses/``) |
| Documentos finales | 5 (elicitation, risks, exit, candidates, model, validation) |
| Clases canónicas | 25 |
| Bounded contexts | 7 |
| Diagramas PlantUML | 8 (1 overview + 7 contexts) |
| UCs validados | 61 / 61 (100 %) |
| Build status final | ``make html`` 0 warnings, 0 errors |
| Riesgos vivos al cierre | 10 (de 15 considerados; 5 descartados por evidencia) |
| Decisiones D-01..D-11 importadas | 11 (todas vinculantes) |
| Versiones de constraints citadas | vigentes (BR-009 v2.0.0, BR-011 v2.0.0, CNST-019/020 v3.0.0) |

## Trazabilidad

- WP previo:
  ``2026-04-30-22-45-55-rm-uc-relationships-analysis``
  (sigue abierto; su análisis hipotético puede
  retomarse sobre la base canónica que este WP
  estableció).
- Programa Z padre:
  ``2026-04-29-17-52-15-modelo-rbac-improvement``
  (sub-WPs Z.1.C, Z.2, Z.2.A cerrados; Z.3, Z.4,
  Z.5 pendientes).
- WP siguiente: corrección sistemática de los 61
  UCs contra el modelo canónico (a abrir tras este
  cierre).

## Cierre

WP cerrado por orden del ejecutor (I-011) el
2026-05-01. Todos los entregables verificados.
Build verde. Hallazgos H-T20, H-T21 cerrados por
las acciones B/C/D del Análisis 07.
