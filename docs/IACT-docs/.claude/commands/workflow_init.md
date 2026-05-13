# /workflow_init — Bootstrap de Tech Skills

Detecta el stack tecnológico del proyecto, genera tech skills desde el registry, y los commitea a git. Ejecutar UNA SOLA VEZ por proyecto.

---

## Paso 1: Detectar tech skills existentes

Antes de detectar, verificar si ya existen tech skills generados:

```bash
ls .claude/skills/ | grep -v thyrox
```

Si existen skills (`frontend-react`, `backend-nodejs`, etc.):
- Mostrar: "Tech skills ya configurados: [lista]. ¿Regenerar con --force? (s/n)"
- Si el usuario dice no: detener aquí
- Si el usuario dice sí: continuar con detección y usar `--force` al generar

---

## Paso 2: Escanear el proyecto

Examinar los siguientes archivos para detectar el stack:

| Archivo / Patrón | Tech skill |
|---|---|
| `package.json` con `"react"` en dependencies | `frontend-react` |
| `package.json` con `"vue"` en dependencies | `frontend-vue` |
| `package.json` con `"next"` en dependencies | `frontend-nextjs` |
| `package.json` sin framework frontend conocido | `backend-nodejs` |
| `package.json` con `"express"`, `"fastify"`, `"koa"` | `backend-nodejs` |
| `requirements.txt` o `pyproject.toml` | `backend-python` (si template existe) |
| `go.mod` | `backend-go` (si template existe) |
| `Gemfile` | `backend-ruby` (si template existe) |
| `*.sql` o `docker-compose.yml` con `postgres` | `db-postgresql` |
| `docker-compose.yml` con `mysql` | `db-mysql` (si template existe) |
| `docker-compose.yml` con `mongo` | `db-mongodb` (si template existe) |

Para cada detección, anotar QUÉ archivo la justifica.

---

## Paso 3: Verificar templates disponibles

Para cada tech detectada, verificar que el template existe:

```bash
ls .claude/registry/frontend/ .claude/registry/backend/ .claude/registry/db/ 2>/dev/null
```

Si una tech detectada no tiene template en el registry:
- Informar al usuario: "Detecté [tech] pero no hay template en registry/[layer]/[framework].template.md"
- Preguntar si quiere continuar sin ese skill o si quiere crearlo primero

---

## Paso 4: Presentar detección y pedir confirmación

Mostrar resumen al usuario:

```
Stack detectado para [nombre-proyecto]:
  frontend-react     (package.json → "react": "^18.0.0")
  backend-nodejs     (package.json → "express": "^4.18.0")
  db-postgresql      (docker-compose.yml → image: postgres)

¿Confirmas? Puedes agregar o quitar techs manualmente.
Techs disponibles en el registry: [listar .claude/registry/*/*]
```

Esperar confirmación. Permitir que el usuario modifique la lista antes de continuar.

---

## Paso 5: Generar skills

Para cada tech confirmada, ejecutar:

```bash
.claude/registry/_generator.sh [layer] [framework] [nombre-proyecto]
# Si ya existen y el usuario confirmó regenerar:
.claude/registry/_generator.sh [layer] [framework] [nombre-proyecto] --force
```

Mostrar cada archivo generado al usuario.

---

## Paso 6: Commitear a git

```bash
git add .claude/skills/ .claude/guidelines/
git commit -m "feat(skills): bootstrap [lista-skills]

Tech skills generados desde registry para proyecto [nombre].
Activos automáticamente en próximas sesiones via .instructions.md."
```

---

## Paso 7: Confirmar éxito

Mostrar resumen final:
- Skills generados: [lista con archivos]
- Próximas sesiones: los skills se activan automáticamente
- Para actualizar un skill en el futuro: `.claude/registry/_generator.sh [layer] [framework] --force`
- Siguiente paso sugerido: `/thyrox:discover` para empezar Phase 1
