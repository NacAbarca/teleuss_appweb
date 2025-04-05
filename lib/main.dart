
// import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/manual_login_screen.dart';
// import 'screens/home_screen.dart'; // Crearemos después
import 'firebase_options.dart'; // <-- IMPORTANTE

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(TeleUSSApp());
}

class TeleUSSApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TeleUSS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/login' : '/home',
      routes: {
        // '/login': (context) => LoginScreen(), -> auth google
        '/login': (context) => ManualLoginScreen(),
        '/home': (context) => HomeScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido a TeleUSS'),
      ),
      body: Center(
        child: Text(
          'App para usuarios sordos',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
