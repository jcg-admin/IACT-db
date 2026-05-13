PROCED-GOB-003: Documentar Regla de Negocio
===========================================

Objetivo
--------

Documentar una regla de negocio siguiendo la clasificación de 5 tipos
(Hechos, Restricciones, Desencadenadores, Inferencias, Cálculos)
establecida en ADR-GOB-006, asegurando trazabilidad completa con otros
niveles de requisitos.

Pre-requisitos
--------------

Antes de comenzar este procedimiento, debe:

-  Haber leído ADR-GOB-005 (Jerarquía de Requerimientos)
-  Haber leído ADR-GOB-006 (Clasificación de Reglas de Negocio)
-  Tener acceso al repositorio del proyecto
-  Conocer el dominio al que pertenece la regla (BACK, FRONT, DEVOPS,
   QA, AI, GOB)

Resultado Esperado
------------------

Al completar este procedimiento tendrá:

-  Un archivo markdown con la regla de negocio documentada
-  Clasificación correcta en uno de los 5 tipos
-  ID único asignado (RN-DOMINIO-###)
-  Trazabilidad establecida con RNEG, UC, RF, RNF relacionados
-  Archivo en ubicación correcta del repositorio
-  Commit en git

PASO 1: Identificar y Capturar la Regla
---------------------------------------

Objetivo del Paso
~~~~~~~~~~~~~~~~~

Identificar la regla de negocio desde su fuente original y capturarla en
texto plano.

Acciones
~~~~~~~~

1. Identificar fuente de la regla:

   -  Regulación externa (ley, norma)
   -  Política interna organizacional
   -  Requerimiento de stakeholder
   -  Análisis del marco integrado

2. Capturar información clave:

   -  Descripción completa de la regla
   -  Fuente (documento, persona, regulación)
   -  Contexto de aplicación
   -  Dominio afectado

Ejemplo
~~~~~~~

::

   Fuente: LFPDPPP Artículo 8
   Descripción: "Todos los usuarios deben estar autenticados para acceder al sistema"
   Contexto: Acceso a datos personales
   Dominio: BACK

Validación
~~~~~~~~~~

-  ☐ La regla está claramente expresada
-  ☐ Se conoce la fuente original
-  ☐ Se identifica el dominio (BACK, FRONT, etc.)

PASO 2: Clasificar en uno de 5 Tipos
------------------------------------

.. _proced-gob-003-documentar-regla-negocio-objetivo-del-paso-1:

Objetivo del Paso
~~~~~~~~~~~~~~~~~

Determinar si la regla es un Hecho, Restricción, Desencadenador,
Inferencia o Cálculo.

Árbol de Decisión
~~~~~~~~~~~~~~~~~

::

   ┌─────────────────────────────────────────────────┐
   │ ¿La regla describe una verdad sobre el negocio? │
   │ (cada X tiene Y, todos X deben tener Y)         │
   └─────────┬───────────────────────────────────────┘
             │ SÍ → HECHO
             │
             │ NO
             ↓
   ┌─────────────────────────────────────────────────┐
   │ ¿La regla limita o restringe una acción?        │
   │ (debe, no debe, no puede, solo puede)           │
   └─────────┬───────────────────────────────────────┘
             │ SÍ → RESTRICCIÓN
             │
             │ NO
             ↓
   ┌─────────────────────────────────────────────────┐
   │ ¿La regla sigue formato SI...ENTONCES?          │
   └─────────┬───────────────────────────────────────┘
             │ SÍ
             ↓
   ┌─────────────────────────────────────────────────┐
   │ ¿El ENTONCES ejecuta una ACCIÓN?                │
   │ (enviar email, bloquear, notificar)             │
   └─────────┬───────────────────────────────────────┘
             │ SÍ → DESENCADENADOR DE ACCIÓN
             │
             │ NO (establece nuevo conocimiento)
             ↓
             INFERENCIA

             │ La regla NO es SI...ENTONCES
             ↓
   ┌─────────────────────────────────────────────────┐
   │ ¿La regla contiene una fórmula matemática       │
   │ o algoritmo de cálculo?                         │
   └─────────┬───────────────────────────────────────┘
             │ SÍ → CÁLCULO COMPUTACIONAL

Palabras Clave por Tipo
~~~~~~~~~~~~~~~~~~~~~~~

**HECHO**: - “cada… tiene…” - “todos… deben tener…” - “debe existir…” -
“se requiere…”

**RESTRICCIÓN**: - “debe” - “no debe” - “no puede” - “solo puede”

**DESENCADENADOR**: - “SI… ENTONCES…” - ENTONCES = acción (enviar,
notificar, ejecutar, bloquear)

**INFERENCIA**: - “SI… ENTONCES…” - ENTONCES = conocimiento nuevo
(marcar como, establecer, clasificar como)

**CÁLCULO**: - Fórmulas: +, -, \*, /, = - “se calcula como” - “se
obtiene mediante” - Tablas de valores

Ejemplo de Clasificación
~~~~~~~~~~~~~~~~~~~~~~~~

::

   Regla: "Todos los usuarios deben estar autenticados para acceder al sistema"

   Análisis:
   - ¿Verdad sobre el negocio? NO
   - ¿Limita acción? SÍ (palabra clave: "deben")
   - Tipo: RESTRICCIÓN

.. _proced-gob-003-documentar-regla-negocio-validación-1:

Validación
~~~~~~~~~~

-  ☐ Tipo seleccionado (Hecho, Restricción, Desencadenador, Inferencia,
   Cálculo)
-  ☐ Palabras clave identificadas
-  ☐ Si hay duda entre 2 tipos, documentar razón de elección

PASO 3: Asignar ID Único
------------------------

.. _proced-gob-003-documentar-regla-negocio-objetivo-del-paso-2:

Objetivo del Paso
~~~~~~~~~~~~~~~~~

Generar un identificador único que no se reutilizará nunca.

Patrón de Nomenclatura
~~~~~~~~~~~~~~~~~~~~~~

::

   RN-DOMINIO-###-descripcion.md

Donde: - **RN**: Regla de Negocio (o BR: Business Rule) - **DOMINIO**:
BACK \| FRONT \| DEVOPS \| QA \| AI \| GOB - **###**: Número secuencial
001-999 - **descripcion**: En snake_case (minúsculas con guiones)

.. _acciones-1:

Acciones
~~~~~~~~

1. Identificar último número usado en el dominio:

.. code:: bash

   ls docs/gobernanza/requisitos/reglas_negocio/**/*BACK*.md | sort | tail -1
   # Ejemplo salida: RN-BACK-028-restriccion-acceso.md
   # Siguiente número: 029

2. Generar descripción breve en snake_case:

   -  Máximo 4-5 palabras
   -  Sin artículos (el, la, los, las)
   -  Descriptiva del contenido

3. Formar ID completo

Ejemplos de IDs Correctos
~~~~~~~~~~~~~~~~~~~~~~~~~

::

   RN-BACK-001-autenticacion-obligatoria.md
   RN-BACK-028-restriccion-acceso-gerentes.md
   RN-BACK-031-notificacion-caducidad-producto.md
   RN-GOB-042-elegibilidad-graduacion.md
   RN-BACK-050-calculo-envio-terrestre.md

.. _proced-gob-003-documentar-regla-negocio-validación-2:

Validación
~~~~~~~~~~

-  ☐ ID no existe previamente
-  ☐ Número es consecutivo al último del dominio
-  ☐ Descripción en snake_case
-  ☐ Formato correcto: RN-DOMINIO-###-descripcion.md

PASO 4: Completar Template Apropiado según Tipo
-----------------------------------------------

.. _proced-gob-003-documentar-regla-negocio-objetivo-del-paso-3:

Objetivo del Paso
~~~~~~~~~~~~~~~~~

Documentar la regla usando el formato específico de su tipo.

Ubicación de Templates
~~~~~~~~~~~~~~~~~~~~~~

::

   docs/gobernanza/requisitos/reglas_negocio/
   ├── hechos/
   ├── restricciones/
   ├── desencadenadores/
   ├── inferencias/
   └── calculos/

Template según Tipo
~~~~~~~~~~~~~~~~~~~

TIPO 1: Hecho
^^^^^^^^^^^^^

.. code:: markdown

   ---
   id: RN-DOMINIO-###
   tipo: regla_negocio
   subtipo: hecho
   categoria: [dominio]
   version: 1.0.0
   fecha: 2025-11-17
                    

   # RN-DOMINIO-###: [Título del Hecho]

   ## Tipo
   Hecho

   ## Declaración
   [Declaración clara del hecho]

   ## Elementos Relacionados
   - Término 1: [Definición]
   - Término 2: [Definición]

   ## Justificación
   [Por qué este hecho es verdadero y relevante]

   ## Fuente
   [De dónde proviene: regulación, política interna, estándar]

   ## Impacto en Requisitos
   - Requisitos de Usuario: [UC-###]
   - Requisitos Funcionales: [RF-###]

TIPO 2: Restricción
^^^^^^^^^^^^^^^^^^^

.. code:: markdown

   ---
   id: RN-DOMINIO-###
   tipo: regla_negocio
   subtipo: restriccion
   categoria: [dominio]
   version: 1.0.0
   fecha: 2025-11-17
                    

   # RN-DOMINIO-###: [Título de la Restricción]

   ## Tipo
   Restricción

   ## Declaración
   [Declaración clara usando: debe, no debe, no puede, solo puede]

   ## Alcance
   - Aplica a: [Usuarios, Sistema, Módulo específico]
   - Roles afectados: [Lista de roles]

   ## Matriz de Permisos (si aplica)

   | Operación | Administrador | Staff | Usuario | Invitado |
   |---|:---:|:---:|:---:|:---:|
   | Ver registro | ✓ | ✓ | ✓ | ✓ |
   | Editar registro | ✓ | ✓ | ✗ | ✗ |
   | Eliminar registro | ✓ | ✗ | ✗ | ✗ |

   Leyenda: ✓ = Permitido    ✗ = No permitido

   ## Justificación
   [Por qué existe esta restricción: seguridad, regulación, política]

   ## Excepciones
   [Si existen excepciones a la restricción]

   ## Validación
   [Cómo se valida el cumplimiento]

   ## Impacto en Requisitos
   - Requisitos de Usuario: [UC-###]
   - Requisitos Funcionales: [RF-###]
   - Atributos de Calidad: [RNF-###]

TIPO 3: Desencadenador de Acción
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: markdown

   ---
   id: RN-DOMINIO-###
   tipo: regla_negocio
   subtipo: desencadenador
   categoria: [dominio]
   version: 1.0.0
   fecha: 2025-11-17
                    

   # RN-DOMINIO-###: [Título del Desencadenador]

   ## Tipo
   Desencadenador de Acción

   ## Declaración

   **SI**: [Condición o evento que dispara la regla]

   **ENTONCES**: [Acción(es) que se ejecutan]

   ## Condición de Activación
   [Descripción detallada de cuándo se activa]

   ## Acción(es) Desencadenada(s)
   1. [Primera acción]
   2. [Segunda acción]
   3. [...]

   ## Frecuencia Esperada
   [Qué tan frecuente se espera que se active esta regla]

   ## Prioridad
   [Alta/Media/Baja - importancia de la acción]

   ## Actores Involucrados
   - [Quién recibe notificación, quién ejecuta acción, etc.]

   ## Impacto en Requisitos
   - Requisitos de Usuario: [UC-###]
   - Requisitos Funcionales: [RF-###]

TIPO 4: Inferencia
^^^^^^^^^^^^^^^^^^

.. code:: markdown

   ---
   id: RN-DOMINIO-###
   tipo: regla_negocio
   subtipo: inferencia
   categoria: [dominio]
   version: 1.0.0
   fecha: 2025-11-17
                    

   # RN-DOMINIO-###: [Título de la Inferencia]

   ## Tipo
   Inferencia (Conocimiento Derivado)

   ## Declaración

   **SI**: [Condiciones sobre hechos existentes]

   **ENTONCES**: [Nuevo hecho que se establece]

   ## Hechos de Entrada
   - [Hecho 1]
   - [Hecho 2]
   - [...]

   ## Conocimiento Derivado
   [Descripción del nuevo hecho que se crea]

   ## Regla de Derivación
   [Lógica que conecta hechos de entrada con conocimiento derivado]

   ## Persistencia
   [Si el conocimiento derivado se guarda, dónde, por cuánto tiempo]

   ## Impacto en Requisitos
   - Requisitos de Usuario: [UC-###]
   - Requisitos Funcionales: [RF-###]

TIPO 5: Cálculo Computacional
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: markdown

   ---
   id: RN-DOMINIO-###
   tipo: regla_negocio
   subtipo: calculo
   categoria: [dominio]
   version: 1.0.0
   fecha: 2025-11-17
                    

   # RN-DOMINIO-###: [Título del Cálculo]

   ## Tipo
   Cálculo Computacional

   ## Declaración
   [Descripción en lenguaje natural del cálculo]

   ## Fórmula

[Fórmula matemática en notación clara] Variable1 = (Variable2 ×
Constante) + Variable3

::


   ## Variables de Entrada
   - Variable1: [Descripción, unidades, rango válido]
   - Variable2: [Descripción, unidades, rango válido]
   - ...

   ## Variables de Salida
   - Resultado: [Descripción, unidades, rango esperado]

   ## Constantes
   - Constante1: [Valor, unidades, origen]

   ## Tabla de Valores (si aplica)

   | ID | Rango Entrada | Valor Calculado |
   |---|---|---|
   | CAL-1 | 0 - 10 | 0% |
   | CAL-2 | 11 - 20 | 10% |
   | CAL-3 | 21+ | 20% |

   ## Ejemplo de Cálculo
   [Ejemplo numérico concreto paso a paso]

   ## Reglas de Redondeo
   [Cómo se redondean los resultados]

   ## Fuente de la Fórmula
   [Ley, regulación, política interna, estándar]

   ## Frecuencia de Actualización
   [Qué tan frecuentemente cambia esta fórmula]

   ## Impacto en Requisitos
   - Requisitos Funcionales: [RF-###]

.. _acciones-2:

Acciones
~~~~~~~~

1. Copiar template del tipo correspondiente
2. Completar frontmatter con ID y fecha
3. Llenar todas las secciones obligatorias
4. Agregar ejemplos cuando sea posible
5. Dejar placeholders en “Impacto en Requisitos” (completar en PASO 5)

.. _proced-gob-003-documentar-regla-negocio-validación-3:

Validación
~~~~~~~~~~

-  ☐ Frontmatter completo (id, tipo, subtipo, categoria, version, fecha)
-  ☐ Título con formato: RN-DOMINIO-###: [Título Descriptivo]
-  ☐ Todas las secciones obligatorias completadas
-  ☐ Lenguaje claro y sin ambigüedades
-  ☐ Ejemplos incluidos cuando aplica

PASO 5: Identificar Impacto en Otros Niveles
--------------------------------------------

.. _proced-gob-003-documentar-regla-negocio-objetivo-del-paso-4:

Objetivo del Paso
~~~~~~~~~~~~~~~~~

Establecer trazabilidad con otros artefactos de requisitos según
ADR-GOB-009.

.. _acciones-3:

Acciones
~~~~~~~~

1. **Identificar Requerimientos de Negocio (RNEG) relacionados**:

   -  ¿Esta regla contribuye a algún objetivo organizacional?
   -  ¿Qué RNEG se apoya en esta regla?

2. **Identificar Casos de Uso (UC) afectados**:

   -  ¿Qué casos de uso deben cumplir esta regla?
   -  ¿Qué interacciones de usuario están restringidas/habilitadas por
      esta regla?

3. **Identificar Requisitos Funcionales (RF) necesarios**:

   -  ¿Qué funcionalidades del sistema implementan esta regla?
   -  ¿Qué validaciones debe hacer el sistema?

4. **Identificar Atributos de Calidad (RNF) relacionados**:

   -  ¿Esta regla impone requisitos de seguridad, rendimiento,
      usabilidad?
   -  ¿Hay restricciones de calidad derivadas de esta regla?

Ejemplo de Trazabilidad
~~~~~~~~~~~~~~~~~~~~~~~

.. code:: markdown

   ## Impacto en Requisitos

   **Requerimientos de Negocio**:
   - RNEG-BACK-001: Sistema de autenticación seguro

   **Requerimientos de Usuario**:
   - UC-BACK-001: Iniciar Sesión
   - UC-BACK-003: Cambiar Contraseña

   **Requisitos Funcionales**:
   - RF-BACK-010: Validar credenciales contra base de datos
   - RF-BACK-011: Generar token JWT con expiración

   **Atributos de Calidad**:
   - RNF-BACK-005: Contraseña debe tener mínimo 8 caracteres
   - RNF-BACK-007: Sesión expira después de 30 minutos

Nota Importante
~~~~~~~~~~~~~~~

Si los artefactos relacionados (UC, RF, RNF) aún no existen, documentar
como “Pendiente de crear”:

.. code:: markdown

   **Requisitos Funcionales**:
   - RF-BACK-010: [Pendiente] Validar credenciales contra base de datos

.. _proced-gob-003-documentar-regla-negocio-validación-4:

Validación
~~~~~~~~~~

-  ☐ Al menos 1 artefacto relacionado identificado
-  ☐ Referencias bidireccionales (cuando el artefacto relacionado
   existe, actualizarlo también)
-  ☐ IDs correctos y verificables

PASO 6: Validar y Revisar
-------------------------

.. _proced-gob-003-documentar-regla-negocio-objetivo-del-paso-5:

Objetivo del Paso
~~~~~~~~~~~~~~~~~

Asegurar calidad y completitud antes de commit.

Checklist de Validación
~~~~~~~~~~~~~~~~~~~~~~~

Validación de Formato
^^^^^^^^^^^^^^^^^^^^^

-  ☐ Frontmatter completo y correcto
-  ☐ ID único asignado (RN-DOMINIO-###)
-  ☐ Tipo correcto (hecho, restriccion, desencadenador, inferencia,
   calculo)
-  ☐ Título descriptivo

Validación de Contenido
^^^^^^^^^^^^^^^^^^^^^^^

-  ☐ Declaración clara y sin ambigüedades
-  ☐ Fuente documentada
-  ☐ Ejemplos incluidos (cuando aplica)
-  ☐ Lenguaje apropiado para el tipo

Validación de Clasificación
^^^^^^^^^^^^^^^^^^^^^^^^^^^

-  ☐ Tipo es consistente con contenido
-  ☐ Si es RESTRICCIÓN: usa palabras clave (debe, no debe, no puede,
   solo puede)
-  ☐ Si es DESENCADENADOR: ENTONCES describe ACCIÓN
-  ☐ Si es INFERENCIA: ENTONCES describe CONOCIMIENTO
-  ☐ Si es CÁLCULO: incluye fórmula clara

Validación de Trazabilidad
^^^^^^^^^^^^^^^^^^^^^^^^^^

-  ☐ Al menos 1 impacto identificado
-  ☐ IDs referenciados son correctos
-  ☐ Referencias bidireccionales establecidas

Validación de Ubicación
^^^^^^^^^^^^^^^^^^^^^^^

-  ☐ Archivo en carpeta correcta según tipo:

   -  ``reglas_negocio/hechos/``
   -  ``reglas_negocio/restricciones/``
   -  ``reglas_negocio/desencadenadores/``
   -  ``reglas_negocio/inferencias/``
   -  ``reglas_negocio/calculos/``

Acciones de Revisión
~~~~~~~~~~~~~~~~~~~~

1. Leer el documento completo
2. Verificar que un stakeholder podría entenderlo
3. Validar que desarrolladores sabrían cómo implementarlo
4. Verificar que QA podría crear tests basados en esto

.. _proced-gob-003-documentar-regla-negocio-validación-5:

Validación
~~~~~~~~~~

-  ☐ Checklist completado
-  ☐ Archivo en ubicación correcta
-  ☐ Sin errores de sintaxis markdown

PASO 7: Commit y Push
---------------------

.. _proced-gob-003-documentar-regla-negocio-objetivo-del-paso-6:

Objetivo del Paso
~~~~~~~~~~~~~~~~~

Versionar la regla de negocio en git.

.. _acciones-4:

Acciones
~~~~~~~~

1. **Verificar ubicación del archivo**:

.. code:: bash

   # Ejemplo para restricción
   ls -la docs/gobernanza/requisitos/reglas_negocio/restricciones/RN-BACK-029-restriccion-ejemplo.md

2. **Agregar al staging**:

.. code:: bash

   git add docs/gobernanza/requisitos/reglas_negocio/restricciones/RN-BACK-029-restriccion-ejemplo.md

3. **Verificar status**:

.. code:: bash

   git status

4. **Crear commit descriptivo**:

.. code:: bash

   git commit -m "$(cat <<'EOF'
   docs(requisitos): agregar RN-BACK-029 restricción de acceso

   - Tipo: Restricción
   - Clasificación: Limita acceso a módulo de administración
   - Trazabilidad: UC-BACK-010, RF-BACK-045, RNF-BACK-020
   - Fuente: Política interna de seguridad

   Relacionado: ADR-GOB-006
   EOF
   )"

5. **Push al repositorio**:

.. code:: bash

   git push origin [nombre-branch]

Formato de Mensaje de Commit
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

   docs(requisitos): agregar [ID] [breve descripción]

   - Tipo: [Hecho|Restricción|Desencadenador|Inferencia|Cálculo]
   - Clasificación: [Justificación breve de la clasificación]
   - Trazabilidad: [UC-XXX, RF-XXX, RNF-XXX]
   - Fuente: [Origen de la regla]

   Relacionado: ADR-GOB-006

.. _proced-gob-003-documentar-regla-negocio-validación-6:

Validación
~~~~~~~~~~

-  ☐ Archivo agregado a git
-  ☐ Commit creado con mensaje descriptivo
-  ☐ Push exitoso

Ejemplo Completo: RN-BACK-029
-----------------------------

PASO 1: Identificación
~~~~~~~~~~~~~~~~~~~~~~

::

   Fuente: Política interna de seguridad - Documento SEC-2025-01
   Descripción: "Solo los usuarios con rol de Administrador pueden acceder al módulo de configuración del sistema"
   Contexto: Seguridad y control de acceso
   Dominio: BACK

PASO 2: Clasificación
~~~~~~~~~~~~~~~~~~~~~

::

   Análisis:
   - ¿Verdad sobre el negocio? NO
   - ¿Limita acción? SÍ (palabra clave: "solo pueden")
   - Tipo: RESTRICCIÓN

PASO 3: ID Asignado
~~~~~~~~~~~~~~~~~~~

::

   RN-BACK-029-restriccion-acceso-configuracion.md

PASO 4: Template Completado
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: markdown

   ---
   id: RN-BACK-029
   tipo: regla_negocio
   subtipo: restriccion
   categoria: backend
   version: 1.0.0
   fecha: 2025-11-17
                    

   # RN-BACK-029: Restricción de Acceso a Configuración del Sistema

   ## Tipo
   Restricción

   ## Declaración
   Solo los usuarios con rol de Administrador pueden acceder al módulo de configuración del sistema.

   ## Alcance
   - Aplica a: Todos los usuarios del sistema
   - Roles afectados: Administrador, Staff, Usuario, Invitado

   ## Matriz de Permisos

   | Operación | Administrador | Staff | Usuario | Invitado |
   |---|:---:|:---:|:---:|:---:|
   | Ver configuración | ✓ | ✗ | ✗ | ✗ |
   | Editar configuración | ✓ | ✗ | ✗ | ✗ |
   | Restaurar configuración | ✓ | ✗ | ✗ | ✗ |

   Leyenda: ✓ = Permitido    ✗ = No permitido

   ## Justificación
   La configuración del sistema afecta aspectos críticos de operación, seguridad y rendimiento. El acceso debe limitarse exclusivamente a personal con capacitación y autorización adecuadas para prevenir errores de configuración que puedan comprometer el sistema.

   ## Excepciones
   Ninguna. Esta restricción no admite excepciones por razones de seguridad.

   ## Validación
   1. El sistema debe validar el rol del usuario antes de mostrar el módulo de configuración
   2. Intentos de acceso no autorizados deben registrarse en log de auditoría
   3. Se debe mostrar mensaje de error apropiado: "Acceso denegado. Esta función requiere privilegios de Administrador."

   ## Impacto en Requisitos

   **Requerimientos de Usuario**:
   - UC-BACK-010: Gestionar Permisos
   - UC-BACK-015: Configurar Sistema

   **Requisitos Funcionales**:
   - RF-BACK-045: Validar rol antes de permitir acceso a módulo
   - RF-BACK-046: Registrar intentos de acceso no autorizado

   **Atributos de Calidad**:
   - RNF-BACK-020: Sistema debe validar permisos en < 100ms

PASO 5: Trazabilidad Identificada
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: markdown

   **Requerimientos de Usuario**:
   - UC-BACK-010: Gestionar Permisos
   - UC-BACK-015: Configurar Sistema

   **Requisitos Funcionales**:
   - RF-BACK-045: Validar rol antes de permitir acceso a módulo
   - RF-BACK-046: Registrar intentos de acceso no autorizado

   **Atributos de Calidad**:
   - RNF-BACK-020: Sistema debe validar permisos en < 100ms

PASO 6: Validación Completada
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

   ✓ Frontmatter completo
   ✓ Tipo: restriccion
   ✓ Declaración usa "solo pueden"
   ✓ Matriz de permisos incluida
   ✓ Justificación clara
   ✓ Trazabilidad con 2 UC, 2 RF, 1 RNF
   ✓ Ubicación: reglas_negocio/restricciones/

PASO 7: Commit
~~~~~~~~~~~~~~

.. code:: bash

   git add docs/gobernanza/requisitos/reglas_negocio/restricciones/RN-BACK-029-restriccion-acceso-configuracion.md

   git commit -m "$(cat <<'EOF'
   docs(requisitos): agregar RN-BACK-029 restricción de acceso a configuración

   - Tipo: Restricción
   - Clasificación: Limita acceso a módulo de configuración
   - Trazabilidad: UC-BACK-010, UC-BACK-015, RF-BACK-045, RF-BACK-046, RNF-BACK-020
   - Fuente: Política interna de seguridad SEC-2025-01

   Relacionado: ADR-GOB-006
   EOF
   )"

   git push origin main

Problemas Comunes y Soluciones
------------------------------

Problema 1: Confusión entre Desencadenador e Inferencia
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Síntoma**: La regla tiene formato SI…ENTONCES pero no sé si es
desencadenador o inferencia.

**Solución**: Analizar el ENTONCES: - Si ejecuta una ACCIÓN (enviar,
notificar, bloquear) → Desencadenador - Si establece CONOCIMIENTO
(marcar como, clasificar, establecer estado) → Inferencia

**Ejemplo**:

::

   SI usuario intenta login 3 veces incorrecto
   ENTONCES enviar email de alerta        ← ACCIÓN = Desencadenador

   SI usuario intenta login 3 veces incorrecto
   ENTONCES usuario tiene estado "sospechoso"  ← CONOCIMIENTO = Inferencia

Problema 2: No encuentro el último número de secuencia
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Solución**:

.. code:: bash

   # Ver todos los archivos del dominio ordenados
   ls docs/gobernanza/requisitos/reglas_negocio/**/*BACK*.md | sort

   # Obtener el último
   ls docs/gobernanza/requisitos/reglas_negocio/**/*BACK*.md | sort | tail -1

Problema 3: No sé qué poner en “Impacto en Requisitos”
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Solución**: No es obligatorio tener todos los niveles. Documentar solo
los que aplican:

.. code:: markdown

   ## Impacto en Requisitos

   **Requisitos Funcionales**:
   - RF-BACK-050: [Pendiente] Implementar validación de regla

   **Nota**: Los casos de uso relacionados serán identificados durante el análisis de requisitos de usuario.

Problema 4: La regla parece ser de 2 tipos a la vez
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Solución**: Probablemente deba dividirse en 2 reglas separadas.

**Ejemplo**:

::

   Regla original: "Cada orden debe tener un costo de envío calculado como peso × $0.50"

   Dividir en:
   - RN-BACK-030 (HECHO): "Cada orden debe tener un costo de envío"
   - RN-BACK-031 (CÁLCULO): "El costo de envío se calcula como peso × $0.50"

Referencias
-----------

-  `ADR-GOB-005: Jerarquía de Requerimientos en 5
   Niveles </home/user/IACT---project/docs/gobernanza/adr/ADR-GOB-005-jerarquia-requerimientos-5-niveles.md>`__
-  `ADR-GOB-006: Clasificación y Documentación de Reglas de
   Negocio </home/user/IACT---project/docs/gobernanza/adr/ADR-GOB-006-clasificacion-reglas-negocio.md>`__
-  `ADR-GOB-009: Trazabilidad entre Artefactos de
   Requisitos </home/user/IACT---project/docs/gobernanza/adr/ADR-GOB-009-trazabilidad-artefactos-requisitos.md>`__

Historial de Cambios
--------------------

======= ========== =========== ===============
Versión Fecha      Autor       Cambios
======= ========== =========== ===============
1.0.0   2025-11-17 Claude Code Versión inicial
======= ========== =========== ===============
