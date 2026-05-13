# ANÁLISIS PARTE 1: Ejemplos Pedagógicos vs Proyecto IACT

**Fecha:** 2026-01-08  
**Documento:** PARTE 1 - IDENTIFICAR REGLAS DE NEGOCIO  
**Objetivo:** Identificar ejemplos pedagógicos para reemplazar con casos IACT

---

## RESUMEN EJECUTIVO

PARTE 1 usa **DOMINIO DE PRODUCTOS QUÍMICOS** como contexto pedagógico principal:
- Sistema de Gestión de Químicos (laboratorio universitario)
- BR-028: Solicitudes >$500 requieren aprobación
- BR-031: Notificar vencimiento de químico
- BR-046: Marcar químico como caduco
- BR-087: Solo personal certificado OSHA

**PROBLEMA:**
El proyecto IACT es un **sistema de análisis IVR** (llamadas telefónicas), NO gestión de químicos.

**SOLUCIÓN:**
Reemplazar TODOS los ejemplos de químicos con ejemplos del dominio IVR del proyecto IACT.

---

## EJEMPLOS PEDAGÓGICOS IDENTIFICADOS EN PARTE 1

### Ejemplo Principal: Sistema de Gestión de Químicos

**BR-028 (Restricción):**
```
Definición: "Solicitudes de compra >$500 requieren aprobación 
             del gerente de departamento"
Tipo: Restricción
Fuente: Política Financiera Corporativa v2.3, Sección 4.2
```

**UC-04: Solicitar Producto Químico**
```
Actor: Solicitante
Objetivo: Obtener autorización para adquirir un producto químico
Flujo:
  1. Solicitante ingresa código del producto
  2. Sistema muestra información del producto
  3. Solicitante ingresa cantidad y justificación
  4. Sistema verifica capacitación del solicitante
  5. Sistema valida cantidad contra límites permitidos
  6. SI monto >$500 ENTONCES solicitar aprobación gerente
  7. Sistema registra la solicitud
  8. Sistema notifica al solicitante
Business Rules: BR-028, BR-087, BR-031
```

**BR-031 (Desencadenador):**
```
Definición: "SI un contenedor de químico alcanza su fecha de 
             vencimiento ENTONCES notificar por email al propietario 
             y al coordinador de seguridad"
Tipo: Desencadenador
Genera: UC-07 "Notificar Vencimiento de Químico"
```

**BR-046 (Inferencia):**
```
Definición: "SI un contenedor de químico alcanza su fecha de 
             vencimiento ENTONCES marcar como 'Caduco'"
Tipo: Inferencia
NO genera UC (solo lógica interna)
```

**BR-087 (Restricción):**
```
Definición: "Solo personal con certificación OSHA vigente puede 
             solicitar productos químicos peligrosos (clase 1-4)"
Tipo: Restricción
Fuente: OSHA 29 CFR 1910.1200
```

### Otros Ejemplos Pedagógicos

**BR-012 (Hecho):**
```
"Cada contenedor de producto químico tiene un código de barras único"
```

**BR-060 (Cálculo):**
```
"El descuento aplicable se determina según tabla de descuentos por volumen"
Tabla:
  1-10 items: 0%
  11-50 items: 5%
  51-100 items: 10%
  101+ items: 15%
```

**BR-089 (Inferencia):**
```
"SI cuenta con saldo impago >30 días ENTONCES clasificar como 'deudora'"
```

**BR-122 (Desencadenador):**
```
"SI cuenta con saldo impago >30 días ENTONCES enviar recordatorio de pago"
```

**BR-156 (Desencadenador):**
```
"SI transacción >$10,000 ENTONCES generar reporte fiscal automático"
```

**BR-178 (Cálculo):**
```
"Costo de envío según zona geográfica, peso y tipo de servicio"
Tabla 3x3 con zonas y rangos de peso
```

**BR-234 (Cálculo):**
```
"Calificación final = 70% teórica + 30% práctica"
```

**BR-245 (Desencadenador):**
```
"SI inventario < punto_reorden ENTONCES alertar a compras"
```

**BR-246 (Inferencia):**
```
"SI inventario < punto_reorden ENTONCES marcar como 'stock bajo'"
```

---

## CORRESPONDENCIA CON base_cognitiva/

Según análisis previo, estos ejemplos aparecen en:

**FND_01_Concepto_Requisito.rst:**
- Línea 316: UC-40 (genérico)
- Línea 490: UC-015 (Generar Reporte Mensual)

**FND_03_Casos_de_Uso.rst:**
- Línea 100: UC-043 (SoD) → químicos
- Líneas 265-274: Tabla agrupadores UC-006 a UC-040
- Línea 277: UC-050 (ETL)
- Líneas 614-616: UC-001, UC-002, UC-003 (Autenticación)

**MTM_01_Metamodelo_Requisitos.rst:**
- UC_010 (Asignar Rol) → ejemplos de trazabilidad BR → UC → FR
- UC_ETL

**MTM_02_Metamodelo_Trazabilidad.rst:**
- 9 referencias a UC_010 en tablas RTM
- Ejemplos de trazabilidad con químicos

**TXM_01_Taxonomia_Requisitos.rst:**
- Rangos UC-005 a UC-011 (mezcla módulos)
- Ejemplos UC-006, UC-010, UC-017, UC-025, UC-022, UC-037

**TXM_03_Taxonomia_Reglas_Negocio.rst:**
- Probablemente ejemplos de BR con químicos

---

## ESTRATEGIA DE REEMPLAZO: Dominio IVR

El proyecto IACT es un sistema de **análisis de llamadas IVR**. Necesitamos ejemplos del dominio IVR/telecomunicaciones.

### Ejemplos de Reemplazo Sugeridos

#### 1. Reemplazo de BR-028 (Restricción - Aprobación)

**ANTES (Químicos):**
```
BR-028: "Solicitudes >$500 requieren aprobación gerente"
```

**DESPUÉS (IVR):**
```
BR_IACT_028 (Restricción):
  Definición: "Consultas de reportes consolidados con >10,000 registros 
               requieren aprobación del supervisor de área"
  Tipo: Restricción
  Fuente: Política de Uso de Recursos Computacionales v1.2, Sección 3.4
  Fecha Vigencia: 2024-01-01
  Estática/Dinámica: Dinámica
  Prioridad: Media
  
  Justificación: Reportes grandes consumen recursos significativos
  del servidor. Requiere autorización para evitar saturación.
```

#### 2. Reemplazo de BR-031 (Desencadenador - Notificación)

**ANTES (Químicos):**
```
BR-031: "SI químico vence ENTONCES notificar propietario"
UC-07: Notificar Vencimiento de Químico
```

**DESPUÉS (IVR):**
```
BR_IACT_031 (Desencadenador):
  Definición: "SI un pipeline ETL falla en 3 intentos consecutivos 
               ENTONCES el sistema debe notificar por email al 
               coordinador técnico y al gerente de TI"
  Tipo: Desencadenador
  Fuente: Política de Monitoreo de Pipelines v2.1, Artículo 5
  Fecha Vigencia: 2024-06-01
  Genera: UC_PIP_05 "Notificar Falla Crítica de Pipeline"
  
  Actor: Sistema (pipeline monitor)
  Actores secundarios: Coordinador Técnico, Gerente TI
  Flujo:
    1. Sistema detecta 3er fallo consecutivo
    2. Sistema identifica pipeline afectado
    3. Sistema identifica coordinador y gerente
    4. Sistema envía email con detalles del error
    5. Sistema registra notificación en bitácora
    
  FR derivados:
    RF_PIP_05_01: "Sistema monitorea estado de pipelines cada 5 minutos"
    RF_PIP_05_02: "Sistema cuenta fallos consecutivos por pipeline"
    RF_PIP_05_03: "Sistema envía email con log de error adjunto"
    RF_PIP_05_04: "Sistema registra timestamp de notificación"
```

#### 3. Reemplazo de BR-046 (Inferencia - Marca Interna)

**ANTES (Químicos):**
```
BR-046: "SI químico vence ENTONCES marcar como 'Caduco'"
```

**DESPUÉS (IVR):**
```
BR_IACT_046 (Inferencia):
  Definición: "SI un pipeline ETL no se ejecuta exitosamente en 24 horas 
               ENTONCES el pipeline debe ser marcado con estado 'Crítico' 
               en el sistema"
  Tipo: Inferencia
  Fuente: Política de Monitoreo de Pipelines v2.1, Artículo 5
  
  Condición: última_ejecución_exitosa > 24 horas
  Nuevo hecho: estado_pipeline = "Crítico" (INTERNO)
  
  NO genera Caso de Uso (solo lógica interna)
  
  Genera:
    RF_PIP_05_05: "Sistema actualiza campo estado_pipeline a 'Crítico' 
                   cuando última ejecución exitosa > 24h"
```

#### 4. Reemplazo de BR-087 (Restricción - Permisos)

**ANTES (Químicos):**
```
BR-087: "Solo personal certificado OSHA puede solicitar químicos peligrosos"
```

**DESPUÉS (IVR):**
```
BR_IACT_087 (Restricción):
  Definición: "Solo usuarios con rol REPORTS_ADVANCED_VIEWER o superior 
               pueden acceder a reportes con datos de clientes sensibles 
               (información financiera, datos personales)"
  Tipo: Restricción
  Fuente: Política de Seguridad de Datos v3.0, Sección 7.2
  Fecha Vigencia: 2023-11-01
  Estática/Dinámica: Dinámica
  Prioridad: Alta
  
  Justificación: Cumplimiento con Ley de Protección de Datos Personales.
  Solo personal autorizado puede ver información sensible.
  
  Impacto:
    - Precondición en UC_RPT_03 "Consultar Reporte Cliente"
    - Validación de rol antes de renderizar columnas sensibles
    - RF_RPT_03_02: "Sistema verifica rol antes de mostrar datos sensibles"
```

#### 5. Reemplazo de BR-012 (Hecho - Estructura)

**ANTES (Químicos):**
```
BR-012: "Cada contenedor de químico tiene código de barras único"
```

**DESPUÉS (IVR):**
```
BR_IACT_012 (Hecho):
  Definición: "Cada llamada registrada en el sistema tiene un identificador 
               único (call_id) que no puede ser reasignado a otra llamada"
  Tipo: Hecho
  Fuente: Estándar de Identificación de Eventos IVR v1.0, Sección 2.1
  Fecha Vigencia: 2023-01-01
  Estática/Dinámica: Estática
  
  Impacto en Sistema:
    - Entidad: Llamada
    - Atributo: call_id (UUID, unique, not null, immutable)
    - Validación: Verificar unicidad al ingestar evento
```

#### 6. Reemplazo de BR-060 (Cálculo - Tabla)

**ANTES (Químicos/Descuentos):**
```
BR-060: "Descuento por volumen según tabla"
1-10: 0%
11-50: 5%
51-100: 10%
101+: 15%
```

**DESPUÉS (IVR):**
```
BR_IACT_060 (Cálculo):
  Definición: "La prioridad de procesamiento de un reporte se determina 
               según la cantidad de registros a procesar"
  Tipo: Cálculo
  Fuente: Política de Asignación de Recursos v1.5, Anexo C
  Fecha Vigencia: 2024-03-01
  
  Tabla de Prioridades:
  
  | ID      | Registros Mín | Registros Máx | Prioridad | Cola     |
  |---------|---------------|---------------|-----------|----------|
  | PRIO-1  | 1             | 1,000         | Alta      | express  |
  | PRIO-2  | 1,001         | 10,000        | Media     | normal   |
  | PRIO-3  | 10,001        | 100,000       | Baja      | batch    |
  | PRIO-4  | 100,001       | ∞             | Diferida  | nightly  |
  
  Algoritmo:
    registros = count(datos_a_procesar)
    IF registros <= 1000 THEN cola = "express", prioridad = "Alta"
    ELSE IF registros <= 10000 THEN cola = "normal", prioridad = "Media"
    ELSE IF registros <= 100000 THEN cola = "batch", prioridad = "Baja"
    ELSE cola = "nightly", prioridad = "Diferida"
  
  Impacto:
    - UC_RPT_01, Paso 5: Determinar prioridad
    - RF_RPT_01_08: "Sistema calcula cantidad de registros"
    - RF_RPT_01_09: "Sistema asigna cola según tabla de prioridades"
```

#### 7. Ejemplo Adicional: UC_AUTH_01 (Caso Simple)

```
UC_AUTH_01: Iniciar Sesión

Actor Primario: Usuario del Sistema
Objetivo: Autenticarse en el sistema IACT para acceder a funcionalidades

Precondiciones:
  - Usuario tiene cuenta creada
  - Sistema está operativo

Flujo Normal:
  1. Usuario accede a pantalla de login
  2. Usuario ingresa email y contraseña
  3. Sistema valida credenciales contra base de datos
  4. Sistema verifica que cuenta esté activa
  5. Sistema registra timestamp de inicio de sesión
  6. Sistema crea token de sesión
  7. Sistema redirige a dashboard principal
  8. Sistema muestra notificación "Bienvenido, [nombre]"

Flujos Alternos:
  FA-1: Credenciales Incorrectas
    3a. SI credenciales no coinciden ENTONCES
      3a.1. Sistema incrementa contador de intentos fallidos
      3a.2. Sistema muestra mensaje "Credenciales incorrectas"
      3a.3. SI intentos >= 5 ENTONCES
        3a.3.1. Sistema bloquea cuenta temporalmente (15 minutos)
        3a.3.2. Sistema envía email de alerta al usuario
      3a.4. Volver a paso 2
  
  FA-2: Cuenta Inactiva
    4a. SI cuenta.estado = "Inactiva" ENTONCES
      4a.1. Sistema muestra mensaje "Cuenta desactivada"
      4a.2. Sistema sugiere contactar administrador
      4a.3. Caso de uso termina

Postcondiciones:
  - Usuario autenticado con sesión activa
  - Timestamp de login registrado en bitácora
  - Token de sesión válido

Business Rules: BR_IACT_101, BR_IACT_102, BR_IACT_103

Functional Requirements Derivados:
  - RF_AUTH_01_01: "Sistema valida formato de email"
  - RF_AUTH_01_02: "Sistema compara hash de contraseña"
  - RF_AUTH_01_03: "Sistema verifica estado de cuenta"
  - RF_AUTH_01_04: "Sistema registra intento de login (exitoso o fallido)"
  - RF_AUTH_01_05: "Sistema bloquea cuenta después de 5 intentos"
  - RF_AUTH_01_06: "Sistema genera token JWT con expiración 8h"
```

#### 8. Ejemplo Adicional: UC_ACC_05 (Caso Complejo)

```
UC_ACC_05: Gestionar Segregación de Funciones (SoD)

Actor Primario: Administrador de Seguridad
Objetivo: Configurar restricciones de segregación de funciones para prevenir 
          conflictos de interés

Precondiciones:
  - Actor tiene rol SYSTEM_ADMIN
  - Al menos 2 roles funcionales existen en sistema

Flujo Normal:
  1. Administrador accede a módulo "Segregación de Funciones"
  2. Sistema muestra lista de roles funcionales existentes
  3. Administrador selecciona primer rol (rol_origen)
  4. Administrador selecciona segundo rol (rol_conflicto)
  5. Sistema valida que roles no sean idénticos
  6. Administrador especifica tipo de restricción:
     - INCOMPATIBLE: Mismo usuario no puede tener ambos roles
     - ADVERTENCIA: Sistema alerta pero permite asignación
  7. Administrador ingresa justificación de la regla SoD
  8. Sistema verifica que regla no exista previamente
  9. Sistema registra regla SoD en tabla configuración
  10. Sistema valida usuarios existentes contra nueva regla
  11. SI existen usuarios con conflicto ENTONCES
      11.1. Sistema genera reporte de usuarios afectados
      11.2. Sistema notifica a administrador de seguridad
  12. Sistema confirma creación de regla SoD

Flujos Alternos:
  FA-1: Roles Idénticos
    5a. SI rol_origen = rol_conflicto ENTONCES
      5a.1. Sistema muestra error "No puede crear SoD con mismo rol"
      5a.2. Volver a paso 3
  
  FA-2: Regla Duplicada
    8a. SI regla SoD ya existe ENTONCES
      8a.1. Sistema muestra mensaje "Regla ya configurada"
      8a.2. Sistema ofrece modificar regla existente
      8a.3. Volver a paso 6
  
  FA-3: Usuarios Afectados Críticos
    11a. SI usuarios afectados incluyen administradores ENTONCES
      11a.1. Sistema requiere confirmación explícita
      11a.2. Sistema registra override en auditoría
      11a.3. Continuar en paso 12

Postcondiciones:
  - Regla SoD registrada en configuración
  - Usuarios existentes validados
  - Conflictos reportados si existen
  - Acción registrada en log de auditoría

Business Rules:
  - BR_IACT_043: "Roles con funciones críticas deben estar segregados"
  - BR_IACT_044: "REPORTS_CREATOR + REPORTS_EXPORTER = incompatible"
  - BR_IACT_045: "USERS_FULL_MANAGER + AUDIT_VIEWER = incompatible"

Functional Requirements Derivados:
  - RF_ACC_05_01: "Sistema valida que roles existan"
  - RF_ACC_05_02: "Sistema verifica unicidad de regla SoD"
  - RF_ACC_05_03: "Sistema valida usuarios contra reglas SoD al asignar rol"
  - RF_ACC_05_04: "Sistema genera reporte de conflictos existentes"
  - RF_ACC_05_05: "Sistema registra creación de regla en auditoría"
```

---

## PLAN DE REESCRITURA DE base_cognitiva/

### Archivo 1: FND_01_Concepto_Requisito_1_0_0.rst

**Cambios:**
- Línea 316: UC-40 → Reemplazar con UC_AUTH_01 (ejemplo simple, claro)
- Línea 490: UC-015 → Reemplazar con UC_RPT_01 (Consultar Reporte)

**Ejemplo pedagógico a mantener:**
- Concepto de requisito (teoría)
- Usar UC_AUTH_01 como ejemplo concreto del proyecto

### Archivo 2: FND_03_Casos_de_Uso_1_0_0.rst

**Cambios:**
- Línea 100: UC-043 → UC_ACC_05 (Gestionar SoD)
- Líneas 265-274: Tabla agrupadores → REESCRIBIR con módulos v4.0
  
  **ANTES (v2.0 - INCORRECTO):**
  ```
  UC-005 a UC-011 (Gestión)
  UC-012 a UC-016 (Operaciones)
  ```
  
  **DESPUÉS (v4.0 - CORRECTO):**
  ```
  Módulo AUTH: UC_AUTH_01 a UC_AUTH_05 (Autenticación)
  Módulo USR:  UC_USR_01 a UC_USR_04 (Usuarios)
  Módulo ACC:  UC_ACC_01 a UC_ACC_09 (Control Acceso)
  Módulo RPT:  UC_RPT_01 a UC_RPT_14 (Reportes)
  Módulo ALR:  UC_ALR_01 a UC_ALR_05 (Alertas)
  Módulo PIP:  UC_PIP_01 a UC_PIP_04 (Pipelines ETL)
  Módulo AUD:  UC_AUD_01 a UC_AUD_04 (Auditoría)
  Módulo LOG:  UC_LOG_01 a UC_LOG_04 (Logs)
  ```

- Línea 277: UC-050 → UC_PIP_01 (Supervisar ETL)
- Líneas 614-616: UC-001/002/003 → UC_AUTH_01/02/03

### Archivo 3: MTM_01_Metamodelo_Requisitos_1_0_0.rst

**Cambios:**
- UC_010 → UC_ACC_01 (Asignar Funciones)
- UC_ETL → UC_PIP_01 (Supervisar ETL)
- BR_015 → BR_IACT_028 o BR_IACT_043 (si existe)
- Diagramas de trazabilidad con ejemplos IACT:
  ```
  BR_IACT_031 --genera--> UC_PIP_05 --deriva--> RF_PIP_05_01
  ```

### Archivo 4: MTM_02_Metamodelo_Trazabilidad_1_0_0.rst

**Cambios:**
- Todas las 9 referencias UC_010 → UC_ACC_01
- Tablas RTM con ejemplos del proyecto:
  
  **Tabla de Trazabilidad Real:**
  ```
  | BR ID        | UC ID       | RF ID           | Código              | Test           |
  |--------------|-------------|-----------------|---------------------|----------------|
  | BR_IACT_031  | UC_PIP_05   | RF_PIP_05_01    | PipelineMonitor.py  | test_notify_01 |
  | BR_IACT_031  | UC_PIP_05   | RF_PIP_05_02    | PipelineMonitor.py  | test_notify_02 |
  | BR_IACT_087  | UC_RPT_03   | RF_RPT_03_02    | ReportAuth.js       | test_auth_03   |
  ```

### Archivo 5: MTM_03_Metamodelo_RBAC_1_0_0.rst

**Cambios:**
- Rangos "UC-005 a UC-011" → Separar por módulo:
  ```
  MOD_AUTH: UC_AUTH_01 a UC_AUTH_05
  MOD_USR:  UC_USR_01 a UC_USR_04
  MOD_ACC:  UC_ACC_01 a UC_ACC_09
  ```

### Archivo 6: TXM_01_Taxonomia_Requisitos_1_0_0.rst

**CRÍTICO - REESCRITURA COMPLETA**

**Sección actual (INCORRECTO):**
```
Rangos por Dominio:
  UC-005 a UC-011: Gestión de Acceso
  UC-012 a UC-024: Operaciones
  ...
```

**Sección correcta (v4.0.0):**
```
Taxonomía por Módulo del Proyecto IACT:

1. Módulo AUTH (Autenticación):
   - Rango: UC_AUTH_01 a UC_AUTH_05
   - Nomenclatura FR: FR_AUTH_[NN]_[MM]
   - Ejemplos:
     * UC_AUTH_01: Iniciar Sesión
     * UC_AUTH_02: Cerrar Sesión
     * UC_AUTH_03: Recuperar Contraseña

2. Módulo USR (Gestión de Usuarios):
   - Rango: UC_USR_01 a UC_USR_04
   - Nomenclatura FR: FR_USR_[NN]_[MM]
   - Ejemplos:
     * UC_USR_01: Crear Usuario
     * UC_USR_02: Consultar Usuarios

3. Módulo ACC (Control de Acceso):
   - Rango: UC_ACC_01 a UC_ACC_09
   - Nomenclatura FR: FR_ACC_[NN]_[MM]
   - Ejemplos:
     * UC_ACC_01: Asignar Funciones
     * UC_ACC_05: Gestionar SoD

4. Módulo RPT (Reportes):
   - Rango: UC_RPT_01 a UC_RPT_14
   - Nomenclatura FR: FR_RPT_[NN]_[MM]
   - Ejemplos:
     * UC_RPT_01: Consultar Reporte
     * UC_RPT_08: Exportar Datos

5. Módulo ALR (Alertas):
   - Rango: UC_ALR_01 a UC_ALR_05
   - Nomenclatura FR: FR_ALR_[NN]_[MM]

6. Módulo PIP (Pipelines ETL):
   - Rango: UC_PIP_01 a UC_PIP_04
   - Nomenclatura FR: FR_PIP_[NN]_[MM]
   - Ejemplos:
     * UC_PIP_01: Supervisar ETL
     * UC_PIP_05: Notificar Falla Crítica

7. Módulo AUD (Auditoría):
   - Rango: UC_AUD_01 a UC_AUD_04
   - Nomenclatura FR: FR_AUD_[NN]_[MM]

8. Módulo LOG (Logs):
   - Rango: UC_LOG_01 a UC_LOG_04
   - Nomenclatura FR: FR_LOG_[NN]_[MM]
```

### Archivo 7: TXM_03_Taxonomia_Reglas_Negocio_1_0_0.rst

**Cambios:**
- Ejemplos de BR con dominio IVR:
  * BR_IACT_028: Restricción de recursos
  * BR_IACT_031: Desencadenador de notificación
  * BR_IACT_046: Inferencia de estado crítico
  * BR_IACT_087: Restricción de acceso a datos sensibles

---

## NOMENCLATURA CORRECTA

**CRÍTICO:** Todos los archivos deben seguir:
```
[PREFIJO]_[NN]_[Nombre_Con_Guion_Bajo]_1_0_0.rst
```

**Ejemplos:**
```
FND_01_Concepto_Requisito_1_0_0.rst
FND_03_Casos_de_Uso_1_0_0.rst
MTM_01_Metamodelo_Requisitos_1_0_0.rst
MTM_02_Metamodelo_Trazabilidad_1_0_0.rst
MTM_03_Metamodelo_RBAC_1_0_0.rst
TXM_01_Taxonomia_Requisitos_1_0_0.rst
TXM_03_Taxonomia_Reglas_Negocio_1_0_0.rst
META_01_Identidad_Proyecto_1_0_0.rst
SBVR_01_Conceptos_Nucleares_1_0_0.rst
```

**NO usar:**
- FND-01 (guion medio)
- FND_01.rst (sin versión)
- FND_01_Concepto_Requisito.rst (sin versión)

---

## RESUMEN DE CAMBIOS TOTALES

| Archivo | Cambios | Esfuerzo | Prioridad |
|---------|---------|----------|-----------|
| FND_01_..._1_0_0.rst | Renombrar + 2 ejemplos | 1-2h | Media |
| FND_03_..._1_0_0.rst | Renombrar + tabla agrupadores + 5 ejemplos | 3-4h | Alta |
| MTM_01_..._1_0_0.rst | Renombrar + 6 referencias + diagramas | 2-3h | Alta |
| MTM_02_..._1_0_0.rst | Renombrar + 9 referencias + tablas RTM | 2-3h | Alta |
| MTM_03_..._1_0_0.rst | Renombrar + rangos | 1h | Media |
| TXM_01_..._1_0_0.rst | Renombrar + REESCRITURA COMPLETA | 4-5h | CRÍTICA |
| TXM_03_..._1_0_0.rst | Renombrar + ejemplos BR | 1-2h | Media |
| **TOTAL** | **Renombrar 23 archivos + reescribir contenido** | **14-20h** | **-** |

---

## DEPENDENCIAS PARA CONTINUAR

Para ejecutar la reescritura, NECESITO:

1. **Listado COMPLETO de 49 UC reales** con nombres completos:
   ```
   UC_AUTH_01: Iniciar Sesión
   UC_AUTH_02: Cerrar Sesión
   ...
   UC_LOG_04: [nombre]
   ```

2. **Archivos UC individuales** (al menos 5-10 representativos):
   - UC_AUTH_01.rst (caso simple)
   - UC_ACC_05.rst (caso complejo con SoD)
   - UC_RPT_01.rst (caso reportes)
   - UC_PIP_01.rst (caso pipelines)
   - UC_ALR_01.rst (caso alertas)

3. **BR reales del proyecto** (si existen documentadas):
   - ¿Existen BR formales en el proyecto IACT?
   - ¿O debo inferirlas de los UC?

4. **Confirmación de dominio:**
   - IACT = Sistema de análisis de llamadas IVR
   - ¿Correcto?
   - ¿Qué otros conceptos clave del dominio debo conocer?

---

**PRÓXIMO PASO:**
Una vez tengas esta información, puedo:
1. Generar los 7 archivos reescritos completos
2. Con nomenclatura correcta (_1_0_0.rst)
3. Con ejemplos 100% del proyecto IACT
4. Con trazabilidad real BR → UC → FR

**ESPERANDO TU CONFIRMACIÓN Y DATOS.**

