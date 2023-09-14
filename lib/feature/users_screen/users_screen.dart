import 'package:case_fe/app/di.dart';
import 'package:case_fe/app/routing.dart';
import 'package:case_fe/feature/components/empty_list_handler.dart';
import 'package:case_fe/feature/users_screen/components/user_card.dart';
import 'package:case_fe/feature/users_screen/users_state.dart';
import 'package:case_fe/feature/users_screen/users_state_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final provider = StateNotifierProvider<UsersStateHolder, UsersState>(
    (ref) => di.usersHolder);

class UsersScreen extends ConsumerWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    final manager = di.usersManager;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Управление пользователями'),
        actions: [
          IconButton(
            onPressed: () async => await manager.getUsers(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: manager.isAuthorized
          ? RefreshIndicator(
              onRefresh: manager.getUsers,
              child: state.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : EmptyListHandler(
                      emptyMessage: 'Список пользователей пуст',
                      isListEmpty: state.users.isEmpty,
                      listWidget: ListView.builder(
                        itemCount: state.users.length,
                        itemBuilder: (context, index) => UserCard(
                          user: state.users.elementAt(index),
                          isYou: state.users.elementAt(index).name ==
                              manager.username,
                        ),
                      ),
                    ),
            )
          : const Center(
              child: Text('Вы не авторизованы'),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, AppRouter.newUserScreen),
      ),
    );
  }
}
