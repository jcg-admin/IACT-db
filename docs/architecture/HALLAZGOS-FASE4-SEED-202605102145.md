# Hallazgos — Ejecución FASE 4 (Documentación)

**Versión:** 1.0.0  
**Fecha:** 2026-05-10  
**Contexto:** Implementación de FASE 4 del
`PLAN-SEED-HISTORICO-V2-202605102100.md`

---

## Resumen de tareas

| Tarea | Descripción | Estado | Observación |
|---|---|---|---|
| T-4.1 | Verificar SCRIPT_VERSION en schema_historico.sh | COMPLETO | 2.4.0 ya correcto |
| T-4.2 | Verificar changelog de schema_historico.sh | COMPLETO | v2.2.0/2.3.0/2.4.0 ya presentes |
| T-4.3a | Verificar changelog de seed_historico.sql | COMPLETO | v3.0.0 ya presente |
| T-4.3b | Agregar CHANGELOG a poblar_historico.py | COMPLETO + H-F4-001 | Gap detectado y corregido |
| T-4.4a | Marcar H-SEED-001..008 como RESUELTO | COMPLETO | Con ref a commit y tarea |
| T-4.4b | Marcar H-SEED-010..015 como RESUELTO | COMPLETO | Con distinción Nivel 1 / Nivel 2 |
| T-4.4c | Marcar H-F1-004 como RESUELTO | COMPLETO | Resuelto en v2.3.0 |

---

## Auditoría de changelogs — estado pre-FASE 4

| Artefacto | Versión | Changelog | Estado pre-FASE 4 |
|---|---|---|---|
| `schema_historico.sh` | 2.4.0 | v2.2.0, v2.3.0, v2.4.0 | Completo |
| `seed_historico.sql` | 3.0.0 | v3.0.0, v2.0.0 | Completo |
| `poblar_historico.py` | 1.0.0→1.1.0 | Sin CHANGELOG | Deuda técnica — corregida |
| `verify.sh` | — | Changelog de 2026-05-10 | Completo |
| `setup.sh` | — | Changelog de 2026-05-10 | Completo |
| `provision-mariadb.sh` | 1.2.1 | v1.2.1 | Completo |

---

## Hallazgos

| ID | Hallazgo | Severidad | Estado |
|---|---|---|---|
| H-F4-001 | `poblar_historico.py` sin sección CHANGELOG ni versión semántica | MEDIA | RESUELTO en sesión |

---

## H-F4-001 — `poblar_historico.py` sin CHANGELOG

**Tipo:** Deuda técnica — omisión de documentación  
**Severidad:** MEDIA  
**Estado:** RESUELTO durante la auditoría T-4.3b

### Descripción

Durante la auditoría de T-4.3, se verificó que `seed_historico.sql`
y `schema_historico.sh` tienen changelogs completos y versionados.
`poblar_historico.py` no tenía ninguna sección de CHANGELOG ni número
de versión semántica, a pesar de haber recibido una corrección de bug
(H-F3-001) en la FASE 3.

Sin un CHANGELOG, es imposible determinar en qué versión fue corregido
un defecto o cuándo se introdujo un comportamiento. Esto es especialmente
relevante para `poblar_historico.py` porque:

1. Es el único artefacto de seed que usa Python — su historial de cambios
   no es visible desde el SQL ni desde el bash wrapper.
2. H-F3-001 (corrección de `gen_phone()`) es un cambio de comportamiento
   con impacto directo en la calidad de los datos generados.
3. El script es mantenido independientemente del SQL y puede tener
   evoluciones futuras (nuevos perfiles, nuevas distribuciones).

### Corrección aplicada

Agregado al docstring de `poblar_historico.py`:

```
CHANGELOG:
    v1.1.0 (2026-05-10):
        H-F3-001: corregir gen_phone() — randint(0, 10**digs-1).zfill(digs)
            producía ceros de padding (9.85% de ocurrencia). Corrección:
            randint(10**(digs-1), 10**digs-1) garantiza exactamente digs
            dígitos con primer dígito siempre 1-9, sin zfill necesario.

    v1.0.0 (2026-05-06):
        Versión inicial. Motor Python para generación de registros históricos
        IVR con perfiles por quarter, VDNs reales, distribuciones calibradas.
```

Se asignó la versión semántica `v1.0.0` a la implementación original
(2026-05-06) y `v1.1.0` a la corrección de H-F3-001 (2026-05-10).

---

## Estado de hallazgos al cierre de la sesión completa

### HALLAZGOS-SEED-SQL-202605102030.md

| ID | Estado final |
|---|---|
| H-SEED-001 | RESUELTO — seed_historico.sql v3.0.0 T-1.4 commit c2890f0 |
| H-SEED-002 | RESUELTO — seed_historico.sql v3.0.0 T-1.2/T-1.3 commit c2890f0 |
| H-SEED-003 | RESUELTO — seed_historico.sql v3.0.0 T-1.6 commit c2890f0 |
| H-SEED-004 | RESUELTO — seed_historico.sql v3.0.0 T-1.7 commit c2890f0 |
| H-SEED-005/006 | RESUELTO — seed_historico.sql v3.0.0 T-1.8a commit c2890f0 |
| H-SEED-007 | RESUELTO — seed_historico.sql v3.0.0 T-1.9 commit c2890f0 |
| H-SEED-008 | RESUELTO — seed_historico.sql v3.0.0 T-1.10 commit c2890f0 |
| H-SEED-009 | DOCUMENTADO (referencia arquitectural) |

### HALLAZGOS-SEED-VOLUMEN-MENUS-202605102045.md

| ID | Estado final |
|---|---|
| H-SEED-010 | RESUELTO — seed_historico.sql v3.0.0 T-1.11 commit c2890f0 |
| H-SEED-011 | RESUELTO — seed_historico.sql v3.0.0 T-1.11 commit c2890f0 |
| H-SEED-012 | RESUELTO (Nivel 1: 22 menús reales) + Nivel 2: catálogo completo |
| H-SEED-013 | RESUELTO (Nivel 1: VDNs reales por menú) + Nivel 2: 28+ VDNs |
| H-SEED-014 | RESUELTO vía Nivel 2 — schema_historico.sh v2.3.0 PASO 4 |
| H-SEED-015 | RESUELTO — arquitectura dos niveles implementada |

### HALLAZGOS-FASE1-SEED-SQL-202605102015.md

| ID | Estado final |
|---|---|
| H-F1-001 | RESUELTO en FASE 1 (cDID SinOpcion/Marque3 → 19020086) |
| H-F1-002 | DOCUMENTADO (55X con 0 en pos.4 — patrón válido CDMX) |
| H-F1-003 | DOCUMENTADO (limitación Nivel 1 cubierta por Nivel 2) |
| H-F1-004 | RESUELTO — schema_historico.sh v2.3.0 T-2.1 commit e825383 |
| H-F1-005 | DOCUMENTADO (script_version refleja wrapper, no SQL — por diseño) |

### Hallazgos de FASE 2 y 3

| ID | Estado final |
|---|---|
| H-F2-001 | RESUELTO — patrón exit code corregido en PASO 4 |
| H-F2-002 | RESUELTO — FORCE_RESEED eliminado (mismo que H-F1-004) |
| H-F2-003 | DOCUMENTADO (SEED_ROWS es rows_base, poblar_historico.py escala internamente) |
| H-F3-001 | RESUELTO — gen_phone() corregido commit abaf146 |
| H-F3-002 | DOCUMENTADO (H-PROV-001 ambiente — servidores reiniciados) |
| H-F4-001 | RESUELTO — CHANGELOG agregado a poblar_historico.py |

---

## Cierre del plan PLAN-SEED-HISTORICO-V2

Todas las 21 tareas del plan completadas:

```
FASE 0 (T-0.1)           COMPLETO — auditoria pre-condición
FASE 1 (T-1.1..T-1.12)  COMPLETO — seed_historico.sql v3.0.0
FASE 2 (T-2.1..T-2.4)   COMPLETO — schema_historico.sh v2.3.0 + v2.4.0
FASE 3 (T-3.1..T-3.6)   COMPLETO — validación + H-F3-001 corregido
FASE 4 (T-4.1..T-4.4)   COMPLETO — documentación cerrada
```

Commits generados en `develop`: a97a617, 2e872d0, e825383, c2890f0,
53f9009, ec28106, d343dbf, 6f1094f, 1fa6ccf, 5aaf2e1, 511a7c4, abaf146,
y el commit de FASE 4 pendiente.
