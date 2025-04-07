import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> registrarUsuario({
    required String nombres,
    required String apellidoPaterno,
    required String correo,
    required String password,
    required String celular,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: correo,
      password: password,
    );

    final user = UsuarioModel(
      uid: cred.user!.uid,
      nombres: nombres,
      apellidoPaterno: apellidoPaterno,
      correo: correo,
      celular: celular,
      fotoUrl: null,
    );

    await _db.collection('usuarios').doc(user.uid).set(user.toMap());
  }
}
