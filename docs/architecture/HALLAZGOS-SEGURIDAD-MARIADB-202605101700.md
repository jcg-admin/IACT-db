# Análisis de hallazgos — Autenticación root MariaDB y metodología de testing

**Versión:** 1.0.0  
**Fecha:** 2026-05-10  
**Contexto:** Detectados durante pruebas de FASE 1 de `schema_historico.sh`  
**Referencia:** `PLAN-CORRECCIONES-EJECUCION-202605101630.md`, T-1.4 y T-1.5

---

## Resumen ejecutivo

| ID | Hallazgo | Tipo | Severidad | Estado |
|---|---|---|---|---|
| H-SEC-001 | Conclusión inicial "root accesible sin password" era incorrecta | Metodología | — | DOCUMENTADO |
| H-SEC-002 | `DB_ROOT_SOCK` hardcoded — no configurable desde entorno | Código | MEDIA | RESUELTO — FASE 5: MARIADB_SOCK documentada en .env.example; schema_historico.sh ya tenía auto-detección · commit 5a48040 |
| H-SEC-003 | Root bloqueado para TCP (`authentication_string=invalid`) | Entorno | MEDIA | DOCUMENTADO — comportamiento correcto post _secure_mariadb; documentado en install.sh v2.2.0 (FASE 5) |
| H-SEC-004 | Prerequisito de securización no documentado en `schema_historico.sh` | Documentación | BAJA | RESUELTO — FASE 2: schema_historico.sh L48-49 actualizado a config.sh (H-F2-004) · commit 8384bab |

---

## H-SEC-001 — La conclusión inicial "root accesible sin password via TCP" era incorrecta

**Tipo:** Hallazgo de metodología de testing  
**Estado:** DOCUMENTADO — no requiere corrección de código

### Qué se observó

Durante las pruebas de T-1.4 y T-1.5, se intentó forzar un fallo de acceso raíz
pasando credenciales incorrectas y un socket inexistente via variables de entorno:

```bash
DB_ROOT_SOCK=/tmp/no_existe.sock \
DB_MARIADB_ROOT_PASSWORD="password_incorrecto_xyz" \
SKIP_SEED=1 \
bash provisioners/mariadb/schema_historico.sh
```

El resultado fue `Acceso raíz OK`, llevando a la conclusión inicial:
> "El MySQL de este entorno tiene root accesible sin password via TCP"

### Por qué la conclusión era incorrecta

La prueba fue inválida por **dos razones independientes** que se cancelaron mutuamente:

**Razón 1 — `DB_ROOT_SOCK` está hardcoded en el script:**

```bash
# provisioners/mariadb/schema_historico.sh línea 74
DB_ROOT_SOCK="/run/mysqld/mysqld.sock"
```

Esta asignación ocurre **después** de cargar `.env`. La variable de entorno
`DB_ROOT_SOCK=/tmp/no_existe.sock` nunca tuvo efecto. El socket efectivo
fue siempre `/run/mysqld/mysqld.sock`, que **sí existe** en el entorno de prueba.

**Razón 2 — `set -a; source .env; set +a` sobreescribe variables de entorno:**

```bash
# El script carga .env con set -a, que re-exporta todas las variables del archivo
if [[ -f "$ENV_FILE" ]]; then set -a; source "$ENV_FILE"; set +a; fi
```

El comportamiento confirmado:
```bash
export DB_MARIADB_ROOT_PASSWORD="desde_entorno_123"
set -a; source .env; set +a
echo $DB_MARIADB_ROOT_PASSWORD
# Output: rootpass123   ← el .env sobreescribe la variable de entorno
```

El `.env` es la fuente autoritativa. Cualquier variable pasada via entorno
queda sobreescrita después del `source`. Las credenciales de test nunca se
usaron — siempre se usó `rootpass123` del `.env`.

### Estado real confirmado

```
root@socket (unix):  FUNCIONA  (peer auth — esperado en Ubuntu/Debian)
root@TCP sin pass:   FALLA     (correcto — root está securizado)
root@TCP con pass:   FALLA     (ver H-SEC-003)
```

---

## H-SEC-002 — `DB_ROOT_SOCK` hardcoded — no configurable desde entorno

**Componente:** `provisioners/mariadb/schema_historico.sh`  
**Severidad:** MEDIA  
**Estado:** RESUELTO — MARIADB_SOCK documentada en .env.example (FASE 5); schema_historico.sh ya tenía auto-detección · commit 5a48040

### Descripción

La ruta del socket Unix de MariaDB está definida como constante:

```bash
DB_ROOT_SOCK="/run/mysqld/mysqld.sock"
```

No se lee de `.env` ni acepta sobreescritura por variable de entorno. Esta
ruta es correcta para Ubuntu 24.04 con MariaDB instalado via apt. Sin embargo,
existen configuraciones legítimas donde el socket está en una ruta diferente:

| Distribución / Configuración | Ruta del socket |
|---|---|
| Ubuntu 24.04 (apt mariadb) | `/run/mysqld/mysqld.sock` |
| Ubuntu 24.04 (apt mysql) | `/var/run/mysqld/mysqld.sock` |
| MariaDB instalado en ruta personalizada | configurable |
| Contenedor con bind mount | cualquier ruta |

`mariadb_cleanup_stale` en `utils/database.sh` ya maneja múltiples sockets:

```bash
_MARIADB_SOCKETS=(
    "/run/mysqld/mysqld.sock"
    "/var/run/mysqld/mysqld.sock"
    "/tmp/mysql.sock"
)
```

`schema_historico.sh` solo intenta uno.

### Impacto

- Si el socket está en `/var/run/mysqld/mysqld.sock` (MySQL vs MariaDB apt),
  el fallback TCP se activa pero root puede estar bloqueado para TCP (H-SEC-003)
- La ruta no es sobreescribible desde `.env` ni desde variable de entorno —
  un operador no puede adaptar el script sin modificar el código

### Corrección implementada

`schema_historico.sh` usa `DB_ROOT_SOCK="${MARIADB_SOCK:-}"` y auto-detecta el socket
en orden: `/run/mysqld/mysqld.sock` → `/var/run/mysqld/mysqld.sock` → `/tmp/mysql.sock`.
Configurable via `MARIADB_SOCK` en `.env`. Documentado en `.env.example` (FASE 5 · commit 5a48040).

---

## H-SEC-003 — Root bloqueado para TCP (`authentication_string=invalid`)

**Componente:** MariaDB — estado de autenticación de root  
**Severidad:** MEDIA — el fallback TCP de `schema_historico.sh` es inoperable  
**Estado:** DOCUMENTADO — comportamiento correcto: root@TCP bloqueado es el resultado esperado de _secure_mariadb(); documentado en install.sh v2.2.0 (FASE 5)

### Descripción

El usuario root tiene `plugin=mysql_native_password` pero
`authentication_string=invalid`:

```sql
SELECT User, Host, plugin, authentication_string
FROM mysql.user WHERE User='root';
-- root | localhost | mysql_native_password | invalid
```

El valor `invalid` en `authentication_string` bloquea toda autenticación via
password. La conexión via socket (peer auth) no depende de este campo y
funciona correctamente, pero TCP falla con cualquier password:

```bash
mysql -h 127.0.0.1 -u root -p"rootpass123"
# ERROR 1698 (28000): Access denied for user 'root'@'localhost'
```

### Causa probable

El entorno de prueba instaló MariaDB via `apt-get install mariadb-server` y
arrancó el daemon manualmente — sin ejecutar `secure_mariadb()` del provisioner
`install.sh`. Ubuntu 24.04 instala MariaDB con root usando `unix_socket` auth
plugin. Durante las pruebas, `setup.sh mariadb` ejecutó una sentencia como:

```sql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'rootpass123';
```

Cuando `ALTER USER IDENTIFIED BY` se ejecuta sobre una cuenta que usa el
plugin `unix_socket`, MariaDB puede establecer `mysql_native_password` como
plugin pero con `authentication_string=invalid`, resultando en una cuenta que
solo acepta socket auth.

### Impacto sobre `schema_historico.sh`

Las funciones `my_exec_root`, `my_exec_file_root` y `my_exec_vars_root`
tienen este comportamiento:

```
Socket disponible  → peer auth → funciona correctamente
Socket no existe   → TCP con DB_ROOT_PASS → FALLA (authentication_string=invalid)
```

El fallback TCP diseñado en T-0.2..T-0.4 y guardado en T-1.5 es
**estructuralmente correcto**, pero **inoperable** en este entorno porque
el estado de auth de root impide cualquier conexión TCP con password.

En un entorno aprovisionado correctamente (con `install.sh` y `secure_mariadb()`),
este estado no ocurre: `secure_mariadb()` establece la password correctamente
dejando `authentication_string` con un hash válido.

### Nota sobre entornos no aprovisionados correctamente

En entornos aprovisionados via `provisioners/mariadb/config.sh` (que ejecuta `_secure_mariadb()`),
este estado no ocurre: `_secure_mariadb()` establece la password correctamente dejando
`authentication_string` con un hash válido.

El estado descrito corresponde a entornos instalados manualmente sin pasar por el
provisioner. En producción con bootstrap.sh, root@TCP funciona correctamente tras
`_secure_mariadb()` (FASE 1, commit f4a9e98). Documentado en `install.sh` v2.2.0 (FASE 5).

---

## H-SEC-004 — Prerequisito de securización no documentado

**Componente:** `provisioners/mariadb/schema_historico.sh` — header y documentación  
**Severidad:** BAJA  
**Estado:** RESUELTO — FASE 2: schema_historico.sh L48-49 actualizado a config.sh/_secure_mariadb() · commit 8384bab

### Descripción

El header de `schema_historico.sh` documenta el USO del script pero no sus
prerequisitos de infraestructura. El script asume silenciosamente que:

1. MariaDB fue instalado y securizado con `install.sh` (que ejecuta `secure_mariadb()`)
2. Root tiene un estado de autenticación funcional (socket o TCP con password válida)
3. `DB_MARIADB_ROOT_PASSWORD` en `.env` corresponde al password actual de root

Si alguna de estas condiciones no se cumple, los errores son:
- H-SEC-003: root TCP inoperable → fallback TCP falla sin mensaje descriptivo
- T-1.4 detecta esto, pero el mensaje indica "revisar .env" cuando el problema
  es el estado de auth de MariaDB

### Corrección implementada

`schema_historico.sh` L47-56 tiene sección `PREREQUISITOS` completa que documenta:
- MariaDB instalado y securizado via `provisioners/mariadb/config.sh`
- `DB_MARIADB_ROOT_PASSWORD` en `.env` corresponde al password actual de root
- Socket Unix auto-detectado, configurable via `MARIADB_SOCK` en `.env`
- Ejecutar como root del sistema operativo (FASE 2, commit 8384bab)

---

## Lecciones de metodología de testing

### Por qué los tests de "credenciales incorrectas" fueron inválidos

Pasar variables de entorno a un script que usa `set -a; source .env; set +a` no
permite sobreescribir las variables del `.env`. Esto es correcto comportamiento
de seguridad — el `.env` debe ser la fuente autoritativa — pero invalida la
técnica de test.

**Para sobreescribir credenciales en tests:**

```bash
# INCORRECTO — el .env sobreescribe:
DB_MARIADB_ROOT_PASSWORD="test_wrong" bash script.sh

# CORRECTO — crear un .env alternativo:
cp .env /tmp/test.env
echo "DB_MARIADB_ROOT_PASSWORD=wrong" >> /tmp/test.env
# Parchear ENV_FILE en el script
ENV_FILE=/tmp/test.env bash script.sh
```

O usar un entorno completamente aislado (contenedor sin .env).

### Por qué `DB_ROOT_SOCK` hardcoded invalida tests de "sin socket"

Una variable hardcoded en el script no es sobreescribible desde el exterior.
Para testear el fallback TCP, el socket físico debe no existir, o bien la
variable debe hacerse configurable (H-SEC-002).

---

## Orden de corrección

```
H-SEC-003 → H-SEC-002 → H-SEC-004
```

H-SEC-003 primero: restablecer el estado de auth de root permite probar el
fallback TCP de H-SEC-002. Sin H-SEC-003, cualquier prueba del fallback TCP
falla independientemente de si H-SEC-002 está corregido.

H-SEC-002 antes de H-SEC-004: la documentación de prerequisitos (H-SEC-004)
debe reflejar el comportamiento correcto de detección de socket (H-SEC-002).

---

## Ver también

- `HALLAZGOS-EJECUCION-2026-05-10.md` — hallazgos H-EXEC-001..009
- `PLAN-CORRECCIONES-EJECUCION-202605101630.md` — plan de correcciones FASE 0..6
- `provisioners/mariadb/install.sh` — `secure_mariadb()` establece password root correctamente
