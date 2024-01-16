import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

// Dart representation of Todo exposed to external layers
@collection
@JsonSerializable()
class Todo {
  @JsonKey(includeFromJson: false)
  Id get localId => fastHash(id);

  @JsonKey(name: 'id')
  final String id;

  @Index(type: IndexType.value)
  final String title;

  Todo({
    required this.id,
    required this.title,
  });
}

/// FNV-1a 64bit hash algorithm optimized for Dart Strings
int fastHash(String string) {
  var hash = 0xcbf29ce484222325;

  var i = 0;
  while (i < string.length) {
    final codeUnit = string.codeUnitAt(i++);
    hash ^= codeUnit >> 8;
    hash *= 0x100000001b3;
    hash ^= codeUnit & 0xFF;
    hash *= 0x100000001b3;
  }

  return hash;
}
