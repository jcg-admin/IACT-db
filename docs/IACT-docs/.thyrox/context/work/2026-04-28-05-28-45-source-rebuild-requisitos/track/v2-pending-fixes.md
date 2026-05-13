```yml
created_at: 2026-04-29 04:50:00
project: IACT-docs
work_package: 2026-04-28-05-28-45-source-rebuild-requisitos
phase: Phase 11 — TRACK (v2 pendiente)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# WP #6 requisitos — Fixes pendientes para iteracion v2

6 hallazgos detectados en audit cross-WP del 2026-04-29 (4 ya
documentados en `track/post-cierre-audit.md`, 2 nuevos: BRs/FRs/NFRs
faltantes).

## Q-1 [ALTO] 571 refs CNST legacy en bodies de UCs

**Problema:** el script `map_cnst_refs.py` (Phase 2 EXECUTE) solo
actualizo el campo `:normativa:` en metadata. Los bodies de los UCs
contienen 571 refs adicionales con format `CNST-NNN` (legacy).

**Ejemplos:**

```
- Baja LOGICA, nunca fisica (CNST-005)         ← legacy
- Registro completo en auditoria (CNST-009)    ← legacy
**Restriccion critica CNST-005:**              ← legacy
```

**Mapping a aplicar (consistente con metadata):**

| Legacy (body) | SRP-31 |
|---------------|--------|
| CNST-001 | CNST_001 (Email/Comunicaciones) |
| CNST-002 | CNST_003 (Sesiones BD) |
| CNST-003 | CNST_007 (BD IVR Readonly) |
| CNST-004 | CNST_008 (ETL Ventana) |
| CNST-005 | **DEPENDE DEL CONTEXTO** — analizar caso a caso: si "Baja Logica" → mapear a NFR (no CNST); si "Seguridad DRF" → CNST_005 timeout actual no es seguridad DRF; revisar |
| CNST-006 | CNST_015 (Antipatrones) |
| CNST-007 | CNST_017 (SLA) |
| CNST-008 | CNST_024 (Logs JSON) |
| CNST-009 | CNST_025 (Audit Inmutable) |
| CNST-010 | CNST_027 (Clasificacion Datos) |

**Accion v2:**

1. Script Python que itera los 49 UCs canonicos.
2. Para cada `CNST-NNN` en body, contextualizar:
   - Si contexto es claro (Baja Logica, Audit Inmutable): mapear directo.
   - Si contexto es ambiguo (CNST-005 sin claridad): marcar
     `CNST-005 [VERIFICAR]` y listar para revision manual.
3. Los UC_PERM (10) ya estan correctos (no tienen refs legacy).

**Estimacion:** 2 h (script + verificacion + casos ambiguos).

## Q-2 [ALTO] 118 ocurrencias "Capacidad" en UC_PERM

**Decision aprobada:** D-RBAC-1 — termino canonico es **"Funcion"**.

**Accion v2:**

1. En los 10 UC_PERM, replace "Capacidad" → "Funcion" (mantener case:
   "capacidad" → "funcion", "Capacidad" → "Funcion", "CAPACIDAD" →
   "FUNCION").
2. Verificar que NO se rompan refs `:doc:` ni `:ref:` (poco probable).
3. Build verde.

**Estimacion:** 30 min.

## Q-3 [MEDIO] 0 cross-refs UC_ACC ↔ UC_PERM

**Problema:** la decision de coexistencia es invisible al lector
de UCs individuales.

**Accion v2:**

Agregar al inicio de UC_ACC_01..04 y UC_PERM_01..06 (los que tienen
correspondencia conceptual) una nota explicita:

```rst
.. note:: Vista alternativa (coexistencia ACC ↔ PERM)

   Este UC representa la **vista funcional** de la asignacion. La
   **vista tecnica granular** del mismo concepto esta en
   :doc:`/requisitos/casos_uso/permissions/UC_PERM_01_Asignar_Grupo_a_Usuario`.
   Ambas coexisten per ADR-GOB-008.
```

Mapeo de cross-refs a agregar:

| UC_ACC | UC_PERM relacionado |
|--------|---------------------|
| UC_ACC_01 Asignar Funciones | UC_PERM_01 Asignar Grupo |
| UC_ACC_02 Revocar Funciones | UC_PERM_02 Revocar Grupo |
| UC_ACC_03 Consultar Permisos | UC_PERM_07 Verificar Permiso + UC_PERM_10 Consultar Auditoria |
| UC_ACC_04 Asignar Agrupador | UC_PERM_06 Asignar Capacidades a Grupo |
| UC_ACC_08 Permiso Temporal | UC_PERM_03 Conceder Permiso Excepcional |
| UC_ACC_09 Auditar Cambios Acceso | UC_PERM_09 Auditar Acceso |

**Estimacion:** 30 min.

## Q-4 [MEDIO] source/requisitos/reglas_negocio/ NO existe

**Problema:** WP #6 solo genero `casos_uso/`. Los inventarios v4.0.0
identificaron **20 BRs IACT reales** (en `analyze/inventory-br-v4.md`)
pero NO se materializaron en source.

**Accion v2:**

1. Crear `source/requisitos/reglas_negocio/`.
2. Copiar las 20 BRs canonicas desde `temp-backup/source-2026-04-28/
   requisitos/reglas_negocio/` o equivalente (verificar ubicacion).
3. Aplicar metadata estandar 10 campos.
4. Crear `index.rst` y conectar al `requisitos/index.rst` con caption
   "Reglas de Negocio".

**Estimacion:** 1.5 h (20 archivos a copiar + estandarizar metadata
+ index).

## Q-5 [MEDIO] source/requisitos/requisitos_funcionales/ NO existe

**Problema:** El inventario detecto 51 FRs IACT documentados (88%
del catalogo esperado, 12% pendiente).

**Accion v2:**

1. Crear `source/requisitos/requisitos_funcionales/`.
2. Decision pendiente del ejecutor: ¿generar los 51 FRs documentados
   en este v2 (esfuerzo alto) o diferir todos los FRs a un WP-hijo
   nuevo dedicado?
3. Si se incluyen los 51 FRs: copiar + estandarizar metadata.

**Estimacion:**

- Si se incluyen los 51 FRs: ~4 h (51 archivos).
- Si se difieren: 0 (solo crear estructura vacia con README "pendiente
  WP-hijo dedicado").

## Q-6 [MEDIO] source/requisitos/requisitos_no_funcionales/ NO existe

**Problema:** 28 NFRs propuestos en `analyze/inventory-nfr-v4.md`
distribuidos en ISO 25010:

- NFR_PERF (Performance): 9
- NFR_SEC (Security): 8
- NFR_REL (Reliability): 5
- NFR_USAB (Usability): 3
- NFR_AUD (Auditability): 3

**Accion v2:**

1. Crear `source/requisitos/requisitos_no_funcionales/`.
2. Decision pendiente del ejecutor (similar a Q-5): ¿generar los 28
   NFRs en este v2 o diferir?
3. Si se incluyen: estructura por atributo ISO + 28 archivos.

**Estimacion:**

- Si se incluyen: ~3 h.
- Si se difieren: 0.

## Total iteracion v2

| Hallazgo | Severidad | Esfuerzo |
|----------|-----------|----------|
| Q-1 | ALTO | 2 h |
| Q-2 | ALTO | 30 min |
| Q-3 | MEDIO | 30 min |
| Q-4 | MEDIO | 1.5 h |
| Q-5 | MEDIO | 4 h o 0 (diferir) |
| Q-6 | MEDIO | 3 h o 0 (diferir) |
| **Total** | | **4 h (sin Q-5/Q-6) o 11 h (con todos)** |

**Recomendacion al ejecutor:** atender Q-1, Q-2, Q-3, Q-4 en v2 (4 h),
diferir Q-5 y Q-6 a WP-hijo nuevo dedicado a "requisitos no-funcionales
y funcionales completos".

## Pre-condicion

- WP #1 v3 + WP #4 v3 + WP #5 v2 idealmente completos antes (Q-1
  necesita CNST_032/033 referenciables).

## Cross-refs

- WP padre `track/cross-wp-deep-audit-2026-04-29.md`
- `track/post-cierre-audit.md` (audit retrospectivo previo)
- `analyze/inventory-br-v4.md`, `analyze/inventory-fr-v4.md`,
  `analyze/inventory-nfr-v4.md`
