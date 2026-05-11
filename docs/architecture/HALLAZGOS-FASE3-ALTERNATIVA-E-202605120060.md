# Hallazgos — Ejecución FASE 3 (Adminer)

**Versión:** 1.0.0  
**Fecha:** 2026-05-11  
**Plan de referencia:** `PLAN-ALTERNATIVA-E-CONSOLIDADO-202605120030.md` FASE 3  
**Baseline al iniciar:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Baseline al cerrar:** verify.sh 27 OK, 0 WARN, 0 ERR

---

## Resultado de las tareas

| Tarea | Descripción | Estado | Hallazgo |
|---|---|---|---|
| T-3.1 | `config/vhost.conf` — reemplazar IP por `%%ADMINER_IP%%` | COMPLETO | — |
| T-3.2 | `config/vhost_ssl.conf` — reemplazar IP por `%%ADMINER_IP%%` | COMPLETO | — |
| T-3.3 | `.gitignore` — proteger `adminer.key` y `adminer.crt` + `git rm --cached` | COMPLETO | — |
| T-3.4 | Crear `adminer/config.sh` con `_configure_apache_vhost` + reload | COMPLETO | H-F3-001, H-F3-002 |
| — | `ssl.sh/configure_ssl_vhost`: actualizar para usar `sed` con `%%ADMINER_IP%%` | COMPLETO | H-F3-001 |
| T-3.5 | `adminer/bootstrap.sh` — agregar paso `adminer_config` | COMPLETO | — |
| T-3.6 | `adminer/install.sh` — eliminar `configure_apache()` + actualizar `main()` | COMPLETO | H-F3-003 |
| T-3.7 | `verify.sh` → 27 OK sin regresión | PASA | — |

---

## H-F3-001 — `ssl.sh/configure_ssl_vhost` también usa `cp` de `vhost_ssl.conf`

**Detectado en:** Pre-análisis de T-3.2  
**Severidad:** ALTA  
**Estado:** RESUELTO — T-3.4 (también actualizado `ssl.sh`)

El plan original capturó que `install.sh/configure_apache()` hacía `cp config/vhost.conf`
y por eso se planificó moverla a `config.sh`. Lo que el plan no capturó es que
`ssl.sh/configure_ssl_vhost()` también hacía `cp config/vhost_ssl.conf`.

Si T-3.2 cambiaba `vhost_ssl.conf` para tener `%%ADMINER_IP%%` pero `ssl.sh`
seguía haciendo `cp` directo, el archivo `/etc/apache2/sites-available/adminer-ssl.conf`
quedaría con el placeholder literal — Apache lo aceptaría como `ServerAlias` pero
nunca coincidiría con ningún `Host:` header real:

```apache
# Resultado incorrecto si no se corrige ssl.sh:
ServerAlias %%ADMINER_IP%%   ← texto literal, no una IP
```

**Resolución:** `ssl.sh/configure_ssl_vhost()` actualizada para usar `sed`:
```bash
sed "s|%%ADMINER_IP%%|${ADMINER_IP}|g" \
    "$ssl_template" > "$ssl_vhost_config"
```
Se agregó además verificación de que el placeholder fue reemplazado antes de
continuar con `apachectl configtest`.

---

## H-F3-002 — `envsubst` no disponible en el entorno base

**Detectado en:** Pre-análisis de T-3.4  
**Severidad:** MEDIA  
**Estado:** RESUELTO — decisión tomada, implementado con `sed`

El plan proponía usar `envsubst` para expandir variables en los templates de vhost.
Al verificar el sistema:

```bash
command -v envsubst    # → no encontrado
dpkg -l gettext-base   # → 0 instalado
```

`envsubst` forma parte del paquete `gettext-base`. No está disponible en el
entorno base del servidor. El plan se escribió asumiendo disponibilidad que
no existe.

**Problema adicional con `envsubst` en este contexto:**

Los archivos `vhost.conf` y `vhost_ssl.conf` usan variables Apache con la
misma sintaxis `${VAR}`:

```apache
ErrorLog ${APACHE_LOG_DIR}/adminer-error.log
```

Si se usara `envsubst` sin scoping (`ADMINER_IP="..." envsubst < template`),
reemplazaría `${APACHE_LOG_DIR}` también. Con scoping
(`envsubst '${ADMINER_IP}'`), el shell expandiría `${ADMINER_IP}` antes de
pasarlo como argumento a `envsubst` (problema de quoting). Se requeriría
comillas simples que pueden ser confusas en scripts complejos.

**Decisión:** Usar un placeholder inequívoco `%%ADMINER_IP%%` con `sed`:
```bash
sed "s|%%ADMINER_IP%%|${ADMINER_IP}|g" template > destino
```

Ventajas:
- `sed` siempre disponible (parte de coreutils)
- `%%VAR%%` no colisiona con variables Apache (`${APACHE_LOG_DIR}`) ni bash
- La sustitución es exacta y verificable con `grep -q "%%ADMINER_IP%%"`
- Sin dependencias externas adicionales

---

## H-F3-003 — `ADMINER_IP` huérfana en `require_vars` de `install.sh`

**Detectado en:** Pre-análisis de T-3.6  
**Severidad:** MEDIA  
**Estado:** RESUELTO — T-3.6

```bash
# install.sh antes:
require_vars ADMINER_VERSION ADMINER_IP
```

`ADMINER_IP` era requerida por `configure_apache()`. Al mover esa función a
`config.sh`, ninguna función de `install.sh` usa `ADMINER_IP`. Solo se necesita
`ADMINER_VERSION` para construir la URL de descarga de Adminer.

Mismo patrón que H-F2-002 en FASE 2 (POSTGRES_PASSWORD huérfana).

**Resolución:** `require_vars` actualizado a `require_vars ADMINER_VERSION` en
`install.sh`. `ADMINER_IP` se requiere en `config.sh` donde se usa.

---

## H-F3-004 — Falso positivo en verificación de IP en comentarios

**Detectado en:** T-3.7 (verificación final)  
**Severidad:** BAJA (informativo)  
**Estado:** DOCUMENTADO

El script de verificación `grep "192\." config/vhost.conf` producía un "ERROR"
porque el comentario de documentación menciona la IP:

```bash
# T-3.1 (H-ADM-002): ADMINER_IP variable reemplaza 192.168.56.12.
```

La IP `192.168.56.12` solo aparece en comentarios Apache (`#`), no en directivas.
La verificación correcta para confirmar que no hay IPs en directivas activas:

```bash
grep "^[[:space:]]*ServerAlias.*192\." config/vhost.conf
# → vacío = correcto
```

---

## Archivos creados y modificados en FASE 3

| Archivo | Acción | Cambio |
|---|---|---|
| `config/vhost.conf` | Reemplazar IP por `%%ADMINER_IP%%` | +7 líneas de comentario template |
| `config/vhost_ssl.conf` | Reemplazar IP por `%%ADMINER_IP%%` | +8 líneas de comentario template |
| `.gitignore` | Proteger `adminer.key` y `adminer.crt` | +5 líneas |
| `provisioners/adminer/config.sh` | NUEVO | 155 líneas |
| `provisioners/adminer/ssl.sh` | Actualizar `configure_ssl_vhost` para usar `sed` | +15 líneas, -8 líneas |
| `provisioners/adminer/bootstrap.sh` | Agregar `adminer_config` step | +10 líneas |
| `provisioners/adminer/install.sh` | Eliminar `configure_apache()` + actualizar `main()` | -80 líneas |
| `config/certs/adminer.key` | Removido del tracking git | (sigue en disco) |
| `config/certs/adminer.crt` | Removido del tracking git | (sigue en disco) |

---

## Estado de los hallazgos del plan tras FASE 3

| Hallazgo | Descripción | Estado |
|---|---|---|
| H-ADM-001 | `configure_apache()` en `install.sh` — CONFIG mezclado con INSTALL | RESUELTO — T-3.4 + T-3.6 |
| H-ADM-002 | IP `192.168.56.12` hardcodeada en `config/vhost*.conf` | RESUELTO — T-3.1 + T-3.2 |
| H-ADM-003 | `ssl.sh` escribe certs en `config/certs/` — riesgo si se commitean | RESUELTO — T-3.3 |
| H-ADM-004 | `bootstrap.sh` sin paso `adminer_config` | RESUELTO — T-3.5 |
| H-ADM-005 | `ADMINER_IP` no se usa en `vhost.conf` para el `ServerAlias` | RESUELTO — T-3.1 + T-3.4 |
| H-F3-001 | `ssl.sh/configure_ssl_vhost` también usaba `cp` del template | RESUELTO — T-3.4 |
| H-F3-002 | `envsubst` no disponible — plan asumía disponibilidad | RESUELTO — `sed` con `%%ADMINER_IP%%` |
| H-F3-003 | `ADMINER_IP` huérfana en `require_vars` de `install.sh` | RESUELTO — T-3.6 |
| H-F3-004 | Falso positivo: IP en comentario, no en directiva Apache | DOCUMENTADO |
