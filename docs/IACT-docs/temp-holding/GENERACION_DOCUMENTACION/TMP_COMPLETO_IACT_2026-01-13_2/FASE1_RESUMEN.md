# FASE 1 - MOD_Auth - GENERACIÓN COMPLETA

**Fecha:** 2026-01-07
**Módulo:** MOD_Auth
**UC Cubiertos:** UC_001 - UC_005

## Estadísticas

| Métrica | Valor |
|---------|-------|
| Archivos FR generados | 21 |
| Archivo index | 1 |
| Total archivos | 22 |
| Total líneas | ~3,385 |
| Carpetas UC | 5 |

## Distribución por UC

| UC | Nombre | FR |
|----|--------|-----|
| UC_001 | Iniciar Sesion | 5 |
| UC_002 | Cerrar Sesion | 3 |
| UC_003 | Recuperar Password | 5 |
| UC_004 | Cambiar Password | 4 |
| UC_005 | Gestionar Sesiones | 4 |
| **TOTAL** | — | **21** |

## Archivos Generados

```
funcionales/auth/
├── index.rst
├── UC_001_Iniciar_Sesion/
│   ├── FR-001.01_Validar_formato_username.rst
│   ├── FR-001.02_Validar_credenciales.rst
│   ├── FR-001.03_Generar_token_JWT.rst
│   ├── FR-001.04_Invalidar_sesiones_previas.rst
│   └── FR-001.05_Registrar_evento_auditoria.rst
├── UC_002_Cerrar_Sesion/
│   ├── FR-002.01_Invalidar_token_JWT.rst
│   ├── FR-002.02_Registrar_evento_logout.rst
│   └── FR-002.03_Limpiar_datos_sesion_cliente.rst
├── UC_003_Recuperar_Password/
│   ├── FR-003.01_Validar_username_existe.rst
│   ├── FR-003.02_Mostrar_pregunta_seguridad.rst
│   ├── FR-003.03_Validar_respuesta.rst
│   ├── FR-003.04_Generar_password_temporal.rst
│   └── FR-003.05_Forzar_cambio_siguiente_login.rst
├── UC_004_Cambiar_Password/
│   ├── FR-004.01_Validar_password_actual.rst
│   ├── FR-004.02_Validar_complejidad_nuevo_password.rst
│   ├── FR-004.03_Actualizar_hash_BD.rst
│   └── FR-004.04_Invalidar_sesiones.rst
└── UC_005_Gestionar_Sesiones/
    ├── FR-005.01_Listar_sesiones_activas.rst
    ├── FR-005.02_Mostrar_detalle_sesion.rst
    ├── FR-005.03_Invalidar_sesion_individual.rst
    └── FR-005.04_Invalidar_sesiones_por_usuario.rst
```

## Próxima Fase

**FASE 2:** MOD_Users (UC_006 - UC_009, 17 FR)
