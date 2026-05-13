```yml
created_at: 2026-04-29 01:30:00
project: IACT-docs
work_package: 2026-04-28-05-28-45-source-rebuild-requisitos
phase: Phase 1 — DISCOVER (analisis consolidado UC)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Catalogo UC IACT v4.0.0 consolidado — analisis y propuesta

## Origen

Tras pregunta del usuario sobre UCs documentados como `.md` no
migrados a `.rst`, se identifico que el catalogo canonico de 49 UCs
esta INCOMPLETO. Faltan dos sub-dominios CORE:

1. **MOD_Call** (4 UCs en `.md`) — gestion de llamadas IVR
2. **MOD_Permissions** (10 UCs en `.md`) — gestion de grupos de
   permisos, capacidades, menu dinamico

Confirmacion del usuario: UC-PERM-001 ≠ UC_ACC_01 (modelos distintos
del RBAC). UC-PERM-005 (Crear Grupo) y UC-PERM-008 (Generar Menu
Dinamico) deben incorporarse.

## Inventario completo de fuentes

| Fuente | Formato | UCs | Status |
|--------|---------|-----|--------|
| `temp-backup/source-2026-04-28/requisitos/casos_uso/` | `.rst` | 49 | Canonicos v4.0.0 |
| `WP-gobernanza/inputs/canonical/UC-CALL-*.md` | `.md` | 4 | Sustantivos, NO en .rst |
| `WP-gobernanza/inputs/canonical/UC-PERM-*.md` | `.md` | 10 | Sustantivos, NO en .rst |
| `WP-gobernanza/inputs/canonical/UC-BACK/UC-FRONT/UC-001` | `.md` | 4 | Ejemplos didacticos — descartar |
| **Total IACT real** | | **63** | |

## Analisis comparativo MOD_Access vs MOD_Permissions

Confirmado por el usuario y verificado contra contenido:

### MOD_Access (UC_ACC, 9 UCs canonicos) — capabilities atomicas

| UC | Concepto | Modelo |
|----|----------|--------|
| UC_ACC_01 Asignar Funciones | Asigna **funciones atomicas** (las 42 RBAC) | Funcion ↔ Usuario |
| UC_ACC_02 Revocar Funciones | Revoca funciones atomicas | Funcion ↔ Usuario |
| UC_ACC_03 Consultar Permisos | Admin: ver que tiene un usuario | Lectura |
| UC_ACC_04 Asignar Agrupador | Asigna un **agrupador-rol** AGR-001..009 | AGR fijo ↔ Usuario |
| UC_ACC_05 Gestionar SoD | Reglas de Separation of Duties | Restriccion |
| UC_ACC_06 Gestionar Segmentos | Catalogo de segmentos de datos | Data scope |
| UC_ACC_07 Asignar Segmento | Asigna segmento a usuario | Data scope ↔ Usuario |
| UC_ACC_08 Permiso Temporal | Funciones con vencimiento | Funcion temporal |
| UC_ACC_09 Auditar Cambios Acceso | Historial de asignaciones | Audit |

**Foco:** modelo del proyecto IACT con **agrupadores fijos** (9 roles
predefinidos AGR-001..009) y **funciones atomicas** (42 capabilities).

### MOD_Permissions (UC_PERM, 10 UCs en .md) — grupos creables + runtime

| UC | Concepto | Modelo |
|----|----------|--------|
| UC_PERM_01 Asignar Grupo a Usuario | Asigna un **grupo de permisos** | Grupo ↔ Usuario |
| UC_PERM_02 Revocar Grupo a Usuario | Revoca grupo | Grupo ↔ Usuario |
| UC_PERM_03 Conceder Permiso Excepcional | One-off override | Excepcion |
| UC_PERM_04 Revocar Permiso Excepcional | | Excepcion |
| UC_PERM_05 **Crear Grupo de Permisos** | **Admin del catalogo de grupos** | Grupo (CRUD) |
| UC_PERM_06 Asignar Capacidades a Grupo | Define que puede hacer un grupo | Capacidad ↔ Grupo |
| UC_PERM_07 Verificar Permiso de Usuario | **Runtime check** | Chequeo |
| UC_PERM_08 **Generar Menu Dinamico** | **UI adaptativa runtime** | UI |
| UC_PERM_09 Auditar Acceso | Registro de cada acceso runtime | Audit runtime |
| UC_PERM_10 Consultar Auditoria de Permisos | Admin lectura de logs permisos | Audit lectura |

**Foco:** modelo de **grupos creables dinamicamente** (no agrupadores
fijos) + **operacion runtime** (verificacion, menu, audit).

### Diferencia conceptual clave

| Aspecto | MOD_Access | MOD_Permissions |
|---------|------------|-----------------|
| Granularidad | Funcion atomica (42 capabilities) | Grupo de permisos (set de capacidades) |
| Catalogo | Cerrado (AGR-001..009) | Abierto (admin crea grupos) |
| Operacion | Admin / catalogo | Admin + Runtime |
| UI | (out of scope) | Genera menu dinamico |
| Audit | Cambios de asignacion | Cada acceso runtime |
| CNST canonico | CNST_029 (RBAC plano) + CNST_030 (SoD) + CNST_031 (Temporal) | CNST_029 (RBAC plano) — modelo coexiste |

**Conclusion:** son modulos COMPLEMENTARIOS del mismo modelo RBAC
plano (CNST_029). ACC opera el catalogo cerrado de la organizacion;
PERM da flexibilidad operativa (grupos creables + runtime).

## MOD_Call (UC_CALL, 4 UCs en .md) — modulo CORE faltante

IACT = "IVR Analytics & Customer Tracking". Los UCs de gestion de
llamadas son CORE del sistema:

| UC | Actor primario | Foco |
|----|----------------|------|
| UC_CALL_01 Registrar Llamada Entrante | Sistema IVR | Captura inicial de llamada |
| UC_CALL_02 Atender Llamada | Agente Call Center | Operacion del agente |
| UC_CALL_03 Transferir Llamada | Supervisor | Routing |
| UC_CALL_04 Generar Reporte Rendimiento | Gerente | KPIs de equipo (¿overlap RPT?) |

**Nota sobre UC_CALL_04:** "Generar Reporte de Rendimiento de Equipo"
puede solapar con MOD_Reports (UC_RPT_*). Decision: dejar en MOD_Call
porque su contexto es "rendimiento de agentes/equipo" (call-center
specifico) — los UC_RPT son reportes generales.

## Catalogo TOTAL propuesto — 3 opciones

### Opcion A (separacion pura) — 63 UCs

| Modulo | UCs | Cantidad |
|--------|-----|----------|
| MOD_Auth | UC_AUTH_01..05 | 5 |
| MOD_Users | UC_USR_01..04 | 4 |
| MOD_Access | UC_ACC_01..09 | 9 |
| MOD_Permissions | UC_PERM_01..10 (NUEVO modulo) | 10 |
| MOD_Reports | UC_RPT_01..14 | 14 |
| MOD_Alerts | UC_ALR_01..05 | 5 |
| MOD_Pipeline | UC_PIP_01..04 | 4 |
| MOD_Audit | UC_AUD_01..04 | 4 |
| MOD_Logs | UC_LOG_01..04 | 4 |
| MOD_Call | UC_CALL_01..04 (NUEVO modulo) | 4 |
| **Total** | | **63** |

**Ventaja:** maxima trazabilidad, cada concepto en su modulo.
**Costo:** 2 modulos nuevos (PERM, CALL); auditoria duplicada en
MOD_Permissions (UC_PERM_09, UC_PERM_10) y MOD_Audit.

### Opcion B (fusion de auditoria PERM → AUD) — 63 UCs total, distribucion distinta

| Modulo | UCs | Cantidad |
|--------|-----|----------|
| MOD_Auth | UC_AUTH_01..05 | 5 |
| MOD_Users | UC_USR_01..04 | 4 |
| MOD_Access | UC_ACC_01..09 | 9 |
| MOD_Permissions | UC_PERM_01..08 (sin 09/10) | 8 |
| MOD_Reports | UC_RPT_01..14 | 14 |
| MOD_Alerts | UC_ALR_01..05 | 5 |
| MOD_Pipeline | UC_PIP_01..04 | 4 |
| MOD_Audit | UC_AUD_01..06 (agrega los 2 de PERM) | 6 |
| MOD_Logs | UC_LOG_01..04 | 4 |
| MOD_Call | UC_CALL_01..04 | 4 |
| **Total** | | **63** |

**Ventaja:** sin duplicacion de auditoria.
**Costo:** PERM pierde su sub-funcionalidad de audit runtime (deberia
quedar en AUD); pierde cohesion del modulo.

### Opcion C (selectiva minima) — 55 UCs

Solo incorporar lo que el usuario explicito + CALL:

| Modulo | UCs | Cantidad |
|--------|-----|----------|
| MOD_Auth..Logs (canonicos) | igual que Opcion A excepto PERM | 49 |
| MOD_Permissions | UC_PERM_05 (Crear Grupo) + UC_PERM_08 (Menu Dinamico) | 2 |
| MOD_Call | UC_CALL_01..04 | 4 |
| **Total** | | **55** |

**Ventaja:** minimo cambio, solo los explicitamente confirmados.
**Costo:** se descartan 8 UC_PERM con contenido sustantivo (incluyendo
Asignar/Revocar Grupo, Conceder Permiso Excepcional, Verificar
Permiso runtime). Probablemente subóptimo: los .md tienen 1894 lineas
de contenido valioso.

## Recomendacion

**OPCION A** (63 UCs en 10 modulos):

1. Los 14 UCs en .md tienen contenido sustantivo formal (frontmatter
   con `id`, `actor_primario`, `trazabilidad_upward/downward`,
   `reglas_negocio_aplicadas`).
2. UC_PERM_09/10 (auditoria de permisos) son distintos de UC_AUD_*
   (auditoria de sistema completo) — la fusion B perderia granularidad.
3. La separacion pura ACC vs PERM refleja la distincion arquitectonica
   real: catalogo cerrado vs grupos creables.
4. El usuario aclaro explicitamente: UC-PERM-001 ≠ UC_ACC_01.

## Estructura de directorios propuesta

```
source/requisitos/casos_uso/
├── index.rst
├── auth/                                     5 UCs
│   ├── UC_AUTH_01_Iniciar_Sesion.rst
│   ├── UC_AUTH_02_Cerrar_Sesion.rst
│   ├── UC_AUTH_03_Recuperar_Contrasena.rst
│   ├── UC_AUTH_04_Cambiar_Contrasena.rst
│   ├── UC_AUTH_05_Gestionar_Sesiones.rst
│   └── index.rst
├── users/                                    4 UCs
│   ├── UC_USR_01..04 + index.rst
├── access/                                   9 UCs
│   ├── UC_ACC_01..09 + index.rst
├── permissions/                              10 UCs (NUEVO modulo)
│   ├── UC_PERM_01_Asignar_Grupo.rst
│   ├── UC_PERM_02_Revocar_Grupo.rst
│   ├── UC_PERM_03_Conceder_Permiso_Excepcional.rst
│   ├── UC_PERM_04_Revocar_Permiso_Excepcional.rst
│   ├── UC_PERM_05_Crear_Grupo_Permisos.rst
│   ├── UC_PERM_06_Asignar_Capacidades_Grupo.rst
│   ├── UC_PERM_07_Verificar_Permiso_Usuario.rst
│   ├── UC_PERM_08_Generar_Menu_Dinamico.rst
│   ├── UC_PERM_09_Auditar_Acceso.rst
│   ├── UC_PERM_10_Consultar_Auditoria_Permisos.rst
│   └── index.rst
├── reports/                                  14 UCs
├── alerts/                                   5 UCs
├── pipeline/                                 4 UCs
├── audit/                                    4 UCs
├── logs/                                     4 UCs
└── call/                                     4 UCs (NUEVO modulo)
    ├── UC_CALL_01_Registrar_Llamada_Entrante.rst
    ├── UC_CALL_02_Atender_Llamada.rst
    ├── UC_CALL_03_Transferir_Llamada.rst
    ├── UC_CALL_04_Generar_Reporte_Rendimiento.rst
    └── index.rst
```

## Tareas para Phase 2 EXECUTE (si Opcion A aprobada)

| # | Tarea | Insumo |
|---|-------|--------|
| T-1 | Copiar 49 RST canonicos al rebuild source/ | temp-backup/.../casos_uso/ |
| T-2 | Convertir 4 UC_CALL .md → .rst | inputs/canonical/UC-CALL-*.md |
| T-3 | Convertir 10 UC_PERM .md → .rst | inputs/canonical/UC-PERM-*.md |
| T-4 | Aplicar metadata estandar 10 campos a todos | TPL_UC standard |
| T-5 | Crear index.rst raiz + 10 index.rst por modulo | |
| T-6 | Conectar a source/requisitos/index.rst | |
| T-7 | Mapear refs CNST legacy → SRP-31 (W-1) | mapping doc |
| T-8 | Build limpio + verificacion | |

## Decisiones D-REQ pendientes (para Phase 1C)

- D-REQ-1: confirmar Opcion A (63 UCs / 10 modulos)
- D-REQ-2: nomenclatura UC_PERM_NN (2-digit) o UC_PERM_NNN (3-digit como en .md)
- D-REQ-3: UC_CALL_04 (Reporte Rendimiento) — ¿queda en MOD_Call o se mueve a MOD_Reports?
- D-REQ-4: UC_PERM_09/10 (auditoria) — confirmar Opcion A (mantener en PERM, no fusionar a AUD)
- D-REQ-5: ¿se generan los UCs faltantes (de RPT/PIP/ALR) que el agente FR menciono "88% no .rst"? O ese conteo aplicaba solo a FR, no a UC?

## Pregunta clave al ejecutor

¿Procedemos con **Opcion A (63 UCs / 10 modulos)** o prefieres
**B/C**?
