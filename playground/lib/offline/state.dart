import 'package:playground/offline/data/model/todo.dart';
import 'package:playground/offline/offline.dart';

class HomepageState {
  HomepageState(this.offlineService);

  final OfflineTodoRepository offlineService;

  Stream getTodos() {
    return offlineService.getTodos();
  }

  Future<void> addTodo(Todo todo) async {
    return offlineService.write(todo);
  }
}
