import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';

/// Global theme notifier used across the app
ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('darkMode') ?? false;
  themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;

  runApp(const FishMVPApp());
}

class FishMVPApp extends StatelessWidget {
  const FishMVPApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'Fish MVP',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          // Light theme
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
            textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black87)),
          ),
          // Dark theme
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF071427),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF0B2340),
              foregroundColor: Colors.white,
            ),
            textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white70)),
          ),
          home: const LoginScreen(),
        );
      },
    );
  }
}
