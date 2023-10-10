import 'package:safqah_assessment/features/expenses_list/data/models/expense_item_model.dart';
import 'package:safqah_assessment/features/expenses_list/domain/entities/expense_item_entity.dart';

extension ExpenseModelToEntityMapper on ExpenseItemModel {
  ExpenseItemEntity toEntity() {
    return ExpenseItemEntity(
      id: id,
      name: name,
      dollars: amount.toInt(),
      cents: amount.toInt(),
      date: DateTime.fromMillisecondsSinceEpoch(dateTimestamp),
    );
  }
}

extension ExpenseEntityToModelMapper on ExpenseItemEntity {
  ExpenseItemModel toEntity() {
    return ExpenseItemModel(
      id: id,
      name: name,
      amount: double.parse("$dollars.$cents"),
      dateTimestamp: date.millisecondsSinceEpoch,
    );
  }
}
