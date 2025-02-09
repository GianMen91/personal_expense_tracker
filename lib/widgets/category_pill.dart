import 'package:flutter/material.dart';

import '../constants.dart';

class CategoryPill extends StatelessWidget {
  final String title;
  final bool isSelected;

  const CategoryPill(
      {super.key, required this.title, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: isSelected ? kThemeColor : Colors.white,
          borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Text(title,key: const Key('category_pill_title_text'),
            style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
