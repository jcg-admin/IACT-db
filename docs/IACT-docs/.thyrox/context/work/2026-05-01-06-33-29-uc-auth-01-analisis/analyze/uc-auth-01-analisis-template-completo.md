```yml
created_at: 2026-05-01 06:33:29
project: IACT-docs
work_package: 2026-05-01-06-33-29-uc-auth-01-analisis
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Borrador
version: 1.0.0
language: es
target_uc: UC_AUTH_01
methodology_source: template de spec completa de 12 partes (referencia del ejecutor)
```

# Análisis UC_AUTH_01 — Gap analysis contra template de spec completa

> Tercer análisis del WP. Mapea el estado actual de
> ``uc-auth-01-iniciar-sesion.rst`` v4.0.0 contra el
> template de 12 partes que el ejecutor declaró
> como nivel de calidad objetivo. Identifica:
>
> - qué partes ya cubre el UC vigente,
> - qué falta para llegar a spec completa,
> - cómo se distribuye el contenido en múltiples
>   archivos (per directiva del ejecutor: *"no
>   todo va en el mismo archivo"*),
> - qué decisiones quedan pendientes para el WP
>   futuro de spec completa.
>
> **No** redacta los flujos faltantes — eso es
> trabajo del WP futuro.

----

## 1. Estructura del template (12 partes)

Resumen del template objetivo (extraído del
ejemplo del ejecutor, dominio ecommerce
adaptado mentalmente al dominio IACT):

| Parte | Foco | Tamaño estimado |
|-------|------|-----------------|
| 1 | Información general (ID, propósito, scope IN/OUT) | corto |
| 2 | Actores y precondiciones / postcondiciones | medio |
| 3 | Flujo principal paso a paso (happy path) | largo |
| 4 | Rutas alternativas (FA-NN) | medio-largo |
| 5 | Excepciones (EX-NN) | medio |
| 6 | Requisitos no funcionales (performance, seguridad, confiabilidad, usabilidad) | medio |
| 7 | Datos involucrados (entrada, salida, BD, errores variantes) | largo |
| 8 | Diagramas UML (secuencias, clases, estados, actividades) | medio |
| 9 | Criterios de aceptación (DADO/CUANDO/ENTONCES) | medio |
| 10 | Patrones de diseño aplicables | corto-medio |
| 11 | Implementación técnica (stack, archivos backend / frontend) | medio |
| 12 | Testing (test cases backend + frontend) | largo |

----

## 2. Estado actual del UC_AUTH_01 vigente

``source/requisitos/casos-uso/auth/uc-auth-01-iniciar-sesion.rst``
v4.0.0 tiene **14 secciones** internas:

::

   1. Resumen
   2. Descripcion
   3. Diagrama de Caso de Uso
   4. Contexto de Ejecucion (4.1 Precondiciones,
                              4.2 Trigger,
                              4.3 Postcondiciones)
   5. Flujo Normal (Camino Feliz)
   6. Diagrama de Secuencia
   7. Flujos Alternos (7.1 FA-01, 7.2 FA-02)
   8. Excepciones (8.1..8.5 EX-01..EX-05)
   9. Diagrama de Actividad
  10. Reglas de Negocio
  11. Restricciones de Arquitectura
  12. Requisitos Funcionales Derivados
  13. Trazabilidad
  14. Historial de Cambios

----

## 3. Mapeo gap-analysis (12 partes ↔ UC vigente)

### Parte 1 — Información general

| Sub-aspecto | Estado en UC vigente | Gap |
|-------------|---------------------|-----|
| 1.1 Identificación (ID, nombre, versión, autor) | ✅ § 1 Resumen + meta | OK |
| 1.2 Propósito | ✅ § 2 Descripcion (3 líneas) | parcial — **expandir** a párrafo de propósito explícito |
| 1.3 Alcance (IN / OUT explícito) | ❌ ausente | **agregar** sección IN/OUT |
| Precedente y siguiente UC | ⚠ § 13 Trazabilidad cita UCs relacionados sin distinguir orden | **agregar** "precedente: ninguno (entrada universal); siguiente: UC_AUTH_04 si first_login, o cualquier UC con T-01" |

### Parte 2 — Actores y precondiciones / postcondiciones

| Sub-aspecto | Estado | Gap |
|-------------|--------|-----|
| 2.1 Actor primario (descripción, características, objetivos, responsabilidades) | parcial — § 1 cita "Usuario" + AGR; el análisis uml-06 lo expande | **integrar** la expansión del análisis uml-06 |
| 2.2 Actores secundarios (Sistema, BD, Email service, Frontend) | ❌ § 1 cita "Sistema" como actor secundario sin desagregar | **agregar** desagregación: Backend Django, MySQL, InternalMailbox service, Frontend React |
| 2.3 Precondiciones (5 categorías: sistema disponible, usuario anónimo, conectividad, datos válidos, etc) | parcial — § 4.1 lista 4 precondiciones | **expandir** a categorías (sistema, usuario, conectividad, datos) |
| 2.4 Postcondiciones (éxito + falla detalladas) | parcial — § 4.3 cubre éxito; falla limitada | **agregar** postcondiciones de falla por tipo de excepción |

### Parte 3 — Flujo principal paso a paso

| Sub-aspecto | Estado | Gap |
|-------------|--------|-----|
| Pasos numerados con Actor / Acción / Sistema responde | ✅ § 5 Flujo Normal | OK estructuralmente |
| Detalle de cada paso (qué hace exactamente, con qué clase del modelo, qué constraint cita) | parcial — pasos textuales sin profundidad | **expandir** cada paso con: clase del dominio tocada, constraint citada, transformación de state |
| Tiempo estimado por paso | ❌ ausente | **agregar** P95/P99 por paso para Parte 6 |

### Parte 4 — Rutas alternativas (FA-NN)

| Sub-aspecto | Estado | Gap |
|-------------|--------|-----|
| FA-01 Primer login (cambio password) | ✅ § 7.1 (extiende a UC_AUTH_04) | OK estructuralmente, **detallar** punto de divergencia exacto |
| FA-02 Password expirado | ✅ § 7.2 | OK estructuralmente |
| FA-03 Sesión previa activa (CNST-003) | ❌ ausente — debería existir | **agregar** flujo alterno para sesión previa |
| Estructura uniforme: activador, punto de divergencia, pasos numerados, retorno | parcial | **uniformar** estructura entre FA |

### Parte 5 — Excepciones (EX-NN)

| Sub-aspecto | Estado | Gap |
|-------------|--------|-----|
| EX-01 Usuario no existe | ✅ § 8.1 | OK |
| EX-02 Password incorrecto | ✅ § 8.2 | OK |
| EX-03 Usuario bloqueado | ✅ § 8.3 | OK |
| EX-04 Usuario inactivo | ✅ § 8.4 | OK |
| EX-05 Throttling excedido | ✅ § 8.5 | OK |
| Estructura uniforme (punto trigger, condición, acción sistema, recuperación, resultado) | parcial — algunas EX más cortas que otras | **uniformar** estructura |
| Excepciones de infraestructura (BD timeout, email service offline) | ❌ ausente | **agregar** EX-06 BD timeout, EX-07 email service offline (impacta InternalMailbox para FA-02) |

### Parte 6 — Requisitos no funcionales

| Sub-aspecto | Estado | Gap |
|-------------|--------|-----|
| Performance (P95, P99, throughput) | ❌ ausente | **agregar** sección con métricas cuantitativas |
| Seguridad (HTTPS, bcrypt rounds, PCI/HSTS, etc) | parcial — § 11 cita CNST_003, CNST_025 sin métricas | **expandir** con detalle |
| Confiabilidad (uptime, RTO, RPO) | ❌ ausente | **agregar** desde el análisis del WP de matriz dependencias |
| Usabilidad (mensajes claros, accesibilidad WCAG, mobile responsive) | ❌ ausente | **agregar** |
| Escalabilidad (horizontal / vertical, cache LRU) | parcial — implícito en CNST | **agregar** explícito |

### Parte 7 — Datos involucrados

| Sub-aspecto | Estado | Gap |
|-------------|--------|-----|
| Entrada (request HTTP completo: método, URL, headers, body, validaciones por campo) | parcial — § 5 cita el body en flujo | **expandir** con tabla de validaciones por campo |
| Salida (response HTTP éxito + estructura JSON) | parcial — implícito en flujo | **expandir** con response detallado |
| Salida errores (variantes 400/429/500/403 con códigos) | ❌ ausente | **agregar** matriz de error responses |
| BD: tablas tocadas (sesion, usuario, audit_event, internal_mailbox) | parcial — § 5 cita SQL implícito | **expandir** con esquemas SQL canónicos vinculados al modelo de dominio |
| Datos modificados (INSERT/UPDATE explícitos) | ❌ ausente | **agregar** lista de operaciones por tabla |

### Parte 8 — Diagramas UML

| Sub-aspecto | Estado | Gap |
|-------------|--------|-----|
| Diagrama de caso de uso | ✅ § 3 (con la deuda H-A07-01: 4 sub-pasos como UCs) | **corregir** per D-A07-01 |
| Diagrama de secuencia | ✅ § 6 | OK estructuralmente |
| Diagrama de actividad | ✅ § 9 | OK estructuralmente |
| Diagrama de estados (Session lifecycle) | ❌ ausente | **agregar** state machine de Session: ACTIVE → CLOSED, ACTIVE → EXPIRED |
| Diagrama de clases (referencia al modelo de dominio) | ⚠ implícito vía § 13 Clase de Dominio | **agregar** snippet del modelo de dominio relevante (User, Session, InternalMailbox, AuditEvent) |

### Parte 9 — Criterios de aceptación

| Sub-aspecto | Estado | Gap |
|-------------|--------|-----|
| Formato DADO/CUANDO/ENTONCES por escenario | ❌ ausente | **agregar** sección con criterios per escenario (1 nominal + 3 alternos + 5 excepciones = 9 criterios mínimo) |
| Criterios verificables (con asserts concretos) | ❌ ausente | **agregar** asserts (status code, BD state, response shape) |
| Criterios de calidad transversal (performance, seguridad) | ❌ ausente | **agregar** |

### Parte 10 — Patrones de diseño aplicables

| Sub-aspecto | Estado | Gap |
|-------------|--------|-----|
| Patrones aplicados (Strategy, Decorator, Chain of Responsibility, Observer, etc) | ❌ ausente en UC vigente; ✅ catalogados en matriz dependencias § 6 | **importar** desde matriz dependencias y aterrizar para UC_AUTH_01 |

### Parte 11 — Implementación técnica

| Sub-aspecto | Estado | Gap |
|-------------|--------|-----|
| Stack tecnológico citado | parcial — § 11 cita CNST que apuntan a ADR-DEVOPS-001 | **explicitar** stack para este UC: Django + DRF + bcrypt + JWT + MySQL + InternalMailbox |
| Archivos backend a crear (models, views, serializers, services, validators, urls, tests) | ❌ ausente | **agregar** árbol de archivos propuesto |
| Archivos frontend a crear (componentes React, hooks, redux slices, validators) | ❌ ausente | **agregar** árbol de archivos propuesto |

### Parte 12 — Testing

| Sub-aspecto | Estado | Gap |
|-------------|--------|-----|
| Test cases backend (pytest) por escenario | ❌ ausente | **agregar** matriz de tests con setup/action/assert por escenario |
| Test cases frontend (Jest + RTL) por UI/UX | ❌ ausente | **agregar** |
| Tests de integración / E2E | ❌ ausente | **agregar** |
| Cobertura mínima objetivo | ❌ ausente | **declarar** ej. 80% líneas, 100% rutas críticas |

----

## 4. Resumen del gap

::

   Partes con cobertura COMPLETA en UC vigente:        0 de 12
   Partes con cobertura PARCIAL (estructura OK):       6 de 12
                                                       (Partes 1, 2, 3, 5, 8, 11)
   Partes con cobertura ESTRUCTURAL pero falta detalle: 2 de 12
                                                       (Partes 4, 7)
   Partes AUSENTES o muy limitadas:                    4 de 12
                                                       (Partes 6, 9, 10, 12)

   Estimación de esfuerzo para llegar a spec completa:
   ────────────────────────────────────────────────────
   Partes parciales — expandir:           ≈ 10 person-days
   Partes ausentes — crear desde cero:    ≈ 12 person-days
   Diagramas adicionales (estado, clase): ≈  3 person-days
   Tests mínimos por escenario:           ≈  8 person-days
   ────────────────────────────────────────────────────
   Total estimado WP de spec completa:    ≈ 33 person-days

   Nota: contradice la estimación de 5 person-days
   "complejidad MEDIA" del UC en la matriz de
   dependencias. Esa cifra cubría sólo
   implementación, no la spec exhaustiva.

----

## 5. Propuesta de split en archivos

Per directiva del ejecutor (*"no todo va en el
mismo archivo"*), la spec completa de UC_AUTH_01
se organizaría en **un directorio dedicado** con
múltiples archivos especializados, en lugar del
``uc-auth-01-iniciar-sesion.rst`` monolítico
actual.

### Propuesta A — directorio por UC

::

   source/requisitos/casos-uso/auth/uc-auth-01/
   ├── index.rst
   │   └── overview + toctree de las partes
   ├── 01-informacion-general.rst        (Parte 1)
   ├── 02-actores-precondiciones.rst     (Parte 2)
   ├── 03-flujo-principal.rst            (Parte 3)
   ├── 04-flujos-alternos.rst            (Parte 4 — FA-01, FA-02, FA-03)
   ├── 05-excepciones.rst                (Parte 5 — EX-01..EX-07)
   ├── 06-requisitos-no-funcionales.rst  (Parte 6)
   ├── 07-datos-involucrados.rst         (Parte 7)
   ├── 08-diagramas-uml.rst              (Parte 8 — los 4 diagramas)
   ├── 09-criterios-aceptacion.rst       (Parte 9)
   ├── 10-patrones-diseno.rst            (Parte 10)
   ├── 11-implementacion-tecnica.rst     (Parte 11)
   └── 12-testing.rst                    (Parte 12)

Ventajas:

- Cada archivo cabe en pantalla (~150-300 líneas).
- Edición concurrente posible (varios devs en
  archivos distintos del mismo UC).
- Renderizado Sphinx permite navegación por
  partes.
- Conserva el patrón ya usado en otros cajones
  del proyecto (e.g.
  ``source/requisitos/_metodologia-aplicacion/``).

Desventajas:

- Aumenta número de archivos del catálogo
  (61 UCs × 12 archivos = 732 archivos sólo en
  spec completa; sólo CRÍTICOS = 8 × 12 = 96
  archivos). Manejable.

### Propuesta B — archivo monolítico expandido

Mantener un solo archivo
``uc-auth-01-iniciar-sesion.rst`` pero
expandirlo de las 14 secciones actuales a
~3000 líneas con las 12 partes.

Ventajas: 1 archivo por UC, fácil de descargar /
versionar / referenciar.

Desventajas: ediciones concurrentes complicadas;
archivos de 3000+ líneas son difíciles de
mantener.

### Recomendación

**Propuesta A** (directorio por UC) por:

- alineación con la directiva *"no todo va en el
  mismo archivo"*;
- escalabilidad para los 61 UCs (o al menos los
  8 CRÍTICOS);
- mejor separación de concerns por parte;
- compatibilidad con el render de Sphinx
  (toctree por UC).

----

## 6. Decisiones pendientes para el WP de spec completa

Decisiones que el WP siguiente debe resolver
antes de redactar:

- **D-T01 — Adoptar Propuesta A o B** (estructura
  de archivos). Recomendada A.
- **D-T02 — Migración de UC vigente**: ¿se
  archiva ``uc-auth-01-iniciar-sesion.rst``
  v4.0.0 reemplazándolo por
  ``uc-auth-01/index.rst`` + 12 partes, o se
  mantiene v4.0.0 como "vista resumida" y se
  crea el directorio en paralelo?
- **D-T03 — Cifras concretas**: dónde viven los
  números de Parte 6 (P95 < 1.5s, throughput,
  bcrypt rounds=12). Opciones: (a) en el archivo
  ``06-requisitos-no-funcionales.rst`` directo,
  (b) en un ADR de implementación, (c) ambos
  (UC cita ADR). Recomendado: (c) per Z.2 D-08
  (CNST normativa, ADR implementación).
- **D-T04 — Stack en Parte 11**: ¿citar
  ADR-DEVOPS-001 vigente o duplicar para hacer
  el UC autocontenido? Recomendado: citar y no
  duplicar.
- **D-T05 — Test cases en Parte 12**: ¿incluir
  código pytest / Jest concreto, o sólo tabla
  con setup/action/assert? Recomendado: tabla
  + snippet de ejemplo por categoría (no código
  completo de cada test).
- **D-T06 — Granularidad de Parte 3**: ¿20 pasos
  detallados como el ejemplo del ejecutor, o
  10 pasos consolidados con detalle moderado?
  Para UC_AUTH_01 lo razonable son ~10 pasos
  (su flujo es relativamente lineal).

----

## 7. Hallazgos del análisis

| ID | Tipo | Descripción |
|----|------|-------------|
| H-T-01 | OBSERVABLE | UC_AUTH_01 vigente cubre estructuralmente 6 de 12 partes; 2 con estructura pero sin detalle; 4 ausentes (RNF, criterios aceptación, patrones, testing). Spec completa requiere ~33 person-days adicionales — más del 6× lo estimado en la matriz para implementación pura. |
| H-T-02 | OBSERVABLE | Las 4 partes ausentes (6, 9, 10, 12) son las que aportan **calidad de ingeniería**: requisitos no funcionales medibles, criterios de aceptación verificables, patrones implementables, tests trazables. Si se omiten, el UC pasa de ser "spec implementable" a "narrativa funcional". |
| H-T-03 | OBSERVABLE | El propio análisis de dependencias del WP previo (matriz § 6) ya catalogó los patrones de diseño aplicables a UC_AUTH_01: Strategy (auth provider), Decorator (rate limit), Chain of Responsibility (validaciones), Observer (audit emission). Importar a Parte 10 directamente sin re-derivar. |
| H-T-04 | OBSERVABLE | El UC vigente § 8 (Excepciones) cubre 5 EX, pero faltan 2 que el template del ejecutor sugiere: BD timeout y servicio externo offline (en este caso InternalMailbox). Estas ya aparecen en el WP previo como riesgos transversales y deberían explicitarse aquí. |
| H-T-05 | INFERRED | El split en 12 archivos (Propuesta A) se beneficiará si los 8 CRÍTICOS adoptan la misma estructura — produce un patrón uniforme de catálogo (8 × 12 = 96 archivos) que el render de Sphinx puede navegar de forma consistente. Los UCs no críticos pueden mantenerse como archivo único sin pérdida significativa. |
| H-T-06 | OBSERVABLE | La estimación de 5 person-days "complejidad MEDIA" en la matriz de dependencias es para **implementación**, no para **redacción de spec exhaustiva**. Distinción importante: implementar el UC con tests automatizados ≈ 5 días; producir su documentación de spec completa de 12 partes ≈ 33 días. La spec se hace una vez; la implementación se hace una vez también. Total ≈ 38 días para "UC_AUTH_01 producción + spec". |

Cero SPECULATIVE. Gate I-012 satisfecho.

----

## 8. Trazabilidad

- Template fuente: ejemplo del ejecutor con
  estructura de 12 partes (referencia).
- UC vigente:
  ``source/requisitos/casos-uso/auth/uc-auth-01-iniciar-sesion.rst``
  v4.0.0.
- Análisis hermanos en este mismo WP:
  - ``uc-auth-01-analisis-uml-06.md`` (actores,
    escenarios, beneficiarios).
  - ``uc-auth-01-analisis-uml-07.md`` (diagrama
    UC, notación, confín del sistema).
- Modelo de dominio:
  :doc:`/arquitectura-tecnica/modelo-dominio-iact`
  v1.0.0 (clases ``Session``, ``User``,
  ``InternalMailbox``, ``AuditEvent``).
- Modelo RBAC:
  :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`
  v5.4.0 (funciones AUTH).
- Matriz dependencias:
  :doc:`/arquitectura-tecnica/matriz-dependencias-uc-iact`
  v1.0.0 (criticidad, transversales, patrones de
  diseño aplicables).
- Constraints: CNST-001, CNST-002, CNST-003,
  CNST-011, CNST-025, CNST-030.
- Decisiones Z: D-01..D-11 (heredadas vinculantes).

----

## 9. Síntesis de los tres análisis del WP

Este WP cierra con tres análisis complementarios
sobre UC_AUTH_01:

| Análisis | Foco | Aporte |
|----------|------|--------|
| ``uc-auth-01-analisis-uml-06.md`` | Vista del usuario, actores, escenarios, value | Quién quiere qué y por qué |
| ``uc-auth-01-analisis-uml-07.md`` | Diagrama UC, notación, confín del sistema | Cómo se representa formalmente |
| ``uc-auth-01-analisis-template-completo.md`` (este) | Gap analysis contra template de spec completa de 12 partes | Qué falta para llegar a spec implementable |

Los tres entregables del WP son **insumo
exclusivo** del WP futuro de spec completa de
UC_AUTH_01 (cuando se abra). No redactan los
flujos detallados — eso es trabajo de ese WP
posterior.

## 10. Recomendación operativa

Antes de avanzar a UC_AUTH_04 (siguiente
CRÍTICO en la secuencia 1-de-8), **considerar**
si:

1. **Repetir el patrón de 3 análisis** (uml-06,
   uml-07, template-completo) por cada uno de
   los 8 CRÍTICOS — produce 24 documentos
   analíticos antes de cualquier spec real.
2. O **iterar diferente**: hacer los 3 análisis
   sólo de UC_AUTH_01 (ya hecho), proceder a la
   spec completa de UC_AUTH_01 (WP siguiente),
   y a partir de la experiencia decidir si el
   patrón de 3 análisis es necesario para los
   otros 7 CRÍTICOS o se puede simplificar.

Recomendación: opción 2. Aprender del primer
ciclo completo (análisis → spec) antes de
estandarizar el patrón para los 8 CRÍTICOS.
