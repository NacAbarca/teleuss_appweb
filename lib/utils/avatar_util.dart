class AvatarUtil {
  static String generar(String nombre) {
    final base = 'https://craftypixels.com/placeholder-image/600x600/1a73e8/fff&text=';
    return '$base${Uri.encodeComponent(nombre)}';
  }
}
