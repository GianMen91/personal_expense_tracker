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

class MockExpenseFormBloc extends MockBloc<ExpenseFormEvent, ExpenseFormState>
    implements ExpenseFormBloc {}

// Create a fake Expense for fallback registration
class FakeExpense extends Fake implements ExpenseFormEvent {}

void main() {
  final testCategory = ExpenseCategories.categories[0];

  group('NewExpenseScreen Integration Tests', () {
    late MockExpenseFormBloc mockFormBloc;

    setUp(() {
      mockFormBloc = MockExpenseFormBloc();

      registerFallbackValue(FakeExpense());

      // Stub initial state
      whenListen(
        mockFormBloc,
        Stream.value(ExpenseFormState()),
        initialState: ExpenseFormState(),
      );
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: BlocProvider<ExpenseFormBloc>.value(
          value: mockFormBloc,
          child: NewExpenseScreen(category: testCategory),
        ),
      );
    }

    testWidgets('should display all form elements', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byKey(const Key('amount_input_field')), findsOneWidget);
      expect(find.byKey(const Key('description_input_field')), findsOneWidget);
      expect(find.byKey(const Key('date_picker_input_field')), findsOneWidget);
      expect(find.byType(CategoryItem), findsOneWidget);
      expect(find.byKey(const Key('save_button')), findsOneWidget);
    });

    testWidgets('should enable save button when form is valid', (tester) async {
      // Arrange: Set valid state
      whenListen(
        mockFormBloc,
        Stream.value(ExpenseFormState(
          cost: '20.0',
          description: 'Test description',
          date: DateTime.now(),
          isValid: true,
        )),
      );

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      final saveButton =
          tester.widget<ElevatedButton>(find.byKey(const Key('save_button')));
      expect(saveButton.enabled, isTrue);
    });
  });
}
