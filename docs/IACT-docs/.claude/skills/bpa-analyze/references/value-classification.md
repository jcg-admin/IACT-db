# Value Classification — VA / BVA / NVA

Guía de clasificación de actividades como Value Added, Business Value Added, y Non-Value Added.

---

## Las tres categorías

### VA — Value Added (Valor Agregado)

**Definición:** Una actividad es VA si cumple los tres criterios simultáneamente:
1. El cliente la valora — estaría dispuesto a pagar por ella si supiera que existe
2. Transforma el producto o servicio — lo hace avanzar hacia el output final
3. Se hace correctamente la primera vez — sin retrabajo ni correcciones

**Pregunta de clasificación:** *"Si el cliente pudiera ver este paso, ¿diría 'gracias por hacerlo'?"*

**Ejemplos VA:**
- Evaluar la solicitud de crédito del cliente (transforma la solicitud en una decisión)
- Ensamblar el producto (agrega valor físico)
- Diseñar la solución técnica para el cliente (crea el entregable)
- Entregar el pedido al cliente (completa la transacción)

---

### BVA — Business Value Added (Valor Agregado para el Negocio)

**Definición:** Actividades que el negocio necesita pero el cliente no pagaría directamente por ellas. Son necesarias para operar legalmente o mantener controles mínimos.

**Criterios BVA:**
- Requerido por ley, regulación o normativa interna
- Necesario para controles de auditoría o compliance
- Protege al negocio de riesgo legal o financiero
- Procesa o documenta el trabajo VA (contabilidad, facturación)

**Pregunta de clasificación:** *"¿Si no lo hiciéramos, violaríamos una ley, regulación o perderíamos un control de negocio crítico?"*

**Ejemplos BVA:**
- Registro de la transacción en el sistema contable (compliance)
- Aprobación de crédito por el Comité (control interno)
- Firma de contrato antes de iniciar el servicio (protección legal)
- Reporte mensual al regulador (requisito normativo)

**CLAVE sobre BVA:** La categoría BVA es la más sobreutilizada.
- *"Siempre lo hemos hecho así"* no hace BVA a una actividad
- *"El manager lo quiere así"* no hace BVA a una actividad
- BVA debe estar justificado por una regulación, política o riesgo concreto

**Pregunta para verificar BVA:** *"¿A qué regulación, política o riesgo específico responde esta actividad?"*
- Si no hay respuesta clara → reclasificar como NVA

---

### NVA — Non-Value Added (Sin Valor Agregado / Desperdicio)

**Definición:** Actividades que ni el cliente valora ni el negocio realmente necesita. Son desperdicio puro que debe eliminarse o reducirse.

**Pregunta de clasificación:** *"¿Qué pasaría si simplemente no lo hiciéramos?"*
- Si la respuesta es "nada, realmente" → NVA, eliminar

---

## Tipos de desperdicio NVA — Lean para procesos de negocio

Basado en los 7 desperdicios de Lean (TIMWOOD adaptado a servicios):

### 1. Espera (Waiting)
**Definición:** Tiempo en que el trabajo está en cola, esperando que alguien lo atienda.

**Señales:**
- "Está en la bandeja de entrada del supervisor desde el lunes"
- "Esperamos que el otro departamento envíe la información"
- "El sistema corre el batch nocturno"

**Ejemplos:** Solicitud esperando aprobación 3 días · Formulario esperando firma del gerente · Pedido esperando confirmación de inventario

**Intervención típica:** Notificaciones automáticas · SLAs internos con escalada · Delegación de aprobación

---

### 2. Retrabajo (Rework / Defects)
**Definición:** Actividad que se repite porque el resultado inicial tuvo errores o fue rechazado.

**Señales:**
- "Con frecuencia nos mandan de vuelta el formulario porque falta algo"
- "El 20% de las solicitudes requiere corrección"
- "Revisamos varias veces antes de enviar"

**Ejemplos:** Corrección de errores en documentos · Re-procesamiento de pedidos por datos incorrectos · Revisión repetida de informes

**Intervención típica:** Validación en el punto de entrada · Checklist de completitud · Estandarización del formato

---

### 3. Sobreprocessing (Over-processing)
**Definición:** Más trabajo del que el cliente necesita o del que el proceso requiere.

**Señales:**
- "Pasamos por 5 niveles de aprobación para una compra de $50"
- "Generamos un reporte de 40 páginas que nadie lee completo"
- "Hacemos la verificación dos veces, una por cada equipo"

**Ejemplos:** Múltiples aprobaciones en cadena · Formatos excesivamente detallados · Verificaciones duplicadas entre departamentos

**Intervención típica:** Simplificar la cadena de aprobación · Reducir el nivel de detalle · Eliminar verificaciones duplicadas

---

### 4. Transporte innecesario (Unnecessary Transport / Handoffs)
**Definición:** Movimiento de información, documentos o trabajo entre personas o sistemas sin agregar valor.

**Señales:**
- "Enviamos el formulario por email, lo imprimen, lo firman, lo escanean y lo envían de vuelta"
- "La información pasa por 4 personas antes de llegar a quien la procesa"
- "Tenemos que recutar la información de 3 sistemas diferentes"

**Ejemplos:** Email → impresión → firma → escaneo · Datos que se re-ingresan manualmente entre sistemas · Handoffs entre departamentos que podrían estar en el mismo equipo

**Intervención típica:** Digitalización · Firma electrónica · Integración de sistemas · Reducción de handoffs

---

### 5. Inventario (Inventory / Work in Progress)
**Definición:** Acumulación de trabajo esperando ser procesado (cola de pendientes).

**Señales:**
- "Tenemos 300 solicitudes en la cola esperando revisión"
- "El trabajo se acumula los martes porque el encargado llega tarde"
- "Al final del mes hay un cuello de botella por el volumen de cierres"

**Ejemplos:** Cola de aprobaciones sin procesar · Facturas pendientes de envío · Solicitudes sin clasificar

**Intervención típica:** Reducir el batch size · Distribuir la carga · Nivelar el flujo de trabajo

---

### 6. Movimiento innecesario (Unnecessary Motion)
**Definición:** Búsqueda manual de información, cambio entre sistemas, navegación innecesaria.

**Señales:**
- "Para cada solicitud tenemos que buscar en 4 sistemas diferentes"
- "No tenemos acceso rápido al historial del cliente, hay que pedírselo a otro equipo"
- "El formulario no está donde debería estar, hay que buscarlo en el directorio"

**Ejemplos:** Búsqueda manual de archivos · Copy-paste entre sistemas · Re-ingreso de datos ya capturados

**Intervención típica:** Dashboard unificado · Integración de sistemas · Acceso directo a información contextual

---

### 7. Sobreproducción (Overproduction)
**Definición:** Producir más de lo que el cliente necesita o antes de que lo necesite.

**Señales:**
- "Generamos el reporte semanal aunque nadie lo revisa hasta fin de mes"
- "Preparamos todo el expediente completo para solicitudes que el 60% se rechaza en la primera revisión"
- "Hacemos proyecciones a 5 años cuando las decisiones se toman a 1 año"

**Ejemplos:** Reportes que nadie usa · Procesamiento anticipado de solicitudes que pueden cancelarse · Preparación de documentos completos antes de la aprobación inicial

**Intervención típica:** Producir bajo demanda · Eliminar reportes no usados · Proceso de filtro rápido antes de trabajo detallado

---

## Guía de clasificación rápida

```
¿Transforma directamente el producto/servicio para el cliente?
    ├─ Sí + cliente pagaría + primera vez correcto → VA
    └─ No → ¿Es requerido por ley, regulación, o control de negocio crítico?
                ├─ Sí + con justificación concreta → BVA
                │       └─ ¿Se puede simplificar? → BVA simplificable
                └─ No → NVA → identificar tipo (espera/retrabajo/etc.) → eliminar
```

---

## Tabla de ejemplos por industria

| Industria | Actividad | Clasificación | Razonamiento |
|-----------|-----------|---------------|-------------|
| Banca — aprobación de crédito | Evaluar riesgo crediticio | VA | Transforma solicitud en decisión; el cliente lo valora |
| Banca — aprobación de crédito | Registrar en sistema regulatorio | BVA | Requerido por regulación bancaria; el cliente no lo valora |
| Banca — aprobación de crédito | Esperar firma del gerente (72h) | NVA (Espera) | El gerente podría delegar o firmar digitalmente en minutos |
| Retail — fulfillment | Preparar y empacar el pedido | VA | Transforma el pedido en entrega; el cliente lo valora |
| Retail — fulfillment | Facturar (generar e-invoice) | BVA | Requerido legalmente; el cliente no paga por el proceso |
| Retail — fulfillment | Re-ingresar dirección en 2 sistemas | NVA (Movimiento) | Los sistemas deberían estar integrados |
| RRHH — onboarding | Orientación y formación inicial | VA | Agrega valor al empleado nuevo; mejora retención |
| RRHH — onboarding | Firma de contrato y NDA | BVA | Requerido legalmente |
| RRHH — onboarding | Esperar 2 semanas para dar acceso a sistemas | NVA (Espera) | El proceso de TI puede anticiparse |
