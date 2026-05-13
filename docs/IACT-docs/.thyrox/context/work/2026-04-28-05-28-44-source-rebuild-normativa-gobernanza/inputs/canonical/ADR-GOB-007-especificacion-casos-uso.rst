ADR-GOB-007: Especificación de Casos de Uso (Formato Completo)
==============================================================

MISMO CASO QUE LOS ULTIMOS 3 DECISIONES DE ARQUITECTURA, VALIDAR SI VA
DE LA “MANO” CON LA METODOLOGIA DE INGENERIA DE REQUIERMIENTOS

Estado
------

**APROBADO** - 2025-11-17

Contexto
--------

Los casos de uso son el nivel 3 en la jerarquía de requerimientos (ver
ADR-GOB-005) y representan **Requerimientos de Usuario**: describen cómo
un usuario interactúa con un sistema para lograr un objetivo de valor.

Confusión Muy Común
~~~~~~~~~~~~~~~~~~~

Existe una confusión generalizada en la industria:

**INCORRECTO**: “Voy a dibujar casos de uso” o “Voy a ilustrar casos de
uso”

**CORRECTO**: “Voy a **especificar** casos de uso” (escribir documentos
de texto)

Los casos de uso son **documentos de texto**, NO son diagramas. Los
**diagramas UML de casos de uso** son una herramienta complementaria
para ilustrar, pero no son el caso de uso en sí (ver ADR-GOB-008).

Problemas sin Formato Estándar
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Ambigüedad en especificaciones**: - No queda claro quién hace qué -
Mezcla de responsabilidades del actor y del sistema - Pasos sin
secuencia clara - No se distingue flujo normal de excepciones

**Falta de información crítica**: - Sin precondiciones (no se sabe qué
se requiere antes) - Sin postcondiciones (no se sabe cuál es el
resultado exitoso) - Sin referencias a reglas de negocio - Sin
trazabilidad a requisitos funcionales

**Inconsistencia entre casos de uso**: - Diferentes niveles de detalle -
Nomenclatura inconsistente - Formatos variados (algunos breves, otros
completos) - Dificultad para comparar y mantener

**Descripción de implementación (CÓMO)**: - Casos de uso que describen
detalles técnicos - Mención de bases de datos, tecnologías específicas -
Pérdida de enfoque en el usuario

Necesidades del Proyecto IACT
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. **Múltiples dominios**: Backend, Frontend, requieren casos de uso
   consistentes
2. **Múltiples stakeholders**: Desde usuarios finales hasta
   desarrolladores
3. **Trazabilidad completa**: Desde reglas de negocio hasta requisitos
   funcionales
4. **Perspectiva de usuario**: Describir QUÉ sin especificar CÓMO
5. **Documentación detallada**: Nivel completo, no breve ni casual

Decisión
--------

**Adoptar formato completo de especificación de casos de uso con
estructura de dos columnas (Actor \| Sistema) y nomenclatura obligatoria
VERBO+OBJETO.**

Principios Fundamentales
~~~~~~~~~~~~~~~~~~~~~~~~

Principio 1: Especificar vs. Ilustrar
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   ESPECIFICAR casos de uso = ESCRIBIR documentos de texto con escenarios
   ILUSTRAR diagramas UML = DIBUJAR figuras (actores, óvalos, flechas)

Los casos de uso son especificaciones textuales. Los diagramas UML son
complementarios.

Principio 2: QUÉ vs. CÓMO
^^^^^^^^^^^^^^^^^^^^^^^^^

Los casos de uso deben describir **QUÉ** debe hacer el sistema sin
decidir **CÓMO** se hará.

**CORRECTO (QUÉ)**:

::

   4. El sistema guarda la venta

**INCORRECTO (CÓMO)**:

::

   4. El sistema escribe la venta dentro de una base de datos SQL mediante un INSERT

**Razón**: El caso de uso especifica comportamiento esperado, no
implementación. La decisión de usar SQL, NoSQL, archivos, etc., es de
diseño/arquitectura.

Principio 3: Perspectiva del Usuario
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Los casos de uso describen desde la perspectiva del usuario y observan
el **comportamiento visible** del sistema, no su funcionamiento interno.

**NO deben describir**: - Componentes internos - Algoritmos específicos
- Estructura de datos - Decisiones de diseño

**DEBEN describir**: - Interacciones usuario-sistema - Resultados
observables - Secuencia de acciones - Caminos alternativos

Nomenclatura Obligatoria
~~~~~~~~~~~~~~~~~~~~~~~~

Patrón
^^^^^^

::

   VERBO + OBJETO

O equivalentemente:

::

   ACCIÓN + OBJETO

Reglas
^^^^^^

1. **Verbo**: Acción que el usuario realiza (infinitivo)
2. **Objeto**: Sobre qué actúa la acción
3. **Sin artículos**: “Registrar Vuelo” NO “Registrar el Vuelo”
4. **Singular o Plural**: Según contexto (“Imprimir Pases” está bien)

Ejemplos Correctos
^^^^^^^^^^^^^^^^^^

**Sistema de Aeropuerto**: - UC-FRONT-001: Registrar Vuelo -
UC-FRONT-002: Imprimir Pases de Abordar - UC-FRONT-003: Cambiar Asientos
- UC-FRONT-004: Registrar Equipaje - UC-FRONT-005: Comprar Actualización
de Asiento

**Sistema de Punto de Venta**: - UC-BACK-001: Procesar Venta -
UC-BACK-002: Aplicar Descuento - UC-BACK-003: Registrar Pago -
UC-BACK-004: Generar Factura - UC-BACK-005: Consultar Inventario

**Sistema IACT**: - UC-BACK-001: Iniciar Sesión - UC-BACK-002: Gestionar
Permisos - UC-BACK-003: Cambiar Contraseña - UC-BACK-004: Solicitar
Producto Químico - UC-BACK-005: Generar Reporte de Auditoría

Ejemplos INCORRECTOS
^^^^^^^^^^^^^^^^^^^^

-  “Login” (no es verbo+objeto, es un sustantivo)
-  “El usuario inicia sesión” (incluye sujeto, debe ser solo
   verbo+objeto)
-  “Sistema de autenticación” (es un sistema, no una acción)
-  “Autenticarse” (solo verbo, falta objeto)

Nomenclatura de Archivos
^^^^^^^^^^^^^^^^^^^^^^^^

::

   UC-DOMINIO-###-verbo-objeto.md

Donde: - **UC**: Use Case - **DOMINIO**: BACK, FRONT, DEVOPS, QA, AI,
GOB - **###**: Número secuencial 001-999 - **verbo-objeto**: En
snake_case (minúsculas con guiones)

**Ejemplos**:

::

   UC-BACK-001-iniciar-sesion.md
   UC-BACK-004-solicitar-producto-quimico.md
   UC-FRONT-001-registrar-vuelo.md
   UC-BACK-010-gestionar-permisos.md

Grado de Formalidad: Completo
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Existen tres grados de formalidad para casos de uso:

1. **Breves**: Resumen en un párrafo del escenario principal
2. **Casuales**: Párrafos informales que cubren varios escenarios
3. **Completos**: Todos los pasos y variaciones escritos en detalle, con
   secciones de apoyo

**Decisión**: Usar **formato completo** para el proyecto IACT.

**Razón**: Proyectos con múltiples stakeholders, requisitos regulatorios
y necesidad de trazabilidad completa requieren documentación detallada.

Formato de Dos Columnas
~~~~~~~~~~~~~~~~~~~~~~~

Estructura
^^^^^^^^^^

::

   ┌────────────────────────────────────────────────────────┐
   │  UC-DOMINIO-###: [VERBO OBJETO]                       │
   │  Actores Primarios: [Actor]                           │
   │  Actores Secundarios: [Actor, Sistema Externo]        │
   ├──────────────────────────┬─────────────────────────────┤
   │  ACCIONES DEL ACTOR      │  RESPONSABILIDADES SISTEMA  │
   ├──────────────────────────┼─────────────────────────────┤
   │ 1. Actor hace X          │                             │
   ├──────────────────────────┼─────────────────────────────┤
   │ 2. Actor introduce Y     │                             │
   ├──────────────────────────┼─────────────────────────────┤
   │                          │ 3. Sistema valida Y         │
   │                          │ 4. Sistema guarda Y         │
   ├──────────────────────────┼─────────────────────────────┤
   │ 5. Actor confirma        │                             │
   ├──────────────────────────┼─────────────────────────────┤
   │                          │ 6. Sistema muestra resultado│
   └──────────────────────────┴─────────────────────────────┘

Ventajas del Formato
^^^^^^^^^^^^^^^^^^^^

1. **Separación clara** de responsabilidades
2. **Visualmente obvio** quién hace qué
3. **Facilita validación** con stakeholders
4. **Reduce ambigüedad**
5. **Fácil identificar** requisitos funcionales del sistema

Ejemplo Completo: UC-001 Procesar Venta
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: markdown

   ## UC-BACK-001: Procesar Venta

   **Actores Primarios**: Cajero
   **Actores Secundarios**: Sistema de Inventario

   ### Flujo Normal (Happy Path)

.. list-table::
   :header-rows: 1

   * - ACCIONES DEL ACTOR
     - RESPONSABILIDADES DEL SISTEMA
   * - 1. El cajero comienza una nueva venta
     - 
   * - 2. El cajero introduce el identificador del artículo
     - 3. El sistema guarda el artículo<br>4. El sistema muestra descripción y subtotal
   * - El cajero repite pasos 2-4 hasta terminar
     - 
   * - 5. El cajero indica fin de captura
     - 6. El sistema muestra total con impuestos calculados
   * - 7. El cajero solicita método de pago al cliente
     - 
   * - 8. El cliente proporciona pago
     - 9. El sistema procesa el pago<br>10. El sistema registra la venta<br>11. El sistema actualiza inventario<br>12. El sistema imprime recibo

Elementos Obligatorios de la Especificación
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Información de Cabecera
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: markdown

   ---
   id: UC-DOMINIO-###
   tipo: caso_uso
   categoria: [dominio]
   version: 1.0.0
   fecha_creacion: YYYY-MM-DD
   ultima_actualizacion: YYYY-MM-DD
   autor: [Nombre]
   estado: [borrador|en_revision|aprobado|obsoleto]
                                                   

   # UC-DOMINIO-###: [VERBO OBJETO]

   ## Información General

   **ID**: UC-DOMINIO-###
   **Nombre**: [VERBO OBJETO]
   **Creado por**: [Autor]
   **Fecha de creación**: YYYY-MM-DD
   **Última actualización**: YYYY-MM-DD
   **Estado**: [borrador|en_revision|aprobado|obsoleto]

2. Actores
^^^^^^^^^^

.. code:: markdown

   ## Actores

   **Actores Primarios**: [Actor que ejecuta/dispara el caso de uso]

   **Actores Secundarios**: [Actores de apoyo: otros usuarios, sistemas externos, bases de datos]

**Reglas**: - **Actores Primarios**: Quiénes ejecutan el caso de uso (1
o más) - **Actores Secundarios**: Quiénes proporcionan soporte (0 o más)
- **Capitalizar nombres** de actores en la especificación - **Actores NO
son roles técnicos**: “Usuario Administrador”, “Cliente”, “Gerente de
Laboratorio” (NO “Base de Datos MySQL”)

3. Descripción
^^^^^^^^^^^^^^

.. code:: markdown

   ## Descripción

   [Breve párrafo describiendo el propósito del caso de uso y el objetivo que el actor busca lograr]

4. Desencadenador (Trigger)
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: markdown

   ## Desencadenador

   [Qué evento o condición inicia este caso de uso]

**Ejemplo**: “El solicitante indica una solicitud de un producto
químico” o “El sistema detecta que la fecha de vencimiento ha sido
alcanzada”

5. Precondiciones
^^^^^^^^^^^^^^^^^

.. code:: markdown

   ## Precondiciones

   - [Condición 1 que debe ser cierta ANTES de iniciar]
   - [Condición 2]
   - [...]

**Importante**: Pueden haber **0 o más precondiciones**. No es
obligatorio tenerlas.

**Ejemplos**: - El usuario debe estar autenticado en el sistema - Debe
existir un catálogo de productos disponible - El inventario debe estar
actualizado

6. Postcondiciones
^^^^^^^^^^^^^^^^^^

.. code:: markdown

   ## Postcondiciones

   - [Estado 1 del sistema DESPUÉS de completar exitosamente]
   - [Estado 2]
   - [...]

**Importante**: Describe el estado al finalizar **con éxito** (happy
path o caminos alternos exitosos).

**Ejemplos**: - La venta ha sido registrada en el sistema - El
inventario ha sido actualizado - El recibo ha sido impreso

7. Flujo Normal (Happy Path)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: markdown

   ## Flujo Normal (Happy Path)

.. list-table::
   :header-rows: 1

   * - ACCIONES DEL ACTOR
     - RESPONSABILIDADES DEL SISTEMA
   * - [Paso del actor]
     - [Pasos del sistema]
   * - ...
     - ...

**Reglas**: - Numerar pasos secuencialmente - Separar claramente
acciones de actor vs. sistema - Un paso = una acción concreta - Evitar
“el sistema hace A, B, C y D” en un solo paso (dividir en pasos 1, 2, 3,
4)

8. Flujos Alternos
^^^^^^^^^^^^^^^^^^

.. code:: markdown

   ## Flujos Alternos

   ### Flujo Alterno #.#: [Nombre descriptivo]

   **Punto de entrada**: Después del paso # del flujo normal

   **Condición**: [Qué condición dispara este flujo alterno]

   **Pasos**:
   - #.#.1 [Paso 1]
   - #.#.2 [Paso 2]
   - ...

   **Punto de retorno**: [Paso al que regresa, o "El caso de uso termina"]

**Ejemplo**:

.. code:: markdown

   ### Flujo Alterno 4.1: Producto No Disponible

   **Punto de entrada**: Después del paso 4 del flujo normal

   **Condición**: El producto solicitado no está en stock

   **Pasos**:
   - 4.1.1 El sistema muestra mensaje "Producto no disponible"
   - 4.1.2 El sistema sugiere productos alternativos
   - 4.1.3 El solicitante puede seleccionar un producto alternativo

   **Punto de retorno**: Regresa al paso 5 si selecciona alternativa, o termina caso de uso

9. Excepciones
^^^^^^^^^^^^^^

.. code:: markdown

   ## Excepciones

   ### Excepción #.#.#: [Nombre de la excepción]

   **Punto de entrada**: Durante el paso #.#

   **Condición**: [Condición de error]

   **Pasos**:
   - #.#.#.1 [Paso de manejo de error]
   - #.#.#.2 [...]

   **Resultado**: [El caso de uso termina | Regresa a paso #]

**Diferencia con Flujos Alternos**: - **Flujos Alternos**: Caminos
válidos que llevan a éxito (puede haber postcondición ligeramente
diferente) - **Excepciones**: Situaciones de error que típicamente
terminan el caso de uso sin éxito completo

10. Requisitos Especiales
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: markdown

   ## Requisitos Especiales

   **Requerimientos No Funcionales Relacionados**:
   - RNF-DOMINIO-###: [Descripción breve]
   - RNF-DOMINIO-###: [Descripción breve]

   **Restricciones**:
   - [Restricción técnica específica]
   - [...]

**Nota**: Solo listar RNF y restricciones **específicos** de este caso
de uso, no todos los del sistema.

11. Reglas de Negocio Relacionadas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: markdown

   ## Reglas de Negocio Relacionadas

   - RN-DOMINIO-###: [Nombre de la regla]
   - RN-DOMINIO-###: [Nombre de la regla]

**Propósito**: Trazabilidad. Permite rastrear qué reglas de negocio
influyen en este caso de uso.

12. Información Adicional
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: markdown

   ## Información Adicional

   **Prioridad**: [Alta | Media | Baja]

   **Frecuencia de uso**: [Diaria | Semanal | Mensual | Ocasional]

   **Suposiciones**:
   - [Suposición 1]
   - [...]

   **Notas**:
   - [Nota relevante]

Términos Clave
~~~~~~~~~~~~~~

Escenario
^^^^^^^^^

Un **escenario** (también llamado **flujo** o **curso**) es una
secuencia específica de acciones entre actores y el sistema.

Características: - Es una **historia particular** al usar el sistema -
Es un **camino a través del caso de uso** - También llamado **instancia
de caso de uso**

Tipos: - **Flujo Normal (Happy Path)**: Camino típico de éxito -
**Flujos Alternos**: Otros caminos válidos de éxito - **Excepciones**:
Caminos de error o fallo

Actor
^^^^^

**Definición**: Ente (persona, sistema externo, dispositivo) que
interactúa con el sistema para ejecutar un caso de uso.

**Tipos**: - **Actor Primario**: Tiene objetivos que se cumplen mediante
el caso de uso. Ejecuta/dispara el caso de uso. - **Actor Secundario**:
Proporciona servicio o información al sistema. Soporte.

**Buenas Prácticas**: - Capitalizar nombres en especificación - Usar
roles de negocio, no técnicos: “Gerente de Laboratorio” NO “Usuario con
rol admin_lab” - Pueden ser personas, sistemas externos, dispositivos de
hardware

Ubicación en Proyecto
---------------------

::

   docs/gobernanza/requisitos/requerimientos_usuario/casos_uso/
   ├── UC-BACK-001-iniciar-sesion.md
   ├── UC-BACK-002-gestionar-permisos.md
   ├── UC-BACK-003-cambiar-contrasena.md
   ├── UC-BACK-004-solicitar-producto-quimico.md
   ├── UC-BACK-005-generar-reporte-auditoria.md
   ├── UC-FRONT-001-registrar-vuelo.md
   ├── UC-FRONT-002-imprimir-pases-abordar.md
   └── ...

Alternativas Consideradas
-------------------------

Alternativa 1: Formato Breve (Un Párrafo)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción**: Resumen del caso de uso en un solo párrafo.

**Ejemplo**:

::

   UC-001: Procesar Venta. El cajero registra los artículos que el cliente
   desea comprar, el sistema calcula el total con impuestos, el cajero
   procesa el pago y el sistema imprime el recibo.

**Pros**: - Muy rápido de escribir - Fácil de leer overview

**Contras**: - Insuficiente detalle para implementar - No captura flujos
alternos - Sin precondiciones/postcondiciones - Ambigüedad en secuencia

**Razón de rechazo**: Inadecuado para proyectos complejos que requieren
trazabilidad y detalle.

Alternativa 2: Formato Casual (Párrafos Múltiples)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción**: Múltiples párrafos informales cubriendo varios
escenarios.

**Pros**: - Más detalle que formato breve - Cubre escenarios alternos -
Menos rígido que formato completo

**Contras**: - Sigue siendo ambiguo en responsabilidades - Difícil
extraer requisitos funcionales - No estructura clara - Inconsistencia
entre autores

**Razón de rechazo**: Balance inadecuado entre detalle y estructura para
proyecto IACT.

Alternativa 3: User Stories (Agile)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción**: Historias de usuario en formato “Como [rol] quiero
[función] para [beneficio]”.

**Ejemplo**:

::

   Como cajero, quiero procesar ventas de artículos para que el cliente
   pueda pagar y llevarse sus productos.

**Pros**: - Muy ágil - Enfocado en valor de negocio - Conversaciones
sobre documentación

**Contras**: - Demasiado alto nivel para detalles - No captura flujos
complejos - Sin secuencia de pasos - Insuficiente para trazabilidad
regulatoria

**Razón de rechazo**: Puede complementar pero no reemplazar casos de uso
detallados en proyecto con requisitos regulatorios.

Alternativa 4: Formato de Una Sola Columna
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción**: Secuencia de pasos sin separar actor y sistema.

**Ejemplo**:

::

   1. El cajero comienza nueva venta
   2. El cajero introduce artículo
   3. El sistema guarda artículo
   4. El sistema muestra subtotal
   ...

**Pros**: - Más simple visualmente - Secuencia clara

**Contras**: - Mezcla responsabilidades - Menos obvio quién hace qué -
Dificulta extracción de requisitos del sistema

**Razón de rechazo**: Formato de dos columnas proporciona mayor claridad
sobre responsabilidades.

Consecuencias
-------------

Positivas
~~~~~~~~~

1. **Claridad en responsabilidades**

   -  Columnas separan actor vs. sistema
   -  Obvio qué debe implementarse
   -  Fácil identificar requisitos funcionales

2. **Perspectiva de usuario mantenida**

   -  Principio QUÉ vs CÓMO previene sobre-especificación técnica
   -  Casos de uso comprensibles por stakeholders no técnicos
   -  Enfoque en valor para usuario

3. **Trazabilidad completa**

   -  Referencias a reglas de negocio
   -  Referencias a RNF
   -  IDs únicos permiten seguimiento

4. **Detalle suficiente**

   -  Formato completo con precondiciones, postcondiciones, flujos
      alternos
   -  Desarrolladores tienen información necesaria
   -  QA puede derivar casos de prueba directamente

5. **Consistencia**

   -  Nomenclatura VERBO+OBJETO estándar
   -  Estructura uniforme entre casos de uso
   -  Fácil comparar y mantener

6. **Documentación duradera**

   -  Casos de uso son estables (menos cambios que código)
   -  Sirven como especificación oficial
   -  Base para regresión y auditorías

Negativas
~~~~~~~~~

1. **Overhead de documentación**

   -  Formato completo requiere tiempo
   -  Múltiples secciones obligatorias
   -  Puede parecer excesivo para casos muy simples

   **Mitigación**:

   -  Templates aceleran creación
   -  Permitir omitir secciones vacías (ej: si no hay precondiciones)
   -  Priorizar casos de uso críticos
   -  No documentar casos triviales si no aportan valor

2. **Curva de aprendizaje**

   -  Equipo debe aprender formato
   -  Principio QUÉ vs CÓMO requiere disciplina
   -  Nomenclatura VERBO+OBJETO no es intuitiva para todos

   **Mitigación**:

   -  Capacitación inicial con ejemplos
   -  Templates con instrucciones inline
   -  Code reviews de especificaciones
   -  Guía de escritura de casos de uso (crear como GUIA-GOB-###)

3. **Mantenimiento**

   -  Cambios en reglas de negocio requieren actualizar casos de uso
   -  Riesgo de desincronización con sistema real

   **Mitigación**:

   -  Revisión periódica (trimestral)
   -  Casos de uso versionados
   -  Cambios en RN desencadenan review de casos de uso relacionados
   -  Trazabilidad facilita identificar qué actualizar

4. **No siempre es formato ideal**

   -  Para casos extremadamente simples puede ser overkill
   -  Formato de dos columnas puede ser rígido para ciertos flujos

   **Mitigación**:

   -  Permitir flexibilidad cuando se justifique
   -  Principio: “¿Este formato agrega valor o solo burocracia?”
   -  Documentar excepciones explícitamente

Implementación
--------------

Fase 1: Reorganización (Semana 1)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Mover casos_de_uso a ubicación correcta
   git mv docs/gobernanza/casos_de_uso \
           docs/gobernanza/requisitos/requerimientos_usuario/casos_uso

Fase 2: Templates (Semana 1)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Crear: - ``templates/UC-template-completo.md``: Plantilla con todas las
secciones - ``templates/UC-ejemplo-procesar-venta.md``: Ejemplo completo
como referencia

Fase 3: Capacitación (Semana 2)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Sesión de 3 horas:

   -  Diferencia especificar vs. ilustrar
   -  Principio QUÉ vs CÓMO con ejercicios
   -  Nomenclatura VERBO+OBJETO
   -  Formato de dos columnas

2. Taller práctico:

   -  Escribir 2-3 casos de uso en equipos
   -  Peer review
   -  Corrección grupal

Fase 4: Migración de Casos Existentes (Semanas 3-4)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Revisar 15 casos de uso existentes en ``casos_de_uso/``
2. Migrar a formato completo
3. Agregar secciones faltantes (precondiciones, reglas de negocio, etc.)
4. Validar nomenclatura

Fase 5: Creación de Nuevos Casos (Ongoing)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Derivar casos de uso desde: - Requerimientos de negocio documentados -
Análisis del marco integrado (ver
REPORTE_ANALISIS_MARCO_INTEGRADO_20251117_083500.md) - Entrevistas con
stakeholders

Validación
----------

Criterios de Éxito
~~~~~~~~~~~~~~~~~~

-  100% de nuevos casos de uso usan formato completo
-  100% de casos de uso usan nomenclatura VERBO+OBJETO
-  100% de casos de uso tienen referencias a reglas de negocio
   relevantes
-  Stakeholders reportan casos de uso más claros
-  Desarrolladores pueden derivar RF directamente de casos de uso

Métricas
~~~~~~~~

-  Número de casos de uso documentados
-  Cobertura: % de funcionalidades con caso de uso
-  Tiempo promedio de creación de caso de uso
-  Defectos por “requisito no entendido” (debería reducirse)
-  Satisfacción del equipo (survey)

Referencias
-----------

-  `Ivar Jacobson: Use Case 2.0
   (2011) <https://www.ivarjacobson.com/publications/white-papers/use-case-ebook>`__
-  `Alistair Cockburn: Writing Effective Use Cases
   (2000) <https://www.amazon.com/Writing-Effective-Use-Cases-Cockburn/dp/0201702258>`__
-  `ADR-GOB-005: Jerarquía de Requerimientos en 5
   Niveles <ADR-GOB-005-jerarquia-requerimientos-5-niveles.md>`__
-  `ADR-GOB-006: Clasificación y Documentación de Reglas de
   Negocio <ADR-GOB-006-clasificacion-reglas-negocio.md>`__
-  `ADR-GOB-008: Diagramas UML de Casos de
   Uso <ADR-GOB-008-diagramas-uml-casos-uso.md>`__
-  `ADR-GOB-009: Trazabilidad entre Artefactos de
   Requisitos <ADR-GOB-009-trazabilidad-artefactos-requisitos.md>`__

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
-  **Fecha de próxima revisión**: 2026-05-17
