import 'package:flutter/material.dart';

import '../constants.dart';

class MonthlyTotalExpenseCard extends StatelessWidget {
  final double monthlyTotal;

  const MonthlyTotalExpenseCard({
    super.key,
    required this.monthlyTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: kThemeColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            '${monthlyTotal.toStringAsFixed(2)} €',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text('Total expense this month',
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ],
      ),
    );
  }
}
