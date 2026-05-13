---

### 1.5 FND_05: Jerarquía de 4 Niveles

**Versión FND:** 1.0.0 (2025-12-19)  
**Estado:** ⚠️ DESALINEACIÓN PARCIAL

| Aspecto | FND_05 dice | MODELO v2.0.4 dice | Alineación |
|---------|-------------|-------------------|------------|
| Nivel 0 | BR (Business Rules) | BR en requisitos/reglas_negocio/ | ✅ |
| Nivel 1 | BReq (Business Requirements) | **NO EXISTE** subcarpeta objetivos/ | ❌ |
| Nivel 2 | UC (Use Cases) | UC en requisitos/casos_uso/ | ✅ |
| Nivel 3 | FR (Functional Requirements) | FR en requisitos/funcionales/ | ✅ |
| Prefijo BReq | BReq_NNN.rst | **NO DOCUMENTADO** | ❌ |
| Ubicación BReq | requisitos/objetivos/ | **NO EXISTE** en árbol | ❌ |

**Hallazgo H-006:** 🔴 NIVEL 1 (BReq) NO IMPLEMENTADO
- FND_05 define 4 niveles: BR → BReq → UC → FR
- MODELO v2.0.4 solo implementa 3 niveles: BR → UC → FR
- **BReq (Business Requirements) está ausente del modelo**

```
FND_05 líneas 500-510:
   requisitos/
       +--- reglas_negocio/      <- Nivel 0 (BR)
       +--- objetivos/           <- Nivel 1 (BReq) ❌ NO EXISTE EN v2.0.4
       +--- casos_uso/           <- Nivel 2 (UC)
       +--- funcionales/         <- Nivel 3 (FR)
```

**Hallazgo H-007:** 🟡 CANTIDADES DESALINEADAS
- FND_05 ejemplo típico: "5-20 BR → 3-10 BReq → 30-100 UC → 200-1000 FR"
- MODELO v2.0.4: 20 BR → 0 BReq → 49 UC → ~400 FR estimados
- BReq completamente ausente

**Decisión requerida:**
1. **Opción A:** Agregar requisitos/objetivos/ con BReq al modelo
2. **Opción B:** Actualizar FND_05 para reflejar modelo de 3 niveles
3. **Opción C:** Documentar que BReq está implícito en META_04_Contexto_IACT

---

### 1.6 FND_06: Derivación vs Transformación

**Versión FND:** 1.0.0 (2025-12-19)  
**Estado:** ✅ ALINEADO

| Aspecto | FND_06 dice | MODELO v2.0.4 dice | Alineación |
|---------|-------------|-------------------|------------|
| Concepto derivación | Explicitar lo implícito | Cadena BR→UC→FR | ✅ |
| Dirección Greenfield | BR→UC→FR→Código | Orden ejecución: BR→UC→FR | ✅ |
| SRP por nivel | Cada nivel responsabilidad única | Niveles separados en subdominios | ✅ |
| Ejemplo SoD | BR_015 → UC_010 → FR-10.x | BR_007 → UC-043 → (pendiente FR) | ✅ |

**Hallazgos:** Ninguno significativo. El principio de derivación está correctamente aplicado.

**Nota menor:** El ejemplo en FND_06 usa BR_015 para SoD, pero MODELO v2.0.4 usa BR_007. Esto es solo diferencia de numeración, no de concepto.

---

### 1.7 FND_07: Requerimientos Funcionales

**Versión FND:** 1.0.0 (2025-12-19)  
**Estado:** ✅ ALINEADO CON OBSERVACIONES

| Aspecto | FND_07 dice | MODELO v2.0.4 dice | Alineación |
|---------|-------------|-------------------|------------|
| Nomenclatura FR | FR-[UC].[SEQ] | FR_UC[NNN]_Nombre.rst | ✅ |
| Ubicación | requisitos/funcionales/ | requisitos/funcionales/{modulo}/ | ✅ |
| Template | 6 campos definidos | Referencia a TPL_003 | ✅ |
| SMART criteria | Documented | No explícito en modelo | ⚠️ |
| Ratio UC:FR | 1:8 típico | 1:8 documentado | ✅ |

**Hallazgo H-008:** 🟢 OBSERVACIÓN MENOR
- FND_07 documenta criterios SMART extensamente
- MODELO v2.0.4 no menciona SMART explícitamente
- No es error, pero podría referenciarse
