.. meta::
 :artefacto: LLD-dark-mode
 :tipo: Diseño Bajo Nivel
 :dominio: base-cognitiva
 :subdominio: ejemplos-pedagogicos
 :saga: dark-mode
 :fase_sdlc: diseno
 :skill_aplicada: bpa-design
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==================================
LLD: Diseño Bajo Nivel — Dark Mode
==================================

.. note::

 **Ejemplo pedagógico (saga dark-mode).** Aplica ``bpa-design``
 con detalle de implementación. Deriva de :doc:`hld-dark-mode`.

1. ThemeProvider (React Context)
================================

.. code-block:: jsx

 const ThemeContext = React.createContext({
   theme: 'light',
   setTheme: () => {},
 });

 export function ThemeProvider({ children }) {
   const [theme, setThemeState] = useState('light');

   useEffect(() => {
     fetch('/api/preferences/theme')
       .then(r => r.json())
       .then(({theme}) => setThemeState(theme));
   }, []);

   const setTheme = useCallback((newTheme) => {
     setThemeState(newTheme);
     document.documentElement.dataset.theme = newTheme;
     fetch('/api/preferences/theme', {
       method: 'POST',
       body: JSON.stringify({ theme: newTheme }),
     });
   }, []);

   return (
     <ThemeContext.Provider value={{ theme, setTheme }}>
       {children}
     </ThemeContext.Provider>
   );
 }

2. ThemeToggle component
========================

.. code-block:: jsx

 export function ThemeToggle() {
   const { theme, setTheme } = useContext(ThemeContext);
   const next = theme === 'light' ? 'dark' : 'light';

   return (
     <button
       onClick={() => setTheme(next)}
       aria-label={`Cambiar a modo ${next}`}
     >
       {theme === 'light' ? '🌙' : '☀️'}
     </button>
   );
 }

3. CSS variables
================

.. code-block:: css

 :root[data-theme="light"] {
   --bg: #ffffff;
   --fg: #1a1a1a;
   --accent: #0066cc;
 }

 :root[data-theme="dark"] {
   --bg: #1a1a1a;
   --fg: #f5f5f5;
   --accent: #4d9fff;
 }

 body {
   background: var(--bg);
   color: var(--fg);
   transition: background 0.2s, color 0.2s;
 }

4. Backend endpoint
===================

.. code-block:: javascript

 // GET /api/preferences/theme
 router.get('/theme', async (req, res) => {
   const userId = req.user.id;
   const result = await db.query(
     'SELECT theme_preference FROM user_preferences WHERE user_id = $1',
     [userId]
   );
   const theme = result.rows[0]?.theme_preference || 'light';
   res.json({ theme });
 });

 // POST /api/preferences/theme
 router.post('/theme', async (req, res) => {
   const userId = req.user.id;
   const { theme } = req.body;
   if (!['light', 'dark'].includes(theme)) {
     return res.status(400).json({ error: 'Invalid theme' });
   }
   await db.query(
     `INSERT INTO user_preferences (user_id, theme_preference)
      VALUES ($1, $2)
      ON CONFLICT (user_id) DO UPDATE
      SET theme_preference = $2, updated_at = NOW()`,
     [userId, theme]
   );
   res.json({ ok: true });
 });

5. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Saga**
   - dark-mode (:doc:`index`)
 * - **Skill aplicada**
   - ``bpa-design``
 * - **Fase SDLC**
   - Diseño
 * - **HLD backing**
   - :doc:`hld-dark-mode`
 * - **Documento siguiente**
   - :doc:`db-user-preferences`
