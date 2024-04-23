import 'package:flutter/material.dart';
import 'package:smart_hemo_check/permission.dart';
import 'package:smart_hemo_check/splash_screen.dart';
import 'package:smart_hemo_check/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request storage permission and initialize database on first run
 await initializeApp();

  runApp(const MyApp());
}

Future<void> initializeApp() async {
  // Request storage permission
  await requestStoragePermissionAndInitializeDatabase();
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
    );
  }
}
