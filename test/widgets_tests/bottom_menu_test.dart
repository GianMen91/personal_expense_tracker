import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_expense_tracker/blocs/navigation/navigation_bloc.dart';
import 'package:personal_expense_tracker/widgets/bottom_menu.dart';

class MockNavigationBloc extends Mock implements NavigationBloc {}

void main() {
  late MockNavigationBloc mockNavigationBloc;
  late PageController pageController;

  setUp(() {
    mockNavigationBloc = MockNavigationBloc();
    pageController = PageController();
  });

  Widget createTestWidget(int currentIndex) {
    return MaterialApp(
      home: BlocProvider<NavigationBloc>(
        create: (_) => mockNavigationBloc,
        child: Scaffold(
          bottomNavigationBar: BottomMenu(
            key: const Key('bottom_menu'),
            currentIndex: currentIndex,
            myPage: pageController,
          ),
        ),
      ),
    );
  }

  testWidgets('BottomMenu renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(0));

    expect(find.byKey(const Key('bottom_menu')), findsOneWidget);
    expect(find.byKey(const Key('home_icon')), findsOneWidget);
    expect(find.byKey(const Key('bar_chart_icon')), findsOneWidget);
  });
}
