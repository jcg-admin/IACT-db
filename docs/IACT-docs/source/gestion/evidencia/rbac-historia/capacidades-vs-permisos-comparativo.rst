.. meta::
 :artefacto: HIST_RBAC_006
 :tipo: Documento Historico
 :dominio: gestion
 :subdominio: evidencia/rbac-historia
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-01-03
 :ultimo_cambio: 2026-04-29
 :autor: Equipo IACT
 :clasificacion: Interno

.. _hist-rbac-006:

==========================================================
Capacidades Atomicas vs Permisos Granulares (Solution Rec)
==========================================================

.. note::

 **Documento historico — Solution Recommendation
 (BABOK ba-strategy output).**

 Comparativa conceptual entre los dos enfoques RBAC evaluados
 en el proyecto IACT antes de adoptar v5.x. Este documento es
 el **origen conceptual de D-RBAC-1** (vocabulario unico
 ``Funcion`` / ``Function``) que CNST-033 vigente formaliza.

 NO es spec vigente. Para spec vigente ver
 :doc:`/normativa/restricciones/cnst-033-vocabulario-unificado-rbac`.

----

1. Contexto
===========

**Fecha:** 2026-01-03.

**Proposito original:** explicar la diferencia conceptual y
practica entre dos enfoques de control de acceso:

- **Capacidades Atomicas** (RBAC Granular Puro) — enfoque
  v4.0 "Sin Pretensiones".
- **Permisos Granulares Dentro del Rol** (RBAC Hibrido) —
  enfoque legacy basado en roles.

**Resultado:** decision de adoptar el enfoque granular puro,
formalizada despues como CNST-029 (RBAC Modelo Plano) +
CNST-033 (Vocabulario Unificado).

----

2. Comparacion de los dos enfoques
==================================

.. list-table::
 :header-rows: 1
 :widths: 25 35 40

 * - Aspecto
   - Capacidades Atomicas (Granular Puro)
   - Permisos Granulares Dentro del Rol (Hibrido)
 * - Modelo
   - RBAC Granular Puro
   - RBAC Hibrido
 * - Ejemplo de referencia
   - "Sin Pretensiones" v4.0
   - Modelo IACT v4.0 tradicional (R001..R018)
 * - Unidad asignable
   - **Funcion atomica** (1 verbo + 1 sustantivo)
   - **Rol** (con N capacidades agrupadas)
 * - Granularidad
   - Maxima (cada accion es atomica)
   - Variable (depende del diseno del rol)
 * - Composicion
   - Tipo LEGO (combinable)
   - Por jerarquia de roles
 * - Auditoria
   - Directa por funcion
   - Indirecta via rol

----

3. Enfoque 1: Capacidades Atomicas (granular puro)
==================================================

3.1 Definicion
--------------

   "Una **funcion atomica** es la unidad minima asignable, que
   representa UNA sola accion sobre UN solo recurso."

::

   FUNCION ATOMICA = 1 verbo + 1 sustantivo

3.2 Arquitectura
----------------

::

   USUARIO
     |
     | tiene asignadas DIRECTAMENTE (muchas funciones individuales)
     v
   FUNCIONES ATOMICAS
   (crea_usuarios, ve_usuarios, modifica_usuarios, ve_reportes,
    exporta_csv, exporta_excel, configura_alertas, ve_auditoria, ...)
     |
     | cada funcion contiene
     v
   CAPACIDAD UNICA (1 funcion = 1 capacidad exacta)

3.3 Catalogo (ejemplo v4.0 — espanol)
-------------------------------------

::

   DOMINIO: Usuarios
     - crea_usuarios        -> usuarios:crear
     - ve_usuarios          -> usuarios:leer
     - modifica_usuarios    -> usuarios:modificar
     - elimina_usuarios     -> usuarios:eliminar
     - activa_usuarios      -> usuarios:activar
     - desbloquea_usuarios  -> usuarios:desbloquear
     - resetea_passwords    -> usuarios:reset_password

   DOMINIO: Reportes
     - ve_reportes          -> reportes:leer
     - filtra_reportes      -> reportes:filtrar
     - exporta_csv          -> reportes:exportar_csv
     - exporta_excel        -> reportes:exportar_excel
     - exporta_pdf          -> reportes:exportar_pdf
     - crea_reportes        -> reportes:crear

   DOMINIO: Alertas
     - ve_alertas           -> alertas:leer
     - configura_alertas    -> alertas:configurar
     - pausa_alertas        -> alertas:pausar
     - elimina_alertas      -> alertas:eliminar

   ... (75+ funciones en v4.0; consolidado a 42 en v5.2.1)

3.4 Ventajas del enfoque atomico
--------------------------------

- Granularidad maxima.
- Auditoria precisa.
- Componibilidad (LEGO).
- Sin etiquetas jerarquicas artificiales.
- Cumple regulaciones (SOX, ISO 27001).
- Principio de menor privilegio aplicado.

3.5 Desventajas del enfoque atomico
-----------------------------------

- Catalogo mas grande (mas filas en tabla ``functions``).
- Asignacion directa a usuarios puede ser tediosa sin bundles
  (resuelto en v5.x con AGR-001..AGR-010).

----

4. Enfoque 2: Permisos Granulares Dentro del Rol (hibrido)
==========================================================

4.1 Definicion
--------------

   "Un **rol** agrupa N capacidades. Los usuarios se asignan al
   rol, y heredan todas las capacidades del mismo."

4.2 Arquitectura
----------------

::

   USUARIO
     |
     | tiene asignado UN rol (a veces, 2-3 roles maximo)
     v
   ROL (R001 USERS_FULL_MANAGER, R016 SYSTEM_ADMIN, etc.)
     |
     | contiene N capacidades
     v
   CAPACIDAD GRANULAR
   (modificar usuario, ver permisos, asignar permisos, etc.)

4.3 Catalogo de roles (ejemplo legacy IACT v4.0 tradicional)
------------------------------------------------------------

::

   R001  USERS_FULL_MANAGER     -> 12 capacidades
   R002  USERS_VIEWER           -> 3 capacidades
   R004  REPORTS_VIEWER         -> 5 capacidades
   R005  REPORTS_EXPORTER       -> 7 capacidades
   R010  DATA_ANALYST           -> 15 capacidades
   R016  SYSTEM_ADMIN           -> 30+ capacidades
   R017  AUDIT_VIEWER           -> 4 capacidades
   R018  SECURITY_ADMIN         -> 18 capacidades
   ... (18 roles en total)

4.4 Ventajas del enfoque hibrido
--------------------------------

- Asignacion mas simple (1 rol vs N funciones).
- Menos filas en ``user_assignments``.
- Familiar para equipos que vienen de RBAC tradicional.

4.5 Desventajas del enfoque hibrido
-----------------------------------

- Auditoria indirecta ("que tiene USERS_FULL_MANAGER?" requiere
  consultar definicion del rol).
- Cambio organizacional fuerza rediseno de roles.
- Combinaciones nuevas requieren crear roles nuevos (explosion).
- Etiquetas jerarquicas (``Admin``, ``Manager``, ``Senior``)
  introducen sesgos organizacionales.
- Difiere del principio de menor privilegio.

----

5. Decision: enfoque atomico + bundles (v5.x adopta este modelo)
================================================================

El proyecto IACT adopto el **enfoque atomico** del v4.0 "Sin
Pretensiones" como fundamento, agregando una capa de **bundles**
(``AGR-001..AGR-010``) para simplificar asignacion sin sacrificar
granularidad.

Resultado en v5.2.1 vigente:

- **42 funciones atomicas** (en ingles canonico per CNST-033).
- **10 grupos predefinidos** (AGR-001..010) que agrupan funciones
  comunes para casos de uso tipicos.
- **3 reglas SoD** (SOD-001/002/003) que declaran funciones
  incompatibles.
- Sin roles jerarquicos.

----

6. Origen de D-RBAC-1 (vocabulario unico)
=========================================

Este documento es el **origen conceptual** de la decision
arquitectonica D-RBAC-1 documentada en
:doc:`/normativa/gobernanza/adr-gob-008-rbac-coexistencia-acc-perm`:

   "Vocabulario unico ``Funcion`` canonico (docs) /
   ``Function`` (codigo)."

La distincion conceptual entre "Capacidad" (atributo del
actor — vista del rol) y "Funcion" (accion atomica — vista
granular) se reconcilio adoptando "Funcion" como termino unico,
ya que describe **que hace** la operacion (action) en lugar de
**que puede** el actor (atributo).

CNST-033 vigente formaliza esta decision como restriccion
inviolable.

----

7. Cierre y trazabilidad
========================

**Documento original:**
``temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/CAPACIDADES_ATOMICAS_VS_PERMISOS_GRANULARES.rst``
(no publicado).

**Materializacion vigente:**

- :doc:`/normativa/restricciones/cnst-029-rbac-modelo-plano` —
  exige RBAC plano (granular puro).
- :doc:`/normativa/restricciones/cnst-033-vocabulario-unificado-rbac` —
  formaliza vocabulario "Funcion" / "Function".
- :doc:`/normativa/gobernanza/adr-gob-008-rbac-coexistencia-acc-perm` —
  documenta D-RBAC-1.
- :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact` —
  catalogo vigente (42 funciones + 10 grupos AGR).
