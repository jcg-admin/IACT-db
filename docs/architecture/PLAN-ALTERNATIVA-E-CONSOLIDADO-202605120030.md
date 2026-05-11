# Plan consolidado — Alternativa E y todos los hallazgos pendientes

**Versión:** 1.0.0  
**Fecha:** 2026-05-11  
**Fuente:** Consolidación de hallazgos de:
- `ANALISIS-FORENSE-CODIGO-MUERTO-202605120010.md` (H-DEAD-001..007)
- `ANALISIS-FORENSE-ADMINER-202605120020.md` (H-ADM-001..006)
- `ANALISIS-PROFUNDO-ALTERNATIVA-E-202605120001.md` (H-INST-001..008)
- `PLAN-DEUDA-CERO-202605102315.md` FASES 2..6 (T-2.1..T-6.6)
- `HALLAZGOS-PAQUETES-SISTEMA-202605112345.md` (H-PKG-003)

**Baseline:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Restricciones:** bash puro (SQL y Python cuando el dominio lo requiera)

---

## Criterio de atomicidad

Cada tarea:
- Modifica exactamente un archivo o un bloque de un archivo
- Tiene verificación ejecutable que retorna OK o FALLO sin ambigüedad
- No tiene más de un prerequisito de otra tarea del mismo bloque
- Se puede revertir con `git revert` o `git checkout HEAD -- <archivo>`

---

## Orden obligatorio entre fases

```
FASE 1 (config.sh enriquecido)   → prerequisito de FASE 2
FASE 2 (eliminar código muerto)  → no ejecutar antes de FASE 1
FASE 3 (Adminer)                 → independiente de FASE 1 y 2
FASE 4 (pipeline ETL + verify)   → independiente de FASE 1 y 2
FASE 5 (seguridad + docs)        → independiente, puede ir en paralelo
FASE 6 (H-PKG-003 decisión)      → independiente
FASE 7 (documentación cierre)    → siempre la última
```

---

## FASE 1 — Enriquecer `config.sh` antes de eliminar el código muerto

Prerequisito estricto de FASE 2. Las funciones de `install.sh` no se
eliminan hasta que `config.sh` tenga toda la lógica que les falta.

### T-1.1 — `mariadb/config.sh`: `backup_file` en `_configure_mariadb_server` (H-DEAD-001)

**Archivo:** `provisioners/mariadb/config.sh`  
**Hallazgo:** `configure_mariadb()` en install.sh hacía `backup_file(50-server.cnf)`
antes de editar. `_configure_mariadb_server()` en config.sh edita directamente sin respaldo.

**Acción:** Agregar antes del primer `sed`:
```bash
if ! backup_file "$config_file"; then
    log_warn "  No se pudo crear backup de ${config_file} — continuando"
fi
```

**Verificación:**
```bash
bash -n provisioners/mariadb/config.sh && echo "Sintaxis: OK"
ls /etc/mysql/mariadb.conf.d/50-server.cnf.backup.* 2>/dev/null \
    || echo "Sin backups previos — se creará en la próxima ejecución"
```

---

### T-1.2 — `mariadb/config.sh`: `mariadb_wait_ready(30)` en `_restart_mariadb` (H-DEAD-002)

**Archivo:** `provisioners/mariadb/config.sh`  
**Hallazgo:** `configure_mariadb()` esperaba hasta 30s que MariaDB aceptara conexiones
tras restart. `_restart_mariadb()` hace restart y asume inmediatamente que está listo.
Si `_secure_mariadb()` se ejecuta antes de que MariaDB acepte conexiones, falla.

**Acción:** En `_restart_mariadb()`, después de `service mariadb restart`:
```bash
log_info "  Esperando que MariaDB acepte conexiones (máx 30s)..."
if mariadb_wait_ready 30 2>/dev/null; then
    log_success "  MariaDB reiniciado y listo"
else
    log_warn "  MariaDB arrancó pero no respondió en 30s — verificar manualmente"
fi
```

**Verificación:**
```bash
bash -n provisioners/mariadb/config.sh && echo "Sintaxis: OK"
grep "mariadb_wait_ready" provisioners/mariadb/config.sh
```

---

### T-1.3 — `mariadb/config.sh`: verificación de parseo en `_apply_iact_mariadb_config` (H-DEAD-003)

**Archivo:** `provisioners/mariadb/config.sh`  
**Hallazgo:** `_apply_iact_mariadb_config()` de install.sh verificaba que MariaDB
podía parsear el archivo tras crear el symlink. config.sh no tiene esa verificación.
Un error de sintaxis en `99-iact.cnf` produce fallo críptico en restart.

**Acción:** Agregar en `_apply_iact_mariadb_config()` después de `ln -sf`:
```bash
if command -v mariadbd &>/dev/null; then
    if mariadbd --defaults-file=/etc/mysql/my.cnf \
                --help --verbose 2>&1 \
            | grep -q "event_scheduler" 2>/dev/null; then
        log_success "  MariaDB parseó 99-iact.cnf correctamente"
    else
        log_warn "  event_scheduler no detectado — verificar sintaxis de 99-iact.cnf"
    fi
fi
```

**Verificación:**
```bash
bash -n provisioners/mariadb/config.sh && echo "Sintaxis: OK"
grep "mariadbd --defaults-file" provisioners/mariadb/config.sh
```

---

### T-1.4 — `mariadb/config.sh`: agregar `_secure_mariadb()` como PASO 0 (H-INST-001, H-INST-006, H-INST-008)

**Archivo:** `provisioners/mariadb/config.sh`  
**Hallazgo:**
- `secure_mariadb()` vive en `install.sh` — capa INSTALL, no CONFIG
- `require_vars` de config.sh no incluye `DB_MARIADB_ROOT_PASSWORD`
- `_secure_mariadb()` debe ejecutarse ANTES que `_configure_mariadb_server()`
  porque en instalación fresca root usa unix_socket — disponible antes de cambiar bind-address

**Acción:**
1. Agregar `DB_MARIADB_ROOT_PASSWORD` a `require_vars` en `main()`
2. Agregar función `_secure_mariadb()` (es la función `secure_mariadb` de install.sh
   renombrada con prefijo `_` por convención del archivo)
3. Agregar `log_step 0 4` que llame a `_secure_mariadb()` antes de los pasos actuales
4. Renumerar pasos existentes a 1-4 (antes eran 1-3)

**Verificación:**
```bash
bash -n provisioners/mariadb/config.sh && echo "Sintaxis: OK"
grep "require_vars.*DB_MARIADB_ROOT_PASSWORD" provisioners/mariadb/config.sh
grep "_secure_mariadb" provisioners/mariadb/config.sh | head -3
```

---

### T-1.5 — `postgres/config.sh`: `backup_file` en `_configure_pg_hba` y `_configure_postgresql_conf` (H-DEAD-001)

**Archivo:** `provisioners/postgres/config.sh`  
**Hallazgo:** `configure_postgresql()` de install.sh hacía `backup_file` de `pg_hba.conf`
y `postgresql.conf` antes de editar. config.sh edita directamente.

**Acción:** Agregar antes del primer `grep` en cada función:
```bash
# En _configure_pg_hba():
if ! backup_file "$pg_hba"; then
    log_warn "  No se pudo crear backup de ${pg_hba} — continuando"
fi

# En _configure_postgresql_conf():
if ! backup_file "$pg_conf"; then
    log_warn "  No se pudo crear backup de ${pg_conf} — continuando"
fi
```

**Verificación:**
```bash
bash -n provisioners/postgres/config.sh && echo "Sintaxis: OK"
grep -c "backup_file" provisioners/postgres/config.sh
# Esperado: 2 (una por función)
```

---

### T-1.6 — `postgres/config.sh`: verificación post-edición en `_configure_postgresql_conf` (H-DEAD-004)

**Archivo:** `provisioners/postgres/config.sh`  
**Hallazgo:** `configure_postgresql()` verificaba que `listen_addresses = '*'` quedó
efectivamente escrito. `_configure_postgresql_conf()` no verifica.

**Acción:** Agregar al final de `_configure_postgresql_conf()` antes de `return 0`:
```bash
if ! grep -q "^listen_addresses = '\*'" "$pg_conf"; then
    log_error "  listen_addresses no se configuró correctamente en ${pg_conf}"
    return 1
fi
log_success "  listen_addresses = '*' verificado"
```

**Verificación:**
```bash
bash -n provisioners/postgres/config.sh && echo "Sintaxis: OK"
grep "listen_addresses.*verificado\|no se configuró" provisioners/postgres/config.sh
```

---

### T-1.7 — `postgres/config.sh`: agregar `_secure_postgres()` como PASO 0 (H-INST-003, H-INST-006, H-INST-007)

**Archivo:** `provisioners/postgres/config.sh`  
**Hallazgo:**
- `set_postgres_password()` vive en `install.sh` — capa INSTALL, no CONFIG
- `require_vars` de config.sh no incluye `POSTGRES_PASSWORD`
- `_secure_postgres()` debe ejecutarse ANTES que `_configure_pg_hba()` porque
  `pg_hba.conf` con `scram-sha-256` requiere que el usuario `postgres` tenga password

**Acción:**
1. Agregar `POSTGRES_PASSWORD` a `require_vars` en `main()`
2. Agregar función `_secure_postgres()`:
```bash
_secure_postgres() {
    log_info "  Configurando password del superusuario postgres del sistema"
    if sudo -u postgres psql -c \
        "ALTER USER postgres WITH PASSWORD '${POSTGRES_PASSWORD}';" \
        2>/dev/null; then
        log_success "  Password de postgres configurado"
    else
        log_error "  No se pudo configurar password de postgres"
        return 1
    fi
}
```
3. Agregar `log_step 0 4` que llame a `_secure_postgres()` antes de los pasos actuales
4. Renumerar pasos existentes a 1-4

**Verificación:**
```bash
bash -n provisioners/postgres/config.sh && echo "Sintaxis: OK"
grep "require_vars.*POSTGRES_PASSWORD" provisioners/postgres/config.sh
grep "_secure_postgres" provisioners/postgres/config.sh | head -3
```

---

### T-1.8 — verify.sh post-FASE 1 (baseline 27 OK sin regresión)

**Acción:**
```bash
export PROJECT_ROOT=$(pwd)
bash verify.sh
```

**Criterio de paso:** 27 OK, 0 ERR, EXIT 0  
Si hay regresión, no proceder a FASE 2.

---

## FASE 2 — Eliminar código muerto de `install.sh` (prerequisito: FASE 1 completa)

### T-2.1 — `postgres/install.sh`: eliminar `configure_postgresql()` (H-INST-002)

**Archivo:** `provisioners/postgres/install.sh`  
**Líneas:** L259-L364 (105 líneas)  
**Condición:** La lógica está completamente en `config.sh` tras T-1.5 y T-1.6.

**Verificación:**
```bash
bash -n provisioners/postgres/install.sh && echo "Sintaxis: OK"
grep "^configure_postgresql()" provisioners/postgres/install.sh \
    && echo "ERROR: función aún existe" || echo "OK: función eliminada"
```

---

### T-2.2 — `postgres/install.sh`: eliminar `_apply_iact_postgres_config()` (H-DEAD-006)

**Archivo:** `provisioners/postgres/install.sh`  
**Líneas:** L376-L402 (27 líneas) — después de T-2.1 los números cambian; usar nombre  
**Condición:** Idéntica a la de config.sh. Ninguna lógica que rescatar (H-DEAD-006 confirmado).

**Verificación:**
```bash
bash -n provisioners/postgres/install.sh && echo "Sintaxis: OK"
grep "^_apply_iact_postgres_config()" provisioners/postgres/install.sh \
    && echo "ERROR: función aún existe" || echo "OK: función eliminada"
```

---

### T-2.3 — `postgres/install.sh`: eliminar `set_postgres_password()` (H-INST-003)

**Archivo:** `provisioners/postgres/install.sh`  
**Condición:** La lógica está en `config.sh/_secure_postgres()` tras T-1.7.

**Verificación:**
```bash
bash -n provisioners/postgres/install.sh && echo "Sintaxis: OK"
grep "^set_postgres_password()" provisioners/postgres/install.sh \
    && echo "ERROR: función aún existe" || echo "OK: función eliminada"
# Verificar que main() no la llama
sed -n '/^main()/,/^}/p' provisioners/postgres/install.sh \
    | grep "set_postgres_password" \
    && echo "ERROR: main() aún la llama" || echo "OK: main() no la llama"
```

---

### T-2.4 — `mariadb/install.sh`: eliminar `configure_mariadb()` (H-INST-002)

**Archivo:** `provisioners/mariadb/install.sh`  
**Líneas:** L317-L374 (57 líneas)  
**Condición:** La lógica está en `config.sh/_configure_mariadb_server()` y
`_configure_mariadb_aio()` tras T-1.1.

**Verificación:**
```bash
bash -n provisioners/mariadb/install.sh && echo "Sintaxis: OK"
grep "^configure_mariadb()" provisioners/mariadb/install.sh \
    && echo "ERROR: función aún existe" || echo "OK: función eliminada"
```

---

### T-2.5 — `mariadb/install.sh`: eliminar `_apply_iact_mariadb_config()` (H-INST-002)

**Archivo:** `provisioners/mariadb/install.sh`  
**Líneas:** L395-L423 (28 líneas) — después de T-2.4 los números cambian; usar nombre  
**Condición:** La lógica está en `config.sh/_apply_iact_mariadb_config()` tras T-1.3.

**Verificación:**
```bash
bash -n provisioners/mariadb/install.sh && echo "Sintaxis: OK"
grep "^_apply_iact_mariadb_config()" provisioners/mariadb/install.sh \
    && echo "ERROR: función aún existe" || echo "OK: función eliminada"
```

---

### T-2.6 — `mariadb/install.sh`: eliminar `secure_mariadb()` (H-INST-001)

**Archivo:** `provisioners/mariadb/install.sh`  
**Condición:** La lógica está en `config.sh/_secure_mariadb()` tras T-1.4.

**Verificación:**
```bash
bash -n provisioners/mariadb/install.sh && echo "Sintaxis: OK"
grep "^secure_mariadb()" provisioners/mariadb/install.sh \
    && echo "ERROR: función aún existe" || echo "OK: función eliminada"
sed -n '/^main()/,/^}/p' provisioners/mariadb/install.sh \
    | grep "secure_mariadb" \
    && echo "ERROR: main() aún la llama" || echo "OK: main() no la llama"
```

---

### T-2.7 — verify.sh post-FASE 2 (baseline 27 OK sin regresión)

**Criterio de paso:** 27 OK, 0 ERR, EXIT 0  
**Proyección:** install.sh postgres: 418 → 271 líneas (-147)  
install.sh mariadb: 502 → 367 líneas (-135)  
Total eliminado: 282 líneas

---

## FASE 3 — Adminer: separación de responsabilidades e IPs

### T-3.1 — `config/vhost.conf`: reemplazar IP hardcodeada por placeholder (H-ADM-002, H-ADM-005)

**Archivo:** `config/vhost.conf`  
**Hallazgo:** `ServerAlias 192.168.56.12` hardcodeada — IP de la Vagrant box original.
`ADMINER_IP` existe como variable pero no se usa en el vhost.

**Acción:** Reemplazar la IP por el nombre de variable en el archivo:
```apache
ServerAlias ${ADMINER_IP}
```
El archivo pasa de ser estático a ser un template que `configure_apache()`
expandirá con `envsubst` en tiempo de deploy.

**Verificación:**
```bash
grep "192\.168\." config/vhost.conf \
    && echo "ERROR: IP hardcodeada" || echo "OK: sin IPs hardcodeadas"
grep "ADMINER_IP" config/vhost.conf && echo "OK: variable presente"
```

---

### T-3.2 — `config/vhost_ssl.conf`: reemplazar IP hardcodeada por placeholder (H-ADM-002)

**Archivo:** `config/vhost_ssl.conf`  
**Acción:** Mismo que T-3.1 para el vhost SSL.

**Verificación:**
```bash
grep "192\.168\." config/vhost_ssl.conf \
    && echo "ERROR: IP hardcodeada" || echo "OK: sin IPs hardcodeadas"
grep "ADMINER_IP" config/vhost_ssl.conf && echo "OK: variable presente"
```

---

### T-3.3 — `.gitignore`: proteger `config/certs/adminer.key` y `adminer.crt` (H-ADM-003)

**Archivo:** `.gitignore`  
**Hallazgo:** `config/certs/adminer.key` y `config/certs/adminer.crt` están commiteados.
`config/certs/ca/` ya está en `.gitignore` (línea 289). Las claves privadas
del servidor no deben estar en el repo.

**Acción:** Agregar a `.gitignore`:
```
# Certificados generados por ssl.sh — específicos del servidor
config/certs/adminer.key
config/certs/adminer.crt
```

Y remover del tracking:
```bash
git rm --cached config/certs/adminer.key config/certs/adminer.crt
```

**Verificación:**
```bash
git check-ignore -v config/certs/adminer.key && echo "OK: ignorado"
git ls-files config/certs/adminer.key \
    && echo "ERROR: aún trackeado" || echo "OK: no trackeado"
```

---

### T-3.4 — Crear `provisioners/adminer/config.sh` (H-ADM-001, H-ADM-004)

**Archivo:** `provisioners/adminer/config.sh` (nuevo)  
**Hallazgo:** `configure_apache()` vive en `install.sh` — CONFIG mezclado con INSTALL.
Adminer es el único de los tres provisioners sin capa `config.sh` separada.

**Responsabilidad del nuevo archivo:**
- `_configure_apache_vhost()`: expandir template vhost con `envsubst`, copiar a
  `sites-available/`, `a2dissite 000-default`, `a2ensite adminer`, `apachectl configtest`
- `_configure_apache_reload()`: `systemctl reload apache2`, `wait_for_url` http://localhost

**Verificación:**
```bash
bash -n provisioners/adminer/config.sh && echo "Sintaxis: OK"
grep "^_configure_apache_vhost\|^_configure_apache_reload\|^main" \
    provisioners/adminer/config.sh | head -5
```

---

### T-3.5 — `adminer/bootstrap.sh`: agregar paso `adminer_config` (H-ADM-004)

**Archivo:** `provisioners/adminer/bootstrap.sh`  
**Acción:**
```bash
adminer_config() {
    init_log "adminer_config"
    source "${PROJECT_ROOT}/provisioners/adminer/config.sh"
    main
}

steps=(
    "adminer_system"
    "adminer_swap"
    "adminer_install"
    "adminer_config"   # nuevo
    "adminer_ssl"
)
```

**Verificación:**
```bash
bash -n provisioners/adminer/bootstrap.sh && echo "Sintaxis: OK"
grep "adminer_config" provisioners/adminer/bootstrap.sh | head -3
```

---

### T-3.6 — `adminer/install.sh`: eliminar `configure_apache()` y su llamada en `main()` (H-ADM-001)

**Archivo:** `provisioners/adminer/install.sh`  
**Condición:** La lógica está en `adminer/config.sh` tras T-3.4.

**Acción:** Eliminar la función `configure_apache()` (L219-L294) y la
llamada `if ! configure_apache` de `main()`.

**Verificación:**
```bash
bash -n provisioners/adminer/install.sh && echo "Sintaxis: OK"
grep "^configure_apache()" provisioners/adminer/install.sh \
    && echo "ERROR: función aún existe" || echo "OK: eliminada"
sed -n '/^main()/,/^}/p' provisioners/adminer/install.sh \
    | grep "configure_apache" \
    && echo "ERROR: main() aún la llama" || echo "OK: no la llama"
```

---

### T-3.7 — verify.sh post-FASE 3 (baseline sin regresión)

**Criterio de paso:** 27 OK, 0 ERR, EXIT 0

---

## FASE 4 — Pipeline ETL y verify.sh

### T-4.1 — `scripts/provision-mariadb.sh`: agregar función de backfill ETL (H-ETL-001)

**Archivo:** `scripts/provision-mariadb.sh`  
**Hallazgo:** En instalación fresca `base_ivr_detalle` y `base_ivr_clientes` quedan
vacías. El ETL histórico no se ejecuta automáticamente.

**Acción:** Agregar función `_run_etl_backfill()` y un PASO opcional controlado
por `RUN_ETL_BACKFILL=1` en `main()`, después del PASO grants.

**Verificación:**
```bash
bash -n scripts/provision-mariadb.sh && echo "Sintaxis: OK"
grep "_run_etl_backfill\|RUN_ETL_BACKFILL" scripts/provision-mariadb.sh | head -4
```

---

### T-4.2 — `verify.sh`: agregar `ivr_contar_dias_semana` e `ivr_agregar_dias_semana` (H-ETL-002)

**Archivo:** `verify.sh`  
**Hallazgo:** El baseline verifica 5 de 7 funciones de utilidad.
`ivr_contar_dias_semana` e `ivr_agregar_dias_semana` (usadas por
`sp_rpt_centros_xsegmento`) no están en el loop de verificación.

**Acción:** En el loop de verificación de funciones, agregar las dos al array:
```bash
for fn in fn_did_segmento fn_normalizar_menu fn_normalizar_centro \
          fn_duracion_seg ivr_es_dia_semana \
          ivr_contar_dias_semana ivr_agregar_dias_semana; do
```

**Verificación:**
```bash
bash -n verify.sh && echo "Sintaxis: OK"
grep "ivr_contar_dias_semana\|ivr_agregar_dias_semana" verify.sh
```

**Nota:** El baseline sube de 27 a 28 OK (una verificación nueva — las
dos funciones se verifican juntas en el mismo contador de éxito).

---

### T-4.3 — `verify.sh`: reordenar sección 3b (H-VFY-001)

**Archivo:** `verify.sh`  
**Hallazgo:** La sección 3b verifica tablas históricas antes que tablas analíticas.
El orden conceptual correcto es: tablas analíticas → funciones → SPs → EXECUTE → históricas.

**Acción:** Reordenar los bloques dentro de `check_mariadb_schema()`:
1. Tablas analíticas (base_ivr_*, job_*, etl_runs)
2. Funciones de utilidad
3. SPs ETL
4. SPs de reporte
5. GRANT EXECUTE
6. Tablas históricas

**Verificación:**
```bash
bash -n verify.sh && echo "Sintaxis: OK"
bash verify.sh 2>/dev/null | grep -E "OK:|ERR"
# Baseline debe mantenerse o aumentar por T-4.2
```

---

### T-4.4 — `utils/logging.sh`: corregir `log_fatal` en subshells (H-ETL-003)

**Archivo:** `utils/logging.sh`  
**Hallazgo:** `log_fatal` llama `exit 1` que mata el subshell pero no el script padre.
Si se llama desde dentro de `$(...)`, el script continúa con datos incorrectos.

**Acción:** Cambiar la implementación de `log_fatal` para que señale al proceso padre:
```bash
log_fatal() {
    log_error "$1"
    # kill -TERM 0 envía la señal al grupo de procesos completo
    kill -TERM 0 2>/dev/null || exit 1
}
```

**Verificación:**
```bash
bash -n utils/logging.sh && echo "Sintaxis: OK"
# Test funcional:
bash -c '
    source utils/logging.sh 2>/dev/null || true
    log_fatal() { echo "FATAL: $1" >&2; kill -TERM 0 2>/dev/null || exit 1; }
    result=$(log_fatal "test")
    echo "ERROR: no deberia llegar aqui"
'
echo "EXIT: $? (esperado: != 0)"
```

---

### T-4.5 — verify.sh post-FASE 4 (baseline ≥ 28 OK sin regresión)

**Criterio de paso:** ≥ 28 OK (sube por T-4.2), 0 ERR, EXIT 0

---

## FASE 5 — Seguridad, archivado y documentación técnica

### T-5.1 — `.env.example`: documentar `MARIADB_SOCK` (H-SEC-001)

**Archivo:** `.env.example`  
**Hallazgo:** `schema_historico.sh` auto-detecta el socket en varias rutas, pero
no hay una variable documentada para override desde `.env`.

**Acción:** Agregar en la sección de MariaDB:
```bash
# Socket Unix de MariaDB para conexión root sin password (peer auth)
# Dejar vacío para auto-detección:
#   /run/mysqld/mysqld.sock, /var/run/mysqld/mysqld.sock, /tmp/mysql.sock
# MARIADB_SOCK=/run/mysqld/mysqld.sock
```

**Verificación:**
```bash
grep "MARIADB_SOCK" .env.example && echo "OK"
```

---

### T-5.2 — `provisioners/mariadb/install.sh`: documentar securización TCP root (H-SEC-002, H-SEC-003)

**Archivo:** `provisioners/mariadb/install.sh`  
**Hallazgo:** `_secure_mariadb()` (que se moverá a config.sh en T-1.4) desactiva
root via TCP. Esto no está documentado en el header del archivo.

**Acción:** Agregar al header de `install.sh` sección:
```bash
# EFECTOS POST-INSTALACIÓN (ejecutados por config.sh/_secure_mariadb):
#   - root@TCP queda bloqueado: authentication_string=invalid para root remoto
#   - Solo root@socket (unix_socket auth) queda activo
#   - Los scripts de provisioning usan socket exclusivamente
#   - El fallback TCP de install.sh/schema_historico.sh nunca se activa
#     en entornos securizados — esto es correcto por diseño
```

**Verificación:**
```bash
grep "EFECTOS POST-INSTALACIÓN\|root@TCP\|unix_socket" \
    provisioners/mariadb/install.sh | head -3
```

---

### T-5.3 — Archivar `seed_historico_real.sql` (H-ARCH-001 / H-GRANT-008 / H-SP-004)

**Archivo origen:** `provisioners/mariadb/seed_historico_real.sql`  
**Hallazgo:** Referencia `FORCE_RESEED` y `sp_seed_historico_real` — eliminados en
`seed_historico.sql` v3.0.0. No referenciado en ningún script activo.

**Acción:**
```bash
mkdir -p docs/referencias/scripts-sql/historico
git mv provisioners/mariadb/seed_historico_real.sql \
       docs/referencias/scripts-sql/historico/
```

Crear `docs/referencias/scripts-sql/historico/README.md`:
```markdown
# Scripts SQL archivados

## seed_historico_real.sql

Archivado 2026-05-11. Reemplazado por:
- Nivel 1: provisioners/mariadb/seed_historico.sql v3.0.0
- Nivel 2: provisioners/mariadb/poblar_historico.py v1.1.0

Referenciaba FORCE_RESEED (eliminado en H-SEED-001..002) y
sp_seed_historico_real (nunca desplegado en producción).
```

**Verificación:**
```bash
ls provisioners/mariadb/seed_historico_real.sql 2>/dev/null \
    && echo "ERROR: no archivado" || echo "OK: archivado"
ls docs/referencias/scripts-sql/historico/seed_historico_real.sql \
    && echo "OK: en archivo"
```

---

### T-5.4 — `docs/architecture/FLUJO-ETL-V2.1.md`: corregir H-ARCH-002

**Archivo:** `docs/architecture/FLUJO-ETL-V2.1.md`  
**Hallazgo:** Tres errores en el documento:
1. Dice que `sp_etl_historico` habilita `etl_historico` en `job_config` — incorrecto
2. Columnas de `etl_runs` con nombres incorrectos (`iniciado_en`, `finalizado_en`, etc.)
3. Heartbeat descrito como 120 segundos — el código usa 60 segundos

**Acción:** Corregir los tres puntos con los valores reales verificados en BD.

**Verificación:**
```bash
grep "habilita temporalmente\|iniciado_en\|finalizado_en\|120 segundos" \
    docs/architecture/FLUJO-ETL-V2.1.md | wc -l
# Esperado: 0
```

---

## FASE 6 — H-PKG-003: decisión sobre manifest centralizado de paquetes

### T-6.1 — Decisión: implementar `config/packages/` o mantener patrón actual

**Hallazgo:** No existe manifest centralizado de paquetes del sistema.
Los paquetes están declarados en cada provisioner (`install_package` calls).

**Las dos opciones (documentadas en HALLAZGOS-PAQUETES-SISTEMA):**

**Opción A:** Mantener el patrón actual (provisioners declaran sus propios paquetes).
Sin implementación — solo documentar la decisión.

**Opción B:** Crear `config/packages/mariadb.txt`, `config/packages/postgres.txt`,
`config/packages/adminer.txt`. Los provisioners leen el archivo en lugar
de hardcodear los nombres.

**Criterio para decidir Opción B:** El proyecto tiene 3 servicios y ~15 paquetes
de sistema. Opción B agrega valor cuando hay paquetes compartidos entre
provisioners o cuando el equipo quiere un inventario en un solo lugar.

**Si se elige Opción B — tareas adicionales:**
- T-6.1a: Crear `config/packages/mariadb.txt`
- T-6.1b: Crear `config/packages/postgres.txt`
- T-6.1c: Crear `config/packages/adminer.txt`
- T-6.1d: Refactorizar `install.sh` de cada motor para leer desde el archivo

**Verificación (Opción B):**
```bash
ls config/packages/*.txt
grep -v "^#\|^$" config/packages/postgres.txt
```

---

## FASE 7 — Cierre documental

### T-7.1 — Marcar en documentos de hallazgos los resueltos por FASE 1 y FASE 2

Documentos a actualizar:
- `ANALISIS-FORENSE-CODIGO-MUERTO-202605120010.md`:
  H-DEAD-001 → RESUELTO (T-1.1, T-1.5)
  H-DEAD-002 → RESUELTO (T-1.2)
  H-DEAD-003 → RESUELTO (T-1.3)
  H-DEAD-004 → RESUELTO (T-1.6)
  H-DEAD-006 → RESUELTO (T-2.2)
- `ANALISIS-PROFUNDO-ALTERNATIVA-E-202605120001.md`:
  H-INST-001..003, H-INST-006..008 → RESUELTO

---

### T-7.2 — Marcar en documentos de hallazgos los resueltos por FASE 3

- `ANALISIS-FORENSE-ADMINER-202605120020.md`:
  H-ADM-001 → RESUELTO (T-3.4 + T-3.6)
  H-ADM-002 → RESUELTO (T-3.1 + T-3.2)
  H-ADM-003 → RESUELTO (T-3.3)
  H-ADM-004 → RESUELTO (T-3.5)
  H-ADM-005 → RESUELTO (T-3.1)

---

### T-7.3 — Marcar en documentos de hallazgos los resueltos por FASE 4 y FASE 5

- `PLAN-DEUDA-CERO-202605102315.md`:
  T-2.1..T-2.4 → RESUELTO (FASE 4)
  T-3.1..T-3.2 → RESUELTO (FASE 5)
  T-4.1..T-4.2 → RESUELTO (FASE 5)

---

### T-7.4 — verify.sh final: confirmar baseline post-implementación completa

**Criterio de cierre:** ≥ 28 OK, 0 ERR, EXIT 0

---

## Resumen ejecutivo

| FASE | Tareas | Hallazgos que cierra | Archivos afectados | Prerequisito | Estado |
|---|---|---|---|---|---|
| FASE 1 — Enriquecer config.sh | T-1.1..T-1.8 | H-DEAD-001..004, H-INST-001..003, H-INST-006..008 | postgres/config.sh, mariadb/config.sh | Ninguno | COMPLETO · f4a9e98 |
| FASE 2 — Eliminar código muerto | T-2.1..T-2.7 | H-INST-002 (220L) | postgres/install.sh, mariadb/install.sh | FASE 1 completa | COMPLETO · 8384bab |
| FASE 3 — Adminer | T-3.1..T-3.7 | H-ADM-001..005 | adminer/config.sh (nuevo), install.sh, bootstrap.sh, config/vhost*.conf, .gitignore | Ninguno | COMPLETO · bb44944 |
| FASE 4 — Pipeline ETL + verify | T-4.1..T-4.5 | H-ETL-001..003, H-VFY-001 | provision-mariadb.sh, verify.sh, utils/logging.sh | Ninguno | COMPLETO · 4ded8ab + cb5c04a |
| FASE 5 — Seguridad + archivado | T-5.1..T-5.4 | H-SEC-001..003, H-ARCH-001..002 | .env.example, install.sh (doc), seed_historico_real.sql, FLUJO-ETL-V2.1.md | Ninguno | COMPLETO · 5a48040 |
| FASE 6 — H-PKG-003 decisión | T-6.1 | H-PKG-003 | bootstrap.sh (inventario) | Ninguno | COMPLETO · a4bcf36 |
| FASE 7 — Cierre documental | T-7.1..T-7.4 | Todos | docs/architecture/ | Todas las fases anteriores | COMPLETO · este commit |

**Total tareas atómicas: 28** (+ sub-tareas opcionales de Opción B)  
**Archivos nuevos a crear: 2** (adminer/config.sh, docs/referencias/README.md)  
**Archivos a eliminar del tracking: 2** (adminer.key, adminer.crt de git)  
**Líneas netas eliminadas: ~360** (282 install.sh + 75 configure_apache)  
**Baseline final real: 27 OK** (H-F4-002: la proyección de ≥28 era incorrecta —
las 2 funciones nuevas se agregan al loop de un check existente, no crean un
nuevo bloque de verificación. 27 OK es el resultado correcto y verificado.)
