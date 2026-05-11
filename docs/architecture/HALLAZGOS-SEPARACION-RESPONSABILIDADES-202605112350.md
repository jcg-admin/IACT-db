# Hallazgo — Separación de responsabilidades en los provisioners

**Versión:** 1.0.0  
**Fecha:** 2026-05-11  
**Contexto:** Análisis de donde deben declararse los paquetes del sistema
en respuesta a la pregunta "¿pero no en el provisioner se aprovisiona la BD?"

---

## El punto central

La pregunta del usuario es correcta: el **provisioner** de una base de datos
debería aprovisionar la base de datos — no instalar software del sistema ni
gestionar configuración del SO. Esas son responsabilidades de capas distintas.

---

## H-ARCH-003 — `install.sh` mezcla instalación de paquetes con configuración del SO

**Estado:** DOCUMENTADO — requiere decisión de refactoring

### Arquitectura actual (mezcla de responsabilidades)

```
bootstrap.sh
    └── postgres/bootstrap.sh
            ├── postgres_system()   → utils/system.sh
            │       apt install curl, wget, git, ca-certificates...  (paquetes base)
            │
            ├── postgres_install()  → provisioners/postgres/install.sh
            │       apt install postgresql-16                         (motor BD)
            │       apt install postgresql-contrib-16                 (extensiones BD)
            │       configure_postgresql():
            │           editar pg_hba.conf                           ← config del SO
            │           agregar regla scram-sha-256                  ← config del SO
            │
            └── postgres_setup()    → provisioners/postgres/setup.sh
                    CREATE USER django_user                           (aprovisionar BD)
                    CREATE DATABASE iact_analytics                    (aprovisionar BD)
                    GRANT privileges                                  (aprovisionar BD)
                    CREATE EXTENSION uuid-ossp, pg_trgm...           (aprovisionar BD)
                    ln -sf config/postgres/99-iact.conf              ← config del SO
```

### El problema

`install.sh` hace dos cosas distintas:
1. Instala los paquetes del sistema (correcto — es "install")
2. Configura `pg_hba.conf` (incorrecto — es configuración del SO, no instalación)

`setup.sh` también tiene una responsabilidad mezclada:
1. Crea usuarios, bases de datos, grants (correcto — es "provisionar la BD")
2. Crea el symlink de `config/postgres/99-iact.conf` (configuración del SO)
3. Instala extensiones (es BD — pero depende de que contrib esté instalado)

### La separación correcta

```
Capa 1 — Sistema operativo:
    utils/system.sh         → paquetes base (curl, git, ca-certificates...)
    install.sh              → instalar el motor (apt install postgresql-16)
                              instalar extensiones del motor (postgresql-contrib)
                              NADA de configuración de archivos del SO

Capa 2 — Configuración del SO:
    _apply_iact_*_config()  → symlinks de config/ → /etc/
    configure_postgresql()  → pg_hba.conf (debería estar en provisioners/postgres/setup.sh
                              o en una función específica llamada desde bootstrap)
    configure_mariadb()     → 50-server.cnf, bind-address

Capa 3 — Base de datos:
    setup.sh                → CREATE USER, CREATE DATABASE, GRANT
                              CREATE EXTENSION (aprovisionar objetos de BD)
                              NO gestionar archivos del SO desde aquí
```

### Por qué importa en N servidores

En un servidor donde PostgreSQL **ya está instalado** (por ejemplo, viene
pre-instalado en la imagen del servidor), el operador debería poder ejecutar
solo `setup.sh` para aprovisionar la BD sin re-instalar nada. Actualmente:
- `setup.sh` crea el symlink de config — mezcla responsabilidades
- `install.sh` edita `pg_hba.conf` — mezcla responsabilidades
- Si se ejecuta solo `setup.sh`, `pg_hba.conf` no queda configurado

---

## H-ARCH-004 — `postgresql-contrib` pertenece en `install.sh`, no en `config/`

**Estado:** CONFIRMADO — ubicación actual es correcta

`postgresql-contrib` instala las extensiones del motor de PostgreSQL
(uuid-ossp, pg_trgm, hstore, citext). Es un paquete apt del sistema
operativo, no un archivo de configuración ni un objeto de la BD.

**Jerarquía de responsabilidades:**

| Artefacto | Tipo | Capa | Ubicación correcta |
|---|---|---|---|
| `postgresql-16` | Paquete SO — motor | Instalación | `install.sh` |
| `postgresql-contrib-16` | Paquete SO — extensiones | Instalación | `install.sh` |
| `pg_hba.conf` | Config del SO | Config SO | `install.sh` o bootstrap |
| `config/postgres/99-iact.conf` | Config del proyecto | Config SO | symlink desde `setup.sh`* |
| `CREATE USER django_user` | Objeto BD | Provisionar BD | `setup.sh` |
| `CREATE EXTENSION uuid-ossp` | Objeto BD | Provisionar BD | `setup.sh` |

*El symlink de `99-iact.conf` debería estar en la capa de Config SO, no en `setup.sh`.
Está en `setup.sh` actualmente como consecuencia del hallazgo H-ARCH-003.

---

## Propuesta de refactoring (para evaluación del equipo)

### Opción A — Mínima (mover configure_postgresql a setup.sh)

Mover `configure_postgresql()` de `install.sh` a `setup.sh`. Esta función
edita `pg_hba.conf` — es configuración del SO que depende de conocer el
usuario de la BD (`django_user`), por lo que tiene más sentido en `setup.sh`.

```bash
# En provisioners/postgres/setup.sh — PASO 0 (antes de PASO 1):
log_step 0 5 "Configuración del SO (pg_hba.conf)"
_configure_pg_hba
```

### Opción B — Completa (introducir capa config/)

Agregar un paso explícito `postgres_config()` en `postgres/bootstrap.sh`
entre `postgres_install` y `postgres_setup`:

```bash
steps=(
    "postgres_system"    # paquetes base del SO (utils/system.sh)
    "postgres_install"   # instalar motor + contrib (install.sh)
    "postgres_config"    # configurar SO: pg_hba.conf + symlink 99-iact.conf
    "postgres_setup"     # aprovisionar BD: users, databases, grants, extensions
)
```

```bash
postgres_config() {
    init_log "postgres_config"
    source "${PROJECT_ROOT}/provisioners/postgres/config.sh"  # nuevo archivo
    main
}
```

`config.sh` contendría:
- Edición de `pg_hba.conf`
- Creación del symlink `config/postgres/99-iact.conf`
- Nada de paquetes apt, nada de objetos de BD

### Recomendación

La Opción B es la arquitectura correcta a largo plazo. La Opción A es el
paso mínimo que resuelve el problema principal (configure_postgresql fuera
de install.sh) sin introducir un archivo nuevo.

En cualquier caso, `postgresql-contrib` se queda en `install.sh` — es
instalación de motor, no provisioning de BD.

---

## Estado en el plan PLAN-DEUDA-CERO

Este hallazgo no estaba en el plan original. Se agrega como:

| ID | Hallazgo | Severidad | Estado |
|---|---|---|---|
| H-ARCH-003 | `install.sh` mezcla instalación con configuración del SO | MEDIA | PENDIENTE DECISIÓN |
| H-ARCH-004 | `postgresql-contrib` correctamente en `install.sh` | — | CONFIRMADO |
