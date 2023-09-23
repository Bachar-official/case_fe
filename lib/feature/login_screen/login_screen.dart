import 'package:case_fe/app/di.dart';
import 'package:case_fe/app/routing.dart';
import 'package:case_fe/feature/login_screen/login_state.dart';
import 'package:case_fe/feature/login_screen/login_state_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final provider = StateNotifierProvider<LoginStateHolder, LoginState>(
    (ref) => di.loginHolder);

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    final manager = di.loginManager;

    return Scaffold(
      appBar: AppBar(),
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: SizedBox(
                width: 500,
                child: Form(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'CASE',
                          style: TextStyle(
                              fontSize: 50, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'is App Storage for Enterprise',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                        TextFormField(
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
                          controller: manager.passwordController,
                          onChanged: manager.setPassword,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Пароль',
                            suffix: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: manager.clearPassword,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ElevatedButton(
                            onPressed: state.username.isNotEmpty &&
                                    state.password.isNotEmpty
                                ? () async {
                                    if (await manager.auth() &&
                                        context.mounted) {
                                      manager.clearPassword();
                                      manager.clearUsername();
                                      await Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          AppRouter.appScreen,
                                          (route) => false);
                                    }
                                  }
                                : null,
                            child: const Text('Войти'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
