.. meta::
 :artefacto: PROC_QA_001
 :tipo: Procedimiento
 :dominio: normativa
 :subdominio: procedimientos
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-01-07
 :ultimo_cambio: 2026-04-28
 :autor: Equipo IACT
 :clasificacion: Interno

Actividades de control documental
=================================

Plan operativo para asegurar que las reglas de documentación, requisitos
y casos de uso se apliquen de forma consistente en todo el repositorio.

Página padre
------------

- ```readme.rst`` <readme>`__

Objetivos
---------

- Garantizar que cada modificación en ``docs/`` pase por revisiones
  estructuradas.
- Confirmar el uso de plantillas oficiales para requisitos, casos de
  uso y matrices.
- Mantener trazabilidad completa entre reglas de negocio, requisitos,
  casos de uso y pruebas.

Actividades recurrentes
-----------------------

1. Revisión de calidad editorial
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Ejecutar el checklist corporativo descrito en
  ```../documentacion_corporativa.rst`` <../documentacion_corporativa.rst>`__
  antes de aprobar un cambio.
- Validar que los documentos incluyan secciones de limitaciones y
  distinción explícita entre QUÉ y CÓMO.
- Registrar hallazgos en la bitácora de QA si se detectan
  incumplimientos.

2. Verificación de estructura y plantillas
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Confirmar que las nuevas entradas utilicen plantillas de
  ```../plantillas/`` <../plantillas/>`__ según el tipo de artefacto.
- Revisar que cada caso de uso documente precondiciones, flujos y
  excepciones con la nomenclatura UC-XXX.
- Escalar al equipo de producto cuando falten campos obligatorios en
  requisitos o casos de uso.

3. Auditoría de trazabilidad
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Actualizar
  ```../requisitos/trazabilidad.rst`` <../requisitos/trazabilidad.rst>`__
  con cualquier relación nueva entre reglas, requisitos, casos de uso y
  pruebas.
- Verificar que la cadena RN → N → RB → RS → UC → RF → TEST esté
  completa para cada iniciativa en curso.
- Programar una revisión cruzada semanal con producto y arquitectura
  para cerrar brechas detectadas.

Actividades por entrega
-----------------------

.. list-table::
   :header-rows: 1

   * - Momento
     - Responsables
     - Acción
     - Evidencia
   * - Inicio de iteración
     - Producto + QA
     - Revisar backlog y asegurar que cada requisito tenga plantilla base completada.
     - Notas en ritual de planificación.
   * - Durante desarrollo
     - QA
     - Corroborar que los casos de uso reflejen reglas de negocio activas y generen requisitos funcionales claros.
     - Comentarios en pull requests.
   * - Pre-cierre
     - QA + Arquitectura
     - Ejecutar auditoría de trazabilidad y documentar ajustes.
     - Actualización firmada en ``tra zabilidad.rst``.
   * - Post-cierre
     - QA
     - Publicar resumen de hallazgos y acciones correctivas.
     - Entrada en ``q a/registros/``.

Métricas de seguimiento
-----------------------

.. list-table::
   :header-rows: 1

   * - Métrica
     - Objetivo
     - Fuente
   * - Revisiones documentales cumplidas
     - 100 % de los cambios en ``docs/``
     - Historial de PR y checklist QA.
   * - Plantillas utilizadas sin modificaciones estructurales
     - ≥ 95 %
     - Auditoría mensual del repositorio.
   * - Cadena de trazabilidad completa
     - 100 % de iniciativas activas
     - ```../r equisitos/trazabilida d.rst`` <../requisitos /trazabilidad.rst>`__.

Procedimiento de escalamiento
-----------------------------

1. Registrar el incumplimiento en la bitácora de QA.
2. Notificar al responsable del documento mediante comentario en PR.
3. Programar reunión de ajuste si el bloqueo persiste por más de dos
   días hábiles.
4. Actualizar la matriz de trazabilidad con el resultado final.

Histórico de revisiones
-----------------------

- **2025-02-19:** Documento inicial que formaliza actividades de
  control documental coordinadas por QA.
