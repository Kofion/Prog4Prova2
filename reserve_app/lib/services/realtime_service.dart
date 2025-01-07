import 'package:firebase_database/firebase_database.dart';

class RealtimeDatabaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<List<Map<String, dynamic>>> getLocais() async {
    try {
      print("Chamando a função getLocais()...");
      DatabaseEvent event = await _database.once();

      print("Dados recebidos: ${event.snapshot.value}");

      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);

        return data.entries.map((entry) {
          return {
            "nome": entry.key,
            "capacidade": entry.value["capacidade"],
            "disponibilidade": entry.value["disponibilidade"],
            'status': entry.value['status'],
          };
        }).toList();
      } else {
        print("Nenhum dado encontrado no Firebase.");
        return [];
      }
    } catch (e) {
      print("Erro ao carregar locais: $e");
      return [];
    }
  }
}
