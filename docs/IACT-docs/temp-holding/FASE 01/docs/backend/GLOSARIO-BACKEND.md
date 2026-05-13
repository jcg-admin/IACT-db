---
id: GLOSARIO-BACKEND-001
tipo: referencia
categoria: glosario
version: 1.0.0
fecha_creacion: 2025-11-18
---

# Glosario Backend

Términos y conceptos clave del backend.

---

## A

**ADR (Architecture Decision Record)**
: Documento que captura una decisión arquitectónica importante junto con su contexto y consecuencias.

**API (Application Programming Interface)**
: Interfaz de programación de aplicaciones. En este proyecto principalmente REST APIs con Django REST Framework.

**APScheduler**
: Librería Python para programar tareas (cron jobs). Usado para tareas programadas en el backend.

---

## B

**Backend**
: Capa del servidor que maneja lógica de negocio, acceso a datos y APIs. En este proyecto basado en Django.

**Bounded Context**
: Límite explícito dentro del cual un modelo de dominio es definido y aplicable. Concepto de DDD.

---

## C

**Clean Architecture**
: Arquitectura en capas donde las dependencias fluyen hacia el centro (business logic).

**Coverage (Cobertura de Tests)**
: Porcentaje de código ejecutado por los tests. Meta: 80%+.

---

## D

**Django**
: Framework web Python usado en este proyecto (versión 5.x).

**DRF (Django REST Framework)**
: Framework para construir APIs REST sobre Django.

**DTOData Transfer Object)**
: Objeto usado para transferir datos entre capas o sistemas.

---

## E

**ETL (Extract, Transform, Load)**
: Proceso de extraer datos de fuentes, transformarlos y cargarlos en destino.

---

## F

**Fixture**
: Datos de prueba predefinidos para tests.

---

## M

**Migration**
: Archivo que define cambios en el esquema de base de datos. Django migrations.

**Model**
: Clase que representa una tabla de base de datos en Django ORM.

---

## O

**ORM (Object-Relational Mapping)**
: Técnica para mapear objetos a tablas de base de datos. Django ORM.

---

## P

**Permissions Granulares**
: Sistema de permisos detallados a nivel de objeto/recurso. No jerárquicos.

**pytest**
: Framework de testing Python usado en el proyecto.

---

## R

**Repository Pattern**
: Patrón que abstrae el acceso a datos.

**REST (Representational State Transfer)**
: Estilo arquitectónico para APIs web.

**Runbook**
: Documento con procedimientos operacionales paso a paso.

---

## S

**Serializer**
: Clase DRF que convierte modelos Django a/desde JSON.

**Service Layer**
: Capa que contiene lógica de negocio. Entre presentación y datos.

---

## T

**TDD (Test-Driven Development)**
: Metodología donde se escriben tests antes del código.

---

## V

**ViewSet**
: Clase DRF que agrupa lógica relacionada de API views.

---

**Última actualización:** 2025-11-18
