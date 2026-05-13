---
id: GUIA-DEPLOYMENT-005
tipo: guia_operativa
categoria: deployment
audiencia: desarrolladores-frontend
prioridad: P1
tiempo_lectura: 25 minutos
version: 1.0.0
fecha: 2025-11-07
relacionados: ["deployment_003_implementacion_permisos_granular", "deployment_004_tdd_backend_permisos_granular", "CATALOGO_GRUPOS_FUNCIONALES"]
---

# Implementacion TDD Frontend - Sistema de Permisos Granular

## Proposito

Esta guia explica como implementar los componentes frontend del sistema de permisos granular usando Test-Driven Development (TDD) con React, Jest y Testing Library.

## Audiencia

Esta guia esta dirigida a: **Desarrolladores frontend** que implementaran la UI del sistema de permisos granular usando TDD.

## Pre-requisitos

- [ ] Haber leido GUIA-DEPLOYMENT-003 y GUIA-DEPLOYMENT-004
- [ ] Conocimiento de React 18+ y hooks
- [ ] Conocimiento de Redux Toolkit
- [ ] Conocimiento de Jest y React Testing Library
- [ ] Conocimiento de TDD (Red-Green-Refactor)
- [ ] Node.js 18+ instalado

## Tiempo estimado

Tiempo de lectura: 25 minutos
Tiempo de implementacion completa: 20-30 horas distribuidas en 3-4 semanas

## Contexto: Filosofia TDD para Frontend

**Ciclo TDD (Red-Green-Refactor):**
1. RED: Escribir test que falle (componente no existe)
2. GREEN: Escribir componente minimo para que pase
3. REFACTOR: Mejorar el codigo manteniendo tests pasando

**Tipos de tests frontend:**
- Tests unitarios: Componentes aislados, hooks, utilidades
- Tests de integracion: Componentes + Redux + API mocks
- Tests de accesibilidad: ARIA, keyboard navigation
- Tests visuales: Snapshot testing (opcional)

**Cobertura esperada:**
- Cobertura de lineas: 80%+
- Cobertura de ramas: 75%+
- Tests totales: ~150-200 tests
- Tiempo de ejecucion: <30 segundos

## Pasos

### Fase 1: Setup de Testing Environment (Semana 1)

#### 1.1 Verificar Configuracion Jest

**Archivo**: `ui/jest.config.js` (crear si no existe)

```javascript
module.exports = {
  testEnvironment: 'jsdom',
  setupFilesAfterEnv: ['<rootDir>/src/setupTests.js'],
  moduleNameMapper: {
    '\\.(css|less|scss|sass)$': 'identity-obj-proxy',
    '^@/(.*)$': '<rootDir>/src/$1',
  },
  collectCoverageFrom: [
    'src/**/*.{js,jsx}',
    '!src/index.js',
    '!src/setupTests.js',
    '!**/__tests__/**',
    '!**/node_modules/**',
  ],
  coverageThresholds: {
    global: {
      lines: 80,
      branches: 75,
      functions: 80,
      statements: 80,
    },
  },
  testMatch: [
    '**/__tests__/**/*.{js,jsx}',
    '**/*.test.{js,jsx}',
    '**/*.spec.{js,jsx}',
  ],
  transform: {
    '^.+\\.(js|jsx)$': 'babel-jest',
  },
};
```

#### 1.2 Setup de Testing Library

**Archivo**: `ui/src/setupTests.js`

```javascript
// jest-dom adds custom jest matchers for asserting on DOM nodes
import '@testing-library/jest-dom';

// Mock console.error to fail tests on React warnings
const originalError = console.error;

beforeAll(() => {
  console.error = (...args) => {
    if (
      typeof args[0] === 'string' &&
      args[0].includes('Warning:')
    ) {
      throw new Error(args[0]);
    }
    originalError.call(console, ...args);
  };
});

afterAll(() => {
  console.error = originalError;
});

// Mock window.matchMedia (required for some components)
Object.defineProperty(window, 'matchMedia', {
  writable: true,
  value: jest.fn().mockImplementation((query) => ({
    matches: false,
    media: query,
    onchange: null,
    addListener: jest.fn(),
    removeListener: jest.fn(),
    addEventListener: jest.fn(),
    removeEventListener: jest.fn(),
    dispatchEvent: jest.fn(),
  })),
});
```

#### 1.3 Crear Estructura de Directorios

```bash
cd ui/src

mkdir -p components/permissions/__tests__
mkdir -p components/permissions/UserGroupsManager
mkdir -p components/permissions/CapabilitiesViewer
mkdir -p components/permissions/PermissionChecker
mkdir -p hooks/__tests__
mkdir -p store/permissions/__tests__
mkdir -p services/__tests__
mkdir -p utils/__tests__
```

**Estructura esperada:**

```
ui/src/
├── components/
│   └── permissions/
│       ├── __tests__/
│       │   ├── UserGroupsManager.test.js
│       │   ├── CapabilitiesViewer.test.js
│       │   └── PermissionChecker.test.js
│       ├── UserGroupsManager/
│       │   ├── index.js
│       │   └── UserGroupsManager.js
│       ├── CapabilitiesViewer/
│       │   ├── index.js
│       │   └── CapabilitiesViewer.js
│       └── PermissionChecker/
│           ├── index.js
│           └── PermissionChecker.js
├── hooks/
│   ├── __tests__/
│   │   ├── usePermissions.test.js
│   │   └── useUserGroups.test.js
│   ├── usePermissions.js
│   └── useUserGroups.js
├── store/
│   └── permissions/
│       ├── __tests__/
│       │   └── permissionsSlice.test.js
│       └── permissionsSlice.js
├── services/
│   ├── __tests__/
│   │   └── permissionsApi.test.js
│   └── permissionsApi.js
└── utils/
    ├── __tests__/
    │   └── permissionHelpers.test.js
    └── permissionHelpers.js
```

### Fase 2: Tests de Utilidades (Semana 1)

#### 2.1 Tests para Helpers de Permisos

**Archivo**: `ui/src/utils/__tests__/permissionHelpers.test.js`

```javascript
/**
 * Tests TDD para utilidades de permisos.
 */

import {
  hasCapability,
  getCapabilitiesFromGroups,
  formatCapabilityCode,
} from '../permissionHelpers';

describe('permissionHelpers', () => {
  describe('hasCapability', () => {
    it('retorna true cuando usuario tiene la capacidad', () => {
      // GIVEN
      const userCapabilities = [
        'sistema.administracion.usuarios.crear',
        'sistema.vistas.dashboards.ver',
      ];
      const requiredCapability = 'sistema.administracion.usuarios.crear';

      // WHEN
      const result = hasCapability(userCapabilities, requiredCapability);

      // THEN
      expect(result).toBe(true);
    });

    it('retorna false cuando usuario NO tiene la capacidad', () => {
      // GIVEN
      const userCapabilities = [
        'sistema.vistas.dashboards.ver',
      ];
      const requiredCapability = 'sistema.administracion.usuarios.crear';

      // WHEN
      const result = hasCapability(userCapabilities, requiredCapability);

      // THEN
      expect(result).toBe(false);
    });

    it('retorna false cuando userCapabilities es vacio', () => {
      // GIVEN
      const userCapabilities = [];
      const requiredCapability = 'sistema.administracion.usuarios.crear';

      // WHEN
      const result = hasCapability(userCapabilities, requiredCapability);

      // THEN
      expect(result).toBe(false);
    });

    it('retorna false cuando userCapabilities es null', () => {
      // GIVEN
      const userCapabilities = null;
      const requiredCapability = 'sistema.administracion.usuarios.crear';

      // WHEN
      const result = hasCapability(userCapabilities, requiredCapability);

      // THEN
      expect(result).toBe(false);
    });
  });

  describe('getCapabilitiesFromGroups', () => {
    it('retorna todas las capacidades de los grupos del usuario', () => {
      // GIVEN
      const userGroups = [
        {
          codigo: 'atencion_cliente',
          capacidades: [
            { codigo: 'sistema.operaciones.llamadas.realizar' },
            { codigo: 'sistema.operaciones.tickets.crear' },
          ],
        },
        {
          codigo: 'visualizacion_basica',
          capacidades: [
            { codigo: 'sistema.vistas.dashboards.ver' },
          ],
        },
      ];

      // WHEN
      const result = getCapabilitiesFromGroups(userGroups);

      // THEN
      expect(result).toHaveLength(3);
      expect(result).toContain('sistema.operaciones.llamadas.realizar');
      expect(result).toContain('sistema.operaciones.tickets.crear');
      expect(result).toContain('sistema.vistas.dashboards.ver');
    });

    it('elimina capacidades duplicadas', () => {
      // GIVEN
      const userGroups = [
        {
          codigo: 'grupo1',
          capacidades: [
            { codigo: 'sistema.capacidad.duplicada' },
          ],
        },
        {
          codigo: 'grupo2',
          capacidades: [
            { codigo: 'sistema.capacidad.duplicada' },
          ],
        },
      ];

      // WHEN
      const result = getCapabilitiesFromGroups(userGroups);

      // THEN
      expect(result).toHaveLength(1);
      expect(result).toContain('sistema.capacidad.duplicada');
    });

    it('retorna array vacio cuando no hay grupos', () => {
      // GIVEN
      const userGroups = [];

      // WHEN
      const result = getCapabilitiesFromGroups(userGroups);

      // THEN
      expect(result).toEqual([]);
    });
  });

  describe('formatCapabilityCode', () => {
    it('formatea codigo de capacidad para display', () => {
      // GIVEN
      const code = 'sistema.administracion.usuarios.crear';

      // WHEN
      const result = formatCapabilityCode(code);

      // THEN
      expect(result).toBe('Crear Usuarios');
    });

    it('maneja codigos cortos', () => {
      // GIVEN
      const code = 'sistema.test';

      // WHEN
      const result = formatCapabilityCode(code);

      // THEN
      expect(result).toBe('Test');
    });
  });
});
```

**Implementacion**: `ui/src/utils/permissionHelpers.js`

```javascript
/**
 * Utilidades para manejo de permisos.
 */

export function hasCapability(userCapabilities, requiredCapability) {
  if (!userCapabilities || !Array.isArray(userCapabilities)) {
    return false;
  }
  return userCapabilities.includes(requiredCapability);
}

export function getCapabilitiesFromGroups(userGroups) {
  if (!userGroups || !Array.isArray(userGroups)) {
    return [];
  }

  const capabilities = userGroups.flatMap(
    (group) => group.capacidades?.map((cap) => cap.codigo) || []
  );

  // Eliminar duplicados
  return [...new Set(capabilities)];
}

export function formatCapabilityCode(code) {
  if (!code) return '';

  const parts = code.split('.');
  const lastPart = parts[parts.length - 1];

  // Capitalizar primera letra
  return lastPart
    .split('_')
    .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
    .join(' ');
}
```

### Fase 3: Tests de Hooks (Semana 1-2)

#### 3.1 Tests para usePermissions Hook

**Archivo**: `ui/src/hooks/__tests__/usePermissions.test.js`

```javascript
/**
 * Tests TDD para hook usePermissions.
 */

import { renderHook, waitFor } from '@testing-library/react';
import { Provider } from 'react-redux';
import { configureStore } from '@reduxjs/toolkit';
import usePermissions from '../usePermissions';
import permissionsReducer from '../../store/permissions/permissionsSlice';

// Helper para crear store de prueba
function createTestStore(initialState = {}) {
  return configureStore({
    reducer: {
      permissions: permissionsReducer,
    },
    preloadedState: {
      permissions: {
        capabilities: [],
        groups: [],
        loading: false,
        error: null,
        ...initialState,
      },
    },
  });
}

// Wrapper component
function createWrapper(store) {
  return ({ children }) => <Provider store={store}>{children}</Provider>;
}

describe('usePermissions', () => {
  it('retorna capabilities y hasCapability function', () => {
    // GIVEN
    const store = createTestStore({
      capabilities: ['sistema.test.capacidad'],
    });

    // WHEN
    const { result } = renderHook(() => usePermissions(), {
      wrapper: createWrapper(store),
    });

    // THEN
    expect(result.current.capabilities).toEqual(['sistema.test.capacidad']);
    expect(typeof result.current.hasCapability).toBe('function');
  });

  it('hasCapability retorna true cuando usuario tiene capacidad', () => {
    // GIVEN
    const store = createTestStore({
      capabilities: ['sistema.administracion.usuarios.crear'],
    });

    // WHEN
    const { result } = renderHook(() => usePermissions(), {
      wrapper: createWrapper(store),
    });

    // THEN
    const hasIt = result.current.hasCapability('sistema.administracion.usuarios.crear');
    expect(hasIt).toBe(true);
  });

  it('hasCapability retorna false cuando usuario NO tiene capacidad', () => {
    // GIVEN
    const store = createTestStore({
      capabilities: [],
    });

    // WHEN
    const { result } = renderHook(() => usePermissions(), {
      wrapper: createWrapper(store),
    });

    // THEN
    const hasIt = result.current.hasCapability('sistema.administracion.usuarios.crear');
    expect(hasIt).toBe(false);
  });

  it('isLoading retorna true cuando esta cargando', () => {
    // GIVEN
    const store = createTestStore({
      loading: true,
    });

    // WHEN
    const { result } = renderHook(() => usePermissions(), {
      wrapper: createWrapper(store),
    });

    // THEN
    expect(result.current.isLoading).toBe(true);
  });
});
```

**Implementacion**: `ui/src/hooks/usePermissions.js`

```javascript
/**
 * Hook para acceder a permisos del usuario.
 */

import { useSelector } from 'react-redux';
import { hasCapability as hasCapabilityUtil } from '../utils/permissionHelpers';

export default function usePermissions() {
  const capabilities = useSelector((state) => state.permissions.capabilities);
  const loading = useSelector((state) => state.permissions.loading);
  const error = useSelector((state) => state.permissions.error);

  const hasCapability = (requiredCapability) => {
    return hasCapabilityUtil(capabilities, requiredCapability);
  };

  return {
    capabilities,
    hasCapability,
    isLoading: loading,
    error,
  };
}
```

### Fase 4: Tests de Redux Slices (Semana 2)

#### 4.1 Tests para permissionsSlice

**Archivo**: `ui/src/store/permissions/__tests__/permissionsSlice.test.js`

```javascript
/**
 * Tests TDD para permissionsSlice (Redux Toolkit).
 */

import permissionsReducer, {
  setCapabilities,
  setGroups,
  setLoading,
  setError,
} from '../permissionsSlice';

describe('permissionsSlice', () => {
  const initialState = {
    capabilities: [],
    groups: [],
    loading: false,
    error: null,
  };

  it('retorna estado inicial', () => {
    // WHEN
    const result = permissionsReducer(undefined, { type: 'unknown' });

    // THEN
    expect(result).toEqual(initialState);
  });

  it('setCapabilities actualiza capabilities', () => {
    // GIVEN
    const newCapabilities = ['sistema.test.capacidad1', 'sistema.test.capacidad2'];

    // WHEN
    const result = permissionsReducer(
      initialState,
      setCapabilities(newCapabilities)
    );

    // THEN
    expect(result.capabilities).toEqual(newCapabilities);
  });

  it('setGroups actualiza groups', () => {
    // GIVEN
    const newGroups = [
      { codigo: 'grupo1', nombre: 'Grupo 1' },
      { codigo: 'grupo2', nombre: 'Grupo 2' },
    ];

    // WHEN
    const result = permissionsReducer(initialState, setGroups(newGroups));

    // THEN
    expect(result.groups).toEqual(newGroups);
  });

  it('setLoading actualiza estado de loading', () => {
    // WHEN
    const result = permissionsReducer(initialState, setLoading(true));

    // THEN
    expect(result.loading).toBe(true);
  });

  it('setError actualiza error', () => {
    // GIVEN
    const errorMessage = 'Error al cargar permisos';

    // WHEN
    const result = permissionsReducer(initialState, setError(errorMessage));

    // THEN
    expect(result.error).toBe(errorMessage);
  });
});
```

**Implementacion**: `ui/src/store/permissions/permissionsSlice.js`

```javascript
/**
 * Redux slice para manejo de permisos.
 */

import { createSlice } from '@reduxjs/toolkit';

const initialState = {
  capabilities: [],
  groups: [],
  loading: false,
  error: null,
};

const permissionsSlice = createSlice({
  name: 'permissions',
  initialState,
  reducers: {
    setCapabilities: (state, action) => {
      state.capabilities = action.payload;
    },
    setGroups: (state, action) => {
      state.groups = action.payload;
    },
    setLoading: (state, action) => {
      state.loading = action.payload;
    },
    setError: (state, action) => {
      state.error = action.payload;
    },
  },
});

export const { setCapabilities, setGroups, setLoading, setError } =
  permissionsSlice.actions;

export default permissionsSlice.reducer;
```

### Fase 5: Tests de Componentes (Semana 2-3)

#### 5.1 Tests para PermissionChecker Component

**Archivo**: `ui/src/components/permissions/__tests__/PermissionChecker.test.js`

```javascript
/**
 * Tests TDD para componente PermissionChecker.
 *
 * Componente que renderiza children solo si usuario tiene capacidad.
 */

import React from 'react';
import { render, screen } from '@testing-library/react';
import { Provider } from 'react-redux';
import { configureStore } from '@reduxjs/toolkit';
import PermissionChecker from '../PermissionChecker';
import permissionsReducer from '../../../store/permissions/permissionsSlice';

function createTestStore(capabilities = []) {
  return configureStore({
    reducer: {
      permissions: permissionsReducer,
    },
    preloadedState: {
      permissions: {
        capabilities,
        groups: [],
        loading: false,
        error: null,
      },
    },
  });
}

describe('PermissionChecker', () => {
  it('renderiza children cuando usuario tiene capacidad', () => {
    // GIVEN
    const store = createTestStore(['sistema.administracion.usuarios.crear']);

    // WHEN
    render(
      <Provider store={store}>
        <PermissionChecker requiredCapability="sistema.administracion.usuarios.crear">
          <button>Crear Usuario</button>
        </PermissionChecker>
      </Provider>
    );

    // THEN
    expect(screen.getByText('Crear Usuario')).toBeInTheDocument();
  });

  it('NO renderiza children cuando usuario NO tiene capacidad', () => {
    // GIVEN
    const store = createTestStore([]);

    // WHEN
    render(
      <Provider store={store}>
        <PermissionChecker requiredCapability="sistema.administracion.usuarios.crear">
          <button>Crear Usuario</button>
        </PermissionChecker>
      </Provider>
    );

    // THEN
    expect(screen.queryByText('Crear Usuario')).not.toBeInTheDocument();
  });

  it('renderiza fallback cuando no tiene capacidad y fallback es provisto', () => {
    // GIVEN
    const store = createTestStore([]);
    const fallback = <div>No autorizado</div>;

    // WHEN
    render(
      <Provider store={store}>
        <PermissionChecker
          requiredCapability="sistema.administracion.usuarios.crear"
          fallback={fallback}
        >
          <button>Crear Usuario</button>
        </PermissionChecker>
      </Provider>
    );

    // THEN
    expect(screen.queryByText('Crear Usuario')).not.toBeInTheDocument();
    expect(screen.getByText('No autorizado')).toBeInTheDocument();
  });

  it('renderiza children cuando requiredCapability es null (sin restriccion)', () => {
    // GIVEN
    const store = createTestStore([]);

    // WHEN
    render(
      <Provider store={store}>
        <PermissionChecker requiredCapability={null}>
          <button>Siempre visible</button>
        </PermissionChecker>
      </Provider>
    );

    // THEN
    expect(screen.getByText('Siempre visible')).toBeInTheDocument();
  });
});
```

**Implementacion**: `ui/src/components/permissions/PermissionChecker/PermissionChecker.js`

```javascript
/**
 * Componente PermissionChecker.
 *
 * Renderiza children solo si usuario tiene la capacidad requerida.
 */

import React from 'react';
import PropTypes from 'prop-types';
import usePermissions from '../../../hooks/usePermissions';

function PermissionChecker({ requiredCapability, children, fallback }) {
  const { hasCapability } = usePermissions();

  // Si no se requiere capacidad, siempre renderizar
  if (!requiredCapability) {
    return <>{children}</>;
  }

  // Verificar si usuario tiene capacidad
  if (hasCapability(requiredCapability)) {
    return <>{children}</>;
  }

  // No tiene capacidad, renderizar fallback o null
  return fallback || null;
}

PermissionChecker.propTypes = {
  requiredCapability: PropTypes.string,
  children: PropTypes.node.isRequired,
  fallback: PropTypes.node,
};

PermissionChecker.defaultProps = {
  requiredCapability: null,
  fallback: null,
};

export default PermissionChecker;
```

### Fase 6: Tests de Integracion (Semana 3-4)

#### 6.1 Tests de Integracion Completa

**Archivo**: `ui/src/components/permissions/__tests__/UserGroupsManager.integration.test.js`

```javascript
/**
 * Tests de integracion para UserGroupsManager.
 *
 * Simula flujo completo: cargar grupos, asignar, desasignar.
 */

import React from 'react';
import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { Provider } from 'react-redux';
import { configureStore } from '@reduxjs/toolkit';
import UserGroupsManager from '../UserGroupsManager';
import permissionsReducer from '../../../store/permissions/permissionsSlice';
import * as permissionsApi from '../../../services/permissionsApi';

// Mock de API
jest.mock('../../../services/permissionsApi');

function createTestStore() {
  return configureStore({
    reducer: {
      permissions: permissionsReducer,
    },
  });
}

describe('UserGroupsManager - Integration', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('flujo completo: cargar grupos y asignar grupo a usuario', async () => {
    // GIVEN: API retorna grupos disponibles
    const gruposDisponibles = [
      {
        codigo: 'atencion_cliente',
        nombre: 'Atencion al Cliente',
        descripcion: 'Grupo para agentes',
      },
      {
        codigo: 'administracion_usuarios',
        nombre: 'Administracion de Usuarios',
        descripcion: 'Grupo para administradores',
      },
    ];

    permissionsApi.fetchAvailableGroups.mockResolvedValue(gruposDisponibles);
    permissionsApi.assignGroupToUser.mockResolvedValue({ success: true });

    const store = createTestStore();
    const userId = 123;

    // WHEN: Renderizar componente
    render(
      <Provider store={store}>
        <UserGroupsManager userId={userId} />
      </Provider>
    );

    // THEN: Debe cargar grupos
    await waitFor(() => {
      expect(screen.getByText('Atencion al Cliente')).toBeInTheDocument();
      expect(screen.getByText('Administracion de Usuarios')).toBeInTheDocument();
    });

    // WHEN: Usuario hace clic en "Asignar" del primer grupo
    const assignButton = screen.getAllByText('Asignar')[0];
    await userEvent.click(assignButton);

    // THEN: Debe llamar API con parametros correctos
    await waitFor(() => {
      expect(permissionsApi.assignGroupToUser).toHaveBeenCalledWith(
        userId,
        'atencion_cliente'
      );
    });

    // THEN: Debe mostrar confirmacion
    await waitFor(() => {
      expect(screen.getByText('Grupo asignado exitosamente')).toBeInTheDocument();
    });
  });

  it('maneja error de API correctamente', async () => {
    // GIVEN: API retorna error
    permissionsApi.fetchAvailableGroups.mockRejectedValue(
      new Error('Error de red')
    );

    const store = createTestStore();
    const userId = 123;

    // WHEN: Renderizar componente
    render(
      <Provider store={store}>
        <UserGroupsManager userId={userId} />
      </Provider>
    );

    // THEN: Debe mostrar mensaje de error
    await waitFor(() => {
      expect(screen.getByText(/Error al cargar grupos/i)).toBeInTheDocument();
    });
  });
});
```

## Validacion

Para validar que completaste correctamente esta guia:

- [ ] jest.config.js configurado correctamente
- [ ] setupTests.js creado
- [ ] Estructura de directorios creada
- [ ] Tests de utilidades escritos y pasando
- [ ] Tests de hooks escritos y pasando
- [ ] Tests de Redux slices escritos y pasando
- [ ] Tests de componentes escritos y pasando
- [ ] Tests de integracion escritos y pasando
- [ ] Cobertura de codigo >= 80%

## Como interpretar resultados

**Ejecutar tests**:

```bash
cd ui

# Todos los tests
npm test

# Watch mode (desarrollo TDD)
npm run test:watch

# Con cobertura
npm run test:coverage

# Ver reporte de cobertura
open coverage/lcov-report/index.html
```

**Exito**:
- Todos los tests pasan
- Cobertura >= 80%
- Tiempo de ejecucion < 30 segundos
- 0 console.errors

## Troubleshooting

### Error 1: Tests no encuentran componentes

**Sintomas**:
```
Unable to find element with text: "Crear Usuario"
```

**Causa**: Componente no renderiza correctamente

**Solucion**:
```bash
# Verificar que Provider esta configurado
# Verificar que store tiene estado inicial correcto
# Usar screen.debug() para ver DOM renderizado
```

### Error 2: Tests de Redux fallan

**Sintomas**:
```
Cannot read property 'permissions' of undefined
```

**Causa**: Store no configurado en wrapper

**Solucion**:
```javascript
// Crear wrapper con Provider
function createWrapper(store) {
  return ({ children }) => (
    <Provider store={store}>{children}</Provider>
  );
}
```

## Metricas de Exito

```
Tests totales: 150-200
Tests unitarios: 90-120 (60%)
Tests integracion: 40-60 (30%)
Tests accesibilidad: 15-20 (10%)

Cobertura lineas: >= 80%
Cobertura ramas: >= 75%
Tiempo ejecucion: < 30 segundos

Tests por tipo:
- Utilidades: 30-40 tests
- Hooks: 20-30 tests
- Redux: 20-25 tests
- Componentes: 60-80 tests
- Integracion: 20-30 tests
```

## Proximos pasos

Despues de completar implementacion TDD frontend:

1. **GUIA-DEPLOYMENT-006**: Integracion Backend + Frontend
2. **GUIA-DEPLOYMENT-007**: Tests E2E con Cypress
3. **GUIA-WORKFLOWS-007**: Code Review de Implementacion TDD
4. Validar test pyramid con `scripts/test_pyramid_check.sh`

## Referencias

- Jest documentation: https://jestjs.io/
- React Testing Library: https://testing-library.com/react
- Redux Testing: https://redux.js.org/usage/writing-tests
- TDD best practices: https://testdriven.io/

## Feedback

Si encuentras problemas con esta guia o tienes sugerencias:
- Crea un issue en GitHub con label `documentation`
- Contacta a: equipo-frontend

---

**Mantenedores**: equipo-frontend, equipo-qa
**Ultima actualizacion**: 2025-11-07
