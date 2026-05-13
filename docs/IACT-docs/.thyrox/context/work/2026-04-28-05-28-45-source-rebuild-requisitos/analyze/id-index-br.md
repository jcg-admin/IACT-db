```yml
created_at: 2026-04-28 18:00:00
project: IACT-docs
work_package: 2026-04-28-05-28-45-source-rebuild-requisitos
phase: Phase 1 — DISCOVER (concentracion: indice maestro de IDs)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Indice Maestro de IDs — BR

Total IDs unicos BR: **384**

Producido por scan automatizado (`/tmp/index_requirements_ids.py`) sobre todos los `inputs/` de los 16 WPs hijos.

## IDs detectados

| ID | # apariciones | WPs distintos | Contexto sample |
|----|---------------|---------------|----------------|
| `BR-000` | 6 | base-cognitiva | grep -r "BR_[0-9]" --include="*.md"   grep -E "BR_00[1-9] BR_01[0-9] BR_020" |
| `BR-001` | 243 | base-cognitiva, normativa-estandares, normativa-procedimientos (+6) | Relacionado con: BR-001 (Todos los cambios deben auditarse) |
| `BR-002` | 209 | base-cognitiva, normativa-estandares, normativa-procedimientos (+5) | - BR_002: SI 2:00AM ENTONCES ejecutar ETL |
| `BR-003` | 174 | base-cognitiva, normativa-estandares, normativa-procedimientos (+5) | - BR_003: SI sin login 90d ENTONCES inactivo |
| `BR-004` | 106 | base-cognitiva, normativa-procedimientos, normativa-gobernanza (+4) |   BR-004   Rebuild de CPython cada 6 meses o ante CVE crítico   Alta   Calendario de mantenimiento   |
| `BR-005` | 104 | base-cognitiva, normativa-procedimientos, normativa-gobernanza (+4) |   BR-005   Mantener últimas 3 versiones de artefactos disponibles   Media   Script de cleanup automático   |
| `BR-006` | 147 | base-cognitiva, normativa-estandares, normativa-restricciones (+4) | - BR_006: El sistema usa RBAC flat |
| `BR-007` | 184 | base-cognitiva, normativa-restricciones, normativa-gobernanza (+3) |   BR-007   Módulos nativos obligatorios: ssl, sqlite3, uuid, lzma, bz2   Crítica   Test automatizado marca como @critica |
| `BR-008` | 94 | base-cognitiva, normativa-procedimientos, normativa-gobernanza (+2) | - BR_008: Auditoria Accesos |
| `BR-009` | 88 | base-cognitiva, normativa-gobernanza, requisitos (+1) | - BR_008, BR_009, BR_010 |
| `BR-010` | 102 | base-cognitiva, normativa-estandares, requisitos (+2) | BR_010  → Décima regla de negocio |
| `BR-011` | 282 | base-cognitiva, normativa-procedimientos, requisitos (+2) |   🆕 Nuevas BR   BR_011 a BR_020   10   ✅ Generados   |
| `BR-012` | 276 | base-cognitiva, normativa-restricciones, requisitos (+3) | BR relacionada: BR-012 |
| `BR-013` | 81 | base-cognitiva, requisitos, arquitectura-tecnica (+1) | • BR-013: CAS Number debe cumplir formato oficial |
| `BR-014` | 195 | base-cognitiva, requisitos, arquitectura-tecnica (+1) | • BR-014: CAS Number debe pasar validación de checksum |
| `BR-015` | 183 | base-cognitiva, normativa-procedimientos, normativa-gobernanza (+3) | BR-015: "Productos químicos clase 5 requieren aprobación nivel 2" |
| `BR-016` | 192 | base-cognitiva, normativa-estandares, requisitos (+1) | BR_016  → Regla de cálculo (Tasa de Abandono) |
| `BR-017` | 114 | base-cognitiva, requisitos, arquitectura-tecnica | BR_016, BR_017 (Calculos)     --> BReq-001 |
| `BR-018` | 122 | base-cognitiva, requisitos, arquitectura-tecnica | BR_018, BR_019 (Compliance)   --> BReq-004 |
| `BR-019` | 102 | base-cognitiva, requisitos, arquitectura-tecnica | BR_018, BR_019 (Compliance)   --> BReq-004 |
| `BR-020` | 97 | base-cognitiva, normativa-procedimientos, requisitos (+1) |   Generacion BR   BR_001 a BR_020 (20)   NO   |
| `BR-021` | 4 | normativa-procedimientos | Razon: Agregar BR_021 por nuevo requisito de seguridad |
| `BR-022` | 6 | base-cognitiva, requisitos | BR-022 (HECHO) |
| `BR-025` | 4 | base-cognitiva, backend | BR-025: Usuario solo puede ver sus propias solicitudes |
| `BR-026` | 4 | base-cognitiva, backend | BR-026: Estados de solicitud son: |
| `BR-027` | 4 | base-cognitiva, backend | BR-027: Dashboard muestra indicadores en tiempo real |
| `BR-028` | 787 | base-cognitiva, normativa-estandares, normativa-gobernanza (+5) | - BR-028 |
| `BR-029` | 6 | base-cognitiva, requisitos, backend | Relacionadas: BR_029 (Flujo de aprobación), BR_030 (Notificaciones) |
| `BR-030` | 21 | base-cognitiva, requisitos, backend (+1) | Relacionado con: BR-030 (Stock no puede ser negativo) |
| `BR-031` | 424 | base-cognitiva, normativa-gobernanza, requisitos (+4) | • BR-031: Stock reservado debe reflejarse en tiempo real |
| `BR-032` | 7 | base-cognitiva, backend, operations | • BR-032: Solicitudes canceladas NO cuentan en reserva |
| `BR-033` | 28 | base-cognitiva, backend | │   │   └── BR-033: |
| `BR-034` | 13 | base-cognitiva, requisitos, backend | - BR-034: Cálculo de costo total |
| `BR-035` | 4 | base-cognitiva, backend | BR-035: Cancelación es irreversible |
| `BR-036` | 4 | base-cognitiva, backend | BR-036: Stock liberado está disponible inmediatamente |
| `BR-037` | 4 | base-cognitiva, backend | BR-037: Usuario no puede cancelar solicitud de otro usuario |
| `BR-038` | 9 | base-cognitiva | │   ├── BR-038: |
| `BR-040` | 4 | base-cognitiva, backend | BR-040: Password debe cumplir política de complejidad |
| `BR-041` | 7 | base-cognitiva, backend | │   └── BR-041: |
| `BR-042` | 34 | base-cognitiva, backend | │   │   ├── BR-042: |
| `BR-043` | 7 | base-cognitiva, backend | BR-043: Alertar stock <20% capacidad |
| `BR-044` | 4 | base-cognitiva, backend | BR-044: Usuarios con LDAP usan autenticación institucional |
| `BR-045` | 43 | base-cognitiva, requisitos, backend | │ BR_001, BR_002, ... BR_045              │ |
| `BR-046` | 307 | base-cognitiva, requisitos, arquitectura-tecnica (+3) | - Módulo de Autenticación (BR-031, BR-046, UC-AUTH-07) |
| `BR-047` | 4 | base-cognitiva, backend | BR-047: Rate limiting 5 intentos por IP por minuto |
| `BR-048` | 4 | base-cognitiva, backend | BR-048: Máximo 3 sesiones simultáneas por usuario |
| `BR-050` | 3 | base-cognitiva, operations | • BR-050: Transacciones deben ser ACID |
| `BR-052` | 8 | base-cognitiva, requisitos | BR_052 (Cálculo): |
| `BR-053` | 8 | base-cognitiva, normativa-gobernanza, operations | - BR-053 |
| `BR-055` | 5 | base-cognitiva | │   │   ├── BR-055: |
| `BR-060` | 183 | base-cognitiva, requisitos, backend | BR-028 + BR-060 + BR-087 → UC-04 "Solicitar Producto Químico" |
| `BR-062` | 3 | base-cognitiva | │   │   └── BR-062: |
| `BR-070` | 2 | base-cognitiva | ├── Exercise 1: Build UC from BR (BR-070 → UC-25) |
| `BR-077` | 16 | base-cognitiva, requisitos | BR-077 (CÁLCULO) |
| `BR-087` | 468 | base-cognitiva, requisitos, backend (+2) | - Módulo de Control de Acceso (BR-087, UC-ACC-01) |
| `BR-088` | 13 | base-cognitiva, requisitos | - BR_088 (EPA 40 CFR Part 262) |
| `BR-089` | 17 | base-cognitiva, requisitos | - BR_089 (State Chemical Safety Act) |
| `BR-091` | 1 | arquitectura-tecnica | - Más ejemplos (BR-104, BR-091) |
| `BR-095` | 8 | base-cognitiva, backend | Analista: [Acción: Integrar BR-095 en UC] |
| `BR-098` | 9 | base-cognitiva, requisitos | BR-098 (INFERENCIA) |
| `BR-099` | 24 | base-cognitiva, requisitos, backend | BR-099: "El sistema debe ser seguro" |
| `BR-100` | 6 | base-cognitiva, operations | Relacionado con: BR-100 (Passwords deben ser seguros) |
| `BR-101` | 41 | base-cognitiva, requisitos, operations | • BR-101: Passwords nunca deben almacenarse en texto plano |
| `BR-102` | 30 | base-cognitiva, requisitos, operations | • BR-102: Salt debe ser único por usuario |
| `BR-103` | 13 | base-cognitiva, requisitos | BR-103 (Restricción): |
| `BR-104` | 22 | base-cognitiva, requisitos, arquitectura-tecnica (+1) | 1. Identificar BR en conversación (BR-104, BR-105) |
| `BR-105` | 22 | base-cognitiva, requisitos, backend (+1) | 1. Identificar BR en conversación (BR-104, BR-105) |
| `BR-112` | 3 | base-cognitiva | │       • BR-112: Escalar si coordinador no disponible |
| `BR-115` | 17 | base-cognitiva, requisitos | BR-115 (INFERENCIA) |
| `BR-122` | 6 | base-cognitiva, requisitos | DESENCADENADOR (BR-122): |
| `BR-123` | 2 | requisitos | Ejemplos: BR_001, BR_028, BR_099, BR_123 |
| `BR-125` | 9 | base-cognitiva, requisitos | BR-125 (Restricción compleja): |
| `BR-145` | 4 | requisitos | BR-145 (Ley Federal): |
| `BR-146` | 4 | requisitos | BR-146 (Ley Estatal): |
| `BR-156` | 7 | base-cognitiva, requisitos | BR-156 (Desencadenador): |
| `BR-178` | 7 | base-cognitiva, requisitos | BR-178 (Cálculo - Complejo): |
| `BR-188` | 3 | base-cognitiva, requisitos | Implementa: BR-188 (probablemente existe: "Comisión 3% pagos tarjeta") |
| `BR-234` | 7 | base-cognitiva, requisitos | BR-234 (Cálculo): |
| `BR-245` | 38 | base-cognitiva, requisitos | ### Ejercicio 1: Transformar BR-245 en UC |
| `BR-246` | 6 | base-cognitiva, requisitos | INFERENCIA (BR-246): |
| `BR-289` | 26 | requisitos | BR-289 (Restricción - COMPLEJA): |
| `BR-301` | 4 | base-cognitiva, requisitos | BR-301 (Hecho): |
| `BR-302` | 42 | base-cognitiva, requisitos | ### Ejercicio 2: Integrar BR-302 en UC-15 |
| `BR-303` | 2 | requisitos | BR-303 (Restricción): |
| `BR-304` | 2 | requisitos | BR-304 (Desencadenador): |
| `BR-305` | 2 | requisitos | BR-305 (Inferencia): |
| `BR-306` | 2 | requisitos | BR-306 (Cálculo): |
| `BR-401` | 15 | base-cognitiva, requisitos | BR-401 (Hecho): |
| `BR-402` | 44 | base-cognitiva, requisitos | BR-402 (Restricción): |
| `BR-403` | 20 | base-cognitiva, requisitos | BR-403 (Desencadenador): |
| `BR-404` | 29 | base-cognitiva, requisitos | BR-404 (Cálculo): |
| `BR-ACC-001` | 2 | requisitos | * - BR-ACC-01 |
| `BR-ACC-002` | 1 | requisitos | * - BR-ACC-02 |
| `BR-ACC-003` | 1 | requisitos | * - BR-ACC-03 |
| `BR-ACC-004` | 1 | requisitos | * - BR-ACC-04 |
| `BR-ACC-005` | 2 | requisitos | * - BR-ACC-05 |
| `BR-ACC-010` | 2 | requisitos | * - BR-ACC-10 |
| `BR-ACC-011` | 1 | requisitos | * - BR-ACC-11 |
| `BR-ACC-012` | 1 | requisitos | * - BR-ACC-12 |
| `BR-ACC-013` | 2 | requisitos | * - BR-ACC-13 |
| `BR-ACC-020` | 2 | requisitos | * - BR-ACC-20 |
| `BR-ACC-021` | 1 | requisitos | * - BR-ACC-21 |
| `BR-ACC-022` | 1 | requisitos | * - BR-ACC-22 |
| `BR-ACC-023` | 2 | requisitos | * - BR-ACC-23 |
| `BR-ACC-030` | 2 | requisitos | * - BR-ACC-30 |
| `BR-ACC-031` | 1 | requisitos | * - BR-ACC-31 |
| `BR-ACC-032` | 1 | requisitos | * - BR-ACC-32 |
| `BR-ACC-033` | 2 | requisitos | * - BR-ACC-33 |
| `BR-ACC-040` | 2 | requisitos | * - BR-ACC-40 |
| `BR-ACC-041` | 1 | requisitos | * - BR-ACC-41 |
| `BR-ACC-042` | 2 | requisitos | * - BR-ACC-42 |
| `BR-ACC-043` | 1 | requisitos | * - BR-ACC-43 |
| `BR-ACC-050` | 2 | requisitos | * - BR-ACC-50 |
| `BR-ACC-051` | 1 | requisitos | * - BR-ACC-51 |
| `BR-ACC-052` | 2 | requisitos | * - BR-ACC-52 |
| `BR-ACC-060` | 2 | requisitos | * - BR-ACC-60 |
| `BR-ACC-061` | 1 | requisitos | * - BR-ACC-61 |
| `BR-ACC-062` | 2 | requisitos | * - BR-ACC-62 |
| `BR-ACC-070` | 2 | requisitos | * - BR-ACC-70 |
| `BR-ACC-071` | 1 | requisitos | * - BR-ACC-71 |
| `BR-ACC-072` | 1 | requisitos | * - BR-ACC-72 |
| `BR-ACC-073` | 1 | requisitos | * - BR-ACC-73 |
| `BR-ACC-074` | 2 | requisitos | * - BR-ACC-74 |
| `BR-ACC-080` | 2 | requisitos | * - BR-ACC-80 |
| `BR-ACC-081` | 1 | requisitos | * - BR-ACC-81 |
| `BR-ACC-082` | 2 | requisitos | * - BR-ACC-82 |
| `BR-ALR-001` | 2 | requisitos | * - BR-ALR-01 |
| `BR-ALR-002` | 1 | requisitos | * - BR-ALR-02 |
| `BR-ALR-003` | 1 | requisitos | * - BR-ALR-03 |
| `BR-ALR-004` | 2 | requisitos | * - BR-ALR-04 |
| `BR-ALR-010` | 2 | requisitos | * - BR-ALR-10 |
| `BR-ALR-011` | 1 | requisitos | * - BR-ALR-11 |
| `BR-ALR-012` | 1 | requisitos | * - BR-ALR-12 |
| `BR-ALR-013` | 2 | requisitos | * - BR-ALR-13 |
| `BR-ALR-020` | 2 | requisitos | * - BR-ALR-20 |
| `BR-ALR-021` | 1 | requisitos | * - BR-ALR-21 |
| `BR-ALR-022` | 1 | requisitos | * - BR-ALR-22 |
| `BR-ALR-023` | 2 | requisitos | * - BR-ALR-23 |
| `BR-ALR-030` | 2 | requisitos | * - BR-ALR-30 |
| `BR-ALR-031` | 1 | requisitos | * - BR-ALR-31 |
| `BR-ALR-032` | 1 | requisitos | * - BR-ALR-32 |
| `BR-ALR-033` | 2 | requisitos | * - BR-ALR-33 |
| `BR-ALR-040` | 2 | requisitos | * - BR-ALR-40 |
| `BR-ALR-041` | 1 | requisitos | * - BR-ALR-41 |
| `BR-ALR-042` | 1 | requisitos | * - BR-ALR-42 |
| `BR-ALR-043` | 2 | requisitos | * - BR-ALR-43 |
| `BR-ARQ-001` | 2 | requisitos | BR_ARQ_001 (Hecho): |
| `BR-ARQ-002` | 2 | requisitos | BR_ARQ_002 (Restricción): |
| `BR-ARQ-003` | 1 | requisitos | BR_ARQ_003 (Cálculo): |
| `BR-AUD-001` | 2 | requisitos | * - BR-AUD-01 |
| `BR-AUD-002` | 1 | requisitos | * - BR-AUD-02 |
| `BR-AUD-003` | 1 | requisitos | * - BR-AUD-03 |
| `BR-AUD-004` | 2 | requisitos | * - BR-AUD-04 |
| `BR-AUD-010` | 1 | requisitos | * - BR-AUD-10 |
| `BR-AUD-011` | 1 | requisitos | * - BR-AUD-11 |
| `BR-AUD-012` | 1 | requisitos | * - BR-AUD-12 |
| `BR-AUD-020` | 1 | requisitos | * - BR-AUD-20 |
| `BR-AUD-021` | 1 | requisitos | * - BR-AUD-21 |
| `BR-AUD-022` | 1 | requisitos | * - BR-AUD-22 |
| `BR-AUD-030` | 1 | requisitos | * - BR-AUD-30 |
| `BR-AUD-031` | 1 | requisitos | * - BR-AUD-31 |
| `BR-AUD-032` | 1 | requisitos | * - BR-AUD-32 |
| `BR-AUD-033` | 1 | requisitos | * - BR-AUD-33 |
| `BR-AUTH-001` | 4 | requisitos | * - BR-AUTH-01 |
| `BR-AUTH-002` | 4 | requisitos | * - BR-AUTH-02 |
| `BR-AUTH-003` | 4 | requisitos | * - BR-AUTH-03 |
| `BR-AUTH-004` | 4 | requisitos | * - BR-AUTH-04 |
| `BR-AUTH-005` | 4 | requisitos | * - BR-AUTH-05 |
| `BR-AUTH-006` | 4 | requisitos | * - BR-AUTH-06 |
| `BR-AUTH-007` | 4 | requisitos | * - BR-AUTH-07 |
| `BR-AUTH-010` | 2 | requisitos | * - BR-AUTH-10 |
| `BR-AUTH-011` | 2 | requisitos | * - BR-AUTH-11 |
| `BR-AUTH-012` | 2 | requisitos | * - BR-AUTH-12 |
| `BR-AUTH-013` | 2 | requisitos | * - BR-AUTH-13 |
| `BR-AUTH-020` | 2 | requisitos | * - BR-AUTH-20 |
| `BR-AUTH-021` | 1 | requisitos | * - BR-AUTH-21 |
| `BR-AUTH-022` | 1 | requisitos | * - BR-AUTH-22 |
| `BR-AUTH-023` | 1 | requisitos | * - BR-AUTH-23 |
| `BR-AUTH-024` | 1 | requisitos | * - BR-AUTH-24 |
| `BR-AUTH-025` | 2 | requisitos | * - BR-AUTH-25 |
| `BR-AUTH-030` | 2 | requisitos | * - BR-AUTH-30 |
| `BR-AUTH-031` | 1 | requisitos | * - BR-AUTH-31 |
| `BR-AUTH-032` | 1 | requisitos | * - BR-AUTH-32 |
| `BR-AUTH-033` | 1 | requisitos | * - BR-AUTH-33 |
| `BR-AUTH-034` | 1 | requisitos | * - BR-AUTH-34 |
| `BR-AUTH-035` | 2 | requisitos | * - BR-AUTH-35 |
| `BR-AUTH-040` | 2 | requisitos | * - BR-AUTH-40 |
| `BR-AUTH-041` | 1 | requisitos | * - BR-AUTH-41 |
| `BR-AUTH-042` | 1 | requisitos | * - BR-AUTH-42 |
| `BR-AUTH-043` | 1 | requisitos | * - BR-AUTH-43 |
| `BR-AUTH-044` | 2 | requisitos | * - BR-AUTH-44 |
| `BR-C-001` | 6 | normativa-gobernanza | **Reglas de Negocio:** BR-H01, BR-R02, BR-D01, BR-C01 |
| `BR-C-002` | 8 | normativa-gobernanza | **Reglas de Negocio:** BR-R03, BR-R04, BR-H02, BR-D02, BR-C02 |
| `BR-C-003` | 7 | normativa-gobernanza | **Reglas de Negocio:** BR-R05, BR-C03, BR-C04, BR-I01, BR-I02 |
| `BR-C-004` | 7 | normativa-gobernanza | **Reglas de Negocio:** BR-R05, BR-C03, BR-C04, BR-I01, BR-I02 |
| `BR-C-007` | 5 | normativa-gobernanza | - 5.3.3 Sistema actualiza métricas de abandono (BR-C07) |
| `BR-C-008` | 3 | normativa-gobernanza | id: BR-C08 |
| `BR-CAL-001` | 2 | base-cognitiva, arquitectura-tecnica | BR_CAL_001: Tasa de Abandono (Agregacion) |
| `BR-CAL-002` | 1 | base-cognitiva | BR_CAL_002: Tiempo Promedio de Espera (Agregacion) |
| `BR-CAL-003` | 1 | base-cognitiva | BR_CAL_003: Indice de Eficiencia (Derivacion) |
| `BR-CALC-001` | 2 | base-cognitiva, arquitectura-tecnica | BR-CALC-001: "Precio Total = (Suma Items) - Descuento + IVA + Envio" |
| `BR-CHEM-001` | 4 | requisitos | BR_CHEM_001 (Restricción): |
| `BR-CHEM-002` | 6 | requisitos | BR_CHEM_002 (Desencadenador): |
| `BR-CHEM-003` | 2 | requisitos | BR_CHEM_003 (Cálculo): |
| `BR-CHEM-004` | 2 | requisitos | BR_CHEM_004 (Inferencia): |
| `BR-CONST-001` | 2 | base-cognitiva, arquitectura-tecnica | BR-CONST-001: "Solo gerentes pueden aprobar compras mayores a $500" |
| `BR-D-001` | 5 | normativa-gobernanza | **Reglas de Negocio:** BR-H01, BR-R02, BR-D01, BR-C01 |
| `BR-D-002` | 9 | normativa-gobernanza | - 5.2.3 Sistema monitorea tiempo en cola (**BR-D02**) |
| `BR-D-003` | 2 | normativa-gobernanza | **Reglas aplicadas**: BR-D03 (Desencadenador: Reasignación automática) |
| `BR-D-004` | 4 | normativa-gobernanza | - BR-D04           # Desencadenador: Actualizar métricas al cerrar |
| `BR-FACT-001` | 2 | base-cognitiva, arquitectura-tecnica | BR-FACT-001: "Cada contenedor tiene un codigo unico" |
| `BR-H-001` | 11 | normativa-gobernanza | **Reglas de Negocio:** BR-H01, BR-R02, BR-D01, BR-C01 |
| `BR-H-002` | 6 | normativa-gobernanza | **Reglas de Negocio:** BR-R03, BR-R04, BR-H02, BR-D02, BR-C02 |
| `BR-H-003` | 4 | normativa-gobernanza | - BR-H03           # Hecho: Toda llamada debe clasificarse al cerrar |
| `BR-HEC-001` | 4 | base-cognitiva, arquitectura-tecnica | BR_HEC_001: Unicidad de Username (Hecho de Identidad) |
| `BR-HEC-002` | 1 | base-cognitiva | BR_HEC_002: Usuario-Segmento (Hecho de Cardinalidad) |
| `BR-I-001` | 6 | normativa-gobernanza | **Reglas de Negocio:** BR-R05, BR-C03, BR-C04, BR-I01, BR-I02 |
| `BR-I-002` | 4 | normativa-gobernanza | **Reglas de Negocio:** BR-R05, BR-C03, BR-C04, BR-I01, BR-I02 |
| `BR-I-003` | 5 | normativa-gobernanza | id: BR-I03 |
| `BR-IACT-001` | 70 | base-cognitiva, normativa-gobernanza, arquitectura-tecnica (+2) | **BR-IACT-001: Cliente Activo** |
| `BR-IACT-002` | 1 | base-cognitiva | - BR_IACT_002: ETL Batch Nocturno (Desencadenador real del proyecto) |
| `BR-IACT-007` | 1 | base-cognitiva | - BR_IACT_007: Separación SoD (Restricción real del proyecto) |
| `BR-IACT-012` | 80 | base-cognitiva, normativa-gobernanza, backend (+1) | - BR Origen: BR-IACT-012 |
| `BR-IACT-015` | 3 | base-cognitiva | - Ejemplo: BR-IACT-015 ("Función crítica" = es_critica=TRUE) |
| `BR-IACT-016` | 1 | base-cognitiva | - BR_IACT_016: Tasa de Abandono (Cálculo real del proyecto) |
| `BR-IACT-018` | 8 | base-cognitiva, backend | ### Ejemplo Adicional: BR-IACT-018 |
| `BR-IACT-022` | 8 | base-cognitiva, backend | ### Ejemplo Breve: BR-IACT-022 |
| `BR-IACT-028` | 605 | base-cognitiva, normativa-gobernanza, arquitectura-tecnica (+3) | Implementa BR-IACT-028: Aprobacion Consultas Grandes |
| `BR-IACT-031` | 270 | base-cognitiva, normativa-gobernanza, arquitectura-tecnica (+3) | * - BR-IACT-031 |
| `BR-IACT-033` | 44 | base-cognitiva, backend | BR-IACT-033 (DESENCADENADOR): |
| `BR-IACT-043` | 2 | base-cognitiva | - BR_IACT_043: "Roles con funciones críticas deben estar segregados" |
| `BR-IACT-044` | 1 | base-cognitiva | - BR_IACT_044: "REPORTS_CREATOR + REPORTS_EXPORTER = incompatible" |
| `BR-IACT-045` | 1 | base-cognitiva | - BR_IACT_045: "USERS_FULL_MANAGER + AUDIT_VIEWER = incompatible" |
| `BR-IACT-046` | 275 | base-cognitiva, normativa-gobernanza, arquitectura-tecnica (+3) | BR-IACT-046: Marcar sesiones expiradas |
| `BR-IACT-052` | 8 | base-cognitiva, backend | ### Ejemplo Adicional: BR-IACT-052 |
| `BR-IACT-053` | 175 | base-cognitiva, normativa-gobernanza, arquitectura-tecnica (+1) | Implementa BR-IACT-053: Calculo Tasa Abandono |
| `BR-IACT-054` | 3 | base-cognitiva, normativa-gobernanza, operations | - BR-IACT-054: Comparación trimestral |
| `BR-IACT-055` | 3 | base-cognitiva, normativa-gobernanza, operations | - BR-IACT-055: Segmentación por área |
| `BR-IACT-060` | 82 | base-cognitiva, backend | BR-IACT-060: "La prioridad de procesamiento de un pipeline ETL |
| `BR-IACT-064` | 8 | base-cognitiva, backend | ### Ejemplo Adicional: BR-IACT-064 |
| `BR-IACT-070` | 28 | base-cognitiva, backend | **BR-IACT-070 (DESENCADENADOR):** |
| `BR-IACT-072` | 38 | base-cognitiva, backend | - Business Rule: BR-IACT-072 |
| `BR-IACT-087` | 298 | base-cognitiva, normativa-gobernanza, backend (+2) | - BR Origen: BR-IACT-087 |
| `BR-IACT-089` | 1 | base-cognitiva | BR_IACT_089 (Inferencia): |
| `BR-IACT-091` | 11 | base-cognitiva, arquitectura-tecnica | #### Ejemplo 4: BR-IACT-091 (Inferencia) |
| `BR-IACT-092` | 8 | base-cognitiva, backend | BR-IACT-092: Nivel 4 requerido para funciones de auditoría |
| `BR-IACT-095` | 12 | base-cognitiva, backend | BR-IACT-095: Nivel 5 solo para superusuario |
| `BR-IACT-099` | 20 | base-cognitiva, backend | BR-IACT-099 (RESTRICCIÓN): |
| `BR-IACT-101` | 1 | base-cognitiva | Business Rules: BR_IACT_101, BR_IACT_102, BR_IACT_103 |
| `BR-IACT-102` | 1 | base-cognitiva | Business Rules: BR_IACT_101, BR_IACT_102, BR_IACT_103 |
| `BR-IACT-103` | 1 | base-cognitiva | Business Rules: BR_IACT_101, BR_IACT_102, BR_IACT_103 |
| `BR-IACT-104` | 15 | base-cognitiva, arquitectura-tecnica, operations | **BR-IACT-104:** Alerta Llamadas Abandonadas >20% |
| `BR-IACT-105` | 20 | base-cognitiva, backend, operations | **BR-IACT-105:** Cálculo Tasa de Abandono |
| `BR-IACT-112` | 9 | base-cognitiva, arquitectura-tecnica | Analista: "Documenté BR-IACT-112: Timeout de 60 segundos en consultas" |
| `BR-IACT-122` | 1 | base-cognitiva | BR_IACT_122 (Desencadenador): |
| `BR-IACT-150` | 4 | base-cognitiva, quality | PO agrega BR-IACT-150: "Logs de auditoría deben retenerse 7 años" |
| `BR-IACT-156` | 1 | base-cognitiva | BR_IACT_156 (Desencadenador): |
| `BR-IACT-178` | 4 | base-cognitiva | BR_IACT_178 (Cálculo): |
| `BR-IACT-234` | 1 | base-cognitiva | BR_IACT_234 (Cálculo): |
| `BR-IACT-245` | 2 | base-cognitiva | BR_IACT_245 (Desencadenador): |
| `BR-IACT-246` | 1 | base-cognitiva | BR_IACT_246 (Inferencia): |
| `BR-IACT-301` | 1 | base-cognitiva | BR_IACT_301 (Hecho): |
| `BR-IACT-302` | 1 | base-cognitiva | BR_IACT_302 (Restricción): |
| `BR-IACT-303` | 1 | base-cognitiva | BR_IACT_303 (Restricción): |
| `BR-IACT-304` | 1 | base-cognitiva | BR_IACT_304 (Desencadenador): |
| `BR-IACT-305` | 1 | base-cognitiva | BR_IACT_305 (Inferencia): |
| `BR-IACT-306` | 1 | base-cognitiva | BR_IACT_306 (Cálculo): |
| `BR-IACT-401` | 8 | base-cognitiva | 7. Sistema verifica permisos del analista [BR-IACT-401] |
| `BR-INF-001` | 4 | base-cognitiva, arquitectura-tecnica | BR-INF-001: "SI una cuenta tiene mas de 30 dias de impago, |
| `BR-INF-002` | 1 | base-cognitiva | BR_INF_002: Cuenta Premium (Inferencia) |
| `BR-LOG-001` | 2 | requisitos | * - BR-LOG-01 |
| `BR-LOG-002` | 1 | requisitos | * - BR-LOG-02 |
| `BR-LOG-003` | 1 | requisitos | * - BR-LOG-03 |
| `BR-LOG-004` | 2 | requisitos | * - BR-LOG-04 |
| `BR-LOG-010` | 1 | requisitos | * - BR-LOG-10 |
| `BR-LOG-011` | 1 | requisitos | * - BR-LOG-11 |
| `BR-LOG-012` | 1 | requisitos | * - BR-LOG-12 |
| `BR-LOG-013` | 1 | requisitos | * - BR-LOG-13 |
| `BR-LOG-020` | 1 | requisitos | * - BR-LOG-20 |
| `BR-LOG-021` | 1 | requisitos | * - BR-LOG-21 |
| `BR-LOG-022` | 1 | requisitos | * - BR-LOG-22 |
| `BR-LOG-023` | 1 | requisitos | * - BR-LOG-23 |
| `BR-LOG-030` | 1 | requisitos | * - BR-LOG-30 |
| `BR-LOG-031` | 1 | requisitos | * - BR-LOG-31 |
| `BR-LOG-032` | 1 | requisitos | * - BR-LOG-32 |
| `BR-LOG-033` | 1 | requisitos | * - BR-LOG-33 |
| `BR-NEG-001` | 2 | requisitos |   **ID BR**   Identificador único y estático (ej: BR-NEG-001).   Manual/Decisión de Negocio   |
| `BR-NEG-008` | 1 | requisitos |   **BR-NEG-008**   **Criterio de Inactividad de Agente**   `users`, `llamadas`   Un Agente es considerado 'inactivo' en  |
| `BR-NEG-012` | 2 | requisitos |   **BR-NEG-012**   Negocio/Validación   El `numero_telefono` debe cumplir el formato de contacto admitido por el call ce |
| `BR-PIP-001` | 2 | requisitos | * - BR-PIP-01 |
| `BR-PIP-002` | 1 | requisitos | * - BR-PIP-02 |
| `BR-PIP-003` | 2 | requisitos | * - BR-PIP-03 |
| `BR-PIP-010` | 2 | requisitos | * - BR-PIP-10 |
| `BR-PIP-011` | 1 | requisitos | * - BR-PIP-11 |
| `BR-PIP-012` | 2 | requisitos | * - BR-PIP-12 |
| `BR-PIP-020` | 2 | requisitos | * - BR-PIP-20 |
| `BR-PIP-021` | 1 | requisitos | * - BR-PIP-21 |
| `BR-PIP-022` | 2 | requisitos | * - BR-PIP-22 |
| `BR-PIP-030` | 2 | requisitos | * - BR-PIP-30 |
| `BR-PIP-031` | 1 | requisitos | * - BR-PIP-31 |
| `BR-PIP-032` | 1 | requisitos | * - BR-PIP-32 |
| `BR-PIP-033` | 2 | requisitos | * - BR-PIP-33 |
| `BR-R-002` | 7 | normativa-gobernanza | **Reglas de Negocio:** BR-H01, BR-R02, BR-D01, BR-C01 |
| `BR-R-003` | 8 | normativa-gobernanza | **Reglas de Negocio:** BR-R03, BR-R04, BR-H02, BR-D02, BR-C02 |
| `BR-R-004` | 7 | normativa-gobernanza | **Reglas de Negocio:** BR-R03, BR-R04, BR-H02, BR-D02, BR-C02 |
| `BR-R-005` | 8 | normativa-gobernanza | **Reglas de Negocio:** BR-R05, BR-C03, BR-C04, BR-I01, BR-I02 |
| `BR-R-006` | 2 | normativa-gobernanza | **Reglas aplicadas**: BR-R06 (Restricción: Graceful degradation) |
| `BR-R-008` | 8 | normativa-gobernanza | │                              │    (BR-R08: Consentimiento)    │ |
| `BR-R-009` | 3 | normativa-gobernanza | - BR-R09           # Restricción: Agente debe estar logueado |
| `BR-R-010` | 4 | normativa-gobernanza | - L224:         "description": "Regla BR-R10: Restricción - Detectar intentos de cerrar llamadas sin clasificación (viol |
| `BR-R-011` | 2 | normativa-gobernanza | **ID de Referencia:** Mencionado como BR-R11 en documentación |
| `BR-R-012` | 2 | normativa-gobernanza | **ID de Referencia:** Mencionado como BR-R12 en documentación |
| `BR-R-013` | 2 | normativa-gobernanza | **ID de Referencia:** Mencionado como BR-R13 en documentación |
| `BR-RES-001` | 4 | base-cognitiva, arquitectura-tecnica | BR_RES_001: Solo Admin Gestiona Usuarios (Restriccion de Acceso) |
| `BR-RPT-001` | 2 | requisitos | * - BR-RPT-01 |
| `BR-RPT-002` | 1 | requisitos | * - BR-RPT-02 |
| `BR-RPT-003` | 1 | requisitos | * - BR-RPT-03 |
| `BR-RPT-004` | 2 | requisitos | * - BR-RPT-04 |
| `BR-RPT-010` | 2 | requisitos | * - BR-RPT-10 |
| `BR-RPT-011` | 1 | requisitos | * - BR-RPT-11 |
| `BR-RPT-012` | 1 | requisitos | * - BR-RPT-12 |
| `BR-RPT-013` | 2 | requisitos | * - BR-RPT-13 |
| `BR-RPT-020` | 2 | requisitos | * - BR-RPT-20 |
| `BR-RPT-021` | 1 | requisitos | * - BR-RPT-21 |
| `BR-RPT-022` | 1 | requisitos | * - BR-RPT-22 |
| `BR-RPT-023` | 2 | requisitos | * - BR-RPT-23 |
| `BR-RPT-030` | 2 | requisitos | * - BR-RPT-30 |
| `BR-RPT-031` | 1 | requisitos | * - BR-RPT-31 |
| `BR-RPT-032` | 1 | requisitos | * - BR-RPT-32 |
| `BR-RPT-033` | 2 | requisitos | * - BR-RPT-33 |
| `BR-RPT-040` | 2 | requisitos | * - BR-RPT-40 |
| `BR-RPT-041` | 1 | requisitos | * - BR-RPT-41 |
| `BR-RPT-042` | 2 | requisitos | * - BR-RPT-42 |
| `BR-RPT-050` | 2 | requisitos | * - BR-RPT-50 |
| `BR-RPT-051` | 1 | requisitos | * - BR-RPT-51 |
| `BR-RPT-052` | 2 | requisitos | * - BR-RPT-52 |
| `BR-RPT-060` | 1 | requisitos | * - BR-RPT-60 |
| `BR-RPT-061` | 1 | requisitos | * - BR-RPT-61 |
| `BR-RPT-062` | 1 | requisitos | * - BR-RPT-62 |
| `BR-RPT-070` | 1 | requisitos | * - BR-RPT-70 |
| `BR-RPT-071` | 1 | requisitos | * - BR-RPT-71 |
| `BR-RPT-080` | 1 | requisitos | * - BR-RPT-80 |
| `BR-RPT-081` | 1 | requisitos | * - BR-RPT-81 |
| `BR-RPT-090` | 1 | requisitos | * - BR-RPT-90 |
| `BR-RPT-091` | 1 | requisitos | * - BR-RPT-91 |
| `BR-RPT-092` | 1 | requisitos | * - BR-RPT-92 |
| `BR-RPT-100` | 1 | requisitos | * - BR-RPT-100 |
| `BR-RPT-101` | 1 | requisitos | * - BR-RPT-101 |
| `BR-RPT-110` | 1 | requisitos | * - BR-RPT-110 |
| `BR-RPT-111` | 1 | requisitos | * - BR-RPT-111 |
| `BR-RPT-120` | 1 | requisitos | * - BR-RPT-120 |
| `BR-RPT-121` | 1 | requisitos | * - BR-RPT-121 |
| `BR-RPT-130` | 1 | requisitos | * - BR-RPT-130 |
| `BR-RPT-131` | 1 | requisitos | * - BR-RPT-131 |
| `BR-SECRET-001` | 2 | normativa-gobernanza | Artefacto: BR_SECRET_001.rst (Confidencial) |
| `BR-SEG-005` | 2 | normativa-gobernanza | 1. **BR-SEG-005 (Control de intentos fallidos)**: registrar en `requirements_management.md` la regla de bloqueo tras 3 i |
| `BR-SEG-007` | 11 | normativa-gobernanza, requisitos |   **BR-SEG-007**   Seguridad/Autorización   El actor debe contar con la capacidad `sistema.operaciones.llamadas.registra |
| `BR-SEG-021` | 1 | requisitos |   **BR-SEG-021**   `sistema.operaciones.llamadas.finalizar`   Operaciones → Llamadas   Controla el cierre de llamadas y  |
| `BR-SEG-105` | 1 | requisitos |   **BR-SEG-105**   `sistema.analytics.reportes.ver`   Analíticas → Dashboards   Restringe la visualización de reportes c |
| `BR-TRG-001` | 4 | base-cognitiva, arquitectura-tecnica | BR_TRG_001: Alerta por Umbral (Desencadenador de Negocio) |
| `BR-TRG-002` | 1 | base-cognitiva | BR_TRG_002: Bloqueo por Intentos Fallidos (Desencadenador de Seguridad) |
| `BR-TRIG-001` | 2 | base-cognitiva, arquitectura-tecnica | BR-TRIG-001: "SI un quimico vence en 30 dias, |
| `BR-USR-001` | 2 | requisitos | * - BR-USR-01 |
| `BR-USR-002` | 1 | requisitos | * - BR-USR-02 |
| `BR-USR-003` | 1 | requisitos | * - BR-USR-03 |
| `BR-USR-004` | 1 | requisitos | * - BR-USR-04 |
| `BR-USR-005` | 1 | requisitos | * - BR-USR-05 |
| `BR-USR-006` | 2 | requisitos | * - BR-USR-06 |
| `BR-USR-010` | 2 | requisitos | * - BR-USR-10 |
| `BR-USR-011` | 1 | requisitos | * - BR-USR-11 |
| `BR-USR-012` | 1 | requisitos | * - BR-USR-12 |
| `BR-USR-013` | 2 | requisitos | * - BR-USR-13 |
| `BR-USR-020` | 2 | requisitos | * - BR-USR-20 |
| `BR-USR-021` | 1 | requisitos | * - BR-USR-21 |
| `BR-USR-022` | 1 | requisitos | * - BR-USR-22 |
| `BR-USR-023` | 1 | requisitos | * - BR-USR-23 |
| `BR-USR-024` | 1 | requisitos | * - BR-USR-24 |
| `BR-USR-025` | 2 | requisitos | * - BR-USR-25 |
| `BR-USR-030` | 2 | requisitos | * - BR-USR-30 |
| `BR-USR-031` | 1 | requisitos | * - BR-USR-31 |
| `BR-USR-032` | 1 | requisitos | * - BR-USR-32 |
| `BR-USR-033` | 1 | requisitos | * - BR-USR-33 |
| `BR-USR-034` | 1 | requisitos | * - BR-USR-34 |
| `BR-USR-035` | 2 | requisitos | * - BR-USR-35 |

## Distribucion por modulo (si aplica)

- **(sin modulo)** (91): BR-000, BR-001, BR-002, BR-003, BR-004, BR-005, BR-006, BR-007, BR-008, BR-009...
- **ACC** (35): BR-ACC-001, BR-ACC-002, BR-ACC-003, BR-ACC-004, BR-ACC-005, BR-ACC-010, BR-ACC-011, BR-ACC-012, BR-ACC-013, BR-ACC-020...
- **ALR** (20): BR-ALR-001, BR-ALR-002, BR-ALR-003, BR-ALR-004, BR-ALR-010, BR-ALR-011, BR-ALR-012, BR-ALR-013, BR-ALR-020, BR-ALR-021...
- **ARQ** (3): BR-ARQ-001, BR-ARQ-002, BR-ARQ-003
- **AUD** (14): BR-AUD-001, BR-AUD-002, BR-AUD-003, BR-AUD-004, BR-AUD-010, BR-AUD-011, BR-AUD-012, BR-AUD-020, BR-AUD-021, BR-AUD-022...
- **AUTH** (28): BR-AUTH-001, BR-AUTH-002, BR-AUTH-003, BR-AUTH-004, BR-AUTH-005, BR-AUTH-006, BR-AUTH-007, BR-AUTH-010, BR-AUTH-011, BR-AUTH-012...
- **C** (6): BR-C-001, BR-C-002, BR-C-003, BR-C-004, BR-C-007, BR-C-008
- **CAL** (3): BR-CAL-001, BR-CAL-002, BR-CAL-003
- **CALC** (1): BR-CALC-001
- **CHEM** (4): BR-CHEM-001, BR-CHEM-002, BR-CHEM-003, BR-CHEM-004
- **CONST** (1): BR-CONST-001
- **D** (4): BR-D-001, BR-D-002, BR-D-003, BR-D-004
- **FACT** (1): BR-FACT-001
- **H** (3): BR-H-001, BR-H-002, BR-H-003
- **HEC** (2): BR-HEC-001, BR-HEC-002
- **I** (3): BR-I-001, BR-I-002, BR-I-003
- **IACT** (49): BR-IACT-001, BR-IACT-002, BR-IACT-007, BR-IACT-012, BR-IACT-015, BR-IACT-016, BR-IACT-018, BR-IACT-022, BR-IACT-028, BR-IACT-031...
- **INF** (2): BR-INF-001, BR-INF-002
- **LOG** (16): BR-LOG-001, BR-LOG-002, BR-LOG-003, BR-LOG-004, BR-LOG-010, BR-LOG-011, BR-LOG-012, BR-LOG-013, BR-LOG-020, BR-LOG-021...
- **NEG** (3): BR-NEG-001, BR-NEG-008, BR-NEG-012
- **PIP** (13): BR-PIP-001, BR-PIP-002, BR-PIP-003, BR-PIP-010, BR-PIP-011, BR-PIP-012, BR-PIP-020, BR-PIP-021, BR-PIP-022, BR-PIP-030...
- **R** (11): BR-R-002, BR-R-003, BR-R-004, BR-R-005, BR-R-006, BR-R-008, BR-R-009, BR-R-010, BR-R-011, BR-R-012...
- **RES** (1): BR-RES-001
- **RPT** (40): BR-RPT-001, BR-RPT-002, BR-RPT-003, BR-RPT-004, BR-RPT-010, BR-RPT-011, BR-RPT-012, BR-RPT-013, BR-RPT-020, BR-RPT-021...
- **SECRET** (1): BR-SECRET-001
- **SEG** (4): BR-SEG-005, BR-SEG-007, BR-SEG-021, BR-SEG-105
- **TRG** (2): BR-TRG-001, BR-TRG-002
- **TRIG** (1): BR-TRIG-001
- **USR** (22): BR-USR-001, BR-USR-002, BR-USR-003, BR-USR-004, BR-USR-005, BR-USR-006, BR-USR-010, BR-USR-011, BR-USR-012, BR-USR-013...

## Top archivos con mas IDs BR

| Archivo | # IDs |
|---------|-------|
| `canonical/De Reglas de Negocio a Sistema Completo.md` | 441 |
| `canonical/PARTE 2 - TRANSFORMAR REGLAS DE NEGOCIO EN CASOS DE USO - 661ca8 - v.0.1.1.md` | 247 |
| `canonical/Buscar estructura de PARTE 2 en transcripción.txt` | 175 |
| `canonical/ANALISIS_BR_REVISION_INTEGRAL_v1.md` | 175 |
| `canonical/ANALISIS_CONSOLIDADO_COMPLETO_v2_UNIFICADO.md` | 169 |
| `canonical/PLAN_MAESTRO_BASE_COGNITIVA_v3_FINAL.md` | 164 |
| `canonical/PLAN_MAESTRO_BASE_COGNITIVA_v3_FINAL_1.md` | 164 |
| `canonical/ANALISIS_INTEGRADO_PARTES_0_1_2_vs_IACT.md` | 160 |
| `canonical/ANALISIS_CORREGIDO_PARTE2_CON_UC_REALES.md` | 134 |
| `canonical/EJEMPLOS_REALES_IACT_COMPLETO_0_0_1.md` | 124 |
| `canonical/EJEMPLOS_REALES_IACT_COMPLETO.md` | 124 |
| `canonical/PARTE 1 - IDENTIFICAR REGLAS DE NEGOCIO - 661ca8.md` | 119 |
| `canonical/PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md` | 115 |
| `canonical/PARTE_0_CONTEXTO_FUNDAMENTOS_IACT_1_0_0.md` | 115 |
| `canonical/ANALISIS_PARTE1_ESTRUCTURA.md` | 111 |
