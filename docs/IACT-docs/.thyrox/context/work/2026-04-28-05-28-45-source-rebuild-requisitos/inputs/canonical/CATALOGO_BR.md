# CATALOGO_BR.md

## 1. Definición y Alcance

El Catálogo de Reglas de Negocio (BR-XXX) es el **Nivel 1 de Trazabilidad** del estándar IACT (TRZ-001). Cada regla aquí definida debe ser citada como **Precondición** o **Regla Asociada** en al menos un Caso de Uso Completo (UC-V2).

El contenido de este catálogo se gestiona mediante el módulo **`politicas`** (`PoliticaService` y `Politica` Model), asegurando que solo las versiones con estado `'publicada'` son válidas para el código.

## 2. Estructura Formal de una Regla de Negocio (BR)

Cada artefacto BR debe seguir el formato formal para asegurar su trazabilidad:

| Campo | Definición | Fuente de Dato |
| :--- | :--- | :--- |
| **ID BR** | Identificador único y estático (ej: BR-NEG-001). | Manual/Decisión de Negocio |
| **Título** | Resumen de la regla. | `politicas.models.Politica.titulo` |
| **Versión** | Número de versión publicado. | `politicas.models.Politica.version` |
| **Estado** | Estado de Gobernanza. Solo 'Publicada' es ejecutable. | `politicas.models.Politica.estado` |
| **Contenido Detallado** | La especificación técnica y legal de la regla. | `politicas.models.Politica.contenido` |

## 3. Ejemplo de Reglas de Negocio (BR)

A continuación, se listan ejemplos de reglas que deben formalizarse y que afectan a los módulos `llamadas` y `analytics` (Dashboard):

| ID BR | Título | Módulo Impactado | Descripción (Contenido Resumido) |
| :--- | :--- | :--- | :--- |
| **BR-NEG-001** | **Regla de Consistencia de Datos para Dashboard** | `llamadas`, `analytics` | Para el cálculo de la métrica "Llamadas Atendidas", solo se deben considerar los registros que tengan `fecha_fin` NO nula y un `estado` final de tipo `'EXITOSA'` o `'FALLIDA_VALIDA'`. |
| **BR-NEG-008** | **Criterio de Inactividad de Agente** | `users`, `llamadas` | Un Agente es considerado 'inactivo' en el dashboard si no ha registrado una llamada en los últimos 30 minutos y su sesión no está 'activa'. (Impacta el servicio `obtener_estadisticas_agente`). |
| **BR-SEG-007** | **Requisito de Permiso para Registro** | `llamadas` | Un usuario debe poseer el permiso `LLAMADA-REG-001` para ejecutar la acción de registrar una llamada entrante (UC-010). *Esta regla proviene del módulo `permissions`.* |

## 4. Gobernanza de BRs (Basado en `PoliticaService`)

El proceso de gobernanza del BR es una **RNF de Proceso (RNF-PROC-003)**:

| Flujo de Gobernanza | Servicio Implementador | Implicación de Trazabilidad |
| :--- | :--- | :--- |
| **Creación (Borrador)** | `PoliticaService.crear_politica` | La regla existe, pero el código **no debe** implementarla aún. |
| **Publicación (Activa)** | `PoliticaService.publicar_politica` | La regla se vuelve la **referencia oficial** (Nivel 1) y el código **debe** implementarla. |
| **Nueva Versión** | `PoliticaService.nueva_version` | El cambio en la `Politica.version` **requiere** una nueva versión del Caso de Uso (UC-V2) y del servicio implementador (Nivel 5). |
