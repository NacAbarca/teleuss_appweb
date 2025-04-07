import 'package:flutter/material.dart';
import '../utils/toast_util.dart';
import '../models/usuario_model.dart';
import '../presenters/usuario_presenter.dart';

class DummyUsuarioView implements UsuarioView {
  final BuildContext context;
  DummyUsuarioView(this.context);

  @override
  void mostrarError(String error) {
    ToastUtil.showError(context, error);
  }

  @override
  void mostrarUsuarios(List<UsuarioModel> lista) {
    // No se usa aquí
  }
}
