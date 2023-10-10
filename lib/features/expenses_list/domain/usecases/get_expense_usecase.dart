import 'package:dartz/dartz.dart';
import 'package:safqah_assessment/core/error/failures.dart';
import 'package:safqah_assessment/core/usecases/usecase.dart';
import 'package:safqah_assessment/features/expenses_list/domain/entities/expense_item_entity.dart';
import 'package:safqah_assessment/features/expenses_list/domain/repositories/expenses_repository.dart';

class GetExpensesUsecase extends UseCase<List<ExpenseItemEntity>, NoParams> {
  GetExpensesUsecase(this._repository);

  final ExpensesRepository _repository;

  @override
  Future<Either<Failure, List<ExpenseItemEntity>>> call(
      NoParams params) async {
    return await _repository.getAllExpenses();
  }
}
