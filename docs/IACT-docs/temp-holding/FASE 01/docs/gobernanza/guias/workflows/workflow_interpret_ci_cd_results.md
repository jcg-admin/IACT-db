---
id: GUIA-WORKFLOW-INTERPRET-CI-CD-RESULTS
tipo: guia_operativa
categoria: workflows
audiencia: desarrollador
prioridad: P0
tiempo_lectura: 8 minutos
version: 1.0.0
fecha: 2025-01-15
relacionados: []
---

# Interpretar Resultados de CI/CD

## Proposito

Aprende a interpretar los resultados de los workflows de CI/CD y solucionar problemas comunes.

## Audiencia

Esta guia esta dirigida a: desarrollador

## Pre-requisitos

- [ ] PR creado (Ver GUIA-WORKFLOWS-003)
- [ ] Acceso a GitHub Actions

## Tiempo estimado

Tiempo de lectura: 8 minutos
Tiempo de ejecucion: 16 minutos

## Pasos

### 1. Acceder a GitHub Actions

Navega a la pestaña Actions de GitHub para ver los workflows.

**Comando**:
```bash
# Abre: https://github.com/2-Coatl/IACT---project/actions
```

**Output esperado**:
```
Lista de workflow runs
```

### 2. Identificar workflow fallido

Identifica qué workflow falló y en qué job.

**Comando**:
```bash
# Click en el run fallido
# Identifica el job con X roja
# Click en el job para ver logs
```

**Output esperado**:
```
Logs del job fallido
```

### 3. Analizar logs de error

Lee los logs para entender la causa del fallo.

**Comando**:
```bash
# Busca líneas con ERROR o FAILED
# Lee el stack trace completo
# Identifica el archivo y línea del error
```

**Output esperado**:
```
Causa del error identificada
```

### 4. Reproducir error localmente

Intenta reproducir el error en tu máquina local.

**Comando**:
```bash
./scripts/ci/backend_test.sh
# O el script correspondiente al workflow que falló
```

**Output esperado**:
```
Error reproducido localmente
```

{PASO_3_DESCRIPCION}

## Validacion

Para validar que completaste correctamente esta guia:

- [ ] Sabes navegar a GitHub Actions
- [ ] Puedes identificar qué job falló
- [ ] Entiendes cómo leer logs de CI
- [ ] Puedes reproducir errores localmente

## Como interpretar resultados

**Exito**: {DESCRIPCION_EXITO}

**Errores comunes**: Ver seccion Troubleshooting

## Troubleshooting

### Error 1: No puedo ver logs de Actions

**Sintomas**:
```
Actions tab vacío o sin permisos
```

**Causa**: Falta de permisos en repositorio

**Solucion**:
```bash
Solicita permisos al admin del repo
```

### Error 2: Error solo ocurre en CI, no localmente

**Sintomas**:
```
Tests pasan local pero fallan en CI
```

**Causa**: Diferencias de entorno (Python version, DB, etc)

**Solucion**:
```bash
Verifica versiones:
# En CI se usa Python 3.11, MySQL 8.0
# Asegúrate de usar las mismas versiones localmente
```

**Sintomas**: {ERROR_2_SINTOMAS}

**Causa**: {ERROR_2_CAUSA}

**Solucion**: {ERROR_2_SOLUCION}

## Proximos pasos

Despues de completar esta guia, puedes continuar con:

1. Corregir errores y push nuevo commit
2. Validar que CI pase antes de pedir review
3. Entender test pyramid (Ver GUIA-TESTING-003)

## Referencias

- GitHub Actions docs: `https://docs.github.com/actions`
- Workflows del proyecto: `.github/workflows/`
- Scripts de CI: `scripts/ci/`

## Feedback

Si encuentras problemas con esta guia o tienes sugerencias:
- Crea un issue en GitHub con label `documentation`
- Contacta a: TBD

---

**Mantenedores**: @devops-lead, @tech-lead
**Ultima actualizacion**: 2025-11-07
