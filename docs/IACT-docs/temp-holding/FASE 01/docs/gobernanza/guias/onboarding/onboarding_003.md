---
id: GUIA-onboarding-003
tipo: guia_operativa
categoria: onboarding
audiencia: desarrollador-nuevo
prioridad: P0
tiempo_lectura: 8 minutos
version: 1.0.0
fecha: 2025-11-07
relacionados: []
---

# Estructura del Proyecto IACT

## Proposito

Entiende la estructura de directorios y organización del código del proyecto IACT.

## Audiencia

Esta guia esta dirigida a: desarrollador-nuevo

## Pre-requisitos

- [ ] Repositorio clonado localmente
- [ ] Familiaridad básica con terminal

## Tiempo estimado

Tiempo de lectura: 8 minutos
Tiempo de ejecucion: 16 minutos

## Pasos

### 1. Explorar directorio raíz

Familiarízate con los directorios principales del proyecto.

**Comando**:
```bash
ls -la
```

**Output esperado**:
```
api/, frontend/, docs/, scripts/, infrastructure/, .github/
```

### 2. Revisar backend (api/)

El backend Django está en el directorio api/.

**Comando**:
```bash
tree api/ -L 2 -d
```

**Output esperado**:
```
api/
├── apps/
├── core/
├── config/
└── tests/
```

### 3. Revisar frontend (frontend/)

El frontend React está en el directorio frontend/.

**Comando**:
```bash
tree frontend/src -L 2 -d
```

**Output esperado**:
```
frontend/src/
├── components/
├── pages/
├── hooks/
└── utils/
```

### 4. Revisar documentación (docs/)

Toda la documentación está organizada en docs/.

**Comando**:
```bash
ls docs/
```

**Output esperado**:
```
arquitectura/, gobernanza/, requisitos/, adr/, guias/
```

{PASO_3_DESCRIPCION}

## Validacion

Para validar que completaste correctamente esta guia:

- [ ] Entiendes qué contiene cada directorio principal
- [ ] Sabes dónde encontrar el código backend
- [ ] Sabes dónde encontrar el código frontend
- [ ] Sabes dónde encontrar la documentación

## Como interpretar resultados

**Exito**: {DESCRIPCION_EXITO}

**Errores comunes**: Ver seccion Troubleshooting

## Troubleshooting

### Error 1: No encuentro un archivo específico

**Sintomas**:
```
Buscando un archivo y no lo encuentro
```

**Causa**: No sabes en qué directorio buscar

**Solucion**:
```bash
Usa find para buscar:
find . -name 'nombre_archivo.py'
# O usa grep para buscar contenido:
grep -r 'texto_a_buscar' .
```

**Sintomas**: {ERROR_2_SINTOMAS}

**Causa**: {ERROR_2_CAUSA}

**Solucion**: {ERROR_2_SOLUCION}

## Proximos pasos

Despues de completar esta guia, puedes continuar con:

1. Revisar arquitectura del sistema (docs/arquitectura/)
2. Leer ADRs importantes (docs/adr/)
3. Entender flujo de desarrollo (Ver GUIA-WORKFLOWS-001)

## Referencias

- Arquitectura del sistema: `docs/arquitectura/`
- ADRs: `docs/adr/`
- README principal: `README.md`

## Feedback

Si encuentras problemas con esta guia o tienes sugerencias:
- Crea un issue en GitHub con label `documentation`
- Contacta a: TBD

---

**Mantenedores**: @arquitecto-senior, @tech-lead
**Ultima actualizacion**: 2025-11-07
