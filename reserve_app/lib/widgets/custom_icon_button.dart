import 'package:flutter/material.dart';


class CustomIconButton extends StatelessWidget {
  final String route;
  final String label;
  final IconData icon;

  const CustomIconButton({
    super.key,
    required this.route,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(route);
            },
            icon: Column(
              children: [
                Icon(icon, color: Colors.white, size: 30),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ))
      ],
    );
  }
}
