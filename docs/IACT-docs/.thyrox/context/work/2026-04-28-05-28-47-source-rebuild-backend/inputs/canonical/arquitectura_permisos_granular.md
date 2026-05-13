---
title: Arquitectura del Sistema de Permisos Granular
date: 2025-11-13
domain: backend
status: active
---

# Arquitectura del Sistema de Permisos Granular

**Version:** 1.0
**Fecha:** 2025-11-07
**Estado:** Implementado (Prioridad 1)
**ADR:** ADR_2025_017-sistema-permisos-sin-roles-jerarquicos.md

---

## Vision General

Sistema de permisos granular basado en capacidades, SIN roles jerarquicos. Permite control fino de acceso a recursos mediante grupos funcionales combinables.

### Principio Fundamental

**NO usamos roles jerarquicos** (Admin, Supervisor, Agent)
**SI usamos grupos funcionales** (atencion_cliente, gestion_equipos, visualizacion_metricas)

---

## Arquitectura de Componentes

### Diagrama de Alto Nivel

```

 USUARIO 
 (User de Django Auth) 

 puede tener MULTIPLES
 v

 GRUPOS DE PERMISOS 
 (Agrupaciones Funcionales) 

 - atencion_cliente 
 - gestion_equipos 
 - visualizacion_metricas 
 - administracion_usuarios 
 - (combinables, sin jerarquia) 

 contiene
 v

 CAPACIDADES 
 (Permisos Atomicos) 

 Formato: sistema.dominio.recurso.accion 

 Ejemplos: 
 - sistema.vistas.dashboards.ver 
 - sistema.operaciones.llamadas.realizar 
 - sistema.finanzas.pagos.aprobar 

 actua sobre
 v

 FUNCIONES 
 (Recursos del Sistema) 

 - dashboards 
 - usuarios 
 - llamadas 
 - tickets 
 - metricas 

```

### Flujo de Verificacion de Permiso

```
1. Request HTTP llega al endpoint
 |
 v
2. Middleware extrae usuario autenticado
 |
 v
3. Middleware verifica capacidad requerida
 |
 +-- 3a. Obtener grupos activos del usuario
 |
 +-- 3b. Obtener capacidades de esos grupos
 |
 +-- 3c. Verificar permisos excepcionales
 | (conceder o revocar)
 |
 v
4. Decisión
 |
 +-- SI tiene permiso:
 | - Registrar auditoria (si requiere)
 | - Permitir acceso
 | - Continuar request
 |
 +-- NO tiene permiso:
 - Registrar auditoria
 - HTTP 403 Forbidden
 - Respuesta error
```

---

## Modelo de Datos

### Diagrama Entidad-Relacion

```

 Usuario 
 (Django User) 

 N:M (usuarios_grupos)

 v

 GrupoPermisos --------> Capacidad 

 codigo N:M nombre_completo 
 nombre_display (grupo_ accion 
 descripcion capaci- recurso 
 tipo_acceso dades) dominio 
 activo sensibilidad 
 requiere_audit 

 N:M (funcion_capacidades)

 v

 Funcion 

 nombre 
 nombre_completo 
 dominio 
 categoria 
 orden_menu 

PermisoExcepcional

 usuario 
 capacidad FK a Usuario
 tipo 
 fecha_inicio 
 fecha_fin 
 motivo 
 autorizado_por 

AuditoriaPermiso 

 usuario 
 capacidad FK a Usuario
 accion_realizada 
 recurso_accedido 
 ip_address 
 user_agent 
 metadata (JSON) 
 timestamp 

```

### Relaciones Clave

1. **Usuario → GrupoPermisos:** N:M (un usuario puede tener multiples grupos)

2. **GrupoPermisos → Capacidad:** N:M (un grupo puede tener multiples capacidades)

3. **Capacidad → Funcion:** N:M (una capacidad puede aplicar a multiples funciones)

4. **Usuario → PermisoExcepcional:** 1:N (un usuario puede tener multiples excepciones)

5. **Usuario → AuditoriaPermiso:** 1:N (un usuario genera multiples registros de auditoria)

---

## Tablas de Base de Datos

### 1. funciones

Recursos del sistema (dashboards, usuarios, metricas, etc.)

```sql
CREATE TABLE permissions_funciones (
 id BIGINT PRIMARY KEY AUTO_INCREMENT,
 nombre VARCHAR(100) NOT NULL,
 nombre_completo VARCHAR(200) UNIQUE NOT NULL,
 descripcion TEXT,
 dominio VARCHAR(100) NOT NULL,
 categoria VARCHAR(50),
 icono VARCHAR(50),
 orden_menu INT DEFAULT 0,
 activa BOOLEAN DEFAULT TRUE,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 INDEX idx_dominio (dominio),
 INDEX idx_activa (activa),
 INDEX idx_categoria (categoria)
);
```

### 2. capacidades

Acciones atomicas sobre recursos.

```sql
CREATE TABLE permissions_capacidades (
 id BIGINT PRIMARY KEY AUTO_INCREMENT,
 nombre_completo VARCHAR(200) UNIQUE NOT NULL,
 descripcion TEXT,
 accion VARCHAR(50) NOT NULL,
 recurso VARCHAR(100) NOT NULL,
 dominio VARCHAR(100) NOT NULL,
 nivel_sensibilidad VARCHAR(20) DEFAULT 'normal',
 requiere_auditoria BOOLEAN DEFAULT FALSE,
 activa BOOLEAN DEFAULT TRUE,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

 INDEX idx_accion (accion),
 INDEX idx_recurso (recurso),
 INDEX idx_sensibilidad (nivel_sensibilidad),

 CHECK (nivel_sensibilidad IN ('bajo', 'normal', 'alto', 'critico'))
);
```

### 3. funcion_capacidades

Relacion N:M entre Funcion y Capacidad.

```sql
CREATE TABLE permissions_funcion_capacidades (
 id BIGINT PRIMARY KEY AUTO_INCREMENT,
 funcion_id BIGINT NOT NULL,
 capacidad_id BIGINT NOT NULL,
 requerida BOOLEAN DEFAULT FALSE,
 visible_en_ui BOOLEAN DEFAULT TRUE,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

 FOREIGN KEY (funcion_id) REFERENCES permissions_funciones(id) ON DELETE CASCADE,
 FOREIGN KEY (capacidad_id) REFERENCES permissions_capacidades(id) ON DELETE CASCADE,

 UNIQUE (funcion_id, capacidad_id)
);
```

### 4. grupos_permisos

Grupos funcionales de capacidades (NO roles jerarquicos).

```sql
CREATE TABLE permissions_grupos_permisos (
 id BIGINT PRIMARY KEY AUTO_INCREMENT,
 codigo VARCHAR(100) UNIQUE NOT NULL,
 nombre_display VARCHAR(200) NOT NULL,
 descripcion TEXT,
 tipo_acceso VARCHAR(50),
 activo BOOLEAN DEFAULT TRUE,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 CHECK (tipo_acceso IN ('operativo', 'gestion', 'analisis', 'estrategico', 'tecnico', 'finanzas', 'calidad'))
);
```

### 5. grupo_capacidades

Relacion N:M entre Grupo y Capacidad.

```sql
CREATE TABLE permissions_grupo_capacidades (
 id BIGINT PRIMARY KEY AUTO_INCREMENT,
 grupo_id BIGINT NOT NULL,
 capacidad_id BIGINT NOT NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

 FOREIGN KEY (grupo_id) REFERENCES permissions_grupos_permisos(id) ON DELETE CASCADE,
 FOREIGN KEY (capacidad_id) REFERENCES permissions_capacidades(id) ON DELETE CASCADE,

 UNIQUE (grupo_id, capacidad_id)
);
```

### 6. usuarios_grupos

Usuario asignado a grupos (multiples, temporales opcionales).

```sql
CREATE TABLE permissions_usuarios_grupos (
 id BIGINT PRIMARY KEY AUTO_INCREMENT,
 usuario_id BIGINT NOT NULL,
 grupo_id BIGINT NOT NULL,
 fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 fecha_expiracion TIMESTAMP NULL,
 asignado_por BIGINT,
 activo BOOLEAN DEFAULT TRUE,

 FOREIGN KEY (usuario_id) REFERENCES auth_user(id) ON DELETE CASCADE,
 FOREIGN KEY (grupo_id) REFERENCES permissions_grupos_permisos(id) ON DELETE CASCADE,
 FOREIGN KEY (asignado_por) REFERENCES auth_user(id) ON DELETE SET NULL,

 UNIQUE (usuario_id, grupo_id)
);
```

### 7. permisos_excepcionales

Conceder o revocar capacidad especifica temporalmente.

```sql
CREATE TABLE permissions_permisos_excepcionales (
 id BIGINT PRIMARY KEY AUTO_INCREMENT,
 usuario_id BIGINT NOT NULL,
 capacidad_id BIGINT NOT NULL,
 tipo VARCHAR(20) NOT NULL,
 fecha_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 fecha_fin TIMESTAMP NULL,
 motivo TEXT NOT NULL,
 autorizado_por BIGINT,
 activo BOOLEAN DEFAULT TRUE,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

 FOREIGN KEY (usuario_id) REFERENCES auth_user(id) ON DELETE CASCADE,
 FOREIGN KEY (capacidad_id) REFERENCES permissions_capacidades(id) ON DELETE CASCADE,
 FOREIGN KEY (autorizado_por) REFERENCES auth_user(id) ON DELETE SET NULL,

 INDEX idx_usuario_activo (usuario_id, activo),

 CHECK (tipo IN ('conceder', 'revocar'))
);
```

### 8. auditoria_permisos

Registro de TODOS los accesos a recursos protegidos.

```sql
CREATE TABLE permissions_auditoria_permisos (
 id BIGINT PRIMARY KEY AUTO_INCREMENT,
 usuario_id BIGINT,
 capacidad VARCHAR(200) NOT NULL,
 accion_realizada VARCHAR(100) NOT NULL,
 recurso_accedido VARCHAR(200),
 ip_address VARCHAR(50),
 user_agent TEXT,
 metadata JSON,
 timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

 FOREIGN KEY (usuario_id) REFERENCES auth_user(id) ON DELETE SET NULL,

 INDEX idx_usuario (usuario_id),
 INDEX idx_timestamp (timestamp),
 INDEX idx_accion (accion_realizada)
);
```

---

## Dominios del Sistema

| Dominio | Descripcion | Ejemplos de Recursos |
|---------|-------------|---------------------|
| vistas | Visualizaciones y dashboards | dashboards |
| administracion | Gestion del sistema | usuarios |
| analisis | Metricas y reportes | metricas, reportes |
| operaciones | Operaciones diarias | llamadas, tickets, clientes |
| finanzas | Gestion financiera | pagos, facturas, cobranza |
| calidad | Control de calidad | auditoria, evaluaciones |
| supervision | Gestion de equipos | equipos, horarios, excepciones |
| direccion | Decisiones estrategicas | presupuestos, politicas |
| tecnico | Configuracion tecnica | configuracion |
| monitoreo | Alertas y seguimiento | alertas |

---

## Niveles de Sensibilidad

| Nivel | Descripcion | Requiere Auditoria | Ejemplos |
|-------|-------------|-------------------|----------|
| bajo | Consultas basicas | NO | ver dashboards, ver metricas |
| normal | Operaciones estandar | NO | crear tickets, editar clientes |
| alto | Modificaciones importantes | SI | editar usuarios, eliminar tickets |
| critico | Acciones de alto impacto | SI | aprobar pagos, publicar politicas |

---

## Ejemplos de Uso

### Caso 1: Usuario de Atencion al Cliente

**Usuario:** Maria
**Responsabilidad:** Atender clientes, gestionar tickets

**Grupos asignados:**
- `atencion_cliente`
- `visualizacion_metricas`

**Capacidades resultantes:**
```
sistema.operaciones.llamadas.ver
sistema.operaciones.llamadas.realizar
sistema.operaciones.tickets.ver
sistema.operaciones.tickets.crear
sistema.operaciones.tickets.editar
sistema.operaciones.clientes.ver
sistema.vistas.dashboards.ver
sistema.analisis.metricas.ver
```

**Puede hacer:**
- Ver y realizar llamadas
- Crear y editar tickets
- Consultar informacion de clientes
- Ver sus metricas personales

**NO puede hacer:**
- Aprobar pagos (no tiene `sistema.finanzas.pagos.aprobar`)
- Eliminar usuarios (no tiene `sistema.administracion.usuarios.eliminar`)
- Configurar sistema (no tiene `sistema.tecnico.configuracion.*`)

### Caso 2: Coordinador de Equipo

**Usuario:** Carlos
**Responsabilidad:** Gestionar equipo, planificar horarios, atender clientes

**Grupos asignados:**
- `atencion_cliente`
- `gestion_equipos`
- `gestion_horarios`
- `analisis_avanzado`

**Capacidades resultantes:**
```
(Todas de atencion_cliente)
+ sistema.supervision.equipos.ver
+ sistema.supervision.equipos.crear
+ sistema.supervision.equipos.editar
+ sistema.supervision.equipos.asignar_miembros
+ sistema.supervision.horarios.ver
+ sistema.supervision.horarios.crear
+ sistema.supervision.horarios.editar
+ sistema.supervision.horarios.aprobar
+ sistema.analisis.reportes.generar
```

**Puede hacer:**
- TODO lo que Maria puede hacer (atencion_cliente)
- PLUS: Gestionar su equipo
- PLUS: Aprobar horarios
- PLUS: Generar reportes

**NO puede hacer:**
- Aprobar pagos
- Publicar politicas
- Configurar sistema

### Caso 3: Permiso Excepcional Temporal

**Usuario:** Juan (normalmente solo `atencion_cliente`)
**Necesidad:** Aprobar pagos durante 1 mes (proyecto especial)

**Solucion: PermisoExcepcional**
```python
PermisoExcepcional.objects.create(
 usuario=juan,
 capacidad=Capacidad.objects.get(
 nombre_completo='sistema.finanzas.pagos.aprobar'
 ),
 tipo='conceder',
 fecha_inicio=datetime(2025, 11, 1),
 fecha_fin=datetime(2025, 11, 30),
 motivo='Proyecto especial fin de año requiere aprobaciones adicionales',
 autorizado_por=director
)
```

**Resultado:**
- Juan puede aprobar pagos del 1 al 30 de noviembre
- Despues del 30 de noviembre, pierde el permiso automaticamente
- Queda registrado quien autorizo y por que

---

## Servicios y APIs

### PermisoService

Servicio principal para verificar permisos.

**Metodos:**
- `usuarioTienePermiso(usuario_id, capacidad_requerida)`: Verifica si usuario tiene capacidad
- `obtenerCapacidadesUsuario(usuario_id)`: Obtiene todas las capacidades del usuario
- `obtenerFuncionesAccesibles(usuario_id)`: Obtiene funciones que el usuario puede acceder
- `registrarAcceso(...)`: Registra acceso en auditoria

### Middleware: verificarPermiso

Middleware para proteger endpoints.

**Uso:**
```python
from callcentersite.apps.permissions.middleware import verificarPermiso

@verificarPermiso('sistema.finanzas.pagos.aprobar')
def aprobar_pago(request, pago_id):
 # Solo usuarios con capacidad 'aprobar pagos' llegan aqui
 pago = Pago.objects.get(id=pago_id)
 pago.estado = 'aprobado'
 pago.save()
 return JsonResponse({'status': 'aprobado'})
```

---

## Referencias

- **ADR:** ADR_2025_017-sistema-permisos-sin-roles-jerarquicos.md
- **Codigo:** `api/callcentersite/callcentersite/apps/permissions/`
- **Tests:** `api/callcentersite/callcentersite/apps/permissions/tests/test_models.py`
- **Especificaciones:** Documento Sistema de Permisos Granular (Prioridad 1-6)

---

**Version:** 1.0
**Fecha:** 2025-11-07
**Estado:** Implementado y Documentado
