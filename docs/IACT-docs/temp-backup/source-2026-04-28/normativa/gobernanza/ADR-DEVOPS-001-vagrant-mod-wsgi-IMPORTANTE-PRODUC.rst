ADR-001: Entorno de Desarrollo con Vagrant y Aprovisionamiento de Bases de Datos
================================================================================

ESTO ES IMPORTANTE, SE TIENE QUE DOCUMENTAR, COMO SE UTILIZA EN
PRODUCION CON LOS PASOS PARA USAR mod-wsgi, VA DE LA MANO CON EL
CONSUMIR LAS BASE DE DATOS, SIN EMBARGO SON DOS PROYECTOS SEPARADOS

**Estado:** aceptada

**Fecha:** 2025-01-15

**Decisores:** Equipo de Arquitectura, Equipo de DevOps

**Contexto técnico:** Infrastructure

Contexto y Problema
-------------------

El proyecto IACT requiere un entorno de desarrollo local que replique la
infraestructura de datos en producción: - PostgreSQL para almacenamiento
de datos analíticos - MariaDB para acceso de solo lectura a datos del
sistema IVR

**Problemas identificados:** - Inconsistencia entre entornos de
desarrollo de diferentes desarrolladores - Dificultad para nuevos
miembros del equipo al configurar el entorno - Tiempo prolongado de
onboarding (2-3 días) - Errores frecuentes por diferencias de versiones
de bases de datos - Falta de aislamiento entre proyecto y máquina host

**Restricciones:** - Debe funcionar en Windows, macOS y Linux - Debe ser
reproducible y versionable - No debe requerir instalación de servicios
en máquina host - Debe ser lo más similar posible al entorno de
producción

Factores de Decisión
--------------------

-  **Consistencia**: Todos los desarrolladores tienen el mismo entorno
-  **Aislamiento**: No contaminar máquina host con servicios
-  **Reproducibilidad**: Entorno versionado y documentado
-  **Facilidad de uso**: Proceso simple de ``vagrant up``
-  **Compatibilidad**: Funciona en múltiples sistemas operativos
-  **Recursos**: Uso razonable de CPU/RAM

Opciones Consideradas
---------------------

Opción 1: Vagrant + VirtualBox con Aprovisionamiento Shell
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción:** Usar Vagrant para gestionar una VM Ubuntu con
VirtualBox como provider. Aprovisionar PostgreSQL y MariaDB mediante
script shell (``provisioning/bootstrap.sh``).

**Pros:** - OK: Aislamiento completo de servicios - OK: Funciona en
Windows, macOS, Linux - OK: Fácil de versionar (Vagrantfile + scripts) -
OK: No requiere Docker - OK: Familiaridad del equipo con Vagrant - OK:
Configuración explícita y auditable

**Contras:** - NO: Requiere VirtualBox (software adicional) - NO: Mayor
consumo de recursos vs Docker - NO: Boot time más lento que contenedores
- NO: Gestión de snapshots menos elegante

**Implementación:**

.. code:: ruby

   # Vagrantfile
   Vagrant.configure("2") do |config|
     config.vm.box = "ubuntu/focal64"

     # Forwarding de puertos
     config.vm.network "forwarded_port", guest: 5432, host: 15432  # PostgreSQL
     config.vm.network "forwarded_port", guest: 3306, host: 13306  # MariaDB

     # Aprovisionamiento
     config.vm.provision "shell", path: "provisioning/bootstrap.sh"

     config.vm.provider "virtualbox" do |vb|
       vb.memory = "2048"
       vb.cpus = 2
     end
   end

--------------

Opción 2: Docker Compose
~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción:** Usar Docker Compose para levantar contenedores de
PostgreSQL y MariaDB con configuración mediante docker_compose.yml.

**Pros:** - OK: Menor consumo de recursos - OK: Boot time rápido
(segundos) - OK: Ecosistema amplio de imágenes oficiales - OK: Fácil
gestión de volúmenes y redes

**Contras:** - NO: Docker Desktop requiere licencia en empresas grandes
- NO: Problemas de performance en Windows con WSL2 - NO: Equipo tiene
menos experiencia con Docker - NO: Configuración menos explícita
(imágenes pre-built)

--------------

Opción 3: Instalación Nativa
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción:** Cada desarrollador instala PostgreSQL y MariaDB
directamente en su máquina host.

**Pros:** - OK: Máximo rendimiento (sin virtualización) - OK: Sin
overhead de memoria/CPU

**Contras:** - NO: Inconsistencia entre entornos - NO: Contamina máquina
host - NO: Difícil de versionar - NO: Onboarding complejo y propenso a
errores - NO: Conflictos con otras instalaciones

--------------

Opción 4: DevContainers con VS Code
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción:** Usar DevContainers (basado en Docker) con configuración
en ``.devcontainer/``.

**Pros:** - OK: Integración nativa con VS Code - OK: Entorno completo
(IDE + servicios) - OK: Reproducible

**Contras:** - NO: Requiere VS Code (limita elección de editor) - NO:
Requiere Docker - NO: Mayor curva de aprendizaje inicial

Decisión
--------

**Opción elegida:** “Vagrant + VirtualBox con Aprovisionamiento Shell”

**Justificación:**

1. **Familiaridad del equipo**: El equipo ya tiene experiencia con
   Vagrant
2. **Independencia de herramientas**: No limita elección de editor/IDE
3. **Transparencia**: Script shell es auditable línea por línea
4. **Sin restricciones de licencia**: VirtualBox es libre y open source
5. **Compatibilidad probada**: Funciona en todos los SOs del equipo

**Trade-offs aceptados:** - Aceptamos mayor consumo de recursos por
mayor aislamiento - Aceptamos boot time más lento por mayor consistencia
- Priorizamos reproducibilidad sobre performance

Consecuencias
-------------

Positivas
~~~~~~~~~

-  OK: Onboarding reducido de 2-3 días a 1 hora
-  OK: Cero instalaciones en máquina host
-  OK: Configuración versionada en Git
-  OK: Puertos customizados (15432, 13306) evitan conflictos

Negativas
~~~~~~~~~

-  WARNING: Requiere ~2GB RAM adicionales cuando VM está corriendo
-  WARNING: Boot time de ~2 minutos en primera ejecución
-  WARNING: Necesita VirtualBox 7+ instalado

Neutrales
~~~~~~~~~

-  INFO: Desarrolladores necesitan aprender comandos básicos de Vagrant
-  INFO: Scripts de aprovisionamiento deben mantenerse actualizados

Plan de Implementación
----------------------

1. **Fase 1: Configuración Inicial** OK COMPLETADO

   -  Crear Vagrantfile
   -  Crear provisioning/bootstrap.sh
   -  Configurar forwarding de puertos
   -  Timeframe: 1 día

2. **Fase 2: Validación** OK COMPLETADO

   -  Probar en Windows, macOS, Linux
   -  Crear script de verificación (``scripts/verificar_servicios.sh``)
   -  Documentar en README
   -  Timeframe: 2 días

3. **Fase 3: Documentación** OK COMPLETADO

   -  Guía de instalación
   -  Troubleshooting común
   -  Variables de entorno
   -  Timeframe: 1 día

Validación y Métricas
---------------------

**Criterios de Éxito:** - OK: Tiempo de onboarding: < 2 horas (vs 2-3
días anterior) - OK: Tasa de éxito en primera ejecución: > 90% - OK:
Tiempo de ``vagrant up`` primera vez: < 5 minutos - OK: Tiempo de
``vagrant up`` subsecuente: < 2 minutos

**Resultados Obtenidos:** - OK: Onboarding promedio: 1 hora - OK:
Primera ejecución exitosa: 95% - OK: Vagrant up inicial: ~3 minutos -
OK: Vagrant up subsecuente: ~1.5 minutos

**Revisión:** - Fecha de revisión: 2025-06-01 - Responsable: Equipo
DevOps

Configuración Implementada
--------------------------

Puertos Expuestos
~~~~~~~~~~~~~~~~~

::

   PostgreSQL: 127.0.0.1:15432
   MariaDB:    127.0.0.1:13306

Credenciales Creadas
~~~~~~~~~~~~~~~~~~~~

::

   Usuario: django_user
   Password: django_pass

Bases de Datos
~~~~~~~~~~~~~~

::

   PostgreSQL: iact_analytics
   MariaDB:    iact_ivr (read-only)

Referencias
-----------

-  `Vagrantfile <../../../vagrantfile>`__
-  `Script de aprovisionamiento <../../../provisioning/bootstrap.sh>`__
-  `Script de verificación <../../../scripts/verificar_servicios.sh>`__
-  `Guía de
   verificación <../../devops/runbooks/verificar_servicios.md>`__
-  `README principal <../../../README.md>`__

Notas Adicionales
-----------------

**Fecha de discusión inicial:** 2025-01-10

**Participantes:** - Equipo de Arquitectura - Equipo de DevOps - Lead
Backend Developer

**Experimentos realizados:** - POC con Docker Compose (descartado por
licenciamiento) - POC con DevContainers (descartado por dependencia de
VS Code)

**Evolución futura:** Cuando el equipo crezca y todos tengan licencia de
Docker Desktop, puede evaluarse migración a Docker Compose mediante un
nuevo ADR.

--------------

**Última actualización:** 2025-11-02 **Estado:** Implementado y en uso
activo
