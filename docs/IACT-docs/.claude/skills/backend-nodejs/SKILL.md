```yml
name: backend-nodejs
description: "Skill de tecnología para proyectos Node.js. Usar cuando se trabaje en endpoints, middleware, servicios, o lógica de negocio del backend Node.js en el proyecto thyrox. Invocar durante Phase 7 DESIGN/SPECIFY para especificar APIs y contratos, durante Phase 10 EXECUTE para implementar handlers y servicios, y durante Phase 11 TRACK/EVALUATE para revisar calidad y seguridad del código Node."
layer: backend
framework: nodejs
project: thyrox
```

# Backend Node.js — SKILL

Guía fase-por-fase para implementar en Node.js dentro del proyecto thyrox.

---

## Stage 3: DIAGNOSE — Qué investigar en proyectos Node.js

Al analizar un feature de backend, cubrir:
- Endpoints afectados — método HTTP, ruta, parámetros, body
- Capas involucradas — controller, service, repository
- Dependencias externas — base de datos, APIs de terceros, colas
- Autenticación/autorización — ¿qué roles pueden acceder?
- Casos de error — ¿qué puede fallar y cómo responder?

## Phase 7: DESIGN/SPECIFY — Qué especificar para features Node.js

En `requirements-spec.md`, incluir por cada endpoint:
- Contrato de entrada: método, ruta, headers requeridos, body schema (JSON)
- Contrato de salida: status codes posibles, body de respuesta por caso
- Validaciones de input: campos requeridos, tipos, rangos
- Efectos secundarios: qué se escribe en BD, qué eventos se emiten

## Stage 10: IMPLEMENT — Convenciones de implementación

Ver sección INSTRUCTIONS para reglas específicas.

Orden de implementación recomendado:
1. Validación de schema (zod/joi) primero
2. Handler/controller: solo orquesta, no tiene lógica de negocio
3. Service: lógica de negocio pura, testeable en aislamiento
4. Repository: acceso a datos, sin lógica de negocio
5. Tests de integración del endpoint
6. Documentar en OpenAPI/Swagger si el proyecto lo usa

## Phase 11: TRACK/EVALUATE — Qué revisar al cerrar

- Todos los inputs externos validados (no confiar en el cliente)
- No hay secrets hardcodeados (usar `process.env`)
- Queries con `LIMIT` para evitar resultados sin cota
- Logs de error no exponen stack traces al cliente
- Endpoints nuevos tienen al menos 1 test de integración
