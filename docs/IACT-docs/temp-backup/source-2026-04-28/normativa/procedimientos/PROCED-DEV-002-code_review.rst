PROCED-DEV-002: Code Review
===========================

Objetivo
--------

Establecer un proceso sistemático de revisión de código que garantice
calidad, consistencia y transferencia de conocimiento entre el equipo.

Alcance
-------

Este procedimiento cubre: - Pasos para revisar Pull Requests - Checklist
de verificación - Criterios de aprobación/rechazo - Comunicación
efectiva en reviews

NO cubre: - Creación de PRs (ver PROCED-DEV-001) - Resolución de
conflictos de merge - Estrategias de deployment

Pre-requisitos
--------------

-  Ser asignado como reviewer en un PR
-  Acceso al repositorio
-  Conocimiento del dominio/área del código
-  Entorno local configurado (recomendado)

Roles y Responsabilidades
-------------------------

-  **Reviewer**: Ejecuta la revisión completa
-  **Author**: Responde comentarios y realiza cambios
-  **Tech Lead**: Desempata decisiones conflictivas

Procedimiento Detallado
-----------------------

PASO 1: Revisión Inicial (5 minutos)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1.1 Leer título y descripción del PR
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Entender: - ¿Qué problema resuelve? - ¿Cuál es el alcance? - ¿Hay
contexto adicional (issues, ADRs)?

1.2 Verificar información básica
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

✅ **Checklist preliminar**: - [ ] Título descriptivo y sigue convención
- [ ] Descripción completa con resumen - [ ] Test plan incluido - [ ]
Checklist del autor completado - [ ] Issues/ADRs relacionados vinculados
- [ ] Labels apropiados

**Si falta algo crítico**: Solicitar al autor que complete antes de
continuar.

--------------

PASO 2: Verificación de CI/CD (2 minutos)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

2.1 Revisar estado de checks
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

✅ **Verificar que pasen**: - [ ] Tests unitarios - [ ] Tests de
integración - [ ] Linters (flake8, eslint, etc.) - [ ] Code coverage >=
umbral (típicamente 80%) - [ ] Build exitoso - [ ] Security scans sin
alertas críticas

**Si algún check falla**:

.. code:: markdown

   Los siguientes checks están fallando:
   - ❌ Tests unitarios: 3 tests failing en `test_auth.py`
   - ❌ Coverage: 75% (< 80% requerido)

   Por favor corregir antes de continuar con el review.

--------------

PASO 3: Revisión del Diff (15-30 minutos)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

3.1 Vista general de archivos cambiados
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Listar archivos modificados
   git diff main...feature/branch --name-only

Verificar: - ¿Los archivos cambiados son coherentes con el objetivo del
PR? - ¿Hay cambios inesperados o no relacionados?

3.2 Revisión línea por línea
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Para cada archivo, verificar según el **Checklist de Calidad** (ver
sección abajo).

3.3 Dejar comentarios constructivos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Formato recomendado**:

**❌ Comentario NO constructivo**:

::

   Este código está mal.

**✅ Comentario constructivo**:

.. code:: markdown

   **Concern**: Potential N+1 query problem

   Este bucle ejecuta una query por cada usuario:

   ```python
   for user in users:
       permissions = Permission.objects.filter(user=user)  # N+1 query

**Sugerencia**: Usar ``select_related`` o ``prefetch_related``:

.. code:: python

   users = User.objects.prefetch_related('permissions').all()
   for user in users:
       permissions = user.permissions.all()  # Single query

**Referencia**: `Django Query
Optimization <https://docs.djangoproject.com/en/4.2/topics/db/optimization/>`__

::


   **Tipos de comentarios**:
   - 🔴 **Blocker**: Debe corregirse antes de merge
   - 🟡 **Major**: Debería corregirse (discutible)
   - 🟢 **Minor**: Sugerencia opcional (nitpick)
   - 💡 **Question**: Clarificación o pregunta
   - 👍 **Praise**: Reconocer buen trabajo

   ---

   ### PASO 4: Checklist de Calidad Detallado

   #### 4.1 Funcionalidad

   - [ ] **Cumple requerimientos**: El código hace lo que dice el PR
   - [ ] **Sin efectos secundarios**: No introduce bugs en funcionalidad existente
   - [ ] **Edge cases cubiertos**: Maneja casos límite apropiadamente
   - [ ] **Error handling**: Maneja errores gracefully

   #### 4.2 Testing

   - [ ] **Tests incluidos**: Nuevos tests para nueva funcionalidad
   - [ ] **Tests relevantes**: Tests cubren casos importantes
   - [ ] **Tests pasan**: Todos los tests ejecutan exitosamente
   - [ ] **Coverage adecuado**: >= 80% para código nuevo
   - [ ] **Tests comprensibles**: Nombres descriptivos, fáciles de entender

   #### 4.3 Código Limpio

   - [ ] **Nombres descriptivos**: Variables, funciones, clases con nombres claros
   - [ ] **Funciones pequeñas**: Funciones hacen UNA cosa (< 50 líneas ideal)
   - [ ] **DRY**: No hay código duplicado
   - [ ] **KISS**: Simplicidad sobre complejidad
   - [ ] **Comentarios útiles**: Explican el "por qué", no el "qué"

   #### 4.4 Arquitectura y Diseño

   - [ ] **Separación de concerns**: Lógica bien organizada
   - [ ] **SOLID principles**: Si aplica
   - [ ] **Patrones apropiados**: Usa patrones de diseño cuando corresponde
   - [ ] **Cohesión alta**: Módulos/clases cohesivos
   - [ ] **Acoplamiento bajo**: Dependencias mínimas

   #### 4.5 Performance

   - [ ] **Sin N+1 queries**: Optimización de queries a BD
   - [ ] **Cacheo apropiado**: Usa caché donde corresponde
   - [ ] **Algoritmos eficientes**: Complejidad O(n) razonable
   - [ ] **Recursos liberados**: Cierre de conexiones, archivos, etc.

   #### 4.6 Seguridad

   - [ ] **Sin secrets hardcoded**: API keys, passwords en variables de entorno
   - [ ] **Validación de inputs**: Sanitización de datos del usuario
   - [ ] **Autenticación/Autorización**: Endpoints protegidos apropiadamente
   - [ ] **SQL Injection**: Uso de queries parametrizadas
   - [ ] **XSS Prevention**: Output escapado en templates

   #### 4.7 Documentación

   - [ ] **Docstrings**: Funciones/clases públicas documentadas
   - [ ] **README actualizado**: Si cambia funcionalidad mayor
   - [ ] **ADRs creados/actualizados**: Para decisiones arquitectónicas
   - [ ] **Comentarios inline**: Para lógica compleja

   #### 4.8 Estilo y Convenciones

   - [ ] **Style guide**: Sigue PEP8 (Python), Airbnb (JS), etc.
   - [ ] **Nomenclatura consistente**: Sigue convenciones del proyecto
   - [ ] **Formato consistente**: Indentación, espacios, etc.
   - [ ] **Imports organizados**: Agrupados y ordenados

   ---

   ### PASO 5: Testing Local (Opcional pero Recomendado)

   Para PRs complejos o críticos:

   ```bash
   # Checkout del branch del PR
   git fetch origin
   git checkout feature/user-authentication

   # Instalar dependencias (si hay cambios)
   pip install -r requirements.txt  # Python
   npm install                      # Node.js

   # Ejecutar tests localmente
   pytest                           # Python
   npm test                         # Node.js

   # Ejecutar la aplicación localmente
   python manage.py runserver       # Django
   npm start                        # React

   # Probar manualmente la funcionalidad

Verificar: - ✅ Aplicación inicia sin errores - ✅ Funcionalidad nueva
trabaja como se espera - ✅ No hay regresiones en funcionalidad
existente

--------------

PASO 6: Decisión de Aprobación
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

6.1 Aprobar con 👍 (Approve)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Criterios**: - ✅ Todos los checks de CI/CD pasan - ✅ Código cumple
todos los estándares de calidad - ✅ Tests adecuados y pasando - ✅ Sin
blockers pendientes - ✅ Documentación completa

**Acción en GitHub**: 1. Click en “Review changes” 2. Seleccionar
“Approve” 3. Mensaje: \``\` LGTM! 👍

Excelente trabajo con la implementación de autenticación JWT. Tests bien
estructurados y coverage adecuado. \``\`

--------------

6.2 Request Changes ⚠️
^^^^^^^^^^^^^^^^^^^^^^

**Criterios**: - 🔴 Hay blockers que deben corregirse - 🔴 Tests
faltantes o failing - 🔴 Problemas de seguridad - 🔴 Violaciones
significativas de estándares

**Acción en GitHub**: 1. Click en “Review changes” 2. Seleccionar
“Request changes” 3. Mensaje claro con lista de cambios requeridos:
\```markdown ### Cambios Requeridos 🔴

1. **Security**: Remover hardcoded API key en ``config.py:42``
2. **Testing**: Agregar tests para edge case de token expirado
3. **Performance**: Optimizar N+1 query en ``auth_service.py:78``

### Sugerencias Opcionales 🟡

1. Considerar extraer lógica de refresh token a servicio separado
2. Agregar logging para intentos de autenticación fallidos

Por favor actualizar y re-solicitar review. \``\`

--------------

6.3 Comment (sin aprobar/rechazar) 💬
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Cuándo usar**: - Tienes preguntas que necesitan clarificación -
Quieres dar feedback pero no eres el único reviewer - Cambios son muy
menores (nitpicks)

**Acción en GitHub**: 1. Click en “Review changes” 2. Seleccionar
“Comment” 3. Mensaje con tus observaciones

--------------

PASO 7: Seguimiento Post-Review
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

7.1 Si solicitaste cambios
^^^^^^^^^^^^^^^^^^^^^^^^^^

-  Monitorear cuando el autor actualice el PR
-  Re-revisar los cambios específicos solicitados
-  Aprobar si todo está correcto

7.2 Si aprobaste
^^^^^^^^^^^^^^^^

-  Monitorear que el PR sea merged
-  Si hay cambios adicionales después de tu aprobación, considerar
   re-revisar

--------------

Tiempos Esperados de Respuesta
------------------------------

============== ========================
Tamaño del PR  Tiempo Máximo de Review
============== ========================
< 100 líneas   2 horas
100-300 líneas 4 horas
300-500 líneas 8 horas (1 día)
> 500 líneas   Considerar dividir el PR
============== ========================

**Nota**: Reviews de PRs deben ser PRIORIDAD sobre nuevo desarrollo.

--------------

Mejores Prácticas para Reviewers
--------------------------------

DO ✅
~~~~~

1. **Ser constructivo**: Sugerir soluciones, no solo señalar problemas
2. **Ser específico**: Indicar líneas exactas y explicar el por qué
3. **Reconocer buen código**: Comentarios positivos motivan
4. **Hacer preguntas**: Si algo no está claro, preguntar
5. **Priorizar**: Separar blockers de nitpicks
6. **Ser oportuno**: Responder rápido para no bloquear al equipo

DON’T ❌
~~~~~~~~

1. **Ser vago**: “Este código no me gusta” sin explicación
2. **Ser condescendiente**: “Obviamente esto está mal”
3. **Bikeshedding**: Discutir detalles triviales extensamente
4. **Ignorar el contexto**: Considerar limitaciones y trade-offs
5. **Ser inconsistente**: Aplicar estándares diferentes según el autor
6. **Dejar PRs sin revisar**: Causa cuellos de botella

--------------

Problemas Comunes y Soluciones
------------------------------

Problema 1: PR demasiado grande
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Solución**:

.. code:: markdown

   Este PR tiene 1,200 líneas modificadas, lo cual dificulta un review efectivo.

   **Sugerencia**: Dividir en PRs más pequeños:
   1. PR 1: Modelos y migraciones de BD
   2. PR 2: Servicios de negocio
   3. PR 3: API endpoints
   4. PR 4: Frontend integration

   Esto permitirá reviews más rápidos y de mejor calidad.

--------------

Problema 2: Conflicto de opiniones entre reviewers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Solución**: 1. Discutir en los comentarios del PR 2. Si no hay
consenso, escalar al Tech Lead 3. Tech Lead tiene voto decisivo 4.
Documentar decisión en ADR si es arquitectónica

--------------

Problema 3: Autor no responde a comentarios
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Solución**: 1. Mencionar al autor:
``@username por favor atender comentarios`` 2. Después de 24h, notificar
al Tech Lead 3. Tech Lead contacta al autor directamente

--------------

Métricas de Calidad de Reviews
------------------------------

Medir periódicamente: - **Tiempo promedio de review**: < 4 horas ideal -
**Número de iteraciones**: < 3 ideal - **Bugs encontrados en review**:
Más es mejor - **Bugs escapados a producción**: Menos es mejor

--------------

Referencias
-----------

-  `Google Engineering Practices - Code
   Review <https://google.github.io/eng-practices/review/>`__
-  `PROC-QA-001: Actividades de Garantía
   Documental <../procesos/PROC-QA-001-actividades_garantia_documental.md>`__
-  `PROC-QA-002: Estrategia
   QA <../procesos/PROC-QA-002-estrategia_qa.md>`__

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
