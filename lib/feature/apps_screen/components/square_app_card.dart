import 'package:case_fe/feature/apps_screen/components/download_dialog.dart';
import 'package:flutter/material.dart';

import '../../../domain/entity/app.dart';

const emptyPlace = SizedBox.shrink();

final emptySpace = Container();

class SquareAppCard extends StatelessWidget {
  final App app;
  final String baseUrl;
  final void Function(App)? onDeleteApp;
  final void Function()? onUploadApk;
  final Future<void> Function(App)? onInstallApk;
  final double progress;
  const SquareAppCard(
      {required this.app,
      required this.progress,
      required this.onInstallApk,
      super.key,
      required this.baseUrl,
      this.onDeleteApp,
      this.onUploadApk});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          IconButton(
            onPressed: app.apk.isEmpty
                ? null
                : onInstallApk != null
                    ? progress != 0
                        ? null
                        : () async => await onInstallApk!(app)
                    : () => showDialog(
                          context: context,
                          builder: (context) =>
                              DownloadDialog(app: app, baseUrl: baseUrl),
                        ),
            icon: const Icon(Icons.download),
          ),
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
    );
  }
}
