# `bootstrap.sh`

**Requiere root:** Sí  
**Propósito:** Instalar y configurar todo desde cero (reemplaza `vagrant up`)

---

## Uso

```bash
cp .env.example .env        # ajustar credenciales
sudo bash bootstrap.sh      # instalar todo
sudo bash bootstrap.sh --no-adminer  # solo BDs
```

---

## Flujo

```
1. Sistema base (apt-get, timezone, locale)
2. MariaDB: install.sh → config.sh → setup.sh
3. PostgreSQL: install.sh → config.sh → setup.sh
4. (Opcional) Adminer: install.sh → ssl.sh
5. provision-mariadb.sh (schema, SPs, grants)
```
