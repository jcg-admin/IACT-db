.. _uc-auth-05-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **GET listado P50**
   - ≤ 150 ms (50 sessions/pagina, indice
     activo)
 * - **GET listado P99**
   - ≤ 400 ms
 * - **POST close individual P50**
   - ≤ 100 ms
 * - **POST close masivo P50**
   - ≤ 300 ms (hasta ~10 sessions/User)
 * - **Throughput**
   - ≥ 50 GET req/seg, ≥ 10 close req/seg

6.2 Seguridad
=============

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **HTTPS**
   - obligatorio
 * - **JWT**
   - CNST-009
 * - **RBAC granular**
   - lectura vs cierre, distinguidos
 * - **Anti-enumeration**
   - el listado solo muestra Sessions
     existentes con paginacion (no expone
     total real cuando la query es muy
     amplia, redondea)
 * - **Anti-self-bulk-close**
   - EX-04 hard
 * - **Rate limit**
   - 100/min (CNST-011)

6.3 Confiabilidad
=================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Atomicidad**
   - Cada cierre es atomico (UPDATE +
     blacklist + audit en transaccion)
 * - **Cierre masivo**
   - Atomico: si una falla, ROLLBACK de TODAS
     las del User
 * - **Idempotencia close**
   - SI (FA-02 — cerrar lo ya cerrado es
     no-op + AuditEvent SESSION_CLOSE_NOOP)

6.4 Auditabilidad
=================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Append-only**
   - CNST-025
 * - **PII**
   - CNST-026 — payload sin email/full_name;
     solo IDs e IP (la IP del User afectado se
     guarda como dato operacional necesario
     para investigacion, no constituye PII
     directa segun politica)
 * - **Granularidad lectura**
   - SESSIONS_VIEWED_FOR_USER cuando se
     filtra por user_id especifico (mas
     valioso que registrar TODAS las
     consultas)
 * - **Granularidad cierre**
   - 1 SESSION_CLOSED por session cerrada;
     1 BULK_SESSION_CLOSE adicional para
     cierre masivo

6.5 Usabilidad
==============

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Filtros**
   - state, user_id, ip, user_agent fuzzy,
     fecha range
 * - **Paginacion**
   - 50/pagina default; admin puede ajustar
     hasta 200
 * - **Detalle**
   - expandible (no abre nueva pagina)
 * - **Confirmacion cierre**
   - modal individual; doble modal para bulk
 * - **Indicador de sesion propia**
   - badge "TU SESION" en la fila del admin
     (defensa visual contra cierre accidental
     propio)

6.6 Mantenibilidad
==================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Logging**
   - JSON con correlation_id
 * - **Metricas**
   - Counter
     ``auth.session.{view,close,bulk_close,
     unauthorized}``
 * - **Alertas**
   - EX-02/03 (UNAUTHORIZED) → alerta media;
     EX-04 (auto-bulk) → alerta alta;
     > 100 SESSION_CLOSED en 5min → alerta
     incidente

6.7 Compatibilidad
==================

- Browsers: Chrome ≥110, Firefox ≥110,
  Edge ≥110, Safari ≥16
- API: DRF 3.14+ con paginacion estandar
