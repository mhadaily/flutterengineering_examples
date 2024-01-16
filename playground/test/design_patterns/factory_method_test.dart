import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playground/design_patterns/factory_method.dart';

void main() {
  test('IOSWidgetFactory should create a CupertinoButton', () {
    PlatformWidgetFactory factory = IOSWidgetFactory();
    var widget = factory.createWidget();

    expect(widget, isA<CupertinoButton>());
  });

  test('AndroidWidgetFactory should create an ElevatedButton', () {
    PlatformWidgetFactory factory = AndroidWidgetFactory();
    var widget = factory.createWidget();

    expect(widget, isA<ElevatedButton>());
  });

  test('WebWidgetFactory should create a TextButton', () {
    PlatformWidgetFactory factory = WebWidgetFactory();
    var widget = factory.createWidget();

    expect(widget, isA<TextButton>());
  });
}
