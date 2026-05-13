ADR-005: Sistema de Permisos con Grupos Funcionales Sin Jerarquía
=================================================================

**Estado:** aceptada

**Fecha:** 2025-11-07

**Decisores:** equipo-backend, equipo-ba, arquitecto-principal

**Contexto técnico:** Backend

--------------

Contexto y Problema
-------------------

El sistema actual utiliza un modelo de permisos granulares (RF-001 a
RF-004) con 3 niveles de evaluación. Sin embargo, necesitamos escalar
este modelo para soportar:

1. **Múltiples módulos:** 19 funciones diferentes (usuarios, dashboards,
   llamadas IVR, tickets, reportes, etc.)
2. **130+ capacidades:** Acciones específicas sobre recursos
3. **Flexibilidad organizacional:** Diferentes usuarios con
   combinaciones únicas de permisos
4. **Sin jerarquías rígidas:** Evitar etiquetas como “Admin”,
   “Supervisor”, “Agente” que crean barreras

**Preguntas clave:** - ¿Cómo organizamos 130+ capacidades de forma
manejable? - ¿Cómo evitamos la explosión combinatoria de “roles”? -
¿Cómo permitimos flexibilidad sin complejidad excesiva? - ¿Cómo
mantenemos la claridad sobre “quién puede hacer qué”?

**Restricciones actuales:** - Sistema de permisos granulares ya
implementado (3 niveles) - Base de datos PostgreSQL - Django backend con
modelos in-memory para performance - Necesidad de auditoría completa
(ISO 27001)

**Impacto del problema:** - Sin organización clara, 130+ capacidades son
inmanejables - Roles tradicionales son rígidos y no se adaptan a la
realidad operativa - Jerarquías crean barreras artificiales entre
equipos - Dificulta onboarding de nuevos usuarios

--------------

Factores de Decisión
--------------------

-  **Flexibilidad:** Usuarios deben poder tener combinaciones únicas de
   permisos
-  **Claridad:** Debe ser obvio QUÉ puede hacer cada usuario
-  **Escalabilidad:** Diseño debe soportar crecimiento a 200+
   capacidades
-  **Mantenibilidad:** Fácil agregar nuevos permisos sin reestructurar
   todo
-  **Experiencia de Usuario:** Nomenclatura humana, no técnica
-  **Seguridad:** Auditoría completa, sin gaps de permisos
-  **Performance:** Evaluación de permisos < 50ms
-  **Sin Jerarquías:** No crear barreras artificiales entre usuarios

--------------

Opciones Consideradas
---------------------

Opción 1: RBAC Tradicional (Role-Based Access Control)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción:** Sistema clásico de roles jerárquicos: Admin > Manager >
Supervisor > Agent. Cada rol tiene permisos fijos.

**Pros:** - Estándar de industria, bien entendido - Frameworks
existentes (Django Groups, etc.) - Fácil de implementar inicialmente -
Menos tablas en base de datos

**Contras:** - Jerarquías rígidas no se adaptan a la realidad -
Explosión de roles cuando crecen los permisos - Un usuario = un rol
(inflexible) - Nomenclatura pretenciosa (“Admin”, “Supervisor”) -
Dificulta cambios organizacionales

**Ejemplo/Implementación:**

.. code:: python

   # Usuario tiene UN rol
   usuario.rol = "SUPERVISOR"

   # Permisos fijos del rol
   if usuario.rol == "SUPERVISOR":
       permisos = ["ver_todo", "editar_equipo", "aprobar_tickets"]

**Razón del rechazo:** No permite la flexibilidad necesaria. En la
práctica, necesitamos usuarios con permisos mixtos (ej: “Coordinador que
también hace atención al cliente”).

--------------

Opción 2: ABAC (Attribute-Based Access Control)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción:** Sistema basado en atributos y reglas dinámicas.
Permisos se evalúan en runtime basándose en contexto (hora, ubicación,
atributos del usuario, etc.).

**Pros:** - Máxima flexibilidad - Permisos contextuales (ej: “solo entre
9am-5pm”) - Se adapta a cualquier escenario - Muy granular

**Contras:** - Complejidad extrema de implementación - Performance
impact (evaluación en runtime) - Difícil de debuggear - Curva de
aprendizaje alta - Overkill para nuestras necesidades - Difícil auditar
“quién tiene qué permiso”

**Ejemplo/Implementación:**

.. code:: python

   # Regla dinámica
   def puede_aprobar_pago(usuario, pago, contexto):
       return (
           usuario.departamento == "finanzas" and
           pago.monto < usuario.limite_aprobacion and
           contexto.hora_actual.hour >= 9 and
           contexto.hora_actual.hour <= 17 and
           not contexto.es_feriado
       )

**Razón del rechazo:** Demasiado complejo para nuestras necesidades
actuales. La mayoría de nuestros permisos son estáticos, no
contextuales.

--------------

Opción 3: Grupos Funcionales Sin Jerarquía (ELEGIDA)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción:** Sistema de “grupos de permisos” descriptivos que se
pueden combinar libremente. No hay jerarquía entre grupos. Un usuario
puede tener múltiples grupos simultáneamente.

**Conceptos clave:** - **Funciones:** Recursos del sistema (dashboards,
usuarios, tickets, etc.) - **Capacidades:** Acciones sobre recursos
(ver, crear, editar, eliminar) - **Grupos:** Colecciones de capacidades
con nombres descriptivos - **Usuarios:** Pueden tener N grupos
simultáneos

**Pros:** - Flexibilidad total: N grupos por usuario - Nomenclatura
descriptiva: “Atención al Cliente”, “Gestión de Equipos” - Sin
jerarquías: todos los grupos son iguales - Escalable: fácil agregar
nuevos grupos - Claro: se ve inmediatamente qué puede hacer cada usuario
- Mantenible: grupos modulares, no monolíticos - Performance: evaluación
simple con vistas SQL

**Contras:** - Más tablas en base de datos (8 tablas) - Requiere UI para
gestión de grupos - Posible confusión inicial (no es RBAC tradicional) -
Requiere definir bien los grupos iniciales

**Ejemplo/Implementación:**

.. code:: python

   # Usuario tiene MÚLTIPLES grupos
   usuario.grupos = [
       "atencion_cliente",
       "gestion_equipos",
       "analisis_operativo"
   ]

   # Permisos = UNION de todos los grupos
   permisos = []
   for grupo in usuario.grupos:
       permisos.extend(grupo.capacidades)

   # Verificación simple
   if "sistema.operaciones.tickets.crear" in permisos:
       crear_ticket()

**Estructura de Base de Datos:**

::

   funciones (19 recursos)
       ↓
   capacidades (~130 acciones)
       ↓
   grupos_permisos (17+ grupos descriptivos)
       ↓
   usuarios_grupos (N:M - múltiples grupos por usuario)

**Ejemplos de Grupos:** - ``atencion_cliente`` - Operaciones básicas de
call center - ``gestion_equipos`` - Administración de equipos -
``analisis_operativo`` - Métricas y reportes - ``auditoria_llamadas`` -
Evaluación de calidad - ``gestion_pagos`` - Procesamiento financiero

--------------

Decisión
--------

**Opción elegida:** “Grupos Funcionales Sin Jerarquía”

**Justificación:**

1. **Flexibilidad real:** Usuarios pueden tener combinaciones únicas de
   permisos según sus necesidades reales, no forzadas por roles rígidos.

2. **Claridad y experiencia humana:** Nombres descriptivos (“Gestión de
   Equipos”) en lugar de etiquetas jerárquicas (“Supervisor Nivel 2”).

3. **Escalabilidad probada:** Fácil agregar nuevos grupos sin afectar
   existentes. Sistema crece de forma modular.

4. **Sin barreras artificiales:** No hay jerarquía entre grupos. Todos
   son iguales, solo agrupan capacidades diferentes.

5. **Balance complejidad/beneficio:** Más simple que ABAC, más flexible
   que RBAC tradicional.

6. **Compatible con sistema actual:** Extiende el sistema de permisos
   granulares (RF-001 a RF-004) sin romper lo existente.

**Trade-offs aceptados:** - Más tablas en BD (8 en lugar de 3-4 de RBAC
tradicional) - Requiere UI de gestión de grupos (pero necesitaríamos UI
de todas formas) - No hay jerarquía (pero esto es el objetivo, no un
contra)

--------------

Consecuencias
-------------

Positivas
~~~~~~~~~

-  **Flexibilidad total:** Usuarios con permisos exactos que necesitan
-  **Sin etiquetas jerárquicas:** Elimina barreras organizacionales
   artificiales
-  **Escalable:** Fácil agregar módulos nuevos (pagos, facturación,
   etc.)
-  **Mantenible:** Grupos modulares, cambios localizados
-  **Auditable:** Vista SQL consolidada de permisos efectivos
-  **Performance:** Evaluación < 50ms con índices apropiados
-  **Experiencia mejorada:** Nomenclatura clara y descriptiva

Negativas
~~~~~~~~~

-  **Complejidad inicial:** Requiere definir bien los 17+ grupos
   iniciales
-  **UI necesaria:** No se puede gestionar manualmente con SQL
   fácilmente
-  **Curva de aprendizaje:** Equipo debe entender el modelo nuevo
-  **Migración:** Si hay sistema previo, requiere migración de datos
-  **Más tablas:** 8 tablas principales vs 3-4 de RBAC tradicional

Neutrales
~~~~~~~~~

-  **No es estándar:** No es RBAC puro ni ABAC, es híbrido
-  **Documentación custom:** Necesitamos documentar bien el modelo
-  **Tests necesarios:** Requiere test suite completo de permisos

--------------

Plan de Implementación
----------------------

1. **Fase 1: Estructura Base (Semana 1)**

   -  Crear 8 tablas principales en PostgreSQL
   -  Crear vistas auxiliares (vista_capacidades_usuario,
      vista_grupos_usuario)
   -  Crear función usuario_tiene_permiso()
   -  Insertar datos de prueba
   -  Validar estructura con queries de verificación
   -  Timeframe: 1 semana

2. **Fase 2: Funciones Core (Semana 2)**

   -  Insertar 3 funciones core (usuarios, dashboards, configuración)
   -  Definir 16 capacidades core
   -  Crear 3 grupos iniciales (administracion_usuarios,
      visualizacion_basica, configuracion_sistema)
   -  Implementar PermissionService en Django
   -  Crear endpoints API básicos
   -  Timeframe: 1 semana

3. **Fase 3: Módulos Operativos (Semanas 3-4)**

   -  Insertar 6 módulos operativos (llamadas IVR, tickets, clientes,
      métricas, reportes, alertas)
   -  Definir ~50 capacidades operativas
   -  Crear 3 grupos operativos
   -  Integrar con módulos Django existentes (ivr_legacy, reports,
      analytics)
   -  Timeframe: 2 semanas

4. **Fase 4: Módulos de Gestión y Finanzas (Semanas 5-6)**

   -  Crear módulos nuevos (equipos, horarios, evaluaciones, auditoría)
   -  Crear módulos financieros (pagos, facturas, cobranza)
   -  Definir ~50 capacidades adicionales
   -  Crear 8 grupos adicionales
   -  Timeframe: 2 semanas

5. **Fase 5: Módulos Estratégicos y Finalización (Semanas 7-11)**

   -  Crear módulos estratégicos (presupuestos, políticas, excepciones)
   -  UI de gestión de grupos
   -  Testing completo (unitarios, integración, E2E)
   -  Documentación de usuario
   -  Capacitación
   -  Go-live
   -  Timeframe: 5 semanas

**Total:** 11 semanas (~2.5 meses)

--------------

Validación y Métricas
---------------------

**Criterios de Éxito:** - Performance: Evaluación de permisos < 50ms
(p95) - Cobertura: 100% de funcionalidades cubiertas con permisos -
Flexibilidad: 80%+ de usuarios tienen combinaciones únicas de grupos -
Claridad: Encuesta post-implementación > 4/5 en “entiendo mis permisos”
- Escalabilidad: Agregar nuevo módulo < 2 días de trabajo

**Cómo medir:** -
``SELECT AVG(query_time) FROM pg_stat_statements WHERE query LIKE '%usuario_tiene_permiso%'``
- Análisis de combinaciones de grupos en producción - Encuesta de
usuario post-capacitación - Tiempo de implementación de nuevos módulos

**Revisión:** - Fecha de revisión programada: 2026-02-07 (3 meses
post-implementación) - Responsable de seguimiento: equipo-backend

--------------

Alternativas Descartadas
------------------------

ACL (Access Control Lists)
~~~~~~~~~~~~~~~~~~~~~~~~~~

**Por qué se descartó:** - Demasiado granular a nivel individual - No
escala bien con 100+ usuarios - Difícil mantener consistencia - No
proporciona agrupaciones lógicas

Hybrid RBAC + ACL
~~~~~~~~~~~~~~~~~

**Por qué se descartó:** - Complejidad de tener dos sistemas simultáneos
- Confusión sobre cuál usar cuando - Mantenimiento de dos modelos

--------------

Referencias
-----------

-  `ISO/IEC/IEEE 29148:2018 - Requirements
   Engineering <https://www.iso.org/standard/72089.html>`__
-  `OWASP ASVS - Authentication and Access
   Control <https://owasp.org/www-project-application-security-verification-standard/>`__
-  `NIST RBAC
   Model <https://csrc.nist.gov/projects/role-based-access-control>`__
-  `PostgreSQL Row Security
   Policies <https://www.postgresql.org/docs/current/ddl-rowsecurity.html>`__
-  `Django Permission
   System <https://docs.djangoproject.com/en/stable/topics/auth/default/>`__
-  Documento:
   ``docs/backend/requisitos/INDICE_MAESTRO_PERMISOS_GRANULAR.md``
-  Documento:
   ``docs/backend/requisitos/prioridad_01_estructura_base_datos.md``

--------------

Notas Adicionales
-----------------

-  **Fecha de discusión inicial:** 2025-11-04
-  **Participantes:** equipo-backend (3 personas), equipo-ba (1
   persona), arquitecto-principal
-  **Experimentos realizados:**

   -  POC con Django Groups tradicionales (rechazado por inflexibilidad)
   -  POC con django-guardian (rechazado por complejidad object-level)
   -  Benchmark de performance: 3 niveles de evaluación < 10ms

-  **Decisiones relacionadas:**

   -  ADR-002: Suite de Calidad de Código
   -  ADR-003: DORA Metrics Integration
   -  ADR-004: Centralized Log Storage (para auditoría)

--------------

**Documento:** ADR-005 **Fecha:** 07 de Noviembre, 2025 **Estado:**
Aceptada **Próxima revisión:** 2026-02-07
