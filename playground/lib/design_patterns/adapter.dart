import 'package:flutter/material.dart';

abstract interface class MediaPlayer {
  void play(String audioType, String fileName);
}

// Adaptee Class
class MyAppMediaPlayer {
  void playMp3(String fileName) {}
  void playMp4(String fileName) {}
}

// Adapter class
class MediaAdapter implements MediaPlayer {
  MediaAdapter(this.myAppMediaPlayer);

  final MyAppMediaPlayer myAppMediaPlayer;

  @override
  void play(String audioType, String fileName) {
    if (audioType.toLowerCase() == 'mp3') {
      myAppMediaPlayer.playMp3(fileName);
    } else if (audioType.toLowerCase() == 'mp4') {
      myAppMediaPlayer.playMp4(fileName);
    }
  }
}

class AppMediaPlayer implements MediaPlayer {
  @override
  void play(String audioType, String fileName) {
    final mediaAdapter = MediaAdapter(MyAppMediaPlayer());
    mediaAdapter.play(audioType, fileName);
  }
}

class CustomWidgetMediaPlayer extends StatelessWidget {
  const CustomWidgetMediaPlayer({
    super.key,
    required this.type,
    required this.fileName,
    required this.adapter,
  });

  final String type;
  final String fileName;
  final MediaPlayer adapter;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        adapter.play(type, fileName);
      },
      child: const Text('Play'),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              CustomWidgetMediaPlayer(
                type: 'mp3',
                fileName: 'file.mp3',
                adapter: AppMediaPlayer(),
              ),
              CustomWidgetMediaPlayer(
                type: 'mp4',
                fileName: 'file.mp4',
                adapter: AppMediaPlayer(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
