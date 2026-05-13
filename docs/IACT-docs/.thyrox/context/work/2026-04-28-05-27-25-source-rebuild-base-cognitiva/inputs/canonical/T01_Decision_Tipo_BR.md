# TEMPLATE T01: Decisión de Tipo de Business Rule

**Versión:** 1.0.0  
**Categoría:** Análisis de BR  
**Fuente:** PARTE 2A, Sección 1.2  
**Uso:** Clasificar una BR recién identificada en uno de los 5 tipos

---

## ¿CUÁNDO USAR ESTE TEMPLATE?

Usa este template cuando:
- Acabas de identificar una nueva Business Rule
- Necesitas decidir qué tipo de artefacto genera (UC, FR, Modelo)
- Estás revisando una BR mal clasificada

---

## INSTRUCCIONES

1. Copia el template de abajo
2. Pega la BR a analizar
3. Responde cada pregunta de verificación
4. Sigue la decisión final indicada

---

## TEMPLATE

```markdown
### ANÁLISIS DE BR-[ID]: [Nombre]

**Texto de la BR:**
[Copiar aquí el enunciado completo de la BR]

#### VERIFICACIÓN PASO 1: ¿Es HECHO?

☐ ¿Describe ESTRUCTURA de datos/entidades?
☐ ¿Define atributos, relaciones, cardinalidades?
☐ ¿NO describe comportamiento?

Si las 3 respuestas son SÍ → **HECHO**
└─> **NO genera UC**, genera **Modelo de Dominio**

#### VERIFICACIÓN PASO 2: ¿Es DESENCADENADOR?

☐ ¿Tiene estructura IF-THEN?
☐ ¿Condición es temporal o de estado?
☐ ¿Acción es observable por actor externo?
☐ ¿Alguien RECIBE/VE el resultado?

Si las 4 respuestas son SÍ → **DESENCADENADOR** ⭐
└─> **SÍ genera UC completo** (ÚNICO tipo que genera UC)

#### VERIFICACIÓN PASO 3: ¿Es RESTRICCIÓN?

☐ ¿Limita o condiciona comportamiento?
☐ ¿NO inicia comportamiento automáticamente?
☐ ¿Se valida ANTES o DURANTE una acción?

Si las 3 respuestas son SÍ → **RESTRICCIÓN**
└─> **NO genera UC**, se integra como Precondición/Validación/FA

#### VERIFICACIÓN PASO 4: ¿Es INFERENCIA?

☐ ¿Tiene estructura IF-THEN?
☐ ¿Cambio automático pero NO observable?
☐ ¿Solo campo de BD cambia?
☐ ¿Usuario NO ve que ocurrió?

Si las 4 respuestas son SÍ → **INFERENCIA**
└─> **NO genera UC**, genera **FR directo** (UPDATE automático)

#### VERIFICACIÓN PASO 5: ¿Es CÁLCULO?

☐ ¿Es fórmula o algoritmo?
☐ ¿Tiene múltiples inputs?
☐ ¿Produce output calculado?
☐ ¿Se usa DENTRO de proceso mayor?

Si las 4 respuestas son SÍ → **CÁLCULO**
└─> **NO genera UC**, se integra como **paso en flujo**

#### DECISIÓN FINAL

Tipo identificado: [HECHO / DESENCADENADOR / RESTRICCIÓN / INFERENCIA / CÁLCULO]

Resultado:
- [ ] Genera UC completo (solo DESENCADENADOR)
- [ ] Genera Modelo de Dominio (HECHO)
- [ ] Se integra en UC existente (RESTRICCIÓN, CÁLCULO)
- [ ] Genera FR directo (INFERENCIA)

Próximo paso:
[Describir qué hacer con la BR según clasificación]
```

---

## ÁRBOL DE DECISIÓN VISUAL

```
                    ┌──────────────┐
                    │ Business Rule│
                    └──────┬───────┘
                           │
            ┌──────────────┴──────────────┐
            │                             │
    ┌───────▼────────┐           ┌───────▼────────┐
    │ ¿Describe      │           │ ¿Describe      │
    │ ESTRUCTURA?    │           │ COMPORTAMIENTO?│
    └───────┬────────┘           └───────┬────────┘
            │ SÍ                         │ SÍ
            │                            │
      ┌─────▼─────┐              ┌──────▼────────┐
      │   HECHO   │              │  IF-THEN      │
      │ → Modelo  │              │  presente?    │
      └───────────┘              └──────┬────────┘
                                        │ SÍ
                               ┌────────┴────────┐
                               │                 │
                      ┌────────▼────────┐ ┌─────▼─────┐
                      │ ¿Resultado      │ │ ¿Fórmula? │
                      │ OBSERVABLE?     │ │           │
                      └────────┬────────┘ └─────┬─────┘
                               │ SÍ│NO         │ SÍ
                    ┌──────────▼───▼──┐        │
                    │                 │        │
           ┌────────▼────────┐ ┌─────▼────┐   │
           │ DESENCADENADOR  │ │INFERENCIA│   │
           │ → UC Completo ⭐│ │→ FR      │   │
           └─────────────────┘ └──────────┘   │
                                               │
                                      ┌────────▼────────┐
                                      │    CÁLCULO      │
                                      │  → Paso en UC   │
                                      └─────────────────┘
                                      
           [RESTRICCIÓN se detecta por negación: 
            Tiene IF-THEN pero no es DESENCADENADOR ni INFERENCIA ni CÁLCULO]
```

---

## TABLA COMPARATIVA RÁPIDA

| Tipo | Estructura | Observable | Genera UC | Genera FR | Ejemplo |
|------|-----------|-----------|-----------|-----------|---------|
| **HECHO** | Entidad + Atributos | - | ❌ | ❌ | code_slug único |
| **RESTRICCIÓN** | Condición límite | No | ❌ | ✅ | Nivel ≥3 para críticas |
| **DESENCADENADOR** | IF-THEN temporal | ✅ Sí | ✅ | ✅ | Sesión >12 min → Notificar |
| **INFERENCIA** | IF-THEN cambio | No | ❌ | ✅ | Sesión >15 min → EXPIRADA |
| **CÁLCULO** | Fórmula | - | ❌ | ✅ | Score = (func×25)+... |

---

## EJEMPLO DE USO

**BR a clasificar:**

> "SI un permiso temporal expirará en menos de 24 horas Y tiene funciones críticas ENTONCES enviar notificación al usuario Y al admin."

**Aplicación del template:**

#### VERIFICACIÓN PASO 1: ¿Es HECHO?
☐ ¿Describe estructura? → NO (describe comportamiento)
☐ ¿Define atributos? → NO
☐ ¿NO describe comportamiento? → NO

**Resultado:** NO es HECHO

#### VERIFICACIÓN PASO 2: ¿Es DESENCADENADOR?
☑ ¿Tiene IF-THEN? → SÍ
☑ ¿Condición temporal? → SÍ (<24 horas)
☑ ¿Acción observable? → SÍ (enviar notificación)
☑ ¿Alguien RECIBE? → SÍ (usuario Y admin)

**Resultado:** ✅ ES DESENCADENADOR

#### DECISIÓN FINAL
- Tipo: DESENCADENADOR
- ✅ Genera UC completo
- Próximo paso: Aplicar Template T02 (Construcción de UC)

---

## REFERENCIAS

- **Documento fuente:** PARTE_2A_FUNDAMENTOS_IACT.md, Sección 1.2
- **Templates relacionados:**
  - T02: Construcción de UC (si es DESENCADENADOR)
  - T06: Integración de BR (si NO es DESENCADENADOR)
- **Ejemplos completos:** Ver PARTE 2A, Sección 3 (5 Patrones)

---

## NOTAS IMPORTANTES

⚠️ **Distinción crítica: DESENCADENADOR vs INFERENCIA**

La diferencia MÁS confusa es entre estos dos tipos:

- **DESENCADENADOR:** Usuario/actor RECIBE algo (mensaje, alerta, notificación)
  - Ejemplo: "Enviar alerta" → Usuario VE mensaje ✅
  
- **INFERENCIA:** Solo campo BD cambia, usuario NO ve nada
  - Ejemplo: "Marcar EXPIRADA" → Solo campo cambia ❌

**Test rápido:** ¿Si usuario mirara la pantalla, VERÍA que pasó algo?
- SÍ → DESENCADENADOR
- NO → INFERENCIA

---

**Versión:** 1.0.0  
**Última actualización:** 2026-01-08  
**Mantenido por:** Equipo IACT
