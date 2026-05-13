.. _uc-cli-03-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

FA-01: Wait > X min → ofrecer
callback (UC_CLI_04).
FA-02: Wait > Y min → mensaje
"intente mas tarde" + hangup.
FA-03: Cliente cuelga voluntariamente
→ abandoned (UC_RPT contabiliza).
FA-04: Skill-based: cola por
skill / idioma.
FA-05: Priority bypass: clientes
VIP / urgentes en cabeza.
FA-06: Cola colapsada (no agentes) →
mensaje + sugerencia callback.
