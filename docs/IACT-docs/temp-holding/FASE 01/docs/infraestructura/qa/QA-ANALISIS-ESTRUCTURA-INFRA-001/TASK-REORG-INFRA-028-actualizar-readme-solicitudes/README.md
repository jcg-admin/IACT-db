---
id: TASK-REORG-INFRA-028
titulo: Actualizar README solicitudes/
fase: FASE_2_REORGANIZACION_CRITICA
subcategoria: Actualizar READMEs Vacios
prioridad: MEDIA (P2)
duracion_estimada: 1 hora
estado: Pendiente
tipo: Documentacion
dependencias:
  - FASE_1_completada
tecnica_prompting: Chain-of-Thought (CoT)
fecha_creacion: 2025-11-18
autor: QA Infraestructura
tags:
  - documentacion
  - readme
  - solicitudes
  - fase-2
---

# TASK-REORG-INFRA-028: Actualizar README solicitudes/

## Descripción

Actualizar el README vacío de `/docs/infraestructura/solicitudes/` con contenido que explique el proceso de solicitudes de cambios de infraestructura.

## Objetivo

Documentar la carpeta de solicitudes como sistema de tracking y gestión de cambios de infraestructura.

## Técnica de Prompting: Chain-of-Thought (CoT)

### Razonamiento

```
PREGUNTA: ¿Qué es una solicitud de infraestructura?

ANÁLISIS:
├─ Solicitud = Request formal de cambio
├─ En infraestructura:
│   ├─ Solicitar nueva VM
│   ├─ Cambiar configuración
│   ├─ Aprobar deployment
│   └─ Registrar incidentes
└─ Conclusión: Sistema de governance y tracking

PROPÓSITO:
├─ Formalizar cambios de infraestructura
├─ Mantener registro auditable
├─ Proceso de aprobación
└─ Historial de decisiones

CONTENIDO README:
1. ¿Qué es una solicitud?
2. Tipos de solicitudes
3. Proceso de solicitud
4. Plantillas disponibles
5. Estados y seguimiento
```

## Pasos de Ejecución

### Crear README Completo

```bash
cd /home/user/IACT/docs/infraestructura/solicitudes

cat > README.md << 'EOF'
---
tipo: readme
carpeta: solicitudes
proposito: Gestionar solicitudes de cambios de infraestructura
fecha_actualizacion: 2025-11-18
responsable: QA Infraestructura
---

# README: Solicitudes de Infraestructura

## Propósito

Esta carpeta contiene **solicitudes formales de cambios** en la infraestructura del proyecto IACT, facilitando governance, aprobaciones y tracking de cambios.

**Objetivos:**
- Formalizar cambios de infraestructura
- Mantener registro auditable de solicitudes
- Facilitar proceso de aprobación
- Documentar historial de decisiones
- Coordinar cambios entre equipos

## ¿Qué es una Solicitud?

Una **solicitud** es un documento formal que registra:
- Qué cambio se solicita
- Por qué es necesario
- Quién lo solicita
- Cuándo debe implementarse
- Cómo se implementará
- Quién debe aprobar

## Tipos de Solicitudes

### 1. Solicitud de Provisión
Solicitar nuevos recursos de infraestructura:
- Nueva VM
- Nuevo entorno
- Nuevas herramientas

**Plantilla:** `plantilla_solicitud_provision.md`

### 2. Solicitud de Cambio de Configuración
Modificar configuración existente:
- Cambiar capacidad de VM
- Actualizar configuraciones
- Modificar permisos

**Plantilla:** `plantilla_solicitud_cambio_config.md`

### 3. Solicitud de Deployment
Aprobar deployment a entorno:
- Deployment a staging
- Deployment a producción
- Rollback

**Plantilla:** `plantilla_solicitud_deployment.md`

### 4. Solicitud de Mantenimiento
Planificar mantenimiento programado:
- Ventana de mantenimiento
- Updates de sistema
- Backups especiales

**Plantilla:** `plantilla_solicitud_mantenimiento.md`

## Proceso de Solicitud

### Flujo Completo

```
1. CREAR SOLICITUD
   ├─ Usar plantilla apropiada
   ├─ Completar todos los campos
   └─ Justificar necesidad

2. ASIGNAR ID
   ├─ Formato: SOL-INFRA-YYYY-NNN
   └─ Ejemplo: SOL-INFRA-2025-001

3. SUBMIT para REVISIÓN
   ├─ Crear PR en repositorio
   └─ Notificar a aprobadores

4. REVISIÓN y APROBACIÓN
   ├─ Revisión técnica
   ├─ Revisión de seguridad (si aplica)
   └─ Aprobación de responsable

5. IMPLEMENTACIÓN
   ├─ Ejecutar procedimiento correspondiente
   └─ Documentar en solicitud

6. CIERRE
   ├─ Verificar implementación
   ├─ Actualizar estado a "Completado"
   └─ Archivar solicitud
```

## Estados de Solicitud

| Estado | Descripción | Siguiente Paso |
|--------|-------------|----------------|
| **Borrador** | En creación | Submit para revisión |
| **Pendiente Revisión** | Esperando review | Revisar y comentar |
| **Pendiente Aprobación** | Esperando aprobación | Aprobar o rechazar |
| **Aprobada** | Lista para implementar | Ejecutar |
| **En Implementación** | Siendo ejecutada | Completar |
| **Completada** | Implementada exitosamente | Archivar |
| **Rechazada** | No aprobada | Cerrar o revisar |
| **Cancelada** | Ya no necesaria | Cerrar |

## Estructura de Solicitud

```markdown
---
id: SOL-INFRA-YYYY-NNN
tipo: [Provision/Cambio/Deployment/Mantenimiento]
solicitante: [Nombre]
fecha_solicitud: YYYY-MM-DD
fecha_requerida: YYYY-MM-DD
prioridad: [Baja/Media/Alta/Crítica]
estado: [Borrador/Pendiente/Aprobada/etc]
---

# Solicitud: [Título]

## Descripción
[¿Qué se solicita?]

## Justificación
[¿Por qué es necesario?]

## Impacto
[¿A qué afecta?]

## Requisitos Técnicos
- Requisito 1
- Requisito 2

## Procedimiento de Implementación
[Referencia a procedimiento o pasos]

## Aprobaciones Requeridas
- [ ] Aprobación Técnica: @responsable-tecnico
- [ ] Aprobación Seguridad: @responsable-seguridad
- [ ] Aprobación Final: @responsable-infra

## Implementación
[Documentar ejecución]

## Verificación
[Documentar validación]
```

## Nomenclatura

### Archivos de Solicitudes

```
SOL-INFRA-YYYY-NNN-descripcion-corta.md
```

**Componentes:**
- `SOL-INFRA`: Solicitud de Infraestructura
- `YYYY`: Año
- `NNN`: Número secuencial (001, 002, ...)
- `descripcion-corta`: snake_case

**Ejemplos:**
- `SOL-INFRA-2025-001-provision-vm-desarrollo.md`
- `SOL-INFRA-2025-002-cambio-capacidad-vm-staging.md`
- `SOL-INFRA-2025-003-deployment-produccion-v2.md`

## Cómo Crear Nueva Solicitud

```bash
# 1. Obtener próximo número
YEAR=$(date +%Y)
LAST_NUM=$(ls SOL-INFRA-$YEAR-*.md 2>/dev/null | \
           sed "s/SOL-INFRA-$YEAR-//;s/-.*//" | \
           sort -n | tail -1)
NEXT_NUM=$(printf "%03d" $((LAST_NUM + 1)))
SOL_ID="SOL-INFRA-$YEAR-$NEXT_NUM"

# 2. Copiar plantilla
cp ../plantillas/solicitudes/plantilla_solicitud_[tipo].md \
   ${SOL_ID}-descripcion-corta.md

# 3. Completar solicitud

# 4. Crear PR
git add ${SOL_ID}-*.md
git commit -m "solicitud(infra): Add ${SOL_ID} - [descripción]"
```

## Índice de Solicitudes

### Solicitudes 2025

| ID | Tipo | Descripción | Estado | Fecha |
|----|------|-------------|--------|-------|
| SOL-INFRA-2025-001 | Provisión | Nueva VM desarrollo | Completada | 2025-01-15 |

### Solicitudes Activas

[Solicitudes en estado: Pendiente, Aprobada, En Implementación]

### Solicitudes Archivadas

[Solicitudes en estado: Completada, Rechazada, Cancelada]

## Relación con Otras Carpetas

```
solicitudes/ (esta carpeta)
    ↓ requiere
procedimientos/ (para implementación)
    ↓ puede generar
adr/ (decisiones arquitecturales)
    ↓ usa
plantillas/solicitudes/ (templates)
```

**Enlaces Útiles:**
- [Procedimientos](../procedimientos/README.md)
- [Plantillas de Solicitudes](../plantillas/solicitudes/)
- [ADRs](../adr/README.md)

## Mejores Prácticas

1. **Claridad**: Describir claramente qué se solicita
2. **Justificación**: Explicar por qué es necesario
3. **Completitud**: Incluir todos los detalles técnicos
4. **Trazabilidad**: Referenciar documentos relacionados
5. **Seguimiento**: Actualizar estado regularmente

## Mantenimiento

**Actualizar este README cuando:**
- Cambia proceso de aprobación
- Se agregan nuevos tipos de solicitud
- Cambian plantillas

**Última actualización:** 2025-11-18

EOF

echo "[OK] README.md para solicitudes/ creado"
```

## Auto-CoT: Razonamiento

```
ANÁLISIS: ¿Por qué carpeta de solicitudes?

GOVERNANCE:
├─ Cambios de infraestructura son críticos
├─ Requieren aprobación formal
├─ Necesitan trazabilidad
└─ Deben documentarse

BENEFICIOS:
├─ Registro auditable de cambios
├─ Proceso de aprobación claro
├─ Historial de decisiones
├─ Coordinación entre equipos
└─ Reducción de cambios no autorizados

FLUJO:
Solicitud → Revisión → Aprobación → Implementación → Verificación
```

## Criterios de Aceptación

- [ ] README.md creado en `/docs/infraestructura/solicitudes/`
- [ ] Propósito y tipos de solicitudes documentados
- [ ] Proceso completo de solicitud explicado
- [ ] Estados de solicitud definidos
- [ ] Estructura y nomenclatura documentadas
- [ ] Instrucciones para crear nueva solicitud incluidas

## Evidencias

### /docs/infraestructura/solicitudes/README.md
[README completo]

### evidencias/validacion-readme-solicitudes.txt
```
=== VALIDACIÓN README solicitudes/ ===
Fecha: 2025-11-18

[OK] README.md creado
[OK] Propósito documentado
[OK] 4 tipos de solicitudes definidos
[OK] Proceso de solicitud explicado
[OK] 8 estados definidos
[OK] Nomenclatura SOL-INFRA-YYYY-NNN documentada

RESULTADO: [OK] VALIDACIÓN EXITOSA
```

## Referencias

- LISTADO-COMPLETO-TAREAS.md: Línea 1076-1104
- Chain-of-Thought: Governance y trazabilidad de cambios
