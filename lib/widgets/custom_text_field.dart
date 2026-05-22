import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_theme.dart';

/// Campo de texto reutilizable con estilo consistente para la aplicación.
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final String? helperText;
  final int? maxLength;
  final bool autofocus;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.helperText,
    this.maxLength,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      autofocus: autofocus,
      maxLength: maxLength,
      style: const TextStyle(
        color: AppTheme.textPrimary,
        fontSize: 15,
        fontFamily: 'monospace',
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        helperStyle: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
        counterStyle: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12, right: 8),
          child: Icon(icon, size: 18, color: AppTheme.textSecondary),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 40),
      ),
      validator: validator,
    );
  }
}
