# Trazabilidad - Backend

Este directorio contiene matrices de trazabilidad del backend para asegurar alineacion entre requisitos, diseño, implementacion y testing.

## Proposito

Establecer trazabilidad entre:
- Requisitos funcionales → Tests
- Requisitos funcionales → Codigo implementado
- Casos de uso → Endpoints API
- Features → Commits/PRs
- ADRs → Implementacion

## Nomenclatura

```
MATRIZ-origen-destino.md
TRAZABILIDAD-dominio.md
```

**Ejemplos:**
- `MATRIZ-requisitos-tests.md`
- `MATRIZ-requisitos-codigo.md`
- `MATRIZ-casos-uso-endpoints.md`
- `TRAZABILIDAD-permisos.md`
- `IMPLEMENTACION-SCRIPTS.md`

## Matrices Planificadas

### MATRIZ-requisitos-tests.md

Trazabilidad RF → Test Cases:

| Requisito ID | Descripcion | Test Cases | Cobertura | Estado |
|--------------|-------------|------------|-----------|--------|
| RF-001 | ... | test_xxx, test_yyy | 90% | OK |
| RF-002 | ... | test_zzz | 85% | OK |

### MATRIZ-requisitos-codigo.md

Trazabilidad RF → Codigo Implementado:

| Requisito ID | Descripcion | Archivos | Commits | Estado |
|--------------|-------------|----------|---------|--------|
| RF-001 | ... | models.py, views.py | abc123 | IMPL |
| RF-002 | ... | serializers.py | def456 | IMPL |

### MATRIZ-casos-uso-endpoints.md

Trazabilidad Casos de Uso → Endpoints:

| Caso de Uso | Endpoint | Metodo | Vista | Permisos | Tests |
|-------------|----------|--------|-------|----------|-------|
| UC-PERM-001 | /api/usuarios/{id}/grupos/ | POST | assign_group | admin | test_assign |

### TRAZABILIDAD-permisos.md

Trazabilidad del sistema de permisos:
- Requisitos → Diseño
- Diseño → Implementacion
- Implementacion → Tests
- Tests → Validaciones

### IMPLEMENTACION-SCRIPTS.md

Registro de scripts de implementacion:
- Scripts de migracion
- Scripts de validacion
- Scripts de datos iniciales
- Scripts de mantenimiento

## Formato de Matrices

```markdown
---
id: MATRIZ-###
tipo: trazabilidad
categoria: [requisitos|diseño|testing]
titulo: Titulo de la Matriz
version: 1.0.0
fecha_creacion: YYYY-MM-DD
fecha_actualizacion: YYYY-MM-DD
---

# MATRIZ: [Origen] → [Destino]

## Proposito

[Describir objetivo de trazabilidad]

## Tabla de Trazabilidad

| [Col Origen] | [Col Destino] | Estado | Observaciones |
|--------------|---------------|--------|---------------|
| ... | ... | ... | ... |

## Metricas

- Elementos origen: X
- Elementos destino: Y
- Cobertura: Z%
- Items sin trazar: N

## Analisis de Gaps

[Items origen sin destino]
[Items destino sin origen]
```

## Metricas de Trazabilidad

### Coverage Metrics
- **Cobertura de Requisitos → Tests:** >= 90%
- **Cobertura de Requisitos → Codigo:** 100%
- **Cobertura de Casos de Uso → Endpoints:** 100%

### Calidad de Trazabilidad
- Todas las relaciones documentadas
- Referencias bidireccionales
- Estado actualizado
- Gaps identificados y justificados

## Actualizacion de Matrices

Actualizar cuando:
- Se agrega nuevo requisito
- Se implementa funcionalidad
- Se crea nuevo test
- Se completa feature
- Se detecta gap en trazabilidad

## Herramientas de Trazabilidad

### Manual
- Tablas markdown en documentos

### Automatizada (futuro)
- Scripts de validacion de trazabilidad
- Generacion automatica desde codigo/tests
- Dashboard de cobertura

## Restricciones del Proyecto

Trazabilidad debe incluir:
- Validaciones de restricciones (no Redis, no SMTP)
- Configuracion de sesiones MySQL
- Base de datos dual

## Referencias

Ver tambien:
- `requisitos/MATRIZ_TRAZABILIDAD_PERMISOS.md`
- `testing/coverage-reports/`
- `qa/reportes/`

---

**Ultima actualizacion:** 2025-11-18
**Responsable:** Equipo Backend + QA
