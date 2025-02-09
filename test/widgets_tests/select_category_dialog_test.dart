import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/widgets/select_category_dialog.dart';

void main() {
  group('SelectCategoryDialog Widget Test', () {
    testWidgets('Renders correctly the elements of the dialog',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            // Use Builder to get a BuildContext
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        const SelectCategoryDialog(),
                  );
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      // Tap the button to show the dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Verify dialog is open
      expect(
          find.byKey(const Key('select_category_title_text')), findsOneWidget);

      expect(find.text('Select a category'), findsOneWidget);
      expect(find.byKey(const Key('category_list')), findsOneWidget);

      expect(find.byKey(const Key('cancel_button')), findsOneWidget);
      expect(find.byKey(const Key('cancel_button_text')), findsOneWidget);
      expect(find.text('CANCEL'), findsOneWidget);
    });

    testWidgets('Tapping cancel button closes dialog',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            // Use Builder to get a BuildContext
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        const SelectCategoryDialog(),
                  );
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      // Tap the button to show the dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle(); // Important: Wait for dialog to appear

      // Verify dialog is open
      expect(
          find.byKey(const Key('select_category_title_text')), findsOneWidget);

      // Tap the cancel button
      await tester.tap(find.byKey(const Key('cancel_button')));
      await tester.pumpAndSettle(); // Important: Wait for dialog to disappear

      // Verify dialog is closed (you might need to check if the dialog is no longer present in the widget tree).
      expect(find.byKey(const Key('select_category_title_text')), findsNothing);
    });
  });
}
