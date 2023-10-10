import 'package:flutter/material.dart';

class ExpenseTextFieldWidget extends StatelessWidget {
  const ExpenseTextFieldWidget({
    Key? key,
    required this.controller,
    required this.labelText,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);

  final TextEditingController controller;
  final String labelText;
  final bool readOnly;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: onTap,
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
      ),
    );
  }
}
