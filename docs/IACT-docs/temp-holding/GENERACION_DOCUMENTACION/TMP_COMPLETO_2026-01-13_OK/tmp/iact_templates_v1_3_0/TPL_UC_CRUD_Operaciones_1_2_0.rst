.. meta::
   :Proyecto: IACT
   :Codigo: UC-IACT-XXX-YY
   :Titulo: CRUD de [Nombre Entidad]
   :Version: 4.0.0
   :Tipo: CRUD
   :Modulo: [MOD]
   :Fecha: YYYY-MM-DD
   :Autor: [Nombre BA]
   :Estado: DRAFT

======================================================================
UC-IACT-XXX-YY: CRUD de [Nombre Entidad]
======================================================================

**Proyecto:** IACT - IVR Analytics & Customer Tracking  
**Tipo:** CRUD (Create, Read, Update, Delete)  
**Modulo:** [RPT|AUTH|ACC|PIPE|DASH|ADMIN|API|NOTIF]

----------------------------------------------------------------------
INTRODUCCION AL TEMPLATE CRUD
----------------------------------------------------------------------

Este template documenta las 4 operaciones estándar de CRUD para
cualquier entidad del dominio.

**¿Qué es CRUD?**

CRUD son las operaciones básicas de persistencia:

- **C**reate: Crear nuevo registro
- **R**ead: Consultar/Listar registros
- **U**pdate: Modificar registro existente
- **D**elete: Eliminar registro

**¿Cuándo usar este template?**

Cuando necesites documentar operaciones de mantenimiento de datos
para una entidad del dominio (Cliente, Usuario, Producto, etc.).

**Patrones Implementados:**

1. **Validación en cliente y servidor**
2. **Unicidad verificada antes de INSERT**
3. **Optimistic Locking en UPDATE** (version_number)
4. **Soft Delete** (deleted_at, status='DELETED')
5. **Auditoría completa** (audit_log para todas las operaciones)
6. **Paginación** en listados
7. **Búsqueda dinámica** con filtros opcionales

**Estructura del Template:**

- CREATE Operation (flujo completo + 3 FA + 1 FE)
- READ Operation (búsqueda + listado + 3 FA + 1 FE)
- UPDATE Operation (edición + concurrencia + 2 FA + 1 FE)
- DELETE Operation (soft delete + dependencias + 2 FA + 1 FE)
- Ejemplo Completo: Entidad Cliente

----------------------------------------------------------------------
OPERACION 1: CREATE (Crear Nuevo Registro)
----------------------------------------------------------------------

**Actor Principal:** Usuario con permiso de creación

**Objetivo:** Crear nuevo registro en la base de datos

**Precondiciones:**

PC-1: Usuario autenticado
PC-2: Usuario tiene permiso [MOD]-CREATE
PC-3: Formulario de creación accesible

**Trigger:** Usuario hace click en "Crear Nuevo [Entidad]"

FLUJO NORMAL - CREATE
~~~~~~~~~~~~~~~~~~~~~~

1. Sistema muestra formulario vacío con campos de la entidad

2. Usuario completa campos obligatorios:
   - [Campo 1]: [tipo]
   - [Campo 2]: [tipo]
   - [Campo 3]: [tipo]

3. Usuario hace click en "Guardar"

4. Sistema valida datos en cliente (JavaScript) (FR-XXX-01-01)
   - Campos obligatorios no vacíos
   - Formatos correctos (email, teléfono, etc.)
   - Longitudes dentro de rango

5. Sistema envía POST request al backend

6. Sistema valida datos en servidor (FR-XXX-01-02)
   - Re-valida campos obligatorios
   - Verifica tipos de datos
   - Aplica reglas de negocio [BR-IACT-YYY]

7. Sistema verifica unicidad de campos únicos (FR-XXX-01-03)
   
   .. code-block:: sql
   
      SELECT COUNT(*) FROM entidad
      WHERE campo_unico = :valor
        AND deleted_at IS NULL

8. Sistema genera UUID para nuevo registro (FR-XXX-01-04)

9. Sistema ejecuta INSERT (FR-XXX-01-05)
   
   .. code-block:: sql
   
      INSERT INTO entidad (
          id,
          campo1,
          campo2,
          campo3,
          created_at,
          created_by,
          version_number,
          status
      ) VALUES (
          :uuid,
          :campo1,
          :campo2,
          :campo3,
          NOW(),
          :user_id,
          1,
          'ACTIVE'
      )

10. Sistema registra en audit_log (FR-XXX-01-06)
    
    .. code-block:: sql
    
       INSERT INTO audit_log (
           action, table_name, record_id,
           user_id, old_values, new_values,
           created_at
       ) VALUES (
           'CREATE', 'entidad', :uuid,
           :user_id, NULL, :json_values,
           NOW()
       )

11. Sistema confirma transacción (COMMIT)

12. Sistema muestra mensaje de éxito:
    "Registro creado exitosamente. ID: [uuid]"

13. Sistema redirige a pantalla de detalle del nuevo registro

14. Caso de uso termina exitosamente

**Postcondiciones de Éxito:**

PC-E1: Nuevo registro en tabla entidad con status='ACTIVE'
PC-E2: Registro en audit_log con action='CREATE'
PC-E3: Usuario ve pantalla de detalle

**Derivación a FR:**

- FR-XXX-01-01: Validar Formulario Cliente (JavaScript)
- FR-XXX-01-02: Validar Datos Servidor (Python)
- FR-XXX-01-03: Verificar Unicidad
- FR-XXX-01-04: Generar UUID
- FR-XXX-01-05: INSERT en Tabla
- FR-XXX-01-06: Registrar Auditoría

FA-1: Validación Falla (Cliente o Servidor)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

En paso 4 o 6, si validación falla:

  4a/6a. Sistema identifica campos con errores
  
  4b/6b. Sistema muestra mensajes específicos:
         
         .. code-block:: json
         
            {
              "campo1": "Este campo es obligatorio",
              "campo2": "Email inválido",
              "campo3": "Debe tener entre 5 y 100 caracteres"
            }
  
  4c/6c. Sistema mantiene valores ingresados (pre-llenados)
  
  4d/6d. Sistema marca campos con error (borde rojo)
  
  4e/6e. Vuelve a paso 2 (usuario corrige y reintenta)

**Derivación:** FR-XXX-01-02 (validación servidor)

FA-2: Campo Único Ya Existe
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

En paso 7, si verificación de unicidad falla:

  7a. Sistema detecta registro existente:
      
      .. code-block:: sql
      
         SELECT id, campo_unico FROM entidad
         WHERE campo_unico = :valor
           AND deleted_at IS NULL
         -- Retorna 1 fila
  
  7b. Sistema muestra error específico:
      
      "Ya existe un registro con [campo_unico] = '[valor]'.
       ID existente: [uuid]. No se puede crear duplicado."
  
  7c. Sistema sugiere acciones:
      - "Ver registro existente" (botón)
      - "Modificar valor de [campo_unico]" (botón)
  
  7d. Si usuario elige "Ver existente":
      - Redirige a pantalla de detalle del registro existente
      - Caso de uso termina
  
  7e. Si usuario elige "Modificar valor":
      - Vuelve a paso 2 con formulario pre-llenado
      - Usuario corrige campo único
      - Continúa flujo normal

**Derivación:** FR-XXX-01-03

FA-3: Usuario Cancela Creación
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

En pasos 2-3, si usuario hace click en "Cancelar":

  2a/3a. Sistema muestra confirmación:
         
         "¿Descartar cambios? Los datos ingresados se perderán."
         
         [Descartar] [Continuar Editando]
  
  2b/3b. Si usuario confirma "Descartar":
         - Sistema limpia formulario
         - Sistema redirige a listado de registros
         - Caso de uso termina sin guardar
  
  2c/3c. Si usuario elige "Continuar Editando":
         - Sistema mantiene formulario
         - Vuelve a paso 2

**Derivación:** No genera FR nuevo (UI estándar)

FE-1: Error de Base de Datos en INSERT
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

En paso 9, si INSERT falla (error BD):

  9a. Sistema captura exception (IntegrityError, DatabaseError)
  
  9b. Sistema ejecuta ROLLBACK de transacción
  
  9c. Sistema registra error en log:
      
      .. code-block:: python
      
         logger.error(
             f"CREATE failed for entidad. "
             f"User: {user_id}, Error: {str(e)}"
         )
  
  9d. Sistema muestra mensaje genérico al usuario:
      
      "Error al guardar el registro. Intente nuevamente.
       Si el problema persiste, contacte a soporte.
       Código de error: ERR-CREATE-001"
  
  9e. Sistema envía alerta a equipo técnico (Slack #tech-alerts)
  
  9f. Sistema mantiene datos en formulario (para que usuario no pierda info)
  
  9g. Caso de uso termina sin éxito

**Derivación:** FR-XXX-01-05 (manejo de errores)

**Postcondiciones de Fallo:**

PC-F1: No se creó registro en BD
PC-F2: Error registrado en logs
PC-F3: Alerta enviada a equipo técnico

----------------------------------------------------------------------
OPERACION 2: READ (Buscar y Listar Registros)
----------------------------------------------------------------------

**Actor Principal:** Usuario con permiso de lectura

**Objetivo:** Buscar y visualizar registros existentes

**Precondiciones:**

PC-1: Usuario autenticado
PC-2: Usuario tiene permiso [MOD]-READ
PC-3: Listado accesible

**Trigger:** Usuario accede a "Listado de [Entidades]"

FLUJO NORMAL - READ
~~~~~~~~~~~~~~~~~~~

1. Sistema muestra pantalla de búsqueda/listado con:
   - Formulario de filtros (opcional)
   - Tabla de resultados (vacía inicialmente)
   - Paginación (10/25/50/100 por página)

2. Usuario OPCIONALMENTE ingresa criterios de búsqueda:
   - Campo 1: [texto/dropdown/fecha]
   - Campo 2: [texto/dropdown/fecha]
   - Operador: [contiene/igual/mayor que/menor que]

3. Usuario hace click en "Buscar" (o presiona Enter)

4. Sistema construye query SQL dinámica (FR-XXX-02-01)
   
   .. code-block:: python
   
      def build_dynamic_query(filters):
          """Build WHERE clause from filters"""
          conditions = ["deleted_at IS NULL"]  # Exclude soft-deleted
          params = {}
          
          if filters.get('campo1'):
              conditions.append("campo1 ILIKE :campo1")
              params['campo1'] = f"%{filters['campo1']}%"
          
          if filters.get('campo2'):
              conditions.append("campo2 = :campo2")
              params['campo2'] = filters['campo2']
          
          where_clause = " AND ".join(conditions)
          return where_clause, params

5. Sistema ejecuta COUNT(*) con filtros (FR-XXX-02-02)
   
   .. code-block:: sql
   
      SELECT COUNT(*) as total
      FROM entidad
      WHERE deleted_at IS NULL
        AND campo1 ILIKE :campo1
        AND campo2 = :campo2

6. Sistema verifica que total < 1000 [BR-IACT-ZZZ]

7. Sistema ejecuta SELECT con paginación (FR-XXX-02-03)
   
   .. code-block:: sql
   
      SELECT 
          id,
          campo1,
          campo2,
          campo3,
          created_at,
          updated_at,
          status
      FROM entidad
      WHERE deleted_at IS NULL
        AND campo1 ILIKE :campo1
        AND campo2 = :campo2
      ORDER BY created_at DESC
      LIMIT :page_size OFFSET :offset

8. Sistema calcula info de paginación:
   - Total páginas = CEIL(total / page_size)
   - Página actual
   - Rango mostrado (ej: "1-10 de 45 registros")

9. Sistema renderiza tabla con resultados:
   - Columnas configurables
   - Acciones por fila: [Ver] [Editar] [Eliminar]
   - Ordenamiento por columna (click en header)

10. Sistema muestra panel de paginación:
    [<< Primera] [< Anterior] [1] [2] [3] [Siguiente >] [Última >>]

11. Usuario visualiza resultados

12. Caso de uso termina exitosamente

**Postcondiciones:**

PC-E1: Resultados mostrados en pantalla
PC-E2: Consulta registrada en audit_log (opcional para READ)

**Derivación a FR:**

- FR-XXX-02-01: Build Dynamic Query
- FR-XXX-02-02: Execute COUNT
- FR-XXX-02-03: Execute SELECT con Paginación
- FR-XXX-02-04: Renderizar Tabla

FA-4: Demasiados Resultados (> 1000)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

En paso 6, si COUNT > 1000:

  6a. Sistema NO ejecuta SELECT principal
  
  6b. Sistema muestra advertencia:
      
      "La búsqueda retornaría más de 1,000 registros ([total] encontrados).
       Por favor, agregue más filtros para refinar la búsqueda."
  
  6c. Sistema mantiene formulario de filtros pre-llenado
  
  6d. Sistema sugiere filtros adicionales
  
  6e. Vuelve a paso 2 (usuario refina búsqueda)

**Derivación:** FR-XXX-02-02

FA-5: Sin Resultados
~~~~~~~~~~~~~~~~~~~~

En paso 7, si SELECT retorna 0 filas:

  7a. Sistema muestra mensaje:
      
      "No se encontraron registros que cumplan los criterios.
       
       Sugerencias:
       - Verifique los filtros aplicados
       - Intente con criterios más amplios
       - Use búsqueda rápida por ID"
  
  7b. Sistema muestra botón "Limpiar Filtros"
  
  7c. Sistema muestra tabla vacía (headers visibles)
  
  7d. Si usuario hace click "Limpiar Filtros":
      - Sistema limpia formulario
      - Sistema ejecuta búsqueda sin filtros (todos los registros)
      - Continúa flujo normal desde paso 4

**Derivación:** FR-XXX-02-03

FA-6: Búsqueda Rápida por ID
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

En paso 2, si usuario ingresa ID exacto en campo especial:

  2a. Sistema detecta UUID válido en campo "ID"
  
  2b. Sistema ejecuta query directo (sin COUNT):
      
      .. code-block:: sql
      
         SELECT * FROM entidad
         WHERE id = :uuid
           AND deleted_at IS NULL
  
  2c. Si encuentra registro:
      - Sistema redirige DIRECTAMENTE a pantalla de detalle
      - Caso de uso termina
  
  2d. Si NO encuentra:
      - Sistema muestra "ID no encontrado o registro eliminado"
      - Vuelve a paso 2

**Derivación:** FR-XXX-02-05: Quick Search by ID

FE-2: Timeout de Query
~~~~~~~~~~~~~~~~~~~~~~

En paso 7, si SELECT excede timeout (5 segundos):

  7a. Sistema cancela query
  
  7b. Sistema registra timeout en log:
      
      .. code-block:: python
      
         logger.warning(
             f"READ query timeout. "
             f"Filters: {filters}, User: {user_id}"
         )
  
  7c. Sistema muestra mensaje:
      
      "La búsqueda tardó demasiado. Intente con menos filtros
       o contacte a soporte si el problema persiste.
       Código: ERR-TIMEOUT-002"
  
  7d. Caso de uso termina sin éxito

**Derivación:** FR-XXX-02-03 (timeout handling)


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

