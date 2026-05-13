.. meta::
   :artefacto: BR_011
   :tipo: Regla de Negocio
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :ultimo_cambio: 2026-01-07
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-011:

==============================
BR_011: Límites de Exportación
==============================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BR_011
   * - **Nombre**
     - Límites de Exportación
   * - **Tipo**
     - Restricción
   * - **Categoría**
     - Operacional / Rendimiento
   * - **Criticidad**
     - Alta
   * - **Estado**
     - Vigente

----

1. Definición Formal
--------------------

1.1 Enunciado de la Regla
^^^^^^^^^^^^^^^^^^^^^^^^^

.. note:: **Regla de Negocio BR_011**

   El sistema IACT DEBE limitar las exportaciones de datos a un máximo de
   100,000 registros por operación. Exportaciones que excedan este límite
   DEBEN ser rechazadas con mensaje informativo al usuario.

1.2 Formulación SBVR
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   VOCABULARIO:
     - exportacion: Operación que genera archivo CSV, Excel o PDF con datos
     - limite_registros: 100,000 registros máximo por exportación
     - usuario: Actor que solicita la exportación
     - mensaje_limite: Notificación cuando se excede el límite

   REGLA:
     Es OBLIGATORIO que toda exportacion contenga como MAXIMO 100,000 registros.
     
     Es OBLIGATORIO que el sistema rechace exportaciones que excedan
     limite_registros y muestre mensaje_limite al usuario.
     
     Es RECOMENDADO que el sistema sugiera aplicar filtros para reducir
     el volumen de datos cuando se aproxime al límite.

1.3 Justificación
^^^^^^^^^^^^^^^^^

Los límites de exportación protegen:

- **Rendimiento del servidor**: Evita sobrecarga por generación de archivos masivos
- **Experiencia de usuario**: Previene timeouts y esperas excesivas
- **Recursos del sistema**: Controla uso de memoria y CPU
- **Estabilidad**: Evita que una exportación afecte a otros usuarios
- **Almacenamiento**: Previene generación de archivos de tamaño excesivo

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
     - [X] **Restricción**: Limita volumen de datos en exportaciones

2.2 Naturaleza
^^^^^^^^^^^^^^

- **Estática/Dinámica**: Estática - límite fijo del sistema
- **Automatizable**: Sí - validación previa a exportación
- **Alcance**: Todos los módulos con funcionalidad de exportación

----

3. Origen y Autoridad
---------------------

3.1 Fuente Primaria
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Documento**
     - CNST_007_Limites_Performance_SLA.rst
   * - **Sección**
     - Límites de Exportación
   * - **Versión**
     - 1.0.0
   * - **Tipo Fuente**
     - CNST (Restricción Técnica de Performance)

3.2 Autoridad de Modificación
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Responsable**: Arquitecto de Solución
- **Proceso de Cambio**: Requiere análisis de impacto en performance
- **Frecuencia de Revisión**: Semestral o ante cambios de infraestructura

----

4. Aplicación en Sistema
------------------------

4.1 Donde Aplica
^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Componente
     - Descripción de Aplicación
   * - UC_RPT_10
     - Exportar CSV - Valida límite antes de generar
   * - UC_RPT_11
     - Exportar Excel - Valida límite antes de generar
   * - UC_RPT_12
     - Exportar PDF - Valida límite antes de generar
   * - UC_AUD_03
     - Exportar Auditoría - Aplica mismo límite
   * - UC_LOG_03
     - Exportar Logs - Aplica mismo límite

4.2 Actores Afectados
^^^^^^^^^^^^^^^^^^^^^

- **Roles**: agr_analista, agr_exportador, agr_auditor, agr_superadmin
- **Impacto**: Deben aplicar filtros si requieren más de 100,000 registros

4.3 Excepciones
^^^^^^^^^^^^^^^

- Exportaciones programadas (batch) pueden dividirse en múltiples archivos
- Administrador puede solicitar exportación especial vía proceso manual

----

5. Trazabilidad
---------------

5.1 Restricciones Origen (CNST)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - CNST
     - Relación
   * - CNST_007
     - Define límites de performance incluyendo exportaciones

5.2 Casos de Uso Afectados (UC)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - UC
     - Donde Aplica
   * - UC_RPT_10
     - Validación previa en exportación CSV
   * - UC_RPT_11
     - Validación previa en exportación Excel
   * - UC_RPT_12
     - Validación previa en exportación PDF
   * - UC_AUD_03
     - Validación previa en exportación auditoría
   * - UC_LOG_03
     - Validación previa en exportación logs

----

6. Verificación
---------------

6.1 Criterios de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La regla se considera cumplida cuando:

1. Toda exportación valida cantidad de registros antes de procesar
2. Exportaciones >100,000 registros son rechazadas
3. Usuario recibe mensaje claro indicando el límite
4. Sistema sugiere aplicar filtros para reducir volumen
5. Logs registran intentos de exportación que exceden límite

6.2 Método de Verificación
^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Tipo**: Automatizado
- **Frecuencia**: Cada exportación
- **Responsable**: Servicio de Exportación

6.3 Consecuencias de Incumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Degradación de performance del servidor
- Timeouts en solicitudes de otros usuarios
- Posible caída del servicio por agotamiento de recursos
- Archivos corruptos o incompletos

----

7. Implementación Técnica
-------------------------

7.1 Validador de Exportación
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # apps/reports/services/export_service.py
   
   class ExportService:
                                                     
       Servicio de exportación que implementa BR_011.
                                                     
       
       MAX_EXPORT_RECORDS = 100_000  # BR_011: Límite de exportación
       
       def validate_export_size(self, queryset) -> tuple[bool, str]:
                                                                    
           Valida que el queryset no exceda el límite de exportación.
           
           Returns:
               tuple: (es_valido, mensaje)
                                          
           count = queryset.count()
           
           if count > self.MAX_EXPORT_RECORDS:
               return False, (
                   f"BR_011: La exportación contiene {count:,} registros. "
                   f"El límite máximo es {self.MAX_EXPORT_RECORDS:,}. "
                   f"Por favor, aplique filtros para reducir el volumen."
               )
           
           if count > self.MAX_EXPORT_RECORDS * 0.8:  # 80% del límite
               logger.warning(
                   f"Exportación cercana al límite: {count:,} registros"
               )
           
           return True, f"Exportación válida: {count:,} registros"
       
       def export_csv(self, queryset, filename: str):
           """Exporta datos a CSV respetando BR_011."""
           is_valid, message = self.validate_export_size(queryset)
           
           if not is_valid:
               raise ExportLimitExceeded(message)
           
           # Proceder con exportación...

7.2 Respuesta API
^^^^^^^^^^^^^^^^^

.. code-block:: python

   # Respuesta cuando se excede el límite
   
   {
       "error": "EXPORT_LIMIT_EXCEEDED",
       "code": "BR_011",
       "message": "La exportación contiene 150,000 registros. El límite máximo es 100,000.",
       "suggestion": "Aplique filtros de fecha o centro para reducir el volumen.",
       "current_count": 150000,
       "max_allowed": 100000
   }

----

8. Historial de Cambios
-----------------------

.. list-table::
   :widths: 15 15 20 50
   :header-rows: 1

   * - Versión
     - Fecha
     - Autor
     - Descripción del Cambio
   * - 1.0.0
     - 2026-01-07
     - Equipo IACT
     - Versión inicial derivada de CNST_007

----

Referencias
-----------

- CNST_007: Límites de Performance y SLA
- FND_02: Reglas de Negocio
- UC_RPT_10, UC_RPT_11, UC_RPT_12: Casos de uso de exportación

----

*Documento versión 1.0.0 - Proyecto IACT Dashboard Analytics*
