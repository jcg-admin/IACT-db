<!-- SKILL_START -->
```yml
name: frontend-react
description: "Skill de tecnología para proyectos React. Usar cuando se trabaje en componentes, hooks, estado, routing, o testing de frontend React en el proyecto {{PROJECT_NAME}}. Invocar durante Phase 4 STRUCTURE para especificar requisitos de UI, durante Phase 6 EXECUTE para implementar componentes, y durante Phase 7 TRACK para revisar calidad del código React."
layer: frontend
framework: react
project: {{PROJECT_NAME}}
```

# {{LAYER_TITLE}} {{FRAMEWORK_TITLE}} — SKILL

Guía fase-por-fase para implementar en React dentro del proyecto {{PROJECT_NAME}}.

---

## Phase 1: ANALYZE — Qué investigar en proyectos React

Al analizar un feature de frontend, cubrir:
- Árbol de componentes afectados — ¿cuáles existen, cuáles hay que crear?
- Gestión de estado — ¿local (useState), contexto (useContext), o global (zustand/redux)?
- Rutas involucradas — ¿qué páginas/layouts se modifican?
- Dependencias de API — ¿qué endpoints consume este feature?
- Requisitos de accesibilidad — ¿ARIA labels, navegación por teclado?

## Phase 4: STRUCTURE — Qué especificar para features React

En `requirements-spec.md`, incluir por cada componente:
- Props: nombre, tipo, si es requerido, valor default
- Estado interno: variables de estado con su tipo
- Eventos: qué dispara el componente hacia arriba (callbacks)
- Criterio visual: descripción del comportamiento esperado en UI

## Phase 6: EXECUTE — Convenciones de implementación

Ver sección INSTRUCTIONS para reglas específicas.

Orden de implementación recomendado:
1. Tipos/interfaces primero (si usa TypeScript)
2. Componente base sin lógica
3. Hooks y lógica de negocio
4. Conexión a estado/API
5. Tests unitarios
6. Integración en página/layout

## Phase 7: TRACK — Qué revisar al cerrar

- Todos los componentes nuevos tienen tests con React Testing Library
- No hay `console.log` ni código comentado
- Props tienen PropTypes o tipos TypeScript
- Componentes > 200 líneas considerados para split
- No hay imports no usados (`eslint no-unused-vars`)
<!-- SKILL_END -->

<!-- INSTRUCTIONS_START -->
# {{LAYER_TITLE}} {{FRAMEWORK_TITLE}} — Guidelines

Reglas siempre activas para el proyecto {{PROJECT_NAME}}. Aplicar en toda implementación React.

---

## Regla 1: Naming de componentes — PascalCase obligatorio

Los componentes React usan PascalCase. Los archivos llevan el mismo nombre.

```jsx
// CORRECTO
export function UserProfile({ userId }) { ... }
// archivo: UserProfile.jsx

// INCORRECTO
export function userProfile({ userId }) { ... }
export function user_profile({ userId }) { ... }
// archivo: userprofile.jsx
```

## Regla 2: Organización por feature, no por tipo

Los archivos se agrupan por feature/dominio, no por tipo técnico.

```
// CORRECTO
src/features/auth/
  LoginForm.jsx
  LoginForm.test.jsx
  useAuth.js
  authSlice.js

// INCORRECTO
src/components/LoginForm.jsx
src/hooks/useAuth.js
src/store/authSlice.js
src/tests/LoginForm.test.jsx
```

## Regla 3: useState local antes de estado global

Usar el estado más local posible. Escalar solo cuando sea necesario.

```jsx
// CORRECTO — estado local para UI efímera
function Dropdown() {
  const [isOpen, setIsOpen] = useState(false);
  ...
}

// INCORRECTO — no poner estado de UI en store global
dispatch(setDropdownOpen(true)); // evitar para estado local
```

## Regla 4: Testing con React Testing Library — comportamiento, no implementación

Los tests verifican lo que el usuario ve y hace, no los detalles internos.

```jsx
// CORRECTO — testea comportamiento
test('muestra error cuando el email es inválido', () => {
  render(<LoginForm />);
  fireEvent.change(screen.getByLabelText('Email'), { target: { value: 'no-es-email' } });
  fireEvent.click(screen.getByRole('button', { name: 'Ingresar' }));
  expect(screen.getByText('Email inválido')).toBeInTheDocument();
});

// INCORRECTO — testea implementación interna
test('llama setError con mensaje correcto', () => {
  const { result } = renderHook(() => useLoginForm());
  act(() => result.current.setEmail('no-es-email'));
  expect(result.current.error).toBe('Email inválido');
});
```

## Regla 5: Sin estilos inline — usar clases CSS o CSS-in-JS consistente

```jsx
// CORRECTO
<button className="btn btn-primary">Guardar</button>

// CORRECTO (si el proyecto usa styled-components o Tailwind)
<Button variant="primary">Guardar</Button>
<button className="px-4 py-2 bg-blue-500 text-white rounded">Guardar</button>

// INCORRECTO
<button style={{ padding: '8px 16px', backgroundColor: '#3b82f6', color: 'white' }}>
  Guardar
</button>
```

## Regla 6: Custom hooks para lógica reutilizable

Extraer lógica de componentes a hooks cuando se repite en 2+ lugares o supera 20 líneas.

```jsx
// CORRECTO — lógica extraída a hook
function useUserData(userId) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  useEffect(() => { fetchUser(userId).then(setUser).finally(() => setLoading(false)); }, [userId]);
  return { user, loading };
}

// INCORRECTO — lógica duplicada en componentes
function UserCard({ userId }) {
  const [user, setUser] = useState(null);
  useEffect(() => { fetchUser(userId).then(setUser); }, [userId]);
  ...
}
```
<!-- INSTRUCTIONS_END -->
