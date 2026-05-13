---
id: GUIA-onboarding-006
tipo: guia_operativa
categoria: onboarding
audiencia: desarrollador
prioridad: P0
tiempo_lectura: 6 minutos
version: 1.0.0
fecha: 2025-11-07
relacionados: []
---

# Validar Documentacion

## Proposito

Aprende a validar que tu documentación cumple con la estructura y estándares del proyecto.

## Audiencia

Esta guia esta dirigida a: desarrollador

## Pre-requisitos

- [ ] Documentación escrita en docs/
- [ ] Script validar_estructura_docs.sh disponible

## Tiempo estimado

Tiempo de lectura: 6 minutos
Tiempo de ejecucion: 12 minutos

## Pasos

### 1. Ejecutar validación de estructura

Ejecuta el script que valida la estructura de docs/.

**Comando**:
```bash
./scripts/validar_estructura_docs.sh
```

**Output esperado**:
```
Documentation structure validation: PASSED
```

### 2. Revisar warnings

Si hay warnings, revísalos y corrígelos.

**Comando**:
```bash
# El script puede mostrar:
# WARNING: Missing frontmatter in file.md
# WARNING: Broken link to non-existent.md
```

**Output esperado**:
```
Warnings corregidos
```

### 3. Validar links

Verifica que no haya links rotos en tu documentación.

**Comando**:
```bash
# El workflow docs-validation.yml hace esto automáticamente
# Puedes ejecutarlo localmente con:
markdown-link-check docs/**/*.md
```

**Output esperado**:
```
Todos los links válidos
```

{PASO_3_DESCRIPCION}

## Validacion

Para validar que completaste correctamente esta guia:

- [ ] Script pasa sin errores
- [ ] Frontmatter YAML presente en todos los .md
- [ ] No hay links rotos
- [ ] Estructura de directorios correcta

## Como interpretar resultados

**Exito**: {DESCRIPCION_EXITO}

**Errores comunes**: Ver seccion Troubleshooting

## Troubleshooting

### Error 1: Missing frontmatter

**Sintomas**:
```
WARNING: Missing frontmatter in file.md
```

**Causa**: Archivo .md sin metadata YAML

**Solucion**:
```bash
Agrega frontmatter al inicio:
---
id: DOC-XXX
tipo: guia
categoria: onboarding
---
```

**Sintomas**: {ERROR_2_SINTOMAS}

**Causa**: {ERROR_2_CAUSA}

**Solucion**: {ERROR_2_SOLUCION}

## Proximos pasos

Despues de completar esta guia, puedes continuar con:

1. Crear PR con documentación
2. Esperar validación automática en CI

## Referencias

- Script validación: `scripts/validar_estructura_docs.sh`
- Workflow docs-validation: `.github/workflows/docs-validation.yml`
- Estándares documentación: `docs/gobernanza/CONTRIBUTING.md`

## Feedback

Si encuentras problemas con esta guia o tienes sugerencias:
- Crea un issue en GitHub con label `documentation`
- Contacta a: TBD

---

**Mantenedores**: @doc-lead, @tech-lead
**Ultima actualizacion**: 2025-11-07
