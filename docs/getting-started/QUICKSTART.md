# IACT DevBox - Quickstart

Comandos esenciales para usar IACT DevBox. Para más información ver [README.md](README.md).

## Setup Inicial

```powershell
# Método 1: Automático (recomendado)
.\scripts\setup-environment.ps1

# Método 2: Manual
vagrant up
.\scripts\verify-vms.ps1
```

## Comandos Diarios

```powershell
# Iniciar VMs
vagrant up

# Ver estado
vagrant status

# Detener VMs
vagrant halt

# Reiniciar VMs
vagrant reload

# SSH a una VM
vagrant ssh mariadb
vagrant ssh postgresql
vagrant ssh adminer
```

## Acceso Rápido

```bash
# MariaDB
mysql -h 192.168.56.10 -u root -p'rootpass123'
mysql -h 192.168.56.10 -u django_user -p'django_pass' ivr_legacy

# PostgreSQL
psql -h 192.168.56.11 -U postgres
psql -h 192.168.56.11 -U django_user -d iact_analytics

# Adminer (navegador)
http://192.168.56.12
```

## Scripts de Diagnóstico

```powershell
# Problema general
.\scripts\diagnose-system.ps1

# Error de red
.\scripts\fix-network.ps1

# Verificar VMs
.\scripts\verify-vms.ps1

# Reporte para soporte
.\scripts\generate-support-bundle.ps1
```

## Mantenimiento

```powershell
# Limpiar logs
.\scripts\clean-logs.ps1

# Comprimir logs
.\scripts\clean-logs.ps1 -Compress

# Reiniciar desde cero
vagrant destroy -f
.\scripts\setup-environment.ps1
```

## Troubleshooting Rápido

```powershell
# No hay conectividad
.\scripts\diagnose-system.ps1
.\scripts\fix-network.ps1

# VMs no arrancan
vagrant reload --provision

# Ver logs de error
Get-ChildItem logs\*.log | Select-String "ERROR"
```

## Siguiente Paso

Ver [TROUBLESHOOTING.md](TROUBLESHOOTING.md) para problemas específicos.
