import 'dart:io';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print('Please provide a screen name.');
    return;
  }

  String screenName = arguments[0];
  createMVVMScreen(screenName);
}

void createMVVMScreen(String screenName) {
  String screenDirectory = 'lib/screens/$screenName';
  Directory(screenDirectory).createSync(recursive: true);

  // Create View File
  String viewFileName = '${screenName}_view.dart';
  File('$screenDirectory/$viewFileName')
      .writeAsStringSync('import \'package:flutter/material.dart\';\n\n'
          'class ${capitalize(screenName)}View extends StatelessWidget {\n'
          '  @override\n'
          '  Widget build(BuildContext context) {\n'
          '    return Container(); // TODO: Implement view\n'
          '  }\n'
          '}\n');

  // Create ViewModel File
  String viewModelFileName = '${screenName}_view_model.dart';
  File('$screenDirectory/$viewModelFileName')
      .writeAsStringSync('class ${capitalize(screenName)}ViewModel {\n'
          '  // TODO: Implement view model\n'
          '}\n');

  // Create Model or Service File
  String modelFileName = '${screenName}_service.dart';
  File('$screenDirectory/$modelFileName')
      .writeAsStringSync('class ${capitalize(screenName)}Service {\n'
          '  // TODO: Implement service or model\n'
          '}\n');

  print('MVVM screen structure created for $screenName.');
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
