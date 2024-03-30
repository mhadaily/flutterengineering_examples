import 'package:flutter/material.dart';

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm>
    with RestorationMixin {
  final _controller = RestorableTextEditingController();

  @override
  String get restorationId => 'form';

  @override
  void restoreState(
    RestorationBucket? oldBucket,
    bool initialRestore,
  ) {
    registerForRestoration(
      _controller,
      'text_field',
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller.value,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
