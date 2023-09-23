import 'package:case_fe/app/di.dart';
import 'package:case_fe/app/routing.dart';
import 'package:case_fe/domain/entity/app.dart';
import 'package:case_fe/feature/components/preview_image.dart';
import 'package:case_fe/feature/edit_app_screen/edit_app_manager.dart';
import 'package:case_fe/feature/edit_app_screen/edit_app_state.dart';
import 'package:case_fe/feature/edit_app_screen/edit_app_state_holder.dart';
import 'package:case_fe/utils/validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final provider = StateNotifierProvider<EditAppStateHolder, EditAppState>(
    (ref) => di.editAppHolder);

const clearIcon = Icon(Icons.clear);
const padding = EdgeInsets.all(5);

class EditAppScreen extends ConsumerWidget {
  const EditAppScreen({Key? key}) : super(key: key);

  void setDefaultValues(EditAppManager manager, App app) {
    manager.nameC.text = app.name;
    manager.versionC.text = app.version;
    manager.descriptionC.text = app.description ?? '';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    App app = ModalRoute.of(context)!.settings.arguments as App;

    final state = ref.watch(provider);
    final manager = di.editAppManager;

    WidgetsBinding.instance
        .addPostFrameCallback((_) => setDefaultValues(manager, app));

    return Scaffold(
      appBar: AppBar(
        title: Text('Редактирование ${app.package}'),
      ),
      body: manager.canUpdate
          ? Center(
              child: state.isLoading
                  ? const CircularProgressIndicator()
                  : Center(
                      child: SizedBox(
                        width: 500,
                        child: Form(
                          key: manager.formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: manager.nameC,
                                  decoration: InputDecoration(
                                    labelText: 'Название',
                                    suffix: IconButton(
                                      onPressed: () => manager.nameC.text = '',
                                      icon: clearIcon,
                                    ),
                                  ),
                                  validator: Validator.validateEmpty,
                                ),
                                TextFormField(
                                  controller: manager.versionC,
                                  decoration: InputDecoration(
                                    labelText: 'Версия',
                                    suffix: IconButton(
                                      onPressed: () =>
                                          manager.versionC.text = '',
                                      icon: clearIcon,
                                    ),
                                  ),
                                  validator: Validator.validateVersion,
                                ),
                                TextFormField(
                                  controller: manager.descriptionC,
                                  decoration: InputDecoration(
                                    labelText: 'Описание',
                                    suffix: IconButton(
                                      onPressed: () =>
                                          manager.descriptionC.text = '',
                                      icon: clearIcon,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: padding,
                                  child: PreviewImage(
                                      isWeb: kIsWeb,
                                      icon: state.icon,
                                      onClearIcon: manager.clearIcon,
                                      webIcon: state.webIcon),
                                ),
                                Padding(
                                  padding: padding,
                                  child: ElevatedButton(
                                    onPressed: state.icon != null ||
                                            state.webIcon != null
                                        ? null
                                        : () async {
                                            final XFile? image =
                                                await ImagePicker().pickImage(
                                                    source:
                                                        ImageSource.gallery);
                                            manager.setIcon(image);
                                          },
                                    child: const Text('Прикрепить изображение'),
                                  ),
                                ),
                                Padding(
                                  padding: padding,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (manager.formKey.currentState!
                                          .validate()) {
                                        bool isCreated = await manager
                                            .updateApp(app.package);
                                        if (isCreated && context.mounted) {
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              AppRouter.appScreen,
                                              (route) => false);
                                        }
                                      }
                                    },
                                    child: const Text('Обновить'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
            )
          : const Center(
              child: Text('Нет прав на выполнение данной операции.'),
            ),
    );
  }
}
