.. meta::
   :artefacto: OPERATIONS_OVERVIEW
   :tipo: Visión general del tier
   :dominio: tech
   :estado: Esqueleto
   :version: 1.0.0
   :fecha_creacion: 2026-04-28
   :autor: Equipo IACT

============================================
Operations — Visión general
============================================

Alcance
=======

El cajón ``operations/`` agrupa la documentación operativa del
producto IACT: cómo se despliega, monitorea, opera, mantiene y se
responde a incidentes. Es el **lado runtime** complementario a los
tiers técnicos (:doc:`/backend/overview`,
:doc:`/frontend/overview`, :doc:`/infrastructure/overview`,
:doc:`/databases/overview`).

Distinción con ``normativa/procedimientos/``
============================================

- ``normativa/procedimientos/`` define **procedimientos de
  governance** del proyecto (cómo se decide, se aprueba, se
  documenta) — ámbito metodológico.
- ``operations/`` define **runbooks técnicos** (cómo se ejecuta
  un deploy, cómo se responde a una alerta) — ámbito de runtime.

Algunos PROCs históricamente han vivido en
``normativa/procedimientos/`` con contenido operativo (ej:
``PROC-OPS-001-deployment.rst``). Per Decision 10 del rebuild
v2.0, los runbooks operativos pueden migrar acá; los PROCs
metodológicos quedan en ``normativa/procedimientos/``.

Áreas cubiertas
===============

Deployment
----------

- Pipeline de deploy (CI/CD).
- Checklists pre-deploy.
- Rollback procedures.
- Promoción entre entornos (dev → staging → prod).
- Versionado de releases (SemVer del producto, distinto del
  versionado de docs).

Monitoring
----------

- Métricas de health (CPU, RAM, disco, red, latencia, error rate).
- Logs centralizados.
- Dashboards (¿Grafana / equivalente — pendiente decisión).
- Alertas y on-call rotation.

Incident response
-----------------

- Severidad de incidentes (S1/S2/S3/S4).
- Runbooks por tipo de incidente.
- Comunicación durante incidentes.
- Postmortems y lessons learned (las lessons learned
  publicables van a ``gestion/retrospectives/``).

Backup y recovery
-----------------

- Política de backups (frecuencia, retención).
- Procedimientos de restore.
- Verificación periódica (no basta con respaldar — hay que
  validar que el restore funciona).
- DR (disaster recovery) procedures.

Maintenance
-----------

- Updates de OS / software.
- Vacuum / reindex de DB.
- Rotación de logs.
- Limpieza de assets temporales.

Pre-condiciones del tier
========================

Operations consume convenciones de los 4 tiers técnicos
(backend, frontend, infrastructure, databases). Sus runbooks
hacen referencia a ellos.

Restricciones aplicables
========================

CNST específicas para operaciones (auditoría inmutable, RPO/RTO,
ventanas de mantenimiento) viven en
:doc:`/normativa/restricciones/index`.

Interacciones con otros cajones
===============================

- Onboarding del equipo de ops: :doc:`/onboarding/overview` (sección
  específica para ingenieros de operaciones).
- Calidad: deploy gates basados en testing automatizado de
  :doc:`/quality/overview`.
- Risks/TD: incidentes recurrentes alimentan
  :doc:`/risks-technical-debt/index`.
