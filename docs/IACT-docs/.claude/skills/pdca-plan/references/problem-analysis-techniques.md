# Problem Analysis Techniques — PDCA:Plan

Guías paso a paso para las técnicas de análisis de causa raíz más usadas en el paso Plan.

---

## 5 Whys

**Cuándo usar:** síntoma claro, equipo pequeño, problema con cadena causal lineal.

**Paso a paso:**
1. Escribir el síntoma observable como Problem Statement (con datos)
2. Preguntar "¿Por qué ocurre esto?" — responder con evidencia, no suposición
3. Tomar esa respuesta y preguntar "¿Por qué ocurre eso?"
4. Repetir hasta llegar a una causa que el equipo puede controlar (típicamente 3-7 iteraciones)
5. Verificar la cadena leyendo de abajo hacia arriba: "X causa Y, Y causa Z..."

**Template:**
```
Síntoma: [Problem Statement]
  ¿Por qué? → [causa 1]
    ¿Por qué? → [causa 2]
      ¿Por qué? → [causa 3]
        ¿Por qué? → [causa 4]
          ¿Por qué? → [causa raíz]
```

**Señales de que la cadena es inválida:**
- Una respuesta es "porque alguien se equivocó" — los errores humanos son síntomas, no causas raíz
- La cadena llega a "falta de presupuesto" o "falta de tiempo" — son restricciones, no causas
- No se puede verificar con datos la relación causa-efecto entre dos eslabones

---

## Fishbone / Ishikawa (Diagrama de causa y efecto)

**Cuándo usar:** múltiples causas potenciales, equipo necesita brainstorm estructurado, problema con causas en distintas dimensiones.

**Categorías 6M (manufactura / procesos operacionales):**

| Categoría | Qué incluye | Preguntas guía |
|-----------|-------------|----------------|
| **Máquina** | Equipos, herramientas, software, infraestructura | ¿El equipo tiene fallas? ¿Está calibrado? ¿Es el adecuado? |
| **Método** | Procesos, procedimientos, instrucciones de trabajo | ¿El proceso está documentado? ¿Se sigue? ¿Es el correcto? |
| **Material** | Insumos, datos, información de entrada | ¿La calidad de los inputs es consistente? ¿Hay variabilidad? |
| **Mano de obra** | Personas, habilidades, conocimiento, motivación | ¿El equipo tiene la capacitación necesaria? ¿Hay rotación? |
| **Medio ambiente** | Entorno físico, condiciones, contexto | ¿Las condiciones del entorno afectan el proceso? |
| **Medición** | Métricas, instrumentos de medición, sistemas de reporte | ¿Cómo se mide? ¿El sistema de medición es confiable? |

**Categorías 4S (servicios / software):**

| Categoría | Qué incluye |
|-----------|-------------|
| **Surroundings** | Entorno físico y digital |
| **Suppliers** | Proveedores externos, dependencias, APIs |
| **Systems** | Software, infraestructura, integraciones |
| **Skills** | Capacidades del equipo |

**Paso a paso:**
1. Escribir el efecto (Problem Statement) en el extremo derecho de la "espina"
2. Dibujar las ramas principales (una por categoría)
3. Para cada categoría, listar causas potenciales como ramas secundarias
4. Votar o priorizar las causas más probables según datos disponibles
5. Investigar las causas priorizadas antes de fijar la hipótesis

---

## Pareto 80/20

**Cuándo usar:** hay muchos defectos, tipos de error o causas posibles; necesitas identificar las pocas vitales.

**Principio:** ~80% del efecto es producido por ~20% de las causas. Enfocar el Plan en esas causas vitales.

**Paso a paso:**
1. **Recopilar datos:** listar todas las categorías de defectos/causas con su frecuencia (conteo o impacto en $)
2. **Ordenar:** de mayor a menor frecuencia
3. **Calcular % acumulado:** `% acumulado[i] = suma(frecuencias 1..i) / total × 100`
4. **Construir el gráfico:** barras ordenadas (frecuencia) + línea de % acumulado
5. **Identificar el "corte 80%":** las categorías que suman hasta el 80% son las vitales

**Tabla de construcción:**

| Categoría | Frecuencia | % del total | % acumulado |
|-----------|------------|-------------|-------------|
| Defecto A | 45 | 45% | 45% |
| Defecto B | 28 | 28% | 73% |
| Defecto C | 12 | 12% | 85% ← corte 80% |
| Defecto D | 9 | 9% | 94% |
| Otros | 6 | 6% | 100% |

**Interpretación:** El Plan debe atacar Defecto A y B (73% del problema con 2 de 5 causas).

**Trampa común:** usar % de ocurrencia cuando el impacto real es distinto. Si Defecto D ocurre poco pero cuesta 10× más, Pareto por frecuencia puede ser engañoso. Calcular también Pareto por impacto ($, tiempo, riesgo).

---

## IS / IS NOT

**Cuándo usar:** el problema es difuso, el equipo tiene visiones distintas, o se necesita delimitar con precisión antes de ir a 5-Whys o Fishbone.

| Dimensión | IS | IS NOT |
|-----------|-----|--------|
| **Qué** | ¿Qué exactamente está fallando? | ¿Qué no está fallando aunque podría? |
| **Dónde** | ¿En qué parte del proceso/sistema? | ¿Dónde no ocurre el problema? |
| **Cuándo** | ¿Desde cuándo? ¿En qué condiciones? | ¿Cuándo no ocurre? |
| **Magnitud** | ¿Cuánto / cuántos / con qué frecuencia? | ¿Qué no está siendo afectado? |

**Regla de oro:** La columna IS NOT es igual de importante que IS. Las diferencias entre "donde sí ocurre" y "donde no ocurre" frecuentemente revelan la causa.

---

## 5W2H

**Cuándo usar:** complemento a IS/IS NOT cuando se necesita el contexto completo del problema incluyendo impacto y recursos.

| Pregunta | Contenido |
|----------|-----------|
| **Who** | ¿Quién está involucrado? ¿A quién afecta? |
| **What** | ¿Qué está ocurriendo exactamente? |
| **Where** | ¿Dónde ocurre (proceso, sistema, ubicación)? |
| **When** | ¿Cuándo ocurre? ¿Desde cuándo? ¿Con qué frecuencia? |
| **Why** | ¿Por qué es un problema? (impacto en negocio/cliente) |
| **How** | ¿Cómo se manifiesta? ¿Cómo se detecta? |
| **How much** | ¿Cuánto cuesta? ¿Cuántos afectados? ¿Cuál es la magnitud? |
