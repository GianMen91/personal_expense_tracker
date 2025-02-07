import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/expense.dart';
import '../../models/expense_validation_service.dart';
import '../expense_list/expense_list_bloc.dart';
import '../expense_list/expense_list_event.dart';
import 'expense_form_event.dart';
import 'expense_form_state.dart';

class ExpenseFormBloc extends Bloc<ExpenseFormEvent, ExpenseFormState> {
  final ExpenseValidationService validationService;
  final ExpensesListBloc expensesBloc;

  ExpenseFormBloc({required this.validationService, required this.expensesBloc})
      : super(ExpenseFormState()) {
    on<DescriptionChanged>(_onDescriptionChanged);
    on<CostChanged>(_onCostChanged);
    on<DateChanged>(_onDateChanged);
    on<FormSubmitted>(_onFormSubmitted);
    on<ResetForm>(_onResetForm);
  }

  void _onDescriptionChanged(
      DescriptionChanged event, Emitter<ExpenseFormState> emit) {
    final cost = double.tryParse(state.cost.replaceAll(',', '.')) ?? 0;
    final newState = state.copyWith(
        description: event.description,
        isValid: validationService.isValidExpense(event.description, cost));
    emit(newState);
  }

  void _onCostChanged(CostChanged event, Emitter<ExpenseFormState> emit) {
    final cost = double.tryParse(event.cost.replaceAll(',', '.')) ?? 0;
    final newState = state.copyWith(
        cost: event.cost,
        isValid: validationService.isValidExpense(state.description, cost));
    emit(newState);
  }

  void _onDateChanged(DateChanged event, Emitter<ExpenseFormState> emit) {
    emit(state.copyWith(date: event.date));
  }

  void _onFormSubmitted(FormSubmitted event, Emitter<ExpenseFormState> emit) {
    if (state.isValid) {
      final expense = Expense(
        category: event.category.title,
        description: state.description,
        cost: double.parse(state.cost.replaceAll(',', '.')),
        date: state.date,
      );

      expensesBloc.add(AddExpense(expense));
    }
  }

  void _onResetForm(ResetForm event, Emitter<ExpenseFormState> emit) {
    emit(ExpenseFormState());
  }
}
