import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_expense_tracker/blocs/expense_form/expense_form_event.dart';
import 'package:personal_expense_tracker/blocs/expense_form/expense_form_state.dart';
import 'package:personal_expense_tracker/models/expense_categories.dart';
import 'package:personal_expense_tracker/screens/new_expense_screen.dart';
import 'package:personal_expense_tracker/blocs/expense_form/expense_form_bloc.dart';
import 'package:personal_expense_tracker/widgets/category_item.dart';

// Mock implementation of ExpenseFormBloc for testing
class MockExpenseFormBloc extends MockBloc<ExpenseFormEvent, ExpenseFormState>
    implements ExpenseFormBloc {}

// Fake ExpenseFormEvent to be used when fallback values are needed
class FakeExpense extends Fake implements ExpenseFormEvent {}

void main() {
  // Select a test category from predefined expense categories
  final testCategory = ExpenseCategories.categories[0];

  group('NewExpenseScreen Integration Tests', () {
    late MockExpenseFormBloc mockFormBloc;

    setUp(() {
      // Initialize mock ExpenseFormBloc
      mockFormBloc = MockExpenseFormBloc();

      // Register a fallback value for event mocking
      registerFallbackValue(FakeExpense());

      // Stub initial state of ExpenseFormBloc
      whenListen(
        mockFormBloc,
        Stream.value(ExpenseFormState()),
        initialState: ExpenseFormState(),
      );
    });

    // Helper function to create the test widget wrapped with BlocProvider
    Widget createTestWidget() {
      return MaterialApp(
        home: BlocProvider<ExpenseFormBloc>.value(
          value: mockFormBloc,
          child: NewExpenseScreen(category: testCategory),
        ),
      );
    }

    testWidgets('should display all form elements', (tester) async {
      // Render the test widget
      await tester.pumpWidget(createTestWidget());

      // Assert that all form fields and buttons are present
      expect(find.byKey(const Key('amount_input_field')), findsOneWidget);
      expect(find.byKey(const Key('description_input_field')), findsOneWidget);
      expect(find.byKey(const Key('date_picker_input_field')), findsOneWidget);
      expect(find.byType(CategoryItem),
          findsOneWidget); // Category selection widget
      expect(find.byKey(const Key('save_button')), findsOneWidget);
    });

    testWidgets('should enable save button when form is valid', (tester) async {
      // Stub bloc state with valid form input
      whenListen(
        mockFormBloc,
        Stream.value(ExpenseFormState(
          cost: '20.0',
          description: 'Test description',
          date: DateTime.now(),
          isValid: true, // Form is considered valid
        )),
      );

      // Render the test widget
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle(); // Allow UI updates

      // Assert that the save button is enabled
      final saveButton =
          tester.widget<ElevatedButton>(find.byKey(const Key('save_button')));
      expect(saveButton.enabled, isTrue);
    });
  });
}
