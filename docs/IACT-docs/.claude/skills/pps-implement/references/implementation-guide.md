# Guía de Implementación de Contramedidas — PS8

> Referencia para el Step 6 de Toyota TBP: "See Countermeasures Through".

---

## El principio "See It Through"

"See countermeasures through" no es solo ejecutar tareas de un checklist. Es un compromiso de llevar cada contramedida a completitud real y verificar su efecto:

**Completitud**: ejecutar la contramedida según fue diseñada — no una versión reducida ni aproximada. Si la contramedida no puede ejecutarse como fue diseñada, la acción correcta es escalar o rediseñarla (regresando a pps:countermeasures), no implementar una versión debilitada y asumir que tendrá efecto similar.

**Observación**: el Gemba continúa durante la implementación. No implementar a distancia — observar si el proceso responde como se esperaba.

**Ajuste fundamentado**: si algo no funciona, ajustar con datos, no con intuición. Documentar qué se observó, qué se cambió y por qué.

---

## Gemba durante la implementación

El Go-and-See no termina en pps:clarify. Durante pps:implement:

| Cuándo observar | Qué observar |
|----------------|-------------|
| Inmediatamente después de implementar una contramedida | ¿El proceso responde como se esperaba? ¿Hay resistencia o fricción no anticipada? |
| Primera semana post-implementación | ¿Se mantiene el efecto? ¿Hay variabilidad por persona, turno, condición? |
| Cuando los datos muestran anomalía | ¿Qué está pasando realmente? ¿La contramedida se está ejecutando como fue diseñada? |

---

## Manejo de desviaciones

### La contramedida se ejecutó pero no tiene el efecto esperado

Árbol de decisiones:

1. **¿Se ejecutó completamente según el diseño?**
   - No → completar la ejecución antes de evaluar el efecto
   - Sí → continuar al punto 2

2. **¿Hay suficientes datos para evaluar?** (¿transcurrió el período mínimo de medición?)
   - No → esperar más datos antes de concluir
   - Sí → continuar al punto 3

3. **¿El diseño de la contramedida ataca correctamente la causa raíz?**
   - Sí pero sin efecto → regresar a pps:analyze (posible causa raíz adicional no identificada)
   - Posiblemente no → regresar a pps:countermeasures para rediseñar

### La contramedida no puede ejecutarse (bloqueador)

1. Documentar el bloqueador con descripción específica
2. Escalar al responsable con autoridad para resolver
3. Actualizar el Action Plan con el nuevo timeline
4. Evaluar si hay una contramedida alternativa de respaldo (de la evaluación en pps:countermeasures)

### Se necesita ajustar la contramedida durante la ejecución

Si la contramedida requiere modificación (por obstáculos imprevistos, nueva información, feedback del proceso):

1. Documentar el ajuste: qué se cambió, por qué, quién decidió
2. Evaluar si el ajuste reduce el impacto esperado → si es significativo, revisar con el equipo
3. Actualizar el Implementation Log con la descripción del ajuste
4. Si el ajuste es mayor, regresar a pps:countermeasures para re-evaluar

---

## Recolección de datos durante la implementación

**¿Por qué medir durante la implementación?**

Los datos del período de implementación son parte del análisis de efecto. No esperar al final:
- Detectan si algo va fundamentalmente mal antes de que se acumule
- Proveen el contexto de "durante el cambio" para el análisis de pps:evaluate
- Permiten ajustes tempranos basados en evidencia

**Qué medir:**
- La métrica principal definida en pps:target — lectura semanal mínima
- Las métricas secundarias — para detectar efectos secundarios no anticipados
- El estado de cada contramedida — ¿se está ejecutando como fue diseñada?

**Advertencia sobre los datos preliminares:**
Los datos durante la implementación pueden mostrar una mejora artificial (efecto Hawthorne: el proceso mejora porque sabe que está siendo observado). La evaluación formal de efecto en pps:evaluate debe incluir un período post-implementación sin observación intensiva.

---

## Comunicación durante la implementación

**Por qué comunicar activamente:**

Los cambios en el proceso sin comunicación generan resistencia, sorpresa y comportamiento inconsistente — lo que invalida los datos de efecto. La implementación de contramedidas TBP debe ser transparente:

| ¿A quién? | ¿Qué comunicar? | ¿Cuándo? |
|----------|-----------------|---------|
| Equipo que ejecuta el proceso | Qué va a cambiar, por qué, cuándo | Antes de implementar |
| Afectados downstream | Cómo puede cambiar lo que reciben del proceso | Antes de implementar |
| Dueño del proceso | Avance vs Action Plan, bloqueadores | Semanalmente |
| Sponsor | Tendencia de métricas, desviaciones del plan | Cada 2 semanas |

**Formato de actualización de avance:**
- Estado de cada contramedida (Pendiente / En curso / Completado / Bloqueado)
- Datos preliminares de la métrica principal
- Bloqueadores activos y acción en curso para resolverlos
- Próximas contramedidas a ejecutar en las siguientes 2 semanas
