import 'package:flutter_test/flutter_test.dart';
import 'package:safqah_assessment/features/expenses_list/data/models/expense_item_model.dart';

void main() {
  final dateTimeStamp = DateTime.now().millisecondsSinceEpoch;

  final expenseModel = ExpenseItemModel(
      name: 'Food', amount: 10.10, dateTimestamp: dateTimeStamp);

  test(
    'should return a valid map when the toMap called',
    () async {
      // act
      final result = expenseModel.toMap();
      // assert
      expect(result, {'name': 'Food', 'amount': 10.10, 'date': dateTimeStamp});
    },
  );
}
