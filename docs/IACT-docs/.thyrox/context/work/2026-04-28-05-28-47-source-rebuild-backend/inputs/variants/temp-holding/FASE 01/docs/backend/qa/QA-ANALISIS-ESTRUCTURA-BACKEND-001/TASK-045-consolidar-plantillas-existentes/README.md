---
id: TASK-REORG-BACK-045
tipo: tarea
categoria: plantillas
titulo: Consolidar Plantillas Existentes
fase: FASE_3
prioridad: MEDIA
duracion_estimada: 30min
estado: pendiente
dependencias: [TASK-043, TASK-044]
metodologia: Auto-CoT, Self-Consistency
---

# TASK-REORG-BACK-045: Consolidar Plantillas Existentes

**Fase:** FASE 3 - Plantillas y Documentacion Estructurada
**Prioridad:** MEDIA
**Duracion Estimada:** 30 minutos
**Responsable:** Tech Writer
**Estado:** PENDIENTE
**Metodologia:** Auto-CoT (Auto-Chain of Thought), Self-Consistency
**Dependencias:** TASK-043 (plantilla ADR), TASK-044 (plantilla procedimiento)

---

## Objetivo

Identificar, revisar y consolidar todas las plantillas existentes en el proyecto backend, crear un catalogo centralizado de plantillas, y asegurar consistencia entre plantillas nuevas y existentes.

---

## Auto-CoT: Razonamiento en Cadena

### Paso 1: Identificar ubicaciones de plantillas
**Pregunta:** ¿Donde pueden estar las plantillas en el proyecto?
**Razonamiento:**
- docs/templates/
- .github/ (issue templates, PR templates)
- docs/backend/templates/
- Raiz de carpetas especificas (README templates)
- Archivos .template, template-*, plantilla-*

### Paso 2: Categorizar tipos de plantillas
**Pregunta:** ¿Que tipos de plantillas necesita un proyecto backend?
**Razonamiento:**
- **Codigo:** Clases, servicios, controladores, tests
- **Documentacion:** ADRs, procedimientos, READMEs, guias
- **CI/CD:** Pipelines, workflows, jobs
- **Infraestructura:** Dockerfiles, Kubernetes manifests, Terraform
- **Colaboracion:** Issues, PRs, RFC

### Paso 3: Validar con Self-Consistency
**Perspectiva 1 - Tech Writer:** Necesita plantillas de documentacion consistentes
**Perspectiva 2 - Desarrollador:** Necesita plantillas de codigo reutilizables
**Perspectiva 3 - DevOps:** Necesita plantillas de infraestructura estandarizadas
**Perspectiva 4 - Product Manager:** Necesita plantillas de issues/features claras
**Consenso:** Catalogo centralizado con indice categorizado y ejemplos de uso

---

## Prerequisitos

- [ ] TASK-043 completada (plantilla ADR creada)
- [ ] TASK-044 completada (plantilla procedimiento creada)
- [ ] Acceso de lectura a todo el repositorio
- [ ] Herramientas: grep, find, tree

---

## Pasos de Ejecucion

### Paso 1: Descubrir Plantillas Existentes
```bash
# Buscar archivos con "template" en el nombre
find /home/user/IACT -type f -iname "*template*" -o -iname "*plantilla*"

# Buscar archivos .template
find /home/user/IACT -type f -name "*.template"

# Buscar en .github
ls -la /home/user/IACT/.github/ISSUE_TEMPLATE/
ls -la /home/user/IACT/.github/PULL_REQUEST_TEMPLATE/

# Buscar en docs
find /home/user/IACT/docs -type f -iname "*template*" -o -iname "*plantilla*"

# Buscar archivos que empiecen con template- o plantilla-
find /home/user/IACT -type f \( -name "template-*" -o -name "plantilla-*" \)
```

**Resultado Esperado:** Lista completa de plantillas existentes en el proyecto

### Paso 2: Categorizar Plantillas Encontradas
```bash
# Crear archivo temporal para catalogar
cat > /tmp/inventario-plantillas.md << 'EOF'
# Inventario de Plantillas - Backend

## Plantillas de Codigo
- [ ] template-service.ts
- [ ] template-controller.ts
- [ ] template-test.spec.ts

## Plantillas de Documentacion
- [ ] plantilla-adr-backend.md (TASK-043)
- [ ] plantilla-procedimiento-backend.md (TASK-044)
- [ ] template-README.md

## Plantillas de CI/CD
- [ ] .github/workflows/template-*.yml

## Plantillas de Infraestructura
- [ ] template-Dockerfile
- [ ] template-k8s-deployment.yaml

## Plantillas de Colaboracion
- [ ] .github/ISSUE_TEMPLATE/*.md
- [ ] .github/PULL_REQUEST_TEMPLATE.md
EOF

# Llenar inventario con resultados del Paso 1
```

**Resultado Esperado:** Inventario categorizado de todas las plantillas

### Paso 3: Analizar Calidad de Plantillas Existentes
Para cada plantilla encontrada, evaluar:

```bash
# Checklist de calidad de plantillas
# 1. ¿Tiene comentarios explicativos?
# 2. ¿Incluye ejemplos de uso?
# 3. ¿Esta actualizada (< 6 meses)?
# 4. ¿Es completa (no le faltan secciones)?
# 5. ¿Es consistente con otras plantillas?
```

**Criterios de Evaluacion:**
- **Excelente (4-5 criterios):** Mantener como esta
- **Buena (3 criterios):** Mejorar ligeramente
- **Regular (1-2 criterios):** Refactorizar
- **Pobre (0 criterios):** Reescribir o deprecar

**Resultado Esperado:** Cada plantilla evaluada con score de calidad

### Paso 4: Crear Estructura Centralizada de Plantillas
```bash
# Crear estructura unificada
mkdir -p /home/user/IACT/docs/backend/plantillas/{codigo,documentacion,cicd,infraestructura,colaboracion}

# Estructura esperada:
# docs/backend/plantillas/
# README.md (indice maestro)
# codigo/
# README.md
# template-service.ts
# template-controller.ts
# template-test.spec.ts
# documentacion/
# README.md
# plantilla-adr-backend.md
# plantilla-procedimiento-backend.md
# template-README.md
# template-guia-usuario.md
# cicd/
# README.md
# template-workflow.yml
# infraestructura/
# README.md
# template-Dockerfile
# template-k8s-deployment.yaml
# colaboracion/
# README.md
# (enlaces simbolicos a .github/ISSUE_TEMPLATE/)
```

**Resultado Esperado:** Estructura de carpetas creada

### Paso 5: Consolidar Plantillas
```bash
# Copiar o mover plantillas a ubicacion centralizada
# (DECISION: copiar para mantener retrocompatibilidad)

# Ejemplo:
cp /home/user/IACT/docs/backend/arquitectura/decisions/plantilla-adr-backend.md \
 /home/user/IACT/docs/backend/plantillas/documentacion/

cp /home/user/IACT/docs/backend/procedures/plantilla-procedimiento-backend.md \
 /home/user/IACT/docs/backend/plantillas/documentacion/

# Para plantillas de .github, crear enlaces simbolicos
ln -s /home/user/IACT/.github/ISSUE_TEMPLATE \
 /home/user/IACT/docs/backend/plantillas/colaboracion/issue-templates

ln -s /home/user/IACT/.github/PULL_REQUEST_TEMPLATE.md \
 /home/user/IACT/docs/backend/plantillas/colaboracion/pr-template.md
```

**Resultado Esperado:** Plantillas consolidadas en estructura centralizada

### Paso 6: Crear README Maestro de Plantillas
```bash
cat > /home/user/IACT/docs/backend/plantillas/README.md << 'EOF'
# Catalogo de Plantillas - Backend

Repositorio centralizado de plantillas para desarrollo, documentacion, CI/CD e infraestructura del backend.

---

## Indice de Plantillas

### Documentacion
| Plantilla | Proposito | Ubicacion | Cuando Usar |
|-----------|-----------|-----------|-------------|
| `plantilla-adr-backend.md` | Architecture Decision Records | `documentacion/` | Al tomar decisiones arquitectonicas importantes |
| `plantilla-procedimiento-backend.md` | Procedimientos operacionales | `documentacion/` | Al crear runbooks de deployment, rollback, maintenance |
| `template-README.md` | READMEs estandarizados | `documentacion/` | Al crear nuevo modulo/servicio/carpeta |
| `template-guia-usuario.md` | Guias de usuario | `documentacion/` | Al documentar features para usuarios finales |

### Codigo
| Plantilla | Proposito | Ubicacion | Cuando Usar |
|-----------|-----------|-----------|-------------|
| `template-service.ts` | Servicios de negocio | `codigo/` | Al crear nuevo servicio en capa de aplicacion |
| `template-controller.ts` | Controladores REST | `codigo/` | Al crear nuevo endpoint REST |
| `template-repository.ts` | Repositorios de datos | `codigo/` | Al crear acceso a base de datos |
| `template-test.spec.ts` | Tests unitarios | `codigo/` | Al crear tests para servicios/controladores |
| `template-integration-test.spec.ts` | Tests de integracion | `codigo/` | Al crear tests end-to-end |

### CI/CD
| Plantilla | Proposito | Ubicacion | Cuando Usar |
|-----------|-----------|-----------|-------------|
| `template-workflow.yml` | GitHub Actions workflow | `cicd/` | Al crear nuevo workflow de CI/CD |
| `template-pipeline.jenkinsfile` | Jenkins pipeline | `cicd/` | Al crear pipeline de Jenkins |
| `template-job.yml` | Job de CI especifico | `cicd/` | Al crear job reutilizable |

### Infraestructura
| Plantilla | Proposito | Ubicacion | Cuando Usar |
|-----------|-----------|-----------|-------------|
| `template-Dockerfile` | Imagen Docker | `infraestructura/` | Al containerizar servicio backend |
| `template-k8s-deployment.yaml` | Deployment de Kubernetes | `infraestructura/` | Al desplegar en K8s |
| `template-k8s-service.yaml` | Service de Kubernetes | `infraestructura/` | Al exponer servicio en K8s |
| `template-terraform-module.tf` | Modulo Terraform | `infraestructura/` | Al crear infraestructura como codigo |

### Colaboracion
| Plantilla | Proposito | Ubicacion | Cuando Usar |
|-----------|-----------|-----------|-------------|
| `bug-report.md` | Reporte de bugs | `.github/ISSUE_TEMPLATE/` | Al reportar un bug |
| `feature-request.md` | Solicitud de feature | `.github/ISSUE_TEMPLATE/` | Al proponer nueva funcionalidad |
| `pull-request-template.md` | Template de PRs | `.github/` | Automaticamente en cada PR |
| `rfc-template.md` | Request for Comments | `colaboracion/` | Al proponer cambio significativo |

---

## Como Usar las Plantillas

### Paso 1: Seleccionar Plantilla
Identifica en la tabla de arriba cual plantilla necesitas.

### Paso 2: Copiar Plantilla
```bash
# Ejemplo: crear nuevo ADR
cp docs/backend/plantillas/documentacion/plantilla-adr-backend.md \
 docs/backend/arquitectura/decisions/ADR-042-nueva-decision.md
```

### Paso 3: Completar Plantilla
Abre el archivo copiado y reemplaza:
- `[PLACEHOLDER]` con valores reales
- `XXX` con numeros/IDs correspondientes
- `YYYY-MM-DD` con fechas actuales
- Secciones de ejemplo con contenido real

### Paso 4: Validar Completitud
Verifica que:
- [ ] No quedan placeholders sin reemplazar
- [ ] Todas las secciones obligatorias estan completas
- [ ] Formato markdown es correcto
- [ ] Enlaces y referencias son validos

### Paso 5: Someter a Revision
- Crear PR con nuevo documento
- Solicitar revision de al menos 1 peer
- Incorporar feedback
- Mergear

---

## Convenciones de Nomenclatura

### Archivos de Plantilla
- **Documentacion:** `plantilla-{tipo}-backend.md`
- **Codigo:** `template-{componente}.{ext}`
- **Infraestructura:** `template-{recurso}.{ext}`
- **CI/CD:** `template-{tipo}.yml`

### Archivos Creados desde Plantillas
- **ADR:** `ADR-{numero}-{titulo-kebab-case}.md`
- **Procedimiento:** `PROC-BACKEND-{numero}-{titulo}.md`
- **README:** `README.md` (en carpeta correspondiente)
- **Codigo:** Seguir convenciones del lenguaje

---

## Mantenimiento de Plantillas

### Actualizacion
- Revision trimestral de todas las plantillas
- Actualizar basado en feedback del equipo
- Mantener changelog en cada plantilla

### Versionado
- Usar versionado semantico en frontmatter: `version: X.Y.Z`
- MAJOR: Cambios incompatibles en estructura
- MINOR: Nuevas secciones opcionales
- PATCH: Correcciones menores, ejemplos mejorados

### Deprecacion
- Marcar plantilla como `[DEPRECADA]` en titulo
- Añadir seccion "Reemplazada por: [nueva-plantilla]"
- Mantener plantilla deprecada por al menos 6 meses
- Eliminar tras confirmar que no se usa

---

## Contribuir Nuevas Plantillas

### Criterios de Aceptacion
Una plantilla debe:
- [ ] Resolver necesidad recurrente del equipo
- [ ] Incluir comentarios explicativos
- [ ] Tener ejemplos de uso
- [ ] Seguir convenciones del proyecto
- [ ] Ser revisada por al menos 2 personas
- [ ] Estar documentada en este README

### Proceso
1. Crear plantilla en carpeta correspondiente
2. Añadir entrada en tabla de indice de arriba
3. Crear PR con titulo "feat(plantillas): añadir template-{nombre}"
4. Solicitar revision de Tech Lead
5. Mergear tras aprobacion

---

## Metricas de Uso

### Plantillas Mas Usadas
1. `plantilla-adr-backend.md` - 42 usos
2. `template-service.ts` - 38 usos
3. `plantilla-procedimiento-backend.md` - 25 usos
4. `template-README.md` - 23 usos

(Actualizado: 2025-11-18)

---

## Referencias

- [ADR sobre plantillas estandarizadas](#) (si existe)
- [Guia de estilo de documentacion](#)
- [Coding standards del proyecto](#)

---

## Contacto

**Maintainer:** Tech Writer / Tech Lead
**Slack:** #backend-docs
**Issues:** Reportar en GitHub con label `plantillas`

---

**Ultima actualizacion:** 2025-11-18
**Version:** 1.0.0
EOF
```

**Resultado Esperado:** README maestro creado con catalogo completo

### Paso 7: Crear READMEs para Subcarpetas
```bash
# README para codigo/
cat > /home/user/IACT/docs/backend/plantillas/codigo/README.md << 'EOF'
# Plantillas de Codigo - Backend

Plantillas reutilizables para componentes de codigo del backend.

## Plantillas Disponibles

- `template-service.ts` - Servicios de logica de negocio
- `template-controller.ts` - Controladores REST API
- `template-repository.ts` - Repositorios de acceso a datos
- `template-test.spec.ts` - Tests unitarios
- `template-integration-test.spec.ts` - Tests de integracion

Ver README principal para mas detalles: `../README.md`
EOF

# README para documentacion/
cat > /home/user/IACT/docs/backend/plantillas/documentacion/README.md << 'EOF'
# Plantillas de Documentacion - Backend

Plantillas para documentacion tecnica y operacional del backend.

## Plantillas Disponibles

- `plantilla-adr-backend.md` - Architecture Decision Records
- `plantilla-procedimiento-backend.md` - Procedimientos operacionales (runbooks)
- `template-README.md` - READMEs estandarizados
- `template-guia-usuario.md` - Guias de usuario

Ver README principal: `../README.md`
EOF

# README para cicd/
cat > /home/user/IACT/docs/backend/plantillas/cicd/README.md << 'EOF'
# Plantillas de CI/CD - Backend

Plantillas para pipelines y workflows de CI/CD.

## Plantillas Disponibles

- `template-workflow.yml` - GitHub Actions workflows
- `template-pipeline.jenkinsfile` - Jenkins pipelines
- `template-job.yml` - Jobs de CI reutilizables

Ver README principal: `../README.md`
EOF

# README para infraestructura/
cat > /home/user/IACT/docs/backend/plantillas/infraestructura/README.md << 'EOF'
# Plantillas de Infraestructura - Backend

Plantillas para infraestructura como codigo y containerizacion.

## Plantillas Disponibles

- `template-Dockerfile` - Imagenes Docker
- `template-k8s-deployment.yaml` - Deployments de Kubernetes
- `template-k8s-service.yaml` - Services de Kubernetes
- `template-terraform-module.tf` - Modulos Terraform

Ver README principal: `../README.md`
EOF

# README para colaboracion/
cat > /home/user/IACT/docs/backend/plantillas/colaboracion/README.md << 'EOF'
# Plantillas de Colaboracion - Backend

Plantillas para issues, PRs y RFCs.

## Plantillas Disponibles

Las plantillas de GitHub Issues y PRs estan en `.github/`:
- `.github/ISSUE_TEMPLATE/` - Templates de issues
- `.github/PULL_REQUEST_TEMPLATE.md` - Template de PRs

Templates adicionales:
- `rfc-template.md` - Request for Comments

Ver README principal: `../README.md`
EOF
```

**Resultado Esperado:** READMEs creados para cada subcarpeta

### Paso 8: Validar Consolidacion con Self-Consistency
```bash
# Perspectiva 1: Tech Writer
# ¿Es facil encontrar la plantilla que necesito?
# ¿El catalogo esta bien organizado?

# Perspectiva 2: Desarrollador
# ¿Las plantillas de codigo son utiles y actualizadas?
# ¿Los ejemplos son claros?

# Perspectiva 3: DevOps
# ¿Las plantillas de CI/CD cubren casos comunes?
# ¿Estan bien documentadas?

# Perspectiva 4: Product Manager
# ¿Las plantillas de colaboracion facilitan tracking?
# ¿Son suficientemente detalladas?

# Validar estructura
tree -L 2 /home/user/IACT/docs/backend/plantillas/

# Validar que cada carpeta tiene README
find /home/user/IACT/docs/backend/plantillas -type d -exec sh -c 'ls -1 "$1" | grep -q "README.md"' _ {} \; -print
```

**Resultado Esperado:** Estructura validada desde 4 perspectivas

---

## Criterios de Exito

- [ ] Inventario completo de plantillas existentes creado
- [ ] Plantillas categorizadas en 5 categorias: codigo, documentacion, cicd, infraestructura, colaboracion
- [ ] Estructura centralizada creada en docs/backend/plantillas/
- [ ] README maestro con catalogo completo
- [ ] READMEs en cada subcarpeta
- [ ] Plantillas de TASK-043 y TASK-044 incluidas
- [ ] Enlaces simbolicos a .github/ISSUE_TEMPLATE/ creados
- [ ] Cada plantilla evaluada con score de calidad
- [ ] Tabla de indice con "Cuando Usar" para cada plantilla
- [ ] Seccion de "Como Usar las Plantillas" documentada
- [ ] Validacion con Self-Consistency desde 4 perspectivas completada

---

## Validacion

```bash
# Verificar estructura creada
tree /home/user/IACT/docs/backend/plantillas/

# Verificar README maestro
cat /home/user/IACT/docs/backend/plantillas/README.md

# Contar plantillas documentadas
grep -c "^|" /home/user/IACT/docs/backend/plantillas/README.md

# Verificar que cada subcarpeta tiene README
for dir in codigo documentacion cicd infraestructura colaboracion; do
 if [ -f "/home/user/IACT/docs/backend/plantillas/$dir/README.md" ]; then
 echo "OK $dir tiene README"
 else
 echo " $dir NO tiene README"
 fi
done

# Verificar enlaces simbolicos
ls -la /home/user/IACT/docs/backend/plantillas/colaboracion/
```

**Salida Esperada:** Estructura completa, todos los READMEs presentes, enlaces simbolicos funcionando

---

## Riesgos

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|-----------|
| Plantillas duplicadas | ALTA | MEDIO | Crear enlaces simbolicos en lugar de copiar, documentar ubicacion canonica |
| Plantillas desactualizadas | MEDIA | MEDIO | Revision trimestral, versionado semantico |
| Catalogo no se mantiene | ALTA | ALTO | Asignar owner, incluir en DoD de nuevas plantillas |
| Desarrolladores no encuentran plantillas | MEDIA | MEDIO | Linkear desde documentacion principal, educar en onboarding |

---

## Evidencias a Capturar

1. Inventario de plantillas (`inventario-plantillas.md`)
2. Estructura de carpetas (output de `tree`)
3. README maestro completo
4. READMEs de subcarpetas
5. Screenshot de estructura

---

## Notas

- Esta tarea consolida plantillas existentes y nuevas (TASK-043, TASK-044)
- Usar Auto-CoT para razonar sobre categorizacion
- Validar con Self-Consistency: Tech Writer, Dev, DevOps, PM
- La consolidacion debe mejorar descubribilidad sin romper referencias existentes
- Considerar crear script para validar que plantillas no estan desactualizadas
- El catalogo debe ser un documento VIVO que se actualiza con cada nueva plantilla

---

## Referencias Auto-CoT

**Chain 1 - Descubribilidad:**
¿Como hacer que desarrolladores encuentren plantillas? → Ubicacion centralizada → Catalogo con indice → Enlaces desde docs principales → Facil descubrimiento

**Chain 2 - Mantenibilidad:**
¿Como mantener plantillas actualizadas? → Versionado semantico → Revision periodica → Owner asignado → Plantillas se mantienen relevantes

**Chain 3 - Consistencia:**
¿Como asegurar consistencia entre plantillas? → Estructura comun → Convenciones de nomenclatura → Ejemplos claros → Plantillas coherentes

---

## Tiempo de Ejecucion

**Inicio:** __:__
**Fin:** __:__
**Duracion Real:** __ minutos
**Desviacion vs Estimado:** +/- __ minutos

---

## Checklist de Finalizacion

- [ ] Inventario de plantillas completo
- [ ] Estructura docs/backend/plantillas/ creada
- [ ] README maestro con catalogo completo
- [ ] READMEs en todas las subcarpetas
- [ ] plantilla-adr-backend.md consolidada
- [ ] plantilla-procedimiento-backend.md consolidada
- [ ] Enlaces simbolicos a .github/ creados
- [ ] Validacion Self-Consistency desde 4 perspectivas completada
- [ ] Estructura validada con tree
- [ ] Tarea marcada como COMPLETADA en INDICE.md

---

**Tarea creada:** 2025-11-18
**Ultima actualizacion:** 2025-11-18
**Version:** 1.0.0
**Estado:** PENDIENTE
