.. meta::
   :artefacto: BReq_004
   :tipo: Business Requirement
   :dominio: requisitos
   :subdominio: objetivos
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-06
   :autor: Equipo IACT

.. _breq-004:

=======================================================
BReq_004: Cumplimiento de Seguridad y Control de Acceso
=======================================================


Resumen
-------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BReq-004
   * - **Nombre**
     - Cumplimiento de Seguridad y Control de Acceso
   * - **Categoria**
     - Seguridad y Compliance
   * - **Prioridad**
     - Critica
   * - **Estado**
     - Aprobado

----

1. Enunciado Formal
-------------------

El sistema DEBE garantizar que solo usuarios autorizados accedan a los
datos y funcionalidades segun sus permisos asignados, cumpliendo con
politicas de seguridad organizacionales y estandares NIST RBAC.

----

2. Metrica de Exito
-------------------

::

   Indicadores:
   - Accesos no autorizados detectados: 0
   - Porcentaje de accesos auditados: 100%
   - Violaciones de SoD: 0
   - Cumplimiento RBAC NIST: Verificable

   Frecuencia de medicion: Continua (monitoreo automatico)

----

3. Justificacion
----------------

Los datos del call center incluyen informacion sensible de operaciones.
El acceso no autorizado representa:

- Riesgo regulatorio (cumplimiento de datos)
- Riesgo de negocio (fuga de informacion)
- Riesgo reputacional
- Potencial de fraude interno

Un sistema de control de acceso robusto basado en RBAC:

- Garantiza principio de minimo privilegio
- Permite auditoria completa
- Previene conflictos de interes (SoD)
- Facilita cumplimiento normativo

----

4. BR que Influyen
------------------

.. list-table::
   :widths: 15 35 50
   :header-rows: 1

   * - BR
     - Nombre
     - Como Influye
   * - BR_004
     - Comunicaciones Internas Only
     - Limita canales, reduce superficie de ataque
   * - BR_005
     - Sesion Unica por Usuario
     - Previene acceso concurrente/compartido
   * - BR_006
     - RBAC Flat NIST
     - Define modelo de permisos estandar
   * - BR_007
     - Separacion Funciones SoD
     - Previene conflictos de interes
   * - BR_008
     - Auditoria de Accesos
     - Registra toda actividad para revision
   * - BR_009
     - Bajas Logicas
     - Preserva trazabilidad historica
   * - BR_010
     - Auditoria Inmutable
     - Protege evidencia de manipulacion
   * - BR_013
     - Username Unico
     - Garantiza identificacion univoca
   * - BR_015
     - Bloqueo Intentos Fallidos
     - Previene ataques de fuerza bruta
   * - BR_018
     - Retencion de Logs
     - Cumple requerimientos legales
   * - BR_019
     - Clasificacion de Datos
     - Define niveles de proteccion

----

5. UC que Genera
----------------

**Autenticacion (MOD_Auth):**

- UC-001: Iniciar Sesion
- UC-002: Cerrar Sesion
- UC-003: Recuperar Password
- UC-004: Cambiar Password Propio
- UC-005: Gestionar Sesiones Activas

**Control de Acceso (MOD_Access):**

- UC-010: Asignar Funciones a Usuario
- UC-011: Revocar Funciones a Usuario
- UC-041: Asignar Segmento de Datos
- UC-042: Revocar Segmento de Datos
- UC-043: Configurar Restricciones SoD
- UC-044: Consultar Permisos Efectivos
- UC-045: Gestionar Catalogo de Agrupadores
- UC-046: Gestionar Catalogo de Funciones
- UC-047: Auditar Cambios de Permisos

**Auditoria (MOD_Audit):**

- UC-060: Registrar Evento de Auditoria
- UC-061: Consultar Log de Auditoria
- UC-062: Generar Reporte de Auditoria
- UC-063: Exportar Auditoria

**Logs (MOD_Logs):**

- UC-070: Consultar Logs del Sistema
- UC-071: Filtrar Logs por Criterio
- UC-072: Exportar Logs del Sistema
- UC-073: Configurar Retencion de Logs

----

6. Criterios de Aceptacion
--------------------------

1. Modelo RBAC con 44 funciones atomicas implementado
2. 10 Agrupadores configurados
3. 3 Restricciones SoD activas y validadas
4. 100% de operaciones registradas en auditoria
5. Logs inmutables (sin UPDATE/DELETE)
6. Retencion de auditoria >= 2 anos
7. Bloqueo automatico tras 5 intentos fallidos

----

7. Stakeholders
---------------

- **Sponsor**: CISO / Gerencia de TI
- **Beneficiarios**: Toda la organizacion
- **Usuarios**: AGR-007 auditor, AGR-008 admin_seguridad

----

8. Historial de Cambios
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
     - Version inicial
