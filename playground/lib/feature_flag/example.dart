import 'package:flutter/material.dart';

class FeatureFlagWidget extends StatelessWidget {
  const FeatureFlagWidget({
    super.key,
    required this.featureEnabled,
    required this.enabledContent,
    required this.disabledContent,
  });

  final bool featureEnabled;
  final Widget enabledContent;
  final Widget disabledContent;

  @override
  Widget build(BuildContext context) {
    return featureEnabled
        ? enabledContent
        : disabledContent;
  }
}
