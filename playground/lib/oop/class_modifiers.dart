// Can be constructed, Can be extended but Can be implemented be be used as mixin
class Testing {
  log() {}
}

abstract class Drawable {
  void draw() {}
  void paint();
}

class Circle extends Drawable {
  @override
  void paint() {
    // Implementation of paint method
  }
}

// Cannot be constructed, Can be extended and Can be implemented
abstract class Vehicle {
  void moveForward(int meters) {
    print('meters $meters');
  }
}

class Car extends Vehicle {}

// Cannot be constructed, Cannot be extended but Can be implemented
interface class People {
  void moveForward(int meters) {}
}

// Cannot be constructed, Cannot be extended but Can be implemented - Pure interface
abstract interface class Person {
  void moveForward(int meters);
}

// Can be constructed, Can be extended but Cannot be implemented
base class Animal {
  void moveForward(int meters) {
    // ...
  }
}

// Can be constructed, Cannot be extended but Cannot be implemented
final class Customer {}

// Cannot be constructed, Can be extended but Can be implemented and it's exhaustive
sealed class Product {}
// Product product = Product();

class Perfume extends Product {}

class Jewelry implements Product {}

// Subclasses can be instantiated
Perfume perfume = Perfume();
Jewelry jewelry = Jewelry();

// Cannot be constructed, Cannot be extended but Cannot be implemented
// can be used with mixin
mixin Flyable {
  void fly() {}
}

class Airplane with Flyable {}

final Airplane airplane = Airplane();

main() {
  final car = Car();
  car.moveForward(10);
  airplane.fly();
}
