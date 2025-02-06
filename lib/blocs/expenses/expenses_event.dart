import '../../models/expense.dart';

abstract class ExpensesEvent {}

class LoadExpense extends ExpensesEvent {}

class AddExpense extends ExpensesEvent {
  final Expense expense;
  AddExpense(this.expense);
}

class DeleteExpense extends ExpensesEvent {
  final Expense expense;
  DeleteExpense(this.expense);
}

class ChangeCategoryEvent extends ExpensesEvent {
  final String category;
  ChangeCategoryEvent(this.category);
}

class ChangeYearEvent extends ExpensesEvent {
  final int offset;
  ChangeYearEvent(this.offset);
}

class ChangeMonthSelectionEvent extends ExpensesEvent {
  final String? month;
  ChangeMonthSelectionEvent(this.month);
}