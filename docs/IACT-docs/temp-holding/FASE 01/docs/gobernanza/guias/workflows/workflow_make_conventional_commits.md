---
id: GUIA-WORKFLOW-MAKE-CONVENTIONAL-COMMITS
tipo: guia_operativa
categoria: workflows
audiencia: desarrollador
prioridad: P0
tiempo_lectura: 7 minutos
version: 1.0.0
fecha: 2025-01-15
relacionados: []
---

# Hacer Commits Convencionales

## Proposito

Aprende a escribir commits siguiendo Conventional Commits para mantener un historial limpio.

## Audiencia

Esta guia esta dirigida a: desarrollador

## Pre-requisitos

- [ ] Feature branch creado (Ver GUIA-WORKFLOWS-001)
- [ ] Cambios listos para commitear

## Tiempo estimado

Tiempo de lectura: 7 minutos
Tiempo de ejecucion: 14 minutos

## Pasos

### 1. Entender formato de commit

Los commits deben seguir el formato: tipo(scope): mensaje.

**Comando**:
```bash
# Formato:
# tipo(scope): mensaje
# 
# Tipos: feat, fix, docs, style, refactor, test, chore
# Ejemplo:
# feat(auth): agregar login con OAuth2
```

**Output esperado**:
```
Formato aprendido
```

### 2. Hacer commit de feature

Usa 'feat' para nuevas funcionalidades.

**Comando**:
```bash
git add .
git commit -m "feat(auth): agregar sistema de autenticacion OAuth2"
```

**Output esperado**:
```
Commit creado correctamente
```

### 3. Hacer commit de bugfix

Usa 'fix' para correcciones de bugs.

**Comando**:
```bash
git commit -m "fix(api): corregir error 500 en endpoint /users"
```

**Output esperado**:
```
Commit creado correctamente
```

### 4. Verificar historial

Verifica que tu commit sigue las convenciones.

**Comando**:
```bash
git log --oneline -5
```

**Output esperado**:
```
Lista de commits con formato correcto
```

{PASO_3_DESCRIPCION}

## Validacion

Para validar que completaste correctamente esta guia:

- [ ] Commits siguen formato tipo(scope): mensaje
- [ ] Tipo de commit es correcto (feat, fix, docs, etc)
- [ ] Mensaje es claro y descriptivo
- [ ] git log muestra commits bien formateados

## Como interpretar resultados

**Exito**: {DESCRIPCION_EXITO}

**Errores comunes**: Ver seccion Troubleshooting

## Troubleshooting

### Error 1: Pre-commit hook rechaza commit

**Sintomas**:
```
Commit rejected: invalid format
```

**Causa**: Mensaje de commit no sigue convenciones

**Solucion**:
```bash
Reescribe el commit:
git commit --amend -m "feat(scope): mensaje correcto"
```

**Sintomas**: {ERROR_2_SINTOMAS}

**Causa**: {ERROR_2_CAUSA}

**Solucion**: {ERROR_2_SOLUCION}

## Proximos pasos

Despues de completar esta guia, puedes continuar con:

1. Crear Pull Request (Ver GUIA-WORKFLOWS-003)
2. Entender CI/CD (Ver GUIA-WORKFLOWS-004)

## Referencias

- Conventional Commits: `https://www.conventionalcommits.org/`
- Guía de contribución: `CONTRIBUTING.md`

## Feedback

Si encuentras problemas con esta guia o tienes sugerencias:
- Crea un issue en GitHub con label `documentation`
- Contacta a: TBD

---

**Mantenedores**: @tech-lead
**Ultima actualizacion**: 2025-11-07
