import 'package:flutter/material.dart';

class ExpenseListAppBar extends AppBar {
  ExpenseListAppBar({
    required this.onFilterByDateClicked,
    super.key,
  }) : super(
          title: const Text("Expenses List"),
          actions: [
            IconButton(
              icon: const Icon(Icons.date_range),
              tooltip: 'Filter By Date',
              onPressed:onFilterByDateClicked,
            ),
          ],
        );

  final VoidCallback onFilterByDateClicked;
}
