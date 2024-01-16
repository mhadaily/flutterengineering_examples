import 'package:flutter/material.dart';
import 'l10n/generated/app_localizations.dart';

main() {
  runApp(const MaterialApp(
    title: 'Localizations Sample App',
    localizationsDelegates: S.localizationsDelegates,
    supportedLocales: S.supportedLocales,
    home: MyHomeIntl(),
  ));
}

class MyHomeIntl extends StatelessWidget {
  const MyHomeIntl({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(S.of(context)!.helloWorld),
          Text(S.of(context)!.greeting('male', 'username')),
          Text(S.of(context)!.emailCount(1)),
          Text(S.of(context)!.costText(100)),
          Text(
            S.of(context)!.greetingMessage('username', 'date'),
          ),
          Text(
            S.of(context)!.formattedCurrency(1200000),
            // 1,200,000
          ),
          Text(
            S.of(context)!.formattedDate(
                  DateTime.utc(1959, 7, 9),
                ),
          ),
        ],
      ),
    );
  }
}
