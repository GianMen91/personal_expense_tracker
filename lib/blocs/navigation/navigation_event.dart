abstract class NavigationEvent {}

class ChangePage extends NavigationEvent {
  final int pageIndex;
  ChangePage(this.pageIndex);
}
