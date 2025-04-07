class UsuarioModel {
  final String uid;
  final String? usuario;
  final String? nombres;
  final String? apellidoPaterno;
  final String? apellidoMaterno;
  final bool? vigencia;
  final String? sector;
  final DateTime? fechaNacimiento;
  final String? edad;
  final String? correo;
  final String? celular;
  final String? genero;
  final String? direccion;
  final String? region;
  final String? provincia;
  final String? comuna;
  final double? porcentajeDiscapacidad;
  final String? condicion;
  final String? nacionalidad;
  final DateTime? fechaFallecida;
  final String? notificacion;
  final bool? enviando;
  final String? establecimiento;
  final List<String>? patologiaCronica;
  final String? fotoUrl;
  final String? rol; 

  UsuarioModel({
    required this.uid,
    this.usuario,
    this.nombres,
    this.apellidoPaterno,
    this.apellidoMaterno,
    this.vigencia,
    this.sector,
    this.fechaNacimiento,
    this.edad,
    this.correo,
    this.celular,
    this.genero,
    this.direccion,
    this.region,
    this.provincia,
    this.comuna,
    this.porcentajeDiscapacidad,
    this.condicion,
    this.nacionalidad,
    this.fechaFallecida,
    this.notificacion,
    this.enviando,
    this.establecimiento,
    this.patologiaCronica,
    this.fotoUrl,
    this.rol,
  });

  factory UsuarioModel.fromMap(Map<String, dynamic> map, String uid) {
    return UsuarioModel(
      uid: uid,
      usuario: map['Usuario'],
      nombres: map['Nombres'],
      apellidoPaterno: map['Apellido Paterno'],
      apellidoMaterno: map['Apellido Materno'],
      vigencia: map['Vigencia'],
      sector: map['Sector'],
      fechaNacimiento: map['Fecha de Nacimiento'] != null
          ? DateTime.tryParse(map['Fecha de Nacimiento'])
          : null,
      edad: map['Edad'],
      correo: map['Correo'],
      celular: map['Celular'],
      genero: map['Genero'],
      direccion: map['Dirección'],
      region: map['Región'],
      provincia: map['Provincia'],
      comuna: map['Comuna'],
      porcentajeDiscapacidad: map['% de Discapacidad']?.toDouble(),
      condicion: map['Condición'],
      nacionalidad: map['Nacionalidad'],
      fechaFallecida: map['Fecha de fallecida'] != null
          ? DateTime.tryParse(map['Fecha de fallecida'])
          : null,
      notificacion: map['Notificación'],
      enviando: map['¿Enviando?'],
      establecimiento: map['Establecimiento'],
      patologiaCronica: map['Patología cronica'] != null
          ? List<String>.from(map['Patología cronica'])
          : [],
      fotoUrl: map['Fotografía'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Usuario': usuario,
      'Nombres': nombres,
      'Apellido Paterno': apellidoPaterno,
      'Apellido Materno': apellidoMaterno,
      'Vigencia': vigencia,
      'Sector': sector,
      'Fecha de Nacimiento': fechaNacimiento?.toIso8601String(),
      'Edad': edad,
      'Correo': correo,
      'Celular': celular,
      'Genero': genero,
      'Dirección': direccion,
      'Región': region,
      'Provincia': provincia,
      'Comuna': comuna,
      '% de Discapacidad': porcentajeDiscapacidad,
      'Condición': condicion,
      'Nacionalidad': nacionalidad,
      'Fecha de fallecida': fechaFallecida?.toIso8601String(),
      'Notificación': notificacion,
      '¿Enviando?': enviando,
      'Establecimiento': establecimiento,
      'Patología cronica': patologiaCronica,
      'Fotografía': fotoUrl,
    };
  }
}
