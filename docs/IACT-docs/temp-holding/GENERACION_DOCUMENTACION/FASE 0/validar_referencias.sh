#!/bin/bash
# Script de validación de referencias en documentos
# Uso: ./validar_referencias.sh <archivo>

archivo="$1"

if [ -z "$archivo" ]; then
  echo "Uso: $0 <archivo>"
  exit 1
fi

if [ ! -f "$archivo" ]; then
  echo "[ERROR] Archivo no existe: $archivo"
  exit 1
fi

basename=$(basename "$archivo")
errores=0
warnings=0

echo "========================================="
echo "VALIDANDO REFERENCIAS: $basename"
echo "========================================="

# Buscar referencias a archivos .md
echo ""
echo "Referencias a archivos .md:"
echo "----------------------------"
grep -n -o '[A-Z_]*_[0-9]_[0-9]_[0-9]\.md' "$archivo" | while IFS=: read linea ref; do
  echo "  Línea $linea: $ref"
  # Verificar si existe en /tmp o /mnt/user-data/outputs
  if [ -f "/tmp/iact_regeneracion/*/$ref" ] || \
     [ -f "/mnt/user-data/outputs/$ref" ] || \
     [ -f "/tmp/$ref" ]; then
    echo "    [OK] Archivo encontrado"
  else
    echo "    [WARN] Archivo no encontrado (puede no estar generado aún)"
    warnings=$((warnings + 1))
  fi
done

# Buscar referencias a archivos .rst
echo ""
echo "Referencias a archivos .rst:"
echo "----------------------------"
grep -n -o '[A-Z_]*_[0-9]_[0-9]_[0-9]\.rst' "$archivo" | while IFS=: read linea ref; do
  echo "  Línea $linea: $ref"
  if [ -f "/tmp/iact_regeneracion/*/$ref" ] || \
     [ -f "/mnt/user-data/outputs/$ref" ] || \
     [ -f "/tmp/$ref" ]; then
    echo "    [OK] Archivo encontrado"
  else
    echo "    [WARN] Archivo no encontrado (puede no estar generado aún)"
    warnings=$((warnings + 1))
  fi
done

# Buscar referencias antiguas (sin versionado)
echo ""
echo "Verificando referencias antiguas (SIN versionado):"
echo "---------------------------------------------------"

# Buscar "PARTE X" sin underscore y versión
if grep -n 'PARTE [0-9]' "$archivo" | grep -v '_[0-9]_[0-9]_[0-9]'; then
  echo "[ERROR] Encontradas referencias antiguas a PARTES (sin versionado)"
  errores=$((errores + 1))
else
  echo "[OK] No hay referencias antiguas a PARTES"
fi

# Buscar "T01", "T02", etc sin TPL_
if grep -n '\bT[0-9][0-9]\b' "$archivo" | grep -v 'TPL_'; then
  echo "[ERROR] Encontradas referencias antiguas a Templates (T01, T02...)"
  errores=$((errores + 1))
else
  echo "[OK] No hay referencias antiguas a Templates"
fi

# Buscar emojis (prohibido por STD_001)
echo ""
echo "Verificando emojis (prohibido por STD_001):"
echo "--------------------------------------------"
if grep -n '[✅❌⚠️🚀📁💾]' "$archivo"; then
  echo "[ERROR] Encontrados emojis (prohibido por STD_001 v1.1.0)"
  errores=$((errores + 1))
else
  echo "[OK] No hay emojis"
fi

echo ""
echo "========================================="
echo "RESUMEN:"
echo "  Errores: $errores"
echo "  Warnings: $warnings"
echo "========================================="

if [ $errores -eq 0 ]; then
  echo "RESULTADO: [OK] Referencias válidas"
  exit 0
else
  echo "RESULTADO: [ERROR] $errores errores críticos"
  exit 1
fi
