import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:safqah_assessment/core/usecases/usecase.dart';
import 'package:safqah_assessment/features/expenses_list/domain/entities/expense_item_entity.dart';
import 'package:safqah_assessment/features/expenses_list/domain/repositories/expenses_repository.dart';
import 'package:safqah_assessment/features/expenses_list/domain/usecases/get_expense_usecase.dart';

@GenerateNiceMocks([MockSpec<ExpensesRepository>()])
import 'get_expense_usecase_test.mocks.dart';

void main() {
  late ExpensesRepository mocExpenseRepository;
  late GetExpensesUsecase usecase;

  setUp(() {
    mocExpenseRepository = MockExpensesRepository();
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
          [expenseEntity, expenseEntity, expenseEntity],
        ),
      );

      // act
      final result = (await usecase.call(NoParams())).fold((l) => l, (r) => r);
      // assert
      verify(mocExpenseRepository.getAllExpenses());
      expect(result, equals(([expenseEntity, expenseEntity, expenseEntity])));
      verifyNoMoreInteractions(mocExpenseRepository);
    },
  );
}
