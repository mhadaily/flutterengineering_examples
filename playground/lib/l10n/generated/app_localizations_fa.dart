import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

/// The translations for Persian (`fa`).
class SFa extends S {
  SFa([String locale = 'fa']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String greetingMessage(String username, String date) {
    return 'Hello, $username! Today is $date.';
  }

  @override
  String greeting(String gender, String username) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'Hello, Mr. $username',
        'female': 'Hello, Ms. $username',
        'other': 'Hello, $username',
      },
    );
    return '$_temp0';
  }

  @override
  String emailCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You have $count emails',
      one: 'You have one email',
      zero: 'You have no emails',
    );
    return '$_temp0';
  }

  @override
  String costText(num COST) {
    return 'Your pending cost is $COST';
  }

  @override
  String formattedCurrency(double value) {
    final intl.NumberFormat valueNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Total: $valueString';
  }

  @override
  String formattedDate(DateTime date) {
    return 'Date: \$date';
  }
}
