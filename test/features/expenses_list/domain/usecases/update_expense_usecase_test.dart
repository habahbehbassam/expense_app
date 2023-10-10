import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:safqah_assessment/features/expenses_list/domain/entities/expense_item_entity.dart';
import 'package:safqah_assessment/features/expenses_list/domain/repositories/expenses_repository.dart';
import 'package:safqah_assessment/features/expenses_list/domain/usecases/update_expense_usecase.dart';

class MocExpenseRepository extends Mock implements ExpensesRepository {}

void main() {
  late MocExpenseRepository mocExpenseRepository;
  late UpdateExpenseUsecase usecase;

  setUp(() {
    mocExpenseRepository = MocExpenseRepository();
    usecase = UpdateExpenseUsecase(mocExpenseRepository);
  });

  const id = 10;
  const name = 'food';
  const amount = 10.1;
  final date = DateTime.now();

  final editedExpenseEntity =
      ExpenseItemEntity(id: id, name: name, dollars: 10, cents: 1, date: date);

  test(
    'should update Expense name',
    () async {
      // arrange
      when(mocExpenseRepository.updateItem(id, name, amount, date))
          .thenAnswer((_) async => right(editedExpenseEntity));

      // act
      final result =
          await usecase.call(UpdateExpenseParam(id, name, amount, date));
      // assert
      expect(result, right(editedExpenseEntity));
      verify(mocExpenseRepository.updateItem(id, name, amount, date));
      verifyNoMoreInteractions(mocExpenseRepository);
    },
  );
}
