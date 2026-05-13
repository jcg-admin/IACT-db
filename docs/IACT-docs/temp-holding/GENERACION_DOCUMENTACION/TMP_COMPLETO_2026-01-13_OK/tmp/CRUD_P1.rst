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

