# FMEA Guide — DMAIC:Improve

Análisis de Modos de Falla y Efectos: tabla RPN, escalas de Severidad/Ocurrencia/Detección y criterio de priorización.

---

## Qué es el FMEA

El FMEA (Failure Mode and Effects Analysis) evalúa *qué podría salir mal* antes de implementar una solución en DMAIC. Su objetivo es prevenir problemas, no diagnosticarlos después.

**En DMAIC:Improve**, el FMEA se aplica a la solución seleccionada *antes del piloto* para:
- Identificar modos de falla que podrían introducir nuevos defectos
- Priorizar qué riesgos necesitan acción preventiva antes de implementar
- Reducir el riesgo del piloto antes de que ocurran los problemas

---

## Estructura de la tabla FMEA

| Campo | Descripción | Ejemplo |
|-------|-------------|---------|
| **Paso del proceso** | Actividad o paso donde podría fallar | "Asignación automática de ruta" |
| **Modo de falla** | Cómo podría fallar ese paso | "El algoritmo asigna ruta incorrecta" |
| **Efecto del fallo** | Impacto en el cliente o en el proceso siguiente | "Pedido entregado en dirección equivocada" |
| **Causa del modo de falla** | Por qué podría ocurrir el modo de falla | "Datos de dirección incompletos en el sistema" |
| **Severidad (S)** | Gravedad del efecto si ocurre | 8 (impacto en seguridad del cliente) |
| **Ocurrencia (O)** | Probabilidad de que ocurra la causa | 4 (ocurre esporádicamente) |
| **Detección (D)** | Capacidad del proceso para detectar el fallo antes de que llegue al cliente | 6 (difícil de detectar antes de la entrega) |
| **RPN** | S × O × D | 8 × 4 × 6 = 192 |
| **Acción preventiva** | Qué hacer si RPN > umbral | "Validar dirección completa antes de asignar ruta" |

---

## Escala de Severidad (S)

| Valor | Nivel | Criterio general |
|-------|-------|-----------------|
| **10** | Catastrófico | Pone en riesgo la seguridad de personas; daño irreversible; impacto regulatorio severo |
| **9** | Crítico | Fallo de seguridad o funcional que afecta al cliente sin advertencia previa |
| **8** | Muy alto | Pérdida de función principal; cliente muy insatisfecho; reclamación formal |
| **7** | Alto | Reducción significativa de funcionalidad; cliente insatisfecho |
| **6** | Moderado-alto | Funcionalidad degradada; cliente nota el problema; requiere retrabajo |
| **5** | Moderado | Pérdida de funcionalidad menor; cliente insatisfecho pero puede operar |
| **4** | Bajo-moderado | Defecto menor que la mayoría de los clientes notan; leve inconveniente |
| **3** | Bajo | Defecto menor que algunos clientes notan; mínimo impacto |
| **2** | Muy bajo | Defecto que el cliente difícilmente nota |
| **1** | Ninguno | Sin efecto perceptible para el cliente |

---

## Escala de Ocurrencia (O)

| Valor | Nivel | Frecuencia aproximada |
|-------|-------|----------------------|
| **10** | Casi seguro | > 1 de cada 2 ocurrencias (> 50%) |
| **9** | Muy alta | 1 de cada 3 (33%) |
| **8** | Alta | 1 de cada 8 (12%) |
| **7** | Moderada-alta | 1 de cada 20 (5%) |
| **6** | Moderada | 1 de cada 80 (1.25%) |
| **5** | Baja-moderada | 1 de cada 400 (0.25%) |
| **4** | Baja | 1 de cada 2,000 (0.05%) |
| **3** | Muy baja | 1 de cada 15,000 (0.007%) |
| **2** | Remota | 1 de cada 150,000 (0.0007%) |
| **1** | Casi imposible | < 1 de cada 1,500,000 |

---

## Escala de Detección (D)

> **Nota:** La escala de Detección es INVERSA — un D alto significa que es DIFÍCIL detectar el fallo.

| Valor | Nivel | Descripción de la capacidad de detección |
|-------|-------|----------------------------------------|
| **10** | Imposible | El modo de falla no puede detectarse hasta que ya llegó al cliente |
| **9** | Muy remota | Muy poca probabilidad de detectar antes de que llegue al cliente |
| **8** | Remota | Posible detectar pero improbable |
| **7** | Muy baja | La verificación existente tiene baja efectividad |
| **6** | Baja | La verificación puede detectar pero no siempre |
| **5** | Moderada | La verificación detecta en aproximadamente la mitad de los casos |
| **4** | Moderada-alta | La verificación detecta con buena probabilidad |
| **3** | Alta | La verificación tiene alta probabilidad de detectar el problema |
| **2** | Muy alta | La verificación casi siempre detecta el problema |
| **1** | Casi certeza | El modo de falla se detecta siempre antes de llegar al cliente |

---

## RPN — Risk Priority Number

```
RPN = Severidad (S) × Ocurrencia (O) × Detección (D)

Rango: 1 (mínimo) a 1,000 (máximo teórico)
```

### Criterio de priorización

| RPN | Clasificación | Acción requerida |
|-----|--------------|-----------------|
| **> 200** | 🔴 **Crítico** | Acción preventiva OBLIGATORIA antes del piloto. No implementar sin mitigar este modo de falla. |
| **100 – 200** | 🟡 **Importante** | Acción preventiva fuertemente recomendada. Evaluar si el riesgo es aceptable para el piloto. |
| **< 100** | 🟢 **Monitorear** | Incluir en el plan de monitoreo del piloto. No requiere acción preventiva previa. |

### Limitaciones del RPN

El RPN como número único puede ser engañoso. Priorizar también cuando:
- **S = 9 o 10** independientemente del RPN (riesgo de seguridad)
- **S × O > 36** (severidad alta y ocurrencia alta, aunque la detección sea buena)
- El cliente tiene tolerancia cero para ese tipo de fallo

---

## Ejemplo completo de FMEA

**Solución:** Implementar asignación automática de rutas de despacho

| Paso | Modo de falla | Efecto | Causa | S | O | D | RPN | Acción preventiva |
|------|--------------|--------|-------|---|---|---|-----|------------------|
| Recepción de orden | Datos de dirección incompletos | Ruta asignada incorrectamente | Campo de dirección no obligatorio | 7 | 5 | 6 | 210 | 🔴 Hacer campo de dirección obligatorio antes del lanzamiento |
| Asignación de ruta | Algoritmo sin actualización de tráfico en tiempo real | Ruta lenta; demora en entrega | API de tráfico sin fallback | 5 | 3 | 4 | 60 | 🟢 Monitorear en el piloto; agregar fallback en iteración 2 |
| Despacho | Tracking no se actualiza | Cliente sin información del pedido | Falla en webhook del transportista | 6 | 4 | 5 | 120 | 🟡 Implementar retry logic en el webhook antes del piloto |
| Confirmación de entrega | No se registra la entrega | Pedido figura como pendiente | Operador sin conectividad | 4 | 6 | 3 | 72 | 🟢 Agregar confirmación offline con sync posterior |

---

## Acciones preventivas por tipo de modo de falla

| Tipo de modo de falla | Acción preventiva típica |
|----------------------|-------------------------|
| Datos de entrada inválidos | Validación en el origen (formulario, API) antes de procesar |
| Fallo de sistema externo | Fallback / circuit breaker / reintentos con backoff |
| Error humano en nuevo proceso | Poka-yoke (hacer imposible el error) + checklist visual |
| Configuración incorrecta | Validación de configuración al iniciar + alertas |
| Sobrecarga / capacidad | Prueba de carga antes del rollout + límites de rate |
| Regresión en proceso existente | Tests automatizados que cubren el comportamiento anterior |

---

## Cuándo el FMEA es obligatorio vs opcional

| Situación | FMEA |
|-----------|------|
| Solución afecta proceso crítico (producción, pagos, seguridad) | ✅ Obligatorio |
| RPN inicial estimado > 100 en cualquier modo de falla | ✅ Obligatorio |
| Solución se desplegará al 100% sin piloto | ✅ Obligatorio |
| Solución de bajo riesgo, proceso no crítico, piloto pequeño | ⚠️ Opcional — hacer análisis mental y documentar |
| Solución es rollback de un cambio anterior (deshace algo) | ❌ No necesario generalmente |
