class User {
  String _name; // private property

  User(this._name);

  String get name => _name; // getter for name

  set name(String value) {
    // setter for name
    if (value.isNotEmpty) {
      _name = value;
    }
  }
}

class Singleton {
  Singleton._(); // Private constructor

  static final Singleton instance = Singleton._();

  factory Singleton() => instance;
}
