# ANÁLISIS CORREGIDO: PARTE 2 vs PROYECTO IACT REAL

**Documento:** Análisis de Desconexión Pedagógica (CORREGIDO)  
**Fecha:** 2026-01-08  
**Alcance:** PARTE 2 "Transformar BR en UC" vs Documentación Real del Proyecto  
**Corrección de:** Análisis previo que ignoró la documentación existente

---

## ❌ ERROR EN ANÁLISIS ANTERIOR

### Problema Identificado

El análisis anterior trataba PARTE 2 como si el proyecto IACT **NO TUVIERA DOCUMENTACIÓN DEFINIDA**, cuando en realidad YA EXISTE:

| Componente | Estado Real | Lo que Asumí (ERROR) |
|------------|-------------|---------------------|
| Casos de Uso | ✅ **49 UC definidos** (v4.0.0) | ❌ "No hay UC reales" |
| Business Rules | ✅ **20 BR definidas** (BR_001-BR_020) | ❌ "No hay BR reales" |
| Modelo RBAC | ✅ **v5.1.1** (44 funciones, 10 agrupadores) | ❌ "RBAC v4.0 obsoleto" |
| Restricciones | ✅ **10 CNST** actualizados a v1.1.0 | ❌ No considerados |
| Módulos | ✅ **8 módulos** funcionales definidos | ❌ No mencionados |
| Nomenclatura | ✅ **UC_[MOD]_[NN]** estándar v4.0.0 | ❌ "Usar UC-07 genérico" |

**Conclusión:** Mi análisis fue hecho **SIN REVISAR** la documentación real del proyecto.

---

## ✅ DOCUMENTACIÓN REAL DEL PROYECTO IACT

### 1. Los 49 Casos de Uso Reales (v4.0.0)

#### Distribución por Módulo

| Módulo | Código | Cantidad | UC Ejemplos |
|--------|--------|----------|-------------|
| **MOD_Auth** | AUTH | 5 | UC_AUTH_01 a UC_AUTH_05 |
| **MOD_Users** | USR | 4 | UC_USR_01 a UC_USR_04 |
| **MOD_Access** | ACC | 9 | UC_ACC_01 a UC_ACC_09 |
| **MOD_Pipeline** | PIP | 4 | UC_PIP_01 a UC_PIP_04 |
| **MOD_Reports** | RPT | 14 | UC_RPT_01 a UC_RPT_14 |
| **MOD_Alerts** | ALR | 5 | UC_ALR_01 a UC_ALR_05 |
| **MOD_Audit** | AUD | 4 | UC_AUD_01 a UC_AUD_04 |
| **MOD_Logs** | LOG | 4 | UC_LOG_01 a UC_LOG_04 |
| **TOTAL** | - | **49** | - |

#### Ejemplos Concretos de UC Reales

**UC_AUTH_01: Iniciar Sesión**
```
Actor: Usuario (público)
Función RBAC: (público)
CNST: CNST-002 (Sesión única, 15 min timeout)
```

**UC_ALR_01: Configurar Alerta**
```
Actor: AGR-005 (agr_gestor_alertas)
Función RBAC: ALR-002 (configura_alertas)
CNST: CNST-001 (NO email), CNST-004 (Alertas buzón interno), CNST-009 (Auditoría)
```

**UC_RPT_01: Consultar Reporte Trimestral**
```
Actor: AGR-002, AGR-003 (operador_reportes, supervisor)
Función RBAC: RPT-001 (ve_reportes)
CNST: CNST-003 (BD IVR readonly), CNST-006 (Rango máx 2 años)
```

**UC_PIP_01: Supervisar ETL**
```
Actor: AGR-009 (agr_admin_pipeline)
Función RBAC: PIP-001 (ve_estado_etl)
CNST: CNST-003 (BD IVR readonly), CNST-009 (Auditoría)
```

**UC_RPT_06: Exportar CSV**
```
Actor: AGR-003, AGR-004 (supervisor, exportador)
Función RBAC: RPT-004 (exporta_csv)
CNST: CNST-001 (NO email), CNST-007 (Límites: 100K registros), CNST-009 (Auditoría)
```

---

### 2. Las 20 Business Rules Reales (BR_001-BR_020)

#### Distribución por Tipo

| Tipo | Cantidad | BR |
|------|----------|-----|
| **Restricción** | 10 | BR_001, 004, 005, 007, 008, 009, 010, 011, 019, 020 |
| **Desencadenador** | 3 | BR_002, 014, 015 |
| **Hecho** | 3 | BR_006, 012, 013 |
| **Inferencia** | 1 | BR_003 |
| **Cálculo** | 3 | BR_016, 017, 018 |

#### Ejemplos Concretos de BR Reales

**BR_002: ETL Batch Nocturno (Desencadenador)**
```yaml
Tipo: Desencadenador
CNST: CNST_004
Descripción: "SI el sistema alcanza las 02:00 AM ENTONCES ejecutar ETL batch"
Genera: UC_PIP_01 (Supervisar ETL)
```

**BR_014: Alerta por Umbral (Desencadenador)**
```yaml
Tipo: Desencadenador
CNST: No relacionado directamente
Descripción: "SI métrica excede umbral configurado ENTONCES generar alerta"
Genera: UC_ALR_01 (Configurar Alerta)
```

**BR_016: Tasa Abandono (Cálculo)**
```yaml
Tipo: Cálculo
CNST: No relacionado
Fórmula: (COUNT abandonadas / COUNT total) × 100
Usado en: UC_RPT_01, UC_RPT_09, UC_RPT_10
```

**BR_017: Tiempo Promedio Espera (Cálculo)**
```yaml
Tipo: Cálculo
CNST: No relacionado
Fórmula: AVG(tiempo_espera_segundos)
Usado en: UC_RPT_01, UC_RPT_09, UC_RPT_10
```

**BR_011: Límites Exportación (Restricción)**
```yaml
Tipo: Restricción
CNST: CNST_007
Límites:
  - CSV: 100,000 registros
  - Excel: 50,000 registros
  - PDF: 10,000 registros
Afecta: UC_RPT_06, UC_RPT_07, UC_RPT_08
```

---

### 3. Modelo RBAC v5.1.1 (44 Funciones, 10 Agrupadores)

#### 44 Funciones Atómicas

| Módulo | Funciones | Ejemplos |
|--------|-----------|----------|
| MOD_Auth | 4 | gestiona_sesiones, cierra_sesion_usuario, resetea_password |
| MOD_Users | 10 | crea_usuarios, modifica_usuarios, elimina_usuarios, ve_usuarios |
| MOD_Access | 6 | asigna_funciones, revoca_funciones, ve_asignaciones, gestiona_sod |
| MOD_Pipeline | 4 | ve_estado_etl, ve_errores_etl, ve_disponibilidad_datos, solicita_reintento_etl |
| MOD_Reports | 8 | ve_reportes, ve_dashboard, exporta_csv, exporta_excel, exporta_pdf |
| MOD_Alerts | 6 | ve_alertas, configura_alertas, configura_alertas_equipo, pausa_alertas |
| MOD_Audit | 4 | ve_auditoria, busca_auditoria, exporta_auditoria, genera_reporte_compliance |
| MOD_Logs | 2 | ve_logs_tecnicos, exporta_logs |

#### 10 Agrupadores

| ID | Agrupador | Funciones | Descripción |
|----|-----------|-----------|-------------|
| AGR-001 | agr_operador_basico | 5 | Consulta básica de reportes |
| AGR-002 | agr_operador_reportes | 8 | Acceso completo a reportes |
| AGR-003 | agr_supervisor | 12 | Supervisor con alertas de equipo |
| AGR-004 | agr_exportador | 3 | Exportación de reportes |
| AGR-005 | agr_gestor_alertas | 6 | Gestión de alertas |
| AGR-006 | agr_admin_usuarios | 12 | Administración de usuarios |
| AGR-007 | agr_admin_acceso | 6 | Administración de acceso |
| AGR-008 | agr_auditor | 4 | Auditoría y compliance |
| AGR-009 | agr_admin_pipeline | 4 | Supervisión de ETL |
| AGR-010 | agr_admin_logs | 2 | Bitácoras técnicas |

---

### 4. Las 10 Restricciones CNST (v1.1.0)

| CNST | Nombre | Impacto en UC |
|------|--------|---------------|
| CNST-001 | Comunicaciones Prohibidas | NO email, solo InternalMessage |
| CNST-002 | Gestión de Sesiones | Sesión única, 15 min timeout |
| CNST-003 | Base de Datos Dual | IVR readonly, PostgreSQL analítico |
| CNST-004 | Actualización ETL | ETL cada 6-12 horas, NO real-time |
| CNST-005 | Seguridad DRF | Flat RBAC, SoD, permisos temporales |
| CNST-006 | Antipatrones Prohibidos | Rango máx 2 años en reportes |
| CNST-007 | Performance | Límites exportación, throttling |
| CNST-008 | Infraestructura | Audit inmutable, logs sin PII |
| CNST-009 | Logging y Auditoría | UserActionLog para cambios críticos |
| CNST-010 | Clasificación de Datos | 4 niveles (PUBLIC, INTERNAL, RESTRICTED, CONFIDENTIAL) |

---

## 🔍 MAPEO CORRECTO: QUÍMICOS → IACT REAL

### Tabla Maestra de Equivalencias

| Concepto PARTE 2 (Químicos) | UC/BR Real IACT | Razón del Mapeo |
|-----------------------------|-----------------|-----------------|
| **EJEMPLOS CENTRALES** |
| UC-07 "Notificar Vencimiento" | **UC_ALR_01** "Configurar Alerta" | Ambos son procesos automáticos que generan notificaciones por umbral |
| BR-031 "Notificar 30d antes" | **BR_014** "Alerta por Umbral" | Ambos son Desencadenadores (Tipo 3) |
| UC-04 "Solicitar Químico" | **UC_RPT_01** "Consultar Reporte Trimestral" | Ambos son acciones principales del usuario con múltiples pasos |
| **OTROS EJEMPLOS FRECUENTES** |
| BR-028 "Aprobación >$500" | **BR_011** "Límites Exportación" | Ambas son Restricciones con umbral numérico |
| BR-087 "Certificación OSHA" | **BR_007** "Separación Funciones (SoD)" | Ambas son Restricciones de autorización |
| BR-060 "Descuento volumen" | **BR_016** "Tasa Abandono" | Ambos son Cálculos con fórmula |
| BR-046 "Marcar caduco" | **BR_003** "Usuario Inactivo 90d" | Ambas son Inferencias que cambian estado |
| **ACTORES** |
| Propietario | **AGR-002** (agr_operador_reportes) | Usuario normal que consulta |
| Coordinador Seguridad | **AGR-005** (agr_gestor_alertas) | Supervisor que gestiona alertas |
| Gerente | **AGR-003** (agr_supervisor) | Supervisor con permisos elevados |
| Administrador | **AGR-006** (agr_admin_usuarios) | Administrador de usuarios |
| Sistema (tiempo) | **Sistema** con BR_002 o BR_014 | Procesos batch automáticos |

---

## 📋 ANÁLISIS DETALLADO: EJEMPLOS DE PARTE 2

### Ejemplo Central: UC-07 → UC_ALR_01

#### PARTE 2 (INCORRECTO - Químicos)

```
UC-07: Notificar Vencimiento de Químico

Actor: Sistema (tiempo)
Trigger: Diario a las 00:00 horas
BR Origen: BR-031 "Notificar 30 días antes de vencimiento"

Flujo Normal (11 pasos):
  1. Sistema verifica fecha actual
  2. Sistema consulta tabla Contenedores
  3. Sistema filtra: DATEDIFF(fecha_vencimiento, CURDATE()) <= 30
  4. Para cada contenedor venciendo:
     4.1 Obtener propietario
     4.2 Obtener email propietario
     4.3 Obtener coordinador seguridad
     4.4 Obtener email coordinador
     4.5 Obtener datos contenedor
     4.6 Obtener datos producto químico
     4.7 Generar contenido email
     4.8 ENVIAR EMAIL a propietario ❌
     4.9 ENVIAR EMAIL a coordinador ❌
     4.10 Registrar notificación
  5. Contar notificaciones enviadas
  6. Registrar en log
  7. Finalizar

Flujos Alternos (5):
  FA-1: Sin contenedores próximos a vencer
  FA-2: Contenedor sin propietario
  FA-3: Email inválido
  FA-4: Error conexión SMTP ❌
  FA-5: Timeout proceso

FR Derivados (9):
  RF-301: Obtener Fecha Actual
  RF-302: Consultar Contenedores Activos
  RF-303: Filtrar por Vencimiento (30 días)
  RF-304: Obtener Propietario
  RF-305: Validar Email ❌
  RF-306: Obtener Coordinador Seguridad
  RF-307: Generar Contenido Email ❌
  RF-308: Enviar Email vía SMTP ❌
  RF-309: Registrar Timestamp Notificación

PROBLEMAS:
  ❌ Usa EMAIL (violación CNST-001)
  ❌ Dominio químicos (no IVR)
  ❌ Nomenclatura v2.0 (UC-07, BR-031)
  ❌ Actores genéricos (Propietario, Coordinador)
  ❌ No referencia RBAC v5.1.1
  ❌ No referencia CNST aplicables
```

#### CORRECCIÓN: UC_ALR_01 (PROYECTO IACT REAL)

```
UC_ALR_01: Configurar Alerta por Umbral

Identificador: UC_ALR_01
Actor Principal: AGR-005 (agr_gestor_alertas)
Función RBAC: ALR-002 (configura_alertas)
Trigger: Usuario selecciona "Nueva Alerta" en módulo Alertas
BR Origen: BR_014 "Alerta por Umbral" (Desencadenador)

Contexto:
  - Usuario autenticado con función ALR-002
  - Métricas configuradas en el sistema (BR_016, BR_017, BR_018)
  - Sistema de notificaciones interno activo (CNST-001)

Flujo Normal (10 pasos):
  1. Usuario accede a módulo Alertas
  2. Usuario selecciona "Crear Nueva Alerta"
  3. Sistema muestra formulario de configuración
  4. Usuario completa configuración:
     4.1 Nombre descriptivo de la alerta
     4.2 Selecciona métrica a monitorear:
         - Tasa de Abandono (BR_016)
         - Tiempo Promedio de Espera (BR_017)
         - Índice de Eficiencia (BR_018)
     4.3 Define tipo de umbral (absoluto/porcentual)
     4.4 Ingresa valor umbral (ej: >15% para tasa abandono)
     4.5 Selecciona severidad (INFO, WARNING, CRITICAL)
     4.6 Define destinatarios (solo buzón interno, CNST-001)
  5. Sistema valida configuración:
     5.1 Verifica que métrica existe
     5.2 Valida formato de umbral
     5.3 Verifica límite máx 50 destinatarios (CNST-004)
  6. Sistema crea registro en tabla alerts:
     - user_id (creador)
     - metric_id
     - threshold_type, threshold_value
     - severity
     - is_active = TRUE
  7. Sistema registra en UserActionLog (CNST-009):
     - action = 'ALERT_CREATE'
     - resource = 'alert:{alert_id}'
     - result = 'SUCCESS'
  8. Sistema muestra confirmación:
     "Alerta '{nombre}' creada correctamente.
      Se enviarán notificaciones a buzón interno cuando
      {métrica} {operador} {umbral}." ✅
  9. Sistema retorna a lista de alertas
  10. Finalizar

Flujos Alternos:
  FA-1: Métrica No Existe
    4.2a. Usuario selecciona métrica que no está configurada
    4.2b. Sistema muestra error:
          "Métrica no disponible. Contacte administrador."
    4.2c. Retornar a paso 4.2

  FA-2: Umbral Inválido
    4.4a. Usuario ingresa valor fuera de rango permitido
    4.4b. Sistema valida:
          - Tasa abandono: 0-100%
          - Tiempo espera: 0-300 segundos
          - Eficiencia: 0-100%
    4.4c. Sistema muestra error con rango válido
    4.4d. Retornar a paso 4.4

  FA-3: Excede Límite de Destinatarios
    4.6a. Usuario intenta agregar >50 destinatarios
    4.6b. Sistema rechaza (CNST-004)
    4.6c. Sistema muestra error:
          "Máximo 50 destinatarios permitidos por alerta (CNST-004)"
    4.6d. Retornar a paso 4.6

  FA-4: Violación SoD
    5.3a. Sistema detecta que asignación violaría SoD
          (ejemplo: admin_pipeline no puede tener alertas críticas)
    5.3b. Sistema rechaza configuración
    5.3c. Sistema muestra advertencia SoD
    5.3d. Retornar a paso 4

  FA-5: Error al Guardar
    6a. Base de datos no responde o falla constraint
    6b. Sistema hace ROLLBACK de transacción
    6c. Sistema registra error en log
    6d. Sistema muestra error genérico al usuario
    6e. UC termina sin crear alerta

Postcondiciones (éxito):
  - Alerta creada y activa en tabla alerts
  - Sistema monitoreará métrica según configuración (BR_014)
  - Notificaciones se enviarán a buzón interno (CNST-001)
  - Registro inmutable en UserActionLog (CNST-009)
  - Usuario puede ver alerta en UC_ALR_02

Business Rules Aplicadas:
  - BR_014: Alerta por Umbral (Desencadenador) → UC generado
  - BR_016: Tasa Abandono (Cálculo) → Una de las métricas monitoreables
  - BR_017: Tiempo Promedio Espera (Cálculo) → Métrica opcional
  - BR_018: Índice Eficiencia (Cálculo) → Métrica opcional
  - BR_004: Comunicaciones Internas (implícito en CNST-001)

Restricciones de Arquitectura:
  - CNST-001: Notificaciones SOLO buzón interno (NO email bajo ninguna circunstancia)
  - CNST-004: Máximo 50 destinatarios por alerta
  - CNST-004: NO real-time extremo (consolidación de alertas)
  - CNST-009: UserActionLog inmutable para acción crítica
  - CNST-005: Validación de permisos mediante SEC_RULES

Requerimientos Especiales:
  - RNF-XX: Validación de permisos en <100ms
  - RNF-XX: Confirmación visual inmediata
  - RNF-XX: Interfaz responsive (móvil/web)

Frecuencia de Uso: Media (50-100 configuraciones/mes)
Prioridad: Alta (funcionalidad core de alertas)

FR Derivados:
  - RF-ALRXXX: Listar Métricas Disponibles
    Query: SELECT * FROM metrics WHERE is_monitorable = TRUE
  
  - RF-ALRYYY: Validar Umbral por Tipo de Métrica
    Lógica:
      IF metric_type = 'percentage' THEN
        ASSERT 0 <= threshold <= 100
      ELSE IF metric_type = 'duration' THEN
        ASSERT threshold >= 0
      END IF
  
  - RF-ALRZZZ: Crear Registro en Tabla Alerts
    Insert:
      INSERT INTO alerts (user_id, metric_id, threshold_type,
                          threshold_value, severity, is_active)
      VALUES (?, ?, ?, ?, ?, TRUE)
  
  - RF-ALRWWW: Registrar en UserActionLog
    Implementa: CNST-009
    Insert:
      INSERT INTO user_action_log (user_id, action, resource,
                                    result, timestamp, details_json)
      VALUES (?, 'ALERT_CREATE', ?, 'SUCCESS', NOW(), ?)

Trazabilidad:
  - BReq Origen: (si existe)
  - Reglas de Negocio: BR_014, BR_016, BR_017, BR_018
  - Restricciones: CNST-001, CNST-004, CNST-009
  - FR Derivados: RF-ALRXXX, RF-ALRYYY, RF-ALRZZZ, RF-ALRWWW
  - UC Relacionados:
    - UC_ALR_02: Consultar Alertas (ve alertas creadas)
    - UC_ALR_03: Pausar Alerta (modifica estado)
    - UC_ALR_04: Eliminar Alerta (baja lógica)
    - UC_RPT_09: Ver Dashboard (visualiza métricas monitoreadas)
  - Actor Principal: AGR-005 (agr_gestor_alertas)
  - Función RBAC: ALR-002 (configura_alertas)

Diagrama PlantUML:
  (Se incluiría diagrama de secuencia detallado con notas CNST)

VENTAJAS SOBRE UC-07 QUÍMICOS:
  ✅ Dominio correcto (IVR/Alertas)
  ✅ CNST-001 respetado (NO email)
  ✅ Nomenclatura v4.0.0 (UC_ALR_01)
  ✅ Actor real (AGR-005)
  ✅ Función RBAC (ALR-002)
  ✅ BR reales (BR_014, BR_016-018)
  ✅ CNST aplicables listados
  ✅ FR derivados del dominio real
  ✅ Trazabilidad completa
```

---

### Ejemplo Secundario: UC-04 → UC_RPT_01

#### PARTE 2 (INCORRECTO - Químicos)

```
UC-04: Solicitar Producto Químico

Actor: Solicitante
Trigger: Usuario selecciona "Nueva Solicitud"
BR Integradas: BR-012, BR-028, BR-060, BR-087, BR-046

Flujo Normal (12 pasos):
  1. Usuario selecciona "Nueva Solicitud"
  2. Sistema muestra catálogo de productos químicos ❌
  3. Usuario selecciona producto
  4. Usuario especifica cantidad
  5. Sistema obtiene precio
  6. Sistema calcula subtotal
  7. Sistema calcula descuento (BR-060: tabla decisión) ❌
  8. Sistema muestra desglose (precio, descuento, total)
  9. Usuario confirma
  10. Sistema verifica monto >$500 (BR-028) ❌
  11. SI monto <= $500: Aprobar automáticamente
      SI monto > $500: Enviar a gerente para aprobación ❌
  12. Finalizar

PROBLEMAS:
  ❌ Dominio químicos (no IVR)
  ❌ BR incorrectas (BR-028, BR-060, BR-087)
  ❌ Actor genérico (Solicitante)
  ❌ Flujo de aprobación no existe en IACT
  ❌ No aplica CNST
```

#### CORRECCIÓN: UC_RPT_01 (PROYECTO IACT REAL)

```
UC_RPT_01: Consultar Reporte Trimestral de Llamadas

Identificador: UC_RPT_01
Actor Principal: AGR-002, AGR-003 (operador_reportes, supervisor)
Función RBAC: RPT-001 (ve_reportes)
Trigger: Usuario accede a módulo Reportes y selecciona "Trimestral"
BR Aplicadas: BR_016, BR_017, BR_018 (Cálculos)

Contexto:
  - Usuario autenticado con función RPT-001
  - ETL ha ejecutado al menos una vez (BR_002)
  - Datos disponibles en PostgreSQL analítico (CNST-003)
  - Usuario pertenece a 1 segmento (BR_012: Usuario-Segmento Único)

Flujo Normal (8 pasos):
  1. Usuario accede a módulo Reportes
  2. Usuario selecciona "Reporte Trimestral"
  3. Sistema muestra formulario de filtros:
     3.1 Trimestre (Q1, Q2, Q3, Q4)
     3.2 Año (últimos 2 años, CNST-006)
     3.3 Centro (opcional, según segmento usuario)
  4. Usuario completa filtros y presiona "Generar"
  5. Sistema valida filtros:
     5.1 Verificar rango <= 2 años (CNST-006, BR_019)
     5.2 Verificar trimestre válido
     5.3 Aplicar segmento del usuario automáticamente (BR_012)
  6. Sistema consulta PostgreSQL analítico (CNST-003):
     6.1 Ejecutar query con filtros aplicados:
         SELECT 
           DATE_FORMAT(fecha_llamada, '%Y-%m') as mes,
           COUNT(*) as total_llamadas,
           COUNT(*) FILTER (WHERE resultado='COMPLETADA') as atendidas,
           COUNT(*) FILTER (WHERE resultado='ABANDONADA') as abandonadas,
           (COUNT(*) FILTER (WHERE resultado='ABANDONADA') * 100.0 / 
            COUNT(*)) as tasa_abandono_pct,  -- BR_016
           AVG(tiempo_espera_segundos) as tiempo_promedio_espera,  -- BR_017
           (COUNT(*) FILTER (WHERE resultado='COMPLETADA') * 100.0 / 
            COUNT(*)) as indice_eficiencia_pct  -- BR_018
         FROM llamadas_historico
         WHERE fecha_llamada >= :inicio_trimestre
           AND fecha_llamada < :fin_trimestre
           AND segmento_id = :usuario_segmento  -- Filtro automático
         GROUP BY mes
         ORDER BY mes
     6.2 Calcular métricas derivadas (BR_016, BR_017, BR_018)
  7. Sistema renderiza reporte tabular:
     - Columnas: Mes, Total Llamadas, Atendidas, Abandonadas,
                 Tasa Abandono (%), Tiempo Espera Promedio (s),
                 Índice Eficiencia (%)
     - Totales por trimestre
     - Indicadores visuales (verde/amarillo/rojo según umbrales)
  8. Sistema muestra reporte al usuario

Flujos Alternos:
  FA-1: Sin Datos para Trimestre Seleccionado
    6a. Query retorna 0 registros
    6b. Sistema muestra mensaje:
        "No hay datos disponibles para el trimestre seleccionado.
         Verifique que ETL haya procesado el período."
    6c. Sistema muestra reporte vacío
    6d. UC termina (sin error)

  FA-2: Rango Excede 2 Años
    5.1a. Usuario intenta consultar datos >2 años atrás
    5.1b. Sistema rechaza (CNST-006, BR_019)
    5.1c. Sistema muestra error:
          "Rango máximo permitido: 2 años (CNST-006, BR_019)"
    5.1d. Retornar a paso 3

  FA-3: Error Consulta Base de Datos
    6a. PostgreSQL no responde o query falla (timeout)
    6b. Sistema registra error en log
    6c. Sistema muestra error al usuario:
        "Error al consultar datos. Intente nuevamente."
    6d. UC termina con error

  FA-4: Usuario sin Datos en Segmento
    6a. Query retorna 0 registros porque usuario no tiene datos
        en su segmento para el período
    6b. Sistema muestra mensaje específico:
        "Su segmento no tiene datos para el período seleccionado."
    6c. UC termina (sin error)

Postcondiciones (éxito):
  - Reporte visualizado con métricas del trimestre
  - Cálculos correctos (BR_016, BR_017, BR_018)
  - Segmento de usuario aplicado automáticamente (BR_012)
  - Registro en log de consulta (CNST-009 implícito)
  - Usuario puede exportar el reporte (UC_RPT_06, UC_RPT_07)

Business Rules Aplicadas:
  - BR_016: Tasa Abandono (Cálculo) → Columna en reporte
  - BR_017: Tiempo Promedio Espera (Cálculo) → Columna en reporte
  - BR_018: Índice Eficiencia (Cálculo) → Columna en reporte
  - BR_012: Usuario-Segmento Único (Hecho) → Filtro automático
  - BR_019: Retención 2 Años (Restricción) → Validación de rango

Restricciones de Arquitectura:
  - CNST-003: Datos de PostgreSQL analítico (NO MySQL IVR directo)
  - CNST-003: Datos desfasados según último ETL (NO real-time)
  - CNST-006: Rango máximo 2 años hacia atrás
  - CNST-009: Log de consulta (implícito para queries sensibles)
  - CNST-005: Segmento aplicado por SEC_RULES automáticamente

FR Derivados:
  - RF-RPTXXX: Validar Rango Temporal <= 2 Años
  - RF-RPTYYY: Consultar Llamadas por Trimestre
  - RF-RPTZZZ: Calcular Tasa de Abandono (BR_016)
  - RF-RPTWWW: Calcular Tiempo Promedio Espera (BR_017)
  - RF-RPTVVV: Calcular Índice de Eficiencia (BR_018)
  - RF-RPTUUU: Aplicar Filtro de Segmento Automático (BR_012)
  - RF-RPTRRR: Renderizar Reporte Tabular con Indicadores

Trazabilidad:
  - Reglas de Negocio: BR_016, BR_017, BR_018, BR_012, BR_019
  - Restricciones: CNST-003, CNST-006, CNST-009
  - FR Derivados: RF-RPTXXX a RF-RPTRRR
  - UC Relacionados:
    - UC_RPT_04: Filtrar Por Fecha (refinamiento)
    - UC_RPT_06: Exportar CSV (descarga)
    - UC_RPT_09: Ver Dashboard (visualización gráfica)
  - Actor Principal: AGR-002, AGR-003
  - Función RBAC: RPT-001 (ve_reportes)

VENTAJAS SOBRE UC-04 QUÍMICOS:
  ✅ Dominio correcto (IVR/Reportes)
  ✅ BR reales del proyecto (BR_016-018)
  ✅ Actor real (AGR-002, AGR-003)
  ✅ Función RBAC (RPT-001)
  ✅ CNST aplicables (CNST-003, CNST-006)
  ✅ Segmento automático (BR_012)
  ✅ Cálculos del dominio IVR
  ✅ Trazabilidad con UC reales
```

---

## 📊 MAPEO COMPLETO: PARTE 2 vs IACT REAL

### Tabla de Sustitución de Ejemplos

| # | Elemento PARTE 2 | Tipo | Apariciones | UC/BR Real IACT | Justificación |
|---|------------------|------|-------------|-----------------|---------------|
| 1 | **UC-07** Notificar Vencimiento | UC | 30+ | **UC_ALR_01** Configurar Alerta | Proceso automático con BR Desencadenador |
| 2 | **BR-031** Notificar 30d | Desencadenador | 20+ | **BR_014** Alerta por Umbral | Mismo tipo (Desencadenador) |
| 3 | **UC-04** Solicitar Químico | UC | 25+ | **UC_RPT_01** Consultar Reporte | Acción principal del usuario |
| 4 | **BR-028** Aprobación >$500 | Restricción | 15+ | **BR_011** Límites Exportación | Umbral numérico |
| 5 | **BR-087** Certificación OSHA | Restricción | 12+ | **BR_007** SoD | Restricción de autorización |
| 6 | **BR-060** Descuento volumen | Cálculo | 8+ | **BR_016** Tasa Abandono | Fórmula matemática |
| 7 | **BR-046** Marcar caduco | Inferencia | 10+ | **BR_003** Usuario Inactivo 90d | Cambio automático de estado |
| 8 | **Contenedor** | Entidad | 40+ | **Llamada** (tabla llamadas_historico) | Entidad principal |
| 9 | **ProductoQuimico** | Entidad | 25+ | **Cola/Tipo Llamada** | Clasificador |
| 10 | **Propietario** | Actor | 20+ | **AGR-002** operador_reportes | Usuario normal |
| 11 | **Coordinador Seguridad** | Actor | 15+ | **AGR-005** gestor_alertas | Supervisor de alertas |
| 12 | **Gerente** | Actor | 8+ | **AGR-003** supervisor | Supervisor |
| 13 | **UC-09** Aprobar Solicitud | UC | 8+ | **UC_ACC_01** Asignar Funciones | Proceso de autorización |
| 14 | **UC-10** Procesar Orden | UC | 6+ | **UC_RPT_06** Exportar CSV | Proceso con límites |
| 15 | **UC-28** Alertar Stock Bajo | UC | 5+ | **UC_ALR_02** Consultar Alertas | Visualización de alertas |

---

## ✅ ESTRATEGIA DE REESCRITURA CORRECTA

### Prioridad 1: Ejemplos Centrales (12-16h)

#### 1.1 Reescribir UC-07 → UC_ALR_01 (6-8h) ⭐⭐⭐

**Trabajo:**
- Reemplazar las 200+ líneas de UC-07 con UC_ALR_01
- Usar BR_014 en lugar de BR-031
- Cambiar actor de "Sistema (tiempo)" a "AGR-005 (agr_gestor_alertas)"
- Incluir función RBAC ALR-002
- Aplicar CNST-001, CNST-004, CNST-009
- Actualizar 30+ referencias en PARTE 2

**Secciones afectadas:**
- Sección 3.3: Patrón 3 (Desencadenador → UC)
- Sección 6: Derivación de FR
- Sección 7: Trazabilidad
- Ejercicios prácticos

#### 1.2 Reescribir UC-04 → UC_RPT_01 (5-6h) ⭐⭐⭐

**Trabajo:**
- Reemplazar flujo de solicitud con consulta de reporte
- Usar BR_016, BR_017, BR_018 en lugar de BR-060
- Cambiar actor de "Solicitante" a "AGR-002/AGR-003"
- Incluir función RBAC RPT-001
- Aplicar CNST-003, CNST-006
- Actualizar 25+ referencias

**Secciones afectadas:**
- Sección 4: Proceso de construcción de UC
- Sección 5: Integración de múltiples BR
- Ejercicios de derivación FR

#### 1.3 Reescribir BR-028 → BR_011 (1-2h)

**Trabajo:**
- Cambiar de "Aprobación >$500" a "Límites Exportación"
- Usar tabla con 3 límites (CSV/Excel/PDF)
- Vincular con CNST-007
- Actualizar 15+ referencias

### Prioridad 2: Ejemplos Frecuentes (6-8h)

#### 2.1 Reescribir BR-087 → BR_007 (2-3h)

**Trabajo:**
- Cambiar de "Certificación OSHA" a "SoD"
- Usar 3 restricciones SoD del proyecto real
- Vincular con CNST-005
- Mostrar validación en tiempo real

#### 2.2 Reescribir BR-060 → BR_016 (2-3h)

**Trabajo:**
- Cambiar tabla de descuentos por fórmula de Tasa Abandono
- Usar SQL: (COUNT abandonadas / COUNT total) × 100
- Vincular con UC_RPT_01, UC_RPT_09

#### 2.3 Actualizar Actores (2h)

**Trabajo:**
- Propietario → AGR-002 (operador_reportes)
- Coordinador → AGR-005 (gestor_alertas)
- Gerente → AGR-003 (supervisor)
- Sistema → BR_002 o BR_014

### Prioridad 3: Ejemplos Menores (8-12h)

- UC-09, UC-10, UC-12, UC-15, UC-20, UC-28
- BR-046, BR-012, BR-101, BR-102
- Ejercicio 4: Reescribir con UC reales del proyecto
- Referencias cruzadas

---

## 📈 ESTIMACIÓN ACTUALIZADA

| Prioridad | Elementos | Horas Min | Horas Max |
|-----------|-----------|-----------|-----------|
| 1: CRÍTICA | UC-07→UC_ALR_01, UC-04→UC_RPT_01, BR-028→BR_011 | 12h | 16h |
| 2: ALTA | BR-087→BR_007, BR-060→BR_016, Actores | 6h | 8h |
| 3: MEDIA | 8 ejemplos menores + Ejercicio 4 | 8h | 12h |
| **TOTAL PARTE 2** | **~15 elementos** | **26h** | **36h** |

**Diferencia con estimación anterior:** -2h a -2h (más preciso con datos reales)

---

## ✅ CONCLUSIÓN

### Error Corregido

Mi análisis anterior fue **COMPLETAMENTE EQUIVOCADO** porque:

❌ **NO REVISÉ** la documentación existente del proyecto  
❌ **ASUMÍ** que no había UC/BR definidos  
❌ **IGNORÉ** los 49 UC reales v4.0.0  
❌ **IGNORÉ** las 20 BR reales del proyecto  
❌ **IGNORÉ** el modelo RBAC v5.1.1  
❌ **IGNORÉ** las 10 CNST actualizadas  

### Análisis Correcto

✅ **49 UC reales** definidos (UC_AUTH_01 a UC_LOG_04)  
✅ **20 BR reales** definidas (BR_001 a BR_020)  
✅ **Modelo RBAC v5.1.1** (44 funciones, 10 agrupadores)  
✅ **10 CNST actualizadas** a v1.1.0  
✅ **8 módulos funcionales** del proyecto  

### Reescritura de PARTE 2

La reescritura debe usar:

✅ **UC_ALR_01** en lugar de UC-07  
✅ **BR_014** en lugar de BR-031  
✅ **UC_RPT_01** en lugar de UC-04  
✅ **BR_016, BR_017, BR_018** en lugar de BR-060  
✅ **AGR-005** en lugar de "Coordinador Seguridad"  
✅ **CNST-001, CNST-004, CNST-009** aplicables  
✅ **Funciones RBAC** (ALR-002, RPT-001)  

### Próximos Pasos

1. Confirmar que este análisis corregido es correcto
2. Proceder con reescritura de PARTE 2 usando elementos REALES
3. Validar con documentación del proyecto (49 UC, 20 BR, RBAC v5.1.1)

---

**ANÁLISIS CORREGIDO COMPLETADO**

**Fecha:** 2026-01-08  
**Estado:** Listo para validación del usuario  
**Ubicación:** /tmp/ANALISIS_CORREGIDO_PARTE2_CON_UC_REALES.md
