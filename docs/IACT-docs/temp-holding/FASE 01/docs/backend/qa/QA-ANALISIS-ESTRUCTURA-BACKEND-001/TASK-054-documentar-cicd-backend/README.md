---
id: TASK-REORG-BACK-054
tipo: tarea
categoria: varios
titulo: Documentar CI/CD Backend
fase: FASE_3
prioridad: ALTA
duracion_estimada: 40min
estado: pendiente
dependencias: []
metodologia: Auto-CoT, Self-Consistency
---

# TASK-REORG-BACK-054: Documentar CI/CD Backend

**Fase:** FASE 3 - Documentacion Varia
**Prioridad:** ALTA
**Duracion Estimada:** 40 minutos
**Responsable:** DevOps Lead / Tech Lead
**Estado:** PENDIENTE
**Metodologia:** Auto-CoT, Self-Consistency

---

## Objetivo

Crear documentacion completa del pipeline CI/CD del backend, incluyendo workflow, stages, configuracion, troubleshooting, y mejores practicas.

---

## Auto-CoT: Razonamiento en Cadena

### Paso 1: ¿Que componentes tiene un pipeline CI/CD backend?
**Razonamiento:**
- **CI (Continuous Integration):** Build, Test, Lint, Security Scan
- **CD (Continuous Deployment):** Deploy a Staging, Deploy a Produccion, Rollback
- **Gates:** Approval gates, test thresholds, security gates
- **Notificaciones:** Slack, Email, PagerDuty

### Paso 2: ¿Que debe documentarse del CI/CD?
**Razonamiento:**
- Arquitectura del pipeline (diagrama)
- Configuracion (archivos YAML)
- Triggers (cuando se ejecuta)
- Stages y jobs (que hace cada uno)
- Secrets y variables de entorno
- Troubleshooting comun
- Runbooks de rollback

### Paso 3: Validar con Self-Consistency
**Perspectiva DevOps:** Pipeline debe ser reproducible y automatizado
**Perspectiva Developer:** Debe ser claro como deployar y rollback
**Perspectiva QA:** Gates de calidad deben estar documentados
**Perspectiva Security:** Security scans deben estar integrados
**Consenso:** Documentacion completa con runbooks ejecutables

---

## Pasos de Ejecucion

### Paso 1: Investigar Pipeline Actual

```bash
# Buscar archivos de CI/CD
find /home/user/IACT -name ".github" -type d
ls -la /home/user/IACT/.github/workflows/

# Buscar configuracion de otros CI (Jenkins, GitLab CI, etc.)
find /home/user/IACT -name "Jenkinsfile" -o -name ".gitlab-ci.yml" -o -name "azure-pipelines.yml"
```

**Resultado Esperado:** Lista de configuraciones CI/CD existentes

### Paso 2: Crear Documentacion CI-CD.md

```bash
mkdir -p /home/user/IACT/docs/backend/cicd

cat > /home/user/IACT/docs/backend/cicd/CI-CD.md << 'EOF'
# CI/CD Pipeline - Backend

Documentacion completa del pipeline de Continuous Integration y Continuous Deployment.

---

## Arquitectura del Pipeline

```

 Git Push 

 CI PIPELINE (Automated) 

 1. Checkout Code 
 2. Install Dependencies 
 3. Lint & Format Check 
 4. Run Unit Tests (coverage > 80%) 
 5. Security Scan (SAST, Dependency Check) 
 6. Build Docker Image 
 7. Push to Registry 

 CD PIPELINE (Semi-Automated) 

 8. Deploy to Staging (auto) 
 9. Run Integration Tests 
 10. Run E2E Tests 
 11. Manual Approval Gate [WARNING] 
 12. Deploy to Production 
 13. Smoke Tests 
 14. Notify Slack/Email 

```

---

## Triggers

### Automatic Triggers
- **Push to `develop`** → Run CI + Auto-deploy to Staging
- **Push to `main`** → Run CI + Deploy to Production (with approval)
- **Pull Request** → Run CI (without deploy)
- **Tag `v*` (ej: v1.2.3)** → Release pipeline

### Manual Triggers
- Manual run via GitHub Actions UI
- Scheduled (cron): Daily security scan at 2am

---

## Stages Detallados

### Stage 1: Checkout & Setup
```yaml
- name: Checkout code
 uses: actions/checkout@v3

- name: Setup Node.js
 uses: actions/setup-node@v3
 with:
 node-version: '20'
 cache: 'npm'

- name: Install dependencies
 run: npm ci
```

**Duracion:** ~2 min
**Falla si:** Dependencias incompatibles, npm registry down

---

### Stage 2: Code Quality
```yaml
- name: Lint
 run: npm run lint

- name: Format check
 run: npm run format:check

- name: Type check
 run: npm run type-check
```

**Duracion:** ~1 min
**Falla si:** Lint errors, format violations, type errors

---

### Stage 3: Testing
```yaml
- name: Unit tests
 run: npm run test:unit

- name: Coverage check
 run: npm run test:coverage
 # Falla si coverage < 80%

- name: Integration tests
 run: npm run test:integration
 env:
 DATABASE_URL: postgres://test:test@localhost:5432/testdb
```

**Duracion:** ~5 min
**Falla si:** Tests fail, coverage < threshold

---

### Stage 4: Security Scanning
```yaml
- name: SAST - SonarQube
 run: sonar-scanner

- name: Dependency vulnerability check
 run: npm audit --audit-level=high

- name: Secret scanning
 uses: trufflesecurity/trufflehog@v3
```

**Duracion:** ~3 min
**Falla si:** Critical vulnerabilities found, secrets detected

---

### Stage 5: Build & Push
```yaml
- name: Build Docker image
 run: docker build -t backend:${{ github.sha }} .

- name: Tag image
 run: |
 docker tag backend:${{ github.sha }} backend:latest
 docker tag backend:${{ github.sha }} backend:${{ github.ref_name }}

- name: Push to registry
 run: docker push backend:${{ github.sha }}
```

**Duracion:** ~10 min
**Falla si:** Build errors, registry auth fails

---

### Stage 6: Deploy to Staging
```yaml
- name: Deploy to Staging
 run: |
 kubectl set image deployment/backend backend=backend:${{ github.sha }} -n staging
 kubectl rollout status deployment/backend -n staging --timeout=5m
```

**Duracion:** ~3 min
**Falla si:** Deployment timeout, health checks fail

---

### Stage 7: E2E Tests (Staging)
```yaml
- name: Run E2E tests against staging
 run: npm run test:e2e
 env:
 API_URL: https://staging.example.com
```

**Duracion:** ~10 min
**Falla si:** E2E tests fail

---

### Stage 8: Deploy to Production (Manual Approval)
```yaml
- name: Wait for approval
 uses: trstringer/manual-approval@v1
 with:
 approvers: tech-lead, devops-lead

- name: Deploy to Production
 run: |
 kubectl set image deployment/backend backend=backend:${{ github.sha }} -n production
 kubectl rollout status deployment/backend -n production --timeout=10m
```

**Duracion:** ~5 min (+ approval wait time)
**Falla si:** Approval denied, deployment fails

---

## Variables de Entorno & Secrets

### Variables de CI/CD
| Variable | Descripcion | Donde se define |
|----------|-------------|----------------|
| `NODE_ENV` | Ambiente (dev/staging/prod) | GitHub Secrets |
| `DATABASE_URL` | URL de base de datos | GitHub Secrets (por ambiente) |
| `DOCKER_REGISTRY` | URL del registry | GitHub Variables |
| `SLACK_WEBHOOK` | Webhook para notificaciones | GitHub Secrets |

### Como Añadir Secret
1. GitHub repo → Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Nombre: `DATABASE_URL`
4. Valor: `postgres://user:pass@host:5432/db`
5. Add secret

### Como Usar en Workflow
```yaml
env:
 DATABASE_URL: ${{ secrets.DATABASE_URL }}
```

---

## Rollback

### Rollback Automatico
Si deployment falla health checks, Kubernetes hace rollback automatico:
```bash
kubectl rollout undo deployment/backend -n production
```

### Rollback Manual
```bash
# Ver historial de deployments
kubectl rollout history deployment/backend -n production

# Rollback a revision anterior
kubectl rollout undo deployment/backend -n production

# Rollback a revision especifica
kubectl rollout undo deployment/backend -n production --to-revision=5
```

**Duracion:** ~2 min
**Validacion:** Health checks pasan, error rate normal

---

## Troubleshooting

### Problema: Tests fallan en CI pero pasan localmente
**Causas:**
- Diferencias en ambiente (Node version, OS)
- Tests dependen de estado local (archivos, DB)
- Race conditions en tests

**Solucion:**
```bash
# Reproducir ambiente de CI localmente con Docker
docker run -it node:20 bash
npm ci && npm test
```

---

### Problema: Deployment timeout
**Causas:**
- Imagen Docker muy grande (>1GB)
- Health checks fallan
- Recursos insuficientes (CPU/RAM)

**Solucion:**
```bash
# Ver logs de deployment
kubectl logs deployment/backend -n staging --tail=50

# Ver eventos
kubectl get events -n staging --sort-by=.metadata.creationTimestamp
```

---

### Problema: Security scan bloquea pipeline
**Causas:**
- Dependencia con vulnerabilidad critica
- Secret accidentalmente commiteado

**Solucion:**
```bash
# Ver vulnerabilidades
npm audit

# Fix automatico (si disponible)
npm audit fix

# Si no hay fix, evaluar risk y crear exception ticket
```

---

## Mejores Practicas

### [OK] DO
1. **Cachear dependencias** para reducir tiempo de build
2. **Paralelizar tests** cuando sea posible
3. **Fail fast:** Lint/tests primero antes de build
4. **Notificar fallos** inmediatamente a Slack
5. **Mantener pipeline rapido** (<15 min CI, <30 min CD)

### [ERROR] DON'T
1. **No commitear secrets** en codigo
2. **No deployar sin tests** pasando
3. **No deployar viernes tarde** (riesgo de weekend debugging)
4. **No skipear approval gate** en produccion

---

## Metricas del Pipeline

### KPIs a Trackear
- **Build time:** Target < 10 min
- **Deployment frequency:** Daily (dev team), Weekly (releases)
- **Lead time:** Commit → Production < 1 day
- **Change failure rate:** < 15%
- **MTTR (Mean Time To Repair):** < 1 hour

### Donde Ver Metricas
- GitHub Actions: Insights → Actions
- SonarQube: Quality Gates dashboard
- Grafana: CI/CD dashboard

---

## Runbooks

### Runbook: Deploy Hotfix a Produccion
```bash
# 1. Crear branch hotfix
git checkout -b hotfix/critical-bug main

# 2. Fix bug y commit
git commit -m "fix: critical bug in payment processing"

# 3. Push (triggerea CI)
git push origin hotfix/critical-bug

# 4. Esperar CI pass
# 5. Aprobar deployment a produccion en GitHub Actions UI
# 6. Validar en produccion
curl https://api.example.com/health

# 7. Merge a main tras validacion
git checkout main
git merge hotfix/critical-bug
git push origin main
```

---

### Runbook: Rollback Deployment
```bash
# Ver revision actual
kubectl get deployment backend -n production -o yaml | grep "image:"

# Rollback a revision anterior
kubectl rollout undo deployment/backend -n production

# Validar rollback
kubectl rollout status deployment/backend -n production
curl https://api.example.com/health
```

---

## Referencias

- **GitHub Actions Docs:** https://docs.github.com/en/actions
- **Kubernetes Deployments:** https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
- **DORA Metrics:** https://cloud.google.com/blog/products/devops-sre/using-the-four-keys-to-measure-your-devops-performance

---

**Ultima actualizacion:** 2025-11-18
**Version:** 1.0.0
EOF
```

**Resultado Esperado:** CI-CD.md creado

### Paso 3: Crear Diagramas (Opcional)

```bash
# Crear diagrama de pipeline en Mermaid
cat > /home/user/IACT/docs/backend/cicd/pipeline-diagram.mmd << 'EOF'
graph LR
 A[Git Push] --> B[Checkout]
 B --> C[Install Deps]
 C --> D[Lint]
 D --> E[Tests]
 E --> F[Security Scan]
 F --> G[Build Docker]
 G --> H[Push Registry]
 H --> I[Deploy Staging]
 I --> J[E2E Tests]
 J --> K{Approval}
 K -->|Yes| L[Deploy Prod]
 K -->|No| M[Cancel]
 L --> N[Smoke Tests]
 N --> O[Notify Success]
EOF
```

---

## Criterios de Exito

- [ ] CI-CD.md creado en docs/backend/cicd/
- [ ] Diagrama de arquitectura del pipeline
- [ ] Todos los stages documentados (8+ stages)
- [ ] Triggers documentados
- [ ] Variables y secrets explicados
- [ ] Runbooks de rollback incluidos
- [ ] Troubleshooting de problemas comunes (3+ problemas)
- [ ] Mejores practicas DO/DON'T
- [ ] Metricas y KPIs definidos
- [ ] 2+ runbooks ejecutables
- [ ] Validacion con Self-Consistency desde 4 perspectivas completada

---

## Validacion

```bash
# Verificar archivo existe
ls -lh /home/user/IACT/docs/backend/cicd/CI-CD.md

# Verificar estructura
grep "^## " /home/user/IACT/docs/backend/cicd/CI-CD.md

# Contar stages documentados
grep "^### Stage" /home/user/IACT/docs/backend/cicd/CI-CD.md | wc -l

# Verificar runbooks
grep "^### Runbook:" /home/user/IACT/docs/backend/cicd/CI-CD.md
```

---

## Riesgos

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|-----------|
| Documentacion desactualizada | ALTA | MEDIO | Vincular a codigo fuente (YAML), revision trimestral |
| Pipeline cambia sin actualizar docs | MEDIA | ALTO | Requerir actualizacion de docs en PR que modifique pipeline |

---

## Notas

- La documentacion CI/CD debe mantenerse sincronizada con archivos YAML
- Usar Auto-CoT para razonar sobre stages criticos
- Validar con Self-Consistency: DevOps, Dev, QA, Security
- Los runbooks deben ser **ejecutables y testeados**
- Incluir diagramas visuales para facilitar comprension

---

## Tiempo de Ejecucion

**Inicio:** __:__
**Fin:** __:__
**Duracion Real:** __ minutos

---

## Checklist de Finalizacion

- [ ] CI-CD.md creado con documentacion completa
- [ ] Diagrama de pipeline incluido
- [ ] 8+ stages documentados
- [ ] Triggers documentados
- [ ] Variables y secrets
- [ ] Runbooks de rollback
- [ ] 3+ problemas de troubleshooting
- [ ] Mejores practicas
- [ ] Metricas y KPIs
- [ ] 2+ runbooks ejecutables
- [ ] Validacion Self-Consistency completada
- [ ] Tarea marcada como COMPLETADA en INDICE.md

---

**Tarea creada:** 2025-11-18
**Version:** 1.0.0
**Estado:** PENDIENTE
