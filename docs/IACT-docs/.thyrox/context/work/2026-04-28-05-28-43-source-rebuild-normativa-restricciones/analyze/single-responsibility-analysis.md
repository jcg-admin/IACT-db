```yml
created_at: 2026-04-28 09:30:00
project: IACT-docs
work_package: 2026-04-28-05-28-43-source-rebuild-normativa-restricciones
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Deep-Analysis — Single Responsibility por CNST

## Premisa

Cada CNST debe declarar **una sola restricción**: una condición de borde
identificable, verificable de forma independiente, con violación
única. Cuando un CNST combina varias condiciones de borde, su lectura
y su validación se degradan: una "violación de CNST_005" pierde
información sobre qué exactamente se violó (¿la autenticación, el
throttling, la paginación?).

## Diagnóstico — concerns combinados por CNST actual

| CNST actual | Concerns combinados | # |
|-------------|---------------------|---|
| CNST_001 Comunicaciones_Prohibidas | (a) Prohibición de email/SMTP · (b) Buzón interno como mecanismo obligatorio | 2 |
| CNST_002 Gestion_Sesiones_BD | (a) Sesiones persistidas en BD · (b) Sesión única por usuario · (c) Timeout de 15 min · (d) Tracking de sesión en UserSession | 4 |
| CNST_003 Base_Datos_Dual_Inmutable | (a) Arquitectura dual (BD IVR + BD Analytics) · (b) BD IVR readonly · (c) Routers Django para enforcement · (d) Middleware de protección | 4 |
| CNST_004 Actualizacion_Datos_ETL | (a) Ventana ETL 6-12 h · (b) Prohibición de real-time · (c) Scheduler obligatorio · (d) API de estado ETL | 4 |
| CNST_005 Seguridad_DRF_Checklist | (a) Autenticación · (b) Autorización · (c) Throttling · (d) Validación de input · (e) Manejo de excepciones · (f) Paginación obligatoria | 6 |
| CNST_006 Antipatrones_Arquitectura | (a) Antipatrones prohibidos · (b) Patrones recomendados · (c) Principios SOLID | 3 |
| CNST_007 Limites_Performance_SLA | (a) Tiempos de respuesta · (b) Rango temporal de consultas · (c) Exportaciones asíncronas · (d) Optimización de queries | 4 |
| CNST_008 Infraestructura_Deployment | (a) Stack obligatorio (Ubuntu+Apache+mod_wsgi) · (b) Estructura de directorios · (c) Configuración Apache · (d) Proceso de deployment · (e) Rollback | 5 |
| CNST_009 Logging_Auditoria_Inmutable | (a) Logging estructurado · (b) Auditoría inmutable · (c) Retención de logs · (d) PII en logs (prohibición) | 4 |
| CNST_010 Clasificacion_Proteccion_Datos | (a) Clasificación de datos · (b) Matriz de acceso · (c) Protección de exportaciones | 3 |
| CNST_011 RBAC_Flat_SoD_Permisos | (a) Modelo RBAC flat · (b) Reglas SoD · (c) Permisos temporales | 3 |
| **Total** |  | **42 concerns en 11 CNSTs** |

## Propuesta de descomposición SRP

Set canónico re-arquitecturado: **~30 CNSTs atómicas**, agrupadas por
dominio, donde cada una declara una sola condición de borde.

### Dominio: Comunicaciones (2 CNSTs)

| Nuevo | Concern atómico | Origen |
|-------|-----------------|--------|
| **CNST_C01** No_Email_SMTP | Prohibición absoluta de email/SMTP | CNST_001(a) |
| **CNST_C02** Buzon_Interno_Obligatorio | Buzón interno como único canal de notificación + límites (50 destinatarios, consolidación 1 h, evaluación 5–15 min) | CNST_001(b) + TH-CNST_004 |

### Dominio: Sesiones (3 CNSTs)

| Nuevo | Concern atómico | Origen |
|-------|-----------------|--------|
| **CNST_S01** Sesiones_En_BD | Sesiones persistidas en BD (no cookies, no cache externo) | CNST_002(a) |
| **CNST_S02** Sesion_Unica_Por_Usuario | Una sola sesión activa por usuario | CNST_002(b) |
| **CNST_S03** Timeout_Sesion_15min | Timeout de inactividad de 15 min | CNST_002(c) |

### Dominio: Base de datos (3 CNSTs)

| Nuevo | Concern atómico | Origen |
|-------|-----------------|--------|
| **CNST_D01** BD_Dual_Arquitectura | Arquitectura dual obligatoria (BD IVR + BD Analytics) | CNST_003(a) |
| **CNST_D02** BD_IVR_Readonly | BD IVR es estrictamente solo lectura | CNST_003(b,c,d) |
| **CNST_D03** ETL_Ventana_6_12h | Sincronización IVR→Analytics solo vía ETL en ventana de 6–12 h, NO real-time | CNST_004 |

### Dominio: Seguridad DRF (6 CNSTs)

| Nuevo | Concern atómico | Origen |
|-------|-----------------|--------|
| **CNST_SEC01** Auth_DRF_Obligatoria | Toda vista DRF requiere autenticación, sin excepción | CNST_005(a) |
| **CNST_SEC02** Permission_Class_Explicita | Toda vista DRF requiere `permission_classes` explícito | CNST_005(b) |
| **CNST_SEC03** Throttling_Obligatorio | Throttling obligatorio en endpoints públicos y de exportación | CNST_005(c) |
| **CNST_SEC04** Validacion_Input_Serializer | Validación obligatoria de input vía serializer | CNST_005(d) |
| **CNST_SEC05** Manejo_Excepciones_Estandar | Manejo de excepciones estandarizado, sin filtrado de detalles internos | CNST_005(e) |
| **CNST_SEC06** Paginacion_Obligatoria | Paginación obligatoria en endpoints que retornan listas | CNST_005(f) |

### Dominio: Arquitectura (2 CNSTs)

| Nuevo | Concern atómico | Origen |
|-------|-----------------|--------|
| **CNST_A01** Antipatrones_Prohibidos | Lista de antipatrones explícitamente prohibidos | CNST_006(a) |
| **CNST_A02** SOLID_Obligatorio | Principios SOLID obligatorios (con criterios de verificación) | CNST_006(c) |

> Nota: "Patrones recomendados" (CNST_006(b)) NO es restricción —
> pertenece a `normativa/estandares/` o a una guía de arquitectura.

### Dominio: Performance (3 CNSTs)

| Nuevo | Concern atómico | Origen |
|-------|-----------------|--------|
| **CNST_P01** SLA_Respuesta | Límites de tiempo de respuesta por tipo de endpoint | CNST_007(a) |
| **CNST_P02** Rango_Consulta_Maximo_2A | Rango temporal máximo de 2 años (730 días) en consultas | CNST_007(b) + TH-CNST_006 |
| **CNST_P03** Exportaciones_Asincronas | Exportaciones >10k registros deben ser asíncronas | CNST_007(c) |

### Dominio: Infraestructura (3 CNSTs)

| Nuevo | Concern atómico | Origen |
|-------|-----------------|--------|
| **CNST_I01** Stack_Ubuntu_Apache_WSGI | Stack obligatorio: Ubuntu + Apache + mod_wsgi | CNST_008(a) |
| **CNST_I02** Estructura_Directorios_Servidor | Estructura de directorios obligatoria en servidor | CNST_008(b,c) |
| **CNST_I03** Rollback_Obligatorio | Procedimiento de rollback obligatorio en cada deployment | CNST_008(e) |

> Nota: "Proceso de deployment" (CNST_008(d)) es procedimiento, no
> restricción — pertenece a `normativa/procedimientos/`.

### Dominio: Logging y auditoría (3 CNSTs)

| Nuevo | Concern atómico | Origen |
|-------|-----------------|--------|
| **CNST_L01** Logs_Estructurados | Logs en formato estructurado (JSON), no texto libre | CNST_009(a) |
| **CNST_L02** Auditoria_Inmutable | Auditoría inmutable: append-only, sin update/delete | CNST_009(b) |
| **CNST_L03** PII_Prohibida_En_Logs | PII no puede aparecer en logs | CNST_009(d) |

> Nota: "Retención de logs" (CNST_009(c)) puede ser parte de CNST_L02 o
> ir como CNST atómica adicional según el detalle del backup.

### Dominio: Datos (2 CNSTs)

| Nuevo | Concern atómico | Origen |
|-------|-----------------|--------|
| **CNST_DAT01** Clasificacion_4_Niveles | Clasificación obligatoria de datos en 4 niveles (Public, Internal, Confidential, Restricted) | CNST_010(a) |
| **CNST_DAT02** Cifrado_Confidencial | Cifrado obligatorio para datos Confidential y Restricted en reposo y exportación | CNST_010(b,c) |

### Dominio: RBAC (3 CNSTs)

| Nuevo | Concern atómico | Origen |
|-------|-----------------|--------|
| **CNST_R01** RBAC_Flat | Modelo RBAC plano, sin jerarquía ni herencia | CNST_011(a) |
| **CNST_R02** SoD_Reglas_Atomicas | Reglas SoD declaradas y enforced (atómicas, no narrativas) | CNST_011(b) |
| **CNST_R03** Permisos_Temporales_Maximo_6m | Permisos temporales con vigencia máxima de 6 meses, justificación obligatoria, revocación automática | CNST_011(c) |

## Total propuesto

**30 CNSTs atómicas** distribuidas en 10 dominios.

## Trade-offs

### Ventajas (SRP estricto)

1. **Trazabilidad atómica:** una violación apunta a una sola CNST, sin
   ambigüedad.
2. **Verificación independiente:** cada CNST tiene su propio criterio
   de cumplimiento.
3. **Mantenimiento focalizado:** modificar la regla de timeout no
   requiere editar un CNST gigante con N concerns.
4. **Consumo por requisitos:** un UC puede listar exactamente las
   CNSTs que aplican (granularidad fina).

### Costos

1. **+19 archivos:** de 11 a 30 CNSTs. Más toctree, más cross-refs.
2. **Re-numeración total:** la nomenclatura `CNST_001..CNST_011`
   actual queda invalidada. El mapeo viejo→nuevo crece de 12 filas
   a 42.
3. **Re-trabajo:** los 11 archivos actuales (≥10k líneas total) se
   descomponen y se reescriben. Trabajo significativo.
4. **Cross-cutting:** algunas restricciones tienen dependencias
   genuinas (CNST_R02 SoD requiere CNST_R01 RBAC flat). Hay que
   declarar `requires:` explícito en metadata.

## Esquema de identificadores

Dos opciones:

**Opción A — Numérico flat (consistente con resto de cajones):**
`CNST_001` … `CNST_030`

- Pro: consistente con `procedimientos/`, `estandares/`.
- Contra: el número no transmite dominio. El lector tiene que abrir
  el archivo para saber a qué dominio pertenece.

**Opción B — Prefijo de dominio:**
`CNST_C01` (Comunicaciones), `CNST_S01` (Sesiones), `CNST_SEC01`
(Seguridad), etc.

- Pro: el dominio se lee del identificador.
- Contra: rompe la convención flat de los demás cajones; STD_007
  tendría que documentar la excepción.

**Recomendación:** Opción A (flat numérico), respetando la convención
del resto del repo. El dominio se expresa en el `index.rst` por
sección y en `:dominio:` del metadata.

## Pre-condiciones para ejecutar

1. Aprobación explícita del ejecutor — es un cambio de scope mayor.
2. Decidir qué hacer con los 11 archivos actuales: descomponerlos
   in-place (delete + create 30) o dejar los 11 como "agregados de
   referencia" + crear los 30 atómicos.
3. Re-emitir `mapeo-viejo-nuevo.md` con 42 filas.
4. Comunicar a WP #6 (requisitos) que las refs CNST_XXX cambian
   masivamente.

## Riesgo si se descompone

- WP #6 requisitos consumirá 30 CNSTs en lugar de 11. Si la
  granularidad fina sobrepasa las necesidades reales de los UCs,
  los UCs tendrán listas de 5–10 CNSTs cada uno (verboso).

## Riesgo si NO se descompone

- Una violación reportada contra `CNST_005` no comunica qué se
  violó (¿auth? ¿throttling? ¿paginación?).
- Cuando una CNST cambie (ej. Permission Temporal pasa de 6m a 12m),
  hay que editar un archivo de 1 095 líneas en lugar de uno de
  ~150 líneas atómico.

## Decisión pendiente

¿Procedo con la descomposición a 30 CNSTs atómicas (Opción A:
identificador `CNST_001..CNST_030`)?

- **Sí, con descomposición completa**: re-numerar todo, los 11
  archivos actuales se desarman.
- **Sí, parcial**: descomponer solo los CNSTs con >3 concerns
  (CNST_002, 003, 004, 005, 007, 008, 009, 011) — 25 archivos
  finales.
- **No, mantener los 11 actuales**: declarar SRP como deuda
  explícita y dejarlo para una iteración futura.
