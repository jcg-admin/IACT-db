---
id: GUIA-deployment-001
tipo: guia_operativa
categoria: deployment
audiencia: desarrollador
prioridad: P0
tiempo_lectura: 10 minutos
version: 1.0.0
fecha: 2025-11-07
relacionados: []
---

# Workflow de Deployment

## Proposito

Entiende cómo funciona el proceso de deployment automático a staging y producción.

## Audiencia

Esta guia esta dirigida a: desarrollador

## Pre-requisitos

- [ ] PR mergeado a develop o main
- [ ] Todos los tests CI pasando
- [ ] Permisos de deployment (para production)

## Tiempo estimado

Tiempo de lectura: 10 minutos
Tiempo de ejecucion: 20 minutos

## Pasos

### 1. Deployment a staging (automático)

Cada push a develop despliega automáticamente a staging.

**Comando**:
```bash
# Push a develop:
git push origin develop

# Workflow deploy.yml se ejecuta automáticamente
```

**Output esperado**:
```
Deployment to staging initiated
```

### 2. Verificar smoke tests en staging

El workflow ejecuta smoke tests automáticamente.

**Comando**:
```bash
# Ver en GitHub Actions:
# Job: smoke-tests-staging
# Verifica que pasan todos los checks
```

**Output esperado**:
```
Smoke tests passed
```

### 3. Deployment a production (manual)

Para production, se requiere aprobación manual.

**Comando**:
```bash
# Merge a main:
git checkout main
git merge develop
git push origin main

# En GitHub Actions, aprueba el deployment manual
```

**Output esperado**:
```
Deployment to production approved
```

### 4. Verificar deployment exitoso

Verifica que el deployment completó correctamente.

**Comando**:
```bash
# Checks automáticos:
# 1. Blue-green swap completado
# 2. Health checks pasan
# 3. Smoke tests pasan
# 4. Rollback disponible
```

**Output esperado**:
```
Deployment successful
```

{PASO_3_DESCRIPCION}

## Validacion

Para validar que completaste correctamente esta guia:

- [ ] Workflow deploy.yml se ejecutó
- [ ] Blue-green deployment completó
- [ ] Smoke tests pasaron
- [ ] Aplicación accesible en staging/production
- [ ] Rollback disponible

## Como interpretar resultados

**Exito**: {DESCRIPCION_EXITO}

**Errores comunes**: Ver seccion Troubleshooting

## Troubleshooting

### Error 1: Smoke tests fallan en staging

**Sintomas**:
```
Smoke test failed: /health endpoint not responding
```

**Causa**: Aplicación no inició correctamente

**Solucion**:
```bash
Revisa logs:
# GitHub Actions -> Job logs
# Verifica migraciones, variables de entorno, etc
```

### Error 2: Rollback necesario

**Sintomas**:
```
Deployment causó incidente en producción
```

**Causa**: Bug crítico no detectado en staging

**Solucion**:
```bash
Ejecuta rollback inmediato:
# GitHub Actions -> deploy.yml -> Re-run with rollback flag
# O manualmente:
./scripts/deploy/rollback.sh
```

**Sintomas**: {ERROR_2_SINTOMAS}

**Causa**: {ERROR_2_CAUSA}

**Solucion**: {ERROR_2_SOLUCION}

## Proximos pasos

Despues de completar esta guia, puedes continuar con:

1. Monitorear aplicación en producción
2. Revisar DORA metrics (Ver GUIA-DEPLOYMENT-002)
3. Crear post-deployment report

## Referencias

- Workflow deployment: `.github/workflows/deploy.yml`
- Scripts deployment: `scripts/deploy/`
- Blue-green deployment: `docs/gobernanza/ci_cd/workflows/deploy.md`

## Feedback

Si encuentras problemas con esta guia o tienes sugerencias:
- Crea un issue en GitHub con label `documentation`
- Contacta a: TBD

---

**Mantenedores**: @devops-lead, @tech-lead
**Ultima actualizacion**: 2025-11-07
