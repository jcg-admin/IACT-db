---
id: GUIA-onboarding-004
tipo: guia_operativa
categoria: onboarding
audiencia: desarrollador-nuevo
prioridad: P0
tiempo_lectura: 7 minutos
version: 1.0.0
fecha: 2025-11-07
relacionados: []
---

# Configurar Variables de Entorno

## Proposito

Aprende a configurar correctamente las variables de entorno necesarias para el proyecto.

## Audiencia

Esta guia esta dirigida a: desarrollador-nuevo

## Pre-requisitos

- [ ] Repositorio clonado
- [ ] Base de datos instalada

## Tiempo estimado

Tiempo de lectura: 7 minutos
Tiempo de ejecucion: 14 minutos

## Pasos

### 1. Copiar archivo de ejemplo

Crea tu archivo .env desde el template.

**Comando**:
```bash
cp .env.example .env
```

**Output esperado**:
```
.env creado
```

### 2. Configurar variables de base de datos

Configura las credenciales de tu base de datos local.

**Comando**:
```bash
# Edita .env:
DB_NAME=iact_dev
DB_USER=tu_usuario
DB_PASSWORD=tu_password
DB_HOST=localhost
DB_PORT=3306
```

**Output esperado**:
```
Variables de BD configuradas
```

### 3. Configurar SECRET_KEY de Django

Genera una secret key única para tu entorno.

**Comando**:
```bash
python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'
```

**Output esperado**:
```
Secret key generada
```

### 4. Verificar configuración

Verifica que todas las variables están configuradas.

**Comando**:
```bash
cd api
python manage.py check
```

**Output esperado**:
```
System check identified no issues
```

{PASO_3_DESCRIPCION}

## Validacion

Para validar que completaste correctamente esta guia:

- [ ] .env existe y tiene valores
- [ ] SECRET_KEY es única (no la del ejemplo)
- [ ] Credenciales de BD son correctas
- [ ] python manage.py check pasa

## Como interpretar resultados

**Exito**: {DESCRIPCION_EXITO}

**Errores comunes**: Ver seccion Troubleshooting

## Troubleshooting

### Error 1: SECRET_KEY inválida

**Sintomas**:
```
ImproperlyConfigured: The SECRET_KEY setting must not be empty
```

**Causa**: SECRET_KEY no está configurada en .env

**Solucion**:
```bash
Genera y agrega SECRET_KEY:
python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'
# Copia el output a .env
```

**Sintomas**: {ERROR_2_SINTOMAS}

**Causa**: {ERROR_2_CAUSA}

**Solucion**: {ERROR_2_SOLUCION}

## Proximos pasos

Despues de completar esta guia, puedes continuar con:

1. Ejecutar proyecto (Ver GUIA-ONBOARDING-002)
2. Configurar herramientas de desarrollo

## Referencias

- .env.example: `.env.example`
- Django settings: `api/config/settings.py`

## Feedback

Si encuentras problemas con esta guia o tienes sugerencias:
- Crea un issue en GitHub con label `documentation`
- Contacta a: TBD

---

**Mantenedores**: @tech-lead, @backend-lead
**Ultima actualizacion**: 2025-11-07
