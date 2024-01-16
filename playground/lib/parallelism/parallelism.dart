import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// Function to parse JSON. This will be run in a background isolate.
List<dynamic> parseJson(String jsonString) {
  return json.decode(jsonString);
}

class LargeJsonParserWidget extends StatefulWidget {
  const LargeJsonParserWidget({super.key});

  @override
  LargeJsonParserWidgetState createState() => LargeJsonParserWidgetState();
}

class LargeJsonParserWidgetState extends State<LargeJsonParserWidget> {
  bool isLoading = false;
  List<String> jsonData = [];

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  // Function to load and parse JSON
  Future<void> loadJsonData() async {
    setState(() => isLoading = true);

    // Simulate loading a large JSON string
    final jsonString =
        await loadJsonString(); // Assume this function fetches the JSON string

    // Use compute to parse JSON in the background
    final parsedJson = await compute(parseJson, jsonString);

    setState(() {
      jsonData = parsedJson.cast<String>();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Large JSON Parser'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: jsonData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(jsonData[index]),
                );
              },
            ),
    );
  }

  // Imagine, this loads a very large JSON string from the internet
  Future<String> loadJsonString() async {
    return '["John Smith", "Majid Hajian"]';
  }
}

// Long lived isolate
class ComputationModel {
  final int iterations;
  final int factor;

  ComputationModel(this.iterations, this.factor);
}

void computeSum(ComputationModel model) {
  int sum = 0;
  for (int i = 1; i <= model.iterations; i++) {
    sum += i * model.factor;
  }
  debugPrint('Computed Sum: $sum');
}

void workerTask(SendPort mainSendPort) async {
  ReceivePort workerReceivePort = ReceivePort();
  mainSendPort.send(workerReceivePort.sendPort);

  await for (var message in workerReceivePort) {
    if (message is List) {
      String mainMessage = message[0];
      debugPrint(mainMessage);

      SendPort replyPort = message[1];
      replyPort.send('Hello from Worker');
    }
  }
}

createIsolate() async {
  Isolate.spawn<ComputationModel>(computeSum, ComputationModel(10000, 5));

  ReceivePort mainReceivePort = ReceivePort();
  await Isolate.spawn(workerTask, mainReceivePort.sendPort);

  SendPort workerSendPort = await mainReceivePort.first;
  ReceivePort responsePort = ReceivePort();

  workerSendPort.send(['Hello from Main', responsePort.sendPort]);

  final response = await responsePort.first;
  debugPrint('Response from Worker: $response');
}

main() async {
  createIsolate();

  runApp(
    const MaterialApp(
      home: LargeJsonParserWidget(),
    ),
  );
}