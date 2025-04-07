import 'package:flutter/material.dart';
import 'package:teleuss_appweb/services/auth_service.dart';
import 'package:teleuss_appweb/presenters/registro_presenters.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> implements RegistroView {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _rol = 'sordo';
  String _mensaje = '';

  late RegistroPresenter _presenter;


  @override
  void initState() {
    super.initState();
    _presenter = RegistroPresenter(AuthService(), this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 Registro de Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 👤 Nombre
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: '👤 Nombre completo',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) => value == null || value.isEmpty ? '⚠️ Escribe tu nombre' : null,
              ),

              // 📧 Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: '📧 Correo electrónico',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) => value == null || value.isEmpty ? '⚠️ Escribe tu correo' : null,
              ),

              // 🔐 Contraseña
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '🔐 Contraseña',
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) => value != null && value.length < 6 ? '⚠️ Mínimo 6 caracteres' : null,
              ),

              const SizedBox(height: 10),

              // 🧑‍⚕️ Rol
              DropdownButtonFormField<String>(
                value: _rol,
                decoration: const InputDecoration(
                  labelText: '🙋 Tipo de usuario',
                  prefixIcon: Icon(Icons.account_circle),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'sordo',
                    child: Text('🧏 Paciente Sordo'),
                  ),
                  DropdownMenuItem(
                    value: 'tutor',
                    child: Text('🧑‍🏫 Tutor/Responsable'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _rol = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              // ✅ Botón de registro
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _presenter.registrar(
                      _nombreController.text,
                      _apellidoController.text,  // 👈 nuevo campo (asegurate de tenerlo)
                      _emailController.text,
                      _passwordController.text,
                      _rol,
                    );
                  }
                },
                icon: const Icon(Icons.check_circle),
                label: const Text('Registrar 👨‍⚕️'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),

              const SizedBox(height: 10),

              // 💬 Mensaje de éxito o error
              Text(
                _mensaje,
                style: TextStyle(
                  color: _mensaje.contains('Error') ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void mostrarMensaje(String msg) {
    setState(() {
      _mensaje = '✅ $msg';
    });
  }

  @override
  void mostrarError(String msg) {
    setState(() {
      _mensaje = '❌ $msg';
    });
  }
}

