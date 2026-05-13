---
id: RF-004
tipo: funcional
titulo: Sesion unica con cierre de sesiones previas
dominio: backend
owner: equipo-backend
prioridad: alta
estado: aprobado
fecha_creacion: 2025-11-06
trazabilidad_upward: [N-001, RN-001, RS-001]
trazabilidad_downward: [TEST-RF-004, CODE-session-service]
stakeholders: [gerente-seguridad, usuarios-finales]
iso29148_clause: "9.6.4"
verificacion_metodo: test
categoria: security
modulo: authentication
date: 2025-11-13
---

# RF-004: Sesion unica

## 1. Declaracion del Requisito

**El sistema DEBERA** cerrar automaticamente sesiones previas de un usuario **cuando** el usuario inicie nueva sesion **para** garantizar sesion unica por usuario.

## 2. Criterios de Aceptacion

```gherkin
Given un usuario "eve" con sesion activa en dispositivo A
When el usuario inicia login desde dispositivo B
Then el sistema cierra sesion anterior (dispositivo A)
 And el sistema establece session_A.is_active=False
 And el sistema audita evento SESSION_CLOSED con razon='NEW_SESSION'
 And el sistema crea nueva sesion para dispositivo B
 And el usuario recibe notificacion en buzon interno
```

## 3. Trazabilidad

**Upward:** Deriva de N-001 (prevenir fraude comparticion credenciales), RN-001, RS-001

**Downward:** Genera TEST-RF-004 y codigo SessionService

---

Control de Cambios: v1.0 | 2025-11-06 | BA Team | Creacion inicial
