---
id: GUIA-onboarding-007
tipo: guia_operativa
categoria: onboarding
audiencia: desarrollador
prioridad: P0
tiempo_lectura: 5 minutos
version: 1.0.0
fecha: 2025-11-07
relacionados: []
---

# Generar Indices de Requisitos

## Proposito

Aprende a generar automáticamente índices de requisitos del proyecto.

## Audiencia

Esta guia esta dirigida a: desarrollador

## Pre-requisitos

- [ ] Requisitos escritos en docs/requisitos/
- [ ] Python 3.11+ instalado

## Tiempo estimado

Tiempo de lectura: 5 minutos
Tiempo de ejecucion: 10 minutos

## Pasos

### 1. Ejecutar generador de índices

Ejecuta el script Python que genera índices automáticamente.

**Comando**:
```bash
python scripts/requisitos/generar_indices.py
```

**Output esperado**:
```
Índices generados en docs/requisitos/
```

### 2. Verificar índices generados

Revisa que los índices se generaron correctamente.

**Comando**:
```bash
ls docs/requisitos/*/INDICE.md
```

**Output esperado**:
```
Lista de archivos INDICE.md
```

### 3. Commit de índices

Los índices son auto-generados, commitéalos.

**Comando**:
```bash
git add docs/requisitos/*/INDICE.md
git commit -m "docs(requisitos): actualizar indices automaticos"
```

**Output esperado**:
```
Índices commiteados
```

{PASO_3_DESCRIPCION}

## Validacion

Para validar que completaste correctamente esta guia:

- [ ] Script ejecuta sin errores
- [ ] Archivos INDICE.md generados
- [ ] Índices contienen todos los requisitos
- [ ] Links en índices funcionan

## Como interpretar resultados

**Exito**: {DESCRIPCION_EXITO}

**Errores comunes**: Ver seccion Troubleshooting

## Troubleshooting

### Error 1: Script falla por frontmatter inválido

**Sintomas**:
```
Error parsing YAML frontmatter
```

**Causa**: Algún requisito tiene frontmatter mal formateado

**Solucion**:
```bash
Valida frontmatter:
python scripts/requisitos/validar_frontmatter.py
# Corrige el archivo que marca como inválido
```

**Sintomas**: {ERROR_2_SINTOMAS}

**Causa**: {ERROR_2_CAUSA}

**Solucion**: {ERROR_2_SOLUCION}

## Proximos pasos

Despues de completar esta guia, puedes continuar con:

1. Validar trazabilidad de requisitos
2. Crear PR con índices actualizados

## Referencias

- Script generador: `scripts/requisitos/generar_indices.py`
- Workflow requirements_index: `.github/workflows/requirements_index.yml`
- Plantilla requisito: `docs/plantillas/template_requisito_funcional.md`

## Feedback

Si encuentras problemas con esta guia o tienes sugerencias:
- Crea un issue en GitHub con label `documentation`
- Contacta a: TBD

---

**Mantenedores**: @arquitecto-senior, @product-owner
**Ultima actualizacion**: 2025-11-07
