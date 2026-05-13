.. meta::
   :artefacto: INFRASTRUCTURE_OVERVIEW
   :tipo: Visión general del tier
   :dominio: tech
   :estado: Esqueleto
   :version: 1.0.0
   :fecha_creacion: 2026-04-28
   :autor: Equipo IACT

============================================
Infraestructura — Visión general
============================================

Alcance
=======

El tier de infraestructura del producto IACT corre sobre **Ubuntu**
con **Apache** como reverse proxy y servidor WSGI (``mod_wsgi``)
para el backend Django REST Framework
(:doc:`/backend/overview`).

Topología
=========

::

    [Client]
       │
       ▼
    [Apache]  ← reverse proxy + TLS termination + static files
       │
       ▼
    [mod_wsgi] ← gateway hacia Django/DRF
       │
       ▼
    [DRF App] ← :doc:`/backend/overview`
       │
       ├─→ [MySQL]      ← :doc:`/databases/overview` (operativa, RO)
       └─→ [PostgreSQL] ← :doc:`/databases/overview` (analítica)

Componentes
===========

Ubuntu
------

- Versión LTS soportada (24.04 o equivalente vigente).
- Hardening base: firewall (``ufw``), usuarios sin root,
  SSH keys, fail2ban.
- Logs centralizados (rsyslog/journalctl).

Apache
------

- vhosts por entorno (staging, production).
- TLS con certificados Let's Encrypt o equivalente.
- ``mod_wsgi`` para servir Django.
- Static files servidos directamente por Apache (no por Django).
- Compresión (``mod_deflate``), caching (``mod_expires``).

Networking
----------

- DNS gestionado externamente (proveedor cloud o registrar).
- Reverse proxy interno si hay múltiples backends.

Decisiones arquitectónicas
==========================

ADRs relevantes en :doc:`/normativa/gobernanza/index` con prefijo
``ADR-DEVOPS-`` (Vagrant + mod_wsgi para producción, virtualización
WASI-style para DB, etc.).

Restricciones
=============

CNST aplicables al tier de infra (deployment, performance,
auditoría inmutable): :doc:`/normativa/restricciones/index`.

Operaciones
===========

Setup, deploy, monitoring, runbooks: :doc:`/operations/overview`.

Convenciones
============

Naming de hosts, paths, vhosts, security baseline:
:doc:`conventions`.
