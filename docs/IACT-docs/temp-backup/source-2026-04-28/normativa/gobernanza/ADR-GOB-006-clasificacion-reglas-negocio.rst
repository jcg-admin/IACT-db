ADR-GOB-006: Clasificación y Documentación de Reglas de Negocio
===============================================================

Estado
------

VALIDAR SI ESTO VA DE LA MANO CON LA DEFINICION QUE SE TIENE DE
INGENIERIA DE REQUERIMIENTOS

**APROBADO** - 2025-11-17

Contexto
--------

Las reglas de negocio son el nivel más alto en la jerarquía de
requerimientos (ver ADR-GOB-005) y representan políticas, leyes y
estándares bajo los cuales opera la organización. Sin una clasificación
clara, se presentan problemas:

Problemas sin Clasificación
~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Ambigüedad en la documentación**: - No se distingue entre un hecho
inmutable y una restricción modificable - Confusión entre reglas que
desencadenan acciones vs. reglas que calculan valores - Dificultad para
identificar qué tipo de validación aplicar

**Falta de herramientas apropiadas**: - Restricciones complejas
expresadas solo en lenguaje natural - Cálculos difíciles de entender sin
estructura - No hay formato estándar para diferentes tipos

**Mantenimiento difícil**: - Cambios en reglas requieren buscar en
documentación sin estructura - No se sabe dónde buscar cierto tipo de
regla - Inconsistencias entre documentos

**Implementación inconsistente**: - Desarrolladores interpretan reglas
de manera diferente - No queda claro si una regla genera conocimiento o
ejecuta acción - Cálculos implementados incorrectamente

Necesidades del Proyecto IACT
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

El proyecto IACT opera bajo múltiples tipos de reglas:

1. **Regulatorias**: LFPDPPP, normas de salud, estándares de industria
2. **Organizacionales**: Políticas internas, procedimientos aprobados
3. **Operacionales**: Reglas de negocio para procesos diarios
4. **Técnicas**: Restricciones de acceso, validaciones, cálculos

Necesitamos: - Clasificación clara de cada tipo de regla - Herramientas
apropiadas para documentar cada tipo - Nomenclatura consistente -
Trazabilidad con otros niveles de requisitos

Decisión
--------

**Adoptar clasificación de reglas de negocio en 5 tipos con herramientas
específicas de documentación para cada uno.**

Los 5 Tipos de Reglas de Negocio
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

   1. HECHOS
      ↓
   2. RESTRICCIONES
      ↓
   3. DESENCADENADORES DE ACCIÓN
      ↓
   4. INFERENCIAS
      ↓
   5. CÁLCULOS COMPUTACIONALES

1. HECHOS
---------

Definición
~~~~~~~~~~

Declaraciones que son verdaderas sobre el negocio en un punto específico
del tiempo. Describen asociaciones o relaciones entre términos
comerciales importantes.

Características
~~~~~~~~~~~~~~~

-  Son verdades inmutables del negocio
-  Describen relaciones entre elementos
-  No pueden cambiarse arbitrariamente
-  Establecen la base de conocimiento del sistema

Palabras Clave para Identificar
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  “cada… tiene…”
-  “todos… deben tener…”
-  “debe existir…”
-  “se requiere…”

Ejemplos
~~~~~~~~

**Ejemplo 1 - Sistema de Gestión de Químicos**:

::

   RN-BACK-001: Cada contenedor de productos químicos tiene un identificador de código de barras único

   RN-BACK-002: Cada orden debe tener un costo de envío

   RN-BACK-003: Cada artículo en una orden presenta una combinación específica de:
   - Producto químico
   - Grado
   - Tamaño del envase
   - Número de contenedores

**Ejemplo 2 - Sistema Universitario**:

::

   RN-GOB-010: Todos los alumnos deben tener una matrícula para ser estudiantes de la universidad

   RN-GOB-011: Para ser alumno de la universidad, se debe estar registrado oficialmente

Formato de Documentación
~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: markdown

   ---
   id: RN-DOMINIO-###
   tipo: regla_negocio
   subtipo: hecho
   categoria: [dominio]
   version: 1.0.0
   fecha: YYYY-MM-DD
                    

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

2. RESTRICCIONES
----------------

.. _definición-1:

Definición
~~~~~~~~~~

Sentencias que restringen las acciones que el sistema o los usuarios
pueden realizar, definiendo qué se puede hacer y qué no se puede hacer.

.. _características-1:

Características
~~~~~~~~~~~~~~~

-  Limitan acciones de usuarios y sistemas
-  Definen permisos y prohibiciones
-  Frecuentemente vinculadas a roles de usuario
-  Son obligatorias (deben cumplirse)

.. _palabras-clave-para-identificar-1:

Palabras Clave para Identificar
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

+-----------------------+-----------------------+-----------------------+
| Indicador             | Función               | Ejemplo               |
+=======================+=======================+=======================+
| **Debe**              | Obligación            | “El usuario debe      |
|                       |                       | proporcionar          |
|                       |                       | credenciales”         |
+-----------------------+-----------------------+-----------------------+
| **No debe**           | Prohibición           | “El sistema no debe   |
|                       |                       | mostrar datos         |
|                       |                       | confidenciales”       |
+-----------------------+-----------------------+-----------------------+
| **No puede**          | Limitación            | “Un usuario no puede  |
|                       |                       | tener más de 10       |
|                       |                       | sesiones activas”     |
+-----------------------+-----------------------+-----------------------+
| **Solo puede**        | Restricción exclusiva | “Solo puede acceder   |
|                       |                       | el administrador”     |
+-----------------------+-----------------------+-----------------------+

.. _ejemplos-1:

Ejemplos
~~~~~~~~

**Ejemplo 1 - Sistema Financiero**:

::

   RN-BACK-020: Un solicitante de préstamo que es menor de 18 años debe tener un padre o tutor legal como cosignatario en el préstamo

**Ejemplo 2 - Sistema de Biblioteca**:

::

   RN-GOB-021: Un usuario de la biblioteca puede tener un máximo de 10 artículos en espera en cualquier momento

**Ejemplo 3 - Seguridad de Datos**:

::

   RN-BACK-022: La correspondencia no puede mostrar más de cuatro dígitos del número de seguro social del asegurado

Herramienta: Matriz de Roles y Permisos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Para restricciones basadas en roles de usuario, usar matriz:

.. code:: markdown

   ## Matriz de Roles y Permisos: [Sistema/Módulo]

   | Operación | Administrador | Staff | Usuario | Invitado |
   |---|:---:|:---:|:---:|:---:|
   | Ver registro | ✓ | ✓ | ✓ | ✓ |
   | Editar registro | ✓ | ✓ | ✗ | ✗ |
   | Eliminar registro | ✓ | ✗ | ✗ | ✗ |
   | Buscar en catálogo | ✓ | ✓ | ✓ | ✓ |
   | Generar reportes | ✓ | ✓ | ✗ | ✗ |
   | Configurar sistema | ✓ | ✗ | ✗ | ✗ |

   Leyenda: ✓ = Permitido    ✗ = No permitido

.. _formato-de-documentación-1:

Formato de Documentación
~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: markdown

   ---
   id: RN-DOMINIO-###
   tipo: regla_negocio
   subtipo: restriccion
   categoria: [dominio]
   version: 1.0.0
   fecha: YYYY-MM-DD
                    

   # RN-DOMINIO-###: [Título de la Restricción]

   ## Tipo
   Restricción

   ## Declaración
   [Declaración clara de la restricción usando palabras clave: debe, no debe, no puede, solo puede]

   ## Alcance
   - Aplica a: [Usuarios, Sistema, Módulo específico]
   - Roles afectados: [Lista de roles]

   ## Matriz de Permisos (si aplica)
   [Tabla de roles y permisos]

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

3. DESENCADENADORES DE ACCIÓN (Activadores)
-------------------------------------------

.. _definición-2:

Definición
~~~~~~~~~~

Reglas que activan alguna actividad si condiciones específicas son
verdaderas. Desencadenan comportamientos cuando el sistema detecta un
evento.

.. _características-2:

Características
~~~~~~~~~~~~~~~

-  Siguen patrón “Si… entonces…”
-  Detectan eventos específicos
-  Desencadenan comportamientos o acciones
-  La cláusula “entonces” describe una ACCIÓN

Estructura
~~~~~~~~~~

::

   SI [condición es verdadera] O [evento tiene lugar]
   ENTONCES [ejecutar esta acción]

.. _ejemplos-2:

Ejemplos
~~~~~~~~

**Ejemplo 1 - Sistema de Almacén**:

::

   RN-BACK-030: Si el almacén de productos químicos tiene contenedores de un producto químico solicitado en stock, entonces ofrece los contenedores al solicitante

**Ejemplo 2 - Control de Caducidad**:

::

   RN-BACK-031: Si se ha alcanzado la fecha de vencimiento en un envase del producto químico, entonces se notifica a la persona que está a cargo de este producto

**Ejemplo 3 - Sistema de Autenticación**:

::

   RN-BACK-032: Si un usuario intenta iniciar sesión con credenciales incorrectas 3 veces consecutivas, entonces bloquear la cuenta por 15 minutos

Diferencia con Inferencias
~~~~~~~~~~~~~~~~~~~~~~~~~~

============= ========================== ======================
Aspecto       Desencadenadores de Acción Inferencias
============= ========================== ======================
**Propósito** Ejecutar **acciones**      Crear **conocimiento**
**Resultado** Algo **sucede**            Algo **se establece**
**Ejemplo**   “Enviar notificación”      “Marcar como deudor”
============= ========================== ======================

.. _formato-de-documentación-2:

Formato de Documentación
~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: markdown

   ---
   id: RN-DOMINIO-###
   tipo: regla_negocio
   subtipo: desencadenador
   categoria: [dominio]
   version: 1.0.0
   fecha: YYYY-MM-DD
                    

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

4. INFERENCIAS
--------------

.. _definición-3:

Definición
~~~~~~~~~~

Reglas que crean un hecho nuevo a partir de otros hechos existentes.
También llamadas “conocimientos inferidos” o “hechos derivados”.

.. _características-3:

Características
~~~~~~~~~~~~~~~

-  Siguen patrón “Si… entonces…”
-  La cláusula “entonces” establece un NUEVO HECHO
-  No ejecutan acciones, solo derivan conocimiento
-  Generan información que el sistema “sabe”

.. _estructura-1:

Estructura
~~~~~~~~~~

::

   SI [condiciones sobre hechos existentes]
   ENTONCES [nuevo hecho se establece como verdadero]

.. _ejemplos-3:

Ejemplos
~~~~~~~~

**Ejemplo 1 - Sistema de Cuentas por Cobrar**:

::

   RN-BACK-040: Si un pago no se recibe dentro de los 30 días después de que se debe, entonces la cuenta es marcada como deudora

**Ejemplo 2 - Sistema de Órdenes**:

::

   RN-BACK-041: Si un vendedor nuevo no puede enviar un artículo ordenado dentro de los cinco días al recibir la orden, entonces la orden es marcada como cancelada

**Ejemplo 3 - Sistema de Estudiantes**:

::

   RN-GOB-042: Si un estudiante ha completado todos los cursos obligatorios y tiene promedio >= 7.0, entonces el estudiante es elegible para graduación

Diferencia Clave con Desencadenadores
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Desencadenador**:

::

   SI: Usuario intenta login 3 veces con credenciales incorrectas
   ENTONCES: Enviar email de alerta + Bloquear cuenta  ← ACCIONES

**Inferencia**:

::

   SI: Usuario intenta login 3 veces con credenciales incorrectas
   ENTONCES: Usuario tiene estado "sospechoso"  ← NUEVO CONOCIMIENTO

.. _formato-de-documentación-3:

Formato de Documentación
~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: markdown

   ---
   id: RN-DOMINIO-###
   tipo: regla_negocio
   subtipo: inferencia
   categoria: [dominio]
   version: 1.0.0
   fecha: YYYY-MM-DD
                    

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

5. CÁLCULOS COMPUTACIONALES
---------------------------

.. _definición-4:

Definición
~~~~~~~~~~

Reglas que transforman datos existentes en nuevos datos utilizando
fórmulas matemáticas o algoritmos específicos.

.. _características-4:

Características
~~~~~~~~~~~~~~~

-  Transforman datos con fórmulas matemáticas
-  Aplican algoritmos predefinidos
-  Frecuentemente siguen reglas externas (impuestos, estándares)
-  Deben ser precisas y no ambiguas

Fuentes Comunes
~~~~~~~~~~~~~~~

-  Fórmulas de impuestos (ISR, IVA)
-  Contribuciones de seguridad social (IMSS, INFONAVIT)
-  Estándares de la industria
-  Políticas de descuentos
-  Tarifas de envío

.. _ejemplos-4:

Ejemplos
~~~~~~~~

**Ejemplo 1 - Cálculo de Envío**:

::

   RN-BACK-050: El cargo de envío terrestre nacional por una orden que pesa más de 2 kg es de $40.75 + $0.12 por gramo de fracción adicional

   Ejemplo:
   - Peso base: 2 kg = $40.75
   - Peso adicional: 500g = 500 × $0.12 = $60.00
   - Total: $40.75 + $60.00 = $100.75

**Ejemplo 2 - Precio Total de Orden**:

::

   RN-BACK-051: El precio total de una orden se calcula como:

   Precio Total = (Suma Precio Artículos - Descuentos por Volumen) + Impuestos + Gastos de Envío + Seguro Opcional

   Donde:
   - Descuentos por Volumen: según tabla RN-BACK-052
   - Impuestos: IVA 16% sobre subtotal
   - Gastos de Envío: según RN-BACK-050
   - Seguro Opcional: 2% del subtotal si se solicita

Herramienta: Tablas de Cálculo
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Para reglas complejas, usar representación tabular:

.. code:: markdown

   ## Tabla de Descuentos por Volumen (RN-BACK-052)

   | ID | Cantidad Compra | Porcentaje Descuento |
   |---|---|---|
   | DISC-1 | 1 - 5 | 0% |
   | DISC-2 | 6 - 10 | 10% |
   | DISC-3 | 11 - 20 | 20% |
   | DISC-4 | 21 o más | 30% |

**Ventajas de tablas**: - Claridad visual - Elimina ambigüedades del
lenguaje natural - Facilita implementación - Fácil de mantener y
actualizar

.. _formato-de-documentación-4:

Formato de Documentación
~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: markdown

   ---
   id: RN-DOMINIO-###
   tipo: regla_negocio
   subtipo: calculo
   categoria: [dominio]
   version: 1.0.0
   fecha: YYYY-MM-DD
                    

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
   [Tabla estructurada para cálculos basados en rangos]

   ## Ejemplo de Cálculo
   [Ejemplo numérico concreto]

   ## Reglas de Redondeo
   [Cómo se redondean los resultados]

   ## Fuente de la Fórmula
   [Ley, regulación, política interna, estándar]

   ## Frecuencia de Actualización
   [Qué tan frecuentemente cambia esta fórmula]

   ## Impacto en Requisitos
   - Requisitos Funcionales: [RF-###]

Nomenclatura
------------

Patrón de IDs
~~~~~~~~~~~~~

::

   RN-DOMINIO-###-descripcion.md

O alternativamente:

::

   BR-DOMINIO-###-descripcion.md

Donde: - **RN** o **BR**: Regla de Negocio (Business Rule) -
**DOMINIO**: BACK, FRONT, DEVOPS, QA, AI, GOB - **###**: Número
secuencial 001-999 - **descripcion**: Descripción en snake_case

Ejemplos de Nomenclatura
~~~~~~~~~~~~~~~~~~~~~~~~

::

   RN-BACK-001-autenticacion-obligatoria.md
   RN-BACK-028-restriccion-acceso-gerentes.md
   RN-BACK-031-notificacion-caducidad-producto.md
   RN-GOB-042-elegibilidad-graduacion.md
   RN-BACK-050-calculo-envio-terrestre.md

Ubicación en Proyecto
---------------------

::

   docs/gobernanza/requisitos/reglas_negocio/
   ├── hechos/
   │   ├── RN-BACK-001-identificador-unico-contenedor.md
   │   ├── RN-BACK-002-orden-requiere-costo-envio.md
   │   └── RN-GOB-010-matricula-obligatoria-estudiantes.md
   ├── restricciones/
   │   ├── RN-BACK-020-cosignatario-prestamo-menores.md
   │   ├── RN-BACK-022-ocultacion-numeros-sensibles.md
   │   └── matrices/
   │       └── MATRIZ-BACK-001-permisos-sistema-principal.md
   ├── desencadenadores/
   │   ├── RN-BACK-030-oferta-productos-stock.md
   │   ├── RN-BACK-031-notificacion-caducidad.md
   │   └── RN-BACK-032-bloqueo-intentos-login.md
   ├── inferencias/
   │   ├── RN-BACK-040-cuenta-marcada-deudora.md
   │   ├── RN-BACK-041-orden-marcada-cancelada.md
   │   └── RN-GOB-042-estudiante-elegible-graduacion.md
   └── calculos/
       ├── RN-BACK-050-calculo-envio-terrestre.md
       ├── RN-BACK-051-precio-total-orden.md
       ├── RN-BACK-052-tabla-descuentos-volumen.md
       └── tablas/
           └── TABLA-BACK-001-descuentos-volumen.md

Alternativas Consideradas
-------------------------

Alternativa 1: Documentación sin Clasificación
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción**: Todas las reglas en un solo tipo, sin distinción.

**Pros**: - Más simple inicialmente - No requiere aprender clasificación

**Contras**: - Ambigüedad en interpretación - No hay herramientas
específicas por tipo - Dificulta implementación - Mantenimiento caótico

**Razón de rechazo**: Inadecuado para proyectos complejos con múltiples
tipos de reglas.

Alternativa 2: Solo 2 Tipos (Funcionales vs No Funcionales)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción**: Clasificar solo en dos categorías amplias.

**Pros**: - Más simple que 5 tipos - Alineado con clasificación
tradicional de requisitos

**Contras**: - Insuficiente granularidad - No captura diferencia entre
hechos y restricciones - Pierde distinción entre desencadenadores e
inferencias - No orienta sobre herramientas apropiadas

**Razón de rechazo**: Demasiado genérico, pierde valor de clasificación
detallada.

Alternativa 3: Más de 5 Tipos (Clasificación Extendida)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción**: Agregar tipos como “Derivaciones”, “Validaciones”,
“Transformaciones”, etc.

**Pros**: - Máxima granularidad - Muy específico

**Contras**: - Complejidad excesiva - Difícil para equipo aprender y
aplicar - Líneas borrosas entre algunos tipos - Overhead de
documentación

**Razón de rechazo**: 5 tipos proporciona balance adecuado entre
claridad y simplicidad.

Alternativa 4: SBVR (Semantics of Business Vocabulary and Business Rules)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción**: Estándar OMG para vocabulario y reglas de negocio.

**Pros**: - Estándar internacional - Muy formal y riguroso -
Herramientas específicas

**Contras**: - Muy complejo para equipos pequeños - Curva de aprendizaje
pronunciada - Requiere herramientas especializadas - Overkill para
proyecto de este tamaño

**Razón de rechazo**: Demasiado formal y complejo para necesidades
actuales del proyecto.

Consecuencias
-------------

Positivas
~~~~~~~~~

1. **Claridad en documentación**

   -  Tipo de regla explícito
   -  Herramientas apropiadas para cada tipo
   -  Menor ambigüedad

2. **Implementación más fácil**

   -  Desarrolladores entienden qué tipo de lógica implementar
   -  Desencadenadores claramente diferenciados de inferencias
   -  Cálculos con fórmulas precisas

3. **Mantenimiento estructurado**

   -  Cada tipo en su ubicación
   -  Fácil encontrar reglas específicas
   -  Cambios impactan área clara

4. **Validación apropiada**

   -  Cada tipo tiene criterios de validación específicos
   -  Tests más dirigidos
   -  Auditorías más eficientes

5. **Comunicación efectiva**

   -  Stakeholders entienden mejor las reglas
   -  Matrices visuales para restricciones
   -  Tablas claras para cálculos

Negativas
~~~~~~~~~

1. **Curva de aprendizaje**

   -  Equipo debe aprender 5 tipos
   -  Requiere práctica para clasificar correctamente
   -  Posible confusión inicial entre desencadenadores e inferencias

   **Mitigación**:

   -  Capacitación inicial
   -  Ejemplos claros en documentación
   -  Guía de decisión para clasificar
   -  Code reviews de documentación

2. **Overhead de clasificación**

   -  Tiempo para decidir tipo de cada regla
   -  Posibles debates sobre clasificación ambigua

   **Mitigación**:

   -  Árbol de decisión para clasificar
   -  Permitir reclasificación si se identifica error
   -  Priorizar valor sobre perfección

3. **Mantenimiento de estructura de carpetas**

   -  Múltiples subcarpetas
   -  Archivos distribuidos

   **Mitigación**:

   -  IDs únicos permiten búsqueda fácil
   -  Scripts de validación de estructura
   -  Templates automatizan creación en lugar correcto

Implementación
--------------

Fase 1: Capacitación (Semana 1)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Sesión de 2 horas sobre los 5 tipos
2. Ejercicios de clasificación
3. Creación de ejemplos en cada categoría

Fase 2: Templates (Semana 1)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Crear templates para cada tipo: - ``templates/RN-hecho-template.md`` -
``templates/RN-restriccion-template.md`` -
``templates/RN-desencadenador-template.md`` -
``templates/RN-inferencia-template.md`` -
``templates/RN-calculo-template.md``

Fase 3: Identificación de Reglas Existentes (Semana 2)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Revisar documentación actual e identificar reglas de negocio no
documentadas: 1. Entrevistas con stakeholders 2. Revisión de código
existente 3. Análisis de regulaciones aplicables

Fase 4: Documentación (Semanas 3-4)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Documentar primeras 20-30 reglas de negocio más críticas.

Validación
----------

Criterios de Éxito
~~~~~~~~~~~~~~~~~~

-  100% de nuevas reglas clasificadas en uno de los 5 tipos
-  Matrices de permisos para al menos 5 módulos principales
-  Tablas para todos los cálculos complejos
-  Desarrolladores reportan mayor claridad

Métricas
~~~~~~~~

-  Número de reglas por tipo
-  Tiempo promedio de clasificación
-  Errores de clasificación detectados en revisiones
-  Satisfacción del equipo con la clasificación

Referencias
-----------

-  `The Business Rules Group: Defining Business
   Rules <http://www.businessrulesgroup.org/>`__
-  `OMG Business Motivation Model
   (BMM) <https://www.omg.org/spec/BMM/>`__
-  `ADR-GOB-005: Jerarquía de Requerimientos en 5
   Niveles <ADR-GOB-005-jerarquia-requerimientos-5-niveles.md>`__
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
