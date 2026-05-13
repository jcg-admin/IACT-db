# Guía de Resolución: Error 403 al Instalar GitHub Copilot CLI

## NOTA Tabla de Contenidos
1. [Contexto](#contexto)
2. [Información Crítica](#información-crítica)
3. [Requisitos Previos](#requisitos-previos)
4. [Diagnóstico del Error 403](#diagnóstico-del-error-403)
5. [Soluciones por Causa](#soluciones-por-causa)
6. [Proceso de Instalación](#proceso-de-instalación)
7. [Autenticación Post-Instalación](#autenticación-post-instalación)
8. [Validaciones](#validaciones)
9. [Evidencias a Documentar](#evidencias-a-documentar)
10. [Escalamiento](#escalamiento)
11. [Referencias](#referencias)

---

## Contexto

Esta guía aborda el error `403 Forbidden` que puede ocurrir en estaciones corporativas al intentar instalar GitHub Copilot CLI mediante el comando `npm install -g @github/copilot` desde `registry.npmjs.org`.

### Alcance
- **Sistemas operativos**: Linux, macOS, Windows (vía WSL o PowerShell 6+)
- **Entorno**: Redes corporativas con posibles restricciones de proxy/firewall
- **Paquete objetivo**: `@github/copilot` (versión oficial actual)

---

## Información Crítica

### WARNING Aclaraciones Importantes

**El paquete `@github/copilot` se distribuye a través del registro PÚBLICO de npm**
- OK Registry correcto: `https://registry.npmjs.org/`
- NO NO requiere GitHub Packages (`npm.pkg.github.com`)
- NO NO requiere tokens con scope `read:packages` para instalación
- OK La autenticación con GitHub es POSTERIOR a la instalación

### Diferencia entre Instalación y Autenticación

| Fase | Qué se hace | Requiere |
|------|-------------|----------|
| **Instalación** | Descargar el paquete npm | Acceso a `registry.npmjs.org` |
| **Autenticación** | Vincular con cuenta GitHub | Suscripción Copilot + comando `/login` o PAT |

---

## Requisitos Previos

### Software Requerido
```bash
# Verificar versiones
node --version  # Debe ser >= v22.0.0
npm --version   # Debe ser >= 10.0.0
```

Si las versiones son inferiores, actualizar Node.js y npm:
```bash
# Actualizar npm a la última versión
npm install -g npm@latest

# Para Node.js, usar nvm (recomendado) o descargar desde nodejs.org
```

### Permisos y Accesos
- [ ] Permisos de instalación global de paquetes npm (`sudo` en Linux/Mac si es necesario)
- [ ] Acceso de red a `registry.npmjs.org` y subdominios `*.npmjs.org`
- [ ] Suscripción activa a GitHub Copilot (Individual, Business o Enterprise)
- [ ] Credenciales de proxy corporativo (si aplica)

### Verificación de Acceso a Copilot
- Confirmar suscripción activa en: https://github.com/settings/copilot
- Si tienes acceso vía organización, verificar que el administrador haya habilitado Copilot CLI
- Documentación: [Managing policies for GitHub Copilot](https://docs.github.com/en/copilot/managing-copilot/managing-policies-and-features-for-copilot-in-your-organization)

---

## Diagnóstico del Error 403

### Paso 1: Verificar Configuración Actual de npm

```bash
# 1. Verificar registry configurado
npm config get registry
# Salida esperada: https://registry.npmjs.org/

# 2. Verificar configuración de proxy (si aplica)
npm config get proxy
npm config get https-proxy

# 3. Ver configuración completa
npm config list

# 4. Verificar archivo .npmrc del usuario
cat ~/.npmrc

# 5. Verificar archivo .npmrc global (si existe)
cat $(npm config get globalconfig)
```

### Paso 2: Intentar Instalación con Modo Verbose

```bash
# Intentar instalación con logs detallados
npm install -g @github/copilot --verbose 2>&1 | tee copilot-install.log
```

Analizar el log generado para identificar:
- ¿A qué URL exacta intenta conectarse?
- ¿Cuál es el código de error HTTP completo?
- ¿Hay menciones de proxy, SSL o certificados?

### Paso 3: Identificar la Causa Raíz

Revisa los síntomas y mapea a la causa correspondiente:

| Síntoma | Causa Probable | Sección de Solución |
|---------|----------------|---------------------|
| Registry no apunta a `registry.npmjs.org` | Registry mal configurado | [Solución 1](#solución-1-restablecer-configuración-de-registry) |
| Error menciona proxy o ECONNREFUSED | Proxy no configurado | [Solución 2](#solución-2-configurar-proxy-corporativo) |
| 403 persiste con registry correcto | Firewall/DLP corporativo | [Solución 3](#solución-3-gestionar-restricciones-corporativas) |
| `.npmrc` tiene configuraciones de GitHub Packages | Configuración conflictiva | [Solución 4](#solución-4-limpiar-configuraciones-conflictivas) |
| Error de certificado SSL | Certificados corporativos | [Solución 5](#solución-5-resolver-problemas-de-certificados-ssl) |

---

## Soluciones por Causa

### Solución 1: Restablecer Configuración de Registry

Si el registry no apunta al registro público de npm:

```bash
# Establecer registry público oficial
npm config set registry https://registry.npmjs.org/

# Verificar que el cambio se aplicó
npm config get registry

# Limpiar caché de npm para evitar conflictos
npm cache clean --force

# Intentar nuevamente la instalación
npm install -g @github/copilot
```

### Solución 2: Configurar Proxy Corporativo

Si tu red corporativa requiere proxy:

```bash
# Opción A: Configurar vía comando npm
npm config set proxy http://usuario:password@proxy.empresa.com:8080
npm config set https-proxy http://usuario:password@proxy.empresa.com:8080

# Opción B: Configurar vía variables de entorno
export HTTP_PROXY="http://usuario:password@proxy.empresa.com:8080"
export HTTPS_PROXY="http://usuario:password@proxy.empresa.com:8080"

# Verificar configuración
npm config get proxy
npm config get https-proxy

# Intentar instalación
npm install -g @github/copilot
```

**Nota sobre credenciales en proxy:**
- Si el proxy requiere autenticación, incluye `usuario:password@` en la URL
- Para caracteres especiales en la contraseña, codificarlos en URL (ej: `@` -> `%40`)
- Considera usar variables de entorno para no guardar contraseñas en archivos

### Solución 3: Gestionar Restricciones Corporativas

Si sospechas que hay un firewall o DLP bloqueando:

#### Paso 3.1: Probar desde otra red
```bash
# Intentar desde una red móvil o personal
# Si funciona, confirma que es restricción corporativa
npm install -g @github/copilot
```

#### Paso 3.2: Solicitar apertura de dominios
Enviar solicitud al equipo de seguridad/networking para permitir acceso a:
- `registry.npmjs.org`
- `*.npmjs.org`
- `*.cloudfront.net` (CDN usado por npm)

**Template de solicitud:**
```
Asunto: Solicitud de acceso a registry.npmjs.org para GitHub Copilot CLI

Descripción: Se requiere acceso desde estaciones corporativas a los siguientes 
dominios para instalar GitHub Copilot CLI (herramienta oficial de GitHub incluida 
en nuestra suscripción empresarial):

Dominios requeridos:
- registry.npmjs.org
- *.npmjs.org
- *.cloudfront.net

Protocolo: HTTPS (puerto 443)

Justificación: Instalación de herramientas de desarrollo autorizadas

Evidencia de bloqueo: [Adjuntar log de npm con error 403]
```

### Solución 4: Limpiar Configuraciones Conflictivas

Si tienes configuraciones previas que causan conflictos:

```bash
# 1. Hacer backup del .npmrc actual
cp ~/.npmrc ~/.npmrc.backup.$(date +%Y%m%d_%H%M%S)

# 2. Revisar contenido del archivo
cat ~/.npmrc

# 3. Buscar líneas problemáticas (ejemplos de qué ELIMINAR):
# @github:registry=https://npm.pkg.github.com
# //npm.pkg.github.com/:_authToken=...
# @githubnext:registry=https://npm.pkg.github.com

# 4. Editar el archivo y eliminar configuraciones de GitHub Packages
nano ~/.npmrc  # o vim, o tu editor preferido

# 5. Alternativamente, recrear con configuración mínima
cat > ~/.npmrc <<'RC'
proxy=http://proxy.empresa.com:8080
https-proxy=http://proxy.empresa.com:8080
RC

# 7. Verificar el archivo resultante
cat ~/.npmrc

# 8. Limpiar caché
npm cache clean --force

# 9. Intentar instalación
npm install -g @github/copilot
```

### Solución 5: Resolver Problemas de Certificados SSL

Si el error menciona certificados SSL o UNABLE_TO_VERIFY:

```bash
# Opción A: Desactivar verificación SSL (NO RECOMENDADO para producción)
npm config set strict-ssl false

# Opción B: Configurar certificados corporativos
# Obtener el certificado CA de tu empresa (archivo .crt o .pem)
npm config set cafile /ruta/al/certificado-corporativo.crt

# Opción C: Usar el almacén de certificados del sistema
npm config set ca null

# Verificar configuración
npm config get strict-ssl
npm config get cafile

# Intentar instalación
npm install -g @github/copilot
```

---

## Proceso de Instalación

Una vez resuelto el error 403, proceder con la instalación:

### Instalación Estándar

```bash
# Instalación global
npm install -g @github/copilot

# Verificar instalación exitosa
which copilot    # En Linux/Mac
where copilot    # En Windows

# Verificar versión instalada
copilot --version
```

### Instalación con Logs Detallados (Troubleshooting)

```bash
# Si necesitas logs para debugging
npm install -g @github/copilot --verbose --loglevel verbose 2>&1 | tee install.log
```

### Verificación de Binario

```bash
# Verificar que el comando copilot esté disponible
copilot --version

# Si no se encuentra, verificar PATH
echo $PATH

# Obtener la ubicación del prefijo global de npm
npm config get prefix

# Agregar al PATH si es necesario (Linux/Mac)
export PATH="$(npm config get prefix)/bin:$PATH"

# Agregar al PATH permanentemente (Linux/Mac)
echo 'export PATH="$(npm config get prefix)/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

---

## Autenticación Post-Instalación

**IMPORTANTE**: La autenticación se realiza DESPUÉS de instalar exitosamente el CLI.

### Método 1: Autenticación Interactiva (Recomendado)

```bash
# Iniciar Copilot CLI
copilot

# Al primer uso, verás un banner de bienvenida
# Si no estás autenticado, ejecutar dentro de la CLI:
/login

# Seguir las instrucciones en pantalla:
# 1. Se mostrará un código de dispositivo
# 2. Se abrirá automáticamente tu navegador
# 3. Ingresar el código en GitHub
# 4. Autorizar la aplicación
# 5. Regresar al terminal (la autenticación se completará automáticamente)
```

### Método 2: Autenticación con Personal Access Token (PAT)

Para entornos automatizados o sin navegador:

#### Paso 1: Generar PAT
1. Ir a: https://github.com/settings/tokens?type=beta
2. Clic en "Generate new token" -> "Fine-grained personal access token"
3. Configurar:
   - **Token name**: `Copilot CLI - [Nombre Máquina]`
   - **Expiration**: Según política corporativa
   - **Permissions**: 
     - Repository access: No es necesario
     - Account permissions -> Copilot: **Access: Read-only** OK
4. Copiar el token generado (comienza con `github_pat_...`)

#### Paso 2: Configurar Token

```bash
# Opción A: Variable de entorno GH_TOKEN (mayor precedencia)
export GH_TOKEN="github_pat_tu_token_aqui"

# Opción B: Variable de entorno GITHUB_TOKEN
export GITHUB_TOKEN="github_pat_tu_token_aqui"

# Para que sea permanente, agregar a ~/.bashrc o ~/.zshrc
echo 'export GH_TOKEN="github_pat_tu_token_aqui"' >> ~/.bashrc
source ~/.bashrc

# Iniciar copilot (detectará el token automáticamente)
copilot
```

#### Seguridad del Token

```bash
# NO guardar tokens en archivos de configuración de git
# Agregar al .gitignore global
echo '.env' >> ~/.gitignore_global
echo '*.token' >> ~/.gitignore_global

# Usar un gestor de secretos si está disponible
# Ejemplo con pass (password store)
pass insert github/copilot-cli-token
export GH_TOKEN=$(pass show github/copilot-cli-token)
```

### Verificar Autenticación

```bash
# Dentro de Copilot CLI, verificar estado
/user

# Debería mostrar tu nombre de usuario de GitHub
```

---

## Validaciones

Checklist de verificación post-instalación:

### OK Checklist de Configuración npm

```bash
# 1. Registry correcto
npm config get registry
# OK Debe retornar: https://registry.npmjs.org/

# 2. Caché limpio (opcional pero recomendado)
npm cache verify
# OK Debe completar sin errores

# 3. Conectividad a npm registry
npm ping
# OK Debe retornar: Ping success
```

### OK Checklist de Instalación

```bash
# 1. Paquete instalado globalmente
npm list -g @github/copilot
# OK Debe mostrar la versión instalada

# 2. Binario disponible
which copilot  # Linux/Mac
where copilot  # Windows
# OK Debe retornar la ruta del ejecutable

# 3. Versión correcta
copilot --version
# OK Debe mostrar: GitHub Copilot CLI version X.X.X
```

### OK Checklist de Autenticación

```bash
# 1. Iniciar CLI
copilot

# 2. Dentro de la CLI, verificar usuario
/user
# OK Debe mostrar tu usuario de GitHub

# 3. Verificar acceso a Copilot
# Hacer una pregunta simple:
# "What is Node.js?"
# OK Debe responder correctamente sin errores de autenticación
```

### OK Checklist de Funcionalidad Básica

Dentro de `copilot`, probar:

```bash
# 1. Ayuda
/help

# 2. Cambiar modelo (si disponible)
/model

# 3. Ver uso
/usage

# 4. Hacer una consulta técnica
# "Explain how async/await works in JavaScript"

# 5. Crear un archivo de prueba
# "Create a simple hello world in Python"
```

---

## Evidencias a Documentar

Para el registro corporativo o ticket de soporte:

### 1. Evidencia de Configuración

```bash
# Crear reporte de configuración
cat > evidencia-npm-config.txt <<'EOF'
=== NPM Configuration Report ===
Date: $(date)
Hostname: $(hostname)
User: $(whoami)

=== Node & npm Versions ===
$(node --version)
$(npm --version)

=== Registry Configuration ===
$(npm config get registry)

=== Proxy Configuration ===
HTTP_PROXY: $(npm config get proxy)
HTTPS_PROXY: $(npm config get https-proxy)

=== .npmrc Content ===
$(cat ~/.npmrc 2>/dev/null || echo "No .npmrc file found")

=== Full npm Config ===
$(npm config list)
EOF

cat evidencia-npm-config.txt
```

### 2. Evidencia de Instalación Exitosa

```bash
# Capturar evidencia de instalación
cat > evidencia-instalacion.txt <<'EOF'
=== GitHub Copilot CLI Installation Evidence ===
Date: $(date)

=== Global Packages ===
$(npm list -g --depth=0 | grep copilot)

=== Copilot Binary Location ===
$(which copilot 2>/dev/null || where copilot 2>/dev/null || echo "Not found")

=== Copilot Version ===
$(copilot --version 2>/dev/null || echo "Cannot execute copilot")
EOF

cat evidencia-instalacion.txt
```

### 3. Captura de Pantalla de Autenticación

Tomar screenshot de:
- Comando `copilot` mostrando el banner de bienvenida
- Comando `/user` mostrando tu usuario autenticado
- Una respuesta exitosa a una pregunta simple

### 4. Logs de Instalación (si hubo problemas)

```bash
# Si la instalación falló antes, guardar el log completo
npm install -g @github/copilot --verbose 2>&1 | tee copilot-install-full.log

# Extraer solo las líneas relevantes (errores y warnings)
grep -E "(ERR|WARN|403|error|Error)" copilot-install-full.log > copilot-install-errors.log
```

---

## Escalamiento

Si después de aplicar todas las soluciones el error 403 persiste:

### Nivel 1: Verificación con Equipo de Seguridad

**Información a proporcionar:**
```
Asunto: Solicitud de revisión - Bloqueo de acceso a registry.npmjs.org

Descripción del problema:
- Herramienta: GitHub Copilot CLI (parte de suscripción empresarial)
- Error: HTTP 403 Forbidden
- URL bloqueada: https://registry.npmjs.org/@github/copilot
- Impacto: Imposibilidad de instalar herramientas de desarrollo autorizadas

Evidencias adjuntas:
1. Log de instalación con error 403
2. Configuración de npm actual
3. Resultado de npm ping
4. Prueba exitosa desde red externa (si aplica)

Solicitud:
- Revisar políticas de firewall/proxy para registry.npmjs.org
- Permitir acceso a dominios: registry.npmjs.org, *.npmjs.org, *.cloudfront.net
- Verificar si hay bloqueo de DLP por contenido descargado
```

### Nivel 2: Prueba desde Otra Red

```bash
# Conectarse a red móvil o personal
# Intentar instalación limpia
npm cache clean --force
npm install -g @github/copilot

# Si funciona:
# - Confirma que es restricción corporativa
# - Solicitar apertura de acceso según Nivel 1
```

### Nivel 3: Instalación Manual (Workaround Temporal)

**Solo como última alternativa y con aprobación de seguridad:**

```bash
# En máquina con acceso a npm (ej: personal):
# 1. Instalar el paquete
npm install -g @github/copilot

# 2. Encontrar la ubicación de instalación
npm root -g
# Ej: /usr/local/lib/node_modules

# 3. Copiar el directorio completo
cd $(npm root -g)
tar czf github-copilot.tar.gz @github/copilot

# 4. Transferir archivo a máquina corporativa

# En máquina corporativa:
# 5. Extraer en directorio global de npm
cd $(npm root -g)
sudo tar xzf ~/github-copilot.tar.gz

# 6. Crear symlink si es necesario
ln -s $(npm root -g)/@github/copilot/bin/copilot.js /usr/local/bin/copilot

# 7. Verificar
copilot --version
```

**WARNING ADVERTENCIA:** Este método bypasea el proceso normal de npm y puede:
- Violar políticas de seguridad corporativa
- Causar problemas de actualización
- No incluir dependencias del sistema

### Nivel 4: Soporte Oficial de GitHub

Si el problema persiste y no es de red corporativa:

1. **Abrir ticket en GitHub Support:**
   - URL: https://support.github.com
   - Categoría: GitHub Copilot
   - Incluir:
     - Versión de Node.js y npm
     - Sistema operativo
     - Logs completos con `--verbose`
     - Evidencias de configuración

2. **Reportar en repositorio oficial:**
   - URL: https://github.com/github/copilot-cli/issues
   - Buscar issues similares antes de crear uno nuevo
   - Usar template de bug report

---

## Referencias

### Documentación Oficial

- **GitHub Copilot CLI Docs**: https://docs.github.com/en/copilot/using-github-copilot/using-github-copilot-in-the-command-line
- **Repositorio oficial**: https://github.com/github/copilot-cli
- **Paquete npm**: https://www.npmjs.com/package/@github/copilot
- **Pricing & Plans**: https://github.com/features/copilot/plans

### Troubleshooting npm

- **npm 403 Errors**: https://docs.npmjs.com/common-errors#403-forbidden
- **npm config**: https://docs.npmjs.com/cli/v10/commands/npm-config
- **npm registry**: https://docs.npmjs.com/cli/v10/using-npm/registry
- **Proxy configuration**: https://docs.npmjs.com/cli/v10/using-npm/config#proxy

### GitHub Copilot

- **About GitHub Copilot CLI**: https://docs.github.com/en/copilot/using-github-copilot/using-github-copilot-in-the-command-line
- **Managing Copilot policies**: https://docs.github.com/en/copilot/managing-copilot/managing-policies-and-features-for-copilot-in-your-organization
- **Troubleshooting**: https://docs.github.com/en/copilot/troubleshooting-github-copilot

### Comunidad y Soporte

- **GitHub Community Discussions**: https://github.com/orgs/community/discussions/categories/copilot
- **GitHub Support**: https://support.github.com
- **Stack Overflow**: Tag `github-copilot`

---

## Changelog del Documento

| Versión | Fecha | Cambios |
|---------|-------|---------|
| 1.0 | 2025-10-29 | Versión inicial corregida con información validada de fuentes oficiales |

---

## Notas del Autor

Este documento fue creado corrigiendo errores conceptuales en una versión anterior que incorrectamente asumía que `@github/copilot` requería configuración de GitHub Packages. Toda la información aquí ha sido validada contra:

1. Documentación oficial de GitHub Copilot CLI
2. Registro público de npm (npmjs.com)
3. Repositorio oficial del proyecto
4. Búsquedas web de casos reales de error 403 en instalación de paquetes npm

**Correcciones principales aplicadas:**
- NO Eliminada configuración incorrecta de GitHub Packages
- NO Eliminado uso innecesario de tokens con scope `read:packages`
- OK Enfoque en causas reales de error 403 en entornos corporativos
- OK Separación clara entre instalación y autenticación
- OK Soluciones basadas en problemas reales de proxy/firewall/registry

---

**Última actualización**: 29 de octubre de 2025
