
----

3.3 BReq-003: Decisiones Informadas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Enunciado Formal**

El sistema DEBE proporcionar reportes y analisis que permitan a los
tomadores de decision basar sus acciones en datos concretos y actualizados.

**Metrica de Exito**

::

   100% de decisiones operacionales documentadas con datos de soporte
   Reportes disponibles en formatos exportables (CSV, Excel, PDF)
   Tiempo de generacion de reporte: < 30 segundos

**Justificacion**

Decisiones basadas en intuicion o datos desactualizados resultan en
asignacion ineficiente de recursos y oportunidades perdidas.

**BR que Influyen**

.. list-table::
   :header-rows: 1
   :widths: 15 35 50

   * - BR
     - Nombre
     - Como Influye
   * - BR_011
     - Limites de Exportacion
     - Define volumenes maximos exportables
   * - BR_012
     - Segmentacion Usuario-Centro
     - Define alcance de datos por usuario
   * - BR_020
     - Rango Temporal Reportes
     - Define ventana maxima de consulta

**UC que Genera**

.. list-table::
   :header-rows: 1
   :widths: 15 35 50

   * - UC
     - Nombre
     - Relacion
   * - UC-017
     - Generar Reporte Predefinido
     - Reportes estandar
   * - UC-018
     - Crear Reporte Personalizado
     - Reportes ad-hoc
   * - UC-019
     - Programar Reporte Automatico
     - Generacion periodica
   * - UC-020
     - Filtrar Reportes por Fecha
     - Seleccion temporal
   * - UC-021
     - Filtrar Reportes por Centro
     - Seleccion geografica
   * - UC-022
     - Exportar Reporte CSV
     - Formato tabular
   * - UC-023
     - Exportar Reporte Excel
     - Formato enriquecido
   * - UC-024
     - Exportar Reporte PDF
     - Formato presentacion

----

3.4 BReq-004: Cumplimiento de Seguridad
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Enunciado Formal**

El sistema DEBE garantizar que solo usuarios autorizados accedan a los
datos y funcionalidades segun sus permisos asignados, cumpliendo con
politicas de seguridad organizacionales.

**Metrica de Exito**

::

   0 accesos no autorizados detectados
   100% de accesos registrados en auditoria
   Cumplimiento RBAC NIST verificable
   0 violaciones de SoD

**Justificacion**

Datos del call center incluyen informacion sensible de operaciones.
Acceso no autorizado representa riesgo regulatorio y de negocio.

**BR que Influyen**

.. list-table::
   :header-rows: 1
   :widths: 15 35 50

   * - BR
     - Nombre
     - Como Influye
   * - BR_004
     - Comunicaciones Internas Only
     - Limita canales de notificacion
   * - BR_005
     - Sesion Unica por Usuario
     - Previene acceso concurrente
   * - BR_006
     - RBAC Flat NIST
     - Define modelo de permisos
   * - BR_007
     - Separacion Funciones SoD
     - Previene conflictos de interes
   * - BR_008
     - Auditoria de Accesos
     - Registra toda actividad
   * - BR_009
     - Bajas Logicas
     - Preserva trazabilidad
   * - BR_010
     - Auditoria Inmutable
     - Protege evidencia
   * - BR_013
     - Username Unico
     - Garantiza identificacion
   * - BR_015
     - Bloqueo Intentos Fallidos
     - Previene fuerza bruta
   * - BR_018
     - Retencion de Logs
     - Cumple retencion legal
   * - BR_019
     - Clasificacion de Datos
     - Define niveles de proteccion

**UC que Genera**

.. list-table::
   :header-rows: 1
   :widths: 15 35 50

   * - UC
     - Nombre
     - Relacion
   * - UC-001
     - Iniciar Sesion
     - Autenticacion
   * - UC-002
     - Cerrar Sesion
     - Terminacion segura
   * - UC-003
     - Recuperar Password
     - Restablecimiento seguro
   * - UC-004
     - Cambiar Password Propio
     - Gestion credenciales
   * - UC-005
     - Gestionar Sesiones Activas
     - Control de acceso
   * - UC-010
     - Asignar Funciones a Usuario
     - Permisos
   * - UC-011
     - Revocar Funciones a Usuario
     - Desautorizacion
   * - UC-041
     - Asignar Segmento de Datos
     - Alcance de datos
   * - UC-042
     - Revocar Segmento de Datos
     - Restriccion
   * - UC-043
     - Configurar Restricciones SoD
     - Segregacion
   * - UC-044
     - Consultar Permisos Efectivos
     - Verificacion
   * - UC-045
     - Gestionar Catalogo Agrupadores
     - Administracion RBAC
   * - UC-046
     - Gestionar Catalogo Funciones
     - Administracion RBAC
   * - UC-047
     - Auditar Cambios de Permisos
     - Trazabilidad
   * - UC-060
     - Registrar Evento Auditoria
     - Logging
   * - UC-061
     - Consultar Log Auditoria
     - Revision
   * - UC-062
     - Generar Reporte Auditoria
     - Evidencia
   * - UC-063
     - Exportar Auditoria
     - Archivo
   * - UC-070
     - Consultar Logs Sistema
     - Diagnostico
   * - UC-071
     - Filtrar Logs por Criterio
     - Busqueda
   * - UC-072
     - Exportar Logs Sistema
     - Archivo tecnico
   * - UC-073
     - Configurar Retencion Logs
     - Politica
