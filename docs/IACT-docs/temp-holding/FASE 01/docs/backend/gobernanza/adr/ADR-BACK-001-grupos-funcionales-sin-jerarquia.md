---
id: ADR-BACK-001-grupos-funcionales-sin-jerarquia
estado: aceptada
propietario: equipo-backend
ultima_actualizacion: 2025-11-18
relacionados:
 - docs/backend/permisos/arquitectura_permisos_granular.md
 - docs/backend/requisitos/INDICE_MAESTRO_PERMISOS_GRANULAR.md
 - ADR-BACK-003-orm-sql-hybrid-permissions
 - ADR-BACK-005-middleware-decoradores-permisos
tags: [permisos, arquitectura, backend, seguridad]
date: 2025-11-18
---

# ADR-BACK-001: Sistema de Permisos con Grupos Funcionales Sin Jerarquía

**Estado:** Aceptada

**Fecha:** 2025-11-18

**Decisores:** equipo-backend, equipo-ba, arquitecto-principal

**Contexto técnico:** Backend - Sistema de Permisos

---

## Contexto y Problema

El sistema IACT requiere un modelo de permisos granulares para controlar el acceso a recursos y acciones. El sistema debe soportar:

1. **Múltiples módulos:** 19 funciones diferentes (usuarios, dashboards, llamadas IVR, tickets, reportes, etc.)
2. **130+ capacidades:** Acciones específicas sobre recursos
3. **Flexibilidad organizacional:** Diferentes usuarios con combinaciones únicas de permisos
4. **Sin jerarquías rígidas:** Evitar etiquetas como "Admin", "Supervisor", "Agente" que crean barreras artificiales

**Preguntas clave:**
- ¿Cómo organizamos 130+ capacidades de forma manejable?
- ¿Cómo evitamos la explosión combinatoria de "roles"?
- ¿Cómo permitimos flexibilidad sin complejidad excesiva?
- ¿Cómo mantenemos la claridad sobre "quién puede hacer qué"?

**Restricciones actuales:**
- Base de datos PostgreSQL
- Django backend con modelos in-memory para performance
- Necesidad de auditoría completa (ISO 27001)
- Sistema debe integrarse con Django REST Framework

**Impacto del problema:**
- Sin organización clara, 130+ capacidades son inmanejables
- Roles tradicionales son rígidos y no se adaptan a la realidad operativa
- Jerarquías crean barreras artificiales entre equipos
- Dificulta onboarding de nuevos usuarios

---

## Factores de Decisión

- **Flexibilidad:** Usuarios deben poder tener combinaciones únicas de permisos
- **Claridad:** Debe ser obvio QUÉ puede hacer cada usuario
- **Escalabilidad:** Diseño debe soportar crecimiento a 200+ capacidades
- **Mantenibilidad:** Fácil agregar nuevos permisos sin reestructurar todo
- **Experiencia de Usuario:** Nomenclatura humana, no técnica
- **Seguridad:** Auditoría completa, sin gaps de permisos
- **Performance:** Evaluación de permisos < 50ms (p95)
- **Sin Jerarquías:** No crear barreras artificiales entre usuarios

---

## Opciones Consideradas

### Opción 1: RBAC Tradicional (Role-Based Access Control)

**Descripción:**
Sistema clásico de roles jerárquicos: Admin > Manager > Supervisor > Agent. Cada rol tiene permisos fijos.

**Pros:**
- OK Estándar de industria, bien entendido
- OK Frameworks existentes (Django Groups, etc.)
- OK Fácil de implementar inicialmente
- OK Menos tablas en base de datos

**Contras:**
- NO Jerarquías rígidas no se adaptan a la realidad
- NO Explosión de roles cuando crecen los permisos
- NO Un usuario = un rol (inflexible)
- NO Nomenclatura pretenciosa ("Admin", "Supervisor")
- NO Dificulta cambios organizacionales

**Ejemplo/Implementación:**
```python
# Usuario tiene UN rol
usuario.rol = "SUPERVISOR"

# Permisos fijos del rol
if usuario.rol == "SUPERVISOR":
 permisos = ["ver_todo", "editar_equipo", "aprobar_tickets"]
```

**Razón del rechazo:**
No permite la flexibilidad necesaria. En la práctica, necesitamos usuarios con permisos mixtos (ej: "Coordinador que también hace atención al cliente").

---

### Opción 2: ABAC (Attribute-Based Access Control)

**Descripción:**
Sistema basado en atributos y reglas dinámicas. Permisos se evalúan en runtime basándose en contexto (hora, ubicación, atributos del usuario, etc.).

**Pros:**
- OK Máxima flexibilidad
- OK Permisos contextuales (ej: "solo entre 9am-5pm")
- OK Se adapta a cualquier escenario
- OK Muy granular

**Contras:**
- NO Complejidad extrema de implementación
- NO Performance impact (evaluación en runtime)
- NO Difícil de debuggear
- NO Curva de aprendizaje alta
- NO Overkill para nuestras necesidades
- NO Difícil auditar "quién tiene qué permiso"

**Ejemplo/Implementación:**
```python
# Regla dinámica
def puede_aprobar_pago(usuario, pago, contexto):
 return (
 usuario.departamento == "finanzas" and
 pago.monto < usuario.limite_aprobacion and
 contexto.hora_actual.hour >= 9 and
 contexto.hora_actual.hour <= 17 and
 not contexto.es_feriado
 )
```

**Razón del rechazo:**
Demasiado complejo para nuestras necesidades actuales. La mayoría de nuestros permisos son estáticos, no contextuales.

---

### Opción 3: ACL (Access Control Lists)

**Descripción:**
Permisos granulares a nivel individual por usuario y recurso.

**Pros:**
- OK Máxima granularidad
- OK Control preciso por usuario

**Contras:**
- NO Demasiado granular (permisos por usuario por recurso)
- NO Difícil de mantener
- NO No reusable (cada usuario tiene su propia ACL)
- NO No escala bien con 100+ usuarios

**Razón del rechazo:**
Demasiado granular a nivel individual. No proporciona agrupaciones lógicas que faciliten la gestión.

---

### Opción 4: Grupos Funcionales Sin Jerarquía (ELEGIDA)

**Descripción:**
Sistema de "grupos de permisos" descriptivos que se pueden combinar libremente. No hay jerarquía entre grupos. Un usuario puede tener múltiples grupos simultáneamente.

**Conceptos clave:**
- **Funciones:** Recursos del sistema (dashboards, usuarios, tickets, etc.)
- **Capacidades:** Acciones sobre recursos (ver, crear, editar, eliminar)
- **Grupos:** Colecciones de capacidades con nombres descriptivos
- **Usuarios:** Pueden tener N grupos simultáneos

**Pros:**
- OK Flexibilidad total: N grupos por usuario
- OK Nomenclatura descriptiva: "Atención al Cliente", "Gestión de Equipos"
- OK Sin jerarquías: todos los grupos son iguales
- OK Escalable: fácil agregar nuevos grupos
- OK Claro: se ve inmediatamente qué puede hacer cada usuario
- OK Mantenible: grupos modulares, no monolíticos
- OK Performance: evaluación simple con vistas SQL
- OK Reusable: grupos se asignan a múltiples usuarios

**Contras:**
- NO Más tablas en base de datos (8 tablas)
- NO Requiere UI para gestión de grupos
- NO Posible confusión inicial (no es RBAC tradicional)
- NO Requiere definir bien los grupos iniciales

**Ejemplo/Implementación:**
```python
# Usuario tiene MÚLTIPLES grupos
usuario.grupos = [
 "atencion_cliente",
 "gestion_equipos",
 "analisis_operativo"
]

# Permisos = UNION de todos los grupos
permisos = []
for grupo in usuario.grupos:
 permisos.extend(grupo.capacidades)

# Verificación simple
if "sistema.operaciones.tickets.crear" in permisos:
 crear_ticket()
```

**Estructura de Base de Datos:**
```
funciones (19 recursos)
 ↓
capacidades (~130 acciones)
 ↓
grupos_permisos (17+ grupos descriptivos)
 ↓
usuarios_grupos (N:M - múltiples grupos por usuario)
```

**Ejemplos de Grupos:**
- `atencion_cliente` - Operaciones básicas de call center
- `gestion_equipos` - Administración de equipos
- `analisis_operativo` - Métricas y reportes
- `auditoria_llamadas` - Evaluación de calidad
- `gestion_pagos` - Procesamiento financiero

---

## Decisión

**Opción elegida:** "Grupos Funcionales Sin Jerarquía"

**Justificación:**

1. **Flexibilidad real:** Usuarios pueden tener combinaciones únicas de permisos según sus necesidades reales, no forzadas por roles rígidos.

2. **Claridad y experiencia humana:** Nombres descriptivos ("Gestión de Equipos") en lugar de etiquetas jerárquicas ("Supervisor Nivel 2").

3. **Escalabilidad probada:** Fácil agregar nuevos grupos sin afectar existentes. Sistema crece de forma modular.

4. **Sin barreras artificiales:** No hay jerarquía entre grupos. Todos son iguales, solo agrupan capacidades diferentes.

5. **Balance complejidad/beneficio:** Más simple que ABAC, más flexible que RBAC tradicional.

6. **Compatible con Django:** Extiende el sistema de permisos de Django sin romper convenciones.

**Trade-offs aceptados:**
- Más tablas en BD (8 en lugar de 3-4 de RBAC tradicional)
- Requiere UI de gestión de grupos (pero necesitaríamos UI de todas formas)
- No hay jerarquía (pero esto es el objetivo, no un contra)

---

## Consecuencias

### Positivas

- OK Flexibilidad total: Usuarios con permisos exactos que necesitan
- OK Sin etiquetas jerárquicas: Elimina barreras organizacionales artificiales
- OK Escalable: Fácil agregar módulos nuevos (pagos, facturación, etc.)
- OK Mantenible: Grupos modulares, cambios localizados
- OK Auditable: Vista SQL consolidada de permisos efectivos
- OK Performance: Evaluación < 50ms con índices apropiados
- OK Experiencia mejorada: Nomenclatura clara y descriptiva
- OK Reusable: Grupos se asignan a múltiples usuarios sin duplicación

### Negativas

- WARNING Complejidad inicial: Requiere definir bien los 17+ grupos iniciales
- WARNING UI necesaria: No se puede gestionar manualmente con SQL fácilmente
- WARNING Curva de aprendizaje: Equipo debe entender el modelo nuevo
- WARNING Migración: Si hay sistema previo, requiere migración de datos
- WARNING Más tablas: 8 tablas principales vs 3-4 de RBAC tradicional

### Neutrales

- INFO No es estándar: No es RBAC puro ni ABAC, es híbrido
- INFO Documentación custom: Necesitamos documentar bien el modelo
- INFO Tests necesarios: Requiere test suite completo de permisos

---

## Plan de Implementación

1. **Fase 1: Estructura Base**
 - Crear 8 tablas principales en PostgreSQL
 - Crear vistas auxiliares (vista_capacidades_usuario, vista_grupos_usuario)
 - Crear función usuario_tiene_permiso()
 - Insertar datos de prueba
 - Validar estructura con queries de verificación
 - Timeframe: 1 semana

2. **Fase 2: Funciones Core**
 - Insertar 3 funciones core (usuarios, dashboards, configuración)
 - Definir 16 capacidades core
 - Crear 3 grupos iniciales
 - Implementar PermissionService en Django
 - Crear endpoints API básicos
 - Timeframe: 1 semana

3. **Fase 3: Módulos Operativos**
 - Insertar 6 módulos operativos
 - Definir ~50 capacidades operativas
 - Crear 3 grupos operativos
 - Integrar con módulos Django existentes
 - Timeframe: 2 semanas

4. **Fase 4: Módulos de Gestión y Finanzas**
 - Crear módulos nuevos (equipos, horarios, evaluaciones)
 - Crear módulos financieros (pagos, facturas, cobranza)
 - Definir ~50 capacidades adicionales
 - Crear 8 grupos adicionales
 - Timeframe: 2 semanas

5. **Fase 5: Finalización**
 - Crear módulos estratégicos
 - UI de gestión de grupos
 - Testing completo
 - Documentación de usuario
 - Capacitación
 - Go-live
 - Timeframe: 5 semanas

**Total:** 11 semanas (~2.5 meses)

---

## Validación y Métricas

**Criterios de Éxito:**
- Performance: Evaluación de permisos < 50ms (p95)
- Cobertura: 100% de funcionalidades cubiertas con permisos
- Flexibilidad: 80%+ de usuarios tienen combinaciones únicas de grupos
- Claridad: Encuesta post-implementación > 4/5 en "entiendo mis permisos"
- Escalabilidad: Agregar nuevo módulo < 2 días de trabajo

**Cómo medir:**
- `SELECT AVG(query_time) FROM pg_stat_statements WHERE query LIKE '%usuario_tiene_permiso%'`
- Análisis de combinaciones de grupos en producción
- Encuesta de usuario post-capacitación
- Tiempo de implementación de nuevos módulos

**Revisión:**
- Fecha de revisión programada: 2026-02-18 (3 meses post-implementación)
- Responsable de seguimiento: equipo-backend

---

## Alternativas Descartadas

### Hybrid RBAC + ACL

**Por qué se descartó:**
- Complejidad de tener dos sistemas simultáneos
- Confusión sobre cuál usar cuándo
- Mantenimiento de dos modelos

---

## Referencias

- [Documentación Arquitectura Permisos](../../permisos/arquitectura_permisos_granular.md)
- [Índice Maestro Permisos](../../requisitos/INDICE_MAESTRO_PERMISOS_GRANULAR.md)
- [ISO/IEC/IEEE 29148:2018 - Requirements Engineering](https://www.iso.org/standard/72089.html)
- [OWASP ASVS - Authentication and Access Control](https://owasp.org/www-project-application-security-verification-standard/)
- [NIST RBAC Model](https://csrc.nist.gov/projects/role-based-access-control)
- [PostgreSQL Row Security Policies](https://www.postgresql.org/docs/current/ddl-rowsecurity.html)
- [Django Permission System](https://docs.djangoproject.com/en/stable/topics/auth/default/)

---

## Notas Adicionales

- **Fecha de discusión inicial:** 2025-11-04
- **Participantes:** equipo-backend (3 personas), equipo-ba (1 persona), arquitecto-principal
- **Experimentos realizados:**
 - POC con Django Groups tradicionales (rechazado por inflexibilidad)
 - POC con django-guardian (rechazado por complejidad object-level)
 - Benchmark de performance: 3 niveles de evaluación < 10ms
- **Decisiones relacionadas:**
 - ADR-BACK-002: Sistema de Configuración Dinámica
 - ADR-BACK-003: Estrategia Híbrida ORM + SQL
 - ADR-BACK-005: Middleware y Decoradores para Permisos

---

**Documento:** ADR-BACK-001
**Fecha:** 18 de Noviembre, 2025
**Estado:** Aceptada
**Próxima revisión:** 2026-02-18
