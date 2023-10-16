import 'package:equatable/equatable.dart';

class ExpenseItemEntity extends Equatable {
  const ExpenseItemEntity({
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

  @override
  List<Object?> get props => [id, name, dollars, cents, date.millisecondsSinceEpoch];
}
