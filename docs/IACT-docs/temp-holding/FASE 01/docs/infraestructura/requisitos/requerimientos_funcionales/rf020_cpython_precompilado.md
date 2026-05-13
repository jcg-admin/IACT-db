---
id: RF-020
tipo: funcional
titulo: CPython 3.12.6 precompilado en Dev Container
dominio: infraestructura
owner: equipo-infraestructura
prioridad: media
estado: aprobado
fecha_creacion: 2025-11-06
trazabilidad_upward: [Objetivo-DevExp]
trazabilidad_downward: [CONFIG-devcontainer]
stakeholders: [equipo-desarrollo]
iso29148_clause: "9.6.4"
verificacion_metodo: demonstration
categoria: development-environment
modulo: devcontainer
---

# RF-020: CPython 3.12.6 precompilado en Dev Container

## 1. Declaracion del Requisito

**El entorno de desarrollo DEBERA** incluir CPython 3.12.6 precompilado desde fuentes **optimizado** con flags de compilacion **para** garantizar consistencia de entorno de desarrollo.

## 2. Criterios de Aceptacion

```gherkin
Given un desarrollador usa Dev Container
When el contenedor se construye
Then CPython 3.12.6 esta instalado en /usr/local/bin/python3.12
  And python --version retorna "Python 3.12.6"
  And python fue compilado desde fuentes (no binario distro)
  And flags de compilacion incluyen optimizaciones
```

## 3. Trazabilidad

**Upward:** Deriva de objetivo de Developer Experience

**Downward:** Configurado en infrastructure/cpython/

---

Control de Cambios: v1.0 | 2025-11-06 | BA Team | Creacion inicial
