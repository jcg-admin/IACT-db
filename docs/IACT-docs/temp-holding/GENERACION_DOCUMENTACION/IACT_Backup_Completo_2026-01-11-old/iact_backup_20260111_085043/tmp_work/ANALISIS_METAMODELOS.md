# ANÁLISIS: _taxonomias_y_metamodelos/metamodelos/

**Fecha:** 2026-01-07  
**Archivos:** 3 MTM  
**Fecha Creación:** 2025-12-20

---

## RESULTADO: ⚠️ REFERENCIAS DESACTUALIZADAS

### Archivos Verificados
```
_taxonomias_y_metamodelos/metamodelos/
├── MTM_01_Metamodelo_Requisitos.rst      ⚠️ UC_010, UC-XXX
├── MTM_02_Metamodelo_Trazabilidad.rst    ⚠️ UC-010, UC-ETL
└── MTM_03_Metamodelo_RBAC.rst            ⚠️ UC-005 a UC-011
```

---

## REFERENCIAS ENCONTRADAS

### MTM_01: Metamodelo de Requisitos

**Referencias mixtas (UC_XXX y UC-XXX):**
```rst
Línea 413: BR_015 (SoD) --influye--> UC_010 (Asignar Rol)
Línea 434: UC_010 --deriva--> FR-10.1, FR-10.2, ..., FR-10.15
Línea 451: UC_ETL (Sincronizar Datos)
Línea 597: :UC_010 (instancia de UseCase)
Línea 606: ucOrigen = UC_010
```

**Nota:** Usa `UC_010` sin guión (formato de transición)

### MTM_02: Metamodelo de Trazabilidad

**Tabla RTM ejemplo (líneas 535, 538):**
```
| BR_015 | UC-010 | FR-10.6  | RoleService.validateSoD()  |
| BR_015 | UC-010 | FR-10.7  | RoleService.checkConflicts()|
```

**Diagramas (líneas 241-359):**
```rst
- UC_010 --deriva--> FR-10.1
- BR_015 --influye--> UC_010
- UC_010a --refina--> UC_010
- UC_010 (Asignar Rol)
```

**Nota:** Usa tanto `UC-010` (con guión) como `UC_010` (sin guión)

### MTM_03: Metamodelo RBAC

**Referencia en trazabilidad (línea 696):**
```rst
referenciado en los UC de gestion de usuarios (UC-005 a UC-011)
```

**Nota:** Rango genérico de UC antiguos

---

## MAPEO: Referencias Antiguas → Nuevas

| Referencia Antigua | Nueva (v4.0.0) | Nombre |
|--------------------|----------------|--------|
| UC_010 / UC-010 | UC_ACC_01 | Asignar Funciones |
| UC-005 a UC-011 | UC_USR_01 a UC_USR_04 + UC_ACC_01 | Gestión Usuarios + Asignar |
| UC_ETL | UC_PIP_01 a UC_PIP_04 | Pipeline ETL |

**Nota sobre UC_010:**
- v2.0: UC-010 o UC_010 → "Asignar Rol"
- v4.0: UC_ACC_01 → "Asignar Funciones" (mismo concepto, renombrado)

**Nota sobre UC-005 a UC-011:**
- Esta referencia es vaga
- Probablemente se refiere a módulos USR y ACC completos
- Actual: UC_USR_01 a UC_USR_04 (4 UC) + UC_ACC_01 a UC_ACC_09 (9 UC)

---

## ANÁLISIS DE IMPACTO

### Características de los Metamodelos

1. **Fecha:** Creados 2025-12-20 (antes de v4.0.0)
2. **Estado:** Aprobado, PRIVADO (prefijo `_`)
3. **Tipo:** Documentos formales UML
4. **Audiencia:** Arquitectos, BA Lead

### Impacto: MEDIO

**Razones:**

✅ **Bajo impacto operativo:**
- Documentos privados (no en build HTML)
- No son casos de uso ejecutables
- Son documentos de modelado conceptual

❌ **Alto impacto en consistencia:**
- Usan UC_010 como ejemplo recurrente (~15 referencias)
- Matrices RTM muestran nomenclatura antigua
- Confusión al buscar UC_010 en el proyecto

❌ **Impacto en trazabilidad:**
- RTM con UC antiguos dificulta auditorías
- Búsqueda de "UC_010" retorna metamodelo (obsoleto) + real (no existe)

---

## TIPOS DE REFERENCIAS

### 1. Ejemplos en Diagramas UML
```
UC_010 (Asignar Rol)
BR_015 --influye--> UC_010
```

**Tipo:** Ejemplo ilustrativo de relaciones
**Acción:** Actualizar a UC_ACC_01

### 2. Tablas RTM
```
| BR_015 | UC-010 | FR-10.6 | RoleService.validateSoD() |
```

**Tipo:** Matriz de trazabilidad ejemplo
**Acción:** Actualizar a UC_ACC_01

### 3. Referencias Genéricas
```
UC de gestion de usuarios (UC-005 a UC-011)
```

**Tipo:** Rango descriptivo
**Acción:** Actualizar a "UC_USR_01 a UC_USR_04, UC_ACC_01"

---

## DECISIÓN REQUERIDA

### Opción A: Actualizar Referencias (Recomendado)

**Acción:**
- Reemplazar UC_010 / UC-010 → UC_ACC_01
- Actualizar UC-005 a UC-011 → UC_USR_XX y UC_ACC_XX
- Actualizar UC_ETL → UC_PIP_XX
- Actualizar fecha de última modificación

**Pros:**
- ✅ Consistencia total en metamodelos
- ✅ RTM actualizadas como ejemplos válidos
- ✅ Búsquedas de UC no ambiguas

**Contras:**
- ⏱️ Trabajo manual (~15 referencias)
- 📝 Cambiar estado de Aprobado → Actualizado

**Esfuerzo:** 1-2 horas

### Opción B: Agregar Nota de Advertencia

**Acción:**
- Agregar al inicio de cada MTM:

```rst
.. warning::

   Este metamodelo contiene ejemplos con nomenclatura v2.0.
   La nomenclatura actual del proyecto es v4.0.0:
   
   - UC_010 → UC_ACC_01 (Asignar Funciones)
   - UC-005 a UC-011 → UC_USR_XX, UC_ACC_XX
```

**Pros:**
- ✅ Rápido (~15 min)
- ✅ No modifica documentos "formales"

**Contras:**
- ❌ Mantiene inconsistencia
- ❌ RTM siguen siendo ejemplos obsoletos

**Esfuerzo:** 15 minutos

### Opción C: Mantener Como Está

**Acción:** Ninguna

**Razón:**
- Documentos privados (no críticos)
- Son metamodelos conceptuales
- La estructura formal no cambia

**Pros:**
- ✅ Cero trabajo

**Contras:**
- ❌ Total inconsistencia
- ❌ Confusión persistente

---

## RECOMENDACIÓN

### ⭐ Opción A: Actualizar Referencias

**Razón:**
- Metamodelos se usan para documentación formal
- RTM son ejemplos de trazabilidad (deben ser correctos)
- Mantener consistencia mejora calidad del proyecto
- Esfuerzo justificado (1-2 horas)

**Cambios concretos:**

1. **MTM_01:** ~6 referencias UC_010 → UC_ACC_01
2. **MTM_02:** ~9 referencias UC-010/UC_010 → UC_ACC_01
3. **MTM_03:** 1 referencia UC-005 a UC-011 → descripción actualizada

**Total:** ~16 referencias

---

## ARCHIVOS A GENERAR

Si decides Opción A, genero:
1. `MTM_01_Metamodelo_Requisitos_v4.rst`
2. `MTM_02_Metamodelo_Trazabilidad_v4.rst`
3. `MTM_03_Metamodelo_RBAC_v4.rst`

---

**Estado:** ⚠️ REQUIERE ACTUALIZACIÓN  
**Esperando:** Decisión del usuario (A, B o C)

