import 'package:case_fe/feature/home_screen/home_state.dart';
import 'package:riverpod/riverpod.dart';

class HomeStateHolder extends StateNotifier<HomeState> {
  HomeStateHolder() : super(const HomeState.initial());

  HomeState get homeState => state;

  void setPage(int page) {
    state = state.copyWith(pageNumber: page);
  }
}
