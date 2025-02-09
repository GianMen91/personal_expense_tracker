import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/models/expense_categories.dart';
import '../constants.dart';
import '../widgets/category_item.dart';

class SelectCategoryDialog extends StatelessWidget {
  const SelectCategoryDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFF5F5F5),
      title: const Text('Select a category',
          key: Key('select_category_title_text'),
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold)),
      content: SizedBox(
        key: const Key('category_list'),
        height: 300.0,
        width: 300.0,
        child: ListView.builder(
          itemCount: ExpenseCategories.categories.length,
          itemBuilder: (context, index) {
            final category = ExpenseCategories.categories[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CategoryItem(category: category,key: const Key('category_item'),),
            );
          },
        ),
      ),
      actions: <Widget>[
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            key: const Key('cancel_button'),
            style: ElevatedButton.styleFrom(
              backgroundColor: kButtonColor,
              padding: const EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text('CANCEL',key: Key('cancel_button_text'),
                style: TextStyle(fontSize: 18, color: Colors.white)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}
