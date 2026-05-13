# Frontend React — Guidelines

Reglas siempre activas para el proyecto thyrox. Aplicar en toda implementación React.

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
