import 'package:flutter/material.dart';

import '../../../domain/entity/app.dart';

class SquareAppCard extends StatelessWidget {
  final App app;
  final String baseUrl;
  final void Function(App)? onDeleteApp;
  const SquareAppCard(
      {required this.app, super.key, required this.baseUrl, this.onDeleteApp});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 2,
            child: Image.network(
              '$baseUrl${app.iconPath}',
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
          ),
          Badge(
            offset: const Offset(15, 0),
            label: Text(app.version),
            child: Text(
              app.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            app.description ?? 'Описание отсутствует',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              onDeleteApp == null
                  ? const SizedBox.shrink()
                  : IconButton(
                      onPressed: () => onDeleteApp!(app),
                      icon: const Icon(Icons.delete),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
