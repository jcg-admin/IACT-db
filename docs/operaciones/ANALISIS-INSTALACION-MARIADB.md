# Analisis — Instalacion de MariaDB 10.11.14

**Fecha:** 2026-05-07
**Contexto:** El proyecto requiere MariaDB 10.11.14 como version del entorno
de desarrollo, compatible con el diseno de SPs (sin window functions, por
compatibilidad con produccion 10.1.48).

---

## Estado actual vs estado requerido

| Elemento | Estado actual | Estado requerido |
|---|---|---|
| `.env` `MARIADB_VERSION` | `11.4` | `10.11` |
| `.env.example` `MARIADB_VERSION` | `11.4` | `10.11` |
| MariaDB instalada en sandbox | `10.11.14` (OK — llego por Ubuntu noble) | `10.11.14` |
| Ubuntu codename en install.sh | `focal` (hardcodeado, Ubuntu 20.04) | `$(lsb_release -cs)` (dinamico) |
| Importacion GPG key | `apt-key add` (deprecated Ubuntu 22.04+) | `/usr/share/keyrings/` |
| Version del paquete instalado | sin pinear — instala ultima disponible | pineada a `10.11` |

---

## Problema 1 — MARIADB_VERSION incorrecta en .env

**Archivo:** `.env` y `.env.example`
**Valor actual:** `MARIADB_VERSION=11.4`
**Valor correcto:** `MARIADB_VERSION=10.11`

El script `install.sh` usa `MARIADB_VERSION` para construir la URL del
repositorio de MariaDB.org. Con `11.4` instala MariaDB 11.4 (la version
actual de desarrollo). El proyecto requiere `10.11`.

**Correccion:**
```bash
MARIADB_VERSION=10.11
```

---

## Problema 2 — Ubuntu codename hardcodeado como 'focal'

**Archivo:** `provisioners/mariadb/install.sh`
**Linea afectada:**
```
deb [arch=amd64] http://mirror.mariadb.org/repo/${MARIADB_VERSION}/ubuntu focal main
```

`focal` es el codename de Ubuntu 20.04. El sandbox actual corre
Ubuntu 24.04 (noble). Si se ejecuta `install.sh` tal como esta,
apt intentara instalar paquetes de Ubuntu 20.04 sobre Ubuntu 24.04,
lo que puede resultar en dependencias incompatibles o instalacion fallida.

**Correccion:**
```bash
OS_CODENAME=$(lsb_release -cs)
deb [arch=amd64] http://mirror.mariadb.org/repo/${MARIADB_VERSION}/ubuntu ${OS_CODENAME} main
```

---

## Problema 3 — apt-key add esta deprecado desde Ubuntu 22.04

**Archivo:** `provisioners/mariadb/install.sh`
**Codigo actual:**
```bash
curl -fsSL https://mariadb.org/mariadb_release_signing_key.asc | apt-key add -
```

`apt-key` fue marcado como deprecado en Ubuntu 22.04 y genera warnings.
En versiones futuras puede ser removido completamente.

**Correccion — usar keyring dedicado:**
```bash
curl -fsSL https://mariadb.org/mariadb_release_signing_key.asc \
    | gpg --dearmor \
    | tee /usr/share/keyrings/mariadb.gpg > /dev/null

# Y en la definicion del repo:
deb [arch=amd64 signed-by=/usr/share/keyrings/mariadb.gpg] \
    http://mirror.mariadb.org/repo/10.11/ubuntu noble main
```

---

## Problema 4 — Paquete no pineado a version especifica

**Archivo:** `provisioners/mariadb/install.sh`
**Codigo actual:**
```bash
install_package mariadb-server   # instala la ultima disponible en el repo
```

Sin pinear, `apt-get upgrade` puede actualizar MariaDB a una version
mayor (10.11.15, 10.11.16, etc.) sin control. Para garantizar
reproducibilidad del entorno hay dos opciones:

**Opcion A — pinear version exacta en el install:**
```bash
apt-get install -y mariadb-server=1:10.11.14-0ubuntu0.24.04.1
```

**Opcion B — pinear la serie 10.11 con apt preferences (recomendada):**
```
# /etc/apt/preferences.d/mariadb
Package: mariadb-*
Pin: version 1:10.11.*
Pin-Priority: 1001
```
Esto permite recibir parches de seguridad dentro de 10.11.x pero
bloquea saltos a 10.11 → 11.x.

---

## Hallazgo adicional — Ubuntu noble ya trae 10.11.14

El sandbox corre Ubuntu 24.04 (noble). Los repositorios oficiales de
Ubuntu noble-updates ya incluyen MariaDB 10.11.14:

```
mariadb-server:
  Installed: 1:10.11.14-0ubuntu0.24.04.1
  Candidate: 1:10.11.14-0ubuntu0.24.04.1
  Version table:
    1:10.11.14-0ubuntu0.24.04.1  500  noble-updates/universe
    1:10.11.13-0ubuntu0.24.04.1  500  noble-security/universe
    1:10.11.7-2ubuntu2           500  noble/universe
```

Esto significa que para Ubuntu 24.04 no es necesario agregar el repo
de MariaDB.org — la version requerida ya esta en los repos del sistema.
El repo de MariaDB.org es util si se necesita una version que Ubuntu
no incluye (por ejemplo, 10.11 en Ubuntu 20.04).

---

## Plan de correccion

| Orden | Archivo | Cambio |
|---|---|---|
| 1 | `.env.example` | `MARIADB_VERSION=11.4` → `MARIADB_VERSION=10.11` |
| 2 | `.env` | idem |
| 3 | `provisioners/mariadb/install.sh` | detectar codename dinamicamente |
| 4 | `provisioners/mariadb/install.sh` | reemplazar `apt-key add` por keyring |
| 5 | `provisioners/mariadb/install.sh` | agregar apt preferences para pinear serie 10.11 |
| 6 | `provisioners/mariadb/install.sh` | verificar version instalada al final |

