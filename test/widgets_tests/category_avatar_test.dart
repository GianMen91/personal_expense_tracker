import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/models/expense_categories.dart';
import 'package:personal_expense_tracker/widgets/category_avatar.dart';

void main() {
  testWidgets('CategoryAvatar renders with correct icon and color',
      (WidgetTester tester) async {
    // Create a mock ExpenseCategory
    var testCategory = ExpenseCategories.categories[0];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CategoryAvatar(category: testCategory),
        ),
      ),
    );

    // Verify that the category icon is displayed
    expect(find.byKey(const Key('category_icon')), findsOneWidget);

    // Extract the actual widget
    final container = tester.widget<Container>(find.byType(Container));
    final icon = tester.widget<Icon>(find.byKey(const Key('category_icon')));

    // Verify that the container has the expected color with opacity
    expect((container.decoration as BoxDecoration).color,
        equals(testCategory.color.withOpacity(0.2)));

    // Verify that the icon has the expected properties
    expect(icon.icon, equals(Icons.shopping_cart));
    expect(icon.color, equals(Color(0xFF4CAF50)));
  });
}
