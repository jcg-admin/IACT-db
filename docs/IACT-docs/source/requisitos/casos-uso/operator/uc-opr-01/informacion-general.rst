.. _uc-opr-01-parte-01:

==============================
Parte 1 — Informacion general
==============================

.. list-table::
 :widths: 30 70

 * - **ID**
   - UC_OPR_01
 * - **Nombre**
   - Cambiar Estado del Agente
 * - **Modulo**
   - MOD_Operator
 * - **BReq**
   - BReq-007 (operacion)
 * - **Funcion RBAC**
   - implícita ``manage_own_agent_state``

1.1 Proposito
=============

Permitir al agente declarar su disponibilidad
para recibir llamadas. El sistema usa este
estado para enrutar (no enrutar a busy ni a
break).

1.2 Estados validos
===================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Estado
   - Significado
 * - ``available``
   - puede recibir llamada
 * - ``busy``
   - en llamada (auto-set)
 * - ``after_call_work`` (ACW)
   - terminando wrap-up post-call
 * - ``break``
   - pausa autorizada (cafe / lunch)
 * - ``training``
   - capacitacion en curso
 * - ``offline``
   - logout / fin de turno

1.3 Transiciones validas
========================

::

   offline → available (login)
   available → busy (auto: llamada
              entrante atendida)
   busy → after_call_work (auto:
          colgar)
   after_call_work → available (auto al
          terminar wrap-up)
   available → break (manual)
   break → available (manual)
   * → offline (logout)

1.4 Restricciones
=================

CNST-009. CNST-013. CNST-025 (audit
state changes). break time controlado
por politica de adherence (UC_RPT_12).

1.5 Out of scope
================

- Atender llamada (UC_OPR_02).
- Disposition (UC_OPR_06).
