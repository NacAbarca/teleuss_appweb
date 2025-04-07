import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/usuario_model.dart';
import 'dart:typed_data';
import 'dart:io' as io;



class UsuarioService {
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<List<UsuarioModel>> obtenerUsuarios() async {
    final snapshot = await _db.collection('usuarios').get();
    return snapshot.docs.map((doc) {
      return UsuarioModel.fromMap(doc.data(), doc.id);
    }).toList();
  }

  Future<String> subirFoto(dynamic file, String uid) async {
    final ref = _storage.ref('usuarios/$uid.jpg');
    
    if (kIsWeb) {
      // 🌐 Web → usa bytes
      Uint8List bytes = file;
      await ref.putData(bytes);
    } else {
      // 📱 Android/iOS/Desktop → usa File
      io.File archivo = file;
      await ref.putFile(archivo);
    }

    return await ref.getDownloadURL();
  }

  Future<void> eliminarUsuario(String uid) async {
    await _db.collection('usuarios').doc(uid).delete();
  }

  Future<void> actualizarUsuario(UsuarioModel usuario) async {
    await _db.collection('usuarios').doc(usuario.uid).update(usuario.toMap());
  }

  Future<void> crearUsuario(UsuarioModel usuario) async {
    await _db.collection('usuarios').add(usuario.toMap());
  }


//   Future<void> crearUsuariosDummy() async {
//   final db = FirebaseFirestore.instance;

//   final usuarios = [
//     {
//       'Usuario': 'maria.brisas',
//       'Nombres': 'María Alejandra',
//       'Apellido Paterno': 'Brisas',
//       'Apellido Materno': 'Del Sol',
//       'Correo': 'maria.brisas@teleuss.org',
//       'Rol': 'sordo',
//       'Genero': 'Femenino',
//       'Fotografía': null,
//       'Sector': 'Sur',
//       'Edad': '27',
//       'Región': 'Metropolitana',
//       '¿Enviando?': true,
//     },
//     {
//       'Usuario': 'carlos.tutor',
//       'Nombres': 'Carlos Andrés',
//       'Apellido Paterno': 'Rodríguez',
//       'Apellido Materno': 'Pérez',
//       'Correo': 'carlos.tutor@teleuss.org',
//       'Rol': 'tutor',
//       'Genero': 'Masculino',
//       'Fotografía': null,
//       'Sector': 'Norte',
//       'Edad': '45',
//       'Región': 'Valparaíso',
//       '¿Enviando?': false,
//     },
//   ];

//   for (final u in usuarios) {
//     await db.collection('usuarios').add(u);
//     print("✅ Usuario agregado: ${u['Usuario']}");
//   }
// }


}
