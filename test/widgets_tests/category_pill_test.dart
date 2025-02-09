import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/constants.dart';
import 'package:personal_expense_tracker/widgets/category_pill.dart';

void main() {
  testWidgets('CategoryPill renders correctly with unselected state',
      (WidgetTester tester) async {
    // Build the widget inside a testable environment
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CategoryPill(title: 'Groceries', isSelected: false),
        ),
      ),
    );

    // Verify that the category title is displayed correctly
    expect(find.byKey(const Key('category_pill_title_text')), findsOneWidget);
    expect(find.text('Groceries'), findsOneWidget);

    // Extract the actual widget
    final container = tester.widget<Container>(find.byType(Container));
    final text =
        tester.widget<Text>(find.byKey(const Key('category_pill_title_text')));

    // Verify that the container background color is white (not selected)
    expect((container.decoration as BoxDecoration).color, equals(Colors.white));

    // Verify that the text color is grey (not selected)
    expect(text.style?.color, equals(Colors.grey[600]));
  });

  testWidgets('CategoryPill renders correctly with selected state',
      (WidgetTester tester) async {
    // Build the widget inside a testable environment
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CategoryPill(title: 'Food', isSelected: true),
        ),
      ),
    );

    // Extract the actual widget
    final container = tester.widget<Container>(find.byType(Container));
    final text =
        tester.widget<Text>(find.byKey(const Key('category_pill_title_text')));

    // Verify that the container background color is the theme color (selected)
    expect((container.decoration as BoxDecoration).color, equals(kThemeColor));

    // Verify that the text color is white (selected)
    expect(text.style?.color, equals(Colors.white));
  });
}
