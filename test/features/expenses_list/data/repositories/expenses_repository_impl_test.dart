import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:safqah_assessment/features/expenses_list/data/data_sources/expenses_local_data_source.dart';
import 'package:safqah_assessment/features/expenses_list/data/models/expense_item_model.dart';
import 'package:safqah_assessment/features/expenses_list/data/repositories/expenses_repository_impl.dart';
import 'package:safqah_assessment/features/expenses_list/domain/entities/mapper/expense_item_mapper.dart';
import 'package:safqah_assessment/features/expenses_list/domain/repositories/expenses_repository.dart';

@GenerateNiceMocks([MockSpec<ExpensesLocalDataSource>()])
import 'expenses_repository_impl_test.mocks.dart';

void main() {
  late ExpensesLocalDataSource mocExpensesLocalDataSource;
  late ExpensesRepository repository;

  setUp(() {
    mocExpensesLocalDataSource = MockExpensesLocalDataSource();
    repository = ExpensesRepositoryImpl(mocExpensesLocalDataSource);
  });

  const id = 10;
  const name = 'food';
  const amount = 10.1;
  final date = DateTime.now();

  final addExpenseModel = ExpenseItemModel(
      name: name, amount: 10.1, dateTimestamp: date.millisecondsSinceEpoch);

  final editedExpenseModel = ExpenseItemModel(
      id: id,
      name: name,
      amount: 10.1,
      dateTimestamp: date.millisecondsSinceEpoch);

  test(
    'should delete Expense by id and return 1 as deleted item count',
    () async {
      // arrange
      when(mocExpensesLocalDataSource.deleteExpense(id))
          .thenAnswer((_) async => (1));
      // act
      final result = await repository.deleteItem(id);

      // assert
      expect(result, equals(right(1)));
      verify(mocExpensesLocalDataSource.deleteExpense(id));
    },
  );

  test(
    'should get all Expenses from Database',
    () async {
      // arrange
      when(mocExpensesLocalDataSource.getAllExpenses()).thenAnswer((_) async =>
          (List.of(
              [editedExpenseModel, editedExpenseModel, editedExpenseModel])));
      // act
      final result =
          (await repository.getAllExpenses()).fold((l) => l, (r) => r);

      // assert
      verify(mocExpensesLocalDataSource.getAllExpenses());
      expect(
          result,
          equals((List.of([
            editedExpenseModel.toEntity(),
            editedExpenseModel.toEntity(),
            editedExpenseModel.toEntity(),
          ]))));
    },
  );

  test(
    'should Update Expense and return count of changed items',
    () async {
      // arrange
      when(mocExpensesLocalDataSource.updateExpense(editedExpenseModel))
          .thenAnswer((_) async => 1);
      // act
      final result = (await repository.updateItem(id, name, amount, date))
          .fold((l) => l, (r) => r);

      // assert
      expect(result, equals(editedExpenseModel.toEntity()));
      verify(mocExpensesLocalDataSource.updateExpense(editedExpenseModel));
    },
  );

  test(
    'should add Expense and return id of added items',
    () async {
      // arrange
      when(mocExpensesLocalDataSource.addExpense(addExpenseModel))
          .thenAnswer((_) async => id);
      // act
      final result = (await repository.insertItem(name, amount, date))
          .fold((l) => l, (r) => r);

      // assert
      expect(result, editedExpenseModel.toEntity());
      verify(mocExpensesLocalDataSource.addExpense(addExpenseModel));
    },
  );
}
