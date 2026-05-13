```yml
created_at: 2026-05-01 05:17:20
project: IACT-docs
work_package: 2026-05-01-05-17-20-uc-dependency-matrix-iact
phase: Phase 11 — TRACK
author: NestorMonroy
status: Aprobado
version: 1.0.0
language: es
```

# Lessons Learned — Matriz de dependencias UC IACT

Cierre del WP. Decisiones tomadas, patrones que
funcionaron, anti-patrones a evitar en próximos
WPs analíticos.

## Resultado entregado

Documento consolidado MATRIZ-DEPENDENCIAS-UC-IACT
v1.0.0 en 6 partes + conclusión. ~2 630 líneas
totales. Cobertura 100 % de los 61 UCs.
Anclado al modelo canónico
``modelo-dominio-iact.rst`` v1.0.0 y al modelo
RBAC ``modelo-rbac-iact.rst`` v5.4.0.

## Decisiones tomadas (DEC-01..DEC-06)

### DEC-01 — Adaptar la metodología del ejemplo a IACT

El ejecutor pasó un ejemplo del dominio
ecommerce. La adaptación a IACT requirió
reconocer que **no es un pipeline lineal único**
sino un sistema con 4 rutas críticas paralelas
(Sistema, Operador, Admin RBAC, Auditor). El
flujo ecommerce Login → Catálogo → Carrito → Pago
no aplica al dominio call-center.

### DEC-02 — Estructura de 6 partes (no 12)

Inicialmente se planificaron 12 partes. Tras
revisar el ejemplo del ejecutor (6 partes +
conclusión), se reestructuró para alinear con la
calidad y densidad esperadas. Las 6 partes
cubren todos los aspectos sin duplicar.

### DEC-03 — 3 dependencias transversales como
ciudadanas de primera clase

T-01 (sesión activa), T-02 (verificar permiso) y
T-03 (emitir AuditEvent) se documentaron como
**dependencias transversales** con peso propio
(Parte 4) en lugar de mezclarlas con las
dependencias intra-cluster. Esto evita ruido en
la matriz UC × UC y permite ver el sistema en
dos capas: la capa de negocio (UCs) y la capa de
infraestructura cross-cutting.

### DEC-04 — Estimación de 170 person-days más
88 de overhead

Las cifras de Parte 5 son **analíticas**, no
contractuales. Se documentó explícitamente la
metodología (BAJA = 1-2d, MEDIA = 3-4d, ALTA =
5-7d) con criterios verificables (líneas del UC,
flujos alternos, constraints citadas, clases
tocadas) para que sean reproducibles.

### DEC-05 — 8 patrones cross-cutting IACT como
patrones propios

Los patrones GoF son universales. Pero IACT
tiene **ocho patrones cross-cutting propios**
(RBAC Decorator, Audit Emitter, BR-009 Soft
Delete, Filtered Variant, ACC-PERM Coexistence,
Larman Consolidation, Async Throttled Export,
Internal Mailbox Delivery) que capturan la
mayor parte de la infraestructura específica del
sistema. Documentarlos por separado da material
directo para Stage 7 DESIGN futuro.

### DEC-06 — No incluir visualizaciones PlantUML
del grafo completo

Originalmente Parte 12 del plan inicial. Se
descartó porque:

- El diagrama de
  ``modelo-dominio-iact.rst`` ya cubre las 25
  clases en 8 sub-diagramas.
- La matriz UC × UC con 61 nodos y ~70 aristas
  REQUIERE + 153 transversales (T-01 + T-02 +
  T-03) sería un grafo denso ilegible.
- Mejor visualización: las 4 rutas críticas
  textuales en Parte 4 + el diagrama unificado
  ASCII art.

Si se requieren PlantUML adicionales, va en un
WP separado de visualización.

## Lo que funcionó bien

### LF-01 — Heredar el WP predecesor

Las correcciones aplicadas a los 61 UCs en el WP
``2026-05-01-03-29-03-uc-corrections-against-canonical-model``
(61/61 OK, build 0/0/0) dieron una base limpia
sobre la cual analizar dependencias. Sin esa
corrección previa, la matriz hubiera arrastrado
ambigüedades del corpus pre-canónico.

### LF-02 — Partes commiteadas independientemente

Parte 1 commit + Parte 2 commit + Partes 3-6 +
Conclusión commit. Tres commits granulares
permitieron al ejecutor revisar cada hito sin
esperar el cierre.

### LF-03 — Anclaje a outputs del programa Z

Cada decisión de mapeo cita su origen
(D-01..D-11 de Z.2, Cat 1..5 de Z.2.A). Cero
decisiones sin ancla — patrón heredado del WP
predecesor de canonización.

## Lo que se debe evitar en futuros WPs

### LE-01 — No copiar estructura del ejemplo
verbatim

Los ejemplos del ejecutor se usan como **guía de
calidad y profundidad**, no como template
literal. La adaptación al dominio IACT (4 rutas
paralelas, no 1 lineal; 9 clusters, no 13;
patrones cross-cutting propios) generó un
producto más útil que una copia con
sustituciones.

### LE-02 — No estimar sin método declarado

Se documentó explícitamente el método de
estimación BAJA/MEDIA/ALTA con criterios
verificables. Sin esto, los números son
arbitrarios y no reproducibles. Aplicable a
cualquier estimación futura.

### LE-03 — No mezclar transversales con
dependencias específicas

T-01, T-02, T-03 aplican a 59, 59 y 35 UCs
respectivamente. Mezclarlas en la matriz
compacta saturaría con ruido. Tratar los
transversales por separado fue acierto
metodológico.

## Métricas finales

| Métrica | Valor |
|---------|-------|
| Partes entregadas | 6 + conclusión |
| Líneas totales | ~2 630 |
| UCs documentados | 61 / 61 |
| Patrones identificados | 25 (15 GoF + 8 IACT + 2 DDD) |
| Hallazgos | 8 (H-M01..H-M08) |
| SPECULATIVE | 0 (gate I-012 OK) |
| Commits | 3 |
| Build status | n/a (no toca ``source/``) |

## Trazabilidad

- WP predecesor:
  ``2026-05-01-03-29-03-uc-corrections-against-canonical-model``
  (cerrado v1.0.0).
- WP fundacional:
  ``2026-05-01-02-01-06-domain-model-canonization``
  (cerrado v1.0.0).
- Programa Z padre:
  ``2026-04-29-17-52-15-modelo-rbac-improvement``.

## Cierre

WP cerrado por orden del ejecutor (I-011) el
2026-05-01. Todos los entregables verificados.
Cero cambios al corpus ``source/`` (este WP es
analítico puro, vive en
``.thyrox/context/work/``).
