.. meta::
   :artefacto: META_02
   :tipo: Clasificacion
   :dominio: base_cognitiva
   :subdominio: _metadata
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-18
   :ultimo_cambio: 2025-12-18
   :autor: PMO IACT
   :clasificacion: Interno

.. _meta-02:
.. _meta_02_clasificacion_documental:

==================================
META_02 · Clasificación Documental
==================================

1. Propósito
------------

Este documento establece los niveles de clasificación de seguridad aplicables
a toda la documentación del proyecto IACT, definiendo restricciones de acceso,
manejo y distribución para cada nivel.

---------------------------
2. Niveles de Clasificación
---------------------------

2.1. Definición de Niveles
^^^^^^^^^^^^^^^^^^^^^^^^^^

El proyecto IACT adopta cuatro niveles de clasificación documental,
alineados con la política corporativa de seguridad de la información:

.. list-table::
   :widths: 20 40 40
   :header-rows: 1

   * - Nivel
     - Definición
     - Ejemplos
   * - Público
     - Información que puede ser divulgada sin restricciones fuera
       de la organización.
     - Documentación de API pública, guías de usuario final,
       material de marketing técnico.
   * - Interno
     - Información de uso general dentro de la organización. No debe
       divulgarse externamente sin autorización.
     - Documentación técnica, requisitos funcionales, casos de uso,
       arquitectura del sistema.
   * - Confidencial
     - Información sensible cuya divulgación no autorizada podría
       causar daño a la organización o sus clientes.
     - Credenciales de prueba, configuraciones de seguridad,
       datos de clientes anonimizados, contratos.
   * - Restringido
     - Información altamente sensible con acceso limitado a
       personal específicamente autorizado.
     - Claves de producción, datos personales sin anonimizar,
       información financiera detallada, auditorías de seguridad.

2.2. Matriz de Controles por Nivel
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 32 17 17 17 17
   :header-rows: 1

   * - Control
     - Público
     - Interno
     - Confidencial
     - Restringido
   * - Almacenamiento en repo Git
     - Sí
     - Sí
     - Con cifrado
     - No permitido
   * - Envío por email corporativo
     - Sí
     - Sí
     - Cifrado
     - Prohibido
   * - Compartir con externos
     - Sí
     - Con NDA
     - Prohibido
     - Prohibido
   * - Impresión física
     - Libre
     - Controlada
     - Registro
     - Prohibida
   * - Copia a dispositivos USB
     - Sí
     - Autorización
     - Prohibido
     - Prohibido
   * - Discusión en áreas comunes
     - Sí
     - Precaución
     - Prohibido
     - Prohibido

---------------------------------
3. Clasificación por Dominio IACT
---------------------------------

La siguiente tabla establece la clasificación por defecto de cada
dominio primario del modelo documental IACT:

.. list-table::
   :widths: 35 20 45
   :header-rows: 1

   * - Dominio
     - Clasificación
     - Justificación
   * - base_cognitiva/
     - Interno
     - Fundamentos metodológicos del proyecto, sin datos sensibles.
   * - requisitos/
     - Interno
     - Reglas de negocio y casos de uso contienen lógica propietaria.
   * - arquitectura_tecnica/
     - Confidencial
     - Decisiones de arquitectura y diseño son propiedad intelectual.
   * - normativa/
     - Interno
     - Estándares y restricciones de aplicación interna.
   * - trazabilidad/
     - Interno
     - Matrices de relación sin datos operativos.

---------------------------
4. Etiquetado de Documentos
---------------------------

4.1. Metadato Obligatorio
^^^^^^^^^^^^^^^^^^^^^^^^^

Todo artefacto IACT debe incluir el campo ``:clasificacion:`` en su
bloque ``.. meta::``:

.. code-block:: rst

   .. meta::
      :artefacto: XX_NNN
      :clasificacion: Interno

4.2. Valores Permitidos
^^^^^^^^^^^^^^^^^^^^^^^

- ``Publico``
- ``Interno``
- ``Confidencial``
- ``Restringido``

4.3. Herencia de Clasificación
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Un artefacto hereda la clasificación de su dominio por defecto.
- Un artefacto puede tener clasificación superior a su dominio, nunca inferior.
- La clasificación más alta de un artefacto contenido eleva la clasificación
  efectiva del dominio para efectos de acceso.

-----------------
5. Roles y Acceso
-----------------

.. list-table::
   :widths: 25 15 15 15 15
   :header-rows: 1

   * - Rol
     - Público
     - Interno
     - Confidencial
     - Restringido
   * - PMO / Gobernanza
     - Lectura/Escritura
     - Lectura/Escritura
     - Lectura/Escritura
     - Lectura/Escritura
   * - Arquitecto
     - Lectura/Escritura
     - Lectura/Escritura
     - Lectura/Escritura
     - Lectura
   * - Business Analyst
     - Lectura/Escritura
     - Lectura/Escritura
     - Lectura
     - Sin acceso
   * - Desarrollador
     - Lectura/Escritura
     - Lectura/Escritura
     - Lectura
     - Sin acceso
   * - QA
     - Lectura
     - Lectura
     - Lectura
     - Sin acceso
   * - Stakeholder Externo
     - Lectura
     - Sin acceso
     - Sin acceso
     - Sin acceso

---------------------------
6. Procedimientos de Manejo
---------------------------

6.1. Cambio de Clasificación
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Para modificar la clasificación de un artefacto:

1. Solicitante presenta justificación escrita al Owner del dominio.
2. Owner evalúa impacto y consulta con Seguridad de la Información si aplica.
3. PMO aprueba o rechaza mediante registro en historial del artefacto.
4. Si se aprueba, se actualiza metadato y se notifica a interesados.

6.2. Incidentes de Clasificación
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ante divulgación no autorizada de información clasificada:

1. Reportar inmediatamente a Seguridad de la Información.
2. Documentar alcance de la divulgación.
3. Ejecutar plan de contención según nivel afectado.
4. Registrar incidente y acciones correctivas.

--------------
7. Referencias
--------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Documento
     - Referencia
   * - Identidad del Proyecto
     - :doc:`META_01_Identidad_Proyecto`
   * - Política Corporativa de Seguridad
     - (Documento externo al sistema IACT)
   * - Roles y Responsabilidades IACT
     - (Documento externo al sistema IACT)

--------------------
Historial de Cambios
--------------------

.. list-table::
   :widths: 15 15 20 50
   :header-rows: 1

   * - Versión
     - Fecha
     - Autor
     - Cambios
   * - 1.0.0
     - 2025-12-18
     - PMO IACT
     - Versión inicial aprobada

----

**Trazabilidad:** Base para controles de acceso y auditorías de seguridad.
Referenciado por políticas de gobernanza y procedimientos de auditoría.
