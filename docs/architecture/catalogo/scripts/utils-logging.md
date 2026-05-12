# `utils/logging.sh`

**Versión:** 0.1.0  
**Fuente para:** Todos los provisioners

---

## Propósito

Sistema de logging profesional con niveles y timestamps. Sin emojis.

---

## Funciones

| Función | Nivel | Color |
|---|---|---|
| `log_debug(msg)` | DEBUG | Gris |
| `log_info(msg)` | INFO | Blanco |
| `log_success(msg)` | SUCCESS | Verde |
| `log_warn(msg)` | WARN | Amarillo |
| `log_error(msg)` | ERROR | Rojo |
| `log_fatal(msg)` | FATAL | Rojo — termina el proceso |
| `log_step(n, total, desc)` | STEP | Cyan — `[STEP N/TOTAL]` |
| `log_header(msg)` | HEADER | Encabezado visual |
