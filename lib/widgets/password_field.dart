import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController passwordTextController;
  final String labelText;

  const PasswordField(
      {super.key,
      required this.passwordTextController,
      required this.labelText});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool passwordVisibility = false;
  late TextEditingController passwordTextController;
  late String labelText;

  @override
  void initState() {
    super.initState();
    passwordTextController = widget.passwordTextController;
    labelText = widget.labelText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
      child: TextFormField(
        controller: passwordTextController,
        autofocus: false,
        obscureText: !passwordVisibility,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Color(0xFF57636C),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFFE0E3E7),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFF4B39EF),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(24),
          suffixIcon: InkWell(
            onTap: () {
              setState(() {
                passwordVisibility = !passwordVisibility;
              });
            },
            focusNode: FocusNode(skipTraversal: true),
            child: Icon(
              passwordVisibility
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: const Color(0xFF57636C),
              size: 24,
            ),
          ),
        ),
        style: const TextStyle(
          color: Color(0xFF101213),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
