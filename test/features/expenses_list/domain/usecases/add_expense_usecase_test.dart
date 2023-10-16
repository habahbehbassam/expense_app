import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:safqah_assessment/features/expenses_list/domain/entities/expense_item_entity.dart';
import 'package:safqah_assessment/features/expenses_list/domain/repositories/expenses_repository.dart';
import 'package:safqah_assessment/features/expenses_list/domain/usecases/add_expense_usecase.dart';


@GenerateNiceMocks([MockSpec<ExpensesRepository>()])
import 'add_expense_usecase_test.mocks.dart';

void main() {
  late ExpensesRepository mocExpenseRepository;
  late AddExpenseUsecase usecase;

  setUp(() {
    mocExpenseRepository = MockExpensesRepository();
    usecase = AddExpenseUsecase(mocExpenseRepository);
  });

  const name = 'food';
  const amount = 10.1;
  final date = DateTime.now();

  final addedExpenseEntity =
  ExpenseItemEntity(id: 10, name: name, dollars: 10, cents: 1, date: date);

  test(
    'should Add Expense',
        () async {
      // arrange
      when(mocExpenseRepository.insertItem(name, amount, date))
          .thenAnswer((_) async => right(addedExpenseEntity));

      // act
      final result =
      await usecase.call(AddExpenseParam(name, amount, date));
      // assert
      expect(result, right(addedExpenseEntity));
      verify(mocExpenseRepository.insertItem( name, amount, date));
      verifyNoMoreInteractions(mocExpenseRepository);
    },
  );
}
