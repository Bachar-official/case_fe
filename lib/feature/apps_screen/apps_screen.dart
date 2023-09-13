import 'package:case_fe/app/di.dart';
import 'package:case_fe/feature/apps_screen/apps_state.dart';
import 'package:case_fe/feature/apps_screen/apps_state_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final provider =
    StateNotifierProvider<AppsStateHolder, AppsState>((ref) => di.appsHolder);

class AppsScreen extends StatelessWidget {
  const AppsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Приложения'),
      ),
    );
  }
}
