import 'package:equatable/equatable.dart';

class NavigationState extends Equatable {
  final int currentPage;

  const NavigationState(this.currentPage);

  @override
  List<Object?> get props => [currentPage];
}
