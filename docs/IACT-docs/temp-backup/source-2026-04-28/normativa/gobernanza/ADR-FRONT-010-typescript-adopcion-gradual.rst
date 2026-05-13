ADR-FRONT-010: Adopción Gradual de TypeScript
=============================================

**Estado:** aprobado

**Fecha:** 2025-01-17

**Decisores:** equipo-frontend, arquitecto-principal

**Contexto técnico:** Frontend

--------------

Contexto y Problema
-------------------

El proyecto IACT frontend está construido en JavaScript (React + Redux
Toolkit). A medida que la aplicación crece, surgen problemas de
mantenibilidad:

1. **Errores de Tipos en Runtime:**

   -  Bugs por pasar tipos incorrectos a funciones
   -  ``undefined is not a function`` en producción
   -  Props incorrectos en componentes React

2. **Refactoring Riesgoso:**

   -  Cambiar interfaces requiere buscar manualmente todos los usos
   -  Renombrar propiedades es propenso a errores
   -  No hay garantía de que el código sigue funcionando

3. **Documentación Implícita:**

   -  Shape de objetos no está documentado formalmente
   -  PropTypes solo valida en desarrollo, no en producción
   -  Nuevos desarrolladores necesitan leer mucho código para entender
      estructuras

4. **IDE Experience Limitado:**

   -  Autocompletado limitado sin type definitions
   -  No hay navegación tipo “Go to Definition”
   -  Refactoring automático no funciona bien

**Preguntas clave:** - ¿Migrar todo a TypeScript de una vez o
gradualmente? - ¿Qué estrategia de adopción minimiza riesgo? - ¿Cómo
balancear velocidad de desarrollo vs type safety? - ¿Qué nivel de
strictness usar?

**Restricciones actuales:** - Codebase existente: ~30 archivos
JavaScript - Equipo familiarizado con JavaScript, experiencia limitada
con TypeScript - Producto en producción, no podemos pausar features para
migrar - Testing con Jest + React Testing Library ya establecido

**Impacto del problema:** - Bugs en producción por errores de tipos -
Tiempo perdido en debugging - Refactoring lento y riesgoso - Onboarding
de nuevos desarrolladores más lento

--------------

Factores de Decisión
--------------------

-  **Type Safety:** Detectar errores antes de runtime
-  **Velocidad de Desarrollo:** No frenar desarrollo de features
-  **Curva de Aprendizaje:** Equipo debe poder adoptar TypeScript
   gradualmente
-  **Compatibilidad:** TypeScript debe coexistir con JavaScript
-  **Refactoring:** Facilitar refactoring seguro
-  **IDE Experience:** Mejor autocompletado y navegación
-  **Mantenibilidad:** Código autodocumentado con tipos

--------------

Opciones Consideradas
---------------------

Opción 1: Adopción Gradual con Modo Mixto (ELEGIDA)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción:** Permitir archivos ``.js`` y ``.ts`` coexistiendo en el
mismo proyecto. Migrar módulo por módulo según prioridad. Configurar
TypeScript en modo permisivo inicialmente, aumentar strictness
gradualmente.

**Estrategia:** 1. **Fase 1:** Configurar TypeScript con
``allowJs: true``, ``checkJs: false`` 2. **Fase 2:** Migrar módulos
nuevos a ``.ts`` desde el inicio 3. **Fase 3:** Migrar módulos críticos
existentes (types, config, lib) 4. **Fase 4:** Migrar componentes y
services gradualmente 5. **Fase 5:** Aumentar strictness
(``strict: true``) cuando cobertura sea >80%

**Pros:** - **Sin Bloqueo:** Desarrollo de features continúa sin pausa -
**Riesgo Minimizado:** Migración incremental, fácil rollback si hay
problemas - **Curva de Aprendizaje Gradual:** Equipo aprende TypeScript
mientras desarrolla - **Priorización:** Migramos primero lo más crítico
(types, shared libs) - **Coexistencia:** ``.js`` y ``.ts`` funcionan
juntos sin problemas - **Value Inmediato:** Nuevos módulos tienen type
safety desde día 1 - **Strictness Incremental:** Podemos aumentar
strictness gradualmente - **IDE Support Parcial:** Archivos ``.ts``
tienen full support, ``.js`` tienen basic support

**Contras:** - **Codebase Mixto:** Durante transición, algunos archivos
son ``.js``, otros ``.ts`` - **Type Coverage Parcial:** No tenemos 100%
type safety durante transición - **Configuración Dual:** Necesitamos
``allowJs: true`` que no es ideal a largo plazo - **Confusión
Potencial:** Equipo debe recordar qué archivos son ``.ts`` vs ``.js``

**Ejemplo/Implementación:**

.. code:: json

   // tsconfig.json (Fase 1-3)
   {
     "compilerOptions": {
       "target": "ES2020",
       "module": "ESNext",
       "lib": ["ES2020", "DOM", "DOM.Iterable"],
       "jsx": "react-jsx",
       "allowJs": true,          // Permitir .js
       "checkJs": false,         // No validar .js con TS
       "strict": false,          // Strict mode OFF inicialmente
       "esModuleInterop": true,
       "skipLibCheck": true,
       "moduleResolution": "node",
       "resolveJsonModule": true,
       "isolatedModules": true,
       "noEmit": true
     },
     "include": ["src/**/*"],
     "exclude": ["node_modules", "dist"]
   }

   // Progreso actual:
   // ✓ types/permisos.types.ts - MIGRADO
   // ✓ hooks/usePermisos.ts - MIGRADO
   // ✓ lib/permisos-client.ts - MIGRADO
   // ✓ config/api.config.ts - MIGRADO
   // ⏳ services/*.js - EN PROGRESO
   // ⏳ components/*.js - PENDIENTE
   // ⏳ state/slices/*.js - PENDIENTE

--------------

Opción 2: Big Bang Migration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción:** Pausar desarrollo de features por 2-4 semanas y migrar
todo el codebase a TypeScript de una vez.

**Pros:** - **100% TypeScript Rápido:** Todo el codebase en TypeScript
en pocas semanas - **No Mixto:** No hay confusión sobre qué usar -
**Strict Mode Inmediato:** Podemos habilitar ``strict: true`` desde el
inicio - **Type Coverage Completo:** 100% type safety una vez completado

**Contras:** - **Bloqueo de Features:** 2-4 semanas sin nuevas features
es inaceptable - **Riesgo Alto:** Migrar todo de una vez aumenta
probabilidad de bugs - **Rollback Difícil:** Si algo falla, rollback es
muy complejo - **Curva de Aprendizaje Abrupta:** Equipo debe dominar
TypeScript rápidamente - **Testing Masivo:** Necesitamos re-testear toda
la aplicación - **Presión del Negocio:** Producto en producción, no
podemos pausar desarrollo

**Razón del rechazo:** No podemos pausar desarrollo de features por 2-4
semanas. Riesgo muy alto de introducir bugs. Presión del negocio
requiere entregas continuas.

--------------

Opción 3: TypeScript Solo para Nuevos Módulos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción:** Mantener código existente en JavaScript. Solo usar
TypeScript para módulos nuevos. No migrar código legacy.

**Pros:** - **Cero Fricción:** No afecta código existente - **Sin
Riesgo:** No hay chance de romper código que funciona - **Fácil
Adopción:** Equipo solo aprende TypeScript para código nuevo

**Contras:** - **Legacy Crece:** Código JavaScript legacy nunca se
mejora - **Inconsistencia Permanente:** Codebase permanentemente mixto -
**Type Safety Limitado:** Módulos críticos siguen sin types - **Deuda
Técnica:** Acumula deuda técnica en código legacy - **Refactoring
Difícil:** Refactoring cross-módulos requiere manejar .js y .ts

**Razón del rechazo:** Código legacy más crítico (types, shared libs)
necesita type safety. No queremos deuda técnica permanente. Queremos
eventualmente tener 100% TypeScript.

--------------

Opción 4: JSDoc Comments en JavaScript
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción:** Mantener JavaScript pero agregar type annotations con
JSDoc comments. TypeScript puede validar JSDoc.

**Pros:** - **Sin Migración:** Código sigue siendo JavaScript - **Type
Checking:** TypeScript puede validar JSDoc comments - **Gradual:**
Podemos agregar JSDoc gradualmente

**Contras:** - **Sintaxis Verbose:** JSDoc es mucho más verboso que
TypeScript - **IDE Support Limitado:** No tan bueno como TypeScript
nativo - **No es TypeScript Real:** Seguimos con JavaScript, no migramos
- **Mantenimiento Dual:** Código + comments tipo documentation -
**Comunidad Limitada:** Menos recursos y ejemplos que TypeScript

**Razón del rechazo:** JSDoc es un workaround, no una solución real.
Queremos TypeScript nativo para mejor IDE support y comunidad. Sintaxis
JSDoc es muy verbosa.

--------------

Decisión
--------

**Opción elegida:** “Adopción Gradual con Modo Mixto”

**Justificación:**

1. **Sin Bloqueo de Features:** Desarrollo continúa sin pausas, migramos
   en paralelo.

2. **Riesgo Minimizado:** Migración módulo por módulo permite validar
   cada cambio. Rollback fácil si hay problemas.

3. **Priorización Inteligente:** Migramos primero lo más crítico:

   -  Types y interfaces (``types/*.ts``)
   -  Shared libraries (``lib/*.ts``)
   -  Hooks reutilizables (``hooks/*.ts``)
   -  Config files (``config/*.ts``)

4. **Curva de Aprendizaje Gradual:** Equipo aprende TypeScript mientras
   migra, sin presión.

5. **Value Inmediato:** Nuevos módulos tienen type safety desde día 1.
   No esperamos migración completa para tener beneficios.

6. **Strictness Incremental:** Empezamos con ``strict: false``,
   aumentamos a ``strict: true`` cuando cobertura sea >80%.

7. **Compatibilidad Total:** TypeScript y JavaScript coexisten sin
   problemas. Imports cross-language funcionan perfectamente.

**Trade-offs aceptados:** - Codebase mixto durante transición (6-12
meses estimado) - Type coverage parcial durante migración -
``allowJs: true`` en tsconfig (temporal) - Necesitamos disciplina para
migrar gradualmente

**Plan de Migración:** 1. **Crítico primero:** types, lib, hooks, config
(COMPLETADO) 2. **Services:** Migrar services y API clients (EN
PROGRESO) 3. **Components:** Migrar componentes React gradualmente 4.
**State:** Migrar Redux slices 5. **Tests:** Migrar tests a ``.test.ts``

--------------

Consecuencias
-------------

Positivas
~~~~~~~~~

-  **Type Safety Inmediato para Nuevos Módulos:** Todo código nuevo
   tiene types
-  **Refactoring Seguro:** Refactoring en módulos ``.ts`` es seguro con
   TS compiler
-  **Mejor IDE Experience:** Autocompletado, Go to Definition,
   Refactoring automático en archivos ``.ts``
-  **Documentación Autodocumentada:** Interfaces TypeScript documentan
   shape de objetos
-  **Menos Bugs en Producción:** Type checking detecta errores antes de
   runtime
-  **Onboarding Más Rápido:** Nuevos desarrolladores entienden código
   más rápido con types
-  **Catch Errors Early:** ESLint + TypeScript detectan errores en
   desarrollo

Negativas
~~~~~~~~~

-  **Codebase Mixto:** Durante transición, algunos archivos son ``.js``,
   otros ``.ts``
-  **Type Coverage Parcial:** No tenemos 100% type safety hasta
   completar migración
-  **Curva de Aprendizaje:** Equipo necesita aprender TypeScript
   gradualmente
-  **Build Time Mayor:** TypeScript compilation agrega tiempo al build
   (mínimo con esbuild)
-  **Configuración Más Compleja:** ``tsconfig.json`` + ``.eslintrc``
   para TypeScript

Neutrales
~~~~~~~~~

-  **Compatibilidad:** TypeScript es superset de JavaScript, todo JS es
   TS válido
-  **Testing:** Jest + React Testing Library funcionan igual con ``.ts``
   y ``.js``
-  **Bundle Size:** TypeScript es compile-time only, no afecta bundle
   final

--------------

Plan de Implementación
----------------------

Fase 1: Setup TypeScript - COMPLETADO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Instalar TypeScript
   npm install --save-dev typescript @types/react @types/react-dom
   npm install --save-dev @types/node @types/jest

   # Crear tsconfig.json
   npx tsc --init

.. code:: json

   // tsconfig.json
   {
     "compilerOptions": {
       "target": "ES2020",
       "lib": ["ES2020", "DOM", "DOM.Iterable"],
       "jsx": "react-jsx",
       "module": "ESNext",
       "moduleResolution": "node",
       "allowJs": true,
       "checkJs": false,
       "strict": false,
       "esModuleInterop": true,
       "skipLibCheck": true,
       "resolveJsonModule": true,
       "isolatedModules": true,
       "noEmit": true
     },
     "include": ["src/**/*"]
   }

Fase 2: Migrar Tipos y Configuración - COMPLETADO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: typescript

   // ✓ src/types/permisos.types.ts - MIGRADO
   export interface Permiso {
     id: string;
     codigo: string;
     nombre: string;
     descripcion: string;
   }

   export interface Usuario {
     id: number;
     username: string;
     email: string;
     permisos: Permiso[];
   }

   // ✓ src/config/api.config.ts - MIGRADO
   export const API_CONFIG = {
     baseURL: import.meta.env.VITE_API_BASE_URL || "http://localhost:8000",
     timeout: 30000,
   } as const;

   // ✓ src/lib/permisos-client.ts - MIGRADO
   import type { Permiso, Usuario } from "@/types/permisos.types";

   export class PermisosClient {
     async fetchUsuario(id: number): Promise<Usuario> {
       // Implementation...
     }

     async checkPermiso(codigo: string): Promise<boolean> {
       // Implementation...
     }
   }

   // ✓ src/hooks/usePermisos.ts - MIGRADO
   import { useState, useEffect } from "react";
   import type { Permiso } from "@/types/permisos.types";

   export function usePermisos(userId: number) {
     const [permisos, setPermisos] = useState<Permiso[]>([]);
     const [loading, setLoading] = useState(true);

     // Implementation...

     return { permisos, loading };
   }

Fase 3: Migrar Services - EN PROGRESO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: typescript

   // ⏳ src/services/AppConfigService.ts - PENDIENTE
   // ⏳ src/services/PermissionsService.ts - PENDIENTE
   // ⏳ src/services/CallsService.ts - PENDIENTE

Fase 4: Migrar Componentes - PENDIENTE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: typescript

   // ⏳ src/components/PermisosTable.tsx - PENDIENTE
   // ⏳ src/modules/home/HomeView.tsx - PENDIENTE

Fase 5: Aumentar Strictness - FUTURO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: json

   // tsconfig.json (Cuando coverage >80%)
   {
     "compilerOptions": {
       "strict": true,                  // Enable all strict checks
       "noUncheckedIndexedAccess": true,
       "noImplicitReturns": true,
       "noFallthroughCasesInSwitch": true
     }
   }

--------------

Validación y Métricas
---------------------

Criterios de Éxito
~~~~~~~~~~~~~~~~~~

================ ======== ====== =========== =============
Métrica          Baseline Target Actual      Estado
================ ======== ====== =========== =============
Archivos .ts     0        50%    ~15% (4/30) → EN PROGRESO
Type coverage    0%       80%    ~15%        → EN PROGRESO
Strict mode      false    true   false       ⏳ FUTURO
Type errors (TS) N/A      0      0           ✓ OK
Migración types/ 0%       100%   100%        ✓ COMPLETADO
Migración hooks/ 0%       100%   100%        ✓ COMPLETADO
Migración lib/   0%       100%   100%        ✓ COMPLETADO
================ ======== ====== =========== =============

KPIs de Calidad
~~~~~~~~~~~~~~~

.. code:: yaml

   Type Safety:
     - Runtime type errors: -30% (objetivo: -50%)
     - Type coverage: ~15% (objetivo: 80%)
     - Strict mode: false (objetivo: true cuando >80%)

   Developer Experience:
     - IDE autocomplete: Mejorado en archivos .ts
     - Go to Definition: Funciona en archivos .ts
     - Refactoring automático: Funciona en archivos .ts

   Performance:
     - Build time incremento: +5% (aceptable)
     - Bundle size: Sin cambio (TS es compile-time)
     - Hot reload: Sin cambio

Progreso de Migración
~~~~~~~~~~~~~~~~~~~~~

.. code:: yaml

   Completado (100%):
     - ✓ types/permisos.types.ts
     - ✓ hooks/usePermisos.ts
     - ✓ lib/permisos-client.ts
     - ✓ config/api.config.ts

   En Progreso (0-50%):
     - ⏳ services/*.js → .ts

   Pendiente (0%):
     - ⏳ components/*.jsx → .tsx
     - ⏳ state/slices/*.js → .ts
     - ⏳ modules/**/*.js → .ts

--------------

Alternativas Descartadas
------------------------

Flow (Facebook)
~~~~~~~~~~~~~~~

**Por qué se descartó:** - Comunidad más pequeña que TypeScript - Menos
adopción en industria - Tooling menos maduro - TypeScript es estándar de
facto

PropTypes Mejorado
~~~~~~~~~~~~~~~~~~

**Por qué se descartó:** - Solo valida en runtime, no compile-time - No
ayuda con refactoring - No mejora IDE experience - TypeScript es
superior en todos los aspectos

Elm o ReScript
~~~~~~~~~~~~~~

**Por qué se descartó:** - Requiere reescribir todo en nuevo lenguaje -
Curva de aprendizaje muy alta - No hay path gradual desde JavaScript -
Ecosistema limitado vs TypeScript

--------------

Referencias
-----------

Documentación Oficial
~~~~~~~~~~~~~~~~~~~~~

-  `TypeScript Documentation <https://www.typescriptlang.org/docs/>`__
-  `TypeScript +
   React <https://react-typescript-cheatsheet.netlify.app/>`__
-  `Migrating from JS to
   TS <https://www.typescriptlang.org/docs/handbook/migrating-from-javascript.html>`__
-  `TSConfig Reference <https://www.typescriptlang.org/tsconfig>`__

Guías de Migración
~~~~~~~~~~~~~~~~~~

-  `Adopting TypeScript at
   Scale <https://www.typescriptlang.org/docs/handbook/migrating-from-javascript.html>`__
-  `Airbnb TypeScript
   Migration <https://medium.com/airbnb-engineering/ts-migrate-a-tool-for-migrating-to-typescript-at-scale-cd23bfeb5cc>`__
-  `Stripe TypeScript
   Migration <https://stripe.com/blog/migrating-to-typescript>`__

Documentos del Proyecto
~~~~~~~~~~~~~~~~~~~~~~~

-  ``ui/tsconfig.json`` - Configuración TypeScript
-  ``ui/src/types/permisos.types.ts`` - Types de permisos
-  ``ui/src/hooks/usePermisos.ts`` - Custom hook con TypeScript
-  ADR-FRONT-001: Frontend Modular Monolith
-  ADR-QA-002: Testing Strategy Jest + Testing Library
-  RNF-FRONT-061: Mantenibilidad Frontend

--------------

Notas Adicionales
-----------------

Experiencia del Equipo
~~~~~~~~~~~~~~~~~~~~~~

**Feedback del equipo (en progreso):** - “TypeScript en types/ y hooks/
ya nos salvó de varios bugs” - “Autocompletado en archivos .ts es
increíble” - “Refactoring en archivos .ts es mucho más seguro” - “Curva
de aprendizaje es gradual, no abrupta”

Decisiones Técnicas Relacionadas
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Naming Convention:** - Types/Interfaces: PascalCase (``Usuario``,
``Permiso``) - Type files: ``*.types.ts`` (eg: ``permisos.types.ts``) -
React components: ``.tsx`` (eg: ``UserTable.tsx``) - Other modules:
``.ts`` (eg: ``api-client.ts``)

**Import Paths:** - Usar path aliases: ``@/types/permisos.types`` -
Configurado en tsconfig: ``"paths": {"@/*": ["./src/*"]}`` - Vite config
también necesita alias

**Strict Mode Strategy:** - **Fase 1-3:** ``strict: false`` (actual) -
**Fase 4:** Cuando cobertura >50%, habilitar checks individuales: -
``noImplicitAny: true`` - ``strictNullChecks: true`` - **Fase 5:**
Cuando cobertura >80%, habilitar ``strict: true`` completo

Lecciones Aprendidas
~~~~~~~~~~~~~~~~~~~~

**Do’s:** - ✓ Migrar types y shared libs primero - ✓ Usar
``allowJs: true`` durante transición - ✓ No forzar strict mode desde el
inicio - ✓ Migrar módulo completo, no archivos sueltos - ✓ Agregar types
a nuevos módulos desde día 1

**Don’ts:** - ✗ No migrar todo de una vez (big bang) - ✗ No habilitar
strict mode con coverage bajo - ✗ No mezclar ``.js`` y ``.ts`` en mismo
módulo - ✗ No usar ``any`` como escape hatch - ✗ No ignorar type errors
con ``@ts-ignore``

Roadmap Futuro
~~~~~~~~~~~~~~

**Q2 2025:** - Completar migración de services/ a TypeScript - Migrar
componentes críticos a .tsx - Objetivo: 50% type coverage

**Q3 2025:** - Migrar Redux slices a TypeScript - Migrar componentes
restantes a .tsx - Objetivo: 80% type coverage

**Q4 2025:** - Habilitar strict mode - Eliminar ``allowJs`` de tsconfig
- Objetivo: 100% type coverage, strict: true

--------------

Changelog
---------

+------------------------+-------------------+------------------------+
| Versión                | Fecha             | Cambios                |
+========================+===================+========================+
| 1.0                    | 2025-01-17        | ADR inicial            |
|                        |                   | documentando adopción  |
|                        |                   | gradual TypeScript     |
+------------------------+-------------------+------------------------+

--------------

**Documento:** ADR-FRONT-010 **Fecha:** 17 de Enero, 2025 **Estado:**
Aprobado **Próxima revisión:** 2025-07-17 (semestral durante migración)
