import 'package:case_fe/domain/entity/permission.dart';
import 'package:case_fe/domain/entity/user.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final User user;
  final bool isYou;
  const UserCard({required this.user, super.key, required this.isYou});

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: 15);

    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            '${user.name}${isYou ? ' (Вы)' : ''}',
            style: style,
          ),
          Text(
            user.permission.toSemanticString(),
            style: style,
          ),
          IconButton(
            tooltip: 'Удалить',
            onPressed: isYou ? null : () {},
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
