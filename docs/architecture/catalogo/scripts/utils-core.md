# `utils/core.sh`

**Versión:** 0.2.0  
**Fuente para:** Todos los provisioners

---

## Propósito

Funciones utilitarias de bajo nivel para operaciones de sistema de archivos
y gestión de servicios. Es el primer script que cargan todos los provisioners.

---

## Funciones principales

| Función | Descripción |
|---|---|
| `ensure_dir(path)` | Crea directorio si no existe |
| `backup_file(file)` | Hace backup con timestamp antes de modificar |
| `service_action(service, action)` | systemctl → service → arranque directo |
| `install_package(pkg)` | apt-get install con manejo de errores |

---

## Correcciones aplicadas (FASE 1)

- `local backup=$(date ...)` → separado en dos líneas (BUG-007, SC2155)
- `break` sin loop → `return 1` en `service_action` (BUG-001)
