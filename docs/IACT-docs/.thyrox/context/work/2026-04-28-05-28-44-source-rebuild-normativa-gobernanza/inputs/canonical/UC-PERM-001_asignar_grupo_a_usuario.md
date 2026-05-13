---
id: UC-PERM-001
tipo: caso_de_uso
nombre: Asignar Grupo de Permisos a Usuario
actor_primario: Administrador de Sistema
nivel: usuario
prioridad: alta
estado: aprobado
trazabilidad_upward:
  - PRIORIDAD_01  # Sistema de Permisos Granular
  - RNF-002       # Seguridad y autorizacion
trazabilidad_downward:
  - RF-PERM-001   # API asignar grupos
  - RF-PERM-002   # Validacion permisos admin
  - TEST-PERM-001 # Test asignacion grupos
fecha_creacion: 2025-11-09
owner: equipo-backend
---

# UC-PERM-001: Asignar Grupo de Permisos a Usuario

## Identificación

- **ID**: UC-PERM-001
- **Nombre**: Asignar Grupo de Permisos a Usuario
- **Actor primario**: Administrador de Sistema
- **Nivel**: Usuario (sea level)
- **Prioridad**: Alta

## Resumen

El administrador asigna uno o más grupos de permisos a un usuario específico, estableciendo opcionalmente una fecha de expiración para la asignación. El sistema valida los permisos del administrador, verifica la existencia del usuario y grupos, registra la asignación y audita la operación.

**Objetivo del actor**: Otorgar permisos necesarios a un usuario para que pueda realizar sus funciones.

**Alcance**: Incluye validación de permisos, asignación de grupos y auditoría. NO incluye creación de usuarios ni definición de grupos (casos de uso separados).

## Actores

### Actor primario
- **Rol**: Administrador de Sistema
- **Descripción**: Usuario con permisos de administración de usuarios y grupos. Tiene la capacidad `sistema.administracion.usuarios.asignar_grupos`.

### Actores secundarios
- **Sistema de Auditoría**: Registra todas las operaciones de asignación de permisos
- **Base de Datos PostgreSQL**: Almacena las relaciones usuario-grupo

## Precondiciones

1. El administrador está autenticado en el sistema
2. El administrador tiene la capacidad `sistema.administracion.usuarios.asignar_grupos`
3. El usuario objetivo existe en el sistema y está activo
4. Los grupos de permisos a asignar existen y están activos

## Flujo principal

| Actor | Sistema |
|-------|---------|
| 1. Navega al módulo de gestión de usuarios | |
| 2. Selecciona usuario objetivo | |
| | 3. Muestra información del usuario actual |
| | 4. Muestra grupos disponibles para asignar |
| 5. Selecciona uno o más grupos de permisos | |
| 6. [OPCIONAL] Define fecha de expiración | |
| 7. [OPCIONAL] Ingresa motivo de asignación | |
| 8. Confirma asignación | |
| | 9. Valida que el administrador tiene permiso |
| | 10. Valida que los grupos existen y están activos |
| | 11. Crea relaciones UsuarioGrupo en base de datos |
| | 12. Registra asignación en auditoría (AuditoriaPermiso) |
| | 13. Muestra confirmación de éxito |
| | 14. Actualiza vista con grupos asignados |

## Flujos alternos

### FA-1: Usuario ya tiene grupo asignado
**Momento**: Paso 11 del flujo principal
**Condición**: El usuario ya tiene asignado uno de los grupos seleccionados

**Acción**:
| Actor | Sistema |
|-------|---------|
| | 11.a. Sistema detecta duplicado |
| | 11.b. Sistema ignora grupo duplicado |
| | 11.c. Sistema continúa con otros grupos |
| | 11.d. Sistema notifica grupos que fueron ignorados |

**Retorna a**: Paso 12

### FA-2: Asignación temporal (con fecha de expiración)
**Momento**: Paso 6 del flujo principal
**Condición**: Administrador define fecha de expiración

**Acción**:
| Actor | Sistema |
|-------|---------|
| 6.a. Administrador selecciona fecha de expiración | |
| | 6.b. Sistema valida que fecha es futura |
| | 6.c. Sistema almacena fecha_expiracion |

**Retorna a**: Paso 7

### FA-3: Reactivación de grupo previamente revocado
**Momento**: Paso 11 del flujo principal
**Condición**: Usuario tuvo el grupo pero fue desactivado

**Acción**:
| Actor | Sistema |
|-------|---------|
| | 11.a. Sistema detecta registro inactivo existente |
| | 11.b. Sistema reactiva el registro (activo=TRUE) |
| | 11.c. Sistema actualiza fecha_asignacion |

**Retorna a**: Paso 12

## Flujos de excepción

### FE-1: Administrador sin permisos suficientes
**Momento**: Paso 9 del flujo principal
**Condición de error**: Administrador no tiene capacidad requerida

**Manejo**:
| Actor | Sistema |
|-------|---------|
| | 9.e1. Sistema detecta falta de permisos |
| | 9.e2. Sistema registra intento en auditoría (acceso_denegado) |
| | 9.e3. Sistema muestra error: "No tiene permisos para asignar grupos" |
| 9.e4. Administrador reconoce error | |

**Resultado**: Caso de uso termina sin asignación

### FE-2: Grupo no existe o está inactivo
**Momento**: Paso 10 del flujo principal
**Condición de error**: Uno o más grupos seleccionados no existen o están inactivos

**Manejo**:
| Actor | Sistema |
|-------|---------|
| | 10.e1. Sistema valida grupos |
| | 10.e2. Sistema identifica grupos inválidos |
| | 10.e3. Sistema muestra error específico con nombres de grupos |
| 10.e4. Administrador corrige selección | |

**Resultado**: Retorna a paso 5

### FE-3: Usuario objetivo no existe o está inactivo
**Momento**: Paso 2 del flujo principal
**Condición de error**: Usuario seleccionado no existe o is_active=False

**Manejo**:
| Actor | Sistema |
|-------|---------|
| | 2.e1. Sistema valida existencia y estado |
| | 2.e2. Sistema muestra error: "Usuario no encontrado o inactivo" |
| 2.e3. Administrador selecciona otro usuario | |

**Resultado**: Retorna a paso 2

### FE-4: Error de base de datos
**Momento**: Paso 11 del flujo principal
**Condición de error**: Fallo al escribir en base de datos

**Manejo**:
| Actor | Sistema |
|-------|---------|
| | 11.e1. Sistema detecta error de BD |
| | 11.e2. Sistema hace rollback de transacción |
| | 11.e3. Sistema registra error en logs |
| | 11.e4. Sistema muestra error genérico al usuario |
| 11.e5. Administrador puede reintentar | |

**Resultado**: Caso de uso termina, datos no modificados

## Postcondiciones

### Postcondiciones de éxito
1. El usuario tiene los grupos asignados en tabla `usuarios_grupos` con `activo=TRUE`
2. Si se definió fecha de expiración, está almacenada en `fecha_expiracion`
3. El registro de auditoría existe con `accion=asignacion_grupo` y `resultado=exito`
4. El usuario puede ejercer las capacidades de los grupos asignados inmediatamente
5. La vista `vista_grupos_usuario` refleja los nuevos grupos

### Postcondiciones mínimas (en flujos de excepción)
1. No se modificó la tabla `usuarios_grupos`
2. Se registró el intento en auditoría con `resultado=fallo`
3. El usuario mantiene sus permisos anteriores sin cambios

## Reglas de negocio vinculadas

- **RN-PERM-001**: Un usuario puede tener múltiples grupos simultáneamente
- **RN-PERM-002**: Las asignaciones temporales expiran automáticamente (verificado en queries)
- **RN-PERM-003**: Solo usuarios con capacidad `sistema.administracion.usuarios.asignar_grupos` pueden asignar
- **RN-PERM-004**: Todas las asignaciones deben auditarse
- **RN-PERM-005**: Los grupos inactivos no pueden ser asignados

## Requisitos especiales

### Rendimiento
- La asignación debe completarse en < 500ms (p95)
- Soportar asignación de hasta 20 grupos simultáneos
- La auditoría no debe bloquear la respuesta al usuario

### Seguridad
- Autenticación requerida (token JWT válido)
- Autorización por capacidad (verificar antes de ejecutar)
- Logging completo de operación (quién, qué, cuándo, dónde)
- Protección contra CSRF en endpoints web

### Usabilidad
- Confirmación visual clara de grupos asignados
- Indicar si grupo es temporal o permanente
- Mostrar fecha de expiración si aplica
- Permitir deshacer operación inmediatamente después

### Integridad de datos
- Transacción atómica (asignación + auditoría)
- Constraint de unique(usuario_id, grupo_id) en base de datos
- Validación de foreign keys

## Frecuencia de uso

- **Estimada**: 50-100 veces por día
- **Criticidad**: Alta (operación de seguridad crítica)
- **Horario**: Principalmente en horas de oficina (8am-6pm)
- **Patrón**: Picos al inicio de proyectos o cambios de rol

## Supuestos

1. La base de datos PostgreSQL está disponible y operativa
2. El sistema de auditoría puede recibir eventos síncronamente
3. Los grupos de permisos ya están configurados antes de asignar
4. El administrador conoce qué grupos necesita cada usuario
5. La red es confiable para operaciones síncronas

## Restricciones

1. **Técnica**: Máximo 50 grupos por usuario (límite de rendimiento)
2. **Negocio**: Grupos de nivel_riesgo='critico' requieren aprobación adicional (fuera de alcance de este UC)
3. **Regulatoria**: Debe cumplir SOX/GDPR para auditoría de accesos
4. **Operacional**: La asignación no puede revertir grupos previamente revocados manualmente

## Requisitos derivados

### Funcionales
- **RF-PERM-001**: API REST POST /api/usuarios/:id/asignar_grupos/
- **RF-PERM-002**: Endpoint debe validar capacidad del solicitante
- **RF-PERM-003**: Endpoint debe crear registros en usuarios_grupos
- **RF-PERM-004**: Endpoint debe registrar en auditoria_permisos
- **RF-PERM-005**: Endpoint debe soportar asignación batch (múltiples grupos)
- **RF-PERM-006**: Endpoint debe validar unicidad de asignaciones

### No funcionales
- **RNF-PERM-001**: Tiempo de respuesta < 500ms (p95)
- **RNF-PERM-002**: Disponibilidad 99.9%
- **RNF-PERM-003**: Transacciones ACID completas
- **RNF-PERM-004**: Logs estructurados (JSON) para SIEM

### Tests de verificación
- **TEST-PERM-001**: Verificar asignación exitosa de un grupo
- **TEST-PERM-002**: Verificar asignación de múltiples grupos simultáneos
- **TEST-PERM-003**: Verificar asignación temporal con fecha de expiración
- **TEST-PERM-004**: Verificar error cuando administrador sin permisos
- **TEST-PERM-005**: Verificar error cuando grupo no existe
- **TEST-PERM-006**: Verificar registro de auditoría en todos los casos
- **TEST-PERM-007**: Verificar que usuario puede usar capacidades inmediatamente

## Diagramas

### Diagrama de Casos de Uso
Ver: `docs/anexos/diagramas/casos_de_uso/UC-PERM-001_asignar_grupo.puml`

### Diagrama de Secuencia
Ver: `docs/anexos/diagramas/secuencia/UC-PERM-001_asignar_grupo_seq.puml`

### Diagrama de Actividad
Ver: `docs/anexos/diagramas/actividad/UC-PERM-001_asignar_grupo_act.puml`

## Trazabilidad

### Origen
- **PRIORIDAD_01**: Estructura Base - Sistema de Permisos Granular
- **RNF-002**: Sistema debe implementar control de acceso granular
- **N-001**: Administradores necesitan gestionar permisos de usuarios dinámicamente

### Implementación
- **Código**: `api/callcentersite/callcentersite/apps/users/views_usuarios.py:324` (método `asignar_grupos`)
- **Servicio**: `api/callcentersite/callcentersite/apps/users/services_usuarios.py` (clase `UsuarioService`)
- **Modelos**: `api/callcentersite/callcentersite/apps/users/models_permisos_granular.py` (modelo `UsuarioGrupo`)
- **Tests**: `api/callcentersite/tests/permisos_api/test_rest_api_permisos.py`

## Referencias

- [Sistema de Permisos Granular](../backend/arquitectura/permisos-granular.md)
- [ADR-2025-010: Estrategia Híbrida ORM + SQL](../adr/adr_2025_010_orm_sql_hybrid_permissions.md)
- [Guía de Casos de Uso](../gobernanza/casos_de_uso_guide.md)

---

**Estado**: Aprobado
**Fecha**: 2025-11-09
**Owner**: equipo-backend
**Revisores**: equipo-seguridad, product-owner
