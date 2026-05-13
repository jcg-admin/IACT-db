```yml
created_at: 2026-04-29 02:30:00
project: IACT-docs
work_package: 2026-04-28-05-28-45-source-rebuild-requisitos
phase: Phase 1 — DISCOVER (escenario arquitectonico)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Hipotesis 1 — COEXISTENCIA (APROBADA)

> **NOTA: APROBADA por el ejecutor (2026-04-29).** El conteo de UCs es
> **evolutivo** — puede crecer (nuevos UCs identificados durante discovery)
> o decrecer (consolidacion de overlaps detectados). Los numeros documentados
> son **estado actual**, NO decisivos. La decision arquitectonica que se fija
> es la **coexistencia ACC ↔ PERM**, no el conteo.

## Premisa

MOD_Access (catalogo cerrado del proyecto) y MOD_Permissions (sistema
tecnico granular) **COEXISTEN**. Son dos vistas distintas del mismo
sistema RBAC plano (CNST_029):

- MOD_Access = vista funcional para admin no-tech (asignar agrupadores
  predefinidos AGR-001..009).
- MOD_Permissions = sistema tecnico granular para admin tech (crear
  grupos dinamicos, asignar capacidades, runtime check, menu
  dinamico).

Ambos preservan todos sus UCs documentados. No hay perdida.

## Ventajas

- **Cobertura maxima**: preserva los 49 UCs canonicos `.rst` + 10
  UC_PERM `.md` documentados.
- **Dos perfiles de usuario admin**:
  - Admin no-tech (RH, ops): usa UC_ACC con agrupadores fijos (modelo
    simplificado).
  - Admin tech (DevSecOps): usa UC_PERM granular cuando necesita crear
    grupos especiales.
- **Zero rework** sobre los .rst canonicos.
- **Compatibilidad con CNST_005** (18 roles fijos legacy) si se
  preserva.

## Desventajas

- **Doble vocabulario** en docs: "Funcion" (ACC) vs "Capacidad" (PERM),
  "Agrupador" (ACC) vs "Grupo de Permisos" (PERM).
- **Doble auditoria**: UC_ACC_09 (Auditar Cambios Acceso) + UC_PERM_09
  (Auditar Acceso) + UC_AUD_01..04. Tres fuentes potenciales de
  verdad.
- **Sin ADR formal** que declare la coexistencia — riesgo de drift
  futuro.
- **Mas UCs para mantener** (63 vs 54).

## Catalogo modular completo

### Tabla maestra

| Modulo | UCs | Cantidad | Codigo origen |
|--------|-----|----------|---------------|
| MOD_Auth | UC_AUTH_01..05 | 5 | `.rst` canonico |
| MOD_Users | UC_USR_01..04 | 4 | `.rst` canonico |
| MOD_Access | UC_ACC_01..09 | **9** (preservados intactos) | `.rst` canonico |
| MOD_Permissions | UC_PERM_01..10 | **10** (NUEVO modulo) | `.md` en gobernanza inputs |
| MOD_Reports | UC_RPT_01..14 | 14 | `.rst` canonico |
| MOD_Alerts | UC_ALR_01..05 | 5 | `.rst` canonico |
| MOD_Pipeline | UC_PIP_01..04 | 4 | `.rst` canonico |
| MOD_Audit | UC_AUD_01..04 | 4 | `.rst` canonico |
| MOD_Logs | UC_LOG_01..04 | 4 | `.rst` canonico |
| **TOTAL (estado actual)** | | **catalogo evolutivo** | |

### Detalle por modulo

#### MOD_Auth — Autenticacion y Sesiones (5 UCs)

- UC_AUTH_01 Iniciar Sesion
- UC_AUTH_02 Cerrar Sesion
- UC_AUTH_03 Recuperar Contrasena
- UC_AUTH_04 Cambiar Contrasena
- UC_AUTH_05 Gestionar Sesiones

CNSTs: CNST_001 (no email), CNST_002-005 (sesiones BD/unica/timeout),
CNST_009 (auth DRF), CNST_011 (throttling).

#### MOD_Users — Gestion de Identidades (4 UCs)

- UC_USR_01 Crear Usuario
- UC_USR_02 Consultar Usuarios
- UC_USR_03 Modificar Usuario
- UC_USR_04 Eliminar Usuario

CNSTs: CNST_026 (no PII en logs), CNST_027 (clasificacion datos).

#### MOD_Access — Roles, Permisos, Segmentos (9 UCs preservados)

- UC_ACC_01 Asignar Funciones (atomicas)
- UC_ACC_02 Revocar Funciones
- UC_ACC_03 Consultar Permisos
- UC_ACC_04 Asignar Agrupador (AGR-001..009)
- UC_ACC_05 Gestionar SoD
- UC_ACC_06 Gestionar Segmentos
- UC_ACC_07 Asignar Segmento
- UC_ACC_08 Permiso Temporal
- UC_ACC_09 Auditar Cambios Acceso

CNSTs: CNST_029 (RBAC plano), CNST_030 (SoD reglas), CNST_031
(permisos temporales 6 meses).

**Vocabulario:** Funcion (atomic capability), Agrupador (rol predefinido
AGR-001..009 fijo), Segmento (data scope).

#### MOD_Permissions — Sistema PERM Granular (10 UCs NUEVO)

- UC_PERM_01 Asignar Grupo a Usuario
- UC_PERM_02 Revocar Grupo a Usuario
- UC_PERM_03 Conceder Permiso Excepcional
- UC_PERM_04 Revocar Permiso Excepcional
- UC_PERM_05 Crear Grupo de Permisos
- UC_PERM_06 Asignar Capacidades a Grupo
- UC_PERM_07 Verificar Permiso de Usuario (runtime)
- UC_PERM_08 Generar Menu Dinamico
- UC_PERM_09 Auditar Acceso (runtime)
- UC_PERM_10 Consultar Auditoria de Permisos

CNSTs: CNST_029 (RBAC plano — mismo CNST que ACC), CNST_031
(permisos temporales).

**Vocabulario:** Capacidad (granular permission), GrupoPermiso
(set creable de capacidades), PermisoExcepcional (one-off override).

**Implementacion backend (75% PROVEN):**
- 8 modelos Django + 5 funciones SQL nativas + endpoint `/menu/`.

#### MOD_Reports — Dashboards y Reportes (14 UCs)

- UC_RPT_01 Ver Dashboard
- UC_RPT_02 Ver Metricas Tiempo Real
- UC_RPT_03 Ver Reportes Historicos
- UC_RPT_04..06 Exportar (CSV/Excel/PDF)
- UC_RPT_07 Programar Reporte
- UC_RPT_08 Ver Reportes Programados
- UC_RPT_09 Configurar Filtros
- UC_RPT_10 Guardar Vista
- UC_RPT_11 Compartir Reporte
- UC_RPT_12 Ver Reporte Agentes (cubre rendimiento equipo)
- UC_RPT_13 Ver Reporte Colas
- UC_RPT_14 Ver Reporte Campanas

CNSTs: CNST_017 (SLA tiempos), CNST_018 (rango max 2 anos),
CNST_019 (export async >10k), CNST_020 (throttling export por formato).

**Nota:** REFERENCIA_GLOBAL declara "NO real-time" pero los .rst
canonicos incluyen UC_RPT_02 "Ver Metricas Tiempo Real" — los .rst
v4.0.0 son mas recientes que REFERENCIA_GLOBAL.

#### MOD_Alerts — Alertas y Notificaciones (5 UCs)

- UC_ALR_01 Configurar Umbrales
- UC_ALR_02 Ver Alertas Activas
- UC_ALR_03 Reconocer Alerta
- UC_ALR_04 Ver Historial Alertas
- UC_ALR_05 Gestionar Suscripciones

CNSTs: CNST_001 (no email), CNST_002 (buzon interno: 50 destinatarios
max, eval 5-15 min, consolidacion 1h).

#### MOD_Pipeline — Supervision ETL (4 UCs)

- UC_PIP_01 Supervisar ETL
- UC_PIP_02 Consultar Errores ETL
- UC_PIP_03 Consultar Disponibilidad
- UC_PIP_04 Solicitar Reintento

CNSTs: CNST_006 (BD dual), CNST_007 (IVR readonly), CNST_008
(ETL ventana 6-12h).

#### MOD_Audit — Auditoria Funcional (4 UCs)

- UC_AUD_01 Consultar Auditoria
- UC_AUD_02 Buscar Auditoria
- UC_AUD_03 Exportar Auditoria
- UC_AUD_04 Generar Reporte Compliance

CNSTs: CNST_025 (auditoria inmutable), CNST_026 (no PII en logs).

**Convive con UC_PERM_09/10** — auditoria de permisos granular en
PERM, auditoria sistema general en AUD.

#### MOD_Logs — Bitacoras Tecnicas (4 UCs)

- UC_LOG_01 Consultar Logs Sistema
- UC_LOG_02 Consultar Logs ETL
- UC_LOG_03 Buscar Logs
- UC_LOG_04 Exportar Logs

CNSTs: CNST_024 (logs JSON estructurados), CNST_026 (no PII).

## Mapeo de auditoria (3 fuentes en Hipotesis 1)

| UC | Foco |
|----|------|
| UC_ACC_09 Auditar Cambios Acceso | Cambios de asignacion de funciones/agrupadores/segmentos |
| UC_PERM_09 Auditar Acceso | Cada acceso runtime (verificacion de permiso) |
| UC_PERM_10 Consultar Auditoria de Permisos | Vista admin de logs PERM |
| UC_AUD_01 Consultar Auditoria | Vista general de auditoria sistema |
| UC_AUD_02 Buscar Auditoria | Busqueda en auditoria sistema |
| UC_AUD_03 Exportar Auditoria | Export auditoria sistema |
| UC_AUD_04 Generar Reporte Compliance | Reporte ISO/SOC/etc |

**3 fuentes** — riesgo de divergencia mitigado con NFR_AUD_01 (cada
accion sensible registra evento UNICO en AuditLog).

## Tareas Phase 2 EXECUTE (Hipotesis 1)

| # | Tarea | Insumo | Esfuerzo |
|---|-------|--------|----------|
| T-1 | Copiar 49 RST canonicos a `source/requisitos/casos_uso/` | `temp-backup/.../casos_uso/` | Bajo |
| T-2 | Convertir 10 UC_PERM `.md` → `.rst` con metadata estandar | `inputs/canonical/UC-PERM-*.md` | Medio (1894 ln) |
| T-3 | Mapear refs CNST legacy → SRP-31 en metadata UC | inventory + mapping doc | Medio |
| T-4 | Crear 9 `index.rst` por modulo + `index.rst` raiz | nuevo | Bajo |
| T-5 | Conectar a `source/requisitos/index.rst` padre | nuevo | Bajo |
| T-6 | Crear ADR-GOB-008 declarando coexistencia ACC↔PERM | nuevo | Bajo |
| T-7 | Build limpio + verificacion automatizada | | Bajo |

**Esfuerzo total estimado:** 4-6 horas.

## Decisiones D-REQ derivadas

- D-REQ-1: Confirmar coexistencia (Hipotesis 1).
- D-REQ-2: UC_PERM_NN (2-dig) vs UC_PERM_NNN (3-dig) — sugerido 2-dig
  para consistencia.
- D-REQ-3: UC_AUD_04 vs UC_PERM_10 — ambos coexisten con foco distinto.
- D-REQ-4: Crear ADR-GOB-008 que declare la decision arquitectonica.

## Vista del directorio resultante

```
source/requisitos/casos_uso/
├── index.rst
├── auth/         (5 UCs + index)
├── users/        (4 UCs + index)
├── access/       (9 UCs + index) — agrupadores fijos
├── permissions/  (10 UCs + index) — grupos creables [NUEVO]
├── reports/      (14 UCs + index)
├── alerts/       (5 UCs + index)
├── pipeline/     (4 UCs + index)
├── audit/        (4 UCs + index)
└── logs/         (4 UCs + index)
```

## Riesgos a mitigar

1. **Drift de vocabulario** — agregar glosario en
   `source/base_cognitiva/glosario.rst` aclarando: Funcion (atomic),
   Capacidad (granular), Agrupador (predefined fixed), GrupoPermiso
   (creable).
2. **Triple auditoria** — declarar en cada UC su FUENTE DE VERDAD para
   auditoria (referenciar al UC apropiado, no duplicar).
3. **Confusion para nuevos desarrolladores** — documentar en
   ADR-GOB-008 cuando usar ACC vs PERM.
