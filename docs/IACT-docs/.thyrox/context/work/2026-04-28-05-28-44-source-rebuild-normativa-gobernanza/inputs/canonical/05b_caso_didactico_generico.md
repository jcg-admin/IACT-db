# Caso Didáctico Genérico - Aplicación del Marco Integrado

**Versión:** 1.0
**Fecha:** 2025-11-05
**Estado:** Vigente

## Propósito del Documento

Este documento presenta un caso didáctico genérico (dominio bancario) con propósito pedagógico para ilustrar la aplicación completa del marco integrado en un contexto diferente al proyecto IACT. Este caso complementa los casos prácticos reales documentados en `05a_casos_practicos_iact.md`.

**Nota Importante:** Este es un ejemplo genérico con fines educativos. Para casos reales del proyecto IACT, consultar `05a_casos_practicos_iact.md`.

## Referencias

- **01_marco_conceptual_iact.md** - Fundamentos teóricos del marco
- **02_relaciones_fundamentales_iact.md** - Patrones de transformación
- **04_metodologia_analisis_iact.md** - Metodología de 4 fases aplicada
- **05a_casos_practicos_iact.md** - Casos reales del proyecto IACT

---

## Caso Didáctico: Sistema de Apertura de Cuenta Bancaria Digital

### 1. Contexto del Negocio

**Dominio:** Banca Digital
**Área:** Onboarding de Clientes
**Objetivo:** Permitir a nuevos clientes abrir una cuenta bancaria de forma completamente digital, cumpliendo regulaciones de KYC (Know Your Customer) y AML (Anti-Money Laundering)

**Stakeholders:**
- Clientes potenciales (usuarios finales)
- Oficial de cumplimiento (validación KYC/AML)
- Gerente de sucursal (aprobación manual si requerida)
- Auditor regulatorio (cumplimiento normativo)
- Equipo de riesgo (evaluación de fraude)

**Regulaciones Aplicables:**
- Normativa KYC/AML local
- Protección de datos personales (GDPR/LGPD equivalente)
- Regulaciones bancarias nacionales

### 2. Proceso de Negocio

**PROC-BANK-ONBOARD-001: Proceso de Apertura de Cuenta Digital**

```
INICIO
  |
  v
[Cliente inicia solicitud en app/web]
  |
  v
[Completar formulario de datos personales]
  |
  v
[Validar formato de datos] --> [Datos inválidos?] --Sí--> [Mostrar errores] --> [Corregir]
  |                                   |
  No                                 No
  v                                   v
[Verificar identidad (OCR documento)] --> [OCR falla?] --Sí--> [Solicitar reintento/manual]
  |                                          |
  No                                        No
  v                                          v
[Capturar selfie para biometría] --> [Biometría no coincide?] --Sí--> [Rechazar/Escalar]
  |                                           |
  No                                         No
  v                                           v
[Validar contra listas de riesgo (PEP, sanctions)]
  |
  v
[¿Cliente en lista de riesgo?] --Sí--> [Escalar a oficial de cumplimiento] --> [Revisión manual]
  |                                           |
  No                                       [Aprobado?] --No--> [Rechazar solicitud] --> FIN
  v                                           |
[Calcular score de riesgo]                   Sí
  |                                           v
  v                                     [Aprobar cuenta]
[¿Score >= umbral?]                           |
  |                                           v
  |--No--> [Rechazar automáticamente] --> FIN
  |
 Sí
  v
[Crear cuenta en sistema core bancario]
  |
  v
[Generar número de cuenta y tarjeta]
  |
  v
[Enviar credenciales de acceso por email/SMS]
  |
  v
[Registrar auditoría completa]
  |
  v
[Notificar a cliente: Cuenta creada exitosamente]
  |
  v
FIN
```

**Actores:**
- Cliente (solicitante)
- Sistema de Onboarding (automatizado)
- Servicio de OCR (reconocimiento de documentos)
- Servicio de Biometría (validación facial)
- Sistema Core Bancario
- Oficial de Cumplimiento (manual, si requerido)

**Duración Estimada:**
- Flujo exitoso automatizado: 5-10 minutos
- Flujo con revisión manual: 24-48 horas

### 3. Reglas de Negocio

**RN-BANK-01: Edad Mínima del Titular**

```
Tipo: Restricción
Categoría: Elegibilidad

Descripción:
El cliente debe tener edad mínima de 18 años para abrir una cuenta individual.

Condición:
edad_cliente >= 18

Validación:
- Se calcula a partir de la fecha de nacimiento del documento
- Documento debe estar vigente (no expirado)

Excepción:
- Cuentas de menores con tutor legal (flujo diferente)

Impacto:
- Proceso: PROC-BANK-ONBOARD-001 (validación temprana)
- Requisito: RF-BANK-010 (Validación de Elegibilidad)

Sanción:
- Rechazo inmediato de solicitud
- Mensaje: "Debes tener al menos 18 años para abrir una cuenta"
```

**RN-BANK-02: Documentos Aceptados**

```
Tipo: Restricción
Categoría: Identificación

Descripción:
Solo se aceptan documentos de identidad oficiales vigentes.

Documentos Válidos:
- Documento Nacional de Identidad (DNI)
- Pasaporte
- Licencia de Conducir (según jurisdicción)

Requisitos del Documento:
- Debe estar vigente (no expirado)
- Fotografía debe ser legible
- Datos personales deben ser legibles
- Código de barras/MRZ debe ser decodificable

Validación:
- OCR extrae: nombre, apellido, fecha_nacimiento, numero_documento
- Sistema verifica vigencia contra fecha actual
- Sistema verifica integridad (checksums de código de barras)

Impacto:
- Proceso: PROC-BANK-ONBOARD-001 (paso verificación identidad)
- Requisito: RF-BANK-020 (OCR y Extracción de Datos)

Sanción:
- Solicitud rechazada si documento no cumple criterios
- Opción de reintentar con documento diferente (max 3 intentos)
```

**RN-BANK-03: Coincidencia Biométrica**

```
Tipo: Restricción
Categoría: Seguridad

Descripción:
La foto del selfie debe coincidir con la fotografía del documento
con un nivel de confianza mínimo del 85%.

Condición:
biometric_match_score >= 0.85

Proceso:
1. Sistema extrae foto del documento (OCR)
2. Sistema captura selfie del cliente (cámara)
3. Servicio de biometría compara ambas imágenes
4. Servicio retorna score de similitud (0.0 a 1.0)
5. Sistema valida score >= 0.85

Excepciones:
- Score 0.70 - 0.84: Escalar a revisión manual
- Score < 0.70: Rechazo automático

Impacto:
- Proceso: PROC-BANK-ONBOARD-001 (paso captura selfie)
- Requisito: RF-BANK-030 (Validación Biométrica)

Sanción:
- Rechazo si score < 0.70
- Revisión manual si 0.70 <= score < 0.85
```

**RN-BANK-04: Listas de Riesgo (PEP y Sanciones)**

```
Tipo: Desencadenador
Categoría: Cumplimiento

Descripción:
Si el cliente aparece en listas de Personas Expuestas Políticamente (PEP)
o en listas de sanciones internacionales, se debe escalar a revisión manual.

Listas Verificadas:
- PEP nacional e internacional
- OFAC (Office of Foreign Assets Control)
- ONU (Sanciones del Consejo de Seguridad)
- UE (European Union Sanctions)
- Listas locales de alta vigilancia

Validación:
- Búsqueda por nombre completo
- Búsqueda por número de documento
- Coincidencia fuzzy (similitud > 90%)

Acción:
SI cliente_en_lista_riesgo ENTONCES
  escalar_a_oficial_cumplimiento()
  estado = "PENDING_MANUAL_REVIEW"
  notificar_oficial(cliente_info, lista_encontrada)
FIN

Impacto:
- Proceso: PROC-BANK-ONBOARD-001 (validación listas)
- Requisito: RF-BANK-040 (Screening de Riesgo)

Tiempo de Resolución:
- Revisión manual: 24-72 horas
```

**RN-BANK-05: Score de Riesgo Mínimo**

```
Tipo: Cálculo + Restricción
Categoría: Gestión de Riesgo

Descripción:
El sistema calcula un score de riesgo basado en múltiples factores.
Score mínimo requerido: 60/100.

Factores del Score:
1. Calidad de documento (20 puntos)
   - OCR exitoso: 20
   - OCR con errores menores: 10
   - OCR fallido: 0

2. Coincidencia biométrica (25 puntos)
   - Score >= 0.95: 25
   - Score 0.85-0.94: 20
   - Score 0.70-0.84: 10
   - Score < 0.70: 0

3. Validación de datos (20 puntos)
   - Todos los datos válidos: 20
   - Datos con inconsistencias menores: 10
   - Datos inválidos: 0

4. Historial crediticio (si disponible) (20 puntos)
   - Buen historial: 20
   - Sin historial: 10
   - Mal historial: 0

5. Análisis de comportamiento (15 puntos)
   - Tiempo razonable de completado: 15
   - Tiempo sospechoso (muy rápido/lento): 5

Fórmula:
score_total = suma(factores)

Decisión:
- Score >= 80: Aprobación automática
- Score 60-79: Aprobación con monitoreo
- Score < 60: Rechazo automático

Impacto:
- Proceso: PROC-BANK-ONBOARD-001 (calcular score)
- Requisito: RF-BANK-050 (Evaluación de Riesgo)

Sanción:
- Rechazo si score < 60
- Mensaje: "No es posible completar tu solicitud en este momento"
```

### 4. Casos de Uso

**UC-BANK-001: Solicitar Apertura de Cuenta**

| Caso de Uso | UC-BANK-001: Solicitar Apertura de Cuenta |
|-------------|------------------------------------------|
| **Actor Principal** | Cliente potencial |
| **Stakeholders** | - Cliente: Desea abrir cuenta rápido y fácil<br>- Banco: Requiere cumplimiento regulatorio<br>- Oficial de Cumplimiento: Necesita trazabilidad<br>- Auditor: Requiere registros completos |
| **Precondiciones** | - Cliente tiene 18+ años<br>- Cliente tiene documento de identidad vigente<br>- Cliente tiene smartphone con cámara<br>- Cliente tiene email y teléfono válidos |
| **Postcondiciones Éxito** | - Cuenta creada en sistema core<br>- Número de cuenta asignado<br>- Credenciales enviadas al cliente<br>- Auditoría completa registrada |
| **Postcondiciones Fallo** | - Solicitud rechazada con motivo<br>- Datos del intento registrados<br>- Cliente notificado del rechazo |

**Flujo Principal:**

| Paso | Acción del Cliente | Respuesta del Sistema |
|------|-------------------|----------------------|
| 1 | Cliente accede a app móvil o sitio web | Sistema muestra página de inicio de onboarding |
| 2 | Cliente hace clic en "Abrir Cuenta" | Sistema muestra formulario de datos personales |
| 3 | Cliente ingresa: nombre, apellido, fecha_nacimiento, email, teléfono, dirección | Sistema valida formato en tiempo real |
| 4 | Cliente hace clic en "Continuar" | Sistema valida edad >= 18 años (RN-BANK-01) |
| 5 | Cliente acepta términos y condiciones | Sistema registra consentimiento con timestamp |
| 6 | Cliente hace clic en "Tomar foto de documento" | Sistema activa cámara |
| 7 | Cliente captura foto frontal del documento | Sistema ejecuta OCR para extraer datos |
| 8 | - | Sistema valida documento vigente (RN-BANK-02) |
| 9 | - | Sistema compara datos OCR con datos ingresados manualmente |
| 10 | Sistema muestra "Ahora vamos a verificar tu identidad" | Cliente se prepara para selfie |
| 11 | Cliente captura selfie siguiendo instrucciones | Sistema ejecuta validación biométrica |
| 12 | - | Sistema valida coincidencia >= 85% (RN-BANK-03) |
| 13 | - | Sistema consulta listas de riesgo (RN-BANK-04) |
| 14 | - | Sistema calcula score de riesgo (RN-BANK-05) |
| 15 | - | Sistema valida score >= 60 |
| 16 | - | Sistema crea cuenta en core bancario |
| 17 | - | Sistema genera número de cuenta (formato: XXXX-XXXX-XXXX-XXXX) |
| 18 | - | Sistema genera usuario y contraseña temporal |
| 19 | - | Sistema envía email con credenciales |
| 20 | - | Sistema envía SMS con número de cuenta |
| 21 | Sistema muestra "¡Felicidades! Tu cuenta ha sido creada" | Cliente visualiza número de cuenta |
| 22 | Cliente hace clic en "Ir al Dashboard" | Sistema redirige a dashboard bancario |

**Flujos Alternativos:**

**FA-1: Cliente Menor de 18 Años**

| Paso | Condición | Acción del Sistema |
|------|-----------|-------------------|
| 4a | edad_cliente < 18 (RN-BANK-01) | Sistema detiene proceso |
| 4b | - | Sistema muestra mensaje "Debes tener al menos 18 años" |
| 4c | - | Sistema ofrece información sobre cuentas para menores |
| 4d | - | FIN |

**FA-2: OCR Falla o Documento Inválido**

| Paso | Condición | Acción del Sistema |
|------|-----------|-------------------|
| 7a | OCR no puede leer documento | Sistema muestra "No pudimos leer tu documento" |
| 7b | - | Sistema muestra tips (mejor iluminación, menos reflejos) |
| 7c | Cliente reintenta | Sistema permite hasta 3 intentos |
| 7d | 3 intentos fallidos | Sistema ofrece opción de subir foto desde galería |
| 7e | Todos los intentos fallidos | Sistema sugiere visitar sucursal física |
| 7f | - | FIN |

**FA-3: Validación Biométrica Falla**

| Paso | Condición | Acción del Sistema |
|------|-----------|-------------------|
| 12a | Score biométrico < 0.70 (RN-BANK-03) | Sistema rechaza automáticamente |
| 12b | - | Sistema muestra "No pudimos verificar tu identidad" |
| 12c | - | Sistema permite 1 reintento |
| 12d | Segundo intento también falla | Sistema rechaza solicitud |
| 12e | - | Sistema registra intento fraudulento potencial |
| 12f | - | FIN |

**FA-4: Cliente en Lista de Riesgo**

| Paso | Condición | Acción del Sistema |
|------|-----------|-------------------|
| 13a | Cliente encontrado en lista PEP o sanciones (RN-BANK-04) | Sistema escala a revisión manual |
| 13b | - | Sistema cambia estado a "PENDING_MANUAL_REVIEW" |
| 13c | - | Sistema notifica a oficial de cumplimiento |
| 13d | - | Sistema muestra al cliente "Tu solicitud está en revisión" |
| 13e | - | Sistema envía email "Recibirás respuesta en 24-72 horas" |
| 13f | Oficial revisa caso | Manual |
| 13g | Oficial aprueba | Continuar desde paso 16 |
| 13h | Oficial rechaza | Sistema notifica rechazo al cliente → FIN |

**FA-5: Score de Riesgo Bajo**

| Paso | Condición | Acción del Sistema |
|------|-----------|-------------------|
| 15a | Score < 60 (RN-BANK-05) | Sistema rechaza automáticamente |
| 15b | - | Sistema muestra mensaje genérico "No podemos procesar tu solicitud" |
| 15c | - | Sistema registra motivo real en auditoría (no visible al cliente) |
| 15d | - | Sistema bloquea reintentos por 30 días |
| 15e | - | FIN |

**FA-6: Error en Sistema Core Bancario**

| Paso | Condición | Acción del Sistema |
|------|-----------|-------------------|
| 16a | Core bancario no responde o retorna error | Sistema registra error técnico |
| 16b | - | Sistema muestra "Error temporal. Por favor intenta en unos minutos" |
| 16c | - | Sistema guarda estado de la solicitud |
| 16d | Cliente reintenta más tarde | Sistema recupera estado guardado |
| 16e | - | Sistema reintenta creación desde paso 16 |

### 5. Requisitos Derivados

**Requisitos Funcionales:**

**RF-BANK-010: Validación de Elegibilidad**

```
ID: RF-BANK-010
Título: Validación de Elegibilidad del Solicitante
Prioridad: MUST (MoSCoW)
Categoría: Validación - Negocio

Descripción:
El sistema debe validar que el solicitante cumple con los criterios
de elegibilidad para abrir una cuenta bancaria.

Criterios de Aceptación:
1. Validar edad >= 18 años calculada desde fecha_nacimiento
2. Validar que email tiene formato válido
3. Validar que teléfono tiene formato válido según país
4. Validar que dirección está completa (calle, número, ciudad, código_postal)
5. Validaciones deben ejecutarse en tiempo real (mientras el usuario escribe)

Entrada:
- nombre: string (2-50 caracteres)
- apellido: string (2-50 caracteres)
- fecha_nacimiento: date (formato YYYY-MM-DD)
- email: string (formato email válido)
- teléfono: string (formato E.164)
- dirección: object {calle, número, ciudad, código_postal, país}

Salida:
- válido: boolean
- errores: array de string (si inválido)

Validaciones Específicas:

1. Edad:
   edad_actual = hoy - fecha_nacimiento
   SI edad_actual < 18 años ENTONCES
     error = "Debes tener al menos 18 años"
   FIN

2. Email:
   regex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/
   SI email NO coincide con regex ENTONCES
     error = "Email inválido"
   FIN

3. Teléfono:
   SI país = "ARG" ENTONCES formato = "+54 9 XXX XXX-XXXX"
   SI país = "MEX" ENTONCES formato = "+52 1 XXX XXX XXXX"
   Validar contra formato correspondiente

Reglas de Negocio:
- RN-BANK-01: Edad mínima del titular

Trazabilidad:
- Proceso: PROC-BANK-ONBOARD-001 (completar formulario)
- Caso de Uso: UC-BANK-001 (pasos 3-4)
- Prueba: TS-RF-BANK-010-001
```

**RF-BANK-020: Extracción de Datos por OCR**

```
ID: RF-BANK-020
Título: Extracción de Datos de Documento por OCR
Prioridad: MUST (MoSCoW)
Categoría: Procesamiento - Identificación

Descripción:
El sistema debe extraer datos del documento de identidad utilizando
OCR (Optical Character Recognition) y validar su vigencia.

Criterios de Aceptación:
1. Soportar documentos: DNI, Pasaporte, Licencia de Conducir
2. Extraer campos: nombre, apellido, número_documento, fecha_nacimiento, fecha_expiración
3. Validar que documento no esté expirado
4. Validar checksums de códigos de barras (si disponible)
5. OCR debe completarse en menos de 5 segundos

Entrada:
- imagen_documento: file (JPG/PNG, max 5MB)
- tipo_documento: enum (DNI, PASAPORTE, LICENCIA)

Salida:
{
  "éxito": boolean,
  "confianza": float (0.0-1.0),
  "datos": {
    "nombre": string,
    "apellido": string,
    "numero_documento": string,
    "fecha_nacimiento": date,
    "fecha_expiración": date,
    "nacionalidad": string
  },
  "advertencias": string[]
}

Proceso:

1. Preprocesamiento:
   - Rotar imagen si está inclinada
   - Ajustar brillo y contraste
   - Convertir a escala de grises

2. Detección de documento:
   - Detectar bordes del documento
   - Recortar área del documento
   - Verificar que documento ocupa >70% de la imagen

3. OCR:
   - Extraer texto de zonas conocidas (MRZ, campos visuales)
   - Aplicar engine OCR (Tesseract/Google Vision API)
   - Parsear texto extraído según formato de documento

4. Validación:
   - Verificar checksum de MRZ (Machine Readable Zone)
   - Validar fecha_expiración > fecha_actual
   - Comparar fecha_nacimiento con datos ingresados manualmente (tolerancia 1 día)

5. Nivel de Confianza:
   - Confianza >= 0.90: Aceptar automáticamente
   - Confianza 0.70-0.89: Advertir pero permitir continuar
   - Confianza < 0.70: Solicitar reintento

Reglas de Negocio:
- RN-BANK-02: Documentos aceptados

Trazabilidad:
- Proceso: PROC-BANK-ONBOARD-001 (verificar identidad)
- Caso de Uso: UC-BANK-001 (pasos 7-9)
- Prueba: TS-RF-BANK-020-001
```

**RF-BANK-030: Validación Biométrica Facial**

```
ID: RF-BANK-030
Título: Validación Biométrica Facial
Prioridad: MUST (MoSCoW)
Categoría: Seguridad - Identificación

Descripción:
El sistema debe validar que el selfie del cliente coincide con la
fotografía del documento de identidad mediante análisis biométrico.

Criterios de Aceptación:
1. Comparar selfie con foto extraída del documento
2. Calcular score de similitud (0.0 a 1.0)
3. Score >= 0.85 para aprobación automática
4. Score 0.70-0.84 para revisión manual
5. Score < 0.70 para rechazo automático
6. Validación debe completarse en menos de 3 segundos

Entrada:
- imagen_selfie: file (JPG/PNG, max 3MB)
- imagen_documento: file (JPG/PNG, extraída de OCR)

Salida:
{
  "score_similitud": float (0.0-1.0),
  "decisión": "APPROVED" | "MANUAL_REVIEW" | "REJECTED",
  "detalles": {
    "rostro_detectado_selfie": boolean,
    "rostro_detectado_documento": boolean,
    "calidad_selfie": float (0.0-1.0),
    "calidad_documento": float (0.0-1.0),
    "liveness_check": boolean
  }
}

Proceso:

1. Detección de Rostro:
   - Detectar rostro en selfie (face detection)
   - Detectar rostro en foto de documento
   - SI no se detecta rostro ENTONCES rechazar

2. Extracción de Características (Face Embeddings):
   - Generar vector de 128 dimensiones del selfie
   - Generar vector de 128 dimensiones de la foto del documento
   - Usar modelo pre-entrenado (FaceNet/ArcFace)

3. Cálculo de Similitud:
   - Calcular distancia euclidiana entre vectores
   - Convertir distancia a score (0.0-1.0)
   - Score = 1 - (distancia / max_distancia)

4. Liveness Check (detección de vida):
   - Verificar que selfie no es una fotografía de una fotografía
   - Análisis de texturas y micro-movimientos
   - Detección de pantallas (Moiré patterns)

5. Decisión:
   SI score >= 0.85 Y liveness_check = true ENTONCES
     decisión = "APPROVED"
   SI NO, SI 0.70 <= score < 0.85 ENTONCES
     decisión = "MANUAL_REVIEW"
   SI NO
     decisión = "REJECTED"
   FIN

Reglas de Negocio:
- RN-BANK-03: Coincidencia biométrica

Trazabilidad:
- Proceso: PROC-BANK-ONBOARD-001 (captura selfie)
- Caso de Uso: UC-BANK-001 (pasos 11-12)
- Prueba: TS-RF-BANK-030-001
```

**RF-BANK-040: Screening de Riesgo (PEP y Sanciones)**

```
ID: RF-BANK-040
Título: Screening de Listas de Riesgo
Prioridad: MUST (MoSCoW)
Categoría: Cumplimiento - AML/KYC

Descripción:
El sistema debe verificar que el cliente no aparece en listas de
Personas Expuestas Políticamente (PEP) o en listas de sanciones
internacionales.

Criterios de Aceptación:
1. Consultar listas: PEP nacional/internacional, OFAC, ONU, UE
2. Búsqueda por nombre completo y número de documento
3. Coincidencia fuzzy con threshold 90%
4. Escalar a revisión manual si se encuentra coincidencia
5. Consulta debe completarse en menos de 10 segundos

Entrada:
- nombre_completo: string
- numero_documento: string
- fecha_nacimiento: date
- nacionalidad: string

Salida:
{
  "encontrado_en_listas": boolean,
  "listas": [
    {
      "tipo_lista": "PEP" | "OFAC" | "ONU" | "UE" | "LOCAL",
      "nombre_coincidente": string,
      "similitud": float (0.0-1.0),
      "detalles": object
    }
  ],
  "requiere_revisión_manual": boolean
}

Proceso:

1. Normalización de Datos:
   - Convertir nombre a mayúsculas
   - Remover acentos y caracteres especiales
   - Tokenizar nombre (separar por espacios)

2. Búsqueda Exacta:
   - Buscar coincidencia exacta en bases de datos
   - Comparar número de documento
   - Comparar fecha de nacimiento

3. Búsqueda Fuzzy:
   - Calcular similitud de Levenshtein entre nombres
   - SI similitud >= 0.90 ENTONCES marcar como coincidencia potencial

4. Análisis de Contexto:
   - Si nombre común (ej: "José García") y solo coincide nombre
     pero no documento ni fecha_nacimiento ENTONCES
     reducir severidad de la alerta

5. Decisión:
   SI encontrado_en_listas = true ENTONCES
     estado = "PENDING_MANUAL_REVIEW"
     notificar_oficial_cumplimiento()
     NO crear cuenta automáticamente
   SI NO
     continuar_proceso()
   FIN

Reglas de Negocio:
- RN-BANK-04: Listas de riesgo (PEP y Sanciones)

Integraciones:
- API de Dow Jones Risk & Compliance
- API de World-Check (Refinitiv)
- Base de datos PEP local

Trazabilidad:
- Proceso: PROC-BANK-ONBOARD-001 (validar listas)
- Caso de Uso: UC-BANK-001 (paso 13)
- Prueba: TS-RF-BANK-040-001
```

**RF-BANK-050: Evaluación de Riesgo del Cliente**

```
ID: RF-BANK-050
Título: Evaluación de Riesgo del Cliente
Prioridad: MUST (MoSCoW)
Categoría: Gestión de Riesgo

Descripción:
El sistema debe calcular un score de riesgo basado en múltiples
factores para determinar si se aprueba o rechaza la solicitud.

Criterios de Aceptación:
1. Calcular score en escala 0-100
2. Considerar factores: calidad OCR, biometría, validación datos, historial, comportamiento
3. Score >= 80: Aprobación automática
4. Score 60-79: Aprobación con monitoreo
5. Score < 60: Rechazo automático

Entrada:
- datos_solicitud: object {OCR, biometría, validaciones, historial}

Salida:
{
  "score_total": int (0-100),
  "factores": {
    "calidad_documento": int (0-20),
    "coincidencia_biométrica": int (0-25),
    "validación_datos": int (0-20),
    "historial_crediticio": int (0-20),
    "análisis_comportamiento": int (0-15)
  },
  "decisión": "APPROVED" | "APPROVED_WITH_MONITORING" | "REJECTED",
  "motivos": string[]
}

Cálculo de Factores:

1. Calidad de Documento (0-20):
   SI ocr_confianza >= 0.95 ENTONCES 20
   SI ocr_confianza >= 0.80 ENTONCES 15
   SI ocr_confianza >= 0.70 ENTONCES 10
   SI NO 0

2. Coincidencia Biométrica (0-25):
   SI biometric_score >= 0.95 ENTONCES 25
   SI biometric_score >= 0.85 ENTONCES 20
   SI biometric_score >= 0.70 ENTONCES 10
   SI NO 0

3. Validación de Datos (0-20):
   puntos = 0
   SI todos_los_datos_válidos ENTONCES puntos += 20
   SI inconsistencias_menores ENTONCES puntos += 10
   SI datos_inválidos ENTONCES puntos += 0

4. Historial Crediticio (0-20):
   SI credit_score >= 700 ENTONCES 20
   SI sin_historial ENTONCES 10
   SI credit_score < 500 ENTONCES 0

5. Análisis de Comportamiento (0-15):
   tiempo_completado = timestamp_fin - timestamp_inicio
   SI 5min <= tiempo_completado <= 30min ENTONCES 15
   SI tiempo_completado < 2min O > 120min ENTONCES 5

Fórmula:
score_total = suma(todos_los_factores)

Decisión:
SI score_total >= 80 ENTONCES
  decisión = "APPROVED"
SI NO, SI score_total >= 60 ENTONCES
  decisión = "APPROVED_WITH_MONITORING"
  activar_monitoreo_adicional()
SI NO
  decisión = "REJECTED"
FIN

Reglas de Negocio:
- RN-BANK-05: Score de riesgo mínimo

Trazabilidad:
- Proceso: PROC-BANK-ONBOARD-001 (calcular score)
- Caso de Uso: UC-BANK-001 (pasos 14-15)
- Prueba: TS-RF-BANK-050-001
```

**RF-BANK-060: Creación de Cuenta en Sistema Core**

```
ID: RF-BANK-060
Título: Creación de Cuenta en Sistema Core Bancario
Prioridad: MUST (MoSCoW)
Categoría: Integración - Core Bancario

Descripción:
El sistema debe crear la cuenta bancaria en el sistema core,
generar número de cuenta y tarjeta, y configurar credenciales de acceso.

Criterios de Aceptación:
1. Crear registro de cuenta en sistema core bancario
2. Generar número de cuenta único (formato: XXXX-XXXX-XXXX-XXXX)
3. Generar número de tarjeta de débito
4. Crear usuario para banca digital
5. Operación debe ser atómica (rollback si falla algún paso)

Entrada:
- cliente_info: object {nombre, apellido, documento, email, teléfono, dirección}
- tipo_cuenta: "CAJA_AHORRO" | "CUENTA_CORRIENTE"

Salida:
{
  "cuenta_id": uuid,
  "numero_cuenta": string (formato XXXX-XXXX-XXXX-XXXX),
  "numero_tarjeta": string (16 dígitos),
  "usuario_digital": string,
  "contraseña_temporal": string,
  "estado": "ACTIVE"
}

Proceso:

1. Validar Pre-condiciones:
   - Cliente no debe tener cuenta activa existente
   - Datos del cliente deben estar completos
   - Score de riesgo debe estar aprobado

2. Generar Número de Cuenta:
   formato = BBBB-SSSS-TTTT-CCCC
   donde:
     BBBB = código de banco (4 dígitos)
     SSSS = código de sucursal (4 dígitos, "0000" para digital)
     TTTT = tipo de cuenta (4 dígitos)
     CCCC = número secuencial + checksum (4 dígitos)

3. Generar Número de Tarjeta:
   formato = BBBB-BBBB-BBBB-CCCC (16 dígitos)
   - Primeros 6 dígitos: BIN del banco
   - Siguientes 9 dígitos: número secuencial
   - Último dígito: checksum (algoritmo de Luhn)

4. Crear Usuario Digital:
   usuario = email del cliente
   contraseña_temporal = generar_aleatoria(12 caracteres)
   hash_contraseña = bcrypt(contraseña_temporal, salt_rounds=10)

5. Crear Cuenta en Core (Transacción):
   BEGIN TRANSACTION
     INSERT INTO accounts (numero_cuenta, tipo, cliente_id, saldo, estado)
     INSERT INTO cards (numero_tarjeta, cuenta_id, estado)
     INSERT INTO digital_users (usuario, password_hash, cuenta_id)
   COMMIT

6. Configurar Cuenta:
   - Saldo inicial: $0.00
   - Límite diario retiro: $10,000
   - Límite diario transferencia: $50,000
   - Estado: ACTIVE

7. Enviar Credenciales:
   enviar_email(cliente_email,
     "Bienvenido",
     "Tu cuenta: {numero_cuenta}, Usuario: {usuario}, Contraseña temporal: {contraseña}")
   enviar_sms(cliente_teléfono,
     "Cuenta creada: {numero_cuenta}")

Manejo de Errores:
- Si core bancario falla: Rollback completo, reintentar 3 veces
- Si envío de email falla: Guardar para reenvío posterior
- Si generación de número falla: Generar nuevo número

Trazabilidad:
- Proceso: PROC-BANK-ONBOARD-001 (crear cuenta)
- Caso de Uso: UC-BANK-001 (pasos 16-20)
- Prueba: TS-RF-BANK-060-001
```

**Requisitos No Funcionales:**

**RNF-BANK-010: Tiempo de Respuesta del Proceso**

```
ID: RNF-BANK-010
Título: Tiempo de Respuesta del Proceso de Onboarding
Categoría: Rendimiento

Descripción:
El proceso completo de apertura de cuenta debe completarse en
tiempo razonable para garantizar buena experiencia de usuario.

Métricas:
- P50 (mediana): <= 8 minutos
- P95 (percentil 95): <= 15 minutos
- P99 (percentil 99): <= 20 minutos

Tiempos por Fase:
- Formulario de datos: <= 3 minutos
- OCR de documento: <= 5 segundos
- Validación biométrica: <= 3 segundos
- Screening de riesgo: <= 10 segundos
- Creación en core bancario: <= 5 segundos

Condiciones:
- Bajo carga normal (<50 solicitudes simultáneas)
- Con todos los servicios operativos
```

**RNF-BANK-020: Disponibilidad del Servicio**

```
ID: RNF-BANK-020
Título: Disponibilidad del Servicio de Onboarding
Categoría: Disponibilidad

Descripción:
El servicio de onboarding debe estar disponible 24/7 con alta disponibilidad.

Métrica:
- SLA: 99.5% uptime mensual
- Downtime permitido: máx 3.6 horas/mes

Estrategias:
- Despliegue en múltiples zonas de disponibilidad
- Failover automático
- Circuit breakers para servicios externos
- Degradación elegante (modo offline parcial)
```

### 6. Procedimientos Operacionales

**PROC-BANK-MANUAL-REVIEW-001: Procedimiento de Revisión Manual de Solicitudes**

**Objetivo:** Guiar al oficial de cumplimiento en la revisión manual de solicitudes escaladas.

**Alcance:** Aplicable a oficiales de cumplimiento

**Responsable:** Oficial de Cumplimiento

**Casos que Requieren Revisión Manual:**
- Cliente en lista PEP o sanciones (RN-BANK-04)
- Score biométrico entre 0.70-0.84 (RN-BANK-03)
- Score de riesgo entre 50-59 (caso límite)
- Inconsistencias en datos del documento

**Pasos Detallados:**

| Paso | Pantalla | Acción | Validación |
|------|----------|--------|-----------|
| 1 | Dashboard Cumplimiento | Acceder a "Solicitudes Pendientes" | Sistema muestra lista ordenada por fecha |
| 2 | Lista de Solicitudes | Seleccionar solicitud en estado "PENDING_MANUAL_REVIEW" | Sistema carga detalles completos |
| 3 | Detalles del Cliente | Revisar datos personales: nombre, documento, dirección | Verificar consistencia |
| 4 | Documento Escaneado | Visualizar imagen del documento original | Verificar legibilidad y vigencia |
| 5 | Foto Selfie | Visualizar selfie del cliente | Comparar visualmente con foto del documento |
| 6 | Alerta de Riesgo | Leer motivo de escalación (PEP/Sanciones/Biometría/Score) | Evaluar gravedad |
| 7 | Investigación Adicional | Si PEP: Buscar información pública del individuo | Determinar si es la misma persona |
| 8 | Decisión | Determinar: APROBAR o RECHAZAR | - |
| 9a | Si APROBAR | Hacer clic en "Aprobar Solicitud" | Sistema solicita justificación |
| 9b | - | Escribir justificación (mín 50 caracteres) | - |
| 9c | - | Confirmar aprobación | Sistema crea cuenta (RF-BANK-060) |
| 10a | Si RECHAZAR | Hacer clic en "Rechazar Solicitud" | Sistema solicita motivo |
| 10b | - | Seleccionar motivo predefinido | - |
| 10c | - | Escribir detalle adicional | - |
| 10d | - | Confirmar rechazo | Sistema notifica cliente |
| 11 | Auditoría | - | Sistema registra decisión completa |

**Criterios de Decisión:**

**APROBAR:**
- PEP confirmado pero no relacionado con corrupción
- Biometría límite pero verificación visual es positiva
- Inconsistencias menores explicables

**RECHAZAR:**
- PEP con antecedentes de corrupción o lavado de dinero
- Biometría sospechosa (posible fraude)
- Documento falsificado o adulterado
- Datos inconsistentes sin explicación razonable

**SLA:**
- Revisión debe completarse en máximo 48 horas
- Casos CRITICAL: 24 horas

### 7. Trazabilidad Completa

**Matriz de Trazabilidad: Caso Apertura de Cuenta Bancaria**

| Proceso | Caso de Uso | Requisito Funcional | Requisito No Funcional | Regla de Negocio | Procedimiento |
|---------|-------------|---------------------|----------------------|-----------------|---------------|
| PROC-BANK-ONBOARD-001 | UC-BANK-001 | RF-BANK-010 | RNF-BANK-010 | RN-BANK-01 | - |
| PROC-BANK-ONBOARD-001 | UC-BANK-001 | RF-BANK-020 | - | RN-BANK-02 | - |
| PROC-BANK-ONBOARD-001 | UC-BANK-001 | RF-BANK-030 | - | RN-BANK-03 | PROC-BANK-MANUAL-REVIEW-001 |
| PROC-BANK-ONBOARD-001 | UC-BANK-001 | RF-BANK-040 | - | RN-BANK-04 | PROC-BANK-MANUAL-REVIEW-001 |
| PROC-BANK-ONBOARD-001 | UC-BANK-001 | RF-BANK-050 | - | RN-BANK-05 | - |
| PROC-BANK-ONBOARD-001 | UC-BANK-001 | RF-BANK-060 | RNF-BANK-020 | - | - |

**Flujo de Transformación:**

```
PROCESO DE NEGOCIO
(PROC-BANK-ONBOARD-001)
         |
         v
IDENTIFICACIÓN DE REGLAS DE NEGOCIO
(RN-BANK-01 a RN-BANK-05)
         |
         v
CASO DE USO
(UC-BANK-001: Solicitar Apertura de Cuenta)
         |
         v
DERIVACIÓN DE REQUISITOS
- Funcionales: RF-BANK-010 a RF-BANK-060
- No Funcionales: RNF-BANK-010, RNF-BANK-020
         |
         v
PROCEDIMIENTOS OPERACIONALES
(PROC-BANK-MANUAL-REVIEW-001)
         |
         v
IMPLEMENTACIÓN Y PRUEBAS
```

---

## Análisis Comparativo: Caso Genérico vs Casos IACT

### Similitudes

| Aspecto | Caso Genérico (Banco) | Casos IACT (Call Center) |
|---------|----------------------|-------------------------|
| **Estructura** | Proceso → UC → Requisitos → Procedimientos | Proceso → UC → Requisitos → Procedimientos |
| **Reglas de Negocio** | 5 reglas (edad, documentos, biometría, riesgo, score) | 14 reglas (RN-C01-01 a RN-C01-14) |
| **Validación Multinivel** | OCR → Biometría → Listas → Score | Credenciales → Sesión → Permisos (3 niveles) |
| **Auditoría** | Registro de eventos de onboarding | Registro de eventos de seguridad |
| **Revisión Manual** | Oficial de cumplimiento | Administrador/Supervisor |

### Diferencias

| Aspecto | Caso Genérico (Banco) | Casos IACT (Call Center) |
|---------|----------------------|-------------------------|
| **Dominio** | Banca digital, cumplimiento regulatorio | Call center, control de acceso |
| **Complejidad Técnica** | OCR, biometría, scoring de riesgo | Autenticación JWT, RBAC, auditoría |
| **Stakeholders** | Cliente externo, reguladores | Agentes internos, supervisores |
| **Criticidad** | Alta (dinero, identidad) | Alta (datos sensibles, operaciones) |
| **Tiempo de Proceso** | 5-10 minutos (automatizado) | < 1 segundo (login), 30 min (sesión) |

### Lecciones Aplicables al Proyecto IACT

1. **Validación Multinivel:** Ambos casos usan validación en cascada (cada nivel más específico)
2. **Manejo de Excepciones:** Flujos alternativos bien definidos para cada punto de falla
3. **Trazabilidad:** Registro completo de decisiones para auditoría y análisis
4. **Revisión Manual:** Escalación a humano cuando automatización no puede decidir
5. **Scoring:** Evaluación cuantitativa de riesgo/confianza para tomar decisiones

---

## Conclusión del Caso Didáctico

Este caso genérico de apertura de cuenta bancaria demuestra la aplicación del marco integrado en un dominio diferente al proyecto IACT, ilustrando:

1. **Universalidad del Marco:** Los patrones de transformación (Proceso → UC → Requisitos → Procedimientos) son aplicables a cualquier dominio
2. **Adaptabilidad:** Las mismas técnicas (trazabilidad, matrices, validación) funcionan tanto para call centers como para banca digital
3. **Escalabilidad:** El framework soporta desde casos simples (login) hasta complejos (onboarding con KYC/AML)
4. **Valor Pedagógico:** Ver el marco aplicado a diferentes dominios refuerza la comprensión de los conceptos fundamentales

**Métricas del Caso:**
- 1 Proceso de negocio
- 5 Reglas de negocio
- 1 Caso de uso principal
- 6 Flujos alternativos
- 6 Requisitos funcionales
- 2 Requisitos no funcionales
- 1 Procedimiento operacional

**Referencias Complementarias:**
- `05a_casos_practicos_iact.md` - Casos reales del proyecto IACT
- `04_metodologia_analisis_iact.md` - Metodología de 4 fases
- `06_plantillas_integradas_iact.md` - Plantillas para aplicar el marco

---

**Fin del Caso Didáctico Genérico**
