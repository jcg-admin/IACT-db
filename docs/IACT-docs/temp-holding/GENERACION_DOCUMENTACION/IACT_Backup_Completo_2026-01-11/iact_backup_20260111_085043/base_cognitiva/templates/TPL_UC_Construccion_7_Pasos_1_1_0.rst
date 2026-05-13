.. meta::
   :Proyecto: IACT
   :Codigo: UC-IACT-XXX-YY
   :Titulo: [Nombre del Caso de Uso]
   :Version: 4.0.0

======================================================================
UC-IACT-XXX-YY: [Nombre del Caso de Uso]
======================================================================

**Estructura:** 11 Pasos Estándar (Cockburn/Larman)

----------------------------------------------------------------------
1. ACTOR PRINCIPAL
----------------------------------------------------------------------

[Usuario/Sistema que inicia el UC]

**Objetivo:** [Qué busca lograr]

----------------------------------------------------------------------
2. ACTORES SECUNDARIOS
----------------------------------------------------------------------

[Usuarios/Sistemas que participan pero no inician]

----------------------------------------------------------------------
3. PRECONDICIONES
----------------------------------------------------------------------

PC-1: [Condición que debe cumplirse antes]
PC-2: [Otra condición]

----------------------------------------------------------------------
4. TRIGGER
----------------------------------------------------------------------

[Evento que inicia el UC: click, request HTTP, cron, etc.]

----------------------------------------------------------------------
5. FLUJO NORMAL
----------------------------------------------------------------------

1. [Paso 1]
2. [Paso 2]
3. [Paso 3]
4. Sistema valida (FR-XXX-01) [BR-YYY]
5. [Paso 5]
...
N. Caso de uso termina exitosamente

----------------------------------------------------------------------
6. FLUJOS ALTERNOS
----------------------------------------------------------------------

FA-1: [Nombre Flujo Alterno]
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

En paso X, si [condición esperada]:

  Xa. [Acción alternativa]
  Xb. [Resolución]

----------------------------------------------------------------------
7. FLUJOS DE EXCEPCION
----------------------------------------------------------------------

FE-1: [Nombre Excepción]
^^^^^^^^^^^^^^^^^^^^^^^^^

En paso X, si [error inesperado]:

  Xa. Sistema registra error
  Xb. Sistema muestra mensaje
  Xc. Caso de uso termina sin éxito

----------------------------------------------------------------------
8. POSTCONDICIONES
----------------------------------------------------------------------

**Éxito:**
PC-E1: [Estado resultante si éxito]

**Fallo:**
PC-F1: [Estado resultante si fallo]

----------------------------------------------------------------------
9. REQUISITOS NO FUNCIONALES
----------------------------------------------------------------------

**Performance:** < X segundos
**Seguridad:** [Requisitos]
**Usabilidad:** [Requisitos]

----------------------------------------------------------------------
10. REGLAS DE NEGOCIO ASOCIADAS
----------------------------------------------------------------------

BR-IACT-XXX: [Nombre]
- Implementada en: [Paso/FA/Precondición]

----------------------------------------------------------------------
11. DERIVACION A FR
----------------------------------------------------------------------

Paso 4 → FR-XXX-01: [Nombre]
Paso 5 → FR-XXX-02: [Nombre]

**Total FR:** [N]

----------------------------------------------------------------------
**Archivo:** TPL_UC_Construccion_7_Pasos_1_1_0.rst
**Version:** 1.1.0
