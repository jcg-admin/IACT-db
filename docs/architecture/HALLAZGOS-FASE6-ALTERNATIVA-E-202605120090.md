# Hallazgos — Ejecución FASE 6 (H-PKG-003: decisión manifest de paquetes)

**Versión:** 1.0.0  
**Fecha:** 2026-05-11  
**Plan de referencia:** `PLAN-ALTERNATIVA-E-CONSOLIDADO-202605120030.md` FASE 6  
**Baseline al iniciar:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Baseline al cerrar:** verify.sh 27 OK, 0 WARN, 0 ERR

---

## Resultado de la tarea

| Tarea | Descripción | Estado |
|---|---|---|
| T-6.1 | Decisión H-PKG-003: Opción A con inventario en bootstrap.sh | COMPLETO |

---

## Decisión: Opción A — provisioners autocontenidos

### Criterios evaluados

**Tamaño del proyecto:**

El proyecto tiene 3 servicios y ~17 paquetes únicos del sistema.
El plan definía como umbral de reconsideración: 5+ servicios con paquetes
compartidos. El umbral no se alcanza.

**Paquetes compartidos reales:**

Solo `software-properties-common` es instalado por dos provisioners
(mariadb y adminer). `apt` lo maneja como idempotente — el segundo
`install_package` detecta que ya está instalado y no falla.

**Independencia de los provisioners:**

Cada provisioner puede ejecutarse de forma autónoma:
- `bash provisioners/mariadb/bootstrap.sh` (sin postgres, sin adminer)
- `bash provisioners/postgres/bootstrap.sh`
- `bash provisioners/adminer/bootstrap.sh`

La Opción B (manifest externo) introducía una dependencia de archivo:
si `config/packages/mariadb.txt` no existe cuando se ejecuta `install.sh`,
el provisioner falla. La autocontención actual es una ventaja, no un defecto.

**Verificación de prerequisitos:**

El gap que H-PKG-003 documentaba ("hay que leer N scripts para saber qué
necesita el proyecto") tiene solución sin Opción B: un inventario en
`bootstrap.sh` proporciona visibilidad centralizada sin indirección de código.

**Costo de mantenimiento:**

Opción B requeriría mantener dos fuentes sincronizadas para cada paquete:
- `provisioners/*/install.sh` (lógica: cuándo, cómo, con qué flags)
- `config/packages/*.txt` (lista: qué paquetes)

Cualquier cambio de paquete (versión, flags, condición) requeriría editar
dos archivos. Con 17 paquetes el overhead existe pero es manejable; con 3
servicios la ganancia no justifica el costo.

**Analogía con ecosistemas:**

`requirements.txt` (Python) y `package.json` (Node) existen porque las
dependencias de la aplicación cambian con el ciclo de desarrollo de la app.
Los paquetes del SO (apt) son infraestructura: cambian mucho menos
frecuentemente y su gestión no está acoplada al ciclo de vida del código.

### Veredicto

**Opción A — provisioners autocontenidos.** No se implementa `config/packages/`.

### Implementación

En lugar de código nuevo, se agrega un inventario en el header de `bootstrap.sh`:

```
# MariaDB: software-properties-common, dirmngr, apt-transport-https,
#          curl, gpg, mariadb-server, mariadb-client
# PostgreSQL: postgresql-${POSTGRES_VERSION}, postgresql-contrib-${POSTGRES_VERSION}
# Adminer: apache2, software-properties-common, php7.4 + extensiones
# Clientes CI: mariadb-client, postgresql-client, libpq-dev, default-libmysqlclient-dev
```

Esto cierra el gap de visibilidad documentado en H-PKG-003 sin agregar
indirección de código ni archivos adicionales a mantener.

### Condición de reapertura

La decisión debe revisarse si el proyecto supera alguno de estos umbrales:

- 5+ servicios con paquetes compartidos
- Un paquete que deba instalarse con flags diferentes según el servicio
  (ej: `--no-recommends` solo para adminer)
- Necesidad de un script `check-dependencies.sh` que verifique paquetes
  antes de provisionar

---

## Estado de hallazgos del plan tras FASE 6

| Hallazgo | Descripción | Estado |
|---|---|---|
| H-PKG-001 | T-1.7 era falso positivo (ya implementada) | DOCUMENTADO |
| H-PKG-002 | `config/` no es el lugar para paquetes apt | ACLARADO |
| H-PKG-003 | Manifest centralizado de paquetes — decisión pendiente | RESUELTO — Opción A con inventario en bootstrap.sh |
