# Hallazgo — T-1.7 y declaración de paquetes del sistema

**Versión:** 1.0.0  
**Fecha:** 2026-05-11  
**Contexto:** Análisis de T-1.7 del `PLAN-DEUDA-CERO-202605102315.md`
tras la pregunta sobre si `postgresql-contrib` debe ir en `config/`

---

## H-PKG-001 — T-1.7 era un falso positivo (ya resuelto)

**Estado:** DOCUMENTADO — no requiere implementación

`postgresql-contrib` ya estaba instalado y ya estaba declarado en el
provisioner antes de que el plan fuera redactado:

```bash
# provisioners/postgres/install.sh — función install_postgresql():
if ! install_package postgresql-contrib-${POSTGRES_VERSION}; then
    log_error "Failed to install postgresql-contrib-${POSTGRES_VERSION}"
    return 1
fi
```

```
dpkg -l postgresql-contrib → ii  postgresql-contrib  16+257build1.1
```

Este es el tercer hallazgo del tipo "plan desactualizado sin verificar
estado real" (H-F1-001..H-F1-005). Los planes deben verificar el estado
real del artefacto antes de listarlo como PENDIENTE.

---

## H-PKG-002 — `config/` no es el lugar correcto para paquetes del sistema

**Estado:** DOCUMENTADO — decisión de diseño aclarada

`config/` contiene archivos que el sistema operativo usa directamente,
vinculados via symlink durante el provisionamiento:

```
config/mariadb/99-iact.cnf    → symlink → /etc/mysql/mariadb.conf.d/99-iact.cnf
config/postgres/99-iact.conf  → symlink → /etc/postgresql/16/main/conf.d/99-iact.conf
config/vhost.conf             → copy    → /etc/apache2/sites-available/adminer.conf
config/certs/                 → copy    → /etc/ssl/
```

`postgresql-contrib` es un paquete apt, no un archivo. No puede vincularse
con symlink ni copiarse a una ruta del sistema — debe instalarse con el
gestor de paquetes del SO.

**Categorías distintas, mecanismos distintos:**

| Tipo | Mecanismo | Ubicación actual |
|---|---|---|
| Archivos de config del SO | symlink/copy desde `config/` | `config/mariadb/`, `config/postgres/` |
| Paquetes del SO (apt) | `install_package` en provisioners | `provisioners/*/install.sh` |
| Dependencias Python | pip install | `test/requirements.txt` |

---

## H-PKG-003 — No existe un manifest centralizado de paquetes del sistema

**Estado:** RESUELTO — FASE 6: Opción A adoptada. Inventario de paquetes documentado en el header de `bootstrap.sh`. Decisión: provisioners autocontenidos. `config/packages/` descartado · commit a4bcf36

Los paquetes del sistema están declarados implícitamente dentro de cada
provisioner. No hay un archivo que liste todas las dependencias del proyecto
en un solo lugar.

### Estado actual (descentralizado)

```
provisioners/mariadb/install.sh:
    software-properties-common, dirmngr, apt-transport-https, curl, gpg
    mariadb-server, mariadb-client

provisioners/postgres/install.sh:
    postgresql-16, postgresql-contrib-16

provisioners/adminer/install.sh:
    apache2, software-properties-common, php, php-mysql, adminer...

(No hay lista centralizada)
```

### Opción A — Mantener el patrón actual (provisioners declaran sus propios paquetes)

**Pros:**
- Sin cambios — los provisioners ya funcionan
- Los paquetes están cerca del código que los necesita
- Un provisioner puede instalarse de forma independiente

**Contras:**
- Para saber qué necesita el proyecto completo hay que leer N scripts
- No hay un lugar para verificar "¿tengo todo instalado?"

### Opción B — Agregar `config/packages/` como manifest declarativo

```
config/
  packages/
    mariadb.txt      # paquetes del sistema para MariaDB
    postgres.txt     # paquetes del sistema para PostgreSQL
    adminer.txt      # paquetes del sistema para Adminer
    system.txt       # paquetes base (curl, jq, etc.)
```

Cada archivo es una lista de paquetes apt, uno por línea:

```
# config/packages/postgres.txt
postgresql-16
postgresql-contrib-16
```

Los provisioners leen el archivo en lugar de hardcodear los nombres:

```bash
# En install_postgresql():
while IFS= read -r pkg; do
    [[ -z "$pkg" || "$pkg" == \#* ]] && continue
    pkg="${pkg/\${POSTGRES_VERSION}/${POSTGRES_VERSION}}"
    if ! install_package "$pkg"; then
        log_error "Failed to install ${pkg}"
        return 1
    fi
done < "${PROJECT_ROOT}/config/packages/postgres.txt"
```

**Pros:**
- Un lugar para ver todas las dependencias del proyecto
- Separación entre "qué instalar" (manifest) y "cómo instalarlo" (provisioner)
- Permite verificar el estado con un script `check-dependencies.sh`

**Contras:**
- Más archivos para mantener sincronizados con los provisioners
- Añade indirección — para entender el provisioner hay que leer dos archivos

### Recomendación

Para el tamaño actual del proyecto (3 servicios, ~15 paquetes de sistema),
la Opción A es suficiente. Los provisioners son el lugar natural para declarar
sus propias dependencias.

La Opción B tiene valor si el proyecto crece a 5+ servicios con paquetes
compartidos entre provisioners, o si se quiere automatizar la verificación
de prerequisitos antes de provisionar.

**La decisión final corresponde al equipo.** Este documento la deja abierta
para la siguiente sesión de planificación.

---

## Resumen

| ID | Descripción | Estado |
|---|---|---|
| H-PKG-001 | T-1.7 ya estaba implementada — falso positivo en el plan | DOCUMENTADO |
| H-PKG-002 | `config/` es para archivos del SO, no para paquetes apt | ACLARADO |
| H-PKG-003 | No existe manifest centralizado de paquetes — decisión pendiente | RESUELTO — FASE 6: Opción A adoptada, inventario en bootstrap.sh · commit a4bcf36 |
