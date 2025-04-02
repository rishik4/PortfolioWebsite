import 'package:flutter/material.dart';

class TechTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final int maxLines;
  final String? Function(String?)? validator;

  const TechTextField({
    super.key,
    required this.controller,
    required this.label,
    this.maxLines = 1,
    this.validator,
  });

  @override
  State<TechTextField> createState() => _TechTextFieldState();
}

class _TechTextFieldState extends State<TechTextField> {
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 1,
            color: Colors.cyanAccent.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 5),
        Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              _hasFocus = hasFocus;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: _hasFocus
                    ? Colors.cyanAccent
                    : Colors.cyanAccent.withOpacity(0.3),
              ),
            ),
            child: TextFormField(
              controller: widget.controller,
              maxLines: widget.maxLines,
              style: const TextStyle(
                fontSize: 14,
                letterSpacing: 1,
                color: Colors.cyanAccent,
              ),
              cursorColor: Colors.cyanAccent,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                border: InputBorder.none,
                errorStyle: const TextStyle(
                  fontSize: 12,
                  letterSpacing: 0.5,
                  color: Colors.redAccent,
                ),
              ),
              validator: widget.validator,
            ),
          ),
        ),
      ],
    );
  }
}
