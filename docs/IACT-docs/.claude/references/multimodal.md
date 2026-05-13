```yml
type: Reference
title: Multimodal — Leer Imágenes, PDFs, Notebooks y Screenshots
category: Claude Code Platform — I/O
version: 1.0
created_at: 2026-04-13
owner: thyrox (cross-phase)
purpose: Leer imágenes, PDFs, notebooks Jupyter y screenshots con el Read tool
```

# Multimodal — Leer Imágenes, PDFs, Notebooks y Screenshots

Claude Code puede procesar archivos visuales y documentos ricos usando la herramienta `Read`.

---

## Image Reading

### Formatos soportados

| Formato | Extensión | Notas |
|---------|-----------|-------|
| PNG | `.png` | Más común para screenshots y diagramas |
| JPEG | `.jpg`, `.jpeg` | Fotos y capturas comprimidas |
| GIF | `.gif` | Solo primer frame (no animado) |
| WebP | `.webp` | Formato moderno, buena calidad/tamaño |

### Uso con Read tool

```
Read(file_path="/path/to/screenshot.png")
```

No se necesitan parámetros adicionales — Claude interpreta el contenido visual automáticamente.

### Casos de uso

**Screenshots de UI:**
```
Read(file_path="/tmp/bug-screenshot.png")
# → Claude describe el error visual, identifica elementos, sugiere fix
```

**Diagramas de arquitectura:**
```
Read(file_path="/docs/architecture.png")
# → Claude interpreta el diagrama, describe componentes, relaciones
```

**Mockups de diseño:**
```
Read(file_path="/designs/new-feature-mockup.png")
# → Claude describe el diseño, identifica componentes a implementar
```

**Capturas de error:**
```
Read(file_path="/tmp/error-stacktrace.png")
# → Claude lee el stack trace visual, identifica la causa
```

### Limitaciones

- **No OCR de alta precisión**: texto muy pequeño o con fuente decorativa puede leerse incorrectamente
- **No análisis de texto denso**: PDFs escaneados como imagen tienen peor precisión que PDFs nativos
- **No comparación pixel-perfect**: Claude interpreta semánticamente, no hace diff visual exacto
- **Tamaño máximo**: imágenes muy grandes (~10MB+) pueden fallar

---

## PDF Reading

### Uso básico

```
Read(file_path="/path/to/document.pdf")
```

### Para PDFs grandes — `pages:` es OBLIGATORIO

```
Read(file_path="/path/to/large-doc.pdf", pages="1-5")
Read(file_path="/path/to/large-doc.pdf", pages="3")
Read(file_path="/path/to/large-doc.pdf", pages="10-20")
```

**Máximo:** 20 páginas por request. PDFs con más de ~10 páginas sin el parámetro `pages:` fallarán con error.

### Casos de uso

**Documentación técnica:**
```
Read(file_path="/docs/api-spec.pdf", pages="1-15")
# → Claude lee la spec, puede hacer preguntas sobre ella
```

**Reportes y análisis:**
```
Read(file_path="/reports/q4-analysis.pdf", pages="1-5")
# → Claude extrae datos, genera resúmenes
```

**Contratos y specs:**
```
Read(file_path="/legal/contract.pdf", pages="1-10")
# → Claude identifica cláusulas relevantes
```

### Limitaciones

- **PDFs escaneados**: Si el PDF es una imagen escaneada (no texto nativo), la precisión es menor
- **PDFs con DRM**: PDFs con protección de copia pueden no leerse
- **Formularios interactivos**: Los campos de formulario PDF no siempre se leen correctamente
- **Máximo 20 páginas** por llamada — dividir en múltiples Read para documentos largos

---

## Jupyter Notebooks (.ipynb)

### Uso

```
Read(file_path="/path/to/analysis.ipynb")
```

### Qué retorna

Todas las celdas del notebook con sus outputs:
- Celdas de código + resultado de ejecución
- Celdas Markdown como texto
- Outputs numéricos, texto, y referencias a plots
- Errores de ejecución si los hubo

### Casos de uso

**Análisis de datos:**
```
Read(file_path="/notebooks/data-exploration.ipynb")
# → Claude ve el código Python + los resultados + los plots descritos
```

**Experimentos de ML:**
```
Read(file_path="/experiments/model-training.ipynb")
# → Claude ve hyperparámetros, métricas, curvas de pérdida
```

**Documentación ejecutable:**
```
Read(file_path="/tutorials/getting-started.ipynb")
# → Claude puede responder preguntas sobre el tutorial
```

---

## Screenshots y debugging visual

El flujo más común en debugging de UI:

**1. El usuario toma un screenshot del bug**
```bash
# En macOS: Cmd+Shift+4 → guardar en /tmp/
# En Linux: screenshot tool → guardar en /tmp/
```

**2. Claude lee el screenshot**
```
Read(file_path="/tmp/bug-2026-04-13.png")
```

**3. Claude describe lo que ve y sugiere fixes**
```
# Output: "Veo un error de layout donde el botón 'Submit' está fuera del 
# formulario. El padding del contenedor padre parece estar incorrecto..."
```

### Validación de cambios de UI

```
Read(file_path="/tmp/before.png")
Read(file_path="/tmp/after.png")
# → Claude puede describir las diferencias visuales
```

---

## Combinación de fuentes

Claude puede procesar múltiples tipos en una sola sesión:

```
# Leer spec PDF + código fuente + screenshot del bug
Read("/docs/spec.pdf", pages="1-5")
Read("/src/component.tsx")
Read("/tmp/bug.png")
# → Claude tiene todo el contexto para diagnosticar
```

---

## Tabla de referencia rápida

| Tipo | Tool | Parámetros clave | Límite |
|------|------|-----------------|--------|
| PNG/JPG/GIF/WebP | `Read` | `file_path` | ~10MB |
| PDF nativo | `Read` | `file_path`, `pages` | 20 páginas/request |
| PDF escaneado | `Read` | `file_path`, `pages` | 20 páginas/request (menor precisión) |
| `.ipynb` notebook | `Read` | `file_path` | Tamaño del archivo |
| Screenshot debugging | `Read` | `file_path` | ~10MB |
