.. meta::
   :Versión: 1.0.0
   :Fecha: 2026-01-08
   :Estado: VIGENTE
   :Dominio: Sistema IVR Analytics (IACT)
   :Autor: Equipo IACT
   :Clasificación: Pedagógico

===============================================
FND-00: Contexto y Jerarquía de Documentación
===============================================

:Propósito: Establecer el contexto del sistema IACT y la jerarquía de la documentación pedagógica
:Audiencia: Analistas de negocio, arquitectos de software, desarrolladores
:Prerequisitos: Familiaridad con análisis de requisitos y UML básico

---

1. Introducción
===============

1.1 Propósito de Esta Documentación
------------------------------------

Esta documentación pedagógica tiene como objetivo enseñar la **metodología de transformación** 
de requisitos de negocio en especificaciones técnicas, utilizando como caso de estudio el 
**Sistema IACT** (IVR Analytics & Customer Tracking).

**Niveles de transformación:**

.. code-block:: text

   Business Requirements (BReq)
        ↓
   Business Rules (BR)
        ↓
   Use Cases (UC)
        ↓
   Functional Requirements (FR)
        ↓
   CODE + TESTS

La documentación se organiza en 3 partes:

- **PARTE 0:** Introducción y contexto (este documento)
- **PARTE 1:** Cómo identificar Business Rules desde requisitos de negocio
- **PARTE 2:** Cómo transformar Business Rules en Casos de Uso y Requisitos Funcionales

---

1.2 Estructura de la Documentación base_cognitiva/
--------------------------------------------------

La carpeta ``base_cognitiva/`` contiene el conocimiento fundamental sobre 
la metodología de análisis de requisitos:

.. code-block:: text

   base_cognitiva/
   ├── FND_00_Contexto_y_Jerarquia.rst        (Este documento)
   ├── FND_01_Identidad_Estrategica.rst       (Fundamentos)
   ├── FND_02_Glosario_de_Terminos.rst        (Glosario)
   ├── FND_03_Taxonomia_BR.rst                (5 tipos de BR)
   │
   ├── MTM_01_BR_a_UC_Trazabilidad.rst        (Matriz BR→UC)
   ├── MTM_02_UC_a_FR_Trazabilidad.rst        (Matriz UC→FR)
   ├── MTM_03_Esquema_Trazabilidad.rst        (Diagramas)
   │
   ├── TXM_01_Nomenclatura_UC_FR.rst          (Nomenclatura)
   ├── TXM_02_Plantillas_UC_FR.rst            (Plantillas)
   ├── TXM_03_Patrones_Transformacion.rst     (Patrones)
   ├── TXM_04_Proceso_Construccion.rst        (Proceso paso a paso)
   ├── TXM_05_Integracion_BR.rst              (Integración de BR)
   ├── TXM_06_Derivacion_FR.rst               (Derivación de FR)
   ├── TXM_07_Matriz_Trazabilidad.rst         (Matriz completa)
   └── TXM_08_Validacion_Calidad.rst          (Validación)

**Prefijos:**

- **FND:** Fundamentos conceptuales
- **MTM:** Matrices de trazabilidad
- **TXM:** Transformación metodológica

---

1.3 Caso de Estudio: Sistema IACT
----------------------------------

Esta documentación pedagógica utiliza como **caso de estudio** el 
**Sistema IACT** (IVR Analytics & Customer Tracking).

1.3.1 Descripción del Sistema
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**IACT** es un sistema de análisis de llamadas telefónicas para call centers que:

- Analiza métricas de rendimiento de llamadas IVR
- Genera reportes analíticos sobre tasa de abandono, tiempos de espera, eficiencia
- Configura alertas automáticas cuando las métricas exceden umbrales
- Gestiona permisos con modelo RBAC plano y segregación de funciones
- Audita todas las acciones del sistema de forma inmutable

**Contexto de negocio:**

Una empresa de call center necesita monitorear el rendimiento de su sistema 
IVR (Interactive Voice Response) para:

1. Identificar problemas de servicio rápidamente
2. Mejorar la experiencia del cliente
3. Optimizar la asignación de recursos (agentes, colas)
4. Cumplir con objetivos de nivel de servicio (SLA)

**Arquitectura técnica:**

El sistema IACT se compone de:

.. code-block:: text

   ┌─────────────────────────────────────────────────┐
   │  MySQL IVR (Sistema Operacional)                │
   │  - Base de datos del sistema telefónico         │
   │  - Acceso: READONLY para IACT (BR_001)          │
   │  - Contiene: llamadas, agentes, colas           │
   └─────────────────────────────────────────────────┘
                    ↓
           ETL Batch Nocturno (BR_002)
           Ejecuta cada día a las 02:00 AM
                    ↓
   ┌─────────────────────────────────────────────────┐
   │  PostgreSQL Analytics (Sistema Analítico)       │
   │  - Base de datos del sistema IACT               │
   │  - Acceso: READ/WRITE para IACT                 │
   │  - Optimizado para consultas analíticas         │
   └─────────────────────────────────────────────────┘
                    ↓
   ┌─────────────────────────────────────────────────┐
   │  Aplicación Web Django + React                  │
   │  - Dashboards y reportes                        │
   │  - Sistema de alertas                           │
   │  - Gestión de usuarios y permisos               │
   └─────────────────────────────────────────────────┘

**Restricciones arquitectónicas clave:**

- **CNST_003:** BD Dual - MySQL IVR readonly + PostgreSQL Analytics
- **CNST_004:** ETL nocturno (datos no son tiempo real)
- **CNST_001:** Solo notificaciones internas (NO email, SMS, webhook)

---

1.3.2 Los 8 Módulos Funcionales
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

El sistema IACT se divide en 8 módulos funcionales:

.. list-table:: Módulos del Sistema IACT
   :widths: 10 20 15 10 45
   :header-rows: 1

   * - Código
     - Nombre
     - Prefijo UC
     - # UC
     - Responsabilidad
   * - MOD_Auth
     - Autenticación
     - UC_AUTH_
     - 5
     - Login, logout, recuperación contraseña, 2FA
   * - MOD_Users
     - Gestión Usuarios
     - UC_USR_
     - 4
     - CRUD de usuarios, suspensión, activación
   * - MOD_Access
     - Control Acceso
     - UC_ACC_
     - 9
     - RBAC, permisos, agrupadores, SoD, segmentos
   * - MOD_Pipeline
     - Supervisión ETL
     - UC_PIP_
     - 4
     - Monitoreo ETL, errores, disponibilidad
   * - MOD_Reports
     - Reportería
     - UC_RPT_
     - 14
     - Dashboards, reportes, exportaciones, métricas
   * - MOD_Alerts
     - Sistema Alertas
     - UC_ALR_
     - 5
     - Configuración alertas, umbrales, suscripciones
   * - MOD_Audit
     - Auditoría
     - UC_AUD_
     - 4
     - Consulta auditoría, compliance, exportación
   * - MOD_Logs
     - Bitácoras
     - UC_LOG_
     - 4
     - Consulta logs técnicos, exportación

**Total:** 49 Casos de Uso, 23,401 líneas de documentación RST, 147 diagramas PlantUML

---

1.3.3 Artefactos Documentados
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

El proyecto IACT tiene los siguientes artefactos documentados:

**Requisitos:**

- 8 Business Requirements (BReq) - Objetivos de alto nivel
- 20 Business Rules (BR) - Reglas de negocio clasificadas en 5 tipos
- 49 Use Cases (UC) - Casos de uso completos con diagramas
- 55 Functional Requirements (FR) - En progreso (14% completado)

**Arquitectura:**

- 8 Módulos funcionales (MOD)
- 10 Restricciones arquitectónicas (CNST)
- Modelo RBAC v5.1.1 con 44 funciones atómicas y 10 agrupadores

**Gobernanza:**

- 6 Estándares (STD)
- 17 Templates (TPL)
- 38 Procedimientos (PROC)

---

1.3.4 Estadísticas del Proyecto
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: text

   CASOS DE USO (49 UC):
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   MOD_Auth       5 UC     3,251 líneas    (14%)
   MOD_Users      4 UC     2,584 líneas    (11%)
   MOD_Access     9 UC     4,180 líneas    (18%)
   MOD_Pipeline   4 UC     1,778 líneas    ( 8%)
   MOD_Reports   14 UC     5,288 líneas    (23%)
   MOD_Alerts     5 UC     2,565 líneas    (11%)
   MOD_Audit      4 UC     1,900 líneas    ( 8%)
   MOD_Logs       4 UC     1,855 líneas    ( 8%)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   TOTAL         49 UC    23,401 líneas   (100%)

   BUSINESS RULES (20 BR):
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Restricciones          10 BR   (50%)
   Desencadenadores        3 BR   (15%)
   Hechos                  3 BR   (15%)
   Inferencias             1 BR   ( 5%)
   Cálculos                3 BR   (15%)

   MODELO RBAC v5.1.1:
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Agrupadores (AGR)      10
   Funciones atómicas     44
   Reglas SoD              3

---

2. Ejemplo Introductorio: BR_011
=================================

Para ilustrar los conceptos de esta documentación, usaremos como ejemplo 
**BR_011: Límites de Exportación**.

Este ejemplo es ideal porque:

- Es una regla de negocio simple y fácil de entender
- Afecta a múltiples Casos de Uso (5 UC)
- Tiene umbrales numéricos claros
- Se integra con una restricción arquitectónica (CNST_007)
- Tiene implementación técnica concreta

---

2.1 Definición de BR_011
-------------------------

**BR_011: Límites de Exportación**

:Tipo: Restricción (Tipo 2)
:CNST Relacionado: CNST_007 (Performance)
:Módulo: MOD_Reports
:Prioridad: Alta
:Estado: Implementado

**Enunciado formal:**

  Las exportaciones de reportes tienen límites máximos por formato 
  para garantizar el rendimiento del sistema y evitar timeouts:
  
  - **Formato CSV:** Máximo 100,000 registros
  - **Formato Excel:** Máximo 50,000 registros  
  - **Formato PDF:** Máximo 10,000 registros
  
  Si un usuario intenta exportar más registros que el límite permitido 
  para el formato seleccionado, el sistema debe:
  
  1. Rechazar la operación
  2. Mostrar un mensaje de error indicando el límite excedido
  3. Sugerir filtrar los datos o usar un formato con límite mayor

**Justificación de negocio:**

Los límites se establecen por:

- **CSV (100k):** Tamaño archivo aprox 50 MB, tiempo generación ~30 segundos
- **Excel (50k):** Límite técnico Excel, compatibilidad con versiones antiguas
- **PDF (10k):** Rendering complejo, timeout de generación a los 60 segundos

---

2.2 Casos de Uso Afectados por BR_011
--------------------------------------

Esta regla de negocio impacta directamente a **5 Casos de Uso**:

2.2.1 UC_RPT_04: Exportar CSV
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Ubicación:** ``casos_uso_v4/reports/UC_RPT_04_Exportar_CSV.rst`` (489 líneas)

:Actor Principal: AGR_008 (agr_exportador)
:Función RBAC: RPT-004 (exporta_csv)
:Precondición: Verificar ``COUNT(registros) <= 100,000`` (BR_011)

**Flujo Normal - Paso de Validación:**

.. code-block:: text

   Paso 5: Sistema valida límite de exportación
   
   5.1 Sistema cuenta registros a exportar
   5.2 Sistema compara con límite CSV (100,000 - BR_011)
   5.3 SI count > 100,000:
       5.3.1 Sistema rechaza la exportación
       5.3.2 Sistema muestra mensaje de error (FA-2)
       5.3.3 UC termina sin exportar
   5.4 SI count <= 100,000:
       5.4.1 Sistema continúa con generación del archivo
       
**Flujo Alterno FA-2: Límite Excedido**

.. code-block:: text

   Condición: El usuario intenta exportar más de 100,000 registros
   
   2.1 Sistema calcula: count = 125,000 registros
   2.2 Sistema detecta: 125,000 > 100,000 (BR_011 violada)
   2.3 Sistema muestra mensaje:
       
       "ERROR: Límite de exportación excedido
       
        Formato:    CSV
        Límite:     100,000 registros
        Solicitado: 125,000 registros
        
        Sugerencias:
        - Aplique filtros para reducir el conjunto de datos
        - Use formato CSV en múltiples exportaciones
        - Contacte al administrador para exportación masiva
        
        (BR_011 - CNST_007)"
   
   2.4 UC termina sin exportar
   2.5 Sistema registra intento en UserActionLog (CNST_009)

---

2.2.2 UC_RPT_05: Exportar Excel
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Ubicación:** ``casos_uso_v4/reports/UC_RPT_05_Exportar_Excel.rst`` (450 líneas)

:Actor Principal: AGR_008 (agr_exportador)
:Función RBAC: RPT-005 (exporta_excel)
:Precondición: Verificar ``COUNT(registros) <= 50,000`` (BR_011)

**Diferencia con CSV:**

- Límite inferior (50k vs 100k) debido a complejidad formato Excel
- Validación idéntica pero con umbral diferente

---

2.2.3 UC_RPT_06: Exportar PDF
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Ubicación:** ``casos_uso_v4/reports/UC_RPT_06_Exportar_PDF.rst`` (427 líneas)

:Actor Principal: AGR_008 (agr_exportador)
:Función RBAC: RPT-006 (exporta_pdf)
:Precondición: Verificar ``COUNT(registros) <= 10,000`` (BR_011)

**Diferencia con otros formatos:**

- Límite más restrictivo (10k) por rendering complejo
- Timeout configurado a 60 segundos máximo

---

2.2.4 UC_AUD_03: Exportar Auditoría
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Ubicación:** ``casos_uso_v4/audit/UC_AUD_03_Exportar_Auditoria.rst`` (453 líneas)

:Actor Principal: AGR_006 (agr_auditor)
:Función RBAC: AUD-003 (exporta_auditoria)
:Aplicación BR_011: Mismos límites que reportes

**Nota:** Los registros de auditoría también están sujetos a los límites 
de exportación para mantener consistencia en el sistema.

---

2.2.5 UC_LOG_04: Exportar Logs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Ubicación:** ``casos_uso_v4/logs/UC_LOG_04_Exportar_Logs.rst`` (475 líneas)

:Actor Principal: AGR_010 (agr_soporte)
:Función RBAC: LOG-002 (exporta_logs)
:Aplicación BR_011: Mismos límites, principalmente CSV

---

2.3 Implementación Técnica de BR_011
-------------------------------------

La regla de negocio BR_011 se implementa en el servicio de exportación:

.. code-block:: python

   # services/reports/export_service.py
   
   class ExportService:
       """
       Servicio centralizado de exportación de datos.
       Implementa BR_011: Límites de Exportación.
       """
       
       # Límites definidos por BR_011 y CNST_007
       EXPORT_LIMITS = {
           'csv': 100_000,
           'excel': 50_000,
           'pdf': 10_000
       }
       
       def validate_export_limit(self, format: str, record_count: int):
           """
           Valida que el número de registros no exceda el límite 
           para el formato especificado.
           
           Args:
               format: Formato de exportación ('csv', 'excel', 'pdf')
               record_count: Número de registros a exportar
           
           Raises:
               ExportLimitExceededError: Si excede el límite (BR_011)
           """
           limit = self.EXPORT_LIMITS.get(format)
           
           if limit is None:
               raise ValueError(f"Formato inválido: {format}")
           
           if record_count > limit:
               raise ExportLimitExceededError(
                   format=format,
                   limit=limit,
                   requested=record_count,
                   br_code='BR_011',
                   cnst_code='CNST_007'
               )
       
       def export_to_csv(self, queryset, filename):
           """
           Exporta queryset a formato CSV respetando BR_011.
           """
           # Contar registros antes de exportar
           record_count = queryset.count()
           
           # Validar límite (BR_011)
           self.validate_export_limit('csv', record_count)
           
           # Proceder con exportación
           buffer = io.StringIO()
           writer = csv.writer(buffer)
           
           # Escribir headers
           headers = [field.name for field in queryset.model._meta.fields]
           writer.writerow(headers)
           
           # Escribir datos
           for record in queryset:
               row = [getattr(record, field) for field in headers]
               writer.writerow(row)
           
           # Registrar auditoría (CNST_009)
           UserActionLog.record(
               action='EXPORT_CSV',
               resource=filename,
               result='SUCCESS',
               details={
                   'record_count': record_count,
                   'format': 'csv',
                   'br_applied': 'BR_011'
               }
           )
           
           return buffer.getvalue()


   # exceptions.py
   
   class ExportLimitExceededError(Exception):
       """
       Excepción lanzada cuando se excede el límite de exportación (BR_011).
       """
       
       def __init__(self, format, limit, requested, br_code, cnst_code):
           self.format = format
           self.limit = limit
           self.requested = requested
           self.br_code = br_code
           self.cnst_code = cnst_code
           
           message = (
               f"Límite de exportación excedido\n"
               f"\n"
               f"Formato:     {format.upper()}\n"
               f"Límite:      {limit:,} registros\n"
               f"Solicitado:  {requested:,} registros\n"
               f"\n"
               f"Sugerencias:\n"
               f"- Aplique filtros para reducir el conjunto de datos\n"
               f"- Use múltiples exportaciones más pequeñas\n"
               f"- Contacte al administrador para exportación masiva\n"
               f"\n"
               f"({br_code} - {cnst_code})"
           )
           
           super().__init__(message)

---

2.4 Relación con CNST_007
--------------------------

BR_011 está estrechamente relacionada con **CNST_007: Límites de Exportación**.

**Diferencia entre BR y CNST:**

.. list-table::
   :widths: 30 35 35
   :header-rows: 1

   * - Aspecto
     - BR_011 (Business Rule)
     - CNST_007 (Constraint)
   * - **Naturaleza**
     - Regla de negocio
     - Restricción arquitectónica
   * - **Origen**
     - Requisitos de negocio
     - Requisitos no funcionales (performance)
   * - **Definición**
     - "Las exportaciones tienen límites"
     - "Límites técnicos del sistema"
   * - **Valores**
     - 100k CSV, 50k Excel, 10k PDF
     - Basado en capacidad del servidor
   * - **Puede cambiar**
     - Sí (decisión de negocio)
     - Difícil (requiere cambio infraestructura)
   * - **Documentado en**
     - BR_011 (reglas_negocio/)
     - CNST_007 (restricciones_arquitectonicas/)

**Relación:**

.. code-block:: text

   CNST_007 (Restricción Arquitectónica)
      "El servidor tiene capacidad limitada para 
       generar archivos grandes sin timeout"
         ↓ origina
   BR_011 (Regla de Negocio)
      "Las exportaciones tienen límites específicos 
       por formato para garantizar rendimiento"
         ↓ afecta
   UC_RPT_04, UC_RPT_05, UC_RPT_06, UC_AUD_03, UC_LOG_04
      "Los UC validan el límite antes de exportar"

---

2.5 Relación con Otras Business Rules
--------------------------------------

BR_011 trabaja en conjunto con otras BR del sistema:

2.5.1 BR_012: Usuario-Segmento Único
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Definición:** Cada usuario pertenece a exactamente 1 segmento de datos 
(por ejemplo, "Centro Lima", "Centro Bogotá", etc.)

**Relación con BR_011:**

El conteo de registros para validar BR_011 considera solo el segmento 
del usuario que exporta (BR_012).

**Ejemplo:**

.. code-block:: python

   # El queryset ya está filtrado por segmento (BR_012)
   queryset = Llamada.objects.filter(
       centro_id=request.user.segmento_id  # BR_012
   )
   
   # Contar registros del segmento del usuario
   record_count = queryset.count()
   
   # Validar límite (BR_011)
   if record_count > 100_000:
       raise ExportLimitExceededError(...)

**Escenario combinado:**

Un usuario AGR_008 del segmento "Centro Lima" intenta exportar 
llamadas del año 2024 en formato CSV:

1. Sistema aplica BR_012: Filtra solo registros de "Centro Lima"
   → Resultado: 80,000 registros
   
2. Sistema aplica BR_011: Valida 80,000 < 100,000
   → Resultado: APROBADO, procede con exportación

---

2.5.2 BR_019: Retención 2 Años
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Definición:** El sistema retiene datos históricos por máximo 2 años (730 días)

**Relación con BR_011:**

Los registros exportables están limitados a los últimos 2 años, 
lo que ayuda a mantener el conteo dentro de los límites de BR_011.

**Ejemplo:**

.. code-block:: python

   from datetime import timedelta
   
   # Filtrar por rango de retención (BR_019)
   two_years_ago = now() - timedelta(days=730)
   
   queryset = Llamada.objects.filter(
       fecha_llamada__gte=two_years_ago,  # BR_019
       centro_id=request.user.segmento_id  # BR_012
   )
   
   # Validar límite de exportación (BR_011)
   record_count = queryset.count()
   validate_export_limit('csv', record_count)

---

3. Jerarquía de Transformación
===============================

3.1 Del Requisito de Negocio a la Implementación
-------------------------------------------------

El siguiente diagrama muestra cómo se transforman los requisitos desde 
el nivel más alto hasta el código:

.. uml::
   :caption: Jerarquía de Transformación de Requisitos

   @startuml
   
   package "Nivel 1: Negocio" {
       [BReq_RPT\nReportería\nAnalítica] as breq
   }
   
   package "Nivel 2: Reglas" {
       [BR_011\nLímites\nExportación] as br
   }
   
   package "Nivel 3: Casos de Uso" {
       [UC_RPT_04\nExportar CSV] as uc1
       [UC_RPT_05\nExportar Excel] as uc2
       [UC_RPT_06\nExportar PDF] as uc3
   }
   
   package "Nivel 4: Requisitos Funcionales" {
       [RF_UCRPT_04_01\nValidar Límite CSV] as fr1
       [RF_UCRPT_04_02\nGenerar Archivo CSV] as fr2
   }
   
   package "Nivel 5: Implementación" {
       [ExportService\nvalidate_limit()] as code1
       [ExportService\nexport_to_csv()] as code2
   }
   
   breq --> br : "origina"
   br --> uc1 : "restringe"
   br --> uc2 : "restringe"
   br --> uc3 : "restringe"
   uc1 --> fr1 : "deriva"
   uc1 --> fr2 : "deriva"
   fr1 --> code1 : "implementa"
   fr2 --> code2 : "implementa"
   
   @enduml

**Explicación de cada nivel:**

1. **BReq (Business Requirement):** "El sistema debe proporcionar reportería analítica"
2. **BR (Business Rule):** "Las exportaciones tienen límites por formato"
3. **UC (Use Case):** "Exportar CSV respetando el límite de 100k registros"
4. **FR (Functional Requirement):** "Validar que count <= 100,000"
5. **CODE:** ``validate_export_limit('csv', record_count)``

---

3.2 Trazabilidad Bidireccional
-------------------------------

La trazabilidad permite navegar en ambas direcciones:

**Hacia adelante (Forward Tracing):**

.. code-block:: text

   BR_011
     ├─ afecta → UC_RPT_04 (Exportar CSV)
     │             ├─ deriva → RF_UCRPT_04_01 (Validar límite)
     │             │             └─ implementa → validate_export_limit()
     │             └─ deriva → RF_UCRPT_04_02 (Generar archivo)
     │                           └─ implementa → export_to_csv()
     │
     ├─ afecta → UC_RPT_05 (Exportar Excel)
     ├─ afecta → UC_RPT_06 (Exportar PDF)
     ├─ afecta → UC_AUD_03 (Exportar Auditoría)
     └─ afecta → UC_LOG_04 (Exportar Logs)

**Hacia atrás (Backward Tracing):**

.. code-block:: text

   ExportService.validate_export_limit()
     └─ implementa → RF_UCRPT_04_01
                       └─ deriva de → UC_RPT_04
                                        └─ restringe → BR_011
                                                         └─ origina → BReq_RPT

---

4. Próximos Pasos
=================

Esta introducción ha establecido:

✓ El contexto del Sistema IACT (8 módulos, 49 UC, 20 BR)
✓ La estructura de la documentación base_cognitiva/
✓ Un ejemplo completo de Business Rule (BR_011)
✓ La relación entre BR, UC, FR y código
✓ La jerarquía de transformación de requisitos

**Continúa en:**

- **FND_01_Identidad_Estrategica.rst:** Fundamentos conceptuales
- **FND_03_Taxonomia_BR.rst:** Los 5 tipos de Business Rules
- **TXM_01_Nomenclatura_UC_FR.rst:** Ejemplos completos de transformación

**Documentos de referencia del proyecto:**

- ``casos_uso_v4/reports/UC_RPT_04_Exportar_CSV.rst``
- ``reglas_negocio/BR_011_Limites_Exportacion.rst``
- ``restricciones_arquitectonicas/CNST_007_Limites_Exportacion.rst``

---

.. note::
   
   **Nota pedagógica:**
   
   Este documento usa el Sistema IACT como caso de estudio real. 
   Todos los UC, BR y ejemplos de código corresponden a la 
   implementación real del proyecto documentado en:
   
   - 49 Casos de Uso (23,401 líneas RST)
   - 20 Business Rules clasificadas
   - 147 Diagramas PlantUML
   - Código Python/SQL funcional

---

**Historial de Versiones**

.. list-table::
   :widths: 15 15 70
   :header-rows: 1

   * - Versión
     - Fecha
     - Cambios
   * - 1.0.0
     - 2026-01-08
     - Versión inicial con dominio IACT. Reemplaza ejemplos de 
       productos químicos con Sistema IVR Analytics real.
