# ANÁLISIS PROFUNDO: Taxonomías y Metamodelos IACT

## Documentos Analizados

| Documento | Ubicación | Propósito |
|-----------|-----------|-----------|
| MTM_01 | metamodelos/ | Metamodelo de Requisitos |
| MTM_02 | metamodelos/ | Metamodelo de Trazabilidad |
| MTM_03 | metamodelos/ | Metamodelo RBAC |
| TXM_01 | taxonomias/ | Taxonomía de Requisitos |
| TXM_02 | taxonomias/ | Taxonomía de Artefactos |
| TXM_03 | taxonomias/ | Taxonomía de Reglas de Negocio |

---

## 1. HALLAZGOS CRÍTICOS

### 1.1 Las BR ya están PARCIALMENTE identificadas

Según TXM_03, ya hay **~13 BR identificadas**:

| Tipo | Cantidad | Ejemplos Documentados |
|------|----------|----------------------|
| Hecho | 2 | BR_011 (RBAC Flat), BR_HEC_001 (Unicidad username) |
| Restricción | 3 | BR_001 (Inmutable), BR_015 (SoD), BR_RES_001 |
| Desencadenador | 2 | BR_002 (ETL), BR_TRG_001 (Alertas) |
| Inferencia | 1 | BR_003 (Inactivo 90 días) |
| Cálculo | ~5 | Métricas de dashboard |

### 1.2 La numeración de BR NO es consecutiva

Los documentos muestran diferentes convenciones:
- BR_001, BR_002, BR_003 (numérico simple)
- BR_011, BR_015 (saltos numéricos)
- BR_HEC_001, BR_RES_001, BR_TRG_001, BR_INF_001, BR_CAL_001 (prefijo por tipo)

**Problema detectado:** Inconsistencia en nomenclatura.

### 1.3 Conteos declarados vs realidad

| Fuente | BR declaradas | UC declarados | FR estimados |
|--------|---------------|---------------|--------------|
| MTM_01 | 6 | 38 | ~300 |
| MTM_02 | -- | -- | ~300 |
| TXM_01 | 6 | 38 | ~300 |
| TXM_03 | ~13 | -- | -- |

**Inconsistencia:** MTM_01 y TXM_01 dicen "6 BR" pero TXM_03 dice "~13 BR".

---

## 2. ESTRUCTURA METODOLÓGICA COMPLETA

### 2.1 La Cadena de Derivación (MTM_01 + MTM_02)

```
NIVEL 0                    NIVEL 1              NIVEL 2           NIVEL 3

+--------+                                    +---------+
|  BR    |-----(genera si Trigger)---------->|   UC    |
| Regla  |                                    |  Caso   |
+---+----+                                    +----+----+
    |                                              |
    |                                              | deriva
    | influye                                      |
    |                                              v
    |    +--------+      genera      +---------+  +---------+
    +--->| BReq   |----------------->|   UC    |->|   FR    |
         |Objetivo|                  |  Caso   |  | Func.   |
         +--------+                  +---------+  +---------+
```

### 2.2 Tipos de Enlaces de Trazabilidad (MTM_02)

| Tipo Link | Semántica | Ejemplo |
|-----------|-----------|---------|
| DERIVA | Origen produce destino por derivación | UC_010 --deriva--> FR-10.1 |
| INFLUYE | Origen afecta destino sin generarlo | BR_015 --influye--> UC_010 |
| IMPLEMENTA | Código realiza el requisito | FR-10.1 --implementa--> Code |
| VERIFICA | Test valida cumplimiento | TEST_010 --verifica--> FR-10.1 |
| SATISFACE | Cumple objetivo de negocio | UC_010 --satisface--> BReq_003 |

### 2.3 Matriz de Enlaces Válidos (MTM_02)

| Desde\\Hacia | BR | BReq | UC | FR | CODE | TEST |
|--------------|----|----- |----|----|----- |----- |
| **BR** | -- | influye | deriva | influye | -- | -- |
| **BReq** | -- | -- | genera | -- | -- | -- |
| **UC** | -- | satisface | refina | deriva | -- | -- |
| **FR** | -- | -- | -- | depende | implementa | -- |
| **TEST** | -- | -- | -- | verifica | -- | -- |

---

## 3. TIPOS DE BUSINESS RULES (TXM_03)

### 3.1 Los 5 Tipos y su Transformación

| Tipo | Modalidad | Genera UC? | Genera FR | Patrón |
|------|-----------|------------|-----------|--------|
| **Hecho** | Aléctica | NO | Validación integridad | "[X] ES/TIENE [Y]" |
| **Restricción** | Deóntica | Parcial (flujo alterno) | Validación acceso | "[X] DEBE/NO DEBE [Y]" |
| **Desencadenador** | Deóntica | **SÍ (completo)** | Múltiples por paso | "SI [cond] ENTONCES [acción visible]" |
| **Inferencia** | Aléctica | NO | Lógica interna | "SI [cond] ENTONCES [estado interno]" |
| **Cálculo** | Aléctica | NO (paso en UC) | Algoritmo específico | "[Resultado] = [fórmula]" |

### 3.2 Árbol de Decisión para Clasificar BR

```
¿La BR tiene formato SI...ENTONCES?
│
├─ NO → ¿Define una verdad estructural?
│       │
│       ├─ SÍ → HECHO
│       │
│       └─ NO → ¿Define una fórmula/algoritmo?
│               │
│               ├─ SÍ → CÁLCULO
│               │
│               └─ NO → ¿Limita lo que puede hacerse?
│                       │
│                       └─ SÍ → RESTRICCIÓN
│
└─ SÍ → ¿El ENTONCES es visible externamente?
        │
        ├─ SÍ → DESENCADENADOR (genera UC)
        │
        └─ NO → INFERENCIA (lógica interna)
```

---

## 4. MODELO RBAC COMPLETO (MTM_03)

### 4.1 Entidades del Modelo

```
Usuario ─────(N:1)─────► Segmento
    │
    │ (N:N)
    ▼
   Rol ◄────(1:N)──── Permiso
    │
    │ (N:N - SoD)
    ▼
RolConflicto
```

### 4.2 Catálogo de 18 Roles (CERRADO)

| Código | Nombre | Categoría |
|--------|--------|-----------|
| R001 | USERS_FULL_MANAGER | Gestión Usuarios |
| R002 | USERS_VIEWER | Gestión Usuarios |
| R003 | USERS_TEAM_MANAGER | Gestión Usuarios |
| R004 | REPORTS_VIEWER | Reportes |
| R005 | REPORTS_EXPORTER | Reportes |
| R006 | REPORTS_ADVANCED_VIEWER | Reportes |
| R007 | REPORTS_CREATOR | Reportes |
| R008 | DASHBOARD_VIEWER | Visualización |
| R009 | DASHBOARD_CUSTOMIZER | Visualización |
| R010 | DATA_ANALYST | Análisis |
| R011 | ALERTS_VIEWER | Alertas |
| R012 | ALERTS_CONFIGURATOR | Alertas |
| R013 | ALERTS_TEAM_MANAGER | Alertas |
| R014 | ALERTS_GLOBAL_ADMIN | Alertas |
| R015 | MODULES_ADMIN | Administración |
| R016 | SYSTEM_ADMIN | Administración |
| R017 | AUDIT_VIEWER | Administración |
| R018 | SECURITY_ADMIN | Administración |

### 4.3 Restricciones del Modelo

| # | Restricción | Implementación |
|---|-------------|----------------|
| R1 | Usuario tiene exactamente 1 segmento | FK NOT NULL |
| R2 | Usuario tiene al menos 1 rol | Trigger/App |
| R3 | Rol tiene al menos 1 permiso | CHECK |
| R4 | Sesión activa única por usuario | UNIQUE INDEX |
| R5 | Username y email únicos | UNIQUE constraints |
| R6 | SoD: roles conflictivos no coexisten | Trigger |

---

## 5. TAXONOMÍA DE ARTEFACTOS (TXM_02)

### 5.1 Mapa Completo de Prefijos

| Dominio | Prefijos | Cantidad Est. |
|---------|----------|---------------|
| base_cognitiva | META, GLOS, FND, SBVR, TXM, MTM, METH | ~25 |
| normativa | PROC, STD, GOB, CNST, RTM, COV | ~25 |
| requisitos | BR, UC, FR, NFR | ~350 |
| arquitectura | ADR, VIEW, MDL | ~10 |

### 5.2 Artefactos Cognitivos Identificados

| Prefijo | Artefactos |
|---------|------------|
| FND_ | FND_01 a FND_07 (7 documentos) |
| SBVR_ | SBVR_01 a SBVR_05 (5 documentos) |
| TXM_ | TXM_01 a TXM_03 (3 documentos) |
| MTM_ | MTM_01 a MTM_03 (3 documentos) |
| METH_ | METH_01 a METH_03 (3 documentos) |

---

## 6. MÉTRICAS DE COBERTURA (MTM_02)

### 6.1 Umbrales Mínimos Definidos

| Cobertura | Umbral IACT |
|-----------|-------------|
| BR → UC | 100% (toda BR debe tener impacto) |
| UC → FR | 100% (todo UC genera FR) |
| FR → CODE | 90% (MVP permite gaps) |
| FR → TEST | 80% (priorización por riesgo) |

### 6.2 Estado Actual Declarado

| Métrica | Valor | Umbral | Estado |
|---------|-------|--------|--------|
| BR identificadas | 6-13 | -- | ⚠️ Inconsistente |
| UC derivados | 38 | -- | ✓ |
| FR estimados | ~300 | -- | Pendiente |
| Cobertura BR→UC | 100% | 100% | ✓ |
| Cobertura UC→FR | **0%** | 100% | ❌ Pendiente |
| Cobertura FR→TEST | **0%** | 80% | ❌ Pendiente |

---

## 7. CASOS DE USO POR DOMINIO (TXM_01)

| Dominio | Cantidad | Rango UC |
|---------|----------|----------|
| Gestión de Usuarios | 8 | UC-005 a UC-011, UC-041, UC-042 |
| Reportes | 8 | UC-017 a UC-024 |
| Dashboards | 6 | UC-025 a UC-030 |
| Análisis | 5 | UC-031 a UC-035 |
| Alertas | 5 | UC-036 a UC-040 |
| Administración | 6 | UC-012 a UC-016, UC-043 |
| **TOTAL** | **38** | -- |

---

## 8. INCONSISTENCIAS DETECTADAS

### 8.1 Numeración de BR

| Documento | BR mencionadas |
|-----------|---------------|
| TXM_03 | BR_001, BR_002, BR_003, BR_011, BR_015 + prefijadas |
| MTM_01 | 6 BR (sin detallar) |
| Análisis Módulos | BR_001 a BR_010 (propuestas) |

**Problema:** No hay lista canónica de BR.

### 8.2 Numeración de UC

| Fuente | Rango UC |
|--------|----------|
| TXM_01 | UC-005 a UC-043 |
| Documento Módulos | UC-001 a UC-072 |

**Problema:** Dos sistemas de numeración diferentes.

### 8.3 Ubicación de CNST

| Documento | Ubicación CNST |
|-----------|---------------|
| TXM_02 | normativa/restricciones/ |
| Modelo v2.0.0 | arquitectura_tecnica/restricciones/ |
| Modelo v2.0.3 | arquitectura_tecnica/restricciones/ |

**Observación:** CNST está en arquitectura_tecnica, no en normativa.

---

## 9. HALLAZGO CLAVE: DIFERENCIA CNST vs BR

### 9.1 Según TXM_01 y TXM_02

| Artefacto | Prefijo | Ubicación | Propósito |
|-----------|---------|-----------|-----------|
| Restricción (CNST) | CNST_ | normativa/restricciones | Limitaciones impuestas |
| Regla de Negocio (BR) | BR_ | requisitos/reglas_negocio | Políticas del dominio |

### 9.2 Diferencia Conceptual

```
CNST (Constraint/Restricción):
- IMPUESTA desde fuera (cliente, tecnología, regulación)
- Define CÓMO se construye el sistema
- Ejemplos: "Sin email", "BD solo lectura", "Sesión única"

BR (Business Rule):
- DEFINE la lógica del negocio
- Define QUÉ debe cumplir el sistema
- Ejemplos: "SoD", "Permisos vencen en 6 meses", "RBAC Flat"
```

### 9.3 Algunos CNST SON BR

| CNST | ¿Es también BR? | Razón |
|------|-----------------|-------|
| CNST_001 (No email) | Sí → BR tipo Restricción | Es política de negocio |
| CNST_002 (Sesiones BD) | Parcial | Es técnico pero con impacto en BR_005 |
| CNST_003 (BD readonly) | Sí → BR tipo Restricción | Es restricción de negocio |
| CNST_005 (RBAC) | Sí → BR tipo Hecho | Define estructura del modelo |

---

## 10. QUÉ SIGUE SEGÚN LOS DOCUMENTOS

### 10.1 Según MTM_02 (Cobertura)

```
Estado actual:
- Cobertura UC→FR: 0%
- Cobertura FR→TEST: 0%

ACCIÓN REQUERIDA:
1. Derivar FR desde cada UC
2. Crear tests para cada FR
```

### 10.2 Según TXM_03 (Transformación BR)

```
Para cada BR identificada, generar:

HECHO → Constraints BD + Modelo datos
RESTRICCIÓN → Precondiciones UC + Validaciones FR
DESENCADENADOR → UC completo + FR derivados
INFERENCIA → FR lógica interna + Jobs batch
CÁLCULO → FR algoritmo específico
```

### 10.3 Según MTM_01 (Ratios)

```
Ratio típico: 1 UC : 8 FR

Con 38 UC identificados:
FR esperados = 38 × 8 = ~304 FR
```

---

## 11. CONCLUSIÓN: PLAN DE ACCIÓN REVISADO

### Antes (mi análisis previo)
```
1. Crear BR_ (10 documentos)
2. Crear UC_ completos
3. Derivar FR_
```

### Ahora (con taxonomías y metamodelos)

```
FASE 0: CONSOLIDAR BR EXISTENTES
─────────────────────────────────
- Unificar nomenclatura (BR_NNN sin prefijos de tipo)
- Crear lista canónica de las ~13 BR identificadas
- Clasificar cada una por tipo (Hecho/Restricción/Trigger/etc.)
- Documentar formalmente en requisitos/reglas_negocio/

FASE 1: COMPLETAR BR FALTANTES
──────────────────────────────
- Extraer BR implícitas de CNST
- Extraer BR implícitas del modelo RBAC
- Objetivo: ~15-20 BR totales

FASE 2: CREAR UC FORMALES
─────────────────────────
- Ya hay 38 UC identificados
- Crear documentos con estructura completa:
  - Actor + Objetivo + Precondiciones
  - Flujo normal + Flujos alternos + Excepciones
  - BR aplicables + FR derivados

FASE 3: DERIVAR FR
──────────────────
- Ratio 1:8 → ~300 FR esperados
- Organizar por UC de origen
- Formato: FR-[UC].[SEQ]

FASE 4: RTM (Matriz de Trazabilidad)
────────────────────────────────────
- Crear RTM_IACT_v1_0_0.rst
- Cumplir umbrales:
  - BR→UC: 100%
  - UC→FR: 100%
  - FR→CODE: 90%
  - FR→TEST: 80%
```

---

## 12. ARTEFACTOS A CREAR (PRIORIZADO)

### Inmediato (Fase 0)

| Artefacto | Contenido |
|-----------|-----------|
| BR_001.rst | Fuente Operacional Inmutable (Restricción) |
| BR_002.rst | Sincronización ETL Batch (Desencadenador) |
| BR_003.rst | Usuario Inactivo 90 días (Inferencia) |
| BR_004.rst | Comunicaciones Solo Internas (Restricción) |
| BR_005.rst | Sesión Única por Usuario (Restricción) |
| BR_006.rst | Modelo RBAC Flat NIST (Hecho) |
| BR_007.rst | Separación de Funciones SoD (Restricción) |
| BR_008.rst | Permisos con Vencimiento (Restricción) |
| BR_009.rst | Bajas Siempre Lógicas (Restricción) |
| BR_010.rst | Auditoría Inmutable (Restricción) |
| index.rst | Índice de reglas_negocio/ |

### Siguiente (Fase 1-2)

| Artefacto | Contenido |
|-----------|-----------|
| UC_001.rst a UC_005.rst | UC del módulo Auth |
| UC_006.rst a UC_009.rst | UC del módulo Users |
| ... | Resto de UC por módulo |

---

## 13. MAPEO FINAL: CNST → BR

| CNST | Tipo BR | BR Propuesta |
|------|---------|--------------|
| CNST_001 | Restricción | BR_004 Comunicaciones Internas |
| CNST_002 | Restricción | BR_005 Sesión Única |
| CNST_003 | Restricción | BR_001 Fuente Inmutable |
| CNST_004 | Desencadenador | BR_002 ETL Batch |
| CNST_005 | Hecho + Restricción | BR_006 RBAC Flat, BR_007 SoD |
| CNST_007 | Restricción | BR_011 Límites Exportación |
| CNST_009 | Restricción | BR_010 Auditoría Inmutable |

---

## 14. RESUMEN EJECUTIVO

### Lo que YA tenemos

1. **10 CNST completos** ✅
2. **7 FND completos** ✅ (fundamentos metodológicos)
3. **3 TXM completos** ✅ (taxonomías)
4. **3 MTM completos** ✅ (metamodelos)
5. **8 MOD definidos** ✅ (módulos del sistema)
6. **38 UC identificados** (no documentados formalmente)
7. **~13 BR identificadas** (no documentadas formalmente)

### Lo que FALTA

1. **BR formales** → ~15-20 documentos en requisitos/reglas_negocio/
2. **UC formales** → 38+ documentos en requisitos/casos_uso/
3. **FR derivados** → ~300 documentos en requisitos/funcionales/
4. **RTM** → Matriz de trazabilidad
5. **Tests** → Casos de prueba por FR

### Orden de Ejecución

```
1. BR_ (formalizar las ~13-20 identificadas)
2. UC_ (documentar los 38 identificados)
3. FR_ (derivar de cada UC)
4. RTM (crear matriz)
5. TST_ (crear tests)
```

---

*Análisis generado: 2026-01-03*
*Documentos analizados: MTM_01, MTM_02, MTM_03, TXM_01, TXM_02, TXM_03*
*Propósito: Determinar siguiente paso según metodología establecida*
