import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/expense.dart'; // Importing the Expense model
import '../../models/expense_validation_service.dart'; // Importing the validation service
import '../expense_list/expense_list_bloc.dart'; // Importing the expenses list BLoC
import '../expense_list/expense_list_event.dart'; // Importing events for the expense list BLoC
import 'expense_form_event.dart'; // Importing the events related to the form
import 'expense_form_state.dart'; // Importing the state of the expense form

// ExpenseFormBloc is the BLoC managing the state of the expense form.
class ExpenseFormBloc extends Bloc<ExpenseFormEvent, ExpenseFormState> {
  final ExpenseValidationService
      validationService; // Validation service for expense input
  final ExpensesListBloc expensesBloc; // BLoC to interact with the expense list

  // Constructor initializes the BLoC and sets up event handlers.
  ExpenseFormBloc({required this.validationService, required this.expensesBloc})
      : super(ExpenseFormState()) {
    // Mapping events to their handlers.
    on<DescriptionChanged>(_onDescriptionChanged);
    on<CostChanged>(_onCostChanged);
    on<DateChanged>(_onDateChanged);
    on<FormSubmitted>(_onFormSubmitted);
    on<ResetForm>(_onResetForm);
  }

  // Handler for when the description is changed in the form.
  void _onDescriptionChanged(
      DescriptionChanged event, Emitter<ExpenseFormState> emit) {
    final cost = double.tryParse(state.cost.replaceAll(',', '.')) ?? 0;
    // Create a new state with the updated description and validation status.
    final newState = state.copyWith(
        description: event.description,
        isValid: validationService.isValidExpense(event.description, cost));
    emit(newState); // Emit the new state.
  }

  // Handler for when the cost is changed in the form.
  void _onCostChanged(CostChanged event, Emitter<ExpenseFormState> emit) {
    final cost = double.tryParse(event.cost.replaceAll(',', '.')) ?? 0;
    // Create a new state with the updated cost and validation status.
    final newState = state.copyWith(
        cost: event.cost,
        isValid: validationService.isValidExpense(state.description, cost));
    emit(newState); // Emit the new state.
  }

  // Handler for when the date is changed in the form.
  void _onDateChanged(DateChanged event, Emitter<ExpenseFormState> emit) {
    // Emit a new state with the updated date.
    emit(state.copyWith(date: event.date));
  }

  // Handler for when the form is submitted.
  void _onFormSubmitted(FormSubmitted event, Emitter<ExpenseFormState> emit) {
    if (state.isValid) {
      // Create a new expense if the form is valid.
      final expense = Expense(
        category: event.category.title,
        description: state.description,
        cost: double.parse(state.cost.replaceAll(',', '.')),
        date: state.date,
      );

      // Add the new expense to the expense list BLoC.
      expensesBloc.add(AddExpense(expense));
    }
  }

  // Handler for resetting the form.
  void _onResetForm(ResetForm event, Emitter<ExpenseFormState> emit) {
    // Emit a new state with default values to reset the form.
    emit(ExpenseFormState());
  }
}
