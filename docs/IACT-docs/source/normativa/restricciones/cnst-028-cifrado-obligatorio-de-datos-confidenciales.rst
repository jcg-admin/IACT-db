.. meta::
 :artefacto: CNST_028
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Critico

.. _cnst-028:

=====================================================
CNST-028: Cifrado Obligatorio de Datos Confidenciales
=====================================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_028
 * - **Categoria**
   - Datos
 * - **Tipo (TXM_01)**
   - Regulatoria
 * - **Criticidad**
   - Critico
 * - **Negociable**
   - No
 * - **Estado**
   - Vigente

1. Definicion
-------------

1.1 Enunciado
^^^^^^^^^^^^^


Los datos clasificados como ``Confidential`` y ``Restricted`` DEBEN
cifrarse en reposo y en transito en todas las exportaciones que los
incluyan.

1.2 Justificacion
^^^^^^^^^^^^^^^^^


Reduce el impacto de un acceso no autorizado a almacenamiento o
backup. Es requisito tipico de regulaciones aplicables al sector del
cliente.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Compliance (proteccion de datos sensibles)
- **Documento:** Politica de seguridad IACT — RESTRICCIONES_COMPLETAS:182
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^


- En reposo: cifrado a nivel columna con ``pgcrypto`` o equivalente
  para campos ``Restricted``; cifrado a nivel volumen para BD.
- En transito interno: TLS 1.2+ entre componentes.
- En exportaciones: ZIP con AES-256 + password fuera de banda.
- Las llaves se rotan minimo cada 12 meses.

2.2 Parametros
^^^^^^^^^^^^^^

Ver subseccion 2.1.

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- pgcrypto (Postgres)
- TLS 1.2+
- AES-256 ZIP para exports
- HSTS = 31536000s (1 ano)

3. Impacto en Sistema
---------------------

3.1 Modulos Afectados
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Modulo
   - Impacto
 * - MOD_Common
   - Define utilidades de cifrado
 * - MOD_Reports
   - Cifra exports

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - UC_022..024
   - Exports cifrados
 * - (transversal)
   - Datos en reposo cifrados

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Almacenar Confidential/Restricted en claro
- Exportar Confidential/Restricted sin cifrado
- Pasar datos en transito sin TLS

4. Business Rules Derivadas
---------------------------

Sin BRs especificas mapeadas a esta CNST en la base cognitiva actual.
El catalogo BR_NNN del dominio IACT esta pendiente de elaborar en
el WP de requisitos (deuda diferida).

5. Implementacion
-----------------

5.1 Codigo de Referencia
^^^^^^^^^^^^^^^^^^^^^^^^


.. code-block:: bash

 psql -c "SELECT * FROM pg_extension WHERE extname='pgcrypto';"

5.2 Validacion de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ver seccion 5.1 (codigo de referencia es la validacion ejecutable).


6. Excepciones
--------------

6.1 Excepciones Permitidas
^^^^^^^^^^^^^^^^^^^^^^^^^^

- Datos Internal/Public no requieren cifrado en reposo

6.2 Proceso de Excepcion
^^^^^^^^^^^^^^^^^^^^^^^^

Definido por nivel de clasificacion (CNST_027), sin excepciones adicionales.

El protocolo formal de waiver de CNSTs esta pendiente de elaborar en
el WP de gobernanza (`PROC_Excepciones_CNST` — ver
(referencia interna) § W-4).

7. Verificacion
---------------

7.1 Criterios de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El cumplimiento se verifica via los snippets de la seccion 5.

7.2 Metodo de Verificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Tipo:** Mixto
- **Frecuencia:** Por deployment + auditoria trimestral
- **Herramienta:** psql verifica pgcrypto + curl verifica HSTS header + auditoria de keys

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-027-clasificacion-obligatoria-de-datos-en-4-niveles`, :doc:`cnst-020-throttling-de-exportaciones-por-formato`
 * - **BR derivadas**
   - Pendiente WP requisitos
 * - **UCs afectados**
   - UC_022..024, (transversal)
 * - **MODs afectados**
   - MOD_Common, MOD_Reports
 * - **ADRs relacionados**
   - Pendiente WP arquitectura tecnica

9. Historial de Cambios
-----------------------

.. list-table::
 :widths: 12 15 25 48
 :header-rows: 1

 * - Version
   - Fecha
   - Autor
   - Cambios
 * - 1.0.0
   - 2025-12-17
   - NestorMonroy
   - Version inicial (consolidada del backup canonico)
 * - 2.0.0
   - 2026-04-28
   - NestorMonroy
   - Descomposicion SRP (un concern por archivo) + enriquecimiento estructura completa TPL_CNST (9 secciones)

