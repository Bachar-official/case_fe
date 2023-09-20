import 'package:case_fe/app/di.dart';
import 'package:case_fe/app/routing.dart';
import 'package:case_fe/domain/entity/arch.dart';
import 'package:case_fe/feature/new_apk_screen/new_apk_state.dart';
import 'package:case_fe/feature/new_apk_screen/new_apk_state_holder.dart';
import 'package:case_fe/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final provider = StateNotifierProvider<NewApkStateHolder, NewApkState>(
    (ref) => di.newApkHolder);

class NewApkScreen extends ConsumerWidget {
  const NewApkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? package =
        ModalRoute.of(context)?.settings.arguments as String?;
    final state = ref.watch(provider);
    final manager = di.newApkManager;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Загрузка артефакта'),
      ),
      body: manager.canUpload
          ? Center(
              child: state.isLoading
                  ? const CircularProgressIndicator()
                  : Form(
                      key: manager.formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            TextFormField(
                              initialValue: package ?? '',
                              decoration: const InputDecoration(
                                labelText: 'Package',
                              ),
                              onChanged: manager.setPackage,
                              validator: Validator.validatePackage,
                            ),
                            DropdownButtonFormField<Arch>(
                                value: state.arch,
                                decoration: InputDecoration(
                                  labelText: 'Архитектура',
                                  suffix: IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () => manager.setArch(null),
                                  ),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: Arch.common,
                                    child: Text('Универсальная'),
                                  ),
                                  DropdownMenuItem(
                                    value: Arch.armv7,
                                    child: Text('ARM ver.7 (x86)'),
                                  ),
                                  DropdownMenuItem(
                                    value: Arch.armv8,
                                    child: Text('ARM ver.8 (x86_64)'),
                                  ),
                                  DropdownMenuItem(
                                    value: Arch.x86_64,
                                    child: Text('x86_64'),
                                  ),
                                ],
                                onChanged: manager.setArch),
                            Text(state.apk == null
                                ? 'Файл не загружен'
                                : 'Размер файла ${manager.fileSize} кб'),
                            ElevatedButton(
                              onPressed: state.apk == null
                                  ? () => manager.setFile()
                                  : () => manager.setApk(null),
                              child: Text(state.apk == null
                                  ? 'Прикрепить файл'
                                  : 'Очистить файл'),
                            ),
                            ElevatedButton(
                              onPressed: state.apk == null
                                  ? null
                                  : () async {
                                      if (manager.formKey.currentState!
                                          .validate()) {
                                        bool result = await manager.uploadApk();
                                        if (result && context.mounted) {
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              AppRouter.appScreen,
                                              (route) => false);
                                        }
                                      }
                                    },
                              child: const Text('Загрузить'),
                            ),
                          ],
                        ),
                      ),
                    ),
            )
          : const Center(
              child: Text('Нет прав для выполнения операции'),
            ),
    );
  }
}
