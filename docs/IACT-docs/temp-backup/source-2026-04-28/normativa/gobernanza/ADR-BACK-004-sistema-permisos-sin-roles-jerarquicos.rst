ADR-012: Sistema de Permisos Granular SIN Roles Jerarquicos
===========================================================

**Estado:** Aceptado **Fecha:** 2025-11-07 **Decidido por:** Arquitecto
Senior, Tech Lead **Relevancia:** Prioridad 1 - CRITICA

--------------

Contexto
--------

LA DEFINICION ESTA CORRECTA, SIN EMBARGO PARA UNA MAYOR TRAZABILIDAD SE
REQUIERE QUE SE DOCUMENTE UNA MATRIZ RACI, EN DONDE SE IDENTIFIQUE MAS
FACIL LAS FUNCIONES ACTIVAS DEL SISTEMA.

El sistema IACT requiere un sistema de permisos que controle el acceso a
recursos y acciones. Tradicionalmente, los sistemas usan roles
jerarquicos (Admin, Supervisor, Agent) con permisos heredados. Sin
embargo, este enfoque presenta problemas de rigidez y escalabilidad.

Problema con Roles Tradicionales Jerarquicos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Sistema tradicional:**

::

   Admin (nivel 1)
     |-- Puede hacer TODO
     |
   Supervisor (nivel 2)
     |-- Puede hacer menos que Admin
     |
   Agent (nivel 3)
     |-- Puede hacer solo operaciones basicas

**Problemas:**

1. **Rigidez:** Un usuario solo puede tener UN rol. No se puede ser
   “Agent + Visualizador de Metricas” sin crear nuevo rol.

2. **Explosion de Roles:** Necesitas crear “AgentConMetricas”,
   “AgentConReportes”, “AgentConHorarios”, etc.

3. **Jerarquia Artificial:** “Supervisor” implica autoridad, pero a
   veces solo necesitas “gestion de horarios” sin ser “supervisor” de
   nadie.

4. **Mantenimiento Complejo:** Cambiar permisos de “Supervisor” afecta a
   TODOS los supervisores, cuando quizas solo algunos necesitan un
   permiso especifico.

5. **Estigmatizacion:** Etiquetas como “Admin” o “Agent” crean
   percepcion de jerarquia que no siempre refleja responsabilidades
   reales.

Decision
--------

**Implementar Sistema de Permisos Granular BASADO EN CAPACIDADES, SIN
roles jerarquicos.**

Arquitectura Decidida
~~~~~~~~~~~~~~~~~~~~~

::

   USUARIO
     |
     +-- GRUPOS DE PERMISOS (multiples, combinables)
           |
           +-- CAPACIDADES (permisos atomicos)
                 |
                 +-- FUNCIONES (recursos del sistema)

Principios Clave
~~~~~~~~~~~~~~~~

1. **NO Roles Jerarquicos:** No usamos “Admin”, “Supervisor”, “Agent”,
   “Manager”, etc.

2. **Grupos Funcionales:** Usamos grupos DESCRIPTIVOS de lo que puede
   hacer:

   -  ``atencion_cliente``: Capacidades para atender clientes
   -  ``gestion_equipos``: Capacidades para gestionar equipos
   -  ``visualizacion_metricas``: Capacidades para ver metricas

3. **Multiples Grupos:** Un usuario puede tener VARIOS grupos
   simultaneamente:

   ::

      Usuario: Maria
      - atencion_cliente
      - visualizacion_metricas
      - gestion_horarios

4. **Sin Jerarquia:** Grupos NO tienen niveles. ``gestion_equipos`` NO
   es “superior” a ``atencion_cliente``.

5. **Combinable:** Permisos se suman. Maria tiene capacidades de los 3
   grupos.

Componentes del Sistema
~~~~~~~~~~~~~~~~~~~~~~~

1. Funcion (Recurso)
^^^^^^^^^^^^^^^^^^^^

Representa un recurso del sistema.

::

   Ejemplo: dashboards, usuarios, metricas, llamadas, tickets

2. Capacidad (Accion sobre Recurso)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Accion atomica sobre un recurso.

::

   Formato: sistema.dominio.recurso.accion
   Ejemplo: sistema.vistas.dashboards.ver
            sistema.operaciones.llamadas.realizar
            sistema.finanzas.pagos.aprobar

3. Grupo de Permisos (Agrupacion Funcional)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Conjunto de capacidades que forman una funcion logica.

::

   Ejemplo:
     Grupo: atencion_cliente
       - sistema.operaciones.llamadas.ver
       - sistema.operaciones.llamadas.realizar
       - sistema.operaciones.tickets.crear
       - sistema.operaciones.clientes.ver

4. Usuario-Grupo (Asignacion)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Usuario asignado a uno o mas grupos.

::

   Usuario: Carlos
     - atencion_cliente
     - gestion_cobranza
     - visualizacion_metricas

Ventajas del Enfoque
--------------------

1. Flexibilidad Total
~~~~~~~~~~~~~~~~~~~~~

**Antes (jerarquico):**

::

   Usuario: Maria (rol: Agent)
     Problema: Necesita ver metricas, pero Agents no tienen ese permiso.
     Solucion: Crear nuevo rol "AgentConMetricas" (explosion de roles)

**Ahora (grupos funcionales):**

::

   Usuario: Maria
     - atencion_cliente
     - visualizacion_metricas
     (Simplemente agregar segundo grupo)

2. Descripcion Clara de Responsabilidades
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Antes:**

::

   Rol: Supervisor
     Que puede hacer? No esta claro sin ver codigo.

**Ahora:**

::

   Grupos:
     - gestion_equipos: Gestiona equipos de trabajo
     - gestion_horarios: Planifica y aprueba turnos
     - aprobacion_excepciones: Aprueba casos especiales
     (Nombres descriptivos y auto-explicativos)

3. Sin Estigma Jerarquico
~~~~~~~~~~~~~~~~~~~~~~~~~

**Antes:**

::

   Pedro (Agent) solicita algo a Maria (Supervisor)
     Percepcion: Maria tiene "autoridad" sobre Pedro

**Ahora:**

::

   Pedro (atencion_cliente) solicita a Maria (aprobacion_excepciones)
     Percepcion: Maria tiene FUNCION de aprobar, no "autoridad" jerarquica

4. Facil Escalabilidad
~~~~~~~~~~~~~~~~~~~~~~

Agregar nuevas funcionalidades:

::

   Nueva funcion: sistema.calidad.evaluaciones

     Capacidades:
       - sistema.calidad.evaluaciones.ver
       - sistema.calidad.evaluaciones.crear

     Nuevo grupo: evaluacion_desempeno
       - Incluye las capacidades de evaluaciones

     Asignar grupo a usuarios relevantes
     (No necesita cambiar roles existentes)

5. Permisos Excepcionales
~~~~~~~~~~~~~~~~~~~~~~~~~

Sistema permite otorgar/revocar capacidades especificas:

::

   Usuario: Juan (atencion_cliente)
     Problema: Necesita aprobar pagos por 1 mes (proyecto especial)

     Solucion: PermisoExcepcional
       - tipo: conceder
       - capacidad: sistema.finanzas.pagos.aprobar
       - fecha_inicio: 2025-11-01
       - fecha_fin: 2025-11-30
       - motivo: "Proyecto especial fin de año"

Comparacion con Alternativas
----------------------------

Alternativa 1: Roles Jerarquicos (RBAC Tradicional)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**RECHAZADO**

Razones:

-  Rigidez (un usuario = un rol)
-  Explosion de roles para combinaciones
-  Jerarquia artificial
-  Estigmatizacion

Alternativa 2: ACLs (Access Control Lists)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**RECHAZADO**

Razones:

-  Demasiado granular (permisos por usuario por recurso)
-  Dificil de mantener
-  No reusable (cada usuario tiene su propia ACL)

Alternativa 3: Grupos + Capacidades (ELEGIDO)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**ACEPTADO**

Razones:

-  Balance entre flexibilidad y mantenibilidad
-  Reusable (grupos se asignan a multiples usuarios)
-  Sin jerarquia
-  Escalable
-  Descripcion clara de funciones

Consecuencias
-------------

Positivas
~~~~~~~~~

1. **Flexibilidad:** Usuarios pueden tener multiples funciones sin
   explosion de roles

2. **Claridad:** Nombres descriptivos explican que puede hacer cada
   grupo

3. **Escalabilidad:** Agregar nuevas funcionalidades no afecta
   estructura existente

4. **Sin Estigma:** No hay percepcion de jerarquia artificial

5. **Auditoria:** Trazabilidad completa de quien tiene que permisos

Negativas
~~~~~~~~~

1. **Complejidad Inicial:** Mas tablas y relaciones que RBAC simple

2. **Curva de Aprendizaje:** Equipo debe entender el concepto de grupos
   funcionales vs roles

3. **UI Mas Compleja:** Interfaz de asignacion de permisos mas
   sofisticada

Mitigaciones
------------

Para Complejidad Inicial
~~~~~~~~~~~~~~~~~~~~~~~~

-  Documentacion exhaustiva del modelo
-  Diagramas ER claros
-  Ejemplos practicos de casos de uso

Para Curva de Aprendizaje
~~~~~~~~~~~~~~~~~~~~~~~~~

-  Training session para equipo
-  Guias de como asignar grupos
-  Presets de grupos comunes

Para UI Compleja
~~~~~~~~~~~~~~~~

-  Interfaz intuitiva con checkboxes de grupos
-  Preview de capacidades al seleccionar grupo
-  Busqueda y filtrado de grupos

Implementacion
--------------

Fase 1: Base de Datos (8 tablas)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**COMPLETADO**

::

   1. funciones: Recursos del sistema
   2. capacidades: Acciones sobre recursos
   3. funcion_capacidades: Relacion funcion-capacidad
   4. grupos_permisos: Grupos funcionales (NO roles)
   5. grupo_capacidades: Relacion grupo-capacidad
   6. usuarios_grupos: Usuario asignado a grupos
   7. permisos_excepcionales: Conceder/revocar capacidades especificas
   8. auditoria_permisos: Trazabilidad de accesos

Fase 2: Datos Semilla
~~~~~~~~~~~~~~~~~~~~~

Crear grupos predefinidos:

-  atencion_cliente
-  gestion_equipos
-  visualizacion_metricas
-  administracion_usuarios
-  gestion_cobranza
-  auditoria_llamadas
-  (etc…)

Fase 3: Servicio de Permisos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Implementar ``PermisoService`` para:

-  Verificar si usuario tiene capacidad
-  Obtener capacidades de usuario
-  Obtener funciones accesibles
-  Registrar auditorias

Fase 4: Middleware
~~~~~~~~~~~~~~~~~~

Middleware ``verificarPermiso(capacidad_requerida)`` en endpoints:

.. code:: python

   @verificarPermiso('sistema.finanzas.pagos.aprobar')
   def aprobar_pago(request, pago_id):
       # Codigo del endpoint
       pass

Fase 5: Frontend
~~~~~~~~~~~~~~~~

-  Interfaz de asignacion de grupos
-  Menu dinamico basado en capacidades
-  Visualizacion de permisos de usuario

Referencias
-----------

-  REQ-PERM-001: Requisito Sistema de Permisos Granular
-  Codigo: ``api/callcentersite/callcentersite/apps/permissions/``
-  Tests:
   ``api/callcentersite/callcentersite/apps/permissions/tests/test_models.py``
-  Documentacion: ``docs/backend/permisos/``

Aprobacion
----------

-  **Propuesto por:** Arquitecto Senior
-  **Revisado por:** Tech Lead, DevOps Lead
-  **Aprobado por:** Arquitecto Senior, Product Owner
-  **Fecha de aprobacion:** 2025-11-07

--------------

**Version:** 1.0 **Estado:** ACEPTADO e IMPLEMENTADO (Prioridad 1)
