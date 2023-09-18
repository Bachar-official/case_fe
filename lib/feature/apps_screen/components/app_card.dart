import 'package:case_fe/domain/entity/app.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final App app;
  final String baseUrl;
  final void Function(App)? onDeleteApp;
  const AppCard(
      {required this.app, super.key, required this.baseUrl, this.onDeleteApp});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.network(
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Badge(
                offset: const Offset(15, 0),
                label: Text(app.version),
                child: Text(
                  app.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                app.description ?? 'Описание отсутствует',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          onDeleteApp == null
              ? const SizedBox.shrink()
              : IconButton(
                  onPressed: () => onDeleteApp!(app),
                  icon: const Icon(Icons.delete),
                ),
        ],
      ),
    );
  }
}
