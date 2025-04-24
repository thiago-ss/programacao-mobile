import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/home_page.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const JapaneseRestaurantApp());
}

class JapaneseRestaurantApp extends StatelessWidget {
  const JapaneseRestaurantApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kan Japanese',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD4AF37),
          brightness: Brightness.light,
          primary: const Color(0xFFD4AF37),
          secondary: const Color(0xFF121212),
          surface: Colors.white,
          background: Colors.white,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: Color(0xFF121212),
          ),
          headlineMedium: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
            color: Color(0xFF121212),
          ),
          titleLarge: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.2,
            color: Color(0xFF121212),
          ),
          bodyLarge: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.1,
            color: Color(0xFF121212),
          ),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: const HomePage(),
    );
  }
}
