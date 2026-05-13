.. _uc-perm-10-parte-10:

==========================
Parte 10 — Patrones
==========================

10.1 Patrones aplicados
=======================

.. list-table::
 :widths: 18 32 50
 :header-rows: 1

 * - Patron
   - Nombre
   - Aplicacion
 * - **P-15**
   - RBAC granular
   - ``view_audit_log``
 * - **P-44**
   - Visibility audit prio
   - meta-audit
     AUDIT_LOG_QUERIED
 * - **P-39**
   - Audit reforzado
   - cada consulta auditada
 * - **P-09**
   - Audit-or-abort
   - meta-audit fail ⇒
     no retornar datos
 * - **P-56** (nuevo)
   - Cursor-based pagination
     stable
   - cursor opaco con filters_hash
 * - **P-57** (nuevo)
   - Async export with mailbox
     notify
   - export grande no bloquea
     UI; mailbox como canal
     autorizado
 * - **P-25** (heredado)
   - Read replicas
   - queries fuera del path
     write

10.2 P-56: Cursor-based pagination stable
=========================================

**Problema**: paginacion offset en tablas
con writes concurrentes produce duplicados
y omisiones cuando insertan filas durante
la navegacion.

**Solucion**: cursor opaco que codifica
``(last_created_at, last_id)``. La query
filtra por ``created_at < last_created_at
OR (created_at = last_created_at AND id <
last_id)``. Determinista incluso con
inserts concurrentes.

Adicionalmente: ``filters_hash`` evita
reuso del cursor con filtros distintos —
seria undefined behavior.

10.3 P-57: Async export with mailbox notify
===========================================

**Problema**: exports grandes (millones de
rows) no caben en una request sync; pero
el auditor necesita el archivo.

**Solucion**:

- Endpoint encola job y retorna 202.
- ExportWorker procesa en background.
- Notifica al auditor via internal mailbox
  (CNST-002) — NO email externo
  (CNST-001).
- File URL firmado con TTL para download
  controlado.

Trade-off:

- (+) UI no se bloquea; backend escala.
- (+) Cumple constraints de canales.
- (-) Mas componentes (worker, mailbox).

10.4 P-09 aplicado a read
=========================

Variante: meta-audit fail ⇒ NO retornar
datos. Si no podemos auditar al auditor,
la consulta no procede. Evita auditores
"black-hole" que consultan sin dejar
rastro.

10.5 Trazabilidad
=================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Origen
   - Implementado en
 * - P-15
   - PASO 3
 * - P-44
   - PASO 9
 * - P-39
   - meta-audit obligatorio
 * - P-09 read variant
   - EX-10, CA-18
 * - P-56
   - PASO 7, datos 7.4
 * - P-57
   - FA-05, datos 7.3
 * - P-25
   - NFR 6.2
