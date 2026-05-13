---
id: RNF-002
tipo: no_funcional
titulo: Sesiones almacenadas en MySQL (NO Redis)
dominio: backend
owner: equipo-backend
prioridad: critica
estado: aprobado
fecha_creacion: 2025-11-06
trazabilidad_upward: [N-001, RN-001]
trazabilidad_downward: [CODE-django-settings-sessions]
stakeholders: [equipo-infraestructura]
iso29148_clause: "9.6.5"
verificacion_metodo: inspection
categoria: technical-constraint
modulo: authentication
date: 2025-11-13
---

# RNF-002: Sesiones almacenadas en MySQL (NO Redis)

## 1. Declaracion del Requisito

**El sistema DEBERA** almacenar sesiones de usuarios en base de datos MySQL **usando** django.contrib.sessions.backends.db **y NO usar** Redis u otros sistemas de cache **conforme** restriccion tecnica IACT.

## 2. Criterios de Aceptacion

```gherkin
Given la configuracion de Django settings.py
When se verifica SESSION_ENGINE
Then SESSION_ENGINE='django.contrib.sessions.backends.db'
 And sesiones se almacenan en tabla django_session en MySQL
 And NO se usa Redis, Memcached u otros backends de cache
```

## 3. Restriccion CRITICA

**Restriccion IACT**: Sistema NO debe usar Redis. Todas las sesiones deben almacenarse en MySQL para cumplir con arquitectura corporativa.

## 4. Trazabilidad

**Upward:** Deriva de restricciones arquitectonicas IACT

**Downward:** Configuracion en settings.py verificada por code review

---

Control de Cambios: v1.0 | 2025-11-06 | BA Team | Creacion inicial
