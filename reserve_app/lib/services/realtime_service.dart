import 'package:firebase_database/firebase_database.dart';

class RealtimeDatabaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<List<Map<String, dynamic>>> getEspacos() async {
    try {
      print("Chamando a função getEspacos()...");

      DatabaseEvent event = await _database.child("espaços").once();

      print("Dados recebidos do nó 'espaços': ${event.snapshot.value}");

      if (event.snapshot.value != null) {
        final Map<String, dynamic> espacosData =
            Map<String, dynamic>.from(event.snapshot.value as Map);

        return espacosData.entries.map((entry) {
          return {
            "nome": entry.key,
            "capacidade": entry.value["capacidade"],
            "disponibilidade": entry.value["disponibilidade"],
            "status": entry.value["status"],
          };
        }).toList();
      } else {
        print("Nenhum dado encontrado no nó 'espaços'.");
        return [];
      }
    } catch (e) {
      print("Erro ao carregar os espaços: $e");
      throw Exception('Erro ao carregar os espaços: $e');
    }
  }

  Future<void> atualizarStatus() async {
    try {
      // Referência ao nó 'espaços' no Firebase
      DatabaseReference espacosRef = _database.child("espaços");

      // Obter os dados do nó 'espaços'
      DatabaseEvent event = await espacosRef.once();

      if (event.snapshot.value != null) {
        // Converte os dados recebidos
        final Map<String, dynamic> espacosData =
            Map<String, dynamic>.from(event.snapshot.value as Map);

        // Itera pelos espaços para verificar a disponibilidade
        for (String key in espacosData.keys) {
          final espaco = espacosData[key] as Map<dynamic, dynamic>;

          // Verifica a disponibilidade
          if ((espaco["disponibilidade"] ?? 0) == 0) {
            // Atualiza o status para 'inativo'
            await espacosRef.child(key).update({"status": "inativo"});
            print("Status atualizado para 'inativo' para o espaço: $key");
          }
        }
      } else {
        print("Nenhum espaço encontrado no nó 'espaços'.");
      }
    } catch (e) {
      print("Erro ao atualizar status: $e");
      throw Exception('Erro ao atualizar status: $e');
    }
  }

  // Listener em tempo real para atualizar automaticamente quando houver mudanças
  void listenToChanges() {
    _database.child("espaços").onValue.listen((event) {
      if (event.snapshot.value != null) {
        final espacosData =
            Map<String, dynamic>.from(event.snapshot.value as Map);
        for (String key in espacosData.keys) {
          final espaco = espacosData[key] as Map<dynamic, dynamic>;
          if ((espaco["disponibilidade"] ?? 0) == 0) {
            _database.child("espaços/$key").update({"status": "inativo"});
            print(
                "Atualização em tempo real: espaço $key marcado como inativo.");
          }
        }
      }
    });
  }
}
