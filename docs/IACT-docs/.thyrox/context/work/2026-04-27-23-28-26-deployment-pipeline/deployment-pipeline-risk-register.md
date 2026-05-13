```yml
project: IACT-docs
work_package: 2026-04-27-23-28-26-deployment-pipeline
created_at: 2026-04-27 23:28:26
updated_at: 2026-04-27 23:28:26
current_phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
```

# Risk Register — deployment-pipeline

| ID | Riesgo | Prob | Impacto | Mitigación | Estado |
|----|--------|------|---------|------------|--------|
| R-01 | Pipeline deploya a producción contenido roto antes de detectarlo | M | A | Gate CI con `sphinx-build -W` (warnings = error); deploy a staging primero; smoke test post-deploy | Abierto |
| R-02 | Pérdida del estado actual de producción al deployar versión nueva | A | A | Backup automático antes de overwrite; nombrar backup con timestamp; conservar 7 días | Abierto |
| R-03 | Health-check post-deploy falla y el servidor queda en estado inconsistente | M | A | Rollback automático ejecutando `mv backup-latest path` en falla del health-check | Abierto |
| R-04 | SSH keys filtradas en logs/secrets si se manejan mal | B | C | Usar GitHub Secrets, nunca hardcoded; rotación periódica documentada | Abierto |
| R-05 | Deploy a staging no representa producción → sorpresas en prod | M | M | Servidor staging idéntico a prod (misma versión Apache, mismo Python); deploy a staging obligatorio antes de prod | Abierto |
| R-06 | Eliminar `build/` del repo antes de tener pipeline rompe el acceso actual a docs | A | A | NO eliminar `build/` histórico hasta que el pipeline esté operativo y se valide acceso vía nueva URL | Abierto |
| R-07 | Push a `main` por error inicia deploy a producción sin validación | M | A | Tag-based deploy (`v*` triggers), no branch-based para producción; environment con manual approval en GitHub | Abierto |
| R-08 | Pipeline depende de un solo SSH host → SPOF si servidor cae | M | M | Documentar fallback manual (rsync desde laptop con misma key); 2da SSH key de backup | Abierto |
| R-09 | El usuario actual (Néstor) desconoce qué proceso se sigue HOY para entregar docs | A | M | Phase 1 DISCOVER documenta el proceso actual con fidelidad antes de proponer reemplazo | Abierto |
| R-10 | El servidor on-premise no tiene salida a Internet → CI no puede SSH directo | M | A | Self-hosted GitHub Actions runner dentro de la red corporativa; o jump host | Abierto |
