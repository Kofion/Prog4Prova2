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
        title: Text(
          'Espaços',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: databaseService.getEspacos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os locais.'));
          } else if (snapshot.hasData) {
            final locais = snapshot.data!;

            return ListView.builder(
              itemCount: locais.length,
              itemBuilder: (context, index) {
                final local = locais[index];
                return CardItem(
                  name: local['nome'],
                  capacity: local['capacidade'],
                  status: local['status'],
                  availability: local['disponibilidade'],
                );
              },
            );
          } else {
            return Center(child: Text('Nenhum local encontrado.'));
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        height: 90,
        color: Colors.blueAccent.shade100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          spacing: 10,
          children: [
            CustomIconButton(
              label: 'Home',
              icon: Icons.home_outlined,
              route: AppRouts.mainPage,
            ),
            VerticalDivider(
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
