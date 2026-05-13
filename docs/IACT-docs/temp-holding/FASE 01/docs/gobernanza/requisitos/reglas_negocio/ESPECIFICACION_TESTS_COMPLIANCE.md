# Especificación de Tests de Compliance LFPDPPP

**Documento:** Especificación de Tests para Validación de Reglas de Negocio
**Versión:** 1.0
**Fecha:** 2025-11-14
**Principios:** Clean Code (Robert Martin), Clean Architecture (Uncle Bob)

---

## Principios de Diseño

### Independencia de Framework
> Uncle Bob: "The web should be a plugin to your application"

Los tests de reglas de negocio deben ser independientes de Django, Flask o cualquier framework web. Las reglas de negocio son el núcleo del sistema.

### Testability Without Framework
> Uncle Bob: "You should be able to test all your business rules without the web server running"

Los tests deben ejecutarse sin requerir ORM, servidores web o contexto de framework.

---

## Reglas de Negocio a Validar

### Regla: Datos Personales Deben Estar Encriptados

**ID de Referencia:** Mencionado como BR-R11 en documentación
**Descripción Legible:** Los datos personales de clientes (RFC, CURP) deben almacenarse encriptados en la base de datos
**Ley Aplicable:** LFPDPPP Art. 19

**Test Specification:**
```python
def test_rfc_encrypted_in_db():
    """
    Given a client with RFC "ABCD123456XYZ"
    When stored in database
    Then the database value should NOT equal plaintext
    And the application should decrypt automatically when retrieved
    """
    pass
```

**Implementación Esperada:**
- Campo debe usar EncryptedCharField o similar
- Algoritmo: AES-256 mínimo
- Key management: Variables de entorno o secrets manager

**Criterios de Aceptación:**
1. Valor en DB diferente a plaintext
2. Modelo desencripta automáticamente al leer
3. API responses muestran valor enmascarado (ejemplo: "****6ABC")

---

### Regla: Grabaciones Requieren Consentimiento Explícito

**ID de Referencia:** Mencionado como BR-R08 en documentación
**Descripción Legible:** No se puede crear una grabación de llamada sin consentimiento explícito del cliente
**Ley Aplicable:** LFPDPPP Art. 8

**Test Specification:**
```python
def test_recording_requires_consent():
    """
    Given a call in progress
    When attempting to create recording without consent flag
    Then the system should raise ValidationError
    And the error message should mention "consentimiento"
    """
    pass

def test_recording_with_consent():
    """
    Given a call in progress
    When creating recording with consent flag set to True
    Then the recording should be created successfully
    And consent_timestamp should be recorded
    """
    pass
```

**Implementación Esperada:**
- Modelo Grabacion con campo `grabacion_consentida` (Boolean, required)
- Modelo Grabacion con campo `consentimiento_timestamp` (DateTime, auto-set)
- Validación a nivel de modelo (clean method)

**Criterios de Aceptación:**
1. Grabación sin consentimiento rechazada
2. Grabación con consentimiento permitida
3. Timestamp registrado para auditoría

---

### Regla: Acceso a Datos Personales Debe Ser Auditado

**ID de Referencia:** Mencionado como BR-R12 en documentación
**Descripción Legible:** Todo acceso a datos personales debe quedar registrado en log de auditoría
**Ley Aplicable:** LFPDPPP Art. 22

**Test Specification:**
```python
def test_data_access_logged():
    """
    Given a user authenticated
    When accessing cliente personal data via API
    Then an audit log entry should be created
    And log should contain: user_id, resource_type, resource_id, action, timestamp, ip_address
    """
    pass

def test_failed_access_logged():
    """
    Given a user without permissions
    When attempting to access cliente data
    Then the failed attempt should be logged
    And log should indicate "acceso_denegado"
    """
    pass
```

**Implementación Esperada:**
- Middleware que intercepta requests a endpoints de datos personales
- Modelo LogAuditoria con campos: usuario, recurso_tipo, recurso_id, accion, timestamp, ip, user_agent, resultado
- Logging asíncrono para no impactar performance

**Criterios de Aceptación:**
1. GET request genera log
2. PATCH/PUT request genera log
3. Failed access genera log con resultado="acceso_denegado"
4. Logs incluyen IP y user agent

---

### Regla: Datos con Retención Cumplida Deben Ser Eliminados

**ID de Referencia:** Mencionado como BR-R13 en documentación
**Descripción Legible:** Grabaciones con más de 90 días deben ser marcadas para eliminación
**Ley Aplicable:** LFPDPPP Art. 11

**Test Specification:**
```python
def test_old_recording_flagged():
    """
    Given a recording created 100 days ago
    When running retention policy check
    Then the recording should be flagged for deletion
    """
    pass

def test_recent_recording_kept():
    """
    Given a recording created 30 days ago
    When running retention policy check
    Then the recording should NOT be flagged for deletion
    """
    pass
```

**Implementación Esperada:**
- Celery task periódica (diaria)
- Query: grabaciones con timestamp < (now - 90 days)
- Soft delete o flag `pendiente_eliminacion`
- Proceso manual final de eliminación física

**Criterios de Aceptación:**
1. Grabaciones >90 días marcadas
2. Grabaciones <90 días preservadas
3. Proceso de eliminación física requiere confirmación manual

---

## Estructura de Tests Recomendada

### Nivel 1: Tests Unitarios de Lógica de Negocio

**Sin dependencias de framework**

```python
# tests/unit/business_rules/test_encryption_rules.py

def test_rfc_requires_encryption():
    """Test that RFC values are recognized as requiring encryption."""
    from business_rules.data_protection import requires_encryption

    assert requires_encryption("rfc") == True
    assert requires_encryption("nombre") == False

def test_mask_rfc_last_four():
    """Test RFC masking logic."""
    from business_rules.data_protection import mask_rfc

    result = mask_rfc("ABCD123456XYZ")
    assert result == "****6XYZ"
```

### Nivel 2: Tests de Integración con Modelos

**Con dependencias de Django ORM**

```python
# tests/integration/models/test_cliente_data_protection.py

@pytest.mark.django_db
def test_rfc_encrypted_in_db():
    """Integration test for RFC encryption."""
    from callcentersite.clientes.models import Cliente

    cliente = Cliente.objects.create(
        nombre_completo="Test Cliente",
        rfc="TEST123456ABC"
    )

    # Query raw database value
    from django.db import connection
    with connection.cursor() as cursor:
        cursor.execute("SELECT rfc FROM clientes WHERE id = %s", [cliente.id])
        db_value = cursor.fetchone()[0]

    assert db_value != "TEST123456ABC"
    assert cliente.rfc == "TEST123456ABC"  # Model decrypts
```

### Nivel 3: Tests End-to-End de API

**Con dependencias de Django REST Framework**

```python
# tests/e2e/api/test_cliente_api_compliance.py

@pytest.mark.django_db
def test_api_masks_sensitive_data():
    """E2E test for API data masking."""
    client = APIClient()
    # Setup authenticated user

    response = client.get('/api/clientes/1/')
    data = response.json()

    assert 'rfc_masked' in data
    assert data['rfc_masked'].startswith('****')
    assert 'rfc' not in data  # Full value not exposed
```

---

## Implementación por Fases

### Fase 1: Especificación (ACTUAL)
- Documentar reglas de negocio
- Escribir especificaciones de tests
- Definir criterios de aceptación

### Fase 2: Implementación de Reglas
- Crear modelos con encriptación
- Implementar middleware de auditoría
- Configurar retention policies

### Fase 3: Tests Unitarios
- Tests de lógica pura (sin framework)
- Cobertura de casos edge
- Tests rápidos (<1s)

### Fase 4: Tests de Integración
- Tests con base de datos
- Tests con ORM Django
- Cobertura de flujos completos

### Fase 5: Tests E2E
- Tests de API completa
- Tests de flujos de usuario
- Performance tests

---

## Métricas de Compliance

### Métrica: Cobertura de Encriptación

**Definición:** Porcentaje de registros con datos personales que están encriptados

**Query:**
```sql
SELECT
    COUNT(*) as total_clientes,
    COUNT(CASE WHEN rfc IS NOT NULL THEN 1 END) as clientes_con_rfc,
    COUNT(CASE WHEN rfc IS NOT NULL THEN 1 END) * 100.0 / COUNT(*) as porcentaje_encriptacion
FROM clientes;
```

**Meta:** 100%

### Métrica: Cobertura de Consentimiento

**Definición:** Porcentaje de grabaciones con consentimiento registrado

**Query:**
```sql
SELECT
    COUNT(*) as total_grabaciones,
    COUNT(CASE WHEN grabacion_consentida = TRUE THEN 1 END) as con_consentimiento,
    COUNT(CASE WHEN grabacion_consentida = TRUE THEN 1 END) * 100.0 / COUNT(*) as porcentaje_consentimiento
FROM grabaciones;
```

**Meta:** 100%

### Métrica: Cobertura de Auditoría

**Definición:** Porcentaje de accesos a datos personales que fueron auditados

**Query:**
```sql
SELECT
    DATE(timestamp) as fecha,
    COUNT(DISTINCT recurso_id) as recursos_accedidos,
    COUNT(*) as total_logs
FROM auditoria_logs
WHERE recurso_tipo = 'Cliente'
GROUP BY DATE(timestamp)
ORDER BY fecha DESC;
```

**Meta:** 1 log por cada acceso

---

## Referencias

### Legales
- LFPDPPP: Ley Federal de Protección de Datos Personales en Posesión de los Particulares
- INAI: Instituto Nacional de Transparencia, Acceso a la Información y Protección de Datos Personales

### Técnicas
- Robert Martin - "Clean Code" (2008)
- Robert Martin - "Clean Architecture" (2017)
- Django Encrypted Model Fields: django-encrypted-model-fields
- Testing Best Practices: pytest-django

---

**Mantenedor:** Equipo de Arquitectura IACT
**Próxima Revisión:** 2025-12-14
