import 'package:flutter/material.dart';
import '../app/app_routs.dart';
import '../services/realtime_service.dart';
import '../widgets/custom_card_item.dart';
import '../widgets/custom_icon_button.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});
  final RealtimeDatabaseService databaseService = RealtimeDatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent.shade100,
        title: const Text(
          'Reservas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: databaseService.streamReservas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar as reservas.'));
          } else if (snapshot.hasData) {
            final reservas = snapshot.data!;

            return ListView.builder(
              itemCount: reservas.length,
              itemBuilder: (context, index) {
                final reserva = reservas[index];
                return CardItem(
                  name: reserva['nome'],
                  capacity: reserva['capacidade'],
                  status: reserva['status'],
                  availability: "${reserva['disponibilidade']} horários livres",
                );
              },
            );
          } else {
            return const Center(child: Text('Nenhuma reserva encontrada.'));
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        height: 90,
        color: Colors.blueAccent.shade100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomIconButton(
              label: 'Home',
              icon: Icons.home_outlined,
              route: AppRouts.mainPage,
            ),
            const VerticalDivider(
              width: 2,
              color: Colors.white,
            ),
            CustomIconButton(
              label: 'Reservas',
              icon: Icons.calendar_month_outlined,
              route: AppRouts.reservesPage,
            ),
          ],
        ),
      ),
    );
  }
}
