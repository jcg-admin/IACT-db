.. _uc-rpt-04-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: Encolar exitoso
==========================

POST → 202 con job_id.

9.2 CA-02: Worker procesa
=========================

Eventually status=done con file_url.

9.3 CA-03: CSV format
=====================

Archivo CSV valido + UTF-8 BOM si requerido.

9.4 CA-04: XLSX format
======================

Archivo XLSX valido.

9.5 CA-05: PDF format
=====================

PDF generado con resumen visual.

9.6 CA-06: Filtros aplicados
============================

Solo datos del segmento del User + filtros
adicionales.

9.7 CA-07: > 1M filas rechazado
===============================

400 ROW_LIMIT_EXCEEDED.

9.8 CA-08: > 5 jobs rechazado
=============================

429 EXPORT_LIMIT_EXCEEDED.

9.9 CA-09: Permiso revocado mid-job
===================================

failed PERMISSION_REVOKED.

9.10 CA-10: > 200 MB
====================

failed TOO_LARGE.

9.11 CA-11: Storage caido
=========================

failed STORAGE_UNAVAILABLE.

9.12 CA-12: URL firmado TTL
===========================

URL expira 24h tras emisor.

9.13 CA-13: Cleanup expirado
============================

Tras 24h, file purged + status=expired.

9.14 CA-14: Mailbox notify
==========================

Done → mensaje en mailbox del User
(CNST-002).

9.15 CA-15: NO email externo (CNST-001)
=======================================

Verificar que no se llama a SMTP / 3rd
party email.

9.16 CA-16: Audit P-39
======================

QUEUED + COMPLETED (o FAILED) emitidos.

9.17 CA-17: Cancelar job
========================

DELETE → status=cancelled si queued, o
graceful tras batch si running.

9.18 CA-18: Status check
========================

GET .../{id}/ → status, progress_pct.

9.19 CA-19: Sin permiso 403
===========================

403 + UNAUTHORIZED audit.

9.20 Resumen
============

.. list-table::
 :widths: 12 50 38
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01..05
   - Encolar + formats
   - Funcional
 * - CA-06
   - Filtros segmento
   - Cumplimiento
 * - CA-07..11
   - Limites / fallos
   - Robustez
 * - CA-12..13
   - URL firmado + cleanup
   - Seguridad
 * - CA-14..15
   - Mailbox / no email
   - Cumplimiento
 * - CA-16
   - Audit
   - Compliance
 * - CA-17..18
   - Cancelar + status
   - Funcional
 * - CA-19
   - Sin permiso
   - Seguridad
