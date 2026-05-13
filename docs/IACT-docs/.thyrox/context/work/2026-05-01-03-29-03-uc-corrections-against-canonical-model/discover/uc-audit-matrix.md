```yml
created_at: 2026-05-01 03:29:03
project: IACT-docs
work_package: 2026-05-01-03-29-03-uc-corrections-against-canonical-model
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
version: 1.0.0
language: es
```

# Auditoría de defectos — los 61 UCs vigentes

Auditoría inicial de los 61 UCs en
``source/requisitos/casos-uso/`` para identificar
defectos contra el modelo canónico
(``modelo-dominio-iact.rst`` v1.0.0,
``modelo-rbac-iact.rst`` v5.4.0). Esta matriz
guía las correcciones por cluster del Stage 10
EXECUTE.

## Tipos de defecto

| Código | Tipo | Patrón |
|--------|------|--------|
| D-01 | Función RBAC obsoleta (inglés viejo) | ``manage_sessions``, ``delete_users``, ``delete_alerts``, ``view_technical_logs``, ``manage_separation_rules``, ``view_active_sessions`` |
| D-02 | Función RBAC obsoleta (español pre-Z.1.C) | ``gestiona_sesiones``, ``crea_usuarios``, ``elimina_usuarios``, ``asigna_funciones``, ``revoca_funciones``, ``ve_dashboard``, etc. |
| D-03 | Mención al concepto eliminado ``Segmento`` / ``SegmentoDatos`` | Aparición textual en cuerpo, flujos, diagramas |
| D-04 | Referencia a archivo eliminado | ``UC_ACC_06``, ``UC_ACC_07``, ``BR-012``, ``br-012`` |
| D-05 | Campo "UC Relacionados" vacío | Trazabilidad sin completar |
| D-06 | Cita a constraint en versión obsoleta | ``BR-009 v1.x``, ``BR-011 v1.x``, ``CNST-019 v2.x``, ``CNST-020 v2.x`` |
| D-07 | Sin cita a la clase canónica del modelo de dominio | UC opera sobre clase del modelo sin citarla |

## Defectos por cluster

### AUTH (5 UCs)

| UC | D-01 | D-02 | D-03 | D-04 | D-05 | D-06 | D-07 |
|----|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| uc-auth-01-iniciar-sesion | — | — | — | — | — | — | + |
| uc-auth-02-cerrar-sesion | — | — | — | — | — | — | + |
| uc-auth-03-recuperar-contrasena | — | — | — | — | — | — | + |
| uc-auth-04-cambiar-contrasena | — | — | — | — | — | — | + |
| uc-auth-05-gestionar-sesiones | + | — | — | — | — | — | + |

### USR (4 UCs)

| UC | D-01 | D-02 | D-03 | D-04 | D-05 | D-06 | D-07 |
|----|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| uc-usr-01-crear-usuario | — | + | + | + | — | — | + |
| uc-usr-02-consultar-usuarios | — | — | + | — | — | — | + |
| uc-usr-03-modificar-usuario | — | — | + | — | — | — | + |
| uc-usr-04-eliminar-usuario | + | — | — | — | — | — | + |

### ACC (7 UCs)

| UC | D-01 | D-02 | D-03 | D-04 | D-05 | D-06 | D-07 |
|----|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| uc-acc-01-asignar-funciones | — | + | — | — | — | — | + |
| uc-acc-02-revocar-funciones | — | + | — | — | — | — | + |
| uc-acc-03-consultar-permisos | — | + | + | — | — | — | + |
| uc-acc-04-asignar-agrupador | — | — | — | — | — | — | + |
| uc-acc-05-gestionar-sod | — | — | — | — | — | — | + |
| uc-acc-08-permiso-temporal | — | — | — | — | — | — | + |
| uc-acc-09-auditar-cambios-acceso | — | — | + | — | — | — | + |

### PERM (10 UCs)

Todas Cat 5 (vista técnica del RBAC). El campo
"UC Relacionados" se completa con UCs ACC
correspondientes.

| UC | D-01 | D-02 | D-03 | D-04 | D-05 | D-06 | D-07 |
|----|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| uc-perm-01-asignar-grupo-a-usuario | — | — | — | — | + | — | + |
| uc-perm-02-revocar-grupo-a-usuario | — | — | — | — | + | — | + |
| uc-perm-03-conceder-permiso-excepcional | — | — | — | — | + | — | + |
| uc-perm-04-revocar-permiso-excepcional | — | — | — | — | + | — | + |
| uc-perm-05-crear-grupo-permisos | — | — | — | — | + | — | + |
| uc-perm-06-asignar-funciones-grupo | — | — | — | — | + | — | + |
| uc-perm-07-verificar-permiso-usuario | — | — | — | — | + | — | + |
| uc-perm-08-generar-menu-dinamico | — | — | — | — | + | — | + |
| uc-perm-09-auditar-acceso | — | — | — | — | + | — | + |
| uc-perm-10-consultar-auditoria-permisos | — | — | — | — | + | + | + |

### RPT (15 UCs)

| UC | D-01 | D-02 | D-03 | D-04 | D-05 | D-06 | D-07 |
|----|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| uc-rpt-01-ver-dashboard | — | + | — | — | — | — | + |
| uc-rpt-02-ver-metricas-tiempo-real | — | — | + | — | — | — | + |
| uc-rpt-03-ver-reportes-historicos | — | — | + | — | — | — | + |
| uc-rpt-04-exportar-reporte | — | — | + | — | + | + | + |
| uc-rpt-07-programar-reporte | — | — | + | — | + | — | + |
| uc-rpt-08-ver-reportes-programados | — | — | + | — | — | — | + |
| uc-rpt-09-configurar-filtros | — | — | + | — | + | — | + |
| uc-rpt-10-guardar-vista | — | — | + | — | + | — | + |
| uc-rpt-11-compartir-reporte | — | — | + | — | + | — | + |
| uc-rpt-12-ver-reporte-agentes | — | — | + | — | — | — | + |
| uc-rpt-13-ver-reporte-colas | — | — | + | — | — | — | + |
| uc-rpt-14-ver-reporte-campanas | — | — | + | — | — | — | + |
| uc-rpt-15-reporte-transferencias-centro | — | — | — | — | — | — | + |
| uc-rpt-16-reporte-menus-ivr | — | — | + | — | — | — | + |
| uc-rpt-17-reporte-clientes-unicos | — | — | + | — | — | — | + |

### ALR (5 UCs)

| UC | D-01 | D-02 | D-03 | D-04 | D-05 | D-06 | D-07 |
|----|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| uc-alr-01-configurar-umbrales | — | — | — | — | — | — | + |
| uc-alr-02-ver-alertas-activas | — | — | + | — | — | — | + |
| uc-alr-03-reconocer-alerta | — | — | — | — | — | — | + |
| uc-alr-04-ver-historial-alertas | — | — | + | — | — | — | + |
| uc-alr-05-gestionar-suscripciones | — | — | — | — | — | — | + |

### PIP (4 UCs)

| UC | D-01 | D-02 | D-03 | D-04 | D-05 | D-06 | D-07 |
|----|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| uc-pip-01-supervisar-etl | — | — | — | — | — | — | + |
| uc-pip-02-consultar-errores-etl | — | — | — | — | — | — | + |
| uc-pip-03-consultar-disponibilidad | — | — | — | — | — | — | + |
| uc-pip-04-solicitar-reintento | — | — | — | — | — | — | + |

### AUD (4 UCs)

| UC | D-01 | D-02 | D-03 | D-04 | D-05 | D-06 | D-07 |
|----|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| uc-aud-01-consultar-auditoria | — | — | — | — | — | — | + |
| uc-aud-02-buscar-auditoria | — | — | — | — | — | — | + |
| uc-aud-03-exportar-auditoria | — | — | — | — | — | — | + |
| uc-aud-04-generar-reporte-compliance | — | — | — | — | — | — | + |

### LOG (7 UCs)

| UC | D-01 | D-02 | D-03 | D-04 | D-05 | D-06 | D-07 |
|----|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| uc-log-01-consultar-logs-sistema | — | — | — | — | — | — | + |
| uc-log-02-consultar-logs-etl | — | — | — | — | — | — | + |
| uc-log-03-buscar-logs | — | — | — | — | — | — | + |
| uc-log-04-exportar-logs | — | — | — | — | — | — | + |
| uc-log-05-ver-logs-infraestructura | — | — | — | — | — | — | + |
| uc-log-06-ver-estado-sistema | — | — | — | — | — | + | + |
| uc-log-07-ver-metricas-tecnicas | — | — | — | — | — | — | + |

## Resumen

| Tipo de defecto | UCs afectados |
|-----------------|--------------:|
| D-01 Función RBAC obsoleta (inglés viejo) | 2 |
| D-02 Función RBAC obsoleta (español) | 5 |
| D-03 Mención a Segmento residual | 22 |
| D-04 Ref a archivo eliminado | 1 |
| D-05 UC Relacionados vacío | 15 |
| D-06 Constraint en versión obsoleta | 3 |
| D-07 Sin cita a clase canónica | 61 (todos) |

## Estrategia de corrección

### Por cluster (orden de ejecución)

1. AUTH (5) — sólo D-01 + D-07.
2. USR (4) — D-01, D-02, D-03, D-04, D-07.
3. ACC (7) — D-02, D-03, D-07.
4. PERM (10) — D-05, D-07 (todos Cat 5).
5. RPT (15) — D-02, D-03, D-05, D-06, D-07 (cluster
   más afectado).
6. ALR (5) — D-03, D-07.
7. PIP (4) — D-07 únicamente.
8. AUD (4) — D-07 únicamente.
9. LOG (7) — D-06, D-07.

### Patrón de corrección (D-07: cita a clase
canónica)

Insertar en sección **"13. Trazabilidad"** (o
sección equivalente según UC) una fila adicional:

::

   * - **Clase de Dominio**
     - <ClaseCanonica> (modelo-dominio-iact)
       [+ secundarias si aplican]

### Política sobre menciones a "Segmento" (D-03)

- Si la mención es **operativa** (parte del flujo,
  precondición, postcondición): reemplazar por la
  combinación AGR + MOD + Función (per Z.1.C).
- Si la mención es **histórica** o aclaratoria: dejar
  con nota de descarte por Z.1.C.
- En diagramas PlantUML: eliminar referencias y
  reemplazar por la combinación equivalente.

### Política sobre UC_ACC_07 (D-04)

Único caso: ``uc-usr-01-crear-usuario.rst``. La
referencia se reemplaza por una nota explicando
que la asignación de segmento ya no aplica
(Z.1.C Camino C). El paso del flujo pasa a citar
``UC_ACC_04 Asignar Agrupador`` (la
funcionalidad equivalente vigente).

### Build incremental

Tras corregir cada cluster ejecutar
``make html`` (sin ``make clean``) y verificar
0 warnings, 0 errors antes de commitear el
cluster.
