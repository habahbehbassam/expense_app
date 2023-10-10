import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:safqah_assessment/features/expenses_list/domain/entities/expense_item_entity.dart';

import '../widgets/expense_textfield_widget.dart';

class AddExpenseDialog extends StatefulWidget {
  const AddExpenseDialog({
    Key? key,
    required this.onSaveClicked,
    this.selectedItem,
  }) : super(key: key);

  final ExpenseItemEntity? selectedItem;
  final Future<bool> Function(
      String name, String dollars, String cents, DateTime date) onSaveClicked;

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  DateTime selectedDate =  DateTime.now();

  final nameController = TextEditingController();

  final dateController =
      TextEditingController(text: DateFormat.yMd().format(DateTime.now()));

  final dollarsController = TextEditingController();

  final centController = TextEditingController();

  @override
  void initState() {
    super.initState();

    selectedDate =  widget.selectedItem?.date ?? DateTime.now();
    nameController.text = widget.selectedItem?.name ?? '';
    dateController.text = DateFormat.yMd().format(selectedDate);
    dollarsController.text = widget.selectedItem?.dollars.toString() ?? '';
    centController.text = widget.selectedItem?.cents.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Expense'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ExpenseTextFieldWidget(
                  controller: nameController,
                  labelText: 'Name',
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: ExpenseTextFieldWidget(
                  onTap: () {
                    _selectDate(context);
                  },
                  controller: dateController,
                  labelText: 'Date',
                  readOnly: true,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ExpenseTextFieldWidget(
                  controller: dollarsController,
                  labelText: 'Dollars',
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: ExpenseTextFieldWidget(
                  controller: centController,
                  labelText: 'Cent',
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        MaterialButton(
          child: const Text('Save'),
          onPressed: () async {
            final shouldCloseDialog = await widget.onSaveClicked(
              nameController.text,
              dollarsController.text,
              centController.text,
              selectedDate,
            );

            if (shouldCloseDialog && context.mounted) Navigator.pop(context);
          },
        ),
        MaterialButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );
    if (selected != null) {
      setState(() {
        selectedDate = selected;
        dateController.text = DateFormat.yMd().format(selectedDate);
      });
    }
  }
}
