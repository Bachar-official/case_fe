import 'package:case_fe/feature/home_screen/home_screen_state_holder.dart';

class HomeScreenManager {
  final HomeScreenStateHolder holder;

  const HomeScreenManager({required this.holder});

  void setPage(int page) => holder.setPage(page);
}
