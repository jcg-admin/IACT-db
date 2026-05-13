.. meta::
 :artefacto: BR_011
 :tipo: Regla de Negocio
 :dominio: requisitos
 :subdominio: reglas_negocio
 :estado: Aprobado
 :version: 2.0.0
 :fecha_creacion: 2026-01-07
 :ultimo_cambio: 2026-04-30
 :autor: Equipo IACT
 :clasificacion: Interno

.. _br-011:

==============================
BR_011: Límites de Exportación
==============================


Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - BR_011
 * - **Nombre**
   - Límites de Exportación (delegado a CNST-019/020)
 * - **Tipo**
   - Restricción
 * - **Categoría**
   - Operacional / Recursos del sistema
 * - **Criticidad**
   - Alta
 * - **Estado**
   - Vigente

----

1. Definición Formal
--------------------

1.1 Enunciado de la Regla
^^^^^^^^^^^^^^^^^^^^^^^^^

.. note:: **Regla de Negocio BR_011 (v2.0.0)**

 Las exportaciones de datos del sistema IACT DEBEN respetar las
 restricciones declaradas en:

 - **CNST-019**: procesamiento asíncrono sobre umbral declarado.
 - **CNST-020**: throttling anti-abuse por recursos del sistema
   (concurrent jobs, quota diaria total, tamaño máximo de
   artefacto, aislamiento de pool).

 Esta regla **NO declara cifras concretas**. Las cifras
 operacionales (umbral async, max concurrent, max daily, tamaño
 máximo del archivo, timeouts) se definen en el ADR de
 implementación técnica, ajustables según observación empírica
 de uso real.

1.2 Cambio de modelo v1.0.0 → v2.0.0
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La versión 1.0.0 declaraba "100,000 registros máximo por
exportación" como cifra arbitraria genérica, contradiciendo las
cifras por formato de CNST-020 v1.0.0/v2.0.0 (CSV 100K, Excel 50K,
PDF 10K).

La auditoría WP rbac-modelo-conceptual-cleanup determinó que
**ambos modelos eran defectuosos**:

- Cifra genérica BR-011: arbitraria, sin justificación empírica.
- Tabla por formato CNST-020: arbitraria, no refleja la
  restricción real (recursos del sistema).

El modelo correcto es:

- Un reporte de 200,000 registros DEBE poder exportarse en
  cualquier formato si los recursos del sistema lo soportan.
- La protección real está en **recursos** (memoria, CPU, ancho
  de banda, archivos inmanejables del lado cliente), no en el
  formato del archivo.
- CNST-019/020 v3.0.0 redefinen las restricciones en términos
  de recursos abstractos.
- BR-011 v2.0.0 delega a CNST-019/020 sin replicar cifras.

1.3 Justificación
^^^^^^^^^^^^^^^^^

Los límites de exportación protegen:

- **Aislamiento de recursos**: workers de export no compiten con
  tráfico UI/API.
- **Anti-abuse**: limitar concurrent + daily previene scraping y
  uso desproporcionado.
- **Experiencia de usuario**: artefactos demasiado grandes son
  inmanejables del lado cliente.
- **Estabilidad**: protege la disponibilidad para todos los
  usuarios.

----

2. Clasificación
----------------

2.1 Tipo de Regla
^^^^^^^^^^^^^^^^^

[X] **Restricción**: limita las exportaciones según recursos
disponibles, no por formato.

2.2 Naturaleza
^^^^^^^^^^^^^^

- **Estática/Dinámica**: Dinámica — las cifras concretas se
  ajustan en settings, no son fijas en código.
- **Automatizable**: Sí — validación previa a encolar el job.
- **Alcance**: Todos los módulos con funcionalidad de
  exportación (MOD_Reports, MOD_Logs, MOD_Audit).

----

3. Origen y Autoridad
---------------------

3.1 Fuente Primaria
^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **CNSTs autoritativas**
   - CNST-019, CNST-020 (v3.0.0+)
 * - **WP origen**
   - rbac-modelo-conceptual-cleanup (decision D-11)
 * - **Tipo Fuente**
   - Restricción técnica derivada de constraints normativas

----

4. Aplicación en Sistema
------------------------

4.1 Donde Aplica
^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Aplicación
 * - uc-rpt-04
   - Exportar Reporte (consolidado por formato — Larman) — valida
     CNST-019 (async) + CNST-020 (recursos)
 * - uc-aud-03
   - Exportar Auditoría — valida mismo throttling
 * - uc-log-04
   - Exportar Logs — valida mismo throttling

4.2 Actores Afectados
^^^^^^^^^^^^^^^^^^^^^

- **Roles**: cualquiera con función ``RPT-004/005/006`` (export por
  formato), ``AUD-003`` (export audit) o ``LOG-002`` (export logs).
- **Impacto**: si exceden concurrent o daily quota, el job es
  rechazado con mensaje informativo y código 429.

4.3 Excepciones
^^^^^^^^^^^^^^^

- Roles administrativos pueden tener cifras configurables
  superiores en settings.
- Permisos excepcionales temporales (CNST-031) pueden elevar
  quotas por ventana acotada.
- Cualquier excepción permanente requiere ADR.

----

5. Trazabilidad
---------------

5.1 Restricciones Origen (CNST)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 20 80
 :header-rows: 1

 * - CNST
   - Relación
 * - CNST-019 (v3.0.0)
   - Procesamiento asíncrono sobre umbral
 * - CNST-020 (v3.0.0)
   - Throttling por recursos (concurrent, daily, tamaño,
     aislamiento)

5.2 Casos de Uso Afectados (UC)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 20 80
 :header-rows: 1

 * - UC
   - Donde Aplica
 * - uc-rpt-04
   - Exportar Reporte (consolidado, multi-formato)
 * - uc-aud-03
   - Exportar Auditoría
 * - uc-log-04
   - Exportar Logs

----

6. Verificación
---------------

6.1 Criterios de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La regla se considera cumplida cuando:

1. Toda exportación pasa por validación de CNST-019 (async sobre
   umbral) y CNST-020 (throttling).
2. Cifras concretas vienen de settings, no hardcodeadas.
3. Excesos de concurrent/daily devuelven 429 con mensaje claro.
4. Métricas de uso publicadas (tasa rechazo, tiempo medio).

6.2 Método de Verificación
^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Tipo**: Automatizado
- **Frecuencia**: Cada exportación
- **Responsable**: Servicio de Exportación + middleware throttling

----

7. Implementación Técnica
-------------------------

La implementación concreta vive en CNST-019 § 5.1 y CNST-020 § 5.1
(snippets de referencia). BR-011 NO declara código de validación
propio: delega a las CNSTs autoritativas.

----

8. Historial de Cambios
-----------------------

.. list-table::
 :widths: 15 15 20 50
 :header-rows: 1

 * - Versión
   - Fecha
   - Autor
   - Descripción del Cambio
 * - 1.0.0
   - 2026-01-07
   - Equipo IACT
   - Versión inicial con cifra genérica "100,000 registros máximo"
 * - 2.0.0
   - 2026-04-30
   - NestorMonroy
   - **Reescritura:** eliminar cifra arbitraria, delegar a
     CNST-019/020 v3.0.0 (recursos del sistema en lugar de límites
     por formato), alinear UCs a uc-rpt-04 consolidado (Larman).
     Decision D-11 (WP rbac-modelo-conceptual-cleanup).

----

Referencias
-----------

- CNST-019: Exportaciones Asíncronas sobre umbral
- CNST-020: Throttling de Exportaciones (Recursos del sistema)
- uc-rpt-04: Exportar Reporte (consolidado, multi-formato)
- uc-aud-03: Exportar Auditoría
- uc-log-04: Exportar Logs
