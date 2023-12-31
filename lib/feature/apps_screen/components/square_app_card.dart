import 'package:case_fe/app/routing.dart';
import 'package:case_fe/feature/apps_screen/components/app_info_dialog.dart';
import 'package:case_fe/feature/apps_screen/components/download_dialog.dart';
import 'package:flutter/material.dart';

import '../../../domain/entity/app.dart';

const emptyPlace = SizedBox.shrink();
const okIcon = Icon(
  Icons.check,
  color: Colors.green,
);

final emptySpace = Container();

class SquareAppCard extends StatelessWidget {
  final App app;
  final String baseUrl;
  final void Function(App)? onDeleteApp;
  final void Function()? onUploadApk;
  final Future<void> Function(App)? onInstallApk;
  final double progress;
  final bool? isUpdateAvailable;
  const SquareAppCard(
      {required this.app,
      required this.progress,
      this.isUpdateAvailable,
      required this.onInstallApk,
      super.key,
      required this.baseUrl,
      this.onDeleteApp,
      this.onUploadApk});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => AppInfoDialog(
                  app: app,
                  baseUrl: baseUrl,
                  onInstallApk: onInstallApk,
                  isUpdateAvailable: isUpdateAvailable,
                ));
      },
      child: Card(
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            isUpdateAvailable ?? true
                ? IconButton(
                    onPressed: app.apk.isEmpty
                        ? null
                        : onInstallApk != null
                            ? progress != 0
                                ? null
                                : () async => await onInstallApk!(app)
                            : () => showDialog(
                                  context: context,
                                  builder: (context) => DownloadDialog(
                                      app: app, baseUrl: baseUrl),
                                ),
                    icon: const Icon(Icons.download),
                  )
                : okIcon,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.network(
                  '$baseUrl${app.iconPath}',
                  width: 100,
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
                Badge(
                  offset: const Offset(15, 0),
                  label: Text(app.version),
                  child: Text(
                    app.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  app.description ?? 'Описание отсутствует',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onDeleteApp != null || onUploadApk != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          onUploadApk == null
                              ? emptyPlace
                              : IconButton(
                                  icon: const Icon(Icons.upload),
                                  onPressed: onUploadApk,
                                ),
                          IconButton(
                            onPressed: () => Navigator.pushNamed(
                                context, AppRouter.editAppScreen,
                                arguments: app),
                            icon: const Icon(Icons.edit),
                          ),
                          onDeleteApp == null
                              ? emptyPlace
                              : IconButton(
                                  onPressed: () => onDeleteApp!(app),
                                  icon: const Icon(Icons.delete),
                                ),
                        ],
                      )
                    : emptySpace,
                progress == 0
                    ? emptySpace
                    : LinearProgressIndicator(
                        value: progress,
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
