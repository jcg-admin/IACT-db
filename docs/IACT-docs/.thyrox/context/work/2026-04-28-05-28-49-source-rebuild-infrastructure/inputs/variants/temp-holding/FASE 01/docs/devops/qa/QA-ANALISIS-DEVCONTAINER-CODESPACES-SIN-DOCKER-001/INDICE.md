# INDICE - QA-ANALISIS-DEVCONTAINER-CODESPACES-SIN-DOCKER-001

## Tareas trazables
- **TASK-001-inventario-componentes-devcontainer**: registrar servicios, volúmenes, puertos y healthchecks definidos en `.devcontainer/`.
- **TASK-002-validar-hooks-codespaces**: revisar `init_host.sh`, `on_create.sh`, `update_content.sh`, `post_create.sh`, `post_start.sh` y documentar resultados esperados.
- **TASK-003-verificar-env-file**: confirmar variables requeridas en `.devcontainer/.env` y validar que los hooks fallen rápido si falta el archivo.
- **TASK-004-conectividad-postgres**: levantar `db_postgres` o apuntar a Postgres externo y capturar pruebas de conexión desde `app`.
- **TASK-005-conectividad-mariadb**: repetir la verificación con `db_mariadb` o instancia externa, documentando comandos y resultados.
- **TASK-006-paridad-ci**: validar que pipelines o jobs de CI puedan reutilizar `docker_compose.yml` para pruebas de integración.
- **TASK-007-riesgos-seguridad-permisos**: evaluar implicaciones de sudo sin contraseña y manejo de claves SSH dentro del contenedor.
- **TASK-008-publicar-diagramas-evidencias**: generar PNG/SVG desde `diagramas.puml` y almacenarlos junto con logs de tareas en `evidencias/`.

## Evidencias
- `evidencias/TASK-001/`: pruebas y capturas del inventario.
- `evidencias/TASK-002/`: resultados de la inspección de hooks.
- `evidencias/TASK-003/`: validaciones de variables y fallos controlados.
- `evidencias/TASK-004/`: comandos y logs de conectividad PostgreSQL.
- `evidencias/TASK-005/`: comandos y logs de conectividad MariaDB.
- `evidencias/TASK-006/`: notas y referencias de pipelines que consumen el compose.
- `evidencias/TASK-007/`: hallazgos de seguridad y permisos.
- `evidencias/TASK-008/`: artefactos generados (PNG/SVG) y bitácoras asociadas.

## Referencias rápidas
- `README.md`: contexto, alcance y riesgos.
- `diagramas.puml`: diagrama de flujo operativo del DevContainer.
