PROCED-GOB-001: Crear Architecture Decision Record (ADR)
========================================================

Objetivo
--------

Establecer proceso paso a paso para documentar decisiones
arquitectónicas significativas mediante ADRs, asegurando trazabilidad y
contexto histórico.

Alcance
-------

Este procedimiento cubre: - Identificación de cuándo crear un ADR -
Estructura y formato de ADR - Proceso de creación y aprobación -
Nomenclatura y organización

NO cubre: - Toma de decisiones arquitectónicas (solo documentación) -
Implementación técnica de las decisiones - Cambio de ADRs existentes
(usar nuevo ADR que superseda)

Pre-requisitos
--------------

-  Decisión arquitectónica tomada o en proceso
-  Conocimiento del dominio técnico afectado
-  Acceso al repositorio de documentación

Roles y Responsabilidades
-------------------------

-  **Arquitecto/Tech Lead**: Crea y aprueba ADRs
-  **Developer**: Puede proponer ADRs para revisión
-  **Equipo**: Revisa y proporciona feedback

Procedimiento Detallado
-----------------------

PASO 1: Determinar si se Necesita un ADR
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1.1 Preguntas de validación
^^^^^^^^^^^^^^^^^^^^^^^^^^^

¿La decisión cumple al menos UNO de estos criterios?

-  ✅ **Impacto estructural**: Afecta arquitectura general del sistema
-  ✅ **Difícil de revertir**: Cambiarla después sería costoso
-  ✅ **Afecta múltiples equipos**: Impacta varios dominios
-  ✅ **Nueva tecnología**: Introducción de nueva herramienta/framework
-  ✅ **Cambio de patrón**: Modificación de patrón arquitectónico
-  ✅ **Trade-offs significativos**: Pros/cons importantes a considerar
-  ✅ **Precedente**: Sentará base para decisiones futuras

**Ejemplos que SÍ requieren ADR**: - Elegir base de datos (PostgreSQL vs
MongoDB) - Adoptar arquitectura de microservicios - Seleccionar
framework frontend (React vs Vue) - Implementar sistema de permisos sin
roles jerárquicos - Estrategia de deployment (blue-green vs rolling)

**Ejemplos que NO requieren ADR**: - Cambiar nombre de variable -
Agregar campo a formulario - Corregir bug menor - Actualizar versión de
librería patch (2.1.0 → 2.1.1)

1.2 Documentar decisión inicial
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Si la respuesta es SÍ, proceder con creación de ADR.

--------------

PASO 2: Determinar Dominio y Número
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

2.1 Identificar dominio
^^^^^^^^^^^^^^^^^^^^^^^

Según el área técnica afectada:

========== ====== ==============================
Dominio    Código Ejemplo
========== ====== ==============================
Backend    BACK   Modelos de BD, APIs, Servicios
Frontend   FRONT  UI, Componentes, Estado
DevOps     DEVOPS CI/CD, Infraestructura
QA         QA     Testing, Calidad
AI         AI     Agentes, ML, Automatización
Gobernanza GOB    Procesos, Metodologías
Desarrollo DEV    SDLC, Git workflows
========== ====== ==============================

2.2 Obtener siguiente número secuencial
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Navegar a directorio de ADRs
   cd docs/gobernanza/adr

   # Listar ADRs del dominio específico
   ls -1 ADR-BACK-*.md | tail -1
   # Output: ADR-BACK-005-servicios-resilientes.md

   # Siguiente número: ADR-BACK-006

**Patrón**: ``ADR-{DOMINIO}-{###}-{titulo-descriptivo}.md``

--------------

PASO 3: Crear Archivo ADR
~~~~~~~~~~~~~~~~~~~~~~~~~

3.1 Crear archivo con nombre correcto
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Ejemplo: ADR para elegir ORM en backend
   touch docs/gobernanza/adr/ADR-BACK-006-django-orm-vs-sqlalchemy.md

3.2 Agregar estructura base
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Copiar y completar template:

.. code:: markdown

   ---
   id: ADR-BACK-006-django-orm-vs-sqlalchemy
   estado: propuesta  # propuesta | aceptada | rechazada | obsoleta | supersedida
   propietario: equipo-backend
   ultima_actualizacion: 2025-11-17
   relacionados: ["ADR-BACK-003", "PROC-DEV-001"]
   date: 2025-11-17
                   

   # ADR-BACK-006: Selección de ORM para Backend

   **Estado:** propuesta

   **Fecha:** 2025-11-17

   **Decisores:**
   - arquitecto-backend
   - tech-lead-backend
   - equipo-backend

   **Contexto técnico:** Backend / Data Layer

   ---

   ## Contexto

   [Describir el contexto que motiva la decisión]

   ¿Qué problema estamos resolviendo?
   ¿Por qué necesitamos tomar esta decisión ahora?
   ¿Qué restricciones o requerimientos tenemos?

   ## Decisión

   [La decisión que se tomó]

   Hemos decidido usar [OPCIÓN ELEGIDA] porque [RAZONES PRINCIPALES].

   ## Alternativas Consideradas

   ### Opción 1: [Nombre]

   **Pros:**
   - ✅ Ventaja 1
   - ✅ Ventaja 2

   **Contras:**
   - ❌ Desventaja 1
   - ❌ Desventaja 2

   ### Opción 2: [Nombre]

   **Pros:**
   - ✅ Ventaja 1

   **Contras:**
   - ❌ Desventaja 1

   ### Opción Elegida: [Nombre]

   **Justificación:**
   [Por qué esta opción es la mejor para nuestro contexto]

   ## Consecuencias

   ### Positivas
   - ✅ Beneficio 1
   - ✅ Beneficio 2

   ### Negativas
   - ⚠️ Trade-off 1
   - ⚠️ Trade-off 2

   ### Neutrales
   - 🔄 Cambio 1 (ni bueno ni malo)

   ## Implementación

   ### Pasos de migración
   1. Paso 1
   2. Paso 2

   ### Timeline
   - Semana 1: ...
   - Semana 2: ...

   ### Equipo responsable
   - Backend Team

   ## Métricas de Éxito

   ¿Cómo mediremos si esta decisión fue correcta?

   - Métrica 1: [objetivo]
   - Métrica 2: [objetivo]

   ## Referencias

   - [Link a documentación técnica]
   - [Link a proof of concept]
   - [Link a benchmark results]

   ## Notas

   [Información adicional, consideraciones futuras, etc.]

--------------

PASO 4: Completar Cada Sección
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

4.1 Sección: Contexto
^^^^^^^^^^^^^^^^^^^^^

**Qué incluir**: - Situación actual que motiva la decisión - Problema
específico a resolver - Restricciones técnicas/negocio - Requerimientos
funcionales y no funcionales - Por qué la decisión es urgente/importante

**Ejemplo**:

.. code:: markdown

   ## Contexto

   Actualmente el proyecto IACT utiliza SQL directo para queries de base de datos,
   lo cual genera los siguientes problemas:

   1. **Mantenibilidad**: Queries SQL embebidas en código Python son difíciles de mantener
   2. **Seguridad**: Riesgo de SQL injection si no se sanitizan inputs correctamente
   3. **Portabilidad**: Difícil cambiar de PostgreSQL a otra BD en el futuro
   4. **Productividad**: Developers escriben mucho código boilerplate

   Necesitamos seleccionar un ORM que:
   - Sea compatible con PostgreSQL 14+
   - Soporte migraciones de esquema
   - Tenga buen performance para queries complejas
   - Sea familiar para el equipo (mayoría conoce Django)

--------------

4.2 Sección: Decisión
^^^^^^^^^^^^^^^^^^^^^

**Qué incluir**: - Declaración clara y concisa de la decisión - Resumen
de 1-2 párrafos máximo - Evitar ambigüedad

**Ejemplo**:

.. code:: markdown

   ## Decisión

   Hemos decidido utilizar **Django ORM** como capa de abstracción de base de datos
   para el proyecto IACT.

   Esta decisión aplica a:
   - Todos los nuevos modelos de datos
   - Queries de lectura y escritura
   - Migraciones de esquema

   Se permite uso de SQL directo solo para:
   - Queries de optimización extrema (previa aprobación del tech lead)
   - Reportes complejos con agregaciones custom
   - Operaciones bulk que Django ORM no maneja eficientemente

--------------

4.3 Sección: Alternativas Consideradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Qué incluir**: - Mínimo 2-3 alternativas evaluadas - Pros y contras de
cada una - Por qué fueron descartadas

**Ejemplo**:

.. code:: markdown

   ## Alternativas Consideradas

   ### Opción 1: SQL Directo (Status Quo)

   **Pros:**
   - ✅ Control total sobre queries
   - ✅ Performance óptimo para casos específicos
   - ✅ No hay curva de aprendizaje

   **Contras:**
   - ❌ Alto riesgo de SQL injection
   - ❌ Difícil de mantener
   - ❌ No hay abstracción de BD
   - ❌ Mucho código boilerplate

   **Por qué fue descartada:** Los riesgos de seguridad y mantenibilidad superan los beneficios.

   ---

   ### Opción 2: SQLAlchemy

   **Pros:**
   - ✅ ORM muy potente y flexible
   - ✅ Excelente performance
   - ✅ Permite raw SQL cuando se necesita
   - ✅ Independiente de framework

   **Contras:**
   - ❌ Curva de aprendizaje pronunciada
   - ❌ Más verbose que Django ORM
   - ❌ Equipo no está familiarizado
   - ❌ Requiere configuración adicional

   **Por qué fue descartada:** La curva de aprendizaje ralentizaría el desarrollo.

   ---

   ### Opción Elegida: Django ORM

   **Pros:**
   - ✅ Equipo ya conoce Django
   - ✅ Integración nativa con Django
   - ✅ Sintaxis simple e intuitiva
   - ✅ Migraciones automáticas
   - ✅ Admin panel gratis
   - ✅ Gran comunidad y documentación

   **Contras:**
   - ⚠️ Menos flexible que SQLAlchemy
   - ⚠️ Performance subóptimo en casos edge
   - ⚠️ Acoplamiento a Django framework

   **Justificación:**

   Django ORM es la mejor opción para IACT porque:

   1. **Velocidad de desarrollo**: Equipo ya conoce Django, no hay curva de aprendizaje
   2. **Ecosistema**: Aprovecha todo el ecosistema de Django (admin, auth, etc.)
   3. **Suficientemente potente**: Cubre 95% de nuestros casos de uso
   4. **Escape hatch**: Permite raw SQL para el 5% restante

   Los trade-offs de performance son aceptables dado nuestro volumen de datos actual (< 1M registros).

--------------

4.4 Sección: Consecuencias
^^^^^^^^^^^^^^^^^^^^^^^^^^

**Qué incluir**: - Impactos positivos - Impactos negativos (trade-offs)
- Impactos neutrales

**Ejemplo**:

.. code:: markdown

   ## Consecuencias

   ### Positivas

   - ✅ **Seguridad mejorada**: ORM previene SQL injection automáticamente
   - ✅ **Productividad aumentada**: Menos código boilerplate, desarrollo más rápido
   - ✅ **Mantenibilidad**: Código Python en lugar de strings SQL
   - ✅ **Testing**: Fácil mockear modelos en tests
   - ✅ **Migraciones**: Sistema automático de migrations evita errores manuales

   ### Negativas

   - ⚠️ **Dependencia de Django**: Difícil migrar a otro framework en futuro
   - ⚠️ **Performance**: Queries complejas pueden ser menos eficientes que SQL puro
   - ⚠️ **Curva de aprendizaje**: Nuevos devs deben aprender Django ORM quirks
   - ⚠️ **Debug**: Más difícil debuggear queries generadas automáticamente

   ### Neutrales

   - 🔄 **Tamaño del proyecto**: Django agrega dependencias (~10MB)
   - 🔄 **Estilo de código**: Cambio de paradigma de procedural SQL a OOP models

--------------

4.5 Sección: Implementación
^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Qué incluir**: - Plan de migración - Timeline estimado - Responsables

**Ejemplo**:

.. code:: markdown

   ## Implementación

   ### Pasos de migración

   1. **Semana 1: Setup**
      - Instalar Django y dependencias
      - Configurar settings para múltiples entornos
      - Crear estructura de apps Django

   2. **Semana 2-3: Migración de modelos**
      - Convertir tablas existentes a Django models
      - Generar y revisar migrations iniciales
      - Ejecutar migrations en staging

   3. **Semana 4: Migración de queries**
      - Reemplazar raw SQL con Django ORM queries
      - Optimizar N+1 queries con select_related/prefetch_related
      - Agregar tests para cada query migrada

   4. **Semana 5: Testing y validación**
      - Tests de integración end-to-end
      - Performance testing vs baseline actual
      - Code review exhaustivo

   5. **Semana 6: Deployment**
      - Deploy a staging
      - Validación en staging (1 semana)
      - Deploy a production

   ### Equipo responsable

   - **Lead**: @arquitecto-backend
   - **Developers**: @dev1, @dev2, @dev3
   - **QA**: @qa-lead
   - **Reviewer**: @tech-lead

   ### Criterios de aceptación

   - [ ] 100% de modelos migrados
   - [ ] 100% de queries migradas
   - [ ] Tests coverage >= 80%
   - [ ] Performance dentro de 10% del baseline
   - [ ] Zero bugs críticos en staging

--------------

PASO 5: Revisión y Aprobación
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

5.1 Self-review
^^^^^^^^^^^^^^^

Revisar checklist:

-  ☐ Título descriptivo y conciso
-  ☐ Frontmatter completo (id, estado, propietario, fecha)
-  ☐ Contexto explica claramente el problema
-  ☐ Decisión es clara y sin ambigüedades
-  ☐ Al menos 2 alternativas documentadas
-  ☐ Pros/cons de cada alternativa
-  ☐ Justificación de la opción elegida
-  ☐ Consecuencias realistas (no solo positivas)
-  ☐ Plan de implementación con timeline
-  ☐ Referencias incluidas (si aplica)

--------------

5.2 Crear PR para revisión
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Crear branch
   git checkout -b docs/adr-back-006-django-orm

   # Agregar ADR
   git add docs/gobernanza/adr/ADR-BACK-006-django-orm-vs-sqlalchemy.md

   # Commit
   git commit -m "docs(adr): ADR-BACK-006 selección de Django ORM

   Documentar decisión de usar Django ORM como capa de abstracción
   de base de datos en lugar de SQL directo o SQLAlchemy.

   Relacionado: TASK-089"

   # Push
   git push -u origin docs/adr-back-006-django-orm

--------------

5.3 Solicitar revisión
^^^^^^^^^^^^^^^^^^^^^^

Asignar reviewers: - **Obligatorio**: Tech Lead del dominio -
**Opcional**: Arquitecto senior, otros tech leads

Esperar aprobación antes de merge.

--------------

PASO 6: Actualizar Estado del ADR
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

6.1 Estados posibles
^^^^^^^^^^^^^^^^^^^^

+---------------+--------------------------+--------------------------+
| Estado        | Significado              | Cuándo usar              |
+===============+==========================+==========================+
| ``propuesta`` | En revisión              | ADR creado, esperando    |
|               |                          | aprobación               |
+---------------+--------------------------+--------------------------+
| ``aceptada``  | Aprobado y activo        | Decisión aprobada, en    |
|               |                          | implementación           |
+---------------+--------------------------+--------------------------+
| ``rechazada`` | No aprobado              | Decisión rechazada tras  |
|               |                          | revisión                 |
+---------------+--------------------------+--------------------------+
| ``obsoleta``  | Ya no aplica             | Tecnología/contexto      |
|               |                          | cambió                   |
+---------------+--------------------------+--------------------------+
| ``            | Reemplazada              | Otro ADR la reemplaza    |
| supersedida`` |                          |                          |
+---------------+--------------------------+--------------------------+

6.2 Actualizar tras aprobación
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: markdown

   ---
   id: ADR-BACK-006-django-orm-vs-sqlalchemy
   estado: aceptada  # ← Cambiar de propuesta a aceptada
   propietario: equipo-backend
   ultima_actualizacion: 2025-11-18  # ← Actualizar fecha
   relacionados: ["ADR-BACK-003", "PROC-DEV-001"]
   date: 2025-11-17
                   

   # ADR-BACK-006: Selección de ORM para Backend

   **Estado:** aceptada  # ← Actualizar también aquí

   **Fecha:** 2025-11-17
   **Fecha de aprobación:** 2025-11-18  # ← Agregar fecha de aprobación

   [resto del documento...]

--------------

PASO 7: Comunicar la Decisión
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

7.1 Notificar al equipo
^^^^^^^^^^^^^^^^^^^^^^^

-  Enviar mensaje en canal de Slack/Teams del equipo
-  Mencionar en stand-up o reunión de equipo
-  Incluir link al ADR

**Ejemplo de mensaje**:

::

   📢 Nuevo ADR aprobado: ADR-BACK-006

   Hemos decidido usar Django ORM como capa de abstracción de BD.

   Link: https://github.com/org/repo/blob/main/docs/gobernanza/adr/ADR-BACK-006-django-orm-vs-sqlalchemy.md

   Implementación comienza próxima semana. Preguntas/comentarios bienvenidos.

--------------

7.2 Actualizar índice de ADRs (si existe)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Si hay un README en ``/docs/gobernanza/adr/README.md``, agregar entrada:

.. code:: markdown

   ## Backend (BACK)

   - [ADR-BACK-001: Grupos Funcionales Sin Jerarquía](ADR-BACK-001-grupos-funcionales-sin-jerarquia.md)
   - ...
   - [ADR-BACK-006: Django ORM vs SQLAlchemy](ADR-BACK-006-django-orm-vs-sqlalchemy.md) ⭐ NEW

--------------

Problemas Comunes y Soluciones
------------------------------

Problema 1: No sé si mi decisión requiere ADR
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Solución**: Aplica la regla de “si dudas, crea ADR”. Es mejor
documentar de más que de menos. Un ADR corto es mejor que ninguno.

--------------

Problema 2: No encuentro alternativas a documentar
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Solución**: Siempre hay alternativas. Considera: - Status quo (no
hacer nada) - Opciones obvias del mercado (líder vs alternativas) -
Soluciones custom vs off-the-shelf

--------------

Problema 3: El ADR está muy largo
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Solución**: Si el ADR supera 500 líneas, considera: - Dividir en
múltiples ADRs (uno por sub-decisión) - Mover detalles técnicos a
documentación separada - Mantener ADR de alto nivel con links a detalles

--------------

Checklist Final
---------------

Antes de marcar ADR como completo:

-  ☐ Archivo nombrado correctamente: ``ADR-{DOMINIO}-{###}-{titulo}.md``
-  ☐ Frontmatter completo y correcto
-  ☐ Contexto claro y conciso
-  ☐ Decisión inequívoca
-  ☐ >= 2 alternativas documentadas
-  ☐ Pros/cons realistas para cada alternativa
-  ☐ Consecuencias honestas (positivas Y negativas)
-  ☐ Plan de implementación con timeline
-  ☐ PR creado y revisado
-  ☐ Aprobado por tech lead
-  ☐ Merged a main
-  ☐ Equipo notificado

--------------

Referencias
-----------

-  `ADR-GOB-002: Organización de Proyecto por
   Dominio <../adr/ADR-GOB-002-organizacion-proyecto-por-dominio.md>`__
-  `GUIA-GOB-002: Convenciones de
   Nomenclatura <../guias/GUIA-GOB-002-convenciones_nomenclatura.md>`__
-  `Architecture Decision Records - Michael
   Nygard <https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions>`__

Historial de Cambios
--------------------

======= ========== =========== ===============
Versión Fecha      Autor       Cambios
======= ========== =========== ===============
1.0.0   2025-11-17 Claude Code Versión inicial
======= ========== =========== ===============

Aprobación
----------

-  **Autor**: Claude Code (Sonnet 4.5)
-  **Revisado por**: Pendiente
-  **Aprobado por**: Pendiente
-  **Fecha de próxima revisión**: 2026-02-17
