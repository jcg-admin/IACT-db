---
id: RN-[DOMINIO]-[###]
tipo: regla_negocio
subtipo: calculo
categoria: [DOMINIO]
version: 1.0.0
fecha: [YYYY-MM-DD]
autor: [NOMBRE_AUTOR]
estado: [borrador|en_revision|aprobado|obsoleto]
---

# RN-[DOMINIO]-[###]: [Título del Cálculo]

<!--
INSTRUCCIONES:
- Reemplace [DOMINIO] con: BACK, FRONT, DEVOPS, QA, AI, GOB
- Reemplace [###] con número secuencial: 001, 002, 003, etc.
- El título debe describir qué se calcula
- Los cálculos transforman datos existentes en nuevos datos mediante fórmulas matemáticas
-->

## Tipo

Cálculo Computacional

## Declaración

<!--
Describa en lenguaje natural qué se calcula y para qué.

Ejemplos:
- "El cargo de envío terrestre nacional por una orden que pesa más de 2 kg es de $40.75 + $0.12 por gramo de fracción adicional"
- "El precio total de una orden se calcula como: suma de artículos - descuentos + impuestos + envío + seguro opcional"
- "El descuento por volumen se aplica según la cantidad comprada en rangos definidos"
-->

[Describa aquí en lenguaje natural qué se calcula]

## Fórmula

<!--
Escriba la fórmula matemática de manera clara y sin ambigüedades.
Use notación matemática estándar.
Si la fórmula es compleja, divídala en pasos.
-->

```
[Escriba aquí la fórmula matemática]

Ejemplo simple:
Total = Subtotal × (1 + IVA) + Envío

Ejemplo con pasos:
Paso 1: Subtotal = Suma(PrecioArticulo[i] × Cantidad[i]) para todo i
Paso 2: Descuento = Subtotal × PorcentajeDescuento
Paso 3: SubtotalConDescuento = Subtotal - Descuento
Paso 4: Impuestos = SubtotalConDescuento × 0.16
Paso 5: Total = SubtotalConDescuento + Impuestos + Envío + SeguroOpcional
```

## Variables de Entrada

<!--
Liste todas las variables que se necesitan para el cálculo.
Para cada variable indique: descripción, tipo de dato, unidades, rango válido, origen.
-->

| Variable | Descripción | Tipo | Unidades | Rango Válido | Origen |
|----------|-------------|------|----------|--------------|--------|
| [Variable1] | [Descripción] | [número, decimal, entero] | [unidades] | [min-max] | [de dónde viene] |
| [Variable2] | [Descripción] | [número, decimal, entero] | [unidades] | [min-max] | [de dónde viene] |
| [Variable3] | [Descripción] | [número, decimal, entero] | [unidades] | [min-max] | [de dónde viene] |

<!--
Ejemplo:
| Variable | Descripción | Tipo | Unidades | Rango Válido | Origen |
|----------|-------------|------|----------|--------------|--------|
| PesoTotal | Peso total de la orden | Decimal | gramos | > 0 | Suma de pesos de artículos |
| PesoBase | Peso incluido en tarifa base | Entero | gramos | 2000 | Constante de política |
| TarifaBase | Costo base de envío | Decimal | pesos MXN | 40.75 | Tabla de tarifas |
| TarifaAdicional | Costo por gramo adicional | Decimal | pesos/gramo | 0.12 | Tabla de tarifas |
-->

## Variables de Salida

<!--
Liste el resultado del cálculo.
-->

| Variable | Descripción | Tipo | Unidades | Rango Esperado | Uso |
|----------|-------------|------|----------|----------------|-----|
| [Resultado] | [Descripción del resultado] | [tipo] | [unidades] | [min-max esperado] | [para qué se usa] |

<!--
Ejemplo:
| Variable | Descripción | Tipo | Unidades | Rango Esperado | Uso |
|----------|-------------|------|----------|----------------|-----|
| CostoEnvio | Costo total de envío | Decimal | pesos MXN | 40.75 - 10000 | Se suma al precio total de orden |
-->

## Constantes

<!--
Liste todas las constantes usadas en la fórmula.
-->

| Constante | Valor | Unidades | Origen | Frecuencia de Cambio |
|-----------|-------|----------|--------|----------------------|
| [Constante1] | [valor] | [unidades] | [de dónde viene] | [qué tan seguido cambia] |
| [Constante2] | [valor] | [unidades] | [de dónde viene] | [qué tan seguido cambia] |

<!--
Ejemplo:
| Constante | Valor | Unidades | Origen | Frecuencia de Cambio |
|-----------|-------|----------|--------|----------------------|
| IVA | 0.16 | porcentaje | Ley del IVA Art. 1 | Rara vez (requiere cambio legal) |
| PesoBase | 2000 | gramos | Política interna de envíos | Anual |
| TarifaBase | 40.75 | pesos MXN | Contrato con paquetería | Semestral |
-->

## Tabla de Valores

<!--
OPCIONAL: Si el cálculo se basa en rangos (ej: descuentos por volumen, tarifas por peso),
incluya una tabla estructurada.
Elimine esta sección si no aplica.
-->

**Nombre de la tabla**: [Descripción de qué representa la tabla]

| Rango | Condición | Valor/Fórmula |
|-------|-----------|---------------|
| [Rango 1] | [Condición] | [Valor o fórmula a aplicar] |
| [Rango 2] | [Condición] | [Valor o fórmula a aplicar] |
| [Rango 3] | [Condición] | [Valor o fórmula a aplicar] |

<!--
Ejemplo: Descuentos por Volumen
| Rango | Cantidad Compra | Porcentaje Descuento |
|-------|-----------------|----------------------|
| DISC-1 | 1 - 5 | 0% |
| DISC-2 | 6 - 10 | 10% |
| DISC-3 | 11 - 20 | 20% |
| DISC-4 | 21 o más | 30% |

Ejemplo: Tarifas de Envío por Peso
| Rango | Peso (kg) | Fórmula |
|-------|-----------|---------|
| PESO-1 | 0 - 2 | 40.75 |
| PESO-2 | > 2 | 40.75 + (Peso - 2000) × 0.12 |
-->

## Ejemplo de Cálculo

<!--
OBLIGATORIO: Proporcione al menos un ejemplo numérico concreto.
Muestre paso a paso cómo se aplica la fórmula con valores reales.
Esto elimina ambigüedades.
-->

**Escenario**: [Describa el escenario]

**Valores de entrada**:
- [Variable1] = [valor]
- [Variable2] = [valor]
- [Variable3] = [valor]

**Aplicación de la fórmula**:
```
[Muestre paso a paso el cálculo con los valores específicos]

Ejemplo:
Paso 1: Subtotal = (100 × 2) + (50 × 3) = 200 + 150 = 350
Paso 2: Descuento = 350 × 0.10 = 35 (10% por volumen)
Paso 3: SubtotalConDescuento = 350 - 35 = 315
Paso 4: Impuestos = 315 × 0.16 = 50.40
Paso 5: Total = 315 + 50.40 + 40.75 + 0 = 406.15
```

**Resultado**: [valor final] [unidades]

<!-- Agregue más ejemplos si es necesario para cubrir diferentes rangos o casos -->

## Reglas de Redondeo

<!--
Especifique cómo se redondean los resultados.
Esto es CRÍTICO para evitar discrepancias.
-->

**Precisión decimal**: [número de decimales]

**Método de redondeo**: [Redondeo estándar | Redondeo hacia arriba | Redondeo hacia abajo | Truncamiento]

**Aplicación**: [En qué puntos del cálculo se redondea]

<!--
Ejemplos:
- "Todos los montos monetarios se redondean a 2 decimales usando redondeo estándar (0.5 redondea hacia arriba)"
- "Los porcentajes se calculan con 4 decimales y se redondean al final a 2 decimales"
- "Los pesos se redondean al entero más cercano (gramos se eliminan)"
-->

## Fuente de la Fórmula

<!--
Indique de dónde proviene esta fórmula.
Esto es importante para validación y auditorías.
-->

**Origen**: [Ley | Regulación | Política Interna | Estándar | Contrato | Definición del Negocio]

**Detalle**: [Nombre específico del documento, artículo, cláusula]

**Fecha de vigencia**: [Desde cuándo aplica esta fórmula]

**Referencia**: [URL, documento, página específica]

<!--
Ejemplo:
Origen: Ley del Impuesto al Valor Agregado (IVA)
Detalle: Artículo 1 - Tasa general del 16%
Fecha de vigencia: 2025-01-01
Referencia: http://www.diputados.gob.mx/LeyesBiblio/pdf/77_091219.pdf
-->

## Frecuencia de Actualización

<!--
¿Qué tan frecuentemente cambia esta fórmula o sus constantes?
¿Quién tiene autoridad para cambiarla?
-->

**Frecuencia de cambio**: [Nunca | Rara vez | Anual | Semestral | Trimestral | Mensual | Variable]

**Responsable de actualización**: [Rol o persona responsable]

**Proceso de cambio**: [Cómo se aprueba y documenta un cambio]

**Notificación**: [A quién se notifica cuando cambia]

## Validación del Cálculo

<!--
OPCIONAL: ¿Cómo se valida que el cálculo es correcto?
¿Hay casos de prueba específicos?
-->

**Casos de prueba obligatorios**:
1. [Caso de prueba 1]: [Entrada] → [Salida esperada]
2. [Caso de prueba 2]: [Entrada] → [Salida esperada]

**Validación cruzada**: [Si hay forma de validar el resultado contra otro sistema o método]

## Impacto en Requisitos

<!--
Liste los requisitos de otros niveles que son influenciados por este cálculo.
-->

**Requerimientos de Negocio**:
- [RNEG-DOMINIO-###]: [Breve descripción]

**Requerimientos de Usuario**:
- [UC-DOMINIO-###]: [Nombre del caso de uso]

**Requisitos Funcionales**:
- [RF-DOMINIO-###]: [Breve descripción - probablemente el RF que implementa este cálculo]

**Atributos de Calidad**:
- [RNF-DOMINIO-###]: [Breve descripción - ej: precisión, rendimiento]

## Notas Adicionales

<!--
OPCIONAL: Agregue cualquier información adicional relevante.
Consideraciones especiales, casos extremos, limitaciones.
-->

[Notas adicionales, observaciones, consideraciones especiales]

## Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | [YYYY-MM-DD] | [Autor] | Versión inicial |

<!-- Agregue nuevas filas para cambios posteriores -->
