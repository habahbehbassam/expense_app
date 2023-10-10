import 'package:safqah_assessment/features/expenses_list/data/models/expense_item_model.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';

abstract class ExpensesLocalDataSource {
  Future<List<ExpenseItemModel>> getAllExpenses();

  Future<int> deleteExpense(int id);

  Future<int> addExpense(ExpenseItemModel item);

  Future<int> updateExpense(ExpenseItemModel item);
}

class ExpensesLocalDataSourceImpl extends ExpensesLocalDataSource {
  Database? _database;

  static const _expenseListTable = 'EXPENSE_LIST_TABLE';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _openDb();
    return _database!;
  }

  Future<Database> _openDb() async {
    return await openDatabase(
      AppConstants.databaseName,
      version: AppConstants.dbSchemaVersion,
      onOpen: (database) async {
        await _onCreate(
          database,
          AppConstants.dbSchemaVersion,
        );
      },
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database database, int version) async {
    await database.execute(
        'CREATE TABLE IF NOT EXISTS $_expenseListTable(id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'name TEXT,'
        'amount REAL,'
        'date INTEGER'
        ')');
  }

  @override
  Future<int> addExpense(ExpenseItemModel item) async {
    final itemId = await (await database).insert(
      _expenseListTable,
      item.toMap(),
    );

    if (itemId > 0) {
      return itemId;
    }

    throw InsertItemException();
  }

  @override
  Future<int> deleteExpense(int id) async {
    final itemCount = await (await database).delete(
      _expenseListTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (itemCount > 0) {
      return itemCount;
    }

    throw DeleteItemNotFoundException();
  }

  @override
  Future<List<ExpenseItemModel>> getAllExpenses() async {
    final dbItems = await (await database).query(_expenseListTable);

    final items = dbItems
        .map(
          (expense) => ExpenseItemModel(
            name: expense['name'] as String,
            amount: expense['amount'] as double,
            dateTimestamp: expense['date'] as int,
            id: expense['id'] as int,
          ),
        )
        .toList();

    if (items.isNotEmpty) {
      return items;
    }

    throw NoItemsException();
  }

  @override
  Future<int> updateExpense(ExpenseItemModel item) async {
    final itemsCount =  await (await database).update(
      _expenseListTable,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );

    if(itemsCount > 0){
      return itemsCount;
    }

    throw UpdateItemNotFoundException();
  }
}
