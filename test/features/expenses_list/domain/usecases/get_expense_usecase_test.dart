import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:safqah_assessment/core/usecases/usecase.dart';
import 'package:safqah_assessment/features/expenses_list/domain/entities/expense_item_entity.dart';
import 'package:safqah_assessment/features/expenses_list/domain/repositories/expenses_repository.dart';
import 'package:safqah_assessment/features/expenses_list/domain/usecases/get_expense_usecase.dart';

class MocExpenseRepository extends Mock implements ExpensesRepository {}

void main() {
  late MocExpenseRepository mocExpenseRepository;
  late GetExpensesUsecase usecase;

  setUp(() {
    mocExpenseRepository = MocExpenseRepository();
    usecase = GetExpensesUsecase(mocExpenseRepository);
  });

  const id = 10;
  const name = 'food';
  final date = DateTime.now();

  final expenseEntity =
      ExpenseItemEntity(id: id, name: name, dollars: 10, cents: 1, date: date);

  test(
    'should Get All Expenses',
    () async {
      // arrange
      when(mocExpenseRepository.getAllExpenses()).thenAnswer(
        (_) async => right(
          List.of([expenseEntity, expenseEntity, expenseEntity]),
        ),
      );

      // act
      final result =
          await usecase.call(NoParams());
      // assert
      expect(result, right(List.of([expenseEntity, expenseEntity, expenseEntity])));
      verify(mocExpenseRepository.getAllExpenses());
      verifyNoMoreInteractions(mocExpenseRepository);
    },
  );
}
