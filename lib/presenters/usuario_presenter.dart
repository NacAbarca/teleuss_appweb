import '../models/usuario_model.dart';
import '../services/usuario_service.dart';
import '../utils/avatar_util.dart';
import 'dart:io';

abstract class UsuarioView {
  void mostrarUsuarios(List<UsuarioModel> lista);
  void mostrarError(String error);
}

class UsuarioPresenter {
  
  final UsuarioView view;
  final UsuarioService service = UsuarioService();
  UsuarioPresenter(this.view);

  Future<void> registrarUsuario({
  required String uid,
  required String nombres,
  required String apellidoPaterno,
  required String correo,
  required String rol,
  File? fileFoto,

}) async {
  
  try {
    String fotoUrl;

    if (fileFoto != null) {
      fotoUrl = await service.subirFoto(fileFoto, uid); // ✅ Funciona en web y móvil
    } else {
      fotoUrl = AvatarUtil.generar(nombres);
    }

    final usuario = UsuarioModel(
      uid: uid,
      nombres: nombres,
      apellidoPaterno: apellidoPaterno,
      correo: correo,
      rol: rol,
      fotoUrl: fotoUrl,
    );

    await service.crearUsuario(usuario);
    cargarUsuarios(); // refresca tabla
  } catch (e) {
    view.mostrarError('❌ Error al registrar: $e');
  }
}

  void cargarUsuarios() async {
    try {
      final usuarios = await service.obtenerUsuarios();
      view.mostrarUsuarios(usuarios);
    } catch (e) {
      view.mostrarError(e.toString());
    }
  }


}
