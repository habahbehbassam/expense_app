import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/expense_item_entity.dart';

class ExpenseListWidget extends StatelessWidget {
  const ExpenseListWidget(
      {Key? key,
      required this.expensesList,
      required this.deleteExpense,
      required this.updateExpense})
      : super(key: key);

  final List<ExpenseItemEntity> expensesList;
  final Function(ExpenseItemEntity itemEntity, int index) deleteExpense;
  final Function(ExpenseItemEntity itemEntity, int index) updateExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expensesList.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(expensesList[index].id?.toString() ?? ''),
          direction: DismissDirection.horizontal,
          background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: const Icon(Icons.delete, color: Colors.white),
              )),
          onDismissed: (direction) async {
            deleteExpense(expensesList[index], index);
          },
          child: ListTile(
            onLongPress: () {
              updateExpense(expensesList[index], index);
            },
            title: Text(expensesList[index].name),
            subtitle: Text(DateFormat.yMd().format(expensesList[index].date)),
            trailing: Text(
                "\$ ${expensesList[index].dollars}.${expensesList[index].cents}"),
          ),
        );
      },
    );
  }
}
