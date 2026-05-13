.. meta::
   :artefacto: STD_001
   :tipo: Estandar
   :dominio: normativa
   :subdominio: estandares
   :estado: Aprobado
   :version: 1.1.0
   :fecha_creacion: 2026-01-07
   :ultimo_cambio: 2026-01-08
   :autor: Equipo IACT
   :clasificacion: Interno

.. _std-001:

==============================================================================
STD_001: Estándares de Documentación - Sin Emojis ni Iconos Unicode
==============================================================================

.. contents:: Contenido
   :depth: 3
   :local:

----

1. Propósito
============

Este documento establece los estándares para documentación Sphinx/RST en el
proyecto IACT, prohibiendo el uso de emojis, iconos Unicode decorativos y
símbolos especiales que afecten la portabilidad y legibilidad.

.. danger::

   **NORMATIVA OBLIGATORIA**
   
   NUNCA usar emojis, iconos Unicode decorativos, ni símbolos especiales
   en documentación de producción RST/Markdown.

----

2. Prohibiciones
================

2.1 Emojis
----------

**PROHIBIDO en cualquier documento .rst, .md:**

.. code-block:: text

   PROHIBIDO:
   ✅ Completado
   ❌ Error
   ⚠️ Advertencia
   🚀 Iniciando
   📁 Procesando
   💾 Guardando
   🔍 Buscando
   ⏳ Esperando
   ✨ Nuevo
   🎉 Éxito
   ⭐ Importante
   📊 Estadísticas
   📈 Progreso
   🎯 Objetivo
   💡 Recomendación

2.2 Iconos Unicode Decorativos
-------------------------------

**PROHIBIDO:**

.. code-block:: text

   PROHIBIDO:
   ▶ Ejecutando
   ● Item
   → Siguiente
   ★ Importante
   ♦ Nota
   ■ Opción
   ▸ Paso
   » Info
   ☑ Checkbox marcado
   ☐ Checkbox sin marcar

2.3 Box Drawing Characters
---------------------------

**PROHIBIDO:**

.. code-block:: text

   PROHIBIDO:
   ╔════════════╗
   ║   Título   ║
   ╚════════════╝
   ┌──────────┐
   │  Caja    │
   └──────────┘
   ├── Item
   └── Item

**EXCEPCIÓN:** Se permite en diagramas de árbol dentro de code-blocks
cuando son esenciales para representar estructura de directorios.

.. code-block:: text

   PERMITIDO (solo en code-blocks):
   source/
   ├── requisitos/
   │   ├── casos_uso/
   │   └── funcionales/
   └── arquitectura/

----

3. Alternativas Aprobadas
==========================

3.1 Sistema de Prefijos Estándar
---------------------------------

**USAR en lugar de emojis:**

.. list-table::
   :widths: 20 40 40
   :header-rows: 1

   * - Prefijo
     - Uso
     - Ejemplo RST
   * - [OK]
     - Completado, éxito
     - ``[OK] Build exitoso``
   * - [PENDING]
     - Pendiente, en espera
     - ``[PENDING] Verificación``
   * - [ERROR]
     - Error encontrado
     - ``[ERROR] Referencia rota``
   * - [WARN]
     - Advertencia
     - ``[WARN] Nomenclatura obsoleta``
   * - [INFO]
     - Información general
     - ``[INFO] Total: 49 UC``
   * - [SUCCESS]
     - Operación exitosa
     - ``[SUCCESS] Actualización completa``
   * - [FAIL]
     - Operación falló
     - ``[FAIL] Build con warnings``
   * - [DONE]
     - Tarea completada
     - ``[DONE] Fase 1 completada``
   * - [TODO]
     - Por hacer
     - ``[TODO] Verificar módulos``
   * - [CRITICAL]
     - Crítico, urgente
     - ``[CRITICAL] Inconsistencia detectada``

3.2 Estados de Componentes
---------------------------

.. list-table::
   :widths: 20 40 40
   :header-rows: 1

   * - Prefijo
     - Uso
     - Ejemplo
   * - [VERIFIED]
     - Componente verificado
     - ``[VERIFIED] access/ (9 UC)``
   * - [NOT_VERIFIED]
     - No verificado aún
     - ``[NOT_VERIFIED] auth/``
   * - [UPDATED]
     - Actualizado a v4.0
     - ``[UPDATED] index.rst``
   * - [OUTDATED]
     - Desactualizado
     - ``[OUTDATED] Referencias v2.0``
   * - [READY]
     - Listo para usar
     - ``[READY] index_access_v4.rst``

3.3 Listas y Viñetas
--------------------

**Usar sintaxis RST estándar:**

.. code-block:: rst

   Opciones:
   
   - Opción 1
   - Opción 2
   - Opción 3
   
   Pasos:
   
   1. Primer paso
   2. Segundo paso
   3. Tercer paso
   
   Checkboxes (en comentarios o texto):
   
   - [ ] Tarea pendiente
   - [x] Tarea completada

3.4 Admoniciones RST
--------------------

**USAR las directivas RST nativas:**

.. code-block:: rst

   .. note::
      Información adicional
   
   .. warning::
      Advertencia importante
   
   .. danger::
      Peligro crítico
   
   .. important::
      Punto importante
   
   .. tip::
      Sugerencia útil
   
   .. attention::
      Requiere atención
   
   .. caution::
      Precaución necesaria

**RESULTADO VISUAL:**

.. note::
   Esto es una nota informativa.

.. warning::
   Esto es una advertencia.

.. danger::
   Esto es un peligro crítico.

3.5 Tablas de Estado
--------------------

**USAR tablas RST con prefijos:**

.. code-block:: rst

   .. list-table::
      :widths: 30 20 50
      :header-rows: 1
   
      * - Componente
        - Estado
        - Notas
      * - access/
        - [OK]
        - Sin problemas
      * - fundamentos/
        - [OUTDATED]
        - 20 referencias antiguas
      * - auth/
        - [NOT_VERIFIED]
        - Pendiente verificación

**RESULTADO:**

.. list-table::
   :widths: 30 20 50
   :header-rows: 1

   * - Componente
     - Estado
     - Notas
   * - access/
     - [OK]
     - Sin problemas
   * - fundamentos/
     - [OUTDATED]
     - 20 referencias antiguas
   * - auth/
     - [NOT_VERIFIED]
     - Pendiente verificación

3.6 Secciones y Separadores
----------------------------

**USAR líneas simples:**

.. code-block:: rst

   ----
   
   Sección Nueva
   =============
   
   Subsección
   ----------
   
   Sub-subsección
   ^^^^^^^^^^^^^^

----

4. Casos Especiales
===================

4.1 Diagramas de Árbol
----------------------

**PERMITIDO:** Box drawing en code-blocks para estructura de directorios.

.. code-block:: text

   source/
   ├── requisitos/
   │   ├── casos_uso/
   │   │   ├── auth/
   │   │   └── users/
   │   └── funcionales/
   └── arquitectura/

**JUSTIFICACIÓN:** Esencial para representar jerarquía de archivos.

4.2 Diagramas PlantUML
----------------------

**PERMITIDO:** Cualquier símbolo dentro de bloques ``.. uml::``.

.. code-block:: rst

   .. uml::
      :caption: Diagrama UC
      
      @startuml
      actor Usuario
      Usuario -> Sistema : Acción
      @enduml

**JUSTIFICACIÓN:** PlantUML maneja su propia sintaxis interna.

4.3 Código Fuente Citado
-------------------------

**PERMITIDO:** Cualquier símbolo dentro de code-blocks que cite código real.

.. code-block:: rst

   .. code-block:: python
      
      # Este código puede tener cualquier símbolo
      if status == "✅":  # Aunque el emoji está en el código original
          print("OK")

**JUSTIFICACIÓN:** Es cita textual de código existente, no documentación nueva.

----

5. Ejemplos de Conversión
==========================

5.1 Ejemplo 1: Lista de Estado
-------------------------------

**ANTES (con emojis):**

.. code-block:: text

   ### ✅ Verificados y OK
   - ✅ _metadata/ (5 archivos)
   - ✅ _ontologia_sbvr/ (5 archivos)
   
   ### ⚠️ Con Problemas
   - ⚠️ _fundamentos/ (~20 referencias)
   
   ### ⏳ Pendientes
   - ⏳ auth/ (no verificado)

**DESPUÉS (sin emojis):**

.. code-block:: rst

   Verificados y OK
   ----------------
   
   - [OK] _metadata/ (5 archivos)
   - [OK] _ontologia_sbvr/ (5 archivos)
   
   Con Problemas
   -------------
   
   - [OUTDATED] _fundamentos/ (20 referencias antiguas)
   
   Pendientes
   ----------
   
   - [NOT_VERIFIED] auth/ (pendiente)

5.2 Ejemplo 2: Tabla de Progreso
---------------------------------

**ANTES:**

.. code-block:: text

   | Componente | Estado | Acción |
   |------------|--------|--------|
   | access/    | ✅ OK  | Ninguna |
   | fundamentos/ | ⚠️ Desact | 🔧 Actualizar |

**DESPUÉS:**

.. code-block:: rst

   .. list-table::
      :widths: 30 20 50
      :header-rows: 1
   
      * - Componente
        - Estado
        - Acción
      * - access/
        - [OK]
        - Ninguna
      * - fundamentos/
        - [OUTDATED]
        - [TODO] Actualizar

5.3 Ejemplo 3: Checklist
-------------------------

**ANTES:**

.. code-block:: text

   ## 🎯 Próximos Pasos
   - ✅ Análisis completado
   - ⏳ Verificar módulos
   - ❌ No implementado

**DESPUÉS:**

.. code-block:: rst

   Próximos Pasos
   --------------
   
   - [DONE] Análisis completado
   - [TODO] Verificar módulos
   - [PENDING] Implementación

5.4 Ejemplo 4: Nomenclatura Actualizada (v1.1.0)
-------------------------------------------------

**NUEVO en v1.1.0**

Ejemplos con nomenclatura correcta según NOM_001 v2.0.0:

.. code-block:: rst

   Artefactos con versionado correcto:
   
   - [OK] UC_AUTH_01_Iniciar_Sesion_4_0_0.rst
   - [OK] BR_001_Fuente_Inmutable_1_0_0.rst
   - [OK] CNST_001_Comunicaciones_Prohibidas_1_1_0.rst
   - [OK] STD_001_Suite_Calidad_Codigo_1_0_0.rst
   - [OK] FR_001.01_Validar_Username_1_0_0.rst
   
   Nomenclatura incorrecta:
   
   - [ERROR] UC_AUTH_001_Iniciar_Sesion.rst (debe ser 2 dígitos + versión)
   - [ERROR] BR_001_Fuente_Inmutable.rst (falta versionado)
   - [ERROR] FR-001.01_Validar.rst (debe usar guión bajo, no guión medio)

----

6. Validación
=============

6.1 Checklist de Revisión
--------------------------

Antes de aprobar un documento RST:

.. list-table::
   :widths: 10 90
   :header-rows: 0

   * - [ ]
     - Sin emojis en todo el documento
   * - [ ]
     - Sin iconos Unicode decorativos
   * - [ ]
     - Box drawing solo en code-blocks de estructura
   * - [ ]
     - Admoniciones RST usadas correctamente
   * - [ ]
     - Prefijos estándar en lugar de emojis
   * - [ ]
     - Tablas RST para estados
   * - [ ]
     - Build Sphinx sin warnings de encoding
   * - [ ]
     - Nomenclatura con versionado correcto (NOM_001 v2.0.0)

6.2 Comando de Verificación
----------------------------

.. code-block:: bash

   # Buscar emojis comunes
   grep -rn "[✅❌⚠️🚀📁💾🔍⏳✨🎉⭐📊📈🎯💡]" source/*.rst
   
   # Buscar iconos Unicode
   grep -rn "[▶●→★♦■▸»☑☐]" source/*.rst
   
   # RESULTADO ESPERADO: Sin coincidencias

----

7. Excepciones Documentadas
============================

7.1 Documentos Legacy
---------------------

Documentos creados antes de 2026-01-07 pueden contener emojis. Se permite
mantenerlos SOLO si:

1. Son documentos de referencia histórica
2. Están marcados claramente como "legacy"
3. No se modificarán en el futuro

**ACCIÓN:** Agregar advertencia al inicio:

.. code-block:: rst

   .. warning::
      
      Documento Legacy. Contiene emojis por razones históricas.
      No usar como referencia de estilo.

7.2 Documentos Externos Citados
--------------------------------

Si se cita textualmente documentación externa que contiene emojis:

.. code-block:: rst

   Según la documentación de [Herramienta X]:
   
      "✅ Feature enabled"
   
   [Fin de cita]

**ACCIÓN:** Mantener cita textual pero agregar nota:

.. code-block:: rst

   .. note::
      
      Cita textual de documentación externa. Los emojis son parte
      de la fuente original.

----

8. Historial de Cambios
========================

.. list-table::
   :widths: 10 15 20 55
   :header-rows: 1

   * - Versión
     - Fecha
     - Autor
     - Cambios
   * - 1.0.0
     - 2026-01-07
     - Equipo IACT
     - Estándar inicial: Prohibición de emojis e iconos Unicode
   * - 1.1.0
     - 2026-01-08
     - Equipo IACT
     - Actualización ejemplos con nomenclatura v2.0.0 (NOM_001). Añadida sección 5.4 con ejemplos de nomenclatura correcta. Actualizado checklist 6.1 con validación de nomenclatura.

----

**Trazabilidad:** Este estándar es OBLIGATORIO para toda documentación RST/MD
del proyecto IACT.

**Base:** NOM_001_Nomenclatura_Proyecto_IACT_2_0_0.rst
