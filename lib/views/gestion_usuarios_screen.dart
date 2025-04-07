import 'package:flutter/material.dart';
import '../models/usuario_model.dart';
import '../presenters/usuario_presenter.dart';
import 'usuario_form_screen.dart';
import '../services/usuario_service.dart';

class GestionUsuariosScreen extends StatefulWidget {
  const GestionUsuariosScreen({super.key});

  @override
  State<GestionUsuariosScreen> createState() => _GestionUsuariosScreenState();
}

class _GestionUsuariosScreenState extends State<GestionUsuariosScreen> implements UsuarioView {
  late UsuarioPresenter _presenter;
  List<UsuarioModel> _usuarios = [];

  @override
  void initState() {
    super.initState();
    _presenter = UsuarioPresenter(this);
    _presenter.cargarUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('📋 Gestión de Usuarios'),
      ),
      body: _usuarios.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('🖼️ Foto')),
                  DataColumn(label: Text('👤 Nombre')),
                  DataColumn(label: Text('📧 Correo')),
                  DataColumn(label: Text('📱 Celular')),
                  DataColumn(label: Text('🎭 Rol')),
                  DataColumn(label: Text('⚙️ Acciones')),
                ],
                rows: _usuarios.map((u) {
                  return DataRow(
                    cells: [
                      DataCell(CircleAvatar(
                        backgroundImage: u.fotoUrl != null
                          ? NetworkImage(u.fotoUrl!)
                          : const AssetImage('assets/avatar.png') as ImageProvider,
                        radius: 20,
                      )),
                      DataCell(Text('${u.nombres ?? ''} ${u.apellidoPaterno ?? ''}')),
                      DataCell(Text(u.correo ?? '')),
                      DataCell(Text(u.celular ?? '')),
                      DataCell(Text(u.rol ?? 'Paciente Sordo')),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              tooltip: 'Editar',
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => UsuarioFormScreen(usuario: u)),
                                );
                                if (result == true) _presenter.cargarUsuarios();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              tooltip: 'Eliminar',
                              onPressed: () async {
                                final confirmar = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('🗑️ Eliminar usuario'),
                                    content: Text('¿Eliminar a ${u.nombres}?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: const Text('Eliminar'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirmar == true) {
                                  await UsuarioService().eliminarUsuario(u.uid);
                                  _presenter.cargarUsuarios();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('✅ Usuario eliminado correctamente'),
                                      backgroundColor: Colors.green.shade600,
                                      duration: const Duration(seconds: 2),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      margin: const EdgeInsets.all(16),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),

            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UsuarioFormScreen()),
                );
                if (result == true) _presenter.cargarUsuarios();
              },
              icon: const Icon(Icons.person_add),
              label: const Text('Agregar usuario'),
            ),
    );
  }

  @override
  void mostrarUsuarios(List<UsuarioModel> lista) {
    if (!mounted) return;
      setState(() {
        _usuarios = lista;
      });
    }

  @override
  void mostrarError(String error) {
    if (!mounted) return; // 🛑 Previene crash si el widget ya no existe
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ $error')),
    );
  }




}
