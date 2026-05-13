.. _uc-aud-04-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

FA-01: Template desconocido → 400.
FA-02: Periodo > 1 ano → archive query
(latencia mayor).
FA-03: Sin datos para template → reporte
con ``no findings`` explicito (no
silencioso).
FA-04: Verificar firma posteriormente:
endpoint ``GET /audit/compliance/{job_id}/verify/``
recompute hash y compara.

.. list-table::
 :widths: 12 38 30 20

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - Template
   - 400
   -
 * - FA-02
   - > 1 ano
   - archive
   -
 * - FA-03
   - Sin findings
   - explicit
   - claridad
 * - FA-04
   - Verify
   - hash check
   - integridad
