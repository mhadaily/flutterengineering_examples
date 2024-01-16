import 'dart:async';
import 'dart:io';
import 'dart:isolate';

// heavy computation
int sum(int end) {
  int sum = 0;
  for (int i = 1; i <= end; i++) {
    sum += i * 5;
  }
  return sum;
}

main() async {
  final isolateController = await IsolateController.create<int, int>(sum);
  isolateController
    ..add(1000)
    ..add(200)
    ..add(500)
    ..ping()
    ..onData.listen(print)
    ..onError.listen((e) {
      print(e);
      exit(1);
    })
    ..onExit.listen((e) {
      print(e);
      exit(0);
    });

  Future.delayed(const Duration(seconds: 2), () {
    isolateController.pause();
  });

  Future.delayed(const Duration(seconds: 3), () {
    isolateController.ping();
  });

  Future.delayed(const Duration(seconds: 4), () {
    isolateController.resume();
  });

  Future.delayed(const Duration(seconds: 5), () {
    isolateController.ping();
  });

  Future.delayed(const Duration(seconds: 6), () {
    isolateController.add(100);
  });

  Future.delayed(const Duration(seconds: 7), () {
    isolateController.dispose();
  });
}

typedef WorkerHandler<O, P> = O Function(P);

class CreateWorker<O, P> {
  CreateWorker(this.handler, this.sp);

  final WorkerHandler<O, P> handler;
  final SendPort sp;

  void call(SendPort _) {
    final rp = ReceivePort();
    sp.send(rp.sendPort);
    rp.takeWhile((msg) => msg is P).cast<P>().map(handler).listen(sp.send);
  }
}

class IsolateController<O, P> {
  final ReceivePort mainReceiverPort;
  final ReceivePort onExitRp;
  final ReceivePort onErrorRp;
  final SendPort mainSendPort;
  final Isolate isolate;
  final Stream<dynamic> broadcastRp;
  final SendPort communicatorSendPort;

  late Capability? _resumeCap;

  IsolateController._({
    required this.mainReceiverPort,
    required this.onExitRp,
    required this.onErrorRp,
    required this.broadcastRp,
    required this.mainSendPort,
    required this.isolate,
    required this.communicatorSendPort,
  });

  static Future<IsolateController<O, P>> create<O, P>(
    WorkerHandler<O, P> handler,
  ) async {
    final mainReceiverPort = ReceivePort();
    final onExitRp = ReceivePort();
    final onErrorRp = ReceivePort();
    final mainRpSendPort = mainReceiverPort.sendPort;
    final communicator = CreateWorker(handler, mainRpSendPort);

    final isolate = await Isolate.spawn(
      communicator,
      mainRpSendPort,
      debugName: 'IsolateController',
      onExit: onExitRp.sendPort,
      onError: onErrorRp.sendPort,
    );

    final broadcastRp = mainReceiverPort.asBroadcastStream();
    final SendPort communicatorSendPort = await broadcastRp.first;

    return IsolateController._(
      isolate: isolate,
      onErrorRp: onErrorRp,
      onExitRp: onExitRp,
      mainReceiverPort: mainReceiverPort,
      mainSendPort: mainRpSendPort,
      broadcastRp: broadcastRp,
      communicatorSendPort: communicatorSendPort,
    );
  }

  void add(P payload) => communicatorSendPort.send(payload);

  void dispose() {
    mainReceiverPort.close();
    isolate.kill(priority: Isolate.immediate);
  }

  void pause() {
    _resumeCap = isolate.pause(isolate.pauseCapability);
  }

  void resume() {
    if (_resumeCap == null) return;
    isolate.resume(_resumeCap!);
    ping();
  }

  void ping() {
    final onPongMessage = ReceivePort();
    isolate.ping(
      onPongMessage.sendPort,
      response: 'pong',
      priority: Isolate.immediate,
    );
    onPongMessage
        .takeWhile((e) => e is String && e == 'pong')
        .take(1)
        .cast<String>()
        .first
        .then(stdout.writeln);
  }

  Stream get onExit => onExitRp.asBroadcastStream();
  Stream get onError => onErrorRp.asBroadcastStream();

  Stream<P> get onData => broadcastRp
      .takeWhile(
        (element) => element is P,
      )
      .cast<P>();
}
