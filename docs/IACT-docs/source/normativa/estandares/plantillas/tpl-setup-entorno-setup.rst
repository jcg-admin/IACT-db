.. meta::
 :artefacto: TPL_SETUP_ENTORNO
 :tipo: Plantilla
 :dominio: normativa
 :subdominio: estandares/plantillas
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

================================================
TPL_SETUP_ENTORNO: Plantilla de Setup de Entorno
================================================

.. note::

 Plantilla para documentar configuración de entornos
 (desarrollo / staging / producción). Aplica skill
 ``bpa-implement``.

1. Identificación
=================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Ambiente**
   - desarrollo / staging / producción
 * - **Stack**
   - Vagrant + Apache + mod_wsgi (per ADR-DEVOPS-001)
 * - **Owner**
   - DevOps Engineer

2. Prerequisitos
================

Software, accesos, credenciales necesarios antes de comenzar.

3. Pasos de setup
=================

.. list-table::
 :widths: 8 60 32
 :header-rows: 1

 * - #
   - Acción
   - Verificación
 * - {ejemplo}
   - {ejemplo}
   - {ejemplo}

4. Configuración post-setup
===========================

- Variables de entorno.
- Archivos de configuración.
- Servicios a iniciar (systemd).

5. Verificación
===============

Smoke tests para validar que el ambiente funciona correctamente:

- Health endpoint responde.
- BD accesible.
- Buzón interno funcional.

6. Troubleshooting
==================

Problemas comunes y soluciones.

7. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill guía**
   - ``bpa-implement``
 * - **Procedimiento aplicable**
   - :doc:`/normativa/procedimientos/proc-ops-003-instalacion-entorno`
 * - **ADRs aplicables**
   - :doc:`/devops/adr-devops-001-vagrant-mod-wsgi-importante-produc`
