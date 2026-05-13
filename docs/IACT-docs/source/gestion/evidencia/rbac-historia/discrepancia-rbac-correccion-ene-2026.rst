.. meta::
 :artefacto: HIST_RBAC_005
 :tipo: Documento Historico
 :dominio: gestion
 :subdominio: evidencia/rbac-historia
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-01-03
 :ultimo_cambio: 2026-04-29
 :autor: Equipo IACT
 :clasificacion: Interno

.. _hist-rbac-005:

==============================================================
Discrepancia RBAC y Propuesta de Correccion (Enero 2026)
==============================================================

.. note::

 **Documento historico — Change Impact Assessment.**

 Documenta cuando se detecto que las BRs usaban enfoque
 tradicional basado en roles (R001..R018) cuando el proyecto
 requeria enfoque funcional granular. Origen del trabajo de
 reescritura BR_006 + BR_007. NO es spec vigente — para
 vigente ver :doc:`/requisitos/reglas-negocio/br-006-rbac-flat-nist`
 y :doc:`/requisitos/reglas-negocio/br-007-separacion-funciones-sod`.

----

1. El problema detectado
========================

**Fecha:** 2026-01-03.

Las BR creadas inicialmente usaban **enfoque tradicional basado
en roles**:

::

   BR_006 definia 18 roles:
   - R001 USERS_FULL_MANAGER
   - R002 USERS_VIEWER
   - R004 REPORTS_VIEWER
   - R005 REPORTS_EXPORTER
   - R010 DATA_ANALYST
   - R016 SYSTEM_ADMIN
   - R017 AUDIT_VIEWER
   - R018 SECURITY_ADMIN

Problemas del enfoque incorrecto:

- Basado en titulos/cargos organizacionales.
- No describe QUE PUEDE HACER cada rol.
- Cambio de estructura organizacional requiere cambiar roles.
- Dificil de auditar (``que permisos tiene USERS_FULL_MANAGER?``).
- No es granular ni componible.

----

2. Lo que se requeria (correcto)
================================

El proyecto IACT requeria **enfoque funcional granular** segun
documento v4.0 "Sin Pretensiones":

::

   Funciones granulares (en ese momento, en espanol):
   - crea_usuarios
   - modifica_usuarios
   - elimina_usuarios
   - ve_usuarios
   - asigna_funciones
   - revoca_funciones
   - ve_reportes
   - exporta_reportes_csv
   - exporta_reportes_excel
   - configura_alertas
   - ve_auditoria

Ventajas del enfoque correcto:

- Describe QUE PUEDE HACER cada funcion.
- Titulos organizacionales no afectan el modelo.
- Escalable y componible (como LEGO).
- Facil de auditar.
- Cumple regulaciones (SOX, ISO 27001).
- Principio de menor privilegio aplicado.

----

3. Impacto en BR existentes (enero 2026)
========================================

3.1 BRs que requirieron REESCRITURA COMPLETA
--------------------------------------------

.. list-table::
 :header-rows: 1
 :widths: 15 35 50

 * - BR
   - Estado Actual
   - Problema
 * - BR_006
   - 18 roles tradicionales
   - Debe ser catalogo de funciones granulares
 * - BR_007
   - SoD entre roles
   - Debe ser SoD entre funciones

3.2 BRs que requirieron AJUSTES MENORES
---------------------------------------

.. list-table::
 :header-rows: 1
 :widths: 15 35 50

 * - BR
   - Estado Actual
   - Ajuste Necesario
 * - BR_008
   - Permisos directos
   - Cambiar terminologia rol -> funcion
 * - BR_011
   - Limites por rol
   - Cambiar a limites por funcion/bundle
 * - BR_012
   - Usuario-Segmento
   - OK — no depende de roles

3.3 BRs que NO requirieron cambios
----------------------------------

BRs sobre temas no-RBAC: BR_001 (fuente operacional),
BR_002 (ETL nocturno), BR_004 (comunicaciones internas),
BR_010 (auditoria inmutable), entre otras.

----

4. Estado vigente de las BR RBAC
================================

Las BR mencionadas en este documento ya fueron reescritas a la
version vigente del corpus IACT-docs:

.. list-table::
 :header-rows: 1
 :widths: 25 75

 * - BR vigente
   - Estado
 * - :doc:`/requisitos/reglas-negocio/br-006-rbac-flat-nist`
   - Reescrito con enfoque NIST RBAC Flat (Level 0)
 * - :doc:`/requisitos/reglas-negocio/br-007-separacion-funciones-sod`
   - Reescrito con SoD entre funciones (3 reglas SOD-001/002/003)
 * - :doc:`/requisitos/reglas-negocio/br-012-usuario-segmento-unico`
   - Sin cambios

----

5. Cierre y trazabilidad
========================

**Documento original:**
``temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/DISCREPANCIA_RBAC_Y_PROPUESTA_CORRECCION.rst``
(no publicado).

**Materializacion vigente:**

- Modelo conceptual: :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`
- Vocabulario canonico: :doc:`/normativa/restricciones/cnst-033-vocabulario-unificado-rbac`
- Coexistencia ACC + PERM: :doc:`/normativa/gobernanza/adr-gob-008-rbac-coexistencia-acc-perm`

**Notas:**

- El uso de ``ve_*``, ``crea_*``, ``exporta_*`` (espanol) en este
  documento se corrigio posteriormente en v5.2.1 a ``view_*``,
  ``create_*``, ``export_*`` (ingles). Ver
  :doc:`/gestion/evidencia/rbac-historia/analisis-errores-modelo-rbac-v5-2-0`.

- La introduccion de los 18 roles R001..R018 quedo descartada
  formalmente. Ver
  :doc:`/gestion/evidencia/rbac-historia/modelo-rbac-v4-0-roles-jerarquicos-deprecado`.
