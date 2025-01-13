import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ReservesPage extends StatefulWidget {
  const ReservesPage({super.key});

  @override
  State<ReservesPage> createState() => _ReservesPageState();
}

class _ReservesPageState extends State<ReservesPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<List<Map<String, dynamic>>> _fetchReservations() async {
    try {
      // Busca as reservas no nó "reservas"
      final snapshot = await _database.child('reservas').get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        return data.entries.map((entry) {
          final localName = entry.key;
          final reserva = entry.value as Map<dynamic, dynamic>;

          return {
            "local": localName,
            "horarios": List<String>.from(reserva["horarios_reservados"] ?? []),
            "status": reserva["status"] ?? "indefinido",
          };
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception("Erro ao buscar as reservas: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue.shade300,
        title: const Text(
          'Minhas Reservas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchReservations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final reservas = snapshot.data!;

            return ListView.builder(
              itemCount: reservas.length,
              itemBuilder: (context, index) {
                final reserva = reservas[index];

                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Local: ${reserva["local"]}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Horários reservados: ${reserva["horarios"].join(", ")}",
                        ),
                        const SizedBox(height: 8),
                        Text("Status: ${reserva["status"]}"),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('Nenhuma reserva encontrada.'),
            );
          }
        },
      ),
    );
  }
}
