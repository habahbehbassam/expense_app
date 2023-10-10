import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:safqah_assessment/core/error/failures.dart';
import 'package:safqah_assessment/features/expenses_list/domain/entities/expense_item_entity.dart';
import 'package:safqah_assessment/features/expenses_list/domain/usecases/add_expense_usecase.dart';
import 'package:safqah_assessment/features/expenses_list/domain/usecases/delete_expense_usecase.dart';
import 'package:safqah_assessment/features/expenses_list/domain/usecases/get_expense_usecase.dart';
import 'package:safqah_assessment/features/expenses_list/domain/usecases/update_expense_usecase.dart';
import 'package:safqah_assessment/features/expenses_list/presentation/providers/expenses_list_provider.dart';

class MockAddExpenseUsecase extends Mock implements AddExpenseUsecase {}

class MockDeleteExpenseUsecase extends Mock implements DeleteExpenseUsecase {}

class MockUpdateExpenseUsecase extends Mock implements UpdateExpenseUsecase {}

class MockGetExpensesUsecase extends Mock implements GetExpensesUsecase {}

void main() {
  late MockAddExpenseUsecase mockAddExpenseUsecase;
  late MockDeleteExpenseUsecase mockDeleteExpenseUsecase;
  late MockUpdateExpenseUsecase mockUpdateExpenseUsecase;

  late ExpensesListProvider provider;

  setUp(
    () {
      mockAddExpenseUsecase = MockAddExpenseUsecase();
      mockDeleteExpenseUsecase = MockDeleteExpenseUsecase();
      mockUpdateExpenseUsecase = MockUpdateExpenseUsecase();

      provider = ExpensesListProvider(
        mockAddExpenseUsecase,
        mockDeleteExpenseUsecase,
        MockGetExpensesUsecase(),
        mockUpdateExpenseUsecase,
      );
    },
  );

  const id = 10;
  const name = 'food';
  const dollars = '10';
  const cents = '1';
  final amount = double.tryParse('${dollars.trim()}.${cents.trim()}') ?? 0;
  final date = DateTime.now();

  final expenseEntity =
      ExpenseItemEntity(id: id, name: name, dollars: 10, cents: 1, date: date);

  group('Test Add Expense', () {
    test('Add Expense Successfully', () async {
      // arrange
      when(mockAddExpenseUsecase.call(AddExpenseParam(name, amount, date)))
          .thenAnswer((_) async => right(expenseEntity));

      // act
      final result = await provider.addExpense(name, dollars, cents, date);

      // assert
      verify(mockAddExpenseUsecase.call(AddExpenseParam(name, amount, date)));
      expect(result, ExpensesListProviderActions.success);
    });

    test('Add Expense with empty name', () async {
      // arrange
      when(mockAddExpenseUsecase.call(AddExpenseParam('', amount, date)))
          .thenAnswer((_) async => left(ExpenseNameNotValidFailure()));

      // act
      final result = await provider.addExpense('', dollars, cents, date);

      // assert
      verify(mockAddExpenseUsecase.call(AddExpenseParam('', amount, date)));
      expect(result, ExpensesListProviderActions.showNameNotValidMessage);
    });

    test('Add Expense with < 1 amount', () async {
      // arrange
      when(mockAddExpenseUsecase.call(AddExpenseParam(name, 0, date)))
          .thenAnswer((_) async => left(ExpenseAmountNotValidFailure()));

      // act
      final result = await provider.addExpense(name, '', '', date);

      // assert
      verify(mockAddExpenseUsecase.call(AddExpenseParam(name, 0, date)));
      expect(result, ExpensesListProviderActions.showAmountNotValidMessage);
    });

    test('Add Expense with invalid date', () async {
      // arrange
      when(mockAddExpenseUsecase.call(AddExpenseParam(
              name, amount, date.add(const Duration(days: 10)))))
          .thenAnswer((_) async => left(ExpenseDateNotValidFailure()));

      // act
      final result = await provider.addExpense(
        name,
        dollars,
        cents,
        date.add(const Duration(days: 10)),
      );

      // assert
      verify(mockAddExpenseUsecase.call(
          AddExpenseParam(name, amount, date.add(const Duration(days: 10)))));
      expect(result, ExpensesListProviderActions.showDateNotValidMessage);
    });
  });

  group('Test Update Expense', () {
    test('Update Expense Successfully', () async {
      // arrange
      when(mockUpdateExpenseUsecase
              .call(UpdateExpenseParam(id, name, amount, date)))
          .thenAnswer((_) async => right(expenseEntity));

      // act
      final result =
          await provider.updateExpense(0, id, name, dollars, cents, date);

      // assert
      verify(mockUpdateExpenseUsecase
          .call(UpdateExpenseParam(id, name, amount, date)));
      expect(result, ExpensesListProviderActions.success);
    });

    test('Update Expense with ID < 1', () async {
      // arrange
      when(mockUpdateExpenseUsecase
              .call(UpdateExpenseParam(0, name, amount, date)))
          .thenAnswer((_) async => left(ExpenseIdNotValidFailure()));

      // act
      final result =
          await provider.updateExpense(0, 0, name, dollars, cents, date);

      // assert
      verify(mockUpdateExpenseUsecase
          .call(UpdateExpenseParam(id, '', amount, date)));
      expect(result, ExpensesListProviderActions.showIdNotValidMessage);
    });

    test('Update Expense with empty name', () async {
      // arrange
      when(mockUpdateExpenseUsecase
              .call(UpdateExpenseParam(id, '', amount, date)))
          .thenAnswer((_) async => right(expenseEntity));

      // act
      final result =
          await provider.updateExpense(0, id, '', dollars, cents, date);

      // assert
      verify(mockUpdateExpenseUsecase
          .call(UpdateExpenseParam(id, '', amount, date)));
      expect(result, ExpensesListProviderActions.showNameNotValidMessage);
    });

    test('update Expense with < 1 amount', () async {
      // arrange
      when(mockUpdateExpenseUsecase.call(UpdateExpenseParam(id, name, 0, date)))
          .thenAnswer((_) async => right(expenseEntity));

      // act
      final result = await provider.updateExpense(0, id, name, '', '', date);

      // assert
      verify(
          mockUpdateExpenseUsecase.call(UpdateExpenseParam(id, name, 0, date)));
      expect(result, ExpensesListProviderActions.showAmountNotValidMessage);
    });

    test('Add Expense with invalid date', () async {
      // arrange
      when(mockUpdateExpenseUsecase.call(UpdateExpenseParam(
              id, name, amount, date.add(const Duration(days: 10)))))
          .thenAnswer((_) async => right(expenseEntity));

      // act
      final result = await provider.updateExpense(
          0, id, name, dollars, cents, date.add(const Duration(days: 10)));

      // assert
      verify(mockUpdateExpenseUsecase.call(UpdateExpenseParam(
          id, name, amount, date.add(const Duration(days: 10)))));
      expect(result, ExpensesListProviderActions.showDateNotValidMessage);
    });
  });

  group('Test Delete Expense', () {
    test('Delete Expense with id <1', () async {
      // arrange
      when(mockDeleteExpenseUsecase.call(DeleteExpenseParam(0)))
          .thenAnswer((_) async => left(ExpenseIdNotValidFailure()));

      // act
      final result = await provider.deleteExpense(0, id);

      // assert
      verify(mockDeleteExpenseUsecase.call(DeleteExpenseParam(id)));
      expect(result, ExpensesListProviderActions.success);
    });

    test('Delete Expense with id <1', () async {
      // arrange
      when(mockDeleteExpenseUsecase.call(DeleteExpenseParam(0)))
          .thenAnswer((_) async => left(ExpenseIdNotValidFailure()));

      // act
      final result = await provider.deleteExpense(0, 0);

      // assert
      verify(mockDeleteExpenseUsecase.call(DeleteExpenseParam(0)));
      expect(result, ExpensesListProviderActions.showIdNotValidMessage);
    });
  });
}
