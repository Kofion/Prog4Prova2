import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.black,
            height: 0.5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Logar com',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.black,
            height: 0.5,
          ),
        ),
      ],
    );
  }
}
