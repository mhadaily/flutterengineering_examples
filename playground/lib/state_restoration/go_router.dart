import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(
      const RootRestorationScope(
        restorationId: 'root',
        child: MyApp(),
      ),
    );

final _rootNavigatorKey = GlobalKey<NavigatorState>();
const _appRestorationScopeId = 'app';

/// The route configuration.
final GoRouter _router = GoRouter(
  restorationScopeId: _appRestorationScopeId,
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, GoRouterState state) {
        return MaterialPage(
          restorationId: 'router_home',
          child: const HomeScreen(),
          key: state.pageKey,
        );
      },
    ),
    GoRoute(
      path: '/details',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, GoRouterState state) {
        return MaterialPage(
          restorationId: 'router_detail',
          child: const DetailsScreen(),
          key: state.pageKey,
        );
      },
    ),
  ],
);

/// The main app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      restorationScopeId: _appRestorationScopeId,
    );
  }
}

/// The home screen
class HomeScreen extends StatelessWidget {
  /// Constructs a [HomeScreen]
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/details'),
          child: const Text('Go to the Details screen'),
        ),
      ),
    );
  }
}

/// The details screen
class DetailsScreen extends StatelessWidget {
  /// Constructs a [DetailsScreen]
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/'),
          child: const Text('Go back to the Home screen'),
        ),
      ),
    );
  }
}


