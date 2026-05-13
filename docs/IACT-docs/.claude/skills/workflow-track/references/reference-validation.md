# Guía de Validación de Referencias v3

## Resumen Rápido

El validador v3 analiza tu estructura THYROX y clasifica 259 referencias encontradas en:

1. **Válidas** (102): Archivos que existen y son referencian correctamente
2. **Documentales** (91): Ejemplos/patrones mostrados en documentación (OK)
3. **Rotas** (66): Archivos mencionados pero NO existen (ACCIÓN REQUERIDA)

**Resultado**: 74.5% integridad general+

---

## Cómo Ejecutar

### Ejecución Básica
```bash
python3 .claude/scripts/detect_broken_references.py
```
Genera: `reference-validation-report.txt`

### Con Debug (más detallado)
```bash
python3 .claude/scripts/detect_broken_references.py --debug
```
Muestra cada referencia conforme se valida.

### Ignorando Referencias Documentales
```bash
python3 .claude/scripts/detect_broken_references.py --ignore-examples
```
Solo cuenta referencias "concretas" (para CI/CD).

### Directorio Específico
```bash
python3 .claude/scripts/detect_broken_references.py /ruta/al/proyecto
```

---

## Entender el Reporte

El archivo `reference-validation-report.txt` tiene 3 secciones principales:

### Sección 1: REFERENCIAS VÁLIDAS
```
decisions.md:
  -> decisions/adr-001.md
  -> decisions/adr-002.md
  -> ../skills/thyrox/SKILL.md
```
Estas referencias funcionan correctamente.

### Sección 2: REFERENCIAS DOCUMENTALES
```
SKILL.md:
  [DOC] ROADMAP.md          (← Es un ejemplo en SKILL.md, no real)
  [DOC] PLAN.md             (← Mencionado como template, no real)
  [DOC] .template           (← Patrón genérico, no archivo real)
```
Estas están OK. Son ejemplos mostrados para enseñanza, no archivos reales.

### Sección 3: REFERENCIAS ROTAS
```
project-state.md:
  [ROTA] project.json       (← No existe en context)

incremental-correction.md:
  [ROTA] PLAN.md            (← No existe en raíz)
  [ROTA] SKILL.md           (← No existe donde se busca)
```
Estas REQUIEREN ACCIÓN.

---

## Problemas Detectados y Cómo Fijarlos

### Problema 1: ROADMAP.md, CHANGELOG.md, CLAUDE.md falta

**Ubicación**: Raíz de THYROX  
**Afecta**: 20+ referencias  

**Opciones de solución**:

A) Crear archivos vacíos (si van a existir):
```bash
touch /home/thyrox/ROADMAP.md
touch /home/thyrox/CHANGELOG.md
touch /home/thyrox/CLAUDE.md
touch /home/thyrox/PLAN.md
```

B) Actualizar referencias (si estos archivos no son necesarios):
```bash
# Editar cada archivo que las menciona y quitar la referencia
# O cambiar a links válidos
```

C) Crear en subcarpeta docs/ (si van a ser generados):
```bash
mkdir -p docs
touch docs/ROADMAP.md
# Luego actualizar referencias a "docs/ROADMAP.md"
```

### Problema 2: Templates no instanciados

**Ubicación**: `.thyrox/context/`
**Archivos**: `exit-conditions.md`, `project.json`

**Solución**:
```bash
# Existen as .template in assets/, crear instancias
cd /home/thyrox/.thyrox/context/
cp ../skills/workflow-discover/assets/exit-conditions.md.template exit-conditions.md
cp ../skills/workflow-discover/assets/legacy/project.json.template project.json
```

### Problema 3: Archivos en skills/ que faltan

**Ubicación**: `.claude/skills/workflow-discover/assets/` (y otros `workflow-*/assets/`)
**Nota**: Estos archivos ya existen como `.template` en assets/.
Los archivos `modes/` son aspiracionales (referenciados en skill-authoring.md pero no creados).
```

---

## Cómo Funciona Internamente

### Detección de Referencias

El script busca 2 patrones:

1. **Links Markdown**: `[Texto](ruta/archivo.md)`
2. **Rutas con extensión**: `./ruta/archivo.md`, `../ruta/archivo.json`

### Filtrado Inteligente

Ignora automáticamente:
- URLs externas (`http://...`)
- Placeholders (`YYYY-MM-DD`, `NOMBRE`, `PROYECTO`)
- Referencias en bloques de código (entre ``` ```)
- Referencias en comentarios HTML (`<!-- -->`)

### Detección de Ejemplos

Identifica referencias documentales por palabras clave:
- "ejemplo", "como", "tal como", "similar a"
- "template", "plantilla", "pattern"
- "estructura", "formato"

---

## Integración con CI/CD

El script retorna:
- `exit code 0` si NO hay referencias rotas
- `exit code 1` si hay referencias rotas

**Ejemplo en GitHub Actions**:
```yaml
- name: Validar referencias
  run: python3 .claude/scripts/detect_broken_references.py
  # Falla si hay referencias rotas
```

---

## Estadísticas de Este Proyecto

```
Archivos analizados:        46
Total referencias:          259

Desglose:
  +Válidas:               102 (39.4%)
  ~ Documentales:          91  (35.1%)
  -Rotas:                 66  (25.5%)

Integridad general: 74.5%

Archivos críticos:
  • SKILL.md               31 referencias
  • skill-authoring.md     27 referencias
  • incremental-correction.md  20 referencias
```

---

## Preguntas Frecuentes

**P: Un archivo está marcado como "documentacional" pero es real**
R: Edita el script y agrega menos palabras clave en `EXAMPLE_KEYWORDS`, o 
   usa links Markdown formales `[texto](ruta)` en lugar de referencias soltas.

**P: Quiero ignorar ciertos archivos**
R: Agrupa todo lo que quieras ignorar en una carpeta que empiece con `.`
   (ej: `.temp/`, `.docs/`) - el script las ignora automáticamente.

**P: El reporte es muy largo**
R: Usa `grep` para filtrar:
   ```bash
   grep "ROTA" reference-validation-report.txt
   grep "FILE_NAME" reference-validation-report.txt
   ```

**P: Quiero validar solo un subdirectorio**
R: ```bash
   python3 .claude/scripts/detect_broken_references.py .claude/skills/
   ```

---

## Próximas Mejoras

Potenciales features para futuras versiones:
- Detectar referencias circulares
- Generar gráfico de dependencias
- Sugerir refactoring automático
- Validar referencias en JSON
- Exportar a CSV/JSON

---

## Soporte

Para problemas o mejoras:
1. Revisar el reporte detallado en `reference-validation-report.txt`
2. Ejecutar con `--debug` para ver más detalle
3. Revisar la estructura esperada en `.thyrox/context/`
