# ANÁLISIS COMPLETO PARTE 1: Ejemplos Pedagógicos a Reemplazar

**Fecha:** 2026-01-08  
**Documento Fuente:** PARTE 1 - IDENTIFICAR REGLAS DE NEGOCIO  
**Objetivo:** Identificar TODOS los ejemplos pedagógicos del dominio "Químicos" para reemplazarlos con ejemplos del dominio IACT (IVR)

---

## RESUMEN EJECUTIVO

**HALLAZGO CRÍTICO:**
PARTE 1 usa SISTEMÁTICAMENTE el dominio "Sistema de Gestión de Químicos en Laboratorio Universitario" como contexto pedagógico principal para enseñar la metodología de identificación de Business Rules.

**PROBLEMA:**
El proyecto IACT es un **sistema de análisis de llamadas IVR** (telecomunicaciones), NO un sistema de gestión de químicos. Esta desconexión genera:
1. Confusión conceptual en el equipo
2. Ejemplos irrelevantes para el dominio real
3. Dificultad para aplicar la metodología a casos reales del proyecto

**SOLUCIÓN:**
Reescribir PARTE 1 completa reemplazando TODOS los ejemplos de químicos con ejemplos del dominio IVR/telecomunicaciones del proyecto IACT.

---

## INVENTARIO COMPLETO DE EJEMPLOS PEDAGÓGICOS

### Contexto Principal: Sistema de Gestión de Químicos

**Dominio pedagógico usado:**
- Universidad con laboratorios
- Productos químicos peligrosos
- Contenedores con códigos de barras
- Certificaciones OSHA
- Coordinador de Seguridad
- Propietarios de contenedores
- Políticas de seguridad de laboratorio

**Actores del dominio químico:**
1. Solicitante (de productos químicos)
2. Propietario (de contenedor)
3. Coordinador de Seguridad
4. Gerente de Departamento
5. Aprobador

---

## EJEMPLOS DE BUSINESS RULES (Dominio Químicos)

### BR-012 (Hecho)

**ACTUAL (Químicos):**
```
BR-012 (Hecho):
  Definición: "Cada contenedor de producto químico tiene un código 
               de barras único"
  Tipo: Hecho
  Fuente: Estándar de Identificación de Materiales Peligrosos, Sección 3.2
  Impacto: Entidad Contenedor con atributo codigo_barras (unique)
```

**PROPUESTO (IVR):**
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

### BR-028 (Restricción) - EJEMPLO PRINCIPAL

**ACTUAL (Químicos):**
```
BR-028 (Restricción):
  Definición: "Solicitudes de compra que excedan $500 requieren 
               aprobación del gerente de departamento"
  Tipo: Restricción
  Fuente: Política Financiera Corporativa v2.3, Sección 4.2
  Fecha Vigencia: 2023-01-01
  Estática/Dinámica: Dinámica
```

**PROPUESTO (IVR):**
```
BR_IACT_028 (Restricción):
  Definición: "Consultas de reportes consolidados con más de 10,000 registros 
               requieren aprobación del supervisor de área"
  Tipo: Restricción
  Fuente: Política de Uso de Recursos Computacionales v1.2, Sección 3.4
  Fecha Vigencia: 2024-01-01
  Estática/Dinámica: Dinámica
  Prioridad: Media
  
  Justificación: Reportes grandes consumen recursos significativos del 
  servidor. Requiere autorización para evitar saturación del sistema.
  
  Impacto:
    - Precondición en UC_RPT_01 "Consultar Reporte"
    - Flujo alterno si registros >10,000
    - RF_RPT_01_05: Validación de cantidad de registros
    - RF_RPT_01_06: Solicitar aprobación supervisor
```

### BR-031 (Desencadenador) - EJEMPLO PRINCIPAL

**ACTUAL (Químicos):**
```
BR-031 (Desencadenador):
  Definición: "SI un contenedor de químico alcanza su fecha de 
               vencimiento ENTONCES el sistema debe notificar por 
               email al propietario del contenedor y al coordinador 
               de seguridad con 30 días de anticipación"
  Tipo: Desencadenador
  Genera: UC-07 "Notificar Vencimiento de Químico"
```

**PROPUESTO (IVR):**
```
BR_IACT_031 (Desencadenador):
  Definición: "SI un pipeline ETL falla en 3 intentos consecutivos 
               ENTONCES el sistema debe notificar por email al 
               coordinador técnico y al gerente de TI"
  Tipo: Desencadenador
  Fuente: Política de Monitoreo de Pipelines v2.1, Artículo 5
  Fecha Vigencia: 2024-06-01
  Estática/Dinámica: Dinámica
  Prioridad: Alta
  
  Genera: UC_PIP_05 "Notificar Falla Crítica de Pipeline"
  
  Actor Primario: Sistema (monitor de pipelines)
  Actores Secundarios: Coordinador Técnico, Gerente TI
  
  Flujo del UC_PIP_05:
    1. Sistema detecta 3er fallo consecutivo del pipeline
    2. Sistema identifica pipeline afectado por nombre/ID
    3. Sistema obtiene coordinador técnico asignado al pipeline
    4. Sistema obtiene gerente de TI del área
    5. Sistema genera email con:
       - Nombre del pipeline
       - Timestamp del último intento
       - Log de error detallado
       - Datos de la última ejecución exitosa
    6. Sistema envía email a coordinador técnico
    7. Sistema envía email a gerente de TI
    8. Sistema registra notificación en bitácora de alertas
    
  Functional Requirements derivados:
    RF_PIP_05_01: "Sistema monitorea estado de pipelines cada 5 minutos"
    RF_PIP_05_02: "Sistema cuenta fallos consecutivos por pipeline"
    RF_PIP_05_03: "Sistema envía email con log de error adjunto"
    RF_PIP_05_04: "Sistema registra timestamp de notificación"
    
  External Interfaces:
    EI-03: Integración con servidor SMTP para envío de emails
    EI-04: Integración con sistema de logs para extraer detalles de error
```

### BR-046 (Inferencia) - EJEMPLO PRINCIPAL

**ACTUAL (Químicos):**
```
BR-046 (Inferencia):
  Definición: "SI un contenedor de químico alcanza su fecha de 
               vencimiento ENTONCES el contenedor debe ser marcado 
               con estado 'Caduco' en el sistema"
  Tipo: Inferencia
  NO genera Caso de Uso (solo lógica interna)
```

**PROPUESTO (IVR):**
```
BR_IACT_046 (Inferencia):
  Definición: "SI un pipeline ETL no se ejecuta exitosamente en 24 horas 
               ENTONCES el pipeline debe ser marcado con estado 'Crítico' 
               en el sistema"
  Tipo: Inferencia
  Fuente: Política de Monitoreo de Pipelines v2.1, Artículo 5
  Fecha Vigencia: 2024-06-01
  Estática/Dinámica: Dinámica
  Prioridad: Media
  
  Condición: (fecha_actual - fecha_ultima_ejecucion_exitosa) > 24 horas
  Nuevo Hecho: estado_pipeline = "Crítico" (cambio INTERNO)
  
  NO genera Caso de Uso (solo actualización de estado interno)
  
  Genera:
    RF_PIP_05_05: "Sistema actualiza campo estado_pipeline a 'Crítico' 
                   cuando última_ejecución_exitosa > 24h"
    RF_PIP_05_06: "Sistema ejecuta verificación de estado cada hora"
    
  Notas:
    - Esta regla NO genera notificación (ver BR_IACT_031 para eso)
    - Es solo cambio de estado interno en base de datos
    - Pipelines marcados como 'Críticos' aparecen con indicador visual 
      en dashboard de monitoreo
    - El campo estado_pipeline es enumerado: Normal, Advertencia, Crítico, Fallido
```

### BR-060 (Cálculo - Tabla)

**ACTUAL (Químicos - Descuentos):**
```
BR-060 (Cálculo):
  "Descuento aplicable según tabla de descuentos por volumen"
  
  | Cant. Mín | Cant. Máx | Descuento |
  |-----------|-----------|-----------|
  | 1         | 10        | 0%        |
  | 11        | 50        | 5%        |
  | 51        | 100       | 10%       |
  | 101       | ∞         | 15%       |
```

**PROPUESTO (IVR - Prioridad de Procesamiento):**
```
BR_IACT_060 (Cálculo):
  Definición: "La prioridad de procesamiento de un reporte se determina 
               según la cantidad de registros a procesar"
  Tipo: Cálculo
  Fuente: Política de Asignación de Recursos v1.5, Anexo C
  Fecha Vigencia: 2024-03-01
  Estática/Dinámica: Dinámica
  Prioridad: Alta
  
  Tabla de Prioridades:
  
  | ID      | Registros Mín | Registros Máx | Prioridad | Cola      | Timeout |
  |---------|---------------|---------------|-----------|-----------|---------|
  | PRIO-1  | 1             | 1,000         | Alta      | express   | 30 seg  |
  | PRIO-2  | 1,001         | 10,000        | Media     | normal    | 5 min   |
  | PRIO-3  | 10,001        | 100,000       | Baja      | batch     | 1 hora  |
  | PRIO-4  | 100,001       | ∞             | Diferida  | nightly   | 12 horas|
  
  Algoritmo:
    registros = count(datos_a_procesar)
    
    IF registros <= 1000 THEN
      cola = "express"
      prioridad = "Alta"
      timeout = 30 segundos
      
    ELSE IF registros <= 10000 THEN
      cola = "normal"
      prioridad = "Media"
      timeout = 5 minutos
      
    ELSE IF registros <= 100000 THEN
      cola = "batch"
      prioridad = "Baja"
      timeout = 1 hora
      
    ELSE
      cola = "nightly"
      prioridad = "Diferida"
      timeout = 12 horas
    END IF
  
  Impacto:
    - UC_RPT_01, Paso 5: "Sistema determina prioridad de procesamiento"
    - RF_RPT_01_08: "Sistema calcula cantidad de registros a procesar"
    - RF_RPT_01_09: "Sistema asigna cola según tabla de prioridades"
    - RF_RPT_01_10: "Sistema establece timeout según prioridad"
    
  Notas:
    - Tabla almacenada en configuración de BD para permitir actualizaciones
    - Prioridad puede escalarse manualmente por supervisor (override)
    - Reportes en cola nightly solo se procesan entre 00:00 y 06:00
```

### BR-087 (Restricción - Permisos)

**ACTUAL (Químicos - OSHA):**
```
BR-087 (Restricción):
  "Solo personal con certificación OSHA vigente puede solicitar 
   productos químicos peligrosos (clase 1-4)"
  Fuente: OSHA 29 CFR 1910.1200
```

**PROPUESTO (IVR - Datos Sensibles):**
```
BR_IACT_087 (Restricción):
  Definición: "Solo usuarios con rol REPORTS_ADVANCED_VIEWER o superior 
               pueden acceder a reportes que contienen datos de clientes 
               sensibles (información financiera, datos personales 
               identificables)"
  Tipo: Restricción
  Fuente: Política de Seguridad de Datos v3.0, Sección 7.2
  Fecha Vigencia: 2023-11-01
  Estática/Dinámica: Dinámica
  Prioridad: Crítica
  
  Justificación: Cumplimiento con Ley de Protección de Datos Personales 
  (LFPDPPP). Solo personal autorizado puede visualizar información sensible 
  de clientes para evitar violaciones de privacidad.
  
  Roles Autorizados:
    - REPORTS_ADVANCED_VIEWER (lectura de datos sensibles)
    - REPORTS_MANAGER (lectura + exportación)
    - SYSTEM_ADMIN (acceso completo)
    
  Datos Sensibles incluyen:
    - Números de tarjeta de crédito
    - Cuentas bancarias
    - RFC/CURP
    - Direcciones completas
    - Números telefónicos
    - Emails personales
    
  Impacto:
    - Precondición en UC_RPT_03 "Consultar Reporte con Datos Clientes"
    - Validación de rol antes de renderizar columnas sensibles
    - RF_RPT_03_02: "Sistema verifica rol usuario antes de mostrar datos sensibles"
    - RF_RPT_03_03: "Sistema oculta columnas sensibles si usuario no autorizado"
    - RF_RPT_03_04: "Sistema registra cada acceso a datos sensibles en log auditoría"
    
  Sanciones por Incumplimiento:
    - Multas hasta $300,000 USD según LFPDPPP
    - Responsabilidad civil y penal
```

### BR-089 (Inferencia - Clasificación)

**ACTUAL (Químicos/Financiero - Deudor):**
```
BR-089 (Inferencia):
  "SI una cuenta tiene saldo impago mayor a 30 días ENTONCES 
   la cuenta debe ser clasificada como 'deudora'"
```

**PROPUESTO (IVR - Calidad de Llamada):**
```
BR_IACT_089 (Inferencia):
  Definición: "SI una llamada tiene tasa de error de speech recognition 
               mayor al 30% ENTONCES la llamada debe ser clasificada como 
               'baja calidad'"
  Tipo: Inferencia
  Fuente: Política de Calidad de Datos IVR v2.0, Sección 4.1
  Fecha Vigencia: 2024-01-01
  Estática/Dinámica: Dinámica
  Prioridad: Media
  
  Condición: (errores_reconocimiento / total_interacciones) > 0.30
  Nuevo Hecho: calidad_llamada = "Baja" (cambio INTERNO)
  
  NO genera Caso de Uso (solo clasificación interna)
  
  Genera:
    RF_LOG_02_08: "Sistema calcula tasa de error de speech recognition 
                   por llamada"
    RF_LOG_02_09: "Sistema clasifica llamada como 'Baja' cuando 
                   tasa_error > 30%"
    
  Impacto Posterior:
    - Llamadas clasificadas como "Baja" se excluyen de reportes de 
      análisis de patrones
    - Se incluyen en reporte de calidad de audio/línea
    - Pueden desencadenar alerta si % de llamadas baja calidad >10% en día
    
  Categorías de Calidad:
    - Alta: tasa_error <= 10%
    - Media: tasa_error 11-30%
    - Baja: tasa_error > 30%
```

### BR-122 (Desencadenador - Recordatorio)

**ACTUAL (Financiero - Pago):**
```
BR-122 (Desencadenador):
  "SI una cuenta tiene saldo impago mayor a 30 días ENTONCES 
   el sistema debe enviar recordatorio de pago al titular"
```

**PROPUESTO (IVR - Disponibilidad):**
```
BR_IACT_122 (Desencadenador):
  Definición: "SI la disponibilidad del sistema IVR cae por debajo del 
               95% en una ventana de 1 hora ENTONCES el sistema debe 
               enviar alerta automática al equipo de operaciones"
  Tipo: Desencadenador
  Fuente: SLA de Servicio IVR v1.0, Cláusula 3.2
  Fecha Vigencia: 2023-06-01
  Estática/Dinámica: Dinámica
  Prioridad: Crítica
  
  Genera: UC_ALR_02 "Alertar Disponibilidad Baja"
  
  Condición:
    disponibilidad_1h = (llamadas_exitosas / total_llamadas) * 100
    IF disponibilidad_1h < 95% THEN disparar alerta
  
  Flujo del UC_ALR_02:
    1. Sistema calcula disponibilidad cada 5 minutos
    2. Sistema detecta disponibilidad < 95%
    3. Sistema identifica equipo de operaciones (oncall)
    4. Sistema genera alerta con:
       - Porcentaje de disponibilidad actual
       - Número de llamadas fallidas
       - Timestamp de inicio de degradación
       - Posibles causas detectadas automáticamente
    5. Sistema envía alerta vía:
       - Email a operaciones@company.com
       - SMS a teléfono oncall
       - Notificación push en app de monitoreo
    6. Sistema registra alerta en sistema de tickets
    7. Sistema inicia protocolo de escalación si no hay respuesta en 15 min
    
  Functional Requirements:
    RF_ALR_02_01: "Sistema calcula disponibilidad cada 5 minutos"
    RF_ALR_02_02: "Sistema almacena histórico de disponibilidad últimas 24h"
    RF_ALR_02_03: "Sistema envía alerta por 3 canales (email, SMS, push)"
    RF_ALR_02_04: "Sistema inicia escalación después de 15 min sin respuesta"
    
  Quality Attributes:
    QA-15: "Alerta debe enviarse en menos de 60 segundos después de 
            detección de degradación"
```

### BR-156 (Desencadenador - Reporte Fiscal)

**ACTUAL (Financiero - SAT):**
```
BR-156 (Desencadenador):
  "SI una transacción supera $10,000 ENTONCES el sistema debe 
   generar reporte automático para autoridades fiscales"
  Fuente: Ley Anti-Lavado Federal, Artículo 17
```

**PROPUESTO (IVR - Auditoría de Acceso):**
```
BR_IACT_156 (Desencadenador):
  Definición: "SI un usuario accede a datos de más de 100 clientes 
               diferentes en un periodo de 1 hora ENTONCES el sistema 
               debe generar alerta de auditoría automática"
  Tipo: Desencadenador
  Fuente: Política de Seguridad de Información v3.0, Sección 9.4
  Fecha Vigencia: 2023-12-01
  Estática/Dinámica: Dinámica
  Prioridad: Alta
  
  Genera: UC_AUD_03 "Generar Alerta Acceso Masivo"
  
  Justificación: Detectar posible exfiltración de datos o uso indebido 
  del sistema. Patrón de acceso masivo es anómalo y requiere revisión.
  
  Condición:
    clientes_unicos_accedidos_1h = COUNT(DISTINCT cliente_id)
    IF clientes_unicos_accedidos_1h > 100 THEN disparar alerta
  
  Flujo del UC_AUD_03:
    1. Sistema monitorea accesos a datos de clientes por usuario
    2. Sistema detecta umbral de 100 clientes únicos superado en 1h
    3. Sistema identifica:
       - Usuario que realizó accesos
       - Lista de clientes accedidos
       - Tipo de operaciones realizadas
       - IP y ubicación de acceso
    4. Sistema genera reporte de auditoría con:
       - Detalle completo de accesos
       - Timeline de actividad
       - Comparación con patrón normal del usuario
    5. Sistema envía alerta a:
       - Gerente de Seguridad
       - Gerente del usuario involucrado
    6. Sistema bloquea temporalmente acceso del usuario (opcional)
    7. Sistema registra evento en log de seguridad
    
  Functional Requirements:
    RF_AUD_03_01: "Sistema cuenta clientes únicos accedidos por usuario/hora"
    RF_AUD_03_02: "Sistema genera timeline de accesos con timestamps"
    RF_AUD_03_03: "Sistema compara con patrón histórico del usuario"
    RF_AUD_03_04: "Sistema puede bloquear usuario automáticamente si configurado"
    RF_AUD_03_05: "Sistema registra IP y ubicación de cada acceso"
    
  Excepciones:
    - Usuarios con rol AUDIT_VIEWER están exentos (su trabajo es revisar datos)
    - Scripts automáticos con marca especial están exentos
```

### BR-178 (Cálculo - Tabla Multidimensional)

**ACTUAL (Logística - Envío):**
```
BR-178 (Cálculo):
  "Costo de envío según zona geográfica, peso y tipo de servicio"
  
  | Zona | Peso (kg) | Estándar | Express | Premium |
  |------|-----------|----------|---------|---------|
  | 1    | 0-5       | $50      | $80     | $120    |
  | 2    | 0-5       | $80      | $120    | $180    |
```

**PROPUESTO (IVR - Costo de Procesamiento):**
```
BR_IACT_178 (Cálculo):
  Definición: "El costo de procesamiento de un reporte se calcula según 
               cantidad de registros, tipo de análisis y prioridad"
  Tipo: Cálculo
  Fuente: Política de Presupuesto de TI v2.0, Anexo D
  Fecha Vigencia: 2024-01-01
  Estática/Dinámica: Dinámica
  Prioridad: Media
  
  Tabla de Costos (en créditos internos):
  
  | Registros    | Análisis Simple | Análisis Complejo | ML/Predictivo |
  |--------------|-----------------|-------------------|---------------|
  | 1-1K         | 1 crédito       | 3 créditos        | 10 créditos   |
  | 1K-10K       | 3 créditos      | 10 créditos       | 30 créditos   |
  | 10K-100K     | 10 créditos     | 30 créditos       | 100 créditos  |
  | 100K-1M      | 30 créditos     | 100 créditos      | 300 créditos  |
  | >1M          | 100 créditos    | 300 créditos      | 1000 créditos |
  
  Multiplicadores de Prioridad:
    - Alta (express): costo × 1.5
    - Media (normal): costo × 1.0
    - Baja (batch): costo × 0.5
    - Diferida (nightly): costo × 0.3
  
  Algoritmo:
    registros_categoria = clasificar_registros(count)
    tipo_analisis = determinar_tipo(query)
    costo_base = TABLA[registros_categoria][tipo_analisis]
    multiplicador = obtener_multiplicador(prioridad)
    costo_total = costo_base * multiplicador
  
  Tipos de Análisis:
    - Simple: SELECT con WHERE simples, sin JOINs complejos
    - Complejo: JOINs múltiples, agregaciones, subconsultas
    - ML/Predictivo: Modelos de machine learning, análisis predictivo
  
  Impacto:
    - UC_RPT_01, Paso 6: "Sistema calcula costo estimado de procesamiento"
    - RF_RPT_01_11: "Sistema muestra costo estimado antes de ejecutar"
    - RF_RPT_01_12: "Sistema valida que usuario tiene créditos suficientes"
    - RF_RPT_01_13: "Sistema decrementa créditos después de ejecución exitosa"
    
  Notas:
    - Créditos se asignan mensualmente por departamento
    - Gerentes pueden autorizar override de límite de créditos
    - Créditos no usados NO se acumulan al siguiente mes
```

### BR-234 (Cálculo - Fórmula Simple)

**ACTUAL (Académico - Calificación):**
```
BR-234 (Cálculo):
  "Calificación final = 70% teórica + 30% práctica"
```

**PROPUESTO (IVR - Score de Satisfacción):**
```
BR_IACT_234 (Cálculo):
  Definición: "El score de satisfacción de una llamada se calcula como: 
               60% de NPS (Net Promoter Score) + 30% de resolución en 
               primera llamada + 10% de duración ajustada"
  Tipo: Cálculo
  Fuente: Política de Métricas de Calidad IVR v1.5, Sección 2.3
  Fecha Vigencia: 2024-02-01
  Estática/Dinámica: Dinámica
  Prioridad: Alta
  
  Fórmula:
    score_satisfaccion = (NPS * 0.60) + (FCR * 0.30) + (duracion_ajustada * 0.10)
    
  Donde:
    NPS = Net Promoter Score normalizado a escala 0-100
          (de encuesta post-llamada si disponible)
          
    FCR = First Call Resolution (1.0 si resuelto, 0.0 si no resuelto)
          normalizado a escala 0-100
          
    duracion_ajustada = score basado en duración vs duración objetivo:
                        - Si duracion <= duracion_objetivo: 100 puntos
                        - Si duracion > duracion_objetivo: 
                          puntos = 100 - ((duracion - objetivo) / objetivo * 100)
                          min = 0, max = 100
  
  Ejemplo de Cálculo:
    Llamada 1:
      NPS = 80 (cliente satisfecho)
      FCR = 100 (resuelto en primera llamada)
      Duración = 5 minutos (objetivo = 4 min)
      duracion_ajustada = 100 - ((5-4)/4 * 100) = 75
      
      score = (80 * 0.60) + (100 * 0.30) + (75 * 0.10)
            = 48 + 30 + 7.5
            = 85.5
  
  Clasificación de Score:
    - 90-100: Excelente
    - 75-89: Bueno
    - 60-74: Aceptable
    - <60: Deficiente
  
  Impacto:
    - UC_LOG_03, Paso 8: "Sistema calcula score de satisfacción"
    - RF_LOG_03_09: "Sistema normaliza NPS a escala 0-100"
    - RF_LOG_03_10: "Sistema determina FCR basado en resolución"
    - RF_LOG_03_11: "Sistema calcula duración ajustada"
    - RF_LOG_03_12: "Sistema aplica ponderación 60/30/10"
    - RF_LOG_03_13: "Sistema redondea resultado a 1 decimal"
    
  Notas:
    - Si NPS no disponible (sin encuesta), usar promedio histórico del agente
    - Ponderaciones pueden ajustarse trimestralmente por gerencia
    - Score se usa para: evaluación de agentes, KPIs, bonos
```

### BR-245 (Desencadenador - Inventario)

**ACTUAL (Inventario - Stock Bajo):**
```
BR-245 (Desencadenador):
  "SI el inventario de un producto cae por debajo del punto de 
   reorden ENTONCES el sistema debe alertar al departamento de 
   compras"
```

**PROPUESTO (IVR - Capacidad del Sistema):**
```
BR_IACT_245 (Desencadenador):
  Definición: "SI la utilización de CPU del servidor IVR supera el 80% 
               durante 5 minutos consecutivos ENTONCES el sistema debe 
               alertar al equipo de infraestructura"
  Tipo: Desencadenador
  Fuente: Política de Monitoreo de Infraestructura v2.0, Sección 5.1
  Fecha Vigencia: 2024-01-01
  Estática/Dinámica: Dinámica
  Prioridad: Alta
  
  Genera: UC_ALR_04 "Alertar Alta Utilización CPU"
  
  Condición:
    FOR EACH sample IN last_5_minutes:
      IF cpu_usage > 80% THEN count++
    IF count >= 5 THEN disparar alerta
  
  Flujo del UC_ALR_04:
    1. Sistema monitorea utilización CPU cada 1 minuto
    2. Sistema detecta CPU >80% durante 5 muestras consecutivas
    3. Sistema identifica:
       - Servidor afectado
       - Procesos consumiendo más CPU
       - Número de llamadas activas
       - Carga histórica vs actual
    4. Sistema genera alerta con:
       - Porcentaje de CPU actual
       - Top 10 procesos por CPU
       - Gráfica de últimos 30 minutos
       - Llamadas en espera/rechazadas
    5. Sistema envía alerta a:
       - Equipo de infraestructura
       - Oncall de operaciones
    6. Sistema registra evento en sistema de monitoreo
    7. Sistema inicia auto-scaling si configurado (aumentar instancias)
    
  Functional Requirements:
    RF_ALR_04_01: "Sistema muestrea CPU cada 60 segundos"
    RF_ALR_04_02: "Sistema mantiene buffer de últimos 5 minutos"
    RF_ALR_04_03: "Sistema identifica procesos por uso de CPU"
    RF_ALR_04_04: "Sistema puede iniciar auto-scaling automático"
    
  Umbrales Adicionales:
    - Warning (70%): Notificar solo en dashboard
    - Critical (80%): Enviar alerta por email
    - Emergency (90%): Enviar alerta por email + SMS
    - Overload (95%): Iniciar auto-scaling forzado
```

### BR-246 (Inferencia - Estado Inventario)

**ACTUAL (Inventario - Marca):**
```
BR-246 (Inferencia):
  "SI el inventario de un producto cae por debajo del punto de 
   reorden ENTONCES el producto debe ser marcado como 'stock bajo'"
```

**PROPUESTO (IVR - Estado Sistema):**
```
BR_IACT_246 (Inferencia):
  Definición: "SI la utilización de CPU del servidor IVR supera el 80% 
               ENTONCES el servidor debe ser marcado con estado 'Saturado' 
               en el dashboard de monitoreo"
  Tipo: Inferencia
  Fuente: Política de Monitoreo de Infraestructura v2.0, Sección 5.1
  Fecha Vigencia: 2024-01-01
  Estática/Dinámica: Dinámica
  Prioridad: Media
  
  Condición: cpu_usage > 80%
  Nuevo Hecho: estado_servidor = "Saturado" (cambio INTERNO)
  
  NO genera Caso de Uso (solo actualización de estado interno)
  
  Genera:
    RF_ALR_04_05: "Sistema actualiza campo estado_servidor a 'Saturado' 
                   cuando CPU > 80%"
    RF_ALR_04_06: "Sistema actualiza estado cada minuto"
    
  Estados Posibles:
    - Normal: CPU < 70%
    - Advertencia: CPU 70-79%
    - Saturado: CPU 80-94%
    - Crítico: CPU >= 95%
    
  Impacto Visual:
    - Dashboard muestra servidor con color según estado:
      * Normal: Verde
      * Advertencia: Amarillo
      * Saturado: Naranja
      * Crítico: Rojo parpadeante
    
  Notas:
    - Esta regla NO envía alertas (ver BR_IACT_245 para alertas)
    - Es solo cambio de indicador visual en dashboard
    - Estado se actualiza automáticamente cuando CPU baja
```

---

## CASOS DE USO (Dominio Químicos)

### UC-04: Solicitar Producto Químico

**ACTUAL (Químicos):**
```
UC-04: Solicitar Producto Químico

Actor Primario: Solicitante
Objetivo: Obtener autorización para adquirir un producto químico

Precondiciones:
  - Solicitante tiene cuenta activa
  - Solicitante tiene certificación OSHA vigente (BR-087)

Flujo Normal:
  1. Solicitante ingresa código del producto químico
  2. Sistema muestra información del producto (nombre, clase, riesgos)
  3. Solicitante ingresa cantidad y justificación
  4. Sistema verifica capacitación del solicitante (BR-087)
  5. Sistema valida cantidad contra límites permitidos
  6. SI monto >$500 ENTONCES (BR-028)
       6.1. Sistema solicita aprobación de gerente
       6.2. Sistema envía notificación a gerente
       6.3. Sistema espera aprobación
  7. Sistema registra la solicitud
  8. Sistema notifica al solicitante confirmación

Flujos Alternos:
  FA-1: Solicitante sin certificación
    4a. SI solicitante no tiene certificación OSHA ENTONCES
      4a.1. Sistema muestra error "Certificación requerida"
      4a.2. Caso de uso termina
      
  FA-2: Cantidad excede límite
    5a. SI cantidad > límite_permitido ENTONCES
      5a.1. Sistema muestra error "Cantidad excede límite"
      5a.2. Solicitante puede modificar cantidad
      5a.3. Volver a paso 3

Business Rules aplicadas: BR-028, BR-087, BR-031
```

**PROPUESTO (IVR):**
```
UC_RPT_01: Consultar Reporte de Llamadas

Actor Primario: Usuario Analista
Objetivo: Obtener reporte de llamadas según filtros especificados

Precondiciones:
  - Usuario autenticado en sistema
  - Usuario tiene rol REPORTS_VIEWER o superior

Flujo Normal:
  1. Usuario accede a módulo "Reportes"
  2. Sistema muestra catálogo de reportes disponibles
  3. Usuario selecciona "Reporte de Llamadas"
  4. Usuario especifica filtros:
     - Rango de fechas (obligatorio)
     - Tipo de llamada (opcional: entrante/saliente/todas)
     - Estado (opcional: exitosa/fallida/abandonada/todas)
     - Agente (opcional)
     - Cola IVR (opcional)
  5. Sistema calcula cantidad estimada de registros
  6. Sistema determina prioridad de procesamiento (BR_IACT_060)
  7. Sistema calcula costo estimado en créditos (BR_IACT_178)
  8. Sistema muestra resumen:
     - Registros estimados: X
     - Tiempo estimado: Y minutos
     - Costo: Z créditos
  9. SI registros >10,000 ENTONCES (BR_IACT_028)
       9.1. Sistema requiere aprobación de supervisor
       9.2. Sistema solicita comentario de justificación
       9.3. Usuario ingresa justificación
       9.4. Sistema envía solicitud a supervisor
       9.5. Caso de uso queda en estado "Pendiente Aprobación"
  10. Usuario confirma solicitud
  11. Sistema valida créditos disponibles
  12. Sistema procesa reporte según prioridad asignada
  13. Sistema notifica al usuario cuando reporte está listo
  14. Usuario puede descargar reporte en formato Excel/CSV/PDF

Flujos Alternos:
  FA-1: Usuario sin permisos para datos sensibles
    4a. SI usuario selecciona filtro que incluye datos sensibles ENTONCES
      4a.1. SI usuario NO tiene rol REPORTS_ADVANCED_VIEWER ENTONCES (BR_IACT_087)
        4a.1.1. Sistema muestra advertencia "Datos sensibles ocultos"
        4a.1.2. Sistema continúa pero excluye columnas sensibles
  
  FA-2: Créditos insuficientes
    11a. SI usuario.creditos < costo_reporte ENTONCES
      11a.1. Sistema muestra error "Créditos insuficientes"
      11a.2. Sistema ofrece opciones:
             - Solicitar más créditos a gerente
             - Reducir alcance del reporte
             - Cambiar prioridad a "Diferida" (menor costo)
      11a.3. Caso de uso termina o usuario modifica filtros
  
  FA-3: Reporte toma más tiempo del esperado
    12a. SI tiempo_ejecucion > timeout_prioridad ENTONCES
      12a.1. Sistema envía email "Reporte en progreso"
      12a.2. Sistema continúa procesamiento en background
      12a.3. Sistema notifica cuando complete

Postcondiciones:
  - Reporte generado y disponible para descarga
  - Créditos descontados de cuenta de usuario
  - Solicitud registrada en bitácora

Business Rules aplicadas: 
  BR_IACT_028, BR_IACT_060, BR_IACT_087, BR_IACT_178

Functional Requirements derivados:
  RF_RPT_01_01: "Sistema valida autenticación usuario"
  RF_RPT_01_02: "Sistema valida rol mínimo REPORTS_VIEWER"
  RF_RPT_01_03: "Sistema permite especificar filtros múltiples"
  RF_RPT_01_04: "Sistema calcula cantidad estimada de registros"
  RF_RPT_01_05: "Sistema valida umbral 10,000 registros" (BR_IACT_028)
  RF_RPT_01_06: "Sistema solicita aprobación supervisor si >10K"
  RF_RPT_01_07: "Sistema envía notificación email a supervisor"
  RF_RPT_01_08: "Sistema calcula costo en créditos" (BR_IACT_178)
  RF_RPT_01_09: "Sistema valida créditos disponibles"
  RF_RPT_01_10: "Sistema procesa reporte según prioridad" (BR_IACT_060)
  RF_RPT_01_11: "Sistema permite descarga en 3 formatos"
  RF_RPT_01_12: "Sistema registra solicitud en bitácora"
```

### UC-07: Notificar Vencimiento de Químico

**ACTUAL (Químicos):**
```
UC-07: Notificar Vencimiento de Químico

Actor Primario: Sistema (actor tiempo)
Actores Secundarios: Propietario, Coordinador de Seguridad
Trigger: Diario a las 00:00

Flujo Normal:
  1. Sistema ejecuta verificación diaria de vencimientos
  2. Sistema identifica contenedores que vencen en 30 días
  3. Para cada contenedor:
     3.1. Sistema obtiene propietario actual
     3.2. Sistema obtiene coordinador de seguridad
     3.3. Sistema genera email con detalles:
          - Nombre del químico
          - Código del contenedor
          - Fecha de vencimiento
          - Ubicación actual
          - Instrucciones de disposición
     3.4. Sistema envía email a propietario
     3.5. Sistema envía email a coordinador
     3.6. Sistema registra notificación enviada
  4. Sistema actualiza estado del contenedor a "Por Vencer"

Business Rules: BR-031 (genera este UC)
```

**PROPUESTO (IVR):**
```
UC_PIP_05: Notificar Falla Crítica de Pipeline

Actor Primario: Sistema (monitor de pipelines)
Actores Secundarios: Coordinador Técnico, Gerente TI
Trigger: Continuo (monitoreo cada 5 minutos)

Precondiciones:
  - Pipeline está configurado para monitoreo
  - Contactos de coordinador y gerente están actualizados

Flujo Normal:
  1. Sistema monitorea ejecución de pipelines cada 5 minutos
  2. Sistema detecta que pipeline ha fallado 3 veces consecutivas
  3. Sistema identifica pipeline afectado:
     3.1. Nombre del pipeline
     3.2. ID único
     3.3. Responsable asignado
  4. Sistema extrae información de contexto:
     4.1. Timestamp de cada fallo
     4.2. Logs de error de última ejecución
     4.3. Timestamp de última ejecución exitosa
     4.4. Volumen de datos procesado habitualmente
  5. Sistema identifica destinatarios:
     5.1. Obtiene coordinador técnico asignado al pipeline
     5.2. Obtiene gerente de TI del área
     5.3. Si coordinador no definido, usa coordinador técnico general
  6. Sistema genera contenido de notificación:
     6.1. Asunto: "[CRÍTICO] Pipeline [nombre] falló 3 veces consecutivas"
     6.2. Cuerpo HTML con:
         - Resumen del problema
         - Detalles de los 3 fallos
         - Log de error completo
         - Link directo al pipeline en sistema
         - Acciones sugeridas
         - Datos de contacto de oncall
  7. Sistema envía email a coordinador técnico
  8. Sistema envía email a gerente de TI
  9. Sistema registra notificación en bitácora de alertas:
     9.1. Timestamp de envío
     9.2. Pipeline afectado
     9.3. Destinatarios
     9.4. Status de entrega de emails
  10. Sistema marca pipeline con estado "Requiere Atención"
  11. Sistema inicia contador de escalación (15 minutos)

Flujos Alternos:
  FA-1: Error al enviar email
    7a/8a. SI error al enviar email ENTONCES
      7a.1. Sistema registra error de envío
      7a.2. Sistema intenta envío por método alternativo (SMS)
      7a.3. Sistema escala inmediatamente a oncall general

  FA-2: Pipeline se recupera antes de notificar
    2a. SI pipeline ejecuta exitosamente antes de enviar notificación ENTONCES
      2a.1. Sistema cancela notificación
      2a.2. Sistema registra auto-recuperación
      2a.3. Caso de uso termina

  FA-3: Sin contactos configurados
    5a. SI no hay coordinador ni gerente configurado ENTONCES
      5a.1. Sistema usa contacto de emergencia general
      5a.2. Sistema registra advertencia "Contactos no configurados"

Postcondiciones:
  - Notificaciones enviadas a coordinador y gerente
  - Pipeline marcado como "Requiere Atención"
  - Evento registrado en bitácora
  - Contador de escalación iniciado

Business Rules aplicadas: BR_IACT_031 (genera este UC)

Functional Requirements derivados:
  RF_PIP_05_01: "Sistema monitorea pipelines cada 5 minutos"
  RF_PIP_05_02: "Sistema cuenta fallos consecutivos por pipeline"
  RF_PIP_05_03: "Sistema extrae logs de error detallados"
  RF_PIP_05_04: "Sistema identifica coordinador técnico asignado"
  RF_PIP_05_05: "Sistema genera email con template HTML"
  RF_PIP_05_06: "Sistema envía emails vía servidor SMTP"
  RF_PIP_05_07: "Sistema registra timestamp de envío"
  RF_PIP_05_08: "Sistema actualiza estado de pipeline"
  RF_PIP_05_09: "Sistema inicia contador de escalación"

Quality Attributes:
  QA-20: "Notificación debe enviarse en <60 segundos desde detección"
  QA-21: "Email debe entregarse con confirmación de recepción"

External Interfaces:
  EI-03: Integración con servidor SMTP corporativo
  EI-04: Integración con sistema de logs para extraer detalles
```

---

## EJEMPLOS EN EJERCICIOS PRÁCTICOS

### Ejercicio 1: Identificar Tipos

**ACTUAL (Químicos/Genérico):**
```
1. "Cada pedido debe incluir al menos un item"
2. "Solo usuarios con rol Admin pueden eliminar registros"
3. "SI stock < punto_reorden ENTONCES alertar a compras"
```

**PROPUESTO (IVR):**
```
1. "Cada llamada registrada debe tener un call_id único"
   Respuesta: HECHO (estructura del dominio)

2. "Solo usuarios con rol SYSTEM_ADMIN pueden eliminar registros de llamadas"
   Respuesta: RESTRICCIÓN (palabra clave "Solo")

3. "SI disponibilidad < 95% ENTONCES alertar a operaciones"
   Respuesta: DESENCADENADOR (alerta es acción observable)

4. "Duración promedio = suma(duraciones) / count(llamadas)"
   Respuesta: CÁLCULO (fórmula matemática)

5. "SI tasa_error > 30% ENTONCES marcar llamada como 'Baja Calidad'"
   Respuesta: INFERENCIA (marca interna, NO observable)
```

### Ejercicio 2: Desencadenador vs Inferencia

**ACTUAL (Genérico):**
```
1. "SI cuenta inactiva >12 meses ENTONCES enviar encuesta reactivación"
2. "SI cuenta inactiva >12 meses ENTONCES clasificar como dormida"
```

**PROPUESTO (IVR):**
```
1. "SI pipeline falla 3 veces ENTONCES enviar alerta a coordinador"
   Respuesta: DESENCADENADOR (coordinador recibe email - observable)

2. "SI pipeline falla 3 veces ENTONCES marcar como 'Crítico'"
   Respuesta: INFERENCIA (solo campo en BD - NO observable)

3. "SI CPU >80% durante 5 min ENTONCES activar auto-scaling"
   Respuesta: DESENCADENADOR (instancias nuevas se crean - observable)

4. "SI CPU >80% ENTONCES marcar servidor como 'Saturado'"
   Respuesta: INFERENCIA (solo indicador en dashboard - NO observable)

5. "SI usuario accede >100 clientes/hora ENTONCES notificar a seguridad"
   Respuesta: DESENCADENADOR (seguridad recibe alerta - observable)
```

### Ejercicio 5: Caso Completo

**ACTUAL (Hotel):**
```
BR-301: "Cada habitación pertenece a exactamente una categoría"
BR-302: "Solo huéspedes registrados pueden hacer check-in"
```

**PROPUESTO (IVR):**
```
BR_IACT_301 (Hecho):
  "Cada llamada pertenece a exactamente una cola IVR"

BR_IACT_302 (Restricción):
  "Solo usuarios autenticados pueden acceder al módulo de reportes"

BR_IACT_303 (Restricción):
  "Consultas de datos históricos están limitadas a últimos 12 meses"

BR_IACT_304 (Desencadenador):
  "SI tiempo de espera en cola >5 minutos ENTONCES notificar 
   supervisor de turno"

BR_IACT_305 (Inferencia):
  "SI llamada dura >30 minutos ENTONCES clasificar como 'Llamada Larga'"

BR_IACT_306 (Cálculo):
  "Tiempo promedio de atención = suma(duraciones_atendidas) / 
   count(llamadas_atendidas)"
```

---

## ESTRATEGIA DE REESCRITURA

### Paso 1: Mapeo Completo (1-2h)

Crear tabla de mapeo sistemático:

| Concepto Químicos | Concepto IVR | Notas |
|-------------------|--------------|-------|
| Contenedor de químico | Llamada | Entidad principal |
| Propietario | Agente/Usuario | Responsable |
| Coordinador Seguridad | Coordinador Técnico | Supervisor |
| Vencimiento | Fallo/Timeout | Evento negativo |
| Certificación OSHA | Rol/Permiso | Autorización |
| Código de barras | call_id | Identificador único |
| Solicitud de compra | Consulta de reporte | Operación |
| Gerente | Supervisor | Aprobador |
| $500 umbral | 10,000 registros umbral | Límite operacional |
| Stock bajo | CPU alto / Disponibilidad baja | Métrica crítica |

### Paso 2: Reescritura Sistemática (8-10h)

Para cada sección de PARTE 1:

1. **Sección 1-3:** Mantener teoría, cambiar ejemplos
2. **Sección 4 (Taxonomía):** Reescribir todos los 5 tipos con ejemplos IVR
3. **Sección 5 (Desenc vs Inf):** Reescribir ejemplos comparativos
4. **Sección 6 (Licitación):** Adaptar preguntas estratégicas a dominio IVR
5. **Sección 7 (Documentación):** Reescribir plantillas con ejemplos IVR
6. **Sección 8 (Gestión):** Mantener metodología, ejemplos IVR
7. **Sección 9 (Ciclo Vida):** Mantener proceso, ejemplos IVR
8. **Sección 10 (Casos Esp):** Adaptar conflictos a dominio IVR
9. **Sección 11 (Ejercicios):** Reescribir TODOS los ejercicios
10. **Sección 12 (Resumen):** Actualizar referencias a ejemplos

### Paso 3: Validación (1h)

- Verificar consistencia de nomenclatura
- Asegurar que todos los ejemplos usan dominio IVR
- Validar que BR_IACT_XXX son consistentes
- Verificar trazabilidad UC_XXX_XX → BR_IACT_XXX

---

## IMPACTO EN base_cognitiva/

Si PARTE 1 original se usó para generar base_cognitiva/, entonces:

**Archivos afectados:**
- FND_01_Concepto_Requisito.rst → Ejemplos de BR
- FND_03_Casos_de_Uso.rst → Ejemplos UC-04, UC-07
- MTM_01_Metamodelo_Requisitos.rst → Trazabilidad BR → UC → FR
- MTM_02_Metamodelo_Trazabilidad.rst → Tablas RTM con ejemplos
- TXM_03_Taxonomia_Reglas_Negocio.rst → Clasificación de BR

**Cambios requeridos:**
1. Reemplazar TODOS los ejemplos de químicos
2. Actualizar nomenclatura: BR-028 → BR_IACT_028
3. Actualizar nomenclatura: UC-04 → UC_RPT_01 o UC_PIP_05
4. Reescribir tablas de trazabilidad con ejemplos reales
5. Actualizar diagramas PlantUML con ejemplos IVR

---

## CONCLUSIÓN

**PARTE 1 completa requiere reescritura integral** para alinearla con el dominio del proyecto IACT (análisis de llamadas IVR).

**Esfuerzo estimado:**
- Mapeo de conceptos: 1-2h
- Reescritura de ejemplos: 8-10h
- Validación y ajustes: 1-2h
- **TOTAL: 10-14 horas**

**Beneficio:**
- Documentación pedagógica alineada con proyecto real
- Equipo aprende metodología con casos que van a implementar
- Consistencia total entre teoría (PARTE 1) y práctica (base_cognitiva/)
- Reducción de confusión y errores conceptuales

**PRÓXIMO PASO:**
Esperar PARTE 2, 3, 4, 5, 6 para análisis completo y luego ejecutar reescritura integral de base_cognitiva/ con ejemplos 100% del dominio IACT.

