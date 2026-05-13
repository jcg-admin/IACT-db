```yml
created_at: 2026-04-29 02:00:00
project: IACT-docs
work_package: 2026-04-28-05-28-45-source-rebuild-requisitos
phase: Phase 1 — DISCOVER (analisis arquitectonico final)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Analisis arquitectonico final — Catalogo modular IACT

## Premisa actualizada

Tras inventariar `inventory-modules-detailed.md` (agente sobre 3 docs
canonicos: REFERENCIA_GLOBAL, ANALISIS_PROFUNDO_RBAC, GAP_ANALYSIS),
hay **dos hallazgos que cambian la recomendacion previa:**

1. **PERM no es complementario a ACC — es evolucion/reemplazo
   parcial** (INFERRED del GAP_ANALYSIS). Vocabulario distinto:
   PERM usa `Funcion + Capacidad + GrupoPermiso`, RBAC v5.1.1 usa
   `Role + Function + Agrupador`.

2. **MOD_Call NO existe en ningun doc canonico** — `callcentersite`
   es nombre del proyecto Django, no modulo funcional. SPECULATIVE.

## Catalogo modular candidato — clasificacion por evidencia

| Modulo | Status | Evidencia | UCs propuestos |
|--------|--------|-----------|----------------|
| MOD_Auth | PROVEN | REF-GLOBAL §MOD_Auth + 5 .rst en backup | 5 (UC_AUTH_01..05) |
| MOD_Users | PROVEN | REF-GLOBAL + 4 .rst en backup | 4 (UC_USR_01..04) |
| MOD_Access | PROVEN | REF-GLOBAL + 9 .rst en backup | 9 (UC_ACC_01..09) |
| MOD_Reports | PROVEN | REF-GLOBAL + 14 .rst en backup | 14 (UC_RPT_01..14) |
| MOD_Alerts | PROVEN | REF-GLOBAL + 5 .rst en backup | 5 (UC_ALR_01..05) |
| MOD_Pipeline | PROVEN | REF-GLOBAL + 4 .rst en backup | 4 (UC_PIP_01..04) |
| MOD_Audit | PROVEN | REF-GLOBAL + 4 .rst en backup | 4 (UC_AUD_01..04) |
| MOD_Logs | PROVEN | REF-GLOBAL + 4 .rst en backup | 4 (UC_LOG_01..04) |
| MOD_Permissions | INFERRED | GAP_ANALYSIS 75% impl + 10 .md en gobernanza inputs | 10 (UC_PERM_01..10) |
| MOD_Call | SPECULATIVE | 4 .md en gobernanza inputs, NO en docs canonicos | 0 (descartar — ver §3.3) |

## Reanalisis de MOD_Call (SPECULATIVE)

### Lectura del nombre del sistema

**IACT** = "**IVR** Analytics & Customer Tracking".

- **IVR** = Sistema operacional **del cliente** (Voice Response). Es
  donde se gestionan las llamadas (registrar, atender, transferir).
- **Analytics & Tracking** = lo que IACT hace **sobre los datos del
  IVR**.

IACT NO opera el IVR — solo analiza sus datos via ETL (CNST_008
ventana 6-12h, sin tiempo real). El sistema operacional de llamadas
es responsabilidad del cliente.

### Reanalisis de los 4 UC-CALL .md

| UC | Actor | ¿Es de IACT? | Donde encaja |
|----|-------|--------------|--------------|
| UC-CALL-001 Registrar Llamada Entrante | Sistema IVR | NO — operacion del IVR del cliente | Out-of-scope IACT |
| UC-CALL-002 Atender Llamada | Agente Call Center | NO — operacion del IVR | Out-of-scope IACT |
| UC-CALL-003 Transferir Llamada | Supervisor | NO — operacion del IVR | Out-of-scope IACT |
| UC-CALL-004 Generar Reporte Rendimiento | Gerente | SI — es un reporte de IACT | Encaja en MOD_Reports (existing UC_RPT_* "Reporte de Agentes/Equipo") |

**Conclusion sobre MOD_Call:** los `.md` UC-CALL son modelado del
sistema IVR del cliente (origen de datos via ETL), NO modulos
funcionales de IACT. Pueden servir para documentar el contexto
operacional pero no entran al rebuild de `source/requisitos/casos_uso/`.

UC-CALL-004 (Reporte Rendimiento Equipo) probablemente solapa con
algun UC_RPT existente — verificar antes de descartar (titulos RPT
del backup incluyen "Ver Reporte Agentes", "Ver Reporte Colas", "Ver
Reporte Campanas").

**Catalogo corregido: NO incluir MOD_Call.**

## Reanalisis del dilema ACC ↔ PERM

### Hipotesis 1 (COEXISTENCIA pura — mi recomendacion previa)

ACC = vista funcional del proyecto (admin no-tech con agrupadores
fijos AGR-001..009). PERM = sistema tecnico granular (admin tech con
grupos creables).

**Pros:**
- Preserva todos los UCs documentados (ambos catalogos).
- Refleja dos perfiles de usuario admin (no-tech / tech).

**Contras:**
- Vocabulario inconsistente entre ambos.
- Doble auditoria (UC_ACC_09 vs UC_PERM_09).
- 18 roles fijos (CNST_005 legacy) vs grupos genericos (PERM).
- Sin ADR formal que declare la coexistencia.

### Hipotesis 2 (EVOLUCION — recomendacion del agente)

PERM es la evolucion del RBAC_CORE original. MOD_Access se refactoriza
para conservar SEC_RULES (enforcement runtime) + segmentos (data scope)
+ SoD legacy. UC_ACC_01..04 (Asignar Funciones, Revocar, Consultar,
Asignar Agrupador) se MAPEAN a UC_PERM_*.

**Pros:**
- Vocabulario unificado: el modelo implementado (PERM) es la
  realidad del backend.
- Una sola auditoria (PERM_09/10 absorbe UC_ACC_09).
- Menor numero total de UCs (no hay duplicacion).

**Contras:**
- Cambio arquitectonico mayor — requiere ADR formal.
- Los .rst canonicos UC_ACC_01..04 quedan obsoletos.
- 18 roles fijos (CNST_005) deben reformularse como GrupoPermiso.
- Riesgo de incompatibilidad con CNST canonico.

### Hipotesis 3 (RBAC ORIGINAL solo — descartar PERM)

Mantener catalogo de 8 modulos canonicos. Descartar UC-PERM-* como
"work in progress" no integrado.

**Pros:**
- Maxima fidelidad al modelo canonico documentado (REF-GLOBAL).
- Sin cambios arquitectonicos.

**Contras:**
- Pierde 75% de implementacion real del backend.
- Pierde menu dinamico (funcionalidad CORE para UX del RBAC).
- Pierde 1894 lineas de documentacion en .md.
- Sin reflejo de la evolucion arquitectonica que ya ocurrio.

## Recomendacion final

**Hipotesis 2 modificada: EVOLUCION CON LIMITES CLAROS**

1. **Crear MOD_Permissions** como modulo nuevo (10 UCs UC_PERM_01..10
   tomados de los .md). Es la implementacion real del backend.

2. **Mantener MOD_Access** con UCs reducidos:
   - UC_ACC_05 Gestionar SoD ✓ (funcion del catalogo cerrado)
   - UC_ACC_06 Gestionar Segmentos ✓
   - UC_ACC_07 Asignar Segmento ✓
   - UC_ACC_08 Permiso Temporal ✓ (vincula a UC_PERM_03)
   - UC_ACC_09 Auditar Cambios Acceso → fusionar con UC_PERM_09

3. **Marcar UC_ACC_01..04 como REPLACED_BY UC_PERM_***:
   - UC_ACC_01 Asignar Funciones → UC_PERM_01 Asignar Grupo
   - UC_ACC_02 Revocar Funciones → UC_PERM_02 Revocar Grupo
   - UC_ACC_03 Consultar Permisos → UC_PERM_07 Verificar Permiso
     (admin) + UC_PERM_10 Consultar Auditoria
   - UC_ACC_04 Asignar Agrupador → UC_PERM_06 Asignar Capacidades a
     Grupo (los "agrupadores fijos" se mapean a "grupos predefinidos")

4. **Crear ADR-GOB-008 (nuevo)** que declare la decision de evolucion.

### Catalogo resultante: 59 UCs en 9 modulos

| Modulo | UCs | Cantidad | Status |
|--------|-----|----------|--------|
| MOD_Auth | UC_AUTH_01..05 | 5 | PROVEN |
| MOD_Users | UC_USR_01..04 | 4 | PROVEN |
| MOD_Access | UC_ACC_05..08 (4 UCs reducidos) | 4 | PROVEN (5 UCs antiguos descartados o fusionados) |
| MOD_Permissions | UC_PERM_01..10 | 10 | INFERRED (75% backend impl, .md formal) |
| MOD_Reports | UC_RPT_01..14 | 14 | PROVEN |
| MOD_Alerts | UC_ALR_01..05 | 5 | PROVEN |
| MOD_Pipeline | UC_PIP_01..04 | 4 | PROVEN |
| MOD_Audit | UC_AUD_01..04 | 4 | PROVEN |
| MOD_Logs | UC_LOG_01..04 | 4 | PROVEN |
| **Total** | | **54** | (no 59 — recalculo) |

**Recalculo:** 5+4+4+10+14+5+4+4+4 = **54 UCs**

(Si se prefiere preservar UC_ACC_01..04 como vista funcional para
admin no-tech: 5+4+9+10+14+5+4+4+4 = **59 UCs**)

## Decisiones D-ARQ pendientes

### D-ARQ-1: Tratamiento de MOD_Permissions (3 opciones)

- **A)** **Coexistencia** — preserva ACC completo (9 UCs) + agrega PERM
  completo (10 UCs) = **63 UCs**. Total maximo, sin perdida.
- **B)** **Evolucion con SoD/Segmentos preservados** (recomendada) —
  ACC reducido a 4 UCs (SoD, Segmentos, Permiso Temporal,
  Asignar Segmento) + PERM completo = **54 UCs**.
- **C)** **Evolucion total** — ACC desaparece (todo absorbido en PERM)
  + PERM completo = **49 UCs**.

### D-ARQ-2: Tratamiento de MOD_Call (2 opciones)

- **A)** **Descartar** (recomendada) — UC-CALL-001..003 son del
  sistema IVR del cliente, fuera de IACT. UC-CALL-004 (reporte
  rendimiento) probablemente solapa con UC_RPT_*. Total IACT: 54-63 UCs.
- **B)** **Incluir como modulo de "modelado del IVR"** — agregar
  MOD_IVR (no MOD_Call) para documentar el contexto operacional del
  cliente. Total: 58-67 UCs.

### D-ARQ-3: Doble auditoria (3 opciones)

- **A)** **Fusionar UC_PERM_09/10 → MOD_Audit** — la auditoria
  unificada va en MOD_Audit (CNST_008 inmutable).
- **B)** **Mantener separada** — MOD_Permissions tiene su propia
  auditoria de permisos, MOD_Audit auditoria general.
- **C)** **Renombrar AuditoriaPermiso → "Audit Subdomain Permissions"**
  como vista filtrada del MOD_Audit principal.

### D-ARQ-4: Nomenclatura de UCs en MOD_Permissions

- **A)** UC_PERM_NN (2 digitos como ACC) — total 10 con padding 01..10.
- **B)** UC_PERM_NNN (3 digitos como en .md) — total 10 con padding 001..010.

## Pregunta clave al ejecutor

¿Cual de las tres hipotesis arquitectonicas (1 coexistencia / 2
evolucion limitada / 3 evolucion total) prefieres?

¿Y sobre MOD_Call, descartar o incluir como MOD_IVR (modelado
contextual)?

## Mi recomendacion (resumida)

- **D-ARQ-1: Hipotesis 2** (Evolucion con limites claros) — 54 UCs.
- **D-ARQ-2: Descartar MOD_Call** — los UC-CALL-001..003 son del IVR
  del cliente, no de IACT. UC-CALL-004 verificar solape con UC_RPT_*.
- **D-ARQ-3: Mantener separada** — MOD_Permissions tiene auditoria
  especifica de permisos (mas granular), MOD_Audit es general.
- **D-ARQ-4: UC_PERM_NN** (2 digitos, consistencia con ACC).
