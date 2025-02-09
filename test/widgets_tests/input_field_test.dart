import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/widgets/input_field.dart';

void main() {
  testWidgets('InputField displays label and child widget correctly', (WidgetTester tester) async {
    // Mock data for testing
    final testLabel = 'Test Label';
    final testChild = Text('Test Child');

    // Build the InputField widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: InputField(
            label: testLabel,
            child: testChild,
          ),
        ),
      ),
    );

    // Check if the label is displayed
    expect(find.text(testLabel), findsOneWidget);

    // Check if the child widget (Text('Test Child')) is displayed
    expect(find.text('Test Child'), findsOneWidget);

    // Check if the container and row are present
    expect(find.byKey(const Key('input_field_container')), findsOneWidget);
    expect(find.byKey(const Key('input_field_row')), findsOneWidget);
  });

  testWidgets('InputField triggers onTap callback when tapped', (WidgetTester tester) async {
    // Mock onTap callback
    bool tapped = false;
    onTapCallback() {
      tapped = true;
    }

    // Build the InputField widget with the onTap callback
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: InputField(
            onTap: onTapCallback,
            child: const Text('Test Child'),
          ),
        ),
      ),
    );

    // Find the InkWell widget and tap it
    final inkWellFinder = find.byKey(const Key('input_field_inkwell'));
    expect(inkWellFinder, findsOneWidget);

    // Tap on the widget
    await tester.tap(inkWellFinder);
    await tester.pump(); // Wait for animations to complete

    // Check if the onTap callback was triggered
    expect(tapped, true);
  });

  testWidgets('InputField renders correctly without label', (WidgetTester tester) async {
    // Build the InputField widget without a label
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: InputField(
            child: const Text('Test Child'),
          ),
        ),
      ),
    );

    // Check that the label is not displayed
    expect(find.byKey(const Key('input_field_label')), findsNothing);

    // Check if the child widget (Text('Test Child')) is still displayed
    expect(find.text('Test Child'), findsOneWidget);
  });
}
