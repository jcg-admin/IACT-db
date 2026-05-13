.. meta::
 :artefacto: INDEX_RBAC_HISTORIA
 :tipo: Indice
 :dominio: gestion
 :subdominio: evidencia/rbac-historia
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-29
 :autor: Equipo IACT
 :clasificacion: Interno

.. _rbac-historia:

================================
Historia del modelo RBAC IACT
================================

.. note::

 **Subdominio de documentos historicos — referencia para
 trazabilidad.**

 Estos artefactos preservan el contexto historico de la
 evolucion del modelo RBAC del proyecto IACT (octubre 2025 ->
 abril 2026): analisis de errores, gap analysis, decisiones
 modulares, comparativos y disenos de referencia. **NO son
 spec vigente.**

 Para spec vigente del modelo RBAC consultar:

 - :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact` (modelo
   conceptual v5.2.1).
 - :doc:`/normativa/restricciones/cnst-029-rbac-modelo-plano`
   (CNST normativo).
 - :doc:`/normativa/restricciones/cnst-033-vocabulario-unificado-rbac`
   (vocabulario canonico).
 - :doc:`/normativa/gobernanza/adr-gob-008-rbac-coexistencia-acc-perm`
   (decision de coexistencia ACC + PERM).

----

Proposito
=========

Esta seccion alberga **Project Archives + Lessons Learned + Change
Impact Assessments + Gap Analyses + Solution Recommendations**
(taxonomia BABOK/PMBOK) del subsistema RBAC del proyecto IACT.
Documenta:

- Como evoluciono el modelo desde v4.0 (octubre 2025) hasta
  v5.2.1 (enero 2026).
- Que errores se detectaron y como se corrigieron.
- Que decisiones arquitectonicas se tomaron y por que.
- Que conceptos legacy se descartaron y que se preservo.

Audiencias:

- **Implementadores futuros:** entender el por que de las
  decisiones vigentes.
- **Auditores:** trazabilidad de la evolucion del modelo.
- **Onboarding:** contexto historico para entender
  artefactos vigentes.

----

Catalogo
========

.. toctree::
 :maxdepth: 1
 :caption: Documentos historicos del modelo RBAC

 modelo-rbac-v4-0-roles-jerarquicos-deprecado
 analisis-comparativo-rbac-v4-vs-br-iact
 capacidades-vs-permisos-comparativo
 discrepancia-rbac-correccion-ene-2026
 decisiones-modulos-8-vs-9-historico
 gap-analysis-sistema-permisos-nov-2025
 analisis-errores-modelo-rbac-v5-2-0
 diseno-referencia-implementacion-permisos-legacy
 decision-coexistencia-acc-perm
 formalizacion-modelo-rbac

----

Linea temporal
==============

::

   Octubre 2025
     |
     v
   Modelo v4.0 "Sin Pretensiones" (75+ funciones, namespace identity:/epm:)
     -> modelo-rbac-v4-0-roles-jerarquicos-deprecado.rst
     -> analisis-comparativo-rbac-v4-vs-br-iact.rst
     -> capacidades-vs-permisos-comparativo.rst (origen D-RBAC-1)

   Noviembre 2025
     |
     v
   Implementacion parcial (75% completado)
     -> gap-analysis-sistema-permisos-nov-2025.rst

   Enero 2026 (3-13)
     |
     v
   Detencion: BR usaban roles tradicionales (R001..R018)
     -> discrepancia-rbac-correccion-ene-2026.rst

   Enero 2026 (13)
     |
     v
   Modelo v5.x: 8 modulos funcionales (decision SEC_RULES integrado)
     -> decisiones-modulos-8-vs-9-historico.rst

   Enero 2026 (13)
     |
     v
   v5.2.0 -> v5.2.1: vocabulario espanol -> ingles canonico
     -> analisis-errores-modelo-rbac-v5-2-0.rst

   Noviembre 2025
     |
     v
   Diseno de referencia legacy (12 archivos Python)
     -> diseno-referencia-implementacion-permisos-legacy.rst

   Abril 2026 (29)
     |
     v
   Reconciliacion ACC + PERM (vista funcional + vista tecnica)
     -> /normativa/gobernanza/adr-gob-008-rbac-coexistencia-acc-perm
     -> /normativa/restricciones/cnst-033-vocabulario-unificado-rbac
     -> Spec vigente: /arquitectura-tecnica/rbac/modelo-rbac-iact (v5.2.1)
