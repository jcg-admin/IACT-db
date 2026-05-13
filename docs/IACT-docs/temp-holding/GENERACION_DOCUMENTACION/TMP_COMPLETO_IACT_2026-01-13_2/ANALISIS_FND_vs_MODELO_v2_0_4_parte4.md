---

## 6. PLAN DE ACCIÓN

### 6.1 Acciones sobre FND (Fundamentos)

| Prioridad | Acción | Responsable | Esfuerzo |
|-----------|--------|-------------|----------|
| 🔴 CRÍTICA | Recrear FND_04_Trazabilidad.rst con contenido correcto | Documentador | 4h |
| 🔴 ALTA | Actualizar FND_03 actores: R00x → Funciones/Agrupadores | Documentador | 2h |
| 🟡 MEDIA | Actualizar FND_03 cantidad UC: 38 → 49 | Documentador | 1h |
| 🟡 MEDIA | Actualizar FND_03 módulos: agregar mapping a estructura real | Documentador | 1h |
| 🟢 BAJA | Revisar FND_05 para documentar decisión sobre BReq | Documentador | 30m |

### 6.2 Acciones sobre MODELO_DOCUMENTAL

| Prioridad | Acción | Sección Afectada | Esfuerzo |
|-----------|--------|------------------|----------|
| 🟡 MEDIA | Agregar referencia a template BR (FND_02/TPL_001) | Sección 4.2 | 30m |
| 🟡 MEDIA | Documentar decisión sobre BReq (Nivel 1) | Nueva sección | 30m |
| 🟡 MEDIA | Agregar mapeo Actores FND_03 ↔ Agrupadores RBAC | Sección 5.1 | 1h |
| 🟢 BAJA | Referenciar criterios SMART de FND_07 | Sección 3.3 | 15m |

### 6.3 Priorización de Versiones

**Fase 1: Corrección Crítica FND_04** (antes de cualquier otra cosa)
```
FND_04_Trazabilidad.rst → Crear documento correcto
Versión FND_04: 1.0.0
```

**Fase 2: MODELO_DOCUMENTAL v2.0.5** (cambios menores)
```
Cambios:
1. Nota sobre BReq implícito
2. Referencia a template BR
3. Mapeo actores ↔ agrupadores
4. Referencia SMART
```

**Fase 3: Actualización FND_03** (alineación con RBAC v5.1.1)
```
FND_03 v1.2.0:
1. Actores basados en Agrupadores, no Roles fijos
2. Lista actualizada de 49 UC
3. Módulos alineados con estructura real
```

---

## 7. PROPUESTA DE CONTENIDO FND_04_Trazabilidad

### 7.1 Estructura Propuesta

```rst
FND_04: Trazabilidad
====================

1. Definición de Trazabilidad
   - Qué es trazabilidad de requisitos
   - Por qué es importante
   - Trazabilidad bidireccional

2. Tipos de Enlaces
   - deriva (BR→UC, UC→FR)
   - influye (BR→UC sin generar)
   - genera (BReq→UC)
   - implementa (FR→CODE)
   - verifica (TEST→FR)

3. Matriz RTM (Requirements Traceability Matrix)
   - Estructura de la matriz
   - Herramientas (Sphinx cross-references)
   - Mantenimiento

4. Métricas de Cobertura
   - BR→UC: 100%
   - UC→FR: 100%
   - FR→CODE: 90%
   - FR→TEST: 80%

5. Trazabilidad en IACT
   - Ubicación: evidencia/trazabilidad/
   - RTM_Master_v1_0_0.rst
   - COV_001_Reporte_Cobertura.rst
```

### 7.2 Contenido Clave (extracto)

```rst
2. Tipos de Enlaces
-------------------

2.1 Enlace "deriva"
^^^^^^^^^^^^^^^^^^^

Relación donde un artefacto de nivel inferior se genera 
DIRECTAMENTE de un artefacto de nivel superior.

.. code-block:: text

   BR_002 (ETL Batch Nocturno)
       |
       | deriva (tipo Trigger genera UC)
       v
   UC_050 (Supervisar ETL)
       |
       | deriva (paso UC genera FR)
       v
   FR-050.1, FR-050.2, ...

Cardinalidad: 1 BR Trigger : 1 UC
              1 UC : N FR (típico N=8)
```

---

## 8. CONCLUSIÓN Y RECOMENDACIÓN

### 8.1 Estado Actual

| Documento | Estado | Acción |
|-----------|--------|--------|
| FND_01 | ✅ Alineado | Ninguna |
| FND_02 | ⚠️ Parcial | Referenciar en modelo |
| FND_03 | ❌ Desalineado | Actualizar FND |
| FND_04 | 🔴 Corrupto | RECREAR |
| FND_05 | ⚠️ Parcial | Documentar decisión BReq |
| FND_06 | ✅ Alineado | Ninguna |
| FND_07 | ✅ Alineado | Referencia SMART opcional |

### 8.2 Recomendación Final

```
┌─────────────────────────────────────────────────────────────┐
│  DECISIÓN: Actualizar a MODELO_DOCUMENTAL_IACT_v2.0.5      │
│                                                             │
│  Razón: Los cambios son correcciones menores y             │
│         clarificaciones, no cambios estructurales.          │
│                                                             │
│  v2.1.x se reservaría para:                                │
│  - Agregar nuevo dominio                                   │
│  - Cambiar estructura de árbol                             │
│  - Modificar jerarquía de derivación                       │
└─────────────────────────────────────────────────────────────┘
```

### 8.3 Orden de Ejecución

```
1. [CRÍTICO] Crear FND_04_Trazabilidad.rst correcto
2. [ALTO]    Crear MODELO_DOCUMENTAL_IACT_v2.0.5
3. [MEDIO]   Actualizar FND_03 a v1.2.0
4. [BAJO]    Revisar FND_05 para nota sobre BReq
```

---

## 9. CHANGELOG PROPUESTO v2.0.4 → v2.0.5

```markdown
| Versión | Cambio |
|---------|--------|
| v2.0.5 | Documentada decisión: BReq (Nivel 1) implícito en META_04 |
| v2.0.5 | Agregada referencia a template BR (TPL_001, FND_02) |
| v2.0.5 | Agregado mapeo Actores FND_03 ↔ Agrupadores RBAC v5.1.1 |
| v2.0.5 | Agregada referencia a criterios SMART (FND_07) |
| v2.0.5 | Corregida referencia a FND_04 (pendiente recreación) |
```

---

*Análisis FND vs MODELO_DOCUMENTAL_IACT v2.0.4*  
*Fecha: 2026-01-03*  
*Resultado: SE REQUIERE v2.0.5 + Corrección FND_04*
