# Hallazgos de instalacion — 2026-05-07T030715

**Script analizado:** `provisioners/mariadb/install.sh`
**Archivos relacionados:** `.env`, `.env.example`
**Total hallazgos:** 4
**Severidad maxima:** ALTA
**Estado general:** Corregido en commit `367706f`

---

## IN-001 — MARIADB_VERSION incorrecta en .env y .env.example [ALTA]

**Archivos:** `.env`, `.env.example`
**Estado:** Corregido

### Descripcion

Ambos archivos de configuracion tenian `MARIADB_VERSION=11.4`.
El script `install.sh` usa esta variable para construir la URL del
repositorio de MariaDB.org:

```
http://mirror.mariadb.org/repo/${MARIADB_VERSION}/ubuntu ...
```

Con `11.4` el script instala MariaDB 11.4 (version de desarrollo
actual), no la 10.11.14 requerida por el proyecto.

### Impacto

Instalacion de una version mayor que la requerida. MariaDB 11.4
tiene diferencias de comportamiento y configuracion respecto a 10.11.
El entorno de desarrollo resultante no seria representativo del
entorno de produccion objetivo.

### Correccion aplicada

```bash
# Antes
MARIADB_VERSION=11.4

# Despues
MARIADB_VERSION=10.11
```

---

## IN-002 — Ubuntu codename hardcodeado como 'focal' (Ubuntu 20.04) [ALTA]

**Archivo:** `provisioners/mariadb/install.sh`
**Estado:** Corregido

### Descripcion

El script construia la entrada del repositorio apt con el codename
`focal` hardcodeado:

```
deb [arch=amd64] http://mirror.mariadb.org/repo/${MARIADB_VERSION}/ubuntu focal main
```

`focal` es el codename de Ubuntu 20.04. El entorno actual corre
Ubuntu 24.04 (noble). Ejecutar el script sin correccion resultaria
en uno de estos escenarios:

- apt descarga paquetes compilados para Ubuntu 20.04 e intenta
  instalarlos sobre 24.04 — posibles incompatibilidades de libc y
  dependencias del sistema.
- apt falla al resolver dependencias y aborta la instalacion.
- En el mejor caso instala pero con binarios de la plataforma
  equivocada.

### Verificacion del problema

```
OS actual:    Ubuntu 24.04 LTS (noble)
Codename en install.sh: focal
```

### Correccion aplicada

Deteccion dinamica del codename:

```bash
# Antes
deb [arch=amd64] http://mirror.mariadb.org/repo/${MARIADB_VERSION}/ubuntu focal main

# Despues
OS_CODENAME=$(lsb_release -cs 2>/dev/null || echo "noble")
deb [arch=amd64 signed-by=/usr/share/keyrings/mariadb.gpg] \
    https://downloads.mariadb.com/MariaDB/mariadb-${MARIADB_SERIES}/repo/ubuntu \
    ${OS_CODENAME} main
```

---

## IN-003 — apt-key add deprecated desde Ubuntu 22.04 [MEDIA]

**Archivo:** `provisioners/mariadb/install.sh`
**Estado:** Corregido

### Descripcion

El script importaba la clave GPG de MariaDB usando `apt-key add`:

```bash
curl -fsSL https://mariadb.org/mariadb_release_signing_key.asc \
    | apt-key add - 2>/dev/null
```

`apt-key` fue marcado como deprecado en Ubuntu 22.04 y genera el
siguiente warning en cada ejecucion:

```
Warning: apt-key is deprecated. Manage keyring files in
trusted.gpg.d instead (see apt-key(8)).
```

El mecanismo antiguo almacena la clave en el keyring global del
sistema (`/etc/apt/trusted.gpg`), lo que significa que esa clave
se usa para verificar *todos* los repositorios, no solo el de
MariaDB — riesgo de seguridad si la clave se compromete.

### Correccion aplicada

Keyring dedicado por repositorio en `/usr/share/keyrings/`:

```bash
# Antes
curl -fsSL https://mariadb.org/mariadb_release_signing_key.asc \
    | apt-key add -

# Despues
curl -fsSL https://mariadb.org/mariadb_release_signing_key.asc \
    | gpg --dearmor \
    | tee /usr/share/keyrings/mariadb.gpg > /dev/null

# Y en la definicion del repo, signed-by explicito:
deb [arch=amd64 signed-by=/usr/share/keyrings/mariadb.gpg] ...
```

---

## IN-004 — Paquete sin pinning — apt upgrade podia saltar a 11.x [MEDIA]

**Archivo:** `provisioners/mariadb/install.sh`
**Estado:** Corregido

### Descripcion

El script instalaba `mariadb-server` sin especificar version:

```bash
install_package mariadb-server
install_package mariadb-client
```

Sin pinning, un `apt-get upgrade` posterior podia actualizar
automaticamente MariaDB de 10.11.x a 11.x, cambiando la serie
sin aviso. Esto rompe la garantia de reproducibilidad del entorno.

### Correccion aplicada

**Paso 1 — Instalar version exacta cuando esta disponible:**

```bash
pkg_exact=$(apt-cache show mariadb-server \
    | grep "Version: 1:10.11.14" | head -1 | awk '{print $2}')

if [ -n "$pkg_exact" ]; then
    apt-get install -y "mariadb-server=${pkg_exact}"
fi
```

**Paso 2 — Archivo de preferencias apt para bloquear la serie:**

```
# /etc/apt/preferences.d/mariadb-pin
Package: mariadb-server mariadb-client mariadb-common
Pin: version 1:10.11.*
Pin-Priority: 1001
```

`Pin-Priority: 1001` significa que apt siempre prefiere paquetes
de esta serie aunque exista una version mayor disponible en otro
repositorio. Los parches de seguridad dentro de `10.11.x` si se
aplican normalmente.

---

## Hallazgo adicional — Ubuntu 24.04 ya incluye 10.11.14 en repos oficiales

**Severidad:** INFORMATIVO
**Estado:** Documentado, no requiere correccion

Ubuntu 24.04 LTS (noble) incluye MariaDB 10.11.14 en sus repositorios
oficiales `noble-updates/universe`, sin necesidad de agregar el repo
de MariaDB.org:

```
mariadb-server:
  Installed: 1:10.11.14-0ubuntu0.24.04.1     <- noble-updates
  Version table:
    1:10.11.14-0ubuntu0.24.04.1  500  noble-updates/universe
    1:10.11.13-0ubuntu0.24.04.1  500  noble-security/universe
    1:10.11.7-2ubuntu2           500  noble/universe
```

El script actualizado detecta esto automaticamente: si `apt-cache show`
encuentra `10.11.14` en los repos del sistema, omite agregar el repo
de MariaDB.org. El repo externo solo se agrega cuando es necesario
(por ejemplo, Ubuntu 20.04 donde `10.11` no esta en los repos base).

---

## Resumen de correcciones

| ID | Archivo | Cambio |
|---|---|---|
| IN-001 | `.env`, `.env.example` | `MARIADB_VERSION=11.4` → `MARIADB_VERSION=10.11` |
| IN-002 | `provisioners/mariadb/install.sh` | `focal` hardcodeado → `$(lsb_release -cs)` dinamico |
| IN-003 | `provisioners/mariadb/install.sh` | `apt-key add` → keyring `/usr/share/keyrings/mariadb.gpg` |
| IN-004 | `provisioners/mariadb/install.sh` | sin pinning → `apt preferences` Pin-Priority 1001 + version exacta |

**Commit:** `367706f` — `fix: instalar MariaDB 10.11.14 correctamente — 4 problemas corregidos`

