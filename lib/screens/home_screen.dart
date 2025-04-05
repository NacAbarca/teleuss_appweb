import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final citasStream = FirebaseFirestore.instance
        .collection('appointments')
        .where('userId', isEqualTo: user?.uid)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('🗓️ Mis Citas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              final salir = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Cerrar sesión'),
                  content: const Text('¿Estás seguro que deseas Salir?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('❌ Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('🔒 Salir'),
                    ),
                  ],
                ),
              );
              if (salir == null || salir == true) {

                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
                
              }
            },
          )
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: citasStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Error al cargar citas'));
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

          final citas = snapshot.data!.docs;
          return ListView.builder(
            itemCount: citas.length,
            itemBuilder: (context, index) {
              var cita = citas[index].data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  title: Text('${cita['doctor']} - ${cita['fecha']}'),
                  subtitle: Text('Hora: ${cita['hora']} | Estado: ${cita['estado']}'),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => AgendarCitaScreen()));
        },
      ),
    );
  }
}

class AgendarCitaScreen extends StatefulWidget {
  @override
  State<AgendarCitaScreen> createState() => _AgendarCitaScreenState();
}

class _AgendarCitaScreenState extends State<AgendarCitaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fechaController = TextEditingController();
  final _horaController = TextEditingController();
  final _doctorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Agendar Nueva Cita')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _doctorController,
                decoration: const InputDecoration(labelText: 'Doctor'),
                validator: (value) => value == null || value.isEmpty ? 'Ingresa el nombre del doctor' : null,
              ),
              TextFormField(
                controller: _fechaController,
                decoration: const InputDecoration(labelText: 'Fecha (YYYY-MM-DD)'),
                validator: (value) => value == null || value.isEmpty ? 'Ingresa la fecha' : null,
              ),
              TextFormField(
                controller: _horaController,
                decoration: const InputDecoration(labelText: 'Hora (HH:MM)'),
                validator: (value) => value == null || value.isEmpty ? 'Ingresa la hora' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await FirebaseFirestore.instance.collection('appointments').add({
                      'userId': user!.uid,
                      'doctor': _doctorController.text,
                      'fecha': _fechaController.text,
                      'hora': _horaController.text,
                      'estado': 'pendiente',
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Guardar Cita'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
