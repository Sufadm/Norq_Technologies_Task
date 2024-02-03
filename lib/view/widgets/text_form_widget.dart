import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final TextEditingController? controller;
  final VoidCallback? ontap;
  final String? initialvalue;
  const TextFormFieldWidget({
    Key? key,
    required this.hintText,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.maxLength,
    this.controller,
    this.ontap,
    required,
    this.initialvalue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialvalue,
      onTap: ontap,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        // hintStyle: GoogleFonts.lato(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.grey,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 17),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      maxLength: maxLength,
    );
  }
}
