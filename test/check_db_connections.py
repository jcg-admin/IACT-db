#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Check Database Connections - Verificación de conexiones externas Host -> VM
============================================================================
Descripción: Verifica conectividad a MariaDB y PostgreSQL desde el host
Patrón: Funcional, Sin efectos secundarios, Logging estructurado
Requisitos: mysql-connector-python, psycopg2-binary, colorama
============================================================================
"""

import sys
import os
import logging
from typing import Tuple, Dict, Any

# Verificar dependencias antes de importar
REQUIRED_MODULES = {
    'mysql.connector': 'mysql-connector-python',
    'psycopg2': 'psycopg2-binary',
    'colorama': 'colorama'
}

for module_name, package_name in REQUIRED_MODULES.items():
    try:
        __import__(module_name.replace('.connector', ''))
    except ImportError:
        print(f"ERROR: Módulo requerido no encontrado: {module_name}")
        print(f"Instalar con: pip install {package_name}")
        sys.exit(1)

import mysql.connector
import psycopg2
from psycopg2 import OperationalError as PgOperationalError

# Configuración de Colores (para Windows 10)
try:
    from colorama import Fore, Style, init
    init(autoreset=True)
except ImportError:
    class ColorFallback:
        def __getattr__(self, name): 
            return ''
    Fore = ColorFallback()
    Style = ColorFallback()


# =============================================================================
# CLASE DE LOGGING CUSTOM (Imitando iact_log_*)
# =============================================================================

class IACTLogger:
    """Implementa funciones de logging similares a las utilidades Bash IACT."""
    
    def __init__(self, script_name: str, logs_dir: str = "."):
        self.script_name = script_name
        self.log_file = os.path.join(logs_dir, f"{script_name}.log")
        self.logger = logging.getLogger(script_name)
        self.logger.setLevel(logging.INFO)
        self._setup_handlers()
        self._log_init()

    def _setup_handlers(self):
        """Configura handler solo para archivo (consola se maneja con print)."""
        # Limpiar handlers existentes
        if self.logger.handlers:
            self.logger.handlers = []

        # File Handler (sin colores, formato detallado, UTF-8)
        file_formatter = logging.Formatter(
            '[%(asctime)s] [%(levelname)-7s] %(message)s',
            datefmt='%Y-%m-%d %H:%M:%S'
        )
        # IMPORTANTE: encoding='utf-8' para compatibilidad
        file_handler = logging.FileHandler(self.log_file, mode='w', encoding='utf-8')
        file_handler.setFormatter(file_formatter)
        self.logger.addHandler(file_handler)
        
        # NO agregar ConsoleHandler - la consola se maneja con print() directo

    def _log_message(self, level: int, color: str, prefix: str, message: str):
        """Método interno para logging con color."""
        # 1. Impresión en consola con colores y prefijo (print directo)
        print(f"{color}{prefix}{Style.RESET_ALL} {message}")
        # 2. Log a archivo sin colores (solo via FileHandler)
        self.logger.log(level, f"{prefix.strip()} {message}")

    def _log_init(self):
        """Inicializa el log con información del entorno."""
        import datetime
        ts = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        
        self.log_header("Log Inicializado")
        self.log_info(f"Log iniciado: {ts}")
        self.log_info(f"Script: {self.script_name}")
        self.log_info(f"Plataforma: {sys.platform}")
        self.log_info(f"Python: {sys.version.split()[0]}")
        self.log_info(f"Archivo de Log: {self.log_file}")
        self.log_header("---")

    # Métodos de logging que imitan Bash (iact_log_*)
    def log_header(self, message: str):
        """Muestra un header destacado."""
        line = "=" * 70
        print(f"\n{Fore.CYAN}{line}")
        print(message)
        print(f"{line}{Style.RESET_ALL}\n")
        self.logger.info(f"HEADER: {message}")

    def log_step(self, current: int, total: int, message: str):
        """Muestra un paso numerado."""
        prefix = f"[PASO {current}/{total}]"
        print(f"\n{Fore.BLUE}{prefix}{Style.RESET_ALL} {message}")
        print("-" * 70)
        self.logger.info(f"{prefix} {message}")
        
    def log_info(self, message: str):
        """Mensaje informativo."""
        self._log_message(logging.INFO, Fore.CYAN, "[INFO]", message)

    def log_success(self, message: str):
        """Mensaje de éxito."""
        self._log_message(logging.INFO, Fore.GREEN, "[OK]", message)
        
    def log_error(self, message: str):
        """Mensaje de error."""
        self._log_message(logging.ERROR, Fore.RED, "[ERROR]", message)
        
    def log_warning(self, message: str):
        """Mensaje de advertencia."""
        self._log_message(logging.WARNING, Fore.YELLOW, "[WARNING]", message)


# =============================================================================
# CONFIGURACIONES DE CONEXIÓN (Host -> VM via port forwarding)
# =============================================================================

# Configuración MariaDB (localhost:13306 -> VM 192.168.56.10:3306)
MARIADB_CONFIG = {
    "host": "192.168.56.10",  # IP Host-Only de la VM MariaDB
    "port": 3306,              # Puerto estándar (acceso directo por red)
    "user": "django_user",
    "password": "django_pass",
    "database": "ivr_legacy"
}

# Configuración PostgreSQL (localhost:15432 -> VM 192.168.56.11:5432)
POSTGRES_CONFIG = {
    "host": "192.168.56.11",  # IP Host-Only de la VM PostgreSQL
    "port": 5432,              # Puerto estándar (acceso directo por red)
    "user": "django_user",
    "password": "django_pass",
    "dbname": "iact_analytics"
}


# =============================================================================
# FUNCIONES DE CONEXIÓN (Funcional, retornando estado)
# =============================================================================

def test_mariadb_connection(config: Dict[str, Any], logger: IACTLogger) -> Tuple[bool, str]:
    """
    Prueba de conexión a MariaDB (MySQL) via red Host-Only.
    
    Args:
        config: Diccionario con parámetros de conexión
        logger: Instancia de IACTLogger para logging
        
    Returns:
        Tupla (éxito, mensaje)
    """
    db_name = config.get("database")
    host = config.get("host")
    port = config.get("port")
    
    logger.log_info(f"Conectando a MariaDB: {host}:{port}")
    
    try:
        cnx = mysql.connector.connect(**config, connection_timeout=5)
        if cnx.is_connected():
            # Obtener información del servidor
            cursor = cnx.cursor()
            cursor.execute("SELECT VERSION()")
            version = cursor.fetchone()[0]
            cursor.close()
            cnx.close()
            
            logger.log_success(f"Conexión MariaDB exitosa: DB '{db_name}' en {host}:{port}")
            logger.log_info(f"Versión del servidor: {version}")
            return True, "MariaDB OK"
        else:
            logger.log_error("No se pudo establecer la conexión con MariaDB")
            return False, "MariaDB FALLÓ"
            
    except mysql.connector.Error as err:
        error_msg = f"Error de conexión MariaDB: {err}"
        logger.log_error(error_msg)
        logger.log_warning(f"Verifique que la VM MariaDB esté corriendo: vagrant status")
        return False, error_msg


def test_postgres_connection(config: Dict[str, Any], logger: IACTLogger) -> Tuple[bool, str]:
    """
    Prueba de conexión a PostgreSQL via red Host-Only.
    
    Args:
        config: Diccionario con parámetros de conexión
        logger: Instancia de IACTLogger para logging
        
    Returns:
        Tupla (éxito, mensaje)
    """
    db_name = config.get("dbname")
    host = config.get("host")
    port = config.get("port")
    
    logger.log_info(f"Conectando a PostgreSQL: {host}:{port}")
    
    conn = None
    try:
        conn = psycopg2.connect(**config, connect_timeout=5)
        
        # Obtener información del servidor
        cursor = conn.cursor()
        cursor.execute("SELECT version()")
        version = cursor.fetchone()[0]
        cursor.close()
        
        logger.log_success(f"Conexión PostgreSQL exitosa: DB '{db_name}' en {host}:{port}")
        logger.log_info(f"Versión del servidor: {version}")
        return True, "PostgreSQL OK"
        
    except PgOperationalError as err:
        error_msg = f"Error de conexión PostgreSQL: {err}"
        logger.log_error(error_msg)
        logger.log_warning(f"Verifique que la VM PostgreSQL esté corriendo: vagrant status")
        return False, error_msg
        
    finally:
        if conn is not None:
            conn.close()


# =============================================================================
# FUNCIÓN PRINCIPAL DE EJECUCIÓN
# =============================================================================

def run_tests(logger: IACTLogger) -> bool:
    """
    Define y ejecuta las pruebas de conexión externa.
    
    Args:
        logger: Instancia de IACTLogger para logging
        
    Returns:
        True si todas las pruebas pasaron, False si alguna falló
    """
    
    tests = [
        ("MariaDB (Host -> VM 192.168.56.10)", test_mariadb_connection, MARIADB_CONFIG),
        ("PostgreSQL (Host -> VM 192.168.56.11)", test_postgres_connection, POSTGRES_CONFIG),
    ]

    logger.log_header("VERIFICACIÓN DE CONEXIONES EXTERNAS (HOST -> VM)")
    logger.log_info("Método de conexión: Red Host-Only (192.168.56.0/24)")
    logger.log_info("Asegúrese de que ambas VMs estén corriendo: vagrant status")
    
    total_steps = len(tests)
    step = 0
    all_ok = True
    results = []
    
    for name, func, config in tests:
        step += 1
        logger.log_step(step, total_steps, f"Probando {name}")
        
        # Ejecución de la función pura
        success, message = func(config, logger)
        results.append((name, success, message))
        
        if not success:
            all_ok = False
            logger.log_error(f"FALLO: La conexión {name} no fue establecida")
            logger.log_warning(f"  Host: {config.get('host', config.get('host'))}:{config.get('port')}")
            logger.log_warning(f"  Posibles causas:")
            logger.log_warning(f"    1. VM no está corriendo (ejecute: vagrant up)")
            logger.log_warning(f"    2. Red Host-Only no configurada correctamente")
            logger.log_warning(f"    3. Firewall bloqueando conexión")
        
    # Resumen final
    logger.log_header("RESUMEN DE VERIFICACIÓN")
    
    for name, success, message in results:
        if success:
            logger.log_success(f"{name}: {message}")
        else:
            logger.log_error(f"{name}: FALLÓ")
    
    print()  # Línea en blanco
    
    if all_ok:
        logger.log_success("✓ Todas las conexiones externas fueron validadas correctamente")
        logger.log_info("Las VMs están listas para usar desde aplicaciones Django")
    else:
        logger.log_error("✗ Una o más conexiones fallaron")
        logger.log_info("Ejecute 'vagrant status' para verificar el estado de las VMs")
        logger.log_info("Ejecute 'vagrant up' para iniciar las VMs si están detenidas")
    
    return all_ok


# =============================================================================
# PUNTO DE ENTRADA
# =============================================================================

def main():
    """Punto de entrada principal del script."""
    # Crear directorio de logs si no existe
    logs_dir = "logs"
    if not os.path.exists(logs_dir):
        os.makedirs(logs_dir)
    
    # Crear el logger
    iact_logger = IACTLogger(
        script_name="check_db_connections",
        logs_dir=logs_dir
    )
    
    # Ejecutar las pruebas
    success = run_tests(iact_logger)
    
    # Mensaje final
    print()  # Línea en blanco
    iact_logger.log_info(f"Verificación finalizada. Log detallado en: {iact_logger.log_file}")
    
    # Exit code según resultado
    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()