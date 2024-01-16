import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:playground/offline/data/model/todo.dart';

abstract interface class TodoDatabase {
  Future<List<Todo>> getAll();
  Future<Todo?> get(String id);
  Future<void> write(Todo newTodo);
  Future<void> writeAll(List<Todo> newTodos);
}

class IsarDb implements TodoDatabase {
  static final IsarDb instance = IsarDb._();

  factory IsarDb() => instance;

  IsarDb._() {
    openDB();
  }

  openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [TodoSchema],
      directory: dir.path,
    );
  }

  late final Isar _isar;

  @override
  Future<Todo?> get(String id) {
    return _isar.todos.where().localIdEqualTo(fastHash(id)).findFirst();
  }

  @override
  Future<List<Todo>> getAll() {
    // some query to get todos from the database
    return _isar.todos.where().findAll();
  }

  @override
  Future<void> writeAll(List<Todo> newTodos) {
    return _isar.writeTxn(() async {
      await _isar.todos.putAll(newTodos);
    });
  }

  @override
  Future<void> write(Todo newTodo) {
    return _isar.writeTxn(() async {
      await _isar.todos.put(newTodo);
    });
  }
}

class InMemoryDB implements TodoDatabase {
  static final InMemoryDB _instance = InMemoryDB._internal();

  factory InMemoryDB() => _instance;

  InMemoryDB._internal();

  final Map<String, Todo> _cache = {};

  get listOfTodos => _cache.values.toList();

  @override
  Future<Todo?> get(String id) async {
    return _cache[id];
  }

  @override
  Future<List<Todo>> getAll() async {
    // some query to get todos from the database
    return listOfTodos;
  }

  @override
  Future<void> writeAll(List<Todo> newTodos) async {
    // some query to save todos to the database
    for (final todo in newTodos) {
      _cache[todo.id] = todo;
    }
  }

  @override
  Future<void> write(Todo newTodo) async {
    _cache[newTodo.id] = newTodo;
  }
}
