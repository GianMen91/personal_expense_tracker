import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/expenses_stat/expenses_stat_bloc.dart';
import '../blocs/expenses_stat/expenses_stat_event.dart';
import '../constants.dart';

class MonthlyChart extends StatelessWidget {
  final List<MapEntry<String, double>> monthlyData;

   final String? selectedMonth;

  const MonthlyChart(
      {super.key, required this.monthlyData, required this.selectedMonth});


  @override
  Widget build(BuildContext context) {
    final maxAmount = monthlyData.fold(
        0.0, (max, entry) => entry.value > max ? entry.value : max);

    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: monthlyData.map((entry) {
            final heightPercent = maxAmount > 0 ? entry.value / maxAmount : 0;
            final isSelected = entry.key == selectedMonth;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: () {
                  context.read<ExpensesStatBloc>().add(
                      ChangeMonthSelectionEvent(isSelected ? null : entry.key));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                      child: Container(
                        width: 30,
                        height: 120 * heightPercent.toDouble(),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.orange
                              : kThemeColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(entry.key,
                        style:
                        TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
