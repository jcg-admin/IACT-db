---
id: GUIA-onboarding-001
tipo: guia_operativa
categoria: onboarding
audiencia: desarrollador-nuevo
prioridad: P0
tiempo_lectura: 15 minutos
version: 1.0.0
fecha: 2025-11-07
relacionados: []
---

# Configurar Entorno de Desarrollo Local

## Proposito

Aprende a configurar tu entorno de desarrollo local para trabajar en el proyecto IACT.

## Audiencia

Esta guia esta dirigida a: desarrollador-nuevo

## Pre-requisitos

- [ ] Python 3.11 o superior instalado
- [ ] Node.js 18 o superior instalado
- [ ] Git instalado y configurado
- [ ] Cuenta de GitHub con acceso al repositorio
- [ ] Editor de código (VS Code recomendado)

## Tiempo estimado

Tiempo de lectura: 15 minutos
Tiempo de ejecucion: 30 minutos

## Pasos

### 1. Verificar requisitos del sistema

Antes de comenzar, verifica que tu sistema cumple con los requisitos mínimos.

**Comando**:
```bash
python --version && node --version && git --version
```

**Output esperado**:
```
Python 3.11+, Node.js 18+, Git 2.x
```

### 2. Clonar el repositorio

Clona el repositorio del proyecto en tu máquina local.

**Comando**:
```bash
git clone https://github.com/2-Coatl/IACT---project.git
cd IACT---project
```

**Output esperado**:
```
Repositorio clonado exitosamente
```

### 3. Configurar variables de entorno

Copia el archivo .env.example y configura las variables necesarias.

**Comando**:
```bash
cp .env.example .env
# Edita .env con tus valores
```

**Output esperado**:
```
Archivo .env creado
```

### 4. Instalar dependencias backend

Instala las dependencias de Python para el backend Django.

**Comando**:
```bash
cd api
pip install -r requirements.txt
```

**Output esperado**:
```
Dependencias instaladas correctamente
```

### 5. Instalar dependencias frontend

Instala las dependencias de Node.js para el frontend React.

**Comando**:
```bash
cd frontend
npm install
```

**Output esperado**:
```
Dependencias instaladas correctamente
```

{PASO_3_DESCRIPCION}

## Validacion

Para validar que completaste correctamente esta guia:

- [ ] python --version muestra 3.11+
- [ ] node --version muestra 18+
- [ ] git status funciona sin errores
- [ ] Archivo .env existe y tiene valores configurados
- [ ] pip list muestra django instalado

## Como interpretar resultados

**Exito**: {DESCRIPCION_EXITO}

**Errores comunes**: Ver seccion Troubleshooting

## Troubleshooting

### Error 1: Error de permisos al clonar repositorio

**Sintomas**:
```
Permission denied (publickey)
```

**Causa**: SSH key no configurada en GitHub

**Solucion**:
```bash
Configura tu SSH key: ssh-keygen -t ed25519 -C 'tu@email.com'
cat ~/.ssh/id_ed25519.pub  # Agregar a GitHub
```

### Error 2: Versión de Python incorrecta

**Sintomas**:
```
Python 2.x o 3.x < 3.11
```

**Causa**: Sistema usa versión antigua de Python

**Solucion**:
```bash
Instala Python 3.11+ desde python.org o usa pyenv:
pyenv install 3.11.0
pyenv local 3.11.0
```

**Sintomas**: {ERROR_2_SINTOMAS}

**Causa**: {ERROR_2_CAUSA}

**Solucion**: {ERROR_2_SOLUCION}

## Proximos pasos

Despues de completar esta guia, puedes continuar con:

1. Ejecutar tests localmente (Ver guía GUIA-TESTING-001)
2. Crear tu primer feature branch (Ver guía GUIA-WORKFLOWS-001)
3. Ejecutar el proyecto localmente (Ver guía GUIA-ONBOARDING-002)

## Referencias

- Procedimiento completo: `docs/gobernanza/procesos/procedimientos/procedimiento_instalacion_entorno.md`
- Requisitos del sistema: `README.md`
- Troubleshooting avanzado: `docs/guias/troubleshooting/01-problemas-comunes-setup.md`

## Feedback

Si encuentras problemas con esta guia o tienes sugerencias:
- Crea un issue en GitHub con label `documentation`
- Contacta a: TBD

---

**Mantenedores**: @tech-lead, @devops-lead
**Ultima actualizacion**: 2025-11-07
