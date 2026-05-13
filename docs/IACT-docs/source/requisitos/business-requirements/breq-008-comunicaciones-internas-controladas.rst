.. meta::
 :artefacto: BReq-008
 :tipo: Business Requirement
 :dominio: requisitos
 :subdominio: business-requirements
 :estado: Borrador
 :version: 1.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Interno

============================================================
BReq-008: Comunicaciones Internas Controladas
============================================================

.. note::

 Business Requirement nivel 2 — Categoría **Cumplimiento**
 per :doc:`/normativa/procedimientos/proc-req-001-generacion-breq` § 3
 (categoría Integración / Cumplimiento normativo). Refuerza
 el alcance de :doc:`/requisitos/reglas-negocio/br-004-comunicaciones-internas-only`.

1. Identificación
=================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - BReq-008
 * - **Nombre**
   - Comunicaciones Internas Controladas
 * - **Categoría**
   - Cumplimiento / Integración
 * - **Prioridad**
   - Alta
 * - **Estado**
   - Borrador
 * - **Stakeholder primario**
   - Oficial de Seguridad, Compliance, Soporte

2. Enunciado del objetivo de negocio
====================================

El sistema IACT DEBE conducir **toda comunicación
relevante a usuarios internos** (notificaciones,
contraseñas temporales, alertas) por el canal
``InternalMailbox`` del propio sistema, **prohibiendo
canales externos** (email, SMS, webhooks externos) que
puedan ser interceptados o filtrados fuera de control.

3. Justificación de negocio
===========================

Toda comunicación que sale del perímetro técnico es
fuente potencial de fuga de información (PII, credenciales).
La política de "comunicaciones internas only":

- Reduce superficie de ataque.
- Simplifica auditoría de mensajes.
- Mantiene PII dentro del sistema controlado.
- Cumple con políticas de retención y clasificación de
  datos.

4. Criterios de éxito
=====================

BReq-008 se considera satisfecho cuando:

1. **0** envíos de email/SMS/webhook desde IACT en
   producción (validable en código + tests).
2. 100% de mensajes operativos disponibles en
   ``InternalMailbox`` del usuario destinatario.
3. Cada mensaje en mailbox es auditado (CNST-025).
4. Mensajes contienen identificadores no PII directa
   (CNST-026).

5. Trazabilidad downstream
==========================

**Business Rules (BR) derivadas:**

- :doc:`/requisitos/reglas-negocio/br-004-comunicaciones-internas-only`

**Casos de Uso (UC) primarios:**

- :doc:`/requisitos/casos-uso/auth/uc-auth-03/index`
  (Recuperar contraseña — entrega vía mailbox)
- UC_USR_* (notificaciones de cambios)
- UC_ALR_* (alertas operativas)

**BRQ legacy mapeados:**

- Transversal — incluye BRQ-AUTH-003 y BRQ-ALR-*

6. Constraints aplicables
=========================

.. list-table::
 :widths: 20 80
 :header-rows: 1

 * - CNST
   - Aplicación
 * - CNST-001
   - Prohibición de email / SMS / webhooks externos
 * - CNST-002
   - InternalMailbox obligatorio
 * - CNST-025
   - AuditEvent de cada mensaje emitido
 * - CNST-026
   - Sin PII directa en payload

7. Trazabilidad metodológica
============================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Procedimiento de creación**
   - :doc:`/normativa/procedimientos/proc-req-001-generacion-breq`
 * - **Plantilla**
   - :doc:`/normativa/estandares/plantillas/tpl-breq-objetivos-negocio`
 * - **Categoría proc-req-001**
   - § 3 Integración (cumplimiento normativo)
