---
id: FRONTEND-PERMISOS-INTEGRATION
tipo: guia_tecnica
estado: activo
fecha: 2025-11-09
owner: equipo-frontend
prioridad: alta
relacionados: ["ADR_2025_010", "permisos-granular.md", "GAP_ANALYSIS_SISTEMA_PERMISOS.md"]
---

# Guía de Integración - Sistema de Permisos Granular (Frontend)

## Resumen Ejecutivo

Esta guía documenta cómo integrar el Sistema de Permisos Granular en aplicaciones frontend (React, Vue, Angular). Incluye cliente TypeScript, hooks de React, componentes de protección y mejores prácticas.

**Estado**: Producción
**Backend API**: `/api/permisos/*`
**Autenticación**: JWT Bearer Token

---

## 1. Arquitectura de Integración

```
┌─────────────────────────────────────────────────────┐
│                  React Application                  │
│  ┌────────────────────────────────────────────────┐ │
│  │         Components (Protected)                 │ │
│  │  <PermissionGate permission="...">            │ │
│  │    <Dashboard />                               │ │
│  │  </PermissionGate>                             │ │
│  └─────────────────┬──────────────────────────────┘ │
│                    │                                 │
│  ┌─────────────────|──────────────────────────────┐ │
│  │         Custom Hooks                           │ │
│  │  usePermisos(), useMenu(), useCapacidades()   │ │
│  │  - Caché local (localStorage)                  │ │
│  │  - Auto-refresh (5 min TTL)                    │ │
│  └─────────────────┬──────────────────────────────┘ │
│                    │                                 │
│  ┌─────────────────|──────────────────────────────┐ │
│  │         PermisosClient (API Client)            │ │
│  │  - HTTP requests con Axios/Fetch              │ │
│  │  - JWT authentication automática               │ │
│  │  - Error handling centralizado                 │ │
│  └─────────────────┬──────────────────────────────┘ │
└────────────────────┼───────────────────────────────┘
                     │
                     │ HTTPS
                     |
           ┌──────────────────┐
           │   Backend API    │
           │ /api/permisos/*  │
           └──────────────────┘
```

---

## 2. Instalación y Setup

### 2.1 Dependencias

```bash
npm install axios jwt-decode
# o
yarn add axios jwt-decode
```

### 2.2 Estructura de Archivos

Crea la siguiente estructura en tu proyecto:

```
src/
├── lib/
│   └── permisos-client.ts        # Cliente API
├── hooks/
│   └── usePermisos.ts             # Custom hooks
├── components/
│   ├── PermissionGate.tsx         # Componente de protección
│   └── ProtectedRoute.tsx         # Protección de rutas
├── types/
│   └── permisos.types.ts          # TypeScript types
└── config/
    └── api.config.ts              # Configuración API
```

---

## 3. Configuración de API

### 3.1 Archivo de Configuración

**Archivo**: `src/config/api.config.ts`

```typescript
export const API_CONFIG = {
  baseURL: process.env.REACT_APP_API_URL || 'http://localhost:8000',
  endpoints: {
    permisos: {
      verificar: (userId: number) => `/api/permisos/verificar/${userId}`,
      capacidades: (userId: number) => `/api/permisos/verificar/${userId}/capacidades/`,
      tienePermiso: (userId: number, capacidad: string) =>
        `/api/permisos/verificar/${userId}/tiene-permiso/?capacidad=${capacidad}`,
      menu: (userId: number) => `/api/permisos/verificar/${userId}/menu/`,
      grupos: (userId: number) => `/api/permisos/verificar/${userId}/grupos/`,
    },
  },
  cache: {
    ttl: 5 * 60 * 1000, // 5 minutos
    storageKey: 'permisos_cache',
  },
};
```

### 3.2 Variables de Entorno

**Archivo**: `.env`

```bash
REACT_APP_API_URL=https://api.yourdomain.com
REACT_APP_JWT_TOKEN_KEY=auth_token
REACT_APP_PERMISOS_CACHE_TTL=300000
```

---

## 4. Cliente TypeScript

### 4.1 Types (TypeScript)

**Archivo**: `src/types/permisos.types.ts`

```typescript
export interface Capacidad {
  id: number;
  codigo: string;
  nombre: string;
  nivel_riesgo: 'bajo' | 'medio' | 'alto' | 'critico';
}

export interface Grupo {
  id: number;
  codigo: string;
  nombre: string;
  categoria: string;
  nivel_riesgo: 'bajo' | 'medio' | 'alto' | 'critico';
}

export interface UsuarioCapacidades {
  usuario_id: number;
  capacidades: string[];
  total: number;
}

export interface VerificarPermisoResponse {
  usuario_id: number;
  capacidad_codigo: string;
  tiene_permiso: boolean;
  origen?: string;
}

export interface MenuNode {
  [dominio: string]: {
    [funcion: string]: string[]; // Array de capacidades
  };
}

export interface MenuUsuarioResponse {
  usuario_id: number;
  menu: MenuNode;
}

export interface GrupoUsuario {
  grupo_id: number;
  grupo_codigo: string;
  grupo_nombre: string;
  tipo_acceso: string;
  color_hex: string;
  vigente: boolean;
  fecha_asignacion: string;
  fecha_expiracion: string | null;
}

export interface PermisosCache {
  capacidades: string[];
  timestamp: number;
  userId: number;
}

export class PermisosError extends Error {
  constructor(
    message: string,
    public statusCode?: number,
    public response?: any
  ) {
    super(message);
    this.name = 'PermisosError';
  }
}
```

### 4.2 Cliente API

**Archivo**: `src/lib/permisos-client.ts`

Ver implementación completa en archivo adjunto (150 líneas).

**Características**:
- Singleton pattern
- Caché automático con TTL
- Manejo de errores centralizado
- Auto-refresh de token JWT
- TypeScript strict mode

### 4.3 Uso del Cliente

```typescript
import { PermisosClient } from '@/lib/permisos-client';

const client = PermisosClient.getInstance();

// Obtener capacidades del usuario
const capacidades = await client.getCapacidades(userId);

// Verificar permiso específico
const tienePermiso = await client.tienePermiso(
  userId,
  'sistema.vistas.dashboards.ver'
);

// Obtener menú dinámico
const menu = await client.getMenu(userId);

// Obtener grupos activos
const grupos = await client.getGrupos(userId);

// Limpiar caché manualmente
client.clearCache();
```

---

## 5. Custom Hooks (React)

### 5.1 Hook Principal: usePermisos

**Archivo**: `src/hooks/usePermisos.ts`

Ver implementación completa en archivo adjunto (100 líneas).

**API**:
```typescript
const {
  hasPermission,      // (capacidad: string) => boolean
  capacidades,        // string[]
  loading,            // boolean
  error,              // Error | null
  refreshPermissions, // () => Promise<void>
} = usePermisos();
```

**Ejemplo de uso**:
```typescript
import { usePermisos } from '@/hooks/usePermisos';

function Dashboard() {
  const { hasPermission, loading } = usePermisos();

  if (loading) return <Spinner />;

  if (!hasPermission('sistema.vistas.dashboards.ver')) {
    return <AccessDenied />;
  }

  return <DashboardContent />;
}
```

### 5.2 Hook: useMenu

```typescript
export function useMenu() {
  const [menu, setMenu] = useState<MenuNode>({});
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);
  const { user } = useAuth(); // Tu hook de autenticación

  useEffect(() => {
    const loadMenu = async () => {
      if (!user?.id) return;

      try {
        setLoading(true);
        const client = PermisosClient.getInstance();
        const menuData = await client.getMenu(user.id);
        setMenu(menuData.menu);
        setError(null);
      } catch (err) {
        setError(err as Error);
      } finally {
        setLoading(false);
      }
    };

    loadMenu();
  }, [user?.id]);

  return { menu, loading, error };
}
```

**Ejemplo de uso**:
```typescript
import { useMenu } from '@/hooks/usePermisos';

function Navbar() {
  const { menu, loading } = useMenu();

  if (loading) return <Skeleton />;

  return (
    <nav>
      {Object.entries(menu).map(([dominio, funciones]) => (
        <MenuItem key={dominio} title={dominio}>
          {Object.keys(funciones).map(funcion => (
            <SubMenuItem key={funcion} to={`/${dominio}/${funcion}`}>
              {funcion}
            </SubMenuItem>
          ))}
        </MenuItem>
      ))}
    </nav>
  );
}
```

---

## 6. Componentes de Protección

### 6.1 PermissionGate

**Archivo**: `src/components/PermissionGate.tsx`

Ver implementación completa en archivo adjunto (50 líneas).

**Props**:
```typescript
interface PermissionGateProps {
  permission: string;           // Capacidad requerida
  fallback?: React.ReactNode;   // Componente si no tiene permiso
  loading?: React.ReactNode;    // Componente mientras carga
  children: React.ReactNode;
}
```

**Uso básico**:
```typescript
import { PermissionGate } from '@/components/PermissionGate';

function App() {
  return (
    <PermissionGate permission="sistema.vistas.dashboards.ver">
      <Dashboard />
    </PermissionGate>
  );
}
```

**Uso con fallback**:
```typescript
<PermissionGate
  permission="sistema.administracion.usuarios.ver"
  fallback={<AccessDenied message="No tienes acceso a este módulo" />}
>
  <UserManagement />
</PermissionGate>
```

### 6.2 ProtectedRoute (React Router)

**Archivo**: `src/components/ProtectedRoute.tsx`

```typescript
import { Navigate } from 'react-router-dom';
import { usePermisos } from '@/hooks/usePermisos';

interface ProtectedRouteProps {
  permission: string;
  redirectTo?: string;
  children: React.ReactNode;
}

export function ProtectedRoute({
  permission,
  redirectTo = '/access-denied',
  children,
}: ProtectedRouteProps) {
  const { hasPermission, loading } = usePermisos();

  if (loading) {
    return <div>Verificando permisos...</div>;
  }

  if (!hasPermission(permission)) {
    return <Navigate to={redirectTo} replace />;
  }

  return <>{children}</>;
}
```

**Uso en rutas**:
```typescript
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { ProtectedRoute } from '@/components/ProtectedRoute';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/dashboard" element={
          <ProtectedRoute permission="sistema.vistas.dashboards.ver">
            <Dashboard />
          </ProtectedRoute>
        } />

        <Route path="/admin/users" element={
          <ProtectedRoute permission="sistema.administracion.usuarios.ver">
            <UserAdmin />
          </ProtectedRoute>
        } />
      </Routes>
    </BrowserRouter>
  );
}
```

---

## 7. Mejores Prácticas

### 7.1 Caché y Performance

**DO**:
```typescript
// Usar caché del cliente (5 min TTL por defecto)
const client = PermisosClient.getInstance();
const capacidades = await client.getCapacidades(userId);

// Refrescar solo cuando sea necesario
client.clearCache(); // Después de cambios de permisos
```

**DON'T**:
```typescript
// NO llamar API en cada render
function Component() {
  const [permisos, setPermisos] = useState([]);

  useEffect(() => {
    // MAL: Llama API cada vez que se monta
    fetch('/api/permisos/...').then(setPermisos);
  }, []); // Falta dependencia de userId
}
```

### 7.2 Seguridad

**IMPORTANTE**: La verificación client-side es solo para UX, NO es seguridad real.

```typescript
// [OK] CORRECTO: Backend SIEMPRE verifica
function deleteUser(userId: number) {
  // Frontend oculta botón si no tiene permiso (UX)
  if (!hasPermission('sistema.administracion.usuarios.eliminar')) {
    return; // No muestra botón
  }

  // Backend SIEMPRE verifica permiso (SEGURIDAD)
  // El endpoint /api/usuarios/:id/ valida permisos antes de eliminar
  await api.delete(`/api/usuarios/${userId}/`);
}
```

**Nunca confíes solo en client-side**:
- Un usuario malicioso puede manipular localStorage
- Puede modificar código JavaScript
- Puede hacer requests directos a API

### 7.3 Manejo de Errores

```typescript
import { PermisosError } from '@/types/permisos.types';

try {
  const capacidades = await client.getCapacidades(userId);
} catch (error) {
  if (error instanceof PermisosError) {
    if (error.statusCode === 401) {
      // Token expirado, redirect a login
      redirectToLogin();
    } else if (error.statusCode === 403) {
      // Sin permisos
      showAccessDeniedMessage();
    } else if (error.statusCode === 404) {
      // Usuario no encontrado
      showErrorMessage('Usuario no encontrado');
    }
  } else {
    // Error de red u otro
    showErrorMessage('Error al cargar permisos');
  }
}
```

### 7.4 Testing

**Mockear el cliente**:
```typescript
// __mocks__/permisos-client.ts
export const PermisosClient = {
  getInstance: jest.fn(() => ({
    getCapacidades: jest.fn().mockResolvedValue({
      usuario_id: 1,
      capacidades: ['sistema.vistas.dashboards.ver'],
      total: 1,
    }),
    tienePermiso: jest.fn().mockResolvedValue({
      tiene_permiso: true,
    }),
  })),
};
```

**Test de componente**:
```typescript
import { render, screen } from '@testing-library/react';
import { PermissionGate } from '@/components/PermissionGate';

jest.mock('@/hooks/usePermisos', () => ({
  usePermisos: () => ({
    hasPermission: jest.fn((perm) => perm === 'sistema.vistas.dashboards.ver'),
    loading: false,
  }),
}));

test('muestra contenido si tiene permiso', () => {
  render(
    <PermissionGate permission="sistema.vistas.dashboards.ver">
      <div>Contenido protegido</div>
    </PermissionGate>
  );

  expect(screen.getByText('Contenido protegido')).toBeInTheDocument();
});

test('oculta contenido si no tiene permiso', () => {
  render(
    <PermissionGate permission="sistema.admin.delete">
      <div>Contenido protegido</div>
    </PermissionGate>
  );

  expect(screen.queryByText('Contenido protegido')).not.toBeInTheDocument();
});
```

---

## 8. Endpoints API Disponibles

### 8.1 Verificación de Permisos

#### GET /api/permisos/verificar/:userId/capacidades/

**Descripción**: Obtiene todas las capacidades del usuario

**Response**:
```json
{
  "usuario_id": 123,
  "capacidades": [
    "sistema.vistas.dashboards.ver",
    "sistema.vistas.metricas.ver",
    "sistema.operaciones.llamadas.ver"
  ],
  "total": 3
}
```

**Performance**: < 10ms (p95) - Usa función SQL optimizada

#### GET /api/permisos/verificar/:userId/tiene-permiso/?capacidad=X

**Descripción**: Verifica si usuario tiene capacidad específica

**Query Params**:
- `capacidad` (required): Código de capacidad

**Response**:
```json
{
  "usuario_id": 123,
  "capacidad_codigo": "sistema.vistas.dashboards.ver",
  "tiene_permiso": true
}
```

**Performance**: < 5ms (p95) - Usa función SQL nativa

#### GET /api/permisos/verificar/:userId/menu/

**Descripción**: Genera menú dinámico basado en permisos

**Response**:
```json
{
  "usuario_id": 123,
  "menu": {
    "vistas": {
      "dashboards": [
        "sistema.vistas.dashboards.ver",
        "sistema.vistas.dashboards.exportar"
      ],
      "metricas": [
        "sistema.vistas.metricas.ver"
      ]
    },
    "administracion": {
      "usuarios": [
        "sistema.administracion.usuarios.ver",
        "sistema.administracion.usuarios.crear"
      ]
    }
  }
}
```

**Performance**: < 40ms (p95)

#### GET /api/permisos/verificar/:userId/grupos/

**Descripción**: Obtiene grupos activos del usuario

**Response**:
```json
{
  "usuario_id": 123,
  "grupos": [
    {
      "grupo_id": 5,
      "grupo_codigo": "operadores",
      "grupo_nombre": "Operadores",
      "tipo_acceso": "operativo",
      "vigente": true,
      "fecha_asignacion": "2025-01-15T10:00:00Z",
      "fecha_expiracion": null
    }
  ],
  "total": 1
}
```

### 8.2 Autenticación

Todos los endpoints requieren JWT Bearer Token:

```http
GET /api/permisos/verificar/123/capacidades/
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Obtener token** (ver documentación de autenticación):
```http
POST /api/auth/login/
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response**:
```json
{
  "access": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 123,
    "email": "user@example.com"
  }
}
```

### 8.3 Códigos de Error

| Código | Significado | Acción |
|--------|-------------|--------|
| 200 | OK | Procesar respuesta |
| 400 | Bad Request | Verificar query params |
| 401 | Unauthorized | Redirect a login, refresh token |
| 403 | Forbidden | Mostrar acceso denegado |
| 404 | Not Found | Usuario no existe |
| 500 | Server Error | Mostrar error genérico, reportar |

---

## 9. Ejemplos Completos

### 9.1 Dashboard Protegido

```typescript
// pages/Dashboard.tsx
import { PermissionGate } from '@/components/PermissionGate';
import { useMenu } from '@/hooks/usePermisos';

export function DashboardPage() {
  const { menu, loading } = useMenu();

  return (
    <PermissionGate
      permission="sistema.vistas.dashboards.ver"
      fallback={<AccessDenied />}
      loading={<DashboardSkeleton />}
    >
      <div className="dashboard">
        <h1>Dashboard</h1>

        {/* Widgets visibles solo con permiso */}
        <PermissionGate permission="sistema.vistas.metricas.ver">
          <MetricsWidget />
        </PermissionGate>

        <PermissionGate permission="sistema.vistas.graficas.ver">
          <ChartsWidget />
        </PermissionGate>
      </div>
    </PermissionGate>
  );
}
```

### 9.2 Menú Dinámico

```typescript
// components/Navbar.tsx
import { useMenu } from '@/hooks/usePermisos';

export function Navbar() {
  const { menu, loading } = useMenu();

  if (loading) return <NavbarSkeleton />;

  return (
    <nav className="navbar">
      {Object.entries(menu).map(([dominio, funciones]) => (
        <Dropdown key={dominio} title={dominio}>
          {Object.entries(funciones).map(([funcion, capacidades]) => (
            <DropdownItem
              key={funcion}
              to={`/${dominio}/${funcion}`}
              icon={getIconForFunction(funcion)}
            >
              {funcion}
              <Badge>{capacidades.length}</Badge>
            </DropdownItem>
          ))}
        </Dropdown>
      ))}
    </nav>
  );
}
```

### 9.3 Botones Condicionales

```typescript
// components/UserActions.tsx
import { usePermisos } from '@/hooks/usePermisos';

interface UserActionsProps {
  user: User;
}

export function UserActions({ user }: UserActionsProps) {
  const { hasPermission } = usePermisos();

  return (
    <div className="actions">
      {hasPermission('sistema.administracion.usuarios.editar') && (
        <Button onClick={() => editUser(user.id)}>
          Editar
        </Button>
      )}

      {hasPermission('sistema.administracion.usuarios.eliminar') && (
        <Button variant="danger" onClick={() => deleteUser(user.id)}>
          Eliminar
        </Button>
      )}

      {hasPermission('sistema.administracion.usuarios.suspender') && (
        <Button variant="warning" onClick={() => suspendUser(user.id)}>
          Suspender
        </Button>
      )}
    </div>
  );
}
```

### 9.4 Form con Validación de Permisos

```typescript
// pages/CreateUser.tsx
import { usePermisos } from '@/hooks/usePermisos';
import { useNavigate } from 'react-router-dom';

export function CreateUserPage() {
  const { hasPermission } = usePermisos();
  const navigate = useNavigate();

  // Redirect si no tiene permiso
  useEffect(() => {
    if (!hasPermission('sistema.administracion.usuarios.crear')) {
      navigate('/access-denied');
    }
  }, [hasPermission, navigate]);

  const handleSubmit = async (data: UserFormData) => {
    try {
      // Backend valida permiso de nuevo (seguridad)
      await api.post('/api/usuarios/', data);
      showSuccess('Usuario creado');
      navigate('/admin/users');
    } catch (error) {
      if (error.response?.status === 403) {
        showError('No tienes permisos para crear usuarios');
      }
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      {/* Form fields */}
    </form>
  );
}
```

---

## 10. Troubleshooting

### Problema: "Capacidades no se cargan"

**Síntomas**: `capacidades` array vacío, `loading` permanece en true

**Solución**:
1. Verificar que el token JWT es válido
2. Verificar que el usuario tiene grupos asignados en backend
3. Limpiar caché: `PermisosClient.getInstance().clearCache()`
4. Verificar logs de red en DevTools

### Problema: "Usuario tiene permiso en backend pero no en frontend"

**Causa**: Caché desactualizado

**Solución**:
```typescript
// Forzar refresh después de cambios de permisos
const { refreshPermissions } = usePermisos();
await refreshPermissions();
```

### Problema: "Error 401 Unauthorized"

**Causa**: Token JWT expirado

**Solución**:
```typescript
// Implementar refresh token automático
axios.interceptors.response.use(
  (response) => response,
  async (error) => {
    if (error.response?.status === 401) {
      const refreshToken = localStorage.getItem('refresh_token');
      const newToken = await refreshAuthToken(refreshToken);
      localStorage.setItem('auth_token', newToken);
      // Retry original request
      return axios.request(error.config);
    }
    return Promise.reject(error);
  }
);
```

### Problema: "Performance lenta"

**Diagnóstico**:
```typescript
console.time('getCapacidades');
await client.getCapacidades(userId);
console.timeEnd('getCapacidades');
```

**Optimizaciones**:
- Verificar que el caché está activo
- Aumentar TTL si es apropiado
- Usar `menu` para navegación en lugar de múltiples `tienePermiso()`
- Backend: Verificar que funciones SQL están siendo usadas (no ORM)

---

## 11. Migración desde Sistema Anterior

Si tienes un sistema de permisos anterior:

### Paso 1: Mapeo de Permisos

Crear archivo de mapeo:
```typescript
// utils/permission-mapping.ts
const PERMISSION_MAPPING = {
  // Antiguo -> Nuevo
  'view_dashboard': 'sistema.vistas.dashboards.ver',
  'create_user': 'sistema.administracion.usuarios.crear',
  'delete_user': 'sistema.administracion.usuarios.eliminar',
};

export function mapLegacyPermission(old: string): string {
  return PERMISSION_MAPPING[old] || old;
}
```

### Paso 2: Adaptar Componentes

```typescript
// Antes
if (user.permissions.includes('view_dashboard')) { ... }

// Después
const permission = mapLegacyPermission('view_dashboard');
if (hasPermission(permission)) { ... }
```

### Paso 3: Migración Gradual

1. Semana 1: Implementar cliente y hooks (sin romper código existente)
2. Semana 2: Migrar componentes críticos
3. Semana 3: Migrar resto de componentes
4. Semana 4: Eliminar código legacy

---

## 12. Referencias

### Documentación Backend
- [Sistema de Permisos Granular](../backend/arquitectura/permisos-granular.md)
- [ADR_2025_010: Estrategia Híbrida ORM + SQL](../adr/ADR_2025_010-orm-sql-hybrid-permissions.md)
- [GAP Analysis](../analisis/GAP_ANALYSIS_SISTEMA_PERMISOS.md)

### Código de Implementación
- Cliente TypeScript: `ui/src/lib/permisos-client.ts`
- Hooks React: `ui/src/hooks/usePermisos.ts`
- PermissionGate: `ui/src/components/PermissionGate.tsx`
- Types: `ui/src/types/permisos.types.ts`

### API Endpoints
- OpenAPI Spec: (pendiente) `docs/api/openapi_permisos.yaml`
- Postman Collection: (pendiente) `docs/api/permisos.postman_collection.json`

---

## 13. Changelog

### v1.0.0 (2025-11-09)
- Documentación inicial completa
- Cliente TypeScript con caché
- Hooks de React (usePermisos, useMenu)
- Componente PermissionGate
- Ejemplos completos
- Guía de troubleshooting

---

**Estado**: PRODUCCIÓN READY
**Última actualización**: 2025-11-09
**Owner**: equipo-frontend
**Revisores**: equipo-backend, tech-lead

**IMPORTANTE**: Esta documentación desbloquea al equipo frontend. Implementar INMEDIATAMENTE los archivos de código adjuntos.
