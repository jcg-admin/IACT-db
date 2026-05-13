ADR-GOB-009: Trazabilidad entre Artefactos de Requisitos
========================================================

MISMO CASO QUE LAS ULTIMAS DECISIONES DE ARQUITECTURA, VALIDAR SI VA DE
LA “MANO” CON LA METODOLOGIA DE INGENERIA DE REQUIERMIENTOS

Estado
------

**APROBADO** - 2025-11-17

Contexto
--------

La jerarquía de requisitos en 5 niveles (ADR-GOB-005) establece
relaciones entre diferentes tipos de artefactos. Sin trazabilidad
explícita, se presentan problemas:

Problemas sin Trazabilidad
~~~~~~~~~~~~~~~~~~~~~~~~~~

**Cambios no propagados**: - Cambio en regla de negocio no actualiza
casos de uso afectados - Modificación de caso de uso no se refleja en
requisitos funcionales - Atributos de calidad desconectados de casos de
uso

**Incapacidad de responder preguntas**: - ¿Por qué existe esta
funcionalidad? - ¿Qué casos de uso implementa este requisito funcional?
- ¿Qué reglas de negocio afectan este módulo? - ¿Cuál es el impacto de
cambiar esta política?

**Validación imposible**: - No se puede verificar que requisitos de
negocio se cumplen - Difícil confirmar que reglas de negocio están
implementadas - Tests sin conexión a casos de uso

**Documentación fragmentada**: - Artefactos aislados sin relación
visible - Dificulta onboarding de nuevos miembros - Conocimiento tribal
en lugar de documentado

Necesidades del Proyecto IACT
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. **Trazabilidad bidireccional**: Desde reglas de negocio hasta código
   y viceversa
2. **IDs únicos**: Cada artefacto identificable y referenciable
3. **Referencias explícitas**: Conexiones documentadas entre artefactos
4. **Gestión de cambios**: Identificar impacto de modificaciones
5. **Validación**: Verificar que objetivos se cumplen

Decisión
--------

**Establecer sistema de trazabilidad basado en IDs únicos y referencias
explícitas entre todos los artefactos de requisitos.**

Cadena de Trazabilidad
~~~~~~~~~~~~~~~~~~~~~~

::

   RN (Reglas de Negocio)
       ↓ influyen en
   RNEG (Requerimientos de Negocio)
       ↓ se convierten en
   UC (Casos de Uso)
       ↓ se implementan mediante
   RF (Requisitos Funcionales)
       ↓ deben cumplir
   RNF (Atributos de Calidad)

Cada flecha representa **referencias explícitas** en la documentación.

Sistema de IDs Únicos
~~~~~~~~~~~~~~~~~~~~~

Patrón General
^^^^^^^^^^^^^^

::

   TIPO-DOMINIO-###

Donde: - **TIPO**: RN, RNEG, UC, RF, RNF (o BR, AC) - **DOMINIO**: BACK,
FRONT, DEVOPS, QA, AI, GOB - **###**: Número secuencial 001-999

IDs por Tipo de Artefacto
^^^^^^^^^^^^^^^^^^^^^^^^^

======================== ================ =============
Tipo de Artefacto        Patrón ID        Ejemplo
======================== ================ =============
Regla de Negocio         RN-DOMINIO-###   RN-BACK-001
Requerimiento de Negocio RNEG-DOMINIO-### RNEG-BACK-001
Caso de Uso              UC-DOMINIO-###   UC-BACK-001
Requisito Funcional      RF-DOMINIO-###   RF-BACK-005
Atributo de Calidad      RNF-DOMINIO-###  RNF-BACK-005
======================== ================ =============

**Reglas**: - **Únicos globalmente**: No reutilizar IDs - **Secuenciales
por dominio**: RN-BACK-001, RN-BACK-002, … - **No cambiar**: Una vez
asignado, el ID no cambia aunque cambie el contenido - **Gaps
permitidos**: Si RN-BACK-003 se elimina, NO reutilizar, continuar con
RN-BACK-004

Referencias Explícitas en Documentación
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Cada artefacto debe incluir sección de referencias a otros artefactos.

En Reglas de Negocio (RN)
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: markdown

                  
   id: RN-BACK-001
                  

   # RN-BACK-001: Usuario Debe Estar Autenticado

   [Contenido de la regla...]

   ## Impacto en Requisitos

   **Requerimientos de Negocio**:
   - RNEG-BACK-001: Sistema de autenticación seguro

   **Requerimientos de Usuario**:
   - UC-BACK-001: Iniciar Sesión
   - UC-BACK-003: Cambiar Contraseña

   **Requisitos Funcionales**:
   - RF-BACK-010: Validar credenciales
   - RF-BACK-011: Generar token de sesión

   **Atributos de Calidad**:
   - RNF-BACK-005: Contraseña debe tener mínimo 8 caracteres
   - RNF-BACK-007: Sesión expira después de 30 minutos de inactividad

En Requerimientos de Negocio (RNEG)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: markdown

                    
   id: RNEG-BACK-001
                    

   # RNEG-BACK-001: Sistema de Autenticación Seguro

   [Contenido del requerimiento...]

   ## Trazabilidad

   **Derivado de Reglas de Negocio**:
   - RN-BACK-001: Usuario debe estar autenticado
   - RN-BACK-002: Datos personales protegidos según LFPDPPP

   **Se implementa mediante Casos de Uso**:
   - UC-BACK-001: Iniciar Sesión
   - UC-BACK-002: Cerrar Sesión
   - UC-BACK-003: Cambiar Contraseña
   - UC-BACK-004: Recuperar Contraseña

   **Medido por**:
   - Métrica: Tiempo promedio de autenticación < 2 segundos
   - Métrica: 0 accesos no autorizados en logs de auditoría

En Casos de Uso (UC)
^^^^^^^^^^^^^^^^^^^^

.. code:: markdown

                  
   id: UC-BACK-001
                  

   # UC-BACK-001: Iniciar Sesión

   [Contenido del caso de uso...]

   ## Reglas de Negocio Relacionadas

   - RN-BACK-001: Usuario debe estar autenticado
   - RN-BACK-028: Solo usuarios activos pueden iniciar sesión

   ## Requerimientos de Negocio Relacionados

   - RNEG-BACK-001: Sistema de autenticación seguro

   ## Requisitos Funcionales Derivados

   - RF-BACK-010: Validar credenciales contra base de datos
   - RF-BACK-011: Generar token JWT con expiración de 15 minutos
   - RF-BACK-012: Registrar intento de login en log de auditoría

   ## Atributos de Calidad Relacionados

   - RNF-BACK-005: Contraseña debe tener mínimo 8 caracteres
   - RNF-BACK-006: Sistema debe responder en < 2 segundos
   - RNF-BACK-007: Sesión expira después de 30 minutos de inactividad

En Requisitos Funcionales (RF)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: markdown

                  
   id: RF-BACK-010
                  

   # RF-BACK-010: Validar Credenciales contra Base de Datos

   [Contenido del requisito...]

   ## Trazabilidad

   **Implementa Casos de Uso**:
   - UC-BACK-001: Iniciar Sesión

   **Derivado de Reglas de Negocio**:
   - RN-BACK-001: Usuario debe estar autenticado

   **Cumple Atributos de Calidad**:
   - RNF-BACK-006: Sistema debe responder en < 2 segundos

   **Tests Relacionados**:
   - TS-BACK-010-001: Test validación credenciales correctas
   - TS-BACK-010-002: Test validación credenciales incorrectas
   - TS-BACK-010-003: Test usuario inexistente

En Atributos de Calidad (RNF)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: markdown

                   
   id: RNF-BACK-005
                   

   # RNF-BACK-005: Contraseña Mínimo 8 Caracteres

   [Contenido del atributo...]

   ## Trazabilidad

   **Aplica a Casos de Uso**:
   - UC-BACK-001: Iniciar Sesión
   - UC-BACK-003: Cambiar Contraseña
   - UC-BACK-004: Recuperar Contraseña

   **Derivado de Reglas de Negocio**:
   - RN-BACK-001: Usuario debe estar autenticado

   **Implementado en Requisitos Funcionales**:
   - RF-BACK-015: Validar formato de contraseña

   **Tests Relacionados**:
   - TS-RNF-005-001: Test contraseña con < 8 caracteres es rechazada
   - TS-RNF-005-002: Test contraseña con >= 8 caracteres es aceptada

Matriz de Trazabilidad
~~~~~~~~~~~~~~~~~~~~~~

Complementar referencias explícitas con matriz de trazabilidad para
vista panorámica.

Matriz Vertical (Por Artefacto)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: markdown

   # Matriz de Trazabilidad: Módulo de Autenticación

.. list-table::
   :header-rows: 1

   * - RN
     - RNEG
     - UC
     - RF
     - RNF
   * - RN-BACK-001
     - RNEG-BACK-001
     - UC-BACK-001
     - RF-BACK-010
     - RNF-BACK-005
   * - 
     - 
     - 
     - RF-BACK-011
     - RNF-BACK-006
   * - 
     - 
     - 
     - RF-BACK-012
     - RNF-BACK-007
   * - 
     - 
     - UC-BACK-002
     - RF-BACK-013
     - 
   * - 
     - 
     - UC-BACK-003
     - RF-BACK-014
     - RNF-BACK-005
   * - 
     - 
     - 
     - RF-BACK-015
     - 
   * - RN-BACK-028
     - RNEG-BACK-001
     - UC-BACK-001
     - RF-BACK-016
     - 

Matriz Horizontal (Por Caso de Uso)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: markdown

   # Matriz de Trazabilidad: UC-BACK-001 Iniciar Sesión

.. list-table::
   :header-rows: 1

   * - Elemento
     - ID
     - Relación
   * - Regla de Negocio
     - RN-BACK-001
     - Usuario debe estar autenticado
   * - Regla de Negocio
     - RN-BACK-028
     - Solo usuarios activos pueden iniciar sesión
   * - Requerimiento de Negocio
     - RNEG-BACK-001
     - Sistema de autenticación seguro
   * - Requisito Funcional
     - RF-BACK-010
     - Validar credenciales
   * - Requisito Funcional
     - RF-BACK-011
     - Generar token JWT
   * - Requisito Funcional
     - RF-BACK-012
     - Registrar en log
   * - Atributo de Calidad
     - RNF-BACK-005
     - Contraseña >= 8 caracteres
   * - Atributo de Calidad
     - RNF-BACK-006
     - Respuesta < 2 segundos
   * - Atributo de Calidad
     - RNF-BACK-007
     - Sesión expira en 30 min

Herramientas de Trazabilidad
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Scripts de Validación
^^^^^^^^^^^^^^^^^^^^^

Crear scripts que validen trazabilidad:

.. code:: bash

   #!/bin/bash
   # scripts/validar-trazabilidad.sh

   # Verificar que todos los IDs referenciados existen
   grep -r "RN-BACK-" docs/gobernanza/requisitos/ | \
     grep -oE "RN-BACK-[0-9]{3}" | \
     sort -u | \
     while read id; do
       if ! find docs/gobernanza/requisitos/reglas_negocio -name "*$id*" | grep -q .; then
         echo "ERROR: $id referenciado pero no existe"
       fi
     done

   # Verificar que UC tienen al menos 1 RF relacionado
   find docs/gobernanza/requisitos/requerimientos_usuario/casos_uso -name "UC-*.md" | \
     while read uc; do
       if ! grep -q "RF-" "$uc"; then
         echo "WARNING: $uc no tiene RF relacionados"
       fi
     done

Generación Automática de Matrices
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: python

   #!/usr/bin/env python3
   # scripts/generar-matriz-trazabilidad.py

   import os
   import re
   from pathlib import Path

   def extract_ids_from_file(filepath):
       """Extrae IDs referenciados en un archivo markdown"""
       with open(filepath, 'r') as f:
           content = f.read()

       # Buscar patrones tipo RN-BACK-001, UC-BACK-001, etc.
       pattern = r'(RN|RNEG|UC|RF|RNF)-([A-Z]+)-(\d{3})'
       matches = re.findall(pattern, content)

       return [f"{tipo}-{dom}-{num}" for tipo, dom, num in matches]

   def generate_traceability_matrix(domain="BACK"):
       """Genera matriz de trazabilidad para un dominio"""

       requisitos_dir = Path("docs/gobernanza/requisitos")

       # Estructura para almacenar trazabilidad
       traceability = {}

       # Procesar cada tipo de artefacto
       for tipo_dir in requisitos_dir.iterdir():
           if tipo_dir.is_dir():
               for md_file in tipo_dir.rglob("*.md"):
                   # Extraer ID del archivo
                   file_id = extract_id_from_filename(md_file.name)
                   if file_id and domain in file_id:
                       refs = extract_ids_from_file(md_file)
                       traceability[file_id] = refs

       # Generar matriz markdown
       print_matrix(traceability)

   # [resto de implementación...]

Gestión de Cambios con Trazabilidad
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Cuando se modifica un artefacto, identificar impacto:

Ejemplo: Cambio en Regla de Negocio
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   RN-BACK-001 cambió de:
     "Usuario debe estar autenticado"
   a:
     "Usuario debe estar autenticado con 2FA"

   Impacto (basado en trazabilidad):

     Revisar y posiblemente actualizar:
     - RNEG-BACK-001: Sistema de autenticación seguro
     - UC-BACK-001: Iniciar Sesión (agregar paso de 2FA)
     - RF-BACK-011: Generar token JWT (agregar validación 2FA)
     - RNF-BACK-008: NUEVO - Soporte para 2FA

     Tests a crear/actualizar:
     - TS-BACK-011-003: Test 2FA exitoso
     - TS-BACK-011-004: Test 2FA fallido

Checklist de Impacto
^^^^^^^^^^^^^^^^^^^^

.. code:: markdown

   ## Checklist de Impacto de Cambio

   **Artefacto modificado**: RN-BACK-001

   **Tipo de cambio**: [Menor | Mayor | Breaking]

   **Artefactos a revisar**:
   - [ ] RNEG-BACK-001: Actualizado
   - [ ] UC-BACK-001: Actualizado
   - [ ] UC-BACK-003: Actualizado
   - [ ] RF-BACK-010: Sin cambios necesarios
   - [ ] RF-BACK-011: Actualizado
   - [ ] RNF-BACK-005: Sin cambios necesarios
   - [ ] RNF-BACK-006: Sin cambios necesarios
   - [ ] RNF-BACK-007: Sin cambios necesarios

   **Nuevos artefactos creados**:
   - [x] RNF-BACK-008: Soporte para 2FA
   - [x] RF-BACK-017: Validar código 2FA
   - [x] RF-BACK-018: Generar código 2FA

   **Tests actualizados**:
   - [x] TS-BACK-010-001: Actualizado para 2FA
   - [x] TS-BACK-011-003: Nuevo - 2FA exitoso
   - [x] TS-BACK-011-004: Nuevo - 2FA fallido

Ubicación de Matrices
---------------------

::

   docs/gobernanza/trazabilidad/
   ├── matrices/
   │   ├── MATRIZ-BACK-autenticacion.md
   │   ├── MATRIZ-BACK-permisos.md
   │   ├── MATRIZ-FRONT-ui.md
   │   └── ...
   ├── scripts/
   │   ├── validar-trazabilidad.sh
   │   └── generar-matriz-trazabilidad.py
   └── README.md

Alternativas Consideradas
-------------------------

Alternativa 1: Herramienta Especializada (DOORS, Jama, ReqIF)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Pros**: - Trazabilidad automática - Interfaces gráficas - Análisis de
impacto integrado

**Contras**: - Costo elevado - Curva de aprendizaje - No es “docs as
code” - Vendor lock-in

**Razón de rechazo**: Overhead y costo injustificados para proyecto de
este tamaño.

Alternativa 2: Sin Trazabilidad Explícita
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Pros**: - Menos overhead - Más ágil

**Contras**: - Imposible gestionar cambios - No se puede validar
cumplimiento - Conocimiento tribal

**Razón de rechazo**: Inviable para proyectos que requieren gestión de
cambios rigurosa.

Alternativa 3: Solo Trazabilidad Unidireccional (Top-Down)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción**: Solo referencias de arriba hacia abajo (RN → UC → RF).

**Pros**: - Más simple - Menos redundancia

**Contras**: - No se puede responder “¿Por qué existe este RF?” -
Dificulta análisis de impacto bottom-up

**Razón de rechazo**: Trazabilidad bidireccional es necesaria para
análisis completo.

Alternativa 4: Base de Datos de Trazabilidad Separada
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción**: Mantener trazabilidad en base de datos aparte, no en
archivos markdown.

**Pros**: - Queries más eficientes - Análisis más fácil

**Contras**: - Sincronización compleja - Riesgo de desincronización - No
es single source of truth

**Razón de rechazo**: Preferimos single source of truth en archivos
markdown.

Consecuencias
-------------

Positivas
~~~~~~~~~

1. **Gestión de cambios efectiva**

   -  Impacto visible inmediatamente
   -  Checklist de artefactos a actualizar
   -  Previene cambios inconsistentes

2. **Validación de cobertura**

   -  Verificar que todos los RN tienen UC
   -  Confirmar que todos los UC tienen RF
   -  Identificar gaps

3. **Onboarding mejorado**

   -  Nuevos miembros siguen referencias
   -  Comprenden relaciones entre artefactos
   -  Documentación autoexplicativa

4. **Análisis de impacto**

   -  Bottom-up: “¿Por qué existe esto?”
   -  Top-down: “¿Qué implementa esto?”
   -  Lateral: “¿Qué más se afecta?”

5. **Auditorías facilitadas**

   -  Demostrar que requisitos se cumplen
   -  Trazabilidad desde código hasta reglas

Negativas
~~~~~~~~~

1. **Overhead de documentación**

   -  Mantener referencias actualizadas
   -  Riesgo de referencias rotas

   **Mitigación**:

   -  Scripts de validación
   -  CI/CD verifica trazabilidad
   -  Code reviews incluyen revisar referencias

2. **Redundancia**

   -  Misma información en múltiples lugares
   -  UC lista RF, RF lista UC

   **Mitigación**:

   -  Generar matrices automáticamente
   -  Single source of truth en IDs
   -  Scripts detectan inconsistencias

3. **Complejidad inicial**

   -  Tiempo para establecer trazabilidad
   -  Curva de aprendizaje

   **Mitigación**:

   -  Templates pre-poblados con secciones
   -  Ejemplos completos
   -  Capacitación

Implementación
--------------

Fase 1: IDs Únicos (Semana 1)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Asignar IDs a todos los artefactos existentes: - Reglas de negocio -
Casos de uso - Requisitos funcionales (derivar de casos de uso) -
Atributos de calidad

Fase 2: Referencias Iniciales (Semana 2)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Para 5-10 casos de uso principales: - Agregar secciones de trazabilidad
- Listar RN, RNEG, RF, RNF relacionados - Validar bidireccionalidad

Fase 3: Scripts de Validación (Semana 3)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Desarrollar: - ``validar-trazabilidad.sh``: Verificar referencias -
``generar-matriz-trazabilidad.py``: Matrices automáticas

Fase 4: Matrices Iniciales (Semana 4)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Crear matrices para módulos principales: - Autenticación - Permisos -
Auditoría

Fase 5: CI/CD (Semana 5)
~~~~~~~~~~~~~~~~~~~~~~~~

Integrar validación de trazabilidad en pipeline.

Validación
----------

Criterios de Éxito
~~~~~~~~~~~~~~~~~~

-  100% de artefactos tienen IDs únicos

-  = 80% de casos de uso tienen trazabilidad completa

-  Scripts de validación ejecutan sin errores

-  3-5 matrices de trazabilidad creadas

-  Desarrolladores usan trazabilidad en análisis de cambios

Métricas
~~~~~~~~

-  Número de IDs asignados por tipo
-  Cobertura de trazabilidad (% con referencias bidireccionales)
-  Referencias rotas detectadas (debería ser 0)
-  Tiempo para analizar impacto de cambio
-  Satisfacción del equipo con trazabilidad

Referencias
-----------

-  `IEEE 29148-2018: Requirements
   Traceability <https://standards.ieee.org/standard/29148-2018.html>`__
-  `ADR-GOB-005: Jerarquía de Requerimientos en 5
   Niveles <ADR-GOB-005-jerarquia-requerimientos-5-niveles.md>`__
-  `ADR-GOB-006: Clasificación de Reglas de
   Negocio <ADR-GOB-006-clasificacion-reglas-negocio.md>`__
-  `ADR-GOB-007: Especificación de Casos de
   Uso <ADR-GOB-007-especificacion-casos-uso.md>`__

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
