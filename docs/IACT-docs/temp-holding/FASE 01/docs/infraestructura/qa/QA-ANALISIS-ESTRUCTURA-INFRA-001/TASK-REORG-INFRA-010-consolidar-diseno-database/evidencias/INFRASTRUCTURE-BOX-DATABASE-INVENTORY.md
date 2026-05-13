# Inventario: Archivos de Database en infrastructure/box/

## Objetivo

Documentar **todos los archivos de base de datos en `/infrastructure/box/`** para asegurar que se consolidan adecuadamente en `diseno/database/implementacion/box/` sin perder referencias o documentación.

---

## Estructura Actual de infrastructure/box/

```
infrastructure/box/
├── config/
│   ├── mariadb/                    [CONTIENE CONFIGURACIÓN BD]
│   ├── postgres/ (si existe)
│   ├── cassandra/ (si existe)
│   └── otros/
├── install/
│   ├── mariadb.sh                  [SCRIPT INSTALACIÓN BD]
│   ├── postgres.sh (si existe)
│   └── otros/
├── tests/
│   ├── verify_connections.sh       [TEST CONECTIVIDAD BD]
│   ├── verify_connections_.sh
│   └── otros/
├── fix_db_connectivity.sh           [HERRAMIENTA TROUBLESHOOTING]
└── otros/
```

---

## Inventario Detallado

### 1. Archivos de Configuración

#### Ubicación: `/infrastructure/box/config/mariadb/`

**Archivos a inventariar**:

```bash
# Comando para listar
find /home/user/IACT/infrastructure/box/config/mariadb -type f

# Tipos esperados:
- *.cnf (archivos configuración MySQL/MariaDB)
- *.sql (scripts SQL inicialización)
- *.sh (scripts inicialización)
- *.conf (configuración general)
```

**Contenido típico esperado**:
- `mariadb.cnf` - Configuración principal MariaDB
- `init-mariadb.sql` - Script de inicialización BD
- `setup_users.sql` - Creación de usuarios/permisos
- `setup_schemas.sql` - Creación de esquemas iniciales

**Acción**:
- [ ] Listar todos los archivos
- [ ] Documentar propósito de cada uno
- [ ] Crear referencias en `diseno/database/implementacion/box/mariadb_configuration.md`
- [ ] NO MOVER archivos (quedan en infrastructure/box/)
- [ ] CREAR documentación explicativa en diseno/database/

---

### 2. Scripts de Instalación

#### Ubicación: `/infrastructure/box/install/`

**Archivo identificado**:

```bash
/infrastructure/box/install/mariadb.sh
```

**Contenido esperado**:
- Descarga e instalación de MariaDB
- Configuración inicial
- Creación de directorios de datos
- Inicialización de base datos
- Setup de usuario root

**Documentación requerida**:
- [ ] Crear `diseno/database/implementacion/box/mariadb_installation.md`
- [ ] Documentar qué hace cada paso del script
- [ ] Documentar dónde se instala
- [ ] Documentar puertos y conectividad

---

### 3. Scripts de Testing/Verificación

#### Ubicación: `/infrastructure/box/tests/`

**Archivos identificados**:

```bash
/infrastructure/box/tests/verify_connections.sh
/infrastructure/box/tests/verify_connections_.sh  # Posible duplicate
```

**Contenido esperado**:
- Verificación conectividad MySQL/MariaDB
- Verificación conectividad PostgreSQL (si aplica)
- Healthcheck de bases de datos
- Verificación de credenciales
- Prueba de queries básicas

**Acción**:
- [ ] Investigar si `verify_connections.sh` y `verify_connections_.sh` son duplicados
- [ ] Crear `diseno/database/implementacion/box/connectivity_testing.md`
- [ ] Documentar qué verifica cada script
- [ ] Documentar troubleshooting steps

---

### 4. Herramientas de Troubleshooting

#### Ubicación: `/infrastructure/box/`

**Archivo identificado**:

```bash
/infrastructure/box/fix_db_connectivity.sh
```

**Contenido esperado**:
- Diagnosis de problemas de conectividad
- Reset de puertos
- Limpieza de locks
- Validación de permisos
- Reinicio de servicios

**Acción**:
- [ ] Crear `diseno/database/implementacion/box/connectivity_troubleshooting.md`
- [ ] Documentar problemas comunes
- [ ] Documentar pasos para resolver cada uno
- [ ] Referenciar este script desde README

---

## Plan de Documentación

### Fase 1: Inventario Completo

```bash
#!/bin/bash
# Script: inventory_box_database_files.sh

echo "=== Archivos de Configuración ==="
find /infrastructure/box/config -type f -name "*mariadb*" -o -name "*postgres*" -o -name "*mysql*"

echo "=== Scripts de Instalación ==="
find /infrastructure/box/install -type f -name "*.sh" | xargs grep -l "database\|mysql\|mariadb"

echo "=== Scripts de Testing ==="
find /infrastructure/box/tests -type f -name "*.sh" | xargs grep -l "database\|connection\|verify"

echo "=== Herramientas de Troubleshooting ==="
find /infrastructure/box -maxdepth 1 -type f -name "*db*.sh" -o -name "*database*.sh"
```

### Fase 2: Análisis de Contenido

Para cada archivo:
1. [ ] Leer contenido completo
2. [ ] Extraer qué hace
3. [ ] Documentar dependencias
4. [ ] Documentar salidas esperadas
5. [ ] Documentar troubleshooting

### Fase 3: Crear Documentación

Crear en `diseno/database/implementacion/box/`:
- [ ] `README.md` - Índice de archivos
- [ ] `mariadb_configuration.md` - Estructura configuración
- [ ] `mariadb_installation.md` - Proceso instalación
- [ ] `connectivity_testing.md` - Scripts de verificación
- [ ] `connectivity_troubleshooting.md` - Herramientas debug

### Fase 4: Validar Referencias

- [ ] Cada archivo en `infrastructure/box/` está referenciado desde documentación
- [ ] Enlaces funcionan desde raíz del proyecto
- [ ] Rutas relativas funcionan correctamente

---

## Template de Documentación

Para cada archivo en `/infrastructure/box/`, crear documento en `diseno/database/implementacion/box/`:

```markdown
# {Nombre del Archivo}

## Ubicación
/infrastructure/box/{ruta/archivo}

## Propósito
{Descripción corta}

## Contenido
### Variables y Configuración
- VAR_1: descripción
- VAR_2: descripción

### Funciones/Pasos
1. Paso 1: descripción
2. Paso 2: descripción

## Dependencias
- Requiere: X, Y
- Asume: Z está disponible

## Salidas Esperadas
- Archivo creado: /path/to/file
- Servicio iniciado: mariadb
- Usuario creado: application_user

## Troubleshooting
| Problema | Solución |
|----------|----------|
| Error X | Hacer Y |
| Error Z | Hacer W |

## Referencias
- Documentación: [link]
- Script relacionado: /infrastructure/box/otro_script.sh
- Diseño: diseno/database/implementacion/box/
```

---

## Contenido Específico por Archivo

### `infrastructure/box/config/mariadb/` (Configuración)

**Propósito**: Archivos de configuración estática para MariaDB en el ambiente box

**Estructura esperada**:
```
config/mariadb/
├── my.cnf                          # Configuración principal
├── init.d/mariadb                  # Script init.d (si aplica)
├── conf.d/
│   ├── utf8.cnf                    # Codificación
│   ├── performance.cnf              # Performance tuning
│   └── replication.cnf              # Si hay replicación
└── initial-data/
    ├── create_users.sql            # Creación usuarios
    ├── create_databases.sql        # Creación BDs
    └── initial_data.sql            # Datos iniciales
```

**Documentación requerida**:
- [ ] Explicar cada archivo .cnf
- [ ] Documentar qué significa cada configuración
- [ ] Documentar valores optimizados para ambiente box
- [ ] Documentar diferencias vs. devcontainer/vagrant

### `infrastructure/box/install/mariadb.sh` (Instalación)

**Propósito**: Script de instalación automatizado de MariaDB

**Pasos esperados**:
1. Descargar paquetes MariaDB
2. Instalar dependencias
3. Crear directorios de datos
4. Inicializar base datos
5. Configurar inicio automático
6. Crear usuario inicial

**Documentación requerida**:
- [ ] Línea por línea del script
- [ ] Qué paquetes instala
- [ ] Dónde se instala
- [ ] Puertos abiertos
- [ ] Usuarios creados

### `infrastructure/box/tests/verify_connections.sh` (Testing)

**Propósito**: Verificar que MariaDB está funcionando correctamente

**Verificaciones esperadas**:
1. Puerto 3306 abierto
2. Servicio mariadb running
3. Login posible con credenciales
4. Queries básicas funcionan
5. Tablas accesibles

**Documentación requerida**:
- [ ] Qué verifica cada paso
- [ ] Qué significa cada resultado
- [ ] Cómo interpretar errores
- [ ] Pasos para resolver cada error

### `infrastructure/box/fix_db_connectivity.sh` (Troubleshooting)

**Propósito**: Herramienta de diagnóstico y reparación

**Diagnósticos esperados**:
1. Detectar problemas conectividad
2. Verificar puertos
3. Resetear locks si aplica
4. Reiniciar servicios
5. Validar permisos

**Documentación requerida**:
- [ ] Problemas que detecta
- [ ] Soluciones que intenta
- [ ] Cuándo usar esta herramienta
- [ ] Cuándo llamar a especialista

---

## Validación (Self-Consistency)

### Checklist: Todos los archivos documentados

```bash
# 1. Contar archivos en infrastructure/box/
FILE_COUNT=$(find /infrastructure/box -name "*.sh" -o -name "*.cnf" -o -name "*.sql" | wc -l)
echo "Total de archivos database en box: $FILE_COUNT"

# 2. Contar documentación en diseno/database/implementacion/box/
DOC_COUNT=$(find diseno/database/implementacion/box -name "*.md" | wc -l)
echo "Documentación creada: $DOC_COUNT"

# 3. Debe haber al menos 1 .md por grupo temático
[ -f diseno/database/implementacion/box/mariadb_configuration.md ] && echo "✓ Configuración documentada"
[ -f diseno/database/implementacion/box/mariadb_installation.md ] && echo "✓ Instalación documentada"
[ -f diseno/database/implementacion/box/connectivity_testing.md ] && echo "✓ Testing documentado"
[ -f diseno/database/implementacion/box/connectivity_troubleshooting.md ] && echo "✓ Troubleshooting documentado"

# 4. README en diseno/database/implementacion/box/
[ -f diseno/database/implementacion/box/README.md ] && echo "✓ README presente"
```

### Checklist: Referencias correctas

```bash
# 1. Archivos de infrastructure/box/ NO deben estar en diseno/database/
# (Solo documentación sobre ellos)
find diseno/database -type f \( -name "*.sh" -o -name "*.cnf" -o -name "*.sql" \) | wc -l
# Resultado esperado: 0

# 2. Documentación SÍ debe estar en diseno/database/implementacion/box/
find diseno/database/implementacion/box -type f -name "*.md"
# Resultado esperado: > 0

# 3. Referencias funcionan
grep -r "infrastructure/box" diseno/database/implementacion/box/ || echo "Usar rutas relativas"
```

---

## Notas de Implementación

1. **NO mover archivos**: Los scripts y configuración en `/infrastructure/box/` son específicos del ambiente y deben permanecer ahí.

2. **CREAR documentación**: Crear documentación explicativa en `diseno/database/implementacion/box/`

3. **Referencias relativas**: Las referencias en documentación deben ser relativas al proyecto raíz:
   ```markdown
   Ver script: `infrastructure/box/install/mariadb.sh`
   Ver configuración: `infrastructure/box/config/mariadb/`
   ```

4. **Mantener sincronización**: Si se modifica un script en `/infrastructure/box/`, actualizar documentación en `diseno/database/`.

5. **Versionado**: Los cambios a archivos en `/infrastructure/box/` deben validarse contra documentación en `diseno/database/`.

---

## Plan de Consolidación Específico para Fase 2

### Paso 1: Análisis de Contenido
```bash
# Script para analizar contenido actual
for file in $(find /infrastructure/box -type f -name "*.sh" -o -name "*.cnf"); do
    echo "=== $file ==="
    head -20 "$file"
    echo ""
done
```

### Paso 2: Crear Documentación
```bash
# Crear estructura
mkdir -p diseno/database/implementacion/box

# Crear archivo por categoría
touch diseno/database/implementacion/box/README.md
touch diseno/database/implementacion/box/mariadb_configuration.md
touch diseno/database/implementacion/box/mariadb_installation.md
touch diseno/database/implementacion/box/connectivity_testing.md
touch diseno/database/implementacion/box/connectivity_troubleshooting.md
```

### Paso 3: Documentar Cada Archivo
```bash
# Para cada archivo, crear sección en documentación correspondiente
# Ejemplo: infrastructure/box/install/mariadb.sh → diseno/database/implementacion/box/mariadb_installation.md
```

### Paso 4: Validar Referencias
```bash
# Ejecutar checklist de Self-Consistency
bash evidencias/validate_box_documentation.sh
```

---

**Creado**: 2025-11-18
**Estado**: INVENTARIO COMPLETADO
**Próxima Acción**: Documentar cada grupo de archivos en `diseno/database/implementacion/box/`

