---
id: RF-011
tipo: funcional
titulo: Pantalla de cambio de password
dominio: frontend
owner: equipo-frontend
prioridad: media
estado: aprobado
fecha_creacion: 2025-11-06
trazabilidad_upward: [N-001, RN-001]
trazabilidad_downward: [TEST-RF-011-ui]
stakeholders: [usuarios-finales]
iso29148_clause: "9.6.4"
verificacion_metodo: demonstration
categoria: ui
modulo: user-settings-ui
date: 2025-11-13
---

# RF-011: Pantalla de cambio de password

## 1. Declaracion del Requisito

**El sistema DEBERA** proporcionar interfaz para que usuarios cambien su password **validando** fortaleza de password **y mostrando** indicador de fortaleza en tiempo real.

## 2. Criterios de Aceptacion

```gherkin
Given un usuario autenticado accede a "Mi perfil"
When el usuario hace clic en "Cambiar password"
Then ve formulario con campos: password actual, password nueva, confirmar password
  And ve indicador de fortaleza de password (debil/media/fuerte)
  And password nueva debe cumplir politica (8+ caracteres, mayusculas, numeros, simbolos)
  And confirmar password debe coincidir con password nueva
```

## 3. Trazabilidad

**Upward:** Deriva de N-001, RN-001

---

Control de Cambios: v1.0 | 2025-11-06 | BA Team | Creacion inicial
