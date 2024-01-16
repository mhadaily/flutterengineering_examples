import 'package:flutter/material.dart';

class API {}

class MyService {
  API api;
  MyService(this.api);
}

class MyWidget extends StatelessWidget {
  final MyService myService;

  const MyWidget({super.key, required this.myService});

  @override
  Widget build(BuildContext context) {
    return AnotherWidget(myService: myService);
  }
}

class AnotherWidget extends StatelessWidget {
  final MyService myService;

  const AnotherWidget({super.key, required this.myService});

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

class MyServiceInherited extends InheritedWidget {
  final MyService myService;

  const MyServiceInherited({
    super.key,
    required super.child,
    required this.myService,
  });

  static MyService of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MyServiceInherited>()!
        .myService;
  }

  @override
  bool updateShouldNotify(MyServiceInherited oldWidget) => false;
}

// class MyWidget extends StatelessWidget {
//   const MyWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final myService = MyServiceInherited.of(context);
//     return AnotherWidget();
//   }
// }

// class AnotherWidget extends StatelessWidget {
//   const AnotherWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final myService = MyServiceInherited.of(context);
//     return const SizedBox();
//   }
// }
main() {
  final api = API();
  final myService = MyService(api);
  runApp(MaterialApp(
    home: MyWidget(
      myService: myService,
    ),
  ));

  // runApp(MaterialApp(
  //   home: MyServiceInherited(
  //     myService: myService,
  //     child: const MyWidget(),
  //   ),
  // ));
}
