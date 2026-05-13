# Guía de Estandarización — PS8

> Referencia para el Step 8 de Toyota TBP: estandarizar los procesos exitosos y compartir aprendizajes.

---

## ¿Por qué estandarizar?

La estandarización es el mecanismo que convierte una mejora puntual en un cambio permanente. Sin estandarización:

- El proceso puede regresar al estado anterior cuando la atención del proyecto se retire
- Los nuevos miembros del equipo no conocen el nuevo estándar
- La mejora se pierde cuando rota el personal que la implementó
- El conocimiento queda en la cabeza de pocas personas, no en el sistema

**Principio TBP:** El estándar de hoy es el punto de partida de la mejora de mañana. Sin estándar, no hay base desde la cual mejorar.

---

## Tipos de estandarización — de más a menos durable

| Tipo | Descripción | Durabilidad | Cuándo usar |
|------|-------------|-------------|-------------|
| **Poka-yoke (diseño anti-error)** | El proceso hace imposible el error | Muy alta — no depende de comportamiento humano | Cuando la contramedida puede incorporarse en el diseño del sistema |
| **Automatización** | El proceso correcto ocurre automáticamente | Alta — ocurre sin intervención humana | Cuando hay un proceso manual repetitivo que puede automatizarse |
| **Control en código / configuración** | El comportamiento correcto está codificado | Alta — aplicado consistentemente a todos | Para cambios en sistemas, pipelines, configuraciones |
| **Indicador activo con alerta** | El sistema avisa cuando hay desviación | Alta — detecta regresión automáticamente | Cuando el proceso no puede controlarse en el diseño pero puede monitorearse |
| **Procedimiento documentado (SOP)** | Instrucciones escritas del proceso estándar | Media — requiere que alguien lo lea y lo siga | Cuando la variabilidad viene de pasos manuales que dependen del operador |
| **Capacitación** | Conocimiento transferido al equipo | Media-Baja — depende de retención y rotación | Complemento a otros tipos, especialmente para cambios de conducta |
| **Gestión visual** | Señales visuales que guían el comportamiento correcto | Media-Baja — depende de visibilidad y atención | Para procesos físicos o cuando la señalización es parte del flujo |
| **Revisión periódica** | El equipo revisa regularmente el cumplimiento | Baja — depende de que la revisión ocurra | Solo como red de seguridad adicional, no como mecanismo principal |

---

## SOPs que realmente funcionan

Un SOP (Procedimiento Operativo Estándar) efectivo tiene estas características:

| Característica | Descripción |
|----------------|-------------|
| **Breve y visual** | Si tiene más de 2 páginas, probablemente no se leerá en el momento que se necesita |
| **Escrito por quienes lo ejecutan** | No por el manager — por las personas que hacen el trabajo |
| **Accesible en el punto de uso** | Al alcance cuando se necesita, no en un folder compartido difícil de encontrar |
| **Versionado** | Fecha de última actualización visible; historial de cambios |
| **Revisado periódicamente** | Al menos una vez al año para verificar que sigue siendo válido |
| **Con mecanismo de retroalimentación** | Canal para que el equipo reporte cuando el SOP no funciona o está desactualizado |

---

## Yokoten — transferencia lateral de aprendizaje

Yokoten (del japonés "extender horizontalmente") es el principio de compartir activamente los aprendizajes de un proyecto de mejora con otros equipos o procesos que enfrentan problemas similares.

**¿Por qué Yokoten?**

Sin Yokoten, cada equipo redescubre las mismas causas raíz y desarrolla las mismas contramedidas de forma independiente — desperdicio de tiempo y esfuerzo. El conocimiento de un A3 puede evitar meses de análisis en otro equipo.

**Cómo identificar candidatos para Yokoten:**

| Pregunta | Si la respuesta es "sí" |
|----------|------------------------|
| ¿Otros equipos tienen un proceso similar? | Son candidatos a Yokoten |
| ¿La causa raíz identificada podría existir en otros sistemas? | Compartir el análisis para auto-diagnóstico |
| ¿La contramedida es una solución genérica aplicable a múltiples contextos? | Potencial de adopción amplia |

**Formatos de Yokoten:**

- **A3 compartido**: enviar el A3 completo con contexto a equipos relevantes
- **Presentación breve**: 15-20 minutos mostrando el problema, la causa raíz y las contramedidas
- **Base de conocimiento**: archivar los A3 en un repositorio indexado por tipo de problema o proceso
- **Taller de Yokoten**: sesión donde un equipo presenta y otro equipo lo adapta a su contexto

---

## Mecanismos de control para sostenibilidad

El objetivo del mecanismo de control es detectar regresión antes de que el problema regrese a su magnitud original:

| Mecanismo | Cómo funciona | Frecuencia recomendada |
|-----------|--------------|----------------------|
| **Métrica en dashboard** | El indicador del problema está visible y actualizado automáticamente | Continuo |
| **Alerta automática** | Notificación cuando el indicador cruza el umbral de alerta | En tiempo real o diario |
| **Revisión periódica de métricas** | El equipo revisa los datos en reunión regular | Semanal o mensual |
| **Auditoría de cumplimiento** | Verificar que el proceso estándar se está siguiendo | Mensual o trimestral |
| **Revisión anual del estándar** | ¿El estándar sigue siendo válido dado el contexto actual? | Anual |

**Umbral de alerta:** definir el valor de la métrica que dispara una revisión del proceso. No esperar a que el problema regrese a su magnitud original — la alerta debe dispararse mucho antes.

Ejemplo:
```
Problema original: 23% de deploys fallidos
Target alcanzado: <5% de deploys fallidos
Umbral de alerta: >8% en cualquier semana → revisión del proceso
Umbral de acción urgente: >15% → activar protocolo de respuesta inmediata
```

---

## Checklist de cierre de ciclo PS8

Antes de declarar el ciclo PS8 cerrado:

- [ ] **Efecto confirmado** con datos del período de medición completo
- [ ] **Sostenibilidad verificada** con al menos [N] semanas dentro del target
- [ ] **Contramedidas exitosas estandarizadas** con mecanismo de control activo
- [ ] **A3 Report completo** con las 7 secciones
- [ ] **Aprendizajes documentados** en la sección de aprendizajes del A3
- [ ] **Yokoten ejecutado** — aprendizajes compartidos con equipos relevantes
- [ ] **Sponsor informado** del resultado final vs target
- [ ] **Brecha residual documentada** (si aplica) con decisión sobre próximo ciclo
