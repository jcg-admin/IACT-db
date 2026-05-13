```yml
created_at: 2026-04-28 09:00:00
project: IACT-docs
work_package: 2026-04-28-05-28-43-source-rebuild-normativa-restricciones
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Aprobado
version: 2.0.0
```

# Mapeo Viejo → Nuevo (CNST) — SRP-31

> Tabla canónica para que WP #6 requisitos migre referencias desde el
> set anterior al set rebuild SRP. Aplica descomposición a 31 CNSTs
> atómicas (single responsibility).

## Tabla de mapeo (concepts → atomic CNSTs)

| Concepto / CNST viejo (backup) | CNSTs nuevos atómicos | Notas |
|--------------------------------|------------------------|-------|
| **CNST_001 Comunicaciones_Prohibidas** | CNST_001 Prohibicion_Email_SMTP · CNST_002 Buzon_Interno_Obligatorio | 2 concerns separados |
| **CNST_002 Gestion_Sesiones_BD** | CNST_003 Sesiones_Persistidas_BD · CNST_004 Sesion_Unica · CNST_005 Timeout_15min | 3 concerns separados |
| **CNST_003 Base_Datos_Dual_Inmutable** | CNST_006 BD_Dual_Arquitectura · CNST_007 BD_IVR_Solo_Lectura | 2 concerns: arquitectura + inmutabilidad |
| **CNST_004 Actualizacion_Datos_ETL** | CNST_008 ETL_Ventana_6_12h | Consolidado |
| **CNST_005 Seguridad_DRF_Checklist** | CNST_009..014 (6 CNSTs: Auth · Permission · Throttling · Validacion · Excepciones · Paginacion) | Descompuesto el checklist |
| **CNST_006 Antipatrones_Arquitectura** | CNST_015 Antipatrones · CNST_016 SOLID | Patrones recomendados → out of scope (va a `estandares/`) |
| **CNST_007 Limites_Performance_SLA** | CNST_017 SLA · CNST_018 Rango_2A · CNST_019 Async · CNST_020 Throttling_Export | 4 concerns separados |
| **CNST_008 Infraestructura_Deployment** | CNST_021 Stack · CNST_022 Estructura_Dirs · CNST_023 Rollback | Procedimiento deploy → out of scope (va a `procedimientos/`) |
| **CNST_009 Logging_Auditoria_Inmutable** | CNST_024 Logs_JSON · CNST_025 Auditoria_Inmutable · CNST_026 PII_No_Logs | 3 concerns separados |
| **CNST_010 Clasificacion_Proteccion_Datos** | CNST_027 Clasificacion_4N · CNST_028 Cifrado | 2 concerns separados |
| **CNST_012 RBAC_Flat_SoD_Permisos** | CNST_029 RBAC_Flat · CNST_030 SoD_Reglas · CNST_031 Permisos_Temporales | Renumerado y descompuesto |

## Mapeo de referencias (auto-update guidance)

| Referencia anterior | Referencia nueva |
|---------------------|------------------|
| `CNST-001`, `CNST_001`, `:doc:`CNST_001_Comunicaciones_Prohibidas`` | `CNST_001` (email) o `CNST_002` (buzon) según contexto |
| `CNST-002`, `CNST_002` | `CNST_003`, `CNST_004` o `CNST_005` según contexto |
| `CNST-003`, `CNST_003` | `CNST_006` o `CNST_007` |
| `CNST-004`, `CNST_004` | `CNST_008` |
| `CNST-005`, `CNST_005` | `CNST_009..014` según concern |
| `CNST-006`, `CNST_006` | `CNST_015` o `CNST_016` |
| `CNST-007`, `CNST_007` | `CNST_017..020` según concern |
| `CNST-008`, `CNST_008` | `CNST_021..023` |
| `CNST-009`, `CNST_009` | `CNST_024..026` |
| `CNST-010`, `CNST_010` | `CNST_027` o `CNST_028` |
| `CNST-012`, `CNST_012` | `CNST_029..031` según concern |

## Concerns originales NO migrados (decisiones D-CNST)

- **Patrones de Diseño Recomendados** (de CNST_006 backup) → no es
  restricción, va a `normativa/estandares/` o guías de arquitectura.
- **Procedimiento de Deployment** (de CNST_008 backup) → no es
  restricción, va a `normativa/procedimientos/`.
- **Implementación detallada del checklist DRF** (CNST_005 backup) →
  detalles de implementación van al codebase backend; los CNSTs
  atómicos describen solo qué se requiere.
- **CNST_05 Restriccion_Creacion_Iterativa** (TH-FASE 01 standalone)
  → no es restricción del sistema IACT, es regla de proceso de
  generación documental. Diferida a iteración futura del WP de
  procedimientos.

## CNSTs nuevos respecto al backup canónico

Estos concerns NO existían explícitamente como CNST en backup pero
estaban subsumidos en otros CNST o en temp-holding:

| Nuevo | Origen del concept |
|-------|--------------------|
| CNST_002 Buzon_Interno_Obligatorio (con límites cuantitativos) | TH-CNST_004 Alertas_Buzon_Interno (50 destinatarios + consolidación) |
| CNST_018 Rango_Maximo_2_Anos | TH-CNST_006 Reportes_Limites_Rango |
| CNST_020 Throttling_Exportacion (tabla por formato CSV/Excel/PDF) | TH-CNST_007 Limites_Exportacion_Throttling |
| CNST_016 Principios_SOLID | Implícito en CNST_006 backup (Antipatrones), ahora explícito |
| CNST_022 Estructura_Directorios_Servidor | Sub-concern de CNST_008 backup |

## Versión del set canónico

- Set: 31 CNST (CNST_001..CNST_031), gap eliminado.
- Versión metadata: 1.0.0 (rebuild SRP fresh).
- Estado: Vigente.
- Build: 0 warnings, 0 errors al cierre del WP.
