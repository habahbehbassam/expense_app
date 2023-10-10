import 'package:dartz/dartz.dart';
import 'package:safqah_assessment/core/error/failures.dart';
import 'package:safqah_assessment/features/expenses_list/domain/entities/expense_item_entity.dart';

abstract class ExpensesRepository {
  Future<Either<Failure, List<ExpenseItemEntity>>> getAllExpenses();

  Future<Either<Failure, int>> deleteItem(int id);

  Future<Either<Failure, ExpenseItemEntity>> updateItem(
    int id,
    String name,
    double amount,
    DateTime date,
  );

  Future<Either<Failure, ExpenseItemEntity>> insertItem(
    String name,
    double amount,
    DateTime date,
  );
}
