class ExpenseItemEntity {
  ExpenseItemEntity({
    this.id,
    required this.name,
    required this.dollars,
    required this.cents,
    required this.date,
  });

  final int? id;
  final String name;
  final int dollars;
  final int cents;
  final DateTime date;
}
