# Análisis forense — Adminer: separación de responsabilidades

**Versión:** 1.0.0  
**Fecha:** 2026-05-11  
**Contexto:** Complemento al análisis forense de MariaDB y PostgreSQL.
El análisis anterior omitió Adminer. Este documento lo cubre con el
mismo nivel de profundidad.

---

## Por qué Adminer no estaba en el análisis anterior

El análisis de código muerto se centró en funciones no invocadas desde
`main()`. En Adminer, `configure_apache()` SÍ se llama desde `main()` —
no es código muerto en ese sentido. Sin embargo, tiene exactamente el mismo
problema de separación de responsabilidades que `configure_postgresql()` y
`configure_mariadb()`: es configuración del servicio del SO dentro de
`install.sh`.

Adicionalmente, `ssl.sh` tiene lógica de configuración que tampoco ha sido
analizada. Y `config/vhost.conf` y `config/vhost_ssl.conf` tienen IPs
hardcodeadas que rompen la idempotencia en N servidores.

---

## Inventario de funciones por archivo

### `provisioners/adminer/install.sh` — 295 líneas

| Función | Líneas | Ops clave | Capa correcta | Capa actual |
|---|---|---|---|---|
| `install_apache()` | L72-L102 | `install_package apache2`, `a2enmod` | INSTALL | install.sh ✓ |
| `add_php_repository()` | L105-L129 | `apt-get update`, add-apt-repository | INSTALL | install.sh ✓ |
| `install_php()` | L132-L172 | `install_package php`, `phpenmod` | INSTALL | install.sh ✓ |
| `install_adminer()` | L175-L216 | `wget adminer.php`, `cp`, `chmod`, `chown` | INSTALL (deploy) | install.sh ✓ |
| `configure_apache()` | L219-L294 | `cp config/vhost.conf`, `a2ensite`, `apachectl`, `systemctl reload` | CONFIG | install.sh **✗** |

### `provisioners/adminer/ssl.sh` — 474 líneas

| Función | Líneas | Ops clave | Capa correcta |
|---|---|---|---|
| `ensure_certificate_authority()` | L85-L152 | `openssl genrsa`, `openssl req -x509`, escribe en `config/certs/ca/` | CONFIG (genera activos de seguridad) |
| `generate_adminer_certificate()` | L153-L282 | `openssl genrsa`, `openssl req`, `openssl x509`, escribe en `config/certs/` | CONFIG |
| `install_certificates_to_apache()` | L283-L323 | `cp config/certs/ → /etc/ssl/` | CONFIG |
| `configure_ssl_vhost()` | L324-L362 | `cp config/vhost_ssl.conf → sites-available/`, `a2ensite` | CONFIG |
| `enable_ssl_site()` | L363-L444 | `a2enmod ssl`, `apachectl configtest`, `systemctl reload` | CONFIG |
| `show_windows_instructions()` | L446-fin | `echo` instrucciones para instalar CA en Windows | Informativo |

### `provisioners/adminer/bootstrap.sh` — 77 líneas

```bash
steps=( "adminer_system" "adminer_swap" "adminer_install" "adminer_ssl" )
```

No tiene paso `adminer_config` — `configure_apache()` vive dentro de
`adminer_install` (install.sh).

### `provisioners/adminer/swap.sh` — 252 líneas

Gestión de swap (`create_swap_file`, `configure_swap`, `make_swap_permanent`).
No toca instalación de paquetes ni configuración de servicios web. Capa correcta.

---

## Hallazgo 1 — `configure_apache()` en `install.sh`: mismo problema

`configure_apache()` se llama desde `main()` de `install.sh`, pero sus
operaciones son configuración del servicio del SO, no instalación:

```bash
configure_apache() {
    cp config/vhost.conf → /etc/apache2/sites-available/adminer.conf  # CONFIG
    apachectl configtest                                                # CONFIG
    a2dissite 000-default.conf                                         # CONFIG
    a2ensite adminer.conf                                              # CONFIG
    systemctl reload apache2                                           # CONFIG
    wait_for_url "http://localhost" 30 200                             # CONFIG
}
```

**Diferencia con MariaDB/PostgreSQL:** En aquellos motores, el archivo
de configuración ya existía (`pg_hba.conf`, `50-server.cnf`) y se modificaba.
En Apache, `configure_apache()` CREA el archivo de configuración copiando
desde `config/vhost.conf` y lo activa.

**¿Es la misma mezcla?** Sí. `install.sh` debería responsabilizarse de
instalar los paquetes (`apache2`, `php`, `adminer`). `configure_apache()`
debería vivir en un `config.sh` de Adminer.

---

## Hallazgo 2 — IPs hardcodeadas en `config/vhost.conf` y `config/vhost_ssl.conf`

```apache
# config/vhost.conf y config/vhost_ssl.conf:
ServerAlias 192.168.56.12    ← IP hardcodeada de la Vagrant box original
```

**Problema en N servidores:** La IP del servidor es diferente en cada
instalación. Un servidor con IP `10.0.1.50` no se alcanzará via
`192.168.56.12`. Apache responde solo si el `Host:` header coincide
con `ServerName` o `ServerAlias`.

**La variable existe pero no se usa en los archivos de config:**

```bash
# .env.example tiene:
ADMINER_IP=...

# bootstrap.sh requiere y usa ADMINER_IP en la salida:
show_results "HTTP: http://${ADMINER_IP}:${ADMINER_HTTP_PORT}"

# ssl.sh usa ADMINER_IP correctamente para el certificado:
CN = ${ADMINER_IP}
IP.1 = ${ADMINER_IP}

# Pero config/vhost.conf tiene 192.168.56.12 hardcodeado — no usa ADMINER_IP
```

**Solución:** En lugar de copiar el archivo estático (`cp`), `configure_apache()`
debería generar el vhost usando `sed` o template rendering:

```bash
# En configure_apache() — reemplazar cp por template rendering:
sed "s/192\.168\.56\.12/${ADMINER_IP}/g" \
    "${PROJECT_ROOT}/config/vhost.conf" \
    > /etc/apache2/sites-available/adminer.conf
```

O bien, usar symlink y hacer que `config/vhost.conf` use la variable:

```apache
# Si vhost.conf se convierte en template con envsubst:
ServerAlias ${ADMINER_IP}
```

---

## Hallazgo 3 — `ssl.sh` escribe en `config/certs/` (el repo como destino)

`ensure_certificate_authority()` y `generate_adminer_certificate()` generan
certificados y los escriben en `config/certs/ca/` y `config/certs/`:

```bash
readonly CA_DIR="${CONFIG_CERTS_DIR}/ca"
readonly CA_CERT="${CA_DIR}/ca.crt"
readonly CA_KEY="${CA_DIR}/ca.key"
readonly ADMINER_CERT="${CONFIG_CERTS_DIR}/adminer.crt"
readonly ADMINER_KEY="${CONFIG_CERTS_DIR}/adminer.key"
```

**Consecuencia:** Los certificados generados en el servidor quedan en el
directorio del repo. Si el repo se commitea después, los certificados
(incluyendo la clave privada) estarían en git. Actualmente `config/certs/`
SÍ está en el repo (el commit inicial tiene `adminer.crt` y `adminer.key`).

**Pregunta:** ¿Los certificados actuales en `config/certs/` son los del
servidor de desarrollo original, o son placeholders?

```
# En el repo:
config/certs/adminer.crt  → cert firmado por la CA del devbox original
config/certs/adminer.key  → clave privada del devbox original
```

**En N servidores:** Cada servidor debe generar su propio par de certificados.
Si `ssl.sh` escribe en `config/certs/`, el cert del servidor 1 sobreescribirá
al del servidor 2 si comparten el mismo directorio de repo.

**¿El `.gitignore` excluye los certificados generados?**
Los archivos `config/certs/adminer.crt` y `config/certs/adminer.key` están
commiteados — no están en `.gitignore`. Esto es correcto SOLO si son
certificados de referencia/placeholder. Los certificados reales de producción
jamás deben estar en el repo.

---

## Hallazgo 4 — `copy` vs `symlink` para los archivos de Apache

A diferencia de MariaDB y PostgreSQL (que usan `ln -sf` para sus configs),
Adminer usa `cp` para copiar `vhost.conf` a `sites-available/`. La razón
por la que se eligió `cp` en lugar de `symlink`:

**Para `vhost.conf` → `sites-available/adminer.conf`:**

Apache en Ubuntu usa `a2ensite` que crea un symlink de
`sites-enabled/adminer.conf → sites-available/adminer.conf`. Si
`sites-available/adminer.conf` YA fuera un symlink al repo, la cadena sería:

```
sites-enabled/adminer.conf
    → sites-available/adminer.conf  (creado por a2ensite)
        → config/vhost.conf          (symlink al repo)
```

Apache resuelve symlinks correctamente — esta cadena funcionaría.
Pero `config/vhost.conf` tiene la IP hardcodeada (H2), lo que hace que
el symlink sea incorrecto para servidores con IP diferente. Por eso el
`cp` con reemplazo de IP es la única solución idempotente.

**Para los certificados → `/etc/ssl/`:**

`cp` es la decisión correcta para certificados. Las razones:
- `/etc/ssl/private/` tiene permisos 710 — solo root puede leer
- Si el repo estuviera en `/home/usuario/` (644), Apache (www-data) no podría
  leer el symlink
- Los certificados de producción nunca deben estar en el repo — se generan
  en el servidor y se copian a `/etc/ssl/`

---

## Comparación del patrón entre los tres provisioners

| Aspecto | MariaDB | PostgreSQL | Adminer |
|---|---|---|---|
| Config del servicio | `config.sh` (nuevo) | `config.sh` (nuevo) | Dentro de `install.sh` |
| Config vía | `ln -sf` (symlink) | `ln -sf` (symlink) | `cp` (copy) |
| Config archivos | `50-server.cnf`, `pg_hba.conf` | `pg_hba.conf`, `postgresql.conf` | `sites-available/adminer.conf` |
| IP hardcodeada | No | No | Sí — `192.168.56.12` en vhost |
| Certs | N/A | N/A | Generados en `config/certs/` (en el repo) |
| `bootstrap.sh` pasos | 4 (system/install/config/setup) | 4 (system/install/config/setup) | 4 (system/swap/install/ssl) — sin `config` |
| Capa separada para config | Sí | Sí | No |

---

## Decisiones pendientes del equipo

### D-ADM-001 — ¿Crear `config.sh` para Adminer?

Para que Adminer tenga la misma separación que MariaDB y PostgreSQL:

```bash
# provisioners/adminer/config.sh (nuevo):
main() {
    _configure_apache_vhost   # cp vhost.conf (con reemplazo de IP) + a2ensite
    _configure_apache_reload  # apachectl configtest + systemctl reload
}
```

`bootstrap.sh` se actualizaría a:
```bash
steps=( "adminer_system" "adminer_swap" "adminer_install"
        "adminer_config" "adminer_ssl" )
```

### D-ADM-002 — ¿Cómo manejar la IP en `vhost.conf`?

**Opción A — `sed` en tiempo de deploy:**
```bash
sed "s/192\.168\.56\.12/${ADMINER_IP}/g" \
    config/vhost.conf > /etc/apache2/sites-available/adminer.conf
```
Pros: `config/vhost.conf` es estático, fácil de leer.
Cons: `cp` no puede usarse → no es idéntico al archivo del repo.

**Opción B — Convertir `vhost.conf` en template con `envsubst`:**
```apache
# config/vhost.conf:
ServerAlias ${ADMINER_IP}
```
```bash
ADMINER_IP="$ADMINER_IP" envsubst '${ADMINER_IP}' \
    < config/vhost.conf > /etc/apache2/sites-available/adminer.conf
```
Pros: Variable explícita, fácil de mantener.
Cons: `config/vhost.conf` ya no es legible como Apache config directamente.

**Opción C — Mantener `cp` y aceptar que el admin debe actualizar manualmente:**
No recomendada para N servidores.

### D-ADM-003 — ¿Los certificados en `config/certs/` son placeholders o reales?

Si son placeholders (para desarrollo local con la IP `192.168.56.12`):
- Mantener en el repo con documentación clara
- `ssl.sh` genera nuevos en el servidor (sobreescribe los del repo)
- Agregar `config/certs/ca/` al `.gitignore` (la CA generada en servidor es local)

Si son reales (de un entorno de desarrollo compartido):
- Mover fuera del repo
- `ssl.sh` genera y guarda en una ruta fuera del repo (ej. `/etc/ssl/iact/`)

---

## Hallazgos registrados

| ID | Hallazgo | Severidad | Estado |
|---|---|---|---|
| H-ADM-001 | `configure_apache()` en `install.sh` — mezcla CONFIG con INSTALL | MEDIA | RESUELTO — T-3.4 (nuevo config.sh) + T-3.6 (eliminada de install.sh) · commit bb44944 |
| H-ADM-002 | IP `192.168.56.12` hardcodeada en `config/vhost.conf` y `config/vhost_ssl.conf` | ALTA | RESUELTO — T-3.1 + T-3.2 (placeholder %%ADMINER_IP%% + sed) · commit bb44944 |
| H-ADM-003 | `ssl.sh` escribe certificados en `config/certs/` (dentro del repo) — riesgo si se commitea | ALTA | RESUELTO — T-3.3 (.gitignore + git rm --cached) · commit bb44944 |
| H-ADM-004 | `bootstrap.sh` de Adminer no tiene paso `adminer_config` — único de los tres provisioners sin la capa separada | MEDIA | RESUELTO — T-3.5 (paso adminer_config agregado) · commit bb44944 |
| H-ADM-005 | `ADMINER_IP` variable existe y se usa en ssl.sh para el cert, pero no se usa en `vhost.conf` para el ServerAlias | ALTA | RESUELTO — T-3.1 (%%ADMINER_IP%% reemplaza 192.168.56.12 en vhost.conf) · commit bb44944 |
| H-ADM-006 | `cp` para certificados es correcto (permisos `/etc/ssl/private`) — no cambiar a symlink | INFO | DOCUMENTADO |
