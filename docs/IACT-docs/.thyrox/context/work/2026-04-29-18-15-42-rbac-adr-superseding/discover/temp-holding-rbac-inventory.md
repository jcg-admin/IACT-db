```yml
created_at: 2026-04-29 20:10:00
project: IACT-docs
work_package: 2026-04-29-18-15-42-rbac-adr-superseding
phase: Phase 1 — DISCOVER (extension)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# `temp-holding/` — Inventario RBAC relevante a Z.1

## Premisa

Antes de redactar los 2 ADRs nuevos (Opción C: `adr-gob-009`
conceptual + `adr-back-005` técnico), se audita `temp-holding/`
para identificar material histórico que:

1. **Justifique** las decisiones documentadas en los ADRs.
2. **Provea contexto** que evite re-derivar argumentación.
3. **Detecte legacy** que el corpus actual `source/` ya migró pero
   conserve aprendizajes históricos.
4. **Identifique referencias cruzadas** que el ADR debe citar.

## Hallazgos relevantes

### A — `temp-holding/RBAC/` (8 archivos)

Histórico completo de versiones del modelo RBAC:

| Archivo | Tamaño | Rol |
|---------|-------:|-----|
| `Modelo RBAC Sin Pretensiones v4.0.txt` | 99 KB | **v4.0 legacy** — 18 roles tipo R001..R018 (descartado por SBVR-01) |
| `MODELO RBAC COMPLETO - v5.0 - incompleto.txt` | 73 KB | v5.0 incompleto — primera versión "Sin Pretensiones" |
| `MODELO_RBAC_COMPLETO_v5.0_1.md` | 47 KB | v5.0 completo |
| `MODELO_RBAC_IACT_v5.1.md` | 58 KB | v5.1 — adaptación a 8 módulos IACT |
| `MODELO_RBAC_IACT_v5.1.1.md` | 58 KB | v5.1.1 — patch |
| `MODELO_RBAC_IACT_v5_2_0.md` | 55 KB | v5.2.0 — Clean Code + 42 funciones (con errores) |
| `MODELO_RBAC_IACT_v5_2_1.md` | 58 KB | **v5.2.1** — fuente original del .rst migrado |
| **`ANALISIS_ERRORES_MODELO_RBAC_v5_2_0.md`** | 14 KB | **CRÍTICO** — análisis formal de los 87+ errores en v5.2.0 que motivaron v5.2.1 |

#### Hallazgo A-01 CRÍTICO — `ANALISIS_ERRORES_MODELO_RBAC_v5_2_0.md`

Documento que **justifica el cambio v5.2.0 → v5.2.1** con análisis
formal de errores:

| Categoría | Errores | Gravedad |
|-----------|---------|----------|
| Nombres de funciones (dominio) | 42 | CRÍTICA |
| Nombres de grupos | 10 | CRÍTICA |
| Campos SQL mezclados | 15+ | ALTA |
| Inconsistencias en ejemplos | 20+ | ALTA |
| **Total** | **87+** | **INACEPTABLE** |

**Decisión registrada:** todos los nombres de funciones y grupos a
**INGLÉS** (`manage_sessions`, no `gestiona_sesiones`). Esto es el
origen del vocabulario canónico que CNST-033 formaliza después.

**Para el ADR-GOB-009 nuevo:** este archivo **DEBE referenciarse** en
la sección "Origen / Trazabilidad" — explica POR QUÉ v5.2.1 quedó
como modelo canónico (corrige 87+ errores de v5.2.0).

### B — `temp-holding/Modules/` (12 archivos Python)

Código legacy del sistema de permisos:

```
call_center_privilege_models.py
call_center_privilege_service.py
department_privilege_system.py
module_initial_data.py
module_system_admin.py
module_system_models.py
module_system_permissions.py
module_system_serializers.py
module_system_urls.py
module_system_views.py
privilege_flow_diagram.py
updated_main_urls.py
```

#### Hallazgo B-01 INFO — Código backup pre-IACT-docs

Estos archivos representan **implementación legacy** que el corpus
`source/` actualmente describe abstractamente. NO son
implementación vigente del proyecto IACT-docs (el proyecto está
en spec-only).

**Para el ADR-BACK-005 nuevo:** referenciar como **"código de
referencia histórico"** que informó la decisión de estrategia
híbrida ORM + SQL, sin afirmar que es la implementación actual.

### C — `temp-holding/GENERACION_DOCUMENTACION/`

#### Hallazgo C-01 CRÍTICO — `MAPA_RBAC_COMPLETO_v1_0_0.md`

Documento "**Piedra Rosetta**" (sus palabras) que conecta:
- MODELO_RBAC_IACT (¿QUÉ queremos?)
- CNST_005_RBAC_Flat_SoD_Permisos (¿CÓMO lo construimos?)

**Para Z.1:** este documento es **directamente análogo** al
ADR-GOB-009 que vamos a crear — pero más viejo (2026-01-11) y
referencia un CNST_005 que no existe en el corpus actual (los
CNSTs RBAC en `source/` son 029-033).

**Acción propuesta:** preservar la **idea estructural** (mapping
documental QUÉ ↔ CÓMO) pero rehacer el contenido contra el
corpus vigente. NO citar el archivo legacy en el ADR nuevo
(es legacy descontinuado).

#### Hallazgo C-02 CRÍTICO — `ANALISIS_PROFUNDO_RBAC_MODULOS_IACT.md`

Análisis exhaustivo (Jan 2026) que documenta:
- "8 Módulos Funcionales" — alineado con v5.2.1 vigente.
- Filosofía "Sin Pretensiones".
- Referencia a v5.1.1 (no v5.2.1, así que es pre-corrección).

**Para Z.1:** valida que **8 módulos** es la decisión sostenida
desde v5.1.x — NO es novedad de v5.2.1. Refuerza la cita en
ADR-GOB-009.

#### Hallazgo C-03 CRÍTICO — `ANALISIS_PROFUNDO_DECISIONES_MODULOS_IACT_v2.md`

Análisis con **PARTE 3: IDENTIFICACIÓN DE CONTRADICCIONES** que
documenta el debate **"8 vs 9 módulos"** del proyecto.

Resolución registrada:
- 8 módulos con **SEC_RULES integrado en RBAC_CORE** (NO separado).
- "Documentos posteriores ignoraron la decisión de 8 módulos".
- Decisión final: **8 módulos**.

**Para ADR-GOB-009:** trazabilidad histórica de por qué los 8
módulos del modelo v5.2.1 NO son arbitrarios — son resultado
de un debate documentado.

### D — `temp-holding/project/decisions.md`

Template ADR vacío (`ADR-001 (first decision title)` con campos sin
llenar). **No relevante** — es boilerplate inicial sin contenido.

### E — `temp-holding/FASE 01/docs/infraestructura/adr/`

```
ADR-INFRA-001-vagrant-devcontainer-host.md
adr_2025_011_wasi_style_virtualization.md
```

Estos ADRs ya fueron migrados al corpus actual como
`adr-devops-001-vagrant-...` y `adr-devops-003-wasi-...`.
**No relevante** para Z.1 (RBAC).

## Síntesis: ¿qué impacta a los ADRs nuevos?

### Material a CITAR en ADR-GOB-009 (conceptual)

| Cita | Justificación |
|------|---------------|
| `temp-holding/RBAC/ANALISIS_ERRORES_MODELO_RBAC_v5_2_0.md` | Origen del vocabulario inglés canónico (motivó v5.2.1 + después CNST-033) |
| `temp-holding/RBAC/Modelo RBAC Sin Pretensiones v4.0.txt` | Reference legacy descartado (18 roles R001..R018) — explica qué NO replicar |
| `temp-holding/GENERACION_DOCUMENTACION/ANALISIS_PROFUNDO_DECISIONES_MODULOS_IACT_v2.md` § PARTE 3 | Trazabilidad de la decisión "8 módulos" (no 9) |

### Material a CITAR en ADR-BACK-005 (técnico)

| Cita | Justificación |
|------|---------------|
| `temp-holding/Modules/*.py` | Código de referencia histórico que informó la decisión ORM+SQL híbrida |

### Material a NO CITAR

- `temp-holding/GENERACION_DOCUMENTACION/MAPA_RBAC_COMPLETO_v1_0_0.md` — referencia CNST_005 que ya no existe; reemplazado por CNST-029..033.
- `temp-holding/RBAC/MODELO_RBAC_IACT_v5_1.md` y v5.1.1.md — versiones intermedias supersedidas por v5.2.1.
- `temp-holding/project/decisions.md` — template vacío.

## Implicaciones para Phase 5 STRATEGY (Z.1)

1. **Opción C (2 ADRs nuevos) sigue válida** — el material en
   temp-holding la **fortalece**, no la cuestiona.

2. **ADR-GOB-009 gana 3 referencias históricas** que sustentan la
   decisión:
   - Genealogía v4.0 → v5.0 → v5.1 → v5.2.1
   - Análisis de errores que motivó v5.2.1
   - Decisión "8 módulos" trazable

3. **ADR-BACK-005 puede mencionar** el código legacy de
   `temp-holding/Modules/` como "diseño de referencia heredado"
   sin afirmar implementación actual (consistente con framing
   "spec abstracta").

4. **NO hay material en temp-holding que invalide la estrategia
   actual.** El corpus `source/` v5.2.1 + CNST-033 + ADR-GOB-008
   ya consolida lo que temp-holding intentaba reconciliar de
   forma fragmentaria.

## Calibración

- **OBSERVABLE:** 18 claims (verificados con find, grep, head sobre
  archivos en temp-holding/).
- **INFERRED:** 5 claims (interpretación de relevancia para Z.1).
- **SPECULATIVE:** 0.
- **Ratio:** 23/23 = 1.0 ≥ 0.75 ✓

## Próximo paso

Phase 5 STRATEGY de Z.1: confirmar Opción C + diseñar estructura
de los 2 ADRs nuevos, incorporando referencias históricas de este
inventario.
