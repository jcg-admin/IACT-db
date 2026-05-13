---
title: Plantilla 4 - Especificación Rápida de Regla de Negocio
date: 2025-11-16
domain: general
status: active
tipo: plantilla
plantilla_numero: 4
---

# Plantilla 4: Especificación Rápida de Regla de Negocio

### Propósito

Plantilla simplificada para documentar rápidamente una regla de negocio individual.

### Estructura de la Plantilla

```markdown
# Regla de Negocio: [NOMBRE DE LA REGLA]

**ID:** RN-[ÁREA]-[NN]
**Versión:** X.Y
**Fecha:** YYYY-MM-DD
**Autor:** [Nombre]
**Estado:** Borrador | Revisión | Aprobado

---

## Clasificación

**Tipo:** Hecho | Restricción | Desencadenador | Inferencia | Cálculo
**Categoría:** [Categoría específica]
**Criticidad:** Alta | Media | Baja

---

## Descripción

[Descripción en lenguaje natural de la regla de negocio]

---

## Expresión Formal

```
SI [condición]
ENTONCES [acción/resultado]
SI NO [acción alternativa]
```

**Ejemplo:**

```
SI edad_usuario >= 18
ENTONCES permitir_registro()
SI NO rechazar_con_mensaje("Debes tener al menos 18 años")
```

---

## Origen

**Fuente:** [De dónde proviene la regla]
- [ ] Regulación legal/normativa
- [ ] Política de la empresa
- [ ] Lógica de negocio
- [ ] Restricción técnica

**Referencia:** [Número de ley, política, documento, etc.]

---

## Validación

**¿Cómo se valida esta regla?**

[Descripción de cómo el sistema valida que la regla se cumple]

**Momento de Validación:**
- [ ] En tiempo de entrada de datos (frontend)
- [ ] En tiempo de procesamiento (backend)
- [ ] En tiempo de persistencia (base de datos)
- [ ] Post-procesamiento (auditoría)

---

## Excepciones

**¿Existen casos en los que esta regla NO aplica?**

- Excepción 1: [Descripción]
- Excepción 2: [Descripción]

---

## Impacto

**Procesos Afectados:**
- PROC-[XXX]: [Nombre del proceso]

**Casos de Uso Afectados:**
- UC-[XXX]: [Nombre del UC] (paso [N])

**Requisitos Derivados:**
- RF-[XXX]: [Nombre del requisito]

---

## Sanción

**¿Qué ocurre si se viola esta regla?**

[Descripción de la consecuencia: rechazo, alerta, bloqueo, etc.]

**Mensaje al Usuario:**
"[Mensaje que se muestra al usuario cuando se viola la regla]"

---

## Pruebas

**Casos de Prueba:**
- TS-RN-[XX]-001: Validar cumplimiento de la regla
- TS-RN-[XX]-002: Validar detección de violación

---

## Referencias

- Documento detallado: [Ruta al documento]
- Regulación: [Enlace o referencia]
- Decisión de negocio: [Jira ticket, email, acta de reunión]

---

## Historial de Cambios

| Versión | Fecha | Autor | Cambio |
|---------|-------|-------|--------|
| 1.0 | [Fecha] | [Autor] | Creación inicial |

---

**Aprobado por:** [Nombre del aprobador]
**Fecha de Aprobación:** YYYY-MM-DD

---

**Fin de Plantilla de Regla de Negocio**
```

---

## Referencias

Esta plantilla fue extraída de: [06_plantillas_integradas_iact.md](../06_plantillas_integradas_iact.md)

Para más información sobre el marco integrado de análisis, consulte la documentación completa en el directorio padre.
