# CPython Precompilado - Guía de Usuario

**Versión**: 1.0.0
**Fecha**: 2025-11-06
**Referencia**: SPEC_INFRA_001, ADR_008, ADR_009

---

## Qué es esto

Sistema de distribución de CPython precompilado para Dev Containers que reduce los tiempos de construcción de entornos de desarrollo de 20 minutos a menos de 2 minutos.

El intérprete Python se compila una sola vez en una VM Vagrant controlada y se distribuye como binario precompilado mediante una Feature personalizada de Dev Containers, siguiendo el principio "build once, run everywhere".

> Consulta el [resumen del pipeline y uso en DevContainer](pipeline_devcontainer.md) para una vista rápida orientada a ejecución.

---

## Por qué usarlo

### Problemas que resuelve

1. **Tiempos de build largos**: Elimina la espera de 15-20 minutos mientras Python se compila desde fuente
2. **Inconsistencias entre entornos**: Todos usan exactamente el mismo binario de Python con las mismas librerías nativas
3. **Onboarding lento**: Nuevos desarrolladores pueden empezar a trabajar en minutos en lugar de horas
4. **Desperdicio de recursos**: Reduce consumo de GitHub Actions minutes (no compila en CI/CD)

### Beneficios medibles

- Reducción de 90% en tiempo de build (20min → <2min)
- Reproducibilidad total entre desarrolladores
- Zero-configuration para desarrolladores (solo 3 líneas en JSON)
- Compatible 100% con VS Code debugging, linting, testing

---

## Cuándo usarlo

### Casos de uso ideales

- Proyectos Django que usan Dev Containers
- Equipos con onboarding frecuente de nuevos desarrolladores
- Proyectos multi-repo que comparten versión de Python
- Cuando se requiere reproducibilidad exacta del intérprete
- Desarrollo local-first sin dependencias de servicios cloud

### Cuándo NO usarlo

- Proyectos que requieren compilación custom de Python con flags no estándar
- Entornos que ya usan imagen Docker con Python preinstalado satisfactoriamente
- Proyectos con un solo desarrollador y sin planes de crecimiento (overhead no justificado)

---

## Inicio Rápido

### Prerrequisitos

- VS Code >= 1.80.0
- Docker Desktop >= 4.20.0
- Extensión "Dev Containers" instalada en VS Code
- Conexión a internet (solo para primera descarga)

### Paso 1: Agregar Feature a tu proyecto

Editar `.devcontainer/devcontainer.json` de tu proyecto:

```json
{
  "name": "Mi Proyecto Django",
  "build": {
    "dockerfile": "Dockerfile"
  },
  "features": {
    "./infrastructure/cpython/installer": {
      "version": "3.12.6"
    }
  }
}
```

### Paso 2: Rebuild del contenedor

En VS Code:

```
Cmd/Ctrl + Shift + P
→ "Dev Containers: Rebuild Container"
```

El build debería completar en menos de 2 minutos.

### Paso 3: Verificar instalación

Abrir terminal integrada en VS Code y ejecutar:

```bash
python3 --version
# Debería mostrar: Python 3.12.6

python3 -c "import ssl, sqlite3, uuid, lzma, bz2; print('Módulos nativos OK')"
# Debería mostrar: Módulos nativos OK
```

Si ambos comandos funcionan correctamente, la instalación es exitosa.

---

## Configuración Avanzada

### Especificar versión de Python

```json
{
  "features": {
    "./infrastructure/cpython/installer": {
      "version": "3.12.6"  // Cambiar a versión deseada
    }
  }
}
```

Versiones disponibles: Ver sección "Versiones Disponibles" más abajo.

### Usar artefacto local (sin descarga de internet)

Para desarrollo completamente offline o para testing de artefactos compilados localmente:

```json
{
  "features": {
    "./infrastructure/cpython/installer": {
      "version": "3.12.6",
      "artifactUrl": "${localWorkspaceFolder}/infraestructura/cpython/artifacts/cpython-3.12.6-ubuntu20.04-build1.tgz"
    }
  }
}
```

**Opción 1: Descargar artefacto manualmente**

```bash
mkdir -p infraestructura/cpython/artifacts/
curl -L https://github.com/2-Coatl/IACT---project/releases/download/cpython-3.12.6-build1/cpython-3.12.6-ubuntu20.04-build1.tgz \
  -o infraestructura/cpython/artifacts/cpython-3.12.6-ubuntu20.04-build1.tgz
curl -L https://github.com/2-Coatl/IACT---project/releases/download/cpython-3.12.6-build1/cpython-3.12.6-ubuntu20.04-build1.tgz.sha256 \
  -o infraestructura/cpython/artifacts/cpython-3.12.6-ubuntu20.04-build1.tgz.sha256
```

**Opción 2: Compilar artefacto localmente (Fase 2)**

Si necesitas compilar una versión custom o para testing:

```bash
# Compilar CPython en Vagrant
make build_cpython VERSION=3.12.6

# Validar artefacto
make validate-cpython ARTIFACT=cpython-3.12.6-ubuntu20.04-build1.tgz

# El artefacto estará en infraestructura/cpython/artifacts/ listo para usar
```

Ver: `infrastructure/cpython/README.md` para más detalles sobre compilación local.

### Combinar con otras Features

```json
{
  "features": {
    "./infrastructure/cpython/installer": {
      "version": "3.12.6"
    },
    "ghcr.io/devcontainers/features/node:1": {
      "version": "20"
    },
    "ghcr.io/devcontainers/features/docker-in-docker:2": {}
  }
}
```

Las Features son composables sin conflictos.

---

## Versiones Disponibles

| Versión Python | Build | Compatible con | Fecha | Descarga |
|----------------|-------|----------------|-------|----------|
| 3.12.6         | 1     | Ubuntu 20.04   | 2025-11-06 | [Release](https://github.com/2-Coatl/IACT---project/releases/tag/cpython-3.12.6-build1) |

Para ver todas las versiones disponibles:

```bash
gh release list --repo 2-Coatl/IACT---project | grep cpython
```

O visitar: [Releases en GitHub](https://github.com/2-Coatl/IACT---project/releases)

---

## Arquitectura del Sistema

Para entender cómo funciona internamente, ver:

- [Arquitectura técnica detallada](./arquitectura.md)
- [ADR_008: Decisión de usar Features](../../adr/ADR_008-cpython-features-vs-imagen-base.md)
- [ADR_009: Estrategia de distribución](../../adr/ADR_009-distribucion-artefactos-strategy.md)

### Flujo simplificado

```
Vagrant (compilar) → GitHub Releases (distribuir) → Feature (instalar) → Dev Container (usar)
```

1. **Vagrant**: Compila CPython una vez con configuración controlada
2. **GitHub Releases**: Almacena artefacto versionado con checksum
3. **Feature**: Descarga, valida e instala automáticamente
4. **Dev Container**: Desarrollador usa Python sin esperar compilación

---

## Mantenimiento

### Actualizar a nueva versión de Python

Cuando se publica una nueva versión de artefacto:

1. Revisar [Releases](https://github.com/2-Coatl/IACT---project/releases) para confirmar disponibilidad
2. Actualizar `devcontainer.json`:
   ```json
   {
     "features": {
       "./infrastructure/cpython/installer": {
         "version": "3.12.7"  // Nueva versión
       }
     }
   }
   ```
3. Rebuild del contenedor
4. Validar que todo funciona correctamente
5. Commit y push del cambio

### Rollback a versión anterior

Si una nueva versión causa problemas:

1. Cambiar versión en `devcontainer.json` a la anterior:
   ```json
   "version": "3.12.6"  // Versión estable anterior
   ```
2. Rebuild del contenedor
3. Reportar problema al equipo de infraestructura

### Calendario de actualizaciones

- **Rebuilds programados**: Cada 6 meses
- **Rebuilds de emergencia**: Ante CVE crítico de CPython
- **Nuevas versiones de Python**: Dentro de 2 semanas del release oficial

---

## Solución de Problemas

### Error: "Checksum SHA256 inválido"

**Causa**: Artefacto descargado está corrupto o alterado.

**Solución**:
1. Eliminar caché de Docker: `docker system prune -a`
2. Reintentar rebuild
3. Si persiste, reportar al equipo infraestructura (posible problema con release)

### Error: "ModuleNotFoundError: No module named 'ssl'"

**Causa**: Artefacto compilado con versión diferente de OpenSSL que la del contenedor.

**Solución**:
1. Verificar que el contenedor usa Ubuntu 20.04 (misma base que Vagrant)
2. Verificar compatibilidad en [FAQ](./preguntas_frecuentes.md)
3. Usar artefacto específico para tu versión de Ubuntu

### Build del contenedor toma >5 minutos

**Causa posible**: Red lenta descargando artefacto, o Feature no está detectando instalación previa.

**Diagnóstico**:
```bash
# En el contenedor, verificar si Python ya está instalado
ls -la /opt/python-3.12.6/
```

**Solución**:
- Si la carpeta existe: Feature debería ser idempotente, revisar logs de VS Code
- Si no existe: Problema de descarga, considerar artefacto local

### VS Code no puede debuggear código Python

**Causa**: Extensión Python de VS Code no encuentra el intérprete.

**Solución**:
```json
// En .vscode/settings.json
{
  "python.defaultInterpreterPath": "/usr/local/bin/python3"
}
```

Luego:
```
Cmd/Ctrl + Shift + P
→ "Python: Select Interpreter"
→ Seleccionar "/usr/local/bin/python3"
```

### Más problemas

Ver: [Preguntas Frecuentes completas](./preguntas_frecuentes.md)

---

## Contribuir

### Reportar problemas

1. Verificar que el problema no está en [FAQ](./preguntas_frecuentes.md)
2. Abrir issue en GitHub con:
   - Versión de Python usada
   - Logs completos del build
   - Contenido de `devcontainer.json`
   - Output de `python3 --version` y `python3 -c "import ssl"`

### Solicitar nueva versión de Python

1. Verificar que la versión existe en [python.org](https://www.python.org/downloads/)
2. Abrir issue con template "Solicitud de nueva versión CPython"
3. Equipo infraestructura compilará y publicará en próximo ciclo (máximo 2 semanas)

---

## Para Desarrolladores de Infraestructura

Si necesitas compilar artefactos o modificar la Feature:

- [Guía de compilación en Vagrant](../../../infrastructure/cpython/README.md)
- [Guía de desarrollo de Features](../../../infrastructure/cpython/installer/README.md)
- [Especificación completa: SPEC_INFRA_001](../../specs/SPEC_INFRA_001-cpython_precompilado.md)

---

## Referencias

- [Especificación técnica completa](../../specs/SPEC_INFRA_001-cpython_precompilado.md)
- [ADR_008: Decisión arquitectónica Features vs Imagen Base](../../adr/ADR_008-cpython-features-vs-imagen-base.md)
- [ADR_009: Estrategia de distribución de artefactos](../../adr/ADR_009-distribucion-artefactos-strategy.md)
- [Arquitectura del sistema](./arquitectura.md)
- [FAQ completo](./preguntas_frecuentes.md)
- [Dev Containers Specification](https://containers.dev/)
- [CPython Downloads](https://www.python.org/downloads/)

---

**Documento versión**: 1.0.0
**Última actualización**: 2025-11-06
**Mantenido por**: Equipo Infraestructura IACT
