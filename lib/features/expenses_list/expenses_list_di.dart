import 'package:get_it/get_it.dart';
import 'package:safqah_assessment/features/expenses_list/data/data_sources/expenses_local_data_source.dart';
import 'package:safqah_assessment/features/expenses_list/domain/usecases/update_expense_usecase.dart';
import 'package:safqah_assessment/features/expenses_list/presentation/providers/expenses_list_provider.dart';

import 'data/repositories/expenses_repository_impl.dart';
import 'domain/repositories/expenses_repository.dart';
import 'domain/usecases/add_expense_usecase.dart';
import 'domain/usecases/delete_expense_usecase.dart';
import 'domain/usecases/get_expense_usecase.dart';

final expensesListDI = GetIt.instance;

Future<void> init() async {
  // Provider
  expensesListDI.registerFactory<ExpensesListProvider>(
    () => ExpensesListProvider(
      expensesListDI(),
      expensesListDI(),
      expensesListDI(),
      expensesListDI(),
    ),
  );

  // Usecases
  expensesListDI.registerLazySingleton<AddExpenseUsecase>(
    () => AddExpenseUsecase(
      expensesListDI(),
    ),
  );
  expensesListDI.registerLazySingleton<DeleteExpenseUsecase>(
    () => DeleteExpenseUsecase(
      expensesListDI(),
    ),
  );
  expensesListDI.registerLazySingleton<GetExpensesUsecase>(
    () => GetExpensesUsecase(
      expensesListDI(),
    ),
  );
  expensesListDI.registerLazySingleton<UpdateExpenseUsecase>(
    () => UpdateExpenseUsecase(
      expensesListDI(),
    ),
  );

  //Repository
  expensesListDI.registerLazySingleton<ExpensesRepository>(
    () => ExpensesRepositoryImpl(
      expensesListDI(),
    ),
  );

  // Data sources
  expensesListDI.registerLazySingleton<ExpensesLocalDataSource>(
    () => ExpensesLocalDataSourceImpl(),
  );
}
