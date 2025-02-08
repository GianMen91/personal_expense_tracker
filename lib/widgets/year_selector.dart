import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../blocs/expenses_stat/expenses_stat_bloc.dart';
import '../blocs/expenses_stat/expenses_stat_event.dart';

class YearSelector extends StatelessWidget {
  final DateTime selectedDate;

  const YearSelector({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_left, size: 30),
          onPressed: () {
            context.read<ExpensesStatBloc>().add(ChangeYearEvent(-1));
          },
        ),
        Text(
          DateFormat('yyyy').format(selectedDate),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_right, size: 30),
          onPressed: () {
            context.read<ExpensesStatBloc>().add(ChangeYearEvent(1));
          },
        ),
      ],
    );
  }
}
