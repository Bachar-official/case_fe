import 'dart:convert';

import 'package:case_fe/app/di.dart';
import 'package:case_fe/app/routing.dart';
import 'package:case_fe/feature/new_app_screen/new_app_state.dart';
import 'package:case_fe/feature/new_app_screen/new_app_state_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final provider = StateNotifierProvider<NewAppStateHolder, NewAppState>(
    (ref) => di.newAppHolder);

const clearIcon = Icon(Icons.clear);

class NewAppScreen extends ConsumerWidget {
  const NewAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    final manager = di.newAppManager;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Создание приложения'),
      ),
      body: manager.canCreate
          ? Padding(
              padding: const EdgeInsets.all(10),
              child: state.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Form(
                      key: manager.formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextFormField(
                            controller: manager.nameC,
                            validator: manager.validateEmpty,
                            onChanged: manager.setName,
                            decoration: InputDecoration(
                              labelText: 'Название приложения',
                              suffix: IconButton(
                                icon: clearIcon,
                                onPressed: manager.clearName,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: manager.packageC,
                            validator: manager.validatePackage,
                            onChanged: manager.setPackage,
                            decoration: InputDecoration(
                              labelText: 'Package',
                              suffix: IconButton(
                                icon: clearIcon,
                                onPressed: manager.clearPackage,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: manager.versionC,
                            validator: manager.validateVersion,
                            onChanged: manager.setVersion,
                            decoration: InputDecoration(
                              labelText: 'Версия',
                              suffix: IconButton(
                                icon: clearIcon,
                                onPressed: manager.clearVersion,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: manager.descriptionC,
                            onChanged: manager.setDescription,
                            decoration: InputDecoration(
                              labelText: 'Описание',
                              suffix: IconButton(
                                icon: clearIcon,
                                onPressed: manager.clearDescription,
                              ),
                            ),
                          ),
                          state.icon == null
                              ? const Text('Изображение не прикреплено')
                              : SizedBox(
                                  height: 100,
                                  child: Stack(
                                    children: [
                                      Image.memory(
                                        base64.decode(state.icon!),
                                        fit: BoxFit.fitHeight,
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: manager.clearIcon,
                                          child: clearIcon,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          ElevatedButton(
                            onPressed: () async {
                              final XFile? image = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              manager.setIcon(image);
                            },
                            child: const Text('Загрузить изображение'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (manager.formKey.currentState!.validate()) {
                                bool isCreated = await manager.createApp();
                                if (isCreated && context.mounted) {
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      AppRouter.appScreen, (route) => false);
                                }
                              }
                            },
                            child: const Text('Загрузить'),
                          ),
                        ],
                      ),
                    ),
            )
          : const Center(
              child: Text('Недостаточно прав для данной операции.'),
            ),
    );
  }
}
