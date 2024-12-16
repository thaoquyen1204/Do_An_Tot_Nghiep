import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  PasswordField({required this.controller, required this.label});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 6,
          color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.lock, color: Colors.green[800]),
              SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: widget.label,
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.green[800],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.green[800],
                ),
                onPressed: _togglePasswordVisibility,
              ),
            ],
          ),
        ),
      ),
    );
  }
}