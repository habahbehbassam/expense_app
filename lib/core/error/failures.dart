import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}


// Expense Failure
class DeleteItemFailure extends Failure {}
class GetItemsFailure extends Failure {}
class UpdateItemFailure extends Failure {}
class InsertItemFailure extends Failure {}

// Expense Failure For specific cases in usecases
class ExpenseIdNotValidFailure extends Failure {}
class ExpenseAmountNotValidFailure extends Failure {}
class ExpenseNameNotValidFailure extends Failure {}
class ExpenseDateNotValidFailure extends Failure {}