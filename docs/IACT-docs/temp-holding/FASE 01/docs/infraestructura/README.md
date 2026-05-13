---
id: DOC-INFRA-INDEX
estado: activo
propietario: equipo-infraestructura
ultima_actualizacion: 2025-11-18
relacionados: ["DOC-INDEX-GENERAL", "DOC-DEVOPS-INDEX"]
---
# Espacio de documentación - Infraestructura

Este espacio centraliza la documentación operativa y de diseño de la infraestructura que soporta el monolito modular del proyecto. Mantiene alineación con las prácticas de backend y frontend para facilitar la colaboración cruzada.

## Página padre
- [Índice de espacios documentales](../index.md)

## Páginas hijas

### Arquitectura y diseño
- [Arquitectura de infraestructura](diseno/arquitectura/README.md)
- [Diseño detallado y modelos](diseno/README.md)
- [Entornos de desarrollo (DevContainer)](devcontainer/README.md)

### Operación y confiabilidad
- [Checklists operativos y de hardening](checklists/README.md)
- [Procedimientos de infraestructura](procedimientos/README.md)
- [QA y resiliencia](qa/README.md)

### Automatización y DevOps
- [Automatización y pipelines de infraestructura](devops/README.md)
- [Planificación y releases de infraestructura](plan/planificacion_y_releases/README.md)
- [Workspaces y herramientas](workspace/README.md)

### Requisitos y gobierno
- [Requisitos y acuerdos de nivel de servicio](requisitos/README.md)
- [Gobernanza de infraestructura](gobernanza/README.md)

Cada carpeta ofrece un README inicial listo para documentar los artefactos correspondientes.

## Información clave

### Políticas de operación
- **Hardening obligatorio**: aplicar los checklists de sistema operativo, red y contenedores antes de exponer servicios.
- **Observabilidad mínima**: toda plataforma debe publicar métricas, logs y trazas hacia los colectores definidos en QA.
- **Mantenimiento planificado**: las ventanas se registran en `plan/planificacion_y_releases/` e incluyen rollback documentado.

### Estándares de calidad
- **Infra as Code revisable**: cambios a Terraform/Ansible/plantillas deben pasar por revisión cruzada y validación automática.
- **Confiabilidad y SLOs**: los requisitos de disponibilidad y rendimiento se documentan en `requisitos/` y se trazan a pruebas de resiliencia.
- **Reutilización de artefactos**: imágenes base, binarios precompilados y scripts deben tener checksum y versión publicados.

### Metodología y convenciones mínimas
- **TDD y cobertura ≥80%**: toda automatización susceptible de prueba debe implementarse con TDD y mantener cobertura mínima del 80%.
- **Commits convencionales**: usar el formato `<type>(<scope>): <description>` para cada cambio.
- **Revisión y seguridad**: ningún cambio se despliega sin revisión técnica y chequeos automáticos de seguridad.

### Proceso de control de cambios
1. Registrar issue o solicitud en `solicitudes/` con alcance y riesgos.
2. Crear rama `infra/feature-*` o `infra/hotfix-*` desde `develop`.
3. Implementar siguiendo TDD para módulos automatizables y actualizar la documentación afectada.
4. Ejecutar pipelines de infraestructura (lint, validaciones de configuración, planes de despliegue) antes del PR.
5. Solicitar revisión técnica y de seguridad; mergear solo con aprobaciones y pipelines en verde.

### Arquitectura de ramas
- `main`: configuración validada en producción.
- `develop`: integración continua de infraestructura.
- `infra/feature/*`: nuevas capacidades o refactors mayores.
- `infra/hotfix/*`: correcciones urgentes aplicadas sobre producción.
- `docs/*`: ajustes de documentación sin cambios de código.

## Referencias destacadas
- **CPython precompilado**: guía del [pipeline y DevContainer](cpython_precompilado/pipeline_devcontainer.md) que documenta construcción, publicación y consumo del intérprete optimizado.
- **Scripts oficiales**: `build_cpython.sh`, `validate_build.sh` e `install_prebuilt_cpython.sh` viven en `infrastructure/cpython/scripts/` y cuentan con pruebas en `infrastructure/cpython/tests/`.
- **Workspaces Hamilton**: la carpeta [`workspace`](workspace/README.md) concentra tanto el ejemplo `Data → Prompt → LLM → $` como los lenguajes de servidores de desarrollo (`workspace/hamilton_llm/` y `workspace/dev_tools/language_server/hamilton_lsp/`), cada uno con sus pruebas.
- **DevContainer host y pipeline**: los canvas de arquitectura [`devcontainer-host-vagrant.md`](diseno/arquitectura/devcontainer-host-vagrant.md) y [`devcontainer-host-vagrant-pipeline.md`](diseno/arquitectura/devcontainer-host-vagrant-pipeline.md) documentan el modelo sin Docker en el workstation y el pipeline CI/CD asociado.

## Pipeline activo de infraestructura

Las automatizaciones CI/CD para infraestructura viven en `.github/workflows/infrastructure-ci.yml` y se disparan en cada `push` o `pull_request` a `main` y `develop`. El flujo incluye:

- **validate-shell-scripts**: ejecuta `shellcheck` sobre todos los `scripts/*.sh` y advierte sobre permisos de ejecución.
- **test-validation-scripts**: instala dependencias de `api/requirements.txt` y corre validadores de seguridad/configuración sobre MySQL de servicio.
- **validate-terraform**: si existe `infrastructure/terraform`, aplica `terraform fmt`, `init`, `validate` y `tfsec`.
- **validate-docker**: lint de `Dockerfile` y validación de `docker-compose` si están presentes en el repo.
- **validate-configurations**: verifica que todo YAML/JSON sea parseable y alerta sobre patrones típicos de secretos hardcodeados.
- **test-health-check**: levanta el servidor Django de pruebas apuntando a MySQL y comprueba el endpoint `/api/health`.

El job `summary` falla el pipeline si alguno de los pasos anteriores no supera las validaciones.

## Estado de cumplimiento

| Elemento | Estado | Observaciones |
|----------|--------|---------------|
| Checklists de hardening | 🔶 Parcial | Inventario base creado; falta cobertura para Kubernetes y redes L3 |
| Observabilidad de servicios | 🔶 Parcial | Dashboards en construcción; métricas publicadas en QA para cpython-precompilado |
| Procedimientos operativos | OK Sí | Procedimientos registrados en `procedimientos/` con responsables asignados |
| Pipelines CI/CD de infraestructura | OK Sí | Workflow `infrastructure-ci.yml` activo para ramas `main` y `develop` |
| Requisitos y SLOs | OK Sí | Trazabilidad documentada en `requisitos/` y `matriz_trazabilidad_rtm.md` |
| Gestión de artefactos | WARNING Parcial | Faltan checksums automatizados para imágenes base y artefactos binarios |

## Acciones prioritarias

### Corto Plazo (1-2 semanas)
- [ ] Completar checklists de hardening para Kubernetes y redes.
- [ ] Publicar dashboard mínimo de observabilidad para servicios críticos.
- [ ] Agregar validación automática de checksums en pipelines de artefactos.

### Mediano Plazo (1-2 meses)
- [ ] Incorporar pruebas de resiliencia (chaos testing) a `qa/` y enlazarlas al pipeline.
- [ ] Formalizar runbooks de contingencia en `procedimientos/` con criterios de activación.
- [ ] Automatizar generación y publicación de bitácoras en `plan/planificacion_y_releases/`.

### Largo Plazo (3-6 meses)
- [ ] Certificar cobertura de SLOs mediante dashboards y alertas alineadas a `requisitos/`.
- [ ] Consolidar repositorio de artefactos firmados y versionados para entornos productivos.
- [ ] Documentar estrategia de continuidad operativa multirregión y pruebas de recuperación.

## Recursos relacionados
- [Convenciones de Claude Code](../../.github/claude-code-conventions.md)
- [Copilot Instructions](../../.github/copilot-instructions.md)
- [Estrategia de QA](../qa/estrategia_qa.md)
