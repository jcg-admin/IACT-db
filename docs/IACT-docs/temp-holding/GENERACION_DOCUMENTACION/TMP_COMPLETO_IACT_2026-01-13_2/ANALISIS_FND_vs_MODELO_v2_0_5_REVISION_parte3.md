---

## 7. MATRIZ DE HALLAZGOS CONSOLIDADA (REVISADA)

| ID | Severidad | Ubicación | Descripción | Acción |
|----|-----------|-----------|-------------|--------|
| H-001 | 🔴 CRÍTICA | FND_04 | Archivo corrupto (copia de FND_03) | RECREAR documento |
| H-002 | 🔴 ALTA | MODELO/requisitos/ | Falta carpeta objetivos/ para BReq | CREAR estructura |
| H-003 | 🔴 ALTA | MODELO §1.3 | META_04 NO ES BReq (error conceptual) | CORREGIR texto |
| H-004 | 🟡 MEDIA | FND_03 | Lista UC desactualizada (38 vs 49) | ACTUALIZAR FND_03 |
| H-005 | 🟡 MEDIA | FND_03 | Faltan módulos pipeline/audit/logs | ACTUALIZAR FND_03 |
| H-006 | 🟡 MEDIA | FND_03 | Actores R00x vs Agrupadores AGR-00x | CREAR mapeo |
| H-007 | 🟢 BAJA | MODELO §4.2 | Template BR referencia incompleta | COMPLETAR |
| H-008 | 🟢 BAJA | MODELO §6 | SMART no referenciado explícitamente | AGREGAR ref |

---

## 8. PLAN DE ACCIÓN REVISADO

### 8.1 Fase 0: Corrección Crítica (Antes de todo)

| Acción | Documento | Esfuerzo |
|--------|-----------|----------|
| Recrear FND_04_Trazabilidad.rst | FND_04 | 2h |

### 8.2 Fase 1: Actualización MODELO a v2.0.6

| Cambio | Sección | Descripción |
|--------|---------|-------------|
| AGREGAR | requisitos/objetivos/ | Nueva carpeta con BReq_001 |
| CORREGIR | §1.3 | Eliminar "BReq implícito en META_04" |
| AGREGAR | §2 árbol | Incluir requisitos/objetivos/ |
| ACTUALIZAR | §3.1 diagrama | Mostrar 4 niveles completos |
| AGREGAR | §3.x | Nueva sección explicando BReq |

### 8.3 Fase 2: Actualización FND_03 a v1.2.0

| Cambio | Sección | Descripción |
|--------|---------|-------------|
| ACTUALIZAR | §8 | Lista de 49 UC (no 38) |
| AGREGAR | §3.4 | Módulos pipeline, audit, logs |
| AGREGAR | §3.4 | Mapeo Actores → Agrupadores |

### 8.4 Orden de Ejecución

```
1. [DÍA 1] Recrear FND_04_Trazabilidad.rst
2. [DÍA 1] Crear MODELO_DOCUMENTAL_IACT_v2.0.6
3. [DÍA 2] Actualizar FND_03 a v1.2.0
4. [DÍA 2] Validar consistencia cruzada
```

---

## 9. PROPUESTA: MODELO_DOCUMENTAL_IACT v2.0.6

### 9.1 Cambios Estructurales

**ANTES (v2.0.5):**
```
requisitos/
├── reglas_negocio/      # Nivel 0
├── casos_uso/           # Nivel 2
├── funcionales/         # Nivel 3
└── no_funcionales/
```

**DESPUÉS (v2.0.6):**
```
requisitos/
├── objetivos/           # Nivel 1 - NUEVO
│   ├── index.rst
│   └── BReq_001_Objetivos_IACT.rst
├── reglas_negocio/      # Nivel 0
├── casos_uso/           # Nivel 2
├── funcionales/         # Nivel 3
└── no_funcionales/
```

### 9.2 Cambios en Sección 1.3

**ANTES:**
```
> NOTA IMPORTANTE (v2.0.5):
> Para IACT, implementamos 3 niveles operativos: BR → UC → FR
> El Nivel 1 (BReq) está implícito en META_04_Contexto_IACT.rst.
```

**DESPUÉS:**
```
> NOTA (v2.0.6):
> IACT implementa los 4 niveles definidos en FND_05:
> - Nivel 0: BR (Business Rules) → requisitos/reglas_negocio/
> - Nivel 1: BReq (Business Requirements) → requisitos/objetivos/
> - Nivel 2: UC (Use Cases) → requisitos/casos_uso/
> - Nivel 3: FR (Functional Requirements) → requisitos/funcionales/
>
> Ver FND_05_Jerarquia_4_Niveles.rst para teoría completa.
```

### 9.3 Nueva Sección: Business Requirements

```markdown
## X. BUSINESS REQUIREMENTS (Nivel 1)

### X.1 Definición (FND_05)

Los Business Requirements expresan los objetivos de alto nivel que
justifican la existencia del proyecto IACT.

### X.2 BReq Identificados

| ID | Nombre | Descripción | UC Relacionados |
|----|--------|-------------|-----------------|
| BReq-001 | Visibilidad Métricas | Proporcionar visibilidad en tiempo real de métricas IVR | UC-025, UC-027, UC-028 |
| BReq-002 | Reducción Incidentes | Reducir tiempo resolución incidentes en 40% | UC-036 a UC-040 |
| BReq-003 | Decisiones Informadas | Permitir identificar problemas y tomar decisiones | UC-017 a UC-024 |
| BReq-004 | Cumplimiento Seguridad | Garantizar RBAC y auditoría según CNST_005 | UC-010, UC-060-063 |

### X.3 Ubicación

```
requisitos/objetivos/
├── index.rst
└── BReq_001_Objetivos_IACT.rst
```

### X.4 Relación con BR

Las BR influyen en los BReq pero no los generan directamente:

```
BR_001 (Fuente Inmutable) ──influye──> BReq-001 (Visibilidad)
BR_002 (ETL Nocturno) ──influye──> BReq-001 (Visibilidad)
CNST_005 (Seguridad) ──influye──> BReq-004 (Cumplimiento)
```
```

---

## 10. CHANGELOG PROPUESTO v2.0.5 → v2.0.6

```markdown
| Versión | Cambio |
|---------|--------|
| **v2.0.6** | **CORREGIDO: Agregada carpeta requisitos/objetivos/ para BReq** |
| **v2.0.6** | **CORREGIDO: Eliminado "BReq implícito en META_04" (error conceptual)** |
| **v2.0.6** | **AGREGADO: Sección completa de Business Requirements** |
| **v2.0.6** | **ACTUALIZADO: Diagrama jerarquía muestra 4 niveles completos** |
| **v2.0.6** | **ACTUALIZADO: Árbol incluye requisitos/objetivos/** |
| **v2.0.6** | **NOTA: FND_04 pendiente recreación (archivo corrupto identificado)** |
```

---

## 11. CONCLUSIÓN REVISADA

### 11.1 Estado Real

| Componente | Estado Actual | Estado Requerido |
|------------|---------------|------------------|
| FND_04 | 🔴 CORRUPTO | Recrear |
| FND_03 | 🟡 DESACTUALIZADO | Actualizar a v1.2.0 |
| MODELO v2.0.5 | 🟡 ERROR CONCEPTUAL | Actualizar a v2.0.6 |
| _metadata/ | ✅ CORRECTO | Sin cambios |
| _fundamentos_conceptuales/ | ✅ CORRECTO | (excepto FND_04) |

### 11.2 Resumen de Errores Corregidos

1. **META_04 ≠ BReq:** META_04 es contexto, BReq son objetivos medibles
2. **Falta requisitos/objetivos/:** Debe existir para cumplir FND_05
3. **FND_04 corrupto:** Contiene copia de FND_03
4. **FND_03 desactualizado:** 38 UC vs 49 UC reales

### 11.3 Próximos Pasos

```
┌─────────────────────────────────────────────────────────────┐
│  DECISIÓN: Actualizar a MODELO_DOCUMENTAL_IACT_v2.0.6      │
│                                                             │
│  Cambios principales:                                       │
│  1. Agregar requisitos/objetivos/ con BReq                 │
│  2. Corregir error "BReq en META_04"                       │
│  3. Actualizar diagrama a 4 niveles                        │
│  4. Marcar FND_04 para recreación                          │
└─────────────────────────────────────────────────────────────┘
```

---

*Análisis Revisado FND vs MODELO_DOCUMENTAL_IACT*  
*Fecha: 2026-01-03*  
*Resultado: SE REQUIERE v2.0.6 + Recrear FND_04 + Actualizar FND_03*
