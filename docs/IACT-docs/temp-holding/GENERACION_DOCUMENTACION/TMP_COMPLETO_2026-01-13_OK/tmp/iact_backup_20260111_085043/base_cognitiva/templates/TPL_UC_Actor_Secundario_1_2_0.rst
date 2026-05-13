.. meta::
   :Proyecto: IACT
   :Codigo: UC-IACT-XXX-YY
   :Titulo: [Nombre - Con Actores Secundarios]
   :Version: 4.0.0
   :Actor_Principal: [Actor]
   :Actores_Secundarios: [Actor2, Actor3]
   :Fecha: YYYY-MM-DD

======================================================================
UC-IACT-XXX-YY: [Nombre] (Con Actores Secundarios)
======================================================================

----------------------------------------------------------------------
INTRODUCCION
----------------------------------------------------------------------

Este UC involucra múltiples actores:
- 1 Actor Principal (inicia el UC)
- 2+ Actores Secundarios (participan sin iniciar)

----------------------------------------------------------------------
1. ACTORES
----------------------------------------------------------------------

**Actor Principal:**

- **Nombre:** [Actor que inicia]
- **Rol:** [Descripción del rol]
- **Objetivo:** [Qué busca lograr]

**Actores Secundarios:**

Actor Secundario 1: [Nombre]
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- **Rol:** [Descripción]
- **Participa en:** [Pasos N, M del flujo]
- **Responsabilidad:** [Qué hace en el UC]
- **Tipo:** [Usuario|Sistema Externo|Servicio]

Actor Secundario 2: [Nombre]
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- **Rol:** [Descripción]
- **Participa en:** [Pasos X, Y]
- **Responsabilidad:** [Qué hace]
- **Tipo:** [Usuario|Sistema|Servicio]

**Diagrama de Actores:**

.. code-block:: text

   ┌─────────────────┐
   │ Actor Principal │
   │  (Usuario A)    │────┐
   └─────────────────┘    │
                          │
                          ▼
                   ┌──────────────┐
                   │   UC-XXX-YY  │
                   │   [Nombre]   │
                   └──────────────┘
                          ▲
                          │
                  ┌───────┴───────┐
                  │               │
          ┌───────┴────┐   ┌──────┴──────┐
          │  Actor     │   │   Actor     │
          │Secundario 1│   │Secundario 2 │
          │ (Servicio) │   │  (Sistema)  │
          └────────────┘   └─────────────┘

----------------------------------------------------------------------
2. TABLA DE RESPONSABILIDADES
----------------------------------------------------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 15 15 50

   * - Actor
     - Tipo
     - Pasos
     - Responsabilidad
   * - [Actor Principal]
     - Usuario
     - 1-12
     - Inicia UC, ingresa datos, confirma
   * - [Actor Sec. 1]
     - Servicio
     - 5, 7
     - Valida permisos, retorna autorización
   * - [Actor Sec. 2]
     - Sistema
     - 9
     - Ejecuta query, retorna resultados

----------------------------------------------------------------------
3. FLUJO CON PARTICIPACION DE ACTORES
----------------------------------------------------------------------

1. [Actor Principal] hace click en "Iniciar Proceso"

2. Sistema muestra formulario

3. [Actor Principal] ingresa datos

4. Sistema valida formato local

5. Sistema consulta a [Actor Secundario 1: Servicio Autorizacion]
   - Request: {user_id, permission_code}
   - Response: {authorized: true/false}

6. [Actor Secundario 1] valida permisos internamente

7. [Actor Secundario 1] retorna resultado de autorización

8. Si autorizado, Sistema procede

9. Sistema solicita datos a [Actor Secundario 2: BD Analytics]
   - Request: {query_params}
   - Response: {data: [...]}

10. [Actor Secundario 2] ejecuta query y retorna datos

11. Sistema procesa resultados

12. Sistema muestra datos a [Actor Principal]

13. [Actor Principal] visualiza y confirma

14. Caso de uso termina

----------------------------------------------------------------------
DERIVACION A FR
----------------------------------------------------------------------

Paso 5-7 → FR-XXX-01: Validar Autorizacion
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción:** Integración con servicio de autorización

**Actor Responsable:** Actor Secundario 1 (Servicio)

**Input:** user_id, permission_code

**Output:** Boolean (authorized)

Paso 9-10 → FR-XXX-02: Consultar Analytics
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción:** Query a sistema analytics

**Actor Responsable:** Actor Secundario 2 (Sistema)

**Input:** query_params

**Output:** Array de resultados

----------------------------------------------------------------------
REFERENCIAS
----------------------------------------------------------------------

- STD_001_Estandares_Documentacion_1_1_0.rst
- PARTE_2D_Actores_Secundarios_IACT_1_0_0.md

**Archivo:** TPL_UC_Actor_Secundario_1_2_0.rst  
**Líneas:** ~230

