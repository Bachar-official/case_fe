import 'package:case_fe/app/di.dart';
import 'package:case_fe/app/routing.dart';
import 'package:case_fe/feature/new_password_screen/new_password_state.dart';
import 'package:case_fe/feature/new_password_screen/new_password_state_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final provider =
    StateNotifierProvider<NewPasswordStateHolder, NewPasswordState>(
        (ref) => di.newPasswordStateHolder);

class NewPasswordScreen extends ConsumerWidget {
  const NewPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    final manager = di.newPasswordManager;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Смена пароля'),
      ),
      body: manager.isAuthenticated
          ? Form(
              key: manager.formKey,
              child: state.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          TextFormField(
                            validator: manager.validateEmpty,
                            obscureText: true,
                            controller: manager.oldController,
                            onChanged: manager.setOldPassword,
                            decoration: InputDecoration(
                              labelText: 'Старый пароль',
                              suffix: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: manager.clearOldPassword,
                              ),
                            ),
                          ),
                          TextFormField(
                            validator: manager.validateNewPassword,
                            obscureText: true,
                            controller: manager.newController,
                            onChanged: manager.setNewPassword,
                            decoration: InputDecoration(
                              labelText: 'Новый пароль',
                              suffix: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: manager.clearNewPassword,
                              ),
                            ),
                          ),
                          TextFormField(
                            validator: manager.validateConfirmPassword,
                            obscureText: true,
                            controller: manager.confirmController,
                            onChanged: manager.setConfirmPassword,
                            decoration: InputDecoration(
                              labelText: 'Подтверждение пароля',
                              suffix: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: manager.clearConfirmPassword,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              child: const Text('Сменить пароль'),
                              onPressed: () async {
                                if (manager.formKey.currentState!.validate()) {
                                  bool isChanged =
                                      await manager.changePassword();
                                  if (isChanged && context.mounted) {
                                    await manager.tokenRepo.clearToken();
                                    await Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        AppRouter.appScreen,
                                        (route) => false);
                                  }
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
            )
          : const Center(
              child: Text('Вы не авторизованы'),
            ),
    );
  }
}
