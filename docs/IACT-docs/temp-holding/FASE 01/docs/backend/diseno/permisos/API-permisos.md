---
title: API del Sistema de Permisos Granular
date: 2025-11-13
domain: backend
status: active
---

# API del Sistema de Permisos Granular

**Version:** 1.0
**Fecha:** 2025-11-07
**Base URL:** `/api/v1/permissions/`
**Autenticacion:** JWT (Bearer token)

---

## Descripcion General

API RESTful para el sistema de permisos granular sin roles jerarquicos. Permite gestionar funciones, capacidades, grupos de permisos, asignaciones de usuarios y permisos excepcionales.

## Autenticacion

Todos los endpoints requieren autenticacion JWT:

```bash
Authorization: Bearer <jwt_token>
```

## Endpoints

### Funciones

Gestion de funciones del sistema (dashboards, usuarios, llamadas, etc)

#### Listar Funciones

```
GET /api/v1/permissions/funciones/
```

**Parametros de query:**
- `dominio` (string): Filtrar por dominio
- `categoria` (string): Filtrar por categoria
- `activa` (boolean): Filtrar por estado
- `search` (string): Buscar por nombre o descripcion
- `ordering` (string): Ordenar resultados

**Respuesta:**
```json
{
 "count": 10,
 "next": null,
 "previous": null,
 "results": [
 {
 "id": 1,
 "nombre": "llamadas",
 "nombre_completo": "sistema.operaciones.llamadas",
 "descripcion": "Gestion de llamadas telefonicas",
 "dominio": "operaciones",
 "categoria": "operaciones",
 "icono": "phone",
 "orden_menu": 20,
 "activa": true,
 "created_at": "2025-11-07T10:00:00Z",
 "updated_at": "2025-11-07T10:00:00Z"
 }
 ]
}
```

#### Obtener Funcion

```
GET /api/v1/permissions/funciones/{id}/
```

**Respuesta:** Objeto Funcion individual

#### Crear Funcion

```
POST /api/v1/permissions/funciones/
```

**Body:**
```json
{
 "nombre": "reportes",
 "nombre_completo": "sistema.analisis.reportes",
 "descripcion": "Generacion de reportes",
 "dominio": "analisis",
 "categoria": "analisis",
 "icono": "report",
 "orden_menu": 70
}
```

#### Actualizar Funcion

```
PUT /api/v1/permissions/funciones/{id}/
PATCH /api/v1/permissions/funciones/{id}/
```

#### Eliminar Funcion

```
DELETE /api/v1/permissions/funciones/{id}/
```

---

### Capacidades

Gestion de capacidades atomicas (acciones especificas)

#### Listar Capacidades

```
GET /api/v1/permissions/capacidades/
```

**Parametros de query:**
- `dominio` (string): Filtrar por dominio
- `recurso` (string): Filtrar por recurso
- `accion` (string): Filtrar por accion
- `nivel_sensibilidad` (string): bajo|normal|alto|critico
- `activa` (boolean): Filtrar por estado
- `search` (string): Buscar

**Respuesta:**
```json
{
 "count": 27,
 "results": [
 {
 "id": 1,
 "nombre_completo": "sistema.operaciones.llamadas.ver",
 "descripcion": "Ver llamadas",
 "accion": "ver",
 "recurso": "llamadas",
 "dominio": "operaciones",
 "nivel_sensibilidad": "bajo",
 "requiere_auditoria": false,
 "activa": true,
 "created_at": "2025-11-07T10:00:00Z"
 }
 ]
}
```

#### Crear Capacidad

```
POST /api/v1/permissions/capacidades/
```

**Body:**
```json
{
 "nombre_completo": "sistema.operaciones.tickets.cerrar",
 "descripcion": "Cerrar tickets de soporte",
 "accion": "cerrar",
 "recurso": "tickets",
 "dominio": "operaciones",
 "nivel_sensibilidad": "normal",
 "requiere_auditoria": false
}
```

---

### Grupos de Permisos

Gestion de grupos funcionales (NO roles jerarquicos)

#### Listar Grupos

```
GET /api/v1/permissions/grupos/
```

**Parametros de query:**
- `tipo_acceso` (string): operativo|gestion|analisis|estrategico|tecnico|finanzas|calidad
- `activo` (boolean): Filtrar por estado
- `search` (string): Buscar

**Respuesta:**
```json
{
 "count": 8,
 "results": [
 {
 "id": 1,
 "codigo": "atencion_cliente",
 "nombre_display": "Atencion al Cliente",
 "descripcion": "Grupo para agentes de atencion",
 "tipo_acceso": "operativo",
 "activo": true,
 "created_at": "2025-11-07T10:00:00Z",
 "updated_at": "2025-11-07T10:00:00Z",
 "capacidades_count": 6
 }
 ]
}
```

#### Obtener Grupo (Detalle con Capacidades)

```
GET /api/v1/permissions/grupos/{id}/
```

**Respuesta:**
```json
{
 "id": 1,
 "codigo": "atencion_cliente",
 "nombre_display": "Atencion al Cliente",
 "descripcion": "Grupo para agentes de atencion",
 "tipo_acceso": "operativo",
 "activo": true,
 "created_at": "2025-11-07T10:00:00Z",
 "updated_at": "2025-11-07T10:00:00Z",
 "capacidades": [
 {
 "id": 1,
 "nombre_completo": "sistema.operaciones.llamadas.ver",
 "nivel_sensibilidad": "bajo"
 },
 {
 "id": 2,
 "nombre_completo": "sistema.operaciones.llamadas.realizar",
 "nivel_sensibilidad": "normal"
 }
 ]
}
```

#### Obtener Capacidades de Grupo

```
GET /api/v1/permissions/grupos/{id}/capacidades/
```

**Respuesta:**
```json
{
 "capacidades": [
 {
 "id": 1,
 "nombre_completo": "sistema.operaciones.llamadas.ver",
 "descripcion": "Ver llamadas",
 "accion": "ver",
 "recurso": "llamadas",
 "dominio": "operaciones",
 "nivel_sensibilidad": "bajo",
 "requiere_auditoria": false,
 "activa": true
 }
 ]
}
```

#### Agregar Capacidad a Grupo

```
POST /api/v1/permissions/grupos/{id}/agregar_capacidad/
```

**Body:**
```json
{
 "capacidad_id": 5
}
```

**Respuesta:**
```json
{
 "message": "Capacidad agregada exitosamente"
}
```

---

### Asignaciones Usuario-Grupo

Gestion de usuarios asignados a grupos

#### Listar Asignaciones

```
GET /api/v1/permissions/usuarios-grupos/
```

**Parametros de query:**
- `usuario` (int): ID del usuario
- `grupo` (int): ID del grupo
- `activo` (boolean): Filtrar por estado

**Respuesta:**
```json
{
 "count": 15,
 "results": [
 {
 "id": 1,
 "usuario": 10,
 "grupo": 2,
 "fecha_asignacion": "2025-11-07T10:00:00Z",
 "fecha_expiracion": null,
 "asignado_por": 1,
 "activo": true,
 "usuario_username": "maria.garcia",
 "grupo_nombre": "Atencion al Cliente"
 }
 ]
}
```

#### Crear Asignacion

```
POST /api/v1/permissions/usuarios-grupos/
```

**Body:**
```json
{
 "usuario": 10,
 "grupo": 2,
 "asignado_por": 1,
 "activo": true,
 "fecha_expiracion": "2025-12-31T23:59:59Z"
}
```

**Validaciones:**
- Usuario y grupo deben existir
- No puede haber asignaciones duplicadas (usuario-grupo)
- fecha_expiracion debe ser futura (opcional)

#### Desactivar Asignacion

```
POST /api/v1/permissions/usuarios-grupos/{id}/desactivar/
```

**Respuesta:**
```json
{
 "message": "Asignacion desactivada"
}
```

---

### Permisos Excepcionales

Concesion o revocacion temporal de capacidades especificas

#### Listar Permisos Excepcionales

```
GET /api/v1/permissions/permisos-excepcionales/
```

**Parametros de query:**
- `usuario` (int): ID del usuario
- `capacidad` (int): ID de la capacidad
- `tipo` (string): conceder|revocar
- `activo` (boolean): Filtrar por estado

**Respuesta:**
```json
{
 "count": 3,
 "results": [
 {
 "id": 1,
 "usuario": 10,
 "capacidad": 25,
 "tipo": "conceder",
 "fecha_inicio": "2025-11-07T10:00:00Z",
 "fecha_fin": "2025-11-30T23:59:59Z",
 "motivo": "Proyecto especial fin de año",
 "autorizado_por": 1,
 "activo": true,
 "created_at": "2025-11-07T10:00:00Z",
 "usuario_username": "juan.perez",
 "capacidad_nombre": "sistema.finanzas.pagos.aprobar",
 "autorizado_por_username": "director"
 }
 ]
}
```

#### Crear Permiso Excepcional

```
POST /api/v1/permissions/permisos-excepcionales/
```

**Body:**
```json
{
 "usuario": 10,
 "capacidad": 25,
 "tipo": "conceder",
 "fecha_inicio": "2025-11-07T10:00:00Z",
 "fecha_fin": "2025-11-30T23:59:59Z",
 "motivo": "Proyecto especial fin de año requiere aprobaciones adicionales",
 "autorizado_por": 1,
 "activo": true
}
```

**Validaciones:**
- `tipo` debe ser "conceder" o "revocar"
- `fecha_fin` debe ser posterior a `fecha_inicio`
- `motivo` es obligatorio (para auditoria)

---

### Auditoria de Permisos

Consulta de logs de auditoria (solo lectura)

#### Listar Logs de Auditoria

```
GET /api/v1/permissions/auditoria/
```

**Parametros de query:**
- `usuario` (int): ID del usuario
- `capacidad` (string): Capacidad utilizada
- `accion_realizada` (string): Accion realizada

**Respuesta:**
```json
{
 "count": 1250,
 "results": [
 {
 "id": 1000,
 "usuario": 10,
 "capacidad": "sistema.finanzas.pagos.aprobar",
 "accion_realizada": "PAGO_APROBADO",
 "recurso_accedido": "PAY-12345",
 "ip_address": "192.168.1.100",
 "user_agent": "Mozilla/5.0...",
 "metadata": {
 "monto": 1000.00,
 "moneda": "USD",
 "aprobador": "director"
 },
 "timestamp": "2025-11-07T10:00:00Z",
 "usuario_username": "juan.perez"
 }
 ]
}
```

**Nota:** Endpoint de solo lectura. No permite POST, PUT, DELETE.

---

### Endpoints Personalizados

#### Mis Capacidades

Obtiene capacidades del usuario autenticado

```
GET /api/v1/permissions/mis-capacidades/
```

**Respuesta:**
```json
{
 "usuario_id": 10,
 "username": "maria.garcia",
 "capacidades": [
 "sistema.operaciones.llamadas.ver",
 "sistema.operaciones.llamadas.realizar",
 "sistema.operaciones.tickets.ver",
 "sistema.operaciones.tickets.crear",
 "sistema.vistas.dashboards.ver"
 ]
}
```

#### Mis Funciones

Obtiene funciones accesibles para el usuario autenticado

```
GET /api/v1/permissions/mis-funciones/
```

**Respuesta:**
```json
{
 "usuario_id": 10,
 "username": "maria.garcia",
 "funciones": [
 {
 "id": 1,
 "nombre": "llamadas",
 "nombre_completo": "sistema.operaciones.llamadas",
 "dominio": "operaciones",
 "categoria": "operaciones",
 "icono": "phone",
 "orden_menu": 20
 },
 {
 "id": 2,
 "nombre": "tickets",
 "nombre_completo": "sistema.operaciones.tickets",
 "dominio": "operaciones",
 "categoria": "operaciones",
 "icono": "ticket",
 "orden_menu": 30
 }
 ]
}
```

#### Verificar Permiso

Verifica si usuario autenticado tiene una capacidad especifica

```
POST /api/v1/permissions/verificar-permiso/
```

**Body:**
```json
{
 "capacidad": "sistema.finanzas.pagos.aprobar"
}
```

**Respuesta:**
```json
{
 "usuario_id": 10,
 "capacidad": "sistema.finanzas.pagos.aprobar",
 "tiene_permiso": false
}
```

---

## Errores Comunes

### 401 Unauthorized

```json
{
 "detail": "Authentication credentials were not provided."
}
```

**Causa:** Token JWT no proporcionado o invalido

**Solucion:** Incluir header `Authorization: Bearer <token>`

### 403 Forbidden

```json
{
 "error": "Permiso denegado. Requiere: sistema.administracion.usuarios.crear",
 "capacidades_requeridas": ["sistema.administracion.usuarios.crear"]
}
```

**Causa:** Usuario no tiene capacidad requerida

**Solucion:** Solicitar asignacion de capacidad a administrador

### 400 Bad Request

```json
{
 "codigo": ["Este campo debe ser unico."]
}
```

**Causa:** Violacion de constraint (ej: codigo duplicado)

**Solucion:** Usar valor unico

### 404 Not Found

```json
{
 "detail": "No encontrado."
}
```

**Causa:** Recurso no existe

**Solucion:** Verificar ID del recurso

---

## Ejemplos de Uso

### Ejemplo 1: Obtener capacidades de mi usuario

```bash
curl -X GET \
 'https://api.example.com/api/v1/permissions/mis-capacidades/' \
 -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIs...'
```

### Ejemplo 2: Asignar usuario a grupo

```bash
curl -X POST \
 'https://api.example.com/api/v1/permissions/usuarios-grupos/' \
 -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIs...' \
 -H 'Content-Type: application/json' \
 -d '{
 "usuario": 15,
 "grupo": 2,
 "asignado_por": 1,
 "activo": true
 }'
```

### Ejemplo 3: Conceder permiso excepcional temporal

```bash
curl -X POST \
 'https://api.example.com/api/v1/permissions/permisos-excepcionales/' \
 -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIs...' \
 -H 'Content-Type: application/json' \
 -d '{
 "usuario": 15,
 "capacidad": 25,
 "tipo": "conceder",
 "fecha_inicio": "2025-11-07T00:00:00Z",
 "fecha_fin": "2025-11-30T23:59:59Z",
 "motivo": "Proyecto especial requiere aprobaciones financieras",
 "autorizado_por": 1,
 "activo": true
 }'
```

### Ejemplo 4: Consultar auditoria de pagos aprobados

```bash
curl -X GET \
 'https://api.example.com/api/v1/permissions/auditoria/?capacidad=sistema.finanzas.pagos.aprobar&accion_realizada=PAGO_APROBADO' \
 -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIs...'
```

---

## Limitaciones

- Paginacion: 50 resultados por pagina por defecto
- Rate limiting: 100 requests/minuto por usuario
- Auditoria: Solo lectura, no se puede modificar/eliminar
- Permisos excepcionales: Se aplican inmediatamente, sin necesidad de re-login

---

## Referencias

- ADR: `docs/adr/ADR_2025_017-sistema-permisos-sin-roles-jerarquicos.md`
- Arquitectura: `docs/backend/permisos/arquitectura-permisos-granular.md`
- Codigo: `api/callcentersite/callcentersite/apps/permissions/`
- OpenAPI Schema: `/api/schema/`
- Swagger UI: `/api/docs/`

---

**Version:** 1.0
**Fecha:** 2025-11-07
**Mantenedores:** Backend Team, Security Team
