import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart'; // 🔐 Firebase config
import 'routes/app_router.dart'; // 📍 Rutas centralizadas

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
      
      debugShowCheckedModeBanner: false,

      initialRoute: FirebaseAuth.instance.currentUser == null ? '/login' : '/home',
      routes: AppRouter.routes,
    );
  }
}

