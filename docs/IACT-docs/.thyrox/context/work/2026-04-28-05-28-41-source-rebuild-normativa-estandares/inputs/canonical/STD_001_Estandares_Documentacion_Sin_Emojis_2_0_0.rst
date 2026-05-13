.. meta::
   :artefacto: STD_001
   :tipo: Estandar
   :version: 2.0.0
   :fecha_creacion: 2026-01-11
   :ultimo_cambio: 2026-01-11
   :relacionado: STD_002, CNST_05

STD_001: Estándar de Documentación Sin Emojis v2.0.0
=====================================================

.. contents:: Contenido
   :depth: 3
   :local:
----

1. Estándar
===========

**REGLA FUNDAMENTAL:**

**NUNCA usar emojis, iconos Unicode decorativos, ni símbolos especiales en el output de scripts de producción ni en documentación técnica del proyecto IACT.**

**REQUERIDO:** Usar exclusivamente marcadores textuales ASCII estándar.

**Alcance:** Toda la documentación RST, scripts, outputs de herramientas, y mensajes de usuario del proyecto Biblioteca de Traducción Técnica IACT.

----

2. Justificación Técnica
=========================

2.1. Problemas de Compatibilidad
---------------------------------

**Renderizado inconsistente:**

- PDF/LaTeX: Muchos emojis no se renderizan correctamente
- Terminales: Soporte limitado en sistemas legacy
- Editores de texto: Visualización inconsistente
- Sistemas operativos: Windows, Linux, macOS muestran diferente

**Ejemplo de problema:**

.. code-block:: text

   Terminal macOS:  ✅ Build exitoso
   Terminal Windows: □ Build exitoso  (cuadrado blanco)
   PDF LaTeX:       [?] Build exitoso  (carácter desconocido)

2.2. Problemas de Procesamiento Automático
-------------------------------------------

**Búsqueda y parsing:**

- Grep/sed/awk: Dificultad con caracteres multibyte
- Parsing automatizado: Tokens inesperados
- Logs analizables: Scripts esperan ASCII

**Ejemplo:**

.. code-block:: bash

   # Con emojis - FALLA
   grep "✅" build.log  # Encoding issues
   
   # Sin emojis - FUNCIONA
   grep "\[OK\]" build.log  # Siempre funciona

2.3. Profesionalismo y Claridad
--------------------------------

**Documentación técnica:**

- Emojis no son apropiados en contexto profesional
- Ambigüedad semántica (⚠️ puede significar varias cosas)
- Distracción visual en textos técnicos
- No cumplen estándares ISO para documentación técnica

2.4. Accesibilidad
------------------

**Lectores de pantalla:**

- Emojis son leídos como descripciones largas
- "Heavy check mark" vs "OK"
- Dificulta accesibilidad para personas con discapacidad visual

----

3. Elementos Prohibidos
========================

3.1. Emojis
-----------

**PROHIBIDO en CUALQUIER contexto:**

.. code-block:: text

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
   🐛 Debug
   💡 Idea
   📢 Anuncio
   ⏰ Tiempo
   📅 Fecha
   👤 Usuario
   🌐 Red

**Razón:** Incompatibilidad, ambigüedad, no profesionales.

3.2. Iconos Unicode Decorativos
--------------------------------

**PROHIBIDO:**

.. code-block:: text

   ▶ Ejecutando
   ● Item
   → Siguiente
   ★ Importante
   ♦ Nota
   ■ Opción
   ▸ Paso
   » Info
   • Viñeta decorativa
   ◆ Marcador
   ► Play
   ◄ Atrás
   ▲ Arriba
   ▼ Abajo

**Razón:** Problemas de renderizado en PDF, incompatibilidad terminales.

3.3. Box Drawing Characters
----------------------------

**PROHIBIDO para decoración:**

.. code-block:: text

   ╔════════════╗
   ║   Título   ║
   ╚════════════╝
   
   ┌──────────┐
   │  Caja    │
   └──────────┘
   
   ├─ Item
   │  └─ Subitem

**Razón:** Rompe en copiar/pegar, problemas de encoding, no portables.

**Excepción:** Diagramas ASCII art cuando son contenido técnico esencial (ej: flowcharts), NO decoración.

3.4. Símbolos Matemáticos Decorativos
--------------------------------------

**PROHIBIDO usar como decoración:**

.. code-block:: text

   ≈ Aproximadamente (usar: ~)
   ≠ Diferente (usar: !=)
   ≤ Menor igual (usar: <=)
   ≥ Mayor igual (usar: >=)
   ∞ Infinito (escribir: infinito)
   ∑ Suma (escribir: suma)

**Excepción:** En ecuaciones matemáticas formales (directiva ``.. math::``).

----

4. Alternativas Permitidas
===========================

4.1. Sistema de Prefijos Estándar
----------------------------------

**USAR estos marcadores ASCII:**

.. code-block:: text

   [INFO]    Información general
   [DEBUG]   Detalles de depuración
   [WARN]    Advertencia
   [WARNING] Advertencia (forma larga)
   [ERROR]   Error encontrado
   [FATAL]   Error crítico
   [CRITICAL] Error crítico (alternativa)
   [SUCCESS] Operación exitosa
   [OK]      Todo bien
   [FAIL]    Operación falló
   [FAILED]  Operación falló (forma larga)

**Ejemplo en uso:**

.. code-block:: text

   [INFO] Iniciando build de documentación
   [DEBUG] Procesando archivo: PROC_001.rst
   [OK] Build completado exitosamente
   [WARN] 3 referencias sin resolver

4.2. Estados de Proceso
------------------------

**Para indicar progreso:**

.. code-block:: text

   [PENDING]    Operación pendiente
   [RUNNING]    En ejecución
   [PROCESSING] Procesando
   [DONE]       Completado
   [COMPLETE]   Completado (alternativa)
   [SKIPPED]    Omitido
   [RETRY]      Reintentando
   [WAITING]    Esperando
   [START]      Iniciando
   [STOP]       Detenido
   [END]        Finalizado

4.3. Viñetas y Listas
---------------------

**Según tipo de archivo:**

**En Markdown (.md):**

.. code-block:: markdown

   - Item con guión
   * Item con asterisco
   1. Item numerado
   2. Segundo item

**En reStructuredText (.rst):**

.. code-block:: rst

   - Item con guión
   * Item con asterisco
   
   1. Item numerado
   2. Segundo item

**En archivos de texto plano (.txt):**

.. code-block:: text

   - Item
   * Alternativa
   1. Numerado

**NUNCA usar:** ▶, ●, ★, ♦, •

4.4. Flechas y Direcciones
---------------------------

**Según tipo de archivo:**

**ASCII estándar:**

.. code-block:: text

   -> Flecha simple
   => Flecha doble
   <- Flecha izquierda
   <=> Bidireccional

**En diagramas técnicos:**

.. code-block:: text

   A -> B -> C
   
   Usuario -> Sistema -> Base de Datos
   
   if (condicion) {
       // true
   } else {
       // false
   }

**NUNCA usar:** →, ⇒, ➜, ➔, ⬅, ⬆, ⬇

4.5. Marcadores de Estado
--------------------------

**Check/Cross:**

.. code-block:: text

   [OK]   En lugar de: ✓ ✔ ☑
   [PASS] En lugar de: ✅
   [FAIL] En lugar de: ✗ ✘ ☒
   [ERROR] En lugar de: ❌

**Ejemplo de checklist:**

.. code-block:: text

   Validación de Capítulo:
   
   [OK]   Sintaxis RST correcta
   [OK]   Referencias cruzadas válidas
   [FAIL] Glosario incompleto
   [OK]   Build exitoso

----

5. Tabla de Referencia Rápida
==============================

.. list-table:: Conversión de Símbolos a Texto
   :widths: 25 25 25 25
   :header-rows: 1

   * - Concepto
     - ❌ No Usar
     - ✅ Usar
     - Comentarios
   * - **Completado**
     - ✅ ✓ ☑
     - [OK] [SUCCESS] [DONE]
     - ASCII estándar
   * - **Error**
     - ❌ ✗ ☒
     - [ERROR] [FAIL] [FAILED]
     - Parseable
   * - **Advertencia**
     - ⚠️ ⚡ ⛔
     - [WARN] [WARNING]
     - Compatible terminales
   * - **Información**
     - ℹ️ 💡 📢
     - [INFO] [NOTE]
     - Búsqueda fácil
   * - **Depuración**
     - 🐛 🔍
     - [DEBUG]
     - Logs analizables
   * - **En proceso**
     - ⏳ 🔄 ⌛
     - [RUNNING] [PROCESSING]
     - Estados claros
   * - **Esperando**
     - ⏰ ⏱️
     - [PENDING] [WAITING]
     - Sin ambigüedad
   * - **Inicio**
     - 🚀 ▶️
     - [START] Starting...
     - Texto explícito
   * - **Fin**
     - 🏁 ⏹️
     - [STOP] [END] Finished
     - Claro y directo
   * - **Archivo**
     - 📁 📄 💾
     - FILE: archivo.txt
     - Identificable
   * - **Carpeta**
     - 📂 🗂️
     - DIRECTORY: /ruta/
     - Estándar Unix
   * - **Red**
     - 🌐 📡
     - [NETWORK]
     - Compatible
   * - **Usuario**
     - 👤 👥
     - USER: username
     - Parseable
   * - **Tiempo**
     - ⏰ 🕐
     - TIME: 10:30
     - ISO 8601
   * - **Fecha**
     - 📅 🗓️
     - DATE: 2026-01-11
     - ISO 8601 YYYY-MM-DD
   * - **Viñetas**
     - ▶ ● ★ ♦
     - ``-`` ``*`` ``1.`` ``2.``
     - Según formato archivo
   * - **Flechas**
     - → ⇒ ➜ ➔
     - ``->`` ``=>``
     - ASCII estándar
   * - **Check**
     - ☑ ✓ ✔
     - [OK] PASS
     - Texto claro
   * - **Cross**
     - ☒ ✗ ✘
     - [FAIL] ERROR
     - Sin ambigüedad

----

6. Casos Especiales y Excepciones
==================================

6.1. Ecuaciones Matemáticas
----------------------------

**PERMITIDO:** Símbolos matemáticos en contexto formal.

.. code-block:: rst

   .. math::
   
      E = mc^2
      
      \sum_{i=1}^{n} x_i
      
      \int_{0}^{\infty} f(x) dx

**Razón:** MathJax/LaTeX los renderiza correctamente, son contenido técnico esencial.

6.2. Diagramas Técnicos ASCII
------------------------------

**PERMITIDO:** Cuando es contenido técnico, NO decoración.

.. code-block:: text

   Diagrama de flujo aceptable:
   
      +----------+
      | Usuario  |
      +----------+
           |
           v
      +----------+
      | Sistema  |
      +----------+

**Criterio:** ¿Es esencial para entender el concepto técnico?
- Sí → Permitido
- No (solo decorativo) → Prohibido

6.3. Ejemplos de Código Externo
--------------------------------

**PERMITIDO:** Si código original tiene emojis.

.. code-block:: python

   # Código de ejemplo de repositorio externo
   def test_success():
       print("✅ Test passed")  # Preservar como en original

**Aclaración:** Añadir nota explicativa.

.. code-block:: rst

   .. note::
      El código original contiene emojis. En código propio de IACT,
      usar ``[OK]`` en su lugar.

6.4. Capturas de Pantalla
--------------------------

**PERMITIDO:** Emojis en imágenes/screenshots.

Las capturas de pantalla pueden contener emojis si son parte de la UI capturada.

----

7. Validación
=============

7.1. Detección Automatizada
----------------------------

**Script:** ``detect_emojis.py``

.. code-block:: python

   #!/usr/bin/env python3
   """Detecta emojis y símbolos Unicode no permitidos."""
   
   import re
   import sys
   
   PROHIBITED_CHARS = {
       '✅': '[OK]',
       '❌': '[ERROR]',
       '⚠️': '[WARN]',
       '🚀': '[START]',
       '📁': 'FILE:',
       '💾': '[SAVE]',
       '✓': '[OK]',
       '✗': '[FAIL]',
       '→': '->',
       '⇒': '=>',
       # Añadir más según tabla de referencia
   }
   
   def check_file(filepath):
       with open(filepath, 'r', encoding='utf-8') as f:
           content = f.read()
       
       violations = []
       for char, replacement in PROHIBITED_CHARS.items():
           if char in content:
               count = content.count(char)
               violations.append(f"'{char}' encontrado {count} veces. Usar: {replacement}")
       
       return violations
   
   if __name__ == '__main__':
       if len(sys.argv) < 2:
           print("Uso: python detect_emojis.py archivo.rst")
           sys.exit(1)
       
       violations = check_file(sys.argv[1])
       
       if violations:
           print(f"[ERROR] Emojis/símbolos prohibidos encontrados en {sys.argv[1]}:")
           for v in violations:
               print(f"  - {v}")
           sys.exit(1)
       else:
           print(f"[OK] {sys.argv[1]} cumple STD_001")

**Uso:**

.. code-block:: bash

   python detect_emojis.py source/procedimientos/PROC_001.rst

7.2. Integración con Build
---------------------------

**En Makefile o CI/CD:**

.. code-block:: makefile

   validate-emojis:
       @echo "[INFO] Validando cumplimiento STD_001..."
       @find source -name "*.rst" -exec python scripts/detect_emojis.py {} \;

7.3. Pre-commit Hook
--------------------

**Archivo:** ``.git/hooks/pre-commit``

.. code-block:: bash

   #!/bin/bash
   
   echo "[INFO] Validando STD_001 (sin emojis)..."
   
   # Buscar archivos .rst modificados
   changed_files=$(git diff --cached --name-only --diff-filter=ACM | grep '\.rst$')
   
   for file in $changed_files; do
       if ! python scripts/detect_emojis.py "$file"; then
           echo "[ERROR] Commit bloqueado: $file contiene emojis prohibidos"
           echo "[INFO] Ver STD_001 para alternativas permitidas"
           exit 1
       fi
   done
   
   echo "[OK] Todos los archivos cumplen STD_001"

----

8. Ejemplos Completos
=====================

8.1. Ejemplo INCORRECTO
-----------------------

.. code-block:: text

   ✅ FASE 6 completada
   
   Archivos procesados:
   📁 PROC_001.rst
   📁 PROC_004.rst
   
   Estado:
   ✓ Build exitoso
   ⚠️ 3 warnings
   
   Siguiente paso:
   🚀 Iniciar FASE 7

8.2. Ejemplo CORRECTO
---------------------

.. code-block:: text

   [OK] FASE 6 completada
   
   Archivos procesados:
   - PROC_001.rst
   - PROC_004.rst
   
   Estado:
   [OK] Build exitoso
   [WARN] 3 warnings
   
   Siguiente paso:
   [START] Iniciar FASE 7

8.3. Script Output INCORRECTO
------------------------------

.. code-block:: bash

   echo "✅ Traducción completada"
   echo "📊 Estadísticas:"
   echo "   • 1,234 líneas"
   echo "   • 45 términos"
   echo "🎉 ¡Éxito!"

8.4. Script Output CORRECTO
----------------------------

.. code-block:: bash

   echo "[SUCCESS] Traducción completada"
   echo "[INFO] Estadísticas:"
   echo "   - 1,234 líneas"
   echo "   - 45 términos"
   echo "[OK] Proceso finalizado exitosamente"

----

9. Integración con Proyecto IACT
=================================

9.1. Relación con Otros Estándares
-----------------------------------

**STD_001 complementa:**

- **STD_002:** Formato RST (sintaxis)
- **STD_003:** Metadata obligatoria
- **STD_008:** Validación de builds

**STD_001 es prerequisito para:**

- Todos los procedimientos que generan output
- Todos los scripts de herramientas
- Toda documentación nueva

9.2. Relación con Restricciones
--------------------------------

**STD_001 se relaciona con:**

- **CNST_05:** Restricción creación iterativa
  - Ambos buscan calidad y profesionalismo
  - Ambos previenen atajos que reducen calidad

9.3. Aplicación en Procedimientos
----------------------------------

**PROC_002, PROC_007, PROC_009** y todos los demás:

Al generar outputs, logs, mensajes:
- Usar prefijos ``[INFO]``, ``[OK]``, etc.
- NO usar emojis
- Seguir tabla de referencia rápida

----

10. Checklist de Cumplimiento
==============================

**Al crear/modificar documentación:**

.. code-block:: text

   [ ] Sin emojis (✅❌⚠️🚀 etc.)
   [ ] Sin iconos Unicode decorativos (▶●★♦ etc.)
   [ ] Sin box drawing decorativo (╔═╗ etc.)
   [ ] Usar prefijos ASCII: [OK], [ERROR], [WARN]
   [ ] Viñetas apropiadas al formato (-, *, 1.)
   [ ] Flechas ASCII estándar (->  =>)
   [ ] Fechas en formato ISO 8601 (YYYY-MM-DD)
   [ ] Script detect_emojis.py pasa
   [ ] Build sin warnings sobre caracteres especiales

----

11. Referencias
===============

11.1. Estándares Relacionados
------------------------------

- **ISO/IEC 26300:** OpenDocument Format (problemas con Unicode)
- **RFC 3629:** UTF-8 encoding (issues potenciales)
- **ISO 8601:** Formatos de fecha y hora
- **ASCII (ANSI X3.4-1986):** Conjunto de caracteres estándar

11.2. Documentos IACT
---------------------

- :doc:`STD_002_Formato_RST_1_0_0`
- :doc:`STD_003_Metadata_Obligatoria_1_0_0`
- :doc:`/reglas_operativas/CNST_05_Restriccion_Creacion_Iterativa_2_0_0`

11.3. Recursos Externos
-----------------------

- Unicode Consortium - Emoji List
- Sphinx Documentation - reStructuredText Primer
- LaTeX Project - Text Encoding

----

12. Resumen de Cambios
=======================

**Versión 2.0.0 (2026-01-11):**

- Documento inicial creado
- Regla fundamental establecida
- Justificación técnica completa
- Tabla de referencia rápida (21 categorías)
- Casos especiales y excepciones definidos
- Script de validación proporcionado
- Integración con proyecto IACT
- Ejemplos completos correctos e incorrectos

**Propósito:**

Establecer estándar formal para documentación profesional sin emojis/iconos, garantizando compatibilidad, parsabilidad y profesionalismo en todo el proyecto IACT.

**Notas:**

- Este estándar arregla link roto en index.rst
- Documenta restricción mencionada pero no formalizada
- Base para validación automatizada en CI/CD

----

**Documento controlado. Versión 2.0.0. Fecha: 2026-01-11.**

**Aprobado por:** Equipo Traducción IACT

**Próxima revisión:** 2026-04-11 (3 meses)

**Nota importante:** Este estándar aplica a TODA documentación y código del proyecto desde su adopción. Documentos existentes deben ser actualizados progresivamente.
