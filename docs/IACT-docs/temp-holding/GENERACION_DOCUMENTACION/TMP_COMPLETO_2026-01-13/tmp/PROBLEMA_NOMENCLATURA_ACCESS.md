# PROBLEMA DETECTADO: Inconsistencia Nomenclatura ACCESS

## ANÁLISIS RÁPIDO

### Nomenclatura en Archivos Individuales (NUEVA v4.0.0)
```
UC_ACC_01_Asignar_Funciones.rst         ← Nomenclatura v4.0.0
UC_ACC_02_Revocar_Funciones.rst
UC_ACC_03_Consultar_Permisos.rst
UC_ACC_04_Asignar_Agrupador.rst
UC_ACC_05_Gestionar_SoD.rst
UC_ACC_06_Gestionar_Segmentos.rst
UC_ACC_07_Asignar_Segmento.rst
UC_ACC_08_Permiso_Temporal.rst          ← NUEVO, no existe en v2.0
UC_ACC_09_Auditar_Cambios_Acceso.rst
```

### Nomenclatura en index.rst de access (ANTIGUA v2.0)
```
UC-010  Asignar Funciones
UC-011  Revocar Funciones
UC-041  Asignar Segmento
UC-042  Revocar Segmento
UC-043  Configurar SoD
UC-044  Consultar Permisos
UC-045  Gestionar Agrupadores
UC-046  Gestionar Funciones
UC-047  Auditar Permisos
```

### Toctree en index.rst de access (ARCHIVOS ANTIGUOS)
```rst
UC_010_Asignar_Funciones
UC_011_Revocar_Funciones
UC_041_Asignar_Segmento
UC_042_Revocar_Segmento
UC_043_Configurar_SoD
UC_044_Consultar_Permisos
UC_045_Gestionar_Agrupadores
UC_046_Gestionar_Funciones
UC_047_Auditar_Permisos
```

## MAPEO (Nueva → Antigua)

| Nueva (v4.0) | Antigua (v2.0) | Nombre | ¿Coincide? |
|--------------|----------------|--------|------------|
| UC_ACC_01 | UC-010 | Asignar Funciones | ✅ |
| UC_ACC_02 | UC-011 | Revocar Funciones | ✅ |
| UC_ACC_03 | UC-044 | Consultar Permisos | ✅ |
| UC_ACC_04 | UC-045? | Asignar Agrupador | ⚠️ Nombre diferente |
| UC_ACC_05 | UC-043 | Gestionar SoD | ✅ |
| UC_ACC_06 | UC-046? | Gestionar Segmentos | ❌ En v2.0 es "Funciones" |
| UC_ACC_07 | UC-041 | Asignar Segmento | ✅ |
| UC_ACC_08 | ??? | Permiso Temporal | ❌ NO EXISTE en v2.0 |
| UC_ACC_09 | UC-047 | Auditar Cambios Acceso | ✅ |

## PROBLEMAS IDENTIFICADOS

### 1. index.rst de access está desactualizado
- Usa nomenclatura v2.0 (UC-010, UC-011, etc.)
- Debería usar v4.0.0 (UC_ACC_01, UC_ACC_02, etc.)

### 2. Toctree apunta a archivos inexistentes
```rst
.. toctree::
   UC_010_Asignar_Funciones    ← Archivo NO existe
   UC_011_Revocar_Funciones    ← Archivo NO existe
   ...
```

Debería ser:
```rst
.. toctree::
   UC_ACC_01_Asignar_Funciones    ← Archivo SÍ existe
   UC_ACC_02_Revocar_Funciones    ← Archivo SÍ existe
   ...
```

### 3. Discrepancia en UC_ACC_06
- Archivo actual: UC_ACC_06_Gestionar_Segmentos.rst
- index.rst v2.0 dice: UC-046 Gestionar Funciones
- ¿Cuál es el correcto?

### 4. UC_ACC_08 es NUEVO
- No existe en v2.0
- Se agregó en v4.0.0

### 5. Falta UC-042 en la nueva nomenclatura
- v2.0 tiene: UC-042 Revocar Segmento
- v4.0 no tiene UC_ACC_XX equivalente visible
- ¿Se eliminó o se consolidó en otro UC?

## ACCIONES NECESARIAS

### PRIORIDAD 1: Actualizar index.rst de access
1. Cambiar todas las referencias UC-XXX → UC_ACC_XX
2. Actualizar toctree con nombres correctos de archivos
3. Agregar UC_ACC_08 (nuevo)
4. Verificar si UC-042 debe incluirse o se eliminó

### PRIORIDAD 2: Verificar contenido de UC_ACC_06
Necesito ver el archivo para confirmar si es:
- Gestionar Segmentos (nombre del archivo)
- Gestionar Funciones (nombre en v2.0)

### PRIORIDAD 3: Sincronizar métricas
- v2.0 dice: 9 UC
- v4.0 tiene: 9 archivos UC_ACC_XX
- Confirmar que el conteo es correcto

