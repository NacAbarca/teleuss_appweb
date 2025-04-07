import '../services/auth_service.dart';

abstract class RegistroView {
  void mostrarMensaje(String msg);
  void mostrarError(String msg);
}

class RegistroPresenter {
  final AuthService _authService;
  final RegistroView _view;

  RegistroPresenter(this._authService, this._view);

  Future<void> registrar(String nombres, String apellidoPaterno, String correo, String password, String celular) async {
    try {
      await _authService.registrarUsuario(
        nombres: nombres,
        apellidoPaterno: apellidoPaterno,
        correo: correo,
        password: password,
        celular: celular,
      );
      _view.mostrarMensaje('🎉 Registro exitoso');
    } catch (e) {
      _view.mostrarError('❌ Error: ${e.toString()}');
    }
  }
}
