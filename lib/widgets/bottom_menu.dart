import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/navigation/navigation_bloc.dart';
import '../blocs/navigation/navigation_event.dart';
import '../constants.dart';

class BottomMenu extends StatelessWidget {
  final PageController myPage;
  final int currentIndex;

  const BottomMenu(
      {super.key, required this.currentIndex, required this.myPage});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: kBottomNavigationBarColor,
      shape: const CircularNotchedRectangle(),
      child: SizedBox(
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home,
                  key: const Key('homeIcon'),
                  color: currentIndex == 0 ? kThemeColor : Colors.grey),
              onPressed: () {
                context.read<NavigationBloc>().add(ChangePage(0));
                myPage.jumpToPage(0);
              },
            ),
            IconButton(
              key: const Key('barChartIcon'),
              icon: Icon(Icons.bar_chart,
                  color: currentIndex == 1 ? kThemeColor : Colors.grey),
              onPressed: () {
                context.read<NavigationBloc>().add(ChangePage(1));
                myPage.jumpToPage(1);
              },
            ),
          ],
        ),
      ),
    );
  }
}
