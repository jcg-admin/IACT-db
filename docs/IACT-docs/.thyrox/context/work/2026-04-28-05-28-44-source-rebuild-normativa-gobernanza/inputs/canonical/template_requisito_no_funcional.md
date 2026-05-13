---
id: TEMPLATE-REQ-NO-FUNCIONAL
tipo: plantilla
titulo: Plantilla de Requisito No Funcional
version: 1.0.0
fecha_creacion: 2025-11-03
estado: activo
propietario: equipo-arquitectura
estandares: ["ISO/IEC/IEEE 29148:2018", "ISO 25010"]
---

# Template: Requisito No Funcional (Non-Functional Requirement)

```yaml
---
id: RNF-[XXX]
tipo: no_funcional
titulo: [Título conciso]
categoria: [performance|security|usability|reliability|maintainability|portability|scalability|availability]
dominio: [backend|frontend|infrastructure|cross-domain]
owner: [equipo-propietario]
prioridad: [critica|alta|media|baja]
estado: [propuesto|aprobado|implementado|verificado]
fecha_creacion: [YYYY-MM-DD]

trazabilidad_upward:
  - N-[XXX]
  - RN-[XXX]
  - RS-[XXX]

trazabilidad_downward:
  - TEST-[XXX]
  - METRIC-[XXX]

iso29148_clause: "9.6"
iso25010_characteristic: "[Performance|Security|Usability|Reliability|Maintainability|Portability]"
verificacion_metodo: [test|measurement|inspection]
---
```

## 1. Descripción del Requisito

**El sistema DEBERÁ** [cumplir con característica de calidad específica y medible].

### 1.1 Contexto
[¿Por qué es necesario este requisito no funcional?]

### 1.2 Criterio Medible

| Métrica | Target | Método de Medición | Herramienta |
|---------|--------|-------------------|-------------|
| [Nombre métrica] | [Valor objetivo] | [Cómo se mide] | [Tool para medir] |

## 2. Categorías Específicas

### Performance
- **Tiempo de respuesta**: [< X ms/seg]
- **Throughput**: [X transacciones/seg]
- **Capacidad**: [X usuarios concurrentes]

### Security
- **Autenticación**: [Método requerido]
- **Autorización**: [Niveles de acceso]
- **Encriptación**: [En tránsito y/o reposo]
- **Cumplimiento**: [GDPR|SOC2|ISO27001]

### Availability
- **Uptime**: [99.X%]
- **MTBF**: [Mean Time Between Failures]
- **MTTR**: [Mean Time To Recovery]
- **RTO/RPO**: [Recovery Time/Point Objective]

### Scalability
- **Escalamiento vertical**: [Límites]
- **Escalamiento horizontal**: [Estrategia]
- **Límites de crecimiento**: [X% anual]

### Usability
- **Facilidad de aprendizaje**: [< X minutos]
- **Eficiencia de uso**: [Tarea en < Y tiempo]
- **Tasa de error**: [< Z%]
- **Accesibilidad**: [WCAG 2.1 AA]

### Maintainability
- **Cobertura de tests**: [≥ X%]
- **Complejidad ciclomática**: [< Y]
- **Deuda técnica**: [< Z días]

## 3. Criterios de Aceptación

- [ ] [Criterio medible 1]
- [ ] [Criterio medible 2]
- [ ] [Criterio medible 3]

## 4. Tests de Verificación

### 4.1 Tests de Performance
```bash
# Ejemplo: Test de carga
artillery run --target https://api.example.com load-test.yml
# Target: 95th percentile < 200ms
```

### 4.2 Tests de Seguridad
- [ ] OWASP Top 10 verificado
- [ ] Penetration testing realizado
- [ ] Dependency audit sin vulnerabilidades críticas

### 4.3 Monitoreo
- **Métricas a monitorear**: [Lista]
- **Alertas configuradas**: [Umbrales]
- **Dashboard**: [URL o referencia]

## 5. Trazabilidad

### Upward
- [N-XXX](../necesidades/nXXX.md) - [Necesidad]
- [RS-XXX](../stakeholders/rsXXX.md) - [Req Stakeholder]

### Downward
- Tests: `tests/performance/test_[nombre].py`
- Métricas: Monitoreo en [herramienta]

## 6. Aprobaciones

| Rol | Nombre | Fecha | Estado |
|-----|--------|-------|--------|
| Arquitecto | [nombre] | [YYYY-MM-DD] | [ ] |
| QA Lead | [nombre] | [YYYY-MM-DD] | [ ] |
| DevOps | [nombre] | [YYYY-MM-DD] | [ ] |

---

**Referencias:**
- ISO/IEC 25010:2011 - System and Software Quality Models
- ISO/IEC/IEEE 29148:2018 - Requirements Engineering

**Fin del Template**
