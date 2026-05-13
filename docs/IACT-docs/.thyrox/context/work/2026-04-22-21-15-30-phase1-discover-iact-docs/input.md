```yml
type: Análisis Input
version: 1.0
created_at: 2026-04-22 21:15:30
project: IACT-docs
work_package: 2026-04-22-21-15-30-phase1-discover-iact-docs
phase: Phase 1 — DISCOVER
author: claude (orquestador)
status: input preparation
notes: Contenido VERBATIM preservado sin comprimir — claims técnicos, conclusiones, código completo
```

# IACT Documentación — Input para Análisis Adversarial Phase 1 DISCOVER

## Definición de Proyecto

**Nombre:** IACT - Sistema de Dashboard Analytics

**Descripción oficial (index.rst):**
El proyecto IACT es una solución de **Dashboard Analytics** que conecta datos operativos con necesidades de análisis de negocio mediante un proceso ETL robusto y trazable.

**Arquitectura técnica declarada:**
- Backend: Django + Django REST Framework (API REST)
- Frontend: React (Dashboard), compilado con Webpack
- Fuente de Datos: MySQL (operativa, solo lectura)
- Destino Analítico: PostgreSQL (optimizado para consultas analíticas)
- Proceso: ETL robusto y trazable

**Modelo Documental:**
Sigue el "Modelo Documental IACT v2.0.0", organizado en 5 Dominios Primarios que gobiernan 21 Subdominios especializados.

---

## Dominio 1: Base Cognitiva

**Propósito declarado:** Fundamentos conceptuales, ontología, glosarios, taxonomías.

**Contenido:**
- Ontología SBVR (Semantic Business Vocabulary and Business Rules)
- Glosario IACT v1.0.0
- Glosario comparativo BABOK/PMBOK/ISO
- Metadata y taxonomías
- Fundamentos conceptuales

**Claim verificable:** "El proyecto IACT utiliza SBVR como base ontológica para definición de términos y reglas de negocio."

---

## Dominio 2: Normativa

**Propósito declarado:** Estándares, gobernanza, procedimientos.

**Contenido cuantificado:**
- Estándares (documentados)
- Gobernanza (documentada)
- Procedimientos (documentados)
- Restricciones (documentadas)

**Tamaño:** 1.9 MB (el mayor dominio por volumen)

**Claim de cobertura:** "El dominio normativa contiene estándares, gobernanza y procedimientos que rigen la operación del sistema IACT."

---

## Dominio 3: Requisitos

**Propósito declarado:** Funcionales, no-funcionales, casos de uso, objetivos, reglas de negocio, matriz de trazabilidad.

**Subdominios:**
1. Requisitos funcionales (documentados)
2. Requisitos no-funcionales (documentados)
3. Casos de uso (documentados)
4. Objetivos (documentados)
5. Reglas de negocio (documentados)
6. RTM (Requirements Traceability Matrix)

**Tamaño:** 1.1 MB

**Claim de completitud:** "Los requisitos funcionales, no-funcionales y casos de uso están documentados y trazables."

---

## Dominio 4: Arquitectura Técnica

**Propósito declarado:** Diseño general, despliegue, detalles de implementación.

**Subdominios:**
1. Arquitectura general (diseño)
2. Despliegue (infraestructura)
3. Diseño detallado (componentes específicos)

**Stack técnico declarado:**
- Backend: Django + Django REST Framework (API REST)
- Frontend: React (Dashboard)
- Build/bundler Frontend: Webpack
- Base de datos origen: MySQL (lectura, operativa)
- Base de datos destino: PostgreSQL (escritura analítica)
- Proceso: ETL (Extract-Transform-Load)

**Claim de robustez:** "El proceso ETL es robusto y trazable."

---

## Dominio 5: Gestión

**Propósito declarado:** Project Management, evidencia, plantillas ADR, manuales de usuario.

**Contenido:**
- PM (Project Management documentado)
- Evidencia (registrada)
- Plantillas ADR (Architecture Decision Records)
- Manuales usuario (documentados)

**Tamaño:** 53 KB

---

## Metadatos del Sistema Documentario

**Versión documentada:** 1.0.0

**Fecha:** 2025

**Equipo:** IACT Development Team

**Herramienta:** Sphinx (RST — reStructuredText)

**Estructura:** 
- Configuración: conf.py
- Plantillas HTML: base.html, page.html
- Assets estáticos: CSS, JavaScript, imágenes

---

## Claims Principales a Validar

1. **"IACT es una solución de Dashboard Analytics"** — Claim de categorización funcional
2. **"Conecta datos operativos con necesidades de análisis de negocio"** — Claim de purpose
3. **"Mediante un proceso ETL robusto y trazable"** — Claim de calidad técnica
4. **"5 Dominios Primarios gobiernan 21 Subdominios"** — Claim de estructura documentaria
5. **"Modelo Documental IACT v2.0.0"** — Claim de estándar documentario
6. **"Requisitos funcionales, no-funcionales y casos de uso están documentados y trazables"** — Claim de completitud

---

## Notas para el análisis adversarial

- Verificar si los 5 dominios realmente gobiernan 21 subdominios (contar)
- Validar que "ETL robusto y trazable" tiene definición operacional
- Revisar coherencia entre claims en diferentes dominios
- Detectar gaps entre "declarado" (index.rst) y "documentado" (contenido real)
- Verificar si los claims técnicos (MySQL, PostgreSQL, Django, React) están fundamentados en la arquitectura
- Revisar si hay contradicciones entre versiones (v1.0.0 vs v2.0.0)

---

## Metadata de este input

**Preparación:** Orquestador preservó verbatim: definiciones de proyecto, claims técnicos, estructura de dominios, metadata del sistema.

**NO comprimido:** Información técnica específica, números cuantitativos, claims de calidad, nombres de herramientas.

**Proporción:** ~30% del contenido total (seleccionado por relevancia Phase 1, preservando integridad de claims)
