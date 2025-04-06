import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManualLoginScreen extends StatefulWidget {
  const ManualLoginScreen({super.key});

  @override
  State<ManualLoginScreen> createState() => _ManualLoginScreenState();
}

class _ManualLoginScreenState extends State<ManualLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'invalid-credential':
            _errorMessage = '"La credencial de autorización proporcionada es incorrecta, está mal formada o ha caducado".';
            break;
          case 'user-not-found':
            _errorMessage = 'Usuario no encontrado';
            break;
          case 'wrong-password':
            _errorMessage = 'Contraseña incorrecta';
            break;
          case 'invalid-email':
            _errorMessage = 'Correo inválido';
            break;
          case 'user-disabled':
            _errorMessage = 'Se ha producido un error de autenticación de red \n (por ejemplo, tiempo de espera, conexión interrumpida o host inaccesible).';
            break;

          default:
            _errorMessage = e.message ?? 'Error desconocido';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔐 Login TeleUSS')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
            ),

            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Iniciar sesión'),
            ),
            
            const SizedBox(height: 20),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
