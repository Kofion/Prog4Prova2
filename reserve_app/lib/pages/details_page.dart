import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  final String name;
  final int capacity;
  final String status;

  DetailsPage({
    Key? key,
    required this.name,
    required this.capacity,
    required this.status,
  }) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final List<String> times = [
    "08:00 - 10:00",
    "10:00 - 12:00",
    "12:00 - 14:00",
    "14:00 - 16:00",
    "16:00 - 18:00",
  ];
  final Map<String, bool> selectedTimes = {};

  @override
  void initState() {
    super.initState();
    for (var time in times) {
      selectedTimes[time] = false;
    }
    _loadReservationData();
  }

  void _loadReservationData() {
    final DatabaseReference database = FirebaseDatabase.instance.ref();
    final reservationRef = database.child("reservas/${widget.name}");

    reservationRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        final reservationData = event.snapshot.value as Map<dynamic, dynamic>;
        final reservedTimes =
            List<String>.from(reservationData['horarios_reservados'] ?? []);
        if (mounted) {
          setState(() {
            for (var time in times) {
              selectedTimes[time] = reservedTimes.contains(time);
            }
          });
        }
      }
    }, onError: (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade300,
        title: Text(
          widget.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoSection(),
            const SizedBox(height: 20),
            _buildAvailableTimesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: StreamBuilder(
        stream: FirebaseDatabase.instance
            .ref()
            .child("reservas/${widget.name}")
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Text('Erro ao carregar os dados.');
          } else if (snapshot.hasData &&
              (snapshot.data as DatabaseEvent).snapshot.exists) {
            final data = (snapshot.data as DatabaseEvent).snapshot.value
                as Map<dynamic, dynamic>;

            final capacity = data['capacidade'] ?? widget.capacity;
            final status = data['status'] ?? widget.status;
            final reservedTimes =
                List<String>.from(data['horarios_reservados'] ?? []);
            final availability = times.length - reservedTimes.length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informações',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Capacidade: $capacity pessoas'),
                Text('Disponibilidade: $availability horários'),
                Text('Status: $status'),
              ],
            );
          } else {
            return const Text('Nenhuma informação disponível.');
          }
        },
      ),
    );
  }

  Widget _buildAvailableTimesSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Horários Disponíveis',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: _buildAvailableTimeButtons(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAvailableTimeButtons() {
    return times.map((time) {
      final isSelected = selectedTimes[time] ?? false;
      return GestureDetector(
        onTap: () => _showConfirmationDialog(context, time, isSelected),
        child: Container(
          width: 100,
          height: 50,
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.grey
                : Colors.blue.shade300, // Cinza para selecionados
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            time,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }).toList();
  }

  void _showConfirmationDialog(
      BuildContext context, String time, bool isSelected) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isSelected
              ? 'Deseja desmarcar este horário?'
              : 'Deseja selecionar este horário?'),
          content: Text(
              'Você está prestes a ${isSelected ? 'desmarcar' : 'selecionar'} o horário: $time.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  selectedTimes[time] = !isSelected;
                });

                try {
                  final DatabaseReference database =
                      FirebaseDatabase.instance.ref();
                  final reservedTimes = selectedTimes.entries
                      .where((entry) => entry.value)
                      .map((entry) => entry.key)
                      .toList();

                  final availability =
                      times.where((t) => !selectedTimes[t]!).length;
                  final String newStatus =
                      availability == 0 ? 'inativo' : 'ativo';

                  await database.child("reservas/${widget.name}").update({
                    "horarios_reservados": reservedTimes,
                    "status": newStatus,
                  });

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(isSelected
                          ? 'Horário desmarcado com sucesso!'
                          : 'Horário reservado com sucesso!')));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Erro ao atualizar o horário. Tente novamente mais tarde. Erro: $e')));
                }

                Navigator.of(context).pop();
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }
}
