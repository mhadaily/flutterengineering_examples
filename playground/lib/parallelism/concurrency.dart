import 'dart:io';
import 'dart:typed_data';
import 'dart:async';

// Example of a function that performs image processing synchronously
Future<Uint8List> processImage(File imageFile) async {
  // Some asynchronous operation to load the image
  Uint8List imageData = await imageFile.readAsBytes();

  // Synchronous image processing (this part blocks the UI)
  Uint8List processedImageData = _synchronousImageProcessing(imageData);

  return processedImageData;
}

Uint8List _synchronousImageProcessing(Uint8List imageData) {
  // Imagine this function takes a long time to complete
  // ... image processing logic here ...
  return imageData; // Processed image data
}

singleStream() {
  final StreamController<int> controller = StreamController<int>();

  // Creating a single-subscription stream
  final Stream<int> stream = controller.stream;

  // Subscribing to the stream
  stream.listen(
    (number) => print('Received number: $number'),
    onDone: () => print('Stream is closed.'),
    onError: (error) => print('Error: $error'),
  );

  // Adding data to the stream
  for (int i = 0; i < 3; i++) {
    controller.sink.add(i);
  }

  // Closing the stream
  controller.close();
}

broadcastStream() {
  final StreamController<int> controller = StreamController<int>.broadcast();

  // Creating a broadcast stream
  final Stream<int> stream = controller.stream;

  // First subscriber
  stream.listen(
    (number) => print('First subscriber received: $number'),
  );

  // Second subscriber
  stream.listen(
    (number) => print('Second subscriber received: $number'),
  );

  // Adding data to the stream
  for (int i = 0; i < 3; i++) {
    controller.sink.add(i);
  }

  // Closing the stream
  controller.close();
}

void main() {
  singleStream();
  broadcastStream();
}
