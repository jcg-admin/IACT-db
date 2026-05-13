---
id: GUIA-deployment-002
tipo: guia_operativa
categoria: deployment
audiencia: desarrollador
prioridad: P0
tiempo_lectura: 5 minutos
version: 1.0.0
fecha: 2025-11-07
relacionados: []
---

# Validar Restricciones Criticas

## Proposito

Aprende a validar que tu código no viola restricciones críticas del proyecto (RNF-002).

## Audiencia

Esta guia esta dirigida a: desarrollador

## Pre-requisitos

- [ ] Código completo y listo para commit
- [ ] Script validate_critical_restrictions.sh disponible

## Tiempo estimado

Tiempo de lectura: 5 minutos
Tiempo de ejecucion: 10 minutos

## Pasos

### 1. Ejecutar validación de restricciones

Ejecuta el script que valida restricciones críticas.

**Comando**:
```bash
./scripts/validate_critical_restrictions.sh
```

**Output esperado**:
```
All critical restrictions validated: PASSED
```

### 2. Revisar restricciones validadas

El script valida que NO uses tecnologías prohibidas.

**Comando**:
```bash
# Valida que NO uses:
# - Redis
# - RabbitMQ
# - Celery
# - MongoDB
# - Elasticsearch
```

**Output esperado**:
```
No prohibited technologies found
```

### 3. Revisar resultado detallado

Si falla, revisa qué restricción violaste.

**Comando**:
```bash
# El script te dirá:
# ERROR: Found Redis import in file.py:123
# ERROR: Found RabbitMQ config in settings.py:456
```

**Output esperado**:
```
Violación identificada
```

{PASO_3_DESCRIPCION}

## Validacion

Para validar que completaste correctamente esta guia:

- [ ] Script pasa sin errores
- [ ] No hay imports de tecnologías prohibidas
- [ ] No hay configuraciones de tecnologías prohibidas
- [ ] CI workflow también pasa esta validación

## Como interpretar resultados

**Exito**: {DESCRIPCION_EXITO}

**Errores comunes**: Ver seccion Troubleshooting

## Troubleshooting

### Error 1: Encontró Redis import

**Sintomas**:
```
ERROR: Found 'redis' import
```

**Causa**: Código intenta usar Redis (prohibido por RNF-002)

**Solucion**:
```bash
Usa alternativa permitida:
# En lugar de Redis para cache, usa:
# - Django cache framework con database backend
# - Memcached (permitido)
# Ver ADR-XXX para alternatives
```

**Sintomas**: {ERROR_2_SINTOMAS}

**Causa**: {ERROR_2_CAUSA}

**Solucion**: {ERROR_2_SOLUCION}

## Proximos pasos

Despues de completar esta guia, puedes continuar con:

1. Si pasa: crear PR (Ver GUIA-WORKFLOWS-003)
2. Si falla: refactorizar para usar tecnologías permitidas

## Referencias

- Script validación: `scripts/validate_critical_restrictions.sh`
- RNF-002: `docs/requisitos/rnf-002-restricciones-criticas.md`
- Alternativas permitidas: `docs/adr/`

## Feedback

Si encuentras problemas con esta guia o tienes sugerencias:
- Crea un issue en GitHub con label `documentation`
- Contacta a: TBD

---

**Mantenedores**: @arquitecto-senior, @tech-lead
**Ultima actualizacion**: 2025-11-07
