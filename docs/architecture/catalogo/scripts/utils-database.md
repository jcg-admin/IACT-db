# `utils/database.sh`

**Versión:** 1.2.0  
**Fuente para:** `start.sh`, `setup.sh`, provisioners

---

## Propósito

Funciones de conectividad y arranque de bases de datos. Incluye detección
de entorno (systemd vs contenedor), fallback de arranque y health checks.

---

## Funciones clave

| Función | Descripción |
|---|---|
| `mariadb_is_running()` | Verifica via socket Unix primero, TCP después |
| `mariadb_wait_ready(timeout)` | Espera hasta que MariaDB acepte conexiones |
| `db_start_mariadb()` | Cadena: systemctl → service → arranque directo |
| `mariadb_cleanup_stale()` | Elimina PID/socket huérfano antes de arrancar |
| `test_db_connection(host, port, user, pass, db)` | Prueba conexión y retorna OK/FAIL |
