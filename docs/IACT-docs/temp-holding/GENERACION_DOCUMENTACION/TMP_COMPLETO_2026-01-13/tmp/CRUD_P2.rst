
----------------------------------------------------------------------
OPERACION 3: UPDATE (Actualizar Registro Existente)
----------------------------------------------------------------------

**Actor Principal:** Usuario con permiso de edición

**Objetivo:** Modificar datos de registro existente

**Precondiciones:**

PC-1: Usuario autenticado
PC-2: Usuario tiene permiso [MOD]-UPDATE
PC-3: Registro existe y no está eliminado (deleted_at IS NULL)

**Trigger:** Usuario hace click en "Editar" en listado o detalle

FLUJO NORMAL - UPDATE
~~~~~~~~~~~~~~~~~~~~~~

1. Sistema carga registro actual (FR-XXX-03-01)
   
   .. code-block:: sql
   
      SELECT 
          id,
          campo1,
          campo2,
          campo3,
          version_number,
          created_at,
          updated_at,
          status
      FROM entidad
      WHERE id = :uuid
        AND deleted_at IS NULL

2. Sistema muestra formulario PRE-LLENADO con valores actuales

3. Sistema marca campos modificables vs solo-lectura:
   - id: solo-lectura
   - created_at: solo-lectura
   - updated_at: solo-lectura
   - campo1, campo2, campo3: modificables

4. Sistema activa tracking de campos modificados (dirty fields)
   
   .. code-block:: javascript
   
      const originalValues = { ...formData };
      const dirtyFields = new Set();
      
      function trackChange(fieldName, newValue) {
          if (newValue !== originalValues[fieldName]) {
              dirtyFields.add(fieldName);
          } else {
              dirtyFields.delete(fieldName);
          }
      }

5. Usuario modifica uno o más campos

6. Usuario hace click en "Guardar Cambios"

7. Sistema valida SOLO campos modificados (FR-XXX-03-02)

8. Sistema verifica versión (Optimistic Locking) (FR-XXX-03-03)
   
   .. code-block:: sql
   
      SELECT version_number FROM entidad
      WHERE id = :uuid
   
   .. code-block:: python
   
      if db_version != form_version:
          raise ConcurrencyConflictError(
              "Registro modificado por otro usuario"
          )

9. Sistema captura valores ANTES del cambio (FR-XXX-03-04)
   
   .. code-block:: python
   
      before_values = {
          field: getattr(entity, field)
          for field in dirty_fields
      }

10. Sistema ejecuta UPDATE (FR-XXX-03-05)
    
    .. code-block:: sql
    
       UPDATE entidad
       SET 
           campo1 = :nuevo_campo1,
           campo2 = :nuevo_campo2,
           updated_at = NOW(),
           updated_by = :user_id,
           version_number = version_number + 1
       WHERE id = :uuid
         AND version_number = :expected_version
         AND deleted_at IS NULL

11. Sistema verifica que UPDATE afectó 1 fila
    
    .. code-block:: python
    
       if cursor.rowcount == 0:
           raise UpdateFailedError(
               "UPDATE did not affect any row. "
               "Possible concurrent modification."
           )

12. Sistema registra auditoría con before/after (FR-XXX-03-06)
    
    .. code-block:: sql
    
       INSERT INTO audit_log (
           action, table_name, record_id,
           user_id, old_values, new_values,
           created_at
       ) VALUES (
           'UPDATE', 'entidad', :uuid,
           :user_id,
           :before_json,  -- {"campo1": "old_val"}
           :after_json,   -- {"campo1": "new_val"}
           NOW()
       )

13. Sistema confirma transacción (COMMIT)

14. Sistema muestra mensaje:
    "Cambios guardados exitosamente. Campos actualizados: [lista]"

15. Sistema actualiza pantalla con nuevos valores y version_number+1

16. Sistema limpia set de dirty fields

17. Caso de uso termina exitosamente

**Postcondiciones:**

PC-E1: Registro actualizado en BD
PC-E2: version_number incrementado en 1
PC-E3: updated_at = NOW()
PC-E4: Auditoría completa (before/after) en audit_log

**Derivación a FR:**

- FR-XXX-03-01: Load Entity by ID
- FR-XXX-03-02: Validate Changed Fields
- FR-XXX-03-03: Check Version (Optimistic Lock)
- FR-XXX-03-04: Capture Before Values
- FR-XXX-03-05: UPDATE Entity
- FR-XXX-03-06: Audit Before/After

FA-7: Conflicto de Concurrencia (Optimistic Locking)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

En paso 8 o 11, si version_number no coincide:

  8a/11a. Sistema detecta conflicto:
          
          Expected version: 5
          Current DB version: 6
          
          Otro usuario modificó el registro mientras tú lo editabas.
  
  8b/11b. Sistema ejecuta ROLLBACK
  
  8c/11c. Sistema muestra modal de conflicto:
          
          "Conflicto de Concurrencia
          
          Otro usuario modificó este registro mientras tú lo editabas.
          
          Opciones:
          1. Ver cambios del otro usuario (refrescar)
          2. Sobrescribir con tus cambios (forzar)
          3. Cancelar tus cambios"
          
          [Refrescar] [Forzar] [Cancelar]
  
  8d/11d. Si usuario elige "Refrescar":
          - Sistema recarga datos actuales (vuelve a paso 1)
          - Sistema muestra diff de cambios:
            
            .. code-block:: text
            
               TUS CAMBIOS vs CAMBIOS DEL OTRO USUARIO:
               
               Campo1: "tu_valor" → "valor_otro_usuario"
               Campo2: sin cambios
          
          - Usuario decide qué hacer
  
  8e/11e. Si usuario elige "Forzar":
          - Sistema ejecuta UPDATE sin validar version
          - Sistema registra en audit_log:
            action='FORCE_UPDATE', severity='WARNING'
          - Sistema notifica al otro usuario de sobrescritura
          - Continúa flujo normal desde paso 10
  
  8f/11f. Si usuario elige "Cancelar":
          - Sistema descarta cambios
          - Caso de uso termina

**Derivación:** FR-XXX-03-03

FA-8: Usuario Deshace Cambios
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

En pasos 5-6, si usuario hace click en "Deshacer Cambios":

  5a/6a. Sistema muestra confirmación:
         
         "¿Deshacer cambios? Los siguientes campos volverán a su valor original:
          - campo1
          - campo2
          
          [Deshacer] [Continuar Editando]"
  
  5b/6b. Si usuario confirma "Deshacer":
         - Sistema restaura valores originales en formulario
         - Sistema limpia dirty fields
         - Sistema muestra mensaje: "Cambios descartados"
         - Vuelve a paso 4 (formulario en estado limpio)
  
  5c/6c. Si usuario elige "Continuar Editando":
         - Sistema mantiene formulario actual
         - Vuelve a paso 5

**Derivación:** No genera FR (UI estándar)

FE-3: Registro No Existe o Fue Eliminado
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

En paso 1, si SELECT retorna 0 filas:

  1a. Sistema detecta que registro no existe o está eliminado
  
  1b. Sistema registra en log:
      
      .. code-block:: python
      
         logger.warning(
             f"UPDATE failed: entity {uuid} not found. "
             f"User: {user_id}"
         )
  
  1c. Sistema muestra mensaje:
      
      "El registro que intentas editar no existe o fue eliminado.
       
       Posibles causas:
       - Registro eliminado por otro usuario
       - ID inválido
       - Sin permisos para ver este registro"
  
  1d. Sistema redirige a listado
  
  1e. Caso de uso termina sin éxito

**Derivación:** FR-XXX-03-01

----------------------------------------------------------------------
OPERACION 4: DELETE (Eliminar Registro - Soft Delete)
----------------------------------------------------------------------

**Actor Principal:** Usuario con permiso de eliminación

**Objetivo:** Marcar registro como eliminado (soft delete)

**Precondiciones:**

PC-1: Usuario autenticado
PC-2: Usuario tiene permiso [MOD]-DELETE
PC-3: Registro existe y no está ya eliminado
PC-4: Registro no tiene dependencias críticas

**Trigger:** Usuario hace click en "Eliminar" en listado o detalle

FLUJO NORMAL - DELETE
~~~~~~~~~~~~~~~~~~~~~~

1. Sistema muestra modal de confirmación:
   
   "¿Eliminar este registro?
   
   ID: [uuid]
   [Campo1]: [valor]
   [Campo2]: [valor]
   
   Esta acción marcará el registro como eliminado.
   Podrá ser recuperado por un administrador si es necesario.
   
   [Confirmar Eliminación] [Cancelar]"

2. Usuario hace click en "Confirmar Eliminación"

3. Sistema verifica dependencias (FR-XXX-04-01)
   
   .. code-block:: sql
   
      -- Verificar si otras tablas dependen de este registro
      SELECT COUNT(*) FROM tabla_dependiente
      WHERE entidad_id = :uuid
        AND deleted_at IS NULL
   
   .. code-block:: python
   
      dependencies = check_dependencies(entity_id)
      if dependencies.count > 0:
          raise DependencyError(
              f"Entity has {dependencies.count} dependencies"
          )

4. Sistema captura estado actual (before delete) (FR-XXX-04-02)
   
   .. code-block:: python
   
      before_delete = {
          'id': entity.id,
          'campo1': entity.campo1,
          'campo2': entity.campo2,
          'status': entity.status,
          'version_number': entity.version_number
      }

5. Sistema ejecuta SOFT DELETE (FR-XXX-04-03)
   
   .. code-block:: sql
   
      UPDATE entidad
      SET 
          deleted_at = NOW(),
          deleted_by = :user_id,
          status = 'DELETED',
          updated_at = NOW()
      WHERE id = :uuid
        AND deleted_at IS NULL

6. Sistema verifica que UPDATE afectó 1 fila

7. Sistema registra auditoría (FR-XXX-04-04)
   
   .. code-block:: sql
   
      INSERT INTO audit_log (
          action, table_name, record_id,
          user_id, old_values, new_values,
          created_at
       ) VALUES (
          'DELETE', 'entidad', :uuid,
          :user_id,
          :before_json,
          '{"deleted_at": "2026-01-09T10:30:00", "status": "DELETED"}',
          NOW()
      )

8. Sistema confirma transacción (COMMIT)

9. Sistema muestra mensaje:
   "Registro eliminado exitosamente. ID: [uuid]"

10. Sistema remueve fila de la tabla visual (con animación fade-out)

11. Si usuario está en pantalla de detalle:
    - Sistema redirige a listado

12. Caso de uso termina exitosamente

**Postcondiciones:**

PC-E1: Registro marcado con deleted_at = NOW()
PC-E2: status cambiado a 'DELETED'
PC-E3: Auditoría registrada
PC-E4: Registro NO visible en listados normales

**Notas sobre Soft Delete:**

- El registro sigue en la BD (no es DELETE físico)
- Puede ser recuperado por administrador
- Queries normales filtran con "WHERE deleted_at IS NULL"
- Reportes históricos pueden incluir registros eliminados

**Derivación a FR:**

- FR-XXX-04-01: Check Dependencies
- FR-XXX-04-02: Capture Before State
- FR-XXX-04-03: Soft Delete Entity
- FR-XXX-04-04: Audit Delete

FA-9: Registro Tiene Dependencias
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

En paso 3, si check de dependencias falla:

  3a. Sistema identifica dependencias existentes:
      
      .. code-block:: python
      
         dependencies = [
             {'table': 'ventas', 'count': 15},
             {'table': 'facturas', 'count': 8}
         ]
  
  3b. Sistema muestra advertencia:
      
      "No se puede eliminar este registro
      
      Tiene las siguientes dependencias:
      - 15 ventas asociadas
      - 8 facturas asociadas
      
      Opciones:
      1. Ver dependencias (para eliminarlas primero)
      2. Eliminar en cascada (PELIGROSO)
      3. Cancelar eliminación"
      
      [Ver Dependencias] [Eliminar en Cascada] [Cancelar]
  
  3c. Si usuario elige "Ver Dependencias":
      - Sistema muestra listado de dependencias
      - Usuario debe eliminar dependencias primero
      - Caso de uso termina
  
  3d. Si usuario elige "Eliminar en Cascada":
      - Sistema solicita confirmación adicional con contraseña
      - Sistema ejecuta soft delete en cascada:
        
        .. code-block:: sql
        
           -- Eliminar dependencias primero
           UPDATE tabla_dependiente
           SET deleted_at = NOW(), deleted_by = :user_id
           WHERE entidad_id = :uuid;
           
           -- Luego eliminar entidad principal
           UPDATE entidad
           SET deleted_at = NOW(), deleted_by = :user_id
           WHERE id = :uuid;
      
      - Sistema registra TODAS las eliminaciones en audit_log
      - Sistema muestra resumen: "Eliminados: 1 registro + 23 dependencias"
      - Continúa flujo normal desde paso 8
  
  3e. Si usuario elige "Cancelar":
      - Sistema cierra modal
      - Caso de uso termina

**Derivación:** FR-XXX-04-01

FA-10: Usuario Cancela Confirmación
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

En paso 2, si usuario hace click en "Cancelar":

  2a. Sistema cierra modal de confirmación
  
  2b. Sistema NO realiza cambios en BD
  
  2c. Sistema mantiene vista actual (listado o detalle)
  
  2d. Caso de uso termina sin eliminar

**Derivación:** No genera FR (UI estándar)

FE-4: Error de Integridad Referencial
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

En paso 5, si UPDATE falla por constraint FK:

  5a. Sistema captura IntegrityError
  
  5b. Sistema ejecuta ROLLBACK
  
  5c. Sistema registra error:
      
      .. code-block:: python
      
         logger.error(
             f"DELETE failed: integrity error. "
             f"Entity: {uuid}, Error: {str(e)}"
         )
  
  5d. Sistema muestra mensaje:
      
      "No se puede eliminar el registro debido a restricciones
       de integridad referencial.
       
       Código de error: ERR-DELETE-001
       
       Contacte al administrador del sistema."
  
  5e. Sistema envía alerta a equipo técnico
  
  5f. Caso de uso termina sin éxito

**Derivación:** FR-XXX-04-03 (error handling)

----------------------------------------------------------------------
EJEMPLO COMPLETO: ENTIDAD CLIENTE
----------------------------------------------------------------------

**Modelo de Datos:**

.. code-block:: sql

   CREATE TABLE clientes (
       id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
       nombre_completo VARCHAR(200) NOT NULL,
       email VARCHAR(100) NOT NULL UNIQUE,
       telefono VARCHAR(20),
       segmento VARCHAR(20) NOT NULL,  -- 'OP', 'MG', 'AD'
       
       created_at TIMESTAMP NOT NULL DEFAULT NOW(),
       created_by UUID REFERENCES users(id),
       updated_at TIMESTAMP,
       updated_by UUID REFERENCES users(id),
       deleted_at TIMESTAMP,
       deleted_by UUID REFERENCES users(id),
       
       version_number INTEGER NOT NULL DEFAULT 1,
       status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
       
       CONSTRAINT chk_segmento CHECK (segmento IN ('OP', 'MG', 'AD')),
       CONSTRAINT chk_status CHECK (status IN ('ACTIVE', 'INACTIVE', 'DELETED'))
   );
   
   CREATE INDEX idx_clientes_email ON clientes(email) WHERE deleted_at IS NULL;
   CREATE INDEX idx_clientes_deleted ON clientes(deleted_at) WHERE deleted_at IS NOT NULL;

**Código Python - CREATE Cliente:**

.. code-block:: python

   from uuid import uuid4
   from datetime import datetime
   
   def create_cliente(data, user_id):
       """
       Implements CREATE operation for Cliente entity.
       
       Corresponds to FR-CLI-01-01 through FR-CLI-01-06
       """
       # FR-CLI-01-02: Validate data
       errors = validate_cliente_data(data)
       if errors:
           raise ValidationError(errors)
       
       # FR-CLI-01-03: Check email uniqueness
       existing = session.query(Cliente).filter(
           Cliente.email == data['email'],
           Cliente.deleted_at == None
       ).first()
       
       if existing:
           raise UniqueConstraintError(
               f"Email {data['email']} already exists"
           )
       
       # FR-CLI-01-04: Generate UUID
       cliente_id = uuid4()
       
       # FR-CLI-01-05: INSERT
       cliente = Cliente(
           id=cliente_id,
           nombre_completo=data['nombre_completo'],
           email=data['email'],
           telefono=data.get('telefono'),
           segmento=data['segmento'],
           created_at=datetime.now(),
           created_by=user_id,
           version_number=1,
           status='ACTIVE'
       )
       
       session.add(cliente)
       
       # FR-CLI-01-06: Audit
       audit = AuditLog(
           action='CREATE',
           table_name='clientes',
           record_id=cliente_id,
           user_id=user_id,
           old_values=None,
           new_values=cliente.to_dict(),
           created_at=datetime.now()
       )
       session.add(audit)
       
       session.commit()
       
       return cliente

**Código Python - READ Clientes:**

.. code-block:: python

   def search_clientes(filters, page=1, page_size=25):
       """
       Implements READ operation with dynamic filters.
       
       Corresponds to FR-CLI-02-01 through FR-CLI-02-04
       """
       # FR-CLI-02-01: Build dynamic query
       query = session.query(Cliente).filter(
           Cliente.deleted_at == None
       )
       
       if filters.get('nombre'):
           query = query.filter(
               Cliente.nombre_completo.ilike(f"%{filters['nombre']}%")
           )
       
       if filters.get('segmento'):
           query = query.filter(
               Cliente.segmento == filters['segmento']
           )
       
       # FR-CLI-02-02: COUNT
       total = query.count()
       
       if total > 1000:
           raise TooManyResultsError(
               f"Query would return {total} results. Please add filters."
           )
       
       # FR-CLI-02-03: SELECT with pagination
       offset = (page - 1) * page_size
       clientes = query.order_by(
           Cliente.created_at.desc()
       ).limit(page_size).offset(offset).all()
       
       return {
           'data': [c.to_dict() for c in clientes],
           'total': total,
           'page': page,
           'page_size': page_size,
           'total_pages': (total + page_size - 1) // page_size
       }

**Código Python - UPDATE Cliente:**

.. code-block:: python

   def update_cliente(cliente_id, changes, expected_version, user_id):
       """
       Implements UPDATE with optimistic locking.
       
       Corresponds to FR-CLI-03-01 through FR-CLI-03-06
       """
       # FR-CLI-03-01: Load entity
       cliente = session.query(Cliente).filter(
           Cliente.id == cliente_id,
           Cliente.deleted_at == None
       ).first()
       
       if not cliente:
           raise EntityNotFoundError(f"Cliente {cliente_id} not found")
       
       # FR-CLI-03-03: Check version
       if cliente.version_number != expected_version:
           raise ConcurrencyConflictError(
               f"Version mismatch. Expected {expected_version}, "
               f"got {cliente.version_number}"
           )
       
       # FR-CLI-03-04: Capture before values
       before_values = {
           field: getattr(cliente, field)
           for field in changes.keys()
       }
       
       # FR-CLI-03-02: Validate changes
       errors = validate_cliente_data(changes, partial=True)
       if errors:
           raise ValidationError(errors)
       
       # FR-CLI-03-05: UPDATE
       for field, value in changes.items():
           setattr(cliente, field, value)
       
       cliente.updated_at = datetime.now()
       cliente.updated_by = user_id
       cliente.version_number += 1
       
       # FR-CLI-03-06: Audit
       audit = AuditLog(
           action='UPDATE',
           table_name='clientes',
           record_id=cliente_id,
           user_id=user_id,
           old_values=before_values,
           new_values=changes,
           created_at=datetime.now()
       )
       session.add(audit)
       
       session.commit()
       
       return cliente

**Código Python - DELETE Cliente:**

.. code-block:: python

   def delete_cliente(cliente_id, user_id):
       """
       Implements soft DELETE with dependency check.
       
       Corresponds to FR-CLI-04-01 through FR-CLI-04-04
       """
       cliente = session.query(Cliente).filter(
           Cliente.id == cliente_id,
           Cliente.deleted_at == None
       ).first()
       
       if not cliente:
           raise EntityNotFoundError(f"Cliente {cliente_id} not found")
       
       # FR-CLI-04-01: Check dependencies
       ventas_count = session.query(Venta).filter(
           Venta.cliente_id == cliente_id,
           Venta.deleted_at == None
       ).count()
       
       if ventas_count > 0:
           raise DependencyError(
               f"Cliente has {ventas_count} associated sales"
           )
       
       # FR-CLI-04-02: Capture before state
       before_values = cliente.to_dict()
       
       # FR-CLI-04-03: Soft delete
       cliente.deleted_at = datetime.now()
       cliente.deleted_by = user_id
       cliente.status = 'DELETED'
       cliente.updated_at = datetime.now()
       
       # FR-CLI-04-04: Audit
       audit = AuditLog(
           action='DELETE',
           table_name='clientes',
           record_id=cliente_id,
           user_id=user_id,
           old_values=before_values,
           new_values={
               'deleted_at': cliente.deleted_at.isoformat(),
               'status': 'DELETED'
           },
           created_at=datetime.now()
       )
       session.add(audit)
       
       session.commit()
       
       return True

----------------------------------------------------------------------
REFERENCIAS
----------------------------------------------------------------------

**Estándares:**

- STD_001_Estandares_Documentacion_1_1_0.rst
- NOM_001_Nomenclatura_Proyecto_2_0_0.rst

**Material Pedagógico:**

- PARTE_3A_CRUD_Patterns_IACT_1_0_0.md
- PARTE_4_Requisitos_Funcionales_IACT_1_0_0.md

----------------------------------------------------------------------

**Archivo:** TPL_UC_CRUD_Operaciones_1_2_0.rst  
**Version Template:** 1.2.0  
**Fecha:** 2026-01-09  
**Líneas:** ~1,000

