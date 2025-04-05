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
        title: Text('Mis Citas'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: citasStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error al cargar citas'));
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());

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
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => AgendarCitaScreen()));
        },
      ),
    );
  }
}

class AgendarCitaScreen extends StatefulWidget {
  @override
  _AgendarCitaScreenState createState() => _AgendarCitaScreenState();
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
      appBar: AppBar(title: Text('Agendar Nueva Cita')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _doctorController, decoration: InputDecoration(labelText: 'Doctor')),
              TextFormField(controller: _fechaController, decoration: InputDecoration(labelText: 'Fecha (YYYY-MM-DD)')),
              TextFormField(controller: _horaController, decoration: InputDecoration(labelText: 'Hora (HH:MM)')),
              SizedBox(height: 20),
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
                child: Text('Guardar Cita'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
