---
id: GUIA-GOB-005
tipo: guia
categoria: gobernanza
subcategoria: requisitos
version: 1.0.0
fecha: 2025-11-17
autor: Claude Code (Sonnet 4.5)
estado: activo
relacionados: ["ADR-GOB-005", "ADR-GOB-006", "ADR-GOB-007", "ADR-GOB-009"]
---

# GUIA-GOB-005: Derivar Requisitos entre Niveles

## Propósito

Esta guía enseña cómo derivar requisitos desde un nivel superior hacia niveles inferiores en la jerarquía de 5 niveles establecida en ADR-GOB-005, garantizando trazabilidad completa y consistencia en la documentación.

## Audiencia

- Analistas de requisitos
- Product Owners
- Arquitectos de software
- Desarrolladores senior

## Problema que Resuelve

Sin una metodología clara de derivación, los equipos cometen errores como:
- Saltar niveles (de RN directamente a RF sin UC intermedios)
- Crear requisitos funcionales sin justificación de negocio
- Casos de uso que no implementan ningún requerimiento de negocio
- Atributos de calidad desconectados del contexto
- Inconsistencias entre niveles

## Jerarquía de 5 Niveles (Recordatorio)

```
Nivel 1: RN (Reglas de Negocio)
    ↓ influyen en
Nivel 2: RNEG (Requerimientos de Negocio)
    ↓ se convierten en
Nivel 3: UC (Casos de Uso)
    ↓ se implementan mediante
Nivel 4: RF (Requisitos Funcionales)
    ↓ deben cumplir
Nivel 5: RNF (Atributos de Calidad)
```

## Principios de Derivación

### Principio 1: Derivación Descendente Obligatoria

**Regla**: Todo requisito de nivel inferior DEBE derivarse de al menos un requisito de nivel superior.

**Excepciones permitidas**:
- Requisitos funcionales técnicos (logging, monitoreo) pueden derivarse de RNF
- Atributos de calidad transversales pueden no tener UC específico

### Principio 2: Trazabilidad Bidireccional

Cada artefacto debe responder:
- **Hacia arriba**: ¿Por qué existe este requisito?
- **Hacia abajo**: ¿Cómo se implementa/valida este requisito?

### Principio 3: No Saltar Niveles

**INCORRECTO**:
```
RN-BACK-001 → RF-BACK-010
(Saltar UC intermedio)
```

**CORRECTO**:
```
RN-BACK-001 → RNEG-BACK-001 → UC-BACK-001 → RF-BACK-010
```

### Principio 4: Granularidad Apropiada

- **1 RNEG** puede generar **3-10 UC**
- **1 UC** puede generar **5-15 RF**
- **1 RF** puede cumplir **1-3 RNF**

## Metodología de Derivación Paso a Paso

### Paso 1: De RN → RNEG

**Pregunta clave**: ¿Qué objetivo de negocio necesitamos lograr para cumplir esta regla?

#### Ejemplo 1: Regla Regulatoria

**RN-BACK-002**: Los datos personales deben cumplir con LFPDPPP (Ley Federal de Protección de Datos Personales en Posesión de Particulares)

**Derivación**:
```
RNEG-BACK-001: El sistema debe garantizar protección de datos personales
                cumpliendo 100% con LFPDPPP en un plazo de 6 meses

RNEG-BACK-002: El sistema debe obtener consentimiento explícito de usuarios
                antes de procesar datos personales
```

**Razonamiento**: La regla legal (RN) se traduce en objetivos medibles de negocio (RNEG).

#### Ejemplo 2: Regla Organizacional

**RN-BACK-010**: Todas las transacciones financieras deben ser auditables

**Derivación**:
```
RNEG-BACK-010: El sistema debe proporcionar auditoría completa de transacciones
                financieras para cumplir con controles internos y auditorías externas
```

#### Checklist: RN → RNEG

- [ ] El RNEG está redactado como objetivo de negocio (no como implementación técnica)
- [ ] El RNEG es medible (tiene KPIs implícitos o explícitos)
- [ ] El RNEG justifica su existencia citando el RN correspondiente
- [ ] El RNEG tiene horizonte temporal (si aplica)

### Paso 2: De RNEG → UC

**Pregunta clave**: ¿Qué necesitan HACER los usuarios para lograr este objetivo de negocio?

#### Ejemplo 1: Sistema de Protección de Datos

**RNEG-BACK-002**: El sistema debe obtener consentimiento explícito de usuarios antes de procesar datos personales

**Derivación**:
```
UC-BACK-015: Solicitar Consentimiento de Datos
UC-BACK-016: Revocar Consentimiento de Datos
UC-BACK-017: Consultar Historial de Consentimientos
UC-BACK-018: Exportar Datos Personales (Derecho ARCO)
```

**Razonamiento**: Un objetivo de negocio (RNEG) genera múltiples interacciones usuario-sistema (UC).

#### Ejemplo 2: Sistema de Auditoría

**RNEG-BACK-010**: El sistema debe proporcionar auditoría completa de transacciones financieras

**Derivación**:
```
UC-BACK-050: Registrar Transacción Financiera
UC-BACK-051: Consultar Historial de Transacciones
UC-BACK-052: Generar Reporte de Auditoría
UC-BACK-053: Exportar Log de Transacciones
```

#### Técnica: User Story Mapping

1. Identificar actores principales del RNEG
2. Listar actividades que esos actores necesitan realizar
3. Ordenar actividades en secuencia lógica
4. Convertir cada actividad en UC con formato VERBO+OBJETO

#### Checklist: RNEG → UC

- [ ] Cada UC usa nomenclatura VERBO+OBJETO
- [ ] Cada UC describe QUÉ (no CÓMO)
- [ ] Cada UC tiene al menos 1 actor primario identificado
- [ ] Conjunto de UC derivados cubre completamente el RNEG
- [ ] No hay UC redundantes

### Paso 3: De UC → RF

**Pregunta clave**: ¿Qué funciones específicas debe realizar el sistema para que el usuario complete este caso de uso?

#### Ejemplo 1: Del Caso de Uso al Requisito Funcional

**UC-BACK-001**: Iniciar Sesión

**Especificación del UC** (resumen de pasos relevantes):
```
2. El cajero introduce email y contraseña
3. El sistema valida credenciales
4. El sistema genera token de sesión
5. El sistema registra el evento en log de auditoría
6. El sistema muestra pantalla principal
```

**Derivación a RF**:
```
RF-BACK-010: El sistema debe validar formato de email según RFC 5322
RF-BACK-011: El sistema debe validar credenciales contra base de datos de usuarios
RF-BACK-012: El sistema debe verificar que cuenta de usuario esté activa (no bloqueada)
RF-BACK-013: El sistema debe generar token JWT con expiración de 15 minutos
RF-BACK-014: El sistema debe registrar intentos de login en tabla de auditoría
RF-BACK-015: El sistema debe actualizar campo "ultimo_acceso" del usuario
```

**Razonamiento**: Cada responsabilidad del sistema en el UC se convierte en RF específico.

#### Ejemplo 2: UC Complejo con Múltiples Flujos

**UC-BACK-020**: Procesar Pago

**Flujos**:
- Flujo normal: Pago con tarjeta exitoso
- Flujo alterno 1: Pago con transferencia bancaria
- Flujo alterno 2: Aplicar cupón de descuento
- Excepción 1: Tarjeta rechazada

**Derivación a RF**:
```
RF-BACK-050: El sistema debe validar número de tarjeta usando algoritmo Luhn
RF-BACK-051: El sistema debe conectarse a gateway de pago externo (Stripe/PayPal)
RF-BACK-052: El sistema debe validar monto mínimo de transacción ($10 MXN)
RF-BACK-053: El sistema debe aplicar descuento si cupón es válido y no expirado
RF-BACK-054: El sistema debe registrar transacción con estado: exitosa/fallida/pendiente
RF-BACK-055: El sistema debe generar folio único de transacción
RF-BACK-056: El sistema debe enviar email de confirmación al usuario
RF-BACK-057: El sistema debe reintentar transacción fallida hasta 3 veces
RF-BACK-058: El sistema debe registrar códigos de error del gateway externo
```

#### Técnica: Matriz Paso-a-Requisito

| Paso del UC | Responsabilidad del Sistema | RF Derivado |
|-------------|----------------------------|-------------|
| 2. Usuario introduce datos | Validar formato de datos | RF-BACK-010 |
| 3. Sistema valida | Validar contra BD | RF-BACK-011 |
| 3. Sistema valida | Verificar estado cuenta | RF-BACK-012 |
| 4. Sistema genera token | Generar JWT | RF-BACK-013 |
| 5. Sistema registra | Auditoría de login | RF-BACK-014 |

#### Checklist: UC → RF

- [ ] Cada paso del sistema en el UC tiene al menos 1 RF
- [ ] RF están redactados como "El sistema debe..." (no "El usuario debe...")
- [ ] RF describen QUÉ debe hacer el sistema (no CÓMO lo implementa)
- [ ] RF son verificables y testeables
- [ ] RF incluyen referencias al UC del que derivan
- [ ] Flujos alternos y excepciones también generan RF

### Paso 4: De UC → RNF (Paralelo a RF)

**Pregunta clave**: ¿Qué atributos de calidad debe cumplir el sistema al ejecutar este caso de uso?

#### Ejemplo: UC con Múltiples RNF

**UC-BACK-001**: Iniciar Sesión

**Derivación a RNF**:
```
RNF-BACK-005: La contraseña debe tener mínimo 8 caracteres, 1 mayúscula,
              1 minúscula, 1 número y 1 símbolo

RNF-BACK-006: El sistema debe responder a intento de login en menos de
              2 segundos bajo carga de 1000 usuarios concurrentes

RNF-BACK-007: La sesión debe expirar automáticamente después de 30 minutos
              de inactividad

RNF-BACK-008: Las contraseñas deben ser hasheadas usando bcrypt con factor
              de trabajo 12 (no se deben almacenar en texto plano)

RNF-BACK-009: El sistema debe bloquear cuenta después de 5 intentos fallidos
              consecutivos de login
```

#### Categorías de RNF por Caso de Uso

| Categoría RNF | Pregunta a Responder | Ejemplo |
|---------------|---------------------|---------|
| **Rendimiento** | ¿Qué tan rápido debe responder? | Tiempo de respuesta < 2s |
| **Seguridad** | ¿Qué protecciones necesita? | Hashing bcrypt, bloqueo de cuenta |
| **Usabilidad** | ¿Qué tan fácil debe ser de usar? | Mensajes de error claros |
| **Confiabilidad** | ¿Qué disponibilidad requiere? | Disponibilidad 99.9% |
| **Escalabilidad** | ¿Cuántos usuarios soporta? | 1000 usuarios concurrentes |
| **Mantenibilidad** | ¿Qué tan fácil es de mantener? | Logs estructurados en JSON |

#### Checklist: UC → RNF

- [ ] Cada UC crítico tiene al menos 2-3 RNF específicos
- [ ] RNF son medibles (con métricas cuantificables)
- [ ] RNF cubren al menos: rendimiento, seguridad, usabilidad
- [ ] RNF están documentados con formato estándar
- [ ] RNF tienen referencia al UC que los origina

### Paso 5: De RF → RNF (Validación Cruzada)

**Pregunta clave**: ¿Este requisito funcional cumple con los atributos de calidad necesarios?

#### Ejemplo: Validación RF vs RNF

**RF-BACK-013**: El sistema debe generar token JWT con expiración de 15 minutos

**RNF asociados**:
```
RNF-BACK-007: La sesión debe expirar automáticamente después de 30 minutos
              de inactividad

⚠️ INCONSISTENCIA DETECTADA:
RF dice "expiración de 15 minutos"
RNF dice "expiración de 30 minutos"

RESOLUCIÓN:
Clarificar: JWT expira en 15 min (requiere refresh), sesión completa expira en 30 min
```

## Ejemplos Completos de Derivación

### Ejemplo Completo 1: Autenticación

```
RN-BACK-001: Todos los usuarios deben estar autenticados para acceder al sistema
    ↓
RNEG-BACK-001: El sistema debe implementar autenticación segura que prevenga
                accesos no autorizados y cumpla con estándares de seguridad
    ↓
UC-BACK-001: Iniciar Sesión
UC-BACK-002: Cerrar Sesión
UC-BACK-003: Cambiar Contraseña
UC-BACK-004: Recuperar Contraseña
    ↓
RF-BACK-010: Validar formato de email según RFC 5322
RF-BACK-011: Validar credenciales contra base de datos
RF-BACK-012: Verificar estado de cuenta (activa/bloqueada)
RF-BACK-013: Generar token JWT con expiración de 15 minutos
RF-BACK-014: Registrar intento de login en log de auditoría
RF-BACK-015: Actualizar campo "ultimo_acceso"
RF-BACK-016: Enviar email de confirmación de login desde nueva IP
    ↓
RNF-BACK-005: Contraseña >= 8 caracteres con complejidad
RNF-BACK-006: Tiempo de respuesta < 2 segundos
RNF-BACK-007: Sesión expira después de 30 min inactividad
RNF-BACK-008: Contraseñas hasheadas con bcrypt factor 12
RNF-BACK-009: Bloqueo después de 5 intentos fallidos
```

### Ejemplo Completo 2: Gestión de Productos Químicos

```
RN-BACK-030: Todos los productos químicos peligrosos requieren capacitación
              de seguridad aprobada antes de ser solicitados
    ↓
RNEG-BACK-015: El sistema debe garantizar que solo personal capacitado
                pueda solicitar productos químicos peligrosos, reduciendo
                riesgo de incidentes a 0 en 12 meses
    ↓
UC-BACK-040: Solicitar Producto Químico
UC-BACK-041: Registrar Capacitación de Seguridad
UC-BACK-042: Validar Certificación de Usuario
UC-BACK-043: Aprobar Solicitud de Producto Químico
    ↓
RF-BACK-120: El sistema debe verificar certificación de seguridad antes de
             permitir solicitud de producto peligroso
RF-BACK-121: El sistema debe validar vigencia de certificación (< 12 meses)
RF-BACK-122: El sistema debe bloquear solicitud si certificación expirada
RF-BACK-123: El sistema debe enviar notificación a gerente si certificación
             próxima a expirar (30 días)
RF-BACK-124: El sistema debe registrar tabla de auditoría quién solicitó qué producto
    ↓
RNF-BACK-050: El sistema debe mantener historial de capacitaciones por 10 años
              (cumplimiento regulatorio)
RNF-BACK-051: La validación de certificación debe completarse en < 1 segundo
RNF-BACK-052: El sistema debe tener disponibilidad 99.9% para módulo de solicitudes
```

## Errores Comunes y Cómo Evitarlos

### Error 1: Saltar Niveles

**INCORRECTO**:
```
RN-BACK-001: Usuario debe estar autenticado
    ↓ (saltar RNEG y UC)
RF-BACK-010: Validar credenciales contra base de datos
```

**Problema**: No queda claro el objetivo de negocio ni el contexto de usuario.

**CORRECTO**:
```
RN-BACK-001 → RNEG-BACK-001 → UC-BACK-001 → RF-BACK-010
```

### Error 2: RF sin UC que lo Justifique

**INCORRECTO**:
```
RF-BACK-999: El sistema debe limpiar cache cada 10 minutos
(¿Por qué? ¿Qué caso de uso lo necesita?)
```

**CORRECTO**:
```
UC-BACK-050: Consultar Inventario en Tiempo Real
    ↓
RF-BACK-100: El sistema debe actualizar cache de inventario cada 10 minutos
RNF-BACK-060: Los datos de inventario deben tener latencia máxima de 10 minutos
```

### Error 3: Mezclar Niveles

**INCORRECTO** (UC describiendo implementación):
```
UC-BACK-001: Iniciar Sesión
  3. El sistema valida credenciales ejecutando:
     SELECT * FROM usuarios WHERE email = ? AND password_hash = bcrypt(?)
```

**CORRECTO**:
```
UC-BACK-001: Iniciar Sesión
  3. El sistema valida credenciales contra base de datos

RF-BACK-011: El sistema debe validar credenciales usando bcrypt para comparar hash
```

### Error 4: RNF Genéricos sin Contexto

**INCORRECTO**:
```
RNF-BACK-999: El sistema debe ser rápido
(¿Qué tan rápido? ¿En qué operaciones?)
```

**CORRECTO**:
```
RNF-BACK-006: El tiempo de respuesta para UC-BACK-001 (Iniciar Sesión)
              debe ser < 2 segundos para el percentil 95
```

### Error 5: UC sin Trazabilidad a RNEG

**INCORRECTO**:
```
UC-BACK-999: Cambiar Color de Fondo
(¿Qué objetivo de negocio cumple?)
```

**Si no hay RNEG que lo justifique**: Probablemente no debería ser un UC, o bien falta documentar el RNEG.

## Checklist de Validación de Derivación

### Validación de Completitud

- [ ] Todos los RN tienen al menos 1 RNEG derivado
- [ ] Todos los RNEG tienen al menos 1 UC derivado
- [ ] Todos los UC tienen al menos 3 RF derivados
- [ ] Todos los UC críticos tienen al menos 2 RNF específicos
- [ ] No hay RF huérfanos (sin UC que los justifique)

### Validación de Consistencia

- [ ] Los IDs referenciados existen en los documentos correspondientes
- [ ] Las referencias son bidireccionales (UC lista RF, RF lista UC)
- [ ] No hay contradicciones entre niveles
- [ ] La nomenclatura sigue los estándares (VERBO+OBJETO para UC, etc.)

### Validación de Calidad

- [ ] Los RNEG son medibles (tienen KPIs implícitos o explícitos)
- [ ] Los UC describen QUÉ (no CÓMO)
- [ ] Los RF son verificables y testeables
- [ ] Los RNF son cuantificables (con métricas específicas)

## Herramientas de Apoyo

### Matriz de Derivación

Crear tabla que visualice la derivación:

```markdown
| RN | RNEG | UC | RF | RNF |
|----|------|----|----|-----|
| RN-BACK-001 | RNEG-BACK-001 | UC-BACK-001 | RF-BACK-010 | RNF-BACK-005 |
|  |  |  | RF-BACK-011 | RNF-BACK-006 |
|  |  |  | RF-BACK-012 | RNF-BACK-007 |
|  |  | UC-BACK-003 | RF-BACK-020 |  |
```

### Script de Validación

Usar script de trazabilidad (ver ADR-GOB-009):

```bash
./scripts/validar-trazabilidad.sh
```

Este script verifica:
- Referencias rotas
- RF sin UC
- UC sin RNEG
- Inconsistencias en IDs

## Ejercicios Prácticos

### Ejercicio 1: Derivar RNEG desde RN

**Dado**:
```
RN-BACK-100: Los reportes financieros deben cumplir con las normas de
              información financiera (NIF) mexicanas
```

**Tarea**: Derivar 2-3 RNEG

**Solución esperada**:
```
RNEG-BACK-100: El sistema debe generar reportes financieros que cumplan
                100% con NIF en un plazo de 8 meses

RNEG-BACK-101: El sistema debe permitir auditorías de cumplimiento NIF
                mediante trazabilidad completa de transacciones
```

### Ejercicio 2: Derivar UC desde RNEG

**Dado**:
```
RNEG-FRONT-010: El sistema debe proporcionar interface intuitiva que permita
                 a usuarios no técnicos gestionar inventario con capacitación
                 mínima de 2 horas
```

**Tarea**: Derivar 5 UC

**Solución esperada**:
```
UC-FRONT-010: Consultar Inventario
UC-FRONT-011: Registrar Entrada de Producto
UC-FRONT-012: Registrar Salida de Producto
UC-FRONT-013: Generar Reporte de Inventario
UC-FRONT-014: Buscar Producto por Código
```

### Ejercicio 3: Derivar RF desde UC

**Dado**:
```
UC-BACK-200: Generar Factura Electrónica

Flujo normal:
  1. Usuario selecciona venta a facturar
  2. Sistema valida datos de venta
  3. Sistema genera XML según formato SAT
  4. Sistema solicita timbrado a PAC
  5. Sistema registra UUID de factura
  6. Sistema envía factura por email a cliente
```

**Tarea**: Derivar 6 RF

**Solución esperada**:
```
RF-BACK-200: El sistema debe validar que venta tenga RFC de cliente
RF-BACK-201: El sistema debe generar XML CFDI 4.0 según especificación SAT
RF-BACK-202: El sistema debe conectarse a PAC para solicitar timbrado
RF-BACK-203: El sistema debe validar respuesta del PAC (éxito/error)
RF-BACK-204: El sistema debe guardar UUID en tabla de facturas
RF-BACK-205: El sistema debe adjuntar PDF y XML al email del cliente
```

## Referencias

- [ADR-GOB-005: Jerarquía de Requerimientos en 5 Niveles](/home/user/IACT---project/docs/gobernanza/adr/ADR-GOB-005-jerarquia-requerimientos-5-niveles.md)
- [ADR-GOB-006: Clasificación de Reglas de Negocio](/home/user/IACT---project/docs/gobernanza/adr/ADR-GOB-006-clasificacion-reglas-negocio.md)
- [ADR-GOB-007: Especificación de Casos de Uso](/home/user/IACT---project/docs/gobernanza/adr/ADR-GOB-007-especificacion-casos-uso.md)
- [ADR-GOB-009: Trazabilidad entre Artefactos](/home/user/IACT---project/docs/gobernanza/adr/ADR-GOB-009-trazabilidad-artefactos-requisitos.md)

## Próximos Pasos

1. Leer [GUIA-GOB-006: Identificar y Clasificar Reglas de Negocio](GUIA-GOB-006-identificar-clasificar-reglas-negocio.md)
2. Leer [GUIA-GOB-007: Escribir Casos de Uso Efectivos](GUIA-GOB-007-escribir-casos-uso-efectivos.md)
3. Practicar con ejemplos del proyecto IACT
4. Usar scripts de validación de trazabilidad

## Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2025-11-17 | Claude Code | Versión inicial |
