```yml
created_at: 2026-04-28 18:30:00
project: IACT-docs
work_package: 2026-04-28-05-28-45-source-rebuild-requisitos
phase: Phase 1 — DISCOVER (concentracion: inventario NFR)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Inventario NFR — v4.0.0 modular ISO 25010

## Premisa

Los 15 IDs detectados por el indexer revelan dos patrones legacy:

1. **Patron jerarquico** `NFR-XXX.N` donde XXX = UC origen, N = sub-aspecto.
   Ejemplos: NFR-61.1 a NFR-61.5 (5 sub-aspectos del UC-061), NFR-110.1
   a NFR-110.9 (9 sub-aspectos), NFR-62.1 a NFR-62.6.
2. **Patron modular incipiente** `NFR_<TIPO>_NN`. Ejemplos:
   NFR_PERF_001, NFR_REL_001, NFR_SEC_001, NFR_SEC_05.

## Propuesta v4.0.0 modular (ISO 25010)

Adoptar nomenclatura modular alineada con los atributos de calidad
ISO 25010, consistente con la propuesta v4.0.0 de UCs:

| Tipo | Atributo ISO 25010 | Ejemplos en inputs |
|------|---------------------|---------------------|
| `NFR_PERF` | Performance Efficiency | NFR-110.6, NFR-61.1, NFR-62.2 |
| `NFR_SEC` | Security | NFR-110.1..5, NFR-62.4, NFR_SEC_05 |
| `NFR_REL` | Reliability (incl. disponibilidad) | NFR-110.7, NFR-61.5, NFR-62.6 |
| `NFR_USAB` | Usability (incl. A11y) | NFR-110.9, NFR-61.3 |
| `NFR_AUD` | Auditability (cross-cutting con SEC) | NFR-110.8, NFR-62.5 |
| `NFR_FUNC` | Functional Suitability | NFR-001 (tiempo de respuesta API) |
| `NFR_COMPAT` | Compatibility | (no detectado, propuesto) |
| `NFR_MAINT` | Maintainability | (no detectado, propuesto) |

## Inventario IACT canonico (consolidado de inputs)

### NFR_PERF (Performance Efficiency)

| ID v4.0.0 | Descripcion | Origen legacy | Valor cuantitativo |
|-----------|-------------|---------------|---------------------|
| NFR_PERF_01 | Login completa en < 1 s (p95) | NFR-110.1 / NFR_PERF_001 | 1 s p95 |
| NFR_PERF_02 | API GET responde < 500 ms (p95) | (cross CNST_017 SLA) | 500 ms |
| NFR_PERF_03 | API POST/PUT responde < 1 s (p95) | (cross CNST_017 SLA) | 1 s |
| NFR_PERF_04 | Reporte simple < 5 s | NFR-61.1 | 5 s |
| NFR_PERF_05 | Reporte complejo < 10 s | (cross CNST_017) | 10 s |
| NFR_PERF_06 | Analisis exploratorio < 300 s (5 min) | (cross CNST_017) | 300 s |
| NFR_PERF_07 | Dashboard carga inicial < 3 s | (cross CNST_017) | 3 s |
| NFR_PERF_08 | Soporta 100 logins simultaneos | NFR-110.2 / NFR-002 | 100 concurrentes |
| NFR_PERF_09 | Pantalla maximo 50 000 registros | (cross CNST_014) | 50 000 |

### NFR_SEC (Security)

| ID v4.0.0 | Descripcion | Origen legacy | Valor cuantitativo |
|-----------|-------------|---------------|---------------------|
| NFR_SEC_01 | Password con bcrypt cost >= 12 | NFR-110.3 | bcrypt 12+ |
| NFR_SEC_02 | Sesion con cookie HttpOnly + Secure | NFR-110.4 | HttpOnly+Secure |
| NFR_SEC_03 | Bloqueo cuenta tras 5 intentos fallidos | NFR-110.5 | 5 intentos |
| NFR_SEC_04 | Throttling login 5/5min/IP | (cross CNST_011) | 5/5min/IP |
| NFR_SEC_05 | Auditoria inmutable append-only | NFR_SEC_05 / (cross CNST_025) | Inmutable |
| NFR_SEC_06 | Cifrado en transito TLS 1.2+ | NFR_SEC_001 / (cross CNST_028) | TLS 1.2+ |
| NFR_SEC_07 | HSTS 1 ano (31536000 s) | (cross CNST_028) | 31536000 s |
| NFR_SEC_08 | Cifrado en reposo Confidential/Restricted | (cross CNST_028) | pgcrypto |

### NFR_REL (Reliability)

| ID v4.0.0 | Descripcion | Origen legacy | Valor cuantitativo |
|-----------|-------------|---------------|---------------------|
| NFR_REL_01 | Disponibilidad >= 99.5% | NFR-003 / NFR_REL_001 | 99.5% |
| NFR_REL_02 | RTO rollback < 60 s | (cross CNST_023) | 60 s |
| NFR_REL_03 | RPO ETL ventana 6-12h | (cross CNST_008) | 6-12 h |
| NFR_REL_04 | Sesion timeout 15 min | (cross CNST_005) | 15 min |
| NFR_REL_05 | Transaccionalidad ACID en BD Analytics | NFR-62.1 | ACID |

### NFR_USAB (Usability)

| ID v4.0.0 | Descripcion | Origen legacy | Valor cuantitativo |
|-----------|-------------|---------------|---------------------|
| NFR_USAB_01 | Formulario WCAG 2.1 nivel AA | NFR-40.1 | WCAG 2.1 AA |
| NFR_USAB_02 | Mensajes de error claros y accionables | NFR-110.9, NFR-61.3 | (cualitativo) |
| NFR_USAB_03 | Timestamp ultima ETL visible en UI con datos IVR | (cross CNST_008) | Visible |

### NFR_AUD (Auditability)

| ID v4.0.0 | Descripcion | Origen legacy | Valor cuantitativo |
|-----------|-------------|---------------|---------------------|
| NFR_AUD_01 | Cada accion sensible registra evento en AuditLog | NFR-110.8, NFR-62.5 | 100% acciones |
| NFR_AUD_02 | Retencion de auditoria minimo 7 anos | (cross CNST_025) | 7 anos |
| NFR_AUD_03 | Logs estructurados JSON | (cross CNST_024) | JSON obligatorio |

## Trazabilidad NFR ↔ CNST

Muchos NFRs son la cara "cuantitativa" de CNSTs declaratorios:

| NFR | CNST canonico | Relacion |
|-----|---------------|----------|
| NFR_PERF_02..07 | CNST_017 SLA Tiempos Respuesta | NFR materializa los SLA del CNST |
| NFR_PERF_09 | CNST_014 Paginacion Obligatoria | Mismo limite |
| NFR_SEC_04 | CNST_011 Throttling Endpoints Publicos | Mismo limite |
| NFR_SEC_05 | CNST_025 Auditoria Inmutable | NFR cuantitativo del CNST |
| NFR_SEC_06,07,08 | CNST_028 Cifrado Datos Confidenciales | NFR materializa parametros |
| NFR_REL_02 | CNST_023 Rollback Obligatorio | RTO del CNST |
| NFR_REL_03 | CNST_008 ETL Ventana | NFR cuantitativo |
| NFR_REL_04 | CNST_005 Timeout Sesion | NFR cuantitativo |
| NFR_AUD_01,02 | CNST_025 Auditoria Inmutable | NFR cuantitativo |
| NFR_AUD_03 | CNST_024 Logs Estructurados JSON | NFR cuantitativo |

## NFRs no integrados (deuda)

- NFR_MAINT_NN — no detectados, pero IACT requiere al menos:
  cobertura de tests >= 80%, complejidad ciclomatica < 10. Pendiente WP
  quality.
- NFR_COMPAT_NN — no detectados. Pendiente: navegadores
  soportados, versiones API, retrocompatibilidad de migrations.
- NFR_PORTAB_NN — no detectados. Pendiente: deployment portable
  Ubuntu LTS, Docker dev (cross CNST_021).

## Total propuesto v4.0.0

- NFR_PERF: 9
- NFR_SEC: 8
- NFR_REL: 5
- NFR_USAB: 3
- NFR_AUD: 3
- **Total**: **28 NFRs IACT canonicos**

## Hallazgos para Phase 2

1. **Decision D-REQ-N1**: adoptar ISO 25010 como taxonomia raiz de
   NFRs (en lugar de "categoria libre").
2. **Decision D-REQ-N2**: cada NFR cuantitativo que materializa un CNST
   debe declararlo en su trazabilidad (campo "CNST Origen").
3. **Decision D-REQ-N3**: NFRs jerarquicos legacy (NFR-110.1..9) se
   descomponen en NFRs atomicos por atributo de calidad (un NFR por
   tipo, no un NFR multitemica).
4. **Hallazgo H-NFR-1**: 28 NFRs vs 15 detectados — los faltantes
   provienen de cross-CNST (no estaban como NFR explicito en inputs,
   pero CNSTs ya los declaran cuantitativamente). Decision: incluirlos
   en el rebuild de NFRs como duales del CNST origen.
