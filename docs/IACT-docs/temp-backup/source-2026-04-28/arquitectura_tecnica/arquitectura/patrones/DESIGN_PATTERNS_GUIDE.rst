Catálogo Simplificado de Patrones de Diseño
===========================================

Este documento resume los patrones de diseño clásicos desde una
perspectiva práctica. El objetivo es ofrecer una explicación clara, con
ejemplos y advertencias de uso, para que cualquier integrante del equipo
pueda escoger el patrón adecuado sin sobrecargar el diseño.

   **Nota de precaución:** los patrones resuelven problemas recurrentes,
   pero usarlos donde no corresponde introduce complejidad innecesaria.
   Evalúa siempre si el problema realmente requiere un patrón.

Panorama general
----------------

+--------------------+---------------------+--------------------------+
| Patrones           | Patrones            | Patrones de              |
| creacionales       | estructurales       | comportamiento           |
+====================+=====================+==========================+
| Simple Factory     | Adapter             | Chain of Responsibility  |
+--------------------+---------------------+--------------------------+
| Factory Method     | Bridge              | Command                  |
+--------------------+---------------------+--------------------------+
| Abstract Factory   | Composite           | Iterator                 |
+--------------------+---------------------+--------------------------+
| Builder            | Decorator           | Mediator                 |
+--------------------+---------------------+--------------------------+
| Prototype          | Facade              | Memento                  |
+--------------------+---------------------+--------------------------+
| Singleton          | Flyweight           | Observer                 |
+--------------------+---------------------+--------------------------+
|                    | Proxy               | Visitor                  |
+--------------------+---------------------+--------------------------+
|                    |                     | Strategy                 |
+--------------------+---------------------+--------------------------+
|                    |                     | State                    |
+--------------------+---------------------+--------------------------+
|                    |                     | Template Method          |
+--------------------+---------------------+--------------------------+

Introducción
------------

Un patrón de diseño es una solución reusable para un problema común
dentro de un contexto específico. No es una librería ni un fragmento de
código listo para copiar: describe la estructura y el flujo de
responsabilidades que han demostrado funcionar en escenarios concretos.
Comprender el contexto y las consecuencias es clave para aplicarlos
correctamente.

Clasificación principal
-----------------------

1. **Creacionales:** se enfocan en cómo crear instancias, encapsulando
   la lógica de construcción de objetos.
2. **Estructurales:** se ocupan de cómo componer objetos y clases para
   formar estructuras flexibles.
3. **Comportamiento:** definen cómo colaboran los objetos para
   distribuir responsabilidades y flujo de mensajes.

A continuación se describe cada patrón siguiendo el mismo formato:
definición, ejemplo real y ejemplo programático (utilizando PHP 7 para
mantener la coherencia con el material original).

--------------

Patrones creacionales
---------------------

Simple Factory
~~~~~~~~~~~~~~

-  **Idea:** centralizar la creación de un objeto para ocultar la lógica
   de instanciación al consumidor.
-  **Ejemplo cotidiano:** encargas puertas a un carpintero en lugar de
   fabricarlas tú mismo.

.. code:: php

   interface Door {
       public function getWidth(): float;
       public function getHeight(): float;
   }

   class WoodenDoor implements Door {
       public function __construct(private float $width, private float $height) {}
       public function getWidth(): float { return $this->width; }
       public function getHeight(): float { return $this->height; }
   }

   class DoorFactory {
       public static function makeDoor(float $width, float $height): Door {
           return new WoodenDoor($width, $height);
       }
   }

**Cuándo usarlo:** cuando crear el objeto implica pasos adicionales
(validaciones, dependencias) y no quieres duplicar la lógica en cada
punto del código.

Factory Method
~~~~~~~~~~~~~~

-  **Idea:** delegar a las subclases la decisión de qué objeto concreto
   instanciar.
-  **Ejemplo:** un gerente de contratación selecciona entrevistadores
   distintos según el puesto.

.. code:: php

   interface Interviewer { public function askQuestions(): void; }

   class Developer implements Interviewer {
       public function askQuestions(): void { echo 'Asking about design patterns!'; }
   }

   abstract class HiringManager {
       abstract protected function makeInterviewer(): Interviewer;
       public function takeInterview(): void {
           $this->makeInterviewer()->askQuestions();
       }
   }

**Cuándo usarlo:** cuando existe procesamiento genérico, pero el subtipo
concreto debe decidirse en tiempo de ejecución.

Abstract Factory
~~~~~~~~~~~~~~~~

-  **Idea:** agrupar familias de objetos relacionados (producto +
   colaborador) sin exponer las clases concretas.
-  **Ejemplo:** una fábrica de puertas entrega también al especialista
   que las instala.

.. code:: php

   interface DoorFactory {
       public function makeDoor(): Door;
       public function makeFittingExpert(): DoorFittingExpert;
   }

**Cuándo usarlo:** cuando las dependencias entre objetos requieren
instancias coordinadas.

Builder
~~~~~~~

-  **Idea:** construir objetos complejos paso a paso, evitando
   constructores con demasiados argumentos.
-  **Ejemplo:** personalizar un sándwich en una cadena de comida rápida.

.. code:: php

   class Burger {
       public function __construct(private BurgerBuilder $builder) {}
   }

   class BurgerBuilder {
       public function __construct(public int $size) {}
       public bool $cheese = false;
       public bool $pepperoni = false;
       public bool $lettuce = false;
       public bool $tomato = false;
       public function addCheese(): self { $this->cheese = true; return $this; }
       public function build(): Burger { return new Burger($this); }
   }

**Cuándo usarlo:** cuando la creación tiene múltiples pasos opcionales o
combinaciones extensas.

Prototype
~~~~~~~~~

-  **Idea:** clonar objetos existentes para reutilizar su configuración
   base.
-  **Ejemplo:** clonar la oveja Dolly para obtener una copia idéntica.

.. code:: php

   class Sheep {
       public function __construct(private string $name, private string $category = 'Mountain Sheep') {}
       public function setName(string $name): void { $this->name = $name; }
   }

   $original = new Sheep('Jolly');
   $cloned = clone $original;
   $cloned->setName('Dolly');

**Cuándo usarlo:** cuando la creación desde cero es costosa y necesitas
variaciones mínimas.

Singleton
~~~~~~~~~

-  **Idea:** garantizar que solo existe una instancia de una clase.
-  **Ejemplo:** en un país solo hay un presidente en funciones.

.. code:: php

   final class President {
       private static ?self $instance = null;
       private function __construct() {}
       public static function getInstance(): self {
           if (self::$instance === null) { self::$instance = new self(); }
           return self::$instance;
       }
       private function __clone() {}
       private function __wakeup() {}
   }

**Cuándo usarlo:** rara vez. Introduce estado global difícil de testear;
úsalo solo si la restricción de instancia única es imprescindible.

--------------

Patrones estructurales
----------------------

Adapter
~~~~~~~

-  **Idea:** envolver un objeto incompatible para que exponga la
   interfaz que otro componente espera.
-  **Ejemplo:** un lector de tarjetas permite conectar memorias SD a un
   puerto USB.

.. code:: php

   interface Lion { public function roar(): void; }
   class WildDog { public function bark(): void {} }
   class WildDogAdapter implements Lion {
       public function __construct(private WildDog $dog) {}
       public function roar(): void { $this->dog->bark(); }
   }

Bridge
~~~~~~

-  **Idea:** separar una abstracción de su implementación para que ambas
   evolucionen de forma independiente.
-  **Ejemplo:** un sitio web con múltiples temas reutiliza la misma
   lógica de páginas.

.. code:: php

   interface Theme { public function getColor(): string; }
   interface WebPage { public function __construct(Theme $theme); public function getContent(): string; }

Composite
~~~~~~~~~

-  **Idea:** tratar objetos individuales y composiciones de manera
   uniforme.
-  **Ejemplo:** una organización agrupa empleados que pueden tener
   subordinados.

.. code:: php

   interface Employee { public function getSalary(): float; }
   class Organization {
       /** @var Employee[] */
       private array $employees = [];
       public function addEmployee(Employee $employee): void { $this->employees[] = $employee; }
       public function getNetSalaries(): float { return array_sum(array_map(fn ($e) => $e->getSalary(), $this->employees)); }
   }

Decorator
~~~~~~~~~

-  **Idea:** añadir responsabilidades a un objeto de forma dinámica
   envolviéndolo en otro objeto.
-  **Ejemplo:** una cafetería suma ingredientes opcionales al precio
   base.

.. code:: php

   interface Coffee { public function getCost(): int; public function getDescription(): string; }
   class MilkCoffee implements Coffee {
       public function __construct(private Coffee $coffee) {}
       public function getCost(): int { return $this->coffee->getCost() + 2; }
       public function getDescription(): string { return $this->coffee->getDescription() . ', milk'; }
   }

Facade
~~~~~~

-  **Idea:** exponer una interfaz simplificada para un subsistema
   complejo.
-  **Ejemplo:** el botón de encendido encapsula todo el proceso de
   arranque del computador.

.. code:: php

   class ComputerFacade {
       public function __construct(private Computer $computer) {}
       public function turnOn(): void {
           $this->computer->getElectricShock();
           $this->computer->makeSound();
           $this->computer->showLoadingScreen();
           $this->computer->bam();
       }
   }

Flyweight
~~~~~~~~~

-  **Idea:** compartir objetos pesados para ahorrar memoria cuando se
   necesitan múltiples instancias similares.
-  **Ejemplo:** una tienda de té reutiliza el mismo preparado para
   varias órdenes.

.. code:: php

   class TeaMaker {
       /** @var array<string, KarakTea> */
       private array $availableTea = [];
       public function make(string $preference): KarakTea {
           if (!isset($this->availableTea[$preference])) {
               $this->availableTea[$preference] = new KarakTea();
           }
           return $this->availableTea[$preference];
       }
   }

Proxy
~~~~~

-  **Idea:** interponer un objeto que controle el acceso a otro,
   añadiendo lógica extra (autenticación, caché, etc.).
-  **Ejemplo:** una puerta con control de acceso requiere credenciales
   antes de abrirse.

.. code:: php

   class SecuredDoor implements Door {
       public function __construct(private Door $door) {}
       public function open(string $password): void {
           if ($this->authenticate($password)) { $this->door->open(); }
           else { echo 'Access denied'; }
       }
       private function authenticate(string $password): bool { return $password === '$ecr@t'; }
       public function close(): void { $this->door->close(); }
   }

--------------

Patrones de comportamiento
--------------------------

Chain of Responsibility
~~~~~~~~~~~~~~~~~~~~~~~

-  **Idea:** pasar una solicitud por una cadena de manejadores hasta que
   alguno pueda atenderla.
-  **Ejemplo:** cuentas bancarias con distintos saldos intentan pagar
   una compra siguiendo un orden.

.. code:: php

   abstract class Account {
       protected ?Account $successor = null;
       public function setNext(Account $account): void { $this->successor = $account; }
       public function pay(float $amount): void {
           if ($this->canPay($amount)) { echo "Paid {$amount} using " . static::class; }
           elseif ($this->successor) { $this->successor->pay($amount); }
           else { throw new Exception('Insufficient funds'); }
       }
       abstract protected function canPay(float $amount): bool;
   }

Command
~~~~~~~

-  **Idea:** encapsular una acción y sus parámetros en un objeto para
   ejecutar, deshacer o encolar operaciones.
-  **Ejemplo:** un control remoto ejecuta comandos sobre una lámpara.

.. code:: php

   interface Command { public function execute(): void; public function undo(): void; }
   class TurnOn implements Command {
       public function __construct(private Bulb $bulb) {}
       public function execute(): void { $this->bulb->turnOn(); }
       public function undo(): void { $this->bulb->turnOff(); }
   }

Iterator
~~~~~~~~

-  **Idea:** proporcionar una forma estándar de recorrer una colección
   sin exponer su representación interna.
-  **Ejemplo:** cambiar de estación en un radio usando los botones
   siguiente/anterior.

.. code:: php

   class StationList implements Countable, Iterator {
       /** @var RadioStation[] */
       private array $stations = [];
       private int $counter = 0;
       public function addStation(RadioStation $station): void { $this->stations[] = $station; }
       public function current(): RadioStation { return $this->stations[$this->counter]; }
       public function next(): void { ++$this->counter; }
       public function rewind(): void { $this->counter = 0; }
       public function valid(): bool { return isset($this->stations[$this->counter]); }
       public function count(): int { return count($this->stations); }
   }

Mediator
~~~~~~~~

-  **Idea:** centralizar la comunicación entre objetos para reducir el
   acoplamiento directo.
-  **Ejemplo:** una sala de chat distribuye mensajes entre usuarios.

.. code:: php

   interface ChatRoomMediator { public function showMessage(User $user, string $message): void; }
   class ChatRoom implements ChatRoomMediator {
       public function showMessage(User $user, string $message): void {
           $time = date('M d, y H:i');
           echo "$time [{$user->getName()}]: {$message}";
       }
   }

Memento
~~~~~~~

-  **Idea:** capturar y restaurar el estado interno de un objeto sin
   violar su encapsulamiento.
-  **Ejemplo:** un editor de texto guarda versiones para permitir
   deshacer.

.. code:: php

   class Editor {
       private string $content = '';
       public function type(string $words): void { $this->content .= ' ' . $words; }
       public function save(): EditorMemento { return new EditorMemento($this->content); }
       public function restore(EditorMemento $memento): void { $this->content = $memento->getContent(); }
   }

Observer
~~~~~~~~

-  **Idea:** notificar automáticamente a múltiples dependientes cuando
   cambia el estado de un sujeto.
-  **Ejemplo:** buscadores de empleo reciben avisos cuando se publica un
   puesto.

.. code:: php

   class EmploymentAgency {
       /** @var Observer[] */
       private array $observers = [];
       public function attach(Observer $observer): void { $this->observers[] = $observer; }
       public function addJob(JobPost $job): void {
           foreach ($this->observers as $observer) { $observer->onJobPosted($job); }
       }
   }

Visitor
~~~~~~~

-  **Idea:** separar algoritmos de los objetos sobre los que operan,
   permitiendo añadir comportamientos sin modificarlos.
-  **Ejemplo:** agregar acciones como “hablar” o “saltar” a animales del
   zoológico.

.. code:: php

   interface AnimalOperation {
       public function visitMonkey(Monkey $monkey): void;
       public function visitLion(Lion $lion): void;
       public function visitDolphin(Dolphin $dolphin): void;
   }

Strategy
~~~~~~~~

-  **Idea:** definir una familia de algoritmos intercambiables en tiempo
   de ejecución.
-  **Ejemplo:** elegir entre bubble sort y quick sort según el tamaño
   del dataset.

.. code:: php

   interface SortStrategy { public function sort(array $dataset): array; }
   class Sorter {
       public function __construct(private SortStrategy $small, private SortStrategy $big) {}
       public function sort(array $dataset): array {
           return count($dataset) > 5 ? $this->big->sort($dataset) : $this->small->sort($dataset);
       }
   }

State
~~~~~

-  **Idea:** modificar el comportamiento de un objeto cuando su estado
   interno cambia.
-  **Ejemplo:** un teléfono maneja acciones distintas según esté
   marcando, colgado o descolgado.

.. code:: php

   interface PhoneState {
       public function pickUp(): PhoneState;
       public function hangUp(): PhoneState;
       public function dial(): PhoneState;
   }

Template Method
~~~~~~~~~~~~~~~

-  **Idea:** definir el esqueleto de un algoritmo dejando que las
   subclases implementen pasos específicos.
-  **Ejemplo:** un pipeline de compilación que siempre ejecuta test,
   lint, build y deploy, pero cada plataforma define los detalles.

.. code:: php

   abstract class Builder {
       final public function build(): void {
           $this->test();
           $this->lint();
           $this->assemble();
           $this->deploy();
       }
       abstract protected function test(): void;
       abstract protected function lint(): void;
       abstract protected function assemble(): void;
       abstract protected function deploy(): void;
   }

--------------

Consejos finales
----------------

1. **Identifica el olor de diseño** antes de aplicar un patrón. Si la
   implementación actual funciona y es legible, no la reemplaces solo
   por usar un patrón.
2. **Documenta la decisión.** Registra por qué el patrón elegido es la
   mejor respuesta para el contexto.
3. **Mantén las pruebas al día.** Los patrones suelen introducir más
   colaboración entre clases; asegúrate de cubrir los flujos críticos
   con tests.
4. **Revisa periódicamente.** Algunos patrones pueden quedarse obsoletos
   si cambian los requisitos o aparecen simplificaciones.

Con este catálogo, el equipo dispone de una referencia única para
seleccionar patrones de diseño de forma consciente y alineada con la
arquitectura del proyecto.
