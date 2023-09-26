import 'package:case_fe/domain/entity/app.dart';
import 'package:case_fe/feature/apps_screen/components/download_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget getTextButton(
    {required BuildContext context,
    required App app,
    bool? isUpdateAvailable,
    required String baseUrl,
    Future<void> Function(App)? onInstallApk}) {
  if (kIsWeb) {
    return TextButton(
      onPressed: app.apk.isEmpty
          ? null
          : () {
              showDialog(
                context: context,
                builder: (context) =>
                    DownloadDialog(app: app, baseUrl: baseUrl),
              );
            },
      child: const Text('Скачать'),
    );
  } else if (!kIsWeb && isUpdateAvailable != null && !isUpdateAvailable) {
    return const TextButton(
      onPressed: null,
      child: Text('Обновлено'),
    );
  }
  return TextButton(
    onPressed: app.apk.isEmpty
        ? null
        : () {
            Navigator.pop(context);
            onInstallApk!(app);
          },
    child: const Text('Скачать'),
  );
}

class AppInfoDialog extends StatelessWidget {
  final App app;
  final String baseUrl;
  final bool? isUpdateAvailable;
  final Future<void> Function(App)? onInstallApk;
  const AppInfoDialog(
      {super.key,
      this.isUpdateAvailable,
      required this.app,
      required this.baseUrl,
      required this.onInstallApk});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${app.name} v.${app.version}'),
      actions: [
        getTextButton(
            context: context,
            app: app,
            baseUrl: baseUrl,
            isUpdateAvailable: isUpdateAvailable,
            onInstallApk: onInstallApk),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Назад'),
        ),
      ],
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Image.network(
          '$baseUrl${app.iconPath}?${DateTime.now().millisecondsSinceEpoch.toString()}',
          width: 150,
          fit: BoxFit.cover,
          errorBuilder: (context, _, __) {
            return const Icon(
              Icons.image_not_supported_outlined,
              size: 60,
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            return loadingProgress == null
                ? child
                : const CircularProgressIndicator();
          },
        ),
        Text(
          app.description ?? 'Описания нет',
          maxLines: 3,
          textAlign: TextAlign.center,
        ),
      ]),
    );
  }
}
