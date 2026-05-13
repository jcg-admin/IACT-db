---
id: RF-006
tipo: funcional
titulo: Recuperacion de password sin email mediante 3 preguntas seguridad
dominio: backend
owner: equipo-backend
prioridad: media
estado: aprobado
fecha_creacion: 2025-11-06
trazabilidad_upward: [N-001, RN-001]
trazabilidad_downward: [TEST-RF-006, CODE-password-recovery]
stakeholders: [usuarios-finales, soporte-tecnico]
iso29148_clause: "9.6.4"
verificacion_metodo: test
categoria: security
modulo: authentication
date: 2025-11-13
---

# RF-006: Recuperacion de password sin email

## 1. Declaracion del Requisito

**El sistema DEBERA** permitir recuperacion de password mediante 3 preguntas de seguridad **sin usar email** **generando** password temporal enviada via buzon interno (InternalMessage) **cuando** usuario complete validacion de preguntas.

## 2. Criterios de Aceptacion

```gherkin
Given un usuario que olvido su password
When el usuario solicita recuperacion y responde 3 preguntas de seguridad correctamente
Then el sistema genera password temporal (valida 24 horas)
 And el sistema envia password temporal via buzon interno (NO email)
 And el sistema audita evento PASSWORD_RECOVERY
 And el usuario puede iniciar sesion con password temporal
 And el sistema obliga al usuario a cambiar password en primer login
```

## 3. Restriccion CRITICA

**NO usar email**: Sistema IACT prohibe envio de emails. Solo buzon interno (modelo InternalMessage).

## 4. Trazabilidad

**Upward:** Deriva de N-001 (autenticacion robusta con recovery), RN-001

**Downward:** Genera TEST-RF-006 y codigo PasswordRecoveryService

---

Control de Cambios: v1.0 | 2025-11-06 | BA Team | Creacion inicial
