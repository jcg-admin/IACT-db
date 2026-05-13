.. meta::
 :artefacto: HIST_RBAC_002
 :tipo: Documento Historico
 :dominio: gestion
 :subdominio: evidencia/rbac-historia
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2025-10-19
 :ultimo_cambio: 2026-04-29
 :autor: Equipo IACT
 :clasificacion: Interno

.. _hist-rbac-002:

==========================================================
Modelo RBAC v4.0 — Resumen historico (predecesor de v5.x)
==========================================================

.. note::

 **Documento historico — Requirements Baseline previo.**

 Resumen narrativo del documento legacy ``Modelo RBAC Sin
 Pretensiones v4.0`` (~99 KB, octubre 2025). NO es spec
 vigente. Para spec vigente ver
 :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact` (v5.2.1).

 Documento original NO publicado en el corpus para evitar
 confusion con la spec vigente; este resumen preserva los
 conceptos relevantes para trazabilidad.

----

1. Contexto historico
=====================

**Fecha:** Octubre 2025.
**Estado original:** v4.0 FINAL (autodescrito).
**Nombre completo:** "Modelo RBAC Sin Pretensiones v4.0 — Enfoque
Granular por Funcion con Namespace".

v4.0 fue el predecesor directo de la familia v5.x del modelo RBAC
IACT. Introdujo el principio "Sin Pretensiones" que se conserva
en v5.2.1 vigente, pero divergia significativamente en:

- **Granularidad:** ~75 funciones atomicas (vs 42 en v5.2.1).
- **Namespaces:** funciones agrupadas en namespaces ``identity:``,
  ``epm:``, ``base`` (vs 8 modulos MOD_* en v5.2.1).
- **Bundles:** 10 predefinidos (origen conceptual de los AGR-001..010).
- **Vocabulario:** "Personas", "Funciones", "Capacidades" (espanol;
  v5.2.1 normaliza a ``Function`` ingles via CNST-033).

----

2. Filosofia documentada en v4.0
================================

Principio central preservado en v5.x:

   "Los nombres de funciones describen QUE HACE la funcion, no
   QUIEN es la persona o QUE titulo tiene."

Razones del enfoque granular:

1. Seguridad maxima (principio de menor privilegio).
2. SoD posible (separar funciones conflictivas).
3. Auditoria precisa (saber exactamente que puede hacer cada quien).
4. Escalabilidad (crece sin refactorizar).
5. Cumplimiento (SOX, ISO 27001).
6. Flexibilidad (componible como LEGO).

----

3. Arquitectura v4.0 (resumen)
==============================

Modelo de entidades:

::

   Usuario (persona del sistema)
      |
      | tiene asignadas (UA - User Assignment)
      |
      v
   Funcion (granular, con namespace opcional)
      |
      | contiene (PA - Permission Assignment)
      |
      v
   Capacidad (permiso atomico)
      |
      | sobre
      |
      v
   Recurso:Operacion

Capa adicional v4.0 NO presente en v5.2.1:

- **Bundles** (10 predefinidos) — origen conceptual de los
  agrupadores AGR-001..AGR-010 vigentes.
- **Namespaces** (``identity:``, ``epm:``, ``base``) — eliminados
  en v5.x a favor de modulos planos (MOD_*).

----

4. Sistema de nomenclatura v4.0
===============================

v4.0 documentaba una estructura con namespace:

- ``identity:gestiona_aplicaciones``
- ``epm:agrega_miembros``
- ``crea_facturas`` (sin namespace para funciones base)

v5.2.1 elimina los namespaces y separa por modulo flat:

- ``manage_applications`` (en MOD_Auth, equivalente)
- ``add_members`` (en MOD_Users)
- ``create_invoices`` (en MOD_Reports si aplica)

----

5. Catalogo v4.0 (alto nivel)
=============================

v4.0 listaba ~75 funciones distribuidas en:

.. list-table::
 :header-rows: 1
 :widths: 30 70

 * - Categoria v4.0
   - Cantidad aprox / dominio
 * - Funciones base del sistema
   - Capacidades base + finanzas + desarrollo + contenido + clientes + administracion
 * - Funciones Oracle Identity (``identity:``)
   - Aplicaciones, auditoria, autenticacion, passwords, usuarios, dominio, autogestion, registro
 * - Funciones EPM Automate (``epm:``)
   - Ambiente, grupos, archivos
 * - Operaciones masivas
   - Bulk operations
 * - Restricciones SSD
   - Static Separation of Duties
 * - Bundles
   - 10 predefinidos (origen conceptual de AGR-001..010)

----

6. Predecesor de v4.0 — modelo de roles tradicional R001..R018
==============================================================

Antes de v4.0 "Sin Pretensiones" existio un modelo basado en
**roles jerarquicos numerados R001..R018** mencionado en:

- :doc:`/base-cognitiva/_fundamentos-conceptuales/fnd-06-derivacion-vs-transformacion`
- :doc:`/base-cognitiva/_ontologia-sbvr/sbvr-01-conceptos-nucleares`

Ejemplos de roles R001..R018 legacy:

- R001 ``USERS_FULL_MANAGER``
- R002 ``USERS_VIEWER``
- R004 ``REPORTS_VIEWER``
- R005 ``REPORTS_EXPORTER``
- R010 ``DATA_ANALYST``
- R016 ``SYSTEM_ADMIN``
- R017 ``AUDIT_VIEWER``
- R018 ``SECURITY_ADMIN``

Problemas de este enfoque que motivaron v4.0 "Sin Pretensiones":

- Etiquetas jerarquicas (``Admin``, ``Manager``, ``Senior``) no
  describen capacidades, solo titulo organizacional.
- Cambio de estructura organizacional fuerza cambio de roles.
- Combinaciones nuevas requieren crear roles nuevos (explosion).
- Auditoria difusa: "que puede hacer R016?" requiere consultar
  definicion del rol.

v4.0 elimino estos roles a favor de funciones granulares; v5.x
preservo el principio y simplifico el catalogo a 42 funciones +
10 grupos predefinidos.

----

7. Diferencias clave v4.0 vs v5.2.1 vigente
===========================================

.. list-table::
 :header-rows: 1
 :widths: 25 35 40

 * - Aspecto
   - v4.0 (legacy)
   - v5.2.1 (vigente)
 * - Funciones atomicas
   - ~75 con namespace
   - **42 sin namespace** (8 modulos MOD_*)
 * - Idioma de funciones
   - Espanol (``crea_facturas``)
   - **Ingles** (``create_invoices``) — CNST-033
 * - Agrupacion
   - Bundles (10 predefinidos)
   - **AGR-001..AGR-010** (10 grupos)
 * - Namespaces
   - Si (``identity:``, ``epm:``, ``base``)
   - **No** (modulos flat)
 * - SoD
   - SSD con cardinalidad
   - **3 reglas SOD-001/002/003**
 * - Vocabulario
   - "Personas, Funciones, Capacidades"
   - **"Funcion / Function"** unico canonico (CNST-033)

----

8. Que se recupero en v5.x
==========================

- Principio "Sin Pretensiones" (sin etiquetas jerarquicas).
- Granularidad funcional.
- SoD declarativo.
- Bundles -> AGR-001..010.
- Auditoria explicita por funcion.

----

9. Que se elimino en v5.x
=========================

- Namespaces (``identity:``, ``epm:``).
- Funciones en espanol.
- Distincion "Personas" vs "Usuarios" (unificado a "Usuarios").
- Restricciones SSD con cardinalidad (simplificado a 3 reglas
  declarativas).

----

10. Cierre y trazabilidad
=========================

**Documento original:**
``temp-holding/RBAC/Modelo RBAC Sin Pretensiones v4.0.txt``
(~99 KB, no publicado).

**Documento sucesor publicado:**
:doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact` (v5.2.1).

**Decision arquitectonica que reconcilio las vistas (v4.0 ->
v5.x):**
:doc:`/normativa/gobernanza/adr-gob-008-rbac-coexistencia-acc-perm`.

**Restriccion normativa que canonizo el vocabulario:**
:doc:`/normativa/restricciones/cnst-033-vocabulario-unificado-rbac`.

**Comparacion formal v4.0 vs BR IACT:**
:doc:`/gestion/evidencia/rbac-historia/analisis-comparativo-rbac-v4-vs-br-iact`.
