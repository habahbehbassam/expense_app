import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:safqah_assessment/features/expenses_list/domain/repositories/expenses_repository.dart';
import 'package:safqah_assessment/features/expenses_list/domain/usecases/delete_expense_usecase.dart';

class MocExpenseRepository extends Mock implements ExpensesRepository {}

void main() {
  late MocExpenseRepository mocExpenseRepository;
  late DeleteExpenseUsecase usecase;

  setUp(() {
    mocExpenseRepository = MocExpenseRepository();
    usecase = DeleteExpenseUsecase(mocExpenseRepository);
  });

  const id = 10;

  test(
    'should delete Expense by ID and return 1 (1 mean count of deleted items)',
        () async {
      // arrange
      when(mocExpenseRepository.deleteItem(id))
          .thenAnswer((_) async => right(1));

      // act
      final result =
      await usecase.call(DeleteExpenseParam(id));
      // assert
      expect(result, right(1));
      verify(mocExpenseRepository.deleteItem(id));
      verifyNoMoreInteractions(mocExpenseRepository);
    },
  );
}
