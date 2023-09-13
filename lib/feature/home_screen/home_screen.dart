import 'package:case_fe/app/di.dart';
import 'package:case_fe/feature/apps_screen/apps_screen.dart';
import 'package:case_fe/feature/home_screen/home_state.dart';
import 'package:case_fe/feature/home_screen/home_state_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final provider =
    StateNotifierProvider<HomeStateHolder, HomeState>((ref) => di.homeHolder);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    final manager = di.homeManager;

    return Scaffold(
      body: [const AppsScreen()][state.pageNumber],
    );
  }
}
