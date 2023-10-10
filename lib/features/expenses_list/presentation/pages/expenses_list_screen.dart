import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';
import 'package:safqah_assessment/features/expenses_list/presentation/providers/expenses_list_provider.dart';
import 'package:safqah_assessment/features/expenses_list/presentation/widgets/Expense_list_widget.dart';
import 'package:safqah_assessment/features/expenses_list/presentation/widgets/add_expense_widget.dart';

import '../dialogs/add_expense_dialog.dart';
import '../widgets/expense_list_appbar.dart';

class ExpensesListScreen extends StatefulWidget {
  const ExpensesListScreen({Key? key}) : super(key: key);

  @override
  State<ExpensesListScreen> createState() => _ExpensesListScreenState();
}

class _ExpensesListScreenState extends State<ExpensesListScreen> {
  bool firstTime = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpensesListProvider>(
      builder: (context, provider, child) {
        if (firstTime) {
          provider.loadExpensesItems();
          firstTime = false;
        }

        return Scaffold(
          appBar: ExpenseListAppBar(
            onFilterByDateClicked: () {
              showMonthPicker(
                context: context,
                initialDate: provider.filteredMonth,
                lastDate: DateTime.now(),
                cancelWidget: const Text('Clear'),
              ).then((date) {
                provider.loadExpensesForThisMonth(date);
              });
            },
          ),
          body: ExpenseListWidget(
            updateExpense: (itemEntity, index) {
              showDialog(
                context: context,
                builder: (context) {
                  return AddExpenseDialog(
                    selectedItem: itemEntity,
                    onSaveClicked: (name, dollars, cents, date) async {
                      final response = await provider.updateExpense(
                        index,
                        itemEntity.id ?? -1,
                        name,
                        dollars,
                        cents,
                        date,
                      );

                      handleProviderResponse(response);
                      return response ==
                          ExpensesListProviderActions.success;
                    },
                  );
                },
              );
            },
            expensesList: provider.getAllExpenses(),
            deleteExpense: (itemEntity, index) async {
              final response = await provider.deleteExpense(
                  index, provider.getAllExpenses()[index].id!);
              handleProviderResponse(response);
            },
          ),
          floatingActionButton: AddExpenseWidget(
            onSaveClicked: (name, dollars, cents, date) async {
              final response = await provider.addExpense(
                name,
                dollars,
                cents,
                date,
              );

              handleProviderResponse(response);
              return response == ExpensesListProviderActions.success;
            },
          ),
        );
      },
    );
  }

  void handleProviderResponse(ExpensesListProviderActions response) {
    switch (response) {
      case ExpensesListProviderActions.showNameNotValidMessage:
        showSnackMessage(
          context,
          "Name Can't be Empty!",
        );
        break;
      case ExpensesListProviderActions.showAmountNotValidMessage:
        showSnackMessage(
          context,
          "Amount Can't be Empty!",
        );
        break;
      case ExpensesListProviderActions.showDateNotValidMessage:
        showSnackMessage(
          context,
          "Kindly Select Date",
        );
        break;
      case ExpensesListProviderActions.showIdNotValidMessage:
        showSnackMessage(
          context,
          "Something Went wrong kindly try again later",
        );
        break;
      case ExpensesListProviderActions.showGeneralFailedMessage:
        showSnackMessage(
          context,
          "Something Went wrong kindly try again later",
        );
        break;
      case ExpensesListProviderActions.showExpenseDeleteItSuccessfullyMessage:
        showSnackMessage(
          context,
          "Expense Deleted Successfully",
        );
        break;
      default:
        log('Response Not Supported + $response');
        break;
    }
  }

  void showSnackMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
