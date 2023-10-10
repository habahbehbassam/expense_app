import 'package:flutter/material.dart';

import '../dialogs/add_expense_dialog.dart';

class AddExpenseWidget extends StatelessWidget {
  const AddExpenseWidget({Key? key, required this.onSaveClicked}) : super(key: key);

  final Future<bool> Function(String name, String dollars, String cents, DateTime date)
  onSaveClicked;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AddExpenseDialog(
              onSaveClicked: onSaveClicked,
            );
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
