import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:safqah_assessment/core/usecases/usecase.dart';
import 'package:safqah_assessment/features/expenses_list/domain/entities/expense_item_entity.dart';
import 'package:safqah_assessment/features/expenses_list/domain/usecases/add_expense_usecase.dart';
import 'package:safqah_assessment/features/expenses_list/domain/usecases/delete_expense_usecase.dart';
import 'package:safqah_assessment/features/expenses_list/domain/usecases/get_expense_usecase.dart';
import 'package:safqah_assessment/features/expenses_list/domain/usecases/update_expense_usecase.dart';

import '../../../../core/error/failures.dart';

enum ExpensesListProviderActions {
  showNameNotValidMessage,
  showAmountNotValidMessage,
  showDateNotValidMessage,
  showIdNotValidMessage,
  showGeneralFailedMessage,
  showExpenseDeleteItSuccessfullyMessage,
  success,
}

class ExpensesListProvider extends ChangeNotifier {
  ExpensesListProvider(
    this._addExpenseUsecase,
    this._deleteExpenseUsecase,
    this._getExpensesUsecase,
    this._updateExpenseUsecase,
  );

  final AddExpenseUsecase _addExpenseUsecase;
  final DeleteExpenseUsecase _deleteExpenseUsecase;
  final GetExpensesUsecase _getExpensesUsecase;
  final UpdateExpenseUsecase _updateExpenseUsecase;

  List<ExpenseItemEntity> _savedExpensesItems = [];
  List<ExpenseItemEntity> _expensesItems = [];

  DateTime filteredMonth = DateTime.now();

  List<ExpenseItemEntity> getAllExpenses() {
    _expensesItems.sort(
      (a, b) => b.date.compareTo(a.date),
    );
    return _expensesItems;
  }

  void loadExpensesItems() async {
    final response = await _getExpensesUsecase.call(NoParams());
    response.fold((left) {
      log('Failed To Load Expenses');
    }, (right) {
      _savedExpensesItems = right;
      _expensesItems = right;
      notifyListeners();
    });
  }

  Future<ExpensesListProviderActions> addExpense(
    String name,
    String dollars,
    String cents,
    DateTime date,
  ) async {
    final response = await _addExpenseUsecase.call(
      AddExpenseParam(
        name,
        double.tryParse('${dollars.trim()}.${cents.trim()}') ?? 0,
        date,
      ),
    );

    return response.fold((left) {
      if (left is ExpenseAmountNotValidFailure) {
        return ExpensesListProviderActions.showAmountNotValidMessage;
      } else if (left is ExpenseNameNotValidFailure) {
        return ExpensesListProviderActions.showNameNotValidMessage;
      } else if (left is ExpenseDateNotValidFailure) {
        return ExpensesListProviderActions.showDateNotValidMessage;
      }

      return ExpensesListProviderActions.showGeneralFailedMessage;
    }, (right) {
      _savedExpensesItems.add(right);
      _expensesItems.add(right);
      notifyListeners();
      return ExpensesListProviderActions.success;
    });
  }

  Future<ExpensesListProviderActions> updateExpense(
    int index,
    int id,
    String name,
      String dollars,
      String cents,
    DateTime date,
  ) async {
    final response = await _updateExpenseUsecase.call(
      UpdateExpenseParam(
        id,
        name,
        double.tryParse('${dollars.trim()}.${cents.trim()}') ?? 0,
        date,
      ),
    );

    return response.fold((left) {
      if (left is ExpenseIdNotValidFailure) {
        return ExpensesListProviderActions.showIdNotValidMessage;
      }
      if (left is ExpenseAmountNotValidFailure) {
        return ExpensesListProviderActions.showAmountNotValidMessage;
      } else if (left is ExpenseNameNotValidFailure) {
        return ExpensesListProviderActions.showNameNotValidMessage;
      } else if (left is ExpenseDateNotValidFailure) {
        return ExpensesListProviderActions.showDateNotValidMessage;
      }

      return ExpensesListProviderActions.showGeneralFailedMessage;
    }, (right) {
      _savedExpensesItems.removeAt(index);
      _savedExpensesItems.add(right);
      _expensesItems.removeAt(index);
      _expensesItems.add(right);
      notifyListeners();
      return ExpensesListProviderActions.success;
    });
  }

  Future<ExpensesListProviderActions> deleteExpense(
    int index,
    int id,
  ) async {
    final item = _expensesItems[index];

    _savedExpensesItems.removeAt(index);
    _expensesItems.removeAt(index);
    final response = await _deleteExpenseUsecase.call(
      DeleteExpenseParam(
        id,
      ),
    );

    return response.fold((left) {
      _savedExpensesItems.insert(index, item);
      _expensesItems.insert(index, item);
      if (left is ExpenseIdNotValidFailure) {
        return ExpensesListProviderActions.showIdNotValidMessage;
      }

      return ExpensesListProviderActions.showGeneralFailedMessage;
    }, (right) {
      notifyListeners();
      return ExpensesListProviderActions.showExpenseDeleteItSuccessfullyMessage;
    });
  }

  void loadExpensesForThisMonth(DateTime? date) {
    if(date!= null){
      filteredMonth = date;
      final items = _savedExpensesItems
          .where((e) => e.date.year == date.year && e.date.month == date.month)
          .toList();
      _expensesItems = items;
    }else {
      filteredMonth = DateTime.now();
      _expensesItems = _savedExpensesItems;
    }
    notifyListeners();
  }
}
