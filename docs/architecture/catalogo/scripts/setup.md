# `setup.sh`

**Requiere root:** Sí  
**Propósito:** Configura BDs ya instaladas (sin instalar)

---

## Uso

```bash
sudo bash setup.sh           # MariaDB + PostgreSQL
sudo bash setup.sh mariadb   # solo MariaDB
sudo bash setup.sh postgres  # solo PostgreSQL
sudo bash setup.sh mariadb --full  # MariaDB + backfill ETL
```

---

## Diferencia con `bootstrap.sh`

`setup.sh` asume que MariaDB y PostgreSQL ya están instalados. Solo ejecuta
los pasos de configuración (setup.sh de cada BD). Es más rápido y adecuado
para re-configurar un entorno existente.
