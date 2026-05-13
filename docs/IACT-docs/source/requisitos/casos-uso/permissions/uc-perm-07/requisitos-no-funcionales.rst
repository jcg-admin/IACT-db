.. _uc-perm-07-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance — el path mas caliente
======================================

.. list-table::
 :widths: 30 30 40
 :header-rows: 1

 * - Metrica
   - Target
   - Notas
 * - P50 (cache hit)
   - ≤ 5 ms
   - 90%+ del trafico
 * - P50 (cache miss)
   - ≤ 25 ms
   - 1 query agregada
 * - P95
   - ≤ 30 ms
   - incluye GC, contention
 * - P99
   - ≤ 80 ms
   - tail (cold connection)
 * - Cache hit ratio
   - ≥ 90%
   - alerta si < 80%
 * - Bulk (50 codes)
   - ≤ 30 ms
   - via 1 query agregada
 * - Throughput
   - ≥ 5000 req/s
   - por nodo
 * - QPS objetivo
   - 10× pico
   - holgura para spikes

6.2 Consistencia
================

- Lectura consistente con el ultimo COMMIT
  visible.
- Cache invalidado a los pocos ms de cambios
  via UC_ACC_*, UC_PERM_05/06 (P-29
  escalado).
- TTL maximo 60s — limita ventana de
  inconsistencia ante invalidate fallido.

6.3 Seguridad
=============

- **Fail-closed**: cualquier error en el
  algoritmo o BD ⇒ ``allowed=false``. NUNCA
  fail-open (P-08).
- Endpoint admin: misma proteccion JWT que
  el resto. ``view_assignments`` NO lo
  pueden tener Users sin necesidad de
  auditoria.
- NO loguear ``function_code`` con datos
  sensibles en logs comunes (puede revelar
  intencion de privilegio).

6.4 Confiabilidad
=================

- Disponibilidad ≥ 99.95% (la mas alta de
  todos los UCs — su caida causa lockout
  total).
- Read replicas: cache local por nodo +
  cache distribuido. Falla de cache distribuido
  no debe degradar performance > 5x.

6.5 Auditabilidad
=================

- NO se audita por invocacion (escala
  prohibitiva).
- Acciones que dependieron del check SON
  auditadas (UC_PERM_09).
- Agregados de cache hits / misses /
  denies en metricas (Prometheus / similar)
  son obligatorios para detectar abuso.
- Endpoint admin con volumen anomalo dispara
  alerta.

6.6 Usabilidad
==============

- Response self-explanatory: ``origin``
  permite al frontend mostrar "denegado por
  revocacion temporal hasta {valid_until}".
- Bulk endpoint reduce tiempo de carga de
  menu de 1.5s → 30ms.

6.7 Mantenibilidad
==================

- El servicio es la primitiva — debe ser
  trivial de testear (deterministico, sin
  side effects).
- Algoritmo en una funcion pura tomando
  datos como input.

6.8 Cumplimiento
================

- Algoritmo de precedencia documentado y
  versionado.
- Cambios al algoritmo requieren ADR.
- Audit reforzado en endpoint admin
  cuando ``view_assignments`` se otorga
  (UC_PERM_09).
