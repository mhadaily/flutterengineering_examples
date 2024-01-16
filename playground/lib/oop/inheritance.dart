// Dart basic inheritance
import 'package:flutter/material.dart';

class People {
  final String name;

  const People(this.name);

  String showInfo() => 'Name: $name';

  void help(People people) {}
}

class Student extends People {
  final int id;

  const Student(this.id, super.name);
}

class Lecturer extends People {
  const Lecturer(super.name);

  // only for Lecturer class who can help Student class
  @override
  void help(covariant Student people) {}

  giveGrade() {}
}

class UIO extends Lecturer {
  const UIO(super.name);

  joinCamp() {}
}

// Flutter use case
class Gesture {}

class DragGesture extends Gesture {}

class TapGesture extends Gesture {}

class CustomWidget extends StatelessWidget {
  final Gesture gesture;
  const CustomWidget({super.key, required this.gesture});

  void handleGesture(Gesture gesture) {}

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class DraggableWidget extends CustomWidget {
  const DraggableWidget({super.key, required DragGesture gesture})
      : super(gesture: gesture);
  @override
  void handleGesture(covariant DragGesture gesture) {}
}

class TapWidget extends CustomWidget {
  const TapWidget({super.key, required TapGesture gesture})
      : super(gesture: gesture);
  @override
  void handleGesture(covariant TapGesture gesture) {}

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    print({
      'gesture': gesture.hashCode,
    }.toString());
    return super.toString();
  }
}

void main() {
  const uio = UIO('John');
  uio.showInfo();
  uio.name;
  uio.help(const Student(1, 'John'));
  uio.giveGrade();
  uio.joinCamp();
  uio.hashCode; // from Object
}
