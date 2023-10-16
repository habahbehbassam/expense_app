import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:safqah_assessment/core/error/failures.dart';
import 'package:safqah_assessment/core/usecases/usecase.dart';
import 'package:safqah_assessment/features/expenses_list/domain/entities/expense_item_entity.dart';
import 'package:safqah_assessment/features/expenses_list/domain/repositories/expenses_repository.dart';

class UpdateExpenseUsecase
    extends UseCase<ExpenseItemEntity, UpdateExpenseParam> {
  UpdateExpenseUsecase(this._repository);

  final ExpensesRepository _repository;

  @override
  Future<Either<Failure, ExpenseItemEntity>> call(
      UpdateExpenseParam params) async {

    if (params.id < 0) {
      return left(ExpenseIdNotValidFailure());
    } else if (params.amount < 1) {
      return left(ExpenseAmountNotValidFailure());
    } else if (params.name.trim().isEmpty) {
      return left(ExpenseNameNotValidFailure());
    } else if (params.date.isAfter(DateTime.now())) {
      return left(ExpenseDateNotValidFailure());
    }

    return await _repository.updateItem(
      params.id,
      params.name,
      params.amount,
      params.date,
    );
  }
}

class UpdateExpenseParam  extends Equatable{
  const UpdateExpenseParam(this.id, this.name, this.amount, this.date);

  final int id;
  final String name;
  final double amount;
  final DateTime date;

  @override
  List<Object?> get props => [id,name,amount,date];
}
