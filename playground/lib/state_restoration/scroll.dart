import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
      restorationScopeId: 'app',
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with RestorationMixin {
  final _scrollOffset = RestorableDouble(0);
  final _scrollController = ScrollController();

  @override
  String? get restorationId => 'homePage';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(
      () => _scrollOffset.value = _scrollController.offset,
    );
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.jumpTo(
        _scrollOffset.value,
      ),
    );
  }

  @override
  void restoreState(
    RestorationBucket? oldBucket,
    bool initialRestore,
  ) {
    registerForRestoration(
      _scrollOffset,
      'scroll_offset',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scroll Restoration Example',
        ),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: 100,
        itemBuilder: (
          BuildContext context,
          int index,
        ) {
          return ListTile(
            title: Text(
              'Item $index',
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollOffset.dispose();
    super.dispose();
  }
}
