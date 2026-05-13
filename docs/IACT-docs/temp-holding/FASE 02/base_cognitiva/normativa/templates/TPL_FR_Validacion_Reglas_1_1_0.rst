.. meta::
   :Proyecto: IACT
   :Codigo: FR-XXX-YY-ZZ
   :Tipo: Validacion
   :Version: 1.0.0

======================================================================
FR-XXX-YY-ZZ: [Validación de Datos]
======================================================================

REGLAS DE VALIDACION
~~~~~~~~~~~~~~~~~~~~~

V-1: Campo obligatorio
~~~~~~~~~~~~~~~~~~~~~~
**SQL:**

.. code-block:: sql

   campo IS NOT NULL AND campo != ''

**Mensaje Error:** "Campo [nombre] es obligatorio"

V-2: Formato email
~~~~~~~~~~~~~~~~~~
**Regex:**

.. code-block:: python

   ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$

**Mensaje Error:** "Formato de email inválido"

V-3: Rango numérico
~~~~~~~~~~~~~~~~~~~
**Condición:**

.. code-block:: python

   valor >= min_value and valor <= max_value

**Mensaje Error:** "Valor debe estar entre {min} y {max}"

CODIGO VALIDACION
~~~~~~~~~~~~~~~~~

.. code-block:: python

   def validate_entity(data):
       errors = {}
       
       # V-1
       if not data.get('campo'):
           errors['campo'] = "Campo es obligatorio"
       
       # V-2
       if data.get('email'):
           if not re.match(EMAIL_REGEX, data['email']):
               errors['email'] = "Formato inválido"
       
       # V-3
       if data.get('valor'):
           if not (MIN <= data['valor'] <= MAX):
               errors['valor'] = f"Debe estar entre {MIN} y {MAX}"
       
       return errors

TESTS
~~~~~

.. code-block:: python

   def test_validacion_campo_obligatorio():
       errors = validate_entity({'campo': ''})
       assert 'campo' in errors

**Archivo:** TPL_FR_Validacion_Reglas_1_1_0.rst
**Version:** 1.1.0
