import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/provider/login_provider.dart';
import 'package:myapp/provider/signup_provider.dart';
import 'package:myapp/provider/test_provider.dart';
import 'package:myapp/screens/login.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // runApp(const MyApp());
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => TestProvider()),
      ChangeNotifierProvider(create: (_) => LoginProvider()),
      ChangeNotifierProvider(create: (_) => SignupProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes: {
      '/': (context) => const Login(),
      '/home': (context) => const Home(),
      '/login': (context) => const Login()
    });
  }
}
