# Validation Checklist — Guía de referencia

> Reference for rm:validation. Checklist por tipo de requisito, taxonomía de defectos.

---

## Checklist universal — todos los requisitos

Aplicar a CADA requisito antes de la revisión con stakeholders:

| # | Criterio | Verificación | Pass / Fail |
|---|----------|-------------|------------|
| 1 | El requisito tiene un ID único | REQ-NNN o NFR-NNN | |
| 2 | El requisito tiene descripción en lenguaje natural | Oración completa con verbo | |
| 3 | El requisito tiene prioridad MoSCoW asignada | M / S / C / W explícito | |
| 4 | El requisito tiene origen trazable | Stakeholder + sesión | |
| 5 | El requisito tiene criterio de aceptación | Given/When/Then o métrica | |
| 6 | El requisito NO menciona solución técnica | Sin "debe usar React", "con PostgreSQL" | |
| 7 | El requisito NO contiene palabras ambiguas | Sin "rápido", "fácil", "suficiente" | |
| 8 | El requisito es atómico | Una sola necesidad por requisito | |
| 9 | El requisito NO contradice otro | Verificar vs lista de conflictos | |
| 10 | El requisito es factible | Confirmado con tech lead | |

---

## Checklist por tipo de requisito

### Requisitos funcionales

| # | Criterio | Verificación |
|---|----------|-------------|
| 11 | El actor está identificado | "El usuario administrador / cliente / sistema" |
| 12 | La acción es específica | "crear / visualizar / eliminar / exportar" (no "gestionar") |
| 13 | El objeto de la acción está especificado | "pedido / usuario / reporte" |
| 14 | Las condiciones/restricciones están documentadas | "cuando / si / solo si" |
| 15 | El happy path está completo | Flujo principal con todos los pasos |
| 16 | Los flujos alternativos están documentados | Al menos los más frecuentes |
| 17 | Los flujos de excepción están documentados | Qué pasa cuando falla |
| 18 | El estado del sistema post-acción está claro | "El sistema regresa a / muestra / persiste" |
| 19 | Las validaciones de input están especificadas | Tipos, formatos, rangos, obligatoriedad |
| 20 | Las reglas de negocio están documentadas | Condiciones, fórmulas, decisiones |

### Requisitos no funcionales — Performance

| # | Criterio | Verificación |
|---|----------|-------------|
| 21 | La métrica es cuantificada | ms / req/s / usuarios concurrentes |
| 22 | El percentil está especificado | p50 / p95 / p99 (no "promedio") |
| 23 | Las condiciones de carga están definidas | N usuarios, tipo de operación, duración |
| 24 | El entorno de medición está especificado | Producción / Staging / Hardware specs |
| 25 | El método de verificación está definido | Tipo de test de carga, herramienta |

### Requisitos no funcionales — Seguridad

| # | Criterio | Verificación |
|---|----------|-------------|
| 26 | El estándar de referencia está citado | OWASP / ISO 27001 / PCI-DSS / HIPAA |
| 27 | El nivel de cumplimiento está especificado | ASVS Level 1/2/3 / Partial / Full |
| 28 | Los datos sensibles están identificados | PII / PCI data / PHI / credenciales |
| 29 | El control de acceso está especificado | Quién puede ver/modificar qué |
| 30 | El audit log está especificado | Qué eventos se registran, por cuánto tiempo |

### Requisitos no funcionales — Disponibilidad

| # | Criterio | Verificación |
|---|----------|-------------|
| 31 | El SLA está cuantificado | % uptime mensual/anual |
| 32 | El RTO está definido | Tiempo máximo de recuperación ante falla |
| 33 | El RPO está definido | Pérdida máxima de datos aceptable |
| 34 | La ventana de mantenimiento está especificada | Cuándo se pueden hacer downtimes programados |
| 35 | El comportamiento degradado está definido | Qué funciona en modo reducido |

### Requisitos de interfaces

| # | Criterio | Verificación |
|---|----------|-------------|
| 36 | El sistema externo está identificado | Nombre + versión |
| 37 | El protocolo está especificado | REST / SOAP / gRPC / Batch file / Event |
| 38 | El formato de datos está definido | JSON / XML / CSV / Protobuf |
| 39 | La autenticación de la interfaz está definida | API Key / OAuth2 / Certificado |
| 40 | El manejo de errores de la interfaz está definido | Timeout / retry / fallback |

---

## Defect taxonomy — clasificación de defectos

### Tipos de defecto (Inspección Fagan)

| Tipo | Código | Definición | Ejemplo |
|------|--------|-----------|---------|
| **Missing** | M | Requisito necesario omitido | Falta el flujo de error para input inválido |
| **Wrong** | W | Requisito presente pero incorrecto | Performance threshold equivocado |
| **Extra** | E | Requisito incluido que no fue pedido | Feature de bajo valor no solicitada |
| **Ambiguous** | A | Múltiples interpretaciones posibles | "El sistema debe responder rápidamente" |
| **Inconsistent** | I | Contradice otro requisito o documento | REQ-A dice X, NFR-B dice NOT-X |
| **Duplicate** | D | Mismo requisito expresado dos veces | REQ-005 y REQ-023 describen lo mismo |
| **Infeasible** | F | No implementable con los recursos/tecnología disponible | Requiere tecnología no disponible |

### Severidad de defectos

| Severidad | Definición | Acción |
|-----------|-----------|--------|
| **Crítico** | Sin corrección, el requisito es inimplementable o viola regulación | Bloquea aprobación — corregir antes de sign-off |
| **Mayor** | Impacta significativamente la implementación o el valor del requisito | Corregir antes de sign-off o con plan documentado |
| **Menor** | Mejora de claridad; no impacta implementación | Corregir en próxima revisión |
| **Sugerencia** | Mejora opcional sin impacto en calidad | A discreción del analista |

---

## Inspección Fagan — proceso completo

### Roles en la inspección

| Rol | Responsabilidad |
|-----|----------------|
| **Moderador** | Facilita la reunión; NO es el autor; entrenado en inspección Fagan |
| **Autor** | Escribió el documento; responde preguntas; NO defiende ni explica anticipadamente |
| **Revisores** | Inspeccionan el documento independientemente antes de la reunión |
| **Escribano** | Registra todos los defectos encontrados |

### Fases de la Inspección Fagan

| Fase | Actividad | Duración |
|------|-----------|----------|
| **Planning** | Moderador distribuye documentos; define checklist; asigna roles | 1-2h |
| **Overview** | Autor presenta el documento al equipo (opcional si es sencillo) | 1h |
| **Preparation** | Cada revisor lee el documento individualmente usando el checklist | 2-4h por revisor |
| **Meeting** | Equipo revisa en conjunto; moderador guía; escribano documenta defectos | 2h máx |
| **Rework** | Autor corrige los defectos documentados | Variable |
| **Follow-up** | Moderador verifica que los defectos fueron corregidos | 1h |

### Tasa de detección de defectos esperada

| Técnica | Defectos detectados (vs total) |
|---------|-------------------------------|
| Lectura individual | 30-40% |
| Walkthrough | 50-60% |
| Inspección Fagan | 70-85% |

> La Inspección Fagan detecta 2× más defectos que una revisión informal, pero requiere 3-4× más tiempo. Justificada en sistemas críticos o alta complejidad.

---

## Validación con stakeholders — señales de warning

| Señal | Interpretación | Acción |
|-------|---------------|--------|
| Stakeholder aprueba sin leer | No validó realmente | Pedir feedback específico en 2-3 requisitos |
| "Está bien, pero..." frecuente | Hay requisitos incompletos | Revisar los requisitos que generan comentarios |
| Silencio total del stakeholder | No entendió el documento | Cambiar formato; usar prototipos |
| Diferentes stakeholders aprueban cosas contradictorias | No se comunicaron entre sí | Workshop de alineación antes del sign-off |
| Stakeholder pide agregar más en la revisión | La elicitación fue insuficiente | Considerar retornar a rm:elicitation |
