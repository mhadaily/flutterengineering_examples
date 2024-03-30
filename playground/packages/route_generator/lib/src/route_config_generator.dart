import 'dart:async';

import 'package:build/build.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:route_annotations/route_annotations.dart';
import 'package:source_gen/source_gen.dart';

class RouteConfigGenerator
    extends GeneratorForAnnotation<RouteConfig> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    // Only generate code for classes
    if (element is! ClassElement) return '';

    // Extract the name and path from the annotation
    // annotation is a ConstantReader object
    // a ConstantReader object is a wrapper for
    // analyzer's [DartObject] with a predictable high-level API.
    // peek() returns the value of the field with the given name
    final name = annotation.peek('name')!.stringValue;
    final path = annotation.peek('path')!.stringValue;

    return '''
class GeneratedRouter {
  static const String ${element.name}RouteName = '$name';
  static const String ${element.name}Path = '$path';
}
''';
  }
}
