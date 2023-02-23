part of 'home_cubit.dart';

enum HomeTab { home, saved }

class HomeState extends Equatable {
  const HomeState({
    this.tab = HomeTab.home,
  });

  final HomeTab tab;

  @override
  List<Object> get props => [tab];
}
