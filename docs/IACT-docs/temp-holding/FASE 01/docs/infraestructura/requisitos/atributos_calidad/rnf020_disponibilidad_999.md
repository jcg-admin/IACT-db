---
id: RNF-020
tipo: no_funcional
titulo: Disponibilidad del sistema 99.9% uptime
dominio: infraestructura
owner: equipo-infraestructura
prioridad: alta
estado: aprobado
fecha_creacion: 2025-11-06
trazabilidad_upward: [RN-001]
trazabilidad_downward: [MONITOR-uptime]
stakeholders: [usuarios-finales, gerente-operaciones]
iso29148_clause: "9.6.5"
verificacion_metodo: analysis
categoria: availability
modulo: infraestructura
---

# RNF-020: Disponibilidad 99.9% uptime

## 1. Declaracion del Requisito

**El sistema DEBERA** mantener disponibilidad de 99.9% uptime **medido** mensualmente **excluyendo** mantenimientos programados.

## 2. Criterios de Aceptacion

```gherkin
Given el sistema en produccion durante 1 mes (30 dias = 43200 minutos)
When se mide uptime mensual
Then uptime es mayor o igual a 99.9%
  And tiempo maximo de downtime no programado es menor a 43 minutos/mes
  And mantenimientos programados NO cuentan como downtime
```

## 3. Trazabilidad

**Upward:** Deriva de RN-001 (sistema disponible para usuarios)

---

Control de Cambios: v1.0 | 2025-11-06 | BA Team | Creacion inicial
