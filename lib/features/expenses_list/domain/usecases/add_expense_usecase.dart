import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:safqah_assessment/core/error/failures.dart';
import 'package:safqah_assessment/core/usecases/usecase.dart';
import 'package:safqah_assessment/features/expenses_list/domain/entities/expense_item_entity.dart';
import 'package:safqah_assessment/features/expenses_list/domain/repositories/expenses_repository.dart';

class AddExpenseUsecase extends UseCase<ExpenseItemEntity, AddExpenseParam> {
  AddExpenseUsecase(this._repository);

  final ExpensesRepository _repository;

  @override
  Future<Either<Failure, ExpenseItemEntity>> call(
      AddExpenseParam params) async {
    if (params.amount < 1) {
      return left(ExpenseAmountNotValidFailure());
    } else if (params.name.trim().isEmpty) {
      return left(ExpenseNameNotValidFailure());
    } else if (params.date.isAfter(DateTime.now())) {
      return left(ExpenseDateNotValidFailure());
    }

    return await _repository.insertItem(
      params.name,
      params.amount,
      params.date,
    )!;
  }
}

class AddExpenseParam extends Equatable{
  const AddExpenseParam(this.name, this.amount, this.date);

  final String name;
  final double amount;
  final DateTime date;

  @override
  List<Object?> get props => [name,amount,date];
}
