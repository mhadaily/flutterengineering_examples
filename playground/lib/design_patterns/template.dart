import 'package:flutter/material.dart';

abstract class BaseWidget extends StatelessWidget {
  const BaseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appBarTitle())),
      body: buildBody(context),
    );
  }

  String appBarTitle();
  Widget buildBody(BuildContext context);
}

class ConcreteWidget extends BaseWidget {
  const ConcreteWidget({super.key});

  @override
  String appBarTitle() => 'Concrete Widget';

  @override
  Widget buildBody(BuildContext context) {
    return const Center(
      child: Text('Concrete implementation of buildBody.'),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: ConcreteWidget()));
}
