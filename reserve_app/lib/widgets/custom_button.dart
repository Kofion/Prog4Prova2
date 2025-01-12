import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final String? route;
  final VoidCallback onPressed;
  final String? imageIcon;
  final Color? backgroundColor;
  final Color? labelColor;
  final Color? borderColor;
  final EdgeInsets? margin;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.route,
    this.imageIcon,
    this.backgroundColor,
    this.labelColor,
    this.borderColor,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? Colors.blue,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            side: BorderSide(color: borderColor ?? Colors.transparent)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (imageIcon != null)
              Image.asset(
                imageIcon!,
                height: 26,
                width: 26,
                fit: BoxFit.contain,
              )
            else
              const SizedBox(width: 0),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: labelColor ?? Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
