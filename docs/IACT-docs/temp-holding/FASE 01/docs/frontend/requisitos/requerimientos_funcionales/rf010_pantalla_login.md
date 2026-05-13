---
id: RF-010
tipo: funcional
titulo: Pantalla de login con validaciones
dominio: frontend
owner: equipo-frontend
prioridad: critica
estado: aprobado
fecha_creacion: 2025-11-06
trazabilidad_upward: [N-001, RN-001, RS-002]
trazabilidad_downward: [TEST-RF-010-ui]
stakeholders: [usuarios-finales-agentes]
iso29148_clause: "9.6.4"
verificacion_metodo: demonstration
categoria: ui
modulo: authentication-ui
date: 2025-11-13
---

# RF-010: Pantalla de login con validaciones

## 1. Declaracion del Requisito

**El sistema DEBERA** proporcionar interfaz de usuario para login **incluyendo** campos username/password, validaciones, y mensajes de error claros **cuando** un usuario acceda a la aplicacion web.

## 2. Criterios de Aceptacion

```gherkin
Given un usuario accede a aplicacion IACT
When el usuario ve la pantalla de login
Then ve formulario con campos: username, password
  And ve boton "Iniciar sesion"
  And username es requerido (validacion client-side)
  And password es requerido (validacion client-side)
  And password esta enmascarado (tipo="password")
  And al hacer clic en "Iniciar sesion" se llama a POST /api/v1/auth/login
```

## 3. Trazabilidad

**Upward:** Deriva de N-001 (autenticacion robusta), RN-001, RS-002 (acceso rapido)

**Downward:** Genera tests UI TEST-RF-010

---

## 4. Vinculo con Backend

Este requisito frontend consume:
- [RF-001](../../backend/requisitos/funcionales/rf001_login_credenciales.md) - Login backend

Ver: backend/requisitos/necesidades/_necesidades_vinculadas.md

---

Control de Cambios: v1.0 | 2025-11-06 | BA Team | Creacion inicial
