# Standard Operating Procedure — Template

```yml
created_at: [timestamp]
project: [nombre del proyecto]
work_package: [wp-id]
phase: bpa:implement
author: [nombre]
status: Borrador
```

---

# SOP: [Nombre del Proceso]

| Campo | Valor |
|-------|-------|
| **Código del SOP** | SOP-[área]-[NNN] |
| **Versión** | 1.0 |
| **Fecha de creación** | [YYYY-MM-DD] |
| **Fecha de revisión** | [YYYY-MM-DD — máximo 12 meses después de la creación] |
| **Process Owner** | [nombre + cargo] |
| **Aprobado por** | [nombre + cargo + fecha] |
| **Distribución** | [quiénes deben conocer este SOP] |

---

## 1. Purpose (Propósito)

*¿Para qué existe este proceso? ¿Qué problema resuelve o qué valor produce?*

[Descripción en 2-4 oraciones. Ejemplo: "Este procedimiento estandariza la aprobación de solicitudes de crédito para clientes nuevos, asegurando que las decisiones se tomen en ≤ 2 días hábiles con los controles de riesgo requeridos."]

---

## 2. Scope (Alcance)

### Aplica a:
- [Tipos de casos / solicitudes / transacciones cubiertos]
- [Roles que ejecutan este proceso]
- [Sistemas involucrados]

### No aplica a:
- [Excepciones explícitas — qué no cubre este SOP]
- [Casos que tienen un SOP separado]

---

## 3. Roles y Responsabilidades

| Rol | Responsabilidades en este proceso |
|-----|----------------------------------|
| **[Rol 1 — ej: Ejecutivo Comercial]** | [Qué pasos ejecuta, qué decisiones toma] |
| **[Rol 2 — ej: Analista de Crédito]** | [Qué pasos ejecuta, qué decisiones toma] |
| **[Rol 3 — ej: Comité de Crédito]** | [Qué aprueba, cuándo se involucra] |
| **[Sistema — ej: CRM]** | [Qué acciones automatizadas realiza] |

---

## 4. Definiciones y Términos

| Término | Definición |
|---------|------------|
| [Término 1] | [Definición — usar el lenguaje del equipo ejecutor, no el del analista] |
| [Término 2] | [Definición] |

---

## 5. Procedimiento — Pasos

*Instrucciones paso a paso del proceso To-Be. Cada paso tiene: número, actor, acción y output.*

### Paso 1 — [Nombre del paso] | Actor: [Rol]

**Qué hacer:**
[Instrucción clara y específica. Usar verbos de acción: "Abrir", "Verificar", "Completar", "Enviar".]

**Inputs necesarios:**
- [Input 1 — documento, información, sistema]

**Cómo hacerlo:**
1. [Sub-paso a]
2. [Sub-paso b]
3. [Sub-paso c]

**Output producido:**
- [Qué genera este paso — documento, decisión, notificación]

**Dónde registrar:**
- Sistema: [nombre del sistema] → [sección/campo]

*[Espacio para screenshot o visual del sistema si aplica]*
> [VISUAL PLACEHOLDER: Captura de pantalla del formulario / sistema en este paso]

---

### Paso 2 — [Nombre del paso] | Actor: [Rol]

**Qué hacer:**
[Instrucción clara.]

**¿Hay una decisión aquí?** ✅ Sí

| Condición | Acción |
|-----------|--------|
| Si [condición A — ej: monto ≤ $10,000] | → Ir a Paso 3 (aprobación directa) |
| Si [condición B — ej: monto > $10,000] | → Ir a Paso 4 (escalar a Comité) |
| Si [condición C — ej: información incompleta] | → Regresar al solicitante con la lista de documentos faltantes |

---

### Paso 3 — [Nombre del paso] | Actor: [Rol]

**Qué hacer:**
[Instrucción.]

**Output:** [Output del paso]

*[Repetir para todos los pasos del proceso To-Be]*

---

### Paso N — [Último paso — cierre del proceso] | Actor: [Rol]

**Qué hacer:**
[Instrucción de cierre.]

**Verificar antes de cerrar:**
- [ ] [Checklist item 1]
- [ ] [Checklist item 2]
- [ ] [Checklist item 3]

**Output final del proceso:** [Output del proceso completo]

---

## 6. Excepciones y Casos Especiales

| Excepción | Cuándo ocurre | Cómo manejarla | Responsable |
|-----------|--------------|----------------|------------|
| [Excepción 1 — ej: cliente VIP] | [Condición] | [Flujo alternativo o escalada] | [Rol] |
| [Excepción 2 — ej: sistema caído] | [Condición] | [Proceso manual de contingencia] | [Rol] |
| [Excepción 3 — ej: caso fuera de política] | [Condición] | [Escalar a Process Owner para decisión] | [Process Owner] |

> Si la excepción no está cubierta en esta sección: escalar al Process Owner antes de tomar acción.

---

## 7. Controles de Calidad

| Control | Frecuencia | Responsable | Qué verificar |
|---------|-----------|-------------|--------------|
| [Control 1 — ej: revisión de tiempo de ciclo] | [Semanal] | [Process Owner] | [Que el % de casos ≤ 2 días sea ≥ 80%] |
| [Control 2 — ej: auditoría de completitud] | [Mensual] | [Analista de Calidad] | [Que todos los pasos del SOP se están ejecutando] |

---

## 8. Sistemas y Herramientas Utilizados

| Sistema | Pasos | Acceso requerido |
|---------|-------|-----------------|
| [Sistema 1 — ej: CRM] | [Pasos 1, 3, N] | [Rol que necesita acceso] |
| [Sistema 2] | [Pasos] | [Rol] |

---

## 9. Documentos Relacionados

| Documento | Ubicación | Propósito |
|-----------|-----------|-----------|
| [To-Be Process Map] | [link/ruta] | Diagrama visual del proceso |
| [Gap Analysis] | [link/ruta] | Contexto del rediseño |
| [Policy — nombre] | [link/ruta] | Política que sustenta este procedimiento |

---

## 10. Historial de Versiones

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0 | [YYYY-MM-DD] | [nombre] | Versión inicial — proceso To-Be post BPA |

---

## 11. Fecha de Revisión

**Próxima revisión obligatoria:** [YYYY-MM-DD]

*Este SOP debe revisarse si:*
- El proceso cambia significativamente
- Se incorporan nuevos sistemas
- Los KPIs de bpa:monitor muestran desviaciones sostenidas
- Han transcurrido 12 meses desde la última revisión
