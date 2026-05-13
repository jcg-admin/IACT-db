---

## 4. TIPOS DE BUSINESS RULES (TXM_03)

### 4.1 Los 5 Tipos

| Tipo | Modalidad | ¿Genera UC? | Patrón | Cantidad v2.0.4 |
|------|-----------|-------------|--------|-----------------|
| **Hecho** | Aléctica | NO | "[X] ES/TIENE [Y]" | 4 |
| **Restricción** | Deóntica | Parcial | "[X] DEBE/NO DEBE [Y]" | 9 |
| **Desencadenador** | Deóntica | **SÍ** | "SI [cond] ENTONCES [acción visible]" | 3 |
| **Inferencia** | Aléctica | NO | "SI [cond] ENTONCES [estado interno]" | 1 |
| **Cálculo** | Aléctica | NO | "[Resultado] = [fórmula]" | 3 |
| **TOTAL** | | | | **20** |

### 4.2 Catálogo Completo de BR v2.0.4

| BR | Nombre | Tipo | CNST | Funciones RBAC | Estado |
|----|--------|------|------|----------------|--------|
| BR_001 | Fuente Inmutable | Restricción | CNST_003 | PIP-001, RPT-001 | ✅ |
| BR_002 | ETL Batch Nocturno | Desencadenador | CNST_004 | PIP-001 a PIP-004 | ✅ |
| BR_003 | Usuario Inactivo 90d | Inferencia | -- | USR-009 | ✅ |
| BR_004 | Comunicaciones Internas | Restricción | CNST_001 | AUT-003, ALR-002 | ✅ |
| BR_005 | Sesión Única | Restricción | CNST_002 | AUT-001, AUT-002, AUT-004 | ✅ |
| BR_006 | RBAC Flat NIST | Hecho | CNST_005 | ACC-001 a ACC-006 | ⚠️ **ACTUALIZADA** |
| BR_007 | Separación Funciones SoD | Restricción | CNST_005 | ACC-005 | ⚠️ **ACTUALIZADA** |
| BR_008 | Permisos con Vencimiento | Restricción | CNST_005 | ACC-001 | ✅ |
| BR_009 | Bajas Lógicas | Restricción | CNST_005 | USR-004 | ✅ |
| BR_010 | Auditoría Inmutable | Restricción | CNST_009 | AUD-001 a AUD-004 | ✅ |
| BR_011 | Límites Exportación | Restricción | CNST_007 | RPT-004, RPT-005, RPT-006 | ✅ |
| BR_012 | Usuario-Segmento Único | Hecho | -- | USR-010, ACC-006 | ✅ |
| BR_013 | Username Único | Hecho | -- | USR-001 | ✅ |
| BR_014 | Alerta por Umbral | Desencadenador | -- | ALR-002 | ✅ |
| BR_015 | Bloqueo Intentos Fallidos | Desencadenador | CNST_005 | AUT-001 | ✅ |
| BR_016 | Tasa Abandono | Cálculo | -- | RPT-007 | ✅ |
| BR_017 | Tiempo Promedio Espera | Cálculo | -- | RPT-007 | ✅ |
| BR_018 | Índice Eficiencia | Cálculo | -- | RPT-007 | ✅ |
| **BR_019** | **Clasificación Datos** | **Hecho** | **CNST_010** | ACC-006 | 🆕 **NUEVA** |
| **BR_020** | **Rango Temporal Reportes** | **Restricción** | **CNST_007** | RPT-001, RPT-003 | 🆕 **NUEVA** |

### 4.3 Detalle de BR Actualizadas (v2.0.4)

#### BR_006: RBAC Flat NIST (ACTUALIZADA)

**Declaración:**
El sistema IACT implementa un modelo RBAC Flat con las siguientes características:

| Componente | Cantidad | Descripción |
|------------|----------|-------------|
| Funciones Atómicas | 44 | Distribuidas en 8 módulos IACT |
| Agrupadores | 10 | AGR-001 a AGR-010 |
| Segmentos | 5 | OP, FI, TE, SU, CA |
| Restricciones SoD | 3 | SOD-001, SOD-002, SOD-003 |

**Filosofía "Sin Pretensiones":**
Los nombres de funciones describen QUÉ HACE, NO QUIÉN ES:
- ✅ `crea_usuarios`, `ve_reportes`, `exporta_csv`
- ❌ `USERS_FULL_MANAGER`, `SYSTEM_ADMIN`

**Precedencia de Permisos:**
```
Permiso Directo > Función Asignada > Segmento
```

**Funciones por Módulo:**

| Módulo | Código | Cantidad |
|--------|--------|----------|
| MOD_Auth | AUT | 4 |
| MOD_Users | USR | 10 |
| MOD_Access | ACC | 6 |
| MOD_Pipeline | PIP | 4 |
| MOD_Reports | RPT | 8 |
| MOD_Alerts | ALR | 6 |
| MOD_Audit | AUD | 4 |
| MOD_Logs | LOG | 2 |

---

#### BR_007: Separación Funciones SoD (ACTUALIZADA)

**Declaración:**
Un usuario NO DEBE tener asignadas simultáneamente funciones que pertenezcan a grupos en conflicto según las restricciones SoD.

**Restricciones SoD Obligatorias:**

| ID | Nombre | Grupo A | Grupo B | Razón |
|----|--------|---------|---------|-------|
| SOD-001 | sod_admin_auditoria | PIP-001, PIP-002, PIP-003, PIP-004 | AUD-001, AUD-002, AUD-003, AUD-004 | Quien opera pipeline NO audita |
| SOD-002 | sod_usuarios_auditoria | USR-001, USR-003, USR-004, USR-007 | AUD-001, AUD-002, AUD-003 | Quien gestiona usuarios NO audita |
| SOD-003 | sod_acceso_auditoria | ACC-001, ACC-002, ACC-005 | AUD-001, AUD-002 | Quien gestiona acceso NO audita |

**Enforcement:**
- Validación en tiempo de asignación (ACC-001)
- Validación en tiempo de ejecución (SEC_RULES)
- No aplican excepciones

---

#### BR_019: Clasificación de Datos (NUEVA)

**Declaración:**
Los datos del sistema IACT están clasificados en 4 niveles según su sensibilidad.

**Niveles:**

| Nivel | Nombre | Acceso |
|-------|--------|--------|
| C1 | PÚBLICO | Cualquier usuario autenticado |
| C2 | INTERNO | Usuarios con función específica |
| C3 | CONFIDENCIAL | Solo roles supervisión |
| C4 | RESTRINGIDO | Solo auditoría y compliance |

**Segmentos de Datos IACT:**
- **OP:** Datos operativos (llamadas, tiempos)
- **FI:** Datos financieros (costos por llamada)
- **TE:** Datos técnicos (errores, logs)
- **SU:** Datos de supervisión (rendimiento agentes)
- **CA:** Datos de calidad (encuestas, NPS)

**Tratamiento:**
- C3 y C4 requieren enmascaramiento en exportaciones
- PII nunca se exporta en texto plano
- Acceso a C4 genera registro de auditoría nivel CRITICAL

---

#### BR_020: Rango Temporal Reportes (NUEVA)

**Declaración:**
Los reportes y consultas del sistema NO DEBEN solicitar un rango de fechas mayor a 730 días (2 años).

**Parámetros:**
- Rango máximo: 730 días
- Validación: API (serializer) + ORM (queryset)
- Mensaje error: "El rango de fechas no puede exceder 2 años"

**Funciones Afectadas:**
- RPT-001 (ve_reportes)
- RPT-003 (filtra_reportes)
- RPT-004, RPT-005, RPT-006 (exportaciones)

---

### 4.4 Árbol de Decisión para Clasificar BR

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
