---
id: RF-002
tipo: funcional
titulo: Generacion de tokens JWT (access 15min, refresh 7dias)
dominio: backend
owner: equipo-backend
prioridad: critica
estado: aprobado
fecha_creacion: 2025-11-06
trazabilidad_upward: [N-001, RN-001, RS-002]
trazabilidad_downward: [TEST-RF-002, CODE-jwt-service]
stakeholders: [usuarios-finales-agentes, gerente-seguridad]
iso29148_clause: "9.6.4"
verificacion_metodo: test
categoria: security
modulo: authentication
date: 2025-11-13
---

# RF-002: Generacion de tokens JWT

## 1. Declaracion del Requisito

**El sistema DEBERA** generar tokens JWT tras autenticacion exitosa **incluyendo** access token (15 minutos) y refresh token (7 dias) **firmados** con algoritmo HS256 **cuando** un usuario complete login exitosamente.

## 2. Criterios de Aceptacion

```gherkin
Given un usuario autenticado exitosamente
When el sistema genera tokens JWT
Then el access_token tiene expiracion de 15 minutos
 And el refresh_token tiene expiracion de 7 dias
 And ambos tokens estan firmados con HS256
 And ambos tokens incluyen claims: user_id, username, roles
```

## 3. Trazabilidad

**Upward:** Deriva de N-001 (autenticacion robusta), RN-001 (sistema seguro), RS-002 (acceso rapido)

**Downward:** Genera tests TEST-RF-002 y codigo JWTService en apps/authentication/

---

Control de Cambios: v1.0 | 2025-11-06 | BA Team | Creacion inicial
