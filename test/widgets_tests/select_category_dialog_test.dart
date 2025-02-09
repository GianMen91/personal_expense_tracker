import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/widgets/select_category_dialog.dart';
import 'package:personal_expense_tracker/models/expense_categories.dart';


//todo to fix this
void main() {
  testWidgets('SelectCategoryDialog scrolls automatically to display all category items', (WidgetTester tester) async {
    // Build the SelectCategoryDialog widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SelectCategoryDialog(),
        ),
      ),
    );

    // Verify the dialog title text
    expect(find.text('Select a category'), findsOneWidget);
    expect(find.byKey(const Key('select_category_title_text')), findsOneWidget);

    // Verify the list of categories
    final categoryList = find.byKey(const Key('category_list'));
    expect(categoryList, findsOneWidget);

    // Initial state: Check how many items are initially rendered
    var initialItemCount = find.byKey(const Key('category_item')).evaluate().length;

    // Define the scroll action
    final listViewFinder = find.byType(ListView);

    bool hasMoreItems = true;

    // Continue scrolling until no new items are found
    while (hasMoreItems) {
      // Perform a scroll gesture
      await tester.drag(listViewFinder, const Offset(0, -500)); // Drag upwards
      await tester.pumpAndSettle(); // Allow time for the scroll to complete

      // Check how many items are now rendered
      final currentItemCount = find.byKey(const Key('category_item')).evaluate().length;

      // If the number of items is the same, we've reached the bottom
      hasMoreItems = currentItemCount > initialItemCount;

      // Update the initialItemCount to the current one
      initialItemCount = currentItemCount;
    }

    // Now verify that all category items are rendered
    expect(find.byKey(const Key('category_item')), findsNWidgets(ExpenseCategories.categories.length));

    // Verify the presence of the cancel button
    expect(find.byKey(const Key('cancel_button')), findsOneWidget);
    expect(find.byKey(const Key('cancel_button_text')), findsOneWidget);

    // Tap the cancel button and verify the dialog is dismissed
    await tester.tap(find.byKey(const Key('cancel_button')));
    await tester.pumpAndSettle(); // Wait for the dialog to be dismissed

    // Verify that the dialog is no longer in the widget tree
    expect(find.byType(SelectCategoryDialog), findsNothing);
  });
}
