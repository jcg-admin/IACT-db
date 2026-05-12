# `provisioners/mariadb/install.sh`

**Requiere root:** Sí  
**Instala:** MariaDB 10.11 LTS en Ubuntu 24.04

---

## Propósito

Instala MariaDB 10.11 desde el repositorio oficial de MariaDB Foundation.
Configura el repositorio APT, instala el paquete y verifica la versión instalada.

---

## Uso

```bash
sudo bash provisioners/mariadb/install.sh
```

---

## Funciones

| Función | Propósito |
|---|---|
| `_ensure_correct_mariadb_version()` | Verifica/elimina versiones previas incompatibles |
| `add_mariadb_repository()` | Agrega repo APT con GPG key via keyrings |
| `pin_mariadb_series()` | Fija MariaDB 10.11 con apt preferences |
| `install_mariadb()` | `apt-get install mariadb-server mariadb-client` |
| `verify_mariadb_version()` | Confirma que 10.11.x está instalado |
