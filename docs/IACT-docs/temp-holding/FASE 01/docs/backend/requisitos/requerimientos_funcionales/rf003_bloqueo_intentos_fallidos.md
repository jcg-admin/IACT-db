---
id: RF-003
tipo: funcional
titulo: Bloqueo automatico tras 5 intentos fallidos en 5 minutos
dominio: backend
owner: equipo-backend
prioridad: critica
estado: aprobado
fecha_creacion: 2025-11-06
trazabilidad_upward: [N-001, RN-001, RS-001]
trazabilidad_downward: [TEST-RF-003, CODE-login-attempt-service]
stakeholders: [gerente-seguridad, auditoria-interna]
iso29148_clause: "9.6.4"
verificacion_metodo: test
categoria: security
modulo: authentication
date: 2025-11-13
---

# RF-003: Bloqueo automatico tras intentos fallidos

## 1. Declaracion del Requisito

**El sistema DEBERA** bloquear automaticamente una cuenta tras 5 intentos de login fallidos en ventana de 5 minutos **estableciendo** is_locked=True y locked_until=now+15min **cuando** el contador alcance el umbral.

## 2. Criterios de Aceptacion

```gherkin
Given un usuario con 4 intentos fallidos en ultimos 5 minutos
When el usuario intenta login con password incorrecta (5to intento)
Then el sistema incrementa failed_login_attempts a 5
 And el sistema establece is_locked=True
 And el sistema establece locked_until=now+15min
 And el sistema retorna HTTP 403 "Cuenta bloqueada"
 And el sistema audita evento ACCOUNT_LOCKED
```

## 3. Trazabilidad

**Upward:** Deriva de N-001 (prevenir fraude), RN-001 (sistema seguro), RS-001 (trazabilidad)

**Downward:** Genera tests TEST-RF-003 y codigo LoginAttemptService

---

Control de Cambios: v1.0 | 2025-11-06 | BA Team | Creacion inicial
