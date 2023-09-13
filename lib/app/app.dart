import 'package:case_fe/app/di.dart';
import 'package:case_fe/app/routing.dart';
import 'package:case_fe/const/theme.dart';
import 'package:case_fe/feature/apps_screen/apps_state.dart';
import 'package:case_fe/feature/apps_screen/apps_state_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final provider =
    StateNotifierProvider<AppsStateHolder, AppsState>((ref) => di.appsHolder);

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);

    return MaterialApp(
      title: 'CASE',
      theme: themes[state.theme],
      onGenerateRoute: AppRouter.generateRoute,
      scaffoldMessengerKey: di.scaffoldKey,
    );
  }
}
