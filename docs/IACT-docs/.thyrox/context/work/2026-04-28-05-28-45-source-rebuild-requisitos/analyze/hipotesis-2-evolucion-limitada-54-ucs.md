```yml
created_at: 2026-04-29 02:30:00
project: IACT-docs
work_package: 2026-04-28-05-28-45-source-rebuild-requisitos
phase: Phase 1 — DISCOVER (escenario arquitectonico)
author: NestorMonroy
status: Borrador para decision
version: 1.0.0
```

# Hipotesis 2 — EVOLUCION LIMITADA (54 UCs en 9 modulos)

## Premisa

MOD_Permissions es la **EVOLUCION** del subcomponente RBAC_CORE de
MOD_Access (INFERRED del GAP_ANALYSIS — 75% backend implementado).
MOD_Access se preserva pero **REDUCIDO** a las funcionalidades que NO
fueron absorbidas por PERM:

- SoD (Separation of Duties) — politica del proyecto
- Segmentos (data scope) — modelo del proyecto
- Permisos Temporales — vinculo con UC_PERM_03
- Asignar Segmento (operacion sobre segmento)

UC_ACC_01..04 se marcan REPLACED_BY UC_PERM_*: el catalogo cerrado de
agrupadores se vuelve "grupos predefinidos" en el modelo PERM.

## Ventajas

- **Vocabulario unificado**: el modelo PERM es la realidad
  implementada en backend (Funcion, Capacidad, GrupoPermiso). Los
  agrupadores AGR-001..009 quedan como "grupos predefinidos" en PERM.
- **Una sola auditoria de permisos** (UC_PERM_09/10) — sin duplicacion
  con UC_ACC_09.
- **Menor numero de UCs** (54 vs 63) — menos mantenimiento.
- **Reflejo arquitectonico de la realidad** — backend ya tiene 8
  modelos PERM, 5 funciones SQL, endpoint `/menu/`. Documentar lo
  que existe.
- **Evolucion explicita** documentada via ADR-GOB-008.

## Desventajas

- **Cambio arquitectonico mayor** — invalida los UC_ACC_01..04 .rst
  canonicos del backup. Requiere rework de esos 4 archivos (renombrar
  o marcar deprecated).
- **Riesgo de incompatibilidad con CNST_005 legacy** (18 roles fijos)
  — si CNST_005 sigue activo, hay que reformularlo.
- **Perdida de la vista "admin no-tech"** — todos los admins deben
  aprender el modelo PERM granular.
- **Requiere ADR formal** que declare la evolucion.

## Catalogo modular completo

### Tabla maestra

| Modulo | UCs | Cantidad | Codigo origen |
|--------|-----|----------|---------------|
| MOD_Auth | UC_AUTH_01..05 | 5 | `.rst` canonico |
| MOD_Users | UC_USR_01..04 | 4 | `.rst` canonico |
| MOD_Access | UC_ACC_05..08 (4 UCs reducidos) | **4** | `.rst` canonico (preservados de los 9) |
| MOD_Permissions | UC_PERM_01..10 | **10** (NUEVO modulo) | `.md` en gobernanza inputs |
| MOD_Reports | UC_RPT_01..14 | 14 | `.rst` canonico |
| MOD_Alerts | UC_ALR_01..05 | 5 | `.rst` canonico |
| MOD_Pipeline | UC_PIP_01..04 | 4 | `.rst` canonico |
| MOD_Audit | UC_AUD_01..04 | 4 | `.rst` canonico |
| MOD_Logs | UC_LOG_01..04 | 4 | `.rst` canonico |
| **TOTAL** | | **54 UCs** | |

### Re-mapeo de UC_ACC_01..04 → UC_PERM_*

| UC_ACC original | Replaced by | Nota |
|-----------------|-------------|------|
| UC_ACC_01 Asignar Funciones | UC_PERM_01 Asignar Grupo | "Funciones" del proyecto se convierten en "Grupos" predefinidos |
| UC_ACC_02 Revocar Funciones | UC_PERM_02 Revocar Grupo | Inverso de UC_PERM_01 |
| UC_ACC_03 Consultar Permisos | UC_PERM_07 Verificar Permiso (admin) + UC_PERM_10 Consultar Auditoria | Vista admin granular |
| UC_ACC_04 Asignar Agrupador | UC_PERM_06 Asignar Capacidades a Grupo | "Agrupadores fijos" se redefinen como "Grupos creables" |

**Accion en Phase 2:** los .rst de UC_ACC_01..04 se MARCAN como
deprecated con redirect doc:

```rst
.. deprecated:: 2026-04-29
   Reemplazado por :doc:`/requisitos/casos_uso/permissions/UC_PERM_01_Asignar_Grupo`
   tras la decision arquitectonica documentada en ADR-GOB-008.
```

### Detalle por modulo (cambios respecto a Hipotesis 1)

#### MOD_Access — REDUCIDO a 4 UCs

**Preservados:**
- UC_ACC_05 Gestionar SoD (politica del proyecto, distinto de PERM)
- UC_ACC_06 Gestionar Segmentos (data scope, distinto de grupos)
- UC_ACC_07 Asignar Segmento (operacion sobre segmento)
- UC_ACC_08 Permiso Temporal (vincula con UC_PERM_03 conceder
  excepcional, pero foco distinto)

**Removidos del modulo (reemplazados):**
- UC_ACC_01 → UC_PERM_01
- UC_ACC_02 → UC_PERM_02
- UC_ACC_03 → UC_PERM_07/10
- UC_ACC_04 → UC_PERM_06

**Removido (fusionado en MOD_Audit):**
- UC_ACC_09 Auditar Cambios Acceso → fusionado en UC_PERM_10
  Consultar Auditoria de Permisos

CNSTs MOD_Access reducido: CNST_029 (RBAC plano — para SoD), CNST_030
(SoD reglas), CNST_031 (permisos temporales).

#### MOD_Permissions — completo (10 UCs)

Igual que en Hipotesis 1. Es el modulo CORE de RBAC tecnico.

#### MOD_Audit — sin cambios (4 UCs)

UC_AUD_01..04 preservados. UC_PERM_09/10 son auditoria especifica
de permisos (mas granular que UC_AUD).

#### Resto de modulos (Auth, Users, Reports, Alerts, Pipeline, Logs)

Sin cambios respecto a Hipotesis 1.

## Mapeo de auditoria (2 fuentes en Hipotesis 2)

| UC | Foco |
|----|------|
| UC_PERM_09 Auditar Acceso | Cada acceso runtime (verificacion de permiso) — fuente UNICA para auditoria de permisos |
| UC_PERM_10 Consultar Auditoria de Permisos | Vista admin de logs PERM (incluye lo que antes era UC_ACC_09) |
| UC_AUD_01..04 | Auditoria general del sistema (eventos non-PERM) |

**2 fuentes** — una por dominio (permisos vs sistema general).
Eliminado UC_ACC_09 redundante.

## Tareas Phase 2 EXECUTE (Hipotesis 2)

| # | Tarea | Insumo | Esfuerzo |
|---|-------|--------|----------|
| T-1 | Copiar 49 RST canonicos a `source/requisitos/casos_uso/` | `temp-backup/.../casos_uso/` | Bajo |
| T-2 | **Marcar UC_ACC_01..04 + UC_ACC_09 como deprecated** con `.. deprecated::` directive y redirect | edicion sobre los 5 .rst | Medio |
| T-3 | Convertir 10 UC_PERM `.md` → `.rst` con metadata estandar | `inputs/canonical/UC-PERM-*.md` | Medio (1894 ln) |
| T-4 | Mapear refs CNST legacy → SRP-31 en metadata UC | inventory + mapping doc | Medio |
| T-5 | Crear 9 `index.rst` por modulo + `index.rst` raiz | nuevo | Bajo |
| T-6 | Conectar a `source/requisitos/index.rst` padre | nuevo | Bajo |
| T-7 | **Crear ADR-GOB-008** "Evolucion RBAC: ACC → PERM" formalizando la decision | nuevo | Medio |
| T-8 | **Actualizar CNST_005 si aplica** — revisar si "18 roles fijos" sigue siendo restriccion | edicion CNST | Alto (impacto cross-WP) |
| T-9 | Actualizar `glosario.rst` con vocabulario unificado | edicion glosario | Bajo |
| T-10 | Build limpio + verificacion automatizada | | Bajo |

**Esfuerzo total estimado:** 8-12 horas (mas alto que Hipotesis 1
por el ADR + revision de CNST_005 + deprecation).

## Decisiones D-REQ derivadas

- D-REQ-1: Confirmar evolucion limitada (Hipotesis 2).
- D-REQ-2: UC_PERM_NN (2-dig) vs UC_PERM_NNN (3-dig) — sugerido 2-dig.
- D-REQ-3: ¿Mantener UC_ACC_01..04 .rst como deprecated (legible
  historicamente) o eliminar fisicamente?
- D-REQ-4: ¿CNST_005 (18 roles fijos) se preserva, deprecata o se
  reformula a "max N grupos predefinidos en PERM"?
- D-REQ-5: ADR-GOB-008 declarando la evolucion.

## Vista del directorio resultante

```
source/requisitos/casos_uso/
├── index.rst
├── auth/         (5 UCs + index)
├── users/        (4 UCs + index)
├── access/       (4 UCs + index + 5 deprecated stubs)
│   ├── UC_ACC_01_Asignar_Funciones.rst        [deprecated → permissions/UC_PERM_01]
│   ├── UC_ACC_02_Revocar_Funciones.rst        [deprecated → permissions/UC_PERM_02]
│   ├── UC_ACC_03_Consultar_Permisos.rst       [deprecated → permissions/UC_PERM_07]
│   ├── UC_ACC_04_Asignar_Agrupador.rst        [deprecated → permissions/UC_PERM_06]
│   ├── UC_ACC_05_Gestionar_SoD.rst            [preservado]
│   ├── UC_ACC_06_Gestionar_Segmentos.rst      [preservado]
│   ├── UC_ACC_07_Asignar_Segmento.rst         [preservado]
│   ├── UC_ACC_08_Permiso_Temporal.rst         [preservado]
│   └── UC_ACC_09_Auditar_Cambios_Acceso.rst   [deprecated → permissions/UC_PERM_10]
├── permissions/  (10 UCs + index) [NUEVO modulo, vocabulario PERM]
├── reports/      (14 UCs + index)
├── alerts/       (5 UCs + index)
├── pipeline/     (4 UCs + index)
├── audit/        (4 UCs + index)
└── logs/         (4 UCs + index)
```

## Riesgos a mitigar

1. **Romper compatibilidad con CNST_005** — verificar y posiblemente
   actualizar la restriccion arquitectonica.
2. **Refs externas a UC_ACC_01..04** — escanear todo `source/` y
   `inputs/` para identificar y actualizar referencias rotas.
3. **Confusion sobre rol del modulo Access** — documentar claramente
   en `access/index.rst` que el modulo se enfoca en SoD, Segmentos
   y Permisos Temporales (NO en grupos/capacidades, eso es PERM).
4. **Migracion gradual vs total** — decidir si los stubs deprecated
   se mantienen indefinidamente o se eliminan en una version futura.

## Comparacion vs Hipotesis 1

| Criterio | Hipotesis 1 (Coexistencia) | Hipotesis 2 (Evolucion limitada) |
|----------|----------------------------|----------------------------------|
| Total UCs | 63 | 54 |
| MOD_Access UCs | 9 (intactos) | 4 (reducidos) |
| MOD_Permissions UCs | 10 | 10 |
| Vocabulario | Doble (Funcion + Capacidad) | Unificado (Capacidad) |
| Auditoria | 3 fuentes (ACC/PERM/AUD) | 2 fuentes (PERM/AUD) |
| Esfuerzo Phase 2 | 4-6 h | 8-12 h |
| Cambios cross-WP | Bajo | Medio (CNST_005 + glosario) |
| Riesgo | Drift vocabulario | Romper compatibilidad legacy |
| ADR requerido | Coexistencia (ADR-GOB-008) | Evolucion (ADR-GOB-008) |
| Reflejo del backend (75% PERM) | Parcial | Total |

## Recomendacion (mia)

**Hipotesis 2** porque:

1. **Refleja la realidad implementada** — el backend ya tiene PERM al
   75%. Los .rst canonicos UC_ACC_01..04 son del modelo conceptual
   anterior, ya superado.
2. **Evita doble vocabulario** — un solo concepto granular
   (Capacidad), agrupados en GrupoPermiso (puede ser predefinido
   AGR-001..009 o creable).
3. **Reduce mantenimiento** futuro (54 vs 63 UCs).
4. **Audita una sola vez** los accesos (en PERM_09).

PERO la decision es del ejecutor. Si la prioridad es:
- "**No tocar lo canonico .rst**" → Hipotesis 1.
- "**Reflejar la realidad implementada**" → Hipotesis 2.
