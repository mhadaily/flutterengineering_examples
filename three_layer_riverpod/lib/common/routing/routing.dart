import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:three_layer_riverpod/common/routing/config.dart';
import 'package:three_layer_riverpod/common/routing/routes_name.dart';

class AppRouter {
  static go(BuildContext context, RouterNames routeName) {
    GoRouter.of(context).pushNamed(routeName.name);
  }

  static pop(context) {
    GoRouter.of(context).pop();
  }

  static final config = goRouterConfig;
}
