import 'package:case_fe/domain/entity/app.dart';
import 'package:case_fe/domain/entity/arch.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class DownloadDialog extends StatefulWidget {
  final App app;
  final String baseUrl;
  const DownloadDialog({required this.app, super.key, required this.baseUrl});

  @override
  State<DownloadDialog> createState() => _DownloadDialogState();
}

class _DownloadDialogState extends State<DownloadDialog> {
  Arch? _arch;

  @override
  void initState() {
    super.initState();
    _arch = null;
  }

  void setArch(Arch? arch) {
    _arch = arch;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final options = [
      ...widget.app.apk
          .map(
            (apk) => DropdownMenuItem<Arch>(
              value: apk.arch,
              child: Text(
                getArchDescription(apk.arch),
              ),
            ),
          )
          .toList()
    ];

    return AlertDialog(
      title: const Text('Выберите архитектуру'),
      content: DropdownButtonFormField<Arch?>(
          value: _arch, onChanged: setArch, items: options),
      actions: [
        TextButton(
          onPressed: _arch == null
              ? null
              : () async {
                  // if (kIsWeb) {
                  // downloadFileForWeb(
                  //     '${widget.baseUrl}/apps/${widget.app.package}/${_arch!.name}/download');
                  await launchUrl(
                    Uri.parse(
                        '${widget.baseUrl}/apps/${widget.app.package}/${_arch!.name}/download'),
                  );
                  // } else {
                  //   debugPrint('Do it in Android');
                  // }
                },
          child: const Text('Скачать'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
      ],
    );
  }
}
