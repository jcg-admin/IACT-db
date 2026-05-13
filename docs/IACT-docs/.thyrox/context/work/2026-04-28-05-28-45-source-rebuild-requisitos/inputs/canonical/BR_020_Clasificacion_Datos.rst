.. meta::
   :artefacto: BR_020
   :tipo: Regla de Negocio
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :ultimo_cambio: 2026-01-07
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-020:

==============================
BR_020: Clasificación de Datos
==============================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BR_020
   * - **Nombre**
     - Clasificación de Datos
   * - **Tipo**
     - Restricción
   * - **Categoría**
     - Seguridad / Protección de Datos
   * - **Criticidad**
     - Crítica
   * - **Estado**
     - Vigente

----

1. Definición Formal
--------------------

1.1 Enunciado de la Regla
^^^^^^^^^^^^^^^^^^^^^^^^^

.. note:: **Regla de Negocio BR_020**

   Todos los datos del sistema IACT DEBEN estar clasificados según su nivel
   de sensibilidad (Público, Interno, Confidencial, Restringido) y tratados
   de acuerdo a los controles de protección correspondientes a su clasificación.

1.2 Formulación SBVR
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   VOCABULARIO:
     - dato: Cualquier información almacenada en el sistema
     - clasificacion: Nivel de sensibilidad asignado
     - control_proteccion: Medidas de seguridad según clasificación

   NIVELES DE CLASIFICACIÓN:
     - PUBLICO: Sin restricciones de acceso
     - INTERNO: Acceso solo usuarios autenticados
     - CONFIDENCIAL: Acceso restringido por rol
     - RESTRINGIDO: Acceso mínimo necesario + auditoría

   REGLA:
     Es OBLIGATORIO que todo dato tenga una clasificacion asignada.
     
     Es OBLIGATORIO que el acceso a datos respete los controles
     definidos para su clasificación.
     
     Es OBLIGATORIO auditar acceso a datos CONFIDENCIAL y RESTRINGIDO.

1.3 Justificación
^^^^^^^^^^^^^^^^^

La clasificación de datos garantiza:

- **Protección adecuada**: Controles proporcionales al riesgo
- **Cumplimiento normativo**: Requisito de marcos de seguridad
- **Minimización de exposición**: Acceso basado en necesidad
- **Auditoría**: Trazabilidad de acceso a datos sensibles
- **Gestión de riesgos**: Identificación clara de activos críticos

----

2. Clasificación
----------------

2.1 Tipo de Regla
^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 0

   * - **Tipo**
     - **Restricción**
   * - 
     - [X] **Restricción**: Define controles obligatorios por clasificación

2.2 Naturaleza
^^^^^^^^^^^^^^

- **Estática/Dinámica**: Estática - política de seguridad fija
- **Automatizable**: Parcialmente - algunos controles manuales
- **Alcance**: Todo el sistema

----

3. Niveles de Clasificación
---------------------------

3.1 Matriz de Clasificación
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 15 25 30 30
   :header-rows: 1

   * - Nivel
     - Descripción
     - Ejemplos IACT
     - Controles
   * - **PÚBLICO**
     - Sin impacto si se divulga
     - Nombres de centros, menús IVR
     - Ninguno especial
   * - **INTERNO**
     - Uso interno de la organización
     - Métricas agregadas, reportes
     - Autenticación requerida
   * - **CONFIDENCIAL**
     - Impacto si se divulga
     - Datos de usuarios, logs detallados
     - RBAC + Auditoría
   * - **RESTRINGIDO**
     - Alto impacto, regulado
     - Contraseñas (hash), tokens
     - Cifrado + RBAC + Auditoría

3.2 Clasificación por Entidad
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 30 20 50
   :header-rows: 1

   * - Entidad/Dato
     - Clasificación
     - Justificación
   * - Nombres de centros
     - PÚBLICO
     - Información organizacional básica
   * - Métricas agregadas
     - INTERNO
     - KPIs de negocio
   * - Datos de llamadas
     - INTERNO
     - Operacionales sin PII
   * - Username/Email
     - CONFIDENCIAL
     - Datos de usuario
   * - Logs de auditoría
     - CONFIDENCIAL
     - Acciones de usuarios
   * - Hash de contraseña
     - RESTRINGIDO
     - Credencial de acceso
   * - Tokens JWT
     - RESTRINGIDO
     - Credencial de sesión

----

4. Aplicación en Sistema
------------------------

4.1 Controles por Clasificación
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**PÚBLICO:**

- Sin restricciones de API
- Puede aparecer en logs sin sanitizar

**INTERNO:**

- Requiere autenticación JWT válida
- Filtrado por segmento (BR_012)

**CONFIDENCIAL:**

- Requiere función RBAC específica
- Acceso auditado (BR_010)
- No aparece en logs de error

**RESTRINGIDO:**

- Cifrado en reposo y tránsito
- Acceso mínimo necesario
- Auditoría detallada obligatoria
- Sanitización en logs

4.2 Donde Aplica
^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Componente
     - Aplicación
   * - Modelos Django
     - Anotación de clasificación en campos
   * - Serializers
     - Exclusión de campos según rol
   * - Logs
     - Sanitización de datos sensibles
   * - APIs
     - Validación de permisos por clasificación
   * - Exportación
     - Restricción según clasificación

----

5. Implementación Técnica
-------------------------

5.1 Decorador de Clasificación
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # apps/core/security/classification.py
   
   from enum import Enum
   
   class DataClassification(Enum):
       """BR_020: Niveles de clasificación de datos."""
       PUBLIC = 'PUBLIC'
       INTERNAL = 'INTERNAL'
       CONFIDENTIAL = 'CONFIDENTIAL'
       RESTRICTED = 'RESTRICTED'
   
   def classified(level: DataClassification):
                                                               
       Decorador que marca campos/métodos con su clasificación.
                                                               
       def decorator(func_or_field):
           func_or_field._classification = level
           return func_or_field
       return decorator

5.2 Modelo con Clasificación
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # apps/users/models.py
   
   class User(AbstractBaseUser):
       # CONFIDENCIAL - Datos de usuario
       username = models.CharField(max_length=150, unique=True)
       email = models.EmailField()
       
       # RESTRINGIDO - Credenciales
       password = models.CharField(max_length=128)  # Hash
       
       # INTERNO - Metadatos
       created_at = models.DateTimeField(auto_now_add=True)
       
       class Meta:
           # BR_020: Clasificación de la entidad
           classification = DataClassification.CONFIDENTIAL

5.3 Sanitización en Logs
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # apps/core/logging/sanitizer.py
   
   SENSITIVE_FIELDS = [
       'password', 'token', 'secret', 'api_key',
       'email', 'phone', 'ssn'
   ]
   
   def sanitize_log_data(data: dict) -> dict:
                                                         
       BR_020: Sanitiza datos sensibles antes de loguear.
                                                         
       sanitized = data.copy()
       for key in sanitized:
           if any(field in key.lower() for field in SENSITIVE_FIELDS):
               sanitized[key] = '***REDACTED***'
       return sanitized

----

6. Trazabilidad
---------------

- **Origen**: CNST_010 (Clasificación y Protección de Datos)
- **UC Relacionados**: Todos (aplica transversalmente)
- **BR Relacionadas**: BR_010 (Auditoría), BR_012 (Segmentación)
- **CNST**: CNST_010

----

7. Verificación
---------------

7.1 Criterios de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Todas las entidades tienen clasificación documentada
2. Campos sensibles están marcados apropiadamente
3. Logs no contienen datos RESTRINGIDOS sin sanitizar
4. APIs validan permisos según clasificación
5. Exportaciones respetan clasificación

----

8. Historial de Cambios
-----------------------

.. list-table::
   :widths: 15 15 70
   :header-rows: 1

   * - Versión
     - Fecha
     - Descripción del Cambio
   * - 1.0.0
     - 2026-01-07
     - Versión inicial derivada de CNST_010

----

*Documento versión 1.0.0 - Proyecto IACT Dashboard Analytics*
