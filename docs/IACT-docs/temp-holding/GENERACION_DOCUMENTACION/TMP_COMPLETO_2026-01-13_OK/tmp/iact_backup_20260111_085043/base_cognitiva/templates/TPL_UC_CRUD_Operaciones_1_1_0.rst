.. meta::
   :Proyecto: IACT
   :Codigo: UC-IACT-XXX-YY
   :Tipo: CRUD
   :Version: 4.0.0

======================================================================
UC-IACT-XXX-YY: [CRUD de Entidad]
======================================================================

CREATE: Crear Nueva Entidad
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1. Sistema muestra formulario vacío
2. Usuario ingresa datos
3. Usuario hace click en Guardar
4. Sistema valida (FR-XXX-01)
5. Sistema verifica unicidad (FR-XXX-02)
6. Sistema INSERT (FR-XXX-04)
7. Sistema muestra confirmación

READ: Buscar/Consultar
~~~~~~~~~~~~~~~~~~~~~~~
1. Sistema muestra formulario búsqueda
2. Usuario ingresa criterios
3. Sistema ejecuta SELECT (FR-XXX-07)
4. Sistema muestra resultados paginados

UPDATE: Actualizar
~~~~~~~~~~~~~~~~~~
1. Sistema muestra formulario pre-llenado
2. Usuario modifica campos
3. Sistema valida cambios (FR-XXX-09)
4. Sistema verifica version (optimistic lock)
5. Sistema UPDATE (FR-XXX-11)
6. Sistema registra auditoría

DELETE: Eliminar (Soft Delete)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1. Sistema muestra confirmación
2. Usuario confirma
3. Sistema verifica dependencias (FR-XXX-13)
4. Sistema UPDATE deleted_at (FR-XXX-14)
5. Sistema registra auditoría

**Archivo:** TPL_UC_CRUD_Operaciones_1_1_0.rst
**Version:** 1.1.0
