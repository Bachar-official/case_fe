import 'package:case_fe/app/di.dart';
import 'package:case_fe/app/routing.dart';
import 'package:case_fe/const/theme.dart';
import 'package:case_fe/feature/apps_screen/apps_state.dart';
import 'package:case_fe/feature/apps_screen/apps_state_holder.dart';
import 'package:case_fe/feature/apps_screen/components/app_card.dart';
import 'package:case_fe/feature/components/empty_list_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

final provider =
    StateNotifierProvider<AppsStateHolder, AppsState>((ref) => di.appsHolder);

class AppsScreen extends ConsumerWidget {
  const AppsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    final manager = di.appsManager;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Приложения'),
        actions: [
          kIsWeb
              ? IconButton(
                  onPressed: manager.onGetApps,
                  icon: const Icon(Icons.refresh),
                )
              : const SizedBox.shrink(),
          IconButton(
            onPressed: manager.setTheme,
            icon: Icon(state.theme == ColorTheme.dark
                ? Icons.dark_mode
                : Icons.light_mode),
          ),
          manager.isAuthorized
              ? IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.profileScreen);
                  },
                  icon: CircleAvatar(
                    child: Text(manager.shortUsername),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.account_circle),
                  onPressed: () async {
                    await Navigator.pushNamed(context, AppRouter.loginScreen);
                  },
                )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: manager.onGetApps,
        child: state.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : EmptyListHandler(
                listWidget: ListView.builder(
                  itemCount: state.apps.length,
                  itemBuilder: (context, index) => AppCard(
                    app: state.apps.elementAt(index),
                  ),
                ),
                emptyMessage: 'Список приложений пуст',
                isListEmpty: state.apps.isEmpty),
      ),
      floatingActionButton: manager.canUpdate
          ? FloatingActionButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRouter.newAppScreen),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
