# Reporte de Validación de Trazabilidad - Proyecto IACT

**Fecha:** 2025-11-17
**Versión:** 1.0.0
**Ejecutado por:** Script validar-trazabilidad.sh v1.0.0 + generar-matriz-trazabilidad.py v1.0.0
**Basado en:** ADR-GOB-009 - Trazabilidad entre Artefactos de Requisitos

---

## Resumen Ejecutivo

Este reporte presenta los resultados de la validación de trazabilidad de requisitos del proyecto IACT, ejecutada el 17 de noviembre de 2025. La validación identifica el estado actual de la trazabilidad entre artefactos de ingeniería de requisitos y detecta problemas que requieren corrección.

### Estado General

| Estado | Resultado |
|--------|-----------|
| **Estado Global** | FALLIDO |
| **IDs Válidos Encontrados** | 6 |
| **Referencias Totales** | 36 |
| **Errores Críticos** | 17 |
| **Warnings** | 23 |

### Distribución de Artefactos por Tipo

| Tipo | Cantidad | Descripción |
|------|----------|-------------|
| **RN** | 1 | Reglas de Negocio |
| **RNEG** | 1 | Requerimientos de Negocio |
| **UC** | 1 | Casos de Uso |
| **RF** | 1 | Requisitos Funcionales |
| **RNF** | 1 | Atributos de Calidad |
| **Total** | **6** | Artefactos válidos con formato correcto |

---

## Métricas Detalladas

### 1. Cobertura de Trazabilidad

```
Total de Artefactos Válidos:      6
Referencias Totales Verificadas:  36
IDs Duplicados:                   0
Artefactos Huérfanos:             1 (16.67%)
Sin Referencias Salientes:        1 (16.67%)
```

### 2. Calidad de Referencias

| Métrica | Valor | Porcentaje |
|---------|-------|------------|
| **Referencias Válidas** | 20 | 55.56% |
| **Referencias Rotas** | 16 | 44.44% |
| **Tasa de Éxito** | - | 55.56% |

### 3. Distribución de Referencias

#### Por Tipo de Artefacto

| Tipo | Referencias Salientes | Referencias Entrantes | Promedio |
|------|----------------------|----------------------|----------|
| **RN-BACK-001** | 7 | 4 | 5.5 |
| **RNEG-BACK-001** | 6 | 2 | 4.0 |
| **UC-BACK-001** | 9 | 4 | 6.5 |
| **RF-BACK-010** | 3 | 2 | 2.5 |
| **RNF-BACK-005** | 5 | 2 | 3.5 |
| **UC-FRONT-001** | 1 (auto-ref) | 0 | 0.5 |

---

## Issues Identificados

### Críticos (17 errores)

#### 1. Referencias Rotas (16 errores)

Las siguientes referencias apuntan a artefactos que **NO EXISTEN** en el repositorio:

| ID Roto | Referenciado Desde | Archivo |
|---------|-------------------|---------|
| **RF-BACK-011** | UC-BACK-001, RN-BACK-001 | UC-BACK-001-iniciar-sesion.md, RN-BACK-001-autenticacion-requerida.md |
| **RF-BACK-012** | UC-BACK-001 | UC-BACK-001-iniciar-sesion.md |
| **RF-BACK-015** | RNF-BACK-005 | RNF-BACK-005-longitud-contrasena.md |
| **RN-BACK-002** | RNEG-BACK-001 | RNEG-BACK-001-sistema-autenticacion.md |
| **RN-BACK-028** | UC-BACK-001 | UC-BACK-001-iniciar-sesion.md |
| **RNF-BACK-006** | UC-BACK-001, RF-BACK-010 | UC-BACK-001-iniciar-sesion.md, RF-BACK-010-validar-credenciales.md |
| **RNF-BACK-007** | UC-BACK-001, RN-BACK-001 | UC-BACK-001-iniciar-sesion.md, RN-BACK-001-autenticacion-requerida.md |
| **UC-BACK-002** | RNEG-BACK-001 | RNEG-BACK-001-sistema-autenticacion.md |
| **UC-BACK-003** | RNEG-BACK-001, RN-BACK-001, RNF-BACK-005 | RNEG-BACK-001-sistema-autenticacion.md, otros |
| **UC-BACK-004** | RNEG-BACK-001, RNF-BACK-005 | RNEG-BACK-001-sistema-autenticacion.md, RNF-BACK-005-longitud-contrasena.md |

**Impacto:** Estas referencias rotas indican que:
- Los artefactos fueron eliminados sin actualizar las referencias
- Los IDs fueron cambiados sin actualizar dependencias
- Los artefactos nunca existieron (referencias a documentos planificados)

#### 2. Artefacto Huérfano (1 error)

**UC-FRONT-001** - Ejemplo sin Referencias
- **Archivo:** `UC-FRONT-001-ejemplo-sin-referencias.md`
- **Problema:** Ningún otro artefacto referencia este caso de uso
- **Impacto:** No está conectado con ningún requerimiento de negocio, regla de negocio o requisito funcional
- **Estado:** Aislado del resto del sistema de requisitos

### Warnings (23 warnings)

#### 1. Formatos de ID Inválidos (20 warnings)

Los siguientes archivos usan formatos de ID que **NO CUMPLEN** con el estándar ADR-GOB-009:

**Formato Esperado:** `TIPO-DOMINIO-###` donde:
- TIPO: RN, RNEG, UC, RF, RNF
- DOMINIO: BACK, FRONT, DEVOPS, QA, AI, GOB
- ###: 001-999 (3 dígitos)

**Archivos con formatos inválidos:**

| Archivo | ID Actual | Problema |
|---------|-----------|----------|
| `UC-PERM-001_asignar_grupo_a_usuario.md` | UC-PERM-001 | Dominio inválido (PERM no es válido) |
| `UC-PERM-002_revocar_grupo_a_usuario.md` | UC-PERM-002 | Dominio inválido (PERM no es válido) |
| `UC-PERM-003_conceder_permiso_excepcional.md` | UC-PERM-003 | Dominio inválido (PERM no es válido) |
| `UC-PERM-004_revocar_permiso_excepcional.md` | UC-PERM-004 | Dominio inválido (PERM no es válido) |
| `UC-PERM-005_crear_grupo_permisos.md` | UC-PERM-005 | Dominio inválido (PERM no es válido) |
| `UC-PERM-006_asignar_capacidades_grupo.md` | UC-PERM-006 | Dominio inválido (PERM no es válido) |
| `UC-PERM-007_verificar_permiso_usuario.md` | UC-PERM-007 | Dominio inválido (PERM no es válido) |
| `UC-PERM-008_generar_menu_dinamico.md` | UC-PERM-008 | Dominio inválido (PERM no es válido) |
| `UC-PERM-009_auditar_acceso.md` | UC-PERM-009 | Dominio inválido (PERM no es válido) |
| `UC-PERM-010_consultar_auditoria.md` | UC-PERM-010 | Dominio inválido (PERM no es válido) |
| `UC-CALL-001_registrar_llamada_entrante.md` | UC-CALL-001 | Dominio inválido (CALL no es válido) |
| `UC-CALL-002_atender_llamada.md` | UC-CALL-002 | Dominio inválido (CALL no es válido) |
| `UC-CALL-003_transferir_llamada.md` | UC-CALL-003 | Dominio inválido (CALL no es válido) |
| `UC-CALL-004_generar_reporte_rendimiento.md` | UC-CALL-004 | Dominio inválido (CALL no es válido) |
| `README.md` | DOC-REQ-INDEX | Tipo inválido (DOC no es válido) |
| `matriz_trazabilidad_rtm.md` | DOC-RTM | Tipo inválido (DOC no es válido) |
| `brs_business_requirements.md` (x2) | DOC-BRS | Tipo inválido (DOC no es válido) |
| `strs_stakeholder_requirements.md` (x2) | DOC-STRS | Tipo inválido (DOC no es válido) |
| `srs_software_requirements.md` | DOC-SRS | Tipo inválido (DOC no es válido) |

**Recomendación:** Estos IDs deben ser migrados a dominios válidos:
- `UC-PERM-*` → `UC-BACK-*` (si son backend) o `UC-FRONT-*` (si son frontend)
- `UC-CALL-*` → `UC-BACK-*` o `UC-FRONT-*`
- `DOC-*` → Usar categoría de documentación (no son requisitos rastreables)

#### 2. Artefacto Sin Referencias Salientes (1 warning)

**UC-FRONT-001** - Ejemplo sin Referencias
- **Problema:** No referencia ningún otro artefacto (RN, RNEG, RF, RNF)
- **Impacto:** No se puede trazar su justificación de negocio

---

## Matrices de Trazabilidad Generadas

### Matriz Vertical - Dominio BACK

La matriz vertical muestra la cadena de trazabilidad completa desde requerimientos de negocio hasta atributos de calidad:

```
RNEG-BACK-001 (Sistema de Autenticación Seguro)
    ↓
RN-BACK-001 (Usuario Debe Estar Autenticado)
    ↓
UC-BACK-001 (Iniciar Sesión)
    ↓
RF-BACK-010 (Validar Credenciales contra Base de Datos)
    ↓
RNF-BACK-005 (Contraseña Mínimo 8 Caracteres)
```

**Estado:** Cadena de trazabilidad completa y válida para estos 5 artefactos.

**Archivo generado:** `/home/user/IACT---project/scripts/trazabilidad/matriz-vertical-BACK.md`

### Matriz de Dominio - BACK

Análisis completo del dominio BACK con todas las relaciones:

**Estadísticas:**
- Total de artefactos: 5
- Artefactos con referencias salientes: 5 (100%)
- Artefactos con referencias entrantes: 5 (100%)
- Cobertura de trazabilidad: 100% (para artefactos válidos)

**Archivo generado:** `/home/user/IACT---project/scripts/trazabilidad/matriz-dominio-BACK.md`

### Matriz Horizontal - UC-BACK-001

Análisis de trazabilidad del caso de uso UC-BACK-001 (Iniciar Sesión):

**Referencias Salientes:**
- RF-BACK-010 (válido)
- RF-BACK-011 (ROTO)
- RF-BACK-012 (ROTO)
- RN-BACK-001 (válido)
- RN-BACK-028 (ROTO)
- RNEG-BACK-001 (válido)
- RNF-BACK-005 (válido)
- RNF-BACK-006 (ROTO)
- RNF-BACK-007 (ROTO)

**Referencias Entrantes:**
- RF-BACK-010 (válido)
- RN-BACK-001 (válido)
- RNEG-BACK-001 (válido)
- RNF-BACK-005 (válido)

**Estado:** 44% de referencias rotas (4/9 válidas)

**Archivo generado:** `/home/user/IACT---project/scripts/trazabilidad/matriz-horizontal-UC-BACK-001.md`

---

## Análisis de Impacto

### Impacto en Gestión de Requisitos

| Área | Impacto | Severidad |
|------|---------|-----------|
| **Trazabilidad Completa** | 44.44% de referencias rotas impide trazabilidad completa | ALTA |
| **Gestión de Cambios** | Dificulta análisis de impacto de cambios | ALTA |
| **Auditabilidad** | 16.67% de artefactos huérfanos reduce auditabilidad | MEDIA |
| **Calidad de Documentación** | 20 IDs con formato inválido reduce consistencia | MEDIA |
| **Mantenibilidad** | Referencias rotas dificultan mantenimiento | ALTA |

### Impacto en Desarrollo

- **Cobertura de Requisitos:** No se puede validar que todos los requisitos estén implementados
- **Pruebas:** Dificulta creación de casos de prueba completos
- **Revisiones:** Complejiza revisiones de código contra requisitos
- **Documentación Técnica:** Impacta calidad de documentación de arquitectura

---

## Recomendaciones

### Prioridad CRÍTICA (Inmediata)

#### 1. Resolver Referencias Rotas

**Acción:** Revisar los 16 IDs rotos y decidir para cada uno:

**Opción A - Crear Artefactos Faltantes:**
```bash
# Ejemplo: Crear RF-BACK-011
cd /home/user/IACT---project/docs/gobernanza/requisitos/requerimientos_funcionales/backend
cp plantilla-rf.md RF-BACK-011-[nombre-descriptivo].md
# Editar y completar contenido
```

**Opción B - Eliminar Referencias:**
```bash
# Si el ID ya no es relevante, eliminar referencias en archivos que lo mencionan
grep -r "RF-BACK-011" docs/gobernanza/requisitos/
# Editar cada archivo y eliminar la referencia
```

**Opción C - Corregir IDs:**
```bash
# Si el ID cambió, actualizar todas las referencias
# Ejemplo: RF-BACK-011 → RF-BACK-010
```

**Comando para verificar progreso:**
```bash
./scripts/validar-trazabilidad.sh
```

#### 2. Resolver Artefacto Huérfano UC-FRONT-001

**Acción:** Decidir el destino del artefacto:

**Opción A - Conectar con Requisitos:**
1. Identificar el requerimiento de negocio que justifica UC-FRONT-001
2. Crear o actualizar RNEG-FRONT-001 o RN-FRONT-001
3. Agregar referencias en UC-FRONT-001

**Opción B - Eliminar si es obsoleto:**
```bash
# Si es un ejemplo que ya no es necesario
rm docs/gobernanza/requisitos/ejemplos_test/UC-FRONT-001-ejemplo-sin-referencias.md
```

### Prioridad ALTA (Esta semana)

#### 3. Migrar IDs Inválidos a Formato Estándar

**Plan de Migración:**

**Paso 1:** Crear mapeo de IDs antiguos a nuevos
```
UC-PERM-001 → UC-BACK-021 (o UC-FRONT-021)
UC-PERM-002 → UC-BACK-022
UC-PERM-003 → UC-BACK-023
...
UC-CALL-001 → UC-BACK-031
UC-CALL-002 → UC-BACK-032
...
```

**Paso 2:** Renombrar archivos
```bash
cd docs/gobernanza/requisitos/requerimientos_usuario/casos_uso
mv UC-PERM-001_asignar_grupo_a_usuario.md UC-BACK-021-asignar-grupo-a-usuario.md
# Repetir para todos los archivos
```

**Paso 3:** Actualizar IDs en contenido de archivos
```bash
# Buscar y reemplazar en cada archivo
sed -i 's/UC-PERM-001/UC-BACK-021/g' UC-BACK-021-asignar-grupo-a-usuario.md
```

**Paso 4:** Actualizar referencias en otros archivos
```bash
# Buscar referencias al ID antiguo
grep -r "UC-PERM-001" docs/gobernanza/requisitos/
# Actualizar cada referencia encontrada
```

**Paso 5:** Validar migración
```bash
./scripts/validar-trazabilidad.sh
```

**Script de ayuda para migración:**
```bash
# Crear script de migración
cat > scripts/migrar-ids-invalidos.sh << 'EOF'
#!/bin/bash
# Script para migrar IDs inválidos a formato estándar
# Ver: docs/gobernanza/qa/VALIDACION-TRAZABILIDAD-2025-01-17.md

# Definir mapeos
declare -A MAPEO=(
    ["UC-PERM-001"]="UC-BACK-021"
    ["UC-PERM-002"]="UC-BACK-022"
    # ... agregar todos los mapeos
)

# Implementar lógica de migración
# TODO: Completar implementación
EOF
chmod +x scripts/migrar-ids-invalidos.sh
```

#### 4. Establecer Proceso de Revisión

**Acción:** Crear git hook para validar trazabilidad antes de commit

```bash
# Instalar pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Validar trazabilidad antes de commit

# Solo validar si se modificaron archivos de requisitos
if git diff --cached --name-only | grep -q "docs/gobernanza/requisitos/"; then
    echo "Validando trazabilidad de requisitos..."

    if ! ./scripts/validar-trazabilidad.sh --no-color; then
        echo "❌ ERROR: Validación de trazabilidad falló"
        echo "Por favor corrija los errores antes de hacer commit"
        exit 1
    fi

    echo "✅ Validación de trazabilidad exitosa"
fi

exit 0
EOF
chmod +x .git/hooks/pre-commit
```

### Prioridad MEDIA (Este mes)

#### 5. Ampliar Cobertura de Trazabilidad

**Meta:** Crear al menos 3 artefactos por dominio (BACK, FRONT, AI)

**Plan:**
1. Identificar funcionalidades principales del sistema
2. Crear cadena completa de trazabilidad por funcionalidad:
   - RNEG → RN → UC → RF → RNF
3. Validar con `validar-trazabilidad.sh`
4. Generar matrices con `generar-matriz-trazabilidad.py`

#### 6. Documentar Proceso de Trazabilidad

**Crear guía:** `docs/gobernanza/guias/GUIA-GESTION-TRAZABILIDAD.md`

**Contenido sugerido:**
- Cómo crear nuevos requisitos con trazabilidad correcta
- Cómo actualizar referencias al modificar requisitos
- Cómo validar trazabilidad antes de commits
- Cómo generar y leer matrices de trazabilidad
- Mejores prácticas y casos de uso comunes

#### 7. Crear Dashboard de Métricas

**Objetivo:** Visualizar estado de trazabilidad en tiempo real

**Implementación:**
```bash
# Generar reporte de métricas
./scripts/validar-trazabilidad.sh > /tmp/trazabilidad.txt
./scripts/generar-matriz-trazabilidad.py --tipo dominio --dominio BACK \
    --output docs/gobernanza/qa/MATRIZ-BACK-latest.md

# Extraer métricas para dashboard
# TODO: Crear script que genere badges y gráficos
```

---

## Archivos Generados

Este reporte generó los siguientes archivos:

1. **Reporte de Validación:**
   - `/home/user/IACT---project/docs/gobernanza/qa/VALIDACION-TRAZABILIDAD-2025-01-17.md` (este archivo)

2. **Matrices de Trazabilidad:**
   - `/home/user/IACT---project/scripts/trazabilidad/matriz-vertical-BACK.md`
   - `/home/user/IACT---project/scripts/trazabilidad/matriz-dominio-BACK.md`
   - `/home/user/IACT---project/scripts/trazabilidad/matriz-horizontal-UC-BACK-001.md`

---

## Comandos de Validación

### Ejecutar Validación Completa

```bash
cd /home/user/IACT---project

# Validación básica
./scripts/validar-trazabilidad.sh

# Validación con detalles (verbose)
./scripts/validar-trazabilidad.sh -v

# Validación sin colores (para CI/CD)
./scripts/validar-trazabilidad.sh --no-color
```

### Generar Matrices de Trazabilidad

```bash
# Matriz vertical por dominio
./scripts/generar-matriz-trazabilidad.py --tipo vertical --dominio BACK

# Matriz de dominio completo
./scripts/generar-matriz-trazabilidad.py --tipo dominio --dominio BACK \
    --output docs/gobernanza/trazabilidad/MATRIZ-BACK.md

# Matriz horizontal (relaciones de un UC específico)
./scripts/generar-matriz-trazabilidad.py --tipo horizontal --id UC-BACK-001
```

### Buscar Referencias

```bash
# Buscar todas las referencias a un ID específico
grep -r "UC-BACK-001" docs/gobernanza/requisitos/

# Listar todos los IDs válidos
find docs/gobernanza/requisitos/ -name "*.md" -exec grep -oE "(RN|RNEG|UC|RF|RNF)-(BACK|FRONT|DEVOPS|QA|AI|GOB)-[0-9]{3}" {} \; | sort -u

# Detectar IDs con formato inválido
find docs/gobernanza/requisitos/ -name "*.md" -exec grep -oE "[A-Z]+-[A-Z]+-[0-9]+" {} \; | \
    grep -vE "(RN|RNEG|UC|RF|RNF)-(BACK|FRONT|DEVOPS|QA|AI|GOB)-[0-9]{3}" | sort -u
```

---

## Conclusiones

### Estado Actual

El proyecto IACT tiene una **base sólida** de trazabilidad con:
- Scripts de validación funcionales y completos
- 6 artefactos de ejemplo con formato correcto
- Sistema de IDs estructurado según ADR-GOB-009

Sin embargo, existen **problemas críticos** que impiden una trazabilidad efectiva:
- 44.44% de referencias rotas (16/36)
- 20 archivos con formatos de ID inválidos
- 1 artefacto huérfano sin conexión al resto del sistema

### Próximos Pasos

**Corto Plazo (Esta semana):**
1. Resolver las 16 referencias rotas
2. Conectar o eliminar UC-FRONT-001
3. Iniciar migración de IDs inválidos

**Medio Plazo (Este mes):**
1. Completar migración de IDs inválidos
2. Ampliar cobertura de trazabilidad
3. Documentar proceso de gestión de trazabilidad
4. Implementar git hooks de validación

**Largo Plazo (Este trimestre):**
1. Lograr 100% de trazabilidad en todos los dominios
2. Automatizar generación de reportes
3. Integrar validación en CI/CD
4. Crear dashboard de métricas de calidad

### Métricas Objetivo

| Métrica | Actual | Objetivo Q1 2026 |
|---------|--------|------------------|
| Referencias Rotas | 44.44% | 0% |
| Artefactos Huérfanos | 16.67% | 0% |
| IDs con Formato Válido | 23.08% (6/26) | 100% |
| Cobertura de Dominios | 20% (1/5) | 100% |
| Artefactos por Dominio | 1.2 promedio | 10+ promedio |

---

## Referencias

- **ADR-GOB-009:** Trazabilidad entre Artefactos de Requisitos
- **Script de Validación:** `/home/user/IACT---project/scripts/validar-trazabilidad.sh`
- **Script de Matrices:** `/home/user/IACT---project/scripts/generar-matriz-trazabilidad.py`
- **Directorio de Requisitos:** `/home/user/IACT---project/docs/gobernanza/requisitos/`

---

## Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2025-11-17 | Claude Code (Sonnet 4.5) | Reporte inicial de validación de trazabilidad |

---

**Generado automáticamente por:**
- Script: `validar-trazabilidad.sh` v1.0.0
- Script: `generar-matriz-trazabilidad.py` v1.0.0
- Fecha de ejecución: 2025-11-17 09:52:21
