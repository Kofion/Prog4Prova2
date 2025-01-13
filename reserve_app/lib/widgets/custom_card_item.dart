import 'package:flutter/material.dart';

import '../app/app_routs.dart';
import '../app/styles_app.dart';
import '../services/realtime_service.dart';
import '../widgets/custom_button.dart';

class CardItem extends StatelessWidget {
  final RealtimeDatabaseService databaseService = RealtimeDatabaseService();
  final String name;
  final int capacity;
  final String availability;
  final String status;

  CardItem({
    super.key,
    required this.name,
    required this.capacity,
    required this.availability,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 170,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                spacing: 5,
                                children: [
                                  Text(
                                    'Capacidade: ',
                                    style: TextStylesManager.infos,
                                  ),
                                  Icon(
                                    Icons.people_alt,
                                    size: 18,
                                  ),
                                  Text(
                                    capacity.toString(),
                                    style: TextStylesManager.infos,
                                  ),
                                ],
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                spacing: 5,
                                children: [
                                  Text(
                                    'Disponibilidade: ',
                                    style: TextStylesManager.infos,
                                  ),
                                  Icon(
                                    Icons.access_time_filled,
                                    size: 18,
                                  ),
                                  Text(
                                    availability.toString(),
                                    style: TextStylesManager.infos,
                                  ),
                                ],
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                spacing: 5,
                                children: [
                                  Text(
                                    'Status: ',
                                    style: TextStylesManager.infos,
                                  ),
                                  Icon(_icon()),
                                  Text(
                                    _status(),
                                    style: TextStylesManager.infos,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomButton(
                        label: "Ver Detalhes",
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRouts.detailsPage,
                            arguments: {
                              'name': name,
                              'capacity': capacity,
                              'availability': availability,
                              'status': status,
                            },
                          );
                        },
                        margin: EdgeInsets.symmetric(vertical: 0),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _icon() {
    if (status == 'ativo') {
      return Icons.check_circle_outline_outlined;
    } else if (status == 'inativo') {
      return Icons.cancel_outlined;
    } else {
      return Icons.error;
    }
  }

  String _status() {
    if (status != 'ativo' && status != 'inativo') {
      return 'error';
    }
    return status;
  }
}
