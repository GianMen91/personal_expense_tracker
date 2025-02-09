import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/expenses_stat/expenses_stat_bloc.dart';
import '../blocs/expenses_stat/expenses_stat_event.dart';
import '../models/expense_categories.dart';
import 'category_pill.dart';

class CategorySelector extends StatelessWidget {
  final String selectedCategory;

  const CategorySelector({super.key, required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    final categories = [
      "ALL",
      ...ExpenseCategories.categories.map((c) => c.title)
    ];

    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              context
                  .read<ExpensesStatBloc>()
                  .add(ChangeCategoryEvent(category));
            },
            child: CategoryPill(
                key: const Key('category_pill'),
                title: category, isSelected: category == selectedCategory),
          );
        },
      ),
    );
  }
}
