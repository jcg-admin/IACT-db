.. meta::
   :artefacto: CNST_05
   :tipo: Restriccion
   :version: 2.0.0
   :fecha_creacion: 2026-01-11
   :ultimo_cambio: 2026-01-11
   :relacionado: META_001, META_003

CNST_05: Restricción de Creación Iterativa de documentos, archivos, codigos, etc v2.0.0
================================================================

.. contents:: Contenido
   :depth: 3
   :local:


1. Restricción
==============

**PROHIBIDO:** Crear o modificar múltiples documentos mediante procesamiento en batch, loops automatizados, append masivo o cualquier método que impida revisión individual de cada documentos, archivos, codigos, etc 

**REQUERIDO:** Crear y expandir documentos UNO POR UNO con revisión completa e individual de cada archivo antes de proceder con el siguiente.

**Alcance:** Aplica a toda creación, modificación o expansión de documentos de la IACT, especialmente durante implementación de fases del Plan Maestro.

----

2. Justificación
================

2.1. Problemas del Procesamiento en Batch
------------------------------------------

La creación de documentos en batch genera:

1. **Errores no detectados**

   - Errores de sintaxis RST se propagan a múltiples archivos
   - Inconsistencias no se identifican hasta build final
   - Corrección masiva requiere más tiempo que prevención

2. **Reducción de calidad del contenido**

   - Contenido genérico "plantilla" sin adaptación específica
   - Falta de ejemplos concretos por documento
   - Pérdida de profundidad técnica

3. **Imposibilidad de revisión granular**

   - No se puede validar cada documento individualmente
   - Errores acumulados dificultan identificación de origen
   - Build fallido apunta a múltiples archivos simultáneamente

4. **Inconsistencias entre documentos**

   - Referencias cruzadas mal construidas
   - Niveles de detalle dispares
   - Estructura no homogénea

5. **Violación de principio de alta calidad IACT**

   - IACT prioriza calidad sobre velocidad
   - Cada documento debe ser substantivo, no superficial
   - Documentación técnica requiere atención al detalle

2.2. Experiencia Empírica
----------------------------

**Caso real (Sesión 2026-01-11):**

Durante expansión de RT_04-08, se utilizó batch processing:

.. code-block:: bash

   # MÉTODO INCORRECTO usado
   for file in RT_04 RT_05 RT_06 RT_07 RT_08; do
     cat >> ${file}_*.rst << 'EOF'
     # Contenido genérico idéntico
     EOF
   done

**Resultado:**

- 5 archivos modificados sin revisión individual
- Contenido genérico sin adaptación específica a cada RT
- Calidad inferior comparada con RT_01-03 (hechos uno por uno)
- Necesidad de corrección posterior

**Lección aprendida:**

El tiempo "ahorrado" en batch se pierde en correcciones posteriores.

----

3. Metodología Correcta
=======================

3.1. Para Documentos Pequeños (<500 líneas)
--------------------------------------------

**Procedimiento:**

1. **Usar str_replace directamente**

   .. code-block:: python
   
      str_replace(
          path="/ruta/documento.rst",
          old_str="contenido original",
          new_str="contenido expandido v2.0.0"
      )

2. **Revisar resultado inmediato**

   .. code-block:: bash
   
      view /ruta/documento.rst

3. **Validar sintaxis**

   .. code-block:: bash
   
      # Opcional: validar solo este archivo
      rst2html documento.rst > /dev/null

4. **Proceder con siguiente documento**

   SOLO después de validar el anterior.

**Ejemplo correcto (CNST_02, CNST_03, CNST_04):**

.. code-block:: text

   ✓ PASO 1: Expandir CNST_02 completo
   ✓ PASO 2: Revisar CNST_02
   ✓ PASO 3: Validar CNST_02
   ✓ PASO 4: Expandir CNST_03 completo
   ✓ PASO 5: Revisar CNST_03
   ✓ PASO 6: Validar CNST_03
   ✓ PASO 7: Expandir CNST_04 completo
   ...

**NO hacer:**

.. code-block:: text

   ✗ Expandir CNST_02, CNST_03, CNST_04 simultáneamente
   ✗ Revisar después los 3 juntos

3.2. Para Documentos Grandes (>500 líneas)
-------------------------------------------

**Procedimiento:**

1. **Crear archivo completo en /tmp/**

   .. code-block:: python
   
      create_file(
          path="/tmp/PROC_007_completo.rst",
          content="... 800+ líneas ..."
      )

   **Razón:** Archivos grandes pueden exceder límites de str_replace.

2. **Revisar contenido con múltiples métodos**

   .. code-block:: bash
   
      # Ver primeras 50 líneas
      head -50 /tmp/PROC_007_completo.rst
      
      # Ver últimas 50 líneas
      tail -50 /tmp/PROC_007_completo.rst
      
      # Ver sección específica
      view /tmp/PROC_007_completo.rst --view_range [100, 200]
      
      # Buscar patrones
      grep ".. code-block::" /tmp/PROC_007_completo.rst

3. **Validar sintaxis RST**

   .. code-block:: bash
   
      # Validación básica
      python -m sphinx.cmd.quickstart --quiet /tmp/test_build
      cp /tmp/PROC_007_completo.rst /tmp/test_build/
      cd /tmp/test_build && make html

4. **Mover a ubicación final**

   .. code-block:: bash
   
      cp /tmp/PROC_007_completo.rst \
         /tmp/biblioteca_traduccion/source/procedimientos/PROC_007_Control_Calidad_Traduccion_2_0_0.rst

5. **Verificar con build completo del proyecto**

   .. code-block:: bash
   
      cd /tmp/biblioteca_traduccion
      make html 2>&1 | grep PROC_007

6. **Proceder con siguiente documento grande**

**Ejemplo correcto (PROC_007, PROC_008, PROC_009):**

.. code-block:: text

   ✓ Crear PROC_007 en /tmp/
   ✓ Revisar PROC_007 (head, tail, view)
   ✓ Validar PROC_007 sintaxis
   ✓ Mover PROC_007 a destino
   ✓ Build validación
   
   ✓ Crear PROC_008 en /tmp/
   ✓ Revisar PROC_008
   ...

3.3. Para Expansión de Secciones
----------------------------------------

Si se necesita añadir una sección a un documento existente:

**Método correcto:**

.. code-block:: python

   # Documento por documento
   str_replace(
       path="RT_01.rst",
       old_str="6. Referencias",
       new_str="""7. Casos Límite v2.0.0
   ====================
   
   [Contenido específico para RT_01]
   
   8. Referencias"""
   )
   
   # Revisar RT_01
   view RT_01.rst
   
   # LUEGO hacer RT_02
   str_replace(
       path="RT_02.rst",
       old_str="6. Referencias",
       new_str="""7. Casos Límite v2.0.0
   ====================
   
   [Contenido específico para RT_02 - DIFERENTE a RT_01]
   
   8. Referencias"""
   )

**Método INCORRECTO:**

.. code-block:: bash

   # ✗ NO HACER ESTO
   for file in RT_*.rst; do
     sed -i 's/6. Referencias/7. Casos\n\n8. Referencias/' $file
   done

----

4. Ejemplos Detallados de Violaciones
======================================

4.1. Violación: Loop en Bash
----------------------------------------

**Código PROHIBIDO:**

.. code-block:: bash

   ✗ INCORRECTO:
   
   for i in $(seq -w 1 8); do
     cat >> RT_0${i}_*.rst << 'EOF'
   
   7. Casos Adicionales v2.0.0
   ============================
   
   **Ver documentación principal.**
   
   8. Referencias
   ==============
   
   EOF
   done
   
   echo "✓ RT_01-08 todas actualizadas"

**Problemas:**

1. Contenido idéntico copiado a 8 archivos sin adaptación
2. "Ver documentación principal" es vago, no específico
3. No hay revisión individual
4. Si hay error sintáctico, afecta a todos
5. Calidad genérica, no substantiva

**Método CORRECTO:**

.. code-block:: python

   # RT_01 - Contenido específico
   str_replace(
       path="RT_01_Primera_Aparicion_Terminos_1_0_0.rst",
       old_str="6. Referencias",
       new_str="""7. Casos Límite v2.0.0
   ======================
   
   7.1. Término en Título y Texto
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   
   **Situación:** "Callbacks" aparece en título de sección Y en texto.
   
   **Regla:** Título NO cuenta como primera aparición.
   
   .. code-block:: rst
   
      Callbacks en Node.js
      ====================
      
      Node.js utiliza :term:`callbacks` para operaciones asíncronas.
   
   7.2. Término Aparece en Código
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   
   **Situación:** Término técnico dentro de bloque de código.
   
   **Regla:** Código NO cuenta. Marcar en texto explicativo.
   
   8. Referencias"""
   )
   
   # Revisar RT_01
   view RT_01_Primera_Aparicion_Terminos_1_0_0.rst
   
   # Build parcial
   make html 2>&1 | grep RT_01
   
   # SOLO AHORA proceder con RT_02
   str_replace(
       path="RT_02_Nombres_Propios_1_0_0.rst",
       old_str="6. Referencias",
       new_str="""7. Casos Especiales v2.0.0
   ==========================
   
   7.1. Empresas con Nombre Traducible
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   
   **Ejemplo:** "Microsoft" NO traducir (nombre propio)
   
   [Contenido DIFERENTE específico para RT_02]
   
   8. Referencias"""
   )

4.2. Violación: Append Masivo sin Revisión
-------------------------------------------

**Código PROHIBIDO:**

.. code-block:: bash

   ✗ INCORRECTO:
   
   cat >> ESC_01_Escenario_Traduccion_Libro_Tecnico_1_0_0.rst << 'EOF'
   
   10. Métricas de Éxito v2.0.0
   ============================
   
   [200 líneas de contenido sin revisar línea por línea]
   
   11. Lecciones Aprendidas
   =========================
   
   [150 líneas más]
   
   EOF
   
   # Sin validación intermedia
   cat >> ESC_02_*.rst << 'EOF'
   [Más contenido masivo]
   EOF

**Problemas:**

1. 350+ líneas añadidas sin revisión
2. Imposible detectar errores hasta build
3. Contenido puede tener inconsistencias internas
4. Referencias cruzadas no validadas

**Método CORRECTO:**

.. code-block:: python

   # Crear ESC_01 completo en /tmp
   create_file(
       path="/tmp/ESC_01_expandido.rst",
       content="""... [contenido completo 350 líneas] ..."""
   )
   
   # Revisar secciones específicas
   view /tmp/ESC_01_expandido.rst --view_range [200, 250]
   view /tmp/ESC_01_expandido.rst --view_range [300, 350]
   
   # Validar sintaxis
   rst2html /tmp/ESC_01_expandido.rst > /dev/null
   
   # Mover a destino
   cp /tmp/ESC_01_expandido.rst source/reglas_operativas/
   
   # Build parcial
   make html 2>&1 | grep ESC_01
   
   # SOLO AHORA proceder con ESC_02

4.3. Violación: Modificación Simultánea
----------------------------------------

**Código PROHIBIDO:**

.. code-block:: bash

   ✗ INCORRECTO:
   
   # Actualizar versión en todos los PROC simultáneamente
   for f in PROC_00*.rst; do
     sed -i 's/v1.0.0/v2.0.0/' $f
     sed -i 's/:version: 1.0.0/:version: 2.0.0/' $f
     # Añadir contenido nuevo
     cat >> $f << 'EOF'
     [Nuevo contenido]
     EOF
   done

**Problemas:**

1. Cambios de versión + contenido mezclados
2. Si uno falla, todos quedan inconsistentes
3. No hay verificación intermedia

----

5. Excepciones Permitidas
==========================

5.1. Cambios Triviales de Metadata
----------------------------------------

**Permitido SOLO para cambios que NO afectan contenido sustancial:**

.. code-block:: bash

   # Actualizar fecha en todos los archivos (metadata trivial)
   sed -i 's/:ultimo_cambio: 2026-01-10/:ultimo_cambio: 2026-01-11/' *.rst

**Criterio:** Si el cambio es:

- Puramente metadata (fecha, versión en meta tag)
- Idéntico para todos los archivos
- NO afecta contenido visible al usuario
- NO cambia sintaxis RST

→ Batch permitido

**NO permitido:**

- Añadir secciones (requiere revisión)
- Cambiar estructura (varía por documento)
- Modificar contenido técnico (requiere validación)

5.2. Búsqueda y Reporte
----------------------------------------

**Permitido usar loops para LEER, NO para MODIFICAR:**

.. code-block:: bash

   # Buscar patrón en múltiples archivos (lectura)
   for f in *.rst; do
     grep "FIXME" $f && echo "Encontrado en $f"
   done
   
   # Contar líneas (lectura)
   wc -l PROC_*.rst

**Criterio:** Operaciones de solo lectura para análisis o reporte.

----

6. Integración con Workflow
============================

6.1. En Plan Maestro de Implementación
----------------------------------------

Al ejecutar una FASE con múltiples archivos:

**Secuencia correcta:**

.. code-block:: text

   FASE 8: Reglas Operativas (15 archivos)
   
   Día 1:
   - CNST_02 (completo, revisado, validado)
   - CNST_03 (completo, revisado, validado)
   - CNST_04 (completo, revisado, validado)
   
   Día 2:
   - RT_01 (completo, revisado, validado)
   - RT_02 (completo, revisado, validado)
   - RT_03 (completo, revisado, validado)
   
   [Continuar uno por uno]

**NO hacer:**

.. code-block:: text

   ✗ Día 1: Crear CNST_02-04 + RT_01-08 en batch
   ✗ Día 2: Revisar todos juntos

6.2. En Revisión de Calidad (PROC_007)
----------------------------------------

**Checklist adicional:**

.. code-block:: text

   [ ] CNST_05: ¿Documento creado individualmente?
   [ ] ¿Revisión completa antes de siguiente?
   [ ] ¿Validación de sintaxis aplicada?
   [ ] ¿Contenido específico (no genérico)?

6.3. En META_001 (Metodología de Trabajo)
----------------------------------------
----------------------------------------------
META_001 debe referenciar CNST_05 en sección de metodología:

.. code-block:: rst

   5.X. Restricción: Creación Iterativa
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   
   **Ver CNST_05 para restricción completa.**
   
   Resumen: NO crear documentos en batch.
   
   Al expandir múltiples archivos:
   1. Documento 1: Crear → Revisar → Validar
   2. Documento 2: Crear → Revisar → Validar
   3. Documento N: Crear → Revisar → Validar

----

7. Validación de Cumplimiento
==============================

7.1. Autoevaluación Durante Desarrollo
----------------------------------------

**Preguntas antes de continuar con siguiente documento:**

.. code-block:: text

   [ ] ¿Creé este documento UNO POR UNO?
   [ ] ¿Lo revisé completamente (head, tail, view)?
   [ ] ¿Validé la sintaxis RST?
   [ ] ¿El contenido es específico, no genérico?
   [ ] ¿Evité usar loops o batch?
   [ ] Si es >500 líneas, ¿lo creé en /tmp/ primero?
   [ ] ¿Build parcial pasó sin errores?

**Si respuesta es NO a cualquiera → DETENER, corregir antes de continuar.**

7.2. Revisión Post-Fase
----------------------------------------

Al completar una FASE con múltiples archivos:

.. code-block:: text

   [ ] Todos los documentos tienen contenido específico
   [ ] NO hay bloques idénticos copy-paste entre archivos
   [ ] Cada archivo fue validado individualmente
   [ ] Build completo exitoso
   [ ] Sin warnings relacionados con estos archivos

7.3. Señales de Violación
----------------------------------------

**Indicadores de que se usó batch (REVISAR):**

1. **Contenido idéntico en múltiples archivos**

   Ejemplo: "Ver documentación principal" en 5 archivos diferentes.

2. **Errores idénticos en múltiples archivos**

   Ejemplo: Mismo warning de sintaxis en RT_04-08.

3. **Nivel de detalle inconsistente**

   Ejemplo: RT_01-03 tienen 200+ líneas, RT_04-08 tienen 120 líneas.

4. **Referencias genéricas**

   Ejemplo: "Esta regla se aplica..." sin especificar cuál regla.

----

8. Corrección de Violaciones Pasadas
=====================================

Si se detecta que documentos fueron creados en batch:

**Procedimiento de corrección:**

1. **Identificar documentos afectados**

   .. code-block:: bash
   
      # Buscar contenido duplicado sospechoso
      for f in RT_0*.rst; do
        echo "=== $f ==="
        grep "Ver documentación principal" $f
      done

2. **Evaluar nivel de daño**

   - Superficial: Solo metadata → Corrección rápida
   - Moderado: Contenido genérico → Re-escribir secciones
   - Severo: Errores múltiples → Re-crear desde cero

3. **Corregir UNO POR UNO**

   .. code-block:: text
   
      NO corregir todos en batch.
      
      Corregir RT_04 completo → Validar → Siguiente

4. **Documentar lección aprendida**

   En notas del proyecto o changelog.

----

9. Herramientas de Apoyo
=========================

9.1. Script de Detección de Batch
----------------------------------------

.. code-block:: python

   # detect_batch_creation.py
   
   import os
   import difflib
   
   def detect_duplicate_content(files):
       """Detecta contenido duplicado entre archivos."""
       
       contents = {}
       for f in files:
           with open(f) as file:
               contents[f] = file.read()
       
       # Comparar pares de archivos
       for f1 in files:
           for f2 in files:
               if f1 >= f2:
                   continue
               
               # Calcular similitud
               similarity = difflib.SequenceMatcher(
                   None, 
                   contents[f1], 
                   contents[f2]
               ).ratio()
               
               if similarity > 0.7:  # >70% similar
                   print(f"⚠ SOSPECHA BATCH: {f1} y {f2} son {similarity*100:.1f}% similares")

**Uso:**

.. code-block:: bash

   python detect_batch_creation.py RT_*.rst

9.2. Checklist Automatizada
----------------------------

.. code-block:: bash

   # validate_cnst05.sh
   
   echo "Validando cumplimiento CNST_05..."
   
   # Verificar que no hay contenido idéntico
   for f in *.rst; do
     count=$(grep -c "Ver documentación principal" $f 2>/dev/null || echo 0)
     if [ $count -gt 0 ]; then
       echo "⚠ $f tiene frase genérica"
     fi
   done
   
   # Verificar longitud similar
   wc -l *.rst | sort -n

----

10. Referencias
===============

10.1. Documentos Relacionados
----------------------------------------

- :doc:`/metadocumentacion/META_001_Metodologia_Trabajo_2_0_0`
- :doc:`/metadocumentacion/META_003_Instrucciones_Claude_2_0_0`

10.2. Otras Restricciones
----------------------------------------

Esta restricción complementa:

- Restricción de versionado (no especificada formalmente, pero práctica)
- Restricción de no usar emojis/iconos en documentación
- CNST_02: Sin traducciones literales
- CNST_03: Sin cambio estructura
- CNST_04: Sin sinónimos

10.3. Estándares
~~~~~~~~~~~~~~~~~

- STD_002: Formato RST (próximamente)
- STD_009: Calidad Documental (próximamente)

----

11. Resumen de Cambios
=======================

**Versión 2.0.0 (2026-01-11):**

- Documento inicial creado
- Define restricción de creación iterativa
- Justificación basada en experiencia empírica
- Metodología correcta detallada
- Ejemplos de violaciones
- Excepciones permitidas claramente definidas
- Integración con workflow
- Herramientas de validación

**Propósito:**

Establecer formalmente la restricción que asegura calidad individual de cada documento mediante creación iterativa, evitando procesamiento en batch que reduce calidad y genera errores.

----

**Documento controlado. Versión 2.0.0. Fecha: 2026-01-11.**

**Aprobado por:** Equipo Traducción IACT

**Próxima revisión:** 2026-04-11 (3 meses)

**Nota importante:** Esta restricción surge de lecciones aprendidas durante implementación de FASE 6 y FASE 8, y debe aplicarse rigurosamente en todas las fases futuras.
