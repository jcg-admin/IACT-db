# ANÁLISIS: Fundamentos Conceptuales - Nomenclatura Desactualizada

**Fecha:** 2026-01-07  
**Subdominio:** `_fundamentos_conceptuales`  
**Estado:** CONGELADO / PRIVADO

---

## SITUACIÓN DETECTADA

### Características del Subdominio

```
Ubicación:  source/base_cognitiva/_fundamentos_conceptuales/
Estado:     CONGELADO
Visibilidad: PRIVADO (excluido de build HTML por prefijo _)
Última actualización: 2026-01-04 (reciente)
Documentos: 7 archivos FND
```

### Problema: Ejemplos con Nomenclatura Antigua

Los documentos fundacionales contienen **múltiples ejemplos** con nomenclatura **v2.0** (UC-XXX), cuando el proyecto ya está en **v4.0.0** (UC_MOD_NN).

---

## REFERENCIAS ENCONTRADAS

### FND_01_Concepto_Requisito.rst

```rst
Línea 316: UC-40 Paso 6: "Sistema valida formato CAS Number"
Línea 490: - UC-015: Caso de uso numero 15
Línea 491: - FR-015.3: Tercer FR derivado de UC-015
```

### FND_03_Casos_de_Uso.rst (MÚLTIPLES)

```rst
Línea 100:  UC-043: Configurar SoD           → Ahora: UC_ACC_05
Línea 160:  UC-043: Configurar SoD (ejemplo)
Línea 163:  ID: UC-043
Línea 265:  UC-006 a UC-009                  → Ahora: UC_USR_01 a UC_USR_04
Línea 267:  UC-017 a UC-024                  → Ahora: UC_RPT_XX
Línea 269:  UC-036 a UC-040                  → Ahora: UC_ALR_XX
Línea 272:  UC-010, UC-043-047               → Ahora: UC_ACC_01, UC_ACC_05-09
Línea 273:  UC-050-053, UC-070-072           → Ahora: UC_PIP_XX, UC_LOG_XX
Línea 614:  UC-001: Inicio de Sesion         → Ahora: UC_AUTH_01
Línea 615:  UC-002: Cierre de Sesion         → Ahora: UC_AUTH_02
Línea 616:  UC-003: Recuperar Password       → Ahora: UC_AUTH_03
```

**Total:** ~20+ referencias a nomenclatura antigua

---

## MAPEO: Nomenclatura Antigua → Nueva

| Antigua (v2.0) | Nueva (v4.0.0) | Módulo | Nombre |
|----------------|----------------|--------|--------|
| UC-001 | UC_AUTH_01 | AUTH | Inicio Sesión |
| UC-002 | UC_AUTH_02 | AUTH | Cierre Sesión |
| UC-003 | UC_AUTH_03 | AUTH | Recuperar Password |
| UC-006 a UC-009 | UC_USR_01 a UC_USR_04 | USR | Gestión Usuarios |
| UC-010 | UC_ACC_01 | ACC | Asignar Funciones |
| UC-043 | UC_ACC_05 | ACC | Gestionar SoD |
| UC-017 a UC-024 | UC_RPT_01 a UC_RPT_08 | RPT | Reportes |
| UC-036 a UC-040 | UC_ALR_01 a UC_ALR_05 | ALR | Alertas |
| UC-050 a UC-053 | UC_PIP_01 a UC_PIP_04 | PIP | Pipeline |
| UC-060 a UC-063 | UC_AUD_01 a UC_AUD_04 | AUD | Auditoría |
| UC-070 a UC-072 | UC_LOG_01 a UC_LOG_04 | LOG | Logs |

---

## ANÁLISIS DE IMPACTO

### Impacto Bajo (Documentos Privados)

**Razones:**
1. ✅ Carpeta con prefijo `_` (privada, no en build HTML)
2. ✅ Estado "CONGELADO" (referencia teórica)
3. ✅ Audiencia interna (onboarding de equipo)

**PERO:**

### Impacto en Consistencia

❌ **Problema de Onboarding:**
- Nuevos miembros del equipo leen fundamentos con UC-043
- Van a casos de uso reales y ven UC_ACC_05
- **Confusión:** ¿Cuál es el correcto?

❌ **Problema de Mantenibilidad:**
- Si alguien busca "UC-043" en el proyecto
- Encuentra 2 referencias: fundamentos (antigua) + docs reales (nueva)
- Ambigüedad en trazabilidad

❌ **Problema de Credibilidad:**
- Documentos "actualizados 2026-01-04" con ejemplos obsoletos
- Apariencia de documentación descuidada

---

## DECISIÓN REQUERIDA

### Opción A: Actualizar Ejemplos (Recomendado)

**Acción:**
- Actualizar ~20 referencias UC-XXX → UC_MOD_NN en archivos FND
- Mantener conceptos (no cambian)
- Solo actualizar ejemplos/referencias

**Pros:**
- ✅ Consistencia total en el proyecto
- ✅ Onboarding sin confusión
- ✅ Búsqueda de UC unívoca

**Contras:**
- ⏱️ Trabajo manual (~2 horas)
- 📝 Cambiar estado de CONGELADO a ACTUALIZADO

**Esfuerzo:** 2-3 horas

### Opción B: Mantener Como Referencia Histórica

**Acción:**
- No modificar fundamentos
- Agregar nota de advertencia al inicio:

```rst
.. warning::

   Este documento contiene ejemplos con nomenclatura v2.0 (UC-XXX).
   La nomenclatura actual del proyecto es v4.0.0 (UC_MOD_NN).
   Ver: requisitos/casos_uso/index.rst para nomenclatura vigente.
```

**Pros:**
- ✅ No tocar documentos "congelados"
- ✅ Trabajo mínimo (~15 min)

**Contras:**
- ❌ Mantiene inconsistencia
- ❌ Confusión para nuevos miembros

**Esfuerzo:** 15 minutos

### Opción C: Reescribir con Ejemplos Genéricos

**Acción:**
- Cambiar ejemplos específicos a genéricos:
  - `UC-043` → `UC_XXX` o `UC_Ejemplo`
  - `UC-001` → `UC_ModAuth_01`

**Pros:**
- ✅ Sin dependencia de nomenclatura específica
- ✅ Documentos más "atemporales"

**Contras:**
- ❌ Pierde concreción
- ❌ Ejemplos menos útiles

**Esfuerzo:** 3-4 horas

---

## RECOMENDACIÓN

### ⭐ Opción A: Actualizar Ejemplos

**Razón:**
- Documentos fueron modificados recientemente (2026-01-04)
- El estado "CONGELADO" probablemente se refiere a **conceptos**, no a **ejemplos**
- Mantener consistencia mejora la calidad del proyecto
- Esfuerzo justificado (2-3 horas) vs beneficio (claridad total)

**Archivos a modificar:**
1. FND_01_Concepto_Requisito.rst (~3 referencias)
2. FND_03_Casos_de_Uso.rst (~15 referencias)
3. Otros FND_XX.rst si tienen referencias

**Cambios:**
- UC-XXX → UC_MOD_NN según mapeo
- Actualizar fecha de última modificación
- Agregar nota en historial de cambios

---

## PRÓXIMOS PASOS

1. **Decisión:** ¿Opción A, B o C?
2. **Si es Opción A:** Generar archivos FND actualizados
3. **Verificar otros subdominios:**
   - `_metadata/`
   - `_ontologia_sbvr/`
   - `_taxonomias_y_metamodelos/`

---

**Estado:** Análisis completo  
**Esperando:** Decisión del usuario

