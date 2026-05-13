.. meta::
   :Proyecto: IACT
   :Codigo: BR-IACT-XXX
   :Titulo: [Nombre Descriptivo de la BR]
   :Version: 1.0.0
   :Tipo: [Restriccion|Calculo|Desencadenador|Inferencia|Definicion]
   :Genera_UC: [UC-IACT-XXX-XX o "-" si no genera]
   :Fecha: YYYY-MM-DD
   :Autor: [Nombre del BA]

======================================================================
BR-IACT-XXX: [Nombre Descriptivo de la Business Rule]
======================================================================

**Tipo:** [Restriccion|Calculo|Desencadenador|Inferencia|Definicion]  
**Estado:** [DRAFT|REVIEW|APPROVED|IMPLEMENTED]  
**Prioridad:** [Alta|Media|Baja]

----------------------------------------------------------------------
1. ENUNCIADO
----------------------------------------------------------------------

[Descripción clara y concisa de la regla de negocio en lenguaje natural.
Una sola frase declarativa.]

**Ejemplo:**
"Las consultas de reportes que retornen más de 10,000 registros deben ser
aprobadas por el supervisor del área antes de ejecutarse."

----------------------------------------------------------------------
2. DERIVADO DE (Backward Traceability)
----------------------------------------------------------------------

**Business Requirement (BReq):**

- BRQ-XXX: [Nombre del BReq padre]

**Stakeholder:**

- Nombre: [Rol/Persona]
- Reunión: [Fecha]
- Documento: [Referencia si aplica]

**Justificación:**

[¿Por qué existe esta BR? ¿Qué problema del negocio resuelve?]

----------------------------------------------------------------------
3. CRITERIOS DE ACEPTACIÓN
----------------------------------------------------------------------

CA-1: [Criterio específico, medible, verificable]

CA-2: [Otro criterio]

CA-3: [...]

**Ejemplo:**
CA-1: Sistema calcula count antes de ejecutar query
CA-2: Si count > 10,000, sistema solicita aprobación
CA-3: Supervisor recibe notificación en buzón interno

----------------------------------------------------------------------
4. ANÁLISIS POR TIPO DE BR
----------------------------------------------------------------------

.. note::
   Completa SOLO la sección que corresponde al tipo de tu BR.

4.1 Si es RESTRICCIÓN
~~~~~~~~~~~~~~~~~~~~~

**¿Qué restringe?**

[Describe qué acciones, datos o estados están limitados]

**¿Cuándo aplica?**

[Condiciones bajo las cuales la restricción está activa]

**¿Cómo se valida?**

[Método de validación: query, cálculo, regla de negocio]

4.2 Si es CÁLCULO
~~~~~~~~~~~~~~~~~

**Fórmula:**

.. math::

   [LaTeX de la fórmula si es compleja]

O en notación simple:

``[variable_resultado] = [expresión matemática]``

**Ejemplo:**
``tasa_abandono = (llamadas_abandonadas / total_llamadas) * 100``

**Unidades:**

- Input 1: [tipo, rango]
- Input 2: [tipo, rango]
- Output: [tipo, rango, precisión decimal]

4.3 Si es DESENCADENADOR
~~~~~~~~~~~~~~~~~~~~~~~~~

**Test de Observabilidad:**

¿Usuario VE algo como resultado de esta BR? → SÍ (es Desencadenador)

**¿Qué desencadena?**

[Acción observable: notificación, mensaje, cambio en UI]

**Actor que recibe:**

[Usuario, Sistema Externo, etc.]

**Genera UC completo:** SÍ

4.4 Si es INFERENCIA
~~~~~~~~~~~~~~~~~~~~

**Test de Observabilidad:**

¿Usuario VE algo como resultado de esta BR? → NO (es Inferencia)

**¿Qué cambia?**

[Campo en BD, estado interno, cálculo silencioso]

**Actor que recibe:**

Ninguno (cambio silencioso en BD)

**Genera UC completo:** NO (solo FR directo)

4.5 Si es DEFINICIÓN
~~~~~~~~~~~~~~~~~~~~

**Término definido:**

[Palabra o concepto del dominio]

**Definición formal:**

[Definición precisa y sin ambigüedad]

**Ejemplos:**

- Ejemplo 1: [instancia concreta]
- Ejemplo 2: [instancia concreta]

**Contraejemplos:**

- Contraejemplo 1: [qué NO es]

----------------------------------------------------------------------
5. GENERA UC (Forward Traceability)
----------------------------------------------------------------------

.. note::
   - Restricciones: → Precondición + Flujo Alterno
   - Cálculos: → Paso en UC existente (sin UC propio)
   - Desencadenadores: → UC completo nuevo
   - Inferencias: → NO genera UC (solo FR)
   - Definiciones: → Glosario (no genera UC)

**UC Generados:**

- UC_IACT_XXX_XX_[Nombre]_4_0_0.rst [Paso X o FA-Y]
- [Otro UC si aplica]

**O:**

- No genera UC (especificar por qué según tipo de BR)

----------------------------------------------------------------------
6. TRAZABILIDAD FORWARD COMPLETA
----------------------------------------------------------------------

.. code-block:: text

   BR-IACT-XXX ([Nombre corto])
     ↓ genera
   UC-IACT-XXX-XX ([Nombre UC])
     ↓ paso Y deriva
   FR-XXX-YY-ZZ ([Nombre FR])
     ↓ implementa
   [modulo]_X_Y_Z/[archivo].py::[funcion] (línea NNN)
     ↓ valida
   tests/test_[modulo].py::[test_function]

----------------------------------------------------------------------
7. IMPACTO DE CAMBIOS
----------------------------------------------------------------------

**Si esta BR cambia:**

- [ ] Actualizar UC: [listar UC afectados]
- [ ] Actualizar FR: [listar FR afectados]
- [ ] Modificar código: [listar archivos]
- [ ] Actualizar tests: [listar tests]
- [ ] Notificar stakeholders: [listar]

**Riesgo estimado:** [Bajo|Medio|Alto]

**Esfuerzo estimado:** [X horas]

----------------------------------------------------------------------
8. VALIDACIÓN Y TESTING
----------------------------------------------------------------------

**Cómo se valida esta BR:**

Test funcional:

1. [Paso de test]
2. [Paso de test]
3. [Resultado esperado]

**Tests automatizados:**

- tests/test_[modulo].py::[test_nombre]
- [Otro test]

----------------------------------------------------------------------
9. NOTAS Y EXCEPCIONES
----------------------------------------------------------------------

**Excepciones conocidas:**

- [Situación excepcional donde BR no aplica]

**Notas técnicas:**

- [Consideraciones de implementación]

**Decisiones de diseño:**

- [Razones de por qué se implementó de cierta forma]

----------------------------------------------------------------------
10. HISTORIAL DE VERSIONES
----------------------------------------------------------------------

.. list-table::
   :header-rows: 1
   :widths: 10 15 50 25

   * - Versión
     - Fecha
     - Cambios
     - Autor
   * - 1.0.0
     - YYYY-MM-DD
     - Versión inicial
     - [Nombre]
   * - 1.1.0
     - YYYY-MM-DD
     - [Descripción del cambio]
     - [Nombre]

----------------------------------------------------------------------
REFERENCIAS
----------------------------------------------------------------------

**Estándares:**

- STD_001_Estandares_Documentacion_1_1_0.rst
- NOM_001_Nomenclatura_Proyecto_2_0_0.rst

**Material Pedagógico:**

- PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md (Sección 2: Taxonomía)
- PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md (Sección 3: Desencadenadores vs Inferencias)

**Documentos Relacionados:**

- BRQ-XXX: [Nombre del Business Requirement]
- UC_IACT_XXX_XX_[Nombre]_4_0_0.rst
- FR_XXX_YY_ZZ_[Nombre]_1_0_0.rst

----------------------------------------------------------------------

.. note::
   **IMPORTANTE:** Este template debe completarse siguiendo STD_001.
   - No usar emojis (usar [OK], [ERROR], [WARN])
   - Versionado semántico obligatorio
   - Metadata completa al inicio
   - Nomenclatura NOM_001 v2.0.0

**Archivo:** TPL_BR_Decision_Tipo_1_0_0.rst  
**Versión:** 1.0.0  
**Última actualización:** 2026-01-09
