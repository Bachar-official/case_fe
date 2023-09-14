import 'package:case_fe/app/di.dart';
import 'package:case_fe/domain/entity/permission.dart';
import 'package:case_fe/feature/new_user_screen/new_user_state.dart';
import 'package:case_fe/feature/new_user_screen/new_user_state_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final provider = StateNotifierProvider<NewUserStateHolder, NewUserState>(
    (ref) => di.newUserHolder);

class NewUserScreen extends ConsumerWidget {
  const NewUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    final manager = di.newUserManager;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Создание пользователя'),
      ),
      body: manager.canCreate
          ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: manager.formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: manager.validateNull,
                      controller: manager.usernameController,
                      onChanged: manager.setUsername,
                      decoration: InputDecoration(
                        labelText: 'Имя пользователя',
                        suffix: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: manager.clearUsername,
                        ),
                      ),
                    ),
                    TextFormField(
                      obscureText: true,
                      validator: manager.validateNull,
                      controller: manager.passwordController,
                      onChanged: manager.setPassword,
                      decoration: InputDecoration(
                        labelText: 'Пароль',
                        suffix: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: manager.clearPassword,
                        ),
                      ),
                    ),
                    DropdownButtonFormField<Permission>(
                      value: state.permission,
                      items: const [
                        DropdownMenuItem(
                          value: Permission.full,
                          child: Text('Полные'),
                        ),
                        DropdownMenuItem(
                          value: Permission.update,
                          child: Text('Только обновление'),
                        ),
                        DropdownMenuItem(
                          value: Permission.upload,
                          child: Text('Только загрузка'),
                        ),
                      ],
                      onChanged: manager.setPermission,
                      decoration: const InputDecoration(labelText: 'Права'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (manager.formKey.currentState!.validate()) {
                            bool created = await manager.createUser();
                            if (created && context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: const Text('Создать'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: Text('Недостаточно прав для данной операции'),
            ),
    );
  }
}
