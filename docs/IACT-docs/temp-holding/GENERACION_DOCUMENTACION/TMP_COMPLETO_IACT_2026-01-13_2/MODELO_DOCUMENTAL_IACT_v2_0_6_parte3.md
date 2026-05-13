---

## 4. JERARQUÍA DE DERIVACIÓN (4 Niveles Completos)

### 4.1 Diagrama de Jerarquía (FND_05 + MTM_01)

```
NIVEL 0              NIVEL 1              NIVEL 2           NIVEL 3
┌─────────┐         ┌─────────┐          ┌─────────┐       ┌─────────┐
│   BR    │─influye─►│  BReq   │──genera──►│   UC    │──────►│   FR    │
│ Regla   │         │Objetivo │          │  Caso   │deriva │ Funcional│
│ Negocio │         │ Negocio │          │   Uso   │       │          │
└────┬────┘         └─────────┘          └────┬────┘       └────┬────┘
     │                                        │                 │
     │                                        │                 │
     │ genera (si Trigger)                    │ satisface       │ implementa
     │                                        ▼                 ▼
     │                                   ┌─────────┐       ┌─────────┐
     └───────────────────────────────────►│   UC    │       │  CODE   │
                                         └─────────┘       └────┬────┘
                                                                │
                                                                │ verifica
                                                                ▼
                                                           ┌─────────┐
                                                           │  TEST   │
                                                           └─────────┘
```

### 4.2 Tipos de Enlaces (MTM_02)

| Enlace | Origen | Destino | Semántica | Cardinalidad |
|--------|--------|---------|-----------|--------------|
| influye | BR | BReq | BR afecta objetivo sin generar | 0..* : 0..* |
| genera | BReq | UC | Objetivo genera casos de uso | 1 : 1..* |
| genera | BR (Trigger) | UC | BR Desencadenador genera UC | 0..1 : 0..1 |
| deriva | UC | FR | Cada paso "Sistema" genera FR | 1 : 1..* |
| implementa | FR | CODE | FR se codifica | 1 : 0..* |
| verifica | TEST | FR | Test valida FR | 1..* : 1 |

### 4.3 Preguntas por Nivel (FND_05)

| Nivel | Tipo | Pregunta Clave | Responsable |
|-------|------|----------------|-------------|
| 0 | BR | ¿Por qué esta restricción? | Stakeholders, Legal |
| 1 | BReq | ¿Por qué este proyecto? | Product Owner |
| 2 | UC | ¿Qué hace el usuario? | Business Analyst |
| 3 | FR | ¿Cómo lo hace el sistema? | BA + Arquitecto |

### 4.4 Ratio de Derivación Esperado

```
Típico según FND_05:
  5-20 BR → 3-10 BReq → 30-100 UC → 200-1000 FR

IACT v2.0.6:
  20 BR → 5 BReq → 49 UC → ~400 FR (estimado)
  
Ratios:
  BR : BReq = 4:1 (20/5)
  BReq : UC = 1:10 (5/49)
  UC : FR = 1:8 (49/~400)
```

---

## 5. TIPOS DE BUSINESS RULES (TXM_03)

### 5.1 Los 5 Tipos

| Tipo | Modalidad | ¿Genera UC? | Patrón | Cantidad |
|------|-----------|-------------|--------|----------|
| **Hecho** | Aléctica | NO | "[X] ES/TIENE [Y]" | 4 |
| **Restricción** | Deóntica | Parcial | "[X] DEBE/NO DEBE [Y]" | 9 |
| **Desencadenador** | Deóntica | **SÍ** | "SI [cond] ENTONCES [acción visible]" | 3 |
| **Inferencia** | Aléctica | NO | "SI [cond] ENTONCES [estado interno]" | 1 |
| **Cálculo** | Aléctica | NO | "[Resultado] = [fórmula]" | 3 |
| **TOTAL** | | | | **20** |

### 5.2 Template BR (Referencias: FND_02, TPL_001)

**Campos Obligatorios:**

| Campo | Descripción |
|-------|-------------|
| ID | BR_NNN formato |
| Nombre | Título descriptivo |
| Definición | Texto completo en lenguaje natural |
| Tipo | Fact, Constraint, Trigger, Inference, Calculation |
| Modalidad | Aléctica o Deóntica |
| Fuente | Documento origen (CNST, política, etc.) |
| Fecha Vigencia | YYYY-MM-DD |

**Campos Adicionales:**

| Campo | Descripción |
|-------|-------------|
| Prioridad | Alta / Media / Baja |
| Estática/Dinámica | Ley (estática) vs Política (dinámica) |
| Justificación | Razón de negocio |
| Ejemplo | Caso concreto de aplicación |

### 5.3 Catálogo Completo de BR v2.0.6

| BR | Nombre | Tipo | CNST | Funciones RBAC |
|----|--------|------|------|----------------|
| BR_001 | Fuente Inmutable | Restricción | CNST_003 | PIP-001, RPT-001 |
| BR_002 | ETL Batch Nocturno | Desencadenador | CNST_004 | PIP-001 a PIP-004 |
| BR_003 | Usuario Inactivo 90d | Inferencia | -- | USR-009 |
| BR_004 | Comunicaciones Internas | Restricción | CNST_001 | AUT-003, ALR-002 |
| BR_005 | Sesión Única | Restricción | CNST_002 | AUT-001, AUT-002, AUT-004 |
| BR_006 | RBAC Flat NIST | Hecho | CNST_005 | ACC-001 a ACC-006 |
| BR_007 | Separación Funciones SoD | Restricción | CNST_005 | ACC-005 |
| BR_008 | Permisos con Vencimiento | Restricción | CNST_005 | ACC-001 |
| BR_009 | Bajas Lógicas | Restricción | CNST_005 | USR-004 |
| BR_010 | Auditoría Inmutable | Restricción | CNST_009 | AUD-001 a AUD-004 |
| BR_011 | Límites Exportación | Restricción | CNST_007 | RPT-004, RPT-005, RPT-006 |
| BR_012 | Usuario-Segmento Único | Hecho | -- | USR-010, ACC-006 |
| BR_013 | Username Único | Hecho | -- | USR-001 |
| BR_014 | Alerta por Umbral | Desencadenador | -- | ALR-002 |
| BR_015 | Bloqueo Intentos Fallidos | Desencadenador | CNST_005 | AUT-001 |
| BR_016 | Tasa Abandono | Cálculo | -- | RPT-007 |
| BR_017 | Tiempo Promedio Espera | Cálculo | -- | RPT-007 |
| BR_018 | Índice Eficiencia | Cálculo | -- | RPT-007 |
| BR_019 | Clasificación Datos | Hecho | CNST_010 | ACC-006 |
| BR_020 | Rango Temporal Reportes | Restricción | CNST_007 | RPT-001, RPT-003 |

### 5.4 Detalle de BR Clave

#### BR_006: RBAC Flat NIST

**Declaración:** El sistema IACT implementa un modelo RBAC Flat basado en NIST.

| Componente | Cantidad | Descripción |
|------------|----------|-------------|
| Funciones Atómicas | 44 | Distribuidas en 8 módulos |
| Agrupadores | 10 | AGR-001 a AGR-010 |
| Segmentos | 5 | OP, FI, TE, SU, CA |
| Restricciones SoD | 3 | SOD-001, SOD-002, SOD-003 |

**Filosofía "Sin Pretensiones":**
- ✅ `crea_usuarios`, `ve_reportes`, `exporta_csv`
- ❌ `USERS_FULL_MANAGER`, `SYSTEM_ADMIN`

#### BR_007: Separación Funciones SoD

**Restricciones SoD Obligatorias:**

| ID | Grupo A | Grupo B | Razón |
|----|---------|---------|-------|
| SOD-001 | PIP-001 a PIP-004 | AUD-001 a AUD-004 | Quien opera NO audita |
| SOD-002 | USR-001, USR-003, USR-004, USR-007 | AUD-001 a AUD-003 | Quien gestiona usuarios NO audita |
| SOD-003 | ACC-001, ACC-002, ACC-005 | AUD-001, AUD-002 | Quien gestiona acceso NO audita |

### 5.5 Árbol de Decisión para Clasificar BR

```
¿La BR tiene formato SI...ENTONCES?
│
├─ NO → ¿Define una verdad estructural?
│       ├─ SÍ → HECHO
│       └─ NO → ¿Define una fórmula?
│               ├─ SÍ → CÁLCULO
│               └─ NO → RESTRICCIÓN
│
└─ SÍ → ¿El ENTONCES es visible externamente?
        ├─ SÍ → DESENCADENADOR (genera UC)
        └─ NO → INFERENCIA
```
