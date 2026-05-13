.. meta::
   :artefacto: SBVR_05
   :tipo: Ontologia SBVR
   :dominio: base_cognitiva
   :subdominio: _ontologia_sbvr
   :estado: Aprobado
   :version: 1.1.0
   :fecha_creacion: 2025-12-20
   :ultimo_cambio: 2025-12-21
   :autor: Equipo IACT
   :clasificacion: Interno

.. _sbvr-05:

===============================
SBVR_05: Vocabulario Controlado
===============================


Proposito
---------

Este documento define el **vocabulario controlado** para escribir Business
Rules en el proyecto IACT. Especifica los terminos permitidos, prohibidos
y las reglas de redaccion que garantizan precision y consistencia.

----

1. Principios del Vocabulario Controlado
----------------------------------------

1.1 Objetivo
^^^^^^^^^^^^

.. code-block:: text

   Un vocabulario controlado garantiza:

   - PRECISION: Cada termino tiene un solo significado
   - CONSISTENCIA: Mismos terminos en todas las BR
   - VERIFICABILIDAD: Reglas pueden validarse automaticamente
   - CLARIDAD: Sin ambiguedad ni interpretaciones multiples

1.2 Regla de Oro
^^^^^^^^^^^^^^^^

.. code-block:: text

   "Si una palabra puede interpretarse de mas de una manera,
    NO debe usarse en una Business Rule."

----

2. Keywords Obligatorios (Modalidad)
------------------------------------

2.1 Keywords Deonticos
^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Keyword
     - Significado
     - Ejemplo
   * - **DEBE**
     - Obligacion incondicional
     - "Usuario DEBE tener al menos un rol"
   * - **NO DEBE**
     - Prohibicion incondicional
     - "Sistema NO DEBE enviar email externo"
   * - **PUEDE**
     - Permiso (opcional)
     - "Administrador PUEDE cerrar sesion de otro usuario"
   * - **SOLO**
     - Restriccion exclusiva
     - "SOLO R001 puede crear usuarios"
   * - **UNICAMENTE**
     - Sinonimo de SOLO
     - "Notificaciones UNICAMENTE via buzon interno"
   * - **DEBERIA**
     - Recomendado pero no obligatorio
     - "Sistema DEBERIA enviar confirmacion por email"

2.2 Keywords Aleticos
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Keyword
     - Significado
     - Ejemplo
   * - **ES**
     - Verdad estructural
     - "Username ES unico"
   * - **TIENE**
     - Posesion/relacion
     - "Usuario TIENE exactamente un segmento"
   * - **CADA**
     - Cuantificador universal
     - "CADA rol contiene al menos un permiso"
   * - **EXISTE**
     - Cuantificador existencial
     - "EXISTE al menos un administrador activo"
   * - **EXACTAMENTE**
     - Cardinalidad precisa
     - "Usuario tiene EXACTAMENTE una sesion activa"

2.3 Keywords Condicionales
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Keyword
     - Significado
     - Ejemplo
   * - **SI**
     - Condicion antecedente
     - "SI usuario falla 3 intentos..."
   * - **ENTONCES**
     - Consecuencia
     - "...ENTONCES sistema bloquea cuenta"
   * - **CUANDO**
     - Sinonimo de SI (temporal)
     - "CUANDO hora = 00:00, ejecutar ETL"
   * - **MIENTRAS**
     - Condicion continua
     - "MIENTRAS sesion activa, registrar actividad"

----

3. Terminos Prohibidos
----------------------

3.1 Palabras Ambiguas
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Prohibido
     - Problema
     - Alternativa
   * - podria
     - Ambiguo (¿permiso o posibilidad?)
     - PUEDE
   * - normalmente
     - Impreciso (¿cuando no?)
     - Especificar condicion exacta
   * - generalmente
     - Impreciso
     - Especificar condicion exacta
   * - a veces
     - Impreciso (¿cuando?)
     - SI [condicion] ENTONCES
   * - quizas
     - Incertidumbre
     - Eliminar o especificar
   * - posiblemente
     - Incertidumbre
     - Eliminar o especificar
   * - aproximadamente
     - Impreciso
     - Valor exacto o rango

3.2 Palabras Vagas
^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Prohibido
     - Problema
     - Alternativa
   * - rapido
     - ¿Cuanto es rapido?
     - "< 2 segundos"
   * - suficiente
     - ¿Cuanto es suficiente?
     - Valor numerico especifico
   * - adecuado
     - Subjetivo
     - Criterio medible
   * - razonable
     - Subjetivo
     - Criterio especifico
   * - varios
     - ¿Cuantos?
     - Numero exacto o rango
   * - algunos
     - ¿Cuantos?
     - "al menos N" o "entre N y M"
   * - muchos
     - ¿Cuantos?
     - Numero o porcentaje
   * - frecuentemente
     - ¿Cada cuanto?
     - "cada N horas/dias"

3.3 Construcciones Prohibidas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   PROHIBIDO                          CORRECTO
   ─────────────────────────────────────────────────────────────
   "debe ser rapido"                  "debe responder en < 2 seg"
   "normalmente se hace"              "DEBE hacerse" o eliminar
   "el usuario puede o no"            "el usuario PUEDE" (implicito)
   "es recomendable"                  "DEBERIA" (si opcional) o "DEBE"
   "en la medida de lo posible"       Eliminar (no aporta)
   "segun sea necesario"              Especificar condicion
   "a menos que se indique"           SI [condicion] ENTONCES

----

4. Conceptos del Dominio
------------------------

4.1 Terminos Preferidos
^^^^^^^^^^^^^^^^^^^^^^^

Usar siempre el termino preferido (de SBVR_01):

.. list-table::
   :header-rows: 1
   :widths: 30 35 35

   * - Preferido
     - Sinonimos Aceptados
     - NO Usar
   * - Usuario
     - Operador, Cuenta
     - user, persona, individuo
   * - Rol
     - Rol funcional
     - perfil, grupo, tipo
   * - Permiso
     - Privilegio, Capacidad
     - derecho, acceso
   * - Sesion
     - Session, Conexion activa
     - login, conexion
   * - Segmento
     - Segmento de Datos
     - particion, scope, ambito
   * - Llamada
     - Call, Contacto telefonico
     - llamado, comunicacion
   * - Centro
     - Centro de atencion
     - sede, oficina, sucursal
   * - Reporte
     - Informe
     - documento, archivo
   * - Dashboard
     - Tablero, Panel
     - pantalla, vista
   * - Alerta
     - Notificacion de umbral
     - aviso, mensaje, warning

4.2 Roles del Sistema
^^^^^^^^^^^^^^^^^^^^^

Usar siempre el codigo oficial:

.. code-block:: text

   CORRECTO:    "Usuario con rol R001"
   CORRECTO:    "Usuario con rol USERS_FULL_MANAGER"
   INCORRECTO:  "el administrador de usuarios"
   INCORRECTO:  "quien gestiona usuarios"

----

5. Patrones de Redaccion
------------------------

5.1 Patron para Obligacion
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   PATRON:
   [Sujeto] DEBE [accion] [objeto] [condicion opcional]

   EJEMPLOS:
   ✓ "Usuario DEBE tener al menos un rol"
   ✓ "Sistema DEBE registrar toda accion en auditoria"
   ✓ "Sesion DEBE registrar IP de origen"

5.2 Patron para Prohibicion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   PATRON:
   [Sujeto] NO DEBE [accion] [objeto] [condicion opcional]

   EJEMPLOS:
   ✓ "Usuario NO DEBE tener roles conflictivos"
   ✓ "Sistema NO DEBE enviar correo electronico externo"
   ✓ "IACT NO DEBE modificar datos en BD IVR"

5.3 Patron para Permiso
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   PATRON:
   [Sujeto con condicion] PUEDE [accion] [objeto]

   EJEMPLOS:
   ✓ "Usuario con R016 PUEDE cerrar sesion de otro usuario"
   ✓ "Usuario con R009 PUEDE personalizar su dashboard"

5.4 Patron para Restriccion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   PATRON:
   SOLO [sujeto calificado] PUEDE [accion]

   EJEMPLOS:
   ✓ "SOLO usuarios con R001 pueden crear usuarios"
   ✓ "SOLO usuarios con R017 pueden ver logs de auditoria"

5.5 Patron para Trigger
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   PATRON:
   SI [condicion] ENTONCES [sujeto] DEBE [accion]

   EJEMPLOS:
   ✓ "SI usuario falla 3 intentos ENTONCES sistema DEBE bloquear cuenta"
   ✓ "SI metrica > umbral ENTONCES sistema DEBE notificar destinatarios"
   ✓ "SI 90 dias sin login ENTONCES sistema DEBE marcar usuario inactivo"

5.6 Patron para Hecho
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   PATRON:
   [Sujeto] ES/TIENE [caracteristica]
   CADA [sujeto] TIENE [relacion] [objeto]

   EJEMPLOS:
   ✓ "Username ES unico en el sistema"
   ✓ "CADA usuario TIENE exactamente un segmento"
   ✓ "Registros de auditoria son inmutables"

5.7 Patron para Recomendacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   PATRON:
   [Sujeto] DEBERIA [accion] [objeto]

   NOTA: DEBERIA indica "recomendado pero no obligatorio"
   Usar cuando la regla es una buena practica, no un requisito estricto.

   EJEMPLOS:
   ✓ "Sistema DEBERIA enviar confirmacion por email"
   ✓ "Usuario DEBERIA cambiar password cada 90 dias"
   ✓ "Dashboard DEBERIA cargar datos de ultimas 24 horas"

   DIFERENCIA CON DEBE:
   - DEBE: Obligatorio, sistema falla si no se cumple
   - DEBERIA: Recomendado, sistema funciona sin ello pero es mejor practica

----

6. Checklist de Validacion
--------------------------

6.1 Antes de Aprobar una BR
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   □ ¿Usa keywords permitidos (DEBE, DEBERIA, NO DEBE, PUEDE, ES, TIENE)?
   □ ¿Evita palabras ambiguas (normalmente, a veces, podria)?
   □ ¿Evita palabras vagas (rapido, suficiente, varios)?
   □ ¿Usa terminos preferidos del dominio?
   □ ¿Especifica valores numericos cuando aplica?
   □ ¿Es verificable/testeable?
   □ ¿Es atomica (una sola regla)?
   □ ¿Tiene sujeto claro?
   □ ¿Tiene accion clara?
   □ ¿Las condiciones son precisas?

6.2 Validacion Automatica
^^^^^^^^^^^^^^^^^^^^^^^^^

Reglas que pueden validarse por patron:

.. code-block:: text

   REGEX PARA DETECTAR PROBLEMAS:

   /podria/i           → WARNING: Usar PUEDE
   /normalmente/i      → ERROR: Ambiguo
   /generalmente/i     → ERROR: Ambiguo
   /a veces/i          → ERROR: Usar SI...ENTONCES
   /aproximadamente/i  → WARNING: Especificar valor
   /suficiente/i       → ERROR: Especificar cantidad
   /adecuado/i         → ERROR: Especificar criterio

   NOTA: "deberia" es VALIDO, NO es un problema

----

7. Ejemplos Corregidos
----------------------

7.1 Antes y Despues
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 50 50

   * - Incorrecto
     - Correcto
   * - "El sistema podria validar la sesion"
     - "Sistema DEBE validar sesion activa"
   * - "Normalmente el usuario tiene un rol"
     - "Usuario DEBE tener al menos un rol"
   * - "La respuesta debe ser rapida"
     - "Sistema DEBE responder en < 2 segundos"
   * - "Algunos usuarios pueden exportar"
     - "Usuario con R005 PUEDE exportar"
   * - "El administrador gestiona usuarios"
     - "Usuario con R001 PUEDE gestionar usuarios"
   * - "A veces se bloquea la cuenta"
     - "SI 3 intentos fallidos ENTONCES bloquear"
   * - "El reporte debe tener suficientes datos"
     - "Reporte DEBE contener al menos 1 registro"
   * - "Es recomendable confirmar por email"
     - "Sistema DEBERIA enviar confirmacion por email"

----

8. Glosario de Keywords
-----------------------

Referencia rapida alfabetica:

.. list-table::
   :header-rows: 1
   :widths: 20 20 60

   * - Keyword
     - Tipo
     - Uso
   * - CADA
     - Aletico
     - Cuantificador universal
   * - DEBE
     - Deontico
     - Obligacion incondicional
   * - DEBERIA
     - Deontico
     - Recomendado pero no obligatorio
   * - ENTONCES
     - Condicional
     - Consecuencia de SI
   * - ES
     - Aletico
     - Verdad estructural
   * - EXACTAMENTE
     - Aletico
     - Cardinalidad precisa
   * - EXISTE
     - Aletico
     - Cuantificador existencial
   * - NO DEBE
     - Deontico
     - Prohibicion
   * - PUEDE
     - Deontico
     - Permiso
   * - SI
     - Condicional
     - Condicion antecedente
   * - SOLO
     - Deontico
     - Restriccion exclusiva
   * - TIENE
     - Aletico
     - Posesion/relacion
   * - UNICAMENTE
     - Deontico
     - Sinonimo de SOLO

----

9. Referencias
--------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`sbvr-01` - Conceptos Nucleares (terminos preferidos)
- :ref:`sbvr-03` - Reglas Estructurales (ejemplos aleticos)
- :ref:`sbvr-04` - Reglas Operativas (ejemplos deonticos)
- :ref:`fnd-02` - Reglas de Negocio (fundamentos)

Fuentes
^^^^^^^

- OMG SBVR 1.5 Specification (Vocabulary)
- ISO 704: Terminology Work - Principles and Methods
- Simplified Technical English (ASD-STE100)

----

Historial de Cambios
--------------------

.. list-table::
   :header-rows: 1
   :widths: 15 15 20 50

   * - Version
     - Fecha
     - Autor
     - Cambios
   * - 1.1.0
     - 2025-12-21
     - Equipo IACT
     - Correccion: DEBERIA ahora es keyword VALIDO (recomendado pero no obligatorio). Agregado patron 5.7 para Recomendacion. Actualizado glosario y checklist.
   * - 1.0.0
     - 2025-12-20
     - Equipo IACT
     - Version inicial con vocabulario controlado

----

**Trazabilidad:** Este vocabulario es obligatorio para la redaccion de
todas las Business Rules en requisitos/reglas_negocio/. Complementa los
conceptos de :ref:`sbvr-01` y los patrones de :ref:`sbvr-03` y :ref:`sbvr-04`.
