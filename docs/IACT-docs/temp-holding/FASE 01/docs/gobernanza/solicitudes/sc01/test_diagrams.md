---
id: TEST-PLANTUML-RENDER
estado: test
propietario: equipo-backend
fecha: 2025-11-04
relacionados: ["DOC-SOL-SC01"]
---
# Prueba de renderizado de diagramas PlantUML

Esta página prueba si el plugin Kroki renderiza correctamente diagramas PlantUML.

## Test 1: Diagrama inline simple

```plantuml
@startuml
actor Usuario
participant "Sistema IACT" as Sistema
database "Base de Datos" as BD

Usuario -> Sistema: Solicitar reporte
Sistema -> BD: Consultar métricas
BD --> Sistema: Retornar datos
Sistema --> Usuario: Mostrar reporte
@enduml
```

## Test 2: Diagrama de secuencia del proyecto

Diagrama real del proyecto UC-001:

```plantuml
@startuml UC-001 Generar Reporte de Métricas

actor "Analista de Datos" as Analista
participant "Dashboard Web" as Dashboard
participant "API Backend" as API
participant "Motor de Reportes" as Motor
participant "Módulo ETL" as ETL
database "PostgreSQL Analytics" as DB
database "MariaDB IVR" as IVR

Analista -> Dashboard: 1. Solicita reporte de métricas
activate Dashboard

Dashboard -> API: 2. GET /api/reports/metrics
activate API

API -> Motor: 3. generateMetricsReport(params)
activate Motor

Motor -> DB: 4. SELECT métricas agregadas
activate DB
DB --> Motor: 5. Datos históricos
deactivate DB

note right of Motor
  El motor verifica si los
  datos están actualizados
end note

alt Datos desactualizados
    Motor -> ETL: 6a. triggerETLUpdate()
    activate ETL
    ETL -> IVR: 7a. SELECT llamadas recientes
    activate IVR
    IVR --> ETL: 8a. Datos operacionales
    deactivate IVR
    ETL -> DB: 9a. INSERT/UPDATE métricas
    ETL --> Motor: 10a. Actualización completa
    deactivate ETL
end

Motor --> API: 11. Reporte generado (JSON)
deactivate Motor

API --> Dashboard: 12. HTTP 200 + JSON
deactivate API

Dashboard --> Analista: 13. Visualización del reporte
deactivate Dashboard

@enduml
```

## Test 3: Diagrama de casos de uso

```plantuml
@startuml Casos de Uso - Sistema IACT

left to right direction

actor "Analista de Datos" as Analista
actor "Administrador" as Admin
actor "Sistema IVR\n(Externo)" as IVR

rectangle "Sistema IACT - Call Center Analytics" {
  usecase "Generar Reporte\nde Métricas" as UC001
  usecase "Consultar Dashboard\nEn Tiempo Real" as UC002
  usecase "Procesar ETL" as UC003
  usecase "Gestionar Usuarios" as UC004
  usecase "Configurar Alertas" as UC005
}

Analista --> UC001
Analista --> UC002
Admin --> UC004
Admin --> UC005
UC003 --> IVR : << integra >>
UC001 ..> UC003 : << uses >>
UC002 ..> UC003 : << uses >>

@enduml
```

## Test 4: Diagrama de componentes

```plantuml
@startuml Arquitectura de Componentes

package "Frontend (Futuro)" {
  [Dashboard Web]
  [Visualizaciones]
}

package "Backend Django" {
  [API REST] as API
  [Analytics Engine]
  [ETL Engine]
  [Reports Generator]
  [Authentication]
}

package "Bases de Datos" {
  database "PostgreSQL\nAnalytics" as PG
  database "MariaDB\nIVR (Read-Only)" as Maria
}

[Dashboard Web] --> API
API --> [Analytics Engine]
API --> [Reports Generator]
API --> [Authentication]

[Analytics Engine] --> PG
[Reports Generator] --> PG
[ETL Engine] --> PG
[ETL Engine] --> Maria : read only

@enduml
```

## Test 5: Diagrama de actividad

```plantuml
@startuml Proceso ETL

start

:Scheduler ejecuta job ETL;

:Conectar a MariaDB (IVR);

if (Conexión exitosa?) then (sí)
  :Extraer datos desde IVR;

  :Aplicar transformaciones;
  note right
    - Limpieza de datos
    - Agregaciones
    - Cálculo de KPIs
  end note

  :Validar datos transformados;

  if (Datos válidos?) then (sí)
    :Conectar a PostgreSQL;

    :Cargar datos (UPSERT);

    :Commit transacción;

    :Registrar auditoría (éxito);

    stop

  else (no)
    :Registrar errores de validación;

    :Rollback transacción;

    :Enviar alerta;

    stop
  endif

else (no)
  :Registrar error de conexión;

  :Retry con backoff exponencial;

  if (Reintentos agotados?) then (sí)
    :Enviar alerta crítica;

    stop
  else (no)
    :Esperar y reintentar;
  endif
endif

@enduml
```

## Resultado esperado

Si el plugin Kroki está configurado correctamente, deberías ver:
- OK 5 diagramas renderizados como imágenes SVG
- OK Los diagramas deberían ser interactivos y escalables
- OK No deberían aparecer bloques de código PlantUML sin renderizar

## Verificación

Para verificar que funciona:
1. Ejecutar: `mkdocs serve -f docs/mkdocs.yml`
2. Abrir: http://127.0.0.1:8000
3. Navegar a esta página
4. Verificar que los diagramas se rendericen correctamente

## Troubleshooting

Si los diagramas NO se renderizan:
- NO Verificar que `mkdocs-kroki-plugin` esté instalado
- NO Verificar conexión a internet (Kroki usa https://kroki.io)
- NO Revisar configuración en `mkdocs.yml`:
  ```yaml
  plugins:
    - kroki:
        ServerURL: https://kroki.io
  ```
- NO Verificar que `pymdownx.superfences` esté en `markdown_extensions`
