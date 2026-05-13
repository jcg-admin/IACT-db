ADR-GOB-005: Jerarquía de Requerimientos en 5 Niveles
=====================================================

ESTA SE TIENE ACTUALIZAR, YA QUE LA METODOLOGIA QUE SE ESTA USANDO
ACTUALMENTE NO LO CONSIDERA COMO NIVELES, COSULTAR INGENIERIA DE
REQUERMIENTOS

Estado
------

**APROBADO** - 2025-11-17

Contexto
--------

La ingeniería de requerimientos en proyectos de software requiere un
marco estructurado para organizar, clasificar y relacionar diferentes
tipos de requisitos. Sin una jerarquía clara, se presentan problemas
comunes:

Problemas sin Estructura Jerárquica
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Confusión de niveles**: - Mezclar objetivos de negocio con detalles de
implementación - Tratar reglas de negocio como requisitos funcionales -
No distinguir entre necesidades de usuario y características del sistema

**Falta de trazabilidad**: - Dificultad para rastrear por qué existe
cierta funcionalidad - Imposibilidad de validar que requisitos de alto
nivel se cumplen - Cambios en políticas no se reflejan en funcionalidad

**Comunicación deficiente**: - Stakeholders de negocio no entienden
documentación técnica - Desarrolladores no comprenden objetivos de
negocio - QA no sabe qué validar realmente

**Alcance mal definido**: - Requisitos funcionales se expanden sin
justificación - Features sin conexión con objetivos organizacionales -
Atributos de calidad tratados como “extras opcionales”

Necesidades del Proyecto IACT
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

El proyecto IACT requiere:

1. **Múltiples dominios**: Backend, Frontend, DevOps, QA, AI requieren
   organización consistente
2. **Cumplimiento regulatorio**: Reglas de negocio externas (LFPDPPP,
   normas de salud, etc.)
3. **Múltiples stakeholders**: Desde ejecutivos hasta desarrolladores
4. **Trazabilidad completa**: Desde políticas hasta código
5. **Evolución controlada**: Cambios en un nivel deben propagarse
   correctamente

Marco de Referencia
~~~~~~~~~~~~~~~~~~~

La industria de ingeniería de software ha establecido que los
requerimientos no son planos, sino que forman una jerarquía donde cada
nivel: - Tiene un propósito específico - Se deriva del nivel superior -
Informa y restringe el nivel inferior - Requiere diferentes técnicas de
elicitación y validación

Decisión
--------

**Adoptar jerarquía de requerimientos en 5 niveles como estructura
fundamental para documentación de requisitos en el proyecto IACT.**

Jerarquía de 5 Niveles
~~~~~~~~~~~~~~~~~~~~~~

::

   Nivel 1: REGLAS DE NEGOCIO
       ↓ (influencian)
   Nivel 2: REQUERIMIENTOS DE NEGOCIO
       ↓ (se convierten en)
   Nivel 3: REQUERIMIENTOS DE USUARIO
       ↓ (se implementan mediante)
   Nivel 4: REQUERIMIENTOS FUNCIONALES
       ↓ (deben cumplir)
   Nivel 5: ATRIBUTOS DE CALIDAD

Nivel 1: Reglas de Negocio
~~~~~~~~~~~~~~~~~~~~~~~~~~

**Definición**: Políticas, leyes y estándares de la industria bajo los
cuales se rige la organización para operar de manera efectiva y conforme
a las regulaciones.

**Características**: - También llamadas “lógica de negocio” - Son
externas o internas a la organización - NO negociables cuando provienen
de leyes/regulaciones - Restricción y control de funcionalidad

**Funciones principales**: 1. Restringen quién puede realizar ciertos
casos de uso 2. Dictan qué funcionalidad debe continuar el sistema

**Ubicación en proyecto**:
``docs/gobernanza/requisitos/reglas_negocio/``

**Nomenclatura**: ``RN-DOMINIO-###-descripcion.md`` o
``BR-DOMINIO-###-descripcion.md``

**Ejemplos**: - RN-BACK-001: Todos los usuarios deben estar autenticados
para acceder al sistema - RN-BACK-002: Los datos personales deben
cumplir con LFPDPPP - RN-QA-001: Todos los componentes médicos requieren
certificación sanitaria

Nivel 2: Requerimientos de Negocio
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Definición**: Objetivos organizacionales de alto nivel que el sistema
debe permitir alcanzar.

**Características**: - Orientados a resultados de negocio - Medibles
(con KPIs) - Derivan de estrategia organizacional - Justifican la
existencia del proyecto

**Relación con Nivel 1**: Las regulaciones gubernamentales pueden
conducir a objetivos de negocio necesarios para un proyecto.

**Ubicación en proyecto**:
``docs/gobernanza/requisitos/requerimientos_negocio/``

**Nomenclatura**: ``RNEG-DOMINIO-###-descripcion.md``

**Ejemplos**: - RNEG-BACK-001: El sistema de seguimiento de químicos
debe permitir el cumplimiento de todas las regulaciones federales y
estatales sobre el uso de químicos y su eliminación en un período de 5
meses - RNEG-DEVOPS-001: Reducir tiempo de deployment a menos de 10
minutos para cumplir con SLA de disponibilidad 99.9%

Nivel 3: Requerimientos de Usuario
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Definición**: Necesidades específicas de los usuarios del sistema,
descripción de lo que los usuarios deben poder hacer.

**Características**: - Perspectiva del usuario (no del sistema) - Se
expresan como casos de uso, historias de usuario, user journeys -
Describen interacciones usuario-sistema - Orientados a objetivos de
usuario

**Relación con Nivel 1**: Las políticas de privacidad dictan qué
usuarios pueden y no pueden realizar ciertas tareas con el sistema.

**Ubicación en proyecto**:
``docs/gobernanza/requisitos/requerimientos_usuario/``

**Nomenclatura casos de uso**: ``UC-DOMINIO-###-verbo-objeto.md``

**Ejemplos**: - UC-BACK-001: Iniciar Sesión - UC-BACK-010: Gestionar
Permisos - Los gerentes de laboratorio están autorizados a generar
informes de exposición química para cualquier persona

Nivel 4: Requerimientos Funcionales
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Definición**: Funciones o comportamientos específicos que el sistema
debe realizar. Pequeños bits específicos de funciones que permiten a los
usuarios ejecutar casos de uso.

**Características**: - Describen QUÉ debe hacer el sistema (NO CÓMO) -
Detallados y específicos - Verificables y testeables - Implementables
directamente por desarrolladores

**Relación con Nivel 1**: Las políticas empresariales establecen
procesos específicos que el sistema debe implementar.

**Ubicación en proyecto**:
``docs/gobernanza/requisitos/requerimientos_funcionales/``

**Nomenclatura**: ``RF-DOMINIO-###-descripcion.md``

**Ejemplos**: - RF-BACK-005: Cuando una factura es recibida por un
proveedor no registrado, el sistema enviará un email al proveedor con un
PDF editable para darse de alta - RF-BACK-006: El sistema debe validar
formato de email según RFC 5322 - RF-BACK-010: El sistema debe generar
token JWT con expiración de 15 minutos

Nivel 5: Atributos de Calidad (Requerimientos No Funcionales)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Definición**: Características del sistema que describen CÓMO debe
comportarse (rendimiento, seguridad, usabilidad, confiabilidad, etc.).

**Características**: - También llamados RNF (Requerimientos No
Funcionales) - Afectan la arquitectura del sistema - Frecuentemente
medibles (tiempo de respuesta < 2s, disponibilidad > 99.9%) - Aplican
transversalmente al sistema

**Relación con Nivel 1**: Las regulaciones de agencias gubernamentales
pueden dictar ciertos requisitos de seguridad que deben aplicarse a
través de la funcionalidad del sistema.

**Ubicación en proyecto**:
``docs/gobernanza/requisitos/atributos_calidad/``

**Nomenclatura**: ``RNF-DOMINIO-###-descripcion.md`` o
``AC-DOMINIO-###-descripcion.md``

**Ejemplos**: - RNF-BACK-005: El sistema debe mantener registros de
entrenamiento de seguridad que se deben verificar para garantizar que
los usuarios están debidamente capacitados antes de poder solicitar un
producto químico peligroso - RNF-DEVOPS-001: El sistema debe responder a
solicitudes HTTP en menos de 2 segundos bajo carga de 1000 usuarios
concurrentes - RNF-QA-001: El código debe tener cobertura de tests
superior a 80%

Tabla de Influencia entre Niveles
---------------------------------

Esta tabla muestra cómo las Reglas de Negocio influyen en cada nivel:

+-----------------------+-----------------------+-----------------------+
| Tipo de Requerimiento | Cómo Influyen las     | Ejemplo Práctico      |
|                       | Reglas de Negocio     |                       |
+=======================+=======================+=======================+
| **Requerimientos de   | Las regulaciones      | El sistema de         |
| Negocio**             | gubernamentales       | seguimiento de        |
|                       | pueden conducir a     | químicos debe         |
|                       | objetivos de negocio  | permitir el           |
|                       | necesarios para un    | cumplimiento de todas |
|                       | proyecto              | las regulaciones      |
|                       |                       | federales y estatales |
|                       |                       | sobre el uso de       |
|                       |                       | químicos y su         |
|                       |                       | eliminación en un     |
|                       |                       | período de 5 meses    |
+-----------------------+-----------------------+-----------------------+
| **Requerimientos de   | Las políticas de      | Los gerentes de       |
| Usuario**             | privacidad dictan qué | laboratorio están     |
|                       | usuarios pueden y no  | autorizados a generar |
|                       | pueden realizar       | informes de           |
|                       | ciertas tareas con el | exposición química    |
|                       | sistema               | para cualquier        |
|                       |                       | persona               |
+-----------------------+-----------------------+-----------------------+
| **Requerimientos      | Las políticas         | Política: todos los   |
| Funcionales**         | empresariales         | proveedores deben     |
|                       | establecen procesos   | estar registrados y   |
|                       | específicos que el    | aprobados antes de    |
|                       | sistema debe          | que se pague una      |
|                       | implementar           | factura.              |
|                       |                       | Funcionalidad: cuando |
|                       |                       | una factura es        |
|                       |                       | recibida por un       |
|                       |                       | proveedor no          |
|                       |                       | registrado, el        |
|                       |                       | sistema enviará un    |
|                       |                       | email al proveedor    |
|                       |                       | con un PDF editable   |
|                       |                       | para darse de alta    |
+-----------------------+-----------------------+-----------------------+
| **Atributos de        | Las regulaciones de   | El sistema debe       |
| Calidad**             | agencias              | mantener registros de |
|                       | gubernamentales       | entrenamiento de      |
|                       | pueden dictar ciertos | seguridad que se      |
|                       | requisitos de         | deben verificar para  |
|                       | seguridad que deben   | garantizar que los    |
|                       | aplicarse a través de | usuarios están        |
|                       | la funcionalidad del  | debidamente           |
|                       | sistema               | capacitados antes de  |
|                       |                       | poder solicitar un    |
|                       |                       | producto químico      |
|                       |                       | peligroso             |
+-----------------------+-----------------------+-----------------------+

Estructura de Directorios
-------------------------

::

   docs/gobernanza/requisitos/
   ├── reglas_negocio/
   │   ├── RN-BACK-001-autenticacion-obligatoria.md
   │   ├── RN-BACK-002-cumplimiento-lfpdppp.md
   │   └── ...
   ├── requerimientos_negocio/
   │   ├── RNEG-BACK-001-cumplimiento-regulatorio-quimicos.md
   │   └── ...
   ├── requerimientos_usuario/
   │   ├── casos_uso/
   │   │   ├── UC-BACK-001-iniciar-sesion.md
   │   │   ├── UC-BACK-010-gestionar-permisos.md
   │   │   └── ...
   │   ├── historias_usuario/
   │   └── user_journeys/
   ├── requerimientos_funcionales/
   │   ├── RF-BACK-005-registro-proveedor-automatico.md
   │   ├── RF-BACK-006-validacion-email.md
   │   └── ...
   ├── atributos_calidad/
   │   ├── RNF-BACK-005-registro-capacitacion-seguridad.md
   │   ├── RNF-DEVOPS-001-tiempo-respuesta.md
   │   └── ...
   └── stakeholders/
       └── STAKE-001-identificacion-stakeholders.md

Principios de Uso
-----------------

Principio 1: Derivación Descendente
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Los requerimientos de cada nivel deben derivarse del nivel superior:

::

   RN-BACK-001: Usuario debe estar autenticado
           ↓
   RNEG-BACK-001: Sistema seguro que previene accesos no autorizados
           ↓
   UC-BACK-001: Iniciar Sesión
           ↓
   RF-BACK-010: Sistema valida credenciales contra base de datos
           ↓
   RNF-BACK-005: Contraseña debe tener mínimo 8 caracteres

Principio 2: Trazabilidad Bidireccional
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Cada requisito debe poder rastrearse: - **Hacia arriba**: ¿Por qué
existe este requisito? - **Hacia abajo**: ¿Cómo se implementa/valida
este requisito?

Principio 3: Stakeholders Apropiados
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Cada nivel tiene stakeholders primarios diferentes:

+-----------------------+-----------------------+-----------------------+
| Nivel                 | Stakeholders          | Stakeholders          |
|                       | Primarios             | Secundarios           |
+=======================+=======================+=======================+
| Reglas de Negocio     | Legal, Compliance,    | Product Owner,        |
|                       | C-Suite               | Arquitectos           |
+-----------------------+-----------------------+-----------------------+
| Requerimientos de     | C-Suite, Product      | Arquitectos, Tech     |
| Negocio               | Owner                 | Leads                 |
+-----------------------+-----------------------+-----------------------+
| Requerimientos de     | Product Owner, UX,    | Desarrolladores       |
| Usuario               | Usuarios Finales      |                       |
+-----------------------+-----------------------+-----------------------+
| Requerimientos        | Desarrolladores, Tech | QA, DevOps            |
| Funcionales           | Leads                 |                       |
+-----------------------+-----------------------+-----------------------+
| Atributos de Calidad  | Arquitectos, DevOps,  | Desarrolladores       |
|                       | QA                    |                       |
+-----------------------+-----------------------+-----------------------+

Principio 4: Diferentes Técnicas de Validación
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

+-----------------------------------+-----------------------------------+
| Nivel                             | Técnicas de Validación            |
+===================================+===================================+
| Reglas de Negocio                 | Auditoría legal, revisión de      |
|                                   | compliance                        |
+-----------------------------------+-----------------------------------+
| Requerimientos de Negocio         | Validación con ejecutivos,        |
|                                   | análisis de ROI                   |
+-----------------------------------+-----------------------------------+
| Requerimientos de Usuario         | Prototipos, entrevistas,          |
|                                   | observación de usuarios           |
+-----------------------------------+-----------------------------------+
| Requerimientos Funcionales        | Code reviews, tests unitarios e   |
|                                   | integración                       |
+-----------------------------------+-----------------------------------+
| Atributos de Calidad              | Tests de rendimiento, auditorías  |
|                                   | de seguridad, análisis de código  |
+-----------------------------------+-----------------------------------+

Alternativas Consideradas
-------------------------

Alternativa 1: Jerarquía Plana (Sin Niveles)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción**: Todos los requisitos en un mismo nivel, sin
categorización.

**Pros**: - Más simple inicialmente - No requiere entrenamiento en la
jerarquía

**Contras**: - Mezcla niveles de abstracción - Imposibilita trazabilidad
- Confusión entre stakeholders - Dificulta priorización y gestión de
cambios

**Razón de rechazo**: Inadecuado para proyectos complejos con múltiples
stakeholders.

Alternativa 2: IEEE 830 (3 Niveles)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción**: Estructura tradicional con solo: 1. Requisitos
Funcionales 2. Requisitos No Funcionales 3. Restricciones

**Pros**: - Estándar conocido - Documentación abundante

**Contras**: - No captura reglas de negocio explícitamente - No
distingue entre requisitos de negocio y de usuario - Insuficiente para
trazabilidad completa - Orientado solo a desarrollo, no a estrategia

**Razón de rechazo**: Insuficiente para capturar relación entre
estrategia organizacional y funcionalidad técnica.

Alternativa 3: User Stories únicamente (Agile puro)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción**: Solo historias de usuario sin estructura jerárquica
formal.

**Pros**: - Muy ágil y flexible - Fácil de entender - Cercanía con
usuario final

**Contras**: - No captura reglas de negocio externas - Dificulta
cumplimiento regulatorio - No adecuado para requisitos de arquitectura -
Falta de contexto estratégico

**Razón de rechazo**: Insuficiente para proyectos con obligaciones
regulatorias y múltiples dominios técnicos.

Alternativa 4: Modelo de 7 Niveles (Extensión del estándar)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción**: Agregar niveles adicionales: 1. Visión estratégica 2.
Reglas de negocio 3. Objetivos de negocio 4. Requisitos de usuario 5.
Requisitos funcionales 6. Requisitos no funcionales 7. Restricciones
técnicas

**Pros**: - Máxima granularidad - Separación muy clara

**Contras**: - Demasiado complejo para tamaño actual del proyecto -
Overhead de documentación excesivo - Confusión entre niveles similares

**Razón de rechazo**: Overkill para proyectos de tamaño mediano. Modelo
de 5 niveles proporciona balance adecuado.

Consecuencias
-------------

Positivas
~~~~~~~~~

1. **Trazabilidad completa**

   -  Cada feature se justifica desde reglas de negocio hasta atributos
      de calidad
   -  Fácil responder “¿por qué existe esta funcionalidad?”
   -  Validación de que objetivos de negocio se cumplen

2. **Comunicación mejorada**

   -  Cada stakeholder trabaja en su nivel apropiado
   -  Ejecutivos ven requisitos de negocio
   -  Desarrolladores ven requisitos funcionales
   -  Traducción clara entre niveles

3. **Gestión de cambios efectiva**

   -  Cambio en regla de negocio se propaga correctamente
   -  Impacto visible en todos los niveles
   -  Decisiones informadas sobre aceptar/rechazar cambios

4. **Cumplimiento regulatorio**

   -  Reglas de negocio externas explícitas
   -  Auditorías pueden verificar cumplimiento
   -  Evidencia de conformidad con regulaciones

5. **Priorización basada en valor**

   -  Requisitos vinculados a objetivos de negocio
   -  Fácil identificar “nice to have” vs “must have”
   -  ROI más claro

6. **Arquitectura coherente**

   -  Atributos de calidad informan decisiones de arquitectura
   -  No son “extras opcionales”
   -  Evita deuda técnica por omisión de RNF

Negativas
~~~~~~~~~

1. **Curva de aprendizaje**

   -  Equipo debe entender la jerarquía
   -  Requiere disciplina para mantenerla
   -  Tentación de atajos (saltar niveles)

   **Mitigación**:

   -  Capacitación inicial en jerarquía
   -  Templates y ejemplos claros
   -  Revisiones de calidad de documentación
   -  ADRs complementarios (006-009)

2. **Overhead de documentación**

   -  Más documentos que enfoque plano
   -  Mantenimiento de relaciones entre niveles
   -  Tiempo inicial mayor

   **Mitigación**:

   -  Herramientas de trazabilidad
   -  Templates reutilizables
   -  Generación automática de matrices de trazabilidad
   -  Revisar solo lo necesario (no documentar por documentar)

3. **Riesgo de inconsistencias**

   -  Cambio en un nivel puede no reflejarse en otros
   -  Documentos pueden desincronizarse

   **Mitigación**:

   -  Referencias explícitas entre documentos (IDs)
   -  Code reviews de documentación
   -  Scripts de validación de trazabilidad
   -  Principio: cambio en nivel superior requiere review de niveles
      inferiores

4. **Complejidad en proyectos pequeños**

   -  Para features muy simples puede ser excesivo
   -  No todo requisito necesita 5 niveles

   **Mitigación**:

   -  Permitir niveles implícitos cuando sean obvios
   -  No forzar documentación de niveles triviales
   -  Usar juicio: “¿agrega valor documentar esto en 5 niveles?”

Implementación
--------------

Fase 1: Reorganización de Estructura Actual (Semana 1)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Mover casos_de_uso a ubicación correcta en jerarquía
   git mv docs/gobernanza/casos_de_uso docs/gobernanza/requisitos/requerimientos_usuario/casos_uso

   # Verificar estructura completa
   tree docs/gobernanza/requisitos/

Fase 2: Creación de Templates (Semana 1)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Crear templates para cada nivel: - ``templates/RN-template.md`` -
``templates/RNEG-template.md`` - ``templates/UC-template.md`` -
``templates/RF-template.md`` - ``templates/RNF-template.md``

Fase 3: Capacitación del Equipo (Semana 2)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Sesión de 2 horas sobre jerarquía
2. Ejercicio práctico: derivar requisitos de un caso real
3. Q&A y resolución de dudas

Fase 4: Documentación de Requisitos Existentes (Semanas 3-4)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Identificar reglas de negocio actuales
2. Documentar requisitos de negocio
3. Clasificar casos de uso existentes
4. Derivar requisitos funcionales de casos de uso
5. Documentar atributos de calidad

Fase 5: Matriz de Trazabilidad (Semana 5)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Crear matriz que muestre relaciones:

::

   RN-BACK-001 → RNEG-BACK-001 → UC-BACK-001 → RF-BACK-010, RF-BACK-011 → RNF-BACK-005

Validación
----------

Criterios de Éxito
~~~~~~~~~~~~~~~~~~

-  100% de nuevos requisitos documentados siguiendo jerarquía
-  Matriz de trazabilidad completa para features principales
-  Equipo capacitado y usando estructura correctamente
-  Stakeholders reportan mejor comunicación
-  Auditorías de compliance son más eficientes

Métricas
~~~~~~~~

-  Número de requisitos por nivel
-  Cobertura de trazabilidad (% de requisitos con links a nivel
   superior/inferior)
-  Tiempo promedio para derivar requisito de nivel inferior desde
   superior
-  Satisfacción del equipo con la estructura (survey trimestral)
-  Reducción de defectos por “requisito no entendido”

Referencias
-----------

-  `IEEE 29148-2018: Systems and software engineering — Life cycle
   processes — Requirements
   engineering <https://standards.ieee.org/standard/29148-2018.html>`__
-  `IIBA BABOK v3: Business Analysis Body of
   Knowledge <https://www.iiba.org/business-analysis-certifications/babok/>`__
-  `ADR-GOB-006: Clasificación y Documentación de Reglas de
   Negocio <ADR-GOB-006-clasificacion-reglas-negocio.md>`__
-  `ADR-GOB-007: Especificación de Casos de
   Uso <ADR-GOB-007-especificacion-casos-uso.md>`__
-  `ADR-GOB-009: Trazabilidad entre Artefactos de
   Requisitos <ADR-GOB-009-trazabilidad-artefactos-requisitos.md>`__

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
