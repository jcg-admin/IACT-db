---
id: TASK-056
titulo: Crear Plantilla VM Vagrant
fase: FASE_3_CONTENIDO_NUEVO
tipo: Creacion Contenido
tecnica: Template-based Prompting
---

# TASK-056: Crear Plantilla VM Vagrant

## Metadatos

- **ID:** TASK-056
- **Prioridad:** MEDIA (P2)
- **Duracion Estimada:** 2 horas
- **Estado:** Pendiente
- **Tipo:** Creacion Contenido
- **Dependencias:** Ninguna
- **Tecnica de Prompting:** Template-based Prompting

## Descripcion

Crear una plantilla reutilizable para documentar configuraciones de maquinas virtuales Vagrant. Esta plantilla facilitara la documentacion de VMs para desarrollo, testing y ambientes de demostracion.

## Objetivo

Proporcionar un formato estandarizado para documentar VMs Vagrant con:
- Frontmatter YAML con metadatos de VM
- Descripcion de recursos y configuracion
- Instrucciones de instalacion y provisioning
- Scripts de automatizacion asociados
- Ejemplos de verificacion y validacion

## Sub-tareas

1. **Diseñar estructura de frontmatter YAML**
   - Campos: id, nombre-vm, box, version, ambiente
   - Recursos: cpu, memoria, disco, red
   - Campos de aplicacion: dependencias-externas, scripts-provisioning

2. **Definir secciones estándar**
   - Descripcion de la VM y proposito
   - Requisitos del host
   - Especificaciones de recursos
   - Configuracion de red (puertos, IPs)
   - Software y herramientas instaladas
   - Scripts de provisioning y post-setup
   - Instrucciones de uso
   - Troubleshooting comun
   - Referencias a Vagrantfile y documentacion

3. **Crear instrucciones de uso**
   - Como adaptar la plantilla para nuevas VMs
   - Mejores practicas para configurar recursos
   - Guia para crear scripts de provisioning
   - Validacion de configuracion

4. **Desarrollar ejemplo de aplicacion**
   - Ejemplo de VM para desarrollo Python
   - Vagrantfile y scripts de provisioning completos
   - Instrucciones de inicializacion

5. **Validar estructura**
   - Verificar YAML valido
   - Confirmar que recursos especificados son realistas
   - Validar que ejemplo es reproducible

## Tecnica de Prompting

**Template-based Prompting:**
- Usar estructura de Vagrantfile como referencia
- Incluir placeholders para valores customizables
- Proporcionar ejemplos de provisioning scripts
- Documentar variables de entorno

## Evidencias Generadas

- `/home/user/IACT/docs/infraestructura/qa/plantillas/plantilla-vm-vagrant.md`
- Ejemplo de Vagrantfile compatible

## Criterios de Aceptacion

- [ ] Archivo creado con frontmatter YAML valido
- [ ] Minimo 9 secciones estándar incluidas
- [ ] Recursos especificados son realistas
- [ ] Ejemplo de VM completamente documentado
- [ ] Scripts de provisioning incluidos
- [ ] Instrucciones de validacion claras
- [ ] Compatible con versiones recientes de Vagrant

## Consideraciones Especiales

- Alinear con Vagrantfiles existentes en /devcontainer/
- Permitir integracion con scripts de provisioning existentes
- Documentar diferencias entre ambientes (desarrollo, testing, demo)

---

**Creada:** 2025-11-18
**Version:** 1.0.0
