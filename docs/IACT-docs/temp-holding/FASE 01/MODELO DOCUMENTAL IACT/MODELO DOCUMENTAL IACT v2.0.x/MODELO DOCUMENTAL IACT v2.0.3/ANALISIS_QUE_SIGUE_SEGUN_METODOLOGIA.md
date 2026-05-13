# ANÁLISIS: ¿QUÉ SIGUE SEGÚN LA METODOLOGÍA?

## Basado en `_metadata/` y documentos FND_

---

## 1. LA METODOLOGÍA ESTABLECE

### Jerarquía de 4 Niveles (FND_05)

```
NIVEL 0 (BR)    →   NIVEL 1 (BReq)   →   NIVEL 2 (UC)    →   NIVEL 3 (FR)

Más abstracto ────────────────────────────────────────────► Más concreto
Más estable ──────────────────────────────────────────────► Más cambiante
Mayor alcance ────────────────────────────────────────────► Menor alcance
```

| Nivel | Artefacto | Pregunta | ¿Qué define? |
|-------|-----------|----------|--------------|
| 0 | BR | ¿Por qué restricción? | Políticas, regulaciones |
| 1 | BReq | ¿Por qué proyecto? | Objetivos, alcance |
| 2 | UC | ¿Qué hace usuario? | Comportamientos observables |
| 3 | FR | ¿Cómo sistema? | Especificaciones atómicas |

### Dirección de Derivación (FND_06)

**IACT es proyecto Greenfield**, por tanto:

```
BR → UC → FR → Diseño → Código

NUNCA AL REVÉS
```

**Derivar** = hacer explícito lo implícito (NO transformar)

---

## 2. ESTADO ACTUAL DEL PROYECTO

### ✅ COMPLETADO

| Nivel | Artefacto | Estado |
|-------|-----------|--------|
| N/A | CNST (Restricciones) | ✅ 10 documentos completos |
| N/A | FND (Fundamentos) | ✅ 7 documentos completos |
| N/A | MOD (Módulos) | ✅ Definidos (8 módulos) - Documento de referencia |

### ❌ PENDIENTE

| Nivel | Artefacto | Estado |
|-------|-----------|--------|
| 0 | BR (Reglas de Negocio) | ❌ NO creados formalmente |
| 1 | BReq (Business Requirements) | ❌ NO creados |
| 2 | UC (Casos de Uso) | ❌ NO creados formalmente |
| 3 | FR (Functional Requirements) | ❌ NO derivados |

---

## 3. ¿QUÉ SIGUE SEGÚN LA METODOLOGÍA?

### Secuencia Correcta (Greenfield)

```
Paso 1: Identificar Business Rules (BR)
        ↓
Paso 2: Generar Casos de Uso (UC) desde BR + CRUD + Eventos
        ↓
Paso 3: Derivar Functional Requirements (FR) desde UC
        ↓
Paso 4: Diseñar Arquitectura (ya tenemos MOD_ como guía)
        ↓
Paso 5: Implementar Código
```

### El Problema Actual

Tenemos:
- **CNST** (restricciones técnicas del cliente) ✅
- **MOD** (diseño arquitectónico) ✅

Pero NO tenemos:
- **BR** (reglas de negocio formalizadas)
- **UC** (casos de uso con flujos completos)
- **FR** (requisitos funcionales atómicos)

### Observación Clave

Los **CNST** NO son BR. Son diferentes:

| CNST (Restricciones) | BR (Reglas de Negocio) |
|----------------------|------------------------|
| Imposiciones técnicas/contractuales | Políticas del dominio |
| "No usar email" | "Permisos expiran en 6 meses" |
| Restricción de implementación | Lógica de negocio |
| HOW (cómo se construye) | WHAT (qué debe cumplir) |

---

## 4. SIGUIENTE PASO: CREAR BR

### ¿De dónde extraer las BR?

1. **De los CNST** → Algunas restricciones implican BR
2. **De los documentos de análisis de módulos** → Contienen reglas implícitas
3. **Del modelo RBAC** → Define políticas de acceso

### BR a Crear (Propuesta)

Basado en el análisis de los 19 documentos y las restricciones:

| BR | Nombre | Origen |
|----|--------|--------|
| BR_001 | Inmutabilidad Fuente Operacional | CNST_003 |
| BR_002 | Sincronización ETL Batch | CNST_004 |
| BR_003 | Modelo RBAC Flat NIST | CNST_005 |
| BR_004 | Comunicaciones Solo Internas | CNST_001 |
| BR_005 | Sesión Única por Usuario | CNST_002 |
| BR_006 | Separación de Funciones (SoD) | Modelo RBAC |
| BR_007 | Permisos Directos con Vencimiento | Modelo RBAC |
| BR_008 | Bajas Lógicas (Nunca Físicas) | CNST_005 |
| BR_009 | Auditoría Inmutable | CNST_009 |
| BR_010 | Límites de Exportación por Rol | CNST_007 |

---

## 5. FLUJO COMPLETO PROPUESTO

```
┌─────────────────────────────────────────────────────────────────┐
│                    FASE 1: REGLAS DE NEGOCIO                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   CNST (ya hechos) ──────► BR (por crear)                       │
│                                                                  │
│   Crear ~10 BR formales derivados de CNST + Modelo RBAC         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    FASE 2: CASOS DE USO                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   Crear UC completos con:                                        │
│   - Flujo normal                                                 │
│   - Flujos alternos                                              │
│   - Excepciones                                                  │
│   - Precondiciones/Postcondiciones                              │
│   - Referencia a BR aplicables                                   │
│                                                                  │
│   Organizados por módulo:                                        │
│   - auth/: UC-001 a UC-005                                       │
│   - users/: UC-006 a UC-009                                      │
│   - access/: UC-010, UC-041-047                                  │
│   - pipeline/: UC-050 a UC-053                                   │
│   - reports/: UC-017 a UC-029                                    │
│   - alerts/: UC-036 a UC-040                                     │
│   - audit/: UC-060 a UC-063                                      │
│   - logs/: UC-070 a UC-072                                       │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    FASE 3: REQUISITOS FUNCIONALES               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   Derivar FR desde cada paso de UC donde "Sistema" actúa:       │
│                                                                  │
│   UC-001 Paso 3: "Sistema valida credenciales"                  │
│       ↓                                                          │
│   FR-001.3.1: Sistema DEBE verificar email en tabla users       │
│   FR-001.3.2: Sistema DEBE comparar hash de contraseña          │
│   FR-001.3.3: Sistema DEBE verificar estado ACTIVO              │
│                                                                  │
│   Cantidad estimada: ~200-400 FR                                 │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    FASE 4: DISEÑO DETALLADO                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   Ya tenemos:                                                    │
│   - MOD_ (8 módulos definidos)                                   │
│   - CNST (restricciones de implementación)                       │
│                                                                  │
│   Falta crear:                                                   │
│   - API_ por módulo (endpoints concretos)                        │
│   - DSC_MOD_ (modelos de datos)                                  │
│   - FD_ (flujos de datos técnicos)                               │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 6. RECOMENDACIÓN

### Opción A: Seguir la Metodología Estrictamente

```
1. Crear BR_ (10 documentos) ← SIGUIENTE
2. Crear UC_ completos (~49 documentos)
3. Derivar FR_ (~200-400 documentos)
4. Crear API_, DSC_MOD_, FD_
```

**Ventaja:** Trazabilidad perfecta BR→UC→FR
**Desventaja:** Mucho trabajo antes de ver código

### Opción B: Enfoque Pragmático (Iterativo)

```
1. Crear BR_ fundamentales (5-10) ← SIGUIENTE
2. Crear UC_ del módulo más crítico (Auth o Access)
3. Derivar FR_ de ese módulo
4. Crear MOD_Auth.rst o MOD_Access.rst formal
5. Repetir para siguiente módulo
```

**Ventaja:** Valor incremental, se puede validar temprano
**Desventaja:** Trazabilidad parcial inicialmente

---

## 7. CONCLUSIÓN

### ¿Qué sigue según `_metadata/`?

**CREAR LAS BUSINESS RULES (BR)**

Porque:
1. La metodología dice: BR → UC → FR (en ese orden)
2. No se pueden crear UC sin saber qué BR aplican
3. No se pueden derivar FR sin UC con flujos completos
4. Los CNST ya existen pero NO son BR

### Entregable Siguiente

```
requisitos/
└── reglas_negocio/
    ├── index.rst
    ├── BR_001_Inmutabilidad_Fuente.rst
    ├── BR_002_ETL_Batch.rst
    ├── BR_003_RBAC_Flat.rst
    ├── BR_004_Comunicaciones_Internas.rst
    ├── BR_005_Sesion_Unica.rst
    ├── BR_006_Separacion_Funciones.rst
    ├── BR_007_Permisos_Vencimiento.rst
    ├── BR_008_Bajas_Logicas.rst
    ├── BR_009_Auditoria_Inmutable.rst
    └── BR_010_Limites_Exportacion.rst
```

---

*Análisis basado en FND_05 (Jerarquía 4 Niveles) y FND_06 (Derivación vs Transformación)*
