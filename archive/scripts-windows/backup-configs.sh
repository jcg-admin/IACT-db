#!/bin/bash
# backup-configs.sh
# Script de backup manual de archivos de configuracion criticos
# Version: 1.0.0

set -euo pipefail

# Configuracion
BACKUP_BASE_DIR="/vagrant/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="${BACKUP_BASE_DIR}/${TIMESTAMP}"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Archivos criticos a respaldar por VM
declare -A MARIADB_CONFIGS=(
    ["/etc/mysql/mariadb.conf.d/50-server.cnf"]="mariadb-50-server.cnf"
    ["/etc/mysql/debian.cnf"]="mariadb-debian.cnf"
)

declare -A POSTGRES_CONFIGS=(
    ["/etc/postgresql/16/main/postgresql.conf"]="postgresql.conf"
    ["/etc/postgresql/16/main/pg_hba.conf"]="pg_hba.conf"
    ["/etc/postgresql/16/main/pg_ident.conf"]="pg_ident.conf"
)

declare -A ADMINER_CONFIGS=(
    ["/etc/apache2/sites-available/adminer.conf"]="adminer.conf"
    ["/etc/apache2/sites-available/adminer-ssl.conf"]="adminer-ssl.conf"
    ["/etc/apache2/apache2.conf"]="apache2.conf"
)

# Funciones de utilidad
show_header() {
    echo ""
    echo -e "${BLUE}=======================================${NC}"
    echo -e "${BLUE} IACT DevBox - Config Backup Utility${NC}"
    echo -e "${BLUE} Version: 1.0.0${NC}"
    echo -e "${BLUE}=======================================${NC}"
    echo ""
}

show_ok() {
    echo -e "${GREEN}  [OK]${NC} $1"
}

show_fail() {
    echo -e "${RED}  [FAIL]${NC} $1"
}

show_warn() {
    echo -e "${YELLOW}  [WARN]${NC} $1"
}

show_info() {
    echo -e "${BLUE}  [INFO]${NC} $1"
}

show_section() {
    echo ""
    echo -e "${BLUE}$1${NC}"
    printf "${BLUE}%${#1}s${NC}\n" | tr ' ' '-'
}

# Crear directorio de backup
create_backup_directory() {
    show_section "Creando directorio de backup"

    if mkdir -p "$BACKUP_DIR"; then
        show_ok "Directorio creado: $BACKUP_DIR"
        return 0
    else
        show_fail "No se pudo crear directorio: $BACKUP_DIR"
        return 1
    fi
}

# Backup de archivos de una VM
backup_vm_configs() {
    local vm_name=$1
    local -n configs=$2
    local vm_backup_dir="${BACKUP_DIR}/${vm_name}"

    show_section "Backup de configuraciones: $vm_name"

    # Crear subdirectorio para esta VM
    if ! mkdir -p "$vm_backup_dir"; then
        show_fail "No se pudo crear subdirectorio para $vm_name"
        return 1
    fi

    local backed_up=0
    local failed=0
    local not_found=0

    for source_path in "${!configs[@]}"; do
        local dest_name="${configs[$source_path]}"
        local dest_path="${vm_backup_dir}/${dest_name}"

        if [[ -f "$source_path" ]]; then
            if cp "$source_path" "$dest_path"; then
                show_ok "Respaldado: $dest_name"
                backed_up=$((backed_up + 1))
            else
                show_fail "Error copiando: $dest_name"
                failed=$((failed + 1))
            fi
        else
            show_warn "No existe: $source_path"
            not_found=$((not_found + 1))
        fi
    done

    echo ""
    show_info "Resultado: $backed_up respaldados, $failed fallidos, $not_found no encontrados"

    return 0
}

# Crear archivo README en el backup
create_backup_readme() {
    local readme_path="${BACKUP_DIR}/README.txt"

    cat > "$readme_path" << EOF
IACT DevBox - Backup de Configuraciones
========================================

Fecha de backup: $(date '+%Y-%m-%d %H:%M:%S')
Timestamp: $TIMESTAMP
Host: $(hostname)

Estructura:
-----------

mariadb/
  - mariadb-50-server.cnf    Configuracion principal de MariaDB
  - mariadb-debian.cnf        Configuracion de Debian

postgres/
  - postgresql.conf           Configuracion principal de PostgreSQL
  - pg_hba.conf              Configuracion de autenticacion
  - pg_ident.conf            Configuracion de identidades

adminer/
  - adminer.conf             VirtualHost HTTP
  - adminer-ssl.conf         VirtualHost HTTPS
  - apache2.conf             Configuracion principal de Apache

Restauracion:
-------------

Para restaurar un archivo:

1. Detener el servicio correspondiente:
   sudo systemctl stop mariadb|postgresql|apache2

2. Copiar el archivo de backup:
   sudo cp backup_file /etc/path/to/config

3. Reiniciar el servicio:
   sudo systemctl restart mariadb|postgresql|apache2

Advertencia:
-----------

Estos backups son de DESARROLLO.
NO usar en produccion sin revisar credenciales y configuracion.

EOF

    show_ok "README.txt creado"
}

# Crear resumen del backup
create_backup_summary() {
    local summary_path="${BACKUP_DIR}/SUMMARY.txt"

    echo "Resumen del Backup" > "$summary_path"
    echo "==================" >> "$summary_path"
    echo "" >> "$summary_path"
    echo "Timestamp: $TIMESTAMP" >> "$summary_path"
    echo "Fecha: $(date '+%Y-%m-%d %H:%M:%S')" >> "$summary_path"
    echo "" >> "$summary_path"

    # Contar archivos por VM
    for vm_dir in "$BACKUP_DIR"/*; do
        if [[ -d "$vm_dir" ]]; then
            local vm_name=$(basename "$vm_dir")
            local file_count=$(find "$vm_dir" -type f | wc -l)
            echo "$vm_name: $file_count archivos" >> "$summary_path"
        fi
    done

    echo "" >> "$summary_path"
    echo "Tamano total: $(du -sh "$BACKUP_DIR" | cut -f1)" >> "$summary_path"

    show_ok "SUMMARY.txt creado"
}

# Listar backups existentes
list_backups() {
    show_section "Backups existentes"

    if [[ ! -d "$BACKUP_BASE_DIR" ]]; then
        show_warn "No existen backups previos"
        return 0
    fi

    local backup_count=0

    for backup_dir in "$BACKUP_BASE_DIR"/*/; do
        if [[ -d "$backup_dir" ]]; then
            local backup_name=$(basename "$backup_dir")
            local backup_size=$(du -sh "$backup_dir" 2>/dev/null | cut -f1)
            echo "  $backup_name ($backup_size)"
            backup_count=$((backup_count + 1))
        fi
    done

    if [[ $backup_count -eq 0 ]]; then
        show_warn "No se encontraron backups"
    else
        echo ""
        show_info "Total: $backup_count backups"
    fi
}

# Limpiar backups antiguos
cleanup_old_backups() {
    local days_to_keep=${1:-30}

    show_section "Limpieza de backups antiguos"

    if [[ ! -d "$BACKUP_BASE_DIR" ]]; then
        show_info "No hay backups para limpiar"
        return 0
    fi

    local deleted=0
    local cutoff_date=$(date -d "$days_to_keep days ago" +%Y%m%d 2>/dev/null || date -v -${days_to_keep}d +%Y%m%d)

    for backup_dir in "$BACKUP_BASE_DIR"/*/; do
        if [[ -d "$backup_dir" ]]; then
            local backup_name=$(basename "$backup_dir")
            local backup_date="${backup_name:0:8}"

            if [[ "$backup_date" < "$cutoff_date" ]]; then
                if rm -rf "$backup_dir"; then
                    show_ok "Eliminado: $backup_name"
                    deleted=$((deleted + 1))
                else
                    show_fail "Error eliminando: $backup_name"
                fi
            fi
        fi
    done

    if [[ $deleted -eq 0 ]]; then
        show_info "No hay backups antiguos para eliminar (>${days_to_keep} dias)"
    else
        show_ok "Eliminados $deleted backups antiguos"
    fi
}

# Restaurar backup
restore_backup() {
    local backup_timestamp=$1
    local vm_name=$2
    local file_name=$3

    local backup_path="${BACKUP_BASE_DIR}/${backup_timestamp}/${vm_name}/${file_name}"

    if [[ ! -f "$backup_path" ]]; then
        show_fail "Archivo no encontrado: $backup_path"
        return 1
    fi

    show_warn "Restauracion requiere permisos de root"
    show_info "Archivo de backup: $backup_path"

    # Encontrar ruta de destino original
    local dest_path=""

    case "$vm_name" in
        mariadb)
            for source in "${!MARIADB_CONFIGS[@]}"; do
                if [[ "${MARIADB_CONFIGS[$source]}" == "$file_name" ]]; then
                    dest_path="$source"
                    break
                fi
            done
            ;;
        postgres)
            for source in "${!POSTGRES_CONFIGS[@]}"; do
                if [[ "${POSTGRES_CONFIGS[$source]}" == "$file_name" ]]; then
                    dest_path="$source"
                    break
                fi
            done
            ;;
        adminer)
            for source in "${!ADMINER_CONFIGS[@]}"; do
                if [[ "${ADMINER_CONFIGS[$source]}" == "$file_name" ]]; then
                    dest_path="$source"
                    break
                fi
            done
            ;;
    esac

    if [[ -z "$dest_path" ]]; then
        show_fail "No se pudo determinar ruta de destino para $file_name"
        return 1
    fi

    show_info "Ruta de destino: $dest_path"

    read -p "Continuar con restauracion? (s/N): " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Ss]$ ]]; then
        if cp "$backup_path" "$dest_path"; then
            show_ok "Archivo restaurado exitosamente"
            show_warn "Reiniciar el servicio correspondiente para aplicar cambios"
            return 0
        else
            show_fail "Error restaurando archivo"
            return 1
        fi
    else
        show_info "Restauracion cancelada"
        return 1
    fi
}

# Mostrar ayuda
show_help() {
    echo ""
    echo "Uso: sudo bash backup-configs.sh [opciones]"
    echo ""
    echo "Opciones:"
    echo "  backup              Crear nuevo backup (por defecto)"
    echo "  list                Listar backups existentes"
    echo "  cleanup [dias]      Eliminar backups mas antiguos que X dias (default: 30)"
    echo "  restore             Restaurar un archivo desde backup (interactivo)"
    echo "  help                Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  sudo bash backup-configs.sh"
    echo "  sudo bash backup-configs.sh list"
    echo "  sudo bash backup-configs.sh cleanup 60"
    echo "  sudo bash backup-configs.sh restore"
    echo ""
}

# Funcion principal
main() {
    local action=${1:-backup}

    case "$action" in
        backup)
            show_header

            # Verificar permisos
            if [[ $EUID -ne 0 ]]; then
                show_fail "Este script debe ejecutarse como root"
                echo "Uso: sudo bash backup-configs.sh"
                exit 1
            fi

            # Crear directorio de backup
            if ! create_backup_directory; then
                exit 1
            fi

            # Backup de cada VM
            backup_vm_configs "mariadb" MARIADB_CONFIGS
            backup_vm_configs "postgres" POSTGRES_CONFIGS
            backup_vm_configs "adminer" ADMINER_CONFIGS

            # Crear documentacion
            show_section "Creando documentacion del backup"
            create_backup_readme
            create_backup_summary

            # Resumen final
            show_section "Backup completado"
            show_ok "Ubicacion: $BACKUP_DIR"

            local total_size=$(du -sh "$BACKUP_DIR" | cut -f1)
            show_info "Tamano total: $total_size"

            echo ""
            ;;

        list)
            show_header
            list_backups
            echo ""
            ;;

        cleanup)
            show_header

            if [[ $EUID -ne 0 ]]; then
                show_fail "Este script debe ejecutarse como root"
                exit 1
            fi

            local days=${2:-30}
            cleanup_old_backups "$days"
            echo ""
            ;;

        restore)
            show_header

            if [[ $EUID -ne 0 ]]; then
                show_fail "Este script debe ejecutarse como root"
                exit 1
            fi

            show_warn "Restauracion interactiva no implementada aun"
            show_info "Para restaurar manualmente:"
            show_info "  1. Listar backups: sudo bash backup-configs.sh list"
            show_info "  2. Copiar archivo: sudo cp /vagrant/backups/TIMESTAMP/VM/archivo /etc/path/to/config"
            show_info "  3. Reiniciar servicio: sudo systemctl restart SERVICE"
            echo ""
            ;;

        help|--help|-h)
            show_help
            ;;

        *)
            show_fail "Opcion desconocida: $action"
            show_help
            exit 1
            ;;
    esac
}

# Ejecutar
main "$@"