import 'package:case_fe/feature/home_screen/home_screen_state.dart';
import 'package:riverpod/riverpod.dart';

class HomeScreenStateHolder extends StateNotifier<HomeScreenState> {
  HomeScreenStateHolder() : super(const HomeScreenState.initial());

  HomeScreenState get homeState => state;

  void setPage(int page) {
    state = state.copyWith(pageNumber: page);
  }
}
