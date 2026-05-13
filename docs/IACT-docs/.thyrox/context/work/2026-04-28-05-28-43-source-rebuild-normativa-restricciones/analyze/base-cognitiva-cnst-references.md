```yml
created_at: 2026-04-28 00:00:00
project: IACT-docs
work_package: 2026-04-28-05-28-43-source-rebuild-normativa-restricciones
phase: Phase 3 — ANALYZE
author: claude
status: Aprobado
version: 1.0.0
```

# Referencias a CNSTs en `source/base_cognitiva/`

Análisis de qué dice la base cognitiva sobre los CNSTs y qué de eso podría
no estar reflejado en el rebuild de los 31 archivos en
`source/normativa/restricciones/`.

## Definiciones canónicas de CNST

- `source/base_cognitiva/glosario.rst:341` — "**CNST** Restricción Arquitectónica".
- `source/base_cognitiva/_taxonomias_y_metamodelos/taxonomias/TXM_02_Taxonomia_Artefactos.rst:252-257` —
  "3.4 Restriccion (CNST_) / Ubicacion: normativa/restricciones/ / Proposito:
  Limitaciones impuestas al proyecto."
- `source/base_cognitiva/_taxonomias_y_metamodelos/taxonomias/TXM_01_Taxonomia_Requisitos.rst:380` —
  "Prefijo: CNST_NNN".
- `TXM_01:389-397` — tres tipos canónicos: **Tecnica** ("BD origen MySQL solo lectura"),
  **Negocio** ("Sin envio de correo electronico externo"), **Regulatoria**
  ("Logs de auditoria inmutables (compliance)").
- `TXM_01:557` — proporción esperada `CNST : 5-15 (limitaciones)`.
- `TXM_01:597-599` — árbol de decisión: "¿Es una limitacion impuesta? → SI → CONSTRAINT (CNST)".
- `TXM_01:464-466` — Nivel de abstracción: pregunta = "Que limita?", estabilidad = "Muy alta".

## Relaciones declaradas (CNST ↔ otros artefactos)

| Origen | Artefacto/relación | Cita |
|---|---|---|
| `TXM_01:479` | CNST regulatorio ↔ BR (regulaciones) — origen Externo | TXM_01_Taxonomia_Requisitos.rst:478-480 |
| `TXM_01:482` | CNST negocio ↔ BR (politicas) + BReq — origen Organizacional | TXM_01:481-483 |
| `TXM_01:488` | CNST tecnico ↔ FR + NFR — origen Sistema | TXM_01:487-489 |
| `TXM_01:502` | CNST verificable por **Inspeccion** (revisión documental) | TXM_01:501-503 |
| `FND_02:681` | Jerarquía: BR `+---> CNST (Restriccion Tecnica)` | FND_02_Reglas_de_Negocio.rst:681 |
| `FND_01:315-316` | "FUENTE 3: Restricciones del Cliente (CNST) — CNST-001: NO usar email…" | FND_01_Concepto_Requisito.rst:315 |
| `FND_00:287,298` | BR_011 ↔ CNST_007 (Performance) — "Se integra con una restricción arquitectónica" | FND_00:287, 298 |
| `FND_00:599-607` | CNST → origina → BR → afecta → UCs (cadena explícita) | FND_00:597-607 |
| `MTM_03:702` | Modelo RBAC apunta a `/normativa/restricciones/CNST_029_RBAC_Modelo_Plano` | MTM_03_Metamodelo_RBAC.rst:702 |
| `SBVR_04:287,522,724,769,822` | DEO-008 / DEO-017 referencian `CNST_001` como justificación | SBVR_04:287, 522 |

## BRs derivadas conocidas (BR específica → CNST origen)

| BR | CNST origen | Evidencia |
|---|---|---|
| BR_011 (Límites de Exportación) | CNST_007 (Performance / "Límites de Exportación" en base cognitiva) | `FND_00:298, 488, 562-607` — tabla "Diferencia entre BR y CNST" |
| (regla operativa) Notificaciones via buzón | CNST_001 | `SBVR_01_Conceptos_Nucleares.rst:588`; `SBVR_04:287, 522` |
| FR derivada "NO enviar email externo" | CNST_001 | `FND_07_Requerimientos_Funcionales.rst:561-563` (Origen: UC-010 / CNST_001) |

## Hallazgos para enriquecer los 31 CNSTs

1. **Drift de IDs base_cognitiva ↔ rebuild.** `FND_00:151-153` afirma
   `CNST_003 = BD Dual`, `CNST_004 = ETL nocturno`, `CNST_001 = solo
   notificaciones internas`. En el rebuild, `BD Dual` está en CNST_006 y
   `ETL nocturno` en CNST_008; `CNST_003 = Sesiones Persistidas` y
   `CNST_004 = Sesion Unica`. Solo CNST_001 mantiene el sentido. El
   rebuild debería declarar explícitamente la nueva numeración o renumerar;
   actualmente la base cognitiva queda desincronizada.
2. **CNST_007 = Límites de Exportación (en base cognitiva) ≠ rebuild.**
   `FND_00:298,562-607` y `TXM_01` ejemplifican CNST_007 como "Performance /
   Límites de Exportación", relación ancla con BR_011. En el rebuild,
   CNST_007 = "BD IVR Solo Lectura" y los límites de exportación están
   distribuidos en CNST_017 (SLA), CNST_019 (asíncronas >10k), CNST_020
   (throttling). El rebuild no preserva el vínculo BR_011↔CNST_007 ni la
   "tabla de diferencias BR vs CNST" de `FND_00:567-594`.
3. **Tipología canónica de 3 ejes ausente.** `TXM_01:386-397` define los
   tipos Tecnica / Negocio / Regulatoria como atributo obligatorio. Verificar
   que cada CNST_NNN del rebuild declare explícitamente su tipo según esta
   taxonomía (criterio de inspección de `TXM_01:502`).
4. **`CNST_009 = Auditoría` en `FND_00:382, 514`.** El código del WP de
   FND_00 referencia "UserActionLog (CNST_009)" como "registrar auditoría".
   En el rebuild, CNST_009 = "Autenticación DRF Obligatoria" y la auditoría
   inmutable está en CNST_025. Otro caso de drift que conviene mapear.
5. **Trazabilidad inversa CNST→BR/UC/FR no presente.** `FND_00:599-607`
   establece la cadena `CNST → origina BR → afecta UC`. Los archivos
   CNST_NNN del rebuild deberían declarar en su sección "Trazabilidad" qué
   BRs origina y qué UCs afecta (al menos para CNST_001, CNST_007 originales,
   donde la base cognitiva ya lo dice).

## Hallazgos para WPs futuros

1. **Tabla de mapping ID-legacy↔ID-rebuild de CNSTs.** Generar un mapping
   estable y ejecutar refactor cross-repo de citas en
   `_fundamentos_conceptuales/`, `_ontologia_sbvr/`, `_taxonomias_y_metamodelos/`.
   *WP destino:* `cnst-id-realignment-base-cognitiva`.
2. **Ejemplo BR_011↔CNST_007 como estándar de documentación de relaciones.**
   `FND_00:276-607` es un ejemplo profundo (294 líneas) que actualmente no
   tiene equivalente en otros pares BR↔CNST. Generar el mismo nivel de
   detalle para CNST_001 (vs. reglas de notificación) y CNST_025 (vs.
   reglas de auditoría inmutable). *WP destino:* `br-cnst-relation-examples`.
3. **Conteo de CNSTs en estadísticas IACT desactualizado.** `TXM_01:541-542`
   declara "Constraints (CNST) = 4" y `FND_00:231` dice "10 Restricciones
   arquitectónicas (CNST)". El rebuild produjo 31. Sincronizar contadores
   en META/TXM/FND. *WP destino:* `base-cognitiva-statistics-sync`.
