---
id: RNF-001
tipo: no_funcional
titulo: Tiempo de respuesta login menor 2 segundos (P95)
dominio: backend
owner: equipo-backend
prioridad: alta
estado: aprobado
fecha_creacion: 2025-11-06
trazabilidad_upward: [N-001, RN-001, RS-002]
trazabilidad_downward: [TEST-RNF-001-performance]
stakeholders: [usuarios-finales-agentes]
iso29148_clause: "9.6.5"
verificacion_metodo: test
categoria: performance
modulo: authentication
date: 2025-11-13
---

# RNF-001: Tiempo de respuesta login menor 2 segundos

## 1. Declaracion del Requisito

**El sistema DEBERA** procesar solicitudes de login (POST /api/v1/auth/login) en menos de 2 segundos **medido** en el percentil 95 **bajo** condiciones de carga normal (50 usuarios concurrentes).

## 2. Criterios de Aceptacion

```gherkin
Given el sistema bajo carga normal (50 usuarios concurrentes)
When se ejecutan 1000 requests de login en 1 hora
Then el percentil 95 (P95) de tiempo de respuesta es menor a 2000ms
 And el percentil 50 (P50 - mediana) es menor a 1000ms
 And el percentil 99 (P99) es menor a 3000ms
 And la tasa de exito es mayor a 99.5%
```

## 3. Medicion

- **Metrica**: Tiempo desde POST request hasta HTTP 200 response
- **Tool**: APM monitoring + load testing con JMeter
- **Frecuencia**: Weekly performance tests
- **Baseline**: Login actual toma 4-6 segundos (P95)
- **Target**: Login nuevo debe tomar menor 2 segundos (P95)

## 4. Trazabilidad

**Upward:** Deriva de RS-002 (usuarios requieren acceso rapido menor 2 segundos)

**Downward:** Genera tests de performance TEST-RNF-001

---

Control de Cambios: v1.0 | 2025-11-06 | BA Team | Creacion inicial
