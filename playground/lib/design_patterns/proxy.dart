import 'package:flutter/material.dart';

abstract class AccessibleWidget {
  Widget build(BuildContext context);
}

// Real Widget
class RestrictedContentWidget implements AccessibleWidget {
  @override
  Widget build(BuildContext context) {
    return const Text(
      'Restricted Content',
      key: Key('restrictedContentKey'),
    );
  }
}

// Proxy
class AccessControlProxyWidget extends StatelessWidget {
  final AccessibleWidget protectedWidget;
  final bool hasAccess;

  const AccessControlProxyWidget({
    super.key,
    required this.protectedWidget,
    required this.hasAccess,
  });

  @override
  Widget build(BuildContext context) {
    return hasAccess
        ? protectedWidget.build(context)
        : const Text('Access Denied');
  }
}

checkUserAccess() {
  return true;
}

// Usage in the app
void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: AccessControlProxyWidget(
        protectedWidget: RestrictedContentWidget(),
        hasAccess: checkUserAccess(), // A function to check user access
      ),
    ),
  ));
}
