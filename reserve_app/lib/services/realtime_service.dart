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
      return [];
    }
  }

  Future<void> atualizarStatus() async {
    try {
      DatabaseReference espacosRef = _database.child("espaços");

      DatabaseEvent event = await espacosRef.once();

      if (event.snapshot.value != null) {
        final Map<String, dynamic> espacosData =
            Map<String, dynamic>.from(event.snapshot.value as Map);

        for (String key in espacosData.keys) {
          final espaco = espacosData[key] as Map<dynamic, dynamic>;

          if ((espaco["disponibilidade"] ?? 0) == 0) {
            await espacosRef.child(key).update({"status": "inativo"});
            print("Status atualizado para 'inativo' para o espaço: $key");
          }
        }
      } else {
        print("Nenhum espaço encontrado no nó 'espaços'.");
      }
    } catch (e) {
      print("Erro ao atualizar status: $e");
    }
  }

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

  Stream<List<Map<String, dynamic>>> streamReservas() {
    return _database.child("reservas").onValue.map((event) {
      final reservasData =
          Map<String, dynamic>.from(event.snapshot.value as Map);

      reservasData.forEach((key, reservaInfo) {
        reservaInfo = Map<String, dynamic>.from(reservaInfo);

        final horariosLivres = reservaInfo["horarios_livres"] as List?;
        final disponibilidade = horariosLivres?.length ?? 0;

        if (disponibilidade == 0) {
          _database.child("reservas/$key").update({"status": "inativo"});
          print("Espaço $key marcado como inativo.");
        } else {
          _database.child("reservas/$key").update({"status": "ativo"});
          print("Espaço $key marcado como ativo.");
        }
      });

      return reservasData.entries.map((entry) {
        final reservaInfo = Map<String, dynamic>.from(entry.value as Map);

        return {
          "nome": reservaInfo["nome"],
          "capacidade": reservaInfo["capacidade"],
          "status": reservaInfo["status"],
          "disponibilidade":
              (reservaInfo["horarios_livres"] as List?)?.length ?? 0,
        };
      }).toList();
    });
  }

  Future<void> atualizarHorariosLivres() async {
    try {
      print("Chamando a função atualizarHorariosLivres()...");

      DatabaseReference reservasRef = _database.child("reservas");

      DatabaseEvent event = await reservasRef.once();

      if (event.snapshot.value != null) {
        final Map<String, dynamic> reservasData =
            Map<String, dynamic>.from(event.snapshot.value as Map);

        for (String key in reservasData.keys) {
          final reserva = reservasData[key] as Map<dynamic, dynamic>;

          final List<dynamic> horariosReservados =
              reserva["horarios_reservados"] ?? [];

          List<dynamic> horariosLivres = reserva["horarios_livres"] ?? [];

          horariosLivres
              .removeWhere((horario) => horariosReservados.contains(horario));

          await reservasRef.child(key).update({
            "horarios_livres": horariosLivres,
          });

          print("Horários livres atualizados para a reserva: $key");
        }
      } else {
        print("Nenhuma reserva encontrada no nó 'reservas'.");
      }
    } catch (e) {
      print("Erro ao atualizar horários livres: $e");
    }
  }
}
