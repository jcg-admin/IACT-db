.. meta::
 :artefacto: BReq-004
 :tipo: Business Requirement
 :dominio: requisitos
 :subdominio: business-requirements
 :estado: Borrador
 :version: 1.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Interno

==================================================================
BReq-004: Cumplimiento de Seguridad y Auditoría
==================================================================

.. note::

 Business Requirement nivel 2 — Categoría **Seguridad** per
 :doc:`/normativa/procedimientos/proc-req-001-generacion-breq` § 3.

1. Identificación
=================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - BReq-004
 * - **Nombre**
   - Cumplimiento de Seguridad y Auditoría
 * - **Tipo**
   - Business Requirement (nivel 2)
 * - **Categoría**
   - Seguridad
 * - **Prioridad**
   - Crítica
 * - **Estado**
   - Borrador
 * - **Stakeholder primario**
   - Auditor, Oficial de Seguridad, Compliance

2. Enunciado del objetivo de negocio
====================================

El sistema IACT DEBE garantizar que **todo acceso a datos
operativos y toda acción administrativa** se realice bajo
un control de acceso basado en roles (RBAC) auditable,
con segregación de funciones (SoD) y registro inmutable
append-only de cada evento de seguridad, garantizando
**0 accesos no autorizados** y trazabilidad completa para
auditorías regulatorias.

3. Justificación de negocio
===========================

El call center maneja datos personales de clientes
(PII) sujetos a regulación. Una violación de acceso
representa:

- Riesgo regulatorio (multas, suspensión de operación).
- Pérdida de confianza del cliente final.
- Pérdida de contratos.

Sin RBAC granular + auditoría inmutable es imposible
demostrar cumplimiento ante auditor externo.

4. Criterios de éxito
=====================

BReq-004 se considera satisfecho cuando:

1. **0** accesos no autorizados detectados en producción
   (medido vía AuditEvent).
2. 100% de eventos privilegiados generan AuditEvent
   inmutable (CNST-025).
3. Las reglas SoD impiden conflictos críticos en tiempo
   de asignación (no post-hoc).
4. Auditor externo reproduce trazabilidad completa para
   cualquier evento solicitado.

5. Trazabilidad downstream
==========================

**Business Rules (BR) derivadas:**

- :doc:`/requisitos/reglas-negocio/br-005-sesion-unica-por-usuario`
- :doc:`/requisitos/reglas-negocio/br-006-rbac-flat-nist`
- :doc:`/requisitos/reglas-negocio/br-007-separacion-funciones-sod`
- :doc:`/requisitos/reglas-negocio/br-008-auditoria-accesos`
- :doc:`/requisitos/reglas-negocio/br-010-auditoria-inmutable`
- :doc:`/requisitos/reglas-negocio/br-015-bloqueo-intentos-fallidos`
- :doc:`/requisitos/reglas-negocio/br-019-retencion-2-anios`
- :doc:`/requisitos/reglas-negocio/br-020-clasificacion-datos`

**Casos de Uso (UC) primarios:**

- AUTH cluster: :doc:`/requisitos/casos-uso/auth/uc-auth-01/index`,
  :doc:`/requisitos/casos-uso/auth/uc-auth-02/index`,
  :doc:`/requisitos/casos-uso/auth/uc-auth-03/index`,
  :doc:`/requisitos/casos-uso/auth/uc-auth-04/index`,
  :doc:`/requisitos/casos-uso/auth/uc-auth-05/index`
- ACC cluster: UC_ACC_01..09
- AUD cluster: :doc:`/requisitos/casos-uso/audit/uc-aud-01/index`,
  :doc:`/requisitos/casos-uso/audit/uc-aud-02/index`,
  :doc:`/requisitos/casos-uso/audit/uc-aud-03/index`,
  :doc:`/requisitos/casos-uso/audit/uc-aud-04/index`

**BRQ legacy mapeados:**

- BRQ-AUTH-001..005, BRQ-USR-001..009 (parcial),
  BRQ-ACC-001..009, BRQ-AUD-001..004

6. Constraints aplicables
=========================

.. list-table::
 :widths: 20 80
 :header-rows: 1

 * - CNST
   - Aplicación
 * - CNST-003
   - Sesiones persistidas en BD
 * - CNST-004
   - Sesión única por usuario
 * - CNST-005
   - Timeout 15 min
 * - CNST-009
   - Autenticación DRF obligatoria
 * - CNST-013
   - Manejo estandarizado excepciones DRF
 * - CNST-025
   - Auditoría inmutable append-only
 * - CNST-026
   - Sin PII en payload audit

7. Trazabilidad metodológica
============================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Procedimiento de creación**
   - :doc:`/normativa/procedimientos/proc-req-001-generacion-breq`
 * - **Plantilla**
   - :doc:`/normativa/estandares/plantillas/tpl-breq-objetivos-negocio`
 * - **ADR jerarquía**
   - :doc:`/normativa/gobernanza/adr-gob-003-jerarquia-requerimientos-5-niveles`
 * - **Origen FND**
   - :doc:`/base-cognitiva/_fundamentos-conceptuales/fnd-05-jerarquia-4-niveles`
     § 3.5 BReq-004
