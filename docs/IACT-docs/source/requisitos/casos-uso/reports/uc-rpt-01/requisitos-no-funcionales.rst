.. _uc-rpt-01-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

.. list-table::
 :widths: 30 30 40
 :header-rows: 1

 * - Metrica
   - Target
   - Notas
 * - P50 (cache hit)
   - ≤ 5 ms
   - mayoritario
 * - P50 (cache miss)
   - ≤ 200 ms
   - query agregada
 * - P95
   - ≤ 500 ms
   -
 * - Cache hit ratio
   - ≥ 80%
   - 30s TTL
 * - Auto-refresh impact
   - ≤ 1% CPU del frontend
   -
 * - Concurrent users
   - ≥ 1000 simultaneos
   - read replicas

6.2 Confiabilidad
=================

- Disponibilidad ≥ 99.5%.
- Read replicas Analytics.
- Degradacion: si Analytics caido,
  mostrar banner explicito (no datos
  vacios).

6.3 Seguridad
=============

- ``view_reports`` enforcement.
- Filtro por segmento (CNST-008)
  no eludible: tests de seguridad
  obligatorios.
- Sin PII en response (no nombres /
  telefonos de llamadas individuales).

6.4 Auditabilidad
=================

- Sin audit por invocacion (P-51).
- Cambios al dashboard layout (admin)
  audit.

6.5 Usabilidad
==============

- Carga inicial < 1 s al login.
- Auto-refresh sin parpadeo
  (rerender suave).
- Indicador visual cuando datos
  desactualizados.
- Responsive (mobile usable).

6.6 Mantenibilidad
==================

- KPIs definidos en codigo, no en query
  hardcoded.
- Nuevos KPIs: extender KPICalculator,
  cero cambios en frontend.

6.7 Cumplimiento
================

- Sin BD operativa (CNST-007).
- Sin email externo en notificaciones
  (CNST-001).

6.8 Internacionalizacion
========================

- Labels de KPIs por locale.
- Formato numerico por locale (1,234.56
  vs 1.234,56).
