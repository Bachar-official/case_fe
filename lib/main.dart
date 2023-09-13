import 'package:case_fe/app/app.dart';
import 'package:case_fe/app/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await di.init();
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
