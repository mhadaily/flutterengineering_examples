import 'package:go_router/go_router.dart';

import '../../presentation/presentation.dart';
import 'routes_name.dart';

final goRouterConfig = GoRouter(
  initialLocation: '/auth',
  routes: [
    GoRoute(
      path: '/auth',
      name: RouterNames.loginPage.name,
      builder: (context, state) => LoginPage(),
      routes: [
        GoRoute(
          path: 'register',
          name: RouterNames.registerPage.name,
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: 'forgot-password',
          name: RouterNames.forgotPasswordPage.name,
          builder: (context, state) => const ForgotPasswordPage(),
        ),
      ],
    ),
  ],
);
