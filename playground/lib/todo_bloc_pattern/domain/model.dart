// Model (entity) class
import '../data/data_model.dart';
import 'sanitize.dart';

class Todo extends TodoDataModel {
  Todo({
    required super.id,
    required super.title,
    super.isCompleted,
    // create url from title a domain logic
    required this.slug,
  });

  final String slug;

  // business logic here for the domain
  factory Todo.fromDataModel(TodoDataModel dataModel) {
    return Todo(
      id: dataModel.id,
      // you can manipulate the data from data layer here
      // before it is passed to the presentation layer
      title: ValidatorUseCases.text(dataModel.title),
      slug: ValidatorUseCases.slugify(dataModel.title),
      isCompleted: dataModel.isCompleted,
    );
  }

  toDataModel() {
    return TodoDataModel(
      id: id,
      title: title,
      isCompleted: isCompleted,
    );
  }
}
