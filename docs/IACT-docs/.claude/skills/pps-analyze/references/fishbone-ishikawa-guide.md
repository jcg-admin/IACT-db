# Guía del Diagrama Fishbone (Ishikawa) — PS8

> Fuente base: Cause-and-effect diagram — /tmp/references/topics/topics/cause-and-effect-diagram/index.md
> Ampliado con contexto TBP, categorías 6M vs 4P y uso en pps:analyze.

---

## ¿Qué es el Diagrama Fishbone?

El Diagrama de Causa y Efecto, también conocido como Diagrama Ishikawa o Diagrama Fishbone, es una herramienta visual para analizar y resolver problemas. La forma del diagrama se asemeja a un esqueleto de pez: el problema (efecto) se coloca en la cabeza, y las causas potenciales se ramifican a lo largo de la espina.

Fue desarrollado por el experto en control de calidad **Kaoru Ishikawa** en la década de 1960 como parte del movimiento de calidad total en Japón, y se convirtió en una de las "Siete Herramientas Básicas de Calidad" (Q7 Tools). Es parte fundamental del Toyota Production System y del TBP.

**Propósito en pps:analyze**: exploración sistemática y amplia de causas potenciales antes de comprometerse con una hipótesis específica. El Fishbone evita el error de enfocarse en la primera causa que se ocurre y pasar por alto causas más profundas o de categorías menos obvias.

---

## Las 6M — categorías para manufactura e ingeniería

Las 6M son las categorías estándar del Diagrama Ishikawa para procesos de manufactura, operaciones físicas e ingeniería:

| Categoría | Inglés | Qué incluye | Preguntas guía |
|-----------|--------|-------------|---------------|
| **Mano de obra** | Manpower | Habilidades, capacitación, motivación, comportamiento, fatiga | ¿El personal tiene el conocimiento necesario? ¿Varía el problema entre personas? |
| **Métodos** | Methods | Procesos, procedimientos, instrucciones de trabajo, estándares | ¿El proceso está documentado y se sigue? ¿El método es adecuado para este caso? |
| **Máquinas** | Machines | Equipos, herramientas, software, infraestructura, calibración | ¿Las herramientas funcionan correctamente? ¿Hay fallas recurrentes? |
| **Materiales** | Materials | Insumos, datos de entrada, dependencias, proveedores | ¿Los inputs tienen la calidad requerida? ¿Hay variación por proveedor? |
| **Mediciones** | Measurements | Sistemas de medición, calibración, métricas, precisión | ¿Las mediciones son confiables? ¿Hay sesgo en cómo se mide? |
| **Madre naturaleza** | Mother Nature | Condiciones ambientales, temperatura, humedad, carga del sistema, factores externos | ¿El entorno o condiciones externas influyen en el problema? |

---

## Las 4P — categorías para servicios y software

Para procesos de software, servicios y trabajo de conocimiento, las 4P son más adecuadas:

| Categoría | Qué incluye | Preguntas guía |
|-----------|-------------|---------------|
| **Personas** (People) | Habilidades, capacitación, cultura, comunicación, motivación | ¿El equipo tiene el conocimiento y el contexto necesario? |
| **Procesos** (Processes) | Flujos de trabajo, estándares, procedimientos, automatización | ¿El proceso está bien definido y se sigue? ¿Hay pasos manuales que deberían automatizarse? |
| **Políticas** (Policies) | Reglas, restricciones, gobernanza, regulaciones, acuerdos | ¿Hay políticas que crean fricción o contradicciones? |
| **Tecnología** (Plant/Technology) | Sistemas, infraestructura, herramientas, deuda técnica | ¿La tecnología es adecuada y funciona correctamente? |

---

## Cómo construir el Fishbone — proceso paso a paso

1. **Definir el efecto** — colocar el Problem Statement exacto en la "cabeza del pez" (derecha del diagrama)

2. **Elegir las categorías** — 6M para manufactura/operaciones, 4P para software/servicios

3. **Brainstorming por categoría** — para cada categoría, generar causas potenciales sin filtrar:
   - ¿Qué en [categoría] podría causar este problema?
   - Generar al menos 3-5 causas por categoría antes de empezar a filtrar
   - Incluir causas aunque parezcan improbables — el Fishbone es exploración, no certeza

4. **Profundizar con mini-5 Whys** — para causas prometedoras, agregar sub-ramas preguntando "¿por qué?" una o dos veces más

5. **Priorizar causas candidatas** — marcar las más probables basándose en:
   - Conocimiento del proceso de quienes participaron
   - Correlación con cuándo y dónde ocurre el problema
   - Disponibilidad de datos para verificar

6. **Seleccionar para análisis 5 Whys** — las causas priorizadas se exploran con la técnica 5 Whys para llegar a la causa sistémica

---

## El Fishbone como herramienta de colaboración

Una fortaleza del Fishbone es que estructura la participación multidisciplinaria:

- Permite que personas de diferentes áreas contribuyan desde su perspectiva
- Evita que las causas de una sola categoría dominen la conversación
- Hace visible que el problema puede tener múltiples causas raíz
- Documenta tanto las causas identificadas como las descartadas

**Quiénes deben participar en el Fishbone:**
- Quienes ejecutan el proceso directamente (mejor conocimiento práctico)
- Quienes reciben el output del proceso (perspectiva de efecto)
- Expertos técnicos relevantes para las categorías de mayor sospecha
- Facilitador neutral que asegure cobertura de todas las categorías

---

## Conexión con el ciclo PS8

```
pps:clarify → Problem Statement + datos del Gemba
                          ↓
pps:analyze → Fishbone (exploración amplia de hipótesis)
                          ↓
             5 Whys por causa priorizada (profundización)
                          ↓
             Confirmación con datos (Gemba + históricos)
                          ↓
             Causa raíz confirmada → A3 Sección 4
                          ↓
pps:countermeasures → Contramedida por causa raíz
```

El Fishbone sin 5 Whys solo llega al nivel de "causa posible". El 5 Whys sin Fishbone puede enfocarse en la primera hipótesis y perder causas más profundas. Usados juntos son el núcleo del análisis TBP.
