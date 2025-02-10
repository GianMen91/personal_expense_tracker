import 'package:flutter/material.dart';
import '../constants.dart';

class TotalExpenseCard extends StatelessWidget {
  final double totalAmount;
  final String title; // Make title dynamic
  final String? subtitle; // Make subtitle dynamic (nullable)
  final String? category; // Make category dynamic (nullable)
  final String? highestSpendingCategory; // Make this dynamic and nullable

  const TotalExpenseCard({
    super.key,
    required this.totalAmount,
    required this.title,
    this.subtitle,
    this.category,
    this.highestSpendingCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      // Consistent margin
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: kThemeColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          // Consistent shadow
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
            key: const Key('total_amount_text'),
            '${totalAmount.toStringAsFixed(2)} €',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(title,
              key: const Key('title_text'),
              style: const TextStyle(color: Colors.white, fontSize: 18)),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(subtitle!,
                key: const Key('subtitle_text'),
                style: const TextStyle(color: Colors.white, fontSize: 16)),
          ],
          if (category != null && category != "ALL") ...[
            const SizedBox(height: 8),
            Text(category!,
                key: const Key('category_text'),
                style: const TextStyle(color: Colors.white, fontSize: 16)),
            // Dynamic category
          ],
          if (highestSpendingCategory != null && category == "ALL") ...[
            const SizedBox(height: 8),
            Text(
              key: const Key('highest_spending_category_text'),
              'Categories where you spent the most: $highestSpendingCategory',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ],
      ),
    );
  }
}
