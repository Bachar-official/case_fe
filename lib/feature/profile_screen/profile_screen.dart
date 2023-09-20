import 'package:case_fe/app/di.dart';
import 'package:case_fe/app/routing.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final manager = di.profileManager;
    return Scaffold(
      appBar: AppBar(
        title: Text(manager.tokenRepo.username),
      ),
      body: manager.isAuthorized
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    manager.canManageUsers
                        ? ElevatedButton(
                            onPressed: () {
                              manager.getUsers();
                              Navigator.pushNamed(
                                  context, AppRouter.usersScreen);
                            },
                            child: const Text('Управлять пользователями'),
                          )
                        : Container(),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(
                          context, AppRouter.newPasswordScreen),
                      child: const Text('Сменить пароль'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        manager.clearToken();
                        Navigator.pop(
                          context,
                        );
                      },
                      child: const Text('Выйти'),
                    ),
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
