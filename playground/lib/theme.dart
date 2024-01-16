import 'dart:ui';

import 'package:flutter/material.dart';

final themeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.teal,
    primary: Colors.teal,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: Colors.teal,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
    ),
  ),
);

ThemeData newTheme = themeData.copyWith(
  // Customizing the ElevatedButton theme
  textTheme: themeData.textTheme.copyWith(
    displaySmall: themeData.textTheme.displaySmall!.copyWith(
      color: Colors.red,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: themeData.elevatedButtonTheme.style!.copyWith(
      overlayColor: MaterialStateProperty.all<Color>(Colors.red),
    ),
  ),
);

main() {
  runApp(
    // Define ThemeData with a custom primary color
    MaterialApp(
      theme: themeData.copyWith(
        colorScheme: themeData.colorScheme.copyWith(
          primary: Colors.red,
        ),
      ),
      home: const MyThemeApp(),
    ),
  );
}

class MyThemeApp extends StatelessWidget {
  const MyThemeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Text(
          'Themed Text',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

class CustomTheme {
  static const Color customColor = Color(0xFF00FF00);

  static ThemeData get highContrastLight {
    return ThemeData.light().copyWith(
      extensions: <ThemeExtension<dynamic>>[
        CustomThemeExtension(customColor: Colors.red),
      ],
      colorScheme: const ColorScheme.highContrastLight().copyWith(
        primary: Colors.red,
        secondary: Colors.green,
      ),
    );
  }

  static ThemeData get light {
    return ThemeData.light().copyWith(
      extensions: <ThemeExtension<dynamic>>[
        CustomThemeExtension(customColor: Colors.red),
      ],
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Colors.red,
        secondary: Colors.green,
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData.dark().copyWith(
      extensions: <ThemeExtension<dynamic>>[
        CustomThemeExtension(customColor: Colors.grey),
      ],
      colorScheme: const ColorScheme.dark(),
    );
  }

  static ThemeData get highContrastDark {
    return ThemeData.dark().copyWith(
      extensions: <ThemeExtension<dynamic>>[
        CustomThemeExtension(customColor: customColor),
        CustomButtonTheme(
          buttonRadius: 8.0,
          buttonHighlightColor: Colors.green,
        ),
      ],
      colorScheme: const ColorScheme.highContrastDark(),
    );
  }
}

class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final Color customColor;

  CustomThemeExtension({
    required this.customColor,
  });

  @override
  CustomThemeExtension copyWith({Color? customColor}) {
    return CustomThemeExtension(
      customColor: customColor ?? this.customColor,
    );
  }

  @override
  CustomThemeExtension lerp(
      ThemeExtension<CustomThemeExtension>? other, double t) {
    if (other is! CustomThemeExtension) {
      return this;
    }
    return CustomThemeExtension(
      customColor: Color.lerp(
        customColor,
        other.customColor,
        t,
      )!,
    );
  }
}

class CustomButtonTheme extends ThemeExtension<CustomButtonTheme> {
  final double buttonRadius;
  final Color buttonHighlightColor;

  CustomButtonTheme({
    required this.buttonRadius,
    required this.buttonHighlightColor,
  });

  @override
  CustomButtonTheme copyWith({
    double? buttonRadius,
    Color? buttonHighlightColor,
  }) {
    return CustomButtonTheme(
      buttonRadius: buttonRadius ?? this.buttonRadius,
      buttonHighlightColor: buttonHighlightColor ?? this.buttonHighlightColor,
    );
  }

  @override
  CustomButtonTheme lerp(
    ThemeExtension<CustomButtonTheme>? other,
    double t,
  ) {
    if (other is! CustomButtonTheme) return this;
    return CustomButtonTheme(
      buttonRadius: lerpDouble(
        buttonRadius,
        other.buttonRadius,
        t,
      )!,
      buttonHighlightColor: Color.lerp(
        buttonHighlightColor,
        other.buttonHighlightColor,
        t,
      )!,
    );
  }
}


// WidgetsApp(
//       color: Colors.blue,
//       onGenerateRoute: (settings) {
//         return MaterialPageRoute(
//           builder: (context) {
//             return Scaffold(
//               appBar: AppBar(title: Text('Home')),
//               body: Center(child: Text('Welcome to WidgetsApp')),
//             );
//           },
//         );
//       },
//     ),