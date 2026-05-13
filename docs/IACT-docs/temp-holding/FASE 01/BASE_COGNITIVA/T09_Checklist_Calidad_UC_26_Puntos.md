# TEMPLATE T09: Checklist de Calidad de UC (26 Puntos)

**Versión:** 1.0.0  
**Categoría:** Validación y Calidad  
**Fuente:** PARTE 2C, Sección 9.1  
**Uso:** Validar completitud y calidad de un UC antes de aprobación

---

## ¿CUÁNDO USAR ESTE TEMPLATE?

Usa este checklist cuando:
- Terminaste de documentar un UC
- Necesitas validar completitud antes de peer review
- Estás revisando UC de otro analista
- Preparas UC para aprobación final

---

## CHECKLIST COMPLETO (26 PUNTOS)

```markdown
# EVALUACIÓN DE CALIDAD: UC-[ID]

**Evaluador:** [Nombre]  
**Fecha:** [YYYY-MM-DD]  
**Versión UC:** [X.Y.Z]

---

## SECCIÓN 1: COMPLETITUD (8 puntos)

☐ **1. ID único asignado**
   ID del UC: [UC-MODULE-NN]
   Formato correcto: [SÍ / NO]

☐ **2. Nombre claro en formato Verbo + Objeto**
   Nombre: [copiar nombre]
   Formato: [Verbo] + [Objeto] + [Contexto opcional]
   Claro y descriptivo: [SÍ / NO]

☐ **3. Actor Primario identificado**
   Actor: [Nombre del actor]
   Justificación presente: [SÍ / NO]

☐ **4. Trigger específico documentado**
   Trigger: [Descripción]
   Suficientemente específico: [SÍ / NO]

☐ **5. Precondiciones completas (mínimo 2)**
   Cantidad: [N precondiciones]
   Cubren: Estado, Auth, BR, Datos: [SÍ / NO]
   Mínimo cumplido: [SÍ / NO]

☐ **6. Flujo Normal con 5+ pasos**
   Cantidad de pasos: [N]
   Mínimo 5 pasos: [SÍ / NO]
   Pasos numerados consecutivamente: [SÍ / NO]

☐ **7. Al menos 2 Flujos Alternos**
   Cantidad de FA: [N]
   Mínimo 2 FA: [SÍ / NO]
   FA relevantes y útiles: [SÍ / NO]

☐ **8. Postcondiciones definidas (éxito y fallo)**
   Postcondiciones de éxito: [SÍ / NO]
   Postcondiciones de FA: [SÍ / NO]

**Subtotal Sección 1:** [X/8]

---

## SECCIÓN 2: CLARIDAD (6 puntos)

☐ **9. Pasos numerados secuencialmente**
   Secuencia: 1, 2, 3... sin saltos: [SÍ / NO]
   FA numerados: 2a, 2b, 2c...: [SÍ / NO]

☐ **10. Un paso = Una acción atómica**
   Pasos divididos apropiadamente: [SÍ / NO]
   Sin pasos compuestos complejos: [SÍ / NO]

☐ **11. Sin ambigüedad en verbos**
   Verbos específicos ("valida" vs "verifica si"): [SÍ / NO]
   Actor claro en cada paso: [SÍ / NO]

☐ **12. Sin jerga técnica no explicada**
   Términos técnicos explicados: [SÍ / NO]
   Acrónimos definidos: [SÍ / NO]

☐ **13. Ejemplos concretos en pasos complejos**
   Pasos complejos tienen ejemplos: [SÍ / NO]
   Queries SQL incluidos donde relevante: [SÍ / NO]

☐ **14. Puntos de desviación explícitos en FA**
   Formato "Paso Na, Nb...": [SÍ / NO]
   Punto de retorno claro: [SÍ / NO]

**Subtotal Sección 2:** [X/6]

---

## SECCIÓN 3: TRAZABILIDAD (4 puntos)

☐ **15. BR origen identificadas (al menos 1)**
   Cantidad de BR: [N]
   BR documentadas en sección: [SÍ / NO]
   Mínimo 1 BR: [SÍ / NO]

☐ **16. Ubicación de BR en UC documentada (Paso N)**
   Cada BR indica su ubicación: [SÍ / NO]
   Formato: "[BR-ID] en Paso N": [SÍ / NO]

☐ **17. FR derivados listados (mínimo 3)**
   Cantidad de FR: [N]
   Mínimo 3 FR: [SÍ / NO]
   FR nombrados descriptivamente: [SÍ / NO]

☐ **18. UC relacionados referenciados si existen**
   UC relacionados listados: [SÍ / NO / N/A]
   Relación explicada: [SÍ / NO / N/A]

**Subtotal Sección 3:** [X/4]

---

## SECCIÓN 4: COMPLETITUD TÉCNICA (4 puntos)

☐ **19. Queries SQL incluidos para pasos críticos**
   Pasos con queries: [Listar números]
   Queries completos y ejecutables: [SÍ / NO]
   Índices documentados: [SÍ / NO]

☐ **20. Validaciones con lógica explícita (IF-THEN)**
   Validaciones en pseudocódigo: [SÍ / NO]
   Lógica clara e implementable: [SÍ / NO]

☐ **21. Manejo de errores documentado (FA)**
   FA para errores técnicos: [SÍ / NO]
   FA para errores de validación: [SÍ / NO]
   FA para cancelación de usuario: [SÍ / NO / N/A]

☐ **22. Consideraciones de performance si aplican**
   Performance estimada: [SÍ / NO / N/A]
   Timeouts documentados: [SÍ / NO / N/A]
   Límites de recursos: [SÍ / NO / N/A]

**Subtotal Sección 4:** [X/4]

---

## SECCIÓN 5: REVISIÓN DE NEGOCIO (4 puntos)

☐ **23. Stakeholders identificados con intereses**
   Stakeholders listados: [N]
   Intereses específicos documentados: [SÍ / NO]

☐ **24. Valor de negocio claro**
   Valor explicado: [SÍ / NO]
   Beneficio tangible: [SÍ / NO]

☐ **25. Frecuencia de uso estimada**
   Frecuencia documentada: [Diaria/Horaria/etc]
   Estimación razonable: [SÍ / NO]

☐ **26. Prioridad asignada (Alta/Media/Baja)**
   Prioridad: [Alta / Media / Baja]
   Justificación presente: [SÍ / NO]

**Subtotal Sección 5:** [X/4]

---

## PUNTUACIÓN TOTAL

**Sección 1 (Completitud):** [X/8]  
**Sección 2 (Claridad):** [X/6]  
**Sección 3 (Trazabilidad):** [X/4]  
**Sección 4 (Técnica):** [X/4]  
**Sección 5 (Negocio):** [X/4]

**TOTAL:** [X/26]

---

## CALIFICACIÓN

- **26/26:** ⭐⭐⭐⭐⭐ Excelente
- **22-25:** ⭐⭐⭐⭐ Muy Bueno
- **18-21:** ⭐⭐⭐ Bueno
- **14-17:** ⭐⭐ Aceptable (requiere mejoras)
- **<14:** ⭐ Requiere reescritura

**Calificación obtenida:** [Estrellas]

---

## BLOQUEOS CRÍTICOS

❌ **El UC NO puede aprobarse si falta:**

☐ Punto 1 (Sin ID único)
☐ Punto 3 (Sin Actor Primario)
☐ Punto 6 (Sin Flujo Normal completo)
☐ Punto 15 (Sin BR origen)

**Bloqueos detectados:** [Cantidad]

Si hay bloqueos: **UC RECHAZADO** → Corregir antes de continuar

---

## ISSUES IDENTIFICADOS

### Críticos (Bloquean aprobación)
1. [Descripción del issue]
2. [Descripción del issue]

### Mayores (Deben corregirse)
1. [Descripción del issue]
2. [Descripción del issue]

### Menores (Mejoras sugeridas)
1. [Descripción del issue]
2. [Descripción del issue]

---

## DECISIÓN FINAL

- [ ] **APROBADO** sin cambios (26/26 o 22-25/26 sin bloqueos)
- [ ] **APROBADO** con cambios menores (corregir y no re-revisar)
- [ ] **REQUIERE CAMBIOS MAYORES** (re-revisión necesaria)
- [ ] **RECHAZADO** (reescritura completa requerida)

**Comentarios generales:**
[Feedback adicional, fortalezas, áreas de mejora]

---

**Evaluador:** [Nombre]  
**Firma:** [Firma digital]  
**Fecha:** [YYYY-MM-DD]
```

---

## GUÍA DE PUNTUACIÓN

### Cómo Puntuar Cada Ítem

**✅ PUNTO COMPLETO (1 punto):**
- Criterio cumplido completamente
- Sin ambigüedad
- Calidad profesional

**⚠️ MEDIO PUNTO (0.5):**
- Criterio parcialmente cumplido
- Mejorable pero aceptable
- Falta detalle menor

**❌ SIN PUNTO (0):**
- Criterio NO cumplido
- Falta completamente
- Requiere corrección

---

## CRITERIOS DE APROBACIÓN

```
SI puntuación >= 22 Y sin bloqueos ENTONCES
  UC puede aprobarse
SINO
  UC requiere trabajo adicional
FIN SI
```

---

## EJEMPLO DE EVALUACIÓN

**UC-IACT-07: Notificar Expiración de Sesión**

☑ 1. ID: UC-IACT-07 ✅ (1.0)
☑ 2. Nombre: "Notificar Expiración Inminente de Sesión" ✅ (1.0)
☑ 3. Actor: Sistema (Scheduler) ✅ (1.0)
☑ 4. Trigger: "Cada minuto en punto" ✅ (1.0)
☑ 5. Precondiciones: 8 listadas ✅ (1.0)
☑ 6. Flujo Normal: 11 pasos ✅ (1.0)
☑ 7. FA: 6 documentados ✅ (1.0)
☑ 8. Postcondiciones: 24 (éxito + FA) ✅ (1.0)
☑ 9. Pasos numerados: 1-11 ✅ (1.0)
☑ 10. Acción atómica: Sí ✅ (1.0)
☑ 11. Sin ambigüedad: Sí ✅ (1.0)
☑ 12. Sin jerga: Términos explicados ✅ (1.0)
☑ 13. Ejemplos: Query completo ✅ (1.0)
☑ 14. Puntos desviación: "2a, 4b" ✅ (1.0)
☑ 15. BR origen: BR-IACT-031 ✅ (1.0)
☑ 16. Ubicación: Paso 2 ✅ (1.0)
☑ 17. FR: 9 derivados ✅ (1.0)
☑ 18. UC relacionados: UC-08 ✅ (1.0)
☑ 19. Queries: Completo con índices ✅ (1.0)
☑ 20. Validaciones: EXISTS check ✅ (1.0)
☑ 21. Errores: 6 FA ✅ (1.0)
☑ 22. Performance: <100ms ✅ (1.0)
☑ 23. Stakeholders: 3 identificados ✅ (1.0)
☑ 24. Valor: Seguridad ✅ (1.0)
☑ 25. Frecuencia: Continua ✅ (1.0)
☑ 26. Prioridad: Alta ✅ (1.0)

**TOTAL: 26/26 ⭐⭐⭐⭐⭐ EXCELENTE**

Sin bloqueos → **APROBADO**

---

## USO EN DIFERENTES FASES

### Fase 1: Auto-evaluación (Autor)
- Usar checklist antes de enviar a review
- Corregir issues evidentes
- Meta: >22/26 antes de peer review

### Fase 2: Peer Review (Revisor Técnico)
- Evaluar con checklist completo
- Documentar issues en cada sección
- Decisión: Aprobar / Cambios / Rechazar

### Fase 3: Validación Final (Arquitecto/Lead)
- Verificar puntuación >22/26
- Confirmar sin bloqueos
- Aprobación formal para implementación

---

## REFERENCIAS

- **Documento fuente:** PARTE_2C_CASOS_ESPECIALES_IACT.md, Sección 9.1
- **Ejemplo de evaluación:** UC-IACT-07 (26/26)
- **Templates relacionados:**
  - T02: Construcción de UC
  - T10: Peer Review
  - T11: Walkthrough con Stakeholders

---

**Versión:** 1.0.0  
**Última actualización:** 2026-01-08  
**Mantenido por:** Equipo IACT
