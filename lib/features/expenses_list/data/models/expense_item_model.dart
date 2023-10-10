class ExpenseItemModel {
  ExpenseItemModel({
    required this.name,
    required this.amount,
    required this.dateTimestamp,
    this.id,
  });

  Map<String, Object> toMap() {
    final map = <String, Object>{};
    map['name'] = name;
    map['amount'] = amount;
    map['date'] = dateTimestamp;
    return map;
  }

  final int? id;
  final String name;
  final double amount;
  final int dateTimestamp;
}
