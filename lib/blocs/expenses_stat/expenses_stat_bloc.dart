import 'package:flutter_bloc/flutter_bloc.dart';

import 'expenses_stat_event.dart';
import 'expenses_stat_state.dart';

class ExpensesStatBloc extends Bloc<ExpensesStatEvent, ExpensesStatState> {
  ExpensesStatBloc()
      : super(ExpensesStatState(
            selectedDate: DateTime.now(), selectedCategory: "ALL")) {
    on<ChangeCategoryEvent>(_onChangeCategory);
    on<ChangeYearEvent>(_onChangeYear);
    on<ChangeMonthSelectionEvent>(_onChangeMonthSelection);
  }

  void _onChangeCategory(
      ChangeCategoryEvent event, Emitter<ExpensesStatState> emit) {
    emit(state.copyWith(selectedCategory: event.category));
  }

  void _onChangeYear(ChangeYearEvent event, Emitter<ExpensesStatState> emit) {
    final newDate = DateTime(
        state.selectedDate.year + event.offset, state.selectedDate.month);
    emit(state.copyWith(selectedDate: newDate));
  }

  void _onChangeMonthSelection(
      ChangeMonthSelectionEvent event, Emitter<ExpensesStatState> emit) {
    emit(state.copyWith(selectedMonth: event.month));
  }
}
