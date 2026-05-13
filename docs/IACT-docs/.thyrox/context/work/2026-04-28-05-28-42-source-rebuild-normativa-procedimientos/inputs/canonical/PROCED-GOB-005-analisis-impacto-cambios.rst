PROCED-GOB-005: Análisis de Impacto de Cambios en Requisitos
============================================================

Objetivo
--------

Analizar el impacto de cambios en cualquier artefacto de requisitos (RN,
RNEG, UC, RF, RNF) utilizando trazabilidad bidireccional, identificar
todos los artefactos afectados, y actualizarlos de manera consistente y
atómica.

Pre-requisitos
--------------

Antes de comenzar este procedimiento, debe:

-  Haber leído ADR-GOB-009 (Trazabilidad entre Artefactos)
-  Tener trazabilidad establecida en los artefactos del proyecto
-  Conocer el artefacto que cambió o va a cambiar
-  Tener acceso al repositorio del proyecto

Resultado Esperado
------------------

Al completar este procedimiento tendrá:

-  Lista completa de artefactos afectados por el cambio
-  Checklist de cambios necesarios
-  Todos los artefactos afectados actualizados consistentemente
-  Matrices de trazabilidad actualizadas
-  Commit atómico en git con todos los cambios relacionados
-  Documentación del análisis de impacto

Tipos de Cambios
----------------

Clasificación por Magnitud
~~~~~~~~~~~~~~~~~~~~~~~~~~

+-----------------------+-----------------------+-----------------------+
| Tipo                  | Descripción           | Ejemplo               |
+=======================+=======================+=======================+
| **Menor**             | Corrección de typos,  | Corregir ortografía   |
|                       | clarificación de      | en UC-BACK-001        |
|                       | texto                 |                       |
+-----------------------+-----------------------+-----------------------+
| **Mayor**             | Cambio en lógica,     | Agregar validación    |
|                       | flujos, condiciones   | adicional en          |
|                       |                       | RN-BACK-001           |
+-----------------------+-----------------------+-----------------------+
| **Breaking**          | Cambio que invalida   | Cambiar objetivo      |
|                       | artefactos            | completo de UC,       |
|                       | dependientes          | eliminar RN           |
+-----------------------+-----------------------+-----------------------+

Clasificación por Operación
~~~~~~~~~~~~~~~~~~~~~~~~~~~

+-----------------------+-----------------------+-----------------------+
| Operación             | Descripción           | Impacto Típico        |
+=======================+=======================+=======================+
| **Modificar**         | Cambiar contenido de  | Actualizar artefactos |
|                       | artefacto existente   | relacionados          |
+-----------------------+-----------------------+-----------------------+
| **Agregar**           | Crear nuevo artefacto | Agregar referencias   |
|                       |                       | en artefactos         |
|                       |                       | relacionados          |
+-----------------------+-----------------------+-----------------------+
| **Eliminar**          | Remover artefacto     | Eliminar referencias, |
|                       |                       | posiblemente eliminar |
|                       |                       | dependientes          |
+-----------------------+-----------------------+-----------------------+
| **Deprecar**          | Marcar artefacto como | Marcar dependientes,  |
|                       | obsoleto              | planear migración     |
+-----------------------+-----------------------+-----------------------+

PASO 1: Identificar Artefacto que Cambió
----------------------------------------

Objetivo del Paso
~~~~~~~~~~~~~~~~~

Documentar claramente qué artefacto cambió, cómo cambió y por qué.

Información a Capturar
~~~~~~~~~~~~~~~~~~~~~~

1. **ID del artefacto**: RN-BACK-001, UC-BACK-010, etc.
2. **Tipo de artefacto**: Regla de Negocio, Caso de Uso, Requisito
   Funcional, etc.
3. **Tipo de cambio**: Menor, Mayor, Breaking
4. **Operación**: Modificar, Agregar, Eliminar, Deprecar
5. **Razón del cambio**: Regulación nueva, error identificado, mejora
   solicitada
6. **Contenido antes del cambio**: Capturar estado actual
7. **Contenido después del cambio**: Describir estado deseado

Plantilla de Documentación
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: markdown

   # Análisis de Impacto: [ID del Artefacto]

   ## Artefacto Modificado

   **ID**: [RN-BACK-001]
   **Tipo**: [Regla de Negocio - Restricción]
   **Archivo**: [/ruta/completa/al/archivo.md]

   ## Tipo de Cambio

   **Magnitud**: [Menor | Mayor | Breaking]
   **Operación**: [Modificar | Agregar | Eliminar | Deprecar]

   ## Razón del Cambio

   [Descripción de por qué se necesita este cambio. Ejemplo: Nueva regulación LFPDPPP requiere autenticación de dos factores]

   ## Contenido Antes del Cambio

Usuario debe estar autenticado para acceder al sistema

::


   ## Contenido Después del Cambio

Usuario debe estar autenticado con autenticación de dos factores (2FA)
para acceder al sistema

::


   ## Fecha de Análisis

   2025-11-17

   ## Analista

   [Nombre]

Ejemplo Completo
~~~~~~~~~~~~~~~~

.. code:: markdown

   # Análisis de Impacto: RN-BACK-001

   ## Artefacto Modificado

   **ID**: RN-BACK-001
   **Tipo**: Regla de Negocio - Restricción
   **Archivo**: docs/gobernanza/requisitos/reglas_negocio/restricciones/RN-BACK-001-autenticacion-obligatoria.md

   ## Tipo de Cambio

   **Magnitud**: Mayor (Breaking)
   **Operación**: Modificar

   ## Razón del Cambio

   Nueva regulación de seguridad LFPDPPP Artículo 12 bis (vigente desde 2025-12-01) requiere autenticación de dos factores para acceso a datos personales. El sistema actual solo implementa autenticación básica con usuario y contraseña.

   ## Contenido Antes del Cambio

Usuario debe estar autenticado para acceder al sistema

::


   ## Contenido Después del Cambio

Usuario debe estar autenticado con autenticación de dos factores (2FA)
para acceder al sistema. La autenticación 2FA debe usar TOTP (Time-based
One-Time Password) según RFC 6238.

::


   ## Fecha de Análisis

   2025-11-17

   ## Analista

   Claude Code

Validación
~~~~~~~~~~

-  ☐ ID del artefacto identificado
-  ☐ Tipo de cambio clasificado (Menor/Mayor/Breaking)
-  ☐ Razón del cambio documentada
-  ☐ Contenido antes y después capturado
-  ☐ Fecha y analista registrados

PASO 2: Consultar Trazabilidad Bidireccional
--------------------------------------------

.. _proced-gob-005-analisis-impacto-cambios-objetivo-del-paso-1:

Objetivo del Paso
~~~~~~~~~~~~~~~~~

Identificar todos los artefactos que tienen relación con el artefacto
modificado, tanto hacia arriba (upstream) como hacia abajo (downstream).

Trazabilidad Upstream (Hacia Arriba)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

¿De dónde viene este artefacto? ¿Qué lo justifica?

::

   RF → UC → RNEG → RN

**Preguntas**: - ¿Qué caso de uso implementa este RF? - ¿Qué regla de
negocio justifica este UC? - ¿Qué requerimiento de negocio motiva esta
RN?

Trazabilidad Downstream (Hacia Abajo)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

¿Qué depende de este artefacto? ¿Qué implementa esto?

::

   RN → RNEG → UC → RF → RNF

**Preguntas**: - ¿Qué casos de uso están influenciados por esta RN? -
¿Qué requisitos funcionales implementan este UC? - ¿Qué atributos de
calidad aplican a estos RF?

Métodos de Consulta
~~~~~~~~~~~~~~~~~~~

Método 1: Revisar Sección de Trazabilidad en el Artefacto
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Abrir el archivo markdown del artefacto y buscar secciones:

.. code:: markdown

   ## Reglas de Negocio Relacionadas
   ## Requisitos Funcionales Derivados
   ## Impacto en Requisitos
   ## Trazabilidad

Método 2: Búsqueda con Grep
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Buscar todas las referencias al artefacto en el proyecto
   grep -r "RN-BACK-001" docs/gobernanza/requisitos/

   # Buscar en casos de uso
   grep -r "RN-BACK-001" docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/

   # Buscar en requisitos funcionales
   grep -r "RN-BACK-001" docs/gobernanza/requisitos/requerimientos_funcionales/

Método 3: Consultar Matriz de Trazabilidad
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Si existe matriz de trazabilidad
   cat docs/gobernanza/trazabilidad/matrices/MATRIZ-BACK-autenticacion.md | grep "RN-BACK-001"

Ejemplo: RN-BACK-001
~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Buscar todas las referencias
   grep -r "RN-BACK-001" docs/gobernanza/requisitos/

   # Resultados:
   # docs/gobernanza/requisitos/requerimientos_negocio/RNEG-BACK-001-sistema-autenticacion-seguro.md
   # docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/UC-BACK-001-iniciar-sesion.md
   # docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/UC-BACK-003-cambiar-contrasena.md
   # docs/gobernanza/requisitos/requerimientos_funcionales/RF-BACK-010-validar-credenciales.md
   # docs/gobernanza/requisitos/requerimientos_funcionales/RF-BACK-011-generar-token-jwt.md
   # docs/gobernanza/requisitos/atributos_calidad/RNF-BACK-005-contrasena-minimo-8-caracteres.md

Documentar Resultados
~~~~~~~~~~~~~~~~~~~~~

.. code:: markdown

   ## Trazabilidad Identificada

   ### Upstream (Justificación)

   - RNEG-BACK-001: Sistema de autenticación seguro

   ### Downstream (Dependientes)

   **Requerimientos de Usuario**:
   - UC-BACK-001: Iniciar Sesión
   - UC-BACK-003: Cambiar Contraseña
   - UC-BACK-004: Recuperar Contraseña

   **Requisitos Funcionales**:
   - RF-BACK-010: Validar credenciales contra base de datos
   - RF-BACK-011: Generar token JWT con expiración

   **Atributos de Calidad**:
   - RNF-BACK-005: Contraseña debe tener mínimo 8 caracteres
   - RNF-BACK-007: Sesión expira después de 30 minutos de inactividad

.. _proced-gob-005-analisis-impacto-cambios-validación-1:

Validación
~~~~~~~~~~

-  ☐ Trazabilidad upstream identificada (0 o más artefactos)
-  ☐ Trazabilidad downstream identificada (0 o más artefactos)
-  ☐ Todos los IDs de artefactos relacionados capturados
-  ☐ Resultados documentados

PASO 3: Listar Artefactos Potencialmente Afectados
--------------------------------------------------

.. _proced-gob-005-analisis-impacto-cambios-objetivo-del-paso-2:

Objetivo del Paso
~~~~~~~~~~~~~~~~~

Crear una lista completa de todos los artefactos que PUEDEN necesitar
actualización.

Criterios de Inclusión
~~~~~~~~~~~~~~~~~~~~~~

Un artefacto está potencialmente afectado si:

1. **Referencia directa**: El artefacto menciona el ID del artefacto
   modificado
2. **Dependencia lógica**: El artefacto implementa o depende del
   artefacto modificado
3. **Cascada**: Un artefacto afectado tiene dependientes que también
   pueden afectarse

Proceso
~~~~~~~

1. Tomar lista de trazabilidad del PASO 2
2. Para cada artefacto en la lista, consultar SU trazabilidad
3. Agregar artefactos de segundo nivel si aplica
4. Consolidar lista eliminando duplicados

Ejemplo: RN-BACK-001 (2FA)
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: markdown

   ## Artefactos Potencialmente Afectados

   ### Nivel 1: Referencias Directas

   **Requerimientos de Negocio**:
   - RNEG-BACK-001: Sistema de autenticación seguro

   **Casos de Uso**:
   - UC-BACK-001: Iniciar Sesión
   - UC-BACK-003: Cambiar Contraseña
   - UC-BACK-004: Recuperar Contraseña

   **Requisitos Funcionales**:
   - RF-BACK-010: Validar credenciales contra base de datos
   - RF-BACK-011: Generar token JWT con expiración

   **Atributos de Calidad**:
   - RNF-BACK-005: Contraseña debe tener mínimo 8 caracteres
   - RNF-BACK-007: Sesión expira después de 30 minutos

   ### Nivel 2: Dependencias Indirectas

   **Nuevos artefactos necesarios**:
   - RF-BACK-[NUEVO]: Generar código TOTP
   - RF-BACK-[NUEVO]: Validar código TOTP
   - RF-BACK-[NUEVO]: Registrar dispositivo 2FA
   - RNF-BACK-[NUEVO]: Código TOTP debe expirar en 30 segundos

   **Diagramas UML**:
   - UCD-BACK-001-autenticacion.puml: Agregar paso de 2FA

   **Tests (fuera de alcance de requisitos, pero considerar)**:
   - TS-BACK-010-*: Tests de autenticación
   - TS-BACK-011-*: Tests de generación de tokens

   ### Nivel 3: Documentación Relacionada

   - README de módulo de autenticación
   - Guía de usuario para configurar 2FA

.. _proced-gob-005-analisis-impacto-cambios-validación-2:

Validación
~~~~~~~~~~

-  ☐ Todos los artefactos de nivel 1 listados
-  ☐ Artefactos de nivel 2 considerados
-  ☐ Nuevos artefactos necesarios identificados
-  ☐ Diagramas y documentación complementaria incluidos

PASO 4: Revisar Cada Artefacto y Determinar Acción
--------------------------------------------------

.. _proced-gob-005-analisis-impacto-cambios-objetivo-del-paso-3:

Objetivo del Paso
~~~~~~~~~~~~~~~~~

Para cada artefacto potencialmente afectado, determinar si realmente
necesita actualización y qué tipo de cambio requiere.

Tipos de Acción
~~~~~~~~~~~~~~~

+-----------------------+-----------------------+-----------------------+
| Acción                | Descripción           | Ejemplo               |
+=======================+=======================+=======================+
| **Actualizar**        | Modificar contenido   | Agregar paso de 2FA   |
|                       | existente             | en flujo de           |
|                       |                       | UC-BACK-001           |
+-----------------------+-----------------------+-----------------------+
| **Sin cambios**       | No requiere           | RNF-BACK-005 sigue    |
|                       | modificación          | siendo válido sin     |
|                       |                       | cambios               |
+-----------------------+-----------------------+-----------------------+
| **Crear nuevo**       | Artefacto nuevo       | RF-BACK-065: Generar  |
|                       | necesario             | código TOTP           |
+-----------------------+-----------------------+-----------------------+
| **Deprecar**          | Marcar como obsoleto  | RF-BACK-010 se        |
|                       |                       | reemplaza por         |
|                       |                       | RF-BACK-010-v2        |
+-----------------------+-----------------------+-----------------------+
| **Eliminar**          | Remover completamente | (Raro, solo si        |
|                       |                       | artefacto ya no       |
|                       |                       | aplica)               |
+-----------------------+-----------------------+-----------------------+

Proceso de Revisión
~~~~~~~~~~~~~~~~~~~

Para cada artefacto:

1. Abrir el archivo markdown
2. Leer contenido completo
3. Preguntar: “¿Este contenido sigue siendo válido con el cambio?”
4. Si NO es válido, preguntar: “¿Qué necesita cambiar exactamente?”
5. Documentar acción y cambio específico

Plantilla de Análisis por Artefacto
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: markdown

   ### [ID]: [Nombre]

   **Acción**: [Actualizar | Sin cambios | Crear nuevo | Deprecar | Eliminar]

   **Razón**: [Por qué esta acción]

   **Cambio Específico**:

[Descripción del cambio necesario]

::


   **Prioridad**: [Alta | Media | Baja]

Ejemplo: Revisión de UC-BACK-001
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: markdown

   ### UC-BACK-001: Iniciar Sesión

   **Acción**: Actualizar

   **Razón**: El flujo normal debe incluir paso de validación de código 2FA después de validar contraseña

   **Cambio Específico**:

Agregar después del paso 6 (validar credenciales):

+-----------------------------------+-----------------------------------+
| ACCIONES DEL ACTOR                | RESPONSABILIDADES DEL SISTEMA     |
+===================================+===================================+
| 7. El Usuario ingresa código 2FA  | 8. El sistema valida el código    |
| de su aplicación autenticadora    | TOTP9. El sistema verifica que el |
|                                   | código no haya expirado           |
+-----------------------------------+-----------------------------------+

Agregar excepción: ### Excepción 8.1: Código 2FA Incorrecto - El sistema
muestra error “Código 2FA incorrecto” - El Usuario puede reintentar
hasta 3 veces - Después de 3 intentos fallidos, bloquear acceso por 15
minutos

::


   **Prioridad**: Alta (cambio breaking, funcionalidad core)

Ejemplo: Revisión de RNF-BACK-005
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: markdown

   ### RNF-BACK-005: Contraseña Mínimo 8 Caracteres

   **Acción**: Sin cambios

   **Razón**: Esta regla de calidad para contraseñas sigue siendo válida independientemente de agregar 2FA. Ambas medidas de seguridad son complementarias.

   **Cambio Específico**:
   Ninguno.

   **Prioridad**: N/A

Ejemplo: Nuevo Artefacto Necesario
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: markdown

   ### RF-BACK-065: [NUEVO] Generar Código TOTP

   **Acción**: Crear nuevo

   **Razón**: Se requiere nueva funcionalidad para generar códigos TOTP según RFC 6238 para 2FA

   **Cambio Específico**:

Crear nuevo archivo: RF-BACK-065-generar-codigo-totp.md

Contenido: - El sistema debe generar código TOTP de 6 dígitos -
Algoritmo: HMAC-SHA1 - Período de validez: 30 segundos - Basado en RFC
6238 - Sincronización de tiempo: NTP

::


   **Prioridad**: Alta (requisito para implementar 2FA)

Tabla Resumen de Acciones
~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: markdown

   ## Resumen de Acciones

   | ID | Nombre | Acción | Prioridad |
   |---|---|---|---|
   | RNEG-BACK-001 | Sistema de autenticación seguro | Actualizar | Alta |
   | UC-BACK-001 | Iniciar Sesión | Actualizar | Alta |
   | UC-BACK-003 | Cambiar Contraseña | Actualizar | Media |
   | UC-BACK-004 | Recuperar Contraseña | Actualizar | Media |
   | RF-BACK-010 | Validar credenciales | Sin cambios | N/A |
   | RF-BACK-011 | Generar token JWT | Actualizar | Alta |
   | RF-BACK-065 | Generar código TOTP | Crear nuevo | Alta |
   | RF-BACK-066 | Validar código TOTP | Crear nuevo | Alta |
   | RF-BACK-067 | Registrar dispositivo 2FA | Crear nuevo | Alta |
   | RNF-BACK-005 | Contraseña mínimo 8 caracteres | Sin cambios | N/A |
   | RNF-BACK-007 | Sesión expira en 30 min | Sin cambios | N/A |
   | RNF-BACK-020 | Código TOTP expira en 30s | Crear nuevo | Alta |
   | UCD-BACK-001 | Diagrama autenticación | Actualizar | Media |

.. _proced-gob-005-analisis-impacto-cambios-validación-3:

Validación
~~~~~~~~~~

-  ☐ Cada artefacto revisado individualmente
-  ☐ Acción específica asignada
-  ☐ Cambio detallado documentado
-  ☐ Prioridad asignada
-  ☐ Tabla resumen creada

PASO 5: Crear Checklist de Cambios
----------------------------------

.. _proced-gob-005-analisis-impacto-cambios-objetivo-del-paso-4:

Objetivo del Paso
~~~~~~~~~~~~~~~~~

Convertir el análisis en una lista de tareas ejecutables con checkboxes.

Formato de Checklist
~~~~~~~~~~~~~~~~~~~~

.. code:: markdown

   ## Checklist de Implementación de Cambios

   ### Cambio Origen
   - [ ] RN-BACK-001: Actualizar con requisito de 2FA

   ### Artefactos a Actualizar

   **Alta Prioridad**:
   - [ ] RNEG-BACK-001: Actualizar descripción de sistema de autenticación
   - [ ] UC-BACK-001: Agregar pasos de 2FA en flujo normal
   - [ ] RF-BACK-011: Incluir validación de 2FA antes de generar token
   - [ ] UCD-BACK-001: Actualizar diagrama con paso de 2FA

   **Media Prioridad**:
   - [ ] UC-BACK-003: Agregar nota sobre 2FA en cambio de contraseña
   - [ ] UC-BACK-004: Documentar proceso de recuperación con 2FA

   **Baja Prioridad**:
   - [ ] Ninguno

   ### Nuevos Artefactos a Crear

   **Alta Prioridad**:
   - [ ] RF-BACK-065: Generar código TOTP
   - [ ] RF-BACK-066: Validar código TOTP
   - [ ] RF-BACK-067: Registrar dispositivo 2FA
   - [ ] RNF-BACK-020: Código TOTP expira en 30 segundos

   ### Artefactos Sin Cambios (Validados)
   - [x] RF-BACK-010: Validar credenciales (sin cambios)
   - [x] RNF-BACK-005: Contraseña mínimo 8 caracteres (sin cambios)
   - [x] RNF-BACK-007: Sesión expira en 30 minutos (sin cambios)

   ### Documentación Complementaria
   - [ ] README: Actualizar guía de autenticación
   - [ ] CHANGELOG: Documentar cambio breaking

   ### Matrices de Trazabilidad
   - [ ] MATRIZ-BACK-autenticacion.md: Agregar nuevos RF y RNF

.. _proced-gob-005-analisis-impacto-cambios-validación-4:

Validación
~~~~~~~~~~

-  ☐ Checklist completo con todos los artefactos
-  ☐ Organizado por prioridad
-  ☐ Incluye cambio origen
-  ☐ Incluye nuevos artefactos
-  ☐ Incluye matrices y documentación

PASO 6: Actualizar Artefactos Afectados
---------------------------------------

.. _proced-gob-005-analisis-impacto-cambios-objetivo-del-paso-5:

Objetivo del Paso
~~~~~~~~~~~~~~~~~

Ejecutar los cambios documentados en el checklist, actualizando cada
artefacto de manera consistente.

Orden de Actualización
~~~~~~~~~~~~~~~~~~~~~~

1. **Cambio origen**: Actualizar el artefacto que cambió primero
2. **Upstream**: Actualizar artefactos hacia arriba (RNEG)
3. **Mismo nivel**: Actualizar artefactos del mismo nivel (UC)
4. **Downstream**: Actualizar artefactos hacia abajo (RF, RNF)
5. **Nuevos artefactos**: Crear artefactos nuevos necesarios
6. **Diagramas**: Actualizar diagramas UML
7. **Documentación**: Actualizar README, guías

Proceso por Artefacto
~~~~~~~~~~~~~~~~~~~~~

1. Abrir archivo markdown del artefacto
2. Hacer los cambios específicos documentados en PASO 4
3. Actualizar sección de trazabilidad si cambió
4. Incrementar versión si aplica (1.0.0 → 1.1.0 para cambio mayor)
5. Actualizar fecha de última modificación
6. Marcar checkbox en checklist como completado
7. NO hacer commit todavía (se hará commit atómico al final)

Ejemplo: Actualizar UC-BACK-001
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # 1. Abrir archivo
   vim docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/UC-BACK-001-iniciar-sesion.md

   # 2. Actualizar frontmatter
   version: 1.0.0 → 1.1.0
   ultima_actualizacion: 2025-11-17

   # 3. Actualizar flujo normal
   # Agregar pasos de 2FA después de validar credenciales

   # 4. Actualizar reglas de negocio relacionadas
   Agregar: - RN-BACK-001: Usuario debe estar autenticado con 2FA

   # 5. Actualizar RF derivados
   Agregar: - RF-BACK-065: Generar código TOTP
   Agregar: - RF-BACK-066: Validar código TOTP

   # 6. Guardar
   :wq

   # 7. Marcar en checklist
   - [x] UC-BACK-001: Agregar pasos de 2FA en flujo normal

Ejemplo: Crear RF-BACK-065
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Usar procedimiento PROCED-GOB-003 para crear nuevo RF
   # O crear manualmente siguiendo template

   cat > docs/gobernanza/requisitos/requerimientos_funcionales/RF-BACK-065-generar-codigo-totp.md <<'EOF'
                                                                                                         
   id: RF-BACK-065
   tipo: requisito_funcional
   categoria: backend
   version: 1.0.0
   fecha: 2025-11-17
                    

   # RF-BACK-065: Generar Código TOTP

   ## Descripción

   El sistema debe generar códigos TOTP (Time-based One-Time Password) de 6 dígitos para autenticación de dos factores según RFC 6238.

   ## Especificación

   **Algoritmo**: HMAC-SHA1
   **Longitud de código**: 6 dígitos
   **Período de validez**: 30 segundos
   **Sincronización de tiempo**: NTP

   ## Trazabilidad

   **Implementa Casos de Uso**:
   - UC-BACK-001: Iniciar Sesión

   **Derivado de Reglas de Negocio**:
   - RN-BACK-001: Usuario debe estar autenticado con 2FA

   **Cumple Atributos de Calidad**:
   - RNF-BACK-020: Código TOTP expira en 30 segundos

   ## Referencias

   - [RFC 6238: TOTP](https://tools.ietf.org/html/rfc6238)
   EOF

.. _proced-gob-005-analisis-impacto-cambios-validación-5:

Validación
~~~~~~~~~~

-  ☐ Todos los checkboxes del checklist marcados
-  ☐ Cada archivo actualizado tiene fecha actualizada
-  ☐ Versiones incrementadas donde aplica
-  ☐ Trazabilidad actualizada en cada archivo
-  ☐ Archivos guardados pero NO commiteados aún

PASO 7: Validar Consistencia
----------------------------

.. _proced-gob-005-analisis-impacto-cambios-objetivo-del-paso-6:

Objetivo del Paso
~~~~~~~~~~~~~~~~~

Verificar que todos los cambios son consistentes entre sí antes de
commitear.

Checklist de Consistencia
~~~~~~~~~~~~~~~~~~~~~~~~~

Validación de Trazabilidad Bidireccional
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-  ☐ Si UC-BACK-001 menciona RF-BACK-065, entonces RF-BACK-065 menciona
   UC-BACK-001
-  ☐ Si RN-BACK-001 menciona UC-BACK-001, entonces UC-BACK-001 menciona
   RN-BACK-001
-  ☐ Todas las referencias bidireccionales son correctas

Validación de IDs
^^^^^^^^^^^^^^^^^

-  ☐ No hay referencias a IDs que no existen
-  ☐ Todos los IDs nuevos siguen nomenclatura correcta
-  ☐ No hay IDs duplicados

Validación de Formato
^^^^^^^^^^^^^^^^^^^^^

-  ☐ Todos los archivos markdown tienen frontmatter completo
-  ☐ Fechas en formato YYYY-MM-DD
-  ☐ Versiones en formato semántico (X.Y.Z)

Validación de Contenido
^^^^^^^^^^^^^^^^^^^^^^^

-  ☐ Cambios alineados con el cambio origen
-  ☐ No hay contradicciones entre artefactos
-  ☐ Terminología consistente

Scripts de Validación
~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   #!/bin/bash
   # scripts/validar-consistencia.sh

   echo "Validando trazabilidad bidireccional..."

   # Buscar todas las referencias a RF-BACK-065
   grep -r "RF-BACK-065" docs/gobernanza/requisitos/ > /tmp/rf065-refs.txt

   # El archivo RF-BACK-065 debe existir
   if [ ! -f "docs/gobernanza/requisitos/requerimientos_funcionales/RF-BACK-065-generar-codigo-totp.md" ]; then
     echo "ERROR: RF-BACK-065 es referenciado pero no existe"
     exit 1
   fi

   # Validar que UC-BACK-001 menciona RF-BACK-065
   if ! grep -q "RF-BACK-065" "docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/UC-BACK-001-iniciar-sesion.md"; then
     echo "ERROR: UC-BACK-001 no menciona RF-BACK-065 pero debería"
     exit 1
   fi

   # Validar que RF-BACK-065 menciona UC-BACK-001
   if ! grep -q "UC-BACK-001" "docs/gobernanza/requisitos/requerimientos_funcionales/RF-BACK-065-generar-codigo-totp.md"; then
     echo "ERROR: RF-BACK-065 no menciona UC-BACK-001 pero debería"
     exit 1
   fi

   echo "Validación exitosa"

Revisión Manual
~~~~~~~~~~~~~~~

1. Leer el cambio origen (RN-BACK-001) nuevamente
2. Leer cada artefacto actualizado
3. Preguntar: “¿Este artefacto es consistente con el cambio origen?”
4. Preguntar: “¿Este artefacto es consistente con los demás artefactos
   actualizados?”

.. _proced-gob-005-analisis-impacto-cambios-validación-6:

Validación
~~~~~~~~~~

-  ☐ Script de validación ejecutado sin errores
-  ☐ Revisión manual completada
-  ☐ Trazabilidad bidireccional verificada
-  ☐ Contenido consistente entre artefactos
-  ☐ Listo para commit

PASO 8: Actualizar Matrices de Trazabilidad
-------------------------------------------

.. _proced-gob-005-analisis-impacto-cambios-objetivo-del-paso-7:

Objetivo del Paso
~~~~~~~~~~~~~~~~~

Actualizar las matrices de trazabilidad para reflejar los cambios y
nuevas relaciones.

Matrices a Actualizar
~~~~~~~~~~~~~~~~~~~~~

1. Matriz vertical (por columna de jerarquía)
2. Matriz horizontal (por caso de uso)
3. Matriz de módulo específico

Ejemplo: Actualizar MATRIZ-BACK-autenticacion.md
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: markdown

   # Matriz de Trazabilidad: Módulo de Autenticación

   Última actualización: 2025-11-17

   ## Matriz Vertical

   | RN | RNEG | UC | RF | RNF |
   |---|---|---|---|---|
   | RN-BACK-001 | RNEG-BACK-001 | UC-BACK-001 | RF-BACK-010 | RNF-BACK-005 |
   |  |  |  | RF-BACK-011 | RNF-BACK-007 |
   |  |  |  | RF-BACK-065 ← NUEVO | RNF-BACK-020 ← NUEVO |
   |  |  |  | RF-BACK-066 ← NUEVO |  |
   |  |  |  | RF-BACK-067 ← NUEVO |  |
   |  |  | UC-BACK-003 | RF-BACK-014 | RNF-BACK-005 |
   |  |  | UC-BACK-004 | RF-BACK-018 |  |

   ## Matriz por Caso de Uso: UC-BACK-001

   | Tipo | ID | Nombre | Versión |
   |---|---|---|---|
   | RN | RN-BACK-001 | Usuario debe estar autenticado con 2FA | 2.0.0 ← ACTUALIZADO |
   | RNEG | RNEG-BACK-001 | Sistema de autenticación seguro | 1.1.0 ← ACTUALIZADO |
   | UC | UC-BACK-001 | Iniciar Sesión | 1.1.0 ← ACTUALIZADO |
   | RF | RF-BACK-010 | Validar credenciales | 1.0.0 |
   | RF | RF-BACK-011 | Generar token JWT | 1.1.0 ← ACTUALIZADO |
   | RF | RF-BACK-065 | Generar código TOTP | 1.0.0 ← NUEVO |
   | RF | RF-BACK-066 | Validar código TOTP | 1.0.0 ← NUEVO |
   | RF | RF-BACK-067 | Registrar dispositivo 2FA | 1.0.0 ← NUEVO |
   | RNF | RNF-BACK-005 | Contraseña mínimo 8 caracteres | 1.0.0 |
   | RNF | RNF-BACK-007 | Sesión expira en 30 minutos | 1.0.0 |
   | RNF | RNF-BACK-020 | Código TOTP expira en 30 segundos | 1.0.0 ← NUEVO |

   ## Cambios en esta Actualización

   **Fecha**: 2025-11-17
   **Cambio Origen**: RN-BACK-001 actualizado para requerir 2FA

   **Artefactos Actualizados**:
   - RN-BACK-001: v1.0.0 → v2.0.0 (Breaking change: agregar 2FA)
   - RNEG-BACK-001: v1.0.0 → v1.1.0 (Actualizar descripción)
   - UC-BACK-001: v1.0.0 → v1.1.0 (Agregar pasos de 2FA)
   - RF-BACK-011: v1.0.0 → v1.1.0 (Validar 2FA antes de token)

   **Artefactos Nuevos**:
   - RF-BACK-065: Generar código TOTP
   - RF-BACK-066: Validar código TOTP
   - RF-BACK-067: Registrar dispositivo 2FA
   - RNF-BACK-020: Código TOTP expira en 30 segundos

.. _proced-gob-005-analisis-impacto-cambios-validación-7:

Validación
~~~~~~~~~~

-  ☐ Matriz vertical actualizada
-  ☐ Matrices horizontales actualizadas
-  ☐ Nuevos artefactos agregados
-  ☐ Versiones reflejadas correctamente
-  ☐ Cambios documentados en la matriz

PASO 9: Commit Atómico de Todos los Cambios
-------------------------------------------

.. _proced-gob-005-analisis-impacto-cambios-objetivo-del-paso-8:

Objetivo del Paso
~~~~~~~~~~~~~~~~~

Crear un commit único que incluya todos los cambios relacionados con el
análisis de impacto.

Principio de Commit Atómico
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Un commit atómico debe: - Incluir TODOS los cambios relacionados - Ser
una unidad lógica completa - Dejar el repositorio en estado consistente
- No romper la funcionalidad si se hace checkout de ese commit

Verificar Archivos Modificados
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   git status

   # Salida esperada:
   # modified:   docs/gobernanza/requisitos/reglas_negocio/restricciones/RN-BACK-001-autenticacion-obligatoria.md
   # modified:   docs/gobernanza/requisitos/requerimientos_negocio/RNEG-BACK-001-sistema-autenticacion-seguro.md
   # modified:   docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/UC-BACK-001-iniciar-sesion.md
   # modified:   docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/UC-BACK-003-cambiar-contrasena.md
   # modified:   docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/UC-BACK-004-recuperar-contrasena.md
   # modified:   docs/gobernanza/requisitos/requerimientos_funcionales/RF-BACK-011-generar-token-jwt.md
   # new file:   docs/gobernanza/requisitos/requerimientos_funcionales/RF-BACK-065-generar-codigo-totp.md
   # new file:   docs/gobernanza/requisitos/requerimientos_funcionales/RF-BACK-066-validar-codigo-totp.md
   # new file:   docs/gobernanza/requisitos/requerimientos_funcionales/RF-BACK-067-registrar-dispositivo-2fa.md
   # new file:   docs/gobernanza/requisitos/atributos_calidad/RNF-BACK-020-codigo-totp-expira-30s.md
   # modified:   docs/gobernanza/requisitos/requerimientos_usuario/diagramas/casos_uso/UCD-BACK-001-autenticacion.puml
   # modified:   docs/gobernanza/trazabilidad/matrices/MATRIZ-BACK-autenticacion.md

Agregar Todos los Archivos
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Agregar todos los archivos modificados y nuevos
   git add docs/gobernanza/requisitos/
   git add docs/gobernanza/trazabilidad/

Crear Mensaje de Commit Descriptivo
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   git commit -m "$(cat <<'EOF'
   docs(requisitos): implementar autenticación 2FA (BREAKING CHANGE)

   Cambio origen: RN-BACK-001 actualizado para requerir autenticación de dos
   factores (2FA) según nueva regulación LFPDPPP Art. 12 bis.

   BREAKING CHANGE: La autenticación ahora requiere 2FA con TOTP. Esto afecta
   todos los flujos de inicio de sesión.

   Artefactos actualizados (6):
   - RN-BACK-001: v1.0.0 → v2.0.0 - Agregar requisito de 2FA
   - RNEG-BACK-001: v1.0.0 → v1.1.0 - Actualizar descripción
   - UC-BACK-001: v1.0.0 → v1.1.0 - Agregar pasos de 2FA en flujo
   - UC-BACK-003: v1.0.0 → v1.1.0 - Nota sobre 2FA
   - UC-BACK-004: v1.0.0 → v1.1.0 - Proceso de recuperación con 2FA
   - RF-BACK-011: v1.0.0 → v1.1.0 - Validar 2FA antes de generar token

   Artefactos nuevos (4):
   - RF-BACK-065: Generar código TOTP según RFC 6238
   - RF-BACK-066: Validar código TOTP
   - RF-BACK-067: Registrar dispositivo 2FA del usuario
   - RNF-BACK-020: Código TOTP debe expirar en 30 segundos

   Diagramas actualizados:
   - UCD-BACK-001: Agregar paso de validación 2FA

   Matrices actualizadas:
   - MATRIZ-BACK-autenticacion.md

   Fecha de análisis: 2025-11-17
   Analista: Claude Code

   Relacionado: ADR-GOB-005, ADR-GOB-009
   Regulación: LFPDPPP Art. 12 bis
   EOF
   )"

Formato de Mensaje de Commit
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

   docs(requisitos): [descripción breve del cambio] (BREAKING CHANGE si aplica)

   Cambio origen: [ID] [descripción del cambio origen]

   BREAKING CHANGE: [descripción del impacto si es breaking]

   Artefactos actualizados (N):
   - [ID]: [versión anterior] → [versión nueva] - [cambio]
   - ...

   Artefactos nuevos (N):
   - [ID]: [descripción]
   - ...

   Diagramas actualizados:
   - [ID]: [cambio]

   Matrices actualizadas:
   - [archivo]

   Fecha de análisis: [YYYY-MM-DD]
   Analista: [Nombre]

   Relacionado: [ADRs relacionados]
   [Información adicional relevante]

Push al Repositorio
~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Verificar que todo está commiteado
   git status

   # Debería mostrar:
   # On branch main
   # nothing to commit, working tree clean

   # Push
   git push origin main

.. _proced-gob-005-analisis-impacto-cambios-validación-8:

Validación
~~~~~~~~~~

-  ☐ Todos los archivos agregados a git
-  ☐ Commit creado con mensaje descriptivo completo
-  ☐ Mensaje incluye BREAKING CHANGE si aplica
-  ☐ Mensaje lista todos los artefactos actualizados y nuevos
-  ☐ Push exitoso
-  ☐ Working tree clean

Documentar el Análisis
----------------------

.. _proced-gob-005-analisis-impacto-cambios-objetivo-del-paso-9:

Objetivo del Paso
~~~~~~~~~~~~~~~~~

Guardar el análisis de impacto como referencia futura.

Crear Documento de Análisis
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   mkdir -p docs/gobernanza/analisis_impacto/

   cat > docs/gobernanza/analisis_impacto/ANALISIS-2025-11-17-RN-BACK-001-2FA.md <<'EOF'
   [Contenido completo del análisis de los PASOS 1-9]
   EOF

Commitar Documento de Análisis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   git add docs/gobernanza/analisis_impacto/ANALISIS-2025-11-17-RN-BACK-001-2FA.md

   git commit -m "docs(analisis): documentar análisis de impacto RN-BACK-001 (2FA)

   Análisis completo del cambio de autenticación básica a 2FA.
   Fecha: 2025-11-17"

   git push origin main

Ejemplo Completo: RN-BACK-015 Cambio Menor
------------------------------------------

Escenario
~~~~~~~~~

::

   Cambio: Corregir typo en RN-BACK-015
   Antes: "Solo usuarios con rol Auditor puede generar reportes"
   Después: "Solo usuarios con rol Auditor pueden generar reportes"
   Tipo: Menor (corrección ortográfica)

PASO 1: Identificar Artefacto
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: markdown

   ## Artefacto Modificado
   **ID**: RN-BACK-015
   **Tipo**: Regla de Negocio - Restricción
   **Magnitud**: Menor
   **Operación**: Modificar
   **Razón**: Corrección ortográfica (puede → pueden)

PASO 2: Consultar Trazabilidad
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   grep -r "RN-BACK-015" docs/gobernanza/requisitos/

   # Resultados:
   # UC-BACK-020-generar-reporte-auditoria.md

PASO 3: Artefactos Afectados
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: markdown

   ## Artefactos Potencialmente Afectados

   - UC-BACK-020: Generar Reporte de Auditoría (solo referencia, contenido no afectado)

PASO 4: Determinar Acción
~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: markdown

   ### UC-BACK-020
   **Acción**: Sin cambios
   **Razón**: El typo está en RN-BACK-015, no en UC-BACK-020. La referencia por ID sigue siendo válida.

PASO 5: Checklist
~~~~~~~~~~~~~~~~~

.. code:: markdown

   ## Checklist

   - [ ] RN-BACK-015: Corregir typo "puede" → "pueden"
   - [x] UC-BACK-020: Sin cambios (validado)

PASO 6-7: Actualizar y Validar
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Solo actualizar RN-BACK-015
   vim docs/gobernanza/requisitos/reglas_negocio/restricciones/RN-BACK-015-restriccion-acceso-auditores.md

   # Cambiar "puede" por "pueden"
   # Actualizar fecha (no versión, es cambio menor)

PASO 8: Matrices
~~~~~~~~~~~~~~~~

.. code:: markdown

   No requiere actualización de matrices (contenido no cambió, solo ortografía)

PASO 9: Commit
~~~~~~~~~~~~~~

.. code:: bash

   git add docs/gobernanza/requisitos/reglas_negocio/restricciones/RN-BACK-015-restriccion-acceso-auditores.md

   git commit -m "fix(requisitos): corregir typo en RN-BACK-015

   Corrección ortográfica: 'puede' → 'pueden'

   Artefactos afectados: Ninguno (solo corrección ortográfica)

   Fecha: 2025-11-17"

   git push origin main

Problemas Comunes y Soluciones
------------------------------

Problema 1: Demasiados artefactos afectados
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Síntoma**: El cambio afecta 30+ artefactos.

**Solución**: 1. Priorizar por criticidad 2. Hacer cambios en fases: -
Fase 1: Artefactos críticos (Alta prioridad) - Fase 2: Artefactos
importantes (Media prioridad) - Fase 3: Artefactos complementarios (Baja
prioridad) 3. Crear issues/tickets para trackear cada fase

Problema 2: Cambio en cascada infinito
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Síntoma**: Cada artefacto actualizado requiere actualizar 10 más.

**Solución**: - Definir alcance máximo (ej: 3 niveles de profundidad) -
Documentar artefactos fuera de alcance para actualización futura -
Priorizar por impacto en funcionalidad

Problema 3: No encuentro todas las referencias
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Solución**:

.. code:: bash

   # Búsqueda exhaustiva con grep
   grep -r "RN-BACK-001" docs/
   grep -r "RN-BACK-001" --include="*.md" .

   # Búsqueda por palabra clave
   grep -r "autenticación" docs/gobernanza/requisitos/

   # Consultar git history
   git log --all --grep="RN-BACK-001"

Problema 4: Conflicto entre cambios
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Síntoma**: Dos personas modificando el mismo artefacto
simultáneamente.

**Solución**: 1. Coordinar análisis de impacto en equipo 2. Usar
branches para análisis grandes 3. Comunicar en PR qué artefactos se
están modificando 4. Resolver conflictos manualmente revisando ambos
cambios

Referencias
-----------

-  `ADR-GOB-005: Jerarquía de Requerimientos en 5
   Niveles </home/user/IACT---project/docs/gobernanza/adr/ADR-GOB-005-jerarquia-requerimientos-5-niveles.md>`__
-  `ADR-GOB-009: Trazabilidad entre Artefactos de
   Requisitos </home/user/IACT---project/docs/gobernanza/adr/ADR-GOB-009-trazabilidad-artefactos-requisitos.md>`__
-  `PROCED-GOB-003: Documentar Regla de
   Negocio </home/user/IACT---project/docs/gobernanza/procedimientos/PROCED-GOB-003-documentar-regla-negocio.md>`__
-  `PROCED-GOB-004: Crear Caso de
   Uso </home/user/IACT---project/docs/gobernanza/procedimientos/PROCED-GOB-004-crear-caso-uso.md>`__

Historial de Cambios
--------------------

======= ========== =========== ===============
Versión Fecha      Autor       Cambios
======= ========== =========== ===============
1.0.0   2025-11-17 Claude Code Versión inicial
======= ========== =========== ===============
