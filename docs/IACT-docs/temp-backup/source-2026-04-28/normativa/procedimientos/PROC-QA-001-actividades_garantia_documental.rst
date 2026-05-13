Actividades de control documental
=================================

Plan operativo para asegurar que las reglas de documentación, requisitos
y casos de uso se apliquen de forma consistente en todo el repositorio.

Página padre
------------

-  ```readme.md`` <readme.md>`__

Objetivos
---------

-  Garantizar que cada modificación en ``docs/`` pase por revisiones
   estructuradas.
-  Confirmar el uso de plantillas oficiales para requisitos, casos de
   uso y matrices.
-  Mantener trazabilidad completa entre reglas de negocio, requisitos,
   casos de uso y pruebas.

Actividades recurrentes
-----------------------

1. Revisión de calidad editorial
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  Ejecutar el checklist corporativo descrito en
   ```../documentacion_corporativa.md`` <../documentacion_corporativa.md>`__
   antes de aprobar un cambio.
-  Validar que los documentos incluyan secciones de limitaciones y
   distinción explícita entre QUÉ y CÓMO.
-  Registrar hallazgos en la bitácora de QA si se detectan
   incumplimientos.

2. Verificación de estructura y plantillas
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  Confirmar que las nuevas entradas utilicen plantillas de
   ```../plantillas/`` <../plantillas/>`__ según el tipo de artefacto.
-  Revisar que cada caso de uso documente precondiciones, flujos y
   excepciones con la nomenclatura UC-XXX.
-  Escalar al equipo de producto cuando falten campos obligatorios en
   requisitos o casos de uso.

3. Auditoría de trazabilidad
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  Actualizar
   ```../requisitos/trazabilidad.md`` <../requisitos/trazabilidad.md>`__
   con cualquier relación nueva entre reglas, requisitos, casos de uso y
   pruebas.
-  Verificar que la cadena RN → N → RB → RS → UC → RF → TEST esté
   completa para cada iniciativa en curso.
-  Programar una revisión cruzada semanal con producto y arquitectura
   para cerrar brechas detectadas.

Actividades por entrega
-----------------------

+-----------------+-----------------+-----------------+-----------------+
| Momento         | Responsables    | Acción          | Evidencia       |
+=================+=================+=================+=================+
| Inicio de       | Producto + QA   | Revisar backlog | Notas en ritual |
| iteración       |                 | y asegurar que  | de              |
|                 |                 | cada requisito  | planificación.  |
|                 |                 | tenga plantilla |                 |
|                 |                 | base            |                 |
|                 |                 | completada.     |                 |
+-----------------+-----------------+-----------------+-----------------+
| Durante         | QA              | Corroborar que  | Comentarios en  |
| desarrollo      |                 | los casos de    | pull requests.  |
|                 |                 | uso reflejen    |                 |
|                 |                 | reglas de       |                 |
|                 |                 | negocio activas |                 |
|                 |                 | y generen       |                 |
|                 |                 | requisitos      |                 |
|                 |                 | funcionales     |                 |
|                 |                 | claros.         |                 |
+-----------------+-----------------+-----------------+-----------------+
| Pre-cierre      | QA +            | Ejecutar        | Actualización   |
|                 | Arquitectura    | auditoría de    | firmada en      |
|                 |                 | trazabilidad y  | ``tra           |
|                 |                 | documentar      | zabilidad.md``. |
|                 |                 | ajustes.        |                 |
+-----------------+-----------------+-----------------+-----------------+
| Post-cierre     | QA              | Publicar        | Entrada en      |
|                 |                 | resumen de      | ``q             |
|                 |                 | hallazgos y     | a/registros/``. |
|                 |                 | acciones        |                 |
|                 |                 | correctivas.    |                 |
+-----------------+-----------------+-----------------+-----------------+

Métricas de seguimiento
-----------------------

+-----------------------+-----------------------+-----------------------+
| Métrica               | Objetivo              | Fuente                |
+=======================+=======================+=======================+
| Revisiones            | 100 % de los cambios  | Historial de PR y     |
| documentales          | en ``docs/``          | checklist QA.         |
| cumplidas             |                       |                       |
+-----------------------+-----------------------+-----------------------+
| Plantillas utilizadas | ≥ 95 %                | Auditoría mensual del |
| sin modificaciones    |                       | repositorio.          |
| estructurales         |                       |                       |
+-----------------------+-----------------------+-----------------------+
| Cadena de             | 100 % de iniciativas  | ```../r               |
| trazabilidad completa | activas               | equisitos/trazabilida |
|                       |                       | d.md`` <../requisitos |
|                       |                       | /trazabilidad.md>`__. |
+-----------------------+-----------------------+-----------------------+

Procedimiento de escalamiento
-----------------------------

1. Registrar el incumplimiento en la bitácora de QA.
2. Notificar al responsable del documento mediante comentario en PR.
3. Programar reunión de ajuste si el bloqueo persiste por más de dos
   días hábiles.
4. Actualizar la matriz de trazabilidad con el resultado final.

Histórico de revisiones
-----------------------

-  **2025-02-19:** Documento inicial que formaliza actividades de
   control documental coordinadas por QA.
