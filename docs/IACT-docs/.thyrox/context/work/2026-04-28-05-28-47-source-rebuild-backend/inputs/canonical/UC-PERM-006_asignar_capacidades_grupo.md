---
id: UC-PERM-006
tipo: caso_de_uso
nombre: Asignar Capacidades a Grupo
actor_primario: Administrador de Sistema
nivel: usuario
prioridad: media
estado: aprobado
trazabilidad_upward: [PRIORIDAD_01]
trazabilidad_downward: [RF-PERM-006]
date: 2025-11-13
---

# UC-PERM-006: Asignar Capacidades a Grupo

## 1. Resumen

El Administrador modifica las capacidades asociadas a un grupo existente, agregando o removiendo capacidades según necesidades del negocio.

## 2. Flujo Principal

| Paso | Actor | Sistema |
|------|-------|---------|
| 1 | Selecciona grupo existente | Muestra capacidades actuales |
| 2 | Agrega nuevas capacidades | Valida que no estén ya asociadas |
| 3 | Opcionalmente remueve capacidades | Muestra impacto en usuarios |
| 4 | Confirma cambios | Valida grupo tenga al menos 1 capacidad |
| 5 | - | Actualiza asociaciones (INSERT/DELETE) |
| 6 | - | Invalida cache de todos los usuarios del grupo |
| 7 | - | Registra auditoría |
| 8 | - | Notifica usuarios afectados |

## 3. Reglas de Negocio

- RN-006.1: Grupo debe mantener al menos 1 capacidad
- RN-006.2: Cambios afectan inmediatamente a todos los usuarios del grupo
- RN-006.3: Se debe auditar cada cambio

## 4. Datos de Entrada

```json
{
 "grupo_id": 5,
 "agregar_capacidades": [
 "sistema.vistas.reportes.avanzados.ver"
 ],
 "remover_capacidades": [
 "sistema.vistas.dashboards.editar"
 ]
}
```

## 5. API Endpoint

```
PUT /api/permisos/grupos/5/capacidades/
Authorization: Bearer <token>
```

## 6. Impacto

Al modificar capacidades de un grupo, TODOS los usuarios con ese grupo se ven afectados inmediatamente. El sistema debe:
- Invalidar cache de TODOS los usuarios del grupo
- Notificar cambios a usuarios activos
- Registrar en auditoría con lista de usuarios afectados

## Changelog

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2025-01-09 | Sistema | Creación inicial |
