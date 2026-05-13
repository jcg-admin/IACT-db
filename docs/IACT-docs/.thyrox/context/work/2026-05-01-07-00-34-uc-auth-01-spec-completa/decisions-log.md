```yml
created_at: 2026-05-01 07:00:34
project: IACT-docs
work_package: 2026-05-01-07-00-34-uc-auth-01-spec-completa
phase: Phase 7 — DESIGN/SPECIFY
author: NestorMonroy
status: Activo (decisiones agregadas conforme se toman en el loop)
version: 1.0.0
language: es
```

# Decisions Log — UC_AUTH_01 Spec Completa

> Bitácora de decisiones tomadas autónomamente
> durante la producción de la spec de 12 partes.
> Cada decisión queda anclada a su origen (WP
> predecesor, modelo canónico, CNST vigente,
> etc.).

## DEC-A01 — Estructura: Propuesta A (directorio + 13 archivos)

- **Fuente:** ``uc-auth-01-analisis-template-completo.md``
  § 5 Propuesta A.
- **Decisión:** crear
  ``source/requisitos/casos-uso/auth/uc-auth-01/``
  con ``index.rst`` + 12 archivos de parte
  (``01-informacion-general.rst`` ..
  ``12-testing.rst``).
- **Razón:** alineado con la directiva del
  ejecutor *"no todo va en el mismo archivo"*;
  archivos ≤ 500 líneas; edición concurrente
  posible; navegación por toctree de Sphinx.

## DEC-A02 — Eliminar archivo monolítico v4.0.0

- **Fuente:** D-T02 del WP predecesor.
- **Decisión:** ``git rm`` de
  ``source/requisitos/casos-uso/auth/uc-auth-01-iniciar-sesion.rst``
  v4.0.0 al cierre del WP. El nuevo directorio
  reemplaza completamente el contenido.
- **Razón:** evitar duplicación de spec del
  mismo UC. La trazabilidad se conserva en git
  history.

## DEC-A03 — Mapeo CNST canónico vigente

- **Fuente:** ``source/normativa/restricciones/``
  (lectura directa al inicio de este WP).
- **Decisión:** corregir el mapeo CNST aplicado
  en mis análisis previos del WP predecesor.
  El mapeo canónico es:
  - **CNST-001** = Prohibición de email y SMTP
  - **CNST-002** = Buzón interno obligatorio
  - **CNST-003** = Sesiones persistidas en BD
  - **CNST-004** = Sesión única por usuario
  - **CNST-005** = Timeout de sesión 15 min
  - **CNST-009** = Autenticación DRF obligatoria
  - **CNST-011** = Throttling endpoints públicos
  - **CNST-013** = Manejo estandarizado excepciones DRF
  - **CNST-025** = Auditoría inmutable append-only
- **Razón:** el corpus canónico vive en
  ``source/normativa/restricciones/``;
  desviaciones en otros documentos son deuda
  técnica.

## DEC-A04 — Identifiers EN, prosa ES

- **Fuente:** decisión del ejecutor 2026-05-01 +
  NOM_001 § 2.3.
- **Decisión:**
  - Clases del dominio (``User``, ``Session``,
    ``AuditEvent``, ``InternalMailbox``):
    inglés PascalCase.
  - Funciones RBAC (``view_own_sessions``,
    ``acknowledge_alert``): inglés snake_case.
  - Atributos: snake_case inglés cuando son
    identificadores formales (``user_id``,
    ``state``, ``last_activity_at``).
  - Prosa, comentarios PlantUML, notas: español.
- **Razón:** consistencia con modelo-rbac-iact
  v5.4.0 + modelo-dominio-iact v1.0.0.

## DEC-A05 — AGR canónicos en inglés

- **Fuente:** ``modelo-rbac-iact.rst`` v5.4.0
  líneas 1090-1135 + H-A06-06 del WP predecesor.
- **Decisión:** los 10 AccessGroups se citan con
  sus nombres canónicos en inglés
  (``basic_operator_group``, ``user_admin_group``,
  ``permission_admin_group``, etc.). Los nombres
  españoles residuales (``agr_admin_usuarios``,
  etc.) son deuda técnica de otros UCs y no se
  perpetúan en este spec.

## DEC-A06 — Diagrama UC: corregido per H-A07-01

- **Fuente:** H-A07-01 del WP predecesor.
- **Decisión:** el diagrama de caso de uso
  (Parte 8 § 8.1) muestra UC_AUTH_01 como una
  sola elipse, no 5 (Validar Credenciales,
  Generar Tokens, etc. son sub-pasos del flujo,
  no UCs separados). Los sub-pasos viven en el
  diagrama de secuencia (Parte 8 § 8.2).
- **Razón:** UML_07 (uml-07-diagramas-casos-uso)
  desaconseja modelar sub-pasos como UCs en el
  diagrama UC.

## DEC-A07 — Auditor como actor secundario explícito

- **Fuente:** H-A07-02 del WP predecesor.
- **Decisión:** el diagrama UC y la sección 2.2
  Actores Secundarios incluyen al Auditor
  explícitamente como beneficiario del evento
  AuditEvent ``LOGIN`` (CNST-025).
- **Razón:** el diagrama vigente lo omitía pese
  a CNST-025 declararlo beneficiario.

## DEC-A08 — Flujo alterno FA-03 nuevo

- **Fuente:** análisis uml-06 § 4.2 + CNST-004.
- **Decisión:** agregar FA-03 *"Sesión previa
  activa cerrada por CNST-004"* a Parte 4. El
  UC vigente sólo contemplaba FA-01 y FA-02; el
  comportamiento de invalidación de sesión
  anterior al iniciar una nueva (CNST-004
  sesión única) merece ser flujo alterno
  documentado.
- **Razón:** completitud per template de 12
  partes.

## DEC-A09 — EX-06 y EX-07 nuevas

- **Fuente:** análisis template-completo § 3
  (Parte 5).
- **Decisión:** agregar EX-06 *"BD timeout
  durante validación"* y EX-07 *"InternalMailbox
  service offline al recovery"* a Parte 5. El
  UC vigente sólo cubría 5 excepciones.
- **Razón:** completitud per template +
  resiliencia documentada.

## DEC-A10 — Cifras concretas en ADR no en UC

- **Fuente:** D-T03 del WP predecesor + Z.2 D-08.
- **Decisión:** Parte 6 (RNF) cita constraints
  abstractas (CNST-005 timeout sesión, CNST-011
  throttling) sin cifras embebidas. Las cifras
  concretas (15 min, 5 intentos / 5 min, etc.)
  viven en los CNST mismos y en futuros ADRs
  de implementación.
- **Razón:** mantener UC al nivel funcional;
  cifras de performance/seguridad cambian sin
  invalidar el UC.

## DEC-A11 — Mensaje específico en EX-03/EX-04 vs anti-enumeración

- **Fuente:** análisis del trade-off seguridad ↔
  usabilidad mientras redactaba Parte 5.
- **Decisión:** EX-01 y EX-02 retornan
  ``error_code = INVALID_CREDENTIALS`` genérico
  (anti-enumeración de usernames). EX-03
  (cuenta bloqueada) y EX-04 (cuenta inactiva)
  retornan ``ACCOUNT_BLOCKED`` y
  ``ACCOUNT_INACTIVE`` específicos para que el
  usuario sepa qué hacer.
- **Razón:** el orden de validación expone la
  existencia del usuario antes de verificar
  password (paso 8 antes de paso 9), por lo
  que el anti-enumeración ya está parcialmente
  comprometido en estos dos casos. El beneficio
  de usabilidad supera al costo marginal de
  exposición.

## DEC-A12 — InternalMailbox failure no bloquea login

- **Fuente:** EX-08 detectado al redactar
  Parte 5.
- **Decisión:** si InternalMailbox falla al
  intentar dejar mensaje "tu sesión en otro
  dispositivo se cerró" (FA-03), el login
  procede con éxito. La pérdida del mensaje al
  usuario en el otro dispositivo se acepta.
- **Razón:** la prioridad es el flujo principal;
  fallas best-effort de notificación no deben
  bloquear acceso.

## DEC-A13 — Naming sin prefijos numéricos en archivos

- **Fuente:** ``.claude/rules/convention-naming.md``
  + corrección del ejecutor (2026-05-01) tras
  detección de violación.
- **Decisión:** los 12 archivos de partes en
  ``source/requisitos/casos-uso/auth/uc-auth-01/``
  se nombran con kebab-case descriptivo sin
  prefijo numérico:
  - ``informacion-general.rst``
  - ``actores-precondiciones.rst``
  - ``flujo-principal.rst``
  - ``flujos-alternos.rst``
  - ``excepciones.rst``
  - ``requisitos-no-funcionales.rst``
  - ``datos-involucrados.rst``
  - ``diagramas-uml.rst``
  - ``criterios-aceptacion.rst``
  - ``patrones-diseno.rst``
  - ``implementacion-tecnica.rst``
  - ``testing.rst``
- **Razón:** la convención del proyecto
  prohíbe prefijos numéricos. El orden lo
  impone el ``toctree`` en ``index.rst`` (que
  preserva el orden declarado), no el nombre
  de archivo. Aplica a los **61 UCs** cuando
  se conviertan a estructura de directorio.

## Decisiones futuras

Esta bitácora se actualiza durante la
producción de las 12 partes con cualquier
decisión adicional que surja en el camino.
