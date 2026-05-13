---
id: RF-005
tipo: funcional
titulo: Logout manual con invalidacion de tokens
dominio: backend
owner: equipo-backend
prioridad: alta
estado: aprobado
fecha_creacion: 2025-11-06
trazabilidad_upward: [N-001, RN-001, RS-001]
trazabilidad_downward: [TEST-RF-005, CODE-logout-view]
stakeholders: [usuarios-finales, auditoria-interna]
iso29148_clause: "9.6.4"
verificacion_metodo: test
categoria: security
modulo: authentication
date: 2025-11-13
---

# RF-005: Logout manual

## 1. Declaracion del Requisito

**El sistema DEBERA** permitir a usuarios cerrar sesion manualmente **invalidando** tokens JWT **y registrando** evento de auditoria **cuando** el usuario acceda a POST /api/v1/auth/logout.

## 2. Criterios de Aceptacion

```gherkin
Given un usuario autenticado con sesion activa
When el usuario envia POST /api/v1/auth/logout con access_token valido
Then el sistema invalida el access_token
 And el sistema invalida el refresh_token
 And el sistema establece session.is_active=False
 And el sistema audita evento LOGOUT_MANUAL
 And el sistema retorna HTTP 200 "Logout exitoso"
```

## 3. Trazabilidad

**Upward:** Deriva de N-001, RN-001, RS-001 (trazabilidad logout)

**Downward:** Genera TEST-RF-005 y codigo LogoutView

---

Control de Cambios: v1.0 | 2025-11-06 | BA Team | Creacion inicial
