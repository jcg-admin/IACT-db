# `start.sh`

**Requiere root:** No (pero necesita permisos para arrancar servicios)

---

## Propósito

Arranca MariaDB y/o PostgreSQL si no están corriendo. Usa una cadena
de fallback: systemctl → service → arranque directo con mariadbd.

---

## Uso

```bash
bash start.sh           # arranca ambas BDs
bash start.sh mariadb   # solo MariaDB
bash start.sh postgres  # solo PostgreSQL
```

---

## Funciones

| Función | Descripción |
|---|---|
| `start_mariadb()` | Detecta entorno (systemd/contenedor) y arranca MariaDB |
| `start_postgres()` | `pg_ctlcluster` o `pg_ctl` según entorno |
