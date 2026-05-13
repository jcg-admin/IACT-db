---
id: TASK-REORG-BACK-051
tipo: tarea
categoria: varios
titulo: Crear Referencias Tecnicas
fase: FASE_3
prioridad: MEDIA
duracion_estimada: 20min
estado: pendiente
dependencias: []
---

# TASK-REORG-BACK-051: Crear Referencias Tecnicas

**Fase:** FASE 3 - Documentacion Varia
**Prioridad:** MEDIA
**Duracion Estimada:** 20 minutos
**Responsable:** Tech Writer / Tech Lead
**Estado:** PENDIENTE

---

## Objetivo

Crear documento de referencias tecnicas (REFERENCIAS.md) con enlaces a documentacion oficial, libros, articulos, cursos y recursos externos relevantes para el desarrollo backend.

---

## Pasos de Ejecucion

### Paso 1: Crear REFERENCIAS.md

```bash
mkdir -p /home/user/IACT/docs/backend/recursos

cat > /home/user/IACT/docs/backend/recursos/REFERENCIAS.md << 'EOF'
# Referencias Tecnicas - Backend

Recursos externos para desarrollo backend.

---

## Documentacion Oficial

### Frameworks & Runtime
- [Node.js Docs](https://nodejs.org/docs/)
- [NestJS Docs](https://docs.nestjs.com/)
- [Express.js Docs](https://expressjs.com/)
- [Python Docs](https://docs.python.org/)
- [FastAPI Docs](https://fastapi.tiangolo.com/)

### Databases
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [MongoDB Docs](https://www.mongodb.com/docs/)
- [Redis Docs](https://redis.io/docs/)

### Cloud & Infrastructure
- [AWS Docs](https://docs.aws.amazon.com/)
- [Kubernetes Docs](https://kubernetes.io/docs/)
- [Docker Docs](https://docs.docker.com/)
- [Terraform Docs](https://www.terraform.io/docs)

---

## Libros Recomendados

### Arquitectura
- **"Clean Architecture"** - Robert C. Martin
- **"Building Microservices"** - Sam Newman
- **"Domain-Driven Design"** - Eric Evans

### Testing
- **"Test Driven Development: By Example"** - Kent Beck
- **"The Art of Unit Testing"** - Roy Osherove
- **"Working Effectively with Legacy Code"** - Michael Feathers

### DevOps & SRE
- **"The Phoenix Project"** - Gene Kim
- **"Site Reliability Engineering"** - Google SRE Team
- **"Accelerate"** - Nicole Forsgren

---

## Articulos y Blogs

### Arquitectura
- [Martin Fowler's Blog](https://martinfowler.com/)
- [The Twelve-Factor App](https://12factor.net/)
- [Clean Code Blog](https://blog.cleancoder.com/)

### Performance
- [High Scalability](http://highscalability.com/)
- [Netflix Tech Blog](https://netflixtechblog.com/)

---

## Cursos Online

### Udemy
- "Node.js: The Complete Guide" - Maximilian Schwarzmuller
- "Microservices with Node.js and React" - Stephen Grider

### Pluralsight
- "Node.js Path"
- "Kubernetes Path"

---

## Herramientas & Utilidades

### Code Quality
- [SonarQube](https://www.sonarqube.org/)
- [ESLint](https://eslint.org/)
- [Prettier](https://prettier.io/)

### Testing
- [Jest](https://jestjs.io/)
- [Vitest](https://vitest.dev/)
- [Playwright](https://playwright.dev/)

---

**Ultima actualizacion:** 2025-11-18
EOF
```

**Resultado Esperado:** REFERENCIAS.md creado

---

## Criterios de Exito

- [ ] REFERENCIAS.md creado en docs/backend/recursos/
- [ ] Documentacion oficial de frameworks
- [ ] Libros recomendados por categoria
- [ ] Articulos y blogs relevantes
- [ ] Cursos online sugeridos
- [ ] Herramientas listadas

---

**Tarea creada:** 2025-11-18
**Estado:** PENDIENTE
