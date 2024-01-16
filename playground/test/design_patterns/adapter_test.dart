import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:playground/design_patterns/adapter.dart';

class MockMyAppMediaPlayer extends Mock implements MyAppMediaPlayer {}

void main() {
  group('MediaAdapter Tests', () {
    test('Should call playMp3 when MP3 is played', () {
      final mediaPlayer = MockMyAppMediaPlayer();
      final mediaAdapter = MediaAdapter(mediaPlayer);

      mediaAdapter.play('mp3', 'song.mp3');

      verify(mediaPlayer.playMp3('song.mp3')).called(1);
    });

    test('Should call playMp4 when MP4 is played', () {
      final mediaPlayer = MockMyAppMediaPlayer();
      final mediaAdapter = MediaAdapter(mediaPlayer);

      mediaAdapter.play('mp4', 'video.mp4');

      verify(mediaPlayer.playMp4('video.mp4')).called(1);
    });
  });

  group('AppMediaPlayer Tests', () {
    testWidgets('Should display two buttons and react to taps',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.byType(CustomWidgetMediaPlayer), findsNWidgets(2));

      await tester.tap(find.widgetWithText(TextButton, 'Play').first);
      await tester.pump();

      // Here you can add further assertions or verifications
      // Unfortunately, without a concrete implementation, it's hard to test further
    });
  });
}
