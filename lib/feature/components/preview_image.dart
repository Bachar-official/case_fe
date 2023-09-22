import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class PreviewImage extends StatelessWidget {
  final File? icon;
  final Uint8List? webIcon;
  final void Function() onClearIcon;
  final bool isWeb;
  const PreviewImage(
      {super.key,
      required this.isWeb,
      required this.icon,
      required this.onClearIcon,
      required this.webIcon});

  @override
  Widget build(BuildContext context) {
    return icon == null && webIcon == null
        ? const Text('Изображение не прикреплено')
        : SizedBox(
            height: 100,
            child: Stack(
              children: [
                isWeb ? Image.memory(webIcon!) : Image.file(icon!),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: onClearIcon,
                    child: const Icon(Icons.clear),
                  ),
                ),
              ],
            ),
          );
  }
}
