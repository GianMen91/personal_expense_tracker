import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:personal_expense_tracker/blocs/navigation/navigation_bloc.dart';
import 'package:personal_expense_tracker/blocs/navigation/navigation_event.dart';
import 'package:personal_expense_tracker/blocs/navigation/navigation_state.dart';

void main() {
  late NavigationBloc bloc;

  // Setup: Initialize the NavigationBloc before each test
  setUp(() {
    bloc = NavigationBloc();
  });

  // Teardown: Close the bloc after each test
  tearDown(() {
    bloc.close();
  });

  group('NavigationBloc', () {
    // Test for single page change to page 1
    blocTest<NavigationBloc, NavigationState>(
      'emits [1] when ChangePage(1) is added',
      build: () => bloc,
      act: (bloc) => bloc.add(ChangePage(1)),
      expect: () => [NavigationState(1)], // Expected state after event is added
    );

    // Test for single page change to page 2
    blocTest<NavigationBloc, NavigationState>(
      'emits [2] when ChangePage(2) is added',
      build: () => bloc,
      act: (bloc) => bloc.add(ChangePage(2)),
      expect: () => [NavigationState(2)], // Expected state after event is added
    );

    // Test for multiple page changes
    blocTest<NavigationBloc, NavigationState>(
      'handles multiple page changes correctly',
      build: () => bloc,
      act: (bloc) => {
        bloc.add(ChangePage(1)),
        bloc.add(ChangePage(2)),
        bloc.add(ChangePage(0)),
      },
      expect: () => [
        NavigationState(1), // State after first change (page 1)
        NavigationState(2), // State after second change (page 2)
        NavigationState(0), // State after third change (page 0)
      ],
    );

    // Test for comparing NavigationState objects
    test('state equals works correctly', () {
      final state1 = NavigationState(1); // State with page 1
      final state2 = NavigationState(1); // State with page 1 (same as state1)
      final state3 = NavigationState(2); // State with page 2

      // Verify state1 and state2 are considered equal (same page)
      expect(state1, equals(state2));

      // Verify state1 and state3 are not considered equal (different pages)
      expect(state1, isNot(equals(state3)));
    });
  });
}
