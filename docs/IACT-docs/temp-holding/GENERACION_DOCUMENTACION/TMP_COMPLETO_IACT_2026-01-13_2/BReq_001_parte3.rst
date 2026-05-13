
----

3.5 BReq-005: Integridad de Datos Operacionales
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Enunciado Formal**

El sistema DEBE garantizar que los datos operacionales del IVR permanezcan
inalterados, accediendo a la base de datos IVR exclusivamente en modo
lectura.

**Metrica de Exito**

::

   0 operaciones de escritura en base IVR
   100% de accesos via Database Router validado
   Verificacion continua mediante logs de BD

**Justificacion**

La base IVR es un sistema legacy critico que alimenta multiples aplicaciones.
Cualquier modificacion accidental comprometeria operaciones del call center
y otros sistemas dependientes.

**BR que Influyen**

.. list-table::
   :header-rows: 1
   :widths: 15 35 50

   * - BR
     - Nombre
     - Como Influye
   * - BR_001
     - Fuente Operacional Inmutable
     - Define restriccion de solo lectura

**UC que Genera**

.. list-table::
   :header-rows: 1
   :widths: 15 35 50

   * - UC
     - Nombre
     - Relacion
   * - UC-050
     - Supervisar Estado ETL
     - Monitoreo extraccion (solo lectura)
   * - UC-051
     - Consultar Errores ETL
     - Diagnostico sin modificar origen
   * - UC-052
     - Consultar Disponibilidad Datos
     - Verificar sin alterar
   * - UC-053
     - Reiniciar Proceso ETL
     - Re-extraccion (solo lectura)

----

4. Matriz de Trazabilidad
-------------------------

4.1 Trazabilidad BReq -> UC (Generacion)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   BReq-001 (Visibilidad)    --genera--> UC-025 a UC-030 (Dashboard)
                                         UC-050 a UC-053 (Pipeline)
                                         Total: 10 UC

   BReq-002 (Incidentes)     --genera--> UC-036 a UC-040 (Alertas)
                                         Total: 5 UC

   BReq-003 (Decisiones)     --genera--> UC-017 a UC-024 (Reportes)
                                         Total: 8 UC

   BReq-004 (Cumplimiento)   --genera--> UC-001 a UC-005 (Auth)
                                         UC-010, UC-011, UC-041-047 (Access)
                                         UC-060 a UC-063 (Audit)
                                         UC-070 a UC-073 (Logs)
                                         Total: 22 UC

   BReq-005 (Integridad)     --genera--> UC-050 a UC-053 (Pipeline)
                                         Total: 4 UC (compartidos con BReq-001)

4.2 Trazabilidad BR -> BReq (Influencia)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 50 50

   * - Business Rule
     - BReq Influenciados
   * - BR_001 Fuente Operacional Inmutable
     - BReq-005
   * - BR_002 ETL Batch Nocturno
     - BReq-001
   * - BR_003 Usuario Inactivo 90 Dias
     - BReq-004
   * - BR_004 Comunicaciones Internas Only
     - BReq-004
   * - BR_005 Sesion Unica por Usuario
     - BReq-004
   * - BR_006 RBAC Flat NIST
     - BReq-004
   * - BR_007 Separacion Funciones SoD
     - BReq-004
   * - BR_008 Auditoria de Accesos
     - BReq-004
   * - BR_009 Bajas Logicas
     - BReq-004
   * - BR_010 Auditoria Inmutable
     - BReq-004
   * - BR_011 Limites de Exportacion
     - BReq-003
   * - BR_012 Segmentacion Usuario-Centro
     - BReq-003
   * - BR_013 Username Unico
     - BReq-004
   * - BR_014 Alerta por Umbral
     - BReq-002
   * - BR_015 Bloqueo Intentos Fallidos
     - BReq-004
   * - BR_016 Tasa de Abandono
     - BReq-001
   * - BR_017 Tiempo Promedio Espera
     - BReq-001
   * - BR_018 Retencion de Logs
     - BReq-004
   * - BR_019 Clasificacion de Datos
     - BReq-004
   * - BR_020 Rango Temporal Reportes
     - BReq-003

4.3 Resumen de Cobertura
^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 25 25 25 25

   * - Metrica
     - Valor
     - Total
     - Cobertura
   * - BReq con UC
     - 5
     - 5
     - 100%
   * - BR con BReq
     - 20
     - 20
     - 100%
   * - UC generados
     - 49
     - 49
     - 100%

----

5. Criterios de Exito del Proyecto
----------------------------------

5.1 KPIs Agregados
^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 30 40 30

   * - KPI
     - Meta
     - Frecuencia Medicion
   * - Disponibilidad Dashboard
     - >= 99.5%
     - Mensual
   * - Reduccion Tiempo Incidentes
     - >= 40%
     - Trimestral
   * - Decisiones con Datos
     - 100%
     - Mensual
   * - Incidentes Seguridad
     - 0
     - Continua
   * - Escrituras en IVR
     - 0
     - Continua

5.2 Criterios de Aceptacion del Proyecto
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El proyecto IACT se considera exitoso cuando:

1. Dashboard operativo disponible con metricas actualizadas D+1
2. Sistema de alertas funcional con al menos 5 umbrales configurados
3. Reportes exportables en 3 formatos (CSV, Excel, PDF)
4. Modelo RBAC implementado con 44 funciones y 10 agrupadores
5. Auditoria completa de todos los accesos
6. Cero escrituras detectadas en base IVR

----

6. Referencias
--------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- **FND_05**: Jerarquia de 4 Niveles - Define estructura BR -> BReq -> UC -> FR
- **META_04**: Contexto del Proyecto - Describe ambiente operacional
- **reglas_negocio/**: 20 BR documentadas que influyen en estos BReq
- **MODELO_RBAC_IACT_v5.1.1**: Modelo de control de acceso
- **CNST_001 a CNST_010**: Restricciones tecnicas que originan las BR

Fuentes de Requisitos
^^^^^^^^^^^^^^^^^^^^^

- Entrevistas con supervisores de call center
- Analisis de sistema IVR legacy
- Politicas de seguridad organizacionales
- CNST del cliente (restricciones no negociables)

----

7. Historial de Cambios
-----------------------

.. list-table::
   :widths: 15 15 20 50
   :header-rows: 1

   * - Version
     - Fecha
     - Autor
     - Descripcion del Cambio
   * - 1.0.0
     - 2026-01-06
     - Equipo IACT
     - Version inicial con 5 BReq documentados

----

*Documento BReq_001 - Proyecto IACT Dashboard Analytics v2.0.7*
