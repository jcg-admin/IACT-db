.. _uc-aud-04-parte-10:

==========================
Parte 10 — Patrones
==========================

10.1 Patrones aplicados
=======================

Reuso P-15, P-39, P-44, P-57, P-72.

P-80 (nuevo): Cryptographic integrity for
external delivery
- HMAC + hash al firmar.
- Verify endpoint para auditor externo.
- Key en HSM/KMS.

10.2 P-80
=========

**Problema**: documentos enviados a
auditores externos pueden ser modificados
en transit o ex-post. Sin integridad
demostrable, valor compliance es nulo.

**Solucion**: HMAC-SHA256 con key en KMS;
firmar reporte al generarlo. Verify endpoint
recompute hash y compara firma. Auditor
externo confia en el endpoint del proveedor
(o downloads la public key del KMS si se
firma asimetrico).
