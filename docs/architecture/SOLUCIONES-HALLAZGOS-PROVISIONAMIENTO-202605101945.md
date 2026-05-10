# Soluciones — Hallazgos de provisionamiento IACT-db

**Versión:** 1.0.0  
**Fecha:** 2026-05-10  
**Referencia:** `HALLAZGOS-PROVISIONAMIENTO-202605101945.md`  
**Hallazgos que resuelve:** H-PROV-001, H-PROV-002, H-PROV-003 (H-F3-003)

---

## H-PROV-001 — MariaDB no persiste con `service mariadb start` en contenedor

### Diagnóstico confirmado

`service mariadb start` en Ubuntu 24.04 sin systemd activo ejecuta
`/etc/init.d/mariadb`, que llama `start-stop-daemon --background`. El proceso
arranca correctamente y retorna exit 0, pero sin un supervisor (systemd, runit,
s6) que lo supervise, el proceso puede morir silenciosamente. En este entorno
de contenedor, muere entre una llamada al script y la siguiente.

### Solución A — Fix en `start.sh`: verificar persistencia tras `service` (recomendada)

Agregar una verificación de persistencia 2 segundos después de que `service`
reporta OK. Si el proceso ya no responde, escalar al arranque directo.

```bash
# En start_mariadb(), reemplazar el bloque de nivel 1 (service):
if command -v service &>/dev/null; then
    log_debug "start_mariadb: intentando via service"
    if service mariadb start 2>/dev/null; then
        # Esperar brevemente y verificar que el proceso persiste.
        # En contenedores sin systemd, service reporta OK pero el proceso
        # puede morir al terminar el subshell (sin supervisor que lo relance).
        sleep 2
        if mariadb_is_running; then
            log_info "start_mariadb: iniciado via service (estable)"
            started=true
        else
            log_warn "start_mariadb: service reportó OK pero el proceso no persiste"
            log_warn "start_mariadb: escalando a arranque directo"
            # No asignar started=true — cae al siguiente nivel
        fi
    else
        log_debug "start_mariadb: service falló — continuando cadena"
    fi
fi
```

Esta solución usa la cadena de niveles ya existente en `start.sh`. Si `service`
falla la verificación de persistencia, el proceso cae al nivel 3 (arranque
directo con `nohup su -s /bin/bash mysql`), que sí produce un proceso huérfano
estable adoptado por PID 1.

**Verificación:**
```bash
bash start.sh mariadb
sleep 3
mysqladmin --socket=/run/mysqld/mysqld.sock ping --silent \
    && echo "MariaDB: estable" || echo "MariaDB: murió"
```

---

### Solución B — Consolidar arranque directo como nivel primario (alternativa)

En entornos donde siempre se sabe que no hay systemd (contenedor puro), evitar
los dos primeros niveles y arrancar directamente. Requiere detectar el entorno:

```bash
# Detectar si hay init system real antes de intentar service/systemctl
_has_real_init() {
    # systemd: /run/systemd/system existe y tiene contenido
    [[ -d /run/systemd/system ]] && return 0
    # upstart: /sbin/upstart existe
    command -v upstart &>/dev/null && return 0
    return 1
}

start_mariadb() {
    ...
    if _has_real_init; then
        # Solo intentar service/systemctl si hay init system real
        # (niveles 1 y 2 de la cadena actual)
        ...
    fi
    # Siempre disponible: arranque directo (nivel 3)
    _mariadb_start_direct
    ...
}
```

---

### Solución C — `setsid` para desacoplar del shell (complementaria)

`setsid` crea una nueva sesión, desacoplando el proceso del terminal controlador.
Útil si el problema es que el proceso recibe SIGHUP cuando el shell padre termina:

```bash
# En lugar de nohup su -s /bin/bash mysql -c '...' &
# Usar setsid para desacoplar de la sesión del shell:
setsid su -s /bin/bash mysql -c \
    "mariadbd --datadir=/var/lib/mysql \
     --socket=/run/mysqld/mysqld.sock \
     --innodb-use-native-aio=0 \
     >/dev/null 2>&1" &
```

`setsid` es más limpio que `nohup` porque elimina también la asociación con el
terminal controlador, no solo ignora SIGHUP.

---

### Impacto en los planes existentes

La Solución A es la que requiere menor cambio estructural en `start.sh` y
mantiene la compatibilidad con entornos que sí tienen systemd (donde `service`
funciona correctamente y la verificación de persistencia simplemente pasa).

Debe documentarse en `PLAN-SEGURIDAD-MARIADB-202605101715.md` o en un plan
nuevo dado que `start.sh` no estaba en el alcance original de los planes de
corrección existentes.

---

## H-PROV-002 — PostgreSQL sin extensiones opcionales

### Diagnóstico

Las extensiones `uuid-ossp`, `pg_trgm`, `hstore` y `citext` pertenecen al
paquete `postgresql-contrib`, que no estaba instalado en el entorno de
contenedor. No son extensiones de terceros — vienen con PostgreSQL pero en
un paquete separado por razones de distribución.

### Solución — Instalar `postgresql-contrib` y crear las extensiones

**Paso 1 — Instalar el paquete:**

```bash
apt-get install -y postgresql-contrib
# Para PostgreSQL 16 específicamente (si el paquete genérico no lo incluye):
apt-get install -y postgresql-16-contrib
```

**Paso 2 — Crear las extensiones en la BD correcta:**

Las extensiones son por BD, no globales. Deben crearse en `iact_analytics`:

```sql
-- Conectar a iact_analytics como superuser
\c iact_analytics

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS hstore;
CREATE EXTENSION IF NOT EXISTS citext;
```

O desde la línea de comandos:

```bash
for ext in "uuid-ossp" pg_trgm hstore citext; do
    psql -h 127.0.0.1 -U postgres iact_analytics \
        -c "CREATE EXTENSION IF NOT EXISTS \"${ext}\";" 2>/dev/null \
        && echo "OK: ${ext}" \
        || echo "WARN: ${ext} no disponible"
done
```

**Paso 3 — Integrar en `provisioners/postgres/setup.sh`:**

El provisioner actual intenta `CREATE EXTENSION` pero emite WARN cuando falla.
Con el paquete instalado, los intentos tendrán éxito. Para entornos donde el
paquete no puede instalarse, el WARN es correcto — son extensiones opcionales.

```bash
# En setup.sh de postgres, antes de intentar las extensiones:
if ! dpkg -l postgresql-contrib 2>/dev/null | grep -q "^ii"; then
    log_warn "postgresql-contrib no instalado — extensiones opcionales no disponibles"
    log_warn "Instalar con: sudo apt-get install -y postgresql-contrib"
else
    # Intentar crear las extensiones
    for ext in "uuid-ossp" pg_trgm hstore citext; do
        psql ... -c "CREATE EXTENSION IF NOT EXISTS \"${ext}\";" 2>/dev/null \
            && log_info "  Extensión ${ext}: habilitada" \
            || log_warn "  Extensión ${ext}: no disponible"
    done
fi
```

**Verificación:**
```bash
psql -h 127.0.0.1 -U postgres iact_analytics \
    -c "SELECT name, default_version FROM pg_available_extensions
        WHERE name IN ('uuid-ossp','pg_trgm','hstore','citext')
        ORDER BY name;"
```

### Nota sobre Django

Si los modelos de `IACT-api` usan `UUIDField` con generación a nivel de BD,
`HStoreField` o `CITextField`, Django emitirá una advertencia de migración
o fallará en `migrate` si la extensión no existe. Verificar en los modelos
antes de instalar a ciegas.

---

## H-PROV-003 — ERROR 1308 `LEAVE with no matching label` en `seed_historico.sql`

### Diagnóstico de raíz

`DELIMITER` es una directiva del cliente `mysql`, no un statement SQL del
servidor. Cuando se pasa SQL via pipe (`echo ... | mysql --batch`), el cliente
opera en modo no interactivo y **no procesa comandos `DELIMITER`**. Esto
provoca que el cuerpo del stored procedure sea dividido en sentencias separadas
por cada `;`, enviando el `BEGIN ... END` del SP como sentencias individuales.
`LEAVE sp_seed_historico` queda fuera del `CREATE PROCEDURE` → ERROR 1308.

Referencia: <https://dev.mysql.com/doc/refman/8.4/en/create-procedure.html>
("The example uses the mysql client delimiter command to change the statement
delimiter from `;` to `//` while the procedure is being defined.")

### Solución A — Archivo temporal: separar inyección de variables del SP (recomendada)

El problema está en `my_exec_vars_root`: inyecta variables de sesión via pipe
y luego pasa el SQL del seed (que contiene `CREATE PROCEDURE`) por el mismo pipe.
La corrección es escribir todo a un archivo temporal y ejecutarlo sin pipe:

```bash
# Reemplazar my_exec_vars_root en schema_historico.sh:
my_exec_vars_root() {
    local sql_file="$1"
    local tmp_sql
    tmp_sql=$(mktemp /tmp/iact_seed_XXXXXX.sql)

    # Escribir variables de sesión + contenido del archivo a un tmp
    {
        echo "SET @SEED_ROWS    = ${SEED_ROWS};"
        echo "SET @FORCE_RESEED = ${FORCE_RESEED};"
        echo "SET @COMMIT_HASH  = '${COMMIT_HASH}';"
        echo "SET @SCRIPT_VER   = '${SCRIPT_VERSION}';"
        cat "$sql_file"
    } > "$tmp_sql"

    # Ejecutar desde archivo (no pipe) — el cliente procesa DELIMITER correctamente
    local result exit_code
    if [[ -S "${DB_ROOT_SOCK}" ]]; then
        mysql --batch --socket="${DB_ROOT_SOCK}" "${DB_NAME}" < "$tmp_sql" 2>&1
        exit_code=$?
    else
        mysql --batch -h "${DB_HOST}" -P "${DB_PORT}" \
              -u root -p"${DB_ROOT_PASS}" "${DB_NAME}" < "$tmp_sql" 2>&1
        exit_code=$?
    fi

    rm -f "$tmp_sql"
    return "$exit_code"
}
```

Esta solución preserva la inyección de variables de sesión (`@SEED_ROWS`, etc.)
sin modificar `seed_historico.sql`. El cliente `mysql` lee el archivo directamente
y procesa `DELIMITER $$` correctamente.

**Verificación:**
```bash
# Debe crear el SP sin ERROR 1308
SKIP_SEED=0 bash provisioners/mariadb/schema_historico.sh 2>&1 \
    | grep -E "ERROR 1308|Seed completado|tbl_historico_t1_2025: [1-9]"
```

---

### Solución B — Reescribir `seed_historico.sql` sin `DELIMITER` (alternativa robusta)

Eliminar `DELIMITER` del SQL y reescribir el SP para que sea compatible con
cualquier modo de ejecución (pipe, archivo, cliente interactivo). Esto requiere
que el cuerpo del SP no contenga `;` que puedan ser confundidos por el cliente —
lo cual es posible en MariaDB con `CREATE OR REPLACE PROCEDURE`:

La clave es que si se pasa el archivo directamente sin pipe, `DELIMITER` ya
funciona. La Solución A resuelve esto sin modificar el SQL. La Solución B
sería reescribir el SP para que opere con `CALL` en lugar de `LEAVE`, usando
una variable flag de salida:

```sql
-- En lugar de LEAVE sp_seed_historico:
-- Usar una variable de control de flujo
DECLARE v_done TINYINT DEFAULT 0;

IF v_count_antes > 0 AND p_force = 0 THEN
    SET v_accion = 'SKIP';
    -- ... INSERT en seed_executions ...
    SET v_done = 1;
END IF;

IF v_done = 0 THEN
    -- resto del SP
END IF;
```

Esta refactorización elimina el `LEAVE` completamente, haciendo el SP compatible
con cualquier modo de ejecución. Requiere más cambios en el SQL pero es la
solución más portable y elimina la dependencia de `DELIMITER` en producción.

---

### Solución C — `mysql --execute` con heredoc para el CREATE PROCEDURE (descartada)

Intentar pasar el SP completo via `-e "..."` no funciona porque las comillas
del shell interfieren con el contenido del SP. Heredoc tampoco resuelve el
problema del DELIMITER en modo batch.

```bash
# ESTE PATRÓN NO FUNCIONA — heredoc tampoco procesa DELIMITER en batch:
mysql --batch --socket=... ivr_legacy << 'EOF'
DELIMITER $$
CREATE PROCEDURE sp_seed_historico(...)
BEGIN
  ...
END$$
DELIMITER ;
EOF
# Resultado: mismo ERROR 1308
```

La razón: `--batch` desactiva el procesamiento de comandos de cliente como
`DELIMITER` independientemente de si el input viene de pipe o heredoc. Solo
la lectura directa de archivo (opción `< archivo.sql`) activa el procesamiento
completo de directivas del cliente.

---

## Resumen de soluciones por prioridad de implementación

| Hallazgo | Solución recomendada | Complejidad | Archivos modificados |
|---|---|---|---|
| H-PROV-001 | Solución A: verificar persistencia 2s tras `service` | Baja | `start.sh` |
| H-PROV-002 | `apt-get install postgresql-contrib` + mejorar diagnóstico en provisioner | Muy baja | `provisioners/postgres/setup.sh`, entorno |
| H-PROV-003 | Solución A: `mktemp` + archivo temporal en `my_exec_vars_root` | Baja | `provisioners/mariadb/schema_historico.sh` |

Las tres soluciones recomendadas son implementables en una sola sesión. El orden
correcto es H-PROV-003 → H-PROV-001 → H-PROV-002, porque el seed fallando
(H-PROV-003) oculta si el entorno es realmente estable (H-PROV-001).
