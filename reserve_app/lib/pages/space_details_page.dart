import 'package:flutter/material.dart';
import '../widgets/custom_select_date.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({
    super.key,
    required this.name,
    required this.capacity,
    required this.availability,
    required this.status,
  });

  final String name;
  final int capacity;
  final int availability;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: Colors.blue.shade300,
            border: Border(
              bottom: BorderSide(
                width: 10,
                color: Colors.white,
              ),
            ),
          ),
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.blue.shade100,
            child: Padding(
              padding: EdgeInsets.only(top: 12, left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'capacidade: ${capacity.toString()} pessoas',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blueGrey,
                    ),
                  ),
                  Text(
                    'disponibilidade: ${availability.toString()}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blueGrey,
                    ),
                  ),
                  Text(
                    'status: $status',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blueGrey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    child: SelectDate(),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
