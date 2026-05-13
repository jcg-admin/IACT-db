---
title: Script: check_no_emojis.py
date: 2025-11-13
domain: general
status: active
---

# Script: check_no_emojis.py

**Ubicacion:** `scripts/check_no_emojis.py`
**Proposito:** Detectar y prevenir uso de emojis en codigo y documentacion
**Ownership:** Tech Lead
**Prioridad:** P0 (CRITICO - Pre-commit hook)

## Descripcion

Script Python que valida que NO se usen emojis en archivos del proyecto. Se ejecuta como pre-commit hook para mantener profesionalismo y compatibilidad del codigo.

## Uso

### Sintaxis Basica

```bash
# Verificar archivos especificos (git staged)
python scripts/check_no_emojis.py archivo1.py archivo2.md

# Verificar todo el proyecto
python scripts/check_no_emojis.py --all
```

## Funcionamiento

### Patrones de Emojis Detectados

El script detecta emojis usando:

1. **Rangos Unicode de emojis:**
   - U+1F600-U+1F64F: Emoticons
   - U+1F300-U+1F5FF: Simbolos y pictogramas
   - U+1F680-U+1F6FF: Transporte
   - U+1F1E0-U+1F1FF: Banderas
   - Y otros rangos Unicode comunes

2. **Lista de emojis comunes:** El script detecta emojis comunes de checkmarks, simbolos de advertencia, iconos de herramientas, indicadores de estado, iconos de metricas, y simbolos de color

### Archivos Validados

**Extensiones validadas:**
- `.md`, `.txt` (Documentacion)
- `.py` (Python)
- `.js`, `.ts`, `.jsx`, `.tsx` (JavaScript/TypeScript)
- `.yaml`, `.yml`, `.json` (Configuracion)
- `.sh`, `.bash` (Scripts shell)

**Directorios excluidos:**
- `.git`, `.venv`, `venv`, `node_modules`
- `__pycache__`, `.pytest_cache`, `htmlcov`
- `.mypy_cache`, `dist`, `build`

### Excepciones Permitidas

**Box-drawing characters (U+2500-U+257F):** Permitidos para arboles de directorios
```
├── directorio/
│   ├── archivo1.py
│   └── archivo2.py
└── otro/
```

## Exit Codes

| Codigo | Significado |
|--------|-------------|
| 0 | No se encontraron emojis (SUCCESS) |
| 1 | Se encontraron emojis (FAIL) |

## Output

### Cuando encuentra emojis:

```
ERROR: Emojis detectados en docs/README.md
======================================================================
  Linea 12: [checkmark-emoji]
    Contexto: - [checkmark-emoji] Feature completada

  Linea 45: [rocket-emoji]
    Contexto: ## [rocket-emoji] Deployment

======================================================================
TOTAL: 2 emojis encontrados en 1 archivos
======================================================================

El proyecto NO permite emojis en documentacion o codigo.
Ver: docs/gobernanza/GUIA_ESTILO.md para mas informacion.

Alternativas recomendadas:
  - En lugar de checkmark usar: [x] o 'Completado'
  - En lugar de X-mark usar: [ ] o 'Pendiente'
  - En lugar de rocket usar: simplemente omitir
  - En lugar de warning usar: 'ADVERTENCIA:' o 'Nota:'
```

### Cuando NO encuentra emojis:

```
OK: No se encontraron emojis en 42 archivos verificados.
```

## Integracion en Git Hooks

### Pre-commit Hook

El script se ejecuta automaticamente antes de cada commit.

**Setup:**
```bash
# Instalar pre-commit hook
python scripts/install_hooks.sh

# El hook se ejecutara automaticamente en:
git add .
git commit -m "mensaje"
# -> check_no_emojis.py se ejecuta aqui
# -> Si falla, commit es rechazado
```

## Alternativas Recomendadas

### En lugar de emojis, usar:

| Emoji Descripcion | Alternativa |
|-------------------|-------------|
| checkmark | `[x]` o `Completado` |
| X-mark | `[ ]` o `Pendiente` |
| rocket | Omitir o `Release` |
| warning | `ADVERTENCIA:` o `Nota:` |
| wrench | `Config` o `Setup` |
| memo | `Docs` o `Documentacion` |
| lightbulb | `Tip:` o `Sugerencia:` |
| siren | `ALERTA:` o `CRITICO:` |
| target | `Objetivo:` |
| bar-chart | `Metricas` o `Estadisticas` |

## Troubleshooting

### False Positive: Box-drawing characters

**Problema:** Script marca como emoji caracteres de arbol de directorios

**Solucion:** Los box-drawing characters estan permitidos. Si marca error, reporta bug.

```bash
# Estos estan PERMITIDOS:
├── directorio/
│   └── archivo.py
└── otro/
```

### Error: ModuleNotFoundError

**Problema:**
```
ModuleNotFoundError: No module named 'X'
```

**Causa:** Dependencias Python faltantes

**Solucion:**
```bash
pip install -r requirements.txt
```

### Script muy lento con --all

**Problema:** Script tarda mucho en validar todo el proyecto

**Causa:** Muchos archivos a validar

**Solucion:** Validar solo archivos staged en lugar de --all:
```bash
# En lugar de:
python scripts/check_no_emojis.py --all

# Usar:
git add <archivos>
python scripts/check_no_emojis.py $(git diff --cached --name-only)
```

## Arquitectura del Script

```python
# Flujo principal:

1. Parsear argumentos CLI
   |
   v
2. Identificar archivos a validar
   - Si --all: buscar todos los archivos del proyecto
   - Si archivos especificos: usar los proporcionados
   |
   v
3. Filtrar archivos por extension y directorio
   - Solo extensiones validas (.py, .md, etc)
   - Excluir directorios (.git, .venv, etc)
   |
   v
4. Para cada archivo:
   - Leer contenido linea por linea
   - Buscar emojis con regex Unicode
   - Buscar emojis comunes de lista
   - Filtrar box-drawing characters (permitidos)
   - Registrar hallazgos
   |
   v
5. Si hallazgos > 0:
   - Imprimir errores con contexto
   - Imprimir alternativas recomendadas
   - Exit code 1 (FAIL)
   |
   v
6. Si hallazgos == 0:
   - Imprimir OK
   - Exit code 0 (SUCCESS)
```

## Mejores Practicas

1. **Ejecutar antes de commit:**
   ```bash
   # Validar antes de commitear:
   python scripts/check_no_emojis.py $(git diff --cached --name-only)
   ```

2. **Integrar en CI/CD:**
   ```yaml
   # .github/workflows/backend-ci.yml
   - name: Check no emojis
     run: python scripts/check_no_emojis.py --all
   ```

3. **No desactivar el hook:**
   - NO uses `git commit --no-verify` para saltarte el hook
   - Si encuentras emojis, reemplazalos con alternativas

4. **Documentacion sin emojis:**
   - Usa texto descriptivo en lugar de emojis
   - Mejora legibilidad para lectores de pantalla
   - Profesionalismo en documentacion tecnica

## Justificacion: Por que NO emojis?

### Razones tecnicas:

1. **Compatibilidad:** No todos los terminales/editores renderizan emojis correctamente
2. **Accesibilidad:** Lectores de pantalla no leen emojis adecuadamente
3. **Profesionalismo:** Codigo tecnico debe ser formal y claro
4. **Legibilidad:** Emojis pueden ser ambiguos o interpretarse diferente
5. **Git diff:** Emojis complican visualizacion de diffs en terminal
6. **Busqueda:** Dificil buscar/grep texto que usa emojis

### Alternativa:

Usar texto descriptivo y claro que es:
- Universal: funciona en cualquier terminal
- Accesible: lectores de pantalla lo leen correctamente
- Profesional: apropiado para documentacion tecnica
- Searchable: facil de buscar con grep/find

## Referencias

- Codigo fuente: `scripts/check_no_emojis.py`
- Guia de estilo: `docs/gobernanza/GUIA_ESTILO.md`
- Hook installer: `scripts/install_hooks.sh`
- Pre-commit config: `.pre-commit-config.yaml`

## Ownership

- **Maintainer:** Tech Lead
- **Reviewers:** DevOps Team
- **Approvers:** Arquitecto Senior

---

**Ultima actualizacion:** 2025-11-07
**Version:** 1.0.0
