import 'dart:async';
import 'dart:io';
import 'dart:isolate';

class ComputationModel {
  final int iterations;
  final int factor;

  ComputationModel(this.iterations, this.factor);
}

int computeSum(ComputationModel model) {
  int sum = 0;
  for (int i = 1; i <= model.iterations; i++) {
    sum += i * model.factor;
  }
  return sum;
}

void workerTask(SendPort mainSendPort) async {
  ReceivePort workerReceivePort = ReceivePort();
  mainSendPort.send(workerReceivePort.sendPort);

  await for (final message in workerReceivePort) {
    if (message is ComputationModel) {
      mainSendPort.send(computeSum(message));
    }
  }
}

void main() async {
  ReceivePort mainReceivePort = ReceivePort();
  ReceivePort onExitPort = ReceivePort();

  final isolate = await Isolate.spawn(
    workerTask,
    mainReceivePort.sendPort,
    onExit: onExitPort.sendPort,
  );

  final completer = Completer<SendPort>();

  mainReceivePort.listen(
    (message) {
      if (message is SendPort) completer.complete(message);
      if (message is int) print(message);
    },
  );

  SendPort workerSendPort = await completer.future;

  workerSendPort.send(ComputationModel(10000, 5));

  onExitPort.listen((message) {
    exit(0);
  });

  await Future<void>.delayed(const Duration(seconds: 4));

  mainReceivePort.close();
  isolate.kill(priority: Isolate.immediate);
}
