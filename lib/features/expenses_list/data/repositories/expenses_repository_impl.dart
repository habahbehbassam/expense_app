import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:safqah_assessment/core/error/failures.dart';
import 'package:safqah_assessment/features/expenses_list/data/data_sources/expenses_local_data_source.dart';
import 'package:safqah_assessment/features/expenses_list/data/models/expense_item_model.dart';
import 'package:safqah_assessment/features/expenses_list/domain/entities/expense_item_entity.dart';
import 'package:safqah_assessment/features/expenses_list/domain/entities/mapper/expense_item_mapper.dart';
import '../../domain/repositories/expenses_repository.dart';

class ExpensesRepositoryImpl extends ExpensesRepository {
  ExpensesRepositoryImpl(this._localDataSource);

  final ExpensesLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, int>> deleteItem(int id) async {
    try {
      return right(await _localDataSource.deleteExpense(id));
    } catch (e) {
      log('Delete Expense Error ----> ${e.toString()}');
      return left(DeleteItemFailure());
    }
  }

  @override
  Future<Either<Failure, List<ExpenseItemEntity>>> getAllExpenses() async {
    try {
      final items = await _localDataSource.getAllExpenses();
      return right(items.map((model) => model.toEntity()).toList());
    } catch (e) {
      log('Get Expenses Error ----> ${e.toString()}');
      return left(GetItemsFailure());
    }
  }

  @override
  Future<Either<Failure, ExpenseItemEntity>> insertItem(
      String name, double amount, DateTime date) async {
    try {
      final itemId = await _localDataSource.addExpense(
        ExpenseItemModel(
            name: name,
            amount: amount,
            dateTimestamp: date.millisecondsSinceEpoch),
      );

      return right(
        ExpenseItemEntity(
          name: name,
          dollars: amount.toInt(),
          cents: amount.toInt(),
          date: date,
          id: itemId,
        ),
      );
    } catch (e) {
      log('Insert Expense Error ----> ${e.toString()}');
      return left(InsertItemFailure());
    }
  }

  @override
  Future<Either<Failure, ExpenseItemEntity>> updateItem(
      int id, String name, double amount, DateTime date) async {
    try {

      await _localDataSource.updateExpense(
        ExpenseItemModel(
          id: id,
          name: name,
          amount: amount,
          dateTimestamp: date.millisecondsSinceEpoch,
        ),
      );

      return right(
        ExpenseItemEntity(
          name: name,
          dollars: amount.toInt(),
          cents: amount.toInt(),
          date: date,
          id: id,
        ),
      );
    } catch (e) {
      log('Update Expense Error ----> ${e.toString()}');
      return left(UpdateItemFailure());
    }
  }
}
