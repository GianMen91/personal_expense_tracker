import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:personal_expense_tracker/blocs/navigation/navigation_bloc.dart';
import 'package:personal_expense_tracker/blocs/navigation/navigation_event.dart';
import 'package:personal_expense_tracker/blocs/navigation/navigation_state.dart';

void main() {
  late NavigationBloc bloc;

  setUp(() {
    bloc = NavigationBloc();
  });

  tearDown(() {
    bloc.close();
  });

  group('NavigationBloc', () {
    blocTest<NavigationBloc, NavigationState>(
      'emits [1] when ChangePage(1) is added',
      build: () => bloc,
      act: (bloc) => bloc.add(ChangePage(1)),
      expect: () => [NavigationState(1)],
    );

    blocTest<NavigationBloc, NavigationState>(
      'emits [2] when ChangePage(2) is added',
      build: () => bloc,
      act: (bloc) => bloc.add(ChangePage(2)),
      expect: () => [NavigationState(2)],
    );

    blocTest<NavigationBloc, NavigationState>(
      'handles multiple page changes correctly',
      build: () => bloc,
      act: (bloc) => {
        bloc.add(ChangePage(1)),
        bloc.add(ChangePage(2)),
        bloc.add(ChangePage(0)),
      },
      expect: () => [
        NavigationState(1),
        NavigationState(2),
        NavigationState(0),
      ],
    );

    test('state equals works correctly', () {
      final state1 = NavigationState(1);
      final state2 = NavigationState(1);
      final state3 = NavigationState(2);

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });
  });
}
