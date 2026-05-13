```yml
created_at: 2026-04-28 14:30:00
project: IACT-docs
work_package: 2026-04-28-05-28-43-source-rebuild-normativa-restricciones
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Cross-WP Debt — Síntesis y Plan

Síntesis ejecutiva de los hallazgos de los 3 análisis paralelos
(extracción backup, base_cognitiva, temp-holding) con clasificación
por destino: este WP vs WPs futuros.

## Para este WP (enriquecimiento de los 31 CNSTs)

### E-1: Tipología canónica 3 ejes (Técnica/Negocio/Regulatoria)

`TXM_01:386-397` define el tipo como atributo obligatorio. Cada uno
de los 31 CNSTs DEBE declarar su tipo en el "Resumen Ejecutivo".

Asignación propuesta:

| CNST | Tipo |
|------|------|
| CNST_001 (email) | Negocio |
| CNST_002 (buzón) | Negocio |
| CNST_003-005 (sesiones) | Tecnica |
| CNST_006-007 (BD) | Tecnica |
| CNST_008 (ETL) | Tecnica |
| CNST_009-014 (DRF) | Tecnica |
| CNST_015-016 (arquitectura) | Tecnica |
| CNST_017-020 (perf/export) | Tecnica |
| CNST_021-023 (infra) | Tecnica |
| CNST_024 (logs JSON) | Tecnica |
| CNST_025 (auditoría inmutable) | Regulatoria |
| CNST_026 (PII no logs) | Regulatoria |
| CNST_027-028 (datos) | Regulatoria |
| CNST_029-031 (RBAC) | Tecnica |

### E-2: Parámetros cuantitativos rescatables (23 valores)

Verificar que los 31 CNSTs incluyen estos valores específicos
identificados en `RESTRICCIONES COMPLETAS.md`:

- CNST_005: timeout sesión exactamente 15 min
- CNST_008: ETL 6-12 h (no menor a 6h)
- CNST_011: throttle anon 100/h, user 10k/day, login 5/5min/IP
- CNST_009: JWT access 15 min, refresh 7d con rotate+blacklist
- CNST_017: SLA por tipo (5s/10s/300s reportes; 500ms/1s/2s API; 3s
  dashboard inicial)
- CNST_014: pantalla máx 50 000 registros, paginación default 50
- CNST_018: rango fechas máx 2 años
- CNST_019: export CSV/Excel máx 100k, PDF máx 10k
- CNST_020: límites diarios por rol (BÁSICO 5, COORD 20, ADMIN ∞)
- CNST_031: justificación ≥20 caracteres, vencimiento ≤6 meses

### E-3: UCs afectados (14 UCs IACT mapeados)

Sección "Impacto en Sistema → UCs Afectados" debe incluir los UCs
identificados en `RESTRICCIONES COMPLETAS.md` (file:line en
`temp-holding-cross-wp-debt.md`).

### E-4: Trazabilidad inversa CNST → BR

`FND_00:599-607` y `FND_07:561-563` declaran:

- CNST_001 → notificaciones via buzón → afecta UC-010, UC-036..040
- CNST_007 (legacy = Performance) → BR_011 (límites exportación)

Para CNSTs sin BR documentada en base cognitiva: marcar
"(pendiente WP requisitos)" en sección Trazabilidad → BR Derivadas.

### E-5: HSTS específico

`RESTRICCIONES:182` declara HSTS = 31 536 000 s (1 año). No tiene
CNST atómico evidente. Decisión: incluir en CNST_009 (Auth DRF) o
CNST_028 (Cifrado). Asignado a **CNST_028**.

### E-6: Excepciones — tres patrones documentados

| Patrón | Aplica a | Origen |
|--------|----------|--------|
| "Sin excepción" default rígido | CNST_001, 003, 007, 025, 027, 030 | PARTE 1:1050 |
| Aprobación formal genérica | CNSTs operativos (008, 011, 017-020) | PARTE 1:1055 |
| Justificación ≥20 ch + venc ≤6 meses | CNST_031 (permisos temporales) | RBAC v5.2.1:619-623 |

## Para WPs futuros

### W-1: ID realignment base_cognitiva ↔ rebuild

**Drift crítico:** `FND_00:151-153` y `FND_00:382, 514` referencian
`CNST_001/003/004/007/009` con semánticas distintas a la del
rebuild. Solo CNST_001 mantiene el sentido. La base cognitiva tiene
ejemplos rotos:

- `CNST_007 = Performance/Límites Exportación` (base) vs
  `CNST_007 = BD IVR Solo Lectura` (rebuild)
- `CNST_009 = Auditoría` (base) vs `CNST_009 = Autenticación DRF`
  (rebuild)

**WP destino:** nuevo `cnst-id-realignment-base-cognitiva` (Stage
TRACK del WP de base_cognitiva o WP independiente). Debe ejecutar
refactor cross-repo en `_fundamentos_conceptuales/`,
`_ontologia_sbvr/`, `_taxonomias_y_metamodelos/`.

### W-2: Catálogo BRs IACT pendiente

Las BRs encontradas en temp-holding son ejemplos pedagógicos
(químicos/OSHA), no IACT. El catálogo BR_NNN real del dominio NO
existe aún.

**WP destino:** WP `requisitos` (#5 o #6 del padre, ya planeado).
Insumo: `MODELO_RBAC_IACT_v5_2_1.md` (42 funciones atómicas).

### W-3: Catálogo UCs IACT formal

UCs aparecen como referencias sueltas (UC_001..UC_042) sin catálogo
formal. Necesita catalogación en formato TPL_UC.

**WP destino:** WP `requisitos`.

### W-4: PROC_Excepciones_CNST

No existe proceso formal de waiver/exception. Solo menciones
genéricas a "aprobación formal" sin protocolo (formulario,
aprobador, ventana de validez).

**WP destino:** WP `gobernanza` (#7 estimado). Crear
`PROC_Excepciones_CNST.rst`.

### W-5: ADRs RBAC v5.x

`MODELO_RBAC_IACT_v5_2_1.md:27` documenta cambios v5.2.0→v5.2.1
(terminología "44 → 42 funciones", CNST gap report). Son ADRs
latentes.

**WP destino:** `decisions/` global o WP arquitectura técnica.

### W-6: Guía de Patrones Recomendados

`PROPUESTA_AMPLIACIONES_CNST_005-006.md` describe Service Layer,
Custom Manager, Django Signals, Factory/Adapter/Strategy patterns.
Es contenido positivo (qué SÍ usar) — complementa CNST_015
(antipatrones) pero NO es restricción.

**WP destino:** `arquitectura-tecnica` — crear guía de patrones
recomendados como artefacto separado de los CNSTs.

### W-7: Conteo de CNSTs en estadísticas IACT desactualizado

`TXM_01:541-542` declara "Constraints (CNST) = 4" y `FND_00:231`
dice "10 Restricciones arquitectónicas (CNST)". El rebuild produjo
31. Sincronizar contadores en META/TXM/FND.

**WP destino:** `cnst-id-realignment-base-cognitiva` (mismo W-1).

### W-8: BR_011↔CNST_007 ejemplo profundo a replicar

`FND_00:276-607` es un ejemplo de 294 líneas de relación profunda
BR↔CNST. Generar el mismo nivel de detalle para CNST_001, CNST_025
(auditoría inmutable), CNST_030 (SoD).

**WP destino:** WP `requisitos` cuando se materialicen las BRs.

## Referencias

- `analyze/base-cognitiva-cnst-references.md`
- `analyze/temp-holding-cross-wp-debt.md`
- `analyze/single-responsibility-analysis.md`
- `analyze/temp-holding-exhaustive-search.md`
