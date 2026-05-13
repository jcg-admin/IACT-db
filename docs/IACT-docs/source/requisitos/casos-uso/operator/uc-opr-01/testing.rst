.. _uc-opr-01-parte-12:

==================
Parte 12 — Testing
==================

UT-01: StateTransitionValidator OK.
UT-02: Validator rechaza transicion invalida.
UT-03: Reason missing detecta.

IT-01: available → break con reason.
IT-02: Transicion invalida → 409.
IT-03: busy auto al atender.
IT-04: ACW auto al colgar.
IT-05: Logout fuerza offline.
IT-06: Audit emitido.
IT-07: CallRouter notificado.
IT-08: Break exceeded → 409.

E2E-01: Flujo dia agente: login →
disponible → llamada → ACW →
disponible → break → disponible →
logout.

SEC-01: Agente A no puede cambiar
estado de Agente B.

100% de los 10 CAs.
