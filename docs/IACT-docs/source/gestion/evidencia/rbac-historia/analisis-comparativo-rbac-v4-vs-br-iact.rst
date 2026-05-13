.. meta::
 :artefacto: HIST_RBAC_007
 :tipo: Documento Historico
 :dominio: gestion
 :subdominio: evidencia/rbac-historia
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-01-03
 :ultimo_cambio: 2026-04-29
 :autor: Equipo IACT
 :clasificacion: Interno

.. _hist-rbac-007:

================================================================
Analisis Comparativo — Modelo RBAC v4.0 vs BR IACT (Genealogia)
================================================================

.. note::

 **Documento historico — Genealogia del modelo RBAC.**

 Comparacion formal entre el documento "Modelo RBAC Sin
 Pretensiones v4.0" (octubre 2025) y las Business Rules RBAC
 creadas inicialmente para IACT. Documenta la genealogia del
 modelo y los gaps que motivaron la evolucion a v5.x.

 NO es spec vigente. Para spec vigente ver
 :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact` y las BR
 vigentes en :doc:`/requisitos/reglas-negocio/index`.

----

1. Contexto
===========

**Fecha:** 2026-01-03.

**Documentos analizados:**

- ``Modelo_RBAC_Sin_Pretensiones_v4_0.txt`` (octubre 2025).
- ``BR_005_Sesion_Unica.rst``
- ``BR_006_RBAC_Flat_NIST.rst``
- ``BR_007_Separacion_Funciones_SoD.rst``
- ``BR_008_Permisos_Vencimiento.rst``
- ``BR_009_Bajas_Logicas.rst``
- ``BR_012_Usuario_Segmento_Unico.rst``
- ``BR_013_Username_Unico.rst``
- ``BR_015_Bloqueo_Intentos_Fallidos.rst``

----

2. Hallazgos principales
========================

.. list-table::
 :header-rows: 1
 :widths: 22 28 28 22

 * - Aspecto
   - Documento v4.0
   - BR IACT (entonces)
   - Estado
 * - Modelo Base
   - RBAC Granular con Namespace
   - RBAC Flat NIST Level 0
   - DIVERGENCIA
 * - Terminologia
   - Personas, Funciones, Capacidades
   - Usuarios, Roles, Permisos
   - DIFERENTE
 * - Herencia
   - Sin herencia (explicita)
   - Sin herencia (explicita)
   - CONSISTENTE
 * - SoD
   - Estatico (SSD) con cardinalidad
   - Estatico simple
   - PARCIAL
 * - Granularidad
   - 75+ funciones atomicas
   - 18 roles cerrados
   - DIFERENTE
 * - Bundles
   - Si (10 predefinidos)
   - No implementado
   - GAP
 * - Namespace
   - Si (identity, epm, base)
   - No (catalogo plano)
   - GAP

----

3. Conclusion del analisis original
===================================

   "El documento 'Modelo RBAC Sin Pretensiones v4.0' presenta un
   modelo **mas avanzado y granular** que el implementado en las
   BR de IACT. Hay conceptos valiosos que podrian incorporarse,
   pero tambien hay razones validas para mantener el modelo
   simplificado de IACT."

----

4. Resolucion historica
=======================

El analisis identifico que el modelo IACT debia evolucionar hacia
el enfoque granular de v4.0. La evolucion ocurrio en cascada:

1. **Enero 2026** — Reescritura de BR_006 + BR_007 con enfoque
   funcional granular (ver
   :doc:`/gestion/evidencia/rbac-historia/discrepancia-rbac-correccion-ene-2026`).
2. **Enero 2026** — Generacion del modelo v5.x (8 modulos
   funcionales — ver
   :doc:`/gestion/evidencia/rbac-historia/decisiones-modulos-8-vs-9-historico`).
3. **Enero 2026** — Correccion v5.2.0 -> v5.2.1 (vocabulario en
   ingles canonico — ver
   :doc:`/gestion/evidencia/rbac-historia/analisis-errores-modelo-rbac-v5-2-0`).
4. **Abril 2026** — ADR-GOB-008 reconcilia coexistencia ACC + PERM
   y formaliza CNST-033 vocabulario unificado.

----

5. Gaps en BR IACT (entonces) respecto a v4.0
=============================================

- Falta de bundles (resuelto en v5.x con AGR-001..010).
- Falta de namespace (descartado en v5.x — modulos planos MOD_*
  son suficientes).
- Granularidad insuficiente (resuelto: 18 roles -> 42 funciones).
- SoD estatico sin cardinalidad (resuelto: 3 reglas declarativas
  SOD-001/002/003).

----

6. Fortalezas de BR IACT sobre v4.0
===================================

- Foco en restricciones operativas (sesion unica, bloqueo
  intentos).
- Integracion con auditoria y bajas logicas.
- BR explicitas en lugar de implicitas.

----

7. Inconsistencias detectadas
=============================

7.1 Terminologia
----------------

::

   v4.0:    "Personas" + "Funciones" + "Capacidades"
   BR IACT: "Usuarios" + "Roles" + "Permisos"

Resolucion vigente (CNST-033):

::

   "Usuarios" + "Funciones" (Function en codigo) + "Grupos de Funciones"

7.2 Cantidad de roles/funciones
-------------------------------

::

   v4.0:    75+ funciones atomicas
   BR IACT: 18 roles cerrados (R001..R018)

Resolucion vigente (v5.2.1):

::

   42 funciones atomicas + 10 grupos predefinidos AGR-001..010

7.3 Restricciones SoD
---------------------

::

   v4.0:    SSD con cardinalidad (de N permisos, max k al mismo usuario)
   BR IACT: SoD simple (parejas incompatibles)

Resolucion vigente:

::

   3 reglas declarativas SOD-001/002/003 (CNST-030)

----

8. Recomendaciones del analisis original (estado vigente)
=========================================================

8.1 Cambios sugeridos a BR existentes — ESTADO ACTUAL
-----------------------------------------------------

.. list-table::
 :header-rows: 1
 :widths: 25 25 50

 * - BR
   - Sugerencia 2026-01
   - Estado vigente 2026-04
 * - BR_006
   - Reescribir con funciones granulares
   - **Cerrado** — :doc:`/requisitos/reglas-negocio/br-006-rbac-flat-nist`
 * - BR_007
   - Reescribir SoD entre funciones
   - **Cerrado** — :doc:`/requisitos/reglas-negocio/br-007-separacion-funciones-sod`
 * - BR_008
   - Cambiar terminologia rol -> funcion
   - **Pendiente** — el corpus vigente conserva BR_008 con vocabulario actualizado
 * - BR_011
   - Limites por funcion/bundle
   - Diferido

8.2 Nuevos artefactos sugeridos — ESTADO ACTUAL
-----------------------------------------------

.. list-table::
 :header-rows: 1
 :widths: 35 65

 * - Artefacto sugerido 2026-01
   - Estado vigente 2026-04
 * - Catalogo de bundles
   - **Cerrado** — 10 grupos AGR-001..AGR-010 en :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact` § 4
 * - Modelo de datos RBAC formal
   - **Cerrado** — :doc:`/base-cognitiva/_taxonomias-y-metamodelos/metamodelos/mtm-03-metamodelo-rbac`
 * - Vocabulario unico canonico
   - **Cerrado** — :doc:`/normativa/restricciones/cnst-033-vocabulario-unificado-rbac`

8.3 NO incorporar (descartado)
------------------------------

- Namespaces v4.0 (``identity:``, ``epm:``).
- 75+ funciones (consolidado a 42 en v5.2.1).
- Cardinalidad SSD (simplificado a 3 reglas declarativas).

----

9. Conclusion vigente
=====================

El analisis comparativo de enero 2026 documento la genealogia que
llevo al modelo v5.x vigente. La mayoria de gaps identificados se
resolvieron, y los conceptos descartados se documentaron
explicitamente para evitar regresion.

----

10. Cierre y trazabilidad
=========================

**Documento original:**
``temp-holding/GENERACION_DOCUMENTACION/TMP_COMPLETO_IACT_2026-01-13_2/ANALISIS_COMPARATIVO_RBAC_v4_vs_BR_IACT.rst``
(no publicado).

**Genealogia documentada en el corpus vigente:**

- :doc:`/gestion/evidencia/rbac-historia/modelo-rbac-v4-0-roles-jerarquicos-deprecado`
- :doc:`/gestion/evidencia/rbac-historia/discrepancia-rbac-correccion-ene-2026`
- :doc:`/gestion/evidencia/rbac-historia/analisis-errores-modelo-rbac-v5-2-0`
- :doc:`/gestion/evidencia/rbac-historia/decisiones-modulos-8-vs-9-historico`

**Estado vigente:**

- :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`
- :doc:`/normativa/restricciones/cnst-029-rbac-modelo-plano`
- :doc:`/normativa/restricciones/cnst-030-reglas-de-separacion-de-funciones-sod`
- :doc:`/normativa/restricciones/cnst-033-vocabulario-unificado-rbac`
- :doc:`/normativa/gobernanza/adr-gob-008-rbac-coexistencia-acc-perm`
