import 'package:flutter/material.dart';

class ToastUtil {
  static void showSuccess(BuildContext context, String mensaje) {
    _show(context, mensaje, Colors.green.shade600, '✅');
  }

  static void showError(BuildContext context, String mensaje) {
    _show(context, mensaje, Colors.red.shade600, '❌');
  }

  static void showWarning(BuildContext context, String mensaje) {
    _show(context, mensaje, Colors.orange.shade600, '⚠️');
  }

  static void showInfo(BuildContext context, String mensaje) {
    _show(context, mensaje, Colors.blue.shade600, 'ℹ️');
  }

  static void _show(BuildContext context, String mensaje, Color color, String emoji) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$emoji $mensaje'),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
