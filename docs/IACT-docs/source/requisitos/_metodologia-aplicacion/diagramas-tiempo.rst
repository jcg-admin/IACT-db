.. meta::
 :artefacto: METODOLOGIA_DIAGRAMAS_TIEMPO
 :tipo: Guia-Metodologica
 :dominio: requisitos
 :subdominio: _metodologia-aplicacion
 :estado: Borrador
 :version: 0.1.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==========================================================
Diagramas de tiempo (*timing*) — ejemplo preliminar IACT
==========================================================

.. warning::

   **Documento preliminar.** Esta página presenta un único
   ejemplo introductorio. El desarrollo serio de diagramas
   de tiempo aplicados a IACT (catálogo, criterios de uso,
   integración con SLA y ventana ETL) está abierto en el
   work package :ref:`wp-diagramas-tiempo`. No usar este
   documento como referencia normativa hasta que el WP
   cierre.

Propósito
=========

Un **diagrama de tiempo** muestra el comportamiento de uno
o varios objetos a lo largo de **períodos específicos**:
qué estado ocupan en cada instante, cuándo cambian, y qué
restricciones temporales aplican (duraciones máximas,
ventanas, deadlines).

Diferencia con diagramas hermanos:

- **Estados** (H8) → catálogo de estados y transiciones
  posibles.
- **Secuencias** (H9) → orden relativo de mensajes entre
  objetos.
- **Tiempo (*timing*)** → estado de los objetos en función
  del **tiempo absoluto o relativo**, con énfasis en
  duraciones y restricciones cronológicas.

Cuándo justifica un timing diagram en IACT
==========================================

Solo si la corrección del UC depende de **duraciones**, no
solo de orden:

- **CNST_017 SLA ≤ 10 s** — respuesta del backend a la
  consulta del supervisor.
- **CNST_006/008 ventana ETL 6 h** — estados sucesivos del
  ``etl_runner`` dentro de la ventana.
- **CNST_002 sesión única + caducidad** — duración de la
  sesión activa frente a inactividad.
- **CNST_011 throttling 5 / 5 min** — ventana deslizante
  de intentos.

Si el UC se entiende sin tiempo absoluto, **usar
secuencias o estados**, no timing diagram.

Ejemplo introductorio — UC_RPT_01 vs SLA CNST_017
=================================================

Un supervisor consulta un dashboard. El backend debe
responder en ≤ 10 s (CNST_017). Tres objetos relevantes:

- ``Navegador`` del supervisor (estados: ocioso, esperando,
  renderizando).
- ``Backend`` Django (estados: ocioso, ejecutando consulta,
  serializando respuesta).
- ``BD analytics`` (estados: ocioso, sirviendo query).

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   robust "Navegador" as N
   robust "Backend"  as B
   robust "BD analytics" as DB

   @0
   N is ocioso
   B is ocioso
   DB is ocioso

   @1
   N is esperando
   B is consulta
   DB is query

   @5
   DB is ocioso
   B is serializa

   @7
   B is ocioso
   N is renderizando

   @9
   N is ocioso

   highlight 0 to 10 #LightYellow : SLA CNST_017

   @enduml

Lectura: el ciclo completo (de la petición a renderizar)
ocurre entre el instante 0 y el instante 9 — dentro del
área coloreada, que corresponde al SLA CNST_017 (≤ 10 s).
Si cualquier estado se prolongara más allá del instante
10, el UC violaría la restricción.

Limitaciones de este ejemplo
============================

- Los instantes (0, 1, 5, 7, 9) son **ilustrativos**, no
  medidos. No deben tomarse como baseline.
- El catálogo de estados de cada objeto está simplificado;
  la versión completa pertenece al WP.
- No se modelan errores (timeout, fallo de red); el
  diagrama solo cubre el camino feliz.
- No se establece convención IACT canónica para colores,
  resolución temporal, ni interacción con
  :doc:`diagramas-secuencias` y :doc:`diagramas-estados`.
  Eso pertenece al WP.

.. _wp-diagramas-tiempo:

Trabajo pendiente
=================

El desarrollo definitivo está en HOLD bajo el WP
``2026-04-30-XX-XX-XX-diagramas-tiempo`` (ver
``.thyrox/context/work/``). Cuando se retome cubrirá:

- Catálogo completo de UCs IACT donde un timing diagram
  aporta sobre secuencias/estados.
- Convenciones PlantUML del proyecto para timing
  (sintaxis ``robust``/``concise``, granularidad,
  resaltado de ventanas SLA).
- Integración explícita con CNST_017, CNST_006/008,
  CNST_002, CNST_011.
- Mediciones reales que reemplacen los instantes
  ilustrativos del ejemplo de arriba.
- Reglas de cuándo NO usar timing diagram (evitar
  diagramas decorativos sin restricción temporal real).

Trazabilidad (preliminar)
=========================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill principal**
   - ``rm-specification``
 * - **Estado**
   - Borrador (versión 0.1.0). No usar como referencia
     normativa.
 * - **Diagramas hermanos**
   - :doc:`diagramas-estados`,
     :doc:`diagramas-secuencias`,
     :doc:`diagramas-colaboraciones`,
     :doc:`diagramas-actividades`
 * - **Restricciones potencialmente relevantes**
   - CNST_002, CNST_006, CNST_008, CNST_011, CNST_017
 * - **Política de diagramación**
   - :doc:`/base-cognitiva/plantuml-guide/guidelines`
