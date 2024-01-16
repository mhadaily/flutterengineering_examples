import 'package:flutter/material.dart';

// Base Component
abstract class TextComponent {
  Widget build(BuildContext context);
}

// Concrete Component
class SimpleText extends TextComponent {
  final String text;

  SimpleText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}

// Decorator
abstract class TextDecorator extends TextComponent {
  final TextComponent decoratedText;

  TextDecorator(this.decoratedText);

  @override
  Widget build(BuildContext context);
}

// Concrete Decorators
class BorderText extends TextDecorator {
  BorderText(super.decoratedText);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: decoratedText.build(context),
    );
  }
}

class PaddingText extends TextDecorator {
  PaddingText(super.decoratedText);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: decoratedText.build(context),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextComponent text = SimpleText('Hello, World!');
    TextComponent borderedText = BorderText(text);
    TextComponent paddedText = PaddingText(borderedText);

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: paddedText.build(context),
        ),
      ),
    );
  }
}

// Usage in the app
void main() {
  runApp(
    const MyApp(),
  );
}
