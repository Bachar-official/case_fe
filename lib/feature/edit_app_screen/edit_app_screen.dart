import 'package:case_fe/app/di.dart';
import 'package:case_fe/domain/entity/app.dart';
import 'package:case_fe/feature/edit_app_screen/edit_app_manager.dart';
import 'package:case_fe/feature/edit_app_screen/edit_app_state.dart';
import 'package:case_fe/feature/edit_app_screen/edit_app_state_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final provider = StateNotifierProvider<EditAppStateHolder, EditAppState>(
    (ref) => di.editAppHolder);

class EditAppScreen extends ConsumerWidget {
  const EditAppScreen({Key? key}) : super(key: key);

  void setDefaultValues(App app, EditAppManager manager) {
    manager.setName(app.name);
    manager.setVersion(app.version);
    manager.setDescription(app.description ?? '');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    App app = ModalRoute.of(context)!.settings.arguments as App;

    final state = ref.watch(provider);
    final manager = di.editAppManager;

    WidgetsBinding.instance
        .addPostFrameCallback((_) => setDefaultValues(app, manager));

    return Scaffold(
      appBar: AppBar(title: Text('Редактирование ${app.package}')),
    );
  }
}
