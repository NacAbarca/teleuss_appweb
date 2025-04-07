import 'package:image_picker/image_picker.dart';
import '../presenters/usuario_presenter.dart';
// import '../services/usuario_service.dart';
import 'package:flutter/foundation.dart'; // para kIsWeb
import 'package:flutter/material.dart';
import '../models/usuario_model.dart';
import '../utils/toast_util.dart';
// import 'dummy_usuario_view.dart';
// import 'dart:typed_data'; // para Web
import 'dart:io'; // para File en móvil




class UsuarioFormScreen extends StatefulWidget {
  final UsuarioModel? usuario;

  const UsuarioFormScreen({super.key, this.usuario});

  @override
  State<UsuarioFormScreen> createState() => _UsuarioFormScreenState();
}

class DummyUsuarioView implements UsuarioView {
  final BuildContext context;
  DummyUsuarioView(this.context);

  @override
  void mostrarError(String error) {
    ToastUtil.showError(context, error); // ✅ muestra toast si falla algo
  }

  @override
  void mostrarUsuarios(List<UsuarioModel> lista) {
    // No se usa aquí
  }
}

class _UsuarioFormScreenState extends State<UsuarioFormScreen> {

  final _formKey = GlobalKey<FormState>();
  final _nombresCtrl = TextEditingController();
  final _apellidoCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  final _rolCtrl = TextEditingController();

  dynamic _archivoSeleccionado;

  Future<void> seleccionarImagen() async {
  final ImagePicker picker = ImagePicker();
  final picked = await picker.pickImage(source: ImageSource.gallery);

  if (picked != null) {
    if (kIsWeb) {
      _archivoSeleccionado = await picked.readAsBytes(); // Uint8List
    } else {
      _archivoSeleccionado = File(picked.path); // File
    }
    setState(() {}); // 🔄 para mostrar preview si querés
  }
}

  @override
  void initState() {
    super.initState();
    if (widget.usuario != null) {
      _nombresCtrl.text = widget.usuario!.nombres ?? '';
      _apellidoCtrl.text = widget.usuario!.apellidoPaterno ?? '';
      _correoCtrl.text = widget.usuario!.correo ?? '';
      _rolCtrl.text = widget.usuario!.rol ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool editando = widget.usuario != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? '✏️ Editar Usuario' : '🆕 Crear Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombresCtrl,
                decoration: const InputDecoration(labelText: '👤 Nombres'),
                validator: (value) => value == null || value.isEmpty ? '⚠️ Ingresa el nombre' : null,
              ),
              TextFormField(
                controller: _apellidoCtrl,
                decoration: const InputDecoration(labelText: '🧬 Apellido Paterno'),
              ),
              TextFormField(
                controller: _correoCtrl,
                decoration: const InputDecoration(labelText: '📧 Correo'),
              ),
              DropdownButtonFormField<String>(
                value: _rolCtrl.text.isEmpty ? null : _rolCtrl.text,
                items: const [
                  DropdownMenuItem(value: 'sordo', child: Text('🧏 Paciente Sordo')),
                  DropdownMenuItem(value: 'tutor', child: Text('🧑‍🏫 Tutor')),
                ],
                onChanged: (val) => _rolCtrl.text = val ?? '',
                decoration: const InputDecoration(labelText: '🎭 Rol'),
              ),
              const SizedBox(height: 20),
             ElevatedButton.icon(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final uid = widget.usuario?.uid ?? DateTime.now().millisecondsSinceEpoch.toString();

                  final presenter = UsuarioPresenter(
                    DummyUsuarioView(context), // Puedes cambiar a tu implementación real de UsuarioView
                  );

                  await presenter.registrarUsuario(
                    uid: uid,
                    nombres: _nombresCtrl.text,
                    apellidoPaterno: _apellidoCtrl.text,
                    correo: _correoCtrl.text,
                    rol: _rolCtrl.text,
                    fileFoto: _archivoSeleccionado,
                  );

                  Navigator.pop(context, true);
                }
              },
              icon: const Icon(Icons.save),
              label: Text(widget.usuario != null ? 'Guardar Cambios' : 'Crear Usuario'),
            ),

            ElevatedButton.icon(
              onPressed: seleccionarImagen,
              icon: const Icon(Icons.photo),
              label: const Text('Subir foto de perfil 📷'),
            ),

            ],
          ),
        ),
      ),
    );
  }
}
