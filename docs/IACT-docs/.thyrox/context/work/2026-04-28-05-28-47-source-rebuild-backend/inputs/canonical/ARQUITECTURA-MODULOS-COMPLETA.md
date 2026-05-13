---
title: Arquitectura Completa de Modulos - Sistema IACT
date: 2025-11-13
domain: backend
status: active
---

# Arquitectura Completa de Modulos - Sistema IACT

**Version:** 1.0
**Fecha:** 2025-11-07
**Estado:** Implementacion en progreso

---

## Vision General

Sistema modular de call center con permisos granulares sin jerarquias. Implementacion por prioridades 1-6.

## Principios Arquitectonicos

1. **Sin Roles Jerarquicos**: Grupos funcionales combinables (REF: ADR_2025_017)
2. **Permisos Granulares**: Capacidades atomicas formato `sistema.dominio.recurso.accion`
3. **Modularidad**: Cada modulo es independiente con su BD, API y UI
4. **TDD**: Desarrollo guiado por tests
5. **API RESTful**: Django REST Framework con ViewSets
6. **Frontend Modular**: React + Redux Toolkit por modulo

---

## Modulos Implementados

### Prioridad 1: Sistema de Permisos (COMPLETADO 100%)

**Estado**: Implementado y documentado
**Ubicacion**: `api/callcentersite/callcentersite/apps/permissions/`
**Documentacion**: `docs/backend/permisos/`, `docs/adr/ADR_2025_017*.md`

**Modelos (8 tablas)**:
- `Funcion`: Recursos del sistema
- `Capacidad`: Acciones atomicas
- `FuncionCapacidad`: Relacion N:M
- `GrupoPermisos`: Grupos funcionales
- `GrupoCapacidad`: Relacion N:M
- `UsuarioGrupo`: Asignaciones con temporalidad
- `PermisoExcepcional`: Concesion/revocacion temporal
- `AuditoriaPermiso`: Log completo

**API Endpoints**: `/api/v1/permissions/`
- `/funciones/`, `/capacidades/`, `/grupos/`
- `/usuarios-grupos/`, `/permisos-excepcionales/`, `/auditoria/`
- `/mis-capacidades/`, `/mis-funciones/`, `/verificar-permiso/`

**Tests**: 87+ tests completos

---

### Prioridad 2: API Layer Permisos (COMPLETADO 100%)

**Estado**: Implementado
**Componentes**:
- Serializers completos con validaciones
- ViewSets con filtros, busqueda, paginacion
- Middleware `verificar_permiso` para proteger endpoints
- Servicio `PermisoService` con logica centralizada

---

### Prioridad 3: Modulos Operativos

#### 3.1 Llamadas (IMPLEMENTADO 80%)

**Estado**: Backend completado, frontend pendiente
**Ubicacion**: `api/callcentersite/callcentersite/apps/llamadas/`
**API**: `/api/v1/llamadas/`

**Modelos**:
```
EstadoLlamada
 codigo (unique)
 nombre
 es_final
 activo

TipoLlamada
 codigo (unique)
 nombre
 activo

Llamada
 codigo (unique, auto-generado CALL-XXXX)
 numero_telefono
 tipo (FK)
 estado (FK)
 agente (FK User)
 cliente_nombre, cliente_email, cliente_id
 fecha_inicio, fecha_fin
 metadata (JSON)
 notas

LlamadaTranscripcion
 llamada (FK)
 texto
 timestamp_inicio, timestamp_fin
 hablante (agente/cliente)
 confianza (float)

LlamadaGrabacion
 llamada (OneToOne)
 archivo_url
 formato (mp3, wav)
 duracion_segundos
 tamano_bytes
```

**Capacidades Requeridas**:
- `sistema.operaciones.llamadas.ver`
- `sistema.operaciones.llamadas.realizar`

**Endpoints**:
- `GET /api/v1/llamadas/llamadas/` - Listar llamadas
- `POST /api/v1/llamadas/llamadas/` - Crear llamada
- `GET /api/v1/llamadas/llamadas/{id}/` - Detalle
- `POST /api/v1/llamadas/llamadas/{id}/finalizar/` - Finalizar llamada
- `GET /api/v1/llamadas/estados/` - Listar estados
- `GET /api/v1/llamadas/tipos/` - Listar tipos
- `GET /api/v1/llamadas/transcripciones/` - Transcripciones
- `GET /api/v1/llamadas/grabaciones/` - Grabaciones

**Mock Data**: `ui/src/mocks/llamadas.json`

#### 3.2 Tickets (PLANIFICADO)

**Ubicacion**: `api/callcentersite/callcentersite/apps/tickets/`
**API**: `/api/v1/tickets/`

**Modelos Planificados**:
```
EstadoTicket, PrioridadTicket, CategoriaTicket

Ticket
 codigo (TKT-XXXX)
 titulo, descripcion
 estado, prioridad, categoria
 creado_por, asignado_a
 cliente_id, cliente_nombre, cliente_email
 fecha_creacion, fecha_cierre, fecha_limite
 metadata

ComentarioTicket
 ticket (FK)
 usuario (FK)
 contenido
 es_interno (boolean)
```

**Capacidades Requeridas**:
- `sistema.operaciones.tickets.ver`
- `sistema.operaciones.tickets.crear`
- `sistema.operaciones.tickets.editar`
- `sistema.operaciones.tickets.eliminar`

#### 3.3 Clientes (PLANIFICADO)

**Ubicacion**: `api/callcentersite/callcentersite/apps/clientes/`
**API**: `/api/v1/clientes/`

**Modelos Planificados**:
```
Cliente
 codigo (CLI-XXXX)
 nombre, apellido
 email, telefono
 fecha_nacimiento
 metadata
 activo

ClienteContacto
 cliente (FK)
 tipo (telefono, email, direccion)
 valor
 principal (boolean)

ClienteHistorial
 cliente (FK)
 usuario (FK)
 tipo_evento
 descripcion
 metadata
```

**Capacidades Requeridas**:
- `sistema.operaciones.clientes.ver`
- `sistema.operaciones.clientes.editar`

#### 3.4 Metricas (PLANIFICADO)

**Ubicacion**: `api/callcentersite/callcentersite/apps/metricas/`
**API**: `/api/v1/metricas/`

**Modelos Planificados**:
```
Metrica
 codigo (MET-XXXX)
 nombre
 descripcion
 tipo (contador, gauge, histograma)
 unidad

MetricaValor
 metrica (FK)
 valor (float)
 timestamp
 metadata

MetricaAgregacion
 metrica (FK)
 periodo (hora, dia, semana, mes)
 valor_min, valor_max, valor_promedio
 fecha_inicio, fecha_fin
```

**Capacidades Requeridas**:
- `sistema.analisis.metricas.ver`

#### 3.5 Reportes (PLANIFICADO)

**Ubicacion**: `api/callcentersite/callcentersite/apps/reportes/`
**API**: `/api/v1/reportes/`

**Modelos Planificados**:
```
Reporte
 codigo (REP-XXXX)
 nombre
 descripcion
 query_template
 parametros_schema (JSON)

ReporteEjecucion
 reporte (FK)
 usuario (FK)
 parametros (JSON)
 estado (pendiente, procesando, completado, error)
 resultado_url
 fecha_ejecucion

ReporteParametro
 reporte (FK)
 nombre
 tipo_dato
 requerido
```

**Capacidades Requeridas**:
- `sistema.analisis.reportes.ver`
- `sistema.analisis.reportes.generar`

#### 3.6 Alertas (PLANIFICADO)

**Ubicacion**: `api/callcentersite/callcentersite/apps/alertas/`
**API**: `/api/v1/alertas/`

**Modelos Planificados**:
```
AlertaRegla
 codigo (ALT-XXXX)
 nombre
 condicion (expresion)
 severidad (baja, media, alta, critica)
 activa

Alerta
 regla (FK)
 estado (nueva, reconocida, resuelta)
 valores_trigger (JSON)
 fecha_disparo, fecha_resolucion

AlertaNotificacion
 alerta (FK)
 usuario (FK)
 canal (email, sms, push)
 enviada
 fecha_envio
```

**Capacidades Requeridas**:
- `sistema.operaciones.alertas.ver`
- `sistema.operaciones.alertas.gestionar`

---

### Prioridad 4: Modulos de Gestion

#### 4.1 Equipos (PLANIFICADO)

**Ubicacion**: `api/callcentersite/callcentersite/apps/equipos/`
**API**: `/api/v1/equipos/`

**Modelos Planificados**:
```
Equipo
 codigo (EQP-XXXX)
 nombre
 supervisor (FK User)
 activo

EquipoMiembro
 equipo (FK)
 usuario (FK)
 fecha_inicio, fecha_fin
 rol_en_equipo

EquipoMetrica
 equipo (FK)
 metrica (FK)
 objetivo
 periodo
```

**Capacidades Requeridas**:
- `sistema.supervision.equipos.ver`
- `sistema.supervision.equipos.crear`
- `sistema.supervision.equipos.editar`
- `sistema.supervision.equipos.asignar_miembros`

#### 4.2 Horarios (PLANIFICADO)

**Ubicacion**: `api/callcentersite/callcentersite/apps/horarios/`
**API**: `/api/v1/horarios/`

**Modelos Planificados**:
```
Horario
 codigo (HOR-XXXX)
 nombre
 fecha_inicio, fecha_fin
 estado (borrador, publicado, archivado)

HorarioTurno
 horario (FK)
 usuario (FK)
 dia_semana
 hora_inicio, hora_fin
 tipo_turno

HorarioExcepcion
 horario (FK)
 fecha
 motivo
 aplicar_a (todos, equipo, usuario)
```

**Capacidades Requeridas**:
- `sistema.supervision.horarios.ver`
- `sistema.supervision.horarios.crear`
- `sistema.supervision.horarios.editar`
- `sistema.supervision.horarios.aprobar`

#### 4.3 Evaluaciones (PLANIFICADO)

**Ubicacion**: `api/callcentersite/callcentersite/apps/evaluaciones/`
**API**: `/api/v1/evaluaciones/`

**Modelos Planificados**:
```
EvaluacionCriterio
 codigo (EVL-XXXX)
 nombre
 peso (porcentaje)
 activo

Evaluacion
 evaluado (FK User)
 evaluador (FK User)
 periodo_inicio, periodo_fin
 puntaje_total
 estado (borrador, enviada, aprobada)

EvaluacionResultado
 evaluacion (FK)
 criterio (FK)
 puntaje
 comentarios
```

**Capacidades Requeridas**:
- `sistema.supervision.evaluaciones.ver`
- `sistema.supervision.evaluaciones.crear`
- `sistema.supervision.evaluaciones.aprobar`

---

### Prioridad 5: Modulos Financieros

#### 5.1 Pagos (PLANIFICADO - CRITICO)

**Ubicacion**: `api/callcentersite/callcentersite/apps/pagos/`
**API**: `/api/v1/pagos/`

**Modelos Planificados**:
```
Pago
 codigo (PAY-XXXX)
 monto
 moneda
 estado (pendiente, aprobado, rechazado, pagado)
 beneficiario
 metadata

PagoDetalle
 pago (FK)
 concepto
 monto
 porcentaje

PagoAprobacion
 pago (FK)
 aprobador (FK User)
 nivel_aprobacion
 decision (aprobar/rechazar)
 comentarios
 fecha_decision
```

**Capacidades Requeridas** (CRITICAS):
- `sistema.finanzas.pagos.ver` (alto)
- `sistema.finanzas.pagos.aprobar` (critico, auditoria obligatoria)

#### 5.2 Facturas (PLANIFICADO)

**Ubicacion**: `api/callcentersite/callcentersite/apps/facturas/`
**API**: `/api/v1/facturas/`

**Modelos Planificados**:
```
Factura
 codigo (FAC-XXXX)
 cliente (FK)
 fecha_emision, fecha_vencimiento
 subtotal, impuestos, total
 estado (borrador, emitida, pagada, cancelada)

FacturaLinea
 factura (FK)
 descripcion
 cantidad
 precio_unitario
 subtotal

FacturaPago
 factura (FK)
 pago (FK)
 monto_aplicado
 fecha_aplicacion
```

**Capacidades Requeridas**:
- `sistema.finanzas.facturas.ver`
- `sistema.finanzas.facturas.crear`
- `sistema.finanzas.facturas.emitir`

#### 5.3 Cobranza (PLANIFICADO)

**Ubicacion**: `api/callcentersite/callcentersite/apps/cobranza/`
**API**: `/api/v1/cobranza/`

**Modelos Planificados**:
```
Cobranza
 codigo (COB-XXXX)
 cliente (FK)
 monto_total, monto_pendiente
 dias_vencido
 prioridad

CobranzaAccion
 cobranza (FK)
 usuario (FK)
 tipo_accion (llamada, email, visita)
 resultado
 fecha_accion

CobranzaHistorial
 cobranza (FK)
 estado_anterior, estado_nuevo
 usuario (FK)
 fecha_cambio
```

**Capacidades Requeridas**:
- `sistema.finanzas.cobranza.ver`
- `sistema.finanzas.cobranza.gestionar`

---

### Prioridad 6: Modulos Estrategicos

#### 6.1 Presupuestos (PLANIFICADO)

**Ubicacion**: `api/callcentersite/callcentersite/apps/presupuestos/`
**API**: `/api/v1/presupuestos/`

**Modelos Planificados**:
```
Presupuesto
 codigo (PRE-XXXX)
 periodo_fiscal
 monto_total
 estado (borrador, aprobado, activo, cerrado)
 aprobado_por (FK User)

PresupuestoCategoria
 presupuesto (FK)
 categoria
 monto_asignado, monto_ejecutado
 porcentaje_ejecucion

PresupuestoEjecucion
 presupuesto (FK)
 categoria (FK)
 monto
 concepto
 fecha_ejecucion
```

**Capacidades Requeridas** (SOLO DIRECTORES):
- `sistema.direccion.presupuestos.ver`
- `sistema.direccion.presupuestos.crear`
- `sistema.direccion.presupuestos.aprobar`

#### 6.2 Politicas (PLANIFICADO)

**Ubicacion**: `api/callcentersite/callcentersite/apps/politicas/`
**API**: `/api/v1/politicas/`

**Modelos Planificados**:
```
Politica
 codigo (POL-XXXX)
 titulo
 categoria
 vigente
 fecha_vigencia

PoliticaVersion
 politica (FK)
 version
 contenido
 cambios
 autor (FK User)

PoliticaAceptacion
 politica_version (FK)
 usuario (FK)
 fecha_aceptacion
 ip_address
```

**Capacidades Requeridas**:
- `sistema.direccion.politicas.ver`
- `sistema.direccion.politicas.crear`
- `sistema.direccion.politicas.aprobar`

---

## Diagrama de Arquitectura General

```

 FRONTEND (React) 

 Permissions Llamadas Tickets Clientes 

 v 
 Redux Store + RTK Query 

 HTTP/REST
 v

 BACKEND API (Django REST) 

 /api/v1/permissions/ Sistema de permisos granular 
 /api/v1/llamadas/ Gestion de llamadas 
 /api/v1/tickets/ Sistema de tickets 
 /api/v1/clientes/ Gestion de clientes 
 /api/v1/metricas/ Metricas y KPIs 
 /api/v1/reportes/ Generacion de reportes 
 /api/v1/alertas/ Sistema de alertas 
 /api/v1/equipos/ Gestion de equipos 
 /api/v1/horarios/ Planificacion horarios 
 /api/v1/evaluaciones/ Evaluaciones de desempeno 
 /api/v1/pagos/ Aprobacion de pagos 
 /api/v1/facturas/ Gestion de facturas 
 /api/v1/cobranza/ Gestion de cobranza 
 /api/v1/presupuestos/ Gestion presupuestaria 
 /api/v1/politicas/ Politicas corporativas 

 v

 CAPA DE SERVICIOS 

 PermisoService Verificacion de permisos 
 LlamadaService Logica de llamadas 
 TicketService Logica de tickets 
 ClienteService Logica de clientes 
 MetricaService Calculo de metricas 
 ReporteService Generacion de reportes 
 AlertaService Procesamiento de alertas 
 ... 

 v

 BASE DE DATOS (PostgreSQL) 

 permissions_* 8 tablas permisos 
 llamadas_* 5 tablas llamadas 
 tickets_* 5 tablas tickets 
 clientes_* 3 tablas clientes 
 metricas_* 3 tablas metricas 
 reportes_* 3 tablas reportes 
 alertas_* 3 tablas alertas 
 equipos_* 3 tablas equipos 
 horarios_* 3 tablas horarios 
 evaluaciones_* 3 tablas evaluaciones 
 pagos_* 3 tablas pagos 
 facturas_* 3 tablas facturas 
 cobranza_* 3 tablas cobranza 
 presupuestos_* 3 tablas presupuestos 
 politicas_* 3 tablas politicas 

 Total estimado: ~55 tablas 

```

---

## Resumen de Estado

**Completado (Prioridad 1-2)**:
- Sistema de Permisos: 100%
- API Layer Permisos: 100%
- Documentacion Permisos: 100%

**En Progreso (Prioridad 3)**:
- Llamadas Backend: 80%
- Llamadas Frontend: 0%

**Planificado (Prioridad 3-6)**:
- 12 modulos adicionales backend
- Frontend completo para 13 modulos
- Integraciones entre modulos

---

## Estimaciones

**Backend**:
- Modelos: ~55 tablas
- Endpoints: ~150 endpoints
- Tests: ~500 tests

**Frontend**:
- Componentes: ~200 componentes React
- Tests: ~400 tests
- Paginas: ~50 paginas

**Documentacion**:
- ADRs: 15-20 documentos
- APIs: 13 documentos completos
- Guias: 30+ guias operativas

---

## Referencias

- ADR_2025_017: Permisos sin roles jerarquicos
- API Permisos: `docs/backend/permisos/API-permisos.md`
- Arquitectura Permisos: `docs/backend/permisos/arquitectura-permisos-granular.md`
- CODEOWNERS: `/CODEOWNERS`
- Mock Data: `ui/src/mocks/`

---

**Version:** 1.0
**Fecha:** 2025-11-07
**Mantenedores:** Architecture Team, Backend Team, Frontend Team
