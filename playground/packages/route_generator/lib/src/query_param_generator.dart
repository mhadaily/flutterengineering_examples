import 'dart:async';

import 'package:build/build.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:route_annotations/route_annotations.dart';
import 'package:source_gen/source_gen.dart';

class QueryParamGenerator
    extends GeneratorForAnnotation<QueryParam> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    // Only generate code for fields
    if (element is! FieldElement) {
      throw ArgumentError(
        '${element.name} is not a field. annotate a field with @QueryParam.',
      );
    }

    // Extract the key from the annotation
    // annotation is a ConstantReader object
    // a ConstantReader object is a wrapper for
    // analyzer's [DartObject] with a predictable high-level API.
    // peek() returns the value of the field with the given name
    // stringValue returns the value of the field as a string
    final key = annotation.peek('key')!.stringValue;
    // Extract the class name
    final className = element.enclosingElement.name;

    // Generate the extension method/property
    return '''
extension ${className}QueryParam on $className {
  Map<String, dynamic> get queryParams => {'$key': this.${element.name}};
}
''';
  }
}
