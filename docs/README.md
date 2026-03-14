# Documentación IACT DevBox

Bienvenido a la documentación completa del proyecto IACT DevBox, un entorno de desarrollo multi-base de datos basado en Vagrant y VirtualBox.

## Tabla de Contenidos

- [Inicio Rápido](#inicio-rápido)
- [Estructura de la Documentación](#estructura-de-la-documentación)
- [Guías por Rol de Usuario](#guías-por-rol-de-usuario)
- [Documentos por Categoría](#documentos-por-categoría)
- [Recursos Adicionales](#recursos-adicionales)

---

## Inicio Rápido

Si es tu primera vez con IACT DevBox, sigue esta ruta:

1. **[Instalación Rápida](getting-started/QUICKSTART.md)** - Configura el entorno en 10 minutos
2. **[Comandos Básicos](getting-started/COMMANDS.md)** - Aprende los comandos esenciales de Vagrant
3. **[Verificación Completa](getting-started/VERIFICACION_COMPLETA.md)** - Confirma que todo funciona correctamente

Después de completar estos pasos, tu entorno estará listo para desarrollo.

---

## Estructura de la Documentación

La documentación está organizada en categorías para facilitar la navegación:

### Getting Started (Primeros Pasos)

Documentación esencial para comenzar a usar IACT DevBox.

- **[QUICKSTART.md](getting-started/QUICKSTART.md)** - Guía de instalación rápida
- **[COMMANDS.md](getting-started/COMMANDS.md)** - Referencia de comandos Vagrant
- **[VERIFICACION_COMPLETA.md](getting-started/VERIFICACION_COMPLETA.md)** - Checklist de verificación post-instalación

### Setup (Configuración Avanzada)

Configuraciones opcionales que mejoran la experiencia de desarrollo.

- **[INSTALAR_CA_WINDOWS.md](setup/INSTALAR_CA_WINDOWS.md)** - Instalación de certificado CA para HTTPS sin advertencias
- **[PERFILES_POWERSHELL.md](setup/PERFILES_POWERSHELL.md)** - Configuración del perfil de PowerShell

### Architecture (Arquitectura y Desarrollo)

Documentación técnica para desarrolladores y mantenedores del proyecto.

- **[DEVELOPMENT.md](architecture/DEVELOPMENT.md)** - Guía de desarrollo del proyecto
- **[PROVISIONERS.md](architecture/PROVISIONERS.md)** - Documentación del sistema de provisioning

### Troubleshooting (Resolución de Problemas)

Soluciones a problemas comunes y errores conocidos.

- **[TROUBLESHOOTING.md](troubleshooting/TROUBLESHOOTING.md)** - Guía completa de resolución de problemas
- **[VAGRANT_2.4.7_WORKAROUND.md](troubleshooting/VAGRANT_2.4.7_WORKAROUND.md)** - Solución al bug de Vagrant 2.4.7

### Archive (Archivo Histórico)

Documentos obsoletos mantenidos como referencia histórica.

- **[TROUBLESHOOTING_ORIGINAL.md](archive/TROUBLESHOOTING_ORIGINAL.md)** - Versión original de troubleshooting

---

## Guías por Rol de Usuario

### Para Usuarios Nuevos

Si nunca has usado IACT DevBox antes:

1. Lee **[QUICKSTART.md](getting-started/QUICKSTART.md)** para la instalación inicial
2. Familiarízate con **[COMMANDS.md](getting-started/COMMANDS.md)** para comandos básicos
3. Ejecuta **[VERIFICACION_COMPLETA.md](getting-started/VERIFICACION_COMPLETA.md)** para confirmar que todo funciona
4. Opcionalmente, instala el certificado CA siguiendo **[INSTALAR_CA_WINDOWS.md](setup/INSTALAR_CA_WINDOWS.md)**
5. Configura PowerShell con **[PERFILES_POWERSHELL.md](setup/PERFILES_POWERSHELL.md)** para mejor experiencia

### Para Usuarios Experimentados

Si ya conoces Vagrant y necesitas referencia rápida:

- **[COMMANDS.md](getting-started/COMMANDS.md)** - Referencia rápida de comandos
- **[TROUBLESHOOTING.md](troubleshooting/TROUBLESHOOTING.md)** - Solución de problemas específicos
- **[VAGRANT_2.4.7_WORKAROUND.md](troubleshooting/VAGRANT_2.4.7_WORKAROUND.md)** - Si usas Vagrant 2.4.7

### Para Desarrolladores

Si vas a modificar o extender IACT DevBox:

1. Entiende la arquitectura con **[DEVELOPMENT.md](architecture/DEVELOPMENT.md)**
2. Revisa el sistema de provisioning en **[PROVISIONERS.md](architecture/PROVISIONERS.md)**
3. Consulta **[TROUBLESHOOTING.md](troubleshooting/TROUBLESHOOTING.md)** para depuración
4. Ejecuta **[VERIFICACION_COMPLETA.md](getting-started/VERIFICACION_COMPLETA.md)** después de cambios

### Para Administradores de Sistemas

Si vas a desplegar o administrar el entorno:

1. Revisa **[QUICKSTART.md](getting-started/QUICKSTART.md)** para requisitos del sistema
2. Configura el entorno siguiendo **[PERFILES_POWERSHELL.md](setup/PERFILES_POWERSHELL.md)**
3. Implementa certificados con **[INSTALAR_CA_WINDOWS.md](setup/INSTALAR_CA_WINDOWS.md)**
4. Valida con **[VERIFICACION_COMPLETA.md](getting-started/VERIFICACION_COMPLETA.md)**
5. Mantén **[TROUBLESHOOTING.md](troubleshooting/TROUBLESHOOTING.md)** a mano para soporte

---

## Documentos por Categoría

### Instalación y Configuración Inicial

Documentos que necesitas al comenzar con el proyecto.

| Documento | Descripción | Tiempo Estimado |
|-----------|-------------|-----------------|
| [QUICKSTART.md](getting-started/QUICKSTART.md) | Instalación completa paso a paso | 10-15 minutos |
| [PERFILES_POWERSHELL.md](setup/PERFILES_POWERSHELL.md) | Configurar PowerShell correctamente | 5 minutos |
| [VERIFICACION_COMPLETA.md](getting-started/VERIFICACION_COMPLETA.md) | Verificar instalación exitosa | 10-15 minutos |

### Uso Diario

Documentos de referencia para uso cotidiano.

| Documento | Descripción | Cuándo Usar |
|-----------|-------------|-------------|
| [COMMANDS.md](getting-started/COMMANDS.md) | Comandos de Vagrant y gestión de VMs | Referencia diaria |
| [TROUBLESHOOTING.md](troubleshooting/TROUBLESHOOTING.md) | Solución de problemas comunes | Cuando algo falla |
| [VAGRANT_2.4.7_WORKAROUND.md](troubleshooting/VAGRANT_2.4.7_WORKAROUND.md) | Fix para bug específico de versión | Si usas Vagrant 2.4.7 |

### Mejoras Opcionales

Configuraciones que mejoran la experiencia pero no son obligatorias.

| Documento | Descripción | Beneficio |
|-----------|-------------|-----------|
| [INSTALAR_CA_WINDOWS.md](setup/INSTALAR_CA_WINDOWS.md) | Certificados SSL confiables | HTTPS sin advertencias |
| [PERFILES_POWERSHELL.md](setup/PERFILES_POWERSHELL.md) | Optimizar PowerShell | SSH funcional, comandos más rápidos |

### Desarrollo y Arquitectura

Documentación técnica interna del proyecto.

| Documento | Descripción | Para Quién |
|-----------|-------------|------------|
| [DEVELOPMENT.md](architecture/DEVELOPMENT.md) | Guía de desarrollo del proyecto | Desarrolladores |
| [PROVISIONERS.md](architecture/PROVISIONERS.md) | Sistema de provisioning | Mantenedores |

---

## Información del Proyecto

### Qué es IACT DevBox

IACT DevBox es un entorno de desarrollo local que proporciona:

- **MariaDB 11.4** - Base de datos legacy (IVR)
- **PostgreSQL 16** - Base de datos analytics moderna
- **Adminer 4.8.1** - Interfaz web unificada de administración

Todo configurado automáticamente con Vagrant, listo para usar en minutos.

### Arquitectura del Sistema

```
Host Windows (192.168.56.1)
│
├── VM: MariaDB (192.168.56.10:3306)
│   └── Base de datos: ivr_legacy
│
├── VM: PostgreSQL (192.168.56.11:5432)
│   └── Base de datos: iact_analytics
│
└── VM: Adminer (192.168.56.12:80/443)
    └── URL: http://adminer.devbox o https://adminer.devbox
```

### Requisitos del Sistema

**Software requerido**:
- Windows 10/11 (64-bit)
- VirtualBox 7.0+
- Vagrant 2.4+
- PowerShell 5.1+
- Git for Windows

**Hardware recomendado**:
- CPU: 4+ cores
- RAM: 8GB+ (sistema usa ~5GB con 3 VMs)
- Disco: 20GB+ libres

### Características Principales

- Provisioning completamente automatizado
- Networking privado aislado (192.168.56.0/24)
- SSL/HTTPS con Certificate Authority propia
- Dominio local: adminer.devbox
- Scripts modulares y reutilizables
- Logging detallado de todas las operaciones
- Configuración reproducible y documentada

---

## Workflows Comunes

### Workflow 1: Primera Instalación

```powershell
# 1. Configurar PowerShell
# Seguir: setup/PERFILES_POWERSHELL.md

# 2. Levantar VMs
cd D:\Estadia_IACT\proyecto\IACT\db
vagrant up

# 3. Verificar instalación
# Seguir: getting-started/VERIFICACION_COMPLETA.md

# 4. Instalar CA (opcional)
# Seguir: setup/INSTALAR_CA_WINDOWS.md
```

### Workflow 2: Uso Diario

```powershell
# Iniciar VMs
vagrant up

# Trabajar con bases de datos
# - Via Adminer: http://adminer.devbox
# - Via CLI: ver getting-started/COMMANDS.md

# Detener VMs al finalizar
vagrant halt
```

### Workflow 3: Resolver Problemas

```powershell
# 1. Identificar síntomas
vagrant status

# 2. Consultar troubleshooting
# Ver: troubleshooting/TROUBLESHOOTING.md

# 3. Aplicar solución documentada

# 4. Verificar corrección
# Ver: getting-started/VERIFICACION_COMPLETA.md
```

### Workflow 4: Desarrollo de Features

```powershell
# 1. Entender arquitectura
# Leer: architecture/DEVELOPMENT.md

# 2. Revisar provisioners
# Leer: architecture/PROVISIONERS.md

# 3. Hacer cambios

# 4. Reprovisionar para probar
vagrant provision [vm]

# 5. Verificar cambios
# Seguir: getting-started/VERIFICACION_COMPLETA.md
```

---

## Rutas de Aprendizaje

### Ruta 1: Usuario Básico (2-3 horas)

Objetivo: Usar el entorno para desarrollo

1. [QUICKSTART.md](getting-started/QUICKSTART.md) - 15 min
2. [COMMANDS.md](getting-started/COMMANDS.md) - 30 min
3. [VERIFICACION_COMPLETA.md](getting-started/VERIFICACION_COMPLETA.md) - 15 min
4. Práctica con Adminer y bases de datos - 60 min
5. [TROUBLESHOOTING.md](troubleshooting/TROUBLESHOOTING.md) - 30 min (referencia)

### Ruta 2: Usuario Avanzado (4-6 horas)

Objetivo: Dominar configuración y optimización

1. Completar Ruta 1
2. [PERFILES_POWERSHELL.md](setup/PERFILES_POWERSHELL.md) - 30 min
3. [INSTALAR_CA_WINDOWS.md](setup/INSTALAR_CA_WINDOWS.md) - 30 min
4. [VAGRANT_2.4.7_WORKAROUND.md](troubleshooting/VAGRANT_2.4.7_WORKAROUND.md) - 20 min
5. Práctica avanzada con networking y SSL - 120 min
6. [TROUBLESHOOTING.md](troubleshooting/TROUBLESHOOTING.md) - 60 min (completo)

### Ruta 3: Desarrollador/Mantenedor (8-10 horas)

Objetivo: Modificar y extender el sistema

1. Completar Ruta 2
2. [DEVELOPMENT.md](architecture/DEVELOPMENT.md) - 120 min
3. [PROVISIONERS.md](architecture/PROVISIONERS.md) - 120 min
4. Análisis de código fuente - 180 min
5. Implementar cambio de prueba - 120 min
6. Toda la documentación de troubleshooting - 60 min

---

## Recursos Adicionales

### Documentación Oficial Externa

- [Vagrant Documentation](https://developer.hashicorp.com/vagrant/docs)
- [VirtualBox Manual](https://www.virtualbox.org/manual/)
- [MariaDB Documentation](https://mariadb.com/kb/en/documentation/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Adminer Documentation](https://www.adminer.org/)
- [PowerShell Documentation](https://learn.microsoft.com/powershell/)

### Comandos de Ayuda Rápida

```powershell
# Ver estado de VMs
vagrant status

# Ver ayuda de un comando
vagrant [comando] --help

# Ver logs de provisioning
Get-Content logs\[vm]\*.log

# Acceder a Adminer
Start-Process http://adminer.devbox
```

### Directorios Importantes

```
D:\Estadia_IACT\proyecto\IACT\db\
├── Vagrantfile                 # Configuración principal
├── docs\                       # Esta documentación
├── config\                     # Archivos de configuración
│   ├── ssl.sh                  # Script de generación SSL
│   ├── vhost.conf              # VirtualHost HTTP
│   ├── vhost_ssl.conf          # VirtualHost HTTPS
│   └── certs\                  # Certificados SSL
├── provisioners\               # Scripts de provisioning
│   ├── mariadb\
│   ├── postgresql\
│   └── adminer\
├── scripts\                    # Scripts de utilidades
├── utils\                      # Utilidades compartidas
└── logs\                       # Logs de provisioning
```

---

## Convenciones de la Documentación

### Formato de Código

Los bloques de código PowerShell se muestran así:

```powershell
vagrant up
```

Los bloques de código Bash (dentro de VMs) se muestran así:

```bash
sudo systemctl status mariadb
```

### Rutas de Archivo

Las rutas se muestran en formato Windows:

```
D:\Estadia_IACT\proyecto\IACT\db\config\ssl.sh
```

Dentro de VMs, las rutas usan formato Unix:

```
/vagrant/config/ssl.sh
```

### Comandos Opcionales

Los parámetros opcionales se muestran entre corchetes:

```powershell
vagrant up [vm_name]
```

### Valores de Ejemplo

Los valores que debes reemplazar se muestran entre `<>`:

```powershell
mysql -h 192.168.56.10 -u <usuario> -p'<password>'
```

---

## Mantenimiento de la Documentación

### Cómo Contribuir

Si encuentras errores o áreas de mejora en la documentación:

1. Verifica que no esté ya documentado en otra sección
2. Si es un problema técnico, agrégalo a [TROUBLESHOOTING.md](troubleshooting/TROUBLESHOOTING.md)
3. Si es una mejora de proceso, actualiza el documento correspondiente
4. Mantén el estilo y formato consistente

### Principios de Documentación

Esta documentación sigue estos principios:

- **Claridad sobre concisión**: Preferir explicaciones claras aunque sean más largas
- **Ejemplos prácticos**: Cada instrucción debe tener un ejemplo
- **Verificación**: Cada proceso debe incluir cómo verificar que funcionó
- **Troubleshooting proactivo**: Anticipar problemas comunes
- **Actualización continua**: Mantener relevante y precisa

### Última Actualización

Esta documentación fue reorganizada el 2026-01-10 para mejorar la navegación y accesibilidad.

---

## Contacto y Soporte

### Antes de Reportar Problemas

1. Consulta [TROUBLESHOOTING.md](troubleshooting/TROUBLESHOOTING.md)
2. Verifica con [VERIFICACION_COMPLETA.md](getting-started/VERIFICACION_COMPLETA.md)
3. Revisa los logs en `logs/[vm]/`
4. Busca en la documentación por el mensaje de error específico

### Información Útil para Reportes

Al reportar un problema, incluye:

- Salida de `vagrant --version`
- Salida de `VBoxManage --version`
- Salida de `vagrant status`
- Contenido del último log en `logs/`
- Pasos exactos para reproducir el problema

---

## Licencia y Uso

Este proyecto es para uso interno de IACT. Todos los derechos reservados.

La documentación puede ser compartida internamente sin restricciones, pero no debe ser distribuida fuera de la organización sin autorización.

---

## Versión de la Documentación

- **Versión**: 2.1.0
- **Fecha**: 2026-01-10
- **Cambios principales**: Reorganización en subdirectorios, mejora de navegación
- **Sistema**: IACT DevBox v2.1.0

---

## Índice Alfabético de Documentos

- [COMMANDS.md](getting-started/COMMANDS.md) - Referencia de comandos Vagrant
- [DEVELOPMENT.md](architecture/DEVELOPMENT.md) - Guía de desarrollo
- [INSTALAR_CA_WINDOWS.md](setup/INSTALAR_CA_WINDOWS.md) - Instalación de certificado CA
- [PERFILES_POWERSHELL.md](setup/PERFILES_POWERSHELL.md) - Configuración de PowerShell
- [PROVISIONERS.md](architecture/PROVISIONERS.md) - Sistema de provisioning
- [QUICKSTART.md](getting-started/QUICKSTART.md) - Instalación rápida
- [TROUBLESHOOTING.md](troubleshooting/TROUBLESHOOTING.md) - Resolución de problemas
- [VAGRANT_2.4.7_WORKAROUND.md](troubleshooting/VAGRANT_2.4.7_WORKAROUND.md) - Bug de Vagrant 2.4.7
- [VERIFICACION_COMPLETA.md](getting-started/VERIFICACION_COMPLETA.md) - Checklist de verificación

---

**¿Nuevo en IACT DevBox?** Comienza con [QUICKSTART.md](getting-started/QUICKSTART.md)

**¿Tienes un problema?** Consulta [TROUBLESHOOTING.md](troubleshooting/TROUBLESHOOTING.md)

**¿Necesitas una referencia rápida?** Ve a [COMMANDS.md](getting-started/COMMANDS.md)
