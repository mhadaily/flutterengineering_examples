import 'dart:io';
import 'dart:async';

Future<void> main(List<String> arguments) async {
  String hook = arguments.isNotEmpty ? arguments[0] : 'commit';

  if (hook == 'commit') {
    await _runFlutterFormat();
    await _runFlutterAnalyze();
  } else if (hook == 'push') {
    await _runFlutterTest();
  } else if (hook == 'CI') {
    await _runFlutterFormat();
    await _runFlutterAnalyze();
    await _runFlutterTest();
  }
}

Future<void> _runFlutterFormat() async {
  print('Running Flutter Format...');
  await _executeCommand('flutter', ['format', '.']);
}

Future<void> _runFlutterAnalyze() async {
  print('Running Flutter Analyze...');
  await _executeCommand('flutter', ['analyze']);
}

Future<void> _runFlutterTest() async {
  print('Running Flutter Tests...');
  await _executeCommand('flutter', ['test']);
}

Future<void> _executeCommand(String executable, List<String> arguments) async {
  var result = await Process.run(executable, arguments);
  if (result.exitCode != 0) {
    print(result.stdout);
    exit(result.exitCode);
  }
}
