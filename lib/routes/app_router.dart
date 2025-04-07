import 'package:flutter/material.dart';

// Importa las vistas según la estructura de tu proyecto
import 'package:teleuss_appweb/views/manual_login_screen.dart';
import 'package:teleuss_appweb/views/home_screen.dart';
import 'package:teleuss_appweb/views/registro_screen.dart';
import 'package:teleuss_appweb/views/gestion_usuarios_screen.dart';
// import 'package:teleuss_appweb/views/perfil_screen.dart';
// import 'package:teleuss_appweb/views/config_screen.dart';

class AppRouter {
  static Map<String, WidgetBuilder> routes = {
    '/login': (context) => ManualLoginScreen(),
    '/home': (context) => HomeScreen(),
    '/registro': (context) => RegistroScreen(),
    '/usuarios': (context) => GestionUsuariosScreen(),
    // '/perfil': (context) => const PerfilScreen(),
    // '/config': (context) => const ConfigScreen(),
  };
}
