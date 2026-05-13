```yml
created_at: 2026-04-29 04:50:00
project: IACT-docs
work_package: 2026-04-28-05-28-41-source-rebuild-normativa-estandares
phase: Phase 11 — TRACK (v2 pendiente)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# WP #2 normativa-estandares — Fixes pendientes para iteracion v2

## E-1 [MEDIO] STD_007 NO menciona convencion ingles/espanol

**Archivo:** `source/normativa/estandares/STD_007_Convencion_Naming.rst`

**Problema:** `MODELO_RBAC_IACT_v5_2_1.md` § "ESTANDAR DE
NOMENCLATURA" declara la convencion del proyecto:

| Tipo | Idioma |
|------|--------|
| Codigo (clases, metodos, variables, capabilities) | **Ingles** |
| Comentarios, docstrings, help_text | **Espanol** |
| Documentacion (.rst, .md) | **Espanol** |

STD_007 (estandar de naming canonico) NO incluye esta regla. Lectores
del estandar podrian no saber que `class FunctionGroup` (ingles) +
`"""Grupo de funciones que se asignan juntas."""` (espanol) es la
forma correcta.

**Accion v2:**

1. Agregar nueva seccion al STD_007: **§N "Convencion de idioma"** con
   la tabla de arriba.
2. Citar fuente: `MODELO_RBAC_IACT_v5_2_1` cuando este migrado a
   source (en WP #7 arquitectura-tecnica).
3. Ejemplo concreto:

```python
class FunctionGroup(models.Model):
    """Grupo de funciones que se asignan juntas."""  # ← Espanol
    group_id = models.CharField(                     # ← Ingles
        help_text="Identificador unico (AGR-001)"    # ← Espanol
    )
```

**Estimacion:** 20 min.

## Total iteracion v2

- 1 hallazgo (1 MEDIO)
- Estimacion: ~20 min
- Build verification
- Commit + push

## Pre-condicion

Sin pre-condicion de otros WPs. Puede ejecutarse independientemente.

## Cross-refs

- WP padre `track/cross-wp-deep-audit-2026-04-29.md` (master audit)
- WP #6 `analyze/rbac-formalization.md` § 12.1 (convencion idioma)
