.. meta::
   :artefacto: PROC_Generacion_ADR
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :categoria: Generacion
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _proc-generacion-adr:

=============================================================
PROC_Generacion_ADR: Generacion de Decisiones Arquitectonicas
=============================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75

   * - **ID**
     - PROC_Generacion_ADR
   * - **Nombre**
     - Generacion de Decisiones Arquitectonicas
   * - **Categoria**
     - Generacion
   * - **Duracion**
     - 30-60 minutos por ADR

----

1. Proposito
------------

Documentar Decisiones Arquitectonicas (ADR) siguiendo formato estandar
para registrar el contexto, decision y consecuencias.

----

2. Alcance
----------

**Aplica A:** Decisiones tecnicas significativas.

**No Aplica A:** Decisiones triviales o temporales.

----

3. Cuando Crear ADR
-------------------

- Seleccion de tecnologia
- Patron arquitectonico
- Cambio estructural significativo
- Trade-off importante

----

4. Procedimiento
----------------

**Paso 1: Identificar Decision**

Documentar decision arquitectonica tomada.

**Paso 2: Asignar Nomenclatura**

.. code-block:: text

   Formato: ADR_[NNN]
   Archivo: ADR_[NNN]_[Titulo].rst

**Paso 3: Documentar Contexto**

Situacion que motivo la decision:

- Problema a resolver
- Restricciones existentes
- Opciones consideradas

**Paso 4: Documentar Decision**

La decision tomada y por que:

.. code-block:: text

   Decision: Usar JWT para autenticacion stateless
   
   Justificacion:
   - Escalabilidad horizontal
   - No requiere sesiones en servidor
   - Estandar de industria

**Paso 5: Documentar Alternativas**

Opciones descartadas y por que:

.. code-block:: text

   Alternativas descartadas:
   - Sesiones en BD: No escala bien
   - OAuth solo: Complejidad innecesaria

**Paso 6: Documentar Consecuencias**

Impacto positivo y negativo:

.. code-block:: text

   Positivas:
   - Stateless, escala horizontalmente
   
   Negativas:
   - No se puede invalidar token facilmente
   - Requiere refresh token

**Paso 7: Guardar y Validar**

----

5. Estados de ADR
-----------------

- **Propuesta:** En evaluacion
- **Aceptada:** Decision tomada
- **Deprecada:** Reemplazada por otra
- **Rechazada:** No se implemento

----

6. Artefactos de Salida
-----------------------

- ADR_[NNN]_[Titulo].rst

----

7. Verificacion
---------------

- [ ] Contexto claro
- [ ] Decision explicita
- [ ] Alternativas documentadas
- [ ] Consecuencias identificadas

----

8. Referencias
--------------

- TPL_ADR
- CNST relacionadas

----

9. Historial
------------

.. list-table::
   :header-rows: 1

   * - Version
     - Fecha
     - Cambios
   * - 1.0.0
     - 2026-01-07
     - Version inicial

----

*Documento version 1.0.0 - Proyecto IACT*
