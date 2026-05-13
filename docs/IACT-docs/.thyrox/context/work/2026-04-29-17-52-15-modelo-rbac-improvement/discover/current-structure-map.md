```yml
created_at: 2026-04-29 17:55:00
project: IACT-docs
work_package: 2026-04-29-17-52-15-modelo-rbac-improvement
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Current Structure Map — modelo-rbac-iact.rst

## Hechos verificados

| Métrica | Valor |
|---------|-------|
| Path | `source/arquitectura-tecnica/rbac/modelo-rbac-iact.rst` |
| Líneas totales | **2558** |
| Última edición | 2026-04-29 (este WP) |
| `:version:` declarado | **5.2.1** (NO sigue STD_006 SemVer 2.0.0 — mayor.minor.patch sí, pero estado de pre-1.0 sería discutible) |
| `:fecha_creacion:` | 2026-01-13 |
| `:autor:` | NestorMonroy |
| `:estado:` | Vigente — **NO canónico** (STD_007 v2.0.2 §6.1 dice {Borrador, En Revisión, Aprobado, Deprecado}) |
| `:dominio:` | `arquitectura_tecnica` — **NO canónico** (debe ser `arquitectura-tecnica` kebab) |
| `:tipo:` | "Modelo Arquitectonico" — no aparece en lista canónica de §6.1 |
| `:clasificacion:` | Critico — **NO canónico** (STD_007 §6.2 dice {Interno, Público, Confidencial}) |
| `:ultimo_cambio:` | presente ✓ |
| `:subdominio:` | `rbac` ✓ |
| Anchor label | `.. _modelo-rbac-iact:` ✓ |

## Mapa de secciones (12 secciones H1)

| H1 | Líneas | Sub-secciones | Tema |
|----|-------:|--------------:|------|
| Cabecera (sin numerar) | 16-148 | varias | Título del modelo, control de cambios, estándar nomenclatura, tabla de contenido |
| 1. FILOSOFÍA DEL MODELO | 149-188 | 2 (1.1, 1.2) | Principio central, enfoque sin pretensiones |
| 2. ARQUITECTURA IACT | 189-257 | 1 (2.1) | Distribución de 42 funciones |
| 3. CATÁLOGO DE 42 FUNCIONES | 258-744 | 8 (3.1-3.8 por MOD) | Auth, Users, Access, Pipeline, Reports, Alerts, Audit, Logs |
| 4. LOS 10 GRUPOS DE FUNCIONES | 745-1029 | 12 (4.1, 4.2 + 10 AGR-NNN) | Catálogo y detalle de grupos AGR-001 a AGR-010 |
| 5. SEPARACIÓN DE FUNCIONES (SoD) | 1030-1132 | 4 (5.1 + 3 SOD-NNN) | 3 restricciones SoD |
| 6. PERMISOS TEMPORALES | 1133-1182 | 3 (6.1-6.3) | Concepto, reglas, ejemplo |
| 7. MODELO DE DATOS | 1183-1202 | 1 (7.1) | Tablas |
| 8. IMPLEMENTACIÓN SQL | 1203-1535 | 10 (8.1-8.10) | DDL + datos iniciales 42 fn + 10 grp + 3 SoD |
| 9. IMPLEMENTACIÓN DJANGO | 1536-2205 | 5 (9.1-9.5) | Models, Service, Decorator, Middleware, Mgmt Command |
| 10. MAPEO FUNCIONES → CASOS DE USO | 2206-2353 | 1 (10.1) | Tabla mapping |
| 11. MIGRACIÓN DESDE v5.2.0 | 2354-2484 | 2 (11.1-11.2) | Cambios breaking + script SQL |
| 12. RESUMEN | 2485-2558 | 2 (12.1-12.2) | Métricas + cambios clave |

## Observaciones del mapa

### Distribución por tipo de contenido

| Tipo | Líneas aprox | % |
|------|-------------:|--:|
| Conceptual (filosofía, arquitectura, principios) | ~150 | 6% |
| Catálogo de funciones/grupos/SoD (datos del modelo) | ~890 | 35% |
| Modelo de datos abstracto | ~20 | 1% |
| Implementación SQL (DDL + datos) | ~330 | 13% |
| Implementación Django (código Python) | ~670 | 26% |
| Mapeo a UCs | ~150 | 6% |
| Migración de versión anterior | ~130 | 5% |
| Resumen + control de cambios + nomenclatura | ~218 | 9% |

**~39% del documento es código de implementación** (SQL + Django).
Eso es inusual para un "modelo arquitectónico" — sugiere que el
documento mezcla **especificación** (modelo conceptual) con
**implementación** (cómo se traduce a tecnología).

### Versionado interno

El documento mantiene un "ESTÁNDAR DE NOMENCLATURA v5.2.1" en su
cabecera (líneas 112-140) y una sección "11. MIGRACIÓN DESDE v5.2.0".
Esto sugiere que el modelo evoluciona con sus propias versiones,
pero el contenido se mantiene en un solo archivo.

Versionar dentro del mismo archivo es legítimo (STD_007 v2.0.2 §3.3
dice que la versión vive en metadata YAML, NO en filename), pero la
sección "Migración" puede crear confusión cuando se acumulen
v5.3.0, v5.4.0, etc.

### Estructura propia (no canónica)

El documento define **su propia "ESTÁNDAR DE NOMENCLATURA"** (líneas
112-140) con tablas de naming para `:tipo:`, `:estado:`, etc. Esto
genera tensión con STD_007 v2.0.2 §6 (schema canónico de metadata)
y CNST_033 (vocabulario unificado RBAC).

## Próximo paso

T-002: inventariar refs entrantes y T-003: identificar contenido
esperado per convenciones del proyecto.
