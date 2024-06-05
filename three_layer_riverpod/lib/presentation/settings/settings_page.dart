import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/common.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer(
          builder: (
            BuildContext context,
            WidgetRef ref,
            Widget? child,
          ) {
            final themeMode = ref.watch(themeModeProvider);
            return ListTile(
              title: Text(
                'Dark Mode',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              trailing: Switch(
                value: themeMode == ThemeMode.dark,
                onChanged: (value) {
                  ref
                      .read(
                        themeModeProvider.notifier,
                      )
                      .state = value ? ThemeMode.dark : ThemeMode.light;
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
