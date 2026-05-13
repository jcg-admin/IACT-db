---
id: TASK-REORG-BACK-013
tipo: tarea
categoria: consolidacion-diseno
titulo: Crear README diseno/api/
fase: FASE_2
prioridad: MEDIA
duracion_estimada: 10min
estado: pendiente
dependencias: ["TASK-REORG-BACK-012"]
---

# TASK-REORG-BACK-013: Crear README diseno/api/

**Fase:** FASE 2 - Consolidacion diseno/
**Prioridad:** MEDIA
**Duracion Estimada:** 10 minutos
**Responsable:** Tech Writer
**Estado:** PENDIENTE

---

## Objetivo

Crear un README.md completo en docs/backend/diseno/api/ que documente el proposito, contenido y estructura de la documentacion de diseno de APIs.

---

## Auto-CoT: Razonamiento Paso a Paso

### Pensamiento 1: Por que necesitamos este README
- **Problema:** Nueva carpeta sin contexto para desarrolladores
- **Solucion:** README que explique que contiene y como usar
- **Beneficio:** Onboarding rapido, navegacion clara

### Pensamiento 2: Que debe contener el README
- Proposito de la carpeta
- Estructura de archivos
- Convenciones de documentacion
- Enlaces a recursos relacionados
- Ejemplos de uso

### Pensamiento 3: Como mantener consistencia
- Seguir formato de READMEs en docs/gobernanza/
- Incluir metadata en frontmatter
- Usar markdown estandar
- Referencias cruzadas con otros documentos

---

## Prerequisitos

- [ ] TASK-012 completada (archivos movidos a diseno/api/)
- [ ] docs/backend/diseno/api/ existe y tiene contenido
- [ ] Permisos de escritura en docs/backend/diseno/api/

---

## Pasos de Ejecucion

### Paso 1: Analizar Contenido Actual
```bash
# Listar archivos en diseno/api/
echo "=== Archivos en diseno/api/ ==="
find docs/backend/diseno/api/ -type f | sort

# Identificar tipos de documentos
echo "=== Tipos de archivos ==="
find docs/backend/diseno/api/ -type f -name "*.md" | wc -l
find docs/backend/diseno/api/ -type f -name "*.yaml" -o -name "*.yml" | wc -l
find docs/backend/diseno/api/ -type f -name "*.json" | wc -l
```

**Resultado Esperado:** Inventario de contenido de la carpeta

### Paso 2: Crear Estructura Base del README
```bash
cat > docs/backend/diseno/api/README.md << 'EOF'
---
id: README-DISENO-API
tipo: documentacion
categoria: diseno
subcategoria: api
fecha_creacion: 2025-11-18
ultima_actualizacion: 2025-11-18
version: 1.0.0
estado: vigente
---

# Diseno de APIs - Backend IACT

## Proposito

Esta carpeta centraliza toda la documentacion relacionada con el diseno de APIs REST del backend IACT.

## Contenido

- Especificaciones de endpoints
- Contratos de API (OpenAPI/Swagger)
- Documentacion de payloads
- Guias de versionado de APIs
- Ejemplos de requests/responses
- Politicas de API

## Estructura

```
diseno/api/
 README.md (este archivo)
 especificaciones/ # Especificaciones detalladas de endpoints
 contratos/ # Archivos OpenAPI/Swagger
 ejemplos/ # Ejemplos de uso
 politicas/ # Politicas y convenciones
```

## Convenciones

### Nomenclatura de Archivos
- Especificaciones: `{servicio}-{version}-api-spec.md`
- Contratos: `{servicio}-{version}-openapi.yaml`
- Ejemplos: `{endpoint}-example.json`

### Versionado de APIs
- Seguir Semantic Versioning (semver.org)
- Documentar breaking changes
- Mantener retrocompatibilidad cuando sea posible

## Relacion con Otras Carpetas

- `/diseno/arquitectura/` - Decisiones arquitectonicas de APIs
- `/implementacion/` - Codigo de implementacion de APIs
- `/pruebas/apis/` - Tests de APIs

## Recursos

- [Guia de Diseno de APIs REST](../../referencias/rest-api-guidelines.md)
- [Estandar OpenAPI](https://spec.openapis.org/oas/latest.html)
- [Documentacion Swagger](https://swagger.io/docs/)

## Mantenimiento

- **Responsable:** Equipo Backend
- **Frecuencia de Revision:** Trimestral
- **Ultima Revision:** 2025-11-18

## Contribucion

Para agregar o modificar documentacion de APIs:

1. Seguir convenciones de nomenclatura
2. Incluir frontmatter en archivos markdown
3. Actualizar este README si se agregan nuevas secciones
4. Crear PR con cambios para revision

---

**Documento creado:** 2025-11-18
**Version:** 1.0.0
**Estado:** VIGENTE
EOF
```

**Resultado Esperado:** README.md creado con estructura base

### Paso 3: Personalizar con Contenido Real
```bash
# Analizar archivos existentes para personalizar README
# (Este paso puede requerir edicion manual basada en contenido real)

# Listar carpetas existentes
SUBDIRS=$(find docs/backend/diseno/api/ -maxdepth 1 -type d ! -path "docs/backend/diseno/api/" -exec basename {} \; | sort)

# Agregar subdirectorios al README si existen
if [ -n "$SUBDIRS" ]; then
 echo "Subdirectorios encontrados: $SUBDIRS"
 # Actualizar seccion de Estructura en README
fi
```

**Resultado Esperado:** README personalizado con contenido real

### Paso 4: Validar Formato Markdown
```bash
# Verificar que README es markdown valido
if command -v mdl &> /dev/null; then
 mdl docs/backend/diseno/api/README.md
else
 echo "SKIP: markdownlint no instalado"
fi

# Verificar frontmatter YAML
head -20 docs/backend/diseno/api/README.md | grep -A 10 "^---$"
```

**Resultado Esperado:** Markdown valido, frontmatter correcto

### Paso 5: Verificar Enlaces
```bash
# Verificar que enlaces internos existen
grep -o '\[.*\](.*\.md)' docs/backend/diseno/api/README.md | \
 sed 's/.*(\(.*\))/\1/' | \
 while read link; do
 if [ -f "docs/backend/diseno/api/$link" ]; then
 echo "OK: $link existe"
 else
 echo "WARNING: $link no encontrado"
 fi
 done
```

**Resultado Esperado:** Verificacion de enlaces (warnings si no existen aun)

### Paso 6: Agregar a Git
```bash
# Agregar README al staging
git add docs/backend/diseno/api/README.md

# Verificar que esta staged
git status docs/backend/diseno/api/README.md
```

**Resultado Esperado:** README en staging

---

## Criterios de Exito

- [ ] README.md creado en docs/backend/diseno/api/
- [ ] Contiene frontmatter con metadata completa
- [ ] Describe proposito de la carpeta
- [ ] Documenta estructura y convenciones
- [ ] Incluye enlaces a recursos relacionados
- [ ] Markdown valido
- [ ] Agregado a git staging

---

## Validacion

```bash
# Validacion 1: Verificar que README existe
if [ -f "docs/backend/diseno/api/README.md" ]; then
 echo "OK: README.md existe"
else
 echo "ERROR: README.md no encontrado"
 exit 1
fi

# Validacion 2: Verificar frontmatter
if head -1 docs/backend/diseno/api/README.md | grep -q "^---$"; then
 echo "OK: Frontmatter presente"
else
 echo "WARNING: Frontmatter faltante o incorrecto"
fi

# Validacion 3: Verificar secciones minimas
REQUIRED_SECTIONS="Proposito Contenido Estructura Convenciones"
for section in $REQUIRED_SECTIONS; do
 if grep -q "## $section" docs/backend/diseno/api/README.md; then
 echo "OK: Seccion '$section' presente"
 else
 echo "WARNING: Seccion '$section' faltante"
 fi
done

# Validacion 4: Contar palabras (debe ser sustancial)
WORD_COUNT=$(wc -w < docs/backend/diseno/api/README.md)
if [ "$WORD_COUNT" -gt 100 ]; then
 echo "OK: README sustancial ($WORD_COUNT palabras)"
else
 echo "WARNING: README muy breve ($WORD_COUNT palabras)"
fi

# Validacion 5: Verificar que esta en git staging
if git diff --cached --name-only | grep -q "docs/backend/diseno/api/README.md"; then
 echo "OK: README en staging"
else
 echo "WARNING: README no esta en staging"
fi
```

**Salida Esperada:**
- README existe
- Frontmatter correcto
- Secciones requeridas presentes
- Contenido sustancial
- En git staging

---

## Self-Consistency: Verificacion de Coherencia

### Verificacion 1: Consistencia de Formato
- [ ] Frontmatter sigue formato estandar del proyecto
- [ ] Secciones en orden logico
- [ ] Nivel de headers correcto (## para secciones principales)

### Verificacion 2: Consistencia de Contenido
- [ ] Describe contenido real de la carpeta
- [ ] Convenciones alineadas con guias del proyecto
- [ ] Enlaces apuntan a ubicaciones correctas

### Verificacion 3: Consistencia con Otros READMEs
- [ ] Formato similar a READMEs en docs/gobernanza/
- [ ] Nivel de detalle apropiado
- [ ] Tono profesional y claro

---

## Rollback

Si se necesita deshacer:
```bash
# Remover README de staging
git reset HEAD docs/backend/diseno/api/README.md

# Eliminar archivo
rm docs/backend/diseno/api/README.md

# Verificar eliminacion
ls docs/backend/diseno/api/README.md 2>/dev/null || echo "README eliminado"
```

**ADVERTENCIA:** Solo ejecutar rollback ANTES de hacer commit

---

## Riesgos

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|-----------|
| README no refleja contenido real | MEDIA | MEDIO | Analizar carpeta antes de escribir |
| Enlaces rotos | MEDIA | BAJO | Verificar enlaces, usar paths relativos |
| Formato inconsistente | BAJA | BAJO | Seguir template de READMEs existentes |
| Informacion desactualizada | BAJA | MEDIO | Incluir fecha de revision y versionado |

---

## Evidencias a Capturar

1. Archivo README.md completo
2. Output de validacion de secciones
3. Output de git status mostrando README staged
4. Screenshot del README renderizado (opcional)

---

## Template de README

Ver contenido completo en Paso 2. Incluye:
- Frontmatter con metadata
- Proposito
- Contenido
- Estructura
- Convenciones
- Relacion con otras carpetas
- Recursos
- Mantenimiento
- Contribucion

---

## Notas

- Personalizar template basado en contenido real de la carpeta
- Actualizar README cuando se agreguen nuevas secciones
- Mantener enlaces relativos para portabilidad
- Incluir ejemplos concretos si es posible
- Revisar ortografia y gramática
- Considerar agregar diagramas si es relevante

---

## Tiempo de Ejecucion

**Inicio:** __:__
**Fin:** __:__
**Duracion Real:** __ minutos

---

## Checklist de Finalizacion

- [ ] Contenido de carpeta analizado
- [ ] README.md creado con template completo
- [ ] Frontmatter con metadata correcta
- [ ] Secciones requeridas presentes
- [ ] Contenido personalizado (no generico)
- [ ] Enlaces verificados
- [ ] Markdown valido
- [ ] Agregado a git staging
- [ ] Self-Consistency checks pasados
- [ ] Tarea marcada como COMPLETADA en INDICE.md

---

**Tarea creada:** 2025-11-18
**Ultima actualizacion:** 2025-11-18
**Version:** 1.0.0
**Estado:** PENDIENTE
