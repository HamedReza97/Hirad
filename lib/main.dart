import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hirad/landing-page/landing_page.dart';
import 'package:hirad/utils/dark_theme.dart';

void main() {
  debugProfileLayoutsEnabled = true;
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        // '/about': (context) => AboutPage(),
        // '/contact': (context) => ContactPage(),
        // '/products': (context) => ProductsPage(),
        // '/settings': (context) => SettingsPage(),
      },
    );
  }
}
