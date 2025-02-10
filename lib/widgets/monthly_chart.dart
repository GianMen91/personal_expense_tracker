import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/expenses_stat/expenses_stat_bloc.dart';
import '../blocs/expenses_stat/expenses_stat_event.dart';
import '../constants.dart';

// Widget that displays a horizontal bar chart representing monthly expenses.
class MonthlyChart extends StatelessWidget {
  final List<MapEntry<String, double>>
      monthlyData; // List of month names and their respective total expenses
  final String? selectedMonth; // Currently selected month for filtering

  const MonthlyChart({
    super.key,
    required this.monthlyData,
    required this.selectedMonth,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the maximum expense amount to scale the bars proportionally
    final maxAmount = monthlyData.fold(
        0.0, (max, entry) => entry.value > max ? entry.value : max);

    return Container(
      key: const Key('chart_container'),
      height: 200,
      // Fixed height for the chart container
      width: double.infinity,
      // Full width
      padding: const EdgeInsets.all(20),
      // Padding around the chart
      margin: const EdgeInsets.symmetric(horizontal: 16),
      // Margin from screen edges
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Rounded corners for styling
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Allows scrolling if too many months
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          // Align bars to the bottom
          children: monthlyData.map((entry) {
            final heightPercent = maxAmount > 0
                ? entry.value / maxAmount
                : 0; // Normalize bar height
            final isSelected =
                entry.key == selectedMonth; // Check if this month is selected

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              // Space between bars
              child: GestureDetector(
                onTap: () {
                  // Toggle month selection on tap
                  context.read<ExpensesStatBloc>().add(
                      ChangeMonthSelectionEvent(isSelected ? null : entry.key));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                      key: const Key('monthly_data'),
                      child: Container(
                        width: 30,
                        // Fixed width for bars
                        height: 120 * heightPercent.toDouble(),
                        // Adjust height dynamically
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.orange // Highlight selected month
                              : kThemeColor.withOpacity(0.2), // Default color
                          borderRadius:
                              BorderRadius.circular(15), // Rounded bar edges
                        ),
                      ),
                    ),
                    const SizedBox(height: 8), // Space between bar and text
                    Text(
                      entry.key, // Display month name below the bar
                      key: const Key('month_name_text'),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
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
