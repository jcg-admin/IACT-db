---
id: GUIA-onboarding-002
tipo: guia_operativa
categoria: onboarding
audiencia: desarrollador-nuevo
prioridad: P0
tiempo_lectura: 10 minutos
version: 1.0.0
fecha: 2025-11-07
relacionados: []
---

# Ejecutar Proyecto Localmente

## Proposito

Aprende a ejecutar el proyecto completo (backend + frontend) en tu entorno local.

## Audiencia

Esta guia esta dirigida a: desarrollador-nuevo

## Pre-requisitos

- [ ] Entorno de desarrollo configurado (Ver GUIA-ONBOARDING-001)
- [ ] Base de datos MySQL o PostgreSQL instalada
- [ ] Puertos 3000 y 8000 disponibles

## Tiempo estimado

Tiempo de lectura: 10 minutos
Tiempo de ejecucion: 20 minutos

## Pasos

### 1. Iniciar base de datos

Inicia MySQL o PostgreSQL localmente (según tu configuración).

**Comando**:
```bash
# Opción 1: Docker
docker-compose up -d mysql

# Opción 2: Servicio local
sudo systemctl start mysql
```

**Output esperado**:
```
Base de datos iniciada
```

### 2. Aplicar migraciones

Aplica las migraciones de Django para crear el esquema de BD.

**Comando**:
```bash
cd api
python manage.py migrate
```

**Output esperado**:
```
Migraciones aplicadas correctamente
```

### 3. Iniciar servidor backend

Inicia el servidor de desarrollo Django.

**Comando**:
```bash
python manage.py runserver 8000
```

**Output esperado**:
```
Starting development server at http://127.0.0.1:8000/
```

### 4. Iniciar servidor frontend

En otra terminal, inicia el servidor de desarrollo React.

**Comando**:
```bash
cd frontend
npm run dev
```

**Output esperado**:
```
Server running at http://localhost:3000
```

### 5. Verificar funcionamiento

Abre tu navegador y verifica que todo funcione.

**Comando**:
```bash
# Abre en navegador:
# http://localhost:3000 (Frontend)
# http://localhost:8000/admin (Backend Admin)
```

**Output esperado**:
```
Aplicación corriendo correctamente
```

{PASO_3_DESCRIPCION}

## Validacion

Para validar que completaste correctamente esta guia:

- [ ] Backend responde en http://localhost:8000/admin
- [ ] Frontend carga en http://localhost:3000
- [ ] No hay errores en consola de navegador
- [ ] Logs de servidor no muestran errores críticos

## Como interpretar resultados

**Exito**: {DESCRIPCION_EXITO}

**Errores comunes**: Ver seccion Troubleshooting

## Troubleshooting

### Error 1: Error de conexión a base de datos

**Sintomas**:
```
django.db.utils.OperationalError: Can't connect
```

**Causa**: Base de datos no está corriendo o credenciales incorrectas

**Solucion**:
```bash
Verifica que la BD esté corriendo:
docker-compose ps
# Verifica credenciales en .env
```

### Error 2: Puerto 8000 ya en uso

**Sintomas**:
```
Error: That port is already in use
```

**Causa**: Otro proceso usa el puerto 8000

**Solucion**:
```bash
Mata el proceso o usa otro puerto:
lsof -ti:8000 | xargs kill -9
# O usa otro puerto:
python manage.py runserver 8001
```

**Sintomas**: {ERROR_2_SINTOMAS}

**Causa**: {ERROR_2_CAUSA}

**Solucion**: {ERROR_2_SOLUCION}

## Proximos pasos

Despues de completar esta guia, puedes continuar con:

1. Ejecutar tests (Ver GUIA-TESTING-001)
2. Crear feature branch (Ver GUIA-WORKFLOWS-001)
3. Hacer primer commit (Ver GUIA-WORKFLOWS-002)

## Referencias

- Documentación Django: `https://docs.djangoproject.com/`
- Documentación React: `https://react.dev/`
- Procedimiento desarrollo local: `docs/gobernanza/procesos/procedimientos/procedimiento_desarrollo_local.md`

## Feedback

Si encuentras problemas con esta guia o tienes sugerencias:
- Crea un issue en GitHub con label `documentation`
- Contacta a: TBD

---

**Mantenedores**: @tech-lead, @backend-lead, @frontend-lead
**Ultima actualizacion**: 2025-11-07
