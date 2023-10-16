import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:safqah_assessment/core/error/failures.dart';
import 'package:safqah_assessment/core/usecases/usecase.dart';
import 'package:safqah_assessment/features/expenses_list/domain/repositories/expenses_repository.dart';

class DeleteExpenseUsecase extends UseCase<int, DeleteExpenseParam> {
  DeleteExpenseUsecase(this._repository);

  final ExpensesRepository _repository;

  @override
  Future<Either<Failure, int>> call(DeleteExpenseParam params) async {
    if (params.id < 0) return left(ExpenseIdNotValidFailure());
    return await _repository.deleteItem(params.id);
  }
}

class DeleteExpenseParam extends Equatable{
  const DeleteExpenseParam(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}
