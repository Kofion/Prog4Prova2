import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String label;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final double? fontSize;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final bool isPasswordField;

  const CustomTextFormField({
    super.key,
    required this.label,
    this.floatingLabelBehavior,
    this.fontSize,
    this.validator,
    this.controller,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.isPasswordField = false,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPasswordField;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: TextFormField(
        controller: widget.controller,
        cursorColor: Colors.black,
        cursorWidth: 1.0,
        obscureText: _obscureText,
        validator: widget.validator,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(),
          label: Text(
            widget.label,
            style: TextStyle(fontSize: widget.fontSize ?? 20),
          ),
          labelStyle: const TextStyle(color: Colors.black),
          floatingLabelBehavior:
              widget.floatingLabelBehavior ?? FloatingLabelBehavior.always,
          suffixIcon: widget.isPasswordField
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : (widget.suffixIcon != null
                  ? IconButton(
                      icon: Icon(widget.suffixIcon),
                      onPressed: widget.onSuffixIconPressed,
                    )
                  : null),
        ),
      ),
    );
  }
}
