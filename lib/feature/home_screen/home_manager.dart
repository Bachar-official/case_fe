import 'package:case_fe/feature/home_screen/home_state_holder.dart';

class HomeManager {
  final HomeStateHolder holder;

  const HomeManager({required this.holder});

  void setPage(int page) => holder.setPage(page);
}
