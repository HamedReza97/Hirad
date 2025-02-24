import 'package:flutter/material.dart';
import 'package:hirad/database/helper.dart';
import 'package:hirad/landing-page/landing_page.dart';
import 'package:hirad/utils/dark_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive and open the box
  await Hive.initFlutter();
  final dbHelper = DatabaseHelper.instance;
  await dbHelper.box; // Open the box
  await dbHelper.initializeData();
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
