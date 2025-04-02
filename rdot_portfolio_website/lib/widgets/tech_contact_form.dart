import 'package:flutter/material.dart';
import 'tech_text_field.dart';
import 'tech_button.dart';

class TechContactForm extends StatefulWidget {
  const TechContactForm({super.key});

  @override
  State<TechContactForm> createState() => _TechContactFormState();
}

class _TechContactFormState extends State<TechContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "EXECUTE MESSAGE",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TechTextField(
                  controller: _nameController,
                  label: "NAME",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: TechTextField(
                  controller: _emailController,
                  label: "EMAIL",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return 'Invalid format';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TechTextField(
            controller: _messageController,
            label: "MESSAGE",
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TechButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Message sent successfully.'),
                    backgroundColor: Colors.black,
                  ),
                );
                _nameController.clear();
                _emailController.clear();
                _messageController.clear();
              }
            },
            label: "EXECUTE",
          ),
        ],
      ),
    );
  }
}
