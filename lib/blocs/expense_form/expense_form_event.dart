import '../../models/expense_category.dart';

abstract class ExpenseFormEvent {}

class DescriptionChanged extends ExpenseFormEvent {
  final String description;
  DescriptionChanged(this.description);
}

class CostChanged extends ExpenseFormEvent {
  final String cost;
  CostChanged(this.cost);
}

class DateChanged extends ExpenseFormEvent {
  final DateTime date;
  DateChanged(this.date);
}

class FormSubmitted extends ExpenseFormEvent {
  final ExpenseCategory category;
  FormSubmitted(this.category);
}

class ResetForm extends ExpenseFormEvent {}