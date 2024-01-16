import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

main() {
  SemanticsBinding.instance.ensureSemantics();

  SemanticsService.announce(
    'Accessibility',
    TextDirection.ltr,
  );

  SemanticsService.tooltip(
    'Tooltip',
  );

  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Accessibility'),
        ),
        body: Semantics(
          enabled: true,
          textField: true,
          child: const Center(
            child: Text(
              'High Contrast Text',
              style: TextStyle(
                color: Colors.white,
                backgroundColor: Colors.black,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool reduceMotion = MediaQuery.of(context).accessibleNavigation;
    bool highContrast = MediaQuery.of(context).highContrast;
    bool boldText = MediaQuery.of(context).boldText;
    bool disableAnimations = MediaQuery.of(context).disableAnimations;
    bool invertColors = MediaQuery.of(context).invertColors;

    return Semantics(
      enabled: true,
      onTapHint: 'Tap Hint',
      liveRegion: true,
      child: const Text('Tap Me'),
    );
  }
}

class MyRichText extends StatelessWidget {
  const MyRichText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      enabled: true,
      onTapHint: 'Tap Hint',
      liveRegion: true,
      child: const Text.rich(
        TextSpan(
          text: 'Do not forget to',
          children: [
            TextSpan(
              text: 'save',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: ' your work!'),
          ],
        ),
      ),
    );
  }
}
