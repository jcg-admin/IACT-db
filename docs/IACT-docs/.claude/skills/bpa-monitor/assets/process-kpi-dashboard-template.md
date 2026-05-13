# Process KPI Dashboard — Template

```yml
created_at: [timestamp]
project: [nombre del proyecto]
work_package: [wp-id]
phase: bpa:monitor
author: [nombre]
status: Borrador
```

---

## Información del dashboard

| Campo | Valor |
|-------|-------|
| **Proceso monitoreado** | [nombre del proceso] |
| **Fecha de Go-Live** | [YYYY-MM-DD] |
| **Process Owner** | [nombre + cargo] |
| **Responsable del dashboard** | [nombre] |
| **Frecuencia de actualización** | Semanal / Mensual |
| **Último update** | [YYYY-MM-DD] |

---

## KPI Dashboard

| KPI | Baseline (As-Is) | Target (To-Be) | Current | Trend | Owner | Action |
|-----|-----------------|---------------|---------|-------|-------|--------|
| **Tiempo de ciclo total** | [X días] | [Y días] | [Z días] | ↓ Mejorando / → Estable / ↑ Empeorando | [Nombre] | [Ninguna / Investigar / Escalar] |
| **Tasa de error / retrabajo** | [X%] | [Y%] | [Z%] | ↓ / → / ↑ | [Nombre] | |
| **N° de escaladas** | [N/semana] | [M/semana] | [K/semana] | ↓ / → / ↑ | [Nombre] | |
| **N° de handoffs por caso** | [N] | [M] | [K] | ↓ / → / ↑ | [Nombre] | |
| **% tiempo VA** | [X%] | [Y%] | [Z%] | ↑ / → / ↓ | [Nombre] | |
| **Satisfacción ejecutores** | [score As-Is] | [score objetivo] | [score actual] | ↑ / → / ↓ | [Nombre] | |
| **[KPI adicional específico del proceso]** | | | | | | |

**Leyenda de Trend:**
- ↓ Mejorando — el KPI se mueve hacia el target
- → Estable — el KPI está en el target o sin variación significativa
- ↑ Empeorando — el KPI se aleja del target → requiere acción

**Leyenda de Action:**
- **Ninguna** — KPI dentro del umbral aceptable
- **Monitorear** — KPI borderline; observar la próxima semana antes de actuar
- **Investigar** — KPI fuera del umbral; identificar causa raíz esta semana
- **Escalar** — KPI crítico fuera del umbral; escalar al Process Owner para decisión inmediata

---

## Umbrales de alerta

| KPI | Umbral de alerta (amarillo) | Umbral crítico (rojo) |
|-----|---------------------------|----------------------|
| Tiempo de ciclo total | > [target + 20%] | > [baseline As-Is] |
| Tasa de error | > [target × 1.5] | > [baseline As-Is] |
| N° de escaladas | > [target × 2] | > [baseline As-Is] |
| [KPI N] | | |

---

## Historial semanal

| Semana | Tiempo ciclo | Tasa error | N° escaladas | Incidentes notables |
|--------|-------------|-----------|-------------|---------------------|
| Semana 1 post Go-Live | [valor] | [valor] | [valor] | [descripción si aplica] |
| Semana 2 | [valor] | [valor] | [valor] | |
| Semana 3 | [valor] | [valor] | [valor] | |
| Semana 4 | [valor] | [valor] | [valor] | |
| Semana 5 | [valor] | [valor] | [valor] | |
| Semana 6 | [valor] | [valor] | [valor] | |

---

## Log de desviaciones

| Fecha | KPI | Valor observado | Umbral | Tipo | Causa identificada | Acción tomada | Resuelto |
|-------|-----|----------------|--------|------|-------------------|--------------|---------|
| [YYYY-MM-DD] | [KPI] | [valor] | [umbral] | Puntual / Tendencial | [causa] | [acción] | Sí / No / En progreso |

---

## Evaluación mensual

### Mes [N] — [YYYY-MM]

**Estado general:** ✅ En target / ⚠️ Riesgo / ❌ Fuera de target

| Pregunta | Respuesta |
|----------|-----------|
| ¿Se está alcanzando el tiempo de ciclo target? | Sí / No — [evidencia] |
| ¿La tasa de error está dentro del umbral? | Sí / No — [evidencia] |
| ¿El equipo está adoptando el nuevo proceso? | % de adopción + evidencia |
| ¿Hay desviaciones tendenciales sin resolver? | Sí / No — [detalle] |
| ¿Se necesita un ajuste al SOP? | Sí → [qué ajustar] / No |
| ¿Se identificaron nuevas oportunidades de mejora? | Sí → [descripción] / No |

**Decisiones del mes:**
- [ ] Ajustar SOP en: [sección/paso]
- [ ] Iniciar nuevo ciclo bpa:analyze para: [oportunidad]
- [ ] Continuar monitoreo sin cambios
- [ ] Escalar a management: [tema]

---

## Fuentes de datos

| KPI | Fuente de datos | Responsable de actualizar | Frecuencia |
|-----|----------------|--------------------------|-----------|
| Tiempo de ciclo total | [Sistema CRM / ERP / timestamps manuales] | [nombre] | [Semanal] |
| Tasa de error | [Sistema de tickets / log de rechazos] | [nombre] | [Semanal] |
| N° de escaladas | [Registro del Process Owner / sistema] | [Process Owner] | [Semanal] |
| Satisfacción ejecutores | [Encuesta mensual de 3 preguntas] | [nombre] | [Mensual] |
