---
id: TASK-REORG-BACK-048
tipo: tarea
categoria: metodologias
titulo: Crear TDD-metodologia.md
fase: FASE_3
prioridad: MEDIA
duracion_estimada: 30min
estado: pendiente
dependencias: []
metodologia: Auto-CoT, Self-Consistency
---

# TASK-REORG-BACK-048: Crear TDD-metodologia.md

**Fase:** FASE 3 - Metodologias y Mejores Practicas
**Prioridad:** MEDIA
**Duracion Estimada:** 30 minutos
**Responsable:** Tech Lead / QA Lead
**Estado:** PENDIENTE
**Metodologia:** Auto-CoT (Auto-Chain of Thought), Self-Consistency

---

## Objetivo

Crear guia completa de Test-Driven Development (TDD) especifica para el backend, incluyendo ciclo Red-Green-Refactor, ejemplos practicos, mejores practicas, y como integrar TDD en el workflow diario del equipo.

---

## Auto-CoT: Razonamiento en Cadena

### Paso 1: ¿Por que TDD es importante para backend?
**Pregunta:** ¿Que problemas resuelve TDD en desarrollo backend?
**Razonamiento:**
- **Confianza:** Tests primero → codigo testeable por diseño → alta coverage → confianza en deploys
- **Diseño:** TDD fuerza a pensar en interfaces antes que implementacion → mejor diseño
- **Regresiones:** Tests automatizados → detectan regresiones inmediatamente
- **Documentacion:** Tests son documentacion ejecutable del comportamiento esperado
- **Refactoring:** Alta coverage → refactoring seguro

### Paso 2: ¿Cuales son los principios clave de TDD?
**Pregunta:** ¿Que hace que TDD sea efectivo?
**Razonamiento:**
- **Red-Green-Refactor:** Ciclo de 3 pasos que se repite
- **Baby Steps:** Cambios pequeños e incrementales
- **Tests First:** Escribir test ANTES de codigo
- **Simple Design:** Solo escribir codigo necesario para pasar tests
- **Refactoring Continuo:** Mejorar diseño sin cambiar comportamiento

### Paso 3: Validar con Self-Consistency
**Perspectiva 1 - Desarrollador Junior:** "¿Es TDD demasiado lento?" → NO, a largo plazo es mas rapido (menos bugs, menos debugging)
**Perspectiva 2 - Desarrollador Senior:** "¿TDD funciona para codigo legacy?" → SI, con strategic testing (test around the edges)
**Perspectiva 3 - Tech Lead:** "¿Como medimos adopcion de TDD?" → % de PRs con tests-first, coverage trends
**Perspectiva 4 - QA:** "¿TDD reemplaza QA testing?" → NO, complementa (TDD → unit tests, QA → integration/e2e)
**Consenso:** TDD es efectivo para backend, requiere training y practica

---

## Prerequisitos

- [ ] Conocimiento basico de testing (unit, integration, e2e)
- [ ] Framework de testing configurado (Jest, Vitest, Pytest, etc.)
- [ ] Ejemplos de codigo backend del proyecto
- [ ] Revision de literatura TDD (Kent Beck, Martin Fowler)

---

## Pasos de Ejecucion

### Paso 1: Investigar Mejores Practicas TDD
```bash
# Buscar recursos de referencia
# - "Test Driven Development: By Example" - Kent Beck
# - "Growing Object-Oriented Software, Guided by Tests" - Freeman & Pryce
# - Martin Fowler's blog on TDD
# - Uncle Bob's TDD videos

# Buscar ejemplos en el proyecto actual
find /home/user/IACT -name "*.test.ts" -o -name "*.spec.ts" -o -name "*_test.py"
```

**Resultado Esperado:** Lista de recursos y ejemplos actuales

### Paso 2: Crear Archivo TDD-metodologia.md
```bash
mkdir -p /home/user/IACT/docs/backend/metodologias

touch /home/user/IACT/docs/backend/metodologias/TDD-metodologia.md
```

Contenido del documento:

```markdown
---
id: METODOLOGIA-TDD-BACKEND
tipo: metodologia
categoria: testing
titulo: Test-Driven Development (TDD) para Backend
version: 1.0.0
fecha_creacion: 2025-11-18
autores: [Tech Lead, QA Lead]
---

# Test-Driven Development (TDD) - Metodologia Backend

**Version:** 1.0.0
**Ultima actualizacion:** 2025-11-18
**Nivel:** Intermedio - Avanzado

---

## ¿Que es TDD?

**Test-Driven Development (TDD)** es una practica de desarrollo de software donde escribes **tests ANTES de escribir el codigo de produccion**, siguiendo el ciclo **Red-Green-Refactor**.

### Filosofia
> "Escribe solo codigo necesario para pasar un test fallido"
> - Kent Beck

### Beneficios
- [OK] **Alta cobertura:** Tests escritos para cada feature
- [OK] **Mejor diseño:** Codigo testeable por construccion
- [OK] **Confianza:** Refactorizar sin miedo a romper funcionalidad
- [OK] **Documentacion:** Tests describen comportamiento esperado
- [OK] **Menos bugs:** Problemas detectados temprano

### Anti-Beneficios (Mitos)
- [ERROR] "TDD es lento" → Falso a largo plazo (menos debugging)
- [ERROR] "TDD no funciona para UI" → Falso (usar mocks/stubs)
- [ERROR] "100% coverage = 0 bugs" → Falso (coverage no es calidad)

---

## Ciclo Red-Green-Refactor

### 1⃣ RED: Escribir Test Fallido
```typescript
// user.service.spec.ts
describe('UserService', () => {
 it('should create user with valid data', async () => {
 const userData = { email: 'test@example.com', name: 'Test User' };
 const user = await userService.create(userData);

 expect(user).toBeDefined();
 expect(user.email).toBe('test@example.com');
 expect(user.id).toBeDefined();
 });
});
```
**Estado:** [ERROR] Test falla (UserService.create no existe)

### 2⃣ GREEN: Escribir Codigo Minimo para Pasar
```typescript
// user.service.ts
class UserService {
 async create(userData: { email: string; name: string }) {
 return {
 id: '123', // Hardcoded (minimo para pasar)
 ...userData
 };
 }
}
```
**Estado:** [OK] Test pasa

### 3⃣ REFACTOR: Mejorar Diseño Sin Cambiar Comportamiento
```typescript
// user.service.ts (refactored)
class UserService {
 constructor(private userRepository: UserRepository) {}

 async create(userData: CreateUserDto): Promise<User> {
 const user = new User(userData);
 return await this.userRepository.save(user);
 }
}
```
**Estado:** [OK] Tests siguen pasando, diseño mejorado

### 4⃣ REPETIR
Escribir siguiente test → Red → Green → Refactor → ...

---

## Reglas del TDD

### Las 3 Leyes de TDD (Uncle Bob)

1. **No escribas codigo de produccion** hasta tener un test unitario fallido
2. **No escribas mas de un test unitario** de lo suficiente para fallar (no compilar es fallar)
3. **No escribas mas codigo de produccion** de lo necesario para pasar el test actual

### Reglas Adicionales para Backend

4. **Test en aislamiento:** Cada test debe ser independiente
5. **Mocks para dependencias externas:** DB, APIs, filesystem
6. **Tests rapidos:** Unit tests < 100ms, total suite < 5 min
7. **Nombres descriptivos:** Test debe explicar QUE verifica

---

## TDD para Backend: Patrones Comunes

### Patron 1: Testing de Servicios (Logica de Negocio)

**Escenario:** Servicio que procesa pagos

```typescript
// payment.service.spec.ts
describe('PaymentService', () => {
 let service: PaymentService;
 let mockPaymentGateway: jest.Mocked<PaymentGateway>;
 let mockOrderRepository: jest.Mocked<OrderRepository>;

 beforeEach(() => {
 mockPaymentGateway = createMock<PaymentGateway>();
 mockOrderRepository = createMock<OrderRepository>();
 service = new PaymentService(mockPaymentGateway, mockOrderRepository);
 });

 describe('processPayment', () => {
 it('should charge payment gateway and update order status', async () => {
 // ARRANGE
 const order = { id: '123', total: 100, status: 'pending' };
 mockPaymentGateway.charge.mockResolvedValue({ success: true, transactionId: 'tx-456' });
 mockOrderRepository.findById.mockResolvedValue(order);

 // ACT
 const result = await service.processPayment('123');

 // ASSERT
 expect(mockPaymentGateway.charge).toHaveBeenCalledWith({ amount: 100, orderId: '123' });
 expect(mockOrderRepository.updateStatus).toHaveBeenCalledWith('123', 'paid');
 expect(result.success).toBe(true);
 });

 it('should not update order if payment fails', async () => {
 // ARRANGE
 const order = { id: '123', total: 100, status: 'pending' };
 mockPaymentGateway.charge.mockResolvedValue({ success: false, error: 'Insufficient funds' });
 mockOrderRepository.findById.mockResolvedValue(order);

 // ACT
 const result = await service.processPayment('123');

 // ASSERT
 expect(mockOrderRepository.updateStatus).not.toHaveBeenCalled();
 expect(result.success).toBe(false);
 expect(result.error).toBe('Insufficient funds');
 });
 });
});
```

**Implementacion (minima para pasar tests):**
```typescript
// payment.service.ts
class PaymentService {
 constructor(
 private paymentGateway: PaymentGateway,
 private orderRepository: OrderRepository
 ) {}

 async processPayment(orderId: string) {
 const order = await this.orderRepository.findById(orderId);
 const paymentResult = await this.paymentGateway.charge({
 amount: order.total,
 orderId: order.id
 });

 if (paymentResult.success) {
 await this.orderRepository.updateStatus(orderId, 'paid');
 return { success: true, transactionId: paymentResult.transactionId };
 }

 return { success: false, error: paymentResult.error };
 }
}
```

---

### Patron 2: Testing de Controllers/Handlers (API Endpoints)

**Escenario:** Endpoint REST para crear usuario

```typescript
// user.controller.spec.ts
describe('UserController', () => {
 let controller: UserController;
 let mockUserService: jest.Mocked<UserService>;

 beforeEach(() => {
 mockUserService = createMock<UserService>();
 controller = new UserController(mockUserService);
 });

 describe('POST /users', () => {
 it('should return 201 and created user', async () => {
 // ARRANGE
 const createUserDto = { email: 'test@example.com', name: 'Test' };
 const createdUser = { id: '123', ...createUserDto };
 mockUserService.create.mockResolvedValue(createdUser);

 const req = { body: createUserDto };
 const res = { status: jest.fn().mockReturnThis(), json: jest.fn() };

 // ACT
 await controller.createUser(req, res);

 // ASSERT
 expect(res.status).toHaveBeenCalledWith(201);
 expect(res.json).toHaveBeenCalledWith(createdUser);
 expect(mockUserService.create).toHaveBeenCalledWith(createUserDto);
 });

 it('should return 400 if email is invalid', async () => {
 // ARRANGE
 const invalidDto = { email: 'invalid-email', name: 'Test' };
 const req = { body: invalidDto };
 const res = { status: jest.fn().mockReturnThis(), json: jest.fn() };

 // ACT
 await controller.createUser(req, res);

 // ASSERT
 expect(res.status).toHaveBeenCalledWith(400);
 expect(res.json).toHaveBeenCalledWith({ error: 'Invalid email' });
 expect(mockUserService.create).not.toHaveBeenCalled();
 });
 });
});
```

---

### Patron 3: Testing de Repositorios (Acceso a Datos)

**Escenario:** Repository que accede a DB

```typescript
// user.repository.spec.ts (integration test)
describe('UserRepository', () => {
 let repository: UserRepository;
 let testDb: Database;

 beforeEach(async () => {
 testDb = await setupTestDatabase(); // In-memory DB o test container
 repository = new UserRepository(testDb);
 });

 afterEach(async () => {
 await testDb.cleanup();
 });

 it('should save user to database', async () => {
 // ARRANGE
 const userData = { email: 'test@example.com', name: 'Test User' };

 // ACT
 const savedUser = await repository.save(userData);

 // ASSERT
 expect(savedUser.id).toBeDefined();

 const foundUser = await repository.findById(savedUser.id);
 expect(foundUser.email).toBe('test@example.com');
 });

 it('should throw error if email already exists', async () => {
 // ARRANGE
 await repository.save({ email: 'test@example.com', name: 'User 1' });

 // ACT & ASSERT
 await expect(
 repository.save({ email: 'test@example.com', name: 'User 2' })
 ).rejects.toThrow('Email already exists');
 });
});
```

---

## Estrategias de Testing Backend

### Piramide de Testing

```
 /\
 /E2E\ (Pocos, lentos, alto valor)
 /------\
 / API \ (Moderados, medios, integracion)
 /--------\
 / UNIT \ (Muchos, rapidos, bajo nivel)
 /------------\
```

**Distribucion Recomendada:**
- **70% Unit Tests:** Servicios, utilidades, helpers
- **20% Integration Tests:** API endpoints, repositorios con DB
- **10% E2E Tests:** User journeys criticos

### Test Doubles

| Tipo | Cuando Usar | Ejemplo |
|------|------------|---------|
| **Mock** | Verificar interacciones | `expect(mockService.method).toHaveBeenCalled()` |
| **Stub** | Simular respuestas | `stub.getUser.returns({ id: '123' })` |
| **Spy** | Observar sin cambiar comportamiento | `spy(realService.method)` |
| **Fake** | Implementacion simple (ej: in-memory DB) | `FakeUserRepository` |

---

## Mejores Practicas TDD Backend

### [OK] DO

1. **Escribir test primero** (siempre, incluso si es dificil)
2. **Tests pequeños y enfocados** (1 assert por test ideal)
3. **AAA Pattern:** Arrange → Act → Assert (estructura clara)
4. **Nombres descriptivos:** `should return 404 when user not found`
5. **Mocks para I/O:** DB, APIs externas, filesystem, time
6. **Fast tests:** Unit tests < 100ms, suite completo < 5min
7. **Tests independientes:** Cada test puede correr solo
8. **Refactor con tests verdes:** Solo refactorear cuando tests pasan

### [ERROR] DON'T

1. **Tests que dependen de orden de ejecucion**
2. **Tests que comparten estado** (usar beforeEach/afterEach)
3. **Hardcoded IDs, timestamps** (usar factories/fixtures)
4. **Tests que tocan DB real** en unit tests (usar mocks o test DB)
5. **Multiple assertions no relacionadas** en 1 test
6. **Ignorar tests fallidos** (arreglar o eliminar)
7. **Testing de implementacion** (test comportamiento, no detalles internos)

---

## Workflow TDD en el Dia a Dia

### Morning Routine
```bash
# 1. Pull latest changes
git pull origin develop

# 2. Run full test suite (asegurar baseline verde)
npm test

# 3. Pick task from sprint board
# Ejemplo: "Implementar feature: password reset"
```

### Development Loop
```bash
# 1. RED: Escribir test fallido
# Archivo: password-reset.service.spec.ts
# Test: "should send reset email when user exists"

# 2. Run test (debe fallar)
npm test -- password-reset.service.spec.ts

# 3. GREEN: Escribir codigo minimo
# Archivo: password-reset.service.ts
# Implementar solo lo necesario

# 4. Run test (debe pasar)
npm test -- password-reset.service.spec.ts

# 5. REFACTOR: Mejorar diseño
# Extraer metodos, mejorar nombres, etc.

# 6. Run test (debe seguir pasando)
npm test -- password-reset.service.spec.ts

# 7. REPETIR para siguiente caso
# Test: "should throw error when user not found"
```

### Before Commit
```bash
# 1. Run full suite
npm test

# 2. Check coverage
npm run test:coverage

# 3. Lint + format
npm run lint
npm run format

# 4. Commit con mensaje descriptivo
git commit -m "feat(auth): implement password reset with TDD

- Add PasswordResetService with tests
- Coverage: 95% on password-reset module
- Tests: 12 passing"
```

---

## TDD con Codigo Legacy

### Challenge
Codigo sin tests es dificil de testear (dependencies hardcoded, side effects, etc.)

### Estrategia: "Test Around the Edges"

1. **Characterization Tests:** Documentar comportamiento actual
```typescript
it('should behave as it currently does (characterization)', () => {
 const result = legacyFunction(input);
 expect(result).toBe(currentBehavior); // Capturar comportamiento actual
});
```

2. **Refactoring hacia Testabilidad:**
```typescript
// ANTES (no testeable)
class LegacyService {
 doSomething() {
 const db = new Database(); // Dependency hardcoded
 return db.query('SELECT * FROM users');
 }
}

// DESPUES (testeable)
class RefactoredService {
 constructor(private db: Database) {} // Dependency injection

 doSomething() {
 return this.db.query('SELECT * FROM users');
 }
}
```

3. **Baby Steps:** Refactorear pequeñas partes a la vez

---

## Metricas y KPIs de TDD

### Coverage
- **Target:** 80%+ para nuevo codigo
- **Tool:** Jest coverage, SonarQube
- **Command:** `npm run test:coverage`

**Interpretar Coverage:**
- **Statements:** % de lineas ejecutadas
- **Branches:** % de if/else ejecutados
- **Functions:** % de funciones ejecutadas
- **Lines:** % de lineas de codigo ejecutadas

### Test Quality Metrics
- **Mutation Score:** % de mutaciones detectadas (Stryker, PITest)
- **Test Duration:** Unit tests < 5min total
- **Flaky Tests:** Target: 0% (tests que fallan intermitentemente)

### Team Adoption
- **% PRs con tests:** Target: 100%
- **Test-first vs test-after:** Trackear via surveys
- **Bugs encontrados en produccion:** Deberia bajar con TDD

---

## Herramientas para TDD Backend

### Testing Frameworks
| Lenguaje | Framework | Uso |
|----------|-----------|-----|
| TypeScript/Node.js | Jest, Vitest | Unit, integration tests |
| Python | Pytest, unittest | Unit, integration tests |
| Go | testing package | Unit, integration tests |
| Java | JUnit, TestNG | Unit, integration tests |

### Mocking Libraries
- **JavaScript/TypeScript:** Jest mocks, Sinon.js
- **Python:** unittest.mock, pytest-mock
- **Go:** gomock, testify/mock

### Test Doubles & Fixtures
- **Factories:** factory_bot (Ruby), factory-girl (JS)
- **Fixtures:** fixtures.json, YAML files
- **Fake Data:** Faker.js, Bogus

### Coverage Tools
- **JavaScript:** Jest coverage, c8, nyc
- **Python:** Coverage.py
- **Go:** go test -cover
- **Multi-language:** SonarQube

---

## Casos de Uso Reales

### Caso 1: API REST para E-commerce

**Feature:** Agregar item al carrito

**RED: Test fallido**
```typescript
it('should add item to cart and return updated cart', async () => {
 const cart = await cartService.addItem('user-123', { productId: 'prod-456', quantity: 2 });
 expect(cart.items).toHaveLength(1);
 expect(cart.items[0].productId).toBe('prod-456');
 expect(cart.total).toBe(39.98); // 2 * $19.99
});
```

**GREEN: Implementacion minima**
```typescript
class CartService {
 async addItem(userId: string, item: { productId: string; quantity: number }) {
 const product = await this.productService.getById(item.productId);
 const cart = await this.cartRepository.findByUserId(userId);
 cart.items.push({ ...item, price: product.price });
 cart.total = this.calculateTotal(cart.items);
 return await this.cartRepository.save(cart);
 }
}
```

---

### Caso 2: Background Job Processor

**Feature:** Procesar notificaciones

**RED: Test fallido**
```typescript
it('should process pending notifications and mark as sent', async () => {
 const notifications = [
 { id: '1', status: 'pending', userId: 'user-1' },
 { id: '2', status: 'pending', userId: 'user-2' }
 ];
 await notificationProcessor.processBatch(notifications);

 expect(mockEmailService.send).toHaveBeenCalledTimes(2);
 expect(mockNotificationRepo.updateStatus).toHaveBeenCalledWith('1', 'sent');
 expect(mockNotificationRepo.updateStatus).toHaveBeenCalledWith('2', 'sent');
});
```

---

## Troubleshooting TDD

### Problema: "TDD es muy lento"
**Solucion:**
- Tests deben ser rapidos (< 100ms por unit test)
- Usar mocks para I/O (DB, APIs, filesystem)
- Paralelizar tests (`jest --maxWorkers=4`)

### Problema: "No se que testear"
**Solucion:**
- Empezar con happy path (caso de exito)
- Luego edge cases (validaciones, errores)
- Luego exceptional paths (exceptions, timeouts)

### Problema: "El test es mas complejo que el codigo"
**Solucion:**
- Señal de que diseño puede mejorar
- Simplificar codigo (extraer funciones, SRP)
- Usar test helpers/factories para reducir setup

---

## Referencias

### Libros
- **"Test Driven Development: By Example"** - Kent Beck (MUST READ)
- **"Growing Object-Oriented Software, Guided by Tests"** - Freeman & Pryce
- **"Working Effectively with Legacy Code"** - Michael Feathers
- **"The Art of Unit Testing"** - Roy Osherove

### Articulos y Blogs
- [Martin Fowler - Is TDD Dead?](https://martinfowler.com/articles/is-tdd-dead/)
- [Uncle Bob - The Three Laws of TDD](http://butunclebob.com/ArticleS.UncleBob.TheThreeRulesOfTdd)
- [Kent Beck - TDD FAQ](https://github.com/testdouble/contributing-tests/wiki/Test-Driven-Development)

### Videos
- [Uncle Bob - TDD Series](https://cleancoders.com/series/clean-code)
- [Martin Fowler - Refactoring](https://www.youtube.com/watch?v=vqEg37e4Mkw)

---

## Proximos Pasos

1. **Training:** Organizar sesion de "TDD Kata" con el equipo
2. **Piloto:** Implementar 1 feature usando TDD estricto
3. **Retrospectiva:** Evaluar experiencia, ajustar proceso
4. **Adopcion Gradual:** Requerir TDD para nuevo codigo
5. **Metricas:** Trackear coverage, bugs, tiempo de desarrollo

---

## Anexo: TDD Katas para Practicar

### Kata 1: FizzBuzz
**Reglas:**
- Si numero divisible por 3 → "Fizz"
- Si divisible por 5 → "Buzz"
- Si divisible por ambos → "FizzBuzz"
- Sino → numero como string

**Practica:** Implementar usando TDD puro

### Kata 2: String Calculator
**Reglas:**
- `add("")` → 0
- `add("1")` → 1
- `add("1,2")` → 3
- `add("1\n2,3")` → 6

**Practica:** Incrementar complejidad con cada test

---

**Documento creado:** 2025-11-18
**Ultima actualizacion:** 2025-11-18
**Version:** 1.0.0
```

**Resultado Esperado:** TDD-metodologia.md creado con guia completa

### Paso 3: Crear Ejemplos de Codigo
```bash
# Crear carpeta de ejemplos
mkdir -p /home/user/IACT/docs/backend/metodologias/ejemplos-tdd

# Crear ejemplos basicos
# - user-service.example.ts
# - payment-service.example.ts
# - etc.
```

**Resultado Esperado:** Ejemplos practicos de TDD

### Paso 4: Validar con Self-Consistency
```bash
# Perspectiva 1: Desarrollador Junior
# ¿La guia es facil de seguir?
# ¿Los ejemplos son claros?

# Perspectiva 2: Desarrollador Senior
# ¿La guia cubre casos avanzados?
# ¿Las mejores practicas son correctas?

# Perspectiva 3: QA
# ¿La guia clarifica diferencia entre TDD y QA testing?
# ¿Los ejemplos de tests son de calidad?

# Perspectiva 4: Tech Lead
# ¿La guia facilita adopcion en el equipo?
# ¿Incluye metricas para trackear adopcion?
```

**Resultado Esperado:** Guia validada desde 4 perspectivas

---

## Criterios de Exito

- [ ] Archivo TDD-metodologia.md creado en docs/backend/metodologias/
- [ ] Ciclo Red-Green-Refactor explicado con ejemplos
- [ ] 3 Leyes de TDD documentadas
- [ ] Patrones comunes: servicios, controllers, repositorios
- [ ] Piramide de testing explicada
- [ ] Mejores practicas (DO/DON'T) listadas
- [ ] Workflow TDD diario documentado
- [ ] Estrategia para codigo legacy
- [ ] Metricas y KPIs definidos
- [ ] Herramientas recomendadas por lenguaje
- [ ] 2+ casos de uso reales con codigo
- [ ] Troubleshooting de problemas comunes
- [ ] Referencias (libros, articulos, videos)
- [ ] TDD Katas para practicar
- [ ] Validacion con Self-Consistency desde 4 perspectivas completada

---

## Validacion

```bash
# Verificar archivo existe
ls -lh /home/user/IACT/docs/backend/metodologias/TDD-metodologia.md

# Verificar estructura
grep "^## " /home/user/IACT/docs/backend/metodologias/TDD-metodologia.md

# Contar ejemplos de codigo
grep -c "^```typescript" /home/user/IACT/docs/backend/metodologias/TDD-metodologia.md

# Verificar secciones clave
grep -E "(Red-Green-Refactor|3 Leyes|Mejores Practicas|Workflow)" /home/user/IACT/docs/backend/metodologias/TDD-metodologia.md
```

**Salida Esperada:** Archivo existe, estructura completa, multiples ejemplos de codigo

---

## Riesgos

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|-----------|
| Equipo no adopta TDD | ALTA | ALTO | Training, pair programming, TDD champions, requerir en DoD |
| Guia demasiado teorica | MEDIA | MEDIO | Incluir ejemplos practicos del proyecto, workshops hands-on |
| TDD percibido como lento | MEDIA | MEDIO | Mostrar ROI (menos bugs, menos debugging), quick wins |

---

## Notas

- TDD es una **practica que requiere disciplina** y mejora con el tiempo
- Usar Auto-CoT para razonar sobre beneficios y anti-patrones
- Validar con Self-Consistency: Junior, Senior, QA, Tech Lead
- La guia debe ser **practica y aplicable** al proyecto actual
- Incluir TDD Katas para que el equipo practique en safe environment
- Organizar **sesiones de mob programming con TDD** para aprender juntos

---

## Tiempo de Ejecucion

**Inicio:** __:__
**Fin:** __:__
**Duracion Real:** __ minutos

---

## Checklist de Finalizacion

- [ ] TDD-metodologia.md creado con guia completa
- [ ] Ciclo Red-Green-Refactor explicado
- [ ] 3 Leyes de TDD documentadas
- [ ] 3+ patrones de testing backend
- [ ] Piramide de testing incluida
- [ ] Mejores practicas DO/DON'T
- [ ] Workflow diario documentado
- [ ] Estrategia para legacy code
- [ ] Metricas y KPIs
- [ ] Herramientas por lenguaje
- [ ] 2+ casos de uso reales
- [ ] Troubleshooting
- [ ] Referencias completas
- [ ] TDD Katas incluidos
- [ ] Validacion Self-Consistency completada
- [ ] Tarea marcada como COMPLETADA en INDICE.md

---

**Tarea creada:** 2025-11-18
**Ultima actualizacion:** 2025-11-18
**Version:** 1.0.0
**Estado:** PENDIENTE
