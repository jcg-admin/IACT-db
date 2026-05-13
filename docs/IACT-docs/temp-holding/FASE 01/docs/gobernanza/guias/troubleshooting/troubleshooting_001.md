---
id: GUIA-troubleshooting-001
tipo: guia_operativa
categoria: troubleshooting
audiencia: desarrollador-nuevo
prioridad: P0
tiempo_lectura: 15 minutos
version: 1.0.0
fecha: 2025-11-07
relacionados: []
---

# Problemas Comunes de Setup

## Proposito

Soluciones a los problemas más comunes al configurar el entorno de desarrollo.

## Audiencia

Esta guia esta dirigida a: desarrollador-nuevo

## Pre-requisitos

- [ ] Acceso al sistema
- [ ] Permisos de instalación de software

## Tiempo estimado

Tiempo de lectura: 15 minutos
Tiempo de ejecucion: 30 minutos

## Pasos

### 1. Diagnosticar el problema

Identifica en qué categoría cae tu problema.

**Comando**:
```bash
# Categorías comunes:
# 1. Problemas de instalación (Python, Node)
# 2. Problemas de base de datos
# 3. Problemas de permisos
# 4. Problemas de dependencias
# 5. Problemas de red/proxy
```

**Output esperado**:
```
Categoría identificada
```

### 2. Aplicar solución correspondiente

Busca tu problema en la sección de troubleshooting.

**Comando**:
```bash
# Ver secciones abajo para soluciones específicas
```

**Output esperado**:
```
Solución encontrada
```

### 3. Verificar que se resolvió

Ejecuta comando de verificación.

**Comando**:
```bash
# Según el problema:
python --version
node --version
git --version
pip list
npm list
```

**Output esperado**:
```
Problema resuelto
```

{PASO_3_DESCRIPCION}

## Validacion

Para validar que completaste correctamente esta guia:

- [ ] Problema identificado correctamente
- [ ] Solución aplicada
- [ ] Verificación exitosa

## Como interpretar resultados

**Exito**: {DESCRIPCION_EXITO}

**Errores comunes**: Ver seccion Troubleshooting

## Troubleshooting

### Error 1: Python version incorrecta

**Sintomas**:
```
python --version muestra 2.x o 3.x < 3.11
```

**Causa**: Sistema operativo usa versión antigua

**Solucion**:
```bash
# Opción 1: Instalar desde python.org
# Opción 2: Usar pyenv
curl https://pyenv.run | bash
pyenv install 3.11.0
pyenv global 3.11.0
```

### Error 2: Node version incorrecta

**Sintomas**:
```
node --version muestra < 18
```

**Causa**: Versión antigua de Node.js

**Solucion**:
```bash
# Usar nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 18
nvm use 18
```

### Error 3: Error de conexión a MySQL

**Sintomas**:
```
Can't connect to MySQL server
```

**Causa**: MySQL no está corriendo o credenciales incorrectas

**Solucion**:
```bash
# Verificar que MySQL corre:
sudo systemctl status mysql
# Si no corre, iniciarlo:
sudo systemctl start mysql
# Verificar credenciales en .env
```

### Error 4: Permission denied al instalar dependencias

**Sintomas**:
```
EACCES: permission denied
```

**Causa**: Falta de permisos para escribir en directorio

**Solucion**:
```bash
# NO uses sudo con npm
# Configura npm prefix:
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
# Agrega a PATH en ~/.bashrc:
export PATH=~/.npm-global/bin:$PATH
```

### Error 5: Port already in use

**Sintomas**:
```
Error: listen EADDRINUSE: address already in use :::3000
```

**Causa**: Otro proceso usa el puerto

**Solucion**:
```bash
# Encuentra y mata el proceso:
lsof -ti:3000 | xargs kill -9
# O usa otro puerto:
PORT=3001 npm run dev
```

### Error 6: Module not found

**Sintomas**:
```
ModuleNotFoundError: No module named 'X'
```

**Causa**: Dependencia no instalada o PYTHONPATH incorrecto

**Solucion**:
```bash
# Reinstalar dependencias:
pip install -r requirements.txt
# O agregar a PYTHONPATH:
export PYTHONPATH=$PYTHONPATH:$(pwd)/api
```

**Sintomas**: {ERROR_2_SINTOMAS}

**Causa**: {ERROR_2_CAUSA}

**Solucion**: {ERROR_2_SOLUCION}

## Proximos pasos

Despues de completar esta guia, puedes continuar con:

1. Completar setup de entorno (Ver GUIA-ONBOARDING-001)
2. Ejecutar proyecto (Ver GUIA-ONBOARDING-002)
3. Si problema persiste: crear issue en GitHub con label 'help-wanted'

## Referencias

- Documentación completa setup: `docs/gobernanza/procesos/procedimientos/procedimiento_instalacion_entorno.md`
- Requisitos del sistema: `README.md#requirements`
- Canal de ayuda: `#dev-help en Slack`

## Feedback

Si encuentras problemas con esta guia o tienes sugerencias:
- Crea un issue en GitHub con label `documentation`
- Contacta a: TBD

---

**Mantenedores**: @tech-lead, @devops-lead
**Ultima actualizacion**: 2025-11-07
