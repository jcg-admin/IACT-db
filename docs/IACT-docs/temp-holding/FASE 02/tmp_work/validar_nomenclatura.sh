#!/bin/bash
# Script de validación de nomenclatura NOM_001 v2.0.0
# Uso: ./validar_nomenclatura.sh <archivo>

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

echo "========================================="
echo "VALIDANDO NOMENCLATURA: $basename"
echo "========================================="

# Verificar versionado _X_Y_Z
if [[ ! $basename =~ _[0-9]+_[0-9]+_[0-9]+\.(md|rst)$ ]]; then
  echo "[ERROR] Falta versionado _MAJOR_MINOR_PATCH"
  echo "        Formato esperado: *_X_Y_Z.{md|rst}"
  echo "        Encontrado: $basename"
  errores=$((errores + 1))
else
  echo "[OK] Versionado presente"
fi

# Verificar que NO use guiones (solo guiones bajos)
if [[ $basename =~ [A-Z]+-[A-Z]+ ]]; then
  echo "[ERROR] Usa guiones en lugar de guiones bajos"
  echo "        Corregir guiones (-) por guiones bajos (_)"
  errores=$((errores + 1))
else
  echo "[OK] Usa guiones bajos correctamente"
fi

# Verificar prefijo válido
prefijos_validos="PARTE TPL BR UC FR CNST BRQ AGR STD NOM ANLSS PLN INDICE"
prefijo=$(echo "$basename" | cut -d_ -f1)

if echo "$prefijos_validos" | grep -qw "$prefijo"; then
  echo "[OK] Prefijo válido: $prefijo"
else
  echo "[WARN] Prefijo no estándar: $prefijo"
  echo "       Prefijos válidos: $prefijos_validos"
fi

# Verificar extensión
if [[ $basename =~ \.(md|rst)$ ]]; then
  extension="${BASH_REMATCH[1]}"
  echo "[OK] Extensión válida: .$extension"
else
  echo "[ERROR] Extensión inválida (debe ser .md o .rst)"
  errores=$((errores + 1))
fi

echo "========================================="
if [ $errores -eq 0 ]; then
  echo "RESULTADO: [OK] Nomenclatura correcta"
  echo "========================================="
  exit 0
else
  echo "RESULTADO: [ERROR] $errores errores encontrados"
  echo "========================================="
  exit 1
fi
