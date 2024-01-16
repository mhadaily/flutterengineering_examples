import 'dart:async';

import 'package:flutter/material.dart';

class PageViewEvent {
  String pageName;
  PageViewEvent(this.pageName);
}

class UserActionEvent {
  String actionName;
  Map<String, dynamic> parameters;
  UserActionEvent(this.actionName, this.parameters);
}

class EventManager {
  // make sure multiple subscription is accepted
  final _controller = StreamController.broadcast();

  void dispose() {
    _controller.close();
  }

  // fire an event to the stream
  void fire(dynamic event) {
    _controller.add(event);
  }

  // listen to the stream for events actual as a broker
  Stream get stream => _controller.stream;
}

// global variable now
// Better to use a dependency injection
// you will learn about this later int his part of the book
final eventManager = EventManager();

class AnalyticsService {
  AnalyticsService(this.analytics);

  final AnyAnalyticsService analytics;

  void trackEvent(
    String eventName,
    Map<String, dynamic> parameters,
  ) {
    analytics.logEvent(
      name: eventName,
      parameters: parameters,
    );
  }

  void listenToEvents(Stream eventStream) {
    eventStream.listen((event) {
      if (event is PageViewEvent) {
        analytics.setCurrentScreen(
          screenName: event.pageName,
        );
      } else if (event is UserActionEvent) {
        analytics.logEvent(
          name: event.actionName,
          parameters: event.parameters,
        );
      }
    });
  }
}

class AnyAnalyticsService {
  void setCurrentScreen({
    required String screenName,
  }) {
    debugPrint('Analytics: setCurrentScreen $screenName');
  }

  void logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) {
    debugPrint('Analytics: logEvent $name $parameters');
  }
}

main() {
  // You will learn in this part of the book how
  // to use Dependency Injection to inject this
  // where needed rather than using a Global variable.
  final anyAnalyticsService = AnyAnalyticsService();
  final analyticsService = AnalyticsService(anyAnalyticsService);
  analyticsService.listenToEvents(eventManager.stream);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Analytics',
      home: MyHomePage(title: 'Analytics'),
      navigatorObservers: [AnalyticsNavigatorObserver()],
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.title});

  final String title;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Analytics',
            ),
            TextField(
              controller: _controller,
            ),
            ElevatedButton(
              onPressed: () {
                eventManager.fire(
                  UserActionEvent(
                    'ButtonClicked',
                    {'buttonId': 'startButton'},
                  ),
                );
              },
              child: const Text('Start'),
            ),
            ElevatedButton(
              onPressed: () {
                eventManager.fire(
                  UserActionEvent(
                    'ButtonClicked',
                    {'buttonId': 'stopButton'},
                  ),
                );
              },
              child: const Text('Stop'),
            ),
            ElevatedButton(
              onPressed: () {
                eventManager.fire(
                  UserActionEvent(
                    'ButtonClicked',
                    {'buttonId': 'resetButton'},
                  ),
                );
              },
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}

class AnalyticsNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    eventManager.fire(PageViewEvent(route.settings.name ?? 'unknown'));
  }
}
