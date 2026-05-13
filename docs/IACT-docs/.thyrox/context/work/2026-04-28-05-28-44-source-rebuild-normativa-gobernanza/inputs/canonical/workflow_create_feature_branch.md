---
id: GUIA-WORKFLOW-CREATE-FEATURE-BRANCH
tipo: guia_operativa
categoria: workflows
audiencia: desarrollador
prioridad: P0
tiempo_lectura: 5 minutos
version: 1.0.0
fecha: 2025-01-15
relacionados: []
---

# Crear Feature Branch

## Proposito

Aprende a crear un feature branch siguiendo las convenciones del proyecto.

## Audiencia

Esta guia esta dirigida a: desarrollador

## Pre-requisitos

- [ ] Git configurado correctamente
- [ ] Repositorio clonado
- [ ] Acceso al repositorio remoto

## Tiempo estimado

Tiempo de lectura: 5 minutos
Tiempo de ejecucion: 10 minutos

## Pasos

### 1. Actualizar rama principal

Asegúrate de tener la última versión de develop.

**Comando**:
```bash
git checkout develop
git pull origin develop
```

**Output esperado**:
```
Already up to date.
```

### 2. Crear feature branch

Crea tu branch con el formato correcto: feature/TASK-XXX-descripcion.

**Comando**:
```bash
git checkout -b feature/TASK-123-agregar-autenticacion
```

**Output esperado**:
```
Switched to a new branch 'feature/TASK-123-agregar-autenticacion'
```

### 3. Verificar branch activo

Verifica que estás en el branch correcto.

**Comando**:
```bash
git branch
```

**Output esperado**:
```
* feature/TASK-123-agregar-autenticacion
  develop
  main
```

{PASO_3_DESCRIPCION}

## Validacion

Para validar que completaste correctamente esta guia:

- [ ] git branch muestra tu nuevo branch con asterisco
- [ ] Branch sigue convención feature/TASK-XXX-descripcion
- [ ] Estás partiendo desde develop actualizado

## Como interpretar resultados

**Exito**: {DESCRIPCION_EXITO}

**Errores comunes**: Ver seccion Troubleshooting

## Troubleshooting

### Error 1: Error al hacer pull

**Sintomas**:
```
error: Your local changes would be overwritten
```

**Causa**: Tienes cambios sin commitear en develop

**Solucion**:
```bash
Guarda tus cambios primero:
git stash
git pull origin develop
git stash pop
```

**Sintomas**: {ERROR_2_SINTOMAS}

**Causa**: {ERROR_2_CAUSA}

**Solucion**: {ERROR_2_SOLUCION}

## Proximos pasos

Despues de completar esta guia, puedes continuar con:

1. Hacer commits convencionales (Ver GUIA-WORKFLOWS-002)
2. Crear Pull Request (Ver GUIA-WORKFLOWS-003)

## Referencias

- Git workflow: `docs/gobernanza/procesos/SDLC_PROCESS.md`
- Convenciones de nombres: `docs/gobernanza/CONTRIBUTING.md`

## Feedback

Si encuentras problemas con esta guia o tienes sugerencias:
- Crea un issue en GitHub con label `documentation`
- Contacta a: TBD

---

**Mantenedores**: @tech-lead
**Ultima actualizacion**: 2025-11-07
