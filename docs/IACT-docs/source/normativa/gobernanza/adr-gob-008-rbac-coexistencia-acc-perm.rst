.. meta::
 :artefacto: ADR_GOB_008_rbac_coexistencia_acc_perm
 :tipo: ADR
 :dominio: normativa
 :subdominio: gobernanza
 :estado: Aceptada
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-29
 :autor: NestorMonroy
 :clasificacion: Critico

.. _adr_gob_008_rbac_coexistencia_acc_perm:

==============================================================
ADR-GOB-008: RBAC Coexistencia Vista Funcional ↔ Vista Tecnica
==============================================================

**Estado:** Aceptada **Fecha:** 2026-04-29 **Decisor:** Equipo
Arquitectura **Relacionado:** Hipotesis 1 del WP #6 requisitos,
decisiones D-RBAC-1..8, CNST_029, CNST_032, CNST_033

----

Contexto
--------

El sistema IACT tiene dos representaciones del modelo RBAC que
coexisten en el codebase actual y que requieren reconciliacion
formal:

**Vista funcional (MOD_Access — modelo conceptual v5.2.1):**

- Documentada en `:doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact``.
- Catalogo cerrado: 42 funciones atomicas + 10 grupos predefinidos
  AGR-001..AGR-010 + 3 reglas SoD.
- Vocabulario: "Funcion", "Grupo predefinido", "Agrupador".
- Casos de uso: UC_ACC_01..UC_ACC_09 (admin no-tech asigna
  agrupadores predefinidos al usuario).

**Vista tecnica (MOD_Permissions — sistema PERM granular):**

- Implementacion backend con 8 modelos Django, 5 funciones
  SQL nativas (incluida ``obtener_menu_usuario``), 2 vistas SQL,
  3 migraciones.
- Modelo flexible: grupos creables dinamicamente, capacidades
  granulares, permisos excepcionales, runtime check, menu dinamico.
- Vocabulario en codigo: "Capacidad", "GrupoPermiso",
  "PermisoExcepcional", "AuditoriaPermiso".
- Casos de uso: UC_PERM_01..UC_PERM_10.

Problema
--------

Sin un ADR formal, ambas vistas crecen en paralelo con vocabularios
distintos, causando:

- Drift de terminologia ("Capacidad" vs "Funcion") entre docs y
  codigo.
- Duplicacion conceptual aparente (UC_ACC_01 Asignar Funciones vs
  UC_PERM_01 Asignar Grupo).
- Doble auditoria sin gobernanza clara
  (UC_ACC_09 vs UC_PERM_09 vs UC_AUD_*).
- Incertidumbre sobre cual vista es canonica para nuevos UCs.

Alternativas Consideradas
-------------------------

**Alternativa A — Coexistencia (Hipotesis 1)**

Las dos vistas coexisten con propositos distintos:

- MOD_Access = vista para admin no-tech (catalogo cerrado de
  agrupadores predefinidos).
- MOD_Permissions = vista para admin tech / runtime (grupos
  creables, verificacion runtime, menu dinamico).

Preserva los 9 UCs canonicos del backup + agrega los 10 UCs PERM.
Vocabulario unificado a "Funcion" (canonico) via CNST_033.

**Alternativa B — Evolucion limitada (Hipotesis 2)**

PERM absorbe RBAC_CORE de Access. UC_ACC_01..04 se marcan
``deprecated`` con redirect a UC_PERM_*. MOD_Access queda reducido
a SoD + Segmentos + Permisos Temporales (4 UCs).

**Alternativa C — Evolucion total (Hipotesis 3)**

PERM reemplaza completamente Access. Los 9 UC_ACC desaparecen del
catalogo o se marcan obsoletos.

Decision
--------

**Alternativa seleccionada: A — COEXISTENCIA**

Justificacion:

1. Los 49 UCs canonicos del backup (8 modulos) son **fuente de verdad
   confirmada** con metadata ``:version: 4.0.0`` declarada. No hay
   ADR previo que los invalide.
2. Los 10 UC_PERM tienen contenido sustantivo (1 894 lineas en
   total) con frontmatter formal. Son las **especificaciones de la
   implementacion backend ya construida** (estado de avance documentado en el documento interno de GAP analysis, fuera del scope de este ADR).
3. Las dos vistas reflejan **dos perfiles reales de admin** del
   sistema:

   - Admin no-tech (RH, ops): asigna agrupadores predefinidos.
   - Admin tech (DevSecOps): crea grupos custom, define capacidades
     finas.

4. La duplicacion aparente se mitiga con vocabulario unificado
   (CNST_033) y referencias cruzadas explicitas en cada UC afectado
   (deuda diferida).
5. Zero rework sobre los .rst canonicos del backup — preserva
   trazabilidad documental.

Consecuencias
-------------

**Positivas:**

- Cobertura maxima de UCs (49 + 10 = 59 documentados).
- Refleja la realidad del backend implementado (PERM ya existe).
- Dos perfiles de admin diferenciados con UX adecuado a cada uno.
- Permite evolucion futura: si se confirma que admin no-tech ya no
  usa MOD_Access, se puede migrar a Alternativa B sin perdida.

**Negativas:**

- Mas UCs para mantener (~59 vs 49 en Hipotesis 3).
- Doble auditoria (UC_ACC_09 + UC_PERM_09 + UC_AUD_*) — mitigacion:
  cada uno tiene foco distinto declarado.
- Dos terminos en codigo legacy ("Funcion" v5.2.1 vs "Capacidad"
  PERM) — mitigacion: migracion en codigo a "Function" canonico
  (D-RBAC-2 + D-RBAC-8).

**Riesgos identificados:**

- **R-1:** Drift de vocabulario si CNST_033 no se enforce. Mitigacion:
  linter en CI + code review checklist.
- **R-2:** Lectores nuevos confusos sobre cuando usar ACC vs PERM.
  Mitigacion: este ADR + glosario canonico § H +
  ``rbac-formalization.rst`` .
- **R-3:** Triple auditoria duplica datos. Mitigacion: cada UC
  declara su FUENTE DE VERDAD para el evento auditado, sin
  duplicacion.

Mitigaciones Aplicadas
----------------------

Tras esta decision, los siguientes artefactos fueron creados o
actualizados:

- :doc:`/normativa/restricciones/cnst-032-menu-dinamico-obligatorio`
  — formaliza requisito CORE de PERM (D-RBAC-5).
- :doc:`/normativa/restricciones/cnst-033-vocabulario-unificado-rbac`
  — fija vocabulario canonico "Funcion" (D-RBAC-1, D-RBAC-6).
- :doc:`/normativa/restricciones/cnst-029-rbac-modelo-plano`
  enriquecido con catalogo de los 10 grupos AGR-001..010 +
  distincion system vs custom (D-RBAC-4).
- :doc:`/normativa/restricciones/cnst-030-reglas-de-separacion-de-funciones-sod`
  enriquecido con las 3 reglas SoD declaradas (SOD-001/002/003) y
  aplicabilidad a custom groups (D-RBAC-7).
- :doc:`/base-cognitiva/glosario` § H "Vocabulario RBAC unificado"
  agrega los 8 terminos canonicos.
- :doc:`/base-cognitiva/_taxonomias-y-metamodelos/metamodelos/mtm-03-metamodelo-rbac`
  corregido (drift "18 roles" v4.0 legacy → "42 funciones + 10 grupos"
  v5.2.x).

Implementacion
--------------

**Acciones requeridas (cascada de iteraciones):**

1. **iteracion correspondiente** (CERRADO 2026-04-29): MTM_03 fix + glosario unificado.
2. **iteracion correspondiente** (CERRADO 2026-04-29): CNST_032 + CNST_033 +
   enriquecimiento CNST_029/030.
3. **iteracion correspondiente** (este ADR): ADR-GOB-008 oficializa la coexistencia.
4. **iteracion correspondiente** (en curso): cross-refs UC_ACC ↔ UC_PERM + mapeo refs
   CNST en bodies + Capacidad → Funcion.
5. **WP #7** (pendiente): migrar `:doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`` a
   ``source/arquitectura_tecnica/rbac/`` para que sea consultable.
6. **Codigo backend**: migracion ``Capacidad`` → ``Function``
   (D-RBAC-2 + D-RBAC-8) — fuera de scope del rebuild documental.

Decisiones Relacionadas
-----------------------

.. list-table::
 :widths: 20 80
 :header-rows: 1

 * - Decision
   - Resolucion
 * - D-RBAC-1
   - Vocabulario unico "Funcion" canonico (docs) / "Function" (codigo)
 * - D-RBAC-2
   - UsuarioGrupo unificacion (rename ALTER TABLE)
 * - D-RBAC-3
   - AuditoriaPermiso vs AuditLog — tablas separadas
 * - D-RBAC-4
   - Grupos: system inmutables (AGR-001..010) + custom creables
 * - D-RBAC-5
   - Crear CNST_032 Menu Dinamico Obligatorio
 * - D-RBAC-6
   - Crear CNST_033 Vocabulario Unificado RBAC
 * - D-RBAC-7
   - SoD aplica tambien a custom groups
 * - D-RBAC-8
   - Migracion Capacidad → Function: reemplazo total

Trazabilidad
------------

- WP #6 ``analyze/rbac-formalization.rst`` — modelo formal completo.
- WP #6 ``analyze/hipotesis-1-coexistencia.rst`` — hipotesis aprobada.
- WP #6 ``analyze/uc-modular-architecture-final.rst`` — comparacion
  de las 3 hipotesis.
- WP padre ``track/cross-wp-deep-audit-2026-04-29.rst`` — audit que
  detecto la falta de este ADR (G-1).

Historial
---------

.. list-table::
 :widths: 12 15 25 48
 :header-rows: 1

 * - Version
   - Fecha
   - Autor
   - Cambios
 * - 1.0.0
   - 2026-04-29
   - NestorMonroy
   - Version inicial. ADR creado en iteracion correspondiente tras decision
     arquitectonica del WP #6 (Hipotesis 1 — Coexistencia).
