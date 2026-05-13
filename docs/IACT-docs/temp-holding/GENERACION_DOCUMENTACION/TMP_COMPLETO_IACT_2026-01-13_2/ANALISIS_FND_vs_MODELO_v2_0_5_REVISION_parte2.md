---

## 4. ANÁLISIS DETALLADO: FND_03 vs MODELO (Actores/UC)

### 4.1 Discrepancia de Cantidad de UC

| Fuente | Cantidad UC | Detalle |
|--------|-------------|---------|
| FND_03 sección 8 | 38 UC | Lista explícita en documento |
| MODELO v2.0.5 | 49 UC | Distribuidos en 8 módulos |
| **Diferencia** | **+11 UC** | MODELO tiene más |

### 4.2 UC en FND_03 vs UC en MODELO

**FND_03 lista (líneas 708-783):**
```
Gestión Usuarios: 7 UC (UC-005 a UC-011)
Reportes: 8 UC (UC-017 a UC-024)
Dashboards: 6 UC (UC-025 a UC-030)
Análisis: 5 UC (UC-031 a UC-035)
Alertas: 5 UC (UC-036 a UC-040)
Administración: 7 UC (UC-012 a UC-016, UC-041, UC-042)
TOTAL: 38 UC
```

**MODELO v2.0.5 lista:**
```
auth/: 5 UC (UC-001 a UC-005)
users/: 4 UC (UC-006 a UC-009)
access/: 9 UC (UC-010, UC-011, UC-041 a UC-047)
pipeline/: 4 UC (UC-050 a UC-053)
reports/: 12 UC (UC-017 a UC-029)
alerts/: 5 UC (UC-036 a UC-040)
audit/: 4 UC (UC-060 a UC-063)
logs/: 3 UC (UC-070 a UC-072)
TOTAL: 46 UC visibles + 3 implícitos = 49 UC
```

### 4.3 UC que están en MODELO pero NO en FND_03

| UC | Módulo | Descripción | ¿Por qué falta en FND_03? |
|----|--------|-------------|---------------------------|
| UC-001 a UC-004 | auth/ | Login, logout, password | FND_03 empieza en UC-005 |
| UC-043 a UC-047 | access/ | Gestión avanzada RBAC | Añadidos por RBAC v5.1.1 |
| UC-050 a UC-053 | pipeline/ | Supervisión ETL | No existía módulo pipeline |
| UC-060 a UC-063 | audit/ | Auditoría | No existía módulo audit |
| UC-070 a UC-072 | logs/ | Bitácoras | No existía módulo logs |

### 4.4 Conclusión FND_03

**FND_03 está DESACTUALIZADO respecto al MODELO**
- Falta actualizar lista de UC
- Falta módulos: pipeline, audit, logs
- Actores R00x deben mapearse a AGR-00x

---

## 5. ANÁLISIS DETALLADO: FND_05 vs MODELO (Jerarquía)

### 5.1 Jerarquía según FND_05

```
Nivel 0: BR (Business Rules)      → requisitos/reglas_negocio/
Nivel 1: BReq (Business Req.)     → requisitos/objetivos/
Nivel 2: UC (Use Cases)           → requisitos/casos_uso/
Nivel 3: FR (Functional Req.)     → requisitos/funcionales/
```

### 5.2 Jerarquía según MODELO v2.0.5

```
Nivel 0: BR                       → requisitos/reglas_negocio/ ✅
Nivel 1: BReq                     → [NO EXISTE carpeta] ❌
         (dice: "implícito en META_04")
Nivel 2: UC                       → requisitos/casos_uso/ ✅
Nivel 3: FR                       → requisitos/funcionales/ ✅
```

### 5.3 Resolución Propuesta

**Opción Recomendada: Crear estructura BReq mínima**

Agregar en `requisitos/`:
```
requisitos/
├── objetivos/                    # NUEVO - Nivel 1 BReq
│   ├── index.rst
│   └── BReq_001_Objetivos_IACT.rst   # Documento consolidado
├── reglas_negocio/               # Nivel 0 BR
├── casos_uso/                    # Nivel 2 UC
├── funcionales/                  # Nivel 3 FR
└── no_funcionales/               # NFR
```

**Contenido de BReq_001_Objetivos_IACT.rst:**
```rst
BReq_001: Objetivos de Negocio IACT
===================================

1. BReq-001.1: Visibilidad de Métricas
   "El sistema DEBE proporcionar visibilidad en tiempo real
    de las métricas de llamadas del IVR"

2. BReq-001.2: Reducción Tiempo Incidentes
   "El sistema DEBE reducir el tiempo de resolución de
    incidentes en 40%"

3. BReq-001.3: Toma de Decisiones
   "El sistema DEBE permitir a supervisores identificar
    problemas operacionales y tomar decisiones informadas"

Trazabilidad:
- BReq-001.1 → UC-025 (Dashboard Principal)
- BReq-001.2 → UC-036 a UC-040 (Alertas)
- BReq-001.3 → UC-017 a UC-024 (Reportes)
```

---

## 6. ANÁLISIS FND_04: DOCUMENTO CORRUPTO

### 6.1 Evidencia del Error

```
Archivo: FND_04_Trazabilidad.rst
Contenido real: Copia exacta de FND_03_Casos_de_Uso.rst
```

**Líneas problemáticas:**
- Línea 2: `:artefacto: FND_03` (debería ser FND_04)
- Línea 13: `.. _fnd-03:` (debería ser _fnd-04)
- Línea 16: `FND_03: Casos de Uso` (debería ser FND_04: Trazabilidad)

### 6.2 Contenido Esperado de FND_04

Basado en referencias en otros FND (FND_05 línea 543, FND_06 línea 488):

```rst
FND_04: Trazabilidad
====================

1. Definición de Trazabilidad
   - Capacidad de seguir un requisito desde origen hasta implementación
   - Trazabilidad hacia adelante (forward) y hacia atrás (backward)

2. Tipos de Enlaces
   - deriva: BR→UC, UC→FR
   - influye: BR→UC (sin generar)
   - genera: BReq→UC
   - implementa: FR→CODE
   - verifica: TEST→FR

3. Matriz RTM (Requirements Traceability Matrix)
   - Estructura: filas=requisitos, columnas=artefactos
   - Ubicación: evidencia/trazabilidad/RTM_Master_v1_0_0.rst

4. Métricas de Cobertura
   - BR→UC: 100%
   - UC→FR: 100%
   - FR→CODE: 90%
   - FR→TEST: 80%

5. Herramientas en IACT
   - Sphinx cross-references (:ref:)
   - Tags de trazabilidad en metadata
```

### 6.3 Acción Requerida

**CRÍTICO:** Recrear FND_04_Trazabilidad.rst con contenido correcto antes de cualquier otra actualización.
