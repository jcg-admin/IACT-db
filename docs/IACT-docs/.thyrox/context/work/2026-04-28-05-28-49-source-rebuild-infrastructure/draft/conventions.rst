.. meta::
   :artefacto: INFRASTRUCTURE_CONVENTIONS
   :tipo: Convenciones del tier
   :dominio: tech
   :estado: Esqueleto
   :version: 1.0.0
   :fecha_creacion: 2026-04-28
   :autor: Equipo IACT

============================================
Infraestructura — Convenciones
============================================

Naming
======

Hosts
-----

- Formato: ``{rol}-{entorno}-{n}.iact.local`` (ej:
  ``app-prod-01``, ``db-staging-01``).
- Solo lowercase + hyphens.

Paths
-----

- App code: ``/srv/iact/{app}/``
- Logs: ``/var/log/iact/{app}/``
- Configs Apache: ``/etc/apache2/sites-available/``
- Backups: ``/srv/backups/`` (retention según política).

vhosts Apache
-------------

- Un archivo por sitio: ``iact-{entorno}.conf``.
- ``ServerName`` + ``ServerAlias`` explícitos.
- Logs separados por vhost.
- TLS obligatorio en producción y staging.

Seguridad baseline
==================

Ubuntu
------

- ``ufw`` enable con reglas mínimas (ssh, http, https).
- SSH: ``PermitRootLogin no``, ``PasswordAuthentication no``.
- Updates automáticos para parches de seguridad
  (``unattended-upgrades``).
- ``fail2ban`` activado para SSH y posibles otros.

Apache
------

- ``ServerTokens Prod`` (no leak de versión).
- ``ServerSignature Off``.
- Headers de seguridad: ``Strict-Transport-Security``,
  ``X-Frame-Options DENY``, ``X-Content-Type-Options nosniff``,
  ``Referrer-Policy``.
- TLS: solo TLS 1.2+, ciphers modernos.

Logs
====

- Formato: combined (Apache estándar).
- Retención según política de auditoría
  (:doc:`/normativa/restricciones/index`).
- Logs de auditoría en destino inmutable (append-only).

Backups
=======

- Frecuencia y retención según RPO/RTO definidos en NFRs.
- Verificación periódica de restore.
- Detalles en :doc:`/operations/overview`.

Despliegue
==========

- Pipeline de deploy: ver :doc:`/operations/overview`.
- Convención de versionado de release: SemVer.
- Rollback documentado para cada release.

Monitoring
==========

- Métricas mínimas: CPU, memoria, disco, red, latencia HTTP,
  errores 5xx.
- Alertas con thresholds claros y on-call rotation.
- Detalle en :doc:`/operations/overview`.
