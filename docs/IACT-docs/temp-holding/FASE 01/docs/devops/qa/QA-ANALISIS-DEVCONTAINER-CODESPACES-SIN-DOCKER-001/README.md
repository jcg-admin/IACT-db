# QA-ANALISIS-DEVCONTAINER-CODESPACES-SIN-DOCKER-001

Este análisis documenta el estado actual del DevContainer cuando el host no puede ejecutar Docker (dependencia en GitHub Codespaces). Incluye inventario de servicios, riesgos y próximos pasos para QA.

## Objetivo y alcance
- Validar cómo está montada la experiencia de desarrollo usando DevContainer sin requerir Docker en los hosts locales, apoyándose en GitHub Codespaces.
- Cubrir el estado actual del repositorio completo (backends, frontends, infraestructura y documentación) para detectar dependencias cruzadas y acoplamientos con el DevContainer.
- Alinear la evidencia y los hallazgos con tareas trazables (prefijo `TASK-XXX`) y carpeta de evidencias.

## Inventario del estado actual
- **Contenedores y servicios**: `.devcontainer/docker_compose.yml` levanta `app` (workspace Django), `db_postgres` (PostgreSQL 15-alpine con `pg_isready`) y `db_mariadb` (MariaDB 10.11 con healthcheck `healthcheck.sh`). Publica puertos 8000/5432/3306 y persiste datos con volúmenes `callcenter-postgres-data`, `callcenter-mariadb-data`, `callcenter-devcontainer-bashhistory` y `callcenter-devcontainer-pip-cache`.
- **Runtime base**: `.devcontainer/Dockerfile` parte de `mcr.microsoft.com/devcontainers/python:3.12-bookworm`, instala clientes PostgreSQL/MariaDB y herramientas de desarrollo, y define `CMD sleep infinity` para DevContainer.
- **Orquestación VS Code**: `.devcontainer/devcontainer.json` usa los hooks `init_host.sh`, `on_create.sh`, `update_content.sh`, `post_create.sh`, `post_start.sh`, fija intérprete `/usr/local/bin/python3`, extensiones de VS Code y montado de llaves SSH. Usa `.devcontainer/.env` para credenciales y rutas.
- **Scripts de ciclo de vida**: `infrastructure/devcontainer/scripts/` contiene validaciones de host, bootstrap de dependencias, instalación de requirements y checks en arranques posteriores, alineados con cobertura mínima 80 % y TDD.
- **Componentes del repositorio**: backend Django en `api/callcentersite/`, automatización en `infrastructure/`, scripts en `scripts/`, frontends en `ui/`, y documentación bajo `docs/`. Todo se monta en el servicio `app` mediante el volumen `..:/workspaces/${localWorkspaceFolderBasename}`.

## Condiciones operativas sin Docker en el host
- El flujo esperado es usar GitHub Codespaces, donde sí existe Docker Engine; el host del desarrollador solo opera como cliente VS Code (desktop o web).
- Para bases externas (ej. Vagrant), ajustar `.devcontainer/.env` para que el servicio `app` apunte a ellas. Los servicios `db_postgres` y `db_mariadb` pueden mantenerse apagados en Codespaces si se quiere reducir consumo.

## Diagrama de flujo
Archivo `diagramas.puml` (PlantUML) en esta misma carpeta describe la interacción entre Codespaces, contenedor `app` y las bases de datos.

## Organización y trazabilidad
- `INDICE.md`: lista de tareas `TASK-XXX` y su propósito.
- `evidencias/`: repositorio para adjuntar resultados por tarea (logs, capturas, exportados de tests).
- `diagramas.puml`: referencia visual del flujo operativo.

## Observaciones y riesgos
- El contenedor `app` opera con sudo sin contraseña; estándar en Codespaces pero debe vigilarse en entornos autoservicio.
- Los hooks dependen de `.devcontainer/.env`; la falta de ese archivo impide levantar servicios y debe validarse en CI para evitar errores de onboarding.
- Cobertura mínima y TDD están documentados, pero no todas las suites (`pytest`, linters) se ejecutan automáticamente en los hooks; conviene reforzar `post_start.sh` o pipelines.
- La persistencia en volúmenes facilita pruebas, pero limpiar estados entre escenarios (Postgres vs MariaDB) requiere pasos manuales o scripts adicionales.

## Próximos pasos sugeridos
- Añadir checks ligeros en CI que consuman el mismo `docker_compose.yml` para validar conectividad a ambas bases, aun si producción no usa Docker.
- Publicar artefactos generados de `diagramas.puml` (PNG/SVG) en `docs/devops` para consulta rápida del equipo QA.
- Incorporar evidencia en `evidencias/` por cada `TASK-XXX` para mejorar trazabilidad del análisis.
