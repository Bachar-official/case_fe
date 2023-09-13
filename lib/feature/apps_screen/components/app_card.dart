import 'package:case_fe/domain/entity/app.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final App app;
  const AppCard({required this.app, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(child: Text(app.name));
  }
}
