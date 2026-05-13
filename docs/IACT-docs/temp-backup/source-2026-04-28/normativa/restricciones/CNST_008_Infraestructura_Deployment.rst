CNST-008: Infraestructura y Deployment
======================================

:ID: CNST-008
:Versión: 1.0.1
:Fecha: 2026-01-03
:Estado: VIGENTE
:Clasificación: CRÍTICO - NO NEGOCIABLE
:Origen: Restricción del cliente

----

Propósito
---------

Este documento establece la arquitectura de infraestructura y proceso de deployment obligatorio para el Sistema IACT - IVR Analytics & Customer Tracking, usando Apache con mod_wsgi y entrega mediante paquete ZIP.

Contexto
--------

Origen de la Restricción
~~~~~~~~~~~~~~~~~~~~~~~~

Restricción de infraestructura impuesta por el cliente. El cliente NO utiliza contenedores (Docker/Kubernetes) ni servicios cloud. El deployment se realiza en servidores on-premise con Apache.

Justificación del Cliente
~~~~~~~~~~~~~~~~~~~~~~~~~

- Infraestructura existente basada en Apache
- Políticas de seguridad no permiten contenedores
- Control total sobre el entorno de ejecución
- Proceso de deployment auditado y controlado
- Sin dependencia de servicios cloud externos

Aplicable a
~~~~~~~~~~~

- Backend Django (API)
- Frontend React (UI)
- Proceso de deployment
- Configuración de servidores
- Todas las fases del ciclo de vida

Restricciones de Infraestructura
--------------------------------

Prohibiciones Absolutas
~~~~~~~~~~~~~~~~~~~~~~~

Tecnologías Prohibidas
^^^^^^^^^^^^^^^^^^^^^^

PROHIBIDO bajo cualquier circunstancia:

- Docker / Docker Compose
- Kubernetes / OpenShift
- AWS / Azure / GCP (servicios cloud)
- Heroku / Railway / Vercel
- Nginx (cliente usa Apache)
- Gunicorn standalone (debe ser mod_wsgi)
- PM2 / Supervisor para Python

Configuraciones Prohibidas
^^^^^^^^^^^^^^^^^^^^^^^^^^

NO se permite:

- Dockerfile en el repositorio
- docker-compose.yml
- Manifiestos de Kubernetes
- Terraform / CloudFormation
- CI/CD con deployment automático a cloud

Arquitectura Obligatoria
------------------------

Stack Tecnológico
~~~~~~~~~~~~~~~~~

.. code-block:: text

   ┌─────────────────────────────────────────────────────────────────┐
   │                    SERVIDOR CLIENTE                             │
   │                   (On-Premise Linux)                            │
   │                                                                 │
   │  ┌─────────────────────────────────────────────────────────┐   │
   │  │                    Apache 2.4                            │   │
   │  │                 (Reverse Proxy)                          │   │
   │  │                                                          │   │
   │  │   ┌─────────────────┐      ┌─────────────────┐          │   │
   │  │   │   VirtualHost   │      │   VirtualHost   │          │   │
   │  │   │   :443 (HTTPS)  │      │   :80 (HTTP)    │          │   │
   │  │   │                 │      │   Redirect 443  │          │   │
   │  │   └────────┬────────┘      └─────────────────┘          │   │
   │  │            │                                             │   │
   │  │   ┌────────┴────────┐                                   │   │
   │  │   │                 │                                   │   │
   │  │   ▼                 ▼                                   │   │
   │  │ /api/*          /* (static)                             │   │
   │  │   │                 │                                   │   │
   │  └───┼─────────────────┼───────────────────────────────────┘   │
   │      │                 │                                       │
   │      ▼                 ▼                                       │
   │  ┌─────────┐      ┌─────────┐                                  │
   │  │mod_wsgi │      │ Static  │                                  │
   │  │ Django  │      │  Files  │                                  │
   │  │  API    │      │ (React) │                                  │
   │  └────┬────┘      └─────────┘                                  │
   │       │                                                        │
   │       ▼                                                        │
   │  ┌─────────┐      ┌─────────┐                                  │
   │  │PostgreSQL│      │ MariaDB │                                  │
   │  │Analytics│      │   IVR   │                                  │
   │  │  (R/W)  │      │  (R/O)  │                                  │
   │  └─────────┘      └─────────┘                                  │
   │                                                                │
   └────────────────────────────────────────────────────────────────┘

Componentes
~~~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 20 30 50

   * - Componente
     - Tecnología
     - Notas
   * - Servidor Web
     - Apache 2.4
     - Con mod_wsgi, mod_ssl
   * - Backend
     - Django 4.2 + DRF
     - Python 3.11
   * - Frontend
     - React 18
     - Build estático servido por Apache
   * - BD Analytics
     - PostgreSQL 14+
     - Base propia de IACT
   * - BD IVR
     - MariaDB 10.x
     - Solo lectura (CNST-003)
   * - Caché
     - Django DB Cache
     - No Redis (CNST-002)

Estructura de Directorios
-------------------------

Servidor de Producción
~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: text

   /opt/iact/
   ├── api/                          # Backend Django
   │   ├── apps/                     # Aplicaciones Django
   │   │   ├── analytics/
   │   │   ├── common/
   │   │   ├── etl/
   │   │   ├── exports/
   │   │   ├── ivr/
   │   │   ├── reports/
   │   │   └── users/
   │   ├── config/                   # Configuración Django
   │   │   ├── settings/
   │   │   │   ├── __init__.py
   │   │   │   ├── base.py
   │   │   │   └── production.py
   │   │   ├── urls.py
   │   │   └── wsgi.py
   │   ├── manage.py
   │   └── requirements.txt
   │
   ├── ui/                           # Frontend React (build)
   │   ├── index.html
   │   ├── static/
   │   │   ├── css/
   │   │   ├── js/
   │   │   └── media/
   │   └── manifest.json
   │
   ├── venv/                         # Virtual environment
   │   └── ...
   │
   ├── logs/                         # Logs de aplicación
   │   ├── django.log
   │   ├── etl.log
   │   └── access.log
   │
   ├── media/                        # Archivos generados
   │   └── exports/
   │
   └── scripts/                      # Scripts de mantenimiento
       ├── deploy.sh
       ├── backup.sh
       └── cleanup.sh

Configuración Apache
--------------------

VirtualHost Principal
~~~~~~~~~~~~~~~~~~~~~

.. code-block:: apache

   # /etc/apache2/sites-available/iact.conf

   <VirtualHost *:80>
       ServerName iact.cliente.local
       Redirect permanent / https://iact.cliente.local/
   </VirtualHost>

   <VirtualHost *:443>
       ServerName iact.cliente.local
       ServerAdmin admin@cliente.local

       # SSL
       SSLEngine on
       SSLCertificateFile /etc/ssl/certs/iact.crt
       SSLCertificateKeyFile /etc/ssl/private/iact.key

       # Logs
       ErrorLog /opt/iact/logs/apache_error.log
       CustomLog /opt/iact/logs/apache_access.log combined

       # ─────────────────────────────────────────────
       # FRONTEND: React Static Files
       # ─────────────────────────────────────────────
       DocumentRoot /opt/iact/ui

       <Directory /opt/iact/ui>
           Options -Indexes +FollowSymLinks
           AllowOverride None
           Require all granted

           # SPA: Redirect all non-file requests to index.html
           RewriteEngine On
           RewriteBase /
           RewriteRule ^index\.html$ - [L]
           RewriteCond %{REQUEST_FILENAME} !-f
           RewriteCond %{REQUEST_FILENAME} !-d
           RewriteCond %{REQUEST_URI} !^/api/
           RewriteRule . /index.html [L]
       </Directory>

       # Static files cache
       <Directory /opt/iact/ui/static>
           ExpiresActive On
           ExpiresDefault "access plus 1 year"
           Header set Cache-Control "public, max-age=31536000, immutable"
       </Directory>

       # ─────────────────────────────────────────────
       # BACKEND: Django API via mod_wsgi
       # ─────────────────────────────────────────────

       # WSGI Daemon Process
       WSGIDaemonProcess iact \
           python-home=/opt/iact/venv \
           python-path=/opt/iact/api \
           processes=4 \
           threads=2 \
           maximum-requests=1000 \
           display-name=%{GROUP}

       WSGIProcessGroup iact

       # API endpoint
       WSGIScriptAlias /api /opt/iact/api/config/wsgi.py/api process-group=iact

       <Directory /opt/iact/api/config>
           <Files wsgi.py>
               Require all granted
           </Files>
       </Directory>

       # Django static files (admin, DRF)
       Alias /api/static/ /opt/iact/api/staticfiles/
       <Directory /opt/iact/api/staticfiles>
           Require all granted
       </Directory>

       # Media files (exports)
       Alias /media/ /opt/iact/media/
       <Directory /opt/iact/media>
           Require all granted
       </Directory>

       # ─────────────────────────────────────────────
       # SECURITY HEADERS
       # ─────────────────────────────────────────────
       Header always set X-Frame-Options "SAMEORIGIN"
       Header always set X-Content-Type-Options "nosniff"
       Header always set X-XSS-Protection "1; mode=block"
       Header always set Referrer-Policy "strict-origin-when-cross-origin"
       Header always set Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self';"

   </VirtualHost>

WSGI Configuration
~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/config/wsgi.py

   """
   WSGI config para IACT.

   Configurado para Apache mod_wsgi según CNST-008.
                                                   

   import os
   import sys

   # Agregar path del proyecto
   sys.path.insert(0, '/opt/iact/api')

   # Configurar Django settings
   os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings.production')

   # Activar virtual environment
   activate_this = '/opt/iact/venv/bin/activate_this.py'
   if os.path.exists(activate_this):
       exec(open(activate_this).read(), {'__file__': activate_this})

   from django.core.wsgi import get_wsgi_application

   application = get_wsgi_application()

Settings de Producción
~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/config/settings/production.py

   from .base import *
   from decouple import config

   DEBUG = False

   ALLOWED_HOSTS = [
       'iact.cliente.local',
       config('ALLOWED_HOST', default='localhost'),
   ]

   # Seguridad
   SECURE_SSL_REDIRECT = True
   SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')
   SESSION_COOKIE_SECURE = True
   CSRF_COOKIE_SECURE = True
   SECURE_HSTS_SECONDS = 31536000
   SECURE_HSTS_INCLUDE_SUBDOMAINS = True
   SECURE_CONTENT_TYPE_NOSNIFF = True
   SECURE_BROWSER_XSS_FILTER = True
   X_FRAME_OPTIONS = 'SAMEORIGIN'

   # Base de datos
   DATABASES = {
       'default': {
           'ENGINE': 'django.db.backends.postgresql',
           'NAME': config('DB_ANALYTICS_NAME'),
           'USER': config('DB_ANALYTICS_USER'),
           'PASSWORD': config('DB_ANALYTICS_PASSWORD'),
           'HOST': config('DB_ANALYTICS_HOST'),
           'PORT': config('DB_ANALYTICS_PORT', default='5432'),
           'CONN_MAX_AGE': 60,
       },
       'ivr_readonly': {
           'ENGINE': 'django.db.backends.mysql',
           'NAME': config('DB_IVR_NAME'),
           'USER': config('DB_IVR_USER'),
           'PASSWORD': config('DB_IVR_PASSWORD'),
           'HOST': config('DB_IVR_HOST'),
           'PORT': config('DB_IVR_PORT', default='3306'),
           'CONN_MAX_AGE': 60,
           'OPTIONS': {
               'charset': 'utf8mb4',
           },
       },
   }

   # Static files
   STATIC_URL = '/api/static/'
   STATIC_ROOT = '/opt/iact/api/staticfiles'

   # Media files
   MEDIA_URL = '/media/'
   MEDIA_ROOT = '/opt/iact/media'

   # Logging
   LOGGING = {
       'version': 1,
       'disable_existing_loggers': False,
       'formatters': {
           'verbose': {
               'format': '{asctime} [{levelname}] {name}: {message}',
               'style': '{',
           },
       },
       'handlers': {
           'file': {
               'level': 'INFO',
               'class': 'logging.handlers.RotatingFileHandler',
               'filename': '/opt/iact/logs/django.log',
               'maxBytes': 10 * 1024 * 1024,  # 10 MB
               'backupCount': 5,
               'formatter': 'verbose',
           },
           'etl_file': {
               'level': 'INFO',
               'class': 'logging.handlers.RotatingFileHandler',
               'filename': '/opt/iact/logs/etl.log',
               'maxBytes': 10 * 1024 * 1024,
               'backupCount': 5,
               'formatter': 'verbose',
           },
       },
       'loggers': {
           'django': {
               'handlers': ['file'],
               'level': 'INFO',
               'propagate': True,
           },
           'apps': {
               'handlers': ['file'],
               'level': 'INFO',
               'propagate': True,
           },
           'etl': {
               'handlers': ['etl_file'],
               'level': 'INFO',
               'propagate': False,
           },
       },
   }

Proceso de Deployment
---------------------

Generación del Paquete
~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   #!/bin/bash
   # scripts/build_package.sh

   set -e

   VERSION=$(date +%Y%m%d_%H%M%S)
   PACKAGE_NAME="iact_${VERSION}"
   BUILD_DIR="build/${PACKAGE_NAME}"

   echo "=========================================="
   echo "Generando paquete IACT v${VERSION}"
   echo "=========================================="

   # Limpiar builds anteriores
   rm -rf build/
   mkdir -p ${BUILD_DIR}

   # ─────────────────────────────────────────────
   # BACKEND
   # ─────────────────────────────────────────────
   echo "Empaquetando backend..."

   mkdir -p ${BUILD_DIR}/api

   # Copiar código Python
   cp -r api/apps ${BUILD_DIR}/api/
   cp -r api/config ${BUILD_DIR}/api/
   cp api/manage.py ${BUILD_DIR}/api/
   cp api/requirements.txt ${BUILD_DIR}/api/

   # Excluir archivos innecesarios
   find ${BUILD_DIR}/api -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
   find ${BUILD_DIR}/api -type f -name "*.pyc" -delete 2>/dev/null || true
   find ${BUILD_DIR}/api -type f -name ".DS_Store" -delete 2>/dev/null || true

   # ─────────────────────────────────────────────
   # FRONTEND
   # ─────────────────────────────────────────────
   echo "Construyendo frontend..."

   cd ui
   npm ci
   npm run build
   cd ..

   # Copiar build de React
   mkdir -p ${BUILD_DIR}/ui
   cp -r ui/build/* ${BUILD_DIR}/ui/

   # ─────────────────────────────────────────────
   # SCRIPTS Y CONFIGURACIÓN
   # ─────────────────────────────────────────────
   echo "Copiando scripts..."

   mkdir -p ${BUILD_DIR}/scripts
   cp scripts/deploy.sh ${BUILD_DIR}/scripts/
   cp scripts/backup.sh ${BUILD_DIR}/scripts/
   cp scripts/cleanup.sh ${BUILD_DIR}/scripts/
   chmod +x ${BUILD_DIR}/scripts/*.sh

   # Configuración de ejemplo
   cp .env.example ${BUILD_DIR}/.env.example

   # ─────────────────────────────────────────────
   # DOCUMENTACIÓN
   # ─────────────────────────────────────────────
   echo "Incluyendo documentación..."

   mkdir -p ${BUILD_DIR}/docs
   cp -r docs/deployment ${BUILD_DIR}/docs/
   cp CHANGELOG.md ${BUILD_DIR}/
   cp README_DEPLOYMENT.md ${BUILD_DIR}/

   # ─────────────────────────────────────────────
   # EXCEL DE CONTROL
   # ─────────────────────────────────────────────
   echo "Generando Excel de control..."

   python scripts/generate_deployment_excel.py \
       --version ${VERSION} \
       --output ${BUILD_DIR}/IACT_Deployment_Control_${VERSION}.xlsx

   # ─────────────────────────────────────────────
   # CREAR ZIP
   # ─────────────────────────────────────────────
   echo "Creando archivo ZIP..."

   cd build
   zip -r ${PACKAGE_NAME}.zip ${PACKAGE_NAME}/
   cd ..

   # Calcular checksums
   sha256sum build/${PACKAGE_NAME}.zip > build/${PACKAGE_NAME}.zip.sha256

   echo "=========================================="
   echo "Paquete generado: build/${PACKAGE_NAME}.zip"
   echo "SHA256: $(cat build/${PACKAGE_NAME}.zip.sha256)"
   echo "=========================================="

Script de Deployment
~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   #!/bin/bash
   # scripts/deploy.sh
   # Ejecutar en servidor de producción

   set -e

   IACT_HOME="/opt/iact"
   BACKUP_DIR="/opt/iact_backups"
   PACKAGE_ZIP="$1"

   if [ -z "$PACKAGE_ZIP" ]; then
       echo "Uso: ./deploy.sh <paquete.zip>"
       exit 1
   fi

   if [ ! -f "$PACKAGE_ZIP" ]; then
       echo "ERROR: Archivo no encontrado: $PACKAGE_ZIP"
       exit 1
   fi

   echo "=========================================="
   echo "Deployment IACT"
   echo "Paquete: $PACKAGE_ZIP"
   echo "=========================================="

   # ─────────────────────────────────────────────
   # 1. BACKUP
   # ─────────────────────────────────────────────
   echo "[1/7] Creando backup..."

   TIMESTAMP=$(date +%Y%m%d_%H%M%S)
   mkdir -p ${BACKUP_DIR}

   if [ -d "${IACT_HOME}/api" ]; then
       tar -czf ${BACKUP_DIR}/api_backup_${TIMESTAMP}.tar.gz -C ${IACT_HOME} api
   fi

   if [ -d "${IACT_HOME}/ui" ]; then
       tar -czf ${BACKUP_DIR}/ui_backup_${TIMESTAMP}.tar.gz -C ${IACT_HOME} ui
   fi

   # ─────────────────────────────────────────────
   # 2. DETENER SERVICIOS
   # ─────────────────────────────────────────────
   echo "[2/7] Deteniendo Apache..."

   sudo systemctl stop apache2

   # ─────────────────────────────────────────────
   # 3. EXTRAER PAQUETE
   # ─────────────────────────────────────────────
   echo "[3/7] Extrayendo paquete..."

   TEMP_DIR=$(mktemp -d)
   unzip -q ${PACKAGE_ZIP} -d ${TEMP_DIR}
   PACKAGE_DIR=$(ls ${TEMP_DIR})

   # ─────────────────────────────────────────────
   # 4. ACTUALIZAR BACKEND
   # ─────────────────────────────────────────────
   echo "[4/7] Actualizando backend..."

   # Preservar .env
   if [ -f "${IACT_HOME}/api/.env" ]; then
       cp ${IACT_HOME}/api/.env ${TEMP_DIR}/env_backup
   fi

   # Actualizar código
   rm -rf ${IACT_HOME}/api
   cp -r ${TEMP_DIR}/${PACKAGE_DIR}/api ${IACT_HOME}/

   # Restaurar .env
   if [ -f "${TEMP_DIR}/env_backup" ]; then
       cp ${TEMP_DIR}/env_backup ${IACT_HOME}/api/.env
   fi

   # Instalar dependencias
   source ${IACT_HOME}/venv/bin/activate
   pip install -r ${IACT_HOME}/api/requirements.txt --quiet

   # Migraciones
   cd ${IACT_HOME}/api
   python manage.py migrate --noinput

   # Collectstatic
   python manage.py collectstatic --noinput --clear

   deactivate

   # ─────────────────────────────────────────────
   # 5. ACTUALIZAR FRONTEND
   # ─────────────────────────────────────────────
   echo "[5/7] Actualizando frontend..."

   rm -rf ${IACT_HOME}/ui
   cp -r ${TEMP_DIR}/${PACKAGE_DIR}/ui ${IACT_HOME}/

   # ─────────────────────────────────────────────
   # 6. PERMISOS
   # ─────────────────────────────────────────────
   echo "[6/7] Configurando permisos..."

   chown -R www-data:www-data ${IACT_HOME}
   chmod -R 750 ${IACT_HOME}
   chmod -R 770 ${IACT_HOME}/logs
   chmod -R 770 ${IACT_HOME}/media

   # ─────────────────────────────────────────────
   # 7. INICIAR SERVICIOS
   # ─────────────────────────────────────────────
   echo "[7/7] Iniciando Apache..."

   sudo systemctl start apache2

   # Verificar estado
   sleep 3
   if curl -s -o /dev/null -w "%{http_code}" https://localhost/api/v1/health/ | grep -q "200"; then
       echo "=========================================="
       echo "Deployment completado exitosamente"
       echo "=========================================="
   else
       echo "WARNING: Health check falló, verificar logs"
   fi

   # Limpiar
   rm -rf ${TEMP_DIR}

Excel de Control de Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # scripts/generate_deployment_excel.py

   """
   Genera Excel de control para deployment.

   CNST-008: Todo deployment debe incluir Excel de control
   firmado por el cliente.
                          

   import argparse
   from datetime import datetime
   from openpyxl import Workbook
   from openpyxl.styles import Font, Alignment, Border, Side, PatternFill

   def generate_deployment_excel(version, output_path):
       wb = Workbook()
       ws = wb.active
       ws.title = "Control Deployment"

       # Estilos
       header_font = Font(bold=True, size=12)
       header_fill = PatternFill(start_color="366092", end_color="366092", fill_type="solid")
       header_font_white = Font(bold=True, size=12, color="FFFFFF")
       border = Border(
           left=Side(style='thin'),
           right=Side(style='thin'),
           top=Side(style='thin'),
           bottom=Side(style='thin')
       )

       # Título
       ws.merge_cells('A1:F1')
       ws['A1'] = f"IACT - Control de Deployment v{version}"
       ws['A1'].font = Font(bold=True, size=16)
       ws['A1'].alignment = Alignment(horizontal='center')

       # Información general
       ws['A3'] = "Información del Paquete"
       ws['A3'].font = header_font

       info_data = [
           ("Versión", version),
           ("Fecha Generación", datetime.now().strftime("%Y-%m-%d %H:%M:%S")),
           ("Sistema", "IACT - IVR Analytics & Customer Tracking"),
           ("Ambiente", "Producción"),
       ]

       row = 4
       for label, value in info_data:
           ws[f'A{row}'] = label
           ws[f'B{row}'] = value
           ws[f'A{row}'].font = Font(bold=True)
           row += 1

       # Checklist de deployment
       row += 1
       ws[f'A{row}'] = "Checklist de Deployment"
       ws[f'A{row}'].font = header_font
       row += 1

       headers = ["#", "Tarea", "Responsable", "Completado", "Fecha", "Observaciones"]
       for col, header in enumerate(headers, 1):
           cell = ws.cell(row=row, column=col, value=header)
           cell.font = header_font_white
           cell.fill = header_fill
           cell.border = border

       checklist = [
           "Backup de base de datos Analytics",
           "Backup de código actual",
           "Verificar espacio en disco",
           "Detener Apache",
           "Extraer paquete ZIP",
           "Actualizar código backend",
           "Ejecutar migraciones",
           "Actualizar frontend",
           "Configurar permisos",
           "Iniciar Apache",
           "Verificar health check API",
           "Verificar carga de dashboard",
           "Verificar login de usuario",
           "Verificar generación de reporte",
       ]

       row += 1
       for i, task in enumerate(checklist, 1):
           ws.cell(row=row, column=1, value=i).border = border
           ws.cell(row=row, column=2, value=task).border = border
           ws.cell(row=row, column=3, value="").border = border
           ws.cell(row=row, column=4, value="[ ]").border = border
           ws.cell(row=row, column=5, value="").border = border
           ws.cell(row=row, column=6, value="").border = border
           row += 1

       # Firmas
       row += 2
       ws[f'A{row}'] = "Aprobaciones"
       ws[f'A{row}'].font = header_font
       row += 1

       signatures = [
           ("Preparado por", "Equipo IACT", ""),
           ("Ejecutado por", "", ""),
           ("Verificado por", "", ""),
           ("Aprobado por (Cliente)", "", ""),
       ]

       headers = ["Rol", "Nombre", "Firma / Fecha"]
       for col, header in enumerate(headers, 1):
           cell = ws.cell(row=row, column=col, value=header)
           cell.font = header_font_white
           cell.fill = header_fill
           cell.border = border

       row += 1
       for rol, nombre, firma in signatures:
           ws.cell(row=row, column=1, value=rol).border = border
           ws.cell(row=row, column=2, value=nombre).border = border
           ws.cell(row=row, column=3, value=firma).border = border
           row += 1

       # Ajustar anchos
       ws.column_dimensions['A'].width = 25
       ws.column_dimensions['B'].width = 40
       ws.column_dimensions['C'].width = 20
       ws.column_dimensions['D'].width = 12
       ws.column_dimensions['E'].width = 15
       ws.column_dimensions['F'].width = 30

       wb.save(output_path)
       print(f"Excel generado: {output_path}")


   if __name__ == '__main__':
       parser = argparse.ArgumentParser()
       parser.add_argument('--version', required=True)
       parser.add_argument('--output', required=True)
       args = parser.parse_args()

       generate_deployment_excel(args.version, args.output)

Rollback
--------

Script de Rollback
~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   #!/bin/bash
   # scripts/rollback.sh

   set -e

   IACT_HOME="/opt/iact"
   BACKUP_DIR="/opt/iact_backups"

   echo "=========================================="
   echo "Rollback IACT"
   echo "=========================================="

   # Listar backups disponibles
   echo "Backups disponibles:"
   ls -la ${BACKUP_DIR}/*.tar.gz 2>/dev/null || echo "No hay backups"
   echo ""

   read -p "Ingrese timestamp del backup (YYYYMMDD_HHMMSS): " TIMESTAMP

   API_BACKUP="${BACKUP_DIR}/api_backup_${TIMESTAMP}.tar.gz"
   UI_BACKUP="${BACKUP_DIR}/ui_backup_${TIMESTAMP}.tar.gz"

   if [ ! -f "$API_BACKUP" ]; then
       echo "ERROR: Backup de API no encontrado: $API_BACKUP"
       exit 1
   fi

   echo "Ejecutando rollback a versión ${TIMESTAMP}..."

   # Detener Apache
   sudo systemctl stop apache2

   # Restaurar API
   if [ -f "$API_BACKUP" ]; then
       rm -rf ${IACT_HOME}/api
       tar -xzf ${API_BACKUP} -C ${IACT_HOME}
   fi

   # Restaurar UI
   if [ -f "$UI_BACKUP" ]; then
       rm -rf ${IACT_HOME}/ui
       tar -xzf ${UI_BACKUP} -C ${IACT_HOME}
   fi

   # Permisos
   chown -R www-data:www-data ${IACT_HOME}

   # Iniciar Apache
   sudo systemctl start apache2

   echo "Rollback completado"

Validación en Desarrollo
------------------------

Pre-commit Checklist
~~~~~~~~~~~~~~~~~~~~

Antes de hacer commit, verificar:

.. list-table::
   :header-rows: 0
   :widths: 10 90

   * - [ ]
     - NO existe Dockerfile en el repositorio
   * - [ ]
     - NO existe docker-compose.yml
   * - [ ]
     - NO existe configuración de Kubernetes
   * - [ ]
     - WSGI configurado para mod_wsgi
   * - [ ]
     - Settings de producción usan variables de entorno

Code Review Checklist
~~~~~~~~~~~~~~~~~~~~~

Durante code review, rechazar si:

.. list-table::
   :header-rows: 0
   :widths: 10 90

   * - [ ]
     - Se agregan archivos Docker
   * - [ ]
     - Se referencia servicios cloud
   * - [ ]
     - Configuración hardcoded de producción
   * - [ ]
     - Paths absolutos que no sean /opt/iact

Script de Validación
~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   #!/bin/bash
   # scripts/validate_no_docker.sh

   echo "Validando que no existan referencias a Docker/Cloud..."

   ERRORS=0

   # Buscar archivos Docker
   if [ -f "Dockerfile" ] || [ -f "docker-compose.yml" ]; then
       echo "ERROR: Archivos Docker encontrados"
       ERRORS=$((ERRORS + 1))
   fi

   # Buscar referencias a Docker en código
   if grep -r "docker\|kubernetes\|k8s" . --include="*.py" --include="*.yml" 2>/dev/null | grep -v ".git"; then
       echo "WARNING: Referencias a Docker/K8s encontradas"
   fi

   # Verificar WSGI
   if ! grep -q "WSGIScriptAlias\|mod_wsgi\|wsgi.py" . -r 2>/dev/null; then
       echo "WARNING: Configuración WSGI no encontrada"
   fi

   if [ $ERRORS -eq 0 ]; then
       echo "OK: Sin referencias a Docker/Cloud"
       exit 0
   else
       echo "FALLO: $ERRORS errores encontrados"
       exit 1
   fi

Referencias
-----------

Documentos Relacionados
~~~~~~~~~~~~~~~~~~~~~~~

- CNST-002: Gestión de Sesiones (sin Redis)
- CNST-004: Actualización de Datos ETL
- CNST-009: Logging y Auditoría

Implementación de Referencia
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- ``api/config/wsgi.py`` - Configuración WSGI
- ``api/config/settings/production.py`` - Settings producción
- ``scripts/build_package.sh`` - Generación de paquete
- ``scripts/deploy.sh`` - Script de deployment

Historial de Cambios
--------------------

.. list-table::
   :header-rows: 1
   :widths: 15 15 50 20

   * - Versión
     - Fecha
     - Cambios
     - Autor
   * - 1.0.1
     - 2026-01-03
     - Actualización de metadatos. Sin cambios funcionales
     - Equipo IACT
   * - 1.0.0
     - 2025-12-17
     - Versión inicial Apache + mod_wsgi
     - Equipo IACT

Aprobaciones
------------

.. list-table::
   :header-rows: 1
   :widths: 30 30 40

   * - Rol
     - Nombre
     - Firma / Fecha
   * - Cliente (Sponsor)
     - [Nombre]
     - [Pendiente]
   * - Tech Lead
     - [Nombre]
     - [Pendiente]
   * - Sysadmin Cliente
     - [Nombre]
     - [Pendiente]

----

**Fin del Documento CNST-008**