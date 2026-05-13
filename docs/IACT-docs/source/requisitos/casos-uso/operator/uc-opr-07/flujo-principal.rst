.. _uc-opr-07-parte-03:

==========================
Parte 3 — Flujo principal
==========================

PASO 1 — POST.
PASO 2 — JWT.
PASO 3 — Validar break_type +
quota.
PASO 4 — Delegar a UC_OPR_01 con
new_state=break + reason.
PASO 5 — Iniciar timer.
PASO 6 — 200.

Al volver: nuevo POST a UC_OPR_01
con new_state=available.
