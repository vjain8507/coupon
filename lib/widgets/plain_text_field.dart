import 'package:flutter/material.dart';

class PlainTextField extends StatefulWidget {
  final TextEditingController textController;
  final String labelText;

  const PlainTextField(
      {super.key, required this.textController, required this.labelText});

  @override
  State<PlainTextField> createState() => _PlainTextFieldState();
}

class _PlainTextFieldState extends State<PlainTextField> {
  late TextEditingController textController;
  late String labelText;

  @override
  void initState() {
    super.initState();
    textController = widget.textController;
    labelText = widget.labelText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
      child: SizedBox(
        width: double.infinity,
        child: TextFormField(
          controller: textController,
          autofocus: true,
          autofillHints: const [AutofillHints.email],
          obscureText: false,
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
          ),
          style: const TextStyle(
            color: Color(0xFF101213),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          keyboardType: TextInputType.text,
        ),
      ),
    );
  }
}
