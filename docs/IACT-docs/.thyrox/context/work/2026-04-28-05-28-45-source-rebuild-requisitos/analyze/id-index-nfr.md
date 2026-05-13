```yml
created_at: 2026-04-28 18:00:00
project: IACT-docs
work_package: 2026-04-28-05-28-45-source-rebuild-requisitos
phase: Phase 1 — DISCOVER (concentracion: indice maestro de IDs)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Indice Maestro de IDs — NFR

Total IDs unicos NFR: **15**

Producido por scan automatizado (`/tmp/index_requirements_ids.py`) sobre todos los `inputs/` de los 16 WPs hijos.

## IDs detectados

| ID | # apariciones | WPs distintos | Contexto sample |
|----|---------------|---------------|----------------|
| `NFR-001` | 4 | base-cognitiva, normativa-estandares, arquitectura-tecnica | NFR_001  → Tiempo de respuesta de API |
| `NFR-002` | 2 | base-cognitiva | NFR-002: Sistema DEBE soportar 100 usuarios simultaneos |
| `NFR-003` | 2 | base-cognitiva | NFR-003: Disponibilidad DEBE ser >= 99.5% |
| `NFR-004` | 1 | arquitectura-tecnica | │       └── NFR_001 a NFR_004 |
| `NFR-007` | 2 | base-cognitiva | - NFR-007: Septimo requisito no funcional |
| `NFR-020` | 1 | normativa-estandares | NFR_020  → Cifrado de datos en tránsito |
| `NFR-040` | 6 | base-cognitiva, normativa-estandares, requisitos (+1) | NFR-40.1: "Formulario DEBE ser accesible WCAG 2.1 nivel AA" |
| `NFR-060` | 1 | normativa-estandares | NFR_060  → Disponibilidad del sistema |
| `NFR-061` | 25 | base-cognitiva, requisitos, backend (+1) | NFR-61.1: "Consulta de solicitudes DEBE retornar en < 2 seg |
| `NFR-062` | 24 | base-cognitiva, backend | **NFR-62.1: Transaccionalidad (ACID)** |
| `NFR-110` | 72 | base-cognitiva, requisitos, backend (+1) | NFR-110.1: Login DEBE completar en < 1 segundo (95th percentile) |
| `NFR-PERF-001` | 1 | normativa-procedimientos | - NFR_PERF_001: Tiempo de respuesta API |
| `NFR-REL-001` | 1 | normativa-procedimientos | - NFR_REL_001: Disponibilidad 99.5% |
| `NFR-SEC-001` | 1 | normativa-procedimientos | - NFR_SEC_001: Cifrado de datos |
| `NFR-SEC-005` | 1 | requisitos | NFR_SEC_05: Auditoría Inmutable |

## Distribucion por modulo (si aplica)

- **(sin modulo)** (11): NFR-001, NFR-002, NFR-003, NFR-004, NFR-007, NFR-020, NFR-040, NFR-060, NFR-061, NFR-062...
- **PERF** (1): NFR-PERF-001
- **REL** (1): NFR-REL-001
- **SEC** (2): NFR-SEC-001, NFR-SEC-005

## Top archivos con mas IDs NFR

| Archivo | # IDs |
|---------|-------|
| `canonical/PARTE_3B_Tecnica_Larman_IACT_1_0_0.md` | 20 |
| `canonical/PARTE3B_TECNICA_LARMAN_COMPLETA.md` | 20 |
| `canonical/PARTE_3B_temp.md` | 20 |
| `canonical/PARTE_3B_Tecnica_Larman_IACT_1_0_0.md` | 20 |
| `canonical/PARTE_4_Requisitos_Funcionales_IACT_1_0_0.md` | 9 |
| `canonical/De Reglas de Negocio a Sistema Completo.md` | 9 |
| `canonical/PARTE 4 - ESPECIFICAR REQUERIMIENTOS FUNCIONALES - 661ca8.md` | 9 |
| `canonical/PARTE_4_Requisitos_Funcionales_IACT_1_0_0.md` | 9 |
| `canonical/PARTE4_SECCION1_INTRODUCCION_COMPLETA.md` | 9 |
| `canonical/TPL_NFR_No_Funcionales_1_0_0.rst` | 4 |
| `variants/temp-holding/FASE 02/originales/FND_01_Concepto_Requisito.rst` | 4 |
| `variants/temp-backup/source-2026-04-28/base_cognitiva/_fundamentos_conceptuales/FND_01_Concepto_Requisito.rst` | 4 |
| `canonical/PROC_Generacion_NFR_1_0_0.rst` | 3 |
| `canonical/MODELO_DOCUMENTAL_IACT_v2_1_1.md` | 2 |
| `canonical/analisis_parte4_completo.md` | 1 |
