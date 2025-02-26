import 'package:flutter/material.dart';
import 'package:hirad/database/helper.dart';
import 'package:hirad/landing-page/landing_page.dart';
import 'package:hirad/models/product_model.dart';
import 'package:hirad/utils/dark_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  
  // Register the adapters
  Hive.registerAdapter(ProductCategoryAdapter());
  Hive.registerAdapter(ProductIntroductionAdapter());
  Hive.registerAdapter(ProductAdapter());

  final dbHelper = DatabaseHelper.instance;
  await dbHelper.openBoxes();           // Make sure box is opened
  await dbHelper.initializeData();    // Initialize only if empty
  
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
